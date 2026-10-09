<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;

/**
 * Explains StoreActivationGate blockers for the Admin case without re-deciding them: each blocker is tagged with a
 * category (media, hours, authority, terms, delivery, provider capability, verification, tax, account or hold) and
 * the saved source record and revision it was evaluated against, so a reviewer can see exactly which revision must
 * change. It reads saved data only; there is no override, and an Admin cannot mark a provider connection ready.
 * Team Accounts and product listings never appear: they do not block Store Activation.
 */
final class ActivationRestrictions
{
    /**
     * @param  array{ready: bool, status: string, rule_version: string, blockers: list<array{key: string, condition: int, reason: string}>}  $readiness
     * @return array<string, mixed>
     */
    public function explain(string $organizationId, array $readiness): array
    {
        $organization = DB::table('vendor_organizations')->where('id', $organizationId)->first();
        $profile = DB::table('store_profiles')->where('vendor_organization_id', $organizationId)->first(['id', 'version', 'lock_version', 'logo_file_id', 'banner_file_id', 'fulfillment_method', 'updated_at']);
        $payment = DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organizationId)->first();
        $requirements = DB::table('vendor_onboarding_requirements')->where('vendor_organization_id', $organizationId)->where('is_current', true)->get()->keyBy('requirement_key');
        $blockers = [];
        foreach ($readiness['blockers'] as $blocker) {
            $key = (string) $blocker['key'];
            $base = preg_replace('/_(evidence|review)$/', '', $key) ?? $key;
            [$category, $source] = match (true) {
                in_array($key, ['owner_account', 'owner_email_verification'], true) => ['ACCOUNT', ['type' => 'OWNER_ACCOUNT', 'label' => 'Vendor Owner account', 'revision' => null, 'updated_at' => null]],
                in_array($key, ['vendor_terms', 'vendor_code_of_conduct', 'privacy_acknowledgement', 'commission_terms'], true) => ['TERMS', $this->agreement($key)],
                $key === 'authority_to_act' => ['AUTHORITY', $this->authority($organizationId)],
                $key === 'tax_profile' => ['TAX', $this->taxProfile($organizationId)],
                $key === 'public_store_profile' || ($key === 'store_setup' && $profile !== null && ($profile->logo_file_id === null || $profile->banner_file_id === null)) => ['MEDIA', $this->profileSource($profile)],
                $key === 'store_operation' => ['HOURS', $this->hours($profile)],
                in_array($key, ['bulk_capability', 'fulfillment_method', 'store_setup'], true) => ['SETUP', $this->profileSource($profile)],
                $key === 'delivery_configuration' => ['DELIVERY', $this->delivery($organizationId, $profile)],
                $key === 'payment_connection' => ['PROVIDER_CAPABILITY', $this->provider($payment)],
                $key === 'activation_hold' => ['HOLD', ['type' => 'STORE_HOLD', 'label' => 'Store hold '.($organization->activation_hold_code ?? 'none'), 'revision' => (int) ($organization->lock_version ?? 0),
                    'updated_at' => self::iso($organization->updated_at ?? null)]],
                str_ends_with($key, '_evidence') => ['VERIFICATION', $this->evidence($organizationId, $base)],
                default => ['VERIFICATION', $this->requirement($requirements->get($base), $base)],
            };
            $blockers[] = $blocker + ['category' => $category, 'source' => $source];
        }

        return ['ready' => $readiness['ready'], 'status' => $readiness['status'], 'rule_version' => $readiness['rule_version'], 'evaluated_at' => now()->toIso8601String(),
            'blockers' => $blockers, 'categories' => array_values(array_unique(array_column($blockers, 'category'))),
            'not_blocking' => ['Team Accounts are optional and never block activation.', 'Product listings, inventory and product compliance are evaluated later for Marketplace Discoverability.'],
            'override_available' => false];
    }

    /** @return array<string, mixed> separate workstream states for the case header and queue */
    public function workstreams(object $organization): array
    {
        $payment = DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organization->id)->first();

        return [
            'verification' => ['status' => (string) $organization->store_verification_status],
            'setup' => ['status' => (string) $organization->store_setup_status],
            'provider_readiness' => ['status' => $payment === null ? 'NOT_STARTED' : (string) $payment->connection_status, 'provider_status' => $payment?->provider_status, 'environment' => $payment->environment ?? 'TEST',
                'last_error_code' => $payment?->last_error_code, 'last_reconciled_at' => self::iso($payment?->last_reconciled_at),
                'note' => 'CONNECTED_TEST is a technical TEST association only, never live KYC or tax approval. Only the Owner connects; Admins can view status and retry an approved failed job.'],
            'activation' => ['status' => (string) $organization->store_activation_status, 'hold_code' => $organization->activation_hold_code],
            'discoverability' => ['status' => (string) $organization->marketplace_discoverability_status, 'reason' => $organization->marketplace_discoverability_reason ?? null,
                'evaluated_at' => self::iso($organization->discoverability_evaluated_at ?? null)],
        ];
    }

    /** @return array<string, mixed> */
    private function requirement(?object $requirement, string $key): array
    {
        return ['type' => 'REQUIREMENT', 'label' => str_replace('_', ' ', ucfirst($key)), 'revision' => $requirement === null ? null : (int) $requirement->version,
            'status' => $requirement?->status, 'updated_at' => self::iso($requirement?->updated_at)];
    }

    /** @return array<string, mixed> */
    private function evidence(string $organizationId, string $key): array
    {
        $document = DB::table('vendor_documents as d')->leftJoin('vendor_document_versions as v', 'v.id', '=', 'd.current_version_id')->where('d.vendor_organization_id', $organizationId)
            ->where('d.requirement_key', $key)->whereNull('d.superseded_at')->first(['d.status', 'v.version', 'v.scan_state', 'v.created_at']);

        return ['type' => 'DOCUMENT_VERSION', 'label' => str_replace('_', ' ', ucfirst($key)).' evidence', 'revision' => $document?->version === null ? null : (int) $document->version,
            'status' => $document?->status, 'scan_state' => $document?->scan_state, 'updated_at' => self::iso($document?->created_at)];
    }

    /** @return array<string, mixed> */
    private function agreement(string $key): array
    {
        $code = match ($key) {
            'vendor_terms' => 'TERMS_OF_SERVICE',
            'vendor_code_of_conduct' => 'VENDOR_CODE_OF_CONDUCT',
            'privacy_acknowledgement' => 'PRIVACY_NOTICE',
            default => 'VENDOR_COMMISSION_TEST',
        };
        $version = DB::table('agreement_versions as v')->join('agreement_documents as d', 'd.id', '=', 'v.agreement_document_id')->where('d.code', $code)->whereNull('v.retired_at')
            ->where('v.effective_at', '<=', now())->orderByDesc('v.version')->first(['v.version', 'v.effective_at']);

        return ['type' => 'AGREEMENT_VERSION', 'label' => str_replace('_', ' ', ucfirst(strtolower($code))), 'revision' => $version === null ? null : (int) $version->version, 'updated_at' => self::iso($version?->effective_at)];
    }

    /** @return array<string, mixed> */
    private function authority(string $organizationId): array
    {
        $representative = DB::table('vendor_representative_versions')->where('vendor_organization_id', $organizationId)->orderByDesc('version')->first(['id', 'version', 'created_at']);
        $review = $representative === null ? null : DB::table('vendor_authority_reviews')->where('representative_version_id', $representative->id)->orderByDesc('reviewed_at')->first(['decision', 'scope', 'reviewed_at']);

        return ['type' => 'REPRESENTATIVE_VERSION', 'label' => 'Authorized representative and authority scopes', 'revision' => $representative === null ? null : (int) $representative->version,
            'status' => $review->decision ?? 'NOT_REVIEWED', 'scopes' => $review?->scope, 'updated_at' => self::iso($review->reviewed_at ?? $representative?->created_at)];
    }

    /** @return array<string, mixed> */
    private function taxProfile(string $organizationId): array
    {
        $tax = DB::table('vendor_tax_profiles as p')->leftJoin('vendor_tax_profile_versions as v', 'v.id', '=', 'p.current_version_id')->where('p.vendor_organization_id', $organizationId)
            ->first(['p.status', 'v.version', 'v.updated_at']);

        return ['type' => 'TAX_PROFILE_VERSION', 'label' => 'Tax Profile', 'revision' => $tax?->version === null ? null : (int) $tax->version, 'status' => $tax?->status, 'updated_at' => self::iso($tax?->updated_at)];
    }

    /** @return array<string, mixed> */
    private function profileSource(?object $profile): array
    {
        return ['type' => 'STORE_PROFILE', 'label' => 'Public Store Profile (logo '.($profile?->logo_file_id === null ? 'missing' : 'saved').', banner '.($profile?->banner_file_id === null ? 'missing' : 'saved').')',
            'revision' => $profile === null ? null : (int) $profile->version, 'lock_version' => $profile === null ? null : (int) $profile->lock_version, 'updated_at' => self::iso($profile?->updated_at)];
    }

    /** @return array<string, mixed> */
    private function hours(?object $profile): array
    {
        $rows = $profile === null ? collect() : DB::table('operating_hours')->where('store_profile_id', $profile->id)->get(['day_of_week', 'updated_at']);

        return ['type' => 'OPERATING_HOURS', 'label' => 'Weekly hours: '.$rows->pluck('day_of_week')->unique()->count().' of 7 days saved', 'revision' => $profile === null ? null : (int) $profile->lock_version,
            'updated_at' => self::iso($rows->max('updated_at'))];
    }

    /** @return array<string, mixed> */
    private function delivery(string $organizationId, ?object $profile): array
    {
        $vehicles = DB::table('vendor_vehicles')->where('vendor_organization_id', $organizationId)->count();
        $latest = DB::table('vendor_vehicle_versions as v')->join('vendor_vehicles as h', 'h.id', '=', 'v.vendor_vehicle_id')->where('h.vendor_organization_id', $organizationId)->max('v.created_at');

        return ['type' => 'DELIVERY_CONFIGURATION', 'label' => 'Fulfillment '.($profile->fulfillment_method ?? 'not set').'; '.$vehicles.' vehicle record(s)', 'revision' => null, 'updated_at' => self::iso($latest)];
    }

    /** @return array<string, mixed> */
    private function provider(?object $payment): array
    {
        return ['type' => 'PROVIDER_CONNECTION', 'label' => 'Xendit TEST sub-account: '.($payment->connection_status ?? 'NOT_STARTED').($payment?->last_error_code === null ? '' : ' (error '.$payment->last_error_code.')'),
            'revision' => $payment === null ? null : (int) $payment->lock_version, 'status' => $payment?->provider_status, 'updated_at' => self::iso($payment->last_reconciled_at ?? $payment?->updated_at)];
    }

    private static function iso(mixed $value): ?string
    {
        return $value === null ? null : CarbonImmutable::parse((string) $value)->toIso8601String();
    }
}
