<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Finance\FinanceAccess;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Reporting\DocumentExportService;
use App\Domain\Reporting\TaxCalendar;
use App\Domain\Reporting\TaxPackageService;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;
use Symfony\Component\HttpFoundation\StreamedResponse;

final class ReportingController extends Controller
{
    public function index(Request $request, DocumentExportService $service): JsonResponse
    {
        $input = $request->validate(['page' => ['sometimes', 'integer', 'min:1']]);
        $page = DB::table('data_exports')->where('requested_by_user_id', $request->user()->getKey())->whereIn('export_type', DocumentExportService::TYPES)->orderByDesc('id')->paginate(25, ['*'], 'page', $input['page'] ?? 1);
        $rows = [];
        foreach ($page->items() as $export) {
            if ($service->allowed($export)) {
                $rows[] = $service->present($export);
            }
        }

        return ApiResponse::success($rows, ['has_more' => $page->hasMorePages()]);
    }

    public function request(Request $request, DocumentExportService $service): JsonResponse
    {
        $input = $request->validate(['type' => ['required', Rule::in(DocumentExportService::TYPES)], 'format' => ['required', Rule::in(['PDF', 'CSV'])],
            'resource_id' => ['nullable', 'uuid', 'required_unless:type,MATERIALS_ANALYTICS'], 'purpose' => ['required', 'string', 'min:10', 'max:500'],
            'filters' => ['sometimes', 'array:preset_days,start_date,end_date,radius_km,category_id,q,psgc_code,psgc_version_id'],
            'filters.preset_days' => ['sometimes', 'integer', Rule::in([7, 30, 90])], 'filters.start_date' => ['sometimes', 'date_format:Y-m-d'], 'filters.end_date' => ['sometimes', 'date_format:Y-m-d'],
            'filters.radius_km' => ['sometimes', 'integer', 'between:1,50'], 'filters.category_id' => ['sometimes', 'uuid'], 'filters.q' => ['sometimes', 'string', 'max:100'],
            'filters.psgc_code' => ['sometimes', 'string', 'max:16'], 'filters.psgc_version_id' => ['sometimes', 'uuid']]);

        return ApiResponse::success($service->request($request, $input), status: 202);
    }

    public function download(Request $request, string $exportId, DocumentExportService $service): StreamedResponse
    {
        return $service->download($request, $exportId);
    }

    public function taxList(Request $request): JsonResponse
    {
        app(FinanceAccess::class)->admin($request, 'finance.view');
        $input = $request->validate(['page' => ['sometimes', 'integer', 'min:1']]);
        $page = DB::table('tax_report_packages')->orderByDesc('id')->paginate(25, ['id', 'package_type', 'state', 'period_start', 'period_end', 'withholding_entity', 'nominal_due_date', 'actual_due_date', 'due_date_reviewer_id', 'lock_version'], 'page', $input['page'] ?? 1);

        return ApiResponse::success($page->items(), ['has_more' => $page->hasMorePages()]);
    }

    public function prepareTax(Request $request, TaxPackageService $service): JsonResponse
    {
        $input = $request->validate(['form' => ['required', Rule::in(TaxCalendar::FORMS)], 'period_start' => ['required', 'date_format:Y-m-d'],
            'withholding_entity' => ['required', Rule::in(['DEMO_PLATFORM_WITHHOLDER', 'DEMO_PROVIDER_WITHHOLDER'])], 'vendor_organization_id' => ['nullable', 'uuid']]);

        return ApiResponse::success($service->prepare($request, $input), status: 201);
    }

    public function taxDetail(Request $request, string $packageId, TaxPackageService $service): JsonResponse
    {
        return ApiResponse::success($service->detail($request, $packageId));
    }

    public function reviewTax(Request $request, string $packageId, TaxPackageService $service): JsonResponse
    {
        $input = $request->validate(['lock_version' => ['required', 'integer', 'min:1'], 'actual_due_date' => ['required', 'date_format:Y-m-d'],
            'due_date_source' => ['required', 'string', 'min:10', 'max:1000'], 'reason' => ['required', 'string', 'min:10', 'max:1000'], 'reconciled' => ['required', 'accepted']]);

        return ApiResponse::success($service->review($request, $packageId, $input));
    }

    public function simulateTax(Request $request, string $packageId): JsonResponse
    {
        app(FinanceAccess::class)->admin($request, 'finance.record_external_evidence');
        DB::transaction(function () use ($request, $packageId): void {
            $package = DB::table('tax_report_packages')->where('id', $packageId)->lockForUpdate()->first();
            if ($package === null || $package->state !== 'EXPORTED' || $package->environment !== 'TEST') {
                throw new AuthenticationException('PACKAGE_NOT_EXPORTED', 'Export a reviewed demo package first.', 409);
            }
            DB::table('tax_report_packages')->where('id', $packageId)->update(['submission_state' => 'SIMULATED_SUBMISSION_RECORDED', 'updated_at' => now()]);
            app(AuditRecorder::class)->account($request, 'SIMULATED_SUBMISSION_RECORDED', 'TAX_REPORT_PACKAGE', $packageId, after: ['authentic_evidence' => false, 'export_hash' => $package->export_hash]);
        });

        return ApiResponse::success(['submission_state' => 'SIMULATED_SUBMISSION_RECORDED', 'authentic_evidence' => false]);
    }
}
