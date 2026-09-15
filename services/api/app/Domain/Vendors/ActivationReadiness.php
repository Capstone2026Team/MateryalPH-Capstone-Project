<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class ActivationReadiness
{
    public const RULE_VERSION = 'PHASE_3_REVISED_ONBOARDING_V2';

    public function __construct(
        private readonly DocumentRequirements $documents,
        private readonly AuditRecorder $audit,
        private readonly ListingPrerequisite $listings,
    ) {}

    /** @return array<string, mixed> */
    public function evaluate(string $organization): array
    {
        $org = DB::table('vendor_organizations')->where('id', $organization)->firstOrFail();
        $owner = DB::table('vendor_memberships as m')
            ->join('users as u', 'u.id', '=', 'm.user_id')
            ->where('m.vendor_organization_id', $organization)
            ->where('m.role', 'OWNER')
            ->where('m.status', 'ACTIVE')
            ->first(['u.id', 'u.email_verified_at', 'u.account_status']);
        $profile = DB::table('store_profiles')->where('vendor_organization_id', $organization)->first();
        $draft = json_decode($org->business_draft ?? '{}', true, flags: JSON_THROW_ON_ERROR);
        $submitted = $org->submitted_at !== null;
        $businessStatus = $this->businessStatus($org, $draft);
        $steps = [];

        $add = function (
            string $section,
            string $id,
            string $label,
            string $level,
            string $status,
            string $action,
            ?string $reason = null,
            ?string $versionId = null,
        ) use (&$steps): void {
            $steps[] = [
                'id' => $id,
                'section' => $section,
                'label' => $label,
                'requirement_level' => $level,
                'status' => $status,
                'blocking' => $level !== 'OPTIONAL' && $status !== 'NOT_APPLICABLE',
                'reason' => $reason,
                'next_action' => $action,
                'version_id' => $versionId,
                'updated_at' => now()->toIso8601String(),
                'recent_authentication_required' => in_array($action, ['business', 'tax', 'payment', 'commission'], true),
            ];
        };

        $registrationAgreementsAccepted = $this->registrationAgreementsAccepted($organization, $owner?->id);
        $privacyAccepted = $this->agreementAccepted($organization, $owner?->id, 'PRIVACY_NOTICE');
        $add('STORE_VERIFICATION', 'ACCOUNT_ACTIVE', 'Vendor Owner account active', 'REQUIRED', $owner?->account_status === 'ACTIVE' && $org->account_status === 'ACTIVE' ? 'COMPLETED' : 'NOT_STARTED', 'security');
        $add('STORE_VERIFICATION', 'EMAIL_VERIFIED', 'Owner email verified', 'REQUIRED', $owner?->email_verified_at !== null ? 'COMPLETED' : 'NOT_STARTED', 'security');
        $add('STORE_VERIFICATION', 'REGISTRATION_AGREEMENTS', 'Required registration agreements accepted', 'REQUIRED', $registrationAgreementsAccepted ? 'COMPLETED' : 'NOT_STARTED', 'agreements');

        foreach ([
            'BUSINESS_TYPE' => 'Business Type',
            'LEGAL_IDENTITY' => 'Legal identity and registered name',
            'BUSINESS_INFORMATION' => 'Business information and Store contact',
            'BUSINESS_CONTACTS' => 'Primary and additional business contacts',
            'REGISTERED_ADDRESS' => 'Registered business address and map pin',
            'SUPPLIER_CLASSIFICATION' => 'Supplier type and supplier niches',
        ] as $id => $label) {
            $add('STORE_VERIFICATION', $id, $label, 'REQUIRED', $businessStatus, 'business');
        }

        $governmentIdApplies = ($org->business_type ?? $draft['business_type'] ?? null) === 'SOLE_PROPRIETORSHIP';
        $governmentId = $governmentIdApplies ? $this->documents->effective($organization, 'GOVERNMENT_ID') : null;
        $add(
            'STORE_VERIFICATION',
            'GOVERNMENT_ID',
            'Government-issued identity evidence',
            'CONDITIONALLY_REQUIRED',
            $governmentIdApplies ? $this->submittedDocumentStatus($governmentId['status'], $submitted) : 'NOT_APPLICABLE',
            'documents',
            $governmentIdApplies ? $governmentId['reason'] : 'Individual proprietor identity evidence does not apply to the selected organization type.',
            $governmentId['version_id'] ?? null,
        );

        foreach ($this->documents->required($org) as $type) {
            if ($type === 'GOVERNMENT_ID') {
                continue;
            }
            $evidence = $this->documents->effective($organization, $type);
            $add('STORE_VERIFICATION', $type, $this->documents->label($type), 'REQUIRED', $this->submittedDocumentStatus($evidence['status'], $submitted), 'documents', $evidence['reason'], $evidence['version_id']);
        }

        $regulatoryApplies = $org->regulatory_evidence_required === true || $org->regulatory_evidence_required === 1;
        if ($regulatoryApplies) {
            $evidence = $this->documents->effective($organization, 'REGULATORY');
            $add('STORE_VERIFICATION', 'REGULATORY', 'Other regulatory evidence', 'CONDITIONALLY_REQUIRED', $this->submittedDocumentStatus($evidence['status'], $submitted), 'documents', $evidence['reason'], $evidence['version_id']);
        } else {
            $regulatoryStatus = $org->regulatory_evidence_required === null
                ? ($submitted ? 'PENDING_VERIFICATION' : 'NOT_STARTED')
                : 'NOT_APPLICABLE';
            $add('STORE_VERIFICATION', 'REGULATORY', 'Other regulatory evidence', 'CONDITIONALLY_REQUIRED', $regulatoryStatus, 'documents', $org->regulatory_evidence_required === null ? 'Admin must determine applicability during business review.' : 'Admin recorded that no additional regulatory evidence applies.');
        }

        $tax = $this->taxStatus($organization, $submitted);
        $add('STORE_VERIFICATION', 'VENDOR_TAX_PROFILE', 'Vendor Tax Profile and tax evidence', 'REQUIRED', $tax['status'], 'tax', $tax['reason'], $tax['version_id']);
        $add('STORE_VERIFICATION', 'PRIVACY_NOTICE', 'Privacy Notice acknowledgment', 'REQUIRED', $privacyAccepted ? 'COMPLETED' : 'NOT_STARTED', 'agreements');

        $hoursComplete = $profile !== null && DB::table('operating_hours')->where('store_profile_id', $profile->id)->count() === 7;
        $storeProfileComplete = $profile !== null && filled($org->store_name) && filled($profile->description) && (filled($profile->public_email) || filled($profile->public_phone)) && $hoursComplete;
        $add('STORE_SETUP', 'PUBLIC_STORE_PROFILE', 'Public Store Profile', 'REQUIRED', $storeProfileComplete ? 'COMPLETED' : ($profile === null ? 'NOT_STARTED' : 'IN_PROGRESS'), 'store');
        $add('STORE_SETUP', 'STORE_LOGO', 'Logo or profile image', 'REQUIRED', $this->storeMediaStatus($profile?->id, 'LOGO'), 'store');
        $add('STORE_SETUP', 'STORE_BANNER', 'Store banner', 'REQUIRED', $this->storeMediaStatus($profile?->id, 'BANNER'), 'store');
        $add('STORE_SETUP', 'PROMOTIONAL_MEDIA', 'Promotional images or video', 'OPTIONAL', $this->storeMediaStatus($profile?->id, 'PROMOTIONAL'), 'store');
        $add('STORE_SETUP', 'BULK_ORDER_CAPABILITY', 'Bulk Order Capability', 'REQUIRED', $org->bulk_capability_recorded ? 'COMPLETED' : 'NOT_STARTED', 'fulfillment');
        $fulfillmentComplete = $profile !== null && ($profile->pickup_enabled || $profile->delivery_enabled);
        $add('STORE_SETUP', 'FULFILLMENT_CONFIGURATION', 'Fulfillment Configuration', 'REQUIRED', $fulfillmentComplete ? 'COMPLETED' : 'NOT_STARTED', 'fulfillment');

        $deliveryApplies = $profile?->delivery_enabled === true || $profile?->delivery_enabled === 1;
        $deliveryComplete = $deliveryApplies && $this->deliveryConfigurationComplete($organization);
        $add('STORE_SETUP', 'DELIVERY_CONFIGURATION', 'Delivery Configuration', 'CONDITIONALLY_REQUIRED', $deliveryApplies ? ($deliveryComplete ? 'COMPLETED' : 'IN_PROGRESS') : 'NOT_APPLICABLE', 'fulfillment', $deliveryApplies ? ($deliveryComplete ? null : 'Complete at least one valid vehicle and rate configuration.') : 'Vendor Delivery is not enabled.');

        $payment = DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organization)->where('environment', 'TEST')->first();
        $xenditComplete = ($payment?->status === 'TEST_CONNECTED' && $payment->evidence_origin === 'PROVIDER_TEST' && filled($payment->provider_account_reference))
            || ($payment?->status === 'TEST_SIMULATED_READY' && $payment->evidence_origin === 'SIMULATED' && config('vendor_onboarding.simulated_connection'));
        $add('STORE_SETUP', 'XENDIT_ONBOARDING', 'Xendit xenPlatform TEST onboarding', 'REQUIRED', $xenditComplete ? 'COMPLETED' : ($payment === null ? 'NOT_STARTED' : 'IN_PROGRESS'), 'payment', $xenditComplete ? null : 'Every activation-seeking Vendor requires a successful TEST/DEMO onboarding state.');
        $taxReferenceStatus = match ($tax['status']) {
            'APPROVED' => 'COMPLETED',
            'NOT_STARTED' => 'NOT_STARTED',
            'CHANGES_REQUIRED', 'REJECTED', 'EXPIRED' => $tax['status'],
            default => 'IN_PROGRESS',
        };
        $add('STORE_SETUP', 'TAX_PROFILE_REFERENCE', 'Vendor Tax Profile summary and withholding reference', 'REQUIRED', $taxReferenceStatus, 'tax', $tax['status'] === 'APPROVED' ? null : 'Complete or correct the single Vendor Tax Profile in Store Verification.');

        $commission = $this->commissionAccepted($organization, $owner?->id);
        $add('STORE_SETUP', 'COMMISSION_TERMS', 'Owner accepted current 2% commission Terms', 'REQUIRED', $commission ? 'COMPLETED' : 'NOT_STARTED', 'commission');
        $paymentMethodsComplete = $profile !== null && $profile->payment_methods !== null;
        $refundComplete = $profile !== null && $profile->refund_configuration !== null;
        $add('STORE_SETUP', 'PAYMENT_METHODS', 'Online and physical payment methods', 'REQUIRED', $paymentMethodsComplete ? 'COMPLETED' : 'NOT_STARTED', 'payment');
        $add('STORE_SETUP', 'REFUND_CONFIGURATION', 'Refund capability and configuration', 'REQUIRED', $refundComplete ? 'COMPLETED' : 'NOT_STARTED', 'payment');
        $add('STORE_SETUP', 'TEAM_ACCOUNTS', 'Vendor Team Accounts', 'OPTIONAL', DB::table('vendor_memberships')->where('vendor_organization_id', $organization)->where('role', '<>', 'OWNER')->exists() ? 'COMPLETED' : 'NOT_STARTED', 'team');

        $verificationStatus = $this->sectionStatus(collect($steps)->where('section', 'STORE_VERIFICATION'), $submitted || $draft !== [], true, $submitted);
        $setupSteps = collect($steps)->where('section', 'STORE_SETUP');
        $setupStarted = $setupSteps
            ->where('id', '<>', 'TAX_PROFILE_REFERENCE')
            ->contains(fn (array $step): bool => ! in_array($step['status'], ['NOT_STARTED', 'NOT_APPLICABLE'], true));
        $setupStatus = $this->sectionStatus($setupSteps, $setupStarted, false);
        $accountReady = $owner->account_status === 'ACTIVE' && $org->account_status === 'ACTIVE' && $owner->email_verified_at !== null && $registrationAgreementsAccepted;
        $ready = $accountReady
            && $verificationStatus === 'APPROVED'
            && $setupStatus === 'COMPLETED'
            && ! $org->activation_hold
            && $org->activation_status !== 'SUSPENDED'
            && ! config('finance.live_commerce_enabled')
            && in_array(config('finance.mode'), ['TEST', 'DEMO'], true);

        return [
            'organization_id' => $organization,
            'store_name' => $org->store_name,
            'onboarding_status' => $verificationStatus,
            'store_verification_status' => $verificationStatus,
            'store_setup_status' => $setupStatus,
            'activation_status' => $org->activation_status,
            'discoverability_status' => $org->discoverability_status,
            'marketplace_status' => $org->marketplace_status,
            'lock_version' => (int) $org->lock_version,
            'environment' => 'TEST',
            'rule_version' => self::RULE_VERSION,
            'ready' => $ready,
            'evaluated_at' => now()->toIso8601String(),
            'checklist' => $steps,
        ];
    }

    /** @return array<string, mixed> */
    public function reconcile(Request $request, string $organization, bool $activate = false): array
    {
        return DB::transaction(function () use ($request, $organization, $activate): array {
            $org = DB::table('vendor_organizations')->where('id', $organization)->lockForUpdate()->firstOrFail();
            $result = $this->evaluate($organization);
            if ($activate && ! $result['ready']) {
                throw new AuthenticationException('ACTIVATION_BLOCKED', 'Complete every mandatory Store Verification and Store Setup requirement before activation.', 422);
            }

            $activation = $org->activation_status;
            if ($activate) {
                $activation = 'ACTIVE';
            } elseif ($activation === 'ACTIVE' && ! $result['ready']) {
                $activation = 'RESTRICTED';
            } elseif ($activation === 'RESTRICTED' && $result['ready']) {
                $activation = 'ACTIVE';
            }
            $discoverability = match (true) {
                $activation !== 'ACTIVE' => $activation === 'RESTRICTED' ? 'RESTRICTED' : 'NOT_DISCOVERABLE',
                $this->listings->satisfied($organization) => 'DISCOVERABLE',
                default => 'NO_ACTIVE_LISTINGS',
            };
            $legacyMarketplace = $activation === 'ACTIVE' ? 'ACTIVE' : ($activation === 'RESTRICTED' ? 'RESTRICTED' : 'NOT_ACTIVE');

            $this->syncSteps($organization, $result['checklist']);
            DB::table('vendor_organizations')->where('id', $organization)->update([
                'store_verification_status' => $result['store_verification_status'],
                'store_setup_status' => $result['store_setup_status'],
                'onboarding_status' => $result['store_verification_status'],
                'activation_status' => $activation,
                'discoverability_status' => $discoverability,
                'marketplace_status' => $legacyMarketplace,
                'lock_version' => $org->lock_version + ($activation !== $org->activation_status || $discoverability !== $org->discoverability_status ? 1 : 0),
                'updated_at' => now(),
            ]);
            DB::table('vendor_activation_history')->insert([
                'id' => (string) Str::uuid7(),
                'vendor_organization_id' => $organization,
                'actor_user_id' => $request->user()?->getKey(),
                'from_status' => $org->activation_status,
                'to_status' => $activation,
                'reason' => $result['ready'] ? 'ONBOARDING_REQUIREMENTS_SATISFIED' : 'MANDATORY_ONBOARDING_REQUIREMENTS_PENDING',
                'rule_version' => self::RULE_VERSION,
                'result' => json_encode($result, JSON_THROW_ON_ERROR),
                'correlation_id' => $request->attributes->get('correlation_id'),
                'created_at' => now(),
                'updated_at' => now(),
            ]);
            $this->audit->account($request, 'VENDOR_ACTIVATION_EVALUATED', 'VENDOR_ORGANIZATION', $organization, ['activation_status' => $org->activation_status, 'discoverability_status' => $org->discoverability_status], ['activation_status' => $activation, 'discoverability_status' => $discoverability, 'ready' => $result['ready']]);

            return $this->evaluate($organization);
        });
    }

    /** @param array<string, mixed> $draft */
    private function businessStatus(object $organization, array $draft): string
    {
        if ($draft === []) {
            return 'NOT_STARTED';
        }
        if ($organization->submitted_at === null) {
            return 'IN_PROGRESS';
        }

        return in_array($organization->business_review_status, ['APPROVED', 'CHANGES_REQUIRED', 'REJECTED', 'EXPIRED'], true)
            ? $organization->business_review_status
            : 'PENDING_VERIFICATION';
    }

    private function submittedDocumentStatus(string $status, bool $submitted): string
    {
        return ! $submitted && $status === 'PENDING_VERIFICATION' ? 'SUBMITTED' : $status;
    }

    /** @return array{status: string, reason: ?string, version_id: ?string} */
    private function taxStatus(string $organization, bool $submitted): array
    {
        $profile = DB::table('vendor_tax_profiles')->where('vendor_organization_id', $organization)->where('environment', 'TEST')->first();
        $version = $profile?->current_version_id === null ? null : DB::table('vendor_tax_profile_versions')->where('id', $profile->current_version_id)->where('environment', 'TEST')->first();
        $review = $version === null ? null : DB::table('vendor_tax_profile_reviews')->where('vendor_tax_profile_version_id', $version->id)->where('environment', 'TEST')->orderByDesc('id')->first();
        if ($version === null) {
            return ['status' => 'NOT_STARTED', 'reason' => 'Create the Vendor Tax Profile and link the required tax evidence.', 'version_id' => null];
        }
        if ($version->owner_attested_at === null) {
            return ['status' => 'IN_PROGRESS', 'reason' => 'Vendor Owner attestation is required.', 'version_id' => (string) $version->id];
        }
        $effective = Carbon::parse($version->effective_from)->lessThanOrEqualTo(now()) && ($version->effective_until === null || Carbon::parse($version->effective_until)->greaterThan(now()));
        $status = match ($review?->decision) {
            'APPROVE' => $effective ? 'APPROVED' : 'EXPIRED',
            'RETURN_FOR_CORRECTION' => 'CHANGES_REQUIRED',
            'REJECT' => 'REJECTED',
            default => $submitted ? 'PENDING_VERIFICATION' : 'SUBMITTED',
        };

        return ['status' => $status, 'reason' => $review?->reason, 'version_id' => (string) $version->id];
    }

    private function deliveryConfigurationComplete(string $organization): bool
    {
        return DB::table('vendor_vehicles as vehicle')
            ->join('vehicle_rate_versions as rate', 'rate.vendor_vehicle_id', '=', 'vehicle.id')
            ->where('vehicle.vendor_organization_id', $organization)
            ->where('vehicle.active', true)
            ->where('vehicle.number_available', '>', 0)
            ->where('vehicle.capacity_kg', '>', 0)
            ->whereNotNull('vehicle.cargo_length_m')
            ->whereNotNull('vehicle.cargo_width_m')
            ->whereNotNull('vehicle.cargo_height_m')
            ->where('rate.base_fee_centavos', '>=', 0)
            ->where('rate.per_km_centavos', '>=', 0)
            ->where('rate.maximum_distance_km', '>', 0)
            ->exists();
    }

    private function storeMediaStatus(mixed $profile, string $kind): string
    {
        if ($profile === null) {
            return 'NOT_STARTED';
        }
        $media = DB::table('store_media as m')
            ->join('files as f', 'f.id', '=', 'm.file_id')
            ->where('m.store_profile_id', $profile)
            ->where('m.kind', $kind)
            ->whereNull('m.replaced_at')
            ->where('f.environment', 'TEST')
            ->orderByDesc('m.created_at')
            ->first(['m.review_status', 'f.storage_provider', 'f.scan_state']);
        if ($media === null) {
            return 'NOT_STARTED';
        }
        if ($media->review_status === 'APPROVED') {
            return $media->storage_provider === 'CLOUDINARY' && in_array($media->scan_state, ['CLEAN', 'TEST_SIMULATED_CLEAN'], true)
                ? 'APPROVED'
                : 'PENDING_VERIFICATION';
        }

        return match ($media->review_status) {
            'RETURN_FOR_CORRECTION' => 'CHANGES_REQUIRED',
            'REJECTED' => 'REJECTED',
            default => 'PENDING_VERIFICATION',
        };
    }

    private function registrationAgreementsAccepted(string $organization, mixed $owner): bool
    {
        return collect(['TERMS_OF_SERVICE', 'VENDOR_CODE_OF_CONDUCT'])->every(fn (string $code): bool => $this->agreementAccepted($organization, $owner, $code));
    }

    private function agreementAccepted(string $organization, mixed $owner, string $code): bool
    {
        if ($owner === null) {
            return false;
        }
        $version = DB::table('agreement_versions as v')
            ->join('agreement_documents as d', 'd.id', '=', 'v.agreement_document_id')
            ->where('d.code', $code)
            ->whereNull('v.retired_at')
            ->where('v.effective_at', '<=', now())
            ->orderByDesc('v.version')
            ->value('v.id');

        return $version !== null && DB::table('agreement_acceptances')
            ->where('agreement_version_id', $version)
            ->where('user_id', $owner)
            ->where(fn ($query) => $query->whereNull('vendor_organization_id')->orWhere('vendor_organization_id', $organization))
            ->exists();
    }

    private function commissionAccepted(string $organization, mixed $owner): bool
    {
        if ($owner === null) {
            return false;
        }
        $version = DB::table('agreement_versions as v')
            ->join('agreement_documents as d', 'd.id', '=', 'v.agreement_document_id')
            ->where('d.code', 'VENDOR_COMMISSION_TEST')
            ->whereNull('v.retired_at')
            ->where('v.effective_at', '<=', now())
            ->orderByDesc('v.version')
            ->first(['v.id', 'v.version', 'v.content_hash']);
        if ($version === null) {
            return false;
        }
        $path = config('materyalph.agreements.content_path', resource_path('agreements')).'/VENDOR_COMMISSION_TEST/'.$version->version.'.md';

        return is_file($path)
            && hash_equals($version->content_hash, hash_file('sha256', $path))
            && DB::table('agreement_acceptances')->where('agreement_version_id', $version->id)->where('vendor_organization_id', $organization)->where('user_id', $owner)->where('source', 'PHASE_3_TEST')->exists();
    }

    /** @param iterable<array{requirement_level: string, status: string}> $items */
    private function sectionStatus(iterable $items, bool $started, bool $reviewed, bool $submitted = false): string
    {
        $steps = collect($items);
        $mandatory = $steps->filter(fn (array $step): bool => $step['requirement_level'] !== 'OPTIONAL' && $step['status'] !== 'NOT_APPLICABLE');
        foreach (['REJECTED', 'EXPIRED', 'CHANGES_REQUIRED'] as $blocking) {
            if ($mandatory->contains('status', $blocking)) {
                return $blocking;
            }
        }
        if ($mandatory->every(fn (array $step): bool => in_array($step['status'], ['APPROVED', 'COMPLETED'], true))) {
            return $reviewed ? 'APPROVED' : 'COMPLETED';
        }
        if ($reviewed && $submitted && $mandatory->contains(fn (array $step): bool => in_array($step['status'], ['SUBMITTED', 'PENDING_VERIFICATION'], true))) {
            return 'PENDING_VERIFICATION';
        }

        return $started ? 'IN_PROGRESS' : 'NOT_STARTED';
    }

    /** @param list<array<string, mixed>> $steps */
    private function syncSteps(string $organization, array $steps): void
    {
        foreach ($steps as $step) {
            $existing = DB::table('vendor_onboarding_steps')->where('vendor_organization_id', $organization)->where('step_code', $step['id'])->first();
            DB::table('vendor_onboarding_steps')->updateOrInsert(
                ['vendor_organization_id' => $organization, 'step_code' => $step['id']],
                [
                    'id' => $existing->id ?? (string) Str::uuid7(),
                    'section' => $step['section'],
                    'requirement_level' => $step['requirement_level'],
                    'status' => $step['status'],
                    'applicability_reason' => $step['reason'],
                    'source_version' => self::RULE_VERSION,
                    'completed_at' => in_array($step['status'], ['APPROVED', 'COMPLETED', 'NOT_APPLICABLE'], true) ? ($existing->completed_at ?? now()) : null,
                    'submitted_at' => in_array($step['status'], ['SUBMITTED', 'PENDING_VERIFICATION'], true) ? ($existing->submitted_at ?? now()) : ($existing->submitted_at ?? null),
                    'reviewed_at' => in_array($step['status'], ['APPROVED', 'CHANGES_REQUIRED', 'REJECTED', 'EXPIRED'], true) ? now() : ($existing->reviewed_at ?? null),
                    'lock_version' => ($existing->lock_version ?? 0) + 1,
                    'created_at' => $existing->created_at ?? now(),
                    'updated_at' => now(),
                ],
            );
        }
    }
}
