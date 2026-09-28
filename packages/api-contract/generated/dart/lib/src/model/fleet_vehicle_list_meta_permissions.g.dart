// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fleet_vehicle_list_meta_permissions.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FleetVehicleListMetaPermissions
    extends FleetVehicleListMetaPermissions {
  @override
  final bool canManage;

  factory _$FleetVehicleListMetaPermissions(
          [void Function(FleetVehicleListMetaPermissionsBuilder)? updates]) =>
      (FleetVehicleListMetaPermissionsBuilder()..update(updates))._build();

  _$FleetVehicleListMetaPermissions._({required this.canManage}) : super._();
  @override
  FleetVehicleListMetaPermissions rebuild(
          void Function(FleetVehicleListMetaPermissionsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FleetVehicleListMetaPermissionsBuilder toBuilder() =>
      FleetVehicleListMetaPermissionsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FleetVehicleListMetaPermissions &&
        canManage == other.canManage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, canManage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FleetVehicleListMetaPermissions')
          ..add('canManage', canManage))
        .toString();
  }
}

class FleetVehicleListMetaPermissionsBuilder
    implements
        Builder<FleetVehicleListMetaPermissions,
            FleetVehicleListMetaPermissionsBuilder> {
  _$FleetVehicleListMetaPermissions? _$v;

  bool? _canManage;
  bool? get canManage => _$this._canManage;
  set canManage(bool? canManage) => _$this._canManage = canManage;

  FleetVehicleListMetaPermissionsBuilder() {
    FleetVehicleListMetaPermissions._defaults(this);
  }

  FleetVehicleListMetaPermissionsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _canManage = $v.canManage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FleetVehicleListMetaPermissions other) {
    _$v = other as _$FleetVehicleListMetaPermissions;
  }

  @override
  void update(void Function(FleetVehicleListMetaPermissionsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FleetVehicleListMetaPermissions build() => _build();

  _$FleetVehicleListMetaPermissions _build() {
    final _$result = _$v ??
        _$FleetVehicleListMetaPermissions._(
          canManage: BuiltValueNullFieldError.checkNotNull(
              canManage, r'FleetVehicleListMetaPermissions', 'canManage'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
