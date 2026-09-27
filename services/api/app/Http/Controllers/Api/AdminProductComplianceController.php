<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Catalog\ComparableMappingService;
use App\Domain\Compliance\ComplianceRegisterImporter;
use App\Domain\Compliance\ProductComplianceService;
use App\Domain\Identity\AuditRecorder;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\ProductComplianceDecisionRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;

final class AdminProductComplianceController extends Controller
{
    public function __construct(private readonly ProductComplianceService $compliance) {}

    public function queue(Request $request): JsonResponse
    {
        $filters = $request->validate([
            'status' => ['sometimes', Rule::in(['PENDING_ADMIN_REVIEW', 'VERIFIED', 'CHANGES_REQUIRED', 'REJECTED', 'SUPERSEDED', 'ALL'])],
            'path' => ['sometimes', Rule::in(ProductComplianceService::PATHS)],
            'reference_result' => ['sometimes', Rule::in(['MATCHED', 'UNMATCHED', 'UNCERTAIN', 'UNAVAILABLE'])],
            'sort' => ['sometimes', Rule::in(['oldest', 'newest'])],
            'page' => ['sometimes', 'integer', 'between:1,1000'],
        ]);
        $result = $this->compliance->queue($request, $filters);

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function show(Request $request, string $submissionId): JsonResponse
    {
        return ApiResponse::success($this->compliance->detail($request, $submissionId));
    }

    public function decide(ProductComplianceDecisionRequest $request, string $submissionId): JsonResponse
    {
        /** @var array{decision: string, reason?: ?string, remarks?: ?string, lock_version: int, source_reference?: ?string} $input */
        $input = $request->validated();

        return ApiResponse::success($this->compliance->decide($request, $submissionId, $input));
    }

    public function fileUrl(Request $request, string $fileId): JsonResponse
    {
        return ApiResponse::success($this->compliance->adminFileUrl($request, $fileId));
    }

    public function registers(Request $request, CatalogAccess $access): JsonResponse
    {
        $access->requireAdmin($request, 'product_compliance.review');
        $filters = $request->validate(['page' => ['sometimes', 'integer', 'between:1,1000']]);
        $page = DB::table('compliance_reference_registers')->orderByDesc('created_at')->orderBy('id')
            ->paginate(20, ['id', 'register_kind', 'source_reference', 'snapshot_date', 'status', 'row_count', 'rejected_row_count', 'activated_at', 'superseded_at', 'created_at'], 'page', (int) ($filters['page'] ?? 1));

        return ApiResponse::success($page->items(), ['current_page' => $page->currentPage(), 'last_page' => $page->lastPage(), 'total' => $page->total()]);
    }

    public function importRegister(Request $request, CatalogAccess $access, ComplianceRegisterImporter $importer, AuditRecorder $audit): JsonResponse
    {
        $access->requireAdmin($request, 'product_compliance.manage_registers');
        $input = $request->validate([
            'register_kind' => ['required', Rule::in(ComplianceRegisterImporter::KINDS)],
            'source_reference' => ['required', 'string', 'min:3', 'max:500'],
            'snapshot_date' => ['required', 'date_format:Y-m-d', 'before_or_equal:today'],
            'file' => ['required', 'file', 'max:20480'],
        ]);
        $result = $importer->import($request->file('file'), (string) $input['register_kind'], (string) $input['source_reference'], (string) $input['snapshot_date'], (int) $request->user()->getKey());
        $audit->account($request, 'COMPLIANCE_REGISTER_IMPORTED', 'COMPLIANCE_REFERENCE_REGISTER', $result['id'], after: ['register_kind' => $result['register_kind'], 'rows' => $result['row_count'], 'rejected_rows' => $result['rejected_row_count']]);

        return ApiResponse::success($result, status: 201);
    }

    public function activateRegister(Request $request, string $registerId, CatalogAccess $access, ComplianceRegisterImporter $importer, AuditRecorder $audit): JsonResponse
    {
        $access->requireAdmin($request, 'product_compliance.manage_registers');
        $register = $importer->activate($registerId, (int) $request->user()->getKey());
        $audit->account($request, 'COMPLIANCE_REGISTER_ACTIVATED', 'COMPLIANCE_REFERENCE_REGISTER', $registerId, after: ['register_kind' => $register->register_kind, 'snapshot_date' => $register->snapshot_date]);

        return ApiResponse::success((array) $register);
    }

    public function createComparableGroup(Request $request, CatalogAccess $access, ComparableMappingService $comparability, AuditRecorder $audit): JsonResponse
    {
        $access->requireAdmin($request, 'taxonomy.manage');
        $input = $request->validate([
            'material_id' => ['required', 'uuid'],
            'code' => ['required', 'string', 'max:96', 'regex:/^[A-Z0-9_]+$/', 'unique:material_comparable_groups,code'],
            'display_name' => ['required', 'string', 'max:180'],
            'brand' => ['sometimes', 'nullable', 'string', 'max:180'],
            'model' => ['sometimes', 'nullable', 'string', 'max:180'],
            'specification' => ['present', 'array', 'max:30'],
            'canonical_unit_id' => ['required', 'uuid', 'exists:units,id'],
            'conversion_version' => ['sometimes', 'nullable', 'string', 'max:48'],
        ]);
        /** @var array{material_id: string, code: string, display_name: string, brand?: ?string, model?: ?string, specification: array<string, mixed>, canonical_unit_id: string, conversion_version?: ?string} $input */
        $result = $comparability->createGroup($input, (int) $request->user()->getKey());
        $audit->account($request, 'MATERIAL_COMPARABLE_GROUP_CREATED', 'MATERIAL_COMPARABLE_GROUP', $result['group_id'], after: $result);

        return ApiResponse::success($result, status: 201);
    }
}
