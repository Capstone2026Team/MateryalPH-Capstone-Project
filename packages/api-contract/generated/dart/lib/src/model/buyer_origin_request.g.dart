// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_origin_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BuyerOriginRequestOriginSourceEnum
    _$buyerOriginRequestOriginSourceEnum_DEVICE =
    const BuyerOriginRequestOriginSourceEnum._('DEVICE');
const BuyerOriginRequestOriginSourceEnum
    _$buyerOriginRequestOriginSourceEnum_MAP_PIN =
    const BuyerOriginRequestOriginSourceEnum._('MAP_PIN');
const BuyerOriginRequestOriginSourceEnum
    _$buyerOriginRequestOriginSourceEnum_SEARCH =
    const BuyerOriginRequestOriginSourceEnum._('SEARCH');

BuyerOriginRequestOriginSourceEnum _$buyerOriginRequestOriginSourceEnumValueOf(
    String name) {
  switch (name) {
    case 'DEVICE':
      return _$buyerOriginRequestOriginSourceEnum_DEVICE;
    case 'MAP_PIN':
      return _$buyerOriginRequestOriginSourceEnum_MAP_PIN;
    case 'SEARCH':
      return _$buyerOriginRequestOriginSourceEnum_SEARCH;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerOriginRequestOriginSourceEnum>
    _$buyerOriginRequestOriginSourceEnumValues = BuiltSet<
        BuyerOriginRequestOriginSourceEnum>(const <BuyerOriginRequestOriginSourceEnum>[
  _$buyerOriginRequestOriginSourceEnum_DEVICE,
  _$buyerOriginRequestOriginSourceEnum_MAP_PIN,
  _$buyerOriginRequestOriginSourceEnum_SEARCH,
]);

Serializer<BuyerOriginRequestOriginSourceEnum>
    _$buyerOriginRequestOriginSourceEnumSerializer =
    _$BuyerOriginRequestOriginSourceEnumSerializer();

class _$BuyerOriginRequestOriginSourceEnumSerializer
    implements PrimitiveSerializer<BuyerOriginRequestOriginSourceEnum> {
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
  final Iterable<Type> types = const <Type>[BuyerOriginRequestOriginSourceEnum];
  @override
  final String wireName = 'BuyerOriginRequestOriginSourceEnum';

  @override
  Object serialize(
          Serializers serializers, BuyerOriginRequestOriginSourceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerOriginRequestOriginSourceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerOriginRequestOriginSourceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BuyerOriginRequest extends BuyerOriginRequest {
  @override
  final String? locationId;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final BuyerOriginRequestOriginSourceEnum? originSource;
  @override
  final int? radiusKm;

  factory _$BuyerOriginRequest(
          [void Function(BuyerOriginRequestBuilder)? updates]) =>
      (BuyerOriginRequestBuilder()..update(updates))._build();

  _$BuyerOriginRequest._(
      {this.locationId,
      this.latitude,
      this.longitude,
      this.originSource,
      this.radiusKm})
      : super._();
  @override
  BuyerOriginRequest rebuild(
          void Function(BuyerOriginRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerOriginRequestBuilder toBuilder() =>
      BuyerOriginRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerOriginRequest &&
        locationId == other.locationId &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        originSource == other.originSource &&
        radiusKm == other.radiusKm;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, locationId.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, originSource.hashCode);
    _$hash = $jc(_$hash, radiusKm.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerOriginRequest')
          ..add('locationId', locationId)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('originSource', originSource)
          ..add('radiusKm', radiusKm))
        .toString();
  }
}

class BuyerOriginRequestBuilder
    implements Builder<BuyerOriginRequest, BuyerOriginRequestBuilder> {
  _$BuyerOriginRequest? _$v;

  String? _locationId;
  String? get locationId => _$this._locationId;
  set locationId(String? locationId) => _$this._locationId = locationId;

  double? _latitude;
  double? get latitude => _$this._latitude;
  set latitude(double? latitude) => _$this._latitude = latitude;

  double? _longitude;
  double? get longitude => _$this._longitude;
  set longitude(double? longitude) => _$this._longitude = longitude;

  BuyerOriginRequestOriginSourceEnum? _originSource;
  BuyerOriginRequestOriginSourceEnum? get originSource => _$this._originSource;
  set originSource(BuyerOriginRequestOriginSourceEnum? originSource) =>
      _$this._originSource = originSource;

  int? _radiusKm;
  int? get radiusKm => _$this._radiusKm;
  set radiusKm(int? radiusKm) => _$this._radiusKm = radiusKm;

  BuyerOriginRequestBuilder() {
    BuyerOriginRequest._defaults(this);
  }

  BuyerOriginRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _locationId = $v.locationId;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _originSource = $v.originSource;
      _radiusKm = $v.radiusKm;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerOriginRequest other) {
    _$v = other as _$BuyerOriginRequest;
  }

  @override
  void update(void Function(BuyerOriginRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerOriginRequest build() => _build();

  _$BuyerOriginRequest _build() {
    final _$result = _$v ??
        _$BuyerOriginRequest._(
          locationId: locationId,
          latitude: latitude,
          longitude: longitude,
          originSource: originSource,
          radiusKm: radiusKm,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
