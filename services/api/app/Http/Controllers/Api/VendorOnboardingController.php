<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Vendors\ActivationReadiness;
use App\Domain\Vendors\ManageVendorTeam;
use App\Domain\Vendors\OnboardingAccess;
use App\Domain\Vendors\PrivateDocuments;
use App\Domain\Vendors\ReconcileXenditTestAccount;
use App\Domain\Vendors\ReviewVendorEvidence;
use App\Domain\Vendors\SaveBusinessInformation;
use App\Domain\Vendors\StoreMedia;
use App\Domain\Vendors\VendorSetup;
use App\Domain\Vendors\VendorTaxOnboarding;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use App\Http\Requests\Vendors\OnboardingRequest;
use App\Http\Resources\VendorOnboardingResource;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Symfony\Component\HttpFoundation\StreamedResponse;

final class VendorOnboardingController extends Controller
{
    public function __construct(private readonly OnboardingAccess $access, private readonly ActivationReadiness $readiness) {}

    public function media(OnboardingRequest $request, string $organization, StoreMedia $action): JsonResponse
    {
        return ApiResponse::success($action->read($request, $organization));
    }

    public function uploadMedia(OnboardingRequest $request, string $organization, StoreMedia $action): JsonResponse
    {
        $file = $request->file('file');
        abort_unless($file instanceof UploadedFile, 422);
        $action->upload($request, $organization, $file);

        return ApiResponse::success(status: 201);
    }

    public function reviewMedia(OnboardingRequest $request, string $organization, string $media, StoreMedia $action): JsonResponse
    {
        $action->review($request, $organization, $media);

        return ApiResponse::success();
    }

    public function removeMedia(OnboardingRequest $request, string $organization, string $media, StoreMedia $action): JsonResponse
    {
        $action->remove($request, $organization, $media);

        return ApiResponse::success();
    }

    public function previewMedia(OnboardingRequest $request, string $organization, string $media, StoreMedia $action): StreamedResponse
    {
        return $action->preview($request, $organization, $media);
    }

    public function publicMedia(string $organization, string $media, StoreMedia $action): StreamedResponse
    {
        return $action->publicPreview($organization, $media);
    }

    public function show(OnboardingRequest $request, string $organization): JsonResponse
    {
        if ($request->user()->account_type === 'ADMIN') {
            $this->access->reviewer($request);
        } else {
            $this->access->vendor($request, $organization);
        }

        return ApiResponse::success(new VendorOnboardingResource($this->readiness->evaluate($organization)));
    }

    public function business(OnboardingRequest $request, string $organization, SaveBusinessInformation $action): JsonResponse
    {
        return ApiResponse::success(new VendorOnboardingResource($action->read($request, $organization)));
    }

    public function saveBusiness(OnboardingRequest $request, string $organization, SaveBusinessInformation $action): JsonResponse
    {
        return ApiResponse::success(new VendorOnboardingResource($action->save($request, $organization, $request->validated())));
    }

    public function requestStoreEmailVerification(OnboardingRequest $request, string $organization, SaveBusinessInformation $action): JsonResponse
    {
        return ApiResponse::success(new VendorOnboardingResource($action->requestStoreEmailVerification($request, $organization, $request->validated())));
    }

    public function confirmStoreEmailVerification(OnboardingRequest $request, string $organization, SaveBusinessInformation $action): JsonResponse
    {
        return ApiResponse::success(new VendorOnboardingResource($action->confirmStoreEmailVerification($request, $organization, $request->validated())));
    }

    public function upload(OnboardingRequest $request, string $organization, PrivateDocuments $action): JsonResponse
    {
        $file = $request->file('file');
        abort_unless($file instanceof UploadedFile, 422);

        return ApiResponse::success(new VendorOnboardingResource($action->upload($request, $organization, $request->string('document_type')->toString(), $file, $request->integer('lock_version'))), status: 201);
    }

    public function link(OnboardingRequest $request, string $organization, string $version, PrivateDocuments $action): JsonResponse
    {
        return ApiResponse::success(new VendorOnboardingResource($action->link($request, $organization, $version)));
    }

    public function download(OnboardingRequest $request, string $organization, string $version, PrivateDocuments $action): StreamedResponse
    {
        return $action->download($request, $organization, $version);
    }

    public function reviewDocument(OnboardingRequest $request, string $organization, string $version, ReviewVendorEvidence $action): JsonResponse
    {
        return ApiResponse::success(new VendorOnboardingResource($action->document($request, $organization, $version, $request->validated())));
    }

    public function reviewBusiness(OnboardingRequest $request, string $organization, ReviewVendorEvidence $action): JsonResponse
    {
        return ApiResponse::success(new VendorOnboardingResource($action->business($request, $organization, $request->validated())));
    }

    public function activate(OnboardingRequest $request, string $organization): JsonResponse
    {
        return DB::transaction(function () use ($request, $organization): JsonResponse {
            $row = DB::table('vendor_organizations')->where('id', $organization)->lockForUpdate()->firstOrFail();
            $this->access->vendor($request, $organization, sensitive: true);
            $this->access->version($row, $request->integer('lock_version'));

            return ApiResponse::success(new VendorOnboardingResource($this->readiness->reconcile($request, $organization, true)));
        });
    }

    public function queue(OnboardingRequest $request): JsonResponse
    {
        $this->access->reviewer($request);
        $rows = DB::table('vendor_organizations')->whereNotNull('submitted_at')->orderBy('submitted_at')->orderBy('id')->paginate($request->integer('per_page', 20), ['id', 'store_name', 'onboarding_status', 'store_verification_status', 'store_setup_status', 'activation_status', 'discoverability_status', 'marketplace_status', 'lock_version', 'submitted_at']);

        return ApiResponse::success($rows->items(), ['page' => $rows->currentPage(), 'last_page' => $rows->lastPage(), 'total' => $rows->total()]);
    }

    public function documents(OnboardingRequest $request, string $organization): JsonResponse
    {
        if ($request->user()->account_type === 'ADMIN') {
            $this->access->reviewer($request);
        } else {
            $this->access->vendor($request, $organization);
        }
        $rows = DB::table('business_documents as d')->join('business_document_versions as v', 'v.business_document_id', '=', 'd.id')->join('files as f', 'f.id', '=', 'v.file_id')->where('d.vendor_organization_id', $organization)->orderByDesc('v.id')->paginate($request->integer('per_page', 20), ['v.id', 'd.document_type', 'd.status', 'v.version', 'v.environment', 'v.evidence_origin', 'f.scan_state', 'v.created_at']);
        foreach ($rows->items() as $row) {
            $review = DB::table('business_document_reviews')->where('business_document_version_id', $row->id)->where('environment', 'TEST')->orderByDesc('id')->first();
            $row->status = match ($review?->decision) {
                'APPROVE' => 'APPROVED', 'REJECT' => 'REJECTED', 'RETURN_FOR_CORRECTION' => 'CHANGES_REQUIRED', default => 'PENDING_VERIFICATION'
            };
            $row->review_reason = $review?->reason;
            $row->verified_reference = $review?->verified_reference;
            $row->verified_issued_on = $review?->verified_issued_on;
            $row->verified_expires_on = $review?->verified_expires_on;
            $row->verified_expiry_not_applicable = $review->verified_expiry_not_applicable ?? false;
        }

        return ApiResponse::success($rows->items(), ['page' => $rows->currentPage(), 'last_page' => $rows->lastPage(), 'total' => $rows->total()]);
    }

    public function tax(OnboardingRequest $request, string $organization, VendorTaxOnboarding $action): JsonResponse
    {
        return ApiResponse::success(new VendorOnboardingResource($action->read($request, $organization)));
    }

    public function saveTax(OnboardingRequest $request, string $organization, VendorTaxOnboarding $action): JsonResponse
    {
        return ApiResponse::success(new VendorOnboardingResource($action->save($request, $organization, $request->validated())));
    }

    public function reviewTax(OnboardingRequest $request, string $organization, string $version, VendorTaxOnboarding $action): JsonResponse
    {
        return ApiResponse::success(new VendorOnboardingResource($action->review($request, $organization, $version, $request->validated())));
    }

    public function setup(OnboardingRequest $request, string $organization, VendorSetup $action): JsonResponse
    {
        return ApiResponse::success(new VendorOnboardingResource($action->read($request, $organization)));
    }

    public function saveStore(OnboardingRequest $request, string $organization, VendorSetup $action): JsonResponse
    {
        return ApiResponse::success(new VendorOnboardingResource($action->store($request, $organization, $request->validated())));
    }

    public function connect(OnboardingRequest $request, string $organization, VendorSetup $action): JsonResponse
    {
        return ApiResponse::success(new VendorOnboardingResource($action->payment($request, $organization, $request->validated())));
    }

    public function reconcileConnection(OnboardingRequest $request, string $organization, ReconcileXenditTestAccount $action): JsonResponse
    {
        return ApiResponse::success(new VendorOnboardingResource($action->handle($request, $organization, $request->integer('lock_version'))));
    }

    public function commission(OnboardingRequest $request, string $organization, VendorSetup $action): JsonResponse
    {
        return ApiResponse::success(new VendorOnboardingResource($action->commission($request, $organization)));
    }

    public function acceptCommission(OnboardingRequest $request, string $organization, VendorSetup $action): JsonResponse
    {
        return ApiResponse::success(new VendorOnboardingResource($action->commission($request, $organization, $request->string('version_id')->toString())));
    }

    public function team(OnboardingRequest $request, string $organization, ManageVendorTeam $action): JsonResponse
    {
        return ApiResponse::success(new VendorOnboardingResource($action->read($request, $organization)));
    }

    public function invite(OnboardingRequest $request, string $organization, ManageVendorTeam $action): JsonResponse
    {
        $action->invite($request, $organization);

        return ApiResponse::success(status: 202);
    }

    public function revokeInvitation(OnboardingRequest $request, string $organization, string $invitation, ManageVendorTeam $action): JsonResponse
    {
        $action->revoke($request, $organization, $invitation);

        return ApiResponse::success();
    }

    public function changeMember(OnboardingRequest $request, string $organization, string $membership, ManageVendorTeam $action): JsonResponse
    {
        $action->change($request, $organization, $membership);

        return ApiResponse::success();
    }

    public function invitations(OnboardingRequest $request, string $organization): JsonResponse
    {
        $this->access->vendor($request, $organization, 'staff.manage');
        $rows = DB::table('vendor_invitations')->where('vendor_organization_id', $organization)->orderByDesc('id')->paginate($request->integer('per_page', 20), ['id', 'full_name', 'normalized_email', 'role', 'can_manage_staff', 'expires_at', 'accepted_at', 'revoked_at', 'lock_version']);

        return ApiResponse::success($rows->items(), ['page' => $rows->currentPage(), 'last_page' => $rows->lastPage(), 'total' => $rows->total()]);
    }
}
