<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Finance\WithholdingThresholdService;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\OutboxPublisher;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use stdClass;

final class AdminVendorVerificationService
{
    private const REVIEW_GROUPS = [
        'business_information_group' => ['business_type', 'business_information', 'legal_identity', 'registered_business_address', 'supplier_classification', 'tax_profile', 'privacy_acknowledgement'],
        'legal_identity_id' => ['identity_evidence', 'identity_back_evidence'],
        'representative_id' => ['representative_identity', 'representative_identity_back'],
    ];

    public function __construct(
        private readonly AuditRecorder $audit,
        private readonly OutboxPublisher $outbox,
        private readonly VendorOnboardingService $onboarding,
        private readonly VendorAuthorityService $authority,
    ) {}

    /**
     * @param  array<string, mixed>  $filters
     * @return array<string, mixed>
     */
    public function queue(Request $request, array $filters): array
    {
        $this->authorize($request, 'vendor_verification.review');
        $submitted = DB::table('vendor_onboarding_steps')->select('vendor_organization_id')->selectRaw('MAX(submitted_at) AS submitted_at')->where('section', 'STORE_VERIFICATION')->where('is_current', true)->groupBy('vendor_organization_id');
        $regions = new PhilippineRegionDirectory;
        $query = DB::table('vendor_organizations')
            ->leftJoinSub($submitted, 'submission', 'submission.vendor_organization_id', '=', 'vendor_organizations.id')
            ->leftJoin('addresses as address', function ($join): void {
                $join->on('address.owner_id', '=', 'vendor_organizations.id')->where('address.owner_type', 'VENDOR_ORGANIZATION')->where('address.is_current', true);
            })
            ->leftJoinSub($regions->mapping(), 'region', 'region.code', '=', 'address.psgc_code')
            ->select('vendor_organizations.*', 'submission.submitted_at', 'address.province', 'address.city_municipality', 'region.region_code', 'region.region_name')
            ->whereIn('store_verification_status', ['SUBMITTED', 'PENDING_VERIFICATION', 'CHANGES_REQUIRED', 'REJECTED', 'APPROVED', 'EXPIRED']);
        if (is_string($filters['status'] ?? null) && $filters['status'] !== '') {
            $query->where('store_verification_status', $filters['status']);
        }
        if (is_string($filters['business_type'] ?? null) && $filters['business_type'] !== '') {
            $query->where('business_type', $filters['business_type']);
        }
        if (($filters['region_code'] ?? '') === 'UNASSIGNED') {
            $query->whereNull('region.region_code');
        } elseif (! empty($filters['region_code'])) {
            $query->where('region.region_code', $filters['region_code']);
        }
        foreach (['submitted_from' => '>=', 'submitted_to' => '<='] as $key => $operator) {
            if (! empty($filters[$key])) {
                $query->whereRaw("(submission.submitted_at AT TIME ZONE 'Asia/Manila')::date $operator ?", [$filters[$key]]);
            }
        }
        $sort = $filters['sort'] ?? 'submitted_desc';
        if ($sort === 'location') {
            $query->orderBy('region.region_name')->orderBy('address.province')->orderBy('address.city_municipality');
        }
        $query->orderByRaw('submission.submitted_at '.($sort === 'submitted_asc' ? 'ASC' : 'DESC').' NULLS LAST');
        $rows = $query->orderBy('vendor_organizations.id')->paginate(20);

        return [
            'items' => array_map(fn (mixed $row): array => $this->queueItem($row), $rows->items()),
            'meta' => ['current_page' => $rows->currentPage(), 'last_page' => $rows->lastPage(), 'per_page' => $rows->perPage(), 'total' => $rows->total(), 'regions' => $regions->options()],
        ];
    }

    /** @return array<string, mixed> */
    private function queueItem(mixed $value): array
    {
        if (! $value instanceof stdClass) {
            throw new \RuntimeException('Unexpected Vendor verification queue row.');
        }
        $steps = DB::table('vendor_onboarding_steps')->where('vendor_organization_id', $value->id)->where('section', 'STORE_VERIFICATION')->where('requirement_key', '!=', 'commission_terms')->where('is_current', true)->get(['status', 'level', 'submitted_at']);

        return ['id' => $value->id, 'store_name' => $value->store_name, 'registered_name' => $value->registered_name, 'business_type' => $value->business_type, 'verification_status' => $value->store_verification_status, 'setup_status' => $value->store_setup_status, 'activation_status' => $value->store_activation_status, 'submitted_at' => $value->submitted_at, 'region_code' => $value->region_code, 'region_name' => $value->region_name, 'province' => $value->province, 'city_municipality' => $value->city_municipality, 'progress' => ['complete' => $steps->whereIn('status', ['APPROVED', 'NOT_APPLICABLE'])->count(), 'total' => $steps->where('level', '!=', 'OPTIONAL')->count()]];
    }

    /** @return array<string, mixed> */
    public function detail(Request $request, string $organizationId): array
    {
        $this->authorize($request, 'vendor_verification.review');
        $organization = DB::table('vendor_organizations')->where('id', $organizationId)->first();
        if ($organization === null) {
            throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The Vendor verification case is unavailable.', 404);
        }
        $steps = DB::table('vendor_onboarding_steps')->where('vendor_organization_id', $organizationId)->where('is_current', true)->orderBy('section')->orderBy('id')->get();
        $documents = DB::table('vendor_documents as d')->where('d.review_submitted', true)->leftJoin('vendor_document_versions as v', 'v.id', '=', 'd.current_version_id')->where('d.vendor_organization_id', $organizationId)->get(['d.id', 'd.requirement_key', 'd.document_type', 'd.status', 'd.lock_version', 'v.id as version_id', 'v.version', 'v.scan_state', 'v.file_id', 'v.vendor_metadata']);
        $reviews = DB::table('business_document_reviews as r')->join('vendor_document_versions as v', 'v.id', '=', 'r.business_document_version_id')->join('vendor_documents as d', 'd.id', '=', 'v.business_document_id')->join('users as u', 'u.id', '=', 'r.reviewer_user_id')->whereIn('v.business_document_id', $documents->pluck('id')->filter()->all())->orderByDesc('r.reviewed_at')->get(['r.id', 'r.business_document_version_id', 'd.requirement_key', 'v.version', 'r.decision', 'r.reason', 'r.verified_document_number', 'r.verified_issue_date', 'r.expiration_kind', 'r.verified_expiration_date', 'r.evidence_source', 'r.remarks', 'r.reviewed_at', 'r.reviewer_user_id', 'u.name as reviewer_name']);
        $address = DB::table('addresses')->where('owner_type', 'VENDOR_ORGANIZATION')->where('owner_id', $organizationId)->where('is_current', true)->first();
        $classification = DB::table('vendor_classifications')->where('vendor_organization_id', $organizationId)->first();
        $tax = DB::table('vendor_tax_profiles as p')->leftJoin('vendor_tax_profile_versions as v', 'v.id', '=', 'p.current_version_id')->where('p.vendor_organization_id', $organizationId)->first(['p.status', 'p.environment', 'p.attested_at', 'v.version', 'v.entity_class', 'v.registration_category', 'v.vat_category', 'v.vat_verified_category', 'v.bir_cor_reference', 'v.fiscal_year_start_month', 'v.taxpayer_key_last4', 'v.tin_last4', 'v.tax_details', 'v.owner_attested_at']);
        $payment = DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organizationId)->first(['provider', 'environment', 'provider_account_id', 'connection_status', 'provider_status', 'capabilities', 'invitation_url_masked', 'last_reconciled_at', 'last_error_code']);
        $businessType = (string) ($organization->business_type ?? '');
        $companyIdentityRequired = in_array($businessType, ['PARTNERSHIP', 'CORPORATION', 'ONE_PERSON_CORPORATION', 'COOPERATIVE'], true);
        $individualIdentityRequired = in_array($businessType, ['SOLE_PROPRIETORSHIP', 'ONE_PERSON_CORPORATION'], true);

        return ['representative' => $this->authority->snapshot($organizationId), 'representative_history' => DB::table('vendor_representative_versions')->where('vendor_organization_id', $organizationId)->orderByDesc('version')->get(['id', 'version', 'created_at', 'created_by_user_id'])->map(fn (object $row): array => (array) $row)->all(), 'authority_reviews' => DB::table('vendor_authority_reviews as r')->join('vendor_representative_versions as v', 'v.id', '=', 'r.representative_version_id')->where('v.vendor_organization_id', $organizationId)->orderByDesc('r.reviewed_at')->get(['r.*', 'v.version'])->map(fn (object $row): array => (array) $row)->all(), 'organization' => ['id' => $organization->id, 'store_name' => $organization->store_name, 'registered_name' => $organization->registered_name, 'legal_name' => $organization->legal_name, 'business_type' => $organization->business_type, 'date_established' => $organization->date_established, 'store_email' => $organization->store_email, 'store_phone' => $organization->store_phone, 'verification_status' => $organization->store_verification_status, 'setup_status' => $organization->store_setup_status, 'activation_status' => $organization->store_activation_status, 'lock_version' => (int) $organization->lock_version], 'sections' => ['STORE_VERIFICATION' => $steps->where('section', 'STORE_VERIFICATION')->values()->map(fn (object $step): array => $this->step($step, $organization->business_type))->all(), 'STORE_SETUP' => $steps->where('section', 'STORE_SETUP')->values()->map(fn (object $step): array => $this->step($step, $organization->business_type))->all()], 'legal_identity' => ['individual_required' => $individualIdentityRequired, 'company_required' => $companyIdentityRequired, 'same_as_owner' => (bool) ($organization->legal_identity_same_as_owner ?? false), 'surname' => $organization->individual_registered_surname ?? null, 'first_name' => $organization->individual_registered_first_name ?? null, 'middle_name' => $organization->individual_registered_middle_name ?? null, 'suffix' => $organization->individual_registered_suffix ?? null, 'company_registered_name' => $organization->company_registered_name ?? $organization->registered_name ?? null, 'id_type' => $organization->identity_id_type ?? null, 'id_number_last4' => $organization->identity_id_number_last4 ?? null], 'address' => $address === null ? null : ['street' => $address->street, 'unit' => $address->unit, 'barangay' => $address->barangay, 'city_municipality' => $address->city_municipality, 'province' => $address->province, 'postal_code' => $address->postal_code, 'formatted_address' => $address->formatted_address, 'latitude' => $address->latitude === null ? null : (float) $address->latitude, 'longitude' => $address->longitude === null ? null : (float) $address->longitude, 'review_state' => $address->review_state, 'version' => (int) $address->version], 'classification' => $classification === null ? null : ['supplier_type' => $classification->supplier_type, 'niches' => $this->jsonArray($classification->niches), 'custom_label' => $classification->custom_label, 'custom_labels' => $this->jsonArray($classification->custom_labels)], 'tax_profile' => $tax === null ? null : ['status' => $tax->status, 'environment' => $tax->environment, 'version' => $tax->version === null ? null : (int) $tax->version, 'entity_class' => $tax->entity_class, 'registration_category' => $tax->registration_category, 'vat_category' => $tax->vat_category, 'vat_verified_category' => $tax->vat_verified_category, 'bir_cor_reference' => $tax->bir_cor_reference, 'fiscal_year_start_month' => $tax->fiscal_year_start_month, 'taxpayer_key_last4' => $tax->taxpayer_key_last4, 'tin_last4' => $tax->tin_last4, 'details' => array_diff_key(is_string($tax->tax_details) ? (json_decode($tax->tax_details, true) ?: []) : [], array_flip(['head_office', 'branch_code_length'])), 'owner_attested' => $tax->owner_attested_at !== null], 'payment' => $payment === null ? null : ['provider' => $payment->provider, 'environment' => $payment->environment, 'provider_account_id' => $payment->provider_account_id, 'connection_status' => $payment->connection_status, 'provider_status' => $payment->provider_status, 'capabilities' => is_string($payment->capabilities) ? (json_decode($payment->capabilities, true) ?: []) : [], 'invitation_url_masked' => $payment->invitation_url_masked, 'last_reconciled_at' => $payment->last_reconciled_at, 'last_error_code' => $payment->last_error_code], 'documents' => $documents->map(fn (object $document): array => ['id' => $document->id, 'requirement_key' => $document->requirement_key, 'document_type' => $document->document_type, 'status' => $document->status, 'lock_version' => (int) $document->lock_version, 'version_id' => $document->version_id, 'version' => $document->version === null ? null : (int) $document->version, 'scan_state' => $document->scan_state, 'file_id' => $document->file_id])->all(), 'reviews' => $reviews->map(fn (object $review): array => (array) $review)->all(), 'readiness' => $this->onboarding->readinessForOrganization($organizationId)];
    }

    /**
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function decide(Request $request, string $organizationId, string $requirementKey, array $input): array
    {
        $this->authorize($request, 'vendor_verification.review');
        $decision = strtoupper((string) ($input['decision'] ?? ''));
        if (! in_array($decision, ['APPROVED', 'CHANGES_REQUIRED', 'REJECTED'], true)) {
            throw new AuthenticationException('DECISION_INVALID', 'Choose an approved verification decision.', 422);
        }
        if (isset(self::REVIEW_GROUPS[$requirementKey])) {
            return $this->decideGroup($request, $organizationId, $requirementKey, $input, $decision);
        }
        $key = $this->requireIdempotencyKey($request);
        DB::transaction(function () use ($request, $organizationId, $requirementKey, $input, $decision, $key): void {
            $organization = DB::table('vendor_organizations')->where('id', $organizationId)->lockForUpdate()->firstOrFail();
            if ($this->idempotent($request, 'ADMIN_VENDOR_DECISION', $organizationId.'|'.$requirementKey)) {
                return;
            }
            if ($requirementKey === 'commission_terms') {
                throw new AuthenticationException('DECISION_INVALID', 'Commission acceptance must be recorded by the authorized Vendor signatory.', 422);
            }
            $step = DB::table('vendor_onboarding_steps')->where('vendor_organization_id', $organizationId)->where('section', 'STORE_VERIFICATION')->where('requirement_key', $requirementKey)->where('is_current', true)->lockForUpdate()->first();
            if ($step === null) {
                throw new AuthenticationException('REQUIREMENT_NOT_FOUND', 'The verification requirement is unavailable.', 404);
            }
            if (isset($input['lock_version']) && (int) $input['lock_version'] !== (int) $step->lock_version) {
                throw new AuthenticationException('RESOURCE_VERSION_CONFLICT', 'This requirement changed. Reload the review.', 409);
            }
            $reason = isset($input['reason']) ? trim((string) $input['reason']) : null;
            if ($decision !== 'APPROVED' && ($reason === null || $reason === '')) {
                throw new AuthenticationException('DECISION_REASON_REQUIRED', 'A reason is required for correction or rejection.', 422);
            }
            $expirationKind = strtoupper((string) ($input['expiration_kind'] ?? 'UNVERIFIED'));
            $issueDate = $input['verified_issue_date'] ?? null;
            $expirationDate = $input['verified_expiration_date'] ?? null;
            if (! in_array($expirationKind, ['DATE', 'NO_EXPIRATION', 'UNVERIFIED'], true)) {
                throw new AuthenticationException('EXPIRATION_METADATA_INVALID', 'Choose a valid expiration state.', 422);
            }
            if ($expirationKind === 'DATE' && (! is_string($expirationDate) || trim($expirationDate) === '')) {
                throw new AuthenticationException('EXPIRATION_METADATA_INVALID', 'Provide an expiration date or choose Not Applicable.', 422);
            }
            if ($expirationKind !== 'DATE' && $expirationDate !== null && $expirationDate !== '') {
                throw new AuthenticationException('EXPIRATION_METADATA_INVALID', 'An expiration date is only valid when expiration is recorded as a date.', 422);
            }
            if (is_string($issueDate) && is_string($expirationDate) && $expirationDate < $issueDate) {
                throw new AuthenticationException('EXPIRATION_METADATA_INVALID', 'The expiration date cannot be before the issue date.', 422);
            }
            if ($decision === 'APPROVED' && $expirationKind === 'DATE' && $expirationDate < now()->toDateString()) {
                throw new AuthenticationException('DOCUMENT_EXPIRED', 'Expired evidence requires a current replacement before approval.', 422);
            }
            if ($step->status === 'NOT_APPLICABLE') {
                throw new AuthenticationException('REQUIREMENT_NOT_APPLICABLE', 'This requirement does not apply to the current business configuration.', 422);
            }
            if (! in_array($step->status, ['SUBMITTED', 'PENDING_VERIFICATION', 'APPROVED', 'CHANGES_REQUIRED', 'REJECTED', 'EXPIRED'], true)) {
                throw new AuthenticationException('REQUIREMENT_NOT_SUBMITTED', 'The Vendor must submit this requirement before Admin review.', 422);
            }
            if ($requirementKey === 'authority_to_act') {
                $this->authority->review($request, $organizationId, $input);
            }
            if ($decision === 'APPROVED' && $requirementKey === 'tax_profile') {
                $tax = DB::table('vendor_tax_profiles as p')->join('vendor_tax_profile_versions as v', 'v.id', '=', 'p.current_version_id')->where('p.vendor_organization_id', $organizationId)->first(['v.owner_attested_at', 'v.vat_category', 'v.vat_verified_category']);
                if ($tax === null || $tax->owner_attested_at === null || $tax->vat_verified_category === null || $tax->vat_verified_category !== $tax->vat_category) {
                    throw new AuthenticationException('TAX_REVIEW_INCOMPLETE', 'Owner attestation and a matching VAT classification verified against BIR evidence are required.', 422);
                }
            }
            $document = DB::table('vendor_documents')->where('vendor_organization_id', $organizationId)->where('requirement_key', $requirementKey)->first();
            if ($decision === 'APPROVED' && $document !== null && $document->superseded_at !== null) {
                throw new AuthenticationException('EVIDENCE_SUPERSEDED', 'Upload current evidence for the changed business configuration before review.', 422);
            }
            if ($decision === 'APPROVED' && $requirementKey !== 'authority_to_act' && isset(VendorOnboardingService::DOCUMENTS[$requirementKey]) && ($document === null || $document->current_version_id === null)) {
                throw new AuthenticationException('EVIDENCE_NOT_CLEAN', 'Only validated clean evidence can be approved.', 422);
            }
            if ($decision === 'APPROVED' && $document !== null && ($expirationKind === 'UNVERIFIED' || ($expirationKind === 'DATE' && ! is_string($issueDate)))) {
                throw new AuthenticationException('EXPIRATION_METADATA_INVALID', 'Record verified issue and expiration dates for a time-limited document, or explicitly choose No expiration.', 422);
            }
            if ($document !== null && $document->current_version_id !== null) {
                $version = DB::table('vendor_document_versions')->where('id', $document->current_version_id)->first();
                if ($decision === 'APPROVED' && ($version === null || $version->scan_state !== 'CLEAN' || $version->content_validation_state !== 'VALID' || DB::table('files')->where('id', $version->file_id)->value('scan_state') !== 'CLEAN')) {
                    throw new AuthenticationException('EVIDENCE_NOT_CLEAN', 'Only validated clean evidence can be approved.', 422);
                }
                if ($version !== null) {
                    DB::table('business_document_reviews')->insert(['id' => (string) Str::uuid7(), 'business_document_version_id' => $version->id, 'reviewer_user_id' => $request->user()->getKey(), 'decision' => $decision, 'reason' => $reason, 'verified_document_number' => $input['verified_document_number'] ?? null, 'verified_issue_date' => $issueDate, 'expiration_kind' => $expirationKind, 'verified_expiration_date' => $expirationDate, 'evidence_source' => $input['evidence_source'] ?? null, 'remarks' => $input['remarks'] ?? null, 'reviewed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
                    if ($requirementKey === 'tax_relief_evidence') {
                        DB::table('tax_evidence')->where('file_id', $version->file_id)->update(['review_state' => $decision, 'reviewed_by_user_id' => $request->user()->getKey(), 'reviewed_at' => now(), 'updated_at' => now()]);
                        $evidenceId = DB::table('tax_evidence')->where('file_id', $version->file_id)->value('id');
                        $reviewerId = (int) $request->user()->getKey();
                        if ($decision === 'APPROVED' && is_string($evidenceId)) {
                            // FIN-04A: a reviewed relief basis may move SUBJECT_STANDARD/SUBJECT_PRIOR_YEAR only before a crossing.
                            DB::afterCommit(static fn () => app(WithholdingThresholdService::class)->reliefBasisApproved($organizationId, $evidenceId, $reviewerId, (string) Str::uuid7()));
                        }
                    }
                    DB::table('vendor_documents')->where('id', $document->id)->update(['status' => $decision, 'lock_version' => (int) $document->lock_version + 1, 'updated_at' => now()]);
                }
            }
            if ($requirementKey === 'bir_cor' && $decision === 'APPROVED' && is_string($input['verified_vat_category'] ?? null)) {
                $taxVersionId = DB::table('vendor_tax_profiles')->where('vendor_organization_id', $organizationId)->value('current_version_id');
                if (is_string($taxVersionId)) {
                    DB::table('vendor_tax_profile_versions')->where('id', $taxVersionId)->update(['vat_verified_category' => $input['verified_vat_category'], 'updated_at' => now()]);
                }
            }
            DB::table('vendor_onboarding_steps')->where('id', $step->id)->update(['status' => $decision, 'reviewed_by_user_id' => $request->user()->getKey(), 'reviewed_at' => now(), 'last_reason' => $reason, 'lock_version' => (int) $step->lock_version + 1, 'updated_at' => now()]);
            if ($requirementKey === 'tax_profile') {
                DB::table('vendor_tax_profiles')->where('vendor_organization_id', $organizationId)->update(['status' => $decision === 'APPROVED' ? 'APPROVED' : $decision, 'updated_at' => now()]);
                if ($decision === 'APPROVED') {
                    $taxVersionId = DB::table('vendor_tax_profiles')->where('vendor_organization_id', $organizationId)->value('current_version_id');
                    if (is_string($taxVersionId)) {
                        DB::table('vendor_tax_profile_versions')->where('id', $taxVersionId)->update(['approved_by_user_id' => $request->user()->getKey(), 'approved_at' => now(), 'updated_at' => now()]);
                    }
                }
            }
            $verificationStatus = $this->recomputeVerificationStatus($organizationId);
            DB::table('vendor_organizations')->where('id', $organizationId)->update(['store_verification_status' => $verificationStatus, 'updated_at' => now()]);
            $this->claimIdempotency($request, 'ADMIN_VENDOR_DECISION', $key, $organizationId.'|'.$requirementKey, 200);
            $this->notifyOwner($request, $organizationId, $decision, $reason);
            $this->audit->account($request, 'VENDOR_VERIFICATION_DECISION_RECORDED', 'VENDOR_ONBOARDING_STEP', (string) $step->id, after: ['requirement_key' => $requirementKey, 'decision' => $decision], reason: $reason);
        });

        return $this->detail($request, $organizationId);
    }

    /**
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    private function decideGroup(Request $request, string $organizationId, string $groupKey, array $input, string $decision): array
    {
        $idempotencyKey = $this->requireIdempotencyKey($request);
        DB::transaction(function () use ($request, $organizationId, $groupKey, $input, $decision, $idempotencyKey): void {
            DB::table('vendor_organizations')->where('id', $organizationId)->lockForUpdate()->firstOrFail();
            if ($this->idempotent($request, 'ADMIN_VENDOR_DECISION', $organizationId.'|'.$groupKey)) {
                return;
            }
            $steps = DB::table('vendor_onboarding_steps')->where('vendor_organization_id', $organizationId)
                ->where('section', 'STORE_VERIFICATION')->where('is_current', true)
                ->whereIn('requirement_key', self::REVIEW_GROUPS[$groupKey])->orderBy('requirement_key')->lockForUpdate()->get()
                ->filter(fn (object $step): bool => $step->status !== 'NOT_APPLICABLE' && $step->level !== 'OPTIONAL');
            if ($steps->isEmpty()) {
                throw new AuthenticationException('REQUIREMENT_NOT_FOUND', 'The verification requirement is unavailable.', 404);
            }
            $versions = $input['requirement_versions'] ?? null;
            foreach ($steps as $step) {
                if (! is_array($versions) || ! isset($versions[$step->requirement_key]) || (int) $versions[$step->requirement_key] !== (int) $step->lock_version) {
                    throw new AuthenticationException('RESOURCE_VERSION_CONFLICT', 'This requirement changed. Reload the review.', 409);
                }
                if (! in_array($step->status, ['SUBMITTED', 'PENDING_VERIFICATION', 'APPROVED', 'CHANGES_REQUIRED', 'REJECTED', 'EXPIRED'], true)) {
                    throw new AuthenticationException('REQUIREMENT_NOT_SUBMITTED', 'The Vendor must submit this requirement before Admin review.', 422);
                }
            }
            $reason = isset($input['reason']) ? trim((string) $input['reason']) : null;
            if ($decision !== 'APPROVED' && ($reason === null || strlen($reason) < 3)) {
                throw new AuthenticationException('DECISION_REASON_REQUIRED', 'A reason is required for correction or rejection.', 422);
            }
            if ($groupKey === 'business_information_group' && $decision === 'APPROVED' && $steps->contains('requirement_key', 'tax_profile')) {
                $tax = DB::table('vendor_tax_profiles as p')->join('vendor_tax_profile_versions as v', 'v.id', '=', 'p.current_version_id')->where('p.vendor_organization_id', $organizationId)->first(['v.owner_attested_at', 'v.vat_category', 'v.vat_verified_category']);
                if ($tax === null || $tax->owner_attested_at === null || $tax->vat_verified_category === null || $tax->vat_verified_category !== $tax->vat_category) {
                    throw new AuthenticationException('TAX_REVIEW_INCOMPLETE', 'Owner attestation and a matching VAT classification verified against BIR evidence are required.', 422);
                }
            }
            $documentGroup = $groupKey !== 'business_information_group';
            $expirationKind = strtoupper((string) ($input['expiration_kind'] ?? 'UNVERIFIED'));
            $issueDate = $input['verified_issue_date'] ?? null;
            $expirationDate = $input['verified_expiration_date'] ?? null;
            if ($documentGroup && (! in_array($expirationKind, ['DATE', 'NO_EXPIRATION', 'UNVERIFIED'], true)
                || ($expirationKind === 'DATE' && (! is_string($expirationDate) || trim($expirationDate) === ''))
                || ($expirationKind !== 'DATE' && $expirationDate !== null && $expirationDate !== '')
                || (is_string($issueDate) && is_string($expirationDate) && $expirationDate < $issueDate)
                || ($decision === 'APPROVED' && ($expirationKind === 'UNVERIFIED' || ($expirationKind === 'DATE' && (! is_string($issueDate) || $expirationDate < now()->toDateString())))))) {
                throw new AuthenticationException('EXPIRATION_METADATA_INVALID', 'Record valid issue and expiration details before approving this evidence.', 422);
            }
            foreach ($steps as $step) {
                if ($documentGroup) {
                    $document = DB::table('vendor_documents')->where('vendor_organization_id', $organizationId)->where('requirement_key', $step->requirement_key)->lockForUpdate()->first();
                    if ($decision === 'APPROVED' && ($document === null || $document->superseded_at !== null || $document->current_version_id === null)) {
                        throw new AuthenticationException('EVIDENCE_NOT_CLEAN', 'Only current validated clean evidence can be approved.', 422);
                    }
                    if ($document !== null && $document->current_version_id !== null) {
                        $version = DB::table('vendor_document_versions')->where('id', $document->current_version_id)->first();
                        if ($decision === 'APPROVED' && ($version === null || $version->scan_state !== 'CLEAN' || $version->content_validation_state !== 'VALID' || DB::table('files')->where('id', $version->file_id)->value('scan_state') !== 'CLEAN')) {
                            throw new AuthenticationException('EVIDENCE_NOT_CLEAN', 'Only validated clean evidence can be approved.', 422);
                        }
                        if ($version !== null) {
                            DB::table('business_document_reviews')->insert(['id' => (string) Str::uuid7(), 'business_document_version_id' => $version->id, 'reviewer_user_id' => $request->user()->getKey(), 'decision' => $decision, 'reason' => $reason, 'verified_document_number' => $input['verified_document_number'] ?? null, 'verified_issue_date' => $issueDate, 'expiration_kind' => $expirationKind, 'verified_expiration_date' => $expirationDate, 'evidence_source' => $input['evidence_source'] ?? null, 'remarks' => $input['remarks'] ?? null, 'reviewed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
                            DB::table('vendor_documents')->where('id', $document->id)->update(['status' => $decision, 'lock_version' => (int) $document->lock_version + 1, 'updated_at' => now()]);
                        }
                    }
                }
                DB::table('vendor_onboarding_steps')->where('id', $step->id)->update(['status' => $decision, 'reviewed_by_user_id' => $request->user()->getKey(), 'reviewed_at' => now(), 'last_reason' => $reason, 'lock_version' => (int) $step->lock_version + 1, 'updated_at' => now()]);
            }
            if ($groupKey === 'business_information_group' && $steps->contains('requirement_key', 'tax_profile')) {
                DB::table('vendor_tax_profiles')->where('vendor_organization_id', $organizationId)->update(['status' => $decision, 'updated_at' => now()]);
                if ($decision === 'APPROVED') {
                    $taxVersionId = DB::table('vendor_tax_profiles')->where('vendor_organization_id', $organizationId)->value('current_version_id');
                    if (is_string($taxVersionId)) {
                        DB::table('vendor_tax_profile_versions')->where('id', $taxVersionId)->update(['approved_by_user_id' => $request->user()->getKey(), 'approved_at' => now(), 'updated_at' => now()]);
                    }
                }
            }
            DB::table('vendor_organizations')->where('id', $organizationId)->update(['store_verification_status' => $this->recomputeVerificationStatus($organizationId), 'updated_at' => now()]);
            $this->claimIdempotency($request, 'ADMIN_VENDOR_DECISION', $idempotencyKey, $organizationId.'|'.$groupKey, 200);
            $this->notifyOwner($request, $organizationId, $decision, $reason);
            $this->audit->account($request, 'VENDOR_VERIFICATION_DECISION_RECORDED', 'VENDOR_ORGANIZATION', $organizationId, after: ['requirement_key' => $groupKey, 'underlying_keys' => $steps->pluck('requirement_key')->all(), 'decision' => $decision], reason: $reason);
        });

        return $this->detail($request, $organizationId);
    }

    /** @return array{url: string, expires_at: string} */
    public function download(Request $request, string $fileId): array
    {
        return $this->onboarding->signedFile($request, $fileId);
    }

    private function recomputeVerificationStatus(string $organizationId): string
    {
        $steps = DB::table('vendor_onboarding_steps')->where('vendor_organization_id', $organizationId)->where('section', 'STORE_VERIFICATION')->where('requirement_key', '!=', 'commission_terms')->where('is_current', true)->where('level', '!=', 'OPTIONAL')->get();
        if ($steps->contains('status', 'REJECTED')) {
            return 'REJECTED';
        }
        if ($steps->contains('status', 'CHANGES_REQUIRED')) {
            return 'CHANGES_REQUIRED';
        }
        if ($steps->every(fn (object $step): bool => in_array($step->status, ['APPROVED', 'NOT_APPLICABLE'], true))) {
            return 'APPROVED';
        }

        return 'PENDING_VERIFICATION';
    }

    private function authorize(Request $request, string $permission): void
    {
        $scope = $request->attributes->get('account_scope');
        if (! is_array($scope) || ! in_array($permission, $scope['permissions'] ?? [], true)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'This Admin action is not available to your role.', 403);
        }
    }

    private function requireIdempotencyKey(Request $request): string
    {
        $key = $request->header('Idempotency-Key');
        if (! is_string($key) || ! Str::isUuid($key)) {
            throw new AuthenticationException('IDEMPOTENCY_KEY_REQUIRED', 'A unique request identifier is required.', 422);
        }

        return $key;
    }

    private function idempotent(Request $request, string $endpoint, string $scope): bool
    {
        $record = DB::table('idempotency_records')->where('actor_user_id', $request->user()->getKey())->where('endpoint', $endpoint)->where('idempotency_key', $request->header('Idempotency-Key'))->first();
        if ($record === null) {
            return false;
        }
        $hash = hash_hmac('sha256', $endpoint.'|'.$scope.'|'.$request->getContent(), (string) config('app.key'));
        if (! hash_equals((string) $record->request_hash, $hash) || ($record->expires_at !== null && now()->greaterThanOrEqualTo($record->expires_at))) {
            throw new AuthenticationException('IDEMPOTENCY_CONFLICT', 'Use a new request identifier for this changed or expired decision.', 409);
        }

        return true;
    }

    private function claimIdempotency(Request $request, string $endpoint, string $key, string $scope, int $status): void
    {
        DB::table('idempotency_records')->insert(['id' => (string) Str::uuid7(), 'actor_user_id' => $request->user()->getKey(), 'endpoint' => $endpoint, 'idempotency_key' => $key, 'request_hash' => hash_hmac('sha256', $endpoint.'|'.$scope.'|'.$request->getContent(), (string) config('app.key')), 'response_status' => $status, 'expires_at' => now()->addDay(), 'created_at' => now(), 'updated_at' => now()]);
    }

    private function notifyOwner(Request $request, string $organizationId, string $decision, ?string $reason): void
    {
        $owner = DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->where('m.vendor_organization_id', $organizationId)->where('m.role', 'OWNER')->where('m.status', 'ACTIVE')->first(['u.id', 'u.email']);
        if ($owner === null) {
            return;
        }
        $title = 'Store Verification decision recorded';
        $body = $decision === 'APPROVED' ? 'An Admin approved a Store Verification requirement.' : 'An Admin requested a Store Verification correction. Review the requirement and reason in your onboarding dashboard.'.($reason ? ' Reason: '.$reason : '');
        DB::table('notifications')->insert(['id' => (string) Str::uuid7(), 'user_id' => $owner->id, 'category' => 'VENDOR_VERIFICATION', 'title' => $title, 'body' => $body, 'resource_type' => 'VENDOR_ORGANIZATION', 'resource_id' => $organizationId, 'created_at' => now(), 'updated_at' => now()]);
        $this->outbox->publish('VENDOR_ONBOARDING_NOTICE', 'VENDOR_ORGANIZATION', $organizationId, ['recipient' => $owner->email, 'message' => $body]);
    }

    /** @return array<string, mixed> */
    private function step(object $step, ?string $businessType = null): array
    {
        $label = VendorOnboardingService::DOCUMENTS[$step->requirement_key] ?? $step->requirement_key;
        if ($step->requirement_key === 'business_registration') {
            $label = match ($businessType) {
                'SOLE_PROPRIETORSHIP' => 'DTI business name registration',
                'PARTNERSHIP', 'CORPORATION', 'ONE_PERSON_CORPORATION' => 'SEC registration',
                'COOPERATIVE' => 'CDA registration',
                default => 'Business registration evidence',
            };
        }

        return ['id' => $step->id, 'key' => $step->requirement_key, 'label' => $label, 'level' => $step->level, 'status' => $step->status, 'reason' => $step->last_reason, 'lock_version' => (int) $step->lock_version, 'submitted_at' => $step->submitted_at, 'reviewed_at' => $step->reviewed_at];
    }

    /** @return list<string> */
    private function jsonArray(mixed $value): array
    {
        if (is_array($value)) {
            return array_values(array_filter($value, 'is_string'));
        }
        $decoded = is_string($value) ? json_decode($value, true) : null;

        return is_array($decoded) ? array_values(array_filter($decoded, 'is_string')) : [];
    }
}
