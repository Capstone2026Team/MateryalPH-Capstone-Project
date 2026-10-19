<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Catalog\RentalServicePolicy;
use App\Http\Requests\Vendor\VendorVerificationDraftRequest;
use Illuminate\Contracts\Encryption\DecryptException;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

/** Saved form completion is presentation data, never an Admin decision or activation input. */
final class VerificationDraftProgress
{
    /** @param array<string, list<string>> $state
     * @return array<string, string>
     */
    public function statuses(string $organizationId, array $state): array
    {
        $submitted = DB::table('vendor_documents as d')->join('vendor_document_versions as v', 'v.id', '=', 'd.current_version_id')->where('d.vendor_organization_id', $organizationId)->whereNull('d.superseded_at')->whereIn('d.status', ['SUBMITTED', 'PENDING_VERIFICATION', 'APPROVED'])->where('v.scan_state', 'CLEAN')->where('v.content_validation_state', 'VALID')->get(['d.requirement_key', 'v.id']);

        return $this->formStatuses($organizationId, $state, [
            'organization' => (array) DB::table('vendor_organizations')->where('id', $organizationId)->first(),
            'representative' => app(VendorAuthorityService::class)->snapshot($organizationId) ?? [],
            'classification' => (array) DB::table('vendor_classifications')->where('vendor_organization_id', $organizationId)->first(),
            'address' => (array) DB::table('addresses')->where('owner_type', 'VENDOR_ORGANIZATION')->where('owner_id', $organizationId)->where('is_current', true)->first(),
            'tax' => (array) DB::table('vendor_tax_profiles as p')->join('vendor_tax_profile_versions as v', 'v.id', '=', 'p.current_version_id')->where('p.vendor_organization_id', $organizationId)->first(),
            'pending' => DB::table('vendor_pending_documents as p')->join('files as f', 'f.id', '=', 'p.file_id')->where('p.vendor_organization_id', $organizationId)->where('f.scan_state', 'CLEAN')->pluck('p.requirement_key')->all(),
            'submitted' => $submitted->pluck('requirement_key')->all(),
            'registration_versions' => $submitted->where('requirement_key', 'business_registration')->pluck('id')->all(),
        ]);
    }

    /** @param array<string, list<string>> $state
     * @param  array<string, mixed>  $source
     * @return array<string, string>
     */
    public function formStatuses(string $organizationId, array $state, array $source): array
    {
        $organization = (object) ($source['organization'] ?? []);
        $representative = $source['representative'] ?? [];
        $classification = (object) ($source['classification'] ?? []);
        $address = $source['address'] ?? [];
        $tax = (object) ($source['tax'] ?? []);
        $taxDetails = json_decode($tax->tax_details ?? '{}', true, flags: JSON_THROW_ON_ERROR);
        $value = static fn (string $key, mixed $fallback = ''): mixed => array_key_exists($key, $state) ? ($state[$key][0] ?? '') : ($fallback ?? '');
        $type = $value('business_type', $organization->business_type ?? null);
        $company = in_array($type, ['PARTNERSHIP', 'CORPORATION', 'ONE_PERSON_CORPORATION', 'COOPERATIVE'], true);
        $role = $value('representative_relationship', $representative['relationship'] ?? 'PROPRIETOR');
        $relief = $value('tax_relief_claimed', array_key_exists('tax_relief_claimed', $taxDetails) ? ($taxDetails['tax_relief_claimed'] ? 'yes' : 'no') : '');
        $configuration = ['business_type' => $type ?: null, 'representative_role' => $role,
            'identity_id_type' => $value('identity_id_type', $organization->identity_id_type ?? null),
            'representative_id_type' => $value('representative_id_type', $representative['id_type'] ?? null),
            'declaration_claim' => $relief === '' ? null : $relief === 'yes'];
        $definitions = app(OnboardingRequirementResolver::class)->resolve($configuration);
        $statuses = [];
        $rules = (new VendorVerificationDraftRequest)->rules();
        // Use the same field-format rules as the mutation, adding completeness only for this view.
        $group = static function (array $fields, array $required) use ($rules): string {
            $data = [];
            $validation = [];
            foreach ($fields as $path => $fieldValue) {
                data_set($data, $path, is_string($fieldValue) ? trim($fieldValue) : $fieldValue);
                $validation[$path] = array_values(array_filter($rules[$path] ?? [], static fn ($rule): bool => ! is_string($rule) || ! in_array($rule, ['sometimes', 'nullable'], true)));
                if (in_array($path, $required, true)) {
                    array_unshift($validation[$path], 'required');
                }
            }
            if (Validator::make($data, $validation)->passes()) {
                return 'COMPLETED';
            }

            return collect($fields)->contains(static fn ($field): bool => $field !== '' && $field !== null && $field !== []) ? 'IN_PROGRESS' : 'NOT_STARTED';
        };
        $statuses['business_type'] = $group(['business_type' => $type], ['business_type']);
        $business = ['store_name' => $value('store_name', $organization->store_name ?? null), 'date_established' => $value('date_established', $organization->date_established ?? null),
            'store_email' => $value('store_email', $organization->store_email ?? null), 'store_phone' => $value('store_phone', $organization->store_phone ?? null)];
        if ($company) {
            $business['legal_business_name'] = $value('legal_business_name', $organization->legal_business_name ?? null);
        }
        $statuses['business_information'] = $group($business, array_keys($business));
        if (($organization->store_email_verified_at ?? null) === null || mb_strtolower(trim((string) $business['store_email'])) !== ($organization->store_email ?? null)) {
            $statuses['business_information'] = 'IN_PROGRESS';
        }
        $identity = ['legal_identity.surname' => $value('individual_surname', $organization->individual_registered_surname ?? null),
            'legal_identity.first_name' => $value('individual_first_name', $organization->individual_registered_first_name ?? null),
            'legal_identity.id_type' => $configuration['identity_id_type'],
            'legal_identity.id_number' => $value('identity_id_number', $organization->identity_id_number_last4 ?? null)];
        $statuses['legal_identity'] = $definitions['legal_identity']['applicable'] ? $group($identity, array_keys($identity)) : 'NOT_APPLICABLE';
        if (array_key_exists('address_payload', $state) && $value('address_payload') !== '') {
            $decoded = json_decode((string) $value('address_payload'), true);
            $address = is_array($decoded) ? $decoded : [];
        }
        $addressFields = [];
        foreach (['street', 'barangay', 'city_municipality', 'province', 'postal_code'] as $field) {
            $addressFields['address.'.$field] = $address[$field] ?? '';
        }
        $statuses['registered_business_address'] = $group($addressFields, array_keys($addressFields));
        if (! in_array($address['source'] ?? 'MANUAL', ['MANUAL', 'MAP'], true) || (array_key_exists('address_payload', $state) && $value('address_payload') !== '' && (array_key_exists('latitude', $address) || array_key_exists('longitude', $address)))) {
            $statuses['registered_business_address'] = 'IN_PROGRESS';
        }
        // Validate saved map tokens locally; never invoke a geographic provider while reading progress.
        if (($address['source'] ?? 'MANUAL') !== 'MANUAL' && array_key_exists('address_payload', $state) && $value('address_payload') !== '') {
            try {
                $token = json_decode(Crypt::decryptString(is_string($address['resolution_token'] ?? null) ? $address['resolution_token'] : ''), true, 32, JSON_THROW_ON_ERROR);
                $canonical = array_intersect_key($address, array_flip(['street', 'unit', 'barangay', 'city_municipality', 'province', 'postal_code', 'province_code', 'city_code', 'psgc_code']));
                $resolved = array_intersect_key($token['address'] ?? [], $canonical);
                ksort($canonical);
                ksort($resolved);
                if (($token['organization_id'] ?? null) !== $organizationId || ($token['expires_at'] ?? 0) < now()->timestamp
                    || $resolved !== $canonical) {
                    $statuses['registered_business_address'] = 'IN_PROGRESS';
                }
            } catch (DecryptException|\JsonException) {
                $statuses['registered_business_address'] = 'IN_PROGRESS';
            }
        }
        $niches = $state['niches'] ?? json_decode($classification->niches ?? '[]', true, flags: JSON_THROW_ON_ERROR);
        $labels = array_values(array_filter(array_map('trim', $state['custom_labels'] ?? json_decode($classification->custom_labels ?? '[]', true, flags: JSON_THROW_ON_ERROR)), static fn (string $label): bool => $label !== ''));
        $fields = ['classification.supplier_type' => $value('supplier_type', $classification->supplier_type ?? null), 'classification.niches' => $niches];
        $statuses['supplier_classification'] = $group($fields, array_keys($fields));
        if (array_diff($niches, VendorOnboardingService::SUPPLIER_NICHES) !== [] || (in_array('Other Category', $niches, true) && ($labels === [] || count(array_unique(array_map('mb_strtolower', $labels))) !== count($labels)))
            || collect(array_merge($niches, $labels))->contains(fn (string $label): bool => app(RentalServicePolicy::class)->describesRental($label))
            || collect($labels)->contains(static fn (string $label): bool => mb_strlen($label) < 2 || mb_strlen($label) > 60)) {
            $statuses['supplier_classification'] = 'IN_PROGRESS';
        }
        $taxFields = ['tax_profile.tin' => $value('tin', ! empty($tax->tin_encrypted) ? Crypt::decryptString($tax->tin_encrypted) : ''),
            'tax_profile.vat_category' => $value('vat_category', ($taxDetails['vat_declared'] ?? false) ? ($tax->vat_category ?? '') : '')];
        $statuses['tax_profile'] = $group($taxFields, array_keys($taxFields));
        if (! in_array($relief, ['yes', 'no'], true) || ($relief === 'yes' && ! preg_match('/^(20[0-9]{2}|2100)$/D', (string) $value('declaration_year', $taxDetails['declaration_year'] ?? '')))
            || (! $company && $role === 'PROPRIETOR' && $value('owner_attested', ! empty($tax->owner_attested_at) ? 'on' : '') !== 'on')) {
            $statuses['tax_profile'] = 'IN_PROGRESS';
        }
        $representativeFields = [];
        foreach (['full_name' => 'name', 'position' => 'position', 'email' => 'email', 'phone' => 'phone', 'relationship' => 'relationship', 'id_type' => 'id_type', 'id_number' => 'id_number'] as $field => $formField) {
            $representativeFields['representative.'.$field] = $value('representative_'.$formField, $representative[$field === 'id_number' ? 'id_number_last4' : $field] ?? '');
        }
        $statuses['authority_to_act'] = $group($representativeFields, array_keys($representativeFields));
        $authoritySource = $value('authority_evidence_source', $representative['authority_evidence_source'] ?? 'SEPARATE_AUTHORITY_DOCUMENT');
        $authorityProvided = $authoritySource === 'EXISTING_REGISTRATION_EVIDENCE'
            ? in_array($value('authority_evidence_version_id', $representative['authority_evidence_version_id'] ?? ''), $source['registration_versions'] ?? [], true)
            : in_array('authority_to_act', array_merge($source['pending'] ?? [], $source['submitted'] ?? []), true);
        if ($statuses['authority_to_act'] === 'COMPLETED' && ! $authorityProvided) {
            $statuses['authority_to_act'] = 'IN_PROGRESS';
        }
        $statuses['privacy_acknowledgement'] = $value('privacy_acknowledged') === 'on' ? 'COMPLETED' : 'NOT_STARTED';
        foreach (VendorOnboardingService::DOCUMENTS as $key => $label) {
            if ($key === 'authority_to_act') {
                continue;
            }
            $pending = in_array($key, $source['pending'] ?? [], true);
            $statuses[$key] = $pending ? 'COMPLETED' : 'NOT_STARTED';
        }
        // Submitted clean evidence also counts as supplied; its Admin decision remains independent.
        foreach ($source['submitted'] ?? [] as $key) {
            if ($key !== 'authority_to_act') {
                $statuses[$key] = 'COMPLETED';
            }
        }
        foreach ($definitions as $key => $definition) {
            if (! $definition['applicable']) {
                $statuses[$key] = 'NOT_APPLICABLE';
            }
        }

        return $statuses;
    }
}
