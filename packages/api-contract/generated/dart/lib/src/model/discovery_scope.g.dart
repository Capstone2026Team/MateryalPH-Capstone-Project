// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery_scope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DiscoveryScopeAudienceEnum _$discoveryScopeAudienceEnum_BUYER =
    const DiscoveryScopeAudienceEnum._('BUYER');

DiscoveryScopeAudienceEnum _$discoveryScopeAudienceEnumValueOf(String name) {
  switch (name) {
    case 'BUYER':
      return _$discoveryScopeAudienceEnum_BUYER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DiscoveryScopeAudienceEnum> _$discoveryScopeAudienceEnumValues =
    BuiltSet<DiscoveryScopeAudienceEnum>(const <DiscoveryScopeAudienceEnum>[
  _$discoveryScopeAudienceEnum_BUYER,
]);

const DiscoveryScopeKindEnum _$discoveryScopeKindEnum_RADIUS =
    const DiscoveryScopeKindEnum._('RADIUS');

DiscoveryScopeKindEnum _$discoveryScopeKindEnumValueOf(String name) {
  switch (name) {
    case 'RADIUS':
      return _$discoveryScopeKindEnum_RADIUS;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DiscoveryScopeKindEnum> _$discoveryScopeKindEnumValues =
    BuiltSet<DiscoveryScopeKindEnum>(const <DiscoveryScopeKindEnum>[
  _$discoveryScopeKindEnum_RADIUS,
]);

const DiscoveryScopeOriginKindEnum
    _$discoveryScopeOriginKindEnum_SAVED_LOCATION =
    const DiscoveryScopeOriginKindEnum._('SAVED_LOCATION');
const DiscoveryScopeOriginKindEnum _$discoveryScopeOriginKindEnum_DEVICE =
    const DiscoveryScopeOriginKindEnum._('DEVICE');
const DiscoveryScopeOriginKindEnum _$discoveryScopeOriginKindEnum_MAP_PIN =
    const DiscoveryScopeOriginKindEnum._('MAP_PIN');
const DiscoveryScopeOriginKindEnum _$discoveryScopeOriginKindEnum_SEARCH =
    const DiscoveryScopeOriginKindEnum._('SEARCH');

DiscoveryScopeOriginKindEnum _$discoveryScopeOriginKindEnumValueOf(
    String name) {
  switch (name) {
    case 'SAVED_LOCATION':
      return _$discoveryScopeOriginKindEnum_SAVED_LOCATION;
    case 'DEVICE':
      return _$discoveryScopeOriginKindEnum_DEVICE;
    case 'MAP_PIN':
      return _$discoveryScopeOriginKindEnum_MAP_PIN;
    case 'SEARCH':
      return _$discoveryScopeOriginKindEnum_SEARCH;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DiscoveryScopeOriginKindEnum>
    _$discoveryScopeOriginKindEnumValues =
    BuiltSet<DiscoveryScopeOriginKindEnum>(const <DiscoveryScopeOriginKindEnum>[
  _$discoveryScopeOriginKindEnum_SAVED_LOCATION,
  _$discoveryScopeOriginKindEnum_DEVICE,
  _$discoveryScopeOriginKindEnum_MAP_PIN,
  _$discoveryScopeOriginKindEnum_SEARCH,
]);

const DiscoveryScopeDistanceBasisEnum
    _$discoveryScopeDistanceBasisEnum_GEODESIC_STRAIGHT_LINE =
    const DiscoveryScopeDistanceBasisEnum._('GEODESIC_STRAIGHT_LINE');

DiscoveryScopeDistanceBasisEnum _$discoveryScopeDistanceBasisEnumValueOf(
    String name) {
  switch (name) {
    case 'GEODESIC_STRAIGHT_LINE':
      return _$discoveryScopeDistanceBasisEnum_GEODESIC_STRAIGHT_LINE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DiscoveryScopeDistanceBasisEnum>
    _$discoveryScopeDistanceBasisEnumValues = BuiltSet<
        DiscoveryScopeDistanceBasisEnum>(const <DiscoveryScopeDistanceBasisEnum>[
  _$discoveryScopeDistanceBasisEnum_GEODESIC_STRAIGHT_LINE,
]);

Serializer<DiscoveryScopeAudienceEnum> _$discoveryScopeAudienceEnumSerializer =
    _$DiscoveryScopeAudienceEnumSerializer();
Serializer<DiscoveryScopeKindEnum> _$discoveryScopeKindEnumSerializer =
    _$DiscoveryScopeKindEnumSerializer();
Serializer<DiscoveryScopeOriginKindEnum>
    _$discoveryScopeOriginKindEnumSerializer =
    _$DiscoveryScopeOriginKindEnumSerializer();
Serializer<DiscoveryScopeDistanceBasisEnum>
    _$discoveryScopeDistanceBasisEnumSerializer =
    _$DiscoveryScopeDistanceBasisEnumSerializer();

class _$DiscoveryScopeAudienceEnumSerializer
    implements PrimitiveSerializer<DiscoveryScopeAudienceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER': 'BUYER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER': 'BUYER',
  };

  @override
  final Iterable<Type> types = const <Type>[DiscoveryScopeAudienceEnum];
  @override
  final String wireName = 'DiscoveryScopeAudienceEnum';

  @override
  Object serialize(Serializers serializers, DiscoveryScopeAudienceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DiscoveryScopeAudienceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DiscoveryScopeAudienceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DiscoveryScopeKindEnumSerializer
    implements PrimitiveSerializer<DiscoveryScopeKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'RADIUS': 'RADIUS',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'RADIUS': 'RADIUS',
  };

  @override
  final Iterable<Type> types = const <Type>[DiscoveryScopeKindEnum];
  @override
  final String wireName = 'DiscoveryScopeKindEnum';

  @override
  Object serialize(Serializers serializers, DiscoveryScopeKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DiscoveryScopeKindEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DiscoveryScopeKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DiscoveryScopeOriginKindEnumSerializer
    implements PrimitiveSerializer<DiscoveryScopeOriginKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SAVED_LOCATION': 'SAVED_LOCATION',
    'DEVICE': 'DEVICE',
    'MAP_PIN': 'MAP_PIN',
    'SEARCH': 'SEARCH',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SAVED_LOCATION': 'SAVED_LOCATION',
    'DEVICE': 'DEVICE',
    'MAP_PIN': 'MAP_PIN',
    'SEARCH': 'SEARCH',
  };

  @override
  final Iterable<Type> types = const <Type>[DiscoveryScopeOriginKindEnum];
  @override
  final String wireName = 'DiscoveryScopeOriginKindEnum';

  @override
  Object serialize(Serializers serializers, DiscoveryScopeOriginKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DiscoveryScopeOriginKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DiscoveryScopeOriginKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DiscoveryScopeDistanceBasisEnumSerializer
    implements PrimitiveSerializer<DiscoveryScopeDistanceBasisEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'GEODESIC_STRAIGHT_LINE': 'GEODESIC_STRAIGHT_LINE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'GEODESIC_STRAIGHT_LINE': 'GEODESIC_STRAIGHT_LINE',
  };

  @override
  final Iterable<Type> types = const <Type>[DiscoveryScopeDistanceBasisEnum];
  @override
  final String wireName = 'DiscoveryScopeDistanceBasisEnum';

  @override
  Object serialize(
          Serializers serializers, DiscoveryScopeDistanceBasisEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DiscoveryScopeDistanceBasisEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DiscoveryScopeDistanceBasisEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DiscoveryScope extends DiscoveryScope {
  @override
  final DiscoveryScopeAudienceEnum audience;
  @override
  final DiscoveryScopeKindEnum kind;
  @override
  final DiscoveryScopeOriginKindEnum originKind;
  @override
  final String? locationId;
  @override
  final String? originLabel;
  @override
  final String originVersion;
  @override
  final RadiusKm radiusKm;
  @override
  final int radiusMeters;
  @override
  final DiscoveryScopeDistanceBasisEnum distanceBasis;

  factory _$DiscoveryScope([void Function(DiscoveryScopeBuilder)? updates]) =>
      (DiscoveryScopeBuilder()..update(updates))._build();

  _$DiscoveryScope._(
      {required this.audience,
      required this.kind,
      required this.originKind,
      this.locationId,
      this.originLabel,
      required this.originVersion,
      required this.radiusKm,
      required this.radiusMeters,
      required this.distanceBasis})
      : super._();
  @override
  DiscoveryScope rebuild(void Function(DiscoveryScopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DiscoveryScopeBuilder toBuilder() => DiscoveryScopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DiscoveryScope &&
        audience == other.audience &&
        kind == other.kind &&
        originKind == other.originKind &&
        locationId == other.locationId &&
        originLabel == other.originLabel &&
        originVersion == other.originVersion &&
        radiusKm == other.radiusKm &&
        radiusMeters == other.radiusMeters &&
        distanceBasis == other.distanceBasis;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, audience.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, originKind.hashCode);
    _$hash = $jc(_$hash, locationId.hashCode);
    _$hash = $jc(_$hash, originLabel.hashCode);
    _$hash = $jc(_$hash, originVersion.hashCode);
    _$hash = $jc(_$hash, radiusKm.hashCode);
    _$hash = $jc(_$hash, radiusMeters.hashCode);
    _$hash = $jc(_$hash, distanceBasis.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DiscoveryScope')
          ..add('audience', audience)
          ..add('kind', kind)
          ..add('originKind', originKind)
          ..add('locationId', locationId)
          ..add('originLabel', originLabel)
          ..add('originVersion', originVersion)
          ..add('radiusKm', radiusKm)
          ..add('radiusMeters', radiusMeters)
          ..add('distanceBasis', distanceBasis))
        .toString();
  }
}

class DiscoveryScopeBuilder
    implements Builder<DiscoveryScope, DiscoveryScopeBuilder> {
  _$DiscoveryScope? _$v;

  DiscoveryScopeAudienceEnum? _audience;
  DiscoveryScopeAudienceEnum? get audience => _$this._audience;
  set audience(DiscoveryScopeAudienceEnum? audience) =>
      _$this._audience = audience;

  DiscoveryScopeKindEnum? _kind;
  DiscoveryScopeKindEnum? get kind => _$this._kind;
  set kind(DiscoveryScopeKindEnum? kind) => _$this._kind = kind;

  DiscoveryScopeOriginKindEnum? _originKind;
  DiscoveryScopeOriginKindEnum? get originKind => _$this._originKind;
  set originKind(DiscoveryScopeOriginKindEnum? originKind) =>
      _$this._originKind = originKind;

  String? _locationId;
  String? get locationId => _$this._locationId;
  set locationId(String? locationId) => _$this._locationId = locationId;

  String? _originLabel;
  String? get originLabel => _$this._originLabel;
  set originLabel(String? originLabel) => _$this._originLabel = originLabel;

  String? _originVersion;
  String? get originVersion => _$this._originVersion;
  set originVersion(String? originVersion) =>
      _$this._originVersion = originVersion;

  RadiusKm? _radiusKm;
  RadiusKm? get radiusKm => _$this._radiusKm;
  set radiusKm(RadiusKm? radiusKm) => _$this._radiusKm = radiusKm;

  int? _radiusMeters;
  int? get radiusMeters => _$this._radiusMeters;
  set radiusMeters(int? radiusMeters) => _$this._radiusMeters = radiusMeters;

  DiscoveryScopeDistanceBasisEnum? _distanceBasis;
  DiscoveryScopeDistanceBasisEnum? get distanceBasis => _$this._distanceBasis;
  set distanceBasis(DiscoveryScopeDistanceBasisEnum? distanceBasis) =>
      _$this._distanceBasis = distanceBasis;

  DiscoveryScopeBuilder() {
    DiscoveryScope._defaults(this);
  }

  DiscoveryScopeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _audience = $v.audience;
      _kind = $v.kind;
      _originKind = $v.originKind;
      _locationId = $v.locationId;
      _originLabel = $v.originLabel;
      _originVersion = $v.originVersion;
      _radiusKm = $v.radiusKm;
      _radiusMeters = $v.radiusMeters;
      _distanceBasis = $v.distanceBasis;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DiscoveryScope other) {
    _$v = other as _$DiscoveryScope;
  }

  @override
  void update(void Function(DiscoveryScopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DiscoveryScope build() => _build();

  _$DiscoveryScope _build() {
    final _$result = _$v ??
        _$DiscoveryScope._(
          audience: BuiltValueNullFieldError.checkNotNull(
              audience, r'DiscoveryScope', 'audience'),
          kind: BuiltValueNullFieldError.checkNotNull(
              kind, r'DiscoveryScope', 'kind'),
          originKind: BuiltValueNullFieldError.checkNotNull(
              originKind, r'DiscoveryScope', 'originKind'),
          locationId: locationId,
          originLabel: originLabel,
          originVersion: BuiltValueNullFieldError.checkNotNull(
              originVersion, r'DiscoveryScope', 'originVersion'),
          radiusKm: BuiltValueNullFieldError.checkNotNull(
              radiusKm, r'DiscoveryScope', 'radiusKm'),
          radiusMeters: BuiltValueNullFieldError.checkNotNull(
              radiusMeters, r'DiscoveryScope', 'radiusMeters'),
          distanceBasis: BuiltValueNullFieldError.checkNotNull(
              distanceBasis, r'DiscoveryScope', 'distanceBasis'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
