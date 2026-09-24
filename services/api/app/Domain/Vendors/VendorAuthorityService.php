<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class VendorAuthorityService
{
    public function required(string $organizationId): bool
    {
        return in_array(DB::table('vendor_organizations')->where('id', $organizationId)->value('business_type'), ['PARTNERSHIP', 'CORPORATION', 'ONE_PERSON_CORPORATION', 'COOPERATIVE'], true) || (($this->snapshot($organizationId)['relationship'] ?? 'PROPRIETOR') !== 'PROPRIETOR');
    }

    public function current(string $organizationId): ?object
    {
        return DB::table('vendor_representative_versions')->where('vendor_organization_id', $organizationId)->orderByDesc('version')->first();
    }

    /** @return array<string, mixed>|null */
    public function snapshot(string $organizationId): ?array
    {
        $row = $this->current($organizationId);
        if ($row === null) {
            return null;
        }
        $details = json_decode(Crypt::decryptString($row->details_encrypted), true, flags: JSON_THROW_ON_ERROR);
        $details['id_number_last4'] = isset($details['id_number']) ? substr($details['id_number'], -4) : null;
        unset($details['id_number']);

        return $details + ['id' => $row->id, 'version' => (int) $row->version, 'created_at' => $row->created_at];
    }

    /** @param array<string, mixed> $details */
    public function save(Request $request, string $organizationId, array $details): void
    {
        if (($details['authority_evidence_source'] ?? null) === 'EXISTING_REGISTRATION_EVIDENCE' && ! $this->registrationCanEstablishAuthority($organizationId, $details)) {
            throw new AuthenticationException('AUTHORITY_EVIDENCE_REQUIRED', 'Select accepted current registration evidence for an officer, or upload separate Authority Evidence.', 422);
        }
        $current = $this->current($organizationId);
        $previous = $current === null ? [] : json_decode(Crypt::decryptString($current->details_encrypted), true, flags: JSON_THROW_ON_ERROR);
        $personChanged = isset($details['full_name'], $previous['full_name']) && $details['full_name'] !== $previous['full_name'];
        if ($personChanged && empty($details['id_number'])) {
            $details['id_number'] = null;
        }
        if (! $personChanged && empty($details['id_number']) && isset($previous['id_number'])) {
            $details['id_number'] = $previous['id_number'];
        }
        $details = array_merge($previous, $details);
        ksort($details);
        $content = json_encode($details, JSON_THROW_ON_ERROR);
        $hash = hash_hmac('sha256', $content, (string) config('app.key'));
        if ($current !== null && hash_equals($current->content_hash, $hash)) {
            return;
        }
        $ownerId = DB::table('vendor_memberships')->where('vendor_organization_id', $organizationId)->where('role', 'OWNER')->where('status', 'ACTIVE')->value('user_id');
        DB::table('vendor_representative_versions')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'version' => (int) ($current->version ?? 0) + 1, 'details_encrypted' => Crypt::encryptString($content), 'content_hash' => $hash, 'account_user_id' => ($details['same_as_owner'] ?? false) ? $ownerId : null, 'created_by_user_id' => $request->user()->getKey(), 'created_at' => now()]);
    }

    /** @param array<string, mixed> $details */
    public function registrationCanEstablishAuthority(string $organizationId, array $details): bool
    {
        return strtoupper((string) ($details['relationship'] ?? '')) === 'OFFICER'
            && DB::table('vendor_documents as d')->join('vendor_document_versions as v', 'v.id', '=', 'd.current_version_id')
                ->whereNull('d.superseded_at')->where('d.vendor_organization_id', $organizationId)->where('d.requirement_key', 'business_registration')
                ->where('d.status', 'APPROVED')->where('v.id', $details['authority_evidence_version_id'] ?? null)
                ->where('v.scan_state', 'CLEAN')->where('v.content_validation_state', 'VALID')->exists();
    }

    public function assertAttestation(Request $request, string $organizationId, string $scope): ?string
    {
        if (! $this->required($organizationId)) {
            return null;
        }
        $representative = $this->current($organizationId);
        if (! $this->hasCurrentApproval($organizationId, $scope, (int) $request->user()->getKey())) {
            throw new AuthenticationException('AUTHORITY_REQUIRED', 'An Admin must approve the current representative and applicable authority scope before this account can attest.', 422);
        }

        return (string) $representative->id;
    }

    public function hasCurrentApproval(string $organizationId, string $scope, ?int $accountId = null): bool
    {
        if (! in_array($scope, ['TAX_DECLARATIONS', 'COMMISSION_AGREEMENT', 'PAYMENT_CONFIGURATION'], true)) {
            return false;
        }
        $representative = $this->current($organizationId);
        $step = DB::table('vendor_onboarding_steps')->where('vendor_organization_id', $organizationId)->where('requirement_key', 'authority_to_act')->where('is_current', true)->first();
        $review = $representative === null ? null : DB::table('vendor_authority_reviews')->where('representative_version_id', $representative->id)->orderByDesc('reviewed_at')->first();
        $scopes = $review === null ? [] : explode(',', (string) $review->scope);
        if ($representative === null || ($accountId !== null && (int) $representative->account_user_id !== $accountId) || $step?->status !== 'APPROVED' || $review?->decision !== 'APPROVED' || ! in_array($scope, $scopes, true)) {
            return false;
        }

        return DB::table('vendor_document_versions as v')->join('vendor_documents as d', 'd.id', '=', 'v.business_document_id')->join('files as f', 'f.id', '=', 'v.file_id')->whereNull('d.superseded_at')->where('d.vendor_organization_id', $organizationId)->where('v.id', $review->evidence_version_id)->whereColumn('d.current_version_id', 'v.id')->where('v.scan_state', 'CLEAN')->where('f.scan_state', 'CLEAN')->where('v.content_validation_state', 'VALID')->whereNotIn('d.status', ['EXPIRED', 'REJECTED', 'CHANGES_REQUIRED'])->exists();
    }

    /** @param array<string, mixed> $input */
    public function review(Request $request, string $organizationId, array $input): void
    {
        if ($request->user()?->account_type !== 'ADMIN' || ! app(AccountAccess::class)->allows($request->user(), 'vendor_verification.review')) {
            throw new AuthenticationException('PERMISSION_DENIED', 'You cannot review Vendor authority.', 403);
        }
        if (array_diff($input['authority_scopes'] ?? [], ['TAX_DECLARATIONS', 'COMMISSION_AGREEMENT', 'PAYMENT_CONFIGURATION']) !== []) {
            throw new AuthenticationException('AUTHORITY_SCOPE_INVALID', 'Select an approved authority scope.', 422);
        }
        $representative = $this->current($organizationId);
        if ($representative === null || ! $this->required($organizationId)) {
            throw new AuthenticationException('REPRESENTATIVE_REQUIRED', 'Save the applicable representative before reviewing Authority to Act.', 422);
        }
        $evidenceId = $input['authority_evidence_version_id'] ?? null;
        $scopes = $input['authority_scopes'] ?? [];
        if ($input['decision'] !== 'APPROVED') {
            $evidenceId = null;
            $scopes = [];
        }
        if ($input['decision'] === 'APPROVED') {
            $evidence = DB::table('vendor_document_versions as v')->join('vendor_documents as d', 'd.id', '=', 'v.business_document_id')->where('v.id', $evidenceId)->whereNull('d.superseded_at')->where('d.vendor_organization_id', $organizationId)->whereColumn('d.current_version_id', 'v.id')->whereIn('d.requirement_key', ['business_registration', 'authority_to_act'])->where('v.scan_state', 'CLEAN')->where('v.content_validation_state', 'VALID')->whereNotIn('d.status', ['EXPIRED', 'REJECTED', 'CHANGES_REQUIRED'])->first();
            $evidenceMetadata = $evidence === null || ! is_string($evidence->vendor_metadata) ? [] : json_decode($evidence->vendor_metadata, true);
            $businessType = DB::table('vendor_organizations')->where('id', $organizationId)->value('business_type');
            $selected = $this->snapshot($organizationId) ?? [];
            $sourceMatches = ! isset($selected['authority_evidence_source']) || ($evidence?->requirement_key === 'authority_to_act' ? $selected['authority_evidence_source'] === 'SEPARATE_AUTHORITY_DOCUMENT' : $this->registrationCanEstablishAuthority($organizationId, $selected) && ($selected['authority_evidence_version_id'] ?? null) === $evidenceId);
            $evidenceMatches = $sourceMatches && $evidence !== null && ($evidence->requirement_key === 'authority_to_act'
                ? ($evidenceMetadata['representative_version_id'] ?? null) === $representative->id
                : $evidence->status === 'APPROVED' && strtoupper((string) ($selected['relationship'] ?? '')) === 'OFFICER' && $evidence->document_type === ($businessType === 'COOPERATIVE' ? 'CDA_REGISTRATION' : 'SEC_REGISTRATION'));
            $identity = DB::table('vendor_documents as d')->join('vendor_document_versions as v', 'v.id', '=', 'd.current_version_id')->whereNull('d.superseded_at')->where('d.vendor_organization_id', $organizationId)->where('d.requirement_key', 'representative_identity')->where('v.scan_state', 'CLEAN')->where('v.content_validation_state', 'VALID')->first(['v.vendor_metadata']);
            $identityMetadata = $identity === null || ! is_string($identity->vendor_metadata) ? [] : json_decode($identity->vendor_metadata, true);
            $details = $this->snapshot($organizationId);
            $backRequired = ($details['id_type'] ?? null) !== 'PASSPORT';
            $back = DB::table('vendor_documents as d')->join('vendor_document_versions as v', 'v.id', '=', 'd.current_version_id')->whereNull('d.superseded_at')->where('d.vendor_organization_id', $organizationId)->where('d.requirement_key', 'representative_identity_back')->where('v.scan_state', 'CLEAN')->where('v.content_validation_state', 'VALID')->first(['v.vendor_metadata']);
            $backMetadata = $back === null || ! is_string($back->vendor_metadata) ? [] : json_decode($back->vendor_metadata, true);
            if (! $evidenceMatches || ($identityMetadata['representative_version_id'] ?? null) !== $representative->id || ($backRequired && ($backMetadata['representative_version_id'] ?? null) !== $representative->id) || $scopes === [] || empty($details['full_name']) || empty($details['position']) || empty($details['relationship']) || empty($details['id_number_last4'])) {
                throw new AuthenticationException('AUTHORITY_EVIDENCE_REQUIRED', 'Select current clean registration or authority evidence, review the representative identity, and specify the supported authority scopes.', 422);
            }
        }
        DB::table('vendor_authority_reviews')->insert(['id' => (string) Str::uuid7(), 'representative_version_id' => $representative->id, 'evidence_version_id' => $evidenceId, 'decision' => $input['decision'], 'scope' => implode(',', $scopes), 'reason' => $input['reason'] ?? null, 'reviewer_user_id' => $request->user()->getKey(), 'reviewed_at' => now()]);
    }
}
