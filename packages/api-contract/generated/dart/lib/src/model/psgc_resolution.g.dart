// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'psgc_resolution.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PsgcResolutionResolutionEnum _$psgcResolutionResolutionEnum_RESOLVED =
    const PsgcResolutionResolutionEnum._('RESOLVED');
const PsgcResolutionResolutionEnum _$psgcResolutionResolutionEnum_PARTIAL =
    const PsgcResolutionResolutionEnum._('PARTIAL');
const PsgcResolutionResolutionEnum _$psgcResolutionResolutionEnum_UNRESOLVED =
    const PsgcResolutionResolutionEnum._('UNRESOLVED');

PsgcResolutionResolutionEnum _$psgcResolutionResolutionEnumValueOf(
    String name) {
  switch (name) {
    case 'RESOLVED':
      return _$psgcResolutionResolutionEnum_RESOLVED;
    case 'PARTIAL':
      return _$psgcResolutionResolutionEnum_PARTIAL;
    case 'UNRESOLVED':
      return _$psgcResolutionResolutionEnum_UNRESOLVED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PsgcResolutionResolutionEnum>
    _$psgcResolutionResolutionEnumValues =
    BuiltSet<PsgcResolutionResolutionEnum>(const <PsgcResolutionResolutionEnum>[
  _$psgcResolutionResolutionEnum_RESOLVED,
  _$psgcResolutionResolutionEnum_PARTIAL,
  _$psgcResolutionResolutionEnum_UNRESOLVED,
]);

Serializer<PsgcResolutionResolutionEnum>
    _$psgcResolutionResolutionEnumSerializer =
    _$PsgcResolutionResolutionEnumSerializer();

class _$PsgcResolutionResolutionEnumSerializer
    implements PrimitiveSerializer<PsgcResolutionResolutionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'RESOLVED': 'RESOLVED',
    'PARTIAL': 'PARTIAL',
    'UNRESOLVED': 'UNRESOLVED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'RESOLVED': 'RESOLVED',
    'PARTIAL': 'PARTIAL',
    'UNRESOLVED': 'UNRESOLVED',
  };

  @override
  final Iterable<Type> types = const <Type>[PsgcResolutionResolutionEnum];
  @override
  final String wireName = 'PsgcResolutionResolutionEnum';

  @override
  Object serialize(Serializers serializers, PsgcResolutionResolutionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PsgcResolutionResolutionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PsgcResolutionResolutionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PsgcResolution extends PsgcResolution {
  @override
  final PsgcResolutionResolutionEnum resolution;
  @override
  final String? version;
  @override
  final String? reason;
  @override
  final PsgcAreaRef? region;
  @override
  final PsgcAreaRef? province;
  @override
  final PsgcAreaRef? cityMunicipality;
  @override
  final PsgcAreaRef? barangay;

  factory _$PsgcResolution([void Function(PsgcResolutionBuilder)? updates]) =>
      (PsgcResolutionBuilder()..update(updates))._build();

  _$PsgcResolution._(
      {required this.resolution,
      this.version,
      this.reason,
      this.region,
      this.province,
      this.cityMunicipality,
      this.barangay})
      : super._();
  @override
  PsgcResolution rebuild(void Function(PsgcResolutionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PsgcResolutionBuilder toBuilder() => PsgcResolutionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PsgcResolution &&
        resolution == other.resolution &&
        version == other.version &&
        reason == other.reason &&
        region == other.region &&
        province == other.province &&
        cityMunicipality == other.cityMunicipality &&
        barangay == other.barangay;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, resolution.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, region.hashCode);
    _$hash = $jc(_$hash, province.hashCode);
    _$hash = $jc(_$hash, cityMunicipality.hashCode);
    _$hash = $jc(_$hash, barangay.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PsgcResolution')
          ..add('resolution', resolution)
          ..add('version', version)
          ..add('reason', reason)
          ..add('region', region)
          ..add('province', province)
          ..add('cityMunicipality', cityMunicipality)
          ..add('barangay', barangay))
        .toString();
  }
}

class PsgcResolutionBuilder
    implements Builder<PsgcResolution, PsgcResolutionBuilder> {
  _$PsgcResolution? _$v;

  PsgcResolutionResolutionEnum? _resolution;
  PsgcResolutionResolutionEnum? get resolution => _$this._resolution;
  set resolution(PsgcResolutionResolutionEnum? resolution) =>
      _$this._resolution = resolution;

  String? _version;
  String? get version => _$this._version;
  set version(String? version) => _$this._version = version;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  PsgcAreaRefBuilder? _region;
  PsgcAreaRefBuilder get region => _$this._region ??= PsgcAreaRefBuilder();
  set region(PsgcAreaRefBuilder? region) => _$this._region = region;

  PsgcAreaRefBuilder? _province;
  PsgcAreaRefBuilder get province => _$this._province ??= PsgcAreaRefBuilder();
  set province(PsgcAreaRefBuilder? province) => _$this._province = province;

  PsgcAreaRefBuilder? _cityMunicipality;
  PsgcAreaRefBuilder get cityMunicipality =>
      _$this._cityMunicipality ??= PsgcAreaRefBuilder();
  set cityMunicipality(PsgcAreaRefBuilder? cityMunicipality) =>
      _$this._cityMunicipality = cityMunicipality;

  PsgcAreaRefBuilder? _barangay;
  PsgcAreaRefBuilder get barangay => _$this._barangay ??= PsgcAreaRefBuilder();
  set barangay(PsgcAreaRefBuilder? barangay) => _$this._barangay = barangay;

  PsgcResolutionBuilder() {
    PsgcResolution._defaults(this);
  }

  PsgcResolutionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _resolution = $v.resolution;
      _version = $v.version;
      _reason = $v.reason;
      _region = $v.region?.toBuilder();
      _province = $v.province?.toBuilder();
      _cityMunicipality = $v.cityMunicipality?.toBuilder();
      _barangay = $v.barangay?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PsgcResolution other) {
    _$v = other as _$PsgcResolution;
  }

  @override
  void update(void Function(PsgcResolutionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PsgcResolution build() => _build();

  _$PsgcResolution _build() {
    _$PsgcResolution _$result;
    try {
      _$result = _$v ??
          _$PsgcResolution._(
            resolution: BuiltValueNullFieldError.checkNotNull(
                resolution, r'PsgcResolution', 'resolution'),
            version: version,
            reason: reason,
            region: _region?.build(),
            province: _province?.build(),
            cityMunicipality: _cityMunicipality?.build(),
            barangay: _barangay?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'region';
        _region?.build();
        _$failedField = 'province';
        _province?.build();
        _$failedField = 'cityMunicipality';
        _cityMunicipality?.build();
        _$failedField = 'barangay';
        _barangay?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PsgcResolution', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
