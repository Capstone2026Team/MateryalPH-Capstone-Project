<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Enforcement\EnforcementService;
use App\Domain\Operations\AdminAccess;
use App\Domain\Operations\AuditSearchService;
use App\Domain\Operations\JobHealthService;
use App\Domain\Privacy\PrivacyRequestService;
use App\Domain\Settings\PlatformSettingService;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use App\Support\PortalDateRange;
use Carbon\CarbonImmutable;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;

/**
 * Phase 16 Admin operations: Platform Settings, enforcement, privacy requests, audit search, Integration and Job
 * Health and the Budget Override Audit Log. Each action validates transport and hands one use case to its domain
 * service, which authorizes the Admin permission again. No route edits or deletes an audit entry, reveals a secret,
 * shows a balance or moves money.
 */
final class AdminOperationsController extends Controller
{
    public function settings(Request $request, PlatformSettingService $settings): JsonResponse
    {
        $result = $settings->index($request);

        return ApiResponse::success($result['items'], ['fixed' => $result['fixed'], 'can_manage' => $result['can_manage']]);
    }

    public function settingHistory(Request $request, string $key, PlatformSettingService $settings): JsonResponse
    {
        return ApiResponse::success($settings->history($request, $key));
    }

    public function updateSetting(Request $request, string $key, PlatformSettingService $settings): JsonResponse
    {
        $input = $request->validate(['value' => ['present'], 'expected_version' => ['required', 'integer', 'min:0'], 'reason' => ['required', 'string', 'min:10', 'max:500']]);

        /** @var array{value: mixed, expected_version: int, reason: string} $input */
        return ApiResponse::success($settings->update($request, $key, $input));
    }

    public function enforcementQueue(Request $request, EnforcementService $enforcement): JsonResponse
    {
        $filters = $request->validate(['state' => ['sometimes', Rule::in(['EFFECTIVE', 'REFERRED', 'APPLIED', 'LIFTED', 'DECLINED'])], 'subject_type' => ['sometimes', Rule::in(['BUYER', 'VENDOR_ORGANIZATION'])],
            'action' => ['sometimes', Rule::in(EnforcementService::ACTIONS)], 'source' => ['sometimes', Rule::in(['DISPUTE_REFERRAL', 'DIRECT'])], 'subject_id' => ['sometimes', 'uuid'],
            'page' => ['sometimes', 'integer', 'between:1,1000']] + PortalDateRange::rules($request));
        $result = $enforcement->queue($request, $filters);

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function enforcementDetail(Request $request, string $actionId, EnforcementService $enforcement): JsonResponse
    {
        return ApiResponse::success($enforcement->detail($request, $actionId));
    }

    public function enforcementSubjects(Request $request, EnforcementService $enforcement): JsonResponse
    {
        $input = $request->validate(['type' => ['required', Rule::in(['BUYER', 'VENDOR_ORGANIZATION'])], 'q' => ['required', 'string', 'min:3', 'max:120']]);

        return ApiResponse::success($enforcement->search($request, (string) $input['type'], (string) $input['q']));
    }

    public function enforcementSubject(Request $request, string $type, string $subjectId, EnforcementService $enforcement): JsonResponse
    {
        return ApiResponse::success($enforcement->subject($request, $type, $subjectId));
    }

    public function recordEnforcement(Request $request, EnforcementService $enforcement, AdminAccess $access): JsonResponse
    {
        $input = $request->validate(['subject_type' => ['required', Rule::in(['BUYER', 'VENDOR_ORGANIZATION'])], 'subject_id' => ['required', 'uuid'], 'action' => ['required', Rule::in(EnforcementService::ACTIONS)],
            'reason' => ['required', 'string', 'min:10', 'max:2000'], 'scope' => ['sometimes', 'string', 'max:160'], 'duration_days' => ['sometimes', 'nullable', 'integer', 'between:1,365'],
            'restoration_condition' => ['sometimes', 'nullable', 'string', 'max:2000'], 'continuation_plan' => ['sometimes', 'nullable', Rule::in(EnforcementService::PLANS)],
            'continuation_note' => ['sometimes', 'nullable', 'string', 'max:2000']]);

        $outcome = $access->idempotent($request, 'ADMIN_ENFORCEMENT_RECORD', fn (): array => $enforcement->record($request, $input));

        return ApiResponse::success($outcome['result'], status: $outcome['replayed'] ? 200 : 201);
    }

    public function applyEnforcement(Request $request, string $actionId, EnforcementService $enforcement): JsonResponse
    {
        $input = $request->validate(['continuation_plan' => ['required', Rule::in(EnforcementService::PLANS)], 'continuation_note' => ['sometimes', 'nullable', 'string', 'max:2000'],
            'lock_version' => ['required', 'integer', 'min:1'], 'reason' => ['required', 'string', 'min:10', 'max:2000']]);

        return ApiResponse::success($enforcement->apply($request, $actionId, $input));
    }

    public function declineEnforcement(Request $request, string $actionId, EnforcementService $enforcement): JsonResponse
    {
        $input = $request->validate(['lock_version' => ['required', 'integer', 'min:1'], 'reason' => ['required', 'string', 'min:10', 'max:2000']]);

        return ApiResponse::success($enforcement->decline($request, $actionId, (int) $input['lock_version'], $input['reason']));
    }

    public function liftEnforcement(Request $request, string $actionId, EnforcementService $enforcement): JsonResponse
    {
        $input = $request->validate(['lock_version' => ['required', 'integer', 'min:1'], 'reason' => ['required', 'string', 'min:10', 'max:2000']]);

        return ApiResponse::success($enforcement->lift($request, $actionId, (int) $input['lock_version'], $input['reason']));
    }

    public function privacyQueue(Request $request, PrivacyRequestService $privacy): JsonResponse
    {
        $filters = $request->validate(['state' => ['sometimes', Rule::in(['RECEIVED', 'IDENTITY_VERIFIED', 'IN_PROGRESS', 'COMPLETED', 'REJECTED', 'WITHDRAWN'])],
            'request_type' => ['sometimes', Rule::in(PrivacyRequestService::TYPES)], 'handler' => ['sometimes', Rule::in(['UNASSIGNED'])], 'page' => ['sometimes', 'integer', 'between:1,1000']] + PortalDateRange::rules($request));
        $result = $privacy->queue($request, $filters);

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function privacyDetail(Request $request, string $requestId, PrivacyRequestService $privacy): JsonResponse
    {
        return ApiResponse::success($privacy->detail($request, $requestId));
    }

    public function recordPrivacyRequest(Request $request, PrivacyRequestService $privacy, AdminAccess $access): JsonResponse
    {
        $input = $request->validate(['subject_email' => ['required', 'email:rfc', 'max:254'], 'request_type' => ['required', Rule::in(PrivacyRequestService::TYPES)],
            'intake_channel' => ['required', Rule::in(PrivacyRequestService::CHANNELS)], 'received_on' => ['required', 'date_format:Y-m-d'],
            'scope' => ['required', 'string', 'min:10', 'max:4000'], 'note' => ['required', 'string', 'min:3', 'max:2000']]);

        $outcome = $access->idempotent($request, 'ADMIN_PRIVACY_RECORD', fn (): array => $privacy->create($request, $input));

        return ApiResponse::success($outcome['result'], status: $outcome['replayed'] ? 200 : 201);
    }

    public function privacyTransition(Request $request, string $requestId, string $command, PrivacyRequestService $privacy): JsonResponse
    {
        $input = $request->validate(['lock_version' => ['required', 'integer', 'min:1'], 'note' => ['required', 'string', 'min:3', 'max:4000'],
            'handler_user_id' => [Rule::requiredIf($command === 'assign'), 'integer'], 'target_date' => ['sometimes', 'nullable', 'date_format:Y-m-d'],
            'verification_method' => [Rule::requiredIf($command === 'verify'), Rule::in(PrivacyRequestService::VERIFICATION_METHODS)],
            'legal_exception' => ['sometimes', 'nullable', 'string', 'max:2000']]);

        return ApiResponse::success($privacy->transition($request, $requestId, $command, $input));
    }

    public function audit(Request $request, AuditSearchService $audit): JsonResponse
    {
        $filters = $request->validate(['actor' => ['sometimes', 'string', 'max:120'], 'actor_role' => ['sometimes', 'string', 'max:48'], 'action' => ['sometimes', 'string', 'max:96', 'regex:/^[A-Za-z0-9_]+$/'],
            'resource_type' => ['sometimes', 'string', 'max:48', 'regex:/^[A-Z0-9_]+$/'], 'resource_id' => ['sometimes', 'uuid'], 'organization_id' => ['sometimes', 'uuid'],
            'result' => ['sometimes', Rule::in(['SUCCEEDED', 'FAILED'])], 'correlation_id' => ['sometimes', 'string', 'max:64'], 'reason' => ['sometimes', 'string', 'max:200'],
            ...PortalDateRange::rules($request), 'cursor' => ['sometimes', 'string', 'max:300']]);
        $result = $audit->search($request, $filters);

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function auditDetail(Request $request, string $auditId, AuditSearchService $audit): JsonResponse
    {
        return ApiResponse::success($audit->detail($request, $auditId));
    }

    public function auditActions(Request $request, AuditSearchService $audit): JsonResponse
    {
        return ApiResponse::success($audit->facets($request));
    }

    public function integrations(Request $request, JobHealthService $health): JsonResponse
    {
        return ApiResponse::success($health->overview($request));
    }

    public function failures(Request $request, JobHealthService $health): JsonResponse
    {
        $filters = $request->validate(['kind' => ['sometimes', Rule::in(['OUTBOX', 'JOBS'])], 'page' => ['sometimes', 'integer', 'between:1,1000']] + PortalDateRange::rules($request));
        $result = $health->failures($request, $filters);

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function retry(Request $request, JobHealthService $health, AdminAccess $access): JsonResponse
    {
        $input = $request->validate(['target_type' => ['required', Rule::in(['FAILED_JOB', 'OUTBOX_EVENT', 'GEO_FACTS_RUN', 'MATERIAL_SNAPSHOT'])],
            'reference' => ['required', 'string', 'max:80'], 'reason' => ['required', 'string', 'min:10', 'max:500']]);

        $outcome = $access->idempotent($request, 'ADMIN_OPERATION_RETRY', fn (): array => $health->retry($request, (string) $input['target_type'], (string) $input['reference'], $input['reason']));

        return ApiResponse::success($outcome['result'], status: 202);
    }

    public function retries(Request $request, JobHealthService $health): JsonResponse
    {
        return ApiResponse::success($health->retries($request));
    }

    /** Read-only Buyer budget override log: Buyer decisions need no Admin approval. */
    public function budgetOverrides(Request $request, AdminAccess $access): JsonResponse
    {
        $access->require($request, 'budget_overrides.view');
        $input = $request->validate(['page' => ['sometimes', 'integer', 'between:1,1000']] + PortalDateRange::rules($request));
        $query = DB::table('budget_overrides as b')->join('projects as p', 'p.id', '=', 'b.project_id')->join('work_packages as w', 'w.id', '=', 'b.work_package_id')
            ->leftJoin('orders as o', 'o.id', '=', 'b.order_id')->join('users as u', 'u.id', '=', 'b.buyer_user_id')->orderByDesc('b.created_at');
        PortalDateRange::apply($query, 'b.created_at', $input);
        $page = $query->paginate(25, ['b.id', 'b.overage_centavos', 'b.reason', 'b.snapshot', 'b.created_at', 'p.name as project_name', 'w.name as work_package_name', 'o.reference as order_reference', 'u.public_id'], 'page', $input['page'] ?? 1);
        $items = array_map(static function (object $row): array {
            $snapshot = json_decode((string) $row->snapshot, true) ?: [];

            return ['id' => (string) $row->id, 'project' => (string) $row->project_name, 'work_package' => (string) $row->work_package_name, 'order_reference' => $row->order_reference,
                'prior_budget_centavos' => (int) ($snapshot['work_package']['budget_centavos'] ?? 0), 'order_amount_centavos' => (int) ($snapshot['purchase_centavos'] ?? 0),
                'overage_centavos' => (int) $row->overage_centavos, 'reason' => (string) $row->reason, 'actor' => 'Buyer …'.substr(str_replace('-', '', (string) $row->public_id), -6),
                'recorded_at' => CarbonImmutable::parse((string) $row->created_at)->toIso8601String()];
        }, $page->items());

        return ApiResponse::success($items, ['page' => $page->currentPage(), 'last_page' => $page->lastPage(), 'total' => $page->total()]);
    }
}
