import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for BuyerLocationsApi
void main() {
  final instance = MateryalphApiClient().getBuyerLocationsApi();

  group(BuyerLocationsApi, () {
    // Up to five Google Places suggestions restricted to the Philippines. Query travels in the body; no content is persisted. Reuse the session token when resolving the selected Place ID.
    //
    //Future<LocationSuggestionEnvelope> autocompleteBuyerLocation(LocationAutocompleteRequest locationAutocompleteRequest) async
    test('test autocompleteBuyerLocation', () async {
      // TODO
    });

    // Saves a location from a resolution_token issued to this Buyer within 30 minutes. The first location becomes primary. When the address provider was unavailable, address_line is required (ADDRESS_DESCRIPTION_REQUIRED). Retrying with the same Idempotency-Key returns the same location.
    //
    //Future<BuyerLocationEnvelope> createBuyerLocation(String idempotencyKey, BuyerLocationCreate buyerLocationCreate) async
    test('test createBuyerLocation', () async {
      // TODO
    });

    // Optional Buyer profile onboarding snapshot with the approved industry list, active material categories and the saved discovery radius. Skipping never blocks the account.
    //
    //Future<BuyerOnboardingEnvelope> getBuyerOnboarding() async
    test('test getBuyerOnboarding', () async {
      // TODO
    });

    // The Buyer's own active saved locations, primary first. Coordinates, contacts and site instructions are returned only to their owner.
    //
    //Future<BuyerLocationListEnvelope> listBuyerLocations() async
    test('test listBuyerLocations', () async {
      // TODO
    });

    // Paginated PSGC area picker from the ACTIVE imported version. PROVINCE returns provinces plus independent cities directly under a region. Returns an empty list with status NO_ACTIVE_PSGC_VERSION when nothing is imported.
    //
    //Future<PsgcAreaListEnvelope> listBuyerPsgcAreas(String level, { String parentCode, String q, int page }) async
    test('test listBuyerPsgcAreas', () async {
      // TODO
    });

    // Makes this location the single primary location.
    //
    //Future<BuyerLocationEnvelope> makeBuyerLocationPrimary(String locationId, LockVersionRequest lockVersionRequest) async
    test('test makeBuyerLocationPrimary', () async {
      // TODO
    });

    // Archives a saved location. The primary location cannot be removed while other locations exist (409 PRIMARY_LOCATION_REQUIRED).
    //
    //Future<BuyerLocationRemovedEnvelope> removeBuyerLocation(int lockVersion, String locationId) async
    test('test removeBuyerLocation', () async {
      // TODO
    });

    // Resolves a dropped pin, an explicitly granted device point or a typed Philippine address into a reviewable preview with the best resolved versioned PSGC codes. Nothing is stored. GPS is optional; PIN and ADDRESS are complete alternatives. Pin resolution degrades to coordinates only when the address provider is unavailable; ADDRESS returns 503 ADDRESS_PROVIDER_UNAVAILABLE so the Buyer can drop a pin instead.
    //
    //Future<BuyerLocationPreviewEnvelope> resolveBuyerLocation(BuyerLocationResolveRequest buyerLocationResolveRequest) async
    test('test resolveBuyerLocation', () async {
      // TODO
    });

    // Saves, completes or skips optional onboarding with optimistic concurrency. OTHER requires industry_other_label. A stale lock_version returns 409 ONBOARDING_VERSION_CONFLICT.
    //
    //Future<BuyerOnboardingEnvelope> saveBuyerOnboarding(BuyerOnboardingUpdate buyerOnboardingUpdate) async
    test('test saveBuyerOnboarding', () async {
      // TODO
    });

    // Updates details with optimistic concurrency. A new resolution_token appends a new address version; earlier versions stay intact for snapshots. Another Buyer's location returns 404.
    //
    //Future<BuyerLocationEnvelope> updateBuyerLocation(String locationId, BuyerLocationUpdate buyerLocationUpdate) async
    test('test updateBuyerLocation', () async {
      // TODO
    });

  });
}
