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

    public function test_list_thumbnail_fetches_one_small_photo_with_attribution_and_no_reviews(): void
    {
        Http::fake([
            'places.googleapis.com/v1/places/ChIJthumbnailPlace01?*' => Http::response(['photos' => [
                ['name' => 'places/ChIJthumbnailPlace01/photos/first', 'authorAttributions' => [['displayName' => 'Shop Owner', 'uri' => 'https://maps.google.com/contributor/1']], 'googleMapsUri' => 'https://maps.google.com/photo/1'],
                ['name' => 'places/ChIJthumbnailPlace01/photos/second'],
            ], 'attributions' => [['provider' => 'Photo partner', 'providerUri' => 'https://example.test']]]),
            'places.googleapis.com/v1/places/ChIJthumbnailPlace01/photos/first/media*' => Http::response(['photoUri' => 'https://lh3.googleusercontent.com/thumbnail']),
        ]);
        $result = app(GooglePlacesProvider::class)->thumbnail('ChIJthumbnailPlace01');
        self::assertCount(1, $result['photos']);
        self::assertSame('Shop Owner', $result['photos'][0]['authors'][0]['name']);
        self::assertSame('https://maps.google.com/photo/1', $result['photos'][0]['google_maps_uri']);
        self::assertSame('Photo partner', $result['provider_attributions'][0]['name']);
        Http::assertSentCount(2);
        Http::assertSent(fn (Request $request): bool => $request->hasHeader('X-Goog-FieldMask', 'photos,attributions'));
        Http::assertSent(fn (Request $request): bool => str_contains($request->url(), '/media') && (int) $request['maxWidthPx'] === 160);
    }

    public function test_missing_or_failed_thumbnail_media_returns_no_fake_image(): void
    {
        Http::fake(['places.googleapis.com/*' => Http::response([])]);
        self::assertSame([], app(GooglePlacesProvider::class)->thumbnail('ChIJthumbnailPlace01')['photos']);
        Http::assertSentCount(1);
        Http::swap(new Factory);
        Http::fake([
            'places.googleapis.com/v1/places/ChIJthumbnailPlace01?*' => Http::response(['photos' => [['name' => 'places/ChIJthumbnailPlace01/photos/first']]]),
            'places.googleapis.com/v1/places/ChIJthumbnailPlace01/photos/first/media*' => Http::response([], 503),
        ]);
        self::assertSame([], app(GooglePlacesProvider::class)->thumbnail('ChIJthumbnailPlace01')['photos']);
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
        self::assertStringNotContainsString('reviews', GooglePlacesProvider::SEARCH_FIELD_MASK);
        self::assertStringNotContainsString('photos', GooglePlacesProvider::SEARCH_FIELD_MASK);
    }

    public function test_directory_search_cells_cover_the_whole_radius_not_only_its_centre(): void
    {
        foreach ([5, 10, 20, 30, 40, 50] as $radiusKm) {
            $scope = new GeographyScope('BUYER', 'RADIUS', 'DEVICE', 14.6512, 121.0321, $radiusKm, str_repeat('a', 32));
            $cells = app(DirectorySupplierService::class)->cells($scope);
            self::assertLessThanOrEqual(121, count($cells));
            self::assertGreaterThanOrEqual(5, count($cells));
            self::assertCount(count($cells), array_unique(array_column($cells, 'key')));
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
        self::assertSame([5000], array_column($single, 'radius_meters'), 'A one-cell cap keeps the exact Buyer circle.');
    }

    public function test_grid_expansion_adds_outer_cells_and_reuses_inner_cell_keys(): void
    {
        config(['services.google_maps.places.max_search_cells' => 121]);
        $cells = fn (int $radius): array => app(DirectorySupplierService::class)->cells(new GeographyScope('BUYER', 'RADIUS', 'DEVICE', 14.6512, 121.0321, $radius, str_repeat('a', 32)));
        $previous = [];
        foreach ([5, 10, 20, 30, 40, 50] as $radius) {
            $current = $cells($radius);
            self::assertGreaterThan(count($previous), count($current));
            self::assertSame([], array_values(array_diff(array_column($previous, 'key'), array_column($current, 'key'))));
            foreach ($current as $cell) {
                self::assertLessThan(10000, $cell['radius_meters'], 'Large searches must retain small search cells.');
            }
            $previous = $current;
        }
        // Sample the entire disk, not just its boundary.
        foreach (range(-50000, 50000, 5000) as $north) {
            foreach (range(-50000, 50000, 5000) as $east) {
                if (hypot($north, $east) > 50000) {
                    continue;
                }
                $lat = 14.6512 + rad2deg($north / 6371000);
                $lng = 121.0321 + rad2deg($east / (6371000 * cos(deg2rad(14.6512))));
                $covered = array_filter($previous, static fn (array $cell): bool => 6371000 * acos(min(1.0, sin(deg2rad($lat)) * sin(deg2rad($cell['latitude'])) + cos(deg2rad($lat)) * cos(deg2rad($cell['latitude'])) * cos(deg2rad($lng - $cell['longitude'])))) <= $cell['radius_meters']);
                self::assertNotEmpty($covered);
            }
        }
    }

    public function test_autocomplete_and_place_resolution_share_a_session_without_supplier_filters(): void
    {
        Http::fake([
            'places.googleapis.com/v1/places:autocomplete' => Http::response(['suggestions' => [['placePrediction' => ['placeId' => 'ChIJlocation000001', 'structuredFormat' => ['mainText' => ['text' => 'Quiapo'], 'secondaryText' => ['text' => 'Manila']]]]]]),
            'places.googleapis.com/v1/places/ChIJlocation000001*' => Http::response(['location' => ['latitude' => 14.6, 'longitude' => 121.0], 'formattedAddress' => 'Quiapo, Manila']),
        ]);
        $session = '2f22ef20-8daa-41cc-bc34-511ea1b800c4';
        self::assertSame('Quiapo', app(GooglePlacesProvider::class)->autocomplete('Qui', $session)[0]['title']);
        self::assertSame('Quiapo, Manila', app(GooglePlacesProvider::class)->locate('ChIJlocation000001', $session)['formatted_address']);
        Http::assertSent(fn (Request $request): bool => str_contains($request->url(), ':autocomplete') && $request['includedRegionCodes'] === ['ph'] && $request['sessionToken'] === $session && ! isset($request['includedPrimaryTypes']));
        Http::assertSentCount(2);
    }

    public function test_google_media_preserves_authors_and_boolean_attributes_without_inference(): void
    {
        Http::fake([
            'places.googleapis.com/v1/places/ChIJopenPlace000001/photos/*' => Http::response(['photoUri' => 'https://lh3.googleusercontent.com/photo']),
            'places.googleapis.com/v1/places/ChIJopenPlace000001*' => Http::response([
                'id' => 'ChIJopenPlace000001', 'displayName' => ['text' => 'Hardware'], 'location' => ['latitude' => 14.6, 'longitude' => 121.0],
                'photos' => [['name' => 'places/ChIJopenPlace000001/photos/abc', 'authorAttributions' => [['displayName' => 'Photo author', 'uri' => 'https://maps.google.com/author']], 'googleMapsUri' => 'https://maps.google.com/photo']],
                'reviews' => [['rating' => 4, 'text' => ['text' => 'Helpful staff'], 'authorAttribution' => ['displayName' => 'Reviewer'], 'googleMapsUri' => 'https://maps.google.com/review']],
                'delivery' => false, 'paymentOptions' => ['acceptsCashOnly' => true], 'currentOpeningHours' => ['openNow' => true],
            ]),
        ]);
        $details = app(GooglePlacesProvider::class)->details('ChIJopenPlace000001');
        self::assertSame('Photo author', $details['photos'][0]['authors'][0]['name']);
        self::assertArrayNotHasKey('name', $details['photos'][0], 'Photo resource names never leave the adapter.');
        self::assertSame('Reviewer', $details['reviews'][0]['author']['name']);
        self::assertSame([['label' => 'Delivery', 'available' => false], ['label' => 'Cash only', 'available' => true]], $details['attributes']);
        self::assertTrue($details['open_now']);
        Http::assertSentCount(2);
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
