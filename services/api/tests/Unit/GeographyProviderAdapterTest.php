<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Geography\DirectorySupplierService;
use App\Domain\Geography\GeographyProviderUnavailable;
use App\Domain\Geography\GeographyScope;
use App\Domain\Geography\PsgcNames;
use App\Domain\Geography\RadiusPolicy;
use App\Infrastructure\Geography\GooglePlacesProvider;
use App\Infrastructure\Geography\GoogleRoutesProvider;
use Illuminate\Http\Client\ConnectionException;
use Illuminate\Http\Client\Factory;
use Illuminate\Http\Client\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Http;
use Tests\TestCase;

/** Provider adapters are exercised against faked HTTP only; no request reaches Google in tests. */
final class GeographyProviderAdapterTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();
        config()->set('cache.default', 'array');
        config()->set('services.google_maps.server_api_key', 'test-server-key-not-real');
        config()->set('services.google_maps.places.max_calls_per_day', 100);
        config()->set('services.google_maps.routes.max_calls_per_day', 100);
        config()->set('services.google_maps.places.included_types', ['hardware_store', 'home_improvement_store', 'bad type!']);
        Cache::flush();
    }

    public function test_places_search_uses_the_minimum_field_mask_and_drops_closed_or_unusable_results(): void
    {
        Http::fake(['places.googleapis.com/v1/places:searchNearby' => Http::response(['places' => [
            ['id' => 'ChIJopenPlace000001', 'displayName' => ['text' => 'Open Hardware'], 'location' => ['latitude' => 14.6, 'longitude' => 121.0], 'businessStatus' => 'OPERATIONAL', 'primaryType' => 'hardware_store', 'formattedAddress' => 'Manila'],
            ['id' => 'ChIJclosedPlace0001', 'displayName' => ['text' => 'Closed Hardware'], 'location' => ['latitude' => 14.6, 'longitude' => 121.0], 'businessStatus' => 'CLOSED_PERMANENTLY'],
            ['id' => 'ChIJnoLocation00001', 'displayName' => ['text' => 'No Location']],
            ['id' => 'ChIJopenPlace000001', 'displayName' => ['text' => 'Duplicate'], 'location' => ['latitude' => 14.6, 'longitude' => 121.0]],
        ]])]);

        $places = app(GooglePlacesProvider::class)->nearby([['latitude' => 14.6, 'longitude' => 121.0, 'radius_meters' => 6600], ['latitude' => 14.7, 'longitude' => 121.1, 'radius_meters' => 90000]]);

        self::assertSame(['ChIJopenPlace000001'], array_column($places, 'place_id'));
        Http::assertSentCount(2);
        Http::assertSent(function (Request $request): bool {
            $body = $request->data();

            return $request->hasHeader('X-Goog-FieldMask', GooglePlacesProvider::SEARCH_FIELD_MASK)
                && $request->hasHeader('X-Goog-Api-Key', 'test-server-key-not-real')
                && $body['includedTypes'] === ['hardware_store', 'home_improvement_store']
                && $body['rankPreference'] === 'POPULARITY'
                && $body['locationRestriction']['circle']['radius'] <= 50000.0
                && ! str_contains($request->url(), 'key=');
        });
        self::assertStringNotContainsString('reviews', GooglePlacesProvider::SEARCH_FIELD_MASK.GooglePlacesProvider::DETAILS_FIELD_MASK);
        self::assertStringNotContainsString('photos', GooglePlacesProvider::SEARCH_FIELD_MASK.GooglePlacesProvider::DETAILS_FIELD_MASK);
    }

    public function test_directory_search_cells_cover_the_whole_radius_not_only_its_centre(): void
    {
        foreach ([5, 10, 50] as $radiusKm) {
            $scope = new GeographyScope('BUYER', 'RADIUS', 'DEVICE', 14.6512, 121.0321, $radiusKm, str_repeat('a', 32));
            $cells = app(DirectorySupplierService::class)->cells($scope);
            self::assertCount(7, $cells, "{$radiusKm} km uses a centre cell plus a six-cell ring.");
            self::assertCount(7, array_unique(array_column($cells, 'key')));
            // Every point on the radius boundary lies inside at least one cell, so results are not limited to the
            // places nearest the Buyer.
            for ($bearing = 0; $bearing < 360; $bearing += 15) {
                $boundary = [
                    14.6512 + rad2deg($radiusKm * 1000 * cos(deg2rad($bearing)) / 6371000),
                    121.0321 + rad2deg($radiusKm * 1000 * sin(deg2rad($bearing)) / (6371000 * cos(deg2rad(14.6512)))),
                ];
                $covered = array_filter($cells, static fn (array $cell): bool => $cell['radius_meters'] <= 50000
                    && 6371000 * acos(min(1.0, sin(deg2rad($boundary[0])) * sin(deg2rad($cell['latitude'])) + cos(deg2rad($boundary[0])) * cos(deg2rad($cell['latitude'])) * cos(deg2rad($boundary[1] - $cell['longitude'])))) <= $cell['radius_meters']);
                self::assertNotEmpty($covered, "{$radiusKm} km boundary at {$bearing}° is covered.");
            }
        }
        config(['services.google_maps.places.max_search_cells' => 1]);
        $single = app(DirectorySupplierService::class)->cells(new GeographyScope('BUYER', 'RADIUS', 'DEVICE', 14.6512, 121.0321, 5, str_repeat('a', 32)));
        self::assertSame([6600], array_column($single, 'radius_meters'), 'A one-cell cap keeps one padded circle.');
    }

    public function test_places_failures_map_to_timeout_quota_and_error_without_leaking_payloads(): void
    {
        $cells = [['latitude' => 14.6, 'longitude' => 121.0, 'radius_meters' => 6600]];
        foreach ([[429, 'QUOTA'], [500, 'ERROR'], [403, 'ERROR']] as [$status, $reason]) {
            Http::swap(new Factory);
            Http::fake(['*' => Http::response(['error' => ['message' => 'API key test-server-key-not-real invalid']], $status)]);
            try {
                app(GooglePlacesProvider::class)->nearby($cells);
                self::fail('Expected provider failure.');
            } catch (GeographyProviderUnavailable $unavailable) {
                self::assertSame($reason, $unavailable->reason);
                self::assertStringNotContainsString('test-server-key', $unavailable->getMessage());
            }
        }
        Http::swap(new Factory);
        Http::fake(fn () => throw new ConnectionException('timed out'));
        try {
            app(GooglePlacesProvider::class)->details('ChIJopenPlace000001');
            self::fail('Expected timeout.');
        } catch (GeographyProviderUnavailable $unavailable) {
            self::assertSame('TIMEOUT', $unavailable->reason);
        }
        config()->set('services.google_maps.server_api_key', '');
        $this->expectExceptionObject(new GeographyProviderUnavailable('NOT_CONFIGURED'));
        app(GooglePlacesProvider::class)->nearby($cells);
    }

    public function test_place_details_request_only_permitted_fields_and_label_values_safely(): void
    {
        Http::fake(['places.googleapis.com/v1/places/*' => Http::response(['id' => 'ChIJopenPlace000001', 'displayName' => ['text' => 'Open Hardware'], 'location' => ['latitude' => 14.6, 'longitude' => 121.0],
            'nationalPhoneNumber' => '(02) 8123 4567', 'websiteUri' => 'javascript:alert(1)', 'googleMapsUri' => 'https://maps.google.com/?cid=1', 'rating' => 4.84, 'userRatingCount' => 31,
            'regularOpeningHours' => ['weekdayDescriptions' => ['Monday: 8:00 AM – 5:00 PM']]])]);

        $details = app(GooglePlacesProvider::class)->details('ChIJopenPlace000001');

        self::assertNotNull($details);
        self::assertSame(4.8, $details['rating']);
        self::assertNull($details['website_uri'], 'Only https provider links are exposed.');
        Http::assertSent(fn (Request $request): bool => $request->hasHeader('X-Goog-FieldMask', GooglePlacesProvider::DETAILS_FIELD_MASK));
        self::assertNull(app(GooglePlacesProvider::class)->details('../../etc/passwd'));
    }

    public function test_routes_request_one_drive_route_with_the_minimum_field_mask(): void
    {
        Http::fake(['routes.googleapis.com/*' => Http::response(['routes' => [['distanceMeters' => 4200, 'duration' => '1080s', 'polyline' => ['encodedPolyline' => 'abc']]]])]);

        $route = app(GoogleRoutesProvider::class)->drive(14.6, 121.0, 14.62, 121.02);

        self::assertSame(['distance_meters' => 4200, 'duration_seconds' => 1080, 'encoded_polyline' => 'abc', 'duration_basis' => 'TRAFFIC_AWARE'], $route);
        Http::assertSent(fn (Request $request): bool => $request->hasHeader('X-Goog-FieldMask', GoogleRoutesProvider::FIELD_MASK)
            && $request->data()['travelMode'] === 'DRIVE' && $request->data()['computeAlternativeRoutes'] === false);
        Http::swap(new Factory);
        Http::fake(['routes.googleapis.com/*' => Http::response(['routes' => []])]);
        self::assertNull(app(GoogleRoutesProvider::class)->drive(14.6, 121.0, 14.62, 121.02));
    }

    public function test_daily_provider_budget_fails_closed_like_an_outage(): void
    {
        config()->set('services.google_maps.routes.max_calls_per_day', 2);
        Http::fake(['routes.googleapis.com/*' => Http::response(['routes' => [['distanceMeters' => 1, 'duration' => '1s', 'polyline' => ['encodedPolyline' => 'a']]]])]);
        app(GoogleRoutesProvider::class)->drive(14.6, 121.0, 14.62, 121.02);
        app(GoogleRoutesProvider::class)->drive(14.6, 121.0, 14.62, 121.02);
        try {
            app(GoogleRoutesProvider::class)->drive(14.6, 121.0, 14.62, 121.02);
            self::fail('Expected the daily budget to stop the call.');
        } catch (GeographyProviderUnavailable $unavailable) {
            self::assertSame('QUOTA', $unavailable->reason);
        }
        Http::assertSentCount(2);
    }

    public function test_radius_policy_and_psgc_name_rules(): void
    {
        self::assertSame([5, 10, 20, 30, 40, 50], RadiusPolicy::ALLOWED_KM);
        self::assertSame(10, RadiusPolicy::next(5));
        self::assertSame(50, RadiusPolicy::next(40));
        self::assertNull(RadiusPolicy::next(50));
        self::assertSame(20, RadiusPolicy::assertAllowed('20'));
        self::assertSame('manila', PsgcNames::normalize('City of Manila'));
        self::assertSame('quezon', PsgcNames::normalize('Quezon City'));
        self::assertSame('paranaque', PsgcNames::normalize('Parañaque'));
        self::assertContains('metro manila', PsgcNames::regionAliases('National Capital Region (NCR)'));
        self::assertContains('central luzon', PsgcNames::regionAliases('Region III (Central Luzon)'));
        self::assertSame('0100000000', PsgcNames::code('100000000'));
        self::assertNull(PsgcNames::code('12AB'));
        self::assertSame('SUB_MUNICIPALITY', PsgcNames::level('SubMun'));
        self::assertSame('OTHER', PsgcNames::level('Dist'));
    }
}
