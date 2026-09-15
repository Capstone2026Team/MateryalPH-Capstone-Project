<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Agreements\AccountAgreements;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\EmailOtpService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;

final class SaveBusinessInformation
{
    public function __construct(private readonly OnboardingAccess $access, private readonly AccountAgreements $agreements, private readonly AuditRecorder $audit, private readonly ActivationReadiness $readiness, private readonly EmailOtpService $otp) {}

    /** @return array<string, mixed> */
    public function read(Request $request, string $organization): array
    {
        if ($request->user()->account_type === 'ADMIN') {
            $this->access->reviewer($request);
            $org = DB::table('vendor_organizations')->where('id', $organization)->firstOrFail();
        } else {
            $org = $this->access->vendor($request, $organization);
        }

        $review = DB::table('audit_logs')->where('resource_type', 'VENDOR_ORGANIZATION')->where('resource_id', $organization)->where('action', 'VENDOR_BUSINESS_REVIEWED')->orderByDesc('id')->value('after');
        $reviewData = json_decode($review ?? '{}', true);

        return [
            'review_reason' => $reviewData['reason'] ?? null,
            'lock_version' => (int) $org->lock_version,
            'draft' => json_decode($org->business_draft ?? '{}', true),
            'status' => $org->store_verification_status,
            'store_email_verification' => [
                'email' => $org->store_email,
                'verified_at' => $org->store_email_verified_at,
                'pending_email' => $org->pending_store_email,
            ],
        ];
    }

    /** @param array<string, mixed> $input
     * @return array<string, mixed>
     */
    public function save(Request $request, string $organization, array $input): array
    {
        return DB::transaction(function () use ($request, $organization, $input): array {
            $org = DB::table('vendor_organizations')->where('id', $organization)->lockForUpdate()->first();
            $this->access->vendor($request, $organization, sensitive: true);
            $this->agreements->requireCurrentCodes($request, ['TERMS_OF_SERVICE', 'VENDOR_CODE_OF_CONDUCT', 'PRIVACY_NOTICE']);
            $this->access->version($org, $input['lock_version']);
            if ($org->store_verification_status === 'PENDING_VERIFICATION') {
                throw new AuthenticationException('REVIEW_IN_PROGRESS', 'The submitted business information is under review.', 409);
            }
            $draft = array_replace(json_decode($org->business_draft ?? '{}', true), $input['business']);
            $submit = $input['submit'] ?? false;
            $required = $submit ? 'required' : 'sometimes';
            Validator::make($draft, [
                'legal_name' => [$required, 'string', 'max:180'], 'store_name' => [$required, 'string', 'max:180'],
                'business_type' => [$required, Rule::in(['SOLE_PROPRIETORSHIP', 'PARTNERSHIP', 'CORPORATION', 'ONE_PERSON_CORPORATION', 'COOPERATIVE'])],
                'individual_registered_name' => [Rule::requiredIf($submit && ($draft['business_type'] ?? null) === 'SOLE_PROPRIETORSHIP'), 'nullable', 'array:surname,first_name,middle_name,suffix,same_as_owner'],
                'individual_registered_name.surname' => [Rule::requiredIf($submit && ($draft['business_type'] ?? null) === 'SOLE_PROPRIETORSHIP'), 'nullable', 'string', 'max:100'],
                'individual_registered_name.first_name' => [Rule::requiredIf($submit && ($draft['business_type'] ?? null) === 'SOLE_PROPRIETORSHIP'), 'nullable', 'string', 'max:100'],
                'individual_registered_name.middle_name' => ['nullable', 'string', 'max:100'],
                'individual_registered_name.suffix' => ['nullable', 'string', 'max:30'],
                'individual_registered_name.same_as_owner' => ['sometimes', 'boolean'],
                'company_registered_name' => [Rule::requiredIf($submit && in_array($draft['business_type'] ?? null, ['PARTNERSHIP', 'CORPORATION', 'ONE_PERSON_CORPORATION', 'COOPERATIVE'], true)), 'nullable', 'string', 'max:180'],
                'government_id_type' => [Rule::requiredIf($submit && ($draft['business_type'] ?? null) === 'SOLE_PROPRIETORSHIP'), 'nullable', 'string', 'max:80'],
                'government_id_number' => ['nullable', 'string', 'max:120'],
                'established_on' => [$required, 'date_format:Y-m-d', 'before_or_equal:today'],
                'store_email' => [$required, 'email:rfc', 'max:254'],
                'store_phone' => [$required, 'regex:/^\+?[0-9 ()-]{7,20}$/'],
                'classification' => [$required, Rule::in(['WHOLESALER_DISTRIBUTOR', 'RETAIL_HARDWARE_STORE', 'SPECIALIZED_SUPPLIER'])],
                'niches' => [$required, 'array', 'min:1', 'max:26'],
                'niches.*' => ['string', 'distinct', Rule::in(['CONSTRUCTION_MATERIALS', 'ELECTRICAL_SUPPLIES', 'PLUMBING_SANITARY', 'TOOLS_EQUIPMENT', 'FINISHING_MATERIALS', 'FASTENERS_HARDWARE', 'CEMENT_CONCRETE', 'ROOFING_MATERIALS', 'FORMWORKS_SCAFFOLDING', 'WOOD_LUMBER', 'LANDSCAPING_EXTERIOR', 'STEEL_REINFORCEMENT', 'TOOLS_ACCESSORIES', 'MASONRY', 'INSULATION_WATERPROOFING', 'AGGREGATES', 'DRAINAGE_SEPTIC', 'CONSTRUCTION_CHEMICALS', 'FLOORING_MATERIALS', 'WALL_CEILING', 'HVAC_MATERIALS', 'SANITARY_FIXTURES', 'FIRE_PROTECTION', 'PAINTS_FINISHES', 'ADHESIVES_SEALANTS', 'DOORS_WINDOWS_GLASS', 'OTHER'])],
                'other_niche' => [Rule::requiredIf($submit && in_array('OTHER', $draft['niches'] ?? [], true)), 'nullable', 'string', 'max:160'],
                'address' => [$required, 'array:street,barangay,city,province,postal_code,latitude,longitude'],
                'address.street' => [$required, 'string', 'max:200'], 'address.barangay' => [$required, 'string', 'max:100'],
                'address.city' => [$required, 'string', 'max:100'], 'address.province' => [$required, 'string', 'max:100'],
                'address.postal_code' => [$required, 'regex:/^[0-9]{4}$/'],
                'address.latitude' => [$required, 'numeric', 'between:-90,90', 'required_with:address.longitude'],
                'address.longitude' => [$required, 'numeric', 'between:-180,180', 'required_with:address.latitude'],
                'contacts' => [$required, 'array', 'min:1', 'max:10'],
                'contacts.*' => ['array:full_name,position,email,telephone_e164,authorized_representative,is_primary,verification_communication,account_administration_communication,general_administration_communication'],
                'contacts.*.full_name' => ['required', 'string', 'max:160'], 'contacts.*.position' => ['required', 'string', 'max:100'],
                'contacts.*.email' => ['required', 'email:rfc', 'max:254'], 'contacts.*.telephone_e164' => ['required', 'regex:/^\+?[0-9 ()-]{7,20}$/'],
                'contacts.*.authorized_representative' => ['required', 'boolean'], 'contacts.*.is_primary' => ['required', 'boolean'],
                'contacts.*.verification_communication' => ['required', 'boolean'],
                'contacts.*.account_administration_communication' => ['required', 'boolean'],
                'contacts.*.general_administration_communication' => ['required', 'boolean'],
            ])->validate();
            /** @var list<array<string, mixed>> $contacts */
            $contacts = $draft['contacts'] ?? [];
            if (isset($draft['contacts']) && collect($contacts)->where('is_primary', true)->count() !== 1) {
                throw new AuthenticationException('PRIMARY_CONTACT_REQUIRED', 'Select exactly one primary business contact.', 422);
            }
            if (isset($draft['other_niche']) && preg_match('/\b(?:construction\s+)?(?:vehicle|equipment)?\s*rental\b/i', (string) $draft['other_niche']) === 1) {
                throw new AuthenticationException('UNSUPPORTED_RENTAL_CATEGORY', 'Vehicle and equipment rental services are not currently supported by MateryalPH.', 422);
            }
            if ($submit) {
                $this->validateSubmissionDependencies($organization, $draft);
            }
            $nextVerification = $submit ? 'PENDING_VERIFICATION' : 'IN_PROGRESS';
            $changes = ['regulatory_evidence_required' => null, 'regulatory_review_basis' => null, 'business_draft' => json_encode($draft, JSON_THROW_ON_ERROR), 'business_review_status' => $nextVerification, 'store_verification_status' => $nextVerification, 'onboarding_status' => $nextVerification, 'submitted_at' => $submit ? now() : null, 'lock_version' => $org->lock_version + 1, 'updated_at' => now()];
            foreach (['legal_name', 'store_name', 'business_type', 'established_on', 'store_email', 'store_phone'] as $field) {
                if (array_key_exists($field, $draft)) {
                    $changes[$field] = $draft[$field];
                }
            }
            $ownerEmail = DB::table('vendor_memberships as membership')->join('users as user', 'user.id', '=', 'membership.user_id')->where('membership.vendor_organization_id', $organization)->where('membership.role', 'OWNER')->value('user.email');
            $ownerEmailMatches = is_string($ownerEmail) && strcasecmp($ownerEmail, (string) ($draft['store_email'] ?? '')) === 0;
            $existingVerifiedEmailMatches = is_string($org->store_email) && strcasecmp($org->store_email, (string) ($draft['store_email'] ?? '')) === 0 && $org->store_email_verified_at !== null;
            $changes['store_email_verified_at'] = $ownerEmailMatches ? now() : ($existingVerifiedEmailMatches ? $org->store_email_verified_at : null);
            DB::table('vendor_organizations')->where('id', $organization)->update($changes);
            if ($submit) {
                $snapshot = json_encode($draft, JSON_THROW_ON_ERROR);
                DB::table('vendor_business_submissions')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organization, 'submitted_by_user_id' => $request->user()->getKey(), 'organization_version' => $org->lock_version + 1, 'business_information' => $snapshot, 'content_hash' => hash('sha256', $snapshot), 'created_at' => now(), 'updated_at' => now()]);
                $address = $draft['address'];
                $addressId = (string) Str::uuid7();
                DB::table('addresses')->insert(['id' => $addressId, 'owner_type' => 'VENDOR_ORGANIZATION', 'owner_id' => $organization, 'label' => 'REGISTERED_BUSINESS', 'formatted_address' => implode(', ', array_map(fn (string $key): string => $address[$key], ['street', 'barangay', 'city', 'province', 'postal_code'])), 'latitude' => $address['latitude'] ?? null, 'longitude' => $address['longitude'] ?? null, 'verified' => false, 'created_at' => now(), 'updated_at' => now()]);
                $store = DB::table('store_profiles')->where('vendor_organization_id', $organization)->first();
                DB::table('store_profiles')->updateOrInsert(['vendor_organization_id' => $organization], ['id' => $store->id ?? (string) Str::uuid7(), 'address_id' => $addressId, 'created_at' => $store->created_at ?? now(), 'updated_at' => now()]);
            }
            if (isset($draft['classification'])) {
                DB::table('vendor_classifications')->where('vendor_organization_id', $organization)->delete();
                DB::table('vendor_classifications')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organization, 'classification' => $draft['classification'], 'created_at' => now(), 'updated_at' => now()]);
            }
            if (isset($draft['contacts'])) {
                DB::table('vendor_contacts')->where('vendor_organization_id', $organization)->whereNull('deactivated_at')->update(['deactivated_at' => now(), 'is_primary' => false, 'updated_at' => now()]);
                foreach ($draft['contacts'] as $contact) {
                    DB::table('vendor_contacts')->insert($contact + ['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organization, 'created_at' => now(), 'updated_at' => now()]);
                }
            }
            $this->audit->account($request, $submit ? 'VENDOR_ONBOARDING_SUBMITTED' : 'VENDOR_BUSINESS_DRAFT_UPDATED', 'VENDOR_ORGANIZATION', $organization, ['lock_version' => $org->lock_version], ['lock_version' => $org->lock_version + 1]);
            $this->readiness->reconcile($request, $organization);

            return $this->read($request, $organization);
        });
    }

    /** @param array<string, mixed> $draft */
    private function validateSubmissionDependencies(string $organization, array $draft): void
    {
        $organizationRow = DB::table('vendor_organizations')->where('id', $organization)->firstOrFail();
        $owner = DB::table('vendor_memberships as membership')->join('users as user', 'user.id', '=', 'membership.user_id')->where('membership.vendor_organization_id', $organization)->where('membership.role', 'OWNER')->first(['user.email', 'user.email_verified_at']);
        $ownerEmailMatches = $owner->email_verified_at !== null && strcasecmp((string) $owner->email, (string) ($draft['store_email'] ?? '')) === 0;
        $verifiedStoreEmailMatches = $organizationRow->store_email_verified_at !== null && strcasecmp((string) $organizationRow->store_email, (string) ($draft['store_email'] ?? '')) === 0;
        if (! $ownerEmailMatches && ! $verifiedStoreEmailMatches) {
            throw new AuthenticationException('STORE_EMAIL_VERIFICATION_REQUIRED', 'Verify the Store Email before submitting Store Verification.', 422);
        }
        $organizationRow->business_type = $draft['business_type'];
        foreach (app(DocumentRequirements::class)->required($organizationRow) as $type) {
            $document = DB::table('business_documents as document')
                ->join('business_document_versions as version', 'version.id', '=', 'document.current_version_id')
                ->join('files as file', 'file.id', '=', 'version.file_id')
                ->where('document.vendor_organization_id', $organization)
                ->where('document.document_type', $type)
                ->whereIn('file.scan_state', ['CLEAN', 'TEST_SIMULATED_CLEAN'])
                ->exists();
            if (! $document) {
                throw new AuthenticationException('VERIFICATION_REQUIREMENT_MISSING', 'Upload a current '.$type.' evidence file that has passed the file-safety check before submitting.', 422);
            }
        }
        $taxReady = DB::table('vendor_tax_profiles as profile')
            ->join('vendor_tax_profile_versions as version', 'version.id', '=', 'profile.current_version_id')
            ->where('profile.vendor_organization_id', $organization)
            ->where('profile.environment', 'TEST')
            ->whereNotNull('version.owner_attested_at')
            ->exists();
        if (! $taxReady) {
            throw new AuthenticationException('VERIFICATION_REQUIREMENT_MISSING', 'Complete and attest the Vendor Tax Profile before submitting Store Verification.', 422);
        }
    }

    /** @param array<string, mixed> $input
     * @return array<string, mixed>
     */
    public function requestStoreEmailVerification(Request $request, string $organization, array $input): array
    {
        return DB::transaction(function () use ($request, $organization, $input): array {
            $org = DB::table('vendor_organizations')->where('id', $organization)->lockForUpdate()->firstOrFail();
            $this->access->vendor($request, $organization, sensitive: true);
            $this->access->version($org, $input['lock_version']);
            $otp = $this->otp->issue((string) $input['email'], 'VENDOR_STORE_EMAIL', $request->user());
            DB::table('vendor_organizations')->where('id', $organization)->update([
                'pending_store_email' => mb_strtolower(trim((string) $input['email'])),
                'pending_store_email_otp_id' => $otp->getKey(),
                'lock_version' => $org->lock_version + 1,
                'updated_at' => now(),
            ]);
            $this->audit->account($request, 'VENDOR_STORE_EMAIL_VERIFICATION_REQUESTED', 'VENDOR_ORGANIZATION', $organization);

            return $this->read($request, $organization);
        });
    }

    /** @param array<string, mixed> $input
     * @return array<string, mixed>
     */
    public function confirmStoreEmailVerification(Request $request, string $organization, array $input): array
    {
        return DB::transaction(function () use ($request, $organization, $input): array {
            $org = DB::table('vendor_organizations')->where('id', $organization)->lockForUpdate()->firstOrFail();
            $this->access->vendor($request, $organization, sensitive: true);
            $this->access->version($org, $input['lock_version']);
            $email = mb_strtolower(trim((string) $input['email']));
            if ($org->pending_store_email_otp_id === null || ! is_string($org->pending_store_email) || ! hash_equals($org->pending_store_email, $email)) {
                throw new AuthenticationException('STORE_EMAIL_VERIFICATION_INVALID', 'Request a new Store Email verification code.', 409);
            }
            $this->otp->verifyForRequest($email, 'VENDOR_STORE_EMAIL', (string) $input['code'], (string) $org->pending_store_email_otp_id);
            DB::table('vendor_organizations')->where('id', $organization)->update([
                'store_email' => $email,
                'store_email_verified_at' => now(),
                'pending_store_email' => null,
                'pending_store_email_otp_id' => null,
                'lock_version' => $org->lock_version + 1,
                'updated_at' => now(),
            ]);
            $this->audit->account($request, 'VENDOR_STORE_EMAIL_VERIFIED', 'VENDOR_ORGANIZATION', $organization);

            return $this->read($request, $organization);
        });
    }
}
