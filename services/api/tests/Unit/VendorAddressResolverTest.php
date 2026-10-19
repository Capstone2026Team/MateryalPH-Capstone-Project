<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\PsgcDirectory;
use App\Domain\Vendors\PsgcProvider;
use App\Domain\Vendors\VendorAddressResolver;
use Illuminate\Container\Container;
use Illuminate\Encryption\Encrypter;
use Illuminate\Support\Facades\Facade;
use Illuminate\Translation\ArrayLoader;
use Illuminate\Translation\Translator;
use Illuminate\Validation\Factory;
use Illuminate\Validation\ValidationException;
use PHPUnit\Framework\TestCase;

final class VendorAddressResolverTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();
        $container = new Container;
        Container::setInstance($container);
        $container->instance('validator', new Factory(new Translator(new ArrayLoader, 'en')));
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

    private function directory(): PsgcDirectory
    {
        $provider = $this->createStub(PsgcProvider::class);
        $provider->method('list')->willReturnCallback(fn (string $path): array => match ($path) {
            'regions' => [['code' => '1300000000', 'name' => 'National Capital Region (NCR)']],
            'provinces' => [['code' => '1208000000', 'name' => 'Sarangani']],
            'cities-municipalities' => [['code' => '1381300000', 'name' => 'Quezon City', 'province' => 'Sarangani']],
            'cities-municipalities/1381300000/barangays' => [['code' => '1381300001', 'name' => 'Alicia']],
            default => [],
        });

        return new PsgcDirectory($provider);
    }

    /** @return array<string, mixed> */
    private function selection(): array
    {
        return ['province_code' => '1300000000', 'city_code' => '1381300000', 'psgc_code' => '1381300001', 'street' => '1 Test Street', 'unit' => '', 'postal_code' => '1100'];
    }

    public function test_ncr_uses_region_and_ignores_inconsistent_provider_province_name(): void
    {
        $directory = $this->directory();
        $this->assertSame([], $directory->search('CITY', '1208000000', '', 1)['items']);
        $this->assertSame('1381300000', $directory->search('CITY', '1300000000', 'Quez', 1)['items'][0]['code']);
        $this->assertSame('National Capital Region (NCR)', $directory->validateAddress($this->selection())['province']);
        $this->assertSame('1381300001', $directory->match(['city_municipality' => 'Quezon City', 'barangay' => 'Barangay Alicia'])['psgc_code']);
    }

    public function test_invalid_hierarchy_is_rejected(): void
    {
        $this->expectException(ValidationException::class);
        $this->directory()->validateAddress(array_replace($this->selection(), ['province_code' => '1208000000']));
    }

    public function test_resolved_coordinates_are_bound_to_address_and_organization(): void
    {
        $geocoder = $this->createStub(AddressGeocoder::class);
        $geocoder->method('forward')->willReturn(['latitude' => 14.65, 'longitude' => 121.02, 'formatted_address' => 'Test address', 'place_id' => 'test-place']);
        $resolver = new VendorAddressResolver($this->directory(), $geocoder);
        $result = $resolver->resolve('vendor-one', $this->selection());
        $input = $this->selection() + ['resolution_token' => $result['resolution_token']];
        $this->assertSame(14.65, $resolver->validated('vendor-one', $input)['latitude']);
        foreach ([['vendor-two', $input], ['vendor-one', array_replace($input, ['street' => 'Changed Street'])], ['vendor-one', array_replace($input, ['resolution_token' => 'invalid'])]] as [$vendor, $changed]) {
            try {
                $resolver->validated($vendor, $changed);
                $this->fail('Invalid resolution was accepted');
            } catch (ValidationException) {
                $this->addToAssertionCount(1);
            }
        }
    }

    public function test_pin_autofills_codes_and_preserves_the_selected_coordinates(): void
    {
        $geocoder = $this->createMock(AddressGeocoder::class);
        $geocoder->method('reverse')->willReturn(['formatted_address' => 'Test address', 'place_id' => 'test-place', 'street' => '1 Test Street', 'unit' => '', 'barangay' => 'Alicia', 'city_municipality' => 'Quezon City', 'province' => 'Metro Manila', 'postal_code' => '1100']);
        $geocoder->expects($this->never())->method('forward');
        $resolver = new VendorAddressResolver($this->directory(), $geocoder);
        $pin = $resolver->pin('vendor-one', 14.651, 121.021);
        $this->assertSame('1300000000', $pin['address']['province_code']);
        $this->assertSame('1381300001', $pin['address']['psgc_code']);
        $result = $resolver->resolve('vendor-one', $this->selection() + ['pin_token' => $pin['pin_token']]);
        $this->assertSame(14.651, $result['address']['latitude']);
    }

    public function test_geocoding_failure_does_not_issue_a_resolution(): void
    {
        $geocoder = $this->createStub(AddressGeocoder::class);
        $geocoder->method('forward')->willReturn(null);
        $this->expectException(ValidationException::class);
        (new VendorAddressResolver($this->directory(), $geocoder))->resolve('vendor-one', $this->selection());
    }

    /** @return array<string, string> */
    private function namedAddress(): array
    {
        return ['province' => 'Metro Manila', 'city_municipality' => 'Quezon City', 'barangay' => 'Alicia', 'street' => '1 Test Street', 'unit' => '', 'postal_code' => '1100'];
    }

    public function test_manual_address_needs_no_codes_or_google_lookup_and_matches_references_when_available(): void
    {
        $geocoder = $this->createMock(AddressGeocoder::class);
        $geocoder->expects($this->never())->method('forward');
        $geocoder->expects($this->never())->method('reverse');
        $result = (new VendorAddressResolver($this->directory(), $geocoder))->validated('vendor-one', $this->namedAddress() + ['source' => 'MANUAL']);
        $this->assertSame('Metro Manila', $result['province']);
        $this->assertSame('1381300001', $result['psgc_code']);
        $this->assertSame('PSGC_CLOUD_V2', $result['psgc_source']);
        $this->assertNull($result['latitude']);
    }

    public function test_directory_failure_does_not_block_named_manual_or_map_addresses(): void
    {
        $provider = $this->createStub(PsgcProvider::class);
        $provider->method('list')->willThrowException(ValidationException::withMessages(['address' => 'Directory unavailable']));
        $geocoder = $this->createStub(AddressGeocoder::class);
        $geocoder->method('reverse')->willReturn($this->namedAddress() + ['formatted_address' => 'Test address', 'place_id' => 'test-place']);
        $resolver = new VendorAddressResolver(new PsgcDirectory($provider), $geocoder);
        $manual = $resolver->validated('vendor-one', $this->namedAddress() + ['source' => 'MANUAL']);
        $this->assertArrayNotHasKey('psgc_code', $manual);
        $this->assertNull($manual['latitude']);
        $pin = $resolver->pin('vendor-one', 14.65, 121.02);
        $resolved = $resolver->resolve('vendor-one', $this->namedAddress() + ['pin_token' => $pin['pin_token']]);
        $saved = $resolver->validated('vendor-one', $this->namedAddress() + ['resolution_token' => $resolved['resolution_token']]);
        $this->assertSame(14.65, $saved['latitude']);
        $this->assertArrayNotHasKey('psgc_code', $saved);
    }

    public function test_named_address_resolution_is_bound_to_the_address_and_organization(): void
    {
        $geocoder = $this->createMock(AddressGeocoder::class);
        $geocoder->expects($this->never())->method('forward');
        $geocoder->method('reverse')->willReturn($this->namedAddress() + ['formatted_address' => 'Test address', 'place_id' => 'test-place']);
        $resolver = new VendorAddressResolver($this->directory(), $geocoder);
        $pin = $resolver->pin('vendor-one', 14.65, 121.02);
        $this->assertSame('Quezon City', $pin['address']['city_municipality']);
        $input = $this->namedAddress();
        $input['province'] = $pin['address']['province'];
        $resolved = $resolver->resolve('vendor-one', $input + ['pin_token' => $pin['pin_token']]);
        $this->assertSame(14.65, $resolver->validated('vendor-one', $input + ['resolution_token' => $resolved['resolution_token']])['latitude']);
        foreach ([['vendor-two', $input], ['vendor-one', array_replace($input, ['street' => 'Changed Street'])]] as [$organization, $changed]) {
            try {
                $resolver->validated($organization, $changed + ['resolution_token' => $resolved['resolution_token']]);
                $this->fail('A stale or cross-organization token was accepted');
            } catch (ValidationException) {
                $this->addToAssertionCount(1);
            }
        }
    }

    public function test_unmatched_or_conflicting_names_do_not_receive_invented_codes(): void
    {
        $resolver = new VendorAddressResolver($this->directory(), $this->createStub(AddressGeocoder::class));
        foreach ([['city_municipality' => 'Unlisted City'], ['province' => 'Sarangani']] as $changed) {
            $result = $resolver->validated('vendor-one', array_replace($this->namedAddress(), $changed) + ['source' => 'MANUAL']);
            $this->assertArrayNotHasKey('city_code', $result);
            $this->assertNull($result['latitude']);
        }
    }
}
