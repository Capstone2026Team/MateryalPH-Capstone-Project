// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_location_resolve_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BuyerLocationResolveRequestModeEnum
    _$buyerLocationResolveRequestModeEnum_PIN =
    const BuyerLocationResolveRequestModeEnum._('PIN');
const BuyerLocationResolveRequestModeEnum
    _$buyerLocationResolveRequestModeEnum_DEVICE =
    const BuyerLocationResolveRequestModeEnum._('DEVICE');
const BuyerLocationResolveRequestModeEnum
    _$buyerLocationResolveRequestModeEnum_ADDRESS =
    const BuyerLocationResolveRequestModeEnum._('ADDRESS');
const BuyerLocationResolveRequestModeEnum
    _$buyerLocationResolveRequestModeEnum_PLACE =
    const BuyerLocationResolveRequestModeEnum._('PLACE');

BuyerLocationResolveRequestModeEnum
    _$buyerLocationResolveRequestModeEnumValueOf(String name) {
  switch (name) {
    case 'PIN':
      return _$buyerLocationResolveRequestModeEnum_PIN;
    case 'DEVICE':
      return _$buyerLocationResolveRequestModeEnum_DEVICE;
    case 'ADDRESS':
      return _$buyerLocationResolveRequestModeEnum_ADDRESS;
    case 'PLACE':
      return _$buyerLocationResolveRequestModeEnum_PLACE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerLocationResolveRequestModeEnum>
    _$buyerLocationResolveRequestModeEnumValues = BuiltSet<
        BuyerLocationResolveRequestModeEnum>(const <BuyerLocationResolveRequestModeEnum>[
  _$buyerLocationResolveRequestModeEnum_PIN,
  _$buyerLocationResolveRequestModeEnum_DEVICE,
  _$buyerLocationResolveRequestModeEnum_ADDRESS,
  _$buyerLocationResolveRequestModeEnum_PLACE,
]);

Serializer<BuyerLocationResolveRequestModeEnum>
    _$buyerLocationResolveRequestModeEnumSerializer =
    _$BuyerLocationResolveRequestModeEnumSerializer();

class _$BuyerLocationResolveRequestModeEnumSerializer
    implements PrimitiveSerializer<BuyerLocationResolveRequestModeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PIN': 'PIN',
    'DEVICE': 'DEVICE',
    'ADDRESS': 'ADDRESS',
    'PLACE': 'PLACE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PIN': 'PIN',
    'DEVICE': 'DEVICE',
    'ADDRESS': 'ADDRESS',
    'PLACE': 'PLACE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    BuyerLocationResolveRequestModeEnum
  ];
  @override
  final String wireName = 'BuyerLocationResolveRequestModeEnum';

  @override
  Object serialize(
          Serializers serializers, BuyerLocationResolveRequestModeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerLocationResolveRequestModeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerLocationResolveRequestModeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BuyerLocationResolveRequest extends BuyerLocationResolveRequest {
  @override
  final BuyerLocationResolveRequestModeEnum mode;
  @override
  final String? placeId;
  @override
  final String? sessionToken;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final String? addressLine;
  @override
  final String? barangay;
  @override
  final String? cityMunicipality;
  @override
  final String? province;
  @override
  final String? postalCode;
  @override
  final String? cityCode;
  @override
  final String? barangayCode;

  factory _$BuyerLocationResolveRequest(
          [void Function(BuyerLocationResolveRequestBuilder)? updates]) =>
      (BuyerLocationResolveRequestBuilder()..update(updates))._build();

  _$BuyerLocationResolveRequest._(
      {required this.mode,
      this.placeId,
      this.sessionToken,
      this.latitude,
      this.longitude,
      this.addressLine,
      this.barangay,
      this.cityMunicipality,
      this.province,
      this.postalCode,
      this.cityCode,
      this.barangayCode})
      : super._();
  @override
  BuyerLocationResolveRequest rebuild(
          void Function(BuyerLocationResolveRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerLocationResolveRequestBuilder toBuilder() =>
      BuyerLocationResolveRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerLocationResolveRequest &&
        mode == other.mode &&
        placeId == other.placeId &&
        sessionToken == other.sessionToken &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        addressLine == other.addressLine &&
        barangay == other.barangay &&
        cityMunicipality == other.cityMunicipality &&
        province == other.province &&
        postalCode == other.postalCode &&
        cityCode == other.cityCode &&
        barangayCode == other.barangayCode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, mode.hashCode);
    _$hash = $jc(_$hash, placeId.hashCode);
    _$hash = $jc(_$hash, sessionToken.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, addressLine.hashCode);
    _$hash = $jc(_$hash, barangay.hashCode);
    _$hash = $jc(_$hash, cityMunicipality.hashCode);
    _$hash = $jc(_$hash, province.hashCode);
    _$hash = $jc(_$hash, postalCode.hashCode);
    _$hash = $jc(_$hash, cityCode.hashCode);
    _$hash = $jc(_$hash, barangayCode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerLocationResolveRequest')
          ..add('mode', mode)
          ..add('placeId', placeId)
          ..add('sessionToken', sessionToken)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('addressLine', addressLine)
          ..add('barangay', barangay)
          ..add('cityMunicipality', cityMunicipality)
          ..add('province', province)
          ..add('postalCode', postalCode)
          ..add('cityCode', cityCode)
          ..add('barangayCode', barangayCode))
        .toString();
  }
}

class BuyerLocationResolveRequestBuilder
    implements
        Builder<BuyerLocationResolveRequest,
            BuyerLocationResolveRequestBuilder> {
  _$BuyerLocationResolveRequest? _$v;

  BuyerLocationResolveRequestModeEnum? _mode;
  BuyerLocationResolveRequestModeEnum? get mode => _$this._mode;
  set mode(BuyerLocationResolveRequestModeEnum? mode) => _$this._mode = mode;

  String? _placeId;
  String? get placeId => _$this._placeId;
  set placeId(String? placeId) => _$this._placeId = placeId;

  String? _sessionToken;
  String? get sessionToken => _$this._sessionToken;
  set sessionToken(String? sessionToken) => _$this._sessionToken = sessionToken;

  double? _latitude;
  double? get latitude => _$this._latitude;
  set latitude(double? latitude) => _$this._latitude = latitude;

  double? _longitude;
  double? get longitude => _$this._longitude;
  set longitude(double? longitude) => _$this._longitude = longitude;

  String? _addressLine;
  String? get addressLine => _$this._addressLine;
  set addressLine(String? addressLine) => _$this._addressLine = addressLine;

  String? _barangay;
  String? get barangay => _$this._barangay;
  set barangay(String? barangay) => _$this._barangay = barangay;

  String? _cityMunicipality;
  String? get cityMunicipality => _$this._cityMunicipality;
  set cityMunicipality(String? cityMunicipality) =>
      _$this._cityMunicipality = cityMunicipality;

  String? _province;
  String? get province => _$this._province;
  set province(String? province) => _$this._province = province;

  String? _postalCode;
  String? get postalCode => _$this._postalCode;
  set postalCode(String? postalCode) => _$this._postalCode = postalCode;

  String? _cityCode;
  String? get cityCode => _$this._cityCode;
  set cityCode(String? cityCode) => _$this._cityCode = cityCode;

  String? _barangayCode;
  String? get barangayCode => _$this._barangayCode;
  set barangayCode(String? barangayCode) => _$this._barangayCode = barangayCode;

  BuyerLocationResolveRequestBuilder() {
    BuyerLocationResolveRequest._defaults(this);
  }

  BuyerLocationResolveRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _mode = $v.mode;
      _placeId = $v.placeId;
      _sessionToken = $v.sessionToken;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _addressLine = $v.addressLine;
      _barangay = $v.barangay;
      _cityMunicipality = $v.cityMunicipality;
      _province = $v.province;
      _postalCode = $v.postalCode;
      _cityCode = $v.cityCode;
      _barangayCode = $v.barangayCode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerLocationResolveRequest other) {
    _$v = other as _$BuyerLocationResolveRequest;
  }

  @override
  void update(void Function(BuyerLocationResolveRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerLocationResolveRequest build() => _build();

  _$BuyerLocationResolveRequest _build() {
    final _$result = _$v ??
        _$BuyerLocationResolveRequest._(
          mode: BuiltValueNullFieldError.checkNotNull(
              mode, r'BuyerLocationResolveRequest', 'mode'),
          placeId: placeId,
          sessionToken: sessionToken,
          latitude: latitude,
          longitude: longitude,
          addressLine: addressLine,
          barangay: barangay,
          cityMunicipality: cityMunicipality,
          province: province,
          postalCode: postalCode,
          cityCode: cityCode,
          barangayCode: barangayCode,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
