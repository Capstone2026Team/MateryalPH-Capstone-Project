// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_estimate_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RouteEstimateRequestOriginSourceEnum
    _$routeEstimateRequestOriginSourceEnum_DEVICE =
    const RouteEstimateRequestOriginSourceEnum._('DEVICE');
const RouteEstimateRequestOriginSourceEnum
    _$routeEstimateRequestOriginSourceEnum_MAP_PIN =
    const RouteEstimateRequestOriginSourceEnum._('MAP_PIN');
const RouteEstimateRequestOriginSourceEnum
    _$routeEstimateRequestOriginSourceEnum_SEARCH =
    const RouteEstimateRequestOriginSourceEnum._('SEARCH');

RouteEstimateRequestOriginSourceEnum
    _$routeEstimateRequestOriginSourceEnumValueOf(String name) {
  switch (name) {
    case 'DEVICE':
      return _$routeEstimateRequestOriginSourceEnum_DEVICE;
    case 'MAP_PIN':
      return _$routeEstimateRequestOriginSourceEnum_MAP_PIN;
    case 'SEARCH':
      return _$routeEstimateRequestOriginSourceEnum_SEARCH;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RouteEstimateRequestOriginSourceEnum>
    _$routeEstimateRequestOriginSourceEnumValues = BuiltSet<
        RouteEstimateRequestOriginSourceEnum>(const <RouteEstimateRequestOriginSourceEnum>[
  _$routeEstimateRequestOriginSourceEnum_DEVICE,
  _$routeEstimateRequestOriginSourceEnum_MAP_PIN,
  _$routeEstimateRequestOriginSourceEnum_SEARCH,
]);

Serializer<RouteEstimateRequestOriginSourceEnum>
    _$routeEstimateRequestOriginSourceEnumSerializer =
    _$RouteEstimateRequestOriginSourceEnumSerializer();

class _$RouteEstimateRequestOriginSourceEnumSerializer
    implements PrimitiveSerializer<RouteEstimateRequestOriginSourceEnum> {
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
    RouteEstimateRequestOriginSourceEnum
  ];
  @override
  final String wireName = 'RouteEstimateRequestOriginSourceEnum';

  @override
  Object serialize(
          Serializers serializers, RouteEstimateRequestOriginSourceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RouteEstimateRequestOriginSourceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RouteEstimateRequestOriginSourceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RouteEstimateRequest extends RouteEstimateRequest {
  @override
  final String? locationId;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final RouteEstimateRequestOriginSourceEnum? originSource;
  @override
  final int? radiusKm;
  @override
  final SupplierTier tier;
  @override
  final String supplierId;
  @override
  final String requestVersion;

  factory _$RouteEstimateRequest(
          [void Function(RouteEstimateRequestBuilder)? updates]) =>
      (RouteEstimateRequestBuilder()..update(updates))._build();

  _$RouteEstimateRequest._(
      {this.locationId,
      this.latitude,
      this.longitude,
      this.originSource,
      this.radiusKm,
      required this.tier,
      required this.supplierId,
      required this.requestVersion})
      : super._();
  @override
  RouteEstimateRequest rebuild(
          void Function(RouteEstimateRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RouteEstimateRequestBuilder toBuilder() =>
      RouteEstimateRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RouteEstimateRequest &&
        locationId == other.locationId &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        originSource == other.originSource &&
        radiusKm == other.radiusKm &&
        tier == other.tier &&
        supplierId == other.supplierId &&
        requestVersion == other.requestVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, locationId.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, originSource.hashCode);
    _$hash = $jc(_$hash, radiusKm.hashCode);
    _$hash = $jc(_$hash, tier.hashCode);
    _$hash = $jc(_$hash, supplierId.hashCode);
    _$hash = $jc(_$hash, requestVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RouteEstimateRequest')
          ..add('locationId', locationId)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('originSource', originSource)
          ..add('radiusKm', radiusKm)
          ..add('tier', tier)
          ..add('supplierId', supplierId)
          ..add('requestVersion', requestVersion))
        .toString();
  }
}

class RouteEstimateRequestBuilder
    implements Builder<RouteEstimateRequest, RouteEstimateRequestBuilder> {
  _$RouteEstimateRequest? _$v;

  String? _locationId;
  String? get locationId => _$this._locationId;
  set locationId(String? locationId) => _$this._locationId = locationId;

  double? _latitude;
  double? get latitude => _$this._latitude;
  set latitude(double? latitude) => _$this._latitude = latitude;

  double? _longitude;
  double? get longitude => _$this._longitude;
  set longitude(double? longitude) => _$this._longitude = longitude;

  RouteEstimateRequestOriginSourceEnum? _originSource;
  RouteEstimateRequestOriginSourceEnum? get originSource =>
      _$this._originSource;
  set originSource(RouteEstimateRequestOriginSourceEnum? originSource) =>
      _$this._originSource = originSource;

  int? _radiusKm;
  int? get radiusKm => _$this._radiusKm;
  set radiusKm(int? radiusKm) => _$this._radiusKm = radiusKm;

  SupplierTier? _tier;
  SupplierTier? get tier => _$this._tier;
  set tier(SupplierTier? tier) => _$this._tier = tier;

  String? _supplierId;
  String? get supplierId => _$this._supplierId;
  set supplierId(String? supplierId) => _$this._supplierId = supplierId;

  String? _requestVersion;
  String? get requestVersion => _$this._requestVersion;
  set requestVersion(String? requestVersion) =>
      _$this._requestVersion = requestVersion;

  RouteEstimateRequestBuilder() {
    RouteEstimateRequest._defaults(this);
  }

  RouteEstimateRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _locationId = $v.locationId;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _originSource = $v.originSource;
      _radiusKm = $v.radiusKm;
      _tier = $v.tier;
      _supplierId = $v.supplierId;
      _requestVersion = $v.requestVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RouteEstimateRequest other) {
    _$v = other as _$RouteEstimateRequest;
  }

  @override
  void update(void Function(RouteEstimateRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RouteEstimateRequest build() => _build();

  _$RouteEstimateRequest _build() {
    final _$result = _$v ??
        _$RouteEstimateRequest._(
          locationId: locationId,
          latitude: latitude,
          longitude: longitude,
          originSource: originSource,
          radiusKm: radiusKm,
          tier: BuiltValueNullFieldError.checkNotNull(
              tier, r'RouteEstimateRequest', 'tier'),
          supplierId: BuiltValueNullFieldError.checkNotNull(
              supplierId, r'RouteEstimateRequest', 'supplierId'),
          requestVersion: BuiltValueNullFieldError.checkNotNull(
              requestVersion, r'RouteEstimateRequest', 'requestVersion'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
