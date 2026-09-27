<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use Illuminate\Support\Facades\DB;

final class StoreActivationGate
{
    public const RULE_VERSION = 'phase3a.v1';

    /** @return array{ready: bool, status: string, rule_version: string, blockers: list<array{key: string, condition: int, reason: string}>} */
    public function evaluate(string $organizationId): array
    {
        return DB::transaction(function () use ($organizationId): array {
            DB::table('vendor_organizations')->where('id', $organizationId)->lockForUpdate()->first();
            app(OnboardingRequirementResolver::class)->synchronize($organizationId);

            return $this->evaluateLocked($organizationId);
        });
    }

    /** @return array{ready: bool, status: string, rule_version: string, blockers: list<array{key: string, condition: int, reason: string}>} */
    private function evaluateLocked(string $organizationId): array
    {
        $organization = DB::table('vendor_organizations')->where('id', $organizationId)->first();
        $blockers = [];
        $block = static function (int $condition, string $key, string $reason) use (&$blockers): void {
            $blockers[] = ['key' => $key, 'condition' => $condition, 'reason' => $reason];
        };
        $owner = DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->where('m.vendor_organization_id', $organizationId)->where('m.role', 'OWNER')->where('m.status', 'ACTIVE')->first(['u.id', 'u.email', 'u.account_status', 'u.email_verified_at']);
        if ($owner === null || $owner->account_status !== 'ACTIVE') {
            $block(1, 'owner_account', 'An active Vendor Owner account is required.');
        } else {
            $verifiedGoogleEmail = $owner->email_verified_at === null && DB::table('external_identities')
                ->where('user_id', $owner->id)
                ->where('provider', 'GOOGLE')
                ->whereRaw('LOWER(email_at_link) = ?', [mb_strtolower((string) $owner->email)])
                ->exists();
            if ($owner->email_verified_at === null && ! $verifiedGoogleEmail) {
                $block(1, 'owner_email_verification', 'Verify the Vendor Owner account email address.');
            }
            if (! $this->accepted($organizationId, (int) $owner->id, 'TERMS_OF_SERVICE')) {
                $block(1, 'vendor_terms', 'Accept the current Vendor Terms of Service.');
            }
            if (! $this->accepted($organizationId, (int) $owner->id, 'VENDOR_CODE_OF_CONDUCT')) {
                $block(1, 'vendor_code_of_conduct', 'Accept the current Vendor Code of Conduct.');
            }
        }
        $submitted = DB::table('vendor_onboarding_requirements')->where('vendor_organization_id', $organizationId)->where('section', 'STORE_VERIFICATION')->where('is_current', true)->whereNotNull('submitted_at')->exists();
        if (! $submitted || $organization === null || ! in_array($organization->store_verification_status, ['PENDING_VERIFICATION', 'APPROVED', 'CHANGES_REQUIRED', 'REJECTED', 'EXPIRED'], true)) {
            $block(2, 'verification_submission', 'Submit Store Verification.');
        }
        $requirements = DB::table('vendor_onboarding_requirements')->where('vendor_organization_id', $organizationId)->where('is_current', true)->get();
        $verification = $requirements->where('section', 'STORE_VERIFICATION')->where('level', '!=', 'OPTIONAL');
        $setup = $requirements->where('section', 'STORE_SETUP')->where('level', '!=', 'OPTIONAL');
        if ($verification->isEmpty() || $organization?->store_verification_status !== 'APPROVED') {
            $block(3, 'store_verification', 'Mandatory Store Verification requirements must be approved.');
        }
        foreach ($verification as $requirement) {
            if (! $this->satisfied($requirement, $requirement->requirement_key === 'commission_terms' ? 'COMPLETED' : 'APPROVED')) {
                $block(3, $requirement->requirement_key, 'Approval is required for '.$requirement->requirement_key.'.');
            }
        }
        $privacyVersion = DB::table('agreement_versions as v')->join('agreement_documents as d', 'd.id', '=', 'v.agreement_document_id')->where('d.code', 'PRIVACY_NOTICE')->whereNull('v.retired_at')->where('v.effective_at', '<=', now())->orderByDesc('v.version')->value('v.id');
        if ($owner === null || $privacyVersion === null || ! DB::table('privacy_acknowledgments')->where('vendor_organization_id', $organizationId)->where('user_id', $owner->id)->where('agreement_version_id', $privacyVersion)->exists()) {
            $block(3, 'privacy_acknowledgement', 'Acknowledge the current published Privacy Notice.');
        }
        $authority = app(VendorAuthorityService::class);
        $authorityRequired = $authority->required($organizationId);
        if ($authorityRequired) {
            foreach (['TAX_DECLARATIONS' => 5, 'COMMISSION_AGREEMENT' => 9, 'PAYMENT_CONFIGURATION' => 8] as $scope => $condition) {
                if ($owner === null || ! $authority->hasCurrentApproval($organizationId, $scope, (int) $owner->id)) {
                    $block($condition, 'authority_to_act', 'Current representative authority is required for '.$scope.'.');
                }
            }
        }
        // Check evidence itself: a stale checklist approval never bypasses quarantine or replacement.
        $documents = DB::table('vendor_documents as d')->leftJoin('vendor_document_versions as v', 'v.id', '=', 'd.current_version_id')->leftJoin('files as f', 'f.id', '=', 'v.file_id')->whereNull('d.superseded_at')->where('d.vendor_organization_id', $organizationId)->get(['d.requirement_key', 'd.status', 'v.scan_state', 'v.content_validation_state', 'f.scan_state as file_scan_state']);
        foreach ($verification as $requirement) {
            if ($requirement->status === 'NOT_APPLICABLE' || ! isset(VendorOnboardingService::DOCUMENTS[$requirement->requirement_key])) {
                continue;
            }
            // Authority can be established by reviewed registration evidence.
            if ($requirement->requirement_key === 'authority_to_act') {
                continue;
            }
            $document = $documents->firstWhere('requirement_key', $requirement->requirement_key);
            if ($document === null || $document->scan_state !== 'CLEAN' || $document->file_scan_state !== 'CLEAN' || $document->content_validation_state !== 'VALID' || $document->status !== 'APPROVED') {
                $block(3, $requirement->requirement_key.'_evidence', 'Current validated, clean and approved evidence is required.');
            }
        }
        foreach ($requirements as $requirement) {
            if ($requirement->level !== 'OPTIONAL' && in_array($requirement->status, ['PENDING_VERIFICATION', 'CHANGES_REQUIRED', 'REJECTED', 'EXPIRED'], true)) {
                $block(4, $requirement->requirement_key.'_review', 'Resolve the '.$requirement->status.' requirement.');
            }
        }
        $tax = DB::table('vendor_tax_profiles as p')->leftJoin('vendor_tax_profile_versions as v', 'v.id', '=', 'p.current_version_id')->where('p.vendor_organization_id', $organizationId)->first(['p.status', 'p.environment', 'v.owner_attested_at', 'v.vat_category', 'v.vat_verified_category', 'v.representative_version_id']);
        if ($tax === null || $tax->status !== 'APPROVED' || ! in_array($tax->environment, ['TEST', 'DEMO'], true) || $tax->owner_attested_at === null || $tax->vat_verified_category === null || $tax->vat_category !== $tax->vat_verified_category) {
            $block(5, 'tax_profile', 'An attested and reviewed TEST/DEMO Tax Profile with verified VAT classification is required.');
        }
        if ($setup->isEmpty() || $organization?->store_setup_status !== 'COMPLETED') {
            $block(6, 'store_setup', 'Complete Store Setup.');
        }
        foreach ($setup as $requirement) {
            if (! $this->satisfied($requirement, 'COMPLETED')) {
                $label = VendorOnboardingService::STEP_CATALOG['STORE_SETUP'][$requirement->requirement_key]['label'] ?? str_replace('_', ' ', $requirement->requirement_key);
                $block(6, $requirement->requirement_key, 'Complete '.$label.'.');
            }
        }
        $method = DB::table('store_profiles')->where('vendor_organization_id', $organizationId)->value('fulfillment_method');
        $delivery = $setup->firstWhere('requirement_key', 'delivery_configuration');
        if (($method === 'SELF_PICKUP' && ($delivery === null || $delivery->status !== 'NOT_APPLICABLE' || ! $this->satisfied($delivery, 'COMPLETED')))
            || (in_array($method, ['VENDOR_DELIVERY', 'BOTH'], true) && ($delivery?->status !== 'COMPLETED' || ! $this->deliveryReady($organizationId)))
            || ! in_array($method, ['SELF_PICKUP', 'VENDOR_DELIVERY', 'BOTH'], true)) {
            $block(7, 'delivery_configuration', 'Complete delivery configuration, or select Self-Pickup only.');
        }
        $payment = DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organizationId)->first();
        if ($payment === null || $payment->environment !== 'TEST' || $payment->provider_associated_at === null || $payment->connection_status !== 'CONNECTED_TEST' || empty($payment->provider_account_id) || $payment->provider_status !== 'LIVE') {
            $block(8, 'payment_connection', 'A backend-provisioned Xendit TEST sub-account is required.');
        }
        if ($owner === null || ! $this->commissionAccepted($organizationId, (int) $owner->id)) {
            $block(9, 'commission_terms', 'The Owner must accept the current versioned 2% commission agreement.');
        }
        if ($organization === null || $organization->account_status !== 'ACTIVE' || $organization->activation_hold_code !== null || in_array($organization->store_activation_status, ['RESTRICTED', 'SUSPENDED'], true)) {
            $block(10, 'activation_hold', 'Resolve the account suspension or blocking payment, refund, compliance or administrative hold.');
        }

        return ['ready' => $blockers === [], 'status' => $blockers === [] ? 'READY' : 'NOT_READY', 'rule_version' => self::RULE_VERSION, 'blockers' => $blockers];
    }

    private function satisfied(object $requirement, string $success): bool
    {
        return $requirement->status === $success || ($requirement->status === 'NOT_APPLICABLE' && $requirement->level === 'CONDITIONALLY_REQUIRED' && trim((string) $requirement->applicability_reason) !== '');
    }

    public function commissionAccepted(string $organizationId, int $ownerId): bool
    {
        $authority = app(VendorAuthorityService::class);

        return $this->accepted($organizationId, $ownerId, 'VENDOR_COMMISSION_TEST', true)
            && (! $authority->required($organizationId) || $authority->hasCurrentApproval($organizationId, 'COMMISSION_AGREEMENT', $ownerId));
    }

    private function accepted(string $organizationId, int $ownerId, string $code, bool $organizationRequired = false): bool
    {
        $version = DB::table('agreement_versions as v')->join('agreement_documents as d', 'd.id', '=', 'v.agreement_document_id')->where('d.code', $code)->whereNull('v.retired_at')->where('v.effective_at', '<=', now())->orderByDesc('v.version')->value('v.id');

        $query = DB::table('agreement_acceptances')->where('user_id', $ownerId)->where('agreement_version_id', $version)->where(fn ($query) => $organizationRequired ? $query->where('vendor_organization_id', $organizationId) : $query->where('vendor_organization_id', $organizationId)->orWhereNull('vendor_organization_id'));

        return $version !== null && $query->exists();
    }

    private function deliveryReady(string $organizationId): bool
    {
        return app(DeliveryRecommendationService::class)->eligibleVehicles($organizationId) !== [];
    }
}
