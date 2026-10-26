<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Vendors\VerificationDraftProgress;
use Illuminate\Container\Container;
use Illuminate\Encryption\Encrypter;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\Facade;
use Illuminate\Translation\ArrayLoader;
use Illuminate\Translation\Translator;
use Illuminate\Validation\Factory;
use PHPUnit\Framework\TestCase;

final class VerificationDraftProgressTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();
        $container = new Container;
        Container::setInstance($container);
        $container->instance('validator', new Factory(new Translator(new ArrayLoader, 'en'), $container));
        $container->instance('encrypter', new Encrypter(random_bytes(32), 'AES-256-CBC'));
        Facade::clearResolvedInstances();
        Facade::setFacadeApplication($container);
    }

    protected function tearDown(): void
    {
        Facade::clearResolvedInstances();
        Facade::setFacadeApplication(null);
        Container::setInstance(null);
        parent::tearDown();
    }

    public function test_saved_business_and_manual_address_are_complete_without_admin_approval(): void
    {
        $state = $this->state();
        $result = (new VerificationDraftProgress)->formStatuses('vendor', $state, $this->source());
        foreach (['business_type', 'business_information', 'legal_identity', 'registered_business_address', 'supplier_classification', 'tax_profile'] as $key) {
            self::assertSame('COMPLETED', $result[$key], $key);
        }
        self::assertSame('NOT_APPLICABLE', $result['representative_identity']);
        self::assertSame('NOT_APPLICABLE', $result['tax_relief_evidence']);
        self::assertSame('NOT_STARTED', $result['business_registration']);
    }

    public function test_internal_taxpayer_key_is_not_a_vendor_form_requirement(): void
    {
        $state = $this->state();
        unset($state['taxpayer_key']);
        self::assertSame('COMPLETED', (new VerificationDraftProgress)->formStatuses('vendor', $state, $this->source())['tax_profile']);
    }

    public function test_tax_information_is_complete_without_owner_attestation(): void
    {
        $state = $this->state();
        unset($state['owner_attested']);
        self::assertSame('COMPLETED', (new VerificationDraftProgress)->formStatuses('vendor', $state, $this->source())['tax_profile']);
    }

    public function test_resolved_map_fields_match_independently_of_json_key_order(): void
    {
        $state = $this->state();
        $address = json_decode($state['address_payload'][0], true);
        $address['source'] = 'MAP';
        $resolved = array_reverse(array_diff_key($address, ['source' => true]), true);
        $address['resolution_token'] = Crypt::encryptString(json_encode(['organization_id' => 'vendor', 'expires_at' => time() + 1800, 'address' => $resolved], JSON_THROW_ON_ERROR));
        $state['address_payload'] = [json_encode($address, JSON_THROW_ON_ERROR)];
        $progress = new VerificationDraftProgress;
        self::assertSame('COMPLETED', $progress->formStatuses('vendor', $state, $this->source())['registered_business_address']);
        self::assertSame('IN_PROGRESS', $progress->formStatuses('other-vendor', $state, $this->source())['registered_business_address']);
        $address['street'] = 'Changed Street';
        $state['address_payload'] = [json_encode($address, JSON_THROW_ON_ERROR)];
        self::assertSame('IN_PROGRESS', $progress->formStatuses('vendor', $state, $this->source())['registered_business_address']);
    }

    public function test_invalid_draft_fields_and_unverified_email_never_count_as_complete(): void
    {
        $state = $this->state();
        $state['date_established'] = ['2999-01-01'];
        $state['tin'] = ['123'];
        $state['address_payload'] = ['{"source":"MANUAL","street":"Main Street","province":"Metro Manila","city_municipality":"Quezon City","barangay":"Sample","postal_code":"bad"}'];
        $result = (new VerificationDraftProgress)->formStatuses('vendor', $state, $this->source());
        foreach (['business_information', 'registered_business_address', 'tax_profile'] as $key) {
            self::assertSame('IN_PROGRESS', $result[$key], $key);
        }
        $state = $this->state();
        $state['store_email'] = ['replacement@example.test'];
        self::assertSame('IN_PROGRESS', (new VerificationDraftProgress)->formStatuses('vendor', $state, $this->source())['business_information']);
    }

    public function test_missing_or_modified_map_token_is_incomplete_and_bad_json_is_recoverable(): void
    {
        $state = $this->state();
        $address = json_decode($state['address_payload'][0], true);
        $address['source'] = 'MAP';
        $address['resolution_token'] = 'invalid-token';
        $state['address_payload'] = [json_encode($address, JSON_THROW_ON_ERROR)];
        self::assertSame('IN_PROGRESS', (new VerificationDraftProgress)->formStatuses('vendor', $state, $this->source())['registered_business_address']);
        $state['address_payload'] = ['not json'];
        self::assertNotSame('COMPLETED', (new VerificationDraftProgress)->formStatuses('vendor', $state, $this->source())['registered_business_address']);
    }

    public function test_pending_evidence_counts_until_removed_and_conditional_evidence_tracks_draft_choices(): void
    {
        $state = $this->state();
        $source = $this->source() + ['pending' => ['business_registration', 'identity_evidence']];
        self::assertSame('COMPLETED', (new VerificationDraftProgress)->formStatuses('vendor', $state, $source)['business_registration']);
        self::assertSame('NOT_STARTED', (new VerificationDraftProgress)->formStatuses('vendor', $state, $this->source())['business_registration']);
        $state['tax_relief_claimed'] = ['yes'];
        self::assertSame('NOT_STARTED', (new VerificationDraftProgress)->formStatuses('vendor', $state, $source)['tax_relief_evidence']);
        $state['custom_labels'] = ['Equipment rental'];
        $state['niches'] = ['Other Category'];
        self::assertSame('IN_PROGRESS', (new VerificationDraftProgress)->formStatuses('vendor', $state, $source)['supplier_classification']);
    }

    public function test_representative_details_need_current_authority_evidence_to_complete(): void
    {
        $state = $this->state();
        $state['business_type'] = ['CORPORATION'];
        foreach (['name' => 'Sample Signatory', 'position' => 'Director', 'email' => 'signatory@example.test', 'phone' => '09171234567', 'relationship' => 'DIRECTOR', 'id_type' => 'PASSPORT', 'id_number' => 'DEMO-ID'] as $key => $value) {
            $state['representative_'.$key] = [$value];
        }
        $progress = new VerificationDraftProgress;
        self::assertSame('IN_PROGRESS', $progress->formStatuses('vendor', $state, $this->source())['authority_to_act']);
        self::assertSame('COMPLETED', $progress->formStatuses('vendor', $state, $this->source() + ['pending' => ['authority_to_act']])['authority_to_act']);
        $state['authority_evidence_source'] = ['EXISTING_REGISTRATION_EVIDENCE'];
        $state['authority_evidence_version_id'] = ['current-registration'];
        self::assertSame('IN_PROGRESS', $progress->formStatuses('vendor', $state, $this->source())['authority_to_act']);
        self::assertSame('COMPLETED', $progress->formStatuses('vendor', $state, $this->source() + ['registration_versions' => ['current-registration']])['authority_to_act']);
    }

    /** @return array<string, list<string>> */
    private function state(): array
    {
        return ['business_type' => ['SOLE_PROPRIETORSHIP'], 'store_name' => ['Sample Supply'], 'date_established' => ['2020-01-01'],
            'store_email' => ['owner@example.test'], 'store_phone' => ['09171234567'], 'individual_surname' => ['Sample'], 'individual_first_name' => ['Owner'],
            'identity_id_type' => ['PASSPORT'], 'identity_id_number' => ['DEMO-ID'], 'taxpayer_key' => ['sample-taxpayer'], 'tin' => ['123-456-789-000'],
            'vat_category' => ['NON_VAT'], 'tax_relief_claimed' => ['no'], 'owner_attested' => ['on'], 'supplier_type' => ['RETAIL_HARDWARE_STORE'], 'niches' => ['Construction Materials'],
            'address_payload' => ['{"source":"MANUAL","street":"Main Street","province":"Metro Manila","city_municipality":"Quezon City","barangay":"Sample","postal_code":"1100"}']];
    }

    /** @return array<string, mixed> */
    private function source(): array
    {
        return ['organization' => ['store_email' => 'owner@example.test', 'store_email_verified_at' => '2020-01-01']];
    }
}
