// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_details.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ListingDetailsNotPurchasableReasonEnum
    _$listingDetailsNotPurchasableReasonEnum_OUTSIDE_SELECTED_RADIUS =
    const ListingDetailsNotPurchasableReasonEnum._('OUTSIDE_SELECTED_RADIUS');
const ListingDetailsNotPurchasableReasonEnum
    _$listingDetailsNotPurchasableReasonEnum_STORE_PAUSED =
    const ListingDetailsNotPurchasableReasonEnum._('STORE_PAUSED');

ListingDetailsNotPurchasableReasonEnum
    _$listingDetailsNotPurchasableReasonEnumValueOf(String name) {
  switch (name) {
    case 'OUTSIDE_SELECTED_RADIUS':
      return _$listingDetailsNotPurchasableReasonEnum_OUTSIDE_SELECTED_RADIUS;
    case 'STORE_PAUSED':
      return _$listingDetailsNotPurchasableReasonEnum_STORE_PAUSED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ListingDetailsNotPurchasableReasonEnum>
    _$listingDetailsNotPurchasableReasonEnumValues = BuiltSet<
        ListingDetailsNotPurchasableReasonEnum>(const <ListingDetailsNotPurchasableReasonEnum>[
  _$listingDetailsNotPurchasableReasonEnum_OUTSIDE_SELECTED_RADIUS,
  _$listingDetailsNotPurchasableReasonEnum_STORE_PAUSED,
]);

Serializer<ListingDetailsNotPurchasableReasonEnum>
    _$listingDetailsNotPurchasableReasonEnumSerializer =
    _$ListingDetailsNotPurchasableReasonEnumSerializer();

class _$ListingDetailsNotPurchasableReasonEnumSerializer
    implements PrimitiveSerializer<ListingDetailsNotPurchasableReasonEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OUTSIDE_SELECTED_RADIUS': 'OUTSIDE_SELECTED_RADIUS',
    'STORE_PAUSED': 'STORE_PAUSED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OUTSIDE_SELECTED_RADIUS': 'OUTSIDE_SELECTED_RADIUS',
    'STORE_PAUSED': 'STORE_PAUSED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ListingDetailsNotPurchasableReasonEnum
  ];
  @override
  final String wireName = 'ListingDetailsNotPurchasableReasonEnum';

  @override
  Object serialize(Serializers serializers,
          ListingDetailsNotPurchasableReasonEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ListingDetailsNotPurchasableReasonEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ListingDetailsNotPurchasableReasonEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ListingDetails extends ListingDetails {
  @override
  final String listingId;
  @override
  final int publicationVersion;
  @override
  final String displayName;
  @override
  final String? description;
  @override
  final String? brand;
  @override
  final String? model;
  @override
  final String? manufacturer;
  @override
  final String? countryOfManufacture;
  @override
  final ListingCategoryRef? category;
  @override
  final BuiltMap<String, JsonObject?> technicalAttributes;
  @override
  final BuiltList<ListingImage> images;
  @override
  final ListingCompliance compliance;
  @override
  final ProductRatingSummary productRating;
  @override
  final String unitsSold;
  @override
  final bool isFavorite;
  @override
  final bool purchasable;
  @override
  final ListingDetailsNotPurchasableReasonEnum? notPurchasableReason;
  @override
  final int distanceMeters;
  @override
  final ListingDetailVendor vendor;
  @override
  final ListingDetailFulfillment fulfillment;
  @override
  final BuiltList<ListingVariantOffer> variants;
  @override
  final DiscoveryScope scope;
  @override
  final DateTime currentAsOf;
  @override
  final String eligibilityVersion;

  factory _$ListingDetails([void Function(ListingDetailsBuilder)? updates]) =>
      (ListingDetailsBuilder()..update(updates))._build();

  _$ListingDetails._(
      {required this.listingId,
      required this.publicationVersion,
      required this.displayName,
      this.description,
      this.brand,
      this.model,
      this.manufacturer,
      this.countryOfManufacture,
      this.category,
      required this.technicalAttributes,
      required this.images,
      required this.compliance,
      required this.productRating,
      required this.unitsSold,
      required this.isFavorite,
      required this.purchasable,
      this.notPurchasableReason,
      required this.distanceMeters,
      required this.vendor,
      required this.fulfillment,
      required this.variants,
      required this.scope,
      required this.currentAsOf,
      required this.eligibilityVersion})
      : super._();
  @override
  ListingDetails rebuild(void Function(ListingDetailsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListingDetailsBuilder toBuilder() => ListingDetailsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListingDetails &&
        listingId == other.listingId &&
        publicationVersion == other.publicationVersion &&
        displayName == other.displayName &&
        description == other.description &&
        brand == other.brand &&
        model == other.model &&
        manufacturer == other.manufacturer &&
        countryOfManufacture == other.countryOfManufacture &&
        category == other.category &&
        technicalAttributes == other.technicalAttributes &&
        images == other.images &&
        compliance == other.compliance &&
        productRating == other.productRating &&
        unitsSold == other.unitsSold &&
        isFavorite == other.isFavorite &&
        purchasable == other.purchasable &&
        notPurchasableReason == other.notPurchasableReason &&
        distanceMeters == other.distanceMeters &&
        vendor == other.vendor &&
        fulfillment == other.fulfillment &&
        variants == other.variants &&
        scope == other.scope &&
        currentAsOf == other.currentAsOf &&
        eligibilityVersion == other.eligibilityVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, listingId.hashCode);
    _$hash = $jc(_$hash, publicationVersion.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, brand.hashCode);
    _$hash = $jc(_$hash, model.hashCode);
    _$hash = $jc(_$hash, manufacturer.hashCode);
    _$hash = $jc(_$hash, countryOfManufacture.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, technicalAttributes.hashCode);
    _$hash = $jc(_$hash, images.hashCode);
    _$hash = $jc(_$hash, compliance.hashCode);
    _$hash = $jc(_$hash, productRating.hashCode);
    _$hash = $jc(_$hash, unitsSold.hashCode);
    _$hash = $jc(_$hash, isFavorite.hashCode);
    _$hash = $jc(_$hash, purchasable.hashCode);
    _$hash = $jc(_$hash, notPurchasableReason.hashCode);
    _$hash = $jc(_$hash, distanceMeters.hashCode);
    _$hash = $jc(_$hash, vendor.hashCode);
    _$hash = $jc(_$hash, fulfillment.hashCode);
    _$hash = $jc(_$hash, variants.hashCode);
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, currentAsOf.hashCode);
    _$hash = $jc(_$hash, eligibilityVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListingDetails')
          ..add('listingId', listingId)
          ..add('publicationVersion', publicationVersion)
          ..add('displayName', displayName)
          ..add('description', description)
          ..add('brand', brand)
          ..add('model', model)
          ..add('manufacturer', manufacturer)
          ..add('countryOfManufacture', countryOfManufacture)
          ..add('category', category)
          ..add('technicalAttributes', technicalAttributes)
          ..add('images', images)
          ..add('compliance', compliance)
          ..add('productRating', productRating)
          ..add('unitsSold', unitsSold)
          ..add('isFavorite', isFavorite)
          ..add('purchasable', purchasable)
          ..add('notPurchasableReason', notPurchasableReason)
          ..add('distanceMeters', distanceMeters)
          ..add('vendor', vendor)
          ..add('fulfillment', fulfillment)
          ..add('variants', variants)
          ..add('scope', scope)
          ..add('currentAsOf', currentAsOf)
          ..add('eligibilityVersion', eligibilityVersion))
        .toString();
  }
}

class ListingDetailsBuilder
    implements Builder<ListingDetails, ListingDetailsBuilder> {
  _$ListingDetails? _$v;

  String? _listingId;
  String? get listingId => _$this._listingId;
  set listingId(String? listingId) => _$this._listingId = listingId;

  int? _publicationVersion;
  int? get publicationVersion => _$this._publicationVersion;
  set publicationVersion(int? publicationVersion) =>
      _$this._publicationVersion = publicationVersion;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _brand;
  String? get brand => _$this._brand;
  set brand(String? brand) => _$this._brand = brand;

  String? _model;
  String? get model => _$this._model;
  set model(String? model) => _$this._model = model;

  String? _manufacturer;
  String? get manufacturer => _$this._manufacturer;
  set manufacturer(String? manufacturer) => _$this._manufacturer = manufacturer;

  String? _countryOfManufacture;
  String? get countryOfManufacture => _$this._countryOfManufacture;
  set countryOfManufacture(String? countryOfManufacture) =>
      _$this._countryOfManufacture = countryOfManufacture;

  ListingCategoryRefBuilder? _category;
  ListingCategoryRefBuilder get category =>
      _$this._category ??= ListingCategoryRefBuilder();
  set category(ListingCategoryRefBuilder? category) =>
      _$this._category = category;

  MapBuilder<String, JsonObject?>? _technicalAttributes;
  MapBuilder<String, JsonObject?> get technicalAttributes =>
      _$this._technicalAttributes ??= MapBuilder<String, JsonObject?>();
  set technicalAttributes(
          MapBuilder<String, JsonObject?>? technicalAttributes) =>
      _$this._technicalAttributes = technicalAttributes;

  ListBuilder<ListingImage>? _images;
  ListBuilder<ListingImage> get images =>
      _$this._images ??= ListBuilder<ListingImage>();
  set images(ListBuilder<ListingImage>? images) => _$this._images = images;

  ListingComplianceBuilder? _compliance;
  ListingComplianceBuilder get compliance =>
      _$this._compliance ??= ListingComplianceBuilder();
  set compliance(ListingComplianceBuilder? compliance) =>
      _$this._compliance = compliance;

  ProductRatingSummaryBuilder? _productRating;
  ProductRatingSummaryBuilder get productRating =>
      _$this._productRating ??= ProductRatingSummaryBuilder();
  set productRating(ProductRatingSummaryBuilder? productRating) =>
      _$this._productRating = productRating;

  String? _unitsSold;
  String? get unitsSold => _$this._unitsSold;
  set unitsSold(String? unitsSold) => _$this._unitsSold = unitsSold;

  bool? _isFavorite;
  bool? get isFavorite => _$this._isFavorite;
  set isFavorite(bool? isFavorite) => _$this._isFavorite = isFavorite;

  bool? _purchasable;
  bool? get purchasable => _$this._purchasable;
  set purchasable(bool? purchasable) => _$this._purchasable = purchasable;

  ListingDetailsNotPurchasableReasonEnum? _notPurchasableReason;
  ListingDetailsNotPurchasableReasonEnum? get notPurchasableReason =>
      _$this._notPurchasableReason;
  set notPurchasableReason(
          ListingDetailsNotPurchasableReasonEnum? notPurchasableReason) =>
      _$this._notPurchasableReason = notPurchasableReason;

  int? _distanceMeters;
  int? get distanceMeters => _$this._distanceMeters;
  set distanceMeters(int? distanceMeters) =>
      _$this._distanceMeters = distanceMeters;

  ListingDetailVendorBuilder? _vendor;
  ListingDetailVendorBuilder get vendor =>
      _$this._vendor ??= ListingDetailVendorBuilder();
  set vendor(ListingDetailVendorBuilder? vendor) => _$this._vendor = vendor;

  ListingDetailFulfillmentBuilder? _fulfillment;
  ListingDetailFulfillmentBuilder get fulfillment =>
      _$this._fulfillment ??= ListingDetailFulfillmentBuilder();
  set fulfillment(ListingDetailFulfillmentBuilder? fulfillment) =>
      _$this._fulfillment = fulfillment;

  ListBuilder<ListingVariantOffer>? _variants;
  ListBuilder<ListingVariantOffer> get variants =>
      _$this._variants ??= ListBuilder<ListingVariantOffer>();
  set variants(ListBuilder<ListingVariantOffer>? variants) =>
      _$this._variants = variants;

  DiscoveryScopeBuilder? _scope;
  DiscoveryScopeBuilder get scope => _$this._scope ??= DiscoveryScopeBuilder();
  set scope(DiscoveryScopeBuilder? scope) => _$this._scope = scope;

  DateTime? _currentAsOf;
  DateTime? get currentAsOf => _$this._currentAsOf;
  set currentAsOf(DateTime? currentAsOf) => _$this._currentAsOf = currentAsOf;

  String? _eligibilityVersion;
  String? get eligibilityVersion => _$this._eligibilityVersion;
  set eligibilityVersion(String? eligibilityVersion) =>
      _$this._eligibilityVersion = eligibilityVersion;

  ListingDetailsBuilder() {
    ListingDetails._defaults(this);
  }

  ListingDetailsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _listingId = $v.listingId;
      _publicationVersion = $v.publicationVersion;
      _displayName = $v.displayName;
      _description = $v.description;
      _brand = $v.brand;
      _model = $v.model;
      _manufacturer = $v.manufacturer;
      _countryOfManufacture = $v.countryOfManufacture;
      _category = $v.category?.toBuilder();
      _technicalAttributes = $v.technicalAttributes.toBuilder();
      _images = $v.images.toBuilder();
      _compliance = $v.compliance.toBuilder();
      _productRating = $v.productRating.toBuilder();
      _unitsSold = $v.unitsSold;
      _isFavorite = $v.isFavorite;
      _purchasable = $v.purchasable;
      _notPurchasableReason = $v.notPurchasableReason;
      _distanceMeters = $v.distanceMeters;
      _vendor = $v.vendor.toBuilder();
      _fulfillment = $v.fulfillment.toBuilder();
      _variants = $v.variants.toBuilder();
      _scope = $v.scope.toBuilder();
      _currentAsOf = $v.currentAsOf;
      _eligibilityVersion = $v.eligibilityVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListingDetails other) {
    _$v = other as _$ListingDetails;
  }

  @override
  void update(void Function(ListingDetailsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListingDetails build() => _build();

  _$ListingDetails _build() {
    _$ListingDetails _$result;
    try {
      _$result = _$v ??
          _$ListingDetails._(
            listingId: BuiltValueNullFieldError.checkNotNull(
                listingId, r'ListingDetails', 'listingId'),
            publicationVersion: BuiltValueNullFieldError.checkNotNull(
                publicationVersion, r'ListingDetails', 'publicationVersion'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'ListingDetails', 'displayName'),
            description: description,
            brand: brand,
            model: model,
            manufacturer: manufacturer,
            countryOfManufacture: countryOfManufacture,
            category: _category?.build(),
            technicalAttributes: technicalAttributes.build(),
            images: images.build(),
            compliance: compliance.build(),
            productRating: productRating.build(),
            unitsSold: BuiltValueNullFieldError.checkNotNull(
                unitsSold, r'ListingDetails', 'unitsSold'),
            isFavorite: BuiltValueNullFieldError.checkNotNull(
                isFavorite, r'ListingDetails', 'isFavorite'),
            purchasable: BuiltValueNullFieldError.checkNotNull(
                purchasable, r'ListingDetails', 'purchasable'),
            notPurchasableReason: notPurchasableReason,
            distanceMeters: BuiltValueNullFieldError.checkNotNull(
                distanceMeters, r'ListingDetails', 'distanceMeters'),
            vendor: vendor.build(),
            fulfillment: fulfillment.build(),
            variants: variants.build(),
            scope: scope.build(),
            currentAsOf: BuiltValueNullFieldError.checkNotNull(
                currentAsOf, r'ListingDetails', 'currentAsOf'),
            eligibilityVersion: BuiltValueNullFieldError.checkNotNull(
                eligibilityVersion, r'ListingDetails', 'eligibilityVersion'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'category';
        _category?.build();
        _$failedField = 'technicalAttributes';
        technicalAttributes.build();
        _$failedField = 'images';
        images.build();
        _$failedField = 'compliance';
        compliance.build();
        _$failedField = 'productRating';
        productRating.build();

        _$failedField = 'vendor';
        vendor.build();
        _$failedField = 'fulfillment';
        fulfillment.build();
        _$failedField = 'variants';
        variants.build();
        _$failedField = 'scope';
        scope.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ListingDetails', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
