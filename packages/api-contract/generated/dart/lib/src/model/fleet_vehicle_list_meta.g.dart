// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fleet_vehicle_list_meta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FleetVehicleListMetaScopeEnum
    _$fleetVehicleListMetaScopeEnum_ORGANIZATION =
    const FleetVehicleListMetaScopeEnum._('ORGANIZATION');
const FleetVehicleListMetaScopeEnum
    _$fleetVehicleListMetaScopeEnum_ASSIGNED_ONLY =
    const FleetVehicleListMetaScopeEnum._('ASSIGNED_ONLY');

FleetVehicleListMetaScopeEnum _$fleetVehicleListMetaScopeEnumValueOf(
    String name) {
  switch (name) {
    case 'ORGANIZATION':
      return _$fleetVehicleListMetaScopeEnum_ORGANIZATION;
    case 'ASSIGNED_ONLY':
      return _$fleetVehicleListMetaScopeEnum_ASSIGNED_ONLY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FleetVehicleListMetaScopeEnum>
    _$fleetVehicleListMetaScopeEnumValues = BuiltSet<
        FleetVehicleListMetaScopeEnum>(const <FleetVehicleListMetaScopeEnum>[
  _$fleetVehicleListMetaScopeEnum_ORGANIZATION,
  _$fleetVehicleListMetaScopeEnum_ASSIGNED_ONLY,
]);

Serializer<FleetVehicleListMetaScopeEnum>
    _$fleetVehicleListMetaScopeEnumSerializer =
    _$FleetVehicleListMetaScopeEnumSerializer();

class _$FleetVehicleListMetaScopeEnumSerializer
    implements PrimitiveSerializer<FleetVehicleListMetaScopeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ORGANIZATION': 'ORGANIZATION',
    'ASSIGNED_ONLY': 'ASSIGNED_ONLY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ORGANIZATION': 'ORGANIZATION',
    'ASSIGNED_ONLY': 'ASSIGNED_ONLY',
  };

  @override
  final Iterable<Type> types = const <Type>[FleetVehicleListMetaScopeEnum];
  @override
  final String wireName = 'FleetVehicleListMetaScopeEnum';

  @override
  Object serialize(
          Serializers serializers, FleetVehicleListMetaScopeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FleetVehicleListMetaScopeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FleetVehicleListMetaScopeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FleetVehicleListMeta extends FleetVehicleListMeta {
  @override
  final FleetVehicleListMetaScopeEnum scope;
  @override
  final FleetSummary? summary;
  @override
  final FleetVehicleListMetaDelivery? delivery;
  @override
  final FleetVehicleListMetaPermissions permissions;
  @override
  final FleetVehicleListMetaLimits? limits;

  factory _$FleetVehicleListMeta(
          [void Function(FleetVehicleListMetaBuilder)? updates]) =>
      (FleetVehicleListMetaBuilder()..update(updates))._build();

  _$FleetVehicleListMeta._(
      {required this.scope,
      this.summary,
      this.delivery,
      required this.permissions,
      this.limits})
      : super._();
  @override
  FleetVehicleListMeta rebuild(
          void Function(FleetVehicleListMetaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FleetVehicleListMetaBuilder toBuilder() =>
      FleetVehicleListMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FleetVehicleListMeta &&
        scope == other.scope &&
        summary == other.summary &&
        delivery == other.delivery &&
        permissions == other.permissions &&
        limits == other.limits;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, summary.hashCode);
    _$hash = $jc(_$hash, delivery.hashCode);
    _$hash = $jc(_$hash, permissions.hashCode);
    _$hash = $jc(_$hash, limits.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FleetVehicleListMeta')
          ..add('scope', scope)
          ..add('summary', summary)
          ..add('delivery', delivery)
          ..add('permissions', permissions)
          ..add('limits', limits))
        .toString();
  }
}

class FleetVehicleListMetaBuilder
    implements Builder<FleetVehicleListMeta, FleetVehicleListMetaBuilder> {
  _$FleetVehicleListMeta? _$v;

  FleetVehicleListMetaScopeEnum? _scope;
  FleetVehicleListMetaScopeEnum? get scope => _$this._scope;
  set scope(FleetVehicleListMetaScopeEnum? scope) => _$this._scope = scope;

  FleetSummaryBuilder? _summary;
  FleetSummaryBuilder get summary => _$this._summary ??= FleetSummaryBuilder();
  set summary(FleetSummaryBuilder? summary) => _$this._summary = summary;

  FleetVehicleListMetaDeliveryBuilder? _delivery;
  FleetVehicleListMetaDeliveryBuilder get delivery =>
      _$this._delivery ??= FleetVehicleListMetaDeliveryBuilder();
  set delivery(FleetVehicleListMetaDeliveryBuilder? delivery) =>
      _$this._delivery = delivery;

  FleetVehicleListMetaPermissionsBuilder? _permissions;
  FleetVehicleListMetaPermissionsBuilder get permissions =>
      _$this._permissions ??= FleetVehicleListMetaPermissionsBuilder();
  set permissions(FleetVehicleListMetaPermissionsBuilder? permissions) =>
      _$this._permissions = permissions;

  FleetVehicleListMetaLimitsBuilder? _limits;
  FleetVehicleListMetaLimitsBuilder get limits =>
      _$this._limits ??= FleetVehicleListMetaLimitsBuilder();
  set limits(FleetVehicleListMetaLimitsBuilder? limits) =>
      _$this._limits = limits;

  FleetVehicleListMetaBuilder() {
    FleetVehicleListMeta._defaults(this);
  }

  FleetVehicleListMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _scope = $v.scope;
      _summary = $v.summary?.toBuilder();
      _delivery = $v.delivery?.toBuilder();
      _permissions = $v.permissions.toBuilder();
      _limits = $v.limits?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FleetVehicleListMeta other) {
    _$v = other as _$FleetVehicleListMeta;
  }

  @override
  void update(void Function(FleetVehicleListMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FleetVehicleListMeta build() => _build();

  _$FleetVehicleListMeta _build() {
    _$FleetVehicleListMeta _$result;
    try {
      _$result = _$v ??
          _$FleetVehicleListMeta._(
            scope: BuiltValueNullFieldError.checkNotNull(
                scope, r'FleetVehicleListMeta', 'scope'),
            summary: _summary?.build(),
            delivery: _delivery?.build(),
            permissions: permissions.build(),
            limits: _limits?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'summary';
        _summary?.build();
        _$failedField = 'delivery';
        _delivery?.build();
        _$failedField = 'permissions';
        permissions.build();
        _$failedField = 'limits';
        _limits?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'FleetVehicleListMeta', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
