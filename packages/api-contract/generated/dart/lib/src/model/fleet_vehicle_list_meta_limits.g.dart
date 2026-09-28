// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fleet_vehicle_list_meta_limits.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FleetVehicleListMetaLimits extends FleetVehicleListMetaLimits {
  @override
  final int? maxVehicles;

  factory _$FleetVehicleListMetaLimits(
          [void Function(FleetVehicleListMetaLimitsBuilder)? updates]) =>
      (FleetVehicleListMetaLimitsBuilder()..update(updates))._build();

  _$FleetVehicleListMetaLimits._({this.maxVehicles}) : super._();
  @override
  FleetVehicleListMetaLimits rebuild(
          void Function(FleetVehicleListMetaLimitsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FleetVehicleListMetaLimitsBuilder toBuilder() =>
      FleetVehicleListMetaLimitsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FleetVehicleListMetaLimits &&
        maxVehicles == other.maxVehicles;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, maxVehicles.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FleetVehicleListMetaLimits')
          ..add('maxVehicles', maxVehicles))
        .toString();
  }
}

class FleetVehicleListMetaLimitsBuilder
    implements
        Builder<FleetVehicleListMetaLimits, FleetVehicleListMetaLimitsBuilder> {
  _$FleetVehicleListMetaLimits? _$v;

  int? _maxVehicles;
  int? get maxVehicles => _$this._maxVehicles;
  set maxVehicles(int? maxVehicles) => _$this._maxVehicles = maxVehicles;

  FleetVehicleListMetaLimitsBuilder() {
    FleetVehicleListMetaLimits._defaults(this);
  }

  FleetVehicleListMetaLimitsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _maxVehicles = $v.maxVehicles;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FleetVehicleListMetaLimits other) {
    _$v = other as _$FleetVehicleListMetaLimits;
  }

  @override
  void update(void Function(FleetVehicleListMetaLimitsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FleetVehicleListMetaLimits build() => _build();

  _$FleetVehicleListMetaLimits _build() {
    final _$result = _$v ??
        _$FleetVehicleListMetaLimits._(
          maxVehicles: maxVehicles,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
