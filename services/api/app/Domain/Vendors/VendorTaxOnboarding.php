<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;

final class VendorTaxOnboarding
{
    public function __construct(private readonly OnboardingAccess $access, private readonly AuditRecorder $audit, private readonly ActivationReadiness $readiness) {}

    /** @return array<string, mixed> */
    public function read(Request $request, string $organization): array
    {
        if ($request->user()->account_type === 'ADMIN') {
            $this->access->reviewer($request, true);
        } else {
            $this->access->vendor($request, $organization, 'finance.draft_corrections');
        }
        $profile = DB::table('vendor_tax_profiles')->where('vendor_organization_id', $organization)->where('environment', 'TEST')->first();
        $version = $profile === null ? null : DB::table('vendor_tax_profile_versions')->where('id', $profile->current_version_id)->first();
        $history = $profile === null ? collect() : DB::table('vendor_tax_profile_versions')->where('vendor_tax_profile_id', $profile->id)->orderByDesc('version')->limit(20)->get(['id', 'version', 'evidence_origin', 'environment', 'owner_attested_at', 'created_at']);
        foreach ($history as $item) {
            $reviews = DB::table('vendor_tax_profile_reviews')->where('vendor_tax_profile_version_id', $item->id)->orderBy('created_at')->orderBy('id')->get(['id', 'decision', 'reason', 'approval_scope', 'environment', 'created_at']);
            $item->status = $reviews->isEmpty() ? ($item->owner_attested_at === null ? 'DRAFT' : 'PENDING_VERIFICATION') : $reviews->last()->decision;
            $item->reviews = $reviews->all();
        }

        return ['review_reason' => $version === null ? null : DB::table('vendor_tax_profile_reviews')->where('vendor_tax_profile_version_id', $version->id)->orderByDesc('id')->value('reason'), 'lock_version' => (int) DB::table('vendor_organizations')->where('id', $organization)->value('lock_version'), 'evidence_versions' => DB::table('business_document_versions as v')->join('business_documents as d', 'd.id', '=', 'v.business_document_id')->where('d.vendor_organization_id', $organization)->where('d.document_type', 'BIR_COR')->where('v.environment', 'TEST')->orderByDesc('v.version')->limit(20)->get(['v.id', 'v.version'])->all(), 'profile_id' => $profile?->id, 'version_id' => $version?->id, 'version' => $version?->version, 'status' => $profile->status ?? 'INCOMPLETE', 'environment' => 'TEST', 'evidence_origin' => 'SAMPLE_DEMO', 'data' => json_decode($version->profile_data ?? '{}', true), 'owner_attested_at' => $version?->owner_attested_at, 'withholding_treatment' => 'STANDARD_UNLESS_SEPARATE_RELIEF_VALIDATED', 'history' => $history->all(), 'legal_effect' => 'TEST_DEMO_ONLY_NOT_REGULATORY_APPROVAL'];
    }

    /** @param array<string, mixed> $input
     * @return array<string, mixed>
     */
    public function save(Request $request, string $organization, array $input): array
    {
        $this->access->vendor($request, $organization, 'finance.draft_corrections', true);
        $data = Validator::make($input, [
            'lock_version' => ['required', 'integer', 'min:1'], 'attest' => ['required', 'boolean'],
            'profile' => ['required', 'array:taxpayer_key,legal_name,trade_name,tin,branch_code,entity_class,registration_category,vat_category,fiscal_year_start_month,effective_from,effective_until,bir_cor_version_id,invoice_method,invoice_coverage,prior_year_amount_centavos,prior_year_position,declaration_year,declaration_receipt,declaration_valid_from,declaration_valid_until,outside_platform_amount_centavos,outside_platform_as_of,overlap_scope,evidence_version_ids'],
            'profile.taxpayer_key' => ['required', 'string', 'regex:/^SAMPLE-[A-Za-z0-9-]{3,80}$/'],
            'profile.legal_name' => ['required', 'string', 'max:180'], 'profile.trade_name' => ['required', 'string', 'max:180'],
            'profile.tin' => ['required', 'string', 'regex:/^SAMPLE-[A-Za-z0-9-]{3,40}$/'], 'profile.branch_code' => ['nullable', 'string', 'max:20'],
            'profile.entity_class' => ['required', Rule::in(['INDIVIDUAL', 'CORPORATE'])],
            'profile.registration_category' => ['required', 'string', 'max:32'],
            'profile.vat_category' => ['required', Rule::in(['VAT_REGISTERED', 'NON_VAT'])],
            'profile.fiscal_year_start_month' => ['required', 'integer', 'between:1,12'],
            'profile.effective_from' => ['required', 'date_format:Y-m-d'], 'profile.effective_until' => ['nullable', 'date_format:Y-m-d', 'after_or_equal:profile.effective_from'],
            'profile.bir_cor_version_id' => ['required', 'uuid'], 'profile.invoice_method' => ['required', 'string', 'max:120'], 'profile.invoice_coverage' => ['required', 'string', 'max:500'],
            'profile.prior_year_amount_centavos' => ['nullable', 'integer', 'min:0', 'max:9000000000000000'], 'profile.prior_year_position' => ['nullable', 'string', 'max:250'],
            'profile.declaration_year' => ['nullable', 'integer', 'between:2000,2200'], 'profile.declaration_receipt' => ['nullable', 'string', 'max:160'],
            'profile.declaration_valid_from' => ['nullable', 'date_format:Y-m-d'], 'profile.declaration_valid_until' => ['nullable', 'date_format:Y-m-d', 'after_or_equal:profile.declaration_valid_from'],
            'profile.outside_platform_amount_centavos' => ['nullable', 'integer', 'min:0', 'max:9000000000000000'], 'profile.outside_platform_as_of' => ['nullable', 'date_format:Y-m-d'], 'profile.overlap_scope' => ['nullable', 'string', 'max:1000'],
            'profile.evidence_version_ids' => ['sometimes', 'array', 'max:20'], 'profile.evidence_version_ids.*' => ['required', 'uuid', 'distinct'],
        ])->validate();
        if ($data['attest']) {
            $this->access->vendor($request, $organization, 'finance.attest', true);
        }

        return DB::transaction(function () use ($request, $organization, $data): array {
            $org = DB::table('vendor_organizations')->where('id', $organization)->lockForUpdate()->firstOrFail();
            $this->access->version($org, $data['lock_version']);
            $profileData = $data['profile'];
            $evidenceIds = array_values(array_unique([$profileData['bir_cor_version_id'], ...($profileData['evidence_version_ids'] ?? [])]));
            $evidence = DB::table('business_document_versions as v')->join('business_documents as d', 'd.id', '=', 'v.business_document_id')->where('d.vendor_organization_id', $organization)->where('v.environment', 'TEST')->whereIn('v.id', $evidenceIds)->get(['v.id', 'v.file_id', 'v.content_hash', 'd.document_type']);
            if ($evidence->count() !== count($evidenceIds) || ! $evidence->contains(fn (object $row): bool => $row->id === $profileData['bir_cor_version_id'] && $row->document_type === 'BIR_COR')) {
                throw new AuthenticationException('EVIDENCE_INVALID', 'Use this organization’s TEST evidence.', 422);
            }
            $profile = DB::table('vendor_tax_profiles')->where('vendor_organization_id', $organization)->first();
            if ($profile !== null && $profile->environment !== 'TEST') {
                throw new AuthenticationException('ENVIRONMENT_CONFLICT', 'TEST submissions cannot replace another environment profile.', 409);
            }
            $profileId = $profile->id ?? (string) Str::uuid7();
            if ($profile === null) {
                DB::table('vendor_tax_profiles')->insert(['id' => $profileId, 'vendor_organization_id' => $organization, 'environment' => 'TEST', 'created_at' => now(), 'updated_at' => now()]);
            }
            $id = (string) Str::uuid7();
            $number = (int) DB::table('vendor_tax_profile_versions')->where('vendor_tax_profile_id', $profileId)->max('version') + 1;
            $json = json_encode($profileData, JSON_THROW_ON_ERROR);
            DB::table('vendor_tax_profile_versions')->insert(['id' => $id, 'vendor_tax_profile_id' => $profileId, 'version' => $number, 'taxpayer_key_hash' => hash_hmac('sha256', $profileData['taxpayer_key'], (string) config('app.key')), 'entity_class' => $profileData['entity_class'], 'registration_category' => $profileData['registration_category'], 'vat_category' => $profileData['vat_category'], 'fiscal_year_start_month' => $profileData['fiscal_year_start_month'], 'effective_from' => $profileData['effective_from'], 'effective_until' => $profileData['effective_until'] ?? null, 'submitted_by_user_id' => $request->user()->getKey(), 'content_hash' => hash('sha256', $json), 'profile_data' => $json, 'environment' => 'TEST', 'evidence_origin' => 'SAMPLE_DEMO', 'owner_attested_at' => $data['attest'] ? now() : null, 'created_at' => now(), 'updated_at' => now()]);
            foreach ($evidence as $row) {
                DB::table('tax_evidence')->insert(['id' => (string) Str::uuid7(), 'vendor_tax_profile_version_id' => $id, 'file_id' => $row->file_id, 'evidence_type' => $row->document_type, 'origin' => 'SAMPLE_DEMO', 'document_hash' => $row->content_hash, 'created_at' => now(), 'updated_at' => now()]);
            }
            DB::table('vendor_tax_profiles')->where('id', $profileId)->update(['current_version_id' => $id, 'status' => $data['attest'] ? 'PENDING_VERIFICATION' : 'DRAFT', 'lock_version' => ($profile->lock_version ?? 1) + 1, 'updated_at' => now()]);
            DB::table('vendor_organizations')->where('id', $organization)->increment('lock_version');
            $this->audit->account($request, $data['attest'] ? 'VENDOR_TAX_ATTESTED' : 'VENDOR_TAX_DRAFT_CREATED', 'VENDOR_TAX_PROFILE_VERSION', $id, after: ['version' => $number, 'environment' => 'TEST']);
            $this->readiness->reconcile($request, $organization);

            return $this->read($request, $organization);
        });
    }

    /** @param array<string, mixed> $input
     * @return array<string, mixed>
     */
    public function review(Request $request, string $organization, string $version, array $input): array
    {
        $this->access->reviewer($request, true);
        $data = Validator::make($input, ['lock_version' => ['required', 'integer', 'min:1'], 'decision' => ['required', Rule::in(['APPROVE', 'RETURN_FOR_CORRECTION', 'REJECT'])], 'reason' => ['required_unless:decision,APPROVE', 'nullable', 'string', 'min:3', 'max:1000']])->validate();

        return DB::transaction(function () use ($request, $organization, $version, $data): array {
            $org = DB::table('vendor_organizations')->where('id', $organization)->lockForUpdate()->firstOrFail();
            $this->access->version($org, $data['lock_version']);
            $row = DB::table('vendor_tax_profile_versions as v')->join('vendor_tax_profiles as p', 'p.id', '=', 'v.vendor_tax_profile_id')->where('p.vendor_organization_id', $organization)->where('p.current_version_id', $version)->where('v.id', $version)->where('v.environment', 'TEST')->first(['v.*', 'p.status as profile_status']);
            if ($row === null) {
                throw new AuthenticationException('RESOURCE_NOT_FOUND', 'This tax version is unavailable.', 404);
            }
            if ($row->owner_attested_at === null || (string) $row->submitted_by_user_id === (string) $request->user()->getKey()) {
                throw new AuthenticationException('TAX_REVIEW_DENIED', 'Owner attestation and an independent reviewer are required.', 403);
            }
            if ($row->profile_status !== 'PENDING_VERIFICATION' || DB::table('vendor_tax_profile_reviews')->where('vendor_tax_profile_version_id', $version)->exists()) {
                throw new AuthenticationException('TAX_REVIEW_FINAL', 'This immutable tax version already has a review decision. Submit a new correction version for another review.', 409);
            }
            if ($data['decision'] === 'APPROVE' && DB::table('tax_evidence as e')->join('files as f', 'f.id', '=', 'e.file_id')->where('e.vendor_tax_profile_version_id', $version)->whereNotIn('f.scan_state', ['CLEAN', 'TEST_SIMULATED_CLEAN'])->exists()) {
                throw new AuthenticationException('DOCUMENT_SCAN_PENDING', 'All submitted tax evidence must clear scanning before approval.', 409);
            }
            $id = (string) Str::uuid7();
            DB::table('vendor_tax_profile_reviews')->insert(['id' => $id, 'vendor_tax_profile_version_id' => $version, 'reviewer_user_id' => $request->user()->getKey(), 'decision' => $data['decision'], 'reason' => $data['reason'] ?? null, 'approval_scope' => 'TEST_REGISTRATION_AND_INVOICE_METHOD', 'environment' => 'TEST', 'created_at' => now(), 'updated_at' => now()]);
            DB::table('vendor_tax_profiles')->where('id', $row->vendor_tax_profile_id)->update(['status' => match ($data['decision']) {
                'APPROVE' => 'APPROVED', 'REJECT' => 'REJECTED', default => 'CHANGES_REQUIRED'
            }, 'updated_at' => now()]);
            DB::table('vendor_organizations')->where('id', $organization)->increment('lock_version');
            $this->audit->account($request, 'VENDOR_TAX_REVIEWED', 'VENDOR_TAX_PROFILE_VERSION', $version, after: ['review_id' => $id, 'decision' => $data['decision']]);
            app(ReviewVendorEvidence::class)->notice($organization, 'Tax registration and invoice evidence was reviewed. Open the tax profile to see its status.');

            return $this->readiness->reconcile($request, $organization);
        });
    }
}
