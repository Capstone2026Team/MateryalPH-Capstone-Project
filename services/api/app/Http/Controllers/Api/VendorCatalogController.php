<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Catalog\CatalogImportService;
use App\Domain\Catalog\MaterialSearch;
use App\Domain\Catalog\VendorCatalogService;
use App\Domain\Compliance\ProductComplianceService;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use App\Http\Requests\Catalog\CatalogListingCreateRequest;
use App\Http\Requests\Catalog\CatalogListingUpdateRequest;
use App\Http\Requests\Catalog\CatalogVariantsRequest;
use App\Http\Requests\Catalog\ComplianceSubmitRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

final class VendorCatalogController extends Controller
{
    public function __construct(private readonly VendorCatalogService $catalog) {}

    public function taxonomy(Request $request): JsonResponse
    {
        return ApiResponse::success($this->catalog->taxonomy($request));
    }

    public function searchMaterials(Request $request, CatalogAccess $access, MaterialSearch $search): JsonResponse
    {
        $input = $request->validate(['q' => ['required', 'string', 'min:2', 'max:120']]);
        $access->organizationFor($request, CatalogAccess::VIEW);

        return ApiResponse::success($search->search((string) $input['q']), ['fuzzy_threshold' => MaterialSearch::FUZZY_THRESHOLD]);
    }

    public function material(Request $request, string $materialId): JsonResponse
    {
        return ApiResponse::success($this->catalog->material($request, $materialId));
    }

    public function index(Request $request): JsonResponse
    {
        $filters = $request->validate([
            'status' => ['sometimes', Rule::in(['DRAFT', 'PENDING_COMPLIANCE', 'PENDING_ADMIN_REVIEW', 'ACTIVE', 'INACTIVE', 'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED', 'REJECTED'])],
            'compliance_status' => ['sometimes', Rule::in(['NOT_REQUIRED', 'NOT_SUBMITTED', 'PENDING_ADMIN_REVIEW', 'VERIFIED', 'CHANGES_REQUIRED', 'REJECTED'])],
            'category_id' => ['sometimes', 'uuid'],
            'q' => ['sometimes', 'string', 'max:120'],
            'page' => ['sometimes', 'integer', 'between:1,1000'],
        ]);
        $result = $this->catalog->list($request, $filters);

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function show(Request $request, string $listingId): JsonResponse
    {
        return ApiResponse::success($this->catalog->detail($request, $listingId));
    }

    public function store(CatalogListingCreateRequest $request): JsonResponse
    {
        return ApiResponse::success($this->catalog->create($request, $request->validated()), status: 201);
    }

    public function update(CatalogListingUpdateRequest $request, string $listingId): JsonResponse
    {
        return ApiResponse::success($this->catalog->update($request, $listingId, $request->validated()));
    }

    public function variants(CatalogVariantsRequest $request, string $listingId): JsonResponse
    {
        /** @var array{lock_version: int, variants: list<array<string, mixed>>} $input */
        $input = $request->validated();

        return ApiResponse::success($this->catalog->saveVariants($request, $listingId, $input));
    }

    public function uploadMedia(Request $request, string $listingId): JsonResponse
    {
        $input = $request->validate([
            'file' => ['required', 'file', 'max:20480'],
            'alt_text' => ['sometimes', 'nullable', 'string', 'max:160'],
            'replaces_media_id' => ['sometimes', 'nullable', 'uuid'],
        ]);

        return ApiResponse::success($this->catalog->uploadMedia($request, $listingId, $request->file('file'), $input['alt_text'] ?? null, $input['replaces_media_id'] ?? null), status: 201);
    }

    public function removeMedia(Request $request, string $listingId, string $mediaId): JsonResponse
    {
        return ApiResponse::success($this->catalog->removeMedia($request, $listingId, $mediaId));
    }

    public function publish(Request $request, string $listingId): JsonResponse
    {
        $input = $request->validate(['lock_version' => ['required', 'integer', 'min:1']]);

        return ApiResponse::success($this->catalog->publish($request, $listingId, (int) $input['lock_version']));
    }

    public function deactivate(Request $request, string $listingId): JsonResponse
    {
        $input = $request->validate(['lock_version' => ['required', 'integer', 'min:1'], 'reason' => ['sometimes', 'nullable', 'string', 'max:500']]);

        return ApiResponse::success($this->catalog->deactivate($request, $listingId, (int) $input['lock_version'], $input['reason'] ?? null));
    }

    public function destroy(Request $request, string $listingId): JsonResponse
    {
        $input = $request->validate(['lock_version' => ['required', 'integer', 'min:1']]);

        return ApiResponse::success($this->catalog->delete($request, $listingId, (int) $input['lock_version']));
    }

    public function fileUrl(Request $request, string $fileId): JsonResponse
    {
        return ApiResponse::success($this->catalog->fileUrl($request, $fileId));
    }

    public function uploadComplianceEvidence(Request $request, string $listingId, ProductComplianceService $compliance): JsonResponse
    {
        $input = $request->validate([
            'path' => ['required', Rule::in(ProductComplianceService::PATHS)],
            'file' => ['required', 'file', 'max:20480'],
            'qr_payload' => ['sometimes', 'nullable', 'string', 'max:2048'],
        ]);

        return ApiResponse::success($compliance->uploadEvidence($request, $listingId, (string) $input['path'], $request->file('file'), $input['qr_payload'] ?? null), status: 201);
    }

    public function submitCompliance(ComplianceSubmitRequest $request, string $listingId, ProductComplianceService $compliance): JsonResponse
    {
        return ApiResponse::success($compliance->submit($request, $listingId, $request->validated()), status: 201);
    }

    public function uploadImport(Request $request, CatalogImportService $imports): JsonResponse
    {
        $request->validate(['file' => ['required', 'file', 'max:10240']]);

        return ApiResponse::success($imports->upload($request, $request->file('file')), status: 201);
    }

    public function showImport(Request $request, string $jobId, CatalogImportService $imports): JsonResponse
    {
        $input = $request->validate(['page' => ['sometimes', 'integer', 'between:1,1000']]);

        return ApiResponse::success($imports->job($request, $jobId, (int) ($input['page'] ?? 1)));
    }

    public function applyImport(Request $request, string $jobId, CatalogImportService $imports): JsonResponse
    {
        return ApiResponse::success($imports->apply($request, $jobId));
    }

    public function importTemplate(Request $request, CatalogAccess $access): JsonResponse
    {
        $access->organizationFor($request, CatalogAccess::MANAGE);

        return ApiResponse::success(['template_version' => CatalogImportService::TEMPLATE_VERSION, 'columns' => CatalogImportService::COLUMNS, 'required_columns' => CatalogImportService::REQUIRED, 'max_rows' => CatalogImportService::MAX_ROWS]);
    }
}
