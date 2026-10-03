import 'dart:async';

import 'package:materyalph/features/item_procurement/procurement_models.dart';
import 'package:materyalph/features/item_procurement/procurement_repository.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';

/// Synthetic Phase 7 fixtures. Values are fictional and illustrate states, not live marketplace data.
ExploreSummaryView summaryFixture({
  int vendors = 12,
  int listings = 48,
  int radiusKm = 5,
  String originVersion = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
}) => ExploreSummaryView(
  originVersion: originVersion,
  radiusKm: radiusKm,
  scopeLabel: 'All categories within $radiusKm km of 629 J Nepomuceno St',
  currentAsOf: DateTime.utc(2026, 9, 30, 1, 15),
  verifiedVendors: vendors,
  vendorListings: listings,
  vendorsLabel: 'Nearby Verified Vendors',
  listingsLabel: 'Available Products',
  listingsUnit: 'Vendor listings',
  categories: const [
    CategoryCountView(
      id: 'cat-roof',
      code: 'ROOFING_MATERIALS',
      name: 'Roofing Materials',
      vendorListings: 16,
    ),
    CategoryCountView(
      id: 'cat-cement',
      code: 'CEMENT_AND_CONCRETE',
      name: 'Cement and Concrete',
      vendorListings: 7,
    ),
    CategoryCountView(
      id: 'cat-steel',
      code: 'STEEL_AND_REINFORCEMENT',
      name: 'Steel and Reinforcement',
      vendorListings: 42,
    ),
    CategoryCountView(
      id: 'cat-masonry',
      code: 'MASONRY',
      name: 'Masonry',
      vendorListings: 0,
    ),
  ],
  analyticsEnabled: false,
  analyticsMessage: 'Materials Analytics is not available yet.',
  datasetLabel: 'DEMO — Simulated Marketplace Data',
);

const _components = [
  RankingComponentView(
    key: 'distance',
    label: 'Distance',
    weightPercent: 30,
    score: '80.00',
    weighted: '24.00',
    basis: '1.0 km away within a 5 km radius (straight line)',
  ),
  RankingComponentView(
    key: 'price',
    label: 'Price',
    weightPercent: 25,
    score: '83.33',
    weighted: '20.83',
    basis: 'Lowest comparable price ₱15.00 vs this offer ₱18.00 per PC',
  ),
  RankingComponentView(
    key: 'vps',
    label: 'Vendor Performance (VPS)',
    weightPercent: 20,
    score: '50.00',
    weighted: '10.00',
    basis: 'New Vendor — internal neutral score, not a public rating',
  ),
  RankingComponentView(
    key: 'stock',
    label: 'Stock',
    weightPercent: 15,
    score: '100.00',
    weighted: '15.00',
    basis: 'In Stock',
  ),
  RankingComponentView(
    key: 'product_rating',
    label: 'Product Rating',
    weightPercent: 10,
    score: '60.00',
    weighted: '6.00',
    basis: 'New — no product ratings yet (internal neutral score)',
  ),
];

ListingCardView listingCard(
  String id, {
  String name = 'Apo Longspan Roofing - Tilespan',
  int price = 137500,
  String vendor = 'L&D Hardware & Construction Supplies',
  String vendorId = 'vendor-1',
  List<String> badges = const [],
  bool favorite = false,
  int distance = 1000,
  String stock = 'IN_STOCK',
  int rank = 1,
}) => ListingCardView(
  listingId: id,
  variantId: '$id-v1',
  rank: rank,
  displayName: name,
  unitPriceCentavos: price,
  unitName: 'Piece',
  vatLabel: 'VAT inclusive',
  stockLabel: stock,
  stockConfirmedAt: DateTime.utc(2026, 9, 29, 5),
  ratingLabel: 'New',
  ratingAverage: null,
  unitsSold: '0.0000',
  distanceMeters: distance,
  badges: badges,
  isFavorite: favorite,
  vendorId: vendorId,
  vendorName: vendor,
  vendorScore: 'New Vendor',
  pickupAvailable: true,
  delivery: 'WITHIN_STATED_AREA',
  optionsCount: 3,
  srs: '75.83',
  components: _components,
  variantLabel: 'Red · 0.40 mm · 12 ft',
  normalizedUnitPrice: '15.00000000',
  canonicalUnitCode: 'PC',
);

ListingSearchPage searchPage(
  List<ListingCardView> items, {
  ListingSort sort = ListingSort.bestDeal,
  bool personalized = false,
  bool hasMore = false,
  int? suggested,
}) => ListingSearchPage(
  items: items,
  sort: sort,
  defaultSort: ListingSort.bestDeal,
  total: items.length,
  hasMore: hasMore,
  nextCursor: hasMore ? 'cursor-2' : null,
  currentAsOf: DateTime.utc(2026, 9, 30, 1, 15),
  personalized: personalized,
  originVersion: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
  suggestedRadiusKm: suggested,
);

ListingDetailView listingDetail({
  bool purchasable = true,
  bool deliveryOffered = true,
}) => ListingDetailView(
  listingId: 'listing-1',
  displayName: 'Apo Longspan Roofing - Tilespan',
  images: const [],
  variants: const [
    VariantOfferView(
      variantId: 'variant-red',
      label: 'Red · 12 ft',
      unitName: 'Piece',
      quantityStep: '1',
      available: true,
      volumeTiers: [
        VolumeTierView(minimumQuantity: '50.0000', amountCentavos: 130000),
      ],
      bestPrice: true,
      stockLabel: 'IN_STOCK',
      priceVersionId: 'price-1',
      unitPriceCentavos: 137500,
      vatLabel: 'VAT inclusive',
      includedVatCentavos: 14732,
      comparable: true,
    ),
    VariantOfferView(
      variantId: 'variant-green',
      label: 'Green · 12 ft',
      unitName: 'Piece',
      quantityStep: '1',
      available: false,
      volumeTiers: [],
      bestPrice: false,
      availabilityNote: 'Not currently offered',
    ),
  ],
  vendorId: 'vendor-1',
  vendorName: 'L&D Hardware & Construction Supplies',
  vendorScore: 'New Vendor',
  vendorAddress: '629 J Nepomuceno St, Quiapo, Manila',
  vendorOpenStatus: 'OPEN',
  distanceMeters: 4300,
  pickupAvailable: true,
  delivery: deliveryOffered ? 'WITHIN_STATED_AREA' : 'NOT_OFFERED',
  deliveryMaximumKm: deliveryOffered ? 10 : null,
  fulfillmentNotice:
      'Delivery vehicles, trips and the fee are confirmed by the Vendor before you pay. Estimates are advisory.',
  complianceNotice:
      'A PS/ICC badge means MateryalPH matched or reviewed the submitted evidence. It is not a new government certification.',
  ratingLabel: 'New',
  unitsSold: '0.0000',
  isFavorite: false,
  purchasable: purchasable,
  notPurchasableReason: purchasable ? null : 'OUTSIDE_SELECTED_RADIUS',
  attributes: const {'thickness_mm': '0.40', 'effective_width': '43 in'},
  currentAsOf: DateTime.utc(2026, 9, 30, 1, 15),
  brand: 'Apo',
  manufacturer: 'Apo Galtek',
  countryOfManufacture: 'PH',
  categoryName: 'Roofing Materials',
  complianceBadge: 'PS_ICC_VERIFIED',
);

CartLineView cartLine(
  String id, {
  String vendorId = 'vendor-1',
  String name = 'Apo Longspan Roofing - Tilespan',
  int price = 137500,
  List<CartIssueView> issues = const [],
  String status = 'READY',
  int? snapshot,
  bool available = true,
}) => CartLineView(
  id: id,
  listingId: 'listing-$id',
  variantId: 'variant-$id',
  vendorId: vendorId,
  displayName: name,
  unitName: 'Piece',
  quantity: '2.0000',
  quantityStep: '1',
  savedForLater: false,
  issues: issues,
  status: status,
  variantLabel: 'Red · 12 ft',
  snapshotUnitPriceCentavos: snapshot ?? price,
  currentUnitPriceCentavos: available ? price : null,
  appliedUnitPriceCentavos: available ? price : null,
  stockLabel: available ? 'IN_STOCK' : null,
  lineTotalCentavos: available ? price * 2 : null,
);

CartView twoVendorCart({
  bool stalePrice = true,
  int lockVersion = 3,
}) => CartView(
  id: 'cart-1',
  lockVersion: lockVersion,
  groups: [
    CartGroupView(
      vendorId: 'vendor-1',
      vendorName: 'L&D Hardware & Construction Supplies',
      vacationMode: false,
      fulfillmentOptions: const ['DELIVERY', 'PICKUP'],
      fulfillmentMethod: 'DELIVERY',
      lines: [cartLine('a')],
      materialsSubtotalCentavos: 275000,
      status: 'READY',
    ),
    CartGroupView(
      vendorId: 'vendor-2',
      vendorName: 'Bravo Builders Depot',
      vacationMode: false,
      fulfillmentOptions: const ['PICKUP'],
      fulfillmentMethod: 'PICKUP',
      lines: [
        cartLine(
          'b',
          vendorId: 'vendor-2',
          name: 'Apo Longspan Roofing - Ribtype',
          price: stalePrice ? 120000 : 117500,
          snapshot: 117500,
          status: stalePrice ? 'ACTION_REQUIRED' : 'READY',
          issues: stalePrice
              ? const [
                  CartIssueView(
                    code: 'PRICE_CHANGED',
                    severity: 'ACTION_REQUIRED',
                    message:
                        'The price changed since you added this item. Review and accept the current price.',
                  ),
                ]
              : const [],
        ),
      ],
      materialsSubtotalCentavos: stalePrice ? 240000 : 235000,
      status: stalePrice ? 'ACTION_REQUIRED' : 'READY',
    ),
  ],
  savedForLater: const [],
  destination: CartDestinationView.empty,
  lineCount: 2,
  materialsSubtotalCentavos: stalePrice ? 515000 : 510000,
  notice:
      'Checkout creates a separate order request for each Vendor. Nothing is reserved until each Vendor confirms, and totals stay advisory until then.',
  currentAsOf: DateTime.utc(2026, 9, 30, 1, 15),
);

const _intended = CartLocationView(
  locationId: 'loc-1',
  kind: 'PROJECT_SITE',
  active: true,
  label: '629 J Nepomuceno St',
  formattedAddress: '629 J Nepomuceno St, Quiapo, Manila',
);

const _gate = CartLocationView(
  locationId: 'loc-2',
  kind: 'DELIVERY',
  active: true,
  label: 'North gate',
  formattedAddress: 'North gate, Quiapo, Manila',
);

AmountsView _amounts({bool delivery = true, bool manual = false}) =>
    AmountsView(
      materialsSubtotalCentavos: 275000,
      includedVatCentavos: 29464,
      vatExclusiveCentavos: 245536,
      vatIncluded: true,
      deliveryStatus: !delivery
          ? 'NOT_APPLICABLE'
          : manual
          ? 'PENDING_VENDOR_REVIEW'
          : 'ESTIMATE',
      deliveryMinCentavos: !delivery
          ? 0
          : manual
          ? null
          : 60500,
      deliveryMaxCentavos: !delivery
          ? 0
          : manual
          ? null
          : 70500,
      totalMinCentavos: !delivery
          ? 275000
          : manual
          ? null
          : 335500,
      totalMaxCentavos: !delivery
          ? 275000
          : manual
          ? null
          : 345500,
      excludes: const ['VENDOR_COMMISSION', 'MERCHANT_WITHHOLDING'],
    );

CheckoutPreviewView previewFixture({
  String requestVersion = 'preview-1',
  String deliveryStatus = 'ADVISORY_ESTIMATE',
  bool withAlternate = true,
  bool destination = true,
}) {
  final dest = destination
      ? CartDestinationView(
          heavyVehicleRestriction: withAlternate ? 'YES' : 'NO',
          intendedLabel: 'Intended destination / Project site',
          endpointLabel: 'Actual vehicle drop-off',
          intended: _intended,
          alternateDropOff: withAlternate ? _gate : null,
          vehicleEndpoint: withAlternate
              ? 'ALTERNATE_DROP_OFF'
              : 'INTENDED_LOCATION',
          accessInstructions: withAlternate
              ? 'Forklift at the north gate; unload before 5 PM.'
              : null,
        )
      : CartDestinationView.empty;
  final blocked = deliveryStatus == 'BLOCKED';
  final manual = deliveryStatus == 'MANUAL_REVIEW';
  return CheckoutPreviewView(
    requestVersion: requestVersion,
    cartLockVersion: 3,
    destination: dest,
    readyGroups: blocked ? 1 : 2,
    blockedGroups: blocked ? 1 : 0,
    actionRequiredGroups: 0,
    requiresSplitConfirmation: blocked,
    notice:
        'Checkout creates a separate order request for each Vendor. Nothing is reserved or charged until each Vendor confirms and you accept the final amount.',
    currentAsOf: DateTime.utc(2026, 9, 30, 1, 20),
    groups: [
      CheckoutGroupView(
        vendorId: 'vendor-1',
        vendorName: 'L&D Hardware & Construction Supplies',
        status: blocked ? 'BLOCKED' : 'READY',
        issues: blocked
            ? const [
                CartIssueView(
                  code: 'ROUTE_UNAVAILABLE',
                  severity: 'BLOCKING',
                  message:
                      'The delivery route could not be confirmed right now. Retry, or choose Self-Pickup.',
                ),
              ]
            : manual
            ? const [
                CartIssueView(
                  code: 'DELIVERY_MANUAL_REVIEW',
                  severity: 'INFO',
                  message:
                      'The Vendor must review this load manually. Vehicles, trips and the delivery fee will be shown after the Vendor confirms.',
                ),
              ]
            : const [],
        lines: [cartLine('a')],
        fulfillmentMethod: 'DELIVERY',
        fulfillmentOptions: const ['DELIVERY', 'PICKUP'],
        delivery: DeliveryPreviewView(
          status: deliveryStatus,
          issues: blocked
              ? const [
                  CartIssueView(
                    code: 'ROUTE_UNAVAILABLE',
                    severity: 'BLOCKING',
                    message:
                        'The delivery route could not be confirmed right now. Retry, or choose Self-Pickup.',
                  ),
                ]
              : manual
              ? const [
                  CartIssueView(
                    code: 'DELIVERY_MANUAL_REVIEW',
                    severity: 'INFO',
                    message:
                        'The Vendor must review this load manually. Vehicles, trips and the delivery fee will be shown after the Vendor confirms.',
                  ),
                ]
              : const [],
          manualReviewReasons: manual ? const ['WEIGHT_UNKNOWN'] : const [],
          confirmedOffer: false,
          endpoint: withAlternate ? 'ALTERNATE_DROP_OFF' : 'INTENDED_LOCATION',
          routeDistanceMeters: blocked ? null : 4200,
          routeBasis: blocked ? null : 'ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF',
          straightLineMeters: 1803,
          coverageKm: 10,
          estimate: deliveryStatus == 'ADVISORY_ESTIMATE'
              ? const DeliveryEstimateView(
                  feeMinCentavos: 60500,
                  feeMaxCentavos: 70500,
                  tripsMin: 1,
                  tripsMax: 2,
                  vehiclesMin: 1,
                  vehiclesMax: 1,
                )
              : null,
          notice:
              'Estimate only. The Vendor confirms vehicles, trips, the drop-off and the final delivery fee before you pay.',
        ),
        paymentMethods: const [
          PaymentMethodView(method: 'ONLINE', available: true),
          PaymentMethodView(
            method: 'CASH_ON_DELIVERY',
            available: false,
            reason: 'NOT_OFFERED_BY_VENDOR',
          ),
          PaymentMethodView(
            method: 'IN_STORE',
            available: false,
            reason: 'SELF_PICKUP_ONLY',
          ),
        ],
        amounts: _amounts(manual: manual || blocked),
      ),
      CheckoutGroupView(
        vendorId: 'vendor-2',
        vendorName: 'Bravo Builders Depot',
        status: 'READY',
        issues: const [],
        lines: [cartLine('b', vendorId: 'vendor-2')],
        fulfillmentMethod: 'PICKUP',
        fulfillmentOptions: const ['PICKUP'],
        pickupAddress: '12 Evangelista St, Quiapo, Manila',
        delivery: const DeliveryPreviewView(
          status: 'NOT_APPLICABLE',
          issues: [],
          manualReviewReasons: [],
          confirmedOffer: false,
        ),
        paymentMethods: const [
          PaymentMethodView(method: 'ONLINE', available: true),
          PaymentMethodView(
            method: 'CASH_ON_DELIVERY',
            available: false,
            reason: 'SITE_DELIVERY_ONLY',
          ),
          PaymentMethodView(
            method: 'IN_STORE',
            available: false,
            reason: 'NOT_OFFERED_BY_VENDOR',
          ),
        ],
        amounts: _amounts(delivery: false),
      ),
    ],
  );
}

class DestinationCall {
  DestinationCall(
    this.intended,
    this.restriction,
    this.alternate,
    this.instructions,
  );

  final String? intended;
  final String restriction;
  final String? alternate;
  final String? instructions;
}

/// Controllable fake. Calls can be held with [manualSummary]/[manualSearch] to prove that stale
/// responses are discarded.
class FakeProcurementRepository implements ProcurementRepository {
  FakeProcurementRepository({
    ExploreSummaryView? summary,
    ListingSearchPage? page,
    CartView? cart,
    CheckoutPreviewView? preview,
    this.detail,
    this.hours,
  }) : summary = summary ?? summaryFixture(),
       page = page ?? searchPage([listingCard('l-1')]),
       cartView = cart ?? twoVendorCart(),
       preview = preview ?? previewFixture();

  ExploreSummaryView summary;
  ListingSearchPage page;
  CartView cartView;
  CheckoutPreviewView preview;
  ListingDetailView? detail;
  StoreHoursView? hours;
  DiscoveryFailure? summaryFailure;
  DiscoveryFailure? searchFailure;
  DiscoveryFailure? cartFailure;
  DiscoveryFailure? addFailure;
  DiscoveryFailure? saveFailure;
  bool manualSummary = false;
  bool manualSearch = false;
  final List<Completer<ExploreSummaryView>> summaryCalls = [];
  final List<Completer<ListingSearchPage>> searchCalls = [];
  final List<({String query, ListingFilters filters, ListingSort? sort})>
  searches = [];
  final List<String> addKeys = [];
  final List<DestinationCall> destinations = [];
  final List<RankingWeights> savedWeights = [];
  final List<String> acceptedLines = [];
  RankingPreferencesView preferencesView = const RankingPreferencesView(
    weights: RankingWeights.approvedDefault,
    defaults: RankingWeights.approvedDefault,
    personalized: false,
    version: 0,
  );

  @override
  Future<ExploreSummaryView> exploreSummary({
    required DiscoveryOrigin origin,
    required int radiusKm,
  }) {
    if (summaryFailure != null) return Future.error(summaryFailure!);
    final completer = Completer<ExploreSummaryView>();
    summaryCalls.add(completer);
    if (!manualSummary) completer.complete(summary);
    return completer.future;
  }

  @override
  Future<ListingSearchPage> search({
    required DiscoveryOrigin origin,
    required int radiusKm,
    required String query,
    required ListingFilters filters,
    ListingSort? sort,
    String? cursor,
  }) {
    searches.add((query: query, filters: filters, sort: sort));
    if (searchFailure != null) return Future.error(searchFailure!);
    final completer = Completer<ListingSearchPage>();
    searchCalls.add(completer);
    if (!manualSearch) completer.complete(page);
    return completer.future;
  }

  @override
  Future<ListingDetailView> listing({
    required String listingId,
    required DiscoveryOrigin origin,
    required int radiusKm,
  }) async =>
      detail ??
      (throw const DiscoveryFailure(
        DiscoveryFailureKind.notFound,
        'This product is no longer available. Refresh the results to see current offers.',
        code: 'LISTING_UNAVAILABLE',
      ));

  @override
  Future<RankingPreferencesView> preferences() async => preferencesView;

  @override
  Future<RankingPreferencesView> savePreferences(
    RankingWeights weights, {
    required int version,
  }) async {
    if (saveFailure != null) throw saveFailure!;
    savedWeights.add(weights);
    return preferencesView = RankingPreferencesView(
      weights: weights,
      defaults: RankingWeights.approvedDefault,
      personalized: true,
      version: version + 1,
    );
  }

  @override
  Future<RankingPreferencesView> resetPreferences({
    required int version,
  }) async => preferencesView = const RankingPreferencesView(
    weights: RankingWeights.approvedDefault,
    defaults: RankingWeights.approvedDefault,
    personalized: false,
    version: 0,
  );

  @override
  Future<CartView> cart() async {
    if (cartFailure != null) throw cartFailure!;
    return cartView;
  }

  @override
  Future<CartView> addToCart({
    required String variantId,
    required String expectedPriceVersionId,
    required String quantity,
    required DiscoveryOrigin origin,
    required int radiusKm,
    required String idempotencyKey,
    String? fulfillmentMethod,
  }) async {
    addKeys.add(idempotencyKey);
    if (addFailure != null) throw addFailure!;
    return cartView;
  }

  @override
  Future<CartView> updateLine(
    CartLineView line, {
    required int cartLockVersion,
    String? quantity,
    bool? savedForLater,
    bool acceptCurrentPrice = false,
  }) async {
    if (acceptCurrentPrice) {
      acceptedLines.add(line.id);
      return cartView = twoVendorCart(stalePrice: false, lockVersion: 4);
    }
    return cartView;
  }

  @override
  Future<CartView> removeLine(
    CartLineView line, {
    required int cartLockVersion,
  }) async => cartView;

  @override
  Future<CartView> setFulfillment(
    String vendorId,
    String method, {
    required int cartLockVersion,
  }) async => cartView;

  @override
  Future<CartView> setDestination({
    required int cartLockVersion,
    required String? intendedLocationId,
    required String heavyVehicleRestriction,
    String? alternateDropOffLocationId,
    String? accessInstructions,
  }) async {
    destinations.add(
      DestinationCall(
        intendedLocationId,
        heavyVehicleRestriction,
        alternateDropOffLocationId,
        accessInstructions,
      ),
    );
    return cartView;
  }

  @override
  Future<CheckoutPreviewView> checkoutPreview({
    required String requestVersion,
  }) async => CheckoutPreviewView(
    requestVersion: requestVersion,
    cartLockVersion: preview.cartLockVersion,
    destination: preview.destination,
    groups: preview.groups,
    readyGroups: preview.readyGroups,
    blockedGroups: preview.blockedGroups,
    actionRequiredGroups: preview.actionRequiredGroups,
    requiresSplitConfirmation: preview.requiresSplitConfirmation,
    notice: preview.notice,
    currentAsOf: preview.currentAsOf,
  );

  @override
  Future<StoreHoursView> storeHours(String storeId) async => hours!;
}
