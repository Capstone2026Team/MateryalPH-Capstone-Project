// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery_search_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DiscoverySearchRequestOriginSourceEnum
    _$discoverySearchRequestOriginSourceEnum_DEVICE =
    const DiscoverySearchRequestOriginSourceEnum._('DEVICE');
const DiscoverySearchRequestOriginSourceEnum
    _$discoverySearchRequestOriginSourceEnum_MAP_PIN =
    const DiscoverySearchRequestOriginSourceEnum._('MAP_PIN');
const DiscoverySearchRequestOriginSourceEnum
    _$discoverySearchRequestOriginSourceEnum_SEARCH =
    const DiscoverySearchRequestOriginSourceEnum._('SEARCH');

DiscoverySearchRequestOriginSourceEnum
    _$discoverySearchRequestOriginSourceEnumValueOf(String name) {
  switch (name) {
    case 'DEVICE':
      return _$discoverySearchRequestOriginSourceEnum_DEVICE;
    case 'MAP_PIN':
      return _$discoverySearchRequestOriginSourceEnum_MAP_PIN;
    case 'SEARCH':
      return _$discoverySearchRequestOriginSourceEnum_SEARCH;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DiscoverySearchRequestOriginSourceEnum>
    _$discoverySearchRequestOriginSourceEnumValues = BuiltSet<
        DiscoverySearchRequestOriginSourceEnum>(const <DiscoverySearchRequestOriginSourceEnum>[
  _$discoverySearchRequestOriginSourceEnum_DEVICE,
  _$discoverySearchRequestOriginSourceEnum_MAP_PIN,
  _$discoverySearchRequestOriginSourceEnum_SEARCH,
]);

const DiscoverySearchRequestDirectoryMinRatingEnum
    _$discoverySearchRequestDirectoryMinRatingEnum_number3Period0 =
    const DiscoverySearchRequestDirectoryMinRatingEnum._('number3Period0');
const DiscoverySearchRequestDirectoryMinRatingEnum
    _$discoverySearchRequestDirectoryMinRatingEnum_number3Period5 =
    const DiscoverySearchRequestDirectoryMinRatingEnum._('number3Period5');
const DiscoverySearchRequestDirectoryMinRatingEnum
    _$discoverySearchRequestDirectoryMinRatingEnum_number4Period0 =
    const DiscoverySearchRequestDirectoryMinRatingEnum._('number4Period0');
const DiscoverySearchRequestDirectoryMinRatingEnum
    _$discoverySearchRequestDirectoryMinRatingEnum_number4Period5 =
    const DiscoverySearchRequestDirectoryMinRatingEnum._('number4Period5');

DiscoverySearchRequestDirectoryMinRatingEnum
    _$discoverySearchRequestDirectoryMinRatingEnumValueOf(String name) {
  switch (name) {
    case 'number3Period0':
      return _$discoverySearchRequestDirectoryMinRatingEnum_number3Period0;
    case 'number3Period5':
      return _$discoverySearchRequestDirectoryMinRatingEnum_number3Period5;
    case 'number4Period0':
      return _$discoverySearchRequestDirectoryMinRatingEnum_number4Period0;
    case 'number4Period5':
      return _$discoverySearchRequestDirectoryMinRatingEnum_number4Period5;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DiscoverySearchRequestDirectoryMinRatingEnum>
    _$discoverySearchRequestDirectoryMinRatingEnumValues = BuiltSet<
        DiscoverySearchRequestDirectoryMinRatingEnum>(const <DiscoverySearchRequestDirectoryMinRatingEnum>[
  _$discoverySearchRequestDirectoryMinRatingEnum_number3Period0,
  _$discoverySearchRequestDirectoryMinRatingEnum_number3Period5,
  _$discoverySearchRequestDirectoryMinRatingEnum_number4Period0,
  _$discoverySearchRequestDirectoryMinRatingEnum_number4Period5,
]);

const DiscoverySearchRequestDirectoryMaxDistanceKmEnum
    _$discoverySearchRequestDirectoryMaxDistanceKmEnum_number1 =
    const DiscoverySearchRequestDirectoryMaxDistanceKmEnum._('number1');
const DiscoverySearchRequestDirectoryMaxDistanceKmEnum
    _$discoverySearchRequestDirectoryMaxDistanceKmEnum_number3 =
    const DiscoverySearchRequestDirectoryMaxDistanceKmEnum._('number3');
const DiscoverySearchRequestDirectoryMaxDistanceKmEnum
    _$discoverySearchRequestDirectoryMaxDistanceKmEnum_number5 =
    const DiscoverySearchRequestDirectoryMaxDistanceKmEnum._('number5');
const DiscoverySearchRequestDirectoryMaxDistanceKmEnum
    _$discoverySearchRequestDirectoryMaxDistanceKmEnum_number10 =
    const DiscoverySearchRequestDirectoryMaxDistanceKmEnum._('number10');
const DiscoverySearchRequestDirectoryMaxDistanceKmEnum
    _$discoverySearchRequestDirectoryMaxDistanceKmEnum_number20 =
    const DiscoverySearchRequestDirectoryMaxDistanceKmEnum._('number20');

DiscoverySearchRequestDirectoryMaxDistanceKmEnum
    _$discoverySearchRequestDirectoryMaxDistanceKmEnumValueOf(String name) {
  switch (name) {
    case 'number1':
      return _$discoverySearchRequestDirectoryMaxDistanceKmEnum_number1;
    case 'number3':
      return _$discoverySearchRequestDirectoryMaxDistanceKmEnum_number3;
    case 'number5':
      return _$discoverySearchRequestDirectoryMaxDistanceKmEnum_number5;
    case 'number10':
      return _$discoverySearchRequestDirectoryMaxDistanceKmEnum_number10;
    case 'number20':
      return _$discoverySearchRequestDirectoryMaxDistanceKmEnum_number20;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DiscoverySearchRequestDirectoryMaxDistanceKmEnum>
    _$discoverySearchRequestDirectoryMaxDistanceKmEnumValues = BuiltSet<
        DiscoverySearchRequestDirectoryMaxDistanceKmEnum>(const <DiscoverySearchRequestDirectoryMaxDistanceKmEnum>[
  _$discoverySearchRequestDirectoryMaxDistanceKmEnum_number1,
  _$discoverySearchRequestDirectoryMaxDistanceKmEnum_number3,
  _$discoverySearchRequestDirectoryMaxDistanceKmEnum_number5,
  _$discoverySearchRequestDirectoryMaxDistanceKmEnum_number10,
  _$discoverySearchRequestDirectoryMaxDistanceKmEnum_number20,
]);

Serializer<DiscoverySearchRequestOriginSourceEnum>
    _$discoverySearchRequestOriginSourceEnumSerializer =
    _$DiscoverySearchRequestOriginSourceEnumSerializer();
Serializer<DiscoverySearchRequestDirectoryMinRatingEnum>
    _$discoverySearchRequestDirectoryMinRatingEnumSerializer =
    _$DiscoverySearchRequestDirectoryMinRatingEnumSerializer();
Serializer<DiscoverySearchRequestDirectoryMaxDistanceKmEnum>
    _$discoverySearchRequestDirectoryMaxDistanceKmEnumSerializer =
    _$DiscoverySearchRequestDirectoryMaxDistanceKmEnumSerializer();

class _$DiscoverySearchRequestOriginSourceEnumSerializer
    implements PrimitiveSerializer<DiscoverySearchRequestOriginSourceEnum> {
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
    DiscoverySearchRequestOriginSourceEnum
  ];
  @override
  final String wireName = 'DiscoverySearchRequestOriginSourceEnum';

  @override
  Object serialize(Serializers serializers,
          DiscoverySearchRequestOriginSourceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DiscoverySearchRequestOriginSourceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DiscoverySearchRequestOriginSourceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DiscoverySearchRequestDirectoryMinRatingEnumSerializer
    implements
        PrimitiveSerializer<DiscoverySearchRequestDirectoryMinRatingEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'number3Period0': '3.0',
    'number3Period5': '3.5',
    'number4Period0': '4.0',
    'number4Period5': '4.5',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    '3.0': 'number3Period0',
    '3.5': 'number3Period5',
    '4.0': 'number4Period0',
    '4.5': 'number4Period5',
  };

  @override
  final Iterable<Type> types = const <Type>[
    DiscoverySearchRequestDirectoryMinRatingEnum
  ];
  @override
  final String wireName = 'DiscoverySearchRequestDirectoryMinRatingEnum';

  @override
  Object serialize(Serializers serializers,
          DiscoverySearchRequestDirectoryMinRatingEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DiscoverySearchRequestDirectoryMinRatingEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DiscoverySearchRequestDirectoryMinRatingEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DiscoverySearchRequestDirectoryMaxDistanceKmEnumSerializer
    implements
        PrimitiveSerializer<DiscoverySearchRequestDirectoryMaxDistanceKmEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'number1': 1,
    'number3': 3,
    'number5': 5,
    'number10': 10,
    'number20': 20,
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    1: 'number1',
    3: 'number3',
    5: 'number5',
    10: 'number10',
    20: 'number20',
  };

  @override
  final Iterable<Type> types = const <Type>[
    DiscoverySearchRequestDirectoryMaxDistanceKmEnum
  ];
  @override
  final String wireName = 'DiscoverySearchRequestDirectoryMaxDistanceKmEnum';

  @override
  Object serialize(Serializers serializers,
          DiscoverySearchRequestDirectoryMaxDistanceKmEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DiscoverySearchRequestDirectoryMaxDistanceKmEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DiscoverySearchRequestDirectoryMaxDistanceKmEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DiscoverySearchRequest extends DiscoverySearchRequest {
  @override
  final String? locationId;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final DiscoverySearchRequestOriginSourceEnum? originSource;
  @override
  final int? radiusKm;
  @override
  final bool? includeVerified;
  @override
  final bool? includeDirectory;
  @override
  final bool? favoritesOnly;
  @override
  final DiscoverySearchRequestDirectoryMinRatingEnum? directoryMinRating;
  @override
  final DiscoverySearchRequestDirectoryMaxDistanceKmEnum?
      directoryMaxDistanceKm;
  @override
  final String? supplierType;
  @override
  final String? categoryId;
  @override
  final int? page;
  @override
  final int? perPage;

  factory _$DiscoverySearchRequest(
          [void Function(DiscoverySearchRequestBuilder)? updates]) =>
      (DiscoverySearchRequestBuilder()..update(updates))._build();

  _$DiscoverySearchRequest._(
      {this.locationId,
      this.latitude,
      this.longitude,
      this.originSource,
      this.radiusKm,
      this.includeVerified,
      this.includeDirectory,
      this.favoritesOnly,
      this.directoryMinRating,
      this.directoryMaxDistanceKm,
      this.supplierType,
      this.categoryId,
      this.page,
      this.perPage})
      : super._();
  @override
  DiscoverySearchRequest rebuild(
          void Function(DiscoverySearchRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DiscoverySearchRequestBuilder toBuilder() =>
      DiscoverySearchRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DiscoverySearchRequest &&
        locationId == other.locationId &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        originSource == other.originSource &&
        radiusKm == other.radiusKm &&
        includeVerified == other.includeVerified &&
        includeDirectory == other.includeDirectory &&
        favoritesOnly == other.favoritesOnly &&
        directoryMinRating == other.directoryMinRating &&
        directoryMaxDistanceKm == other.directoryMaxDistanceKm &&
        supplierType == other.supplierType &&
        categoryId == other.categoryId &&
        page == other.page &&
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
    _$hash = $jc(_$hash, includeVerified.hashCode);
    _$hash = $jc(_$hash, includeDirectory.hashCode);
    _$hash = $jc(_$hash, favoritesOnly.hashCode);
    _$hash = $jc(_$hash, directoryMinRating.hashCode);
    _$hash = $jc(_$hash, directoryMaxDistanceKm.hashCode);
    _$hash = $jc(_$hash, supplierType.hashCode);
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, perPage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DiscoverySearchRequest')
          ..add('locationId', locationId)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('originSource', originSource)
          ..add('radiusKm', radiusKm)
          ..add('includeVerified', includeVerified)
          ..add('includeDirectory', includeDirectory)
          ..add('favoritesOnly', favoritesOnly)
          ..add('directoryMinRating', directoryMinRating)
          ..add('directoryMaxDistanceKm', directoryMaxDistanceKm)
          ..add('supplierType', supplierType)
          ..add('categoryId', categoryId)
          ..add('page', page)
          ..add('perPage', perPage))
        .toString();
  }
}

class DiscoverySearchRequestBuilder
    implements Builder<DiscoverySearchRequest, DiscoverySearchRequestBuilder> {
  _$DiscoverySearchRequest? _$v;

  String? _locationId;
  String? get locationId => _$this._locationId;
  set locationId(String? locationId) => _$this._locationId = locationId;

  double? _latitude;
  double? get latitude => _$this._latitude;
  set latitude(double? latitude) => _$this._latitude = latitude;

  double? _longitude;
  double? get longitude => _$this._longitude;
  set longitude(double? longitude) => _$this._longitude = longitude;

  DiscoverySearchRequestOriginSourceEnum? _originSource;
  DiscoverySearchRequestOriginSourceEnum? get originSource =>
      _$this._originSource;
  set originSource(DiscoverySearchRequestOriginSourceEnum? originSource) =>
      _$this._originSource = originSource;

  int? _radiusKm;
  int? get radiusKm => _$this._radiusKm;
  set radiusKm(int? radiusKm) => _$this._radiusKm = radiusKm;

  bool? _includeVerified;
  bool? get includeVerified => _$this._includeVerified;
  set includeVerified(bool? includeVerified) =>
      _$this._includeVerified = includeVerified;

  bool? _includeDirectory;
  bool? get includeDirectory => _$this._includeDirectory;
  set includeDirectory(bool? includeDirectory) =>
      _$this._includeDirectory = includeDirectory;

  bool? _favoritesOnly;
  bool? get favoritesOnly => _$this._favoritesOnly;
  set favoritesOnly(bool? favoritesOnly) =>
      _$this._favoritesOnly = favoritesOnly;

  DiscoverySearchRequestDirectoryMinRatingEnum? _directoryMinRating;
  DiscoverySearchRequestDirectoryMinRatingEnum? get directoryMinRating =>
      _$this._directoryMinRating;
  set directoryMinRating(
          DiscoverySearchRequestDirectoryMinRatingEnum? directoryMinRating) =>
      _$this._directoryMinRating = directoryMinRating;

  DiscoverySearchRequestDirectoryMaxDistanceKmEnum? _directoryMaxDistanceKm;
  DiscoverySearchRequestDirectoryMaxDistanceKmEnum?
      get directoryMaxDistanceKm => _$this._directoryMaxDistanceKm;
  set directoryMaxDistanceKm(
          DiscoverySearchRequestDirectoryMaxDistanceKmEnum?
              directoryMaxDistanceKm) =>
      _$this._directoryMaxDistanceKm = directoryMaxDistanceKm;

  String? _supplierType;
  String? get supplierType => _$this._supplierType;
  set supplierType(String? supplierType) => _$this._supplierType = supplierType;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  int? _perPage;
  int? get perPage => _$this._perPage;
  set perPage(int? perPage) => _$this._perPage = perPage;

  DiscoverySearchRequestBuilder() {
    DiscoverySearchRequest._defaults(this);
  }

  DiscoverySearchRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _locationId = $v.locationId;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _originSource = $v.originSource;
      _radiusKm = $v.radiusKm;
      _includeVerified = $v.includeVerified;
      _includeDirectory = $v.includeDirectory;
      _favoritesOnly = $v.favoritesOnly;
      _directoryMinRating = $v.directoryMinRating;
      _directoryMaxDistanceKm = $v.directoryMaxDistanceKm;
      _supplierType = $v.supplierType;
      _categoryId = $v.categoryId;
      _page = $v.page;
      _perPage = $v.perPage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DiscoverySearchRequest other) {
    _$v = other as _$DiscoverySearchRequest;
  }

  @override
  void update(void Function(DiscoverySearchRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DiscoverySearchRequest build() => _build();

  _$DiscoverySearchRequest _build() {
    final _$result = _$v ??
        _$DiscoverySearchRequest._(
          locationId: locationId,
          latitude: latitude,
          longitude: longitude,
          originSource: originSource,
          radiusKm: radiusKm,
          includeVerified: includeVerified,
          includeDirectory: includeDirectory,
          favoritesOnly: favoritesOnly,
          directoryMinRating: directoryMinRating,
          directoryMaxDistanceKm: directoryMaxDistanceKm,
          supplierType: supplierType,
          categoryId: categoryId,
          page: page,
          perPage: perPage,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
