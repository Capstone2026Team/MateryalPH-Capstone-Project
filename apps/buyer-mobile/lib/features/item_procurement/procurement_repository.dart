import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

import '../../core/api_guard.dart';
import '../map_discovery/discovery_models.dart';
import 'procurement_models.dart';

/// Item-Based discovery, ranking preferences, cart and checkout preview through `/api/v1` only.
/// No request here reserves stock or creates an order.
abstract interface class ProcurementRepository {
  Future<ExploreSummaryView> exploreSummary({
    required DiscoveryOrigin origin,
    required int radiusKm,
  });

  Future<ListingSearchPage> search({
    required DiscoveryOrigin origin,
    required int radiusKm,
    required String query,
    required ListingFilters filters,
    ListingSort? sort,
    String? cursor,
  });

  Future<ListingDetailView> listing({
    required String listingId,
    required DiscoveryOrigin origin,
    required int radiusKm,
  });

  Future<RankingPreferencesView> preferences();

  Future<RankingPreferencesView> savePreferences(
    RankingWeights weights, {
    required int version,
  });

  Future<RankingPreferencesView> resetPreferences({required int version});

  Future<CartView> cart();

  Future<CartView> addToCart({
    required String variantId,
    required String expectedPriceVersionId,
    required String quantity,
    required DiscoveryOrigin origin,
    required int radiusKm,
    required String idempotencyKey,
    String? fulfillmentMethod,
  });

  Future<CartView> updateLine(
    CartLineView line, {
    required int cartLockVersion,
    String? quantity,
    bool? savedForLater,
    bool acceptCurrentPrice = false,
  });

  Future<CartView> removeLine(
    CartLineView line, {
    required int cartLockVersion,
  });

  Future<CartView> setFulfillment(
    String vendorId,
    String method, {
    required int cartLockVersion,
  });

  Future<CartView> setDestination({
    required int cartLockVersion,
    required String? intendedLocationId,
    required String heavyVehicleRestriction,
    String? alternateDropOffLocationId,
    String? accessInstructions,
  });

  Future<CheckoutPreviewView> checkoutPreview({required String requestVersion});

  Future<StoreHoursView> storeHours(String storeId);
}

final class ApiProcurementRepository implements ProcurementRepository {
  ApiProcurementRepository({
    required api.MateryalphApiClient client,
    required Future<void> Function() onSessionExpired,
  }) : _client = client,
       _api = ApiGuard(onSessionExpired);

  final api.MateryalphApiClient _client;
  final ApiGuard _api;

  api.BuyerExploreApi get _explore => _client.getBuyerExploreApi();
  api.BuyerCartApi get _cart => _client.getBuyerCartApi();

  @override
  Future<ExploreSummaryView> exploreSummary({
    required DiscoveryOrigin origin,
    required int radiusKm,
  }) => _api(() async {
    final response = await _explore.getBuyerExploreSummary(
      buyerOriginRequest: _origin(origin, radiusKm),
    );
    final summary = _api.required(response.data?.data);
    return ExploreSummaryView(
      originVersion: summary.scope.originVersion,
      radiusKm: _radius(summary.scope.radiusKm),
      scopeLabel: summary.scopeLabel,
      currentAsOf: summary.currentAsOf,
      verifiedVendors: summary.counts.verifiedVendors,
      vendorListings: summary.counts.vendorListings,
      vendorsLabel: summary.labels.verifiedVendors,
      listingsLabel: summary.labels.vendorListings,
      listingsUnit: summary.labels.vendorListingsUnit,
      categories: summary.categories
          .map(
            (category) => CategoryCountView(
              id: category.id,
              code: category.code,
              name: category.name,
              vendorListings: category.vendorListings,
            ),
          )
          .toList(),
      analyticsEnabled: summary.materialsAnalytics.enabled,
      analyticsMessage: summary.materialsAnalytics.message,
      datasetLabel: summary.dataset.label,
    );
  });

  @override
  Future<ListingSearchPage> search({
    required DiscoveryOrigin origin,
    required int radiusKm,
    required String query,
    required ListingFilters filters,
    ListingSort? sort,
    String? cursor,
  }) => _api(() async {
    final response = await _explore.searchBuyerListings(
      listingSearchRequest: api.ListingSearchRequest(
        (b) => b
          ..locationId = origin.locationId
          ..latitude = origin.locationId == null ? origin.point!.latitude : null
          ..longitude = origin.locationId == null
              ? origin.point!.longitude
              : null
          ..originSource = origin.locationId == null
              ? api.ListingSearchRequestOriginSourceEnum.valueOf(
                  _sourceName(origin.source),
                )
              : null
          ..radiusKm = radiusKm
          ..query = query.trim().isEmpty ? null : query.trim()
          ..sort = sort == null
              ? null
              : api.ListingSearchSort.valueOf(sort.wire)
          ..categoryId = filters.categoryId
          ..favoritesOnly = filters.favoritesOnly
          ..fulfillment = filters.fulfillment == null
              ? api.ListingSearchRequestFulfillmentEnum.ANY
              : api.ListingSearchRequestFulfillmentEnum.valueOf(
                  filters.fulfillment!,
                )
          ..availability = filters.inStockOnly
              ? api.ListingSearchRequestAvailabilityEnum.IN_STOCK
              : api.ListingSearchRequestAvailabilityEnum.ANY
          ..compliance = filters.verifiedComplianceOnly
              ? api.ListingSearchRequestComplianceEnum.PS_ICC_VERIFIED
              : api.ListingSearchRequestComplianceEnum.ANY
          ..vendorId = filters.vendorId
          ..cursor = cursor
          ..perPage = 20,
      ),
    );
    final envelope = _api.required(response.data);
    final meta = envelope.meta;
    return ListingSearchPage(
      items: envelope.data.map(_card).toList(),
      sort: ListingSortWire.parse(meta.sort.name),
      defaultSort: ListingSortWire.parse(meta.defaultSort.name),
      total: meta.total,
      hasMore: meta.hasMore,
      nextCursor: meta.nextCursor,
      currentAsOf: meta.currentAsOf,
      personalized: meta.ranking.personalized,
      originVersion: meta.scope.originVersion,
      suggestedRadiusKm: meta.expansion?.suggestedRadiusKm,
    );
  });

  @override
  Future<ListingDetailView> listing({
    required String listingId,
    required DiscoveryOrigin origin,
    required int radiusKm,
  }) => _api(() async {
    final response = await _explore.getBuyerListingDetails(
      listingId: listingId,
      buyerOriginRequest: _origin(origin, radiusKm),
    );
    final detail = _api.required(response.data?.data);
    return ListingDetailView(
      listingId: detail.listingId,
      displayName: detail.displayName,
      description: detail.description,
      brand: detail.brand,
      manufacturer: detail.manufacturer,
      countryOfManufacture: detail.countryOfManufacture,
      categoryName: detail.category?.name,
      images: detail.images
          .map((image) => (url: image.url, alt: image.altText))
          .toList(),
      variants: detail.variants.map(_variant).toList(),
      vendorId: detail.vendor.id,
      vendorName: detail.vendor.name,
      vendorScore: detail.vendor.scoreLabel.text,
      vendorAddress: detail.vendor.address.formattedAddress,
      vendorOpenStatus: detail.vendor.openStatus.status.name,
      distanceMeters: detail.distanceMeters,
      pickupAvailable: detail.fulfillment.pickupAvailable,
      delivery: detail.fulfillment.delivery.name,
      deliveryMaximumKm: detail.fulfillment.deliveryMaximumKm,
      fulfillmentNotice: detail.fulfillment.notice,
      complianceNotice: detail.compliance.notice,
      complianceBadge: detail.compliance.badge?.name,
      ratingLabel: detail.productRating.label,
      unitsSold: detail.unitsSold,
      isFavorite: detail.isFavorite,
      purchasable: detail.purchasable,
      notPurchasableReason: detail.notPurchasableReason?.name,
      attributes: {
        for (final entry in detail.technicalAttributes.entries)
          if (entry.value != null) entry.key: '${entry.value!.value}',
      },
      currentAsOf: detail.currentAsOf,
    );
  });

  @override
  Future<RankingPreferencesView> preferences() => _api(() async {
    final response = await _explore.getBuyerItemRankingPreferences();
    return _preferences(_api.required(response.data?.data));
  });

  @override
  Future<RankingPreferencesView> savePreferences(
    RankingWeights weights, {
    required int version,
  }) => _api(() async {
    final response = await _explore.saveBuyerItemRankingPreferences(
      rankingPreferencesUpdate: api.RankingPreferencesUpdate(
        (b) => b
          ..version = version
          ..weights.distance = weights.distance
          ..weights.price = weights.price
          ..weights.vps = weights.vps
          ..weights.stock = weights.stock
          ..weights.productRating = weights.productRating,
      ),
    );
    return _preferences(_api.required(response.data?.data));
  });

  @override
  Future<RankingPreferencesView> resetPreferences({required int version}) =>
      _api(() async {
        final response = await _explore.resetBuyerItemRankingPreferences(
          version: version,
        );
        return _preferences(_api.required(response.data?.data));
      });

  @override
  Future<CartView> cart() => _api(() async {
    final response = await _cart.getBuyerCart();
    return _cartView(_api.required(response.data?.data));
  });

  @override
  Future<CartView> addToCart({
    required String variantId,
    required String expectedPriceVersionId,
    required String quantity,
    required DiscoveryOrigin origin,
    required int radiusKm,
    required String idempotencyKey,
    String? fulfillmentMethod,
  }) => _api(() async {
    final response = await _cart.addBuyerCartItem(
      idempotencyKey: idempotencyKey,
      cartItemCreate: api.CartItemCreate(
        (b) => b
          ..listingVariantId = variantId
          ..expectedPriceVersionId = expectedPriceVersionId
          ..quantity = quantity
          ..fulfillmentMethod = fulfillmentMethod == null
              ? null
              : api.CartItemCreateFulfillmentMethodEnum.valueOf(
                  fulfillmentMethod,
                )
          ..locationId = origin.locationId
          ..latitude = origin.locationId == null ? origin.point!.latitude : null
          ..longitude = origin.locationId == null
              ? origin.point!.longitude
              : null
          ..originSource = origin.locationId == null
              ? api.CartItemCreateOriginSourceEnum.valueOf(
                  _sourceName(origin.source),
                )
              : null
          ..radiusKm = radiusKm,
      ),
    );
    return _cartView(_api.required(response.data?.data));
  });

  @override
  Future<CartView> updateLine(
    CartLineView line, {
    required int cartLockVersion,
    String? quantity,
    bool? savedForLater,
    bool acceptCurrentPrice = false,
  }) => _api(() async {
    final response = await _cart.updateBuyerCartItem(
      itemId: line.id,
      cartItemUpdate: api.CartItemUpdate(
        (b) => b
          ..lockVersion = cartLockVersion
          ..quantity = quantity
          ..savedForLater = savedForLater
          ..acceptCurrentPrice = acceptCurrentPrice ? true : null,
      ),
    );
    return _cartView(_api.required(response.data?.data));
  });

  @override
  Future<CartView> removeLine(
    CartLineView line, {
    required int cartLockVersion,
  }) => _api(() async {
    final response = await _cart.removeBuyerCartItem(
      itemId: line.id,
      lockVersion: cartLockVersion,
    );
    return _cartView(_api.required(response.data?.data));
  });

  @override
  Future<CartView> setFulfillment(
    String vendorId,
    String method, {
    required int cartLockVersion,
  }) => _api(() async {
    final response = await _cart.setBuyerCartFulfillment(
      vendorId: vendorId,
      cartFulfillmentUpdate: api.CartFulfillmentUpdate(
        (b) => b
          ..lockVersion = cartLockVersion
          ..fulfillmentMethod =
              api.CartFulfillmentUpdateFulfillmentMethodEnum.valueOf(method),
      ),
    );
    return _cartView(_api.required(response.data?.data));
  });

  @override
  Future<CartView> setDestination({
    required int cartLockVersion,
    required String? intendedLocationId,
    required String heavyVehicleRestriction,
    String? alternateDropOffLocationId,
    String? accessInstructions,
  }) => _api(() async {
    final response = await _cart.setBuyerCartDestination(
      cartDestinationUpdate: api.CartDestinationUpdate(
        (b) => b
          ..lockVersion = cartLockVersion
          ..intendedLocationId = intendedLocationId
          ..heavyVehicleRestriction =
              api.CartDestinationUpdateHeavyVehicleRestrictionEnum.valueOf(
                _restrictionName(heavyVehicleRestriction),
              )
          ..alternateDropOffLocationId = alternateDropOffLocationId
          ..accessInstructions = accessInstructions,
      ),
    );
    return _cartView(_api.required(response.data?.data));
  });

  @override
  Future<CheckoutPreviewView> checkoutPreview({
    required String requestVersion,
  }) => _api(() async {
    final response = await _cart.previewBuyerCheckout(
      checkoutPreviewRequest: api.CheckoutPreviewRequest(
        (b) => b..requestVersion = requestVersion,
      ),
    );
    final preview = _api.required(response.data?.data);
    return CheckoutPreviewView(
      requestVersion: preview.requestVersion,
      cartLockVersion: preview.cartLockVersion,
      destination: _destination(preview.destination),
      groups: preview.groups.map(_checkoutGroup).toList(),
      readyGroups: preview.summary.readyGroups,
      blockedGroups: preview.summary.blockedGroups,
      actionRequiredGroups: preview.summary.actionRequiredGroups,
      requiresSplitConfirmation: preview.summary.requiresSplitConfirmation,
      notice: preview.summary.notice,
      currentAsOf: preview.currentAsOf,
    );
  });

  @override
  Future<StoreHoursView> storeHours(String storeId) => _api(() async {
    final response = await _client.getStoresApi().getPublicStoreProfile(
      storeId: storeId,
    );
    return storeHoursFromProfile(_api.required(response.data?.data));
  });

  ListingCardView _card(api.ListingSearchResult result) => ListingCardView(
    listingId: result.listingId,
    variantId: result.variantId,
    rank: result.rank,
    displayName: result.displayName,
    brand: result.brand,
    variantLabel: result.variantLabel,
    imageUrl: result.image?.url,
    imageAlt: result.image?.altText,
    unitPriceCentavos: result.price.unitPriceCentavos,
    unitName: result.price.unitName,
    vatLabel: result.price.vatLabel,
    stockLabel: result.stockLabel.name,
    stockConfirmedAt: result.stockConfirmedAt,
    ratingLabel: result.productRating.label,
    ratingAverage: result.productRating.average,
    unitsSold: result.unitsSold,
    distanceMeters: result.distanceMeters,
    badges: result.badges.map((badge) => badge.name).toList(),
    isFavorite: result.isFavorite,
    vendorId: result.vendor.id,
    vendorName: result.vendor.name,
    vendorScore: result.vendor.scoreLabel.text,
    pickupAvailable: result.fulfillment.pickupAvailable,
    delivery: result.fulfillment.delivery.name,
    optionsCount: result.optionsCount,
    normalizedUnitPrice: result.comparable.normalizedUnitPrice,
    canonicalUnitCode: result.comparable.canonicalUnitCode,
    srs: result.ranking.srs,
    components: result.ranking.components
        .map(
          (component) => RankingComponentView(
            key: _componentKey(component.key),
            label: component.label,
            weightPercent: component.weightPercent,
            score: component.score,
            weighted: component.weighted,
            basis: component.basis,
          ),
        )
        .toList(),
  );

  VariantOfferView _variant(api.ListingVariantOffer variant) =>
      VariantOfferView(
        variantId: variant.variantId,
        sku: variant.sku,
        attributes: {
          for (final entry in variant.attributes.entries)
            if (entry.value != null) entry.key: '${entry.value!.value}',
        },
        label: variant.label ?? variant.sku,
        unitName: variant.unitName,
        quantityStep: variant.quantityStep,
        available: variant.available,
        availabilityNote: variant.availabilityNote,
        stockLabel: variant.stockLabel?.name,
        priceVersionId: variant.price?.priceVersionId,
        unitPriceCentavos: variant.price?.unitPriceCentavos,
        vatLabel: variant.price?.vatLabel,
        includedVatCentavos: variant.price?.includedVatCentavos,
        bestPrice: variant.bestPrice,
        comparable: variant.comparable?.status.name == 'COMPARABLE',
        volumeTiers: variant.volumeTiers
            .map(
              (tier) => VolumeTierView(
                minimumQuantity: tier.minimumQuantity,
                amountCentavos: tier.amountCentavos,
              ),
            )
            .toList(),
      );

  RankingPreferencesView _preferences(api.RankingPreferences value) =>
      RankingPreferencesView(
        weights: _weights(value.weights),
        defaults: _weights(value.defaultWeights),
        personalized: value.personalized,
        version: value.version,
      );

  RankingWeights _weights(api.RankingWeightSet set) => RankingWeights(
    distance: set.distance,
    price: set.price,
    vps: set.vps,
    stock: set.stock,
    productRating: set.productRating,
  );

  CartView _cartView(api.Cart cart) => CartView(
    id: cart.id,
    lockVersion: cart.lockVersion,
    currentAsOf: cart.currentAsOf,
    destination: _destination(cart.destination),
    groups: cart.groups
        .map(
          (group) => CartGroupView(
            vendorId: group.vendor.id,
            vendorName: group.vendor.name,
            vacationMode: group.vendor.vacationMode,
            fulfillmentMethod: group.fulfillmentMethod?.name,
            fulfillmentOptions: group.fulfillmentOptions
                .map((option) => option.name)
                .toList(),
            lines: group.lines.map(_line).toList(),
            materialsSubtotalCentavos: group.materialsSubtotalCentavos,
            status: group.status.name,
          ),
        )
        .toList(),
    savedForLater: cart.savedForLater.map(_line).toList(),
    lineCount: cart.summary.lineCount,
    materialsSubtotalCentavos: cart.summary.materialsSubtotalCentavos,
    notice: cart.summary.notice,
  );

  CartLineView _line(api.CartLine line) => CartLineView(
    id: line.id,
    listingId: line.listingId,
    variantId: line.variantId,
    vendorId: line.vendorId,
    displayName: line.displayName,
    variantLabel: line.variantLabel,
    imageUrl: line.image?.url,
    unitName: line.unitName,
    quantity: line.quantity,
    quantityStep: line.quantityStep,
    savedForLater: line.savedForLater,
    snapshotUnitPriceCentavos: line.snapshot.unitPriceCentavos,
    currentUnitPriceCentavos: line.current?.unitPriceCentavos,
    appliedUnitPriceCentavos: line.current?.appliedUnitPriceCentavos,
    volumeTierApplied: line.current?.volumeTierApplied ?? false,
    stockLabel: line.current?.stockLabel.name,
    lineTotalCentavos: line.lineTotalCentavos,
    issues: line.issues.map(_issue).toList(),
    status: line.status.name,
  );

  CartIssueView _issue(api.CartIssue issue) => CartIssueView(
    code: issue.code,
    severity: issue.severity.name,
    message: issue.message,
  );

  CartDestinationView _destination(api.CartDestination destination) =>
      CartDestinationView(
        heavyVehicleRestriction: _restrictionWire(
          destination.heavyVehicleRestriction.name,
        ),
        intendedLabel: destination.labels.intended,
        endpointLabel: destination.labels.vehicleEndpoint,
        intended: _location(destination.intended),
        alternateDropOff: _location(destination.alternateDropOff),
        vehicleEndpoint: destination.vehicleEndpoint?.name,
        accessInstructions: destination.accessInstructions,
      );

  CartLocationView? _location(api.CartLocationRef? location) => location == null
      ? null
      : CartLocationView(
          locationId: location.locationId,
          label: location.label,
          kind: location.kind,
          formattedAddress: location.formattedAddress,
          active: location.status.name == 'ACTIVE',
        );

  CheckoutGroupView _checkoutGroup(api.CheckoutGroupPreview group) {
    final delivery = group.delivery;
    final estimate = delivery.estimate;
    final amounts = group.amounts;
    return CheckoutGroupView(
      vendorId: group.vendor.id,
      vendorName: group.vendor.name,
      status: group.status.name,
      issues: group.issues.map(_issue).toList(),
      lines: group.lines.map(_line).toList(),
      fulfillmentMethod: group.fulfillmentMethod?.name,
      fulfillmentOptions: group.fulfillmentOptions
          .map((option) => option.name)
          .toList(),
      pickupAddress: group.pickup?.address?.formattedAddress,
      delivery: DeliveryPreviewView(
        status: delivery.status.name,
        issues: delivery.issues.map(_issue).toList(),
        manualReviewReasons: delivery.manualReviewReasons.toList(),
        confirmedOffer: delivery.confirmedOffer != null,
        endpoint: delivery.endpoint?.name,
        routeDistanceMeters: delivery.route?.distanceMeters,
        routeBasis: delivery.route?.basis.name,
        straightLineMeters: delivery.straightLineMeters,
        coverageKm: delivery.coverageKm,
        notice: delivery.notice,
        estimate: estimate == null
            ? null
            : DeliveryEstimateView(
                feeMinCentavos: estimate.feeMinCentavos,
                feeMaxCentavos: estimate.feeMaxCentavos,
                tripsMin: estimate.tripsMin,
                tripsMax: estimate.tripsMax,
                vehiclesMin: estimate.vehiclesMin,
                vehiclesMax: estimate.vehiclesMax,
              ),
      ),
      paymentMethods: group.paymentMethods
          .map(
            (method) => PaymentMethodView(
              method: method.method.name,
              available: method.available,
              reason: method.reason,
            ),
          )
          .toList(),
      amounts: AmountsView(
        materialsSubtotalCentavos: amounts.materialsSubtotalCentavos,
        includedVatCentavos: amounts.includedVatCentavos,
        vatExclusiveCentavos: amounts.vatExclusiveMaterialsCentavos,
        vatIncluded: amounts.vatTreatment.name == 'PRICES_INCLUDE_VAT',
        deliveryStatus: amounts.delivery.status.name,
        deliveryMinCentavos: amounts.delivery.minCentavos,
        deliveryMaxCentavos: amounts.delivery.maxCentavos,
        totalMinCentavos: amounts.totalBeforeProcessingMinCentavos,
        totalMaxCentavos: amounts.totalBeforeProcessingMaxCentavos,
        excludes: amounts.excludes.map((value) => value.name).toList(),
      ),
    );
  }

  api.BuyerOriginRequest _origin(DiscoveryOrigin origin, int radiusKm) =>
      api.BuyerOriginRequest(
        (b) => b
          ..locationId = origin.locationId
          ..latitude = origin.locationId == null ? origin.point!.latitude : null
          ..longitude = origin.locationId == null
              ? origin.point!.longitude
              : null
          ..originSource = origin.locationId == null
              ? api.BuyerOriginRequestOriginSourceEnum.valueOf(
                  _sourceName(origin.source),
                )
              : null
          ..radiusKm = radiusKm,
      );

  int _radius(api.RadiusKm radius) =>
      int.tryParse(radius.name.replaceFirst('number', '')) ?? kDefaultRadiusKm;

  String _sourceName(OriginSource source) => switch (source) {
    OriginSource.device => 'DEVICE',
    OriginSource.search => 'SEARCH',
    _ => 'MAP_PIN',
  };

  String _componentKey(api.RankingComponentKeyEnum key) =>
      key == api.RankingComponentKeyEnum.productRating
      ? 'product_rating'
      : key.name;

  // The generated heavy-restriction enum uses Dart-safe names for the NO/YES wire values.
  String _restrictionName(String wire) => switch (wire) {
    'YES' => api.CartDestinationUpdateHeavyVehicleRestrictionEnum.YES.name,
    'NO' => api.CartDestinationUpdateHeavyVehicleRestrictionEnum.NO.name,
    _ => api.CartDestinationUpdateHeavyVehicleRestrictionEnum.UNANSWERED.name,
  };

  String _restrictionWire(String name) =>
      name == api.CartDestinationHeavyVehicleRestrictionEnum.YES.name
      ? 'YES'
      : name == api.CartDestinationHeavyVehicleRestrictionEnum.NO.name
      ? 'NO'
      : 'UNANSWERED';
}

/// Maps the public Store Profile's saved-schedule fields. Dates and times are the server's
/// Asia/Manila values and are displayed as sent, whatever the phone's time zone.
StoreHoursView storeHoursFromProfile(api.PublicStoreProfile profile) =>
    StoreHoursView(
      available: profile.hoursStatus.name == 'AVAILABLE',
      week: profile.week
          .map(
            (day) => StoreHoursDayView(
              date: _isoDate(day.date),
              weekday: day.weekday,
              open: day.status.name == 'OPEN',
              fromOverride: day.source_.name == 'DATE_OVERRIDE',
              opensAt: day.opensAt,
              closesAt: day.closesAt,
            ),
          )
          .toList(),
      openNowStatus: profile.openNow.status.name,
      closesAt: profile.openNow.closesAt,
      nextOpeningDate: profile.openNow.nextOpening == null
          ? null
          : _isoDate(profile.openNow.nextOpening!.date),
      nextOpeningWeekday: profile.openNow.nextOpening?.weekday,
      nextOpeningTime: profile.openNow.nextOpening?.opensAt,
      allClosed: profile.allClosed,
      asOf: profile.hoursAsOf,
      notice: profile.hoursNotice,
    );

String _isoDate(api.Date date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
