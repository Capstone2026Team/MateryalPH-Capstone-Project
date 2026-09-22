<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

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
            'representative_role' => $representative === null ? 'PROPRIETOR' : 'REPRESENTATIVE',
            'representative_id_type' => $representative['id_type'] ?? null,
            'representative_version_id' => $representative['id'] ?? null,
            'supplier_type' => $classification?->supplier_type,
            'niches' => json_decode($classification->niches ?? '[]', true, flags: JSON_THROW_ON_ERROR),
            'declaration_claim' => $details['tax_relief_claimed'] ?? null,
            'fulfillment_method' => DB::table('store_profiles')->where('vendor_organization_id', $organizationId)->value('fulfillment_method'),
        ];
        foreach ($this->resolve($configuration) as $key => $definition) {
            $query = DB::table('vendor_onboarding_requirements')->where('vendor_organization_id', $organizationId)->where('requirement_key', $key)->where('is_current', true);
            $row = $query->first();
            $status = $row->status ?? 'NOT_STARTED';
            if (! $definition['applicable']) {
                $status = 'NOT_APPLICABLE';
            } elseif ($status === 'NOT_APPLICABLE' || ($row?->resolution_hash !== null && $row->resolution_hash !== $definition['resolution_hash'])) {
                $status = 'IN_PROGRESS';
            }
            $success = $definition['section'] === 'STORE_VERIFICATION' ? 'APPROVED' : 'COMPLETED';
            $blocking = $definition['level'] !== 'OPTIONAL' && $definition['applicable'] && $status !== $success;
            $values = ['level' => $definition['level'], 'status' => $status, 'applicability_reason' => $definition['applicability_reason'], 'resolution_hash' => $definition['resolution_hash'], 'blocking' => $blocking, 'blocking_reason' => $blocking ? ($row->last_reason ?? 'Complete the applicable requirement.') : null];
            if ($row === null) {
                $query->insert($values + ['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'section' => $definition['section'], 'requirement_key' => $key, 'source_version' => 'phase3a.v1', 'version' => 1, 'is_current' => true, 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);
            } elseif (collect($values)->contains(fn ($value, $field): bool => (string) $row->{$field} !== (string) $value)) {
                $query->update($values + ['lock_version' => (int) $row->lock_version + 1, 'updated_at' => now()]);
            }
        }
    }
}
