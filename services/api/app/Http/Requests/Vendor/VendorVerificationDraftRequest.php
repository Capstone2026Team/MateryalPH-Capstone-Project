<?php

declare(strict_types=1);

namespace App\Http\Requests\Vendor;

use App\Domain\Vendors\VendorOnboardingService;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

final class VendorVerificationDraftRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()?->account_type === 'VENDOR';
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        return [
            'draft_lock_version' => ['sometimes', 'integer', 'min:0'],
            'lock_version' => ['required', 'integer', 'min:1'],
            'business_type' => ['sometimes', Rule::in(VendorOnboardingService::BUSINESS_TYPES)],
            'registered_name' => ['sometimes', 'string', 'max:180'],
            'store_name' => ['sometimes', 'string', 'max:180'],
            'date_established' => ['sometimes', 'date', 'before_or_equal:today'],
            'store_email' => ['sometimes', 'email:rfc', 'max:254'],
            'store_phone' => ['sometimes', 'string', 'max:24'],
            'legal_identity' => ['sometimes', 'array'],
            'legal_identity.same_as_owner' => ['sometimes', 'boolean'],
            'legal_identity.surname' => ['sometimes', 'nullable', 'string', 'max:120'],
            'legal_identity.first_name' => ['sometimes', 'nullable', 'string', 'max:120'],
            'legal_identity.middle_name' => ['sometimes', 'nullable', 'string', 'max:120'],
            'legal_identity.suffix' => ['sometimes', 'nullable', 'string', 'max:32'],
            'legal_identity.company_registered_name' => ['sometimes', 'nullable', 'string', 'max:180'],
            'legal_identity.id_type' => ['sometimes', 'nullable', 'string', 'max:48'],
            'legal_identity.id_number' => ['sometimes', 'nullable', 'string', 'max:64'],
            'representative' => ['sometimes', 'array'],
            'representative.same_as_owner' => ['sometimes', 'boolean'],
            'representative.full_name' => ['required_with:representative', 'string', 'max:180'],
            'representative.position' => ['nullable', 'string', 'max:120'],
            'representative.email' => ['nullable', 'email:rfc', 'max:254'],
            'representative.phone' => ['nullable', 'string', 'max:24'],
            'representative.relationship' => ['nullable', 'string', 'max:120'],
            'representative.id_type' => ['nullable', Rule::in(['NATIONAL_ID', 'DRIVERS_LICENSE', 'PASSPORT', 'UMID', 'OTHER'])],
            'representative.id_number' => ['nullable', 'string', 'max:64'],
            'contacts' => ['sometimes', 'array', 'max:20'],
            'contacts.*.full_name' => ['required', 'string', 'max:160'],
            'contacts.*.title' => ['nullable', 'string', 'max:120'],
            'contacts.*.email' => ['nullable', 'email:rfc', 'max:254'],
            'contacts.*.phone' => ['nullable', 'string', 'max:24'],
            'contacts.*.is_primary' => ['required', 'boolean'],
            'contacts.*.is_public' => ['sometimes', 'boolean'],
            'contacts.*.is_authorized' => ['sometimes', 'boolean'],
            'classification' => ['sometimes', 'array'],
            'classification.supplier_type' => ['required_with:classification', Rule::in(VendorOnboardingService::SUPPLIER_TYPES)],
            'classification.niches' => ['sometimes', 'array', 'max:27'],
            'classification.niches.*' => ['string', 'max:96'],
            'classification.custom_label' => ['nullable', 'string', 'max:120'],
            'address' => ['sometimes', 'array'],
            'address.street' => ['required_with:address', 'string', 'max:180'],
            'address.unit' => ['nullable', 'string', 'max:120'],
            'address.barangay' => ['required_with:address', 'string', 'max:120'],
            'address.city_municipality' => ['required_with:address', 'string', 'max:120'],
            'address.province' => ['required_with:address', 'string', 'max:120'],
            'address.postal_code' => ['required_with:address', 'string', 'max:16'],
            'address.formatted_address' => ['sometimes', 'string', 'max:500'],
            'address.latitude' => ['required_with:address', 'numeric', 'between:-90,90'],
            'address.longitude' => ['required_with:address', 'numeric', 'between:-180,180'],
            'address.psgc_code' => ['nullable', 'string', 'max:16'],
            'address.provider_place_id' => ['nullable', 'string', 'max:191'],
            'address.source' => ['sometimes', Rule::in(['MAP', 'MANUAL'])],
            'address.provider' => ['nullable', 'string', 'max:32'],
            'tax_profile' => ['sometimes', 'array'],
            'tax_profile.taxpayer_key' => ['sometimes', 'string', 'max:128'],
            'tax_profile.tin' => ['sometimes', 'string', 'regex:/^[0-9]{9}$/D'],
            'tax_profile.branch_code' => ['sometimes', 'nullable', 'string', 'regex:/^(?:[0-9]{3}|[0-9]{5})$/D'],
            'tax_profile.branch_code_length' => ['sometimes', 'integer', Rule::in([3, 5])],
            'tax_profile.head_office' => ['sometimes', 'boolean'],
            'tax_profile.bir_cor_reference' => ['sometimes', 'nullable', 'string', 'max:160'],
            'tax_profile.entity_class' => ['sometimes', Rule::in(['INDIVIDUAL', 'CORPORATION', 'PARTNERSHIP', 'COOPERATIVE'])],
            'tax_profile.registration_category' => ['sometimes', 'string', 'max:32'],
            'tax_profile.vat_category' => ['sometimes', Rule::in(['VAT', 'NON_VAT', 'VAT_ZERO', 'VAT_EXEMPT'])],
            'tax_profile.fiscal_year_start_month' => ['sometimes', 'integer', 'between:1,12'],
            'tax_profile.fiscal_year' => ['nullable', 'integer', 'between:2000,2100'],
            'tax_profile.taxable_year_start' => ['nullable', 'date'],
            'tax_profile.taxable_year_end' => ['nullable', 'date', 'after_or_equal:tax_profile.taxable_year_start'],
            'tax_profile.prior_year_amount_centavos' => ['sometimes', 'integer', 'min:0'],
            'tax_profile.declaration' => ['nullable', 'boolean'],
            'tax_profile.declaration_type' => ['nullable', 'string', 'max:64'],
            'tax_profile.threshold_position' => ['nullable', 'string', 'max:64'],
            'tax_profile.submission_date' => ['nullable', 'date'],
            'tax_profile.declaration_year' => ['nullable', 'integer', 'between:2000,2100'],
            'tax_profile.receipt_reference' => ['nullable', 'string', 'max:160'],
            'tax_profile.valid_from' => ['nullable', 'date'],
            'tax_profile.valid_until' => ['nullable', 'date', 'after_or_equal:tax_profile.valid_from'],
            'tax_profile.outside_platform_amount_centavos' => ['sometimes', 'integer', 'min:0'],
            'tax_profile.outside_platform_period' => ['nullable', 'string', 'max:32'],
            'tax_profile.outside_platform_as_of' => ['nullable', 'date'],
            'tax_profile.outside_platform_overlap' => ['nullable', 'boolean'],
            'tax_profile.withholding_scenario' => ['nullable', Rule::in(['DEMO_PLATFORM_WITHHOLDER', 'DEMO_PROVIDER_WITHHOLDER'])],
            'tax_profile.tax_relief_claimed' => ['sometimes', 'boolean'],
            'tax_profile.owner_attested' => ['sometimes', 'boolean'],
        ];
    }
}
