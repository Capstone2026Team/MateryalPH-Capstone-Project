<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Disputes\DisputeAccess;
use App\Domain\Disputes\DisputeAdminService;
use App\Domain\Disputes\DisputeCaseService;
use App\Domain\Disputes\DisputeChannel;
use App\Domain\Disputes\DisputeExportService;
use App\Domain\Disputes\DisputeFiles;
use App\Domain\Disputes\DisputeFilingService;
use App\Domain\Disputes\DisputeQueries;
use App\Domain\Disputes\DisputeRules;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderAccess;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Broadcast;
use Illuminate\Validation\Rule;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\StreamedResponse;

/**
 * Dispute endpoints for the three audiences. The route prefix fixes the audience and transport (Buyer bearer, Vendor
 * and Admin cookies with CSRF); every request is authorized again in the domain. No request accepts a refund
 * destination, and filing never returns or creates a refund.
 */
final class DisputeController extends Controller
{
    public function __construct(
        private readonly DisputeQueries $queries,
        private readonly DisputeFilingService $filing,
        private readonly DisputeCaseService $cases,
        private readonly DisputeAdminService $admin,
        private readonly DisputeAccess $access,
    ) {}

    // ── Buyer and Vendor ─────────────────────────────────────────────────────────────────────────────

    public function index(Request $request): JsonResponse
    {
        $filters = $request->validate(['group' => ['sometimes', Rule::in(['ALL', ...array_keys(DisputeQueries::VENDOR_GROUPS)])], 'q' => ['sometimes', 'string', 'max:120'], 'page' => ['sometimes', 'integer', 'between:1,1000']]);
        $result = self::party($request) === 'BUYER' ? $this->queries->buyerList($request, (int) ($filters['page'] ?? 1)) : $this->queries->vendorList($request, $filters);

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function show(Request $request, string $caseId): JsonResponse
    {
        return ApiResponse::success($this->detail($request, $caseId));
    }

    public function eligibility(Request $request, string $orderId, OrderAccess $orders): JsonResponse
    {
        if (self::party($request) === 'BUYER') {
            $order = $orders->buyerOrder($request, $orderId);
        } else {
            $scope = $this->access->vendorScope($request);
            $order = $orders->vendorOrder(['organization_id' => $scope['organization_id'], 'role' => $scope['role'], 'permissions' => $scope['permissions']], $orderId);
        }

        return ApiResponse::success($this->filing->eligibility($order, self::party($request)));
    }

    public function file(Request $request): JsonResponse
    {
        $party = self::party($request);
        DisputeFilingService::rejectDestination($request);
        $input = $request->validate([
            'order_id' => ['required', 'uuid'],
            'issue_type' => ['required', Rule::in(DisputeRules::issuesFor($party))],
            'requested_remedy' => ['required', Rule::in(DisputeRules::remediesFor($party))],
            'requested_amount_centavos' => ['sometimes', 'nullable', 'integer', 'min:1', 'max:100000000000'],
            'description' => ['required', 'string', 'min:20', 'max:4000'],
            'affected_line_ids' => ['sometimes', 'array', 'max:200'], 'affected_line_ids.*' => ['uuid'],
            'preferred_contact_channel' => ['sometimes', 'nullable', Rule::in(['IN_APP', 'EMAIL'])],
            'files' => ['sometimes', 'array', 'max:'.DisputeFiles::MAX_FILES], 'files.*' => ['file', 'max:10240'],
        ]);
        /** @var array{order_id: string, issue_type: string, requested_remedy: string, requested_amount_centavos?: int|null, description: string, affected_line_ids?: list<string>, preferred_contact_channel?: string|null} $input */
        $input['requested_amount_centavos'] = isset($input['requested_amount_centavos']) ? (int) $input['requested_amount_centavos'] : null;
        $uploads = self::uploads($request);
        $caseId = $party === 'BUYER' ? $this->filing->fileAsBuyer($request, $input, $uploads) : $this->filing->fileAsVendor($request, $input, $uploads);

        return ApiResponse::success($this->detail($request, $caseId), [], 201);
    }

    public function respond(Request $request, string $caseId): JsonResponse
    {
        DisputeFilingService::rejectDestination($request);
        $input = $request->validate(['position' => ['required', Rule::in(DisputeRules::RESPONSE_POSITIONS)], 'body' => ['required', 'string', 'min:10', 'max:4000'],
            'amount_centavos' => ['sometimes', 'nullable', 'integer', 'min:1', 'max:100000000000'], 'files' => ['sometimes', 'array', 'max:'.DisputeFiles::MAX_FILES], 'files.*' => ['file', 'max:10240']]);
        $this->cases->respond($request, self::party($request), $caseId, ['position' => (string) $input['position'], 'body' => (string) $input['body'],
            'amount_centavos' => isset($input['amount_centavos']) ? (int) $input['amount_centavos'] : null], self::uploads($request));

        return ApiResponse::success($this->detail($request, $caseId));
    }

    public function propose(Request $request, string $caseId): JsonResponse
    {
        DisputeFilingService::rejectDestination($request);
        $input = $request->validate(['remedy' => ['required', Rule::in(DisputeRules::PROPOSAL_REMEDIES)], 'amount_centavos' => ['sometimes', 'nullable', 'integer', 'min:1', 'max:100000000000'],
            'terms' => ['required', 'string', 'min:10', 'max:2000']]);
        $this->cases->propose($request, self::party($request), $caseId, ['remedy' => (string) $input['remedy'], 'amount_centavos' => isset($input['amount_centavos']) ? (int) $input['amount_centavos'] : null,
            'terms' => (string) $input['terms']]);

        return ApiResponse::success($this->detail($request, $caseId));
    }

    public function answerProposal(Request $request, string $caseId, string $proposalId): JsonResponse
    {
        $input = $request->validate(['decision' => ['required', Rule::in(['ACCEPT', 'REJECT'])]]);
        $this->cases->answerProposal($request, self::party($request), $caseId, $proposalId, $input['decision'] === 'ACCEPT');

        return ApiResponse::success($this->detail($request, $caseId));
    }

    public function escalate(Request $request, string $caseId): JsonResponse
    {
        $input = $request->validate(['reason' => ['required', 'string', 'min:10', 'max:2000']]);
        if (self::party($request) === 'ADMIN') {
            $this->admin->escalate($request, $caseId, (string) $input['reason']);
        } else {
            $this->cases->escalate($request, self::party($request), $caseId, (string) $input['reason']);
        }

        return ApiResponse::success($this->detail($request, $caseId));
    }

    public function evidence(Request $request, string $caseId): JsonResponse
    {
        $input = $request->validate(['description' => ['sometimes', 'nullable', 'string', 'max:500'], 'files' => ['required', 'array', 'min:1', 'max:'.DisputeFiles::MAX_FILES], 'files.*' => ['file', 'max:10240']]);
        $this->cases->addEvidence($request, self::party($request), $caseId, isset($input['description']) ? (string) $input['description'] : null, self::uploads($request));

        return ApiResponse::success($this->detail($request, $caseId), [], 201);
    }

    public function message(Request $request, string $caseId): JsonResponse
    {
        DisputeFilingService::rejectDestination($request);
        $input = $request->validate(['body' => ['required', 'string', 'min:2', 'max:2000']]);
        $this->cases->message($request, self::party($request), $caseId, (string) $input['body']);

        return ApiResponse::success($this->detail($request, $caseId), [], 201);
    }

    public function answerClarification(Request $request, string $caseId, string $clarificationId): JsonResponse
    {
        DisputeFilingService::rejectDestination($request);
        $input = $request->validate(['response' => ['required', 'string', 'min:5', 'max:4000'], 'files' => ['sometimes', 'array', 'max:'.DisputeFiles::MAX_FILES], 'files.*' => ['file', 'max:10240']]);
        $this->cases->answerClarification($request, self::party($request), $caseId, $clarificationId, (string) $input['response'], self::uploads($request));

        return ApiResponse::success($this->detail($request, $caseId));
    }

    public function appeal(Request $request, string $caseId): JsonResponse
    {
        DisputeFilingService::rejectDestination($request);
        $input = $request->validate(['grounds' => ['required', Rule::in(DisputeRules::APPEAL_GROUNDS)], 'statement' => ['required', 'string', 'min:20', 'max:4000'],
            'files' => ['sometimes', 'array', 'max:'.DisputeFiles::MAX_FILES], 'files.*' => ['file', 'max:10240']]);
        $this->cases->appeal($request, self::party($request), $caseId, (string) $input['grounds'], (string) $input['statement'], self::uploads($request));

        return ApiResponse::success($this->detail($request, $caseId), [], 201);
    }

    public function recordReplacement(Request $request, string $caseId, string $remedyId): JsonResponse
    {
        $input = $request->validate(['note' => ['required', 'string', 'min:10', 'max:500'], 'files' => ['sometimes', 'array', 'max:1'], 'files.*' => ['file', 'max:10240']]);
        $this->cases->recordReplacement($request, $caseId, $remedyId, (string) $input['note'], self::uploads($request));

        return ApiResponse::success($this->detail($request, $caseId));
    }

    public function confirmReplacement(Request $request, string $caseId, string $remedyId): JsonResponse
    {
        if (self::party($request) === 'ADMIN') {
            $input = $request->validate(['reason' => ['required', 'string', 'min:10', 'max:2000']]);
            $this->admin->confirmRemedy($request, $caseId, $remedyId, (string) $input['reason']);
        } else {
            $this->cases->confirmReplacement($request, $caseId, $remedyId);
        }

        return ApiResponse::success($this->detail($request, $caseId));
    }

    public function evidenceContent(Request $request, string $caseId, string $fileId, DisputeFiles $files): StreamedResponse
    {
        $user = $request->user();
        if (! $user instanceof User) {
            throw new AuthenticationException('FILE_NOT_FOUND', 'This file is unavailable.', 404);
        }

        return $files->stream($user, $caseId, $fileId);
    }

    // ── Vendor exports ───────────────────────────────────────────────────────────────────────────────

    public function exports(Request $request, DisputeExportService $exports): JsonResponse
    {
        return ApiResponse::success($exports->list($request));
    }

    public function requestExport(Request $request, DisputeExportService $exports): JsonResponse
    {
        $input = $request->validate(['group' => ['sometimes', 'nullable', Rule::in(['ALL', ...array_keys(DisputeQueries::VENDOR_GROUPS)])]]);

        return ApiResponse::success($exports->request($request, ['group' => $input['group'] ?? 'ALL']), [], 202);
    }

    public function downloadExport(Request $request, string $exportId, DisputeExportService $exports): StreamedResponse
    {
        return $exports->download($request, $exportId);
    }

    // ── Admin ────────────────────────────────────────────────────────────────────────────────────────

    public function queue(Request $request): JsonResponse
    {
        $filters = $request->validate(['status' => ['sometimes', Rule::in(['NEEDS_ADMIN', 'WITH_PARTIES', 'REMEDY_TRACKING', 'CONCLUDED', 'ALL'])], 'page' => ['sometimes', 'integer', 'between:1,1000']]);
        $result = $this->queries->adminQueue($request, $filters);

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function assign(Request $request, string $caseId): JsonResponse
    {
        $this->admin->assign($request, $caseId);

        return ApiResponse::success($this->detail($request, $caseId));
    }

    public function requestClarification(Request $request, string $caseId): JsonResponse
    {
        $input = $request->validate(['parties' => ['required', 'array', 'min:1', 'max:2'], 'parties.*' => [Rule::in(['BUYER', 'VENDOR'])], 'question' => ['required', 'string', 'min:10', 'max:2000']]);
        $this->admin->requestClarification($request, $caseId, array_values(array_map('strval', $input['parties'])), (string) $input['question']);

        return ApiResponse::success($this->detail($request, $caseId));
    }

    public function decide(Request $request, string $caseId): JsonResponse
    {
        $input = $request->validate(self::decisionRules() + ['outcome' => ['required', Rule::in(array_values(array_diff(DisputeRules::OUTCOMES, ['NO_FURTHER_ACTION'])))],
            'enforceable' => ['required', 'boolean'], 'evidence_limitation' => ['sometimes', 'nullable', 'string', 'max:2000']]);
        $this->admin->decide($request, $caseId, self::decisionInput($input) + ['outcome' => (string) $input['outcome'], 'enforceable' => (bool) $input['enforceable'],
            'evidence_limitation' => isset($input['evidence_limitation']) ? (string) $input['evidence_limitation'] : null]);

        return ApiResponse::success($this->detail($request, $caseId));
    }

    public function decideAppeal(Request $request, string $caseId): JsonResponse
    {
        $input = $request->validate(self::decisionRules() + ['result' => ['required', Rule::in(['AFFIRMED', 'MODIFIED', 'REVERSED'])],
            'outcome' => ['sometimes', 'nullable', Rule::in(array_values(array_diff(DisputeRules::OUTCOMES, ['NO_FURTHER_ACTION'])))]]);
        $this->admin->decideAppeal($request, $caseId, self::decisionInput($input) + ['result' => (string) $input['result'], 'outcome' => isset($input['outcome']) ? (string) $input['outcome'] : null]);

        return ApiResponse::success($this->detail($request, $caseId));
    }

    // ── Realtime ─────────────────────────────────────────────────────────────────────────────────────

    public function realtime(Request $request, DisputeChannel $channel): JsonResponse
    {
        $user = $request->user();

        return ApiResponse::success(['channel' => $user instanceof User ? $channel->name($user) : null, 'enabled' => config('broadcasting.default') === 'reverb',
            'key' => config('broadcasting.connections.reverb.key'), 'host' => config('reverb.public.host') ?: $request->getHost(), 'port' => is_numeric(config('reverb.public.port')) ? (int) config('reverb.public.port') : null, 'scheme' => config('reverb.public.scheme')]);
    }

    public function authorizeChannel(Request $request, DisputeChannel $channel): Response
    {
        $request->validate(['socket_id' => ['required', 'regex:/^\d+\.\d+$/'], 'channel_name' => ['required', 'string', 'max:240']]);
        $user = $request->user();
        abort_unless($user instanceof User && $channel->join($user, (string) $request->input('channel_name')), 403);
        if (config('broadcasting.default') !== 'reverb') {
            return ApiResponse::error('REALTIME_UNAVAILABLE', 'Realtime is unavailable. Cases refresh through REST.', 503);
        }
        $broadcaster = Broadcast::connection('reverb');
        $broadcaster->channel('disputes-{audience}.{epoch}', fn (User $member): bool => $channel->join($member, (string) $request->input('channel_name')), ['guards' => ['api']]);

        return response()->json($broadcaster->auth($request));
    }

    // ── Helpers ──────────────────────────────────────────────────────────────────────────────────────

    /** @return array<string, mixed> */
    private function detail(Request $request, string $caseId): array
    {
        return match (self::party($request)) {
            'BUYER' => $this->queries->buyerDetail($request, $caseId),
            'VENDOR' => $this->queries->vendorDetail($request, $caseId),
            default => $this->queries->adminDetail($request, $caseId),
        };
    }

    /** @return array<string, list<mixed>> */
    private static function decisionRules(): array
    {
        return [
            'reason' => ['required', 'string', 'min:20', 'max:4000'], 'amount_centavos' => ['sometimes', 'nullable', 'integer', 'min:1', 'max:100000000000'],
            'affected_line_ids' => ['sometimes', 'array', 'max:200'], 'affected_line_ids.*' => ['uuid'], 'conflict_check_confirmed' => ['required', 'boolean'], 'lock_version' => ['required', 'integer', 'min:1'],
            'sanctions' => ['sometimes', 'array', 'max:4'], 'sanctions.*.subject' => ['required', Rule::in(['BUYER', 'VENDOR'])], 'sanctions.*.action' => ['required', Rule::in(DisputeRules::SANCTIONS)],
            'sanctions.*.reason' => ['required', 'string', 'min:10', 'max:1000'], 'sanctions.*.scope' => ['sometimes', 'nullable', 'string', 'max:160'],
            'sanctions.*.duration_days' => ['sometimes', 'nullable', 'integer', 'min:1', 'max:365'], 'sanctions.*.restoration_condition' => ['sometimes', 'nullable', 'string', 'max:1000'],
            'metric_event' => ['sometimes', 'nullable', Rule::in(DisputeRules::METRIC_EVENTS)],
        ];
    }

    /**
     * @param  array<string, mixed>  $input
     * @return array{reason: string, amount_centavos: int|null, affected_line_ids: list<string>, conflict_check_confirmed: bool, lock_version: int, sanctions: list<array{subject: string, action: string, reason: string, scope?: string|null, duration_days?: int|null, restoration_condition?: string|null}>, metric_event: string|null}
     */
    private static function decisionInput(array $input): array
    {
        /** @var list<array{subject: string, action: string, reason: string, scope?: string|null, duration_days?: int|null, restoration_condition?: string|null}> $sanctions */
        $sanctions = array_values((array) ($input['sanctions'] ?? []));

        return ['reason' => (string) $input['reason'], 'amount_centavos' => isset($input['amount_centavos']) ? (int) $input['amount_centavos'] : null,
            'affected_line_ids' => array_values(array_map('strval', (array) ($input['affected_line_ids'] ?? []))), 'conflict_check_confirmed' => (bool) $input['conflict_check_confirmed'],
            'lock_version' => (int) $input['lock_version'], 'sanctions' => $sanctions, 'metric_event' => isset($input['metric_event']) ? (string) $input['metric_event'] : null];
    }

    /** @return list<UploadedFile> */
    private static function uploads(Request $request): array
    {
        $files = $request->file('files');
        if ($files instanceof UploadedFile) {
            return [$files];
        }

        return is_array($files) ? array_values($files) : [];
    }

    private static function party(Request $request): string
    {
        return match ($request->user()?->account_type) {
            'BUYER' => 'BUYER', 'VENDOR' => 'VENDOR', default => 'ADMIN'
        };
    }
}
