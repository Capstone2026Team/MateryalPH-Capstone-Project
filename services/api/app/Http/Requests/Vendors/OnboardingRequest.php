<?php

declare(strict_types=1);

namespace App\Http\Requests\Vendors;

use App\Domain\Vendors\ManageVendorTeam;
use App\Domain\Vendors\PrivateDocuments;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;
use Illuminate\Validation\Validator;

final class OnboardingRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user() !== null;
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        $version = ['required', 'integer', 'min:1'];

        return match ($this->route()?->getActionMethod()) {
            'uploadMedia' => ['lock_version' => $version, 'kind' => ['required', Rule::in(['LOGO', 'BANNER', 'PROMOTIONAL'])], 'alt_text' => ['required', 'string', 'max:250'], 'file' => ['required', 'file', 'max:10240']],
            'reviewMedia' => ['lock_version' => $version, 'decision' => ['required', Rule::in(['APPROVE', 'RETURN_FOR_CORRECTION', 'REJECT'])], 'reason' => ['required_unless:decision,APPROVE', 'nullable', 'string', 'min:3', 'max:1000']],
            'removeMedia' => ['lock_version' => $version],
            'saveBusiness' => ['lock_version' => $version, 'submit' => ['required', 'boolean'], 'business' => ['required', 'array:legal_name,individual_registered_name,company_registered_name,government_id_type,government_id_number,store_name,established_on,store_email,store_phone,classification,niches,other_niche,business_type,address,contacts']],
            'requestStoreEmailVerification' => ['lock_version' => $version, 'email' => ['required', 'email:rfc', 'max:254']],
            'confirmStoreEmailVerification' => ['lock_version' => $version, 'email' => ['required', 'email:rfc', 'max:254'], 'code' => ['required', 'digits:6']],
            'upload' => ['lock_version' => $version, 'document_type' => ['required', Rule::in(PrivateDocuments::TYPES)], 'file' => ['required', 'file', 'max:10240']],
            'reviewBusiness' => ['regulatory_evidence_required' => ['sometimes', 'boolean'], 'regulatory_review_basis' => ['nullable', 'string', 'max:1000'], 'lock_version' => $version, 'decision' => ['required', 'string'], 'reason' => ['nullable', 'string', 'max:1000']],
            'reviewDocument' => ['lock_version' => $version, 'decision' => ['required', 'string'], 'reason' => ['nullable', 'string', 'max:1000'], 'verified_reference' => ['nullable', 'string'], 'verified_issued_on' => ['nullable', 'string'], 'verified_expires_on' => ['nullable', 'string'], 'verified_expiry_not_applicable' => ['required', 'boolean'], 'source_reference' => ['required', 'string'], 'remarks' => ['nullable', 'string'], 'immediate_restriction' => ['required', 'boolean']],
            'activate' => ['lock_version' => $version],
            'saveTax' => ['lock_version' => $version, 'attest' => ['required', 'boolean'], 'profile' => ['required', 'array']],
            'reviewTax' => ['lock_version' => $version, 'decision' => ['required', 'string'], 'reason' => ['nullable', 'string', 'max:1000']],
            'saveStore' => ['lock_version' => $version, 'description' => ['required', 'string'], 'public_email' => ['nullable', 'string'], 'public_phone' => ['nullable', 'string'], 'bulk_order_capable' => ['required', 'boolean'], 'fulfillment' => ['required', 'string'], 'cod_enabled' => ['required', 'boolean'], 'in_store_payment_enabled' => ['required', 'boolean'], 'online_payment_enabled' => ['required', 'boolean'], 'refund_configuration' => ['required', 'array'], 'delivery_vehicles' => ['present', 'array'], 'hours' => ['required', 'array']],
            'connect' => ['lock_version' => $version, 'withholding_demo_scenario' => ['required', 'string']],
            'reconcileConnection' => ['lock_version' => $version],
            'acceptCommission' => ['version_id' => ['required', 'uuid']],
            'invite' => ['full_name' => ['required', 'string'], 'email' => ['required', 'email:rfc'], 'telephone_e164' => ['nullable', 'string'], 'role' => ['required', 'string'], 'can_manage_staff' => ['sometimes', 'boolean'], 'expires_at' => ['required', 'date']],
            'revokeInvitation' => ['lock_version' => $version],
            'changeMember' => ['lock_version' => $version, 'role' => ['required_without_all:status,can_manage_staff', 'prohibits:status,can_manage_staff', Rule::in([...ManageVendorTeam::STAFF_ROLES, 'STORE_MANAGER'])], 'status' => ['required_without_all:role,can_manage_staff', 'prohibits:role,can_manage_staff', Rule::in(['ACTIVE', 'SUSPENDED', 'DEACTIVATED'])], 'can_manage_staff' => ['required_without_all:role,status', 'prohibits:role,status', 'boolean']],
            'team', 'invitations' => ['page' => ['sometimes', 'integer', 'min:1'], 'per_page' => ['sometimes', 'integer', 'between:1,50']],
            'queue', 'documents' => ['page' => ['sometimes', 'integer', 'min:1'], 'per_page' => ['sometimes', 'integer', 'between:1,50']],
            default => [],
        };
    }

    /** @return list<\Closure> */
    public function after(): array
    {
        return [function (Validator $validator): void {
            if (in_array($this->route()?->getActionMethod(), ['download'], true)) {
                return;
            }
            foreach (array_keys($this->all()) as $field) {
                if (! array_key_exists($field, $this->rules())) {
                    $validator->errors()->add($field, 'This field cannot be changed here.');
                }
            }
        }];
    }
}
