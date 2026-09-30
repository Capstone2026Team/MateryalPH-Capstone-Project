// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_vehicle_selection.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeliveryVehicleSelection extends DeliveryVehicleSelection {
  @override
  final String vehicleId;
  @override
  final int numberOfVehicles;
  @override
  final int totalVehicleTrips;
  @override
  final String? groupKey;

  factory _$DeliveryVehicleSelection(
          [void Function(DeliveryVehicleSelectionBuilder)? updates]) =>
      (DeliveryVehicleSelectionBuilder()..update(updates))._build();

  _$DeliveryVehicleSelection._(
      {required this.vehicleId,
      required this.numberOfVehicles,
      required this.totalVehicleTrips,
      this.groupKey})
      : super._();
  @override
  DeliveryVehicleSelection rebuild(
          void Function(DeliveryVehicleSelectionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeliveryVehicleSelectionBuilder toBuilder() =>
      DeliveryVehicleSelectionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeliveryVehicleSelection &&
        vehicleId == other.vehicleId &&
        numberOfVehicles == other.numberOfVehicles &&
        totalVehicleTrips == other.totalVehicleTrips &&
        groupKey == other.groupKey;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vehicleId.hashCode);
    _$hash = $jc(_$hash, numberOfVehicles.hashCode);
    _$hash = $jc(_$hash, totalVehicleTrips.hashCode);
    _$hash = $jc(_$hash, groupKey.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeliveryVehicleSelection')
          ..add('vehicleId', vehicleId)
          ..add('numberOfVehicles', numberOfVehicles)
          ..add('totalVehicleTrips', totalVehicleTrips)
          ..add('groupKey', groupKey))
        .toString();
  }
}

class DeliveryVehicleSelectionBuilder
    implements
        Builder<DeliveryVehicleSelection, DeliveryVehicleSelectionBuilder> {
  _$DeliveryVehicleSelection? _$v;

  String? _vehicleId;
  String? get vehicleId => _$this._vehicleId;
  set vehicleId(String? vehicleId) => _$this._vehicleId = vehicleId;

  int? _numberOfVehicles;
  int? get numberOfVehicles => _$this._numberOfVehicles;
  set numberOfVehicles(int? numberOfVehicles) =>
      _$this._numberOfVehicles = numberOfVehicles;

  int? _totalVehicleTrips;
  int? get totalVehicleTrips => _$this._totalVehicleTrips;
  set totalVehicleTrips(int? totalVehicleTrips) =>
      _$this._totalVehicleTrips = totalVehicleTrips;

  String? _groupKey;
  String? get groupKey => _$this._groupKey;
  set groupKey(String? groupKey) => _$this._groupKey = groupKey;

  DeliveryVehicleSelectionBuilder() {
    DeliveryVehicleSelection._defaults(this);
  }

  DeliveryVehicleSelectionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vehicleId = $v.vehicleId;
      _numberOfVehicles = $v.numberOfVehicles;
      _totalVehicleTrips = $v.totalVehicleTrips;
      _groupKey = $v.groupKey;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeliveryVehicleSelection other) {
    _$v = other as _$DeliveryVehicleSelection;
  }

  @override
  void update(void Function(DeliveryVehicleSelectionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeliveryVehicleSelection build() => _build();

  _$DeliveryVehicleSelection _build() {
    final _$result = _$v ??
        _$DeliveryVehicleSelection._(
          vehicleId: BuiltValueNullFieldError.checkNotNull(
              vehicleId, r'DeliveryVehicleSelection', 'vehicleId'),
          numberOfVehicles: BuiltValueNullFieldError.checkNotNull(
              numberOfVehicles,
              r'DeliveryVehicleSelection',
              'numberOfVehicles'),
          totalVehicleTrips: BuiltValueNullFieldError.checkNotNull(
              totalVehicleTrips,
              r'DeliveryVehicleSelection',
              'totalVehicleTrips'),
          groupKey: groupKey,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
