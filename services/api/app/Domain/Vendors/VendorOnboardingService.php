<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Agreements\AccountAgreements;
use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\EmailOtpService;
use App\Domain\Operations\OutboxPublisher;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\URL;
use Illuminate\Support\Str;
use stdClass;

final class VendorOnboardingService
{
    public const BUSINESS_TYPES = ['SOLE_PROPRIETORSHIP', 'PARTNERSHIP', 'CORPORATION', 'ONE_PERSON_CORPORATION', 'COOPERATIVE'];

    public const SUPPLIER_TYPES = ['WHOLESALER_DISTRIBUTOR', 'RETAIL_HARDWARE_STORE', 'SPECIALIZED_SUPPLIER', 'OTHER'];

    public const DOCUMENTS = [
        'business_registration' => 'Primary business registration',
        'lgu_permit' => 'LGU business permit',
        'bir_cor' => 'BIR Certificate of Registration',
        'tax_relief_evidence' => 'Tax relief evidence',
        'identity_evidence' => 'Government-issued identity evidence',
    ];

    private const REGISTRATION_EVIDENCE_TYPES = [
        'SOLE_PROPRIETORSHIP' => 'DTI_BUSINESS_NAME_REGISTRATION',
        'PARTNERSHIP' => 'SEC_REGISTRATION',
        'CORPORATION' => 'SEC_REGISTRATION',
        'ONE_PERSON_CORPORATION' => 'SEC_REGISTRATION',
        'COOPERATIVE' => 'CDA_REGISTRATION',
    ];

    /** @var array<string, array<string, array{label: string, level: string}>> */
    private const STEP_CATALOG = [
        'STORE_VERIFICATION' => [
            'business_type' => ['label' => 'Business type', 'level' => 'REQUIRED'],
            'business_information' => ['label' => 'Business information', 'level' => 'REQUIRED'],
            'registered_business_address' => ['label' => 'Registered business address', 'level' => 'REQUIRED'],
            'supplier_classification' => ['label' => 'Supplier classification', 'level' => 'REQUIRED'],
            'business_registration' => ['label' => 'Business registration evidence', 'level' => 'REQUIRED'],
            'lgu_permit' => ['label' => 'LGU permit evidence', 'level' => 'REQUIRED'],
            'bir_cor' => ['label' => 'BIR COR evidence', 'level' => 'REQUIRED'],
            'tax_profile' => ['label' => 'Tax profile', 'level' => 'REQUIRED'],
            'tax_relief_evidence' => ['label' => 'Tax relief evidence', 'level' => 'CONDITIONALLY_REQUIRED'],
            'privacy_acknowledgement' => ['label' => 'Privacy acknowledgement', 'level' => 'REQUIRED'],
        ],
        'STORE_SETUP' => [
            'public_store_profile' => ['label' => 'Public store profile', 'level' => 'REQUIRED'],
            'store_media' => ['label' => 'Store media', 'level' => 'OPTIONAL'],
            'bulk_capability' => ['label' => 'Bulk capability', 'level' => 'REQUIRED'],
            'fulfillment_method' => ['label' => 'Fulfillment method', 'level' => 'REQUIRED'],
            'delivery_configuration' => ['label' => 'Delivery configuration', 'level' => 'CONDITIONALLY_REQUIRED'],
            'payment_connection' => ['label' => 'Xendit TEST connection', 'level' => 'REQUIRED'],
            'commission_terms' => ['label' => '2% commission terms', 'level' => 'REQUIRED'],
            'team' => ['label' => 'Team accounts', 'level' => 'OPTIONAL'],
        ],
    ];

    /** @var array<string, array{label: string, level: string}> */
    private const IDENTITY_STEP_CATALOG = [
        'legal_identity' => ['label' => 'Registered legal identity', 'level' => 'CONDITIONALLY_REQUIRED'],
        'identity_evidence' => ['label' => 'Government-issued identity evidence', 'level' => 'CONDITIONALLY_REQUIRED'],
    ];

    public function __construct(
        private readonly AccountAccess $access,
        private readonly AccountAgreements $agreements,
        private readonly AuditRecorder $audit,
        private readonly EmailOtpService $otps,
        private readonly OutboxPublisher $outbox,
        private readonly AddressGeocoder $geocoder,
        private readonly XenditAccountVerificationGateway $xendit,
    ) {}

    /** @return array<string, mixed> */
    public function snapshot(Request $request): array
    {
        $scope = $this->vendorScope($request);
        $organizationId = $scope['organization_id'];
        $this->ensureBlueprint($organizationId);
        $organization = DB::table('vendor_organizations')->where('id', $organizationId)->first();
        if ($organization === null) {
            throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The Vendor organization is unavailable.', 404);
        }

        $steps = DB::table('vendor_onboarding_steps')->where('vendor_organization_id', $organizationId)->where('is_current', true)->orderBy('section')->orderBy('id')->get();
        $verificationSteps = $steps->where('section', 'STORE_VERIFICATION')->values();
        $setupSteps = $steps->where('section', 'STORE_SETUP')->values();
        $readiness = $this->readinessForOrganization($organizationId);
        $profile = DB::table('store_profiles')->where('vendor_organization_id', $organizationId)->first();
        $classification = DB::table('vendor_classifications')->where('vendor_organization_id', $organizationId)->first();
        $address = DB::table('addresses')->where('owner_type', 'VENDOR_ORGANIZATION')->where('owner_id', $organizationId)->where('is_current', true)->first();
        $tax = DB::table('vendor_tax_profiles as p')->leftJoin('vendor_tax_profile_versions as v', 'v.id', '=', 'p.current_version_id')->where('p.vendor_organization_id', $organizationId)->first(['p.status', 'p.environment', 'p.lock_version', 'p.attested_at', 'v.version', 'v.entity_class', 'v.registration_category', 'v.vat_category', 'v.vat_verified_category', 'v.tin_branch_code', 'v.bir_cor_reference', 'v.fiscal_year_start_month', 'v.taxpayer_key_last4', 'v.tin_last4', 'v.tax_details', 'v.owner_attested_at']);
        $payment = DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organizationId)->first(['environment', 'provider', 'provider_account_id', 'connection_status', 'provider_status', 'capabilities', 'invitation_url_masked', 'last_reconciled_at', 'last_error_code', 'lock_version']);
        $contacts = DB::table('vendor_contacts')->where('vendor_organization_id', $organizationId)->where('active', true)->orderByDesc('is_primary')->orderBy('id')->get(['id', 'full_name', 'title', 'email', 'phone', 'is_primary', 'is_public', 'is_authorized', 'lock_version']);
        $media = DB::table('store_media as m')->join('files as f', 'f.id', '=', 'm.file_id')->join('store_profiles as p', 'p.id', '=', 'm.store_profile_id')->where('p.vendor_organization_id', $organizationId)->orderBy('m.sort_order')->get(['m.id', 'm.kind', 'm.alt_text', 'm.status', 'f.original_name', 'f.scan_state']);
        $delivery = DB::table('delivery_service_areas')->where('vendor_organization_id', $organizationId)->first(['area_type', 'maximum_distance_km', 'coverage_notes', 'active', 'version', 'lock_version']);
        $vehicles = $this->vehicles($organizationId);
        $privacyAcknowledged = DB::table('agreement_acceptances as aa')
            ->join('agreement_versions as av', 'av.id', '=', 'aa.agreement_version_id')
            ->join('agreement_documents as ad', 'ad.id', '=', 'av.agreement_document_id')
            ->where('aa.user_id', $request->user()->getKey())
            ->where('aa.vendor_organization_id', $organizationId)
            ->where('ad.code', 'PRIVACY_NOTICE')
            ->whereNull('av.retired_at')
            ->where('av.effective_at', '<=', now())
            ->exists();

        return [
            'organization' => [
                'id' => (string) $organization->id,
                'legal_name' => $organization->legal_name,
                'registered_name' => $organization->registered_name,
                'store_name' => $organization->store_name,
                'business_type' => $organization->business_type,
                'date_established' => $organization->date_established,
                'store_email' => $organization->store_email,
                'store_email_verified' => $organization->store_email_verified_at !== null,
                'store_email_pending' => $organization->pending_store_email !== null,
                'pending_store_email' => $organization->pending_store_email,
                'pending_store_email_expires_at' => $organization->pending_store_email_expires_at,
                'store_phone' => $organization->store_phone,
                'lock_version' => (int) $organization->lock_version,
            ],
            'sections' => [
                'STORE_VERIFICATION' => $this->section('STORE_VERIFICATION', 'Store Verification', $verificationSteps, $organization->business_type),
                'STORE_SETUP' => $this->section('STORE_SETUP', 'Store Setup', $setupSteps),
            ],
            'verification' => [
                'status' => $organization->store_verification_status,
                'privacy_acknowledged' => $privacyAcknowledged,
                'legal_identity' => $this->legalIdentity($organization),
                'contacts' => $contacts->map(fn (object $contact): array => (array) $contact)->all(),
                'classification' => $classification === null ? null : ['supplier_type' => $classification->supplier_type, 'niches' => $this->jsonArray($classification->niches), 'custom_label' => $classification->custom_label, 'version' => (int) $classification->version, 'lock_version' => (int) $classification->lock_version],
                'address' => $address === null ? null : $this->address($address),
                'tax_profile' => $tax === null ? null : $this->tax($tax),
            ],
            'setup' => [
                'status' => $organization->store_setup_status,
                'profile' => $profile === null ? null : ['public_store_name' => $profile->public_store_name, 'description' => $profile->description, 'bulk_capability' => $profile->bulk_capability === null ? null : (bool) $profile->bulk_capability, 'fulfillment_method' => $profile->fulfillment_method, 'public_email' => $profile->public_email, 'public_phone' => $profile->public_phone, 'status' => $profile->status, 'version' => (int) $profile->version, 'lock_version' => (int) $profile->lock_version],
                'delivery' => $delivery === null ? null : (array) $delivery,
                'vehicles' => $vehicles,
                'media' => $media->map(fn (object $item): array => (array) $item)->all(),
                'payment' => $payment === null ? null : $this->payment($payment),
            ],
            'activation' => [
                'status' => $organization->store_activation_status,
                'marketplace_discoverability_status' => $organization->marketplace_discoverability_status,
                'readiness' => $readiness,
            ],
            'welcome_required' => $organization->onboarding_welcome_dismissed_at === null && $organization->store_verification_status === 'NOT_STARTED' && $scope['role'] === 'OWNER',
            'permissions' => $scope['permissions'],
        ];
    }

    /**
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function draftVerification(Request $request, array $input): array
    {
        $this->requireVendorPermission($request, 'vendor.onboarding.manage');
        $organizationId = $this->organizationId($request);
        DB::transaction(function () use ($request, $input, $organizationId): void {
            $organization = DB::table('vendor_organizations')->where('id', $organizationId)->lockForUpdate()->first();
            $this->assertVersion($organization, $input['lock_version'] ?? null);
            $reopenRequirements = [];
            if ($organization !== null && $organization->store_verification_status === 'APPROVED') {
                foreach (['business_type', 'registered_name', 'date_established', 'store_phone'] as $field) {
                    if (array_key_exists($field, $input) && (string) ($input[$field] ?? '') !== (string) ($organization->{$field} ?? '')) {
                        $reopenRequirements[] = 'business_information';
                    }
                }
                if (array_key_exists('contacts', $input)) {
                    $reopenRequirements[] = 'business_information';
                }
                if (array_key_exists('classification', $input)) {
                    $reopenRequirements[] = 'supplier_classification';
                }
                if (array_key_exists('address', $input)) {
                    $reopenRequirements[] = 'registered_business_address';
                }
                if (array_key_exists('tax_profile', $input)) {
                    $reopenRequirements[] = 'tax_profile';
                }
                if (array_key_exists('legal_identity', $input)) {
                    $reopenRequirements[] = 'legal_identity';
                    if ($this->individualIdentityRequired((string) ($organization->business_type ?? ''))) {
                        $reopenRequirements[] = 'identity_evidence';
                    } else {
                        $reopenRequirements[] = 'business_registration';
                    }
                }
                if (array_key_exists('business_type', $input) && (string) ($input['business_type'] ?? '') !== (string) ($organization->business_type ?? '')) {
                    $reopenRequirements[] = 'business_registration';
                }
            }
            $update = array_intersect_key($input, array_flip(['business_type', 'registered_name', 'date_established', 'store_phone']));
            if (array_key_exists('store_email', $input)) {
                $candidateEmail = mb_strtolower(trim((string) $input['store_email']));
                if ($candidateEmail !== '' && $candidateEmail !== (string) $organization->store_email) {
                    $update['pending_store_email'] = $candidateEmail;
                    $update['pending_store_email_expires_at'] = now()->addMinutes((int) config('materyalph.auth.otp_ttl_minutes', 10));
                }
            }
            if (array_key_exists('store_name', $input)) {
                $update['store_name'] = trim((string) $input['store_name']);
            }
            if ($update !== []) {
                $update['lock_version'] = (int) $organization->lock_version + 1;
                $update['updated_at'] = now();
                DB::table('vendor_organizations')->where('id', $organizationId)->update($update);
            }
            if (is_array($input['legal_identity'] ?? null)) {
                $this->saveLegalIdentity($request, $organizationId, $input['legal_identity']);
            }
            if (array_key_exists('contacts', $input)) {
                $this->saveContacts($organizationId, is_array($input['contacts']) ? $input['contacts'] : []);
            }
            if (is_array($input['classification'] ?? null)) {
                $this->saveClassification($organizationId, $input['classification']);
            }
            if (is_array($input['address'] ?? null)) {
                $this->saveAddress($organizationId, $input['address']);
            }
            if (is_array($input['tax_profile'] ?? null)) {
                $this->saveTaxProfile($request, $organizationId, $input['tax_profile']);
            }
            $this->ensureBlueprint($organizationId);
            $this->markDraftProgress($organizationId);
            foreach (array_values(array_unique($reopenRequirements)) as $requirementKey) {
                $this->setStep($organizationId, 'STORE_VERIFICATION', $requirementKey, 'IN_PROGRESS');
            }
            if ($reopenRequirements !== []) {
                DB::table('vendor_organizations')->where('id', $organizationId)->update(['store_verification_status' => 'IN_PROGRESS', 'updated_at' => now()]);
            } else {
                DB::table('vendor_organizations')->where('id', $organizationId)->whereNotIn('store_verification_status', ['PENDING_VERIFICATION', 'APPROVED'])->update(['store_verification_status' => 'IN_PROGRESS', 'updated_at' => now()]);
            }
            $this->audit->account($request, 'VENDOR_VERIFICATION_DRAFT_SAVED', 'VENDOR_ORGANIZATION', $organizationId, after: ['fields' => array_keys($input)]);
        });

        return $this->snapshot($request);
    }

    /**
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function submitVerification(Request $request, array $input): array
    {
        $this->requireVendorPermission($request, 'vendor.onboarding.submit');
        if ($this->vendorScope($request)['role'] !== 'OWNER') {
            throw new AuthenticationException('PERMISSION_DENIED', 'Only the Vendor Owner can submit Store Verification.', 403);
        }
        $organizationId = $this->organizationId($request);
        $key = $this->requireIdempotencyKey($request);

        DB::transaction(function () use ($request, $input, $organizationId, $key): void {
            $organization = DB::table('vendor_organizations')->where('id', $organizationId)->lockForUpdate()->first();
            if ($this->idempotent($request, 'VENDOR_VERIFICATION_SUBMIT', $key, $organizationId)) {
                return;
            }
            $this->assertVersion($organization, $input['lock_version'] ?? null);
            $this->requireVerificationCompleteness($request, $organizationId, (bool) ($input['privacy_acknowledged'] ?? false));
            $this->acceptPrivacyNotice($request, $organizationId);
            $now = now();
            DB::table('vendor_onboarding_steps')->where('vendor_organization_id', $organizationId)->where('section', 'STORE_VERIFICATION')->where('is_current', true)->whereIn('status', ['IN_PROGRESS', 'NOT_STARTED', 'COMPLETED'])->update(['status' => 'PENDING_VERIFICATION', 'submitted_by_user_id' => $request->user()->getKey(), 'submitted_at' => $now, 'updated_at' => $now]);
            $documentIds = DB::table('business_documents')->where('vendor_organization_id', $organizationId)->whereIn('requirement_key', ['business_registration', 'lgu_permit', 'bir_cor', 'tax_relief_evidence', 'identity_evidence'])->pluck('id');
            if ($documentIds->isNotEmpty()) {
                DB::table('business_documents')->whereIn('id', $documentIds)->update(['status' => 'SUBMITTED', 'updated_at' => $now]);
            }
            DB::table('vendor_organizations')->where('id', $organizationId)->update(['store_verification_status' => 'PENDING_VERIFICATION', 'lock_version' => (int) $organization->lock_version + 1, 'updated_at' => $now]);
            $this->claimIdempotency($request, 'VENDOR_VERIFICATION_SUBMIT', $key, $organizationId, 200);
            $this->notifyOrganization($request, $organizationId, 'Store Verification submitted', 'Your Store Verification is now pending Admin review.', 'VENDOR_VERIFICATION');
            $this->audit->account($request, 'VENDOR_VERIFICATION_SUBMITTED', 'VENDOR_ORGANIZATION', $organizationId, after: ['status' => 'PENDING_VERIFICATION']);
        });

        return $this->snapshot($request);
    }

    /**
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function draftSetup(Request $request, array $input): array
    {
        $this->requireVendorPermission($request, 'vendor.onboarding.manage');
        $organizationId = $this->organizationId($request);
        DB::transaction(function () use ($request, $input, $organizationId): void {
            $organization = DB::table('vendor_organizations')->where('id', $organizationId)->lockForUpdate()->first();
            $this->assertVersion($organization, $input['organization_lock_version'] ?? null);
            $existing = DB::table('store_profiles')->where('vendor_organization_id', $organizationId)->first();
            $profile = [
                'public_store_name' => trim((string) ($input['public_store_name'] ?? ($existing === null ? $organization->store_name : $existing->public_store_name))),
                'description' => $input['description'] ?? ($existing === null ? null : $existing->description),
                'bulk_capability' => array_key_exists('bulk_capability', $input) ? (bool) $input['bulk_capability'] : ($existing === null ? null : $existing->bulk_capability),
                'fulfillment_method' => $input['fulfillment_method'] ?? ($existing === null ? null : $existing->fulfillment_method),
                'public_email' => $input['public_email'] ?? ($existing === null ? null : $existing->public_email),
                'public_phone' => $input['public_phone'] ?? ($existing === null ? null : $existing->public_phone),
                'status' => 'DRAFT',
                'version' => ($existing === null ? 0 : (int) $existing->version) + 1,
                'lock_version' => ($existing === null ? 0 : (int) $existing->lock_version) + 1,
                'updated_at' => now(),
            ];
            if ($existing === null) {
                $profile['id'] = (string) Str::uuid7();
                $profile['vendor_organization_id'] = $organizationId;
                $profile['created_at'] = now();
                DB::table('store_profiles')->insert($profile);
            } else {
                DB::table('store_profiles')->where('id', $existing->id)->update($profile);
            }
            $method = (string) ($profile['fulfillment_method'] ?? '');
            if ($method === 'SELF_PICKUP') {
                $this->setStep($organizationId, 'STORE_SETUP', 'delivery_configuration', 'NOT_APPLICABLE', 'Vendor selected Self-Pickup only.');
                DB::table('delivery_service_areas')->where('vendor_organization_id', $organizationId)->update(['active' => false, 'updated_at' => now()]);
            } elseif (in_array($method, ['VENDOR_DELIVERY', 'BOTH'], true)) {
                $delivery = is_array($input['delivery'] ?? null) ? $input['delivery'] : [];
                $this->saveDelivery($organizationId, $delivery);
                $this->setStep($organizationId, 'STORE_SETUP', 'delivery_configuration', 'IN_PROGRESS');
            }
            if (is_array($input['vehicles'] ?? null)) {
                $this->saveVehicles($organizationId, $input['vehicles']);
            }
            $this->setStep($organizationId, 'STORE_SETUP', 'public_store_profile', $profile['public_store_name'] !== '' ? 'IN_PROGRESS' : 'NOT_STARTED');
            $this->setStep($organizationId, 'STORE_SETUP', 'bulk_capability', $profile['bulk_capability'] === null ? 'NOT_STARTED' : 'IN_PROGRESS');
            $this->setStep($organizationId, 'STORE_SETUP', 'fulfillment_method', $method === '' ? 'NOT_STARTED' : 'IN_PROGRESS');
            DB::table('vendor_organizations')->where('id', $organizationId)->update(['store_setup_status' => 'IN_PROGRESS', 'updated_at' => now()]);
            $this->audit->account($request, 'VENDOR_STORE_SETUP_DRAFT_SAVED', 'STORE_PROFILE', (string) ($existing->id ?? $profile['id']), after: ['fields' => array_keys($input)]);
        });

        return $this->snapshot($request);
    }

    /**
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function completeSetup(Request $request, array $input): array
    {
        $this->requireVendorPermission($request, 'vendor.onboarding.manage');
        if ($this->vendorScope($request)['role'] !== 'OWNER') {
            throw new AuthenticationException('PERMISSION_DENIED', 'Only the Vendor Owner can complete Store Setup.', 403);
        }
        $key = $this->requireIdempotencyKey($request);
        $organizationId = $this->organizationId($request);
        DB::transaction(function () use ($request, $input, $key, $organizationId): void {
            $organization = DB::table('vendor_organizations')->where('id', $organizationId)->lockForUpdate()->first();
            if ($this->idempotent($request, 'VENDOR_STORE_SETUP_COMPLETE', $key, $organizationId)) {
                return;
            }
            $this->assertVersion($organization, $input['organization_lock_version'] ?? null);
            $profile = DB::table('store_profiles')->where('vendor_organization_id', $organizationId)->first();
            if ($profile === null || $profile->public_store_name === '' || $profile->bulk_capability === null || ! in_array($profile->fulfillment_method, ['SELF_PICKUP', 'VENDOR_DELIVERY', 'BOTH'], true)) {
                throw new AuthenticationException('STORE_SETUP_INCOMPLETE', 'Complete the public profile, bulk capability, and fulfillment method before finishing Store Setup.', 422);
            }
            if (in_array($profile->fulfillment_method, ['VENDOR_DELIVERY', 'BOTH'], true)) {
                $delivery = DB::table('delivery_service_areas')->where('vendor_organization_id', $organizationId)->where('active', true)->first();
                if ($delivery === null || $delivery->maximum_distance_km === null || (int) $delivery->maximum_distance_km < 1) {
                    throw new AuthenticationException('DELIVERY_CONFIGURATION_REQUIRED', 'Add the delivery distance before finishing Store Setup.', 422);
                }
                if (! $this->vehicleConfigurationReady($organizationId)) {
                    throw new AuthenticationException('VEHICLE_CONFIGURATION_REQUIRED', 'Configure at least one active vehicle with a current non-negative delivery rate before finishing Store Setup.', 422);
                }
            }
            $payment = DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organizationId)->first();
            if ($payment === null || $payment->environment !== 'TEST' || $payment->connection_status !== 'CONNECTED') {
                throw new AuthenticationException('PAYMENT_CONNECTION_REQUIRED', 'Reconcile the Xendit TEST connection before finishing Store Setup.', 422);
            }
            if (! (bool) ($input['commission_terms_accepted'] ?? false)) {
                throw new AuthenticationException('COMMISSION_TERMS_REQUIRED', 'Review and accept the current 2% Vendor commission terms.', 422);
            }
            $this->acceptCommissionTerms($request, $organizationId);
            $this->setStep($organizationId, 'STORE_SETUP', 'public_store_profile', 'COMPLETED');
            $this->setStep($organizationId, 'STORE_SETUP', 'bulk_capability', 'COMPLETED');
            $this->setStep($organizationId, 'STORE_SETUP', 'fulfillment_method', 'COMPLETED');
            $this->setStep($organizationId, 'STORE_SETUP', 'payment_connection', 'COMPLETED');
            $this->setStep($organizationId, 'STORE_SETUP', 'commission_terms', 'COMPLETED');
            if ($profile->fulfillment_method === 'SELF_PICKUP') {
                $this->setStep($organizationId, 'STORE_SETUP', 'delivery_configuration', 'NOT_APPLICABLE', 'Vendor selected Self-Pickup only.');
            } else {
                $this->setStep($organizationId, 'STORE_SETUP', 'delivery_configuration', 'COMPLETED');
            }
            DB::table('store_profiles')->where('id', $profile->id)->update(['status' => 'COMPLETED', 'updated_at' => now()]);
            DB::table('vendor_organizations')->where('id', $organizationId)->update(['store_setup_status' => 'COMPLETED', 'lock_version' => (int) $organization->lock_version + 1, 'updated_at' => now()]);
            $this->claimIdempotency($request, 'VENDOR_STORE_SETUP_COMPLETE', $key, $organizationId, 200);
            $this->audit->account($request, 'VENDOR_STORE_SETUP_COMPLETED', 'VENDOR_ORGANIZATION', $organizationId, after: ['status' => 'COMPLETED']);
        });

        return $this->snapshot($request);
    }

    /** @return array<string, mixed> */
    public function dismissWelcome(Request $request): array
    {
        $this->requireVendorPermission($request, 'vendor.onboarding.manage');
        if ($this->vendorScope($request)['role'] !== 'OWNER') {
            throw new AuthenticationException('PERMISSION_DENIED', 'Only the Vendor Owner can dismiss onboarding welcome.', 403);
        }
        $organizationId = $this->organizationId($request);
        DB::table('vendor_organizations')->where('id', $organizationId)->update(['onboarding_welcome_dismissed_at' => now(), 'updated_at' => now()]);
        $this->audit->account($request, 'VENDOR_ONBOARDING_WELCOME_DISMISSED', 'VENDOR_ORGANIZATION', $organizationId);

        return $this->snapshot($request);
    }

    /** @return array<string, mixed> */
    public function geocode(float $latitude, float $longitude): array
    {
        $result = $this->geocoder->reverse($latitude, $longitude);
        if ($result === null) {
            return ['available' => false, 'fallback_required' => true, 'message' => 'Map address lookup is unavailable. Complete the structured address fields manually.'];
        }

        return ['available' => true, 'fallback_required' => false, 'address' => $result];
    }

    /** @return array<string, mixed> */
    public function requestStoreEmailVerification(Request $request, string $email): array
    {
        $this->requireVendorPermission($request, 'vendor.onboarding.manage');
        $organizationId = $this->organizationId($request);
        $email = mb_strtolower(trim($email));
        DB::table('vendor_organizations')->where('id', $organizationId)->update(['pending_store_email' => $email, 'pending_store_email_expires_at' => now()->addMinutes((int) config('materyalph.auth.otp_ttl_minutes', 10)), 'updated_at' => now()]);
        $otp = $this->otps->issue($email, 'VENDOR_STORE_EMAIL_VERIFICATION', $request->user());

        return ['sent' => true, 'expires_at' => $otp->expires_at->toIso8601String()];
    }

    /** @return array<string, mixed> */
    public function confirmStoreEmailVerification(Request $request, string $email, string $code): array
    {
        $this->requireVendorPermission($request, 'vendor.onboarding.manage');
        $organizationId = $this->organizationId($request);
        $normalizedEmail = mb_strtolower(trim($email));
        $organization = DB::table('vendor_organizations')->where('id', $organizationId)->first(['pending_store_email', 'pending_store_email_expires_at']);
        if ($organization === null || $organization->pending_store_email !== $normalizedEmail || $organization->pending_store_email_expires_at === null || now()->greaterThanOrEqualTo($organization->pending_store_email_expires_at)) {
            throw new AuthenticationException('OTP_INVALID_OR_EXPIRED', 'The code is invalid or expired.');
        }
        $otp = $this->otps->verify($normalizedEmail, 'VENDOR_STORE_EMAIL_VERIFICATION', $code);
        if ((string) $otp->user_id !== (string) $request->user()->getKey()) {
            throw new AuthenticationException('OTP_INVALID_OR_EXPIRED', 'The code is invalid or expired.');
        }
        $updated = DB::table('vendor_organizations')->where('id', $organizationId)->where('pending_store_email', $normalizedEmail)->where('pending_store_email_expires_at', '>', now())->update(['store_email' => $normalizedEmail, 'store_email_verified_at' => now(), 'pending_store_email' => null, 'pending_store_email_expires_at' => null, 'lock_version' => DB::raw('lock_version + 1'), 'updated_at' => now()]);
        if ($updated !== 1) {
            throw new AuthenticationException('OTP_INVALID_OR_EXPIRED', 'The code is invalid or expired.');
        }
        $status = DB::table('vendor_organizations')->where('id', $organizationId)->value('store_verification_status');
        if ($status === 'APPROVED') {
            $this->setStep($organizationId, 'STORE_VERIFICATION', 'business_information', 'IN_PROGRESS');
            DB::table('vendor_organizations')->where('id', $organizationId)->update(['store_verification_status' => 'IN_PROGRESS', 'updated_at' => now()]);
        }

        return $this->snapshot($request);
    }

    /**
     * @param  array<string, mixed>  $metadata
     * @return array<string, mixed>
     */
    public function uploadDocument(Request $request, UploadedFile $file, string $requirementKey, array $metadata = []): array
    {
        $this->requireVendorPermission($request, 'vendor.onboarding.private_documents');
        if (! isset(self::DOCUMENTS[$requirementKey])) {
            throw new AuthenticationException('DOCUMENT_TYPE_UNAVAILABLE', 'This evidence type is not available for Store Verification.', 422);
        }
        $organizationId = $this->organizationId($request);
        $maxKb = (int) config('materyalph.files.max_document_kb', 10240);
        if ($file->getSize() > $maxKb * 1024 || ! in_array(mb_strtolower((string) $file->getMimeType()), ['image/jpeg', 'image/png', 'application/pdf'], true)) {
            throw new AuthenticationException('FILE_VALIDATION_FAILED', 'Upload a JPG, PNG, or PDF within the allowed file size.', 422);
        }

        return DB::transaction(function () use ($request, $file, $requirementKey, $metadata, $organizationId): array {
            $step = DB::table('vendor_onboarding_steps')->where('vendor_organization_id', $organizationId)->where('section', 'STORE_VERIFICATION')->where('requirement_key', $requirementKey)->where('is_current', true)->first();
            if ($step === null) {
                throw new AuthenticationException('DOCUMENT_TYPE_UNAVAILABLE', 'This evidence requirement is unavailable.', 422);
            }
            $organization = DB::table('vendor_organizations')->where('id', $organizationId)->first(['business_type']);
            $taxVersionId = null;
            if ($requirementKey === 'tax_relief_evidence') {
                $taxProfile = DB::table('vendor_tax_profiles as p')
                    ->join('vendor_tax_profile_versions as v', 'v.id', '=', 'p.current_version_id')
                    ->where('p.vendor_organization_id', $organizationId)
                    ->first(['v.id as version_id', 'v.tax_details']);
                $taxDetails = $taxProfile === null ? [] : (is_string($taxProfile->tax_details) ? (json_decode($taxProfile->tax_details, true) ?: []) : (is_array($taxProfile->tax_details) ? $taxProfile->tax_details : []));
                if ($taxProfile === null || ! is_string($taxProfile->version_id) || ($taxDetails['tax_relief_claimed'] ?? null) !== true) {
                    throw new AuthenticationException('TAX_RELIEF_NOT_DECLARED', 'Declare the tax relief claim before uploading supporting evidence.', 422);
                }
                $taxVersionId = $taxProfile->version_id;
            }
            $document = DB::table('business_documents')->where('vendor_organization_id', $organizationId)->where('requirement_key', $requirementKey)->first();
            $documentId = $document === null ? (string) Str::uuid7() : (string) $document->id;
            $previous = $document === null ? null : DB::table('business_document_versions')->where('id', $document->current_version_id)->first();
            $documentType = $requirementKey === 'business_registration'
                ? $this->registrationEvidenceType($organization === null ? null : $organization->business_type)
                : ($requirementKey === 'identity_evidence' ? 'GOVERNMENT_ID' : $requirementKey);
            if ($document === null) {
                DB::table('business_documents')->insert(['id' => $documentId, 'vendor_organization_id' => $organizationId, 'onboarding_step_id' => $step->id, 'requirement_key' => $requirementKey, 'document_type' => $documentType, 'status' => 'IN_PROGRESS', 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);
            }
            $fileId = $this->storeUploadedFile($request, $file, $organizationId, 'BUSINESS_DOCUMENT');
            $versionId = (string) Str::uuid7();
            $version = ($previous === null ? 0 : (int) $previous->version) + 1;
            $checksum = hash_file('sha256', $file->getRealPath());
            DB::table('business_document_versions')->insert(['id' => $versionId, 'business_document_id' => $documentId, 'file_id' => $fileId, 'version' => $version, 'uploaded_by_user_id' => $request->user()->getKey(), 'content_hash' => $checksum, 'scan_state' => 'CLEAN', 'vendor_metadata' => $metadata === [] ? null : json_encode($this->safeMetadata($metadata), JSON_THROW_ON_ERROR), 'supersedes_version_id' => $previous === null ? null : $previous->id, 'submitted_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
            DB::table('business_documents')->where('id', $documentId)->update(['document_type' => $documentType, 'current_version_id' => $versionId, 'status' => 'IN_PROGRESS', 'lock_version' => DB::raw('lock_version + 1'), 'updated_at' => now()]);
            if ($requirementKey === 'tax_relief_evidence') {
                $safeMetadata = $this->safeMetadata($metadata);
                DB::table('tax_evidence')->insert(['id' => (string) Str::uuid7(), 'vendor_tax_profile_version_id' => $taxVersionId, 'file_id' => $fileId, 'evidence_type' => 'TAX_RELIEF_DECLARATION', 'origin' => 'VENDOR_UPLOAD', 'document_hash' => $checksum, 'valid_from' => $this->metadataDate($safeMetadata['valid_from'] ?? null), 'valid_until' => $this->metadataDate($safeMetadata['valid_until'] ?? null), 'review_state' => 'PENDING', 'created_at' => now(), 'updated_at' => now()]);
            }
            $this->setStep($organizationId, 'STORE_VERIFICATION', $requirementKey, 'IN_PROGRESS');
            $this->audit->account($request, 'VENDOR_EVIDENCE_UPLOADED', 'BUSINESS_DOCUMENT_VERSION', $versionId, after: ['requirement_key' => $requirementKey, 'version' => $version, 'scan_state' => 'CLEAN']);

            return ['id' => $versionId, 'requirement_key' => $requirementKey, 'version' => $version, 'scan_state' => 'CLEAN'];
        });
    }

    /** @return array<string, mixed> */
    public function uploadMedia(Request $request, UploadedFile $file, string $kind, ?string $altText = null): array
    {
        $this->requireVendorPermission($request, 'vendor.onboarding.manage');
        if (! in_array($kind, ['LOGO', 'BANNER', 'PROMOTIONAL_IMAGE', 'PROMOTIONAL_VIDEO'], true)) {
            throw new AuthenticationException('MEDIA_TYPE_UNAVAILABLE', 'This store-media type is unavailable.', 422);
        }
        $allowed = $kind === 'PROMOTIONAL_VIDEO' ? ['video/mp4'] : ['image/jpeg', 'image/png', 'image/webp'];
        if ($file->getSize() > (int) config('materyalph.files.max_media_kb', 20480) * 1024 || ! in_array(mb_strtolower((string) $file->getMimeType()), $allowed, true)) {
            throw new AuthenticationException('FILE_VALIDATION_FAILED', 'Upload an allowed store image or MP4 video within the allowed file size.', 422);
        }
        $organizationId = $this->organizationId($request);

        return DB::transaction(function () use ($request, $file, $kind, $altText, $organizationId): array {
            $profile = DB::table('store_profiles')->where('vendor_organization_id', $organizationId)->first();
            if ($profile === null) {
                throw new AuthenticationException('STORE_PROFILE_REQUIRED', 'Save the public store profile before uploading media.', 422);
            }
            $fileId = $this->storeUploadedFile($request, $file, $organizationId, 'STORE_MEDIA');
            $mediaId = (string) Str::uuid7();
            DB::table('store_media')->insert(['id' => $mediaId, 'store_profile_id' => $profile->id, 'file_id' => $fileId, 'kind' => $kind, 'alt_text' => $altText, 'sort_order' => 0, 'status' => 'READY', 'created_at' => now(), 'updated_at' => now()]);
            $update = $kind === 'LOGO' ? ['logo_file_id' => $fileId] : ($kind === 'BANNER' ? ['banner_file_id' => $fileId] : []);
            if ($update !== []) {
                DB::table('store_profiles')->where('id', $profile->id)->update($update + ['updated_at' => now()]);
            }
            $this->setStep($organizationId, 'STORE_SETUP', 'store_media', 'IN_PROGRESS');
            $this->audit->account($request, 'VENDOR_STORE_MEDIA_UPLOADED', 'STORE_MEDIA', $mediaId, after: ['kind' => $kind]);

            return ['id' => $mediaId, 'kind' => $kind, 'status' => 'READY'];
        });
    }

    /** @return array{url: string, expires_at: string} */
    public function signedFile(Request $request, string $fileId): array
    {
        $file = $this->authorizedFile($request, $fileId);
        $expires = now()->addMinutes(5);

        return ['url' => URL::temporarySignedRoute('vendor.onboarding.file-content', $expires, ['fileId' => $file->id]), 'expires_at' => $expires->toIso8601String()];
    }

    public function streamFile(Request $request, string $fileId): mixed
    {
        $file = $this->authorizedFile($request, $fileId);
        $stream = Storage::disk($this->disk())->readStream($file->object_key);
        if (! is_resource($stream)) {
            throw new AuthenticationException('FILE_UNAVAILABLE', 'The private file is temporarily unavailable.', 503);
        }

        return response()->streamDownload(static function () use ($stream): void {
            fpassthru($stream);
            fclose($stream);
        }, $file->original_name ?: 'private-evidence', ['Content-Type' => $file->content_type, 'Cache-Control' => 'private, no-store']);
    }

    /**
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function capturePaymentConnection(Request $request, array $input): array
    {
        $this->requireVendorPermission($request, 'vendor.payment.configure');
        if ($this->vendorScope($request)['role'] !== 'OWNER') {
            throw new AuthenticationException('PERMISSION_DENIED', 'Only the Vendor Owner can configure the payment connection.', 403);
        }
        $link = trim((string) ($input['invitation_url'] ?? ''));
        $accountId = trim((string) ($input['provider_account_id'] ?? ''));
        $parts = parse_url($link);
        $host = mb_strtolower(rtrim((string) ($parts['host'] ?? ''), '.'));
        $hostAllowed = preg_match('/(^|\.)xendit\.(?:co|com)$/i', $host) === 1;
        if ($link === '' || strlen($link) > 2048 || ($parts['scheme'] ?? null) !== 'https' || ! $hostAllowed || isset($parts['port'], $parts['user'], $parts['pass']) || $accountId === '' || ! preg_match('/^[A-Za-z0-9_-]{3,128}$/', $accountId)) {
            throw new AuthenticationException('PAYMENT_CONNECTION_INVALID', 'Enter the exact HTTPS Xendit invitation link and TEST sub-account ID.', 422);
        }
        $key = $this->requireIdempotencyKey($request);
        $organizationId = $this->organizationId($request);
        $masked = 'https://'.$host.'/…';
        DB::transaction(function () use ($request, $link, $accountId, $organizationId, $key, $masked): void {
            $organization = DB::table('vendor_organizations')->where('id', $organizationId)->lockForUpdate()->firstOrFail();
            if ($this->idempotent($request, 'VENDOR_PAYMENT_CONNECTION_CAPTURE', $key, $organizationId)) {
                return;
            }
            $existing = DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organizationId)->lockForUpdate()->first();
            $paymentId = $existing === null ? (string) Str::uuid7() : (string) $existing->id;
            $values = [
                'provider' => 'XENDIT', 'environment' => 'TEST', 'provider_account_id' => $accountId, 'connection_status' => 'PENDING',
                'invitation_url_encrypted' => Crypt::encryptString($link), 'invitation_url_hash' => hash_hmac('sha256', $link, (string) config('app.key')), 'invitation_url_masked' => $masked,
                'last_error_code' => null, 'lock_version' => ($existing === null ? 0 : (int) $existing->lock_version) + 1, 'updated_at' => now(),
            ];
            if ($existing === null) {
                DB::table('vendor_payment_accounts')->insert($values + ['id' => $paymentId, 'vendor_organization_id' => $organizationId, 'created_at' => now()]);
            } else {
                DB::table('vendor_payment_accounts')->where('id', $existing->id)->update($values);
            }
            $this->setStep($organizationId, 'STORE_SETUP', 'payment_connection', 'IN_PROGRESS');
            DB::table('vendor_organizations')->where('id', $organizationId)->update(['lock_version' => (int) $organization->lock_version + 1, 'updated_at' => now()]);
            $this->claimIdempotency($request, 'VENDOR_PAYMENT_CONNECTION_CAPTURE', $key, $organizationId, 200);
            $this->audit->account($request, 'VENDOR_PAYMENT_CONNECTION_CAPTURED', 'VENDOR_PAYMENT_ACCOUNT', $paymentId, after: ['provider' => 'XENDIT', 'environment' => 'TEST', 'provider_account_id' => $accountId, 'invitation_url' => 'REDACTED']);
        });

        return $this->snapshot($request);
    }

    /** @return array<string, mixed> */
    public function reconcilePaymentConnection(Request $request): array
    {
        $this->requireVendorPermission($request, 'vendor.payment.configure');
        if ($this->vendorScope($request)['role'] !== 'OWNER') {
            throw new AuthenticationException('PERMISSION_DENIED', 'Only the Vendor Owner can reconcile the payment connection.', 403);
        }
        $organizationId = $this->organizationId($request);
        $account = DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organizationId)->lockForUpdate()->first();
        if ($account === null || $account->provider_account_id === null) {
            throw new AuthenticationException('PAYMENT_CONNECTION_REQUIRED', 'Capture the Xendit TEST sub-account before reconciling it.', 422);
        }
        try {
            $result = $this->xendit->reconcile($account->provider_account_id);
        } catch (XenditProviderUnavailable) {
            DB::table('vendor_payment_accounts')->where('id', $account->id)->update(['connection_status' => 'PENDING', 'last_error_code' => 'PROVIDER_UNAVAILABLE', 'updated_at' => now()]);

            return ['status' => 'PENDING', 'provider_available' => false, 'message' => 'Xendit TEST reconciliation is unavailable. The connection remains unverified.'];
        }
        if ($result['provider_account_id'] !== $account->provider_account_id) {
            DB::table('vendor_payment_accounts')->where('id', $account->id)->update(['connection_status' => 'FAILED', 'last_error_code' => 'PROVIDER_ACCOUNT_MISMATCH', 'updated_at' => now()]);
            throw new AuthenticationException('PROVIDER_ACCOUNT_MISMATCH', 'The provider account does not match this Vendor organization.', 422);
        }
        $status = strtoupper($result['status']);
        $connection = in_array($status, ['PASSED', 'VERIFIED', 'ACTIVE'], true) ? 'CONNECTED' : (in_array($status, ['FAILED'], true) ? 'FAILED' : 'PENDING');
        DB::table('vendor_payment_accounts')->where('id', $account->id)->update(['connection_status' => $connection, 'provider_status' => $status, 'capabilities' => json_encode($this->safeMetadata($result['capabilities']), JSON_THROW_ON_ERROR), 'last_reconciled_at' => now(), 'last_error_code' => null, 'updated_at' => now()]);
        $this->setStep($organizationId, 'STORE_SETUP', 'payment_connection', $connection === 'CONNECTED' ? 'COMPLETED' : 'IN_PROGRESS');

        return ['status' => $connection, 'provider_status' => $status, 'provider_available' => true];
    }

    /**
     * @param  array<string, mixed>  $payload
     * @return array<string, mixed>
     */
    public function handleXenditWebhook(array $payload, ?string $verificationToken): array
    {
        $expected = config('services.xendit.webhook_token');
        if (! is_string($expected) || trim($expected) === '') {
            throw new AuthenticationException('WEBHOOK_NOT_CONFIGURED', 'The provider notification endpoint is not configured.', 503);
        }
        if (! hash_equals($expected, (string) $verificationToken)) {
            throw new AuthenticationException('WEBHOOK_INVALID', 'The provider notification could not be verified.', 401);
        }
        $eventId = $payload['id'] ?? null;
        $accountId = $payload['for_user_id'] ?? $payload['account_id'] ?? $payload['subaccount_id'] ?? null;
        $status = $payload['status'] ?? $payload['verification_status'] ?? null;
        if (! is_string($eventId) || ! is_string($accountId) || ! is_string($status)) {
            throw new AuthenticationException('WEBHOOK_INVALID', 'The provider notification is incomplete.', 422);
        }
        if (DB::table('webhook_events')->where('provider', 'XENDIT')->where('provider_event_id', $eventId)->exists()) {
            return ['accepted' => true, 'duplicate' => true];
        }
        DB::transaction(function () use ($eventId, $accountId, $status, $payload): void {
            DB::table('webhook_events')->insert(['id' => (string) Str::uuid7(), 'provider' => 'XENDIT', 'provider_event_id' => $eventId, 'payload_hash' => hash('sha256', json_encode($payload, JSON_THROW_ON_ERROR)), 'state' => 'RECEIVED', 'created_at' => now(), 'updated_at' => now()]);
            $account = DB::table('vendor_payment_accounts')->where('provider', 'XENDIT')->where('environment', 'TEST')->where('provider_account_id', $accountId)->lockForUpdate()->first();
            if ($account === null) {
                return;
            }
            $connection = strtoupper($status) === 'PASSED' ? 'CONNECTED' : (strtoupper($status) === 'FAILED' ? 'FAILED' : 'PENDING');
            DB::table('vendor_payment_accounts')->where('id', $account->id)->update(['connection_status' => $connection, 'provider_status' => strtoupper($status), 'last_provider_event_at' => now(), 'updated_at' => now()]);
            $this->setStep((string) $account->vendor_organization_id, 'STORE_SETUP', 'payment_connection', $connection === 'CONNECTED' ? 'COMPLETED' : 'IN_PROGRESS');
            DB::table('webhook_events')->where('provider', 'XENDIT')->where('provider_event_id', $eventId)->update(['state' => 'PROCESSED', 'processed_at' => now(), 'updated_at' => now()]);
        });

        return ['accepted' => true, 'duplicate' => false];
    }

    /** @return array{ready: bool, status: string, blockers: list<array{key: string, reason: string}>} */
    public function readinessForOrganization(string $organizationId): array
    {
        $organization = DB::table('vendor_organizations')->where('id', $organizationId)->first();
        if ($organization === null) {
            return ['ready' => false, 'status' => 'NOT_READY', 'blockers' => [['key' => 'organization', 'reason' => 'Vendor organization is unavailable.']]];
        }
        $blockers = [];
        $verificationSteps = DB::table('vendor_onboarding_steps')->where('vendor_organization_id', $organizationId)->where('section', 'STORE_VERIFICATION')->where('is_current', true)->where('level', '!=', 'OPTIONAL')->get(['status']);
        $verificationComplete = $organization->store_verification_status === 'APPROVED'
            && $verificationSteps->isNotEmpty()
            && $verificationSteps->every(fn (object $step): bool => in_array($step->status, ['APPROVED', 'NOT_APPLICABLE'], true));
        if (! $verificationComplete) {
            $blockers[] = ['key' => 'store_verification', 'reason' => 'Mandatory Store Verification requirements are not approved.'];
        }
        $setupSteps = DB::table('vendor_onboarding_steps')->where('vendor_organization_id', $organizationId)->where('section', 'STORE_SETUP')->where('is_current', true)->where('level', '!=', 'OPTIONAL')->get(['status']);
        $setupComplete = $organization->store_setup_status === 'COMPLETED'
            && $setupSteps->isNotEmpty()
            && $setupSteps->every(fn (object $step): bool => in_array($step->status, ['COMPLETED', 'APPROVED', 'NOT_APPLICABLE'], true));
        if (! $setupComplete) {
            $blockers[] = ['key' => 'store_setup', 'reason' => 'Store Setup is not complete.'];
        }
        $profile = DB::table('store_profiles')->where('vendor_organization_id', $organizationId)->first(['fulfillment_method']);
        if ($profile !== null && in_array($profile->fulfillment_method, ['VENDOR_DELIVERY', 'BOTH'], true) && ! $this->vehicleConfigurationReady($organizationId)) {
            $blockers[] = ['key' => 'vehicle_configuration', 'reason' => 'Configure an active vehicle with a current delivery rate for Vendor Delivery.'];
        }
        $payment = DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organizationId)->first();
        if ($payment === null || $payment->environment !== 'TEST' || $payment->connection_status !== 'CONNECTED') {
            $blockers[] = ['key' => 'payment_connection', 'reason' => 'A confirmed Xendit TEST connection is required.'];
        }
        $commission = DB::table('agreement_acceptances as aa')->join('agreement_versions as av', 'av.id', '=', 'aa.agreement_version_id')->join('agreement_documents as ad', 'ad.id', '=', 'av.agreement_document_id')->where('aa.vendor_organization_id', $organizationId)->where('ad.code', 'VENDOR_COMMISSION_TEST')->where('av.version', 1)->exists();
        if (! $commission) {
            $blockers[] = ['key' => 'commission_terms', 'reason' => 'The current 2% Vendor commission terms have not been accepted.'];
        }
        if ($organization->activation_hold_code !== null) {
            $blockers[] = ['key' => 'activation_hold', 'reason' => (string) ($organization->activation_hold_reason ?? 'Activation is restricted.')];
        }
        $ready = $blockers === [];

        return ['ready' => $ready, 'status' => $ready ? 'READY' : 'NOT_READY', 'blockers' => $blockers];
    }

    /** @return array<string, mixed> */
    public function activate(Request $request): array
    {
        $this->requireVendorPermission($request, 'vendor.activation');
        if ($this->vendorScope($request)['role'] !== 'OWNER') {
            throw new AuthenticationException('PERMISSION_DENIED', 'Only the Vendor Owner can request activation.', 403);
        }
        $key = $this->requireIdempotencyKey($request);
        $organizationId = $this->organizationId($request);
        DB::transaction(function () use ($request, $key, $organizationId): void {
            $organization = DB::table('vendor_organizations')->where('id', $organizationId)->lockForUpdate()->first();
            if ($this->idempotent($request, 'VENDOR_ACTIVATION', $key, $organizationId)) {
                return;
            }
            $readiness = $this->readinessForOrganization($organizationId);
            if (! $readiness['ready']) {
                throw new AuthenticationException('ACTIVATION_NOT_READY', 'Activation is still blocked by the listed requirements.', 409, $readiness);
            }
            DB::table('vendor_organizations')->where('id', $organizationId)->update(['store_activation_status' => 'ACTIVE', 'lock_version' => (int) $organization->lock_version + 1, 'updated_at' => now()]);
            $this->recordActivation($organizationId, $organization->store_activation_status, 'ACTIVE', 'ACTIVATED', null, $readiness, $request->user()->getKey(), 'VENDOR');
            $this->claimIdempotency($request, 'VENDOR_ACTIVATION', $key, $organizationId, 200);
            $this->audit->account($request, 'VENDOR_ACTIVATED', 'VENDOR_ORGANIZATION', $organizationId, after: ['status' => 'ACTIVE', 'discoverability' => 'NOT_DISCOVERABLE']);
        });

        return $this->snapshot($request);
    }

    public function restrict(Request $request, string $organizationId, string $reason): void
    {
        $this->requireAdminPermission($request, 'vendor_verification.restrict');
        $key = $this->requireIdempotencyKey($request);
        DB::transaction(function () use ($request, $organizationId, $reason, $key): void {
            $organization = DB::table('vendor_organizations')->where('id', $organizationId)->lockForUpdate()->firstOrFail();
            if ($this->idempotent($request, 'ADMIN_VENDOR_RESTRICT', $key, $organizationId)) {
                return;
            }
            DB::table('vendor_organizations')->where('id', $organizationId)->update(['store_activation_status' => 'RESTRICTED', 'activation_hold_code' => 'ADMIN_RESTRICTION', 'activation_hold_reason' => $reason, 'lock_version' => (int) $organization->lock_version + 1, 'updated_at' => now()]);
            $this->recordActivation($organizationId, $organization->store_activation_status, 'RESTRICTED', 'RESTRICTED', $reason, $this->readinessForOrganization($organizationId), $request->user()->getKey(), 'ADMIN');
            $this->claimIdempotency($request, 'ADMIN_VENDOR_RESTRICT', $key, $organizationId, 200);
            $this->notifyOrganization($request, $organizationId, 'Store activation restricted', 'An Admin placed a restriction on Store activation. Review the reason in your onboarding dashboard.', 'VENDOR_ACTIVATION');
            $this->audit->account($request, 'VENDOR_ACTIVATION_RESTRICTED', 'VENDOR_ORGANIZATION', $organizationId, reason: $reason);
        });
    }

    public function restore(Request $request, string $organizationId, string $reason): void
    {
        $this->requireAdminPermission($request, 'vendor_verification.restrict');
        $key = $this->requireIdempotencyKey($request);
        DB::transaction(function () use ($request, $organizationId, $reason, $key): void {
            $organization = DB::table('vendor_organizations')->where('id', $organizationId)->lockForUpdate()->firstOrFail();
            if ($this->idempotent($request, 'ADMIN_VENDOR_RESTORE', $key, $organizationId)) {
                return;
            }
            $readiness = $this->readinessForOrganization($organizationId);
            if (! $readiness['ready']) {
                throw new AuthenticationException('ACTIVATION_NOT_READY', 'The Vendor still has activation blockers.', 409, $readiness);
            }
            DB::table('vendor_organizations')->where('id', $organizationId)->update(['store_activation_status' => 'READY', 'activation_hold_code' => null, 'activation_hold_reason' => null, 'lock_version' => (int) $organization->lock_version + 1, 'updated_at' => now()]);
            $this->recordActivation($organizationId, $organization->store_activation_status, 'READY', 'RESTORED', $reason, $readiness, $request->user()->getKey(), 'ADMIN');
            $this->claimIdempotency($request, 'ADMIN_VENDOR_RESTORE', $key, $organizationId, 200);
            $this->notifyOrganization($request, $organizationId, 'Store activation restriction restored', 'Your Store activation restriction was restored after Admin review.', 'VENDOR_ACTIVATION');
            $this->audit->account($request, 'VENDOR_ACTIVATION_RESTORED', 'VENDOR_ORGANIZATION', $organizationId, reason: $reason);
        });
    }

    private function ensureBlueprint(string $organizationId): void
    {
        $businessType = DB::table('vendor_organizations')->where('id', $organizationId)->value('business_type');
        $ownerEmail = DB::table('vendor_memberships as m')
            ->join('users as u', 'u.id', '=', 'm.user_id')
            ->where('m.vendor_organization_id', $organizationId)
            ->where('m.role', 'OWNER')
            ->where('m.status', 'ACTIVE')
            ->whereNotNull('u.email_verified_at')
            ->whereNotNull('u.email')
            ->value('u.email');
        if (is_string($ownerEmail) && trim($ownerEmail) !== '') {
            DB::table('vendor_organizations')
                ->where('id', $organizationId)
                ->whereNull('store_email')
                ->whereNull('pending_store_email')
                ->update(['store_email' => mb_strtolower(trim($ownerEmail)), 'store_email_verified_at' => now(), 'updated_at' => now()]);
        }
        if (! DB::table('vendor_contacts')->where('vendor_organization_id', $organizationId)->where('active', true)->exists()) {
            $owner = DB::table('vendor_memberships as m')
                ->join('users as u', 'u.id', '=', 'm.user_id')
                ->leftJoin('user_profiles as p', 'p.user_id', '=', 'u.id')
                ->where('m.vendor_organization_id', $organizationId)
                ->where('m.role', 'OWNER')
                ->where('m.status', 'ACTIVE')
                ->first(['u.name', 'u.email', 'p.mobile_e164']);
            if ($owner !== null) {
                DB::table('vendor_contacts')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'full_name' => (string) $owner->name, 'title' => 'Owner', 'email' => mb_strtolower((string) $owner->email), 'phone' => $owner->mobile_e164, 'is_primary' => true, 'is_public' => false, 'is_authorized' => true, 'active' => true, 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);
            }
        }
        foreach (self::STEP_CATALOG as $section => $requirements) {
            foreach ($requirements as $key => $definition) {
                if (! DB::table('vendor_onboarding_steps')->where('vendor_organization_id', $organizationId)->where('section', $section)->where('requirement_key', $key)->where('version', 1)->exists()) {
                    DB::table('vendor_onboarding_steps')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'section' => $section, 'requirement_key' => $key, 'level' => $definition['level'], 'status' => 'NOT_STARTED', 'source_version' => 'phase3.v1', 'version' => 1, 'is_current' => true, 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);
                }
            }
        }
        $this->ensureIdentitySteps($organizationId, is_string($businessType) ? $businessType : null);
        if (! DB::table('vendor_tax_profiles')->where('vendor_organization_id', $organizationId)->exists()) {
            DB::table('vendor_tax_profiles')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'environment' => 'TEST', 'status' => 'INCOMPLETE', 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);
        }
    }

    private function ensureIdentitySteps(string $organizationId, ?string $businessType): void
    {
        if ($businessType === null) {
            return;
        }
        $required = $this->individualIdentityRequired($businessType);
        foreach (self::IDENTITY_STEP_CATALOG as $key => $definition) {
            $step = DB::table('vendor_onboarding_steps')->where('vendor_organization_id', $organizationId)->where('section', 'STORE_VERIFICATION')->where('requirement_key', $key)->where('is_current', true)->first();
            if ($step === null && $required) {
                DB::table('vendor_onboarding_steps')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'section' => 'STORE_VERIFICATION', 'requirement_key' => $key, 'level' => $definition['level'], 'status' => 'NOT_STARTED', 'source_version' => 'phase3.v1', 'version' => 1, 'is_current' => true, 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);
            } elseif ($step !== null && ! $required && $step->status !== 'NOT_APPLICABLE') {
                DB::table('vendor_onboarding_steps')->where('id', $step->id)->update(['status' => 'NOT_APPLICABLE', 'applicability_reason' => 'Individual legal-identity evidence does not apply to this selected Business Type.', 'updated_at' => now()]);
            } elseif ($step !== null && $required && $step->status === 'NOT_APPLICABLE') {
                DB::table('vendor_onboarding_steps')->where('id', $step->id)->update(['status' => 'IN_PROGRESS', 'applicability_reason' => null, 'updated_at' => now()]);
            }
        }
    }

    /** @param array<string, mixed> $identity */
    private function saveLegalIdentity(Request $request, string $organizationId, array $identity): void
    {
        $organization = DB::table('vendor_organizations')->where('id', $organizationId)->first();
        if ($organization === null) {
            throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The Vendor organization is unavailable.', 404);
        }
        $current = $organization;
        $sameAsOwner = (bool) ($identity['same_as_owner'] ?? false);
        $surname = trim((string) ($identity['surname'] ?? ($current->individual_registered_surname ?? '')));
        $firstName = trim((string) ($identity['first_name'] ?? ($current->individual_registered_first_name ?? '')));
        $middleName = trim((string) ($identity['middle_name'] ?? ($current->individual_registered_middle_name ?? '')));
        $suffix = trim((string) ($identity['suffix'] ?? ($current->individual_registered_suffix ?? '')));
        if ($sameAsOwner) {
            $owner = DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->leftJoin('user_profiles as p', 'p.user_id', '=', 'u.id')->where('m.vendor_organization_id', $organizationId)->where('m.role', 'OWNER')->where('m.status', 'ACTIVE')->first(['u.name', 'p.full_name']);
            $ownerName = trim((string) ($owner->full_name ?? $owner->name ?? ''));
            $parts = array_values(array_filter(preg_split('/\s+/u', $ownerName) ?: [], static fn (string $part): bool => $part !== ''));
            if ($parts !== []) {
                $surname = (string) array_pop($parts);
                $firstName = implode(' ', $parts);
            }
        }
        $idNumber = trim((string) ($identity['id_number'] ?? ''));
        $values = [
            'individual_registered_surname' => $surname !== '' ? $surname : null,
            'individual_registered_first_name' => $firstName !== '' ? $firstName : null,
            'individual_registered_middle_name' => $middleName !== '' ? $middleName : null,
            'individual_registered_suffix' => $suffix !== '' ? $suffix : null,
            'company_registered_name' => array_key_exists('company_registered_name', $identity) ? (trim((string) $identity['company_registered_name']) !== '' ? trim((string) $identity['company_registered_name']) : null) : $current->company_registered_name,
            'legal_identity_same_as_owner' => $sameAsOwner,
            'identity_id_type' => array_key_exists('id_type', $identity) ? trim((string) $identity['id_type']) : $current->identity_id_type,
            'updated_at' => now(),
        ];
        if ($idNumber !== '') {
            $values['identity_id_number_encrypted'] = Crypt::encryptString($idNumber);
            $values['identity_id_number_last4'] = substr($idNumber, -4);
        }
        DB::table('vendor_organizations')->where('id', $organizationId)->update($values + ['lock_version' => DB::raw('lock_version + 1')]);
        $this->ensureIdentitySteps($organizationId, is_string($organization->business_type) ? $organization->business_type : null);
        if ($surname !== '' && $firstName !== '') {
            $this->setStep($organizationId, 'STORE_VERIFICATION', 'legal_identity', 'IN_PROGRESS');
        }
    }

    private function individualIdentityRequired(string $businessType): bool
    {
        return in_array($businessType, ['SOLE_PROPRIETORSHIP', 'ONE_PERSON_CORPORATION'], true);
    }

    /** @return array<string, mixed> */
    private function legalIdentity(object $organization): array
    {
        $businessType = (string) ($organization->business_type ?? '');

        return [
            'required' => $this->individualIdentityRequired($businessType),
            'company_required' => in_array($businessType, ['PARTNERSHIP', 'CORPORATION', 'ONE_PERSON_CORPORATION', 'COOPERATIVE'], true),
            'same_as_owner' => (bool) ($organization->legal_identity_same_as_owner ?? false),
            'surname' => $organization->individual_registered_surname ?? null,
            'first_name' => $organization->individual_registered_first_name ?? null,
            'middle_name' => $organization->individual_registered_middle_name ?? null,
            'suffix' => $organization->individual_registered_suffix ?? null,
            'company_registered_name' => ($organization->company_registered_name ?? '') !== '' ? $organization->company_registered_name : ($organization->registered_name ?? null),
            'id_type' => $organization->identity_id_type ?? null,
            'id_number_last4' => $organization->identity_id_number_last4 ?? null,
        ];
    }

    /** @return list<array<string, mixed>> */
    private function vehicles(string $organizationId): array
    {
        $rows = DB::table('vendor_vehicles')->where('vendor_organization_id', $organizationId)->orderBy('id')->get();
        if ($rows->isEmpty()) {
            return [];
        }
        $rates = DB::table('vehicle_rate_versions')->whereIn('vendor_vehicle_id', $rows->pluck('id')->all())->orderByDesc('version')->get()->groupBy('vendor_vehicle_id');

        return $rows->map(function (object $vehicle) use ($rates): array {
            $rate = $rates->get($vehicle->id)?->first();

            return [
                'id' => $vehicle->id,
                'vehicle_type' => $vehicle->vehicle_type,
                'name' => $vehicle->name,
                'capacity_kg' => (float) $vehicle->capacity_kg,
                'number_available' => (int) $vehicle->number_available,
                'cargo_length_m' => $vehicle->cargo_length_m === null ? null : (float) $vehicle->cargo_length_m,
                'cargo_width_m' => $vehicle->cargo_width_m === null ? null : (float) $vehicle->cargo_width_m,
                'cargo_height_m' => $vehicle->cargo_height_m === null ? null : (float) $vehicle->cargo_height_m,
                'heavy_classification' => $vehicle->heavy_classification,
                'image_file_id' => $vehicle->image_file_id,
                'rate_version' => $rate === null ? null : (int) $rate->version,
                'base_fee_centavos' => $rate === null ? null : (int) $rate->base_fee_centavos,
                'per_km_centavos' => $rate === null ? null : (int) $rate->per_km_centavos,
                'maximum_distance_km' => $rate === null ? null : (int) $rate->maximum_distance_km,
            ];
        })->all();
    }

    /**
     * @param  Collection<int, stdClass>  $steps
     * @return array<string, mixed>
     */
    private function section(string $key, string $label, Collection $steps, ?string $businessType = null): array
    {
        $rows = $steps->map(function (object $step) use ($businessType): array {
            $definition = self::STEP_CATALOG[$step->section][$step->requirement_key] ?? self::IDENTITY_STEP_CATALOG[$step->requirement_key] ?? null;
            $stepLabel = is_array($definition) ? $definition['label'] : $step->requirement_key;
            if ($step->requirement_key === 'business_registration') {
                $stepLabel = $this->registrationEvidenceLabel($businessType);
            }

            return ['key' => $step->requirement_key, 'label' => $stepLabel, 'level' => $step->level, 'status' => $step->status, 'applicability_reason' => $step->applicability_reason, 'version' => (int) $step->version, 'lock_version' => (int) $step->lock_version];
        })->all();
        $applicable = array_values(array_filter($rows, fn (array $row): bool => $row['level'] !== 'OPTIONAL' && $row['status'] !== 'NOT_APPLICABLE'));
        $done = count(array_filter($applicable, fn (array $row): bool => in_array($row['status'], ['APPROVED', 'COMPLETED'], true))) + count(array_filter($rows, fn (array $row): bool => $row['status'] === 'NOT_APPLICABLE'));

        return ['key' => $key, 'label' => $label, 'status' => $rows === [] ? 'NOT_STARTED' : (count($applicable) > 0 && $done >= count($applicable) ? 'COMPLETE' : 'IN_PROGRESS'), 'complete' => min($done, count($applicable)), 'total' => count($applicable), 'progress' => ['complete' => min($done, count($applicable)), 'total' => count($applicable)], 'steps' => $rows];
    }

    /** @param array<string, mixed> $contacts */
    private function saveContacts(string $organizationId, array $contacts): void
    {
        $primary = count(array_filter($contacts, fn ($contact): bool => is_array($contact) && (bool) ($contact['is_primary'] ?? false)));
        if ($contacts !== [] && $primary !== 1) {
            throw new AuthenticationException('PRIMARY_CONTACT_REQUIRED', 'Choose exactly one primary Vendor contact.', 422);
        }
        DB::table('vendor_contacts')->where('vendor_organization_id', $organizationId)->update(['active' => false, 'is_primary' => false, 'updated_at' => now()]);
        foreach ($contacts as $contact) {
            if (! is_array($contact)) {
                continue;
            }
            DB::table('vendor_contacts')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'full_name' => trim((string) ($contact['full_name'] ?? '')), 'title' => $contact['title'] ?? null, 'email' => isset($contact['email']) ? mb_strtolower(trim((string) $contact['email'])) : null, 'phone' => $contact['phone'] ?? null, 'is_primary' => (bool) ($contact['is_primary'] ?? false), 'is_public' => (bool) ($contact['is_public'] ?? false), 'is_authorized' => (bool) ($contact['is_authorized'] ?? false), 'active' => true, 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);
        }
    }

    /** @param array<string, mixed> $classification */
    private function saveClassification(string $organizationId, array $classification): void
    {
        $type = (string) ($classification['supplier_type'] ?? '');
        if (! in_array($type, self::SUPPLIER_TYPES, true)) {
            throw new AuthenticationException('CLASSIFICATION_INVALID', 'Choose an approved supplier type.', 422);
        }
        $niches = array_values(array_filter($classification['niches'] ?? [], 'is_string'));
        if (count($niches) > 20) {
            throw new AuthenticationException('CLASSIFICATION_INVALID', 'Choose no more than 20 supplier niches.', 422);
        }
        $labels = array_merge($niches, [$classification['custom_label'] ?? null]);
        $normalizedLabels = preg_replace('/[^a-z0-9]+/i', ' ', implode(' ', array_filter($labels, 'is_string')));
        if (is_string($normalizedLabels) && preg_match('/\brental\b/i', $normalizedLabels) === 1) {
            throw new AuthenticationException('CLASSIFICATION_UNSUPPORTED', 'Vehicle and equipment rental services are not currently supported by MateryalPH.', 422);
        }
        $existing = DB::table('vendor_classifications')->where('vendor_organization_id', $organizationId)->first();
        $values = ['supplier_type' => $type, 'niches' => json_encode($niches, JSON_THROW_ON_ERROR), 'custom_label' => $type === 'OTHER' ? trim((string) ($classification['custom_label'] ?? '')) : null, 'version' => ($existing === null ? 0 : (int) $existing->version) + 1, 'lock_version' => ($existing === null ? 0 : (int) $existing->lock_version) + 1, 'updated_at' => now()];
        if ($existing === null) {
            DB::table('vendor_classifications')->insert($values + ['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'created_at' => now()]);
        } else {
            DB::table('vendor_classifications')->where('id', $existing->id)->update($values);
        }
    }

    /** @param array<string, mixed> $address */
    private function saveAddress(string $organizationId, array $address): void
    {
        $values = ['street' => trim((string) ($address['street'] ?? '')), 'unit' => $address['unit'] ?? null, 'barangay' => trim((string) ($address['barangay'] ?? '')), 'city_municipality' => trim((string) ($address['city_municipality'] ?? '')), 'province' => trim((string) ($address['province'] ?? '')), 'postal_code' => trim((string) ($address['postal_code'] ?? '')), 'formatted_address' => trim((string) ($address['formatted_address'] ?? '')), 'latitude' => $address['latitude'] ?? null, 'longitude' => $address['longitude'] ?? null, 'psgc_code' => $address['psgc_code'] ?? null, 'provider_place_id' => $address['provider_place_id'] ?? null, 'source' => $address['source'] ?? 'MANUAL', 'provider' => $address['provider'] ?? null, 'review_state' => 'PENDING_REVIEW', 'verified' => false];
        $current = DB::table('addresses')->where('owner_type', 'VENDOR_ORGANIZATION')->where('owner_id', $organizationId)->where('is_current', true)->first();
        $same = $current !== null && collect(['street', 'unit', 'barangay', 'city_municipality', 'province', 'postal_code', 'formatted_address', 'latitude', 'longitude', 'provider_place_id'])->every(fn (string $key): bool => (string) ($current->{$key} ?? '') === (string) ($values[$key] ?? ''));
        if ($same) {
            return;
        }
        if ($current !== null) {
            DB::table('addresses')->where('id', $current->id)->update(['is_current' => false, 'updated_at' => now()]);
        }
        $id = (string) Str::uuid7();
        DB::table('addresses')->insert($values + ['id' => $id, 'owner_type' => 'VENDOR_ORGANIZATION', 'owner_id' => $organizationId, 'label' => 'Registered business address', 'version' => (int) ($current->version ?? 0) + 1, 'is_current' => true, 'created_at' => now(), 'updated_at' => now()]);
        if ($values['latitude'] !== null && $values['longitude'] !== null) {
            DB::statement('UPDATE addresses SET location = ST_SetSRID(ST_MakePoint(?, ?), 4326)::geography, geography_wkt = ? WHERE id = ?', [(float) $values['longitude'], (float) $values['latitude'], 'POINT('.$values['longitude'].' '.$values['latitude'].')', $id]);
        }
    }

    /** @param array<string, mixed> $tax */
    private function saveTaxProfile(Request $request, string $organizationId, array $tax): void
    {
        $ownerAttested = (bool) ($tax['owner_attested'] ?? false);
        if ($ownerAttested && $this->vendorScope($request)['role'] !== 'OWNER') {
            throw new AuthenticationException('PERMISSION_DENIED', 'Only the Vendor Owner can attest to the tax profile.', 403);
        }
        $profile = DB::table('vendor_tax_profiles')->where('vendor_organization_id', $organizationId)->first();
        if ($profile === null) {
            $profileId = (string) Str::uuid7();
            DB::table('vendor_tax_profiles')->insert(['id' => $profileId, 'vendor_organization_id' => $organizationId, 'environment' => 'TEST', 'status' => 'INCOMPLETE', 'created_at' => now(), 'updated_at' => now()]);
        } else {
            $profileId = (string) $profile->id;
        }
        $key = trim((string) ($tax['taxpayer_key'] ?? ''));
        $currentVersionId = $profile === null ? null : $profile->current_version_id;
        $current = $this->currentTaxVersion($currentVersionId);
        $previousTaxpayerKeyLast4 = $current === null ? null : $current->taxpayer_key_last4;
        $previousTinLast4 = $current === null ? null : $current->tin_last4;
        if ($key === '' && $current === null) {
            throw new AuthenticationException('TAXPAYER_KEY_REQUIRED', 'Enter the synthetic TEST taxpayer key.', 422);
        }
        $keyHash = $key === '' ? (string) ($current->taxpayer_key_hash ?? '') : hash_hmac('sha256', $key, (string) config('app.key'));
        $tin = trim((string) ($tax['tin'] ?? ''));
        $tinDigits = preg_replace('/\D+/', '', $tin) ?: '';
        if ($tin !== '' && ! in_array(strlen($tinDigits), [9, 12], true)) {
            throw new AuthenticationException('TIN_INVALID', 'Enter a valid 9- or 12-digit TIN, including the branch code where applicable.', 422);
        }
        $tinHash = $tin === '' ? (string) ($current->tin_hash ?? '') : hash_hmac('sha256', $tinDigits, (string) config('app.key'));
        $tinEncrypted = $tin === '' ? ($current->tin_encrypted ?? null) : Crypt::encryptString($tin);
        $branchCode = trim((string) ($tax['branch_code'] ?? ($current->tin_branch_code ?? '')));
        $birCorReference = trim((string) ($tax['bir_cor_reference'] ?? ($current->bir_cor_reference ?? '')));
        $currentDetails = $current === null ? [] : (is_string($current->tax_details) ? (json_decode($current->tax_details, true) ?: []) : (is_array($current->tax_details) ? $current->tax_details : []));
        $details = array_merge($currentDetails, $this->taxDetails($tax));
        $entityClass = (string) ($tax['entity_class'] ?? ($current->entity_class ?? 'INDIVIDUAL'));
        $registrationCategory = (string) ($tax['registration_category'] ?? ($current->registration_category ?? 'OTHER'));
        $vatCategory = (string) ($tax['vat_category'] ?? ($current->vat_category ?? 'NON_VAT'));
        $fiscalYearStartMonth = (int) ($tax['fiscal_year_start_month'] ?? ($current->fiscal_year_start_month ?? 1));
        $withholdingScenario = strtoupper(trim((string) ($tax['withholding_scenario'] ?? ($details['withholding_scenario'] ?? 'DEMO_PLATFORM_WITHHOLDER'))));
        if (! in_array($withholdingScenario, ['DEMO_PLATFORM_WITHHOLDER', 'DEMO_PROVIDER_WITHHOLDER'], true)) {
            throw new AuthenticationException('WITHHOLDING_SCENARIO_INVALID', 'Choose an approved DEMO withholding scenario.', 422);
        }
        $details['withholding_scenario'] = $withholdingScenario;
        $content = json_encode(['key_hash' => $keyHash, 'tin_hash' => $tinHash, 'tin_branch_code' => $branchCode, 'bir_cor_reference' => $birCorReference, 'entity_class' => $entityClass, 'registration_category' => $registrationCategory, 'vat_category' => $vatCategory, 'fiscal_year_start_month' => $fiscalYearStartMonth, 'details' => $details], JSON_THROW_ON_ERROR);
        if ($current !== null && hash_equals((string) $current->content_hash, hash('sha256', $content))) {
            if ($ownerAttested && $current->owner_attested_at === null) {
                $attestedAt = now();
                DB::table('vendor_tax_profile_versions')->where('id', $current->id)->update(['owner_attested_at' => $attestedAt, 'owner_attested_by_user_id' => $request->user()->getKey(), 'updated_at' => $attestedAt]);
                DB::table('vendor_tax_profiles')->where('id', $profileId)->update(['attested_at' => $attestedAt, 'attested_by_user_id' => $request->user()->getKey(), 'updated_at' => $attestedAt]);
            }

            return;
        }
        $version = ($current === null ? 0 : (int) $current->version) + 1;
        $versionId = (string) Str::uuid7();
        $attestedAt = $ownerAttested ? now() : null;
        DB::table('vendor_tax_profile_versions')->insert(['id' => $versionId, 'vendor_tax_profile_id' => $profileId, 'version' => $version, 'taxpayer_key_hash' => $keyHash, 'taxpayer_key_encrypted' => $key === '' ? ($current->taxpayer_key_encrypted ?? null) : Crypt::encryptString($key), 'entity_class' => $entityClass, 'registration_category' => $registrationCategory, 'vat_category' => $vatCategory, 'tin_encrypted' => $tinEncrypted, 'tin_hash' => $tinHash !== '' ? $tinHash : null, 'tin_branch_code' => $branchCode !== '' ? $branchCode : null, 'bir_cor_reference' => $birCorReference !== '' ? $birCorReference : null, 'vat_verified_category' => null, 'fiscal_year_start_month' => $fiscalYearStartMonth, 'effective_from' => now(), 'submitted_by_user_id' => $request->user()->getKey(), 'content_hash' => hash('sha256', $content), 'taxpayer_key_last4' => $key !== '' ? substr($key, -4) : $previousTaxpayerKeyLast4, 'tin_last4' => $tin !== '' ? substr($tinDigits, -4) : $previousTinLast4, 'tax_details' => json_encode($details, JSON_THROW_ON_ERROR), 'drafted_by_user_id' => $request->user()->getKey(), 'owner_attested_at' => $attestedAt, 'owner_attested_by_user_id' => $ownerAttested ? $request->user()->getKey() : null, 'created_at' => now(), 'updated_at' => now()]);
        $rule = DB::table('tax_rule_versions')->where('environment', 'DEMO')->where('code', $withholdingScenario)->where('version', 1)->first(['id', 'rules']);
        if ($rule === null) {
            throw new AuthenticationException('WITHHOLDING_RULE_UNAVAILABLE', 'The approved DEMO withholding fixture is unavailable.', 503);
        }
        $ruleValues = is_string($rule->rules) ? (json_decode($rule->rules, true) ?: []) : (is_array($rule->rules) ? $rule->rules : []);
        $rateBasisPoints = $ruleValues['rate_basis_points'] ?? null;
        if (! is_numeric($rateBasisPoints) || (int) $rateBasisPoints < 0) {
            throw new AuthenticationException('WITHHOLDING_RULE_INVALID', 'The approved DEMO withholding fixture is invalid.', 503);
        }
        DB::table('withholding_assignments')->insert(['id' => (string) Str::uuid7(), 'vendor_tax_profile_version_id' => $versionId, 'tax_rule_version_id' => $rule->id, 'atc_code' => null, 'rate_basis_points' => (int) $rateBasisPoints, 'effective_from' => now(), 'effective_until' => null, 'reason' => 'DEMO fixture selected during Vendor Onboarding; not evidence of LIVE withholding responsibility.', 'created_at' => now(), 'updated_at' => now()]);
        DB::table('vendor_tax_profiles')->where('id', $profileId)->update(['current_version_id' => $versionId, 'status' => 'INCOMPLETE', 'attested_at' => $attestedAt, 'attested_by_user_id' => $ownerAttested ? $request->user()->getKey() : null, 'updated_at' => now()]);
    }

    /**
     * @param  array<string, mixed>  $tax
     * @return array<string, mixed>
     */
    private function taxDetails(array $tax): array
    {
        $allowed = ['vat_declared', 'vat_verified', 'fiscal_year', 'taxable_year_start', 'taxable_year_end', 'prior_year_amount_centavos', 'declaration', 'declaration_type', 'threshold_position', 'submission_date', 'declaration_year', 'receipt_reference', 'valid_from', 'valid_until', 'outside_platform_amount_centavos', 'outside_platform_period', 'outside_platform_as_of', 'outside_platform_overlap', 'withholding_scenario', 'tax_relief_claimed'];
        $details = array_intersect_key($tax, array_flip($allowed));
        foreach (['prior_year_amount_centavos', 'outside_platform_amount_centavos'] as $key) {
            if (array_key_exists($key, $details)) {
                $details[$key] = (int) $details[$key];
            }
        }

        return $details;
    }

    private function currentTaxVersion(?string $versionId): ?object
    {
        if ($versionId === null) {
            return null;
        }

        return DB::table('vendor_tax_profile_versions')->where('id', $versionId)->first();
    }

    private function registrationEvidenceType(?string $businessType): string
    {
        return self::REGISTRATION_EVIDENCE_TYPES[$businessType ?? ''] ?? 'BUSINESS_REGISTRATION';
    }

    private function registrationEvidenceLabel(?string $businessType): string
    {
        return match ($this->registrationEvidenceType($businessType)) {
            'DTI_BUSINESS_NAME_REGISTRATION' => 'DTI business name registration',
            'SEC_REGISTRATION' => 'SEC registration',
            'CDA_REGISTRATION' => 'CDA registration',
            default => 'Business registration evidence',
        };
    }

    private function metadataDate(mixed $value): ?string
    {
        if (! is_string($value) || preg_match('/^\d{4}-\d{2}-\d{2}$/', $value) !== 1) {
            return null;
        }

        return $value;
    }

    private function markDraftProgress(string $organizationId): void
    {
        $organization = DB::table('vendor_organizations')->where('id', $organizationId)->first();
        if ($organization !== null && $organization->business_type !== null) {
            $this->setStep($organizationId, 'STORE_VERIFICATION', 'business_type', 'IN_PROGRESS');
        }
        if ($organization !== null && $organization->registered_name !== null && $organization->date_established !== null && $organization->store_email !== null && $organization->store_phone !== null) {
            $this->setStep($organizationId, 'STORE_VERIFICATION', 'business_information', 'IN_PROGRESS');
        }
        if (DB::table('addresses')->where('owner_type', 'VENDOR_ORGANIZATION')->where('owner_id', $organizationId)->where('is_current', true)->exists()) {
            $this->setStep($organizationId, 'STORE_VERIFICATION', 'registered_business_address', 'IN_PROGRESS');
        }
        if (DB::table('vendor_classifications')->where('vendor_organization_id', $organizationId)->exists()) {
            $this->setStep($organizationId, 'STORE_VERIFICATION', 'supplier_classification', 'IN_PROGRESS');
        }
        if ($organization !== null && $this->individualIdentityRequired((string) ($organization->business_type ?? '')) && $organization->individual_registered_surname !== null && $organization->individual_registered_first_name !== null) {
            $this->setStep($organizationId, 'STORE_VERIFICATION', 'legal_identity', 'IN_PROGRESS');
        }
        $taxVersion = DB::table('vendor_tax_profiles as p')->join('vendor_tax_profile_versions as v', 'v.id', '=', 'p.current_version_id')->where('p.vendor_organization_id', $organizationId)->first(['v.tax_details']);
        if ($taxVersion !== null) {
            $taxDetails = is_string($taxVersion->tax_details) ? (json_decode($taxVersion->tax_details, true) ?: []) : (is_array($taxVersion->tax_details) ? $taxVersion->tax_details : []);
            $this->setStep($organizationId, 'STORE_VERIFICATION', 'tax_profile', 'IN_PROGRESS');
            if (array_key_exists('tax_relief_claimed', $taxDetails) && (bool) $taxDetails['tax_relief_claimed']) {
                $this->setStep($organizationId, 'STORE_VERIFICATION', 'tax_relief_evidence', 'IN_PROGRESS');
            } elseif (array_key_exists('tax_relief_claimed', $taxDetails)) {
                $this->setStep($organizationId, 'STORE_VERIFICATION', 'tax_relief_evidence', 'NOT_APPLICABLE', 'No tax relief is claimed; applicable withholding remains governed by the approved tax rules.');
            }
        }
    }

    private function requireVerificationCompleteness(Request $request, string $organizationId, bool $privacyAcknowledged): void
    {
        $organization = DB::table('vendor_organizations')->where('id', $organizationId)->first();
        if ($organization === null) {
            throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The Vendor organization is unavailable.', 404);
        }
        $blockers = [];
        if (! $privacyAcknowledged && ! $this->privacyNoticeAccepted($request, $organizationId)) {
            $blockers[] = ['key' => 'privacy_acknowledgement', 'reason' => 'Acknowledge the Privacy Notice before submission.'];
        }
        foreach (['business_type' => $organization->business_type, 'registered_name' => $organization->registered_name, 'date_established' => $organization->date_established, 'store_email' => $organization->store_email, 'store_email_verified_at' => $organization->store_email_verified_at, 'store_phone' => $organization->store_phone] as $key => $value) {
            if ($value === null || $value === '') {
                $blockers[] = ['key' => $key, 'reason' => 'Complete this required business-information field.'];
            }
        }
        if ($organization->date_established !== null && $organization->date_established > now()->toDateString()) {
            $blockers[] = ['key' => 'date_established', 'reason' => 'The establishment date cannot be in the future.'];
        }
        $address = DB::table('addresses')->where('owner_type', 'VENDOR_ORGANIZATION')->where('owner_id', $organizationId)->where('is_current', true)->first();
        foreach (['street', 'barangay', 'city_municipality', 'province', 'postal_code', 'latitude', 'longitude'] as $key) {
            if ($address === null || $address->{$key} === null || $address->{$key} === '') {
                $blockers[] = ['key' => 'registered_business_address.'.$key, 'reason' => 'Complete the structured address and map coordinates.'];
            }
        }
        if (! DB::table('vendor_contacts')->where('vendor_organization_id', $organizationId)->where('active', true)->where('is_primary', true)->exists()) {
            $blockers[] = ['key' => 'contacts', 'reason' => 'Add exactly one primary Vendor contact.'];
        }
        if (! DB::table('vendor_classifications')->where('vendor_organization_id', $organizationId)->exists()) {
            $blockers[] = ['key' => 'supplier_classification', 'reason' => 'Choose an approved supplier classification.'];
        }
        if ($this->individualIdentityRequired((string) $organization->business_type)) {
            foreach (['individual_registered_surname' => $organization->individual_registered_surname, 'individual_registered_first_name' => $organization->individual_registered_first_name, 'identity_id_type' => $organization->identity_id_type, 'identity_id_number_last4' => $organization->identity_id_number_last4] as $key => $value) {
                if ($value === null || $value === '') {
                    $blockers[] = ['key' => 'legal_identity.'.$key, 'reason' => 'Complete the registered individual identity and identification details.'];
                }
            }
        }
        $companyRegisteredName = trim((string) ($organization->company_registered_name ?: $organization->registered_name ?: ''));
        if (in_array((string) $organization->business_type, ['PARTNERSHIP', 'CORPORATION', 'ONE_PERSON_CORPORATION', 'COOPERATIVE'], true) && $companyRegisteredName === '') {
            $blockers[] = ['key' => 'legal_identity.company_registered_name', 'reason' => 'Complete the official company registered name shown on the applicable registration evidence.'];
        }
        $tax = DB::table('vendor_tax_profiles as p')->join('vendor_tax_profile_versions as v', 'v.id', '=', 'p.current_version_id')->where('p.vendor_organization_id', $organizationId)->first();
        $taxDetails = $tax === null ? [] : (is_string($tax->tax_details) ? (json_decode($tax->tax_details, true) ?: []) : (is_array($tax->tax_details) ? $tax->tax_details : []));
        if ($tax === null || ! is_string($tax->taxpayer_key_hash) || trim($tax->taxpayer_key_hash) === '' || $tax->tin_last4 === null || $tax->tin_last4 === '' || $tax->owner_attested_at === null) {
            $blockers[] = ['key' => 'tax_profile', 'reason' => 'Complete and attest the TEST taxpayer key and private TIN metadata as the Vendor Owner.'];
        }
        if (! array_key_exists('tax_relief_claimed', $taxDetails)) {
            $blockers[] = ['key' => 'tax_relief_claimed', 'reason' => 'Declare whether the Vendor is claiming tax relief; missing evidence never implies zero withholding.'];
        }
        $requiredDocuments = ['business_registration', 'lgu_permit', 'bir_cor'];
        if ($this->individualIdentityRequired((string) $organization->business_type)) {
            $requiredDocuments[] = 'identity_evidence';
        }
        if (($taxDetails['tax_relief_claimed'] ?? false) === true) {
            $requiredDocuments[] = 'tax_relief_evidence';
        }
        foreach ($requiredDocuments as $key) {
            $document = DB::table('business_documents as d')->join('business_document_versions as v', 'v.id', '=', 'd.current_version_id')->where('d.vendor_organization_id', $organizationId)->where('d.requirement_key', $key)->first(['d.document_type', 'v.scan_state']);
            $registrationTypeMatches = $key !== 'business_registration' || ($document !== null && $document->document_type === $this->registrationEvidenceType($organization->business_type));
            if ($document === null || $document->scan_state !== 'CLEAN' || ! $registrationTypeMatches) {
                $blockers[] = ['key' => $key, 'reason' => 'Upload a validated, clean evidence file.'];
            }
        }
        if ($blockers !== []) {
            throw new AuthenticationException('VERIFICATION_INCOMPLETE', 'Complete the highlighted Store Verification requirements before submitting.', 422, ['blockers' => $blockers]);
        }
    }

    private function acceptCommissionTerms(Request $request, string $organizationId): void
    {
        $row = DB::table('agreement_versions as v')->join('agreement_documents as d', 'd.id', '=', 'v.agreement_document_id')->where('d.code', 'VENDOR_COMMISSION_TEST')->where('v.version', 1)->whereNull('v.retired_at')->where('v.effective_at', '<=', now())->first(['v.id', 'v.content_hash']);
        if ($row === null) {
            throw new AuthenticationException('AGREEMENT_CONTENT_UNAVAILABLE', 'The current commission terms are unavailable.', 503);
        }
        if (! DB::table('agreement_acceptances')->where('user_id', $request->user()->getKey())->where('agreement_version_id', $row->id)->where('vendor_organization_id', $organizationId)->exists()) {
            DB::table('agreement_acceptances')->insert(['id' => (string) Str::uuid7(), 'user_id' => $request->user()->getKey(), 'agreement_version_id' => $row->id, 'vendor_organization_id' => $organizationId, 'source' => 'VENDOR_ONBOARDING', 'accepted_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
            $this->audit->account($request, 'VENDOR_COMMISSION_TERMS_ACCEPTED', 'AGREEMENT_VERSION', (string) $row->id, after: ['code' => 'VENDOR_COMMISSION_TEST', 'version' => 1]);
        }
    }

    private function privacyNoticeAccepted(Request $request, string $organizationId): bool
    {
        return DB::table('agreement_acceptances as aa')
            ->join('agreement_versions as av', 'av.id', '=', 'aa.agreement_version_id')
            ->join('agreement_documents as ad', 'ad.id', '=', 'av.agreement_document_id')
            ->where('aa.user_id', $request->user()->getKey())
            ->where('aa.vendor_organization_id', $organizationId)
            ->where('ad.code', 'PRIVACY_NOTICE')
            ->whereNull('av.retired_at')
            ->where('av.effective_at', '<=', now())
            ->exists();
    }

    private function acceptPrivacyNotice(Request $request, string $organizationId): void
    {
        $agreement = DB::table('agreement_versions as av')
            ->join('agreement_documents as ad', 'ad.id', '=', 'av.agreement_document_id')
            ->where('ad.code', 'PRIVACY_NOTICE')
            ->whereNull('av.retired_at')
            ->where('av.effective_at', '<=', now())
            ->orderByDesc('av.version')
            ->first(['av.id', 'av.version']);
        if ($agreement === null) {
            throw new AuthenticationException('PRIVACY_NOTICE_UNAVAILABLE', 'The current Privacy Notice is unavailable. Try again later.', 503);
        }
        $inserted = DB::table('agreement_acceptances')->insertOrIgnore([
            'id' => (string) Str::uuid7(),
            'user_id' => $request->user()->getKey(),
            'agreement_version_id' => $agreement->id,
            'vendor_organization_id' => $organizationId,
            'source' => 'VENDOR_ONBOARDING',
            'accepted_at' => now(),
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        if ($inserted === 1) {
            $this->audit->account($request, 'VENDOR_PRIVACY_NOTICE_ACKNOWLEDGED', 'AGREEMENT_VERSION', (string) $agreement->id, after: ['code' => 'PRIVACY_NOTICE', 'version' => (int) $agreement->version]);
        }
    }

    /** @param array<string, mixed> $delivery */
    private function saveDelivery(string $organizationId, array $delivery): void
    {
        $distance = (int) ($delivery['maximum_distance_km'] ?? 0);
        if ($distance < 1 || $distance > 1000) {
            throw new AuthenticationException('DELIVERY_CONFIGURATION_INVALID', 'Choose a delivery distance between 1 and 1000 km.', 422);
        }
        $existing = DB::table('delivery_service_areas')->where('vendor_organization_id', $organizationId)->first();
        $values = ['area_type' => 'RADIUS', 'maximum_distance_km' => $distance, 'coverage_notes' => $delivery['coverage_notes'] ?? null, 'active' => true, 'version' => ($existing === null ? 0 : (int) $existing->version) + 1, 'lock_version' => ($existing === null ? 0 : (int) $existing->lock_version) + 1, 'updated_at' => now()];
        if ($existing === null) {
            DB::table('delivery_service_areas')->insert($values + ['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'created_at' => now()]);
        } else {
            DB::table('delivery_service_areas')->where('id', $existing->id)->update($values);
        }
    }

    /** @param array<int, mixed> $vehicles */
    private function saveVehicles(string $organizationId, array $vehicles): void
    {
        $deliveryDistance = DB::table('delivery_service_areas')
            ->where('vendor_organization_id', $organizationId)
            ->where('active', true)
            ->value('maximum_distance_km');
        $centavos = static function (mixed $value): ?int {
            if (is_int($value)) {
                return $value >= 0 ? $value : null;
            }
            if ((! is_string($value) && ! is_float($value)) || ! is_numeric($value) || ! is_finite((float) $value) || floor((float) $value) !== (float) $value || (float) $value < 0) {
                return null;
            }

            return (int) $value;
        };
        foreach ($vehicles as $vehicle) {
            if (! is_array($vehicle)) {
                throw new AuthenticationException('VEHICLE_CONFIGURATION_INVALID', 'Each vehicle must be a structured configuration.', 422);
            }
            $hasId = isset($vehicle['id']) && trim((string) $vehicle['id']) !== '';
            $id = $hasId ? (string) $vehicle['id'] : (string) Str::uuid7();
            $existing = $hasId ? DB::table('vendor_vehicles')->where('id', $id)->lockForUpdate()->first() : null;
            if ($hasId && ($existing === null || (string) $existing->vendor_organization_id !== $organizationId)) {
                throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The requested vehicle configuration is unavailable.', 404);
            }
            $vehicleType = trim((string) ($vehicle['vehicle_type'] ?? ''));
            $name = trim((string) ($vehicle['name'] ?? ''));
            $capacity = $vehicle['capacity_kg'] ?? null;
            $numberAvailable = $vehicle['number_available'] ?? null;
            if ($vehicleType === '' || $name === '' || ! is_numeric($capacity) || ! is_finite((float) $capacity) || (float) $capacity <= 0 || ! is_numeric($numberAvailable) || ! is_finite((float) $numberAvailable) || floor((float) $numberAvailable) !== (float) $numberAvailable || (int) $numberAvailable < 1) {
                throw new AuthenticationException('VEHICLE_CONFIGURATION_INVALID', 'Provide a vehicle type, name, positive capacity, and at least one available vehicle.', 422);
            }
            $dimensions = [];
            foreach (['cargo_length_m', 'cargo_width_m', 'cargo_height_m'] as $dimension) {
                $value = $vehicle[$dimension] ?? null;
                if ($value === null || $value === '') {
                    $dimensions[$dimension] = null;

                    continue;
                }
                if (! is_numeric($value) || ! is_finite((float) $value) || (float) $value <= 0 || (float) $value > 1000) {
                    throw new AuthenticationException('VEHICLE_CONFIGURATION_INVALID', 'Vehicle dimensions must be positive values within the supported range.', 422);
                }
                $dimensions[$dimension] = (float) $value;
            }
            $values = ['vehicle_type' => $vehicleType, 'name' => $name, 'capacity_kg' => (float) $capacity, 'number_available' => (int) $numberAvailable, 'cargo_length_m' => $dimensions['cargo_length_m'], 'cargo_width_m' => $dimensions['cargo_width_m'], 'cargo_height_m' => $dimensions['cargo_height_m'], 'heavy_classification' => isset($vehicle['heavy_classification']) ? trim((string) $vehicle['heavy_classification']) : null, 'active' => true, 'lock_version' => ($existing === null ? 0 : (int) $existing->lock_version) + 1, 'updated_at' => now()];
            if ($existing === null) {
                DB::table('vendor_vehicles')->insert($values + ['id' => $id, 'vendor_organization_id' => $organizationId, 'created_at' => now()]);
            } else {
                DB::table('vendor_vehicles')->where('id', $id)->update($values);
            }

            $rateKeys = ['base_fee_centavos', 'per_km_centavos', 'maximum_distance_km'];
            $rateProvided = count(array_intersect($rateKeys, array_keys($vehicle))) > 0;
            if ($rateProvided) {
                $currentRate = DB::table('vehicle_rate_versions')->where('vendor_vehicle_id', $id)->orderByDesc('version')->lockForUpdate()->first();
                $baseFee = $centavos(array_key_exists('base_fee_centavos', $vehicle) ? $vehicle['base_fee_centavos'] : ($currentRate === null ? null : $currentRate->base_fee_centavos));
                $perKm = $centavos(array_key_exists('per_km_centavos', $vehicle) ? $vehicle['per_km_centavos'] : ($currentRate === null ? null : $currentRate->per_km_centavos));
                $maximumDistance = array_key_exists('maximum_distance_km', $vehicle) ? $vehicle['maximum_distance_km'] : ($currentRate === null ? $deliveryDistance : ($currentRate->maximum_distance_km ?? $deliveryDistance));
                if ($baseFee === null || $perKm === null || ! is_numeric($maximumDistance) || ! is_finite((float) $maximumDistance) || floor((float) $maximumDistance) !== (float) $maximumDistance || (int) $maximumDistance < 1 || (int) $maximumDistance > 1000) {
                    throw new AuthenticationException('VEHICLE_RATE_INCOMPLETE', 'Provide non-negative base and per-kilometer fees and a delivery distance between 1 and 1000 km.', 422);
                }
                if ($currentRate === null || (int) $currentRate->base_fee_centavos !== $baseFee || (int) $currentRate->per_km_centavos !== $perKm || (int) $currentRate->maximum_distance_km !== (int) $maximumDistance) {
                    DB::table('vehicle_rate_versions')->insert(['id' => (string) Str::uuid7(), 'vendor_vehicle_id' => $id, 'version' => ($currentRate === null ? 0 : (int) $currentRate->version) + 1, 'base_fee_centavos' => $baseFee, 'per_km_centavos' => $perKm, 'maximum_distance_km' => (int) $maximumDistance, 'effective_at' => now()]);
                }
            }
        }
    }

    private function vehicleConfigurationReady(string $organizationId): bool
    {
        return DB::table('vendor_vehicles as vehicle')
            ->join('vehicle_rate_versions as rate', 'rate.vendor_vehicle_id', '=', 'vehicle.id')
            ->where('vehicle.vendor_organization_id', $organizationId)
            ->where('vehicle.active', true)
            ->where('vehicle.number_available', '>', 0)
            ->where('vehicle.capacity_kg', '>', 0)
            ->where('rate.base_fee_centavos', '>=', 0)
            ->where('rate.per_km_centavos', '>=', 0)
            ->where('rate.maximum_distance_km', '>', 0)
            ->where('rate.effective_at', '<=', now())
            ->exists();
    }

    private function storeUploadedFile(Request $request, UploadedFile $file, string $organizationId, string $purpose): string
    {
        $fileId = (string) Str::uuid7();
        $extension = Str::lower($file->guessExtension() ?: 'bin');
        $objectKey = 'private/vendors/'.$organizationId.'/onboarding/'.$fileId.'.'.$extension;
        if (! Storage::disk($this->disk())->putFileAs('', $file, $objectKey)) {
            throw new AuthenticationException('FILE_STORAGE_UNAVAILABLE', 'The private file could not be stored. Try again.', 503);
        }
        $metadata = ['source' => 'VENDOR_ONBOARDING', 'purpose' => $purpose];
        DB::table('files')->insert(['id' => $fileId, 'owner_type' => 'VENDOR_ORGANIZATION', 'owner_id' => $organizationId, 'purpose' => $purpose, 'visibility' => 'PRIVATE', 'content_type' => (string) $file->getMimeType(), 'byte_size' => (int) $file->getSize(), 'checksum_sha256' => hash_file('sha256', $file->getRealPath()), 'scan_state' => 'CLEAN', 'object_key' => $objectKey, 'retention_class' => 'VENDOR_ONBOARDING', 'original_name' => $file->getClientOriginalName(), 'uploaded_by_user_id' => $request->user()->getKey(), 'metadata' => json_encode($metadata, JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);

        return $fileId;
    }

    private function authorizedFile(Request $request, string $fileId): object
    {
        $scope = $this->access->resolve($request->user());
        $query = DB::table('files as f')->join('business_document_versions as v', 'v.file_id', '=', 'f.id')->join('business_documents as d', 'd.id', '=', 'v.business_document_id')->where('f.id', $fileId);
        if ($request->user()->account_type === 'VENDOR') {
            if (! in_array('vendor.onboarding.private_documents', $scope['permissions'], true)) {
                throw new AuthenticationException('PERMISSION_DENIED', 'You cannot access private onboarding evidence.', 403);
            }
            $query->where('d.vendor_organization_id', $scope['organization_id']);
        } elseif ($request->user()->account_type === 'ADMIN') {
            if (! in_array('vendor_verification.view_private_documents', $scope['permissions'], true)) {
                throw new AuthenticationException('PERMISSION_DENIED', 'You cannot access private Vendor evidence.', 403);
            }
        } else {
            throw new AuthenticationException('PERMISSION_DENIED', 'You cannot access private onboarding evidence.', 403);
        }
        $file = $query->first(['f.id', 'f.object_key', 'f.original_name', 'f.content_type']);
        if ($file === null) {
            throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The private file is unavailable.', 404);
        }

        return $file;
    }

    private function setStep(string $organizationId, string $section, string $key, string $status, ?string $reason = null): void
    {
        DB::table('vendor_onboarding_steps')->where('vendor_organization_id', $organizationId)->where('section', $section)->where('requirement_key', $key)->where('is_current', true)->update(['status' => $status, 'applicability_reason' => $reason, 'updated_at' => now()]);
    }

    /** @param array<string, mixed> $readiness */
    private function recordActivation(string $organizationId, ?string $before, string $after, string $result, ?string $reason, array $readiness, ?int $actorId, string $source): void
    {
        DB::table('vendor_activation_history')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'state_before' => $before, 'state_after' => $after, 'result' => $result, 'reason' => $reason, 'blockers' => json_encode($readiness['blockers'], JSON_THROW_ON_ERROR), 'readiness_snapshot' => json_encode($readiness, JSON_THROW_ON_ERROR), 'actor_user_id' => $actorId, 'source' => $source, 'recorded_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
    }

    private function notifyOrganization(Request $request, string $organizationId, string $title, string $body, string $category): void
    {
        $owner = DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->where('m.vendor_organization_id', $organizationId)->where('m.role', 'OWNER')->where('m.status', 'ACTIVE')->first(['u.id', 'u.email', 'u.public_id']);
        if ($owner === null) {
            return;
        }
        $notificationId = (string) Str::uuid7();
        DB::table('notifications')->insert(['id' => $notificationId, 'user_id' => $owner->id, 'category' => $category, 'title' => $title, 'body' => $body, 'resource_type' => 'VENDOR_ORGANIZATION', 'resource_id' => $organizationId, 'created_at' => now(), 'updated_at' => now()]);
        $this->outbox->publish('VENDOR_ONBOARDING_NOTICE', 'VENDOR_ORGANIZATION', $organizationId, ['recipient' => $owner->email, 'message' => $body, 'notification_id' => $notificationId]);
    }

    /** @return array{role: string, organization_id: string, membership_id: ?string, can_manage_staff: bool, permissions: list<string>} */
    private function vendorScope(Request $request): array
    {
        $scope = $request->attributes->get('account_scope');
        if (! is_array($scope) || ! is_string($scope['organization_id'] ?? null)) {
            throw new AuthenticationException('PORTAL_ACCESS_DENIED', 'This account cannot access Vendor onboarding.', 403);
        }

        return $scope;
    }

    private function organizationId(Request $request): string
    {
        return $this->vendorScope($request)['organization_id'];
    }

    private function requireVendorPermission(Request $request, string $permission): void
    {
        $this->vendorScope($request);
        if (! $this->access->allows($request->user(), $permission)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'This Vendor action is not available to your role.', 403);
        }
    }

    private function requireAdminPermission(Request $request, string $permission): void
    {
        $scope = $request->attributes->get('account_scope');
        if (! is_array($scope) || ! in_array($permission, $scope['permissions'] ?? [], true)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'This Admin action is not available to your role.', 403);
        }
    }

    private function assertVersion(?object $row, mixed $version): void
    {
        if ($row === null || ! is_numeric($version) || (int) $version !== (int) $row->lock_version) {
            throw new AuthenticationException('RESOURCE_VERSION_CONFLICT', 'This onboarding draft changed. Reload before saving.', 409);
        }
    }

    private function requireIdempotencyKey(Request $request): string
    {
        $key = $request->header('Idempotency-Key');
        if (! is_string($key) || ! Str::isUuid($key)) {
            throw new AuthenticationException('IDEMPOTENCY_KEY_REQUIRED', 'A unique request identifier is required.', 422);
        }

        return $key;
    }

    private function idempotent(Request $request, string $endpoint, string $key, string $organizationId): bool
    {
        $hash = hash_hmac('sha256', $endpoint.'|'.$organizationId.'|'.$request->getContent(), (string) config('app.key'));
        $record = DB::table('idempotency_records')->where('actor_user_id', $request->user()->getKey())->where('endpoint', $endpoint)->where('idempotency_key', $key)->first();
        if ($record === null) {
            return false;
        }
        if (! hash_equals((string) $record->request_hash, $hash) || ($record->expires_at !== null && now()->greaterThanOrEqualTo($record->expires_at))) {
            throw new AuthenticationException('IDEMPOTENCY_CONFLICT', 'Use a new request identifier for the changed or expired request.', 409);
        }

        return true;
    }

    private function claimIdempotency(Request $request, string $endpoint, string $key, string $organizationId, int $status): void
    {
        DB::table('idempotency_records')->insert(['id' => (string) Str::uuid7(), 'actor_user_id' => $request->user()->getKey(), 'endpoint' => $endpoint, 'idempotency_key' => $key, 'request_hash' => hash_hmac('sha256', $endpoint.'|'.$organizationId.'|'.$request->getContent(), (string) config('app.key')), 'response_status' => $status, 'expires_at' => now()->addDay(), 'created_at' => now(), 'updated_at' => now()]);
    }

    private function disk(): string
    {
        return (string) config('materyalph.files.disk', config('filesystems.default', 'local'));
    }

    /**
     * @param  array<string, mixed>  $metadata
     * @return array<string, mixed>
     */
    private function safeMetadata(array $metadata): array
    {
        return collect($metadata)->filter(fn ($value, $key): bool => preg_match('/^[A-Za-z0-9_.-]{1,64}$/', (string) $key) === 1 && (is_string($value) || is_int($value) || is_bool($value)))->all();
    }

    /** @return list<string> */
    private function jsonArray(mixed $value): array
    {
        if (is_array($value)) {
            return array_values(array_filter($value, 'is_string'));
        }
        $decoded = is_string($value) ? json_decode($value, true) : null;

        return is_array($decoded) ? array_values(array_filter($decoded, 'is_string')) : [];
    }

    /** @return array<string, mixed> */
    private function address(object $address): array
    {
        return ['id' => $address->id, 'street' => $address->street, 'unit' => $address->unit, 'barangay' => $address->barangay, 'city_municipality' => $address->city_municipality, 'province' => $address->province, 'postal_code' => $address->postal_code, 'formatted_address' => $address->formatted_address, 'latitude' => $address->latitude === null ? null : (float) $address->latitude, 'longitude' => $address->longitude === null ? null : (float) $address->longitude, 'source' => $address->source, 'provider' => $address->provider, 'provider_place_id' => $address->provider_place_id, 'review_state' => $address->review_state, 'version' => (int) $address->version];
    }

    /** @return array<string, mixed> */
    private function tax(object $tax): array
    {
        return ['status' => $tax->status, 'environment' => $tax->environment, 'version' => $tax->version === null ? null : (int) $tax->version, 'entity_class' => $tax->entity_class, 'registration_category' => $tax->registration_category, 'vat_category' => $tax->vat_category, 'vat_verified_category' => $tax->vat_verified_category, 'tin_branch_code' => $tax->tin_branch_code, 'bir_cor_reference' => $tax->bir_cor_reference, 'fiscal_year_start_month' => $tax->fiscal_year_start_month === null ? null : (int) $tax->fiscal_year_start_month, 'taxpayer_key_last4' => $tax->taxpayer_key_last4, 'tin_last4' => $tax->tin_last4, 'details' => is_string($tax->tax_details) ? (json_decode($tax->tax_details, true) ?: []) : (is_array($tax->tax_details) ? $tax->tax_details : []), 'owner_attested' => $tax->owner_attested_at !== null];
    }

    /** @return array<string, mixed> */
    private function payment(object $payment): array
    {
        return ['environment' => $payment->environment, 'provider' => $payment->provider, 'provider_account_id' => $payment->provider_account_id, 'connection_status' => $payment->connection_status, 'provider_status' => $payment->provider_status, 'capabilities' => is_string($payment->capabilities) ? (json_decode($payment->capabilities, true) ?: []) : ($payment->capabilities ?? []), 'invitation_url_masked' => $payment->invitation_url_masked, 'last_reconciled_at' => $payment->last_reconciled_at, 'last_error_code' => $payment->last_error_code, 'lock_version' => (int) $payment->lock_version];
    }
}
