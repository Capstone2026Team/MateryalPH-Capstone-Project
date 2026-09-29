// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_search_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ListingSearchRequestOriginSourceEnum
    _$listingSearchRequestOriginSourceEnum_DEVICE =
    const ListingSearchRequestOriginSourceEnum._('DEVICE');
const ListingSearchRequestOriginSourceEnum
    _$listingSearchRequestOriginSourceEnum_MAP_PIN =
    const ListingSearchRequestOriginSourceEnum._('MAP_PIN');
const ListingSearchRequestOriginSourceEnum
    _$listingSearchRequestOriginSourceEnum_SEARCH =
    const ListingSearchRequestOriginSourceEnum._('SEARCH');

ListingSearchRequestOriginSourceEnum
    _$listingSearchRequestOriginSourceEnumValueOf(String name) {
  switch (name) {
    case 'DEVICE':
      return _$listingSearchRequestOriginSourceEnum_DEVICE;
    case 'MAP_PIN':
      return _$listingSearchRequestOriginSourceEnum_MAP_PIN;
    case 'SEARCH':
      return _$listingSearchRequestOriginSourceEnum_SEARCH;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ListingSearchRequestOriginSourceEnum>
    _$listingSearchRequestOriginSourceEnumValues = BuiltSet<
        ListingSearchRequestOriginSourceEnum>(const <ListingSearchRequestOriginSourceEnum>[
  _$listingSearchRequestOriginSourceEnum_DEVICE,
  _$listingSearchRequestOriginSourceEnum_MAP_PIN,
  _$listingSearchRequestOriginSourceEnum_SEARCH,
]);

const ListingSearchRequestAvailabilityEnum
    _$listingSearchRequestAvailabilityEnum_ANY =
    const ListingSearchRequestAvailabilityEnum._('ANY');
const ListingSearchRequestAvailabilityEnum
    _$listingSearchRequestAvailabilityEnum_IN_STOCK =
    const ListingSearchRequestAvailabilityEnum._('IN_STOCK');

ListingSearchRequestAvailabilityEnum
    _$listingSearchRequestAvailabilityEnumValueOf(String name) {
  switch (name) {
    case 'ANY':
      return _$listingSearchRequestAvailabilityEnum_ANY;
    case 'IN_STOCK':
      return _$listingSearchRequestAvailabilityEnum_IN_STOCK;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ListingSearchRequestAvailabilityEnum>
    _$listingSearchRequestAvailabilityEnumValues = BuiltSet<
        ListingSearchRequestAvailabilityEnum>(const <ListingSearchRequestAvailabilityEnum>[
  _$listingSearchRequestAvailabilityEnum_ANY,
  _$listingSearchRequestAvailabilityEnum_IN_STOCK,
]);

const ListingSearchRequestFulfillmentEnum
    _$listingSearchRequestFulfillmentEnum_ANY =
    const ListingSearchRequestFulfillmentEnum._('ANY');
const ListingSearchRequestFulfillmentEnum
    _$listingSearchRequestFulfillmentEnum_DELIVERY =
    const ListingSearchRequestFulfillmentEnum._('DELIVERY');
const ListingSearchRequestFulfillmentEnum
    _$listingSearchRequestFulfillmentEnum_PICKUP =
    const ListingSearchRequestFulfillmentEnum._('PICKUP');

ListingSearchRequestFulfillmentEnum
    _$listingSearchRequestFulfillmentEnumValueOf(String name) {
  switch (name) {
    case 'ANY':
      return _$listingSearchRequestFulfillmentEnum_ANY;
    case 'DELIVERY':
      return _$listingSearchRequestFulfillmentEnum_DELIVERY;
    case 'PICKUP':
      return _$listingSearchRequestFulfillmentEnum_PICKUP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ListingSearchRequestFulfillmentEnum>
    _$listingSearchRequestFulfillmentEnumValues = BuiltSet<
        ListingSearchRequestFulfillmentEnum>(const <ListingSearchRequestFulfillmentEnum>[
  _$listingSearchRequestFulfillmentEnum_ANY,
  _$listingSearchRequestFulfillmentEnum_DELIVERY,
  _$listingSearchRequestFulfillmentEnum_PICKUP,
]);

const ListingSearchRequestComplianceEnum
    _$listingSearchRequestComplianceEnum_ANY =
    const ListingSearchRequestComplianceEnum._('ANY');
const ListingSearchRequestComplianceEnum
    _$listingSearchRequestComplianceEnum_PS_ICC_VERIFIED =
    const ListingSearchRequestComplianceEnum._('PS_ICC_VERIFIED');

ListingSearchRequestComplianceEnum _$listingSearchRequestComplianceEnumValueOf(
    String name) {
  switch (name) {
    case 'ANY':
      return _$listingSearchRequestComplianceEnum_ANY;
    case 'PS_ICC_VERIFIED':
      return _$listingSearchRequestComplianceEnum_PS_ICC_VERIFIED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ListingSearchRequestComplianceEnum>
    _$listingSearchRequestComplianceEnumValues = BuiltSet<
        ListingSearchRequestComplianceEnum>(const <ListingSearchRequestComplianceEnum>[
  _$listingSearchRequestComplianceEnum_ANY,
  _$listingSearchRequestComplianceEnum_PS_ICC_VERIFIED,
]);

Serializer<ListingSearchRequestOriginSourceEnum>
    _$listingSearchRequestOriginSourceEnumSerializer =
    _$ListingSearchRequestOriginSourceEnumSerializer();
Serializer<ListingSearchRequestAvailabilityEnum>
    _$listingSearchRequestAvailabilityEnumSerializer =
    _$ListingSearchRequestAvailabilityEnumSerializer();
Serializer<ListingSearchRequestFulfillmentEnum>
    _$listingSearchRequestFulfillmentEnumSerializer =
    _$ListingSearchRequestFulfillmentEnumSerializer();
Serializer<ListingSearchRequestComplianceEnum>
    _$listingSearchRequestComplianceEnumSerializer =
    _$ListingSearchRequestComplianceEnumSerializer();

class _$ListingSearchRequestOriginSourceEnumSerializer
    implements PrimitiveSerializer<ListingSearchRequestOriginSourceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DEVICE': 'DEVICE',
    'MAP_PIN': 'MAP_PIN',
    'SEARCH': 'SEARCH',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DEVICE': 'DEVICE',
    'MAP_PIN': 'MAP_PIN',
    'SEARCH': 'SEARCH',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ListingSearchRequestOriginSourceEnum
  ];
  @override
  final String wireName = 'ListingSearchRequestOriginSourceEnum';

  @override
  Object serialize(
          Serializers serializers, ListingSearchRequestOriginSourceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ListingSearchRequestOriginSourceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ListingSearchRequestOriginSourceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ListingSearchRequestAvailabilityEnumSerializer
    implements PrimitiveSerializer<ListingSearchRequestAvailabilityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ANY': 'ANY',
    'IN_STOCK': 'IN_STOCK',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ANY': 'ANY',
    'IN_STOCK': 'IN_STOCK',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ListingSearchRequestAvailabilityEnum
  ];
  @override
  final String wireName = 'ListingSearchRequestAvailabilityEnum';

  @override
  Object serialize(
          Serializers serializers, ListingSearchRequestAvailabilityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ListingSearchRequestAvailabilityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ListingSearchRequestAvailabilityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ListingSearchRequestFulfillmentEnumSerializer
    implements PrimitiveSerializer<ListingSearchRequestFulfillmentEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ANY': 'ANY',
    'DELIVERY': 'DELIVERY',
    'PICKUP': 'PICKUP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ANY': 'ANY',
    'DELIVERY': 'DELIVERY',
    'PICKUP': 'PICKUP',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ListingSearchRequestFulfillmentEnum
  ];
  @override
  final String wireName = 'ListingSearchRequestFulfillmentEnum';

  @override
  Object serialize(
          Serializers serializers, ListingSearchRequestFulfillmentEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ListingSearchRequestFulfillmentEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ListingSearchRequestFulfillmentEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ListingSearchRequestComplianceEnumSerializer
    implements PrimitiveSerializer<ListingSearchRequestComplianceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ANY': 'ANY',
    'PS_ICC_VERIFIED': 'PS_ICC_VERIFIED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ANY': 'ANY',
    'PS_ICC_VERIFIED': 'PS_ICC_VERIFIED',
  };

  @override
  final Iterable<Type> types = const <Type>[ListingSearchRequestComplianceEnum];
  @override
  final String wireName = 'ListingSearchRequestComplianceEnum';

  @override
  Object serialize(
          Serializers serializers, ListingSearchRequestComplianceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ListingSearchRequestComplianceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ListingSearchRequestComplianceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ListingSearchRequest extends ListingSearchRequest {
  @override
  final String? locationId;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final ListingSearchRequestOriginSourceEnum? originSource;
  @override
  final int? radiusKm;
  @override
  final String? query;
  @override
  final ListingSearchSort? sort;
  @override
  final String? categoryId;
  @override
  final String? brand;
  @override
  final String? variant;
  @override
  final ListingSearchRequestAvailabilityEnum? availability;
  @override
  final ListingSearchRequestFulfillmentEnum? fulfillment;
  @override
  final bool? favoritesOnly;
  @override
  final ListingSearchRequestComplianceEnum? compliance;
  @override
  final int? minPriceCentavos;
  @override
  final int? maxPriceCentavos;
  @override
  final String? vendorId;
  @override
  final String? cursor;
  @override
  final int? perPage;

  factory _$ListingSearchRequest(
          [void Function(ListingSearchRequestBuilder)? updates]) =>
      (ListingSearchRequestBuilder()..update(updates))._build();

  _$ListingSearchRequest._(
      {this.locationId,
      this.latitude,
      this.longitude,
      this.originSource,
      this.radiusKm,
      this.query,
      this.sort,
      this.categoryId,
      this.brand,
      this.variant,
      this.availability,
      this.fulfillment,
      this.favoritesOnly,
      this.compliance,
      this.minPriceCentavos,
      this.maxPriceCentavos,
      this.vendorId,
      this.cursor,
      this.perPage})
      : super._();
  @override
  ListingSearchRequest rebuild(
          void Function(ListingSearchRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListingSearchRequestBuilder toBuilder() =>
      ListingSearchRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListingSearchRequest &&
        locationId == other.locationId &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        originSource == other.originSource &&
        radiusKm == other.radiusKm &&
        query == other.query &&
        sort == other.sort &&
        categoryId == other.categoryId &&
        brand == other.brand &&
        variant == other.variant &&
        availability == other.availability &&
        fulfillment == other.fulfillment &&
        favoritesOnly == other.favoritesOnly &&
        compliance == other.compliance &&
        minPriceCentavos == other.minPriceCentavos &&
        maxPriceCentavos == other.maxPriceCentavos &&
        vendorId == other.vendorId &&
        cursor == other.cursor &&
        perPage == other.perPage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, locationId.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, originSource.hashCode);
    _$hash = $jc(_$hash, radiusKm.hashCode);
    _$hash = $jc(_$hash, query.hashCode);
    _$hash = $jc(_$hash, sort.hashCode);
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, brand.hashCode);
    _$hash = $jc(_$hash, variant.hashCode);
    _$hash = $jc(_$hash, availability.hashCode);
    _$hash = $jc(_$hash, fulfillment.hashCode);
    _$hash = $jc(_$hash, favoritesOnly.hashCode);
    _$hash = $jc(_$hash, compliance.hashCode);
    _$hash = $jc(_$hash, minPriceCentavos.hashCode);
    _$hash = $jc(_$hash, maxPriceCentavos.hashCode);
    _$hash = $jc(_$hash, vendorId.hashCode);
    _$hash = $jc(_$hash, cursor.hashCode);
    _$hash = $jc(_$hash, perPage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListingSearchRequest')
          ..add('locationId', locationId)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('originSource', originSource)
          ..add('radiusKm', radiusKm)
          ..add('query', query)
          ..add('sort', sort)
          ..add('categoryId', categoryId)
          ..add('brand', brand)
          ..add('variant', variant)
          ..add('availability', availability)
          ..add('fulfillment', fulfillment)
          ..add('favoritesOnly', favoritesOnly)
          ..add('compliance', compliance)
          ..add('minPriceCentavos', minPriceCentavos)
          ..add('maxPriceCentavos', maxPriceCentavos)
          ..add('vendorId', vendorId)
          ..add('cursor', cursor)
          ..add('perPage', perPage))
        .toString();
  }
}

class ListingSearchRequestBuilder
    implements Builder<ListingSearchRequest, ListingSearchRequestBuilder> {
  _$ListingSearchRequest? _$v;

  String? _locationId;
  String? get locationId => _$this._locationId;
  set locationId(String? locationId) => _$this._locationId = locationId;

  double? _latitude;
  double? get latitude => _$this._latitude;
  set latitude(double? latitude) => _$this._latitude = latitude;

  double? _longitude;
  double? get longitude => _$this._longitude;
  set longitude(double? longitude) => _$this._longitude = longitude;

  ListingSearchRequestOriginSourceEnum? _originSource;
  ListingSearchRequestOriginSourceEnum? get originSource =>
      _$this._originSource;
  set originSource(ListingSearchRequestOriginSourceEnum? originSource) =>
      _$this._originSource = originSource;

  int? _radiusKm;
  int? get radiusKm => _$this._radiusKm;
  set radiusKm(int? radiusKm) => _$this._radiusKm = radiusKm;

  String? _query;
  String? get query => _$this._query;
  set query(String? query) => _$this._query = query;

  ListingSearchSort? _sort;
  ListingSearchSort? get sort => _$this._sort;
  set sort(ListingSearchSort? sort) => _$this._sort = sort;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  String? _brand;
  String? get brand => _$this._brand;
  set brand(String? brand) => _$this._brand = brand;

  String? _variant;
  String? get variant => _$this._variant;
  set variant(String? variant) => _$this._variant = variant;

  ListingSearchRequestAvailabilityEnum? _availability;
  ListingSearchRequestAvailabilityEnum? get availability =>
      _$this._availability;
  set availability(ListingSearchRequestAvailabilityEnum? availability) =>
      _$this._availability = availability;

  ListingSearchRequestFulfillmentEnum? _fulfillment;
  ListingSearchRequestFulfillmentEnum? get fulfillment => _$this._fulfillment;
  set fulfillment(ListingSearchRequestFulfillmentEnum? fulfillment) =>
      _$this._fulfillment = fulfillment;

  bool? _favoritesOnly;
  bool? get favoritesOnly => _$this._favoritesOnly;
  set favoritesOnly(bool? favoritesOnly) =>
      _$this._favoritesOnly = favoritesOnly;

  ListingSearchRequestComplianceEnum? _compliance;
  ListingSearchRequestComplianceEnum? get compliance => _$this._compliance;
  set compliance(ListingSearchRequestComplianceEnum? compliance) =>
      _$this._compliance = compliance;

  int? _minPriceCentavos;
  int? get minPriceCentavos => _$this._minPriceCentavos;
  set minPriceCentavos(int? minPriceCentavos) =>
      _$this._minPriceCentavos = minPriceCentavos;

  int? _maxPriceCentavos;
  int? get maxPriceCentavos => _$this._maxPriceCentavos;
  set maxPriceCentavos(int? maxPriceCentavos) =>
      _$this._maxPriceCentavos = maxPriceCentavos;

  String? _vendorId;
  String? get vendorId => _$this._vendorId;
  set vendorId(String? vendorId) => _$this._vendorId = vendorId;

  String? _cursor;
  String? get cursor => _$this._cursor;
  set cursor(String? cursor) => _$this._cursor = cursor;

  int? _perPage;
  int? get perPage => _$this._perPage;
  set perPage(int? perPage) => _$this._perPage = perPage;

  ListingSearchRequestBuilder() {
    ListingSearchRequest._defaults(this);
  }

  ListingSearchRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _locationId = $v.locationId;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _originSource = $v.originSource;
      _radiusKm = $v.radiusKm;
      _query = $v.query;
      _sort = $v.sort;
      _categoryId = $v.categoryId;
      _brand = $v.brand;
      _variant = $v.variant;
      _availability = $v.availability;
      _fulfillment = $v.fulfillment;
      _favoritesOnly = $v.favoritesOnly;
      _compliance = $v.compliance;
      _minPriceCentavos = $v.minPriceCentavos;
      _maxPriceCentavos = $v.maxPriceCentavos;
      _vendorId = $v.vendorId;
      _cursor = $v.cursor;
      _perPage = $v.perPage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListingSearchRequest other) {
    _$v = other as _$ListingSearchRequest;
  }

  @override
  void update(void Function(ListingSearchRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListingSearchRequest build() => _build();

  _$ListingSearchRequest _build() {
    final _$result = _$v ??
        _$ListingSearchRequest._(
          locationId: locationId,
          latitude: latitude,
          longitude: longitude,
          originSource: originSource,
          radiusKm: radiusKm,
          query: query,
          sort: sort,
          categoryId: categoryId,
          brand: brand,
          variant: variant,
          availability: availability,
          fulfillment: fulfillment,
          favoritesOnly: favoritesOnly,
          compliance: compliance,
          minPriceCentavos: minPriceCentavos,
          maxPriceCentavos: maxPriceCentavos,
          vendorId: vendorId,
          cursor: cursor,
          perPage: perPage,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
