// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fleet_vehicles_save.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FleetVehiclesSave extends FleetVehiclesSave {
  @override
  final BuiltList<FleetVehicleInput> vehicles;

  factory _$FleetVehiclesSave(
          [void Function(FleetVehiclesSaveBuilder)? updates]) =>
      (FleetVehiclesSaveBuilder()..update(updates))._build();

  _$FleetVehiclesSave._({required this.vehicles}) : super._();
  @override
  FleetVehiclesSave rebuild(void Function(FleetVehiclesSaveBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FleetVehiclesSaveBuilder toBuilder() =>
      FleetVehiclesSaveBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FleetVehiclesSave && vehicles == other.vehicles;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vehicles.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FleetVehiclesSave')
          ..add('vehicles', vehicles))
        .toString();
  }
}

class FleetVehiclesSaveBuilder
    implements Builder<FleetVehiclesSave, FleetVehiclesSaveBuilder> {
  _$FleetVehiclesSave? _$v;

  ListBuilder<FleetVehicleInput>? _vehicles;
  ListBuilder<FleetVehicleInput> get vehicles =>
      _$this._vehicles ??= ListBuilder<FleetVehicleInput>();
  set vehicles(ListBuilder<FleetVehicleInput>? vehicles) =>
      _$this._vehicles = vehicles;

  FleetVehiclesSaveBuilder() {
    FleetVehiclesSave._defaults(this);
  }

  FleetVehiclesSaveBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vehicles = $v.vehicles.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FleetVehiclesSave other) {
    _$v = other as _$FleetVehiclesSave;
  }

  @override
  void update(void Function(FleetVehiclesSaveBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FleetVehiclesSave build() => _build();

  _$FleetVehiclesSave _build() {
    _$FleetVehiclesSave _$result;
    try {
      _$result = _$v ??
          _$FleetVehiclesSave._(
            vehicles: vehicles.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'vehicles';
        vehicles.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'FleetVehiclesSave', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
