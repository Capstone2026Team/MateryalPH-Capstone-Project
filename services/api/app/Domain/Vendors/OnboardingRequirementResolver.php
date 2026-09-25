<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class OnboardingRequirementResolver
{
    /** @param array<string, mixed> $configuration
     * @return array<string, array<string, mixed>>
     */
    public function resolve(array $configuration): array
    {
        $businessType = $configuration['business_type'] ?? null;
        $individual = in_array($businessType, ['SOLE_PROPRIETORSHIP', 'ONE_PERSON_CORPORATION'], true);
        $representative = in_array($businessType, ['PARTNERSHIP', 'CORPORATION', 'ONE_PERSON_CORPORATION', 'COOPERATIVE'], true)
            || ($configuration['representative_role'] ?? 'PROPRIETOR') !== 'PROPRIETOR';
        $catalog = VendorOnboardingService::STEP_CATALOG;
        foreach (VendorOnboardingService::IDENTITY_STEP_CATALOG as $key => $definition) {
            $catalog['STORE_VERIFICATION'][$key] = $definition;
        }
        foreach (['authority_to_act', 'representative_identity', 'representative_identity_back', 'identity_back_evidence'] as $key) {
            $catalog['STORE_VERIFICATION'][$key] = ['label' => VendorOnboardingService::DOCUMENTS[$key], 'level' => 'CONDITIONALLY_REQUIRED'];
        }
        $catalog['STORE_VERIFICATION']['optional_certification'] = ['label' => 'Optional certification', 'level' => 'OPTIONAL'];
        $result = [];
        $niches = $configuration['niches'] ?? [];
        sort($niches);
        foreach ($catalog as $section => $definitions) {
            foreach ($definitions as $key => $definition) {
                if ($key === 'authority_to_act' && $representative) {
                    $definition['level'] = ($configuration['authority_from_registration'] ?? false) ? 'CONDITIONALLY_REQUIRED' : 'REQUIRED';
                }
                $applies = match ($key) {
                    'legal_identity', 'identity_evidence' => $individual || $businessType === null,
                    'authority_to_act', 'representative_identity' => $representative || $businessType === null,
                    'identity_back_evidence' => $individual && ! in_array($configuration['identity_id_type'] ?? null, [null, '', 'PASSPORT'], true),
                    'representative_identity_back' => $representative && ($configuration['representative_id_type'] ?? 'PASSPORT') !== 'PASSPORT',
                    'tax_relief_evidence' => ($configuration['declaration_claim'] ?? null) !== false,
                    'delivery_configuration' => ($configuration['fulfillment_method'] ?? null) !== 'SELF_PICKUP',
                    default => true,
                };
                $dependencies = match ($key) {
                    'supplier_classification' => [$configuration['supplier_type'] ?? null, $niches],
                    'delivery_configuration', 'fulfillment_method' => [$configuration['fulfillment_method'] ?? null],
                    'tax_relief_evidence' => [$configuration['declaration_claim'] ?? null],
                    'authority_to_act', 'representative_identity', 'representative_identity_back' => [$businessType, $configuration['representative_version_id'] ?? null, $configuration['representative_role'] ?? null],
                    'business_type', 'business_registration', 'legal_identity', 'identity_evidence', 'identity_back_evidence', 'tax_profile', 'bir_cor' => [$businessType],
                    default => [],
                };
                $reason = $applies ? null : match ($key) {
                    'delivery_configuration' => 'Self-Pickup only; Vendor Delivery is not enabled.',
                    'tax_relief_evidence' => 'No relief declaration is claimed; standard withholding applies.',
                    default => 'Not applicable to the selected Business Type, representative role or ID type.',
                };
                $result[$key] = $definition + ['section' => $section, 'applicable' => $applies, 'applicability_reason' => $reason, 'resolution_hash' => hash('sha256', json_encode([$applies, $dependencies], JSON_THROW_ON_ERROR)), 'document_type' => $key === 'business_registration' ? match ($businessType) {
                    'SOLE_PROPRIETORSHIP' => 'DTI_BUSINESS_NAME_REGISTRATION', 'COOPERATIVE' => 'CDA_REGISTRATION', default => 'SEC_REGISTRATION'
                } : null];
            }
        }

        return $result;
    }

    public function synchronize(string $organizationId): void
    {
        DB::transaction(function () use ($organizationId): void {
            DB::table('vendor_organizations')->where('id', $organizationId)->lockForUpdate()->first();
            $this->synchronizeLocked($organizationId);
        });
    }

    private function synchronizeLocked(string $organizationId): void
    {
        $organization = DB::table('vendor_organizations')->where('id', $organizationId)->first();
        if ($organization === null) {
            return;
        }
        $representative = app(VendorAuthorityService::class)->snapshot($organizationId);
        $classification = DB::table('vendor_classifications')->where('vendor_organization_id', $organizationId)->first();
        $tax = DB::table('vendor_tax_profiles as p')->join('vendor_tax_profile_versions as v', 'v.id', '=', 'p.current_version_id')->where('p.vendor_organization_id', $organizationId)->first(['v.tax_details']);
        $details = json_decode($tax->tax_details ?? '{}', true, flags: JSON_THROW_ON_ERROR);
        $configuration = (array) $organization + [
            'representative_role' => $representative['relationship'] ?? ($representative === null ? 'PROPRIETOR' : 'REPRESENTATIVE'),
            'authority_from_registration' => $representative !== null && app(VendorAuthorityService::class)->registrationCanEstablishAuthority($organizationId, $representative),
            'representative_id_type' => $representative['id_type'] ?? null,
            'representative_version_id' => $representative['id'] ?? null,
            'supplier_type' => $classification?->supplier_type,
            'niches' => json_decode($classification->niches ?? '[]', true, flags: JSON_THROW_ON_ERROR),
            'declaration_claim' => $details['tax_relief_claimed'] ?? null,
            'fulfillment_method' => DB::table('store_profiles')->where('vendor_organization_id', $organizationId)->value('fulfillment_method'),
        ];
        DB::table('vendor_onboarding_requirements')->where('vendor_organization_id', $organizationId)
            ->where('section', 'STORE_SETUP')->whereIn('requirement_key', ['store_media', 'team'])
            ->where('is_current', true)->update(['is_current' => false, 'updated_at' => now()]);
        foreach ($this->resolve($configuration) as $key => $definition) {
            $query = DB::table('vendor_onboarding_requirements')->where('vendor_organization_id', $organizationId)->where('requirement_key', $key)->where('is_current', true);
            $row = $query->first();
            $status = $row->status ?? 'NOT_STARTED';
            if (! $definition['applicable']) {
                $status = 'NOT_APPLICABLE';
            } elseif ($status === 'NOT_APPLICABLE' || ($row?->resolution_hash !== null && $row->resolution_hash !== $definition['resolution_hash'])) {
                $status = 'IN_PROGRESS';
            }
            if ($key === 'commission_terms') {
                $ownerId = DB::table('vendor_memberships')->where('vendor_organization_id', $organizationId)->where('role', 'OWNER')->where('status', 'ACTIVE')->value('user_id');
                $status = $ownerId !== null && app(StoreActivationGate::class)->commissionAccepted($organizationId, (int) $ownerId) ? 'COMPLETED' : 'NOT_STARTED';
            }
            $success = $definition['section'] === 'STORE_VERIFICATION' && $key !== 'commission_terms' ? 'APPROVED' : 'COMPLETED';
            $blocking = $definition['level'] !== 'OPTIONAL' && $definition['applicable'] && $status !== $success;
            $values = ['level' => $definition['level'], 'status' => $status, 'applicability_reason' => $definition['applicability_reason'], 'resolution_hash' => $definition['resolution_hash'], 'blocking' => $blocking, 'blocking_reason' => $blocking ? ($row->last_reason ?? 'Complete the applicable requirement.') : null];
            if ($row === null) {
                $query->insert($values + ['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'section' => $definition['section'], 'requirement_key' => $key, 'source_version' => 'phase3a.v1', 'version' => 1, 'is_current' => true, 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);
            } elseif (collect($values)->contains(fn ($value, $field): bool => (string) $row->{$field} !== (string) $value)) {
                $query->update($values + ['lock_version' => (int) $row->lock_version + 1, 'updated_at' => now()]);
            }
        }
        $this->synchronizeSetup($organizationId);
    }

    private function synchronizeSetup(string $organizationId): void
    {
        $profile = DB::table('store_profiles')->where('vendor_organization_id', $organizationId)->first();
        $mediaReady = static function (?string $fileId, string $kind) use ($organizationId): bool {
            return $fileId !== null && DB::table('store_media as m')
                ->join('store_profiles as p', 'p.id', '=', 'm.store_profile_id')
                ->join('files as f', 'f.id', '=', 'm.file_id')
                ->where('p.vendor_organization_id', $organizationId)->where('m.file_id', $fileId)->where('m.kind', $kind)
                ->where('m.status', 'READY')->where('f.scan_state', 'CLEAN')->exists();
        };
        $name = trim((string) ($profile->public_store_name ?? ''));
        $description = trim((string) ($profile->description ?? ''));
        $logo = $mediaReady($profile?->logo_file_id, 'LOGO');
        $banner = $mediaReady($profile?->banner_file_id, 'BANNER');
        $method = (string) ($profile->fulfillment_method ?? '');
        $delivery = DB::table('delivery_service_areas')->where('vendor_organization_id', $organizationId)->where('active', true)->first();
        $encryptedDraft = DB::table('vendor_onboarding_drafts')->where('vendor_organization_id', $organizationId)->where('workstream', 'STORE_SETUP')->value('payload_encrypted');
        $draft = is_string($encryptedDraft) ? json_decode(Crypt::decryptString($encryptedDraft), true, flags: JSON_THROW_ON_ERROR) : [];
        $formState = json_decode($draft['form_state'] ?? '{}', true, flags: JSON_THROW_ON_ERROR);
        $pendingVehicles = is_array($formState) && ($formState['vehicles'] ?? []) !== [];
        $deliveryReady = in_array($method, ['VENDOR_DELIVERY', 'BOTH'], true) && $delivery !== null && (int) $delivery->maximum_distance_km >= 1
            && ! $pendingVehicles && app(DeliveryRecommendationService::class)->eligibleVehicles($organizationId) !== [];
        $payment = DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organizationId)->first();
        $paymentReady = $payment !== null && $payment->environment === 'TEST'
            && $payment->provider_associated_at !== null && $payment->connection_status === 'CONNECTED_TEST'
            && $payment->provider_status === 'LIVE' && ! empty($payment->provider_account_id);
        $schedule = $profile === null ? [] : app(StoreOperatingSchedule::class)->weekly((string) $profile->id);
        $statuses = [
            'public_store_profile' => $name !== '' && $description !== '' && $logo && $banner ? 'COMPLETED' : ($name !== '' || $description !== '' || $logo || $banner ? 'IN_PROGRESS' : 'NOT_STARTED'),
            'bulk_capability' => $profile?->bulk_capability === null ? 'NOT_STARTED' : 'COMPLETED',
            'fulfillment_method' => in_array($method, ['SELF_PICKUP', 'VENDOR_DELIVERY', 'BOTH'], true) ? 'COMPLETED' : 'NOT_STARTED',
            'delivery_configuration' => $method === 'SELF_PICKUP' ? 'NOT_APPLICABLE' : ($method === '' ? 'NOT_STARTED' : ($deliveryReady ? 'COMPLETED' : 'IN_PROGRESS')),
            'payment_connection' => $paymentReady ? 'COMPLETED' : ($payment === null ? 'NOT_STARTED' : 'IN_PROGRESS'),
            'store_operation' => app(StoreOperatingSchedule::class)->valid($schedule) ? 'COMPLETED' : ($schedule === [] ? 'NOT_STARTED' : 'IN_PROGRESS'),
        ];
        if ($profile !== null && $profile->status === 'COMPLETED' && $statuses['public_store_profile'] !== 'COMPLETED') {
            DB::table('store_profiles')->where('id', $profile->id)->update(['status' => 'DRAFT', 'updated_at' => now()]);
        }
        foreach ($statuses as $key => $status) {
            $query = DB::table('vendor_onboarding_requirements')->where('vendor_organization_id', $organizationId)->where('section', 'STORE_SETUP')->where('requirement_key', $key)->where('is_current', true);
            $row = $query->first();
            if ($row !== null && $row->status !== $status) {
                $query->update(['status' => $status, 'blocking' => ! in_array($status, ['COMPLETED', 'NOT_APPLICABLE'], true),
                    'applicability_reason' => $status === 'NOT_APPLICABLE' ? 'Vendor selected Self-Pickup only.' : null,
                    'lock_version' => (int) $row->lock_version + 1, 'updated_at' => now()]);
            }
        }
        if (DB::table('vendor_organizations')->where('id', $organizationId)->where('store_setup_status', 'COMPLETED')->exists()
            && collect($statuses)->contains(fn (string $status): bool => ! in_array($status, ['COMPLETED', 'NOT_APPLICABLE'], true))) {
            DB::table('vendor_organizations')->where('id', $organizationId)->update(['store_setup_status' => 'IN_PROGRESS', 'updated_at' => now()]);
        }
    }
}
