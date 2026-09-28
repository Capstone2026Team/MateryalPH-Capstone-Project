// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_location_preview.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BuyerLocationPreviewSource_Enum _$buyerLocationPreviewSourceEnum_DEVICE =
    const BuyerLocationPreviewSource_Enum._('DEVICE');
const BuyerLocationPreviewSource_Enum _$buyerLocationPreviewSourceEnum_MAP_PIN =
    const BuyerLocationPreviewSource_Enum._('MAP_PIN');
const BuyerLocationPreviewSource_Enum
    _$buyerLocationPreviewSourceEnum_ADDRESS_SEARCH =
    const BuyerLocationPreviewSource_Enum._('ADDRESS_SEARCH');

BuyerLocationPreviewSource_Enum _$buyerLocationPreviewSourceEnumValueOf(
    String name) {
  switch (name) {
    case 'DEVICE':
      return _$buyerLocationPreviewSourceEnum_DEVICE;
    case 'MAP_PIN':
      return _$buyerLocationPreviewSourceEnum_MAP_PIN;
    case 'ADDRESS_SEARCH':
      return _$buyerLocationPreviewSourceEnum_ADDRESS_SEARCH;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerLocationPreviewSource_Enum>
    _$buyerLocationPreviewSourceEnumValues = BuiltSet<
        BuyerLocationPreviewSource_Enum>(const <BuyerLocationPreviewSource_Enum>[
  _$buyerLocationPreviewSourceEnum_DEVICE,
  _$buyerLocationPreviewSourceEnum_MAP_PIN,
  _$buyerLocationPreviewSourceEnum_ADDRESS_SEARCH,
]);

const BuyerLocationPreviewProviderStatusEnum
    _$buyerLocationPreviewProviderStatusEnum_AVAILABLE =
    const BuyerLocationPreviewProviderStatusEnum._('AVAILABLE');
const BuyerLocationPreviewProviderStatusEnum
    _$buyerLocationPreviewProviderStatusEnum_UNAVAILABLE =
    const BuyerLocationPreviewProviderStatusEnum._('UNAVAILABLE');
const BuyerLocationPreviewProviderStatusEnum
    _$buyerLocationPreviewProviderStatusEnum_NOT_FOUND =
    const BuyerLocationPreviewProviderStatusEnum._('NOT_FOUND');

BuyerLocationPreviewProviderStatusEnum
    _$buyerLocationPreviewProviderStatusEnumValueOf(String name) {
  switch (name) {
    case 'AVAILABLE':
      return _$buyerLocationPreviewProviderStatusEnum_AVAILABLE;
    case 'UNAVAILABLE':
      return _$buyerLocationPreviewProviderStatusEnum_UNAVAILABLE;
    case 'NOT_FOUND':
      return _$buyerLocationPreviewProviderStatusEnum_NOT_FOUND;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerLocationPreviewProviderStatusEnum>
    _$buyerLocationPreviewProviderStatusEnumValues = BuiltSet<
        BuyerLocationPreviewProviderStatusEnum>(const <BuyerLocationPreviewProviderStatusEnum>[
  _$buyerLocationPreviewProviderStatusEnum_AVAILABLE,
  _$buyerLocationPreviewProviderStatusEnum_UNAVAILABLE,
  _$buyerLocationPreviewProviderStatusEnum_NOT_FOUND,
]);

Serializer<BuyerLocationPreviewSource_Enum>
    _$buyerLocationPreviewSourceEnumSerializer =
    _$BuyerLocationPreviewSource_EnumSerializer();
Serializer<BuyerLocationPreviewProviderStatusEnum>
    _$buyerLocationPreviewProviderStatusEnumSerializer =
    _$BuyerLocationPreviewProviderStatusEnumSerializer();

class _$BuyerLocationPreviewSource_EnumSerializer
    implements PrimitiveSerializer<BuyerLocationPreviewSource_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DEVICE': 'DEVICE',
    'MAP_PIN': 'MAP_PIN',
    'ADDRESS_SEARCH': 'ADDRESS_SEARCH',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DEVICE': 'DEVICE',
    'MAP_PIN': 'MAP_PIN',
    'ADDRESS_SEARCH': 'ADDRESS_SEARCH',
  };

  @override
  final Iterable<Type> types = const <Type>[BuyerLocationPreviewSource_Enum];
  @override
  final String wireName = 'BuyerLocationPreviewSource_Enum';

  @override
  Object serialize(
          Serializers serializers, BuyerLocationPreviewSource_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerLocationPreviewSource_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerLocationPreviewSource_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BuyerLocationPreviewProviderStatusEnumSerializer
    implements PrimitiveSerializer<BuyerLocationPreviewProviderStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'AVAILABLE': 'AVAILABLE',
    'UNAVAILABLE': 'UNAVAILABLE',
    'NOT_FOUND': 'NOT_FOUND',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'AVAILABLE': 'AVAILABLE',
    'UNAVAILABLE': 'UNAVAILABLE',
    'NOT_FOUND': 'NOT_FOUND',
  };

  @override
  final Iterable<Type> types = const <Type>[
    BuyerLocationPreviewProviderStatusEnum
  ];
  @override
  final String wireName = 'BuyerLocationPreviewProviderStatusEnum';

  @override
  Object serialize(Serializers serializers,
          BuyerLocationPreviewProviderStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerLocationPreviewProviderStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerLocationPreviewProviderStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BuyerLocationPreview extends BuyerLocationPreview {
  @override
  final String? formattedAddress;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final BuyerLocationPreviewSource_Enum source_;
  @override
  final BuyerLocationPreviewProviderStatusEnum providerStatus;
  @override
  final AddressComponents components;
  @override
  final PsgcResolution psgc;
  @override
  final String resolutionToken;
  @override
  final DateTime expiresAt;

  factory _$BuyerLocationPreview(
          [void Function(BuyerLocationPreviewBuilder)? updates]) =>
      (BuyerLocationPreviewBuilder()..update(updates))._build();

  _$BuyerLocationPreview._(
      {this.formattedAddress,
      required this.latitude,
      required this.longitude,
      required this.source_,
      required this.providerStatus,
      required this.components,
      required this.psgc,
      required this.resolutionToken,
      required this.expiresAt})
      : super._();
  @override
  BuyerLocationPreview rebuild(
          void Function(BuyerLocationPreviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerLocationPreviewBuilder toBuilder() =>
      BuyerLocationPreviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerLocationPreview &&
        formattedAddress == other.formattedAddress &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        source_ == other.source_ &&
        providerStatus == other.providerStatus &&
        components == other.components &&
        psgc == other.psgc &&
        resolutionToken == other.resolutionToken &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, formattedAddress.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jc(_$hash, providerStatus.hashCode);
    _$hash = $jc(_$hash, components.hashCode);
    _$hash = $jc(_$hash, psgc.hashCode);
    _$hash = $jc(_$hash, resolutionToken.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerLocationPreview')
          ..add('formattedAddress', formattedAddress)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('source_', source_)
          ..add('providerStatus', providerStatus)
          ..add('components', components)
          ..add('psgc', psgc)
          ..add('resolutionToken', resolutionToken)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class BuyerLocationPreviewBuilder
    implements Builder<BuyerLocationPreview, BuyerLocationPreviewBuilder> {
  _$BuyerLocationPreview? _$v;

  String? _formattedAddress;
  String? get formattedAddress => _$this._formattedAddress;
  set formattedAddress(String? formattedAddress) =>
      _$this._formattedAddress = formattedAddress;

  double? _latitude;
  double? get latitude => _$this._latitude;
  set latitude(double? latitude) => _$this._latitude = latitude;

  double? _longitude;
  double? get longitude => _$this._longitude;
  set longitude(double? longitude) => _$this._longitude = longitude;

  BuyerLocationPreviewSource_Enum? _source_;
  BuyerLocationPreviewSource_Enum? get source_ => _$this._source_;
  set source_(BuyerLocationPreviewSource_Enum? source_) =>
      _$this._source_ = source_;

  BuyerLocationPreviewProviderStatusEnum? _providerStatus;
  BuyerLocationPreviewProviderStatusEnum? get providerStatus =>
      _$this._providerStatus;
  set providerStatus(BuyerLocationPreviewProviderStatusEnum? providerStatus) =>
      _$this._providerStatus = providerStatus;

  AddressComponentsBuilder? _components;
  AddressComponentsBuilder get components =>
      _$this._components ??= AddressComponentsBuilder();
  set components(AddressComponentsBuilder? components) =>
      _$this._components = components;

  PsgcResolutionBuilder? _psgc;
  PsgcResolutionBuilder get psgc => _$this._psgc ??= PsgcResolutionBuilder();
  set psgc(PsgcResolutionBuilder? psgc) => _$this._psgc = psgc;

  String? _resolutionToken;
  String? get resolutionToken => _$this._resolutionToken;
  set resolutionToken(String? resolutionToken) =>
      _$this._resolutionToken = resolutionToken;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  BuyerLocationPreviewBuilder() {
    BuyerLocationPreview._defaults(this);
  }

  BuyerLocationPreviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _formattedAddress = $v.formattedAddress;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _source_ = $v.source_;
      _providerStatus = $v.providerStatus;
      _components = $v.components.toBuilder();
      _psgc = $v.psgc.toBuilder();
      _resolutionToken = $v.resolutionToken;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerLocationPreview other) {
    _$v = other as _$BuyerLocationPreview;
  }

  @override
  void update(void Function(BuyerLocationPreviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerLocationPreview build() => _build();

  _$BuyerLocationPreview _build() {
    _$BuyerLocationPreview _$result;
    try {
      _$result = _$v ??
          _$BuyerLocationPreview._(
            formattedAddress: formattedAddress,
            latitude: BuiltValueNullFieldError.checkNotNull(
                latitude, r'BuyerLocationPreview', 'latitude'),
            longitude: BuiltValueNullFieldError.checkNotNull(
                longitude, r'BuyerLocationPreview', 'longitude'),
            source_: BuiltValueNullFieldError.checkNotNull(
                source_, r'BuyerLocationPreview', 'source_'),
            providerStatus: BuiltValueNullFieldError.checkNotNull(
                providerStatus, r'BuyerLocationPreview', 'providerStatus'),
            components: components.build(),
            psgc: psgc.build(),
            resolutionToken: BuiltValueNullFieldError.checkNotNull(
                resolutionToken, r'BuyerLocationPreview', 'resolutionToken'),
            expiresAt: BuiltValueNullFieldError.checkNotNull(
                expiresAt, r'BuyerLocationPreview', 'expiresAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'components';
        components.build();
        _$failedField = 'psgc';
        psgc.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BuyerLocationPreview', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
