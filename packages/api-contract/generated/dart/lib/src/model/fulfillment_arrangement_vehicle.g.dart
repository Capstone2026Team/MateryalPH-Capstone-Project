// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fulfillment_arrangement_vehicle.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FulfillmentArrangementVehicle extends FulfillmentArrangementVehicle {
  @override
  final int vehicleIndex;
  @override
  final String? name;
  @override
  final String? vehicleType;
  @override
  final int numberOfVehicles;
  @override
  final int totalVehicleTrips;

  factory _$FulfillmentArrangementVehicle(
          [void Function(FulfillmentArrangementVehicleBuilder)? updates]) =>
      (FulfillmentArrangementVehicleBuilder()..update(updates))._build();

  _$FulfillmentArrangementVehicle._(
      {required this.vehicleIndex,
      this.name,
      this.vehicleType,
      required this.numberOfVehicles,
      required this.totalVehicleTrips})
      : super._();
  @override
  FulfillmentArrangementVehicle rebuild(
          void Function(FulfillmentArrangementVehicleBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FulfillmentArrangementVehicleBuilder toBuilder() =>
      FulfillmentArrangementVehicleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FulfillmentArrangementVehicle &&
        vehicleIndex == other.vehicleIndex &&
        name == other.name &&
        vehicleType == other.vehicleType &&
        numberOfVehicles == other.numberOfVehicles &&
        totalVehicleTrips == other.totalVehicleTrips;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vehicleIndex.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, vehicleType.hashCode);
    _$hash = $jc(_$hash, numberOfVehicles.hashCode);
    _$hash = $jc(_$hash, totalVehicleTrips.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FulfillmentArrangementVehicle')
          ..add('vehicleIndex', vehicleIndex)
          ..add('name', name)
          ..add('vehicleType', vehicleType)
          ..add('numberOfVehicles', numberOfVehicles)
          ..add('totalVehicleTrips', totalVehicleTrips))
        .toString();
  }
}

class FulfillmentArrangementVehicleBuilder
    implements
        Builder<FulfillmentArrangementVehicle,
            FulfillmentArrangementVehicleBuilder> {
  _$FulfillmentArrangementVehicle? _$v;

  int? _vehicleIndex;
  int? get vehicleIndex => _$this._vehicleIndex;
  set vehicleIndex(int? vehicleIndex) => _$this._vehicleIndex = vehicleIndex;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _vehicleType;
  String? get vehicleType => _$this._vehicleType;
  set vehicleType(String? vehicleType) => _$this._vehicleType = vehicleType;

  int? _numberOfVehicles;
  int? get numberOfVehicles => _$this._numberOfVehicles;
  set numberOfVehicles(int? numberOfVehicles) =>
      _$this._numberOfVehicles = numberOfVehicles;

  int? _totalVehicleTrips;
  int? get totalVehicleTrips => _$this._totalVehicleTrips;
  set totalVehicleTrips(int? totalVehicleTrips) =>
      _$this._totalVehicleTrips = totalVehicleTrips;

  FulfillmentArrangementVehicleBuilder() {
    FulfillmentArrangementVehicle._defaults(this);
  }

  FulfillmentArrangementVehicleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vehicleIndex = $v.vehicleIndex;
      _name = $v.name;
      _vehicleType = $v.vehicleType;
      _numberOfVehicles = $v.numberOfVehicles;
      _totalVehicleTrips = $v.totalVehicleTrips;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FulfillmentArrangementVehicle other) {
    _$v = other as _$FulfillmentArrangementVehicle;
  }

  @override
  void update(void Function(FulfillmentArrangementVehicleBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FulfillmentArrangementVehicle build() => _build();

  _$FulfillmentArrangementVehicle _build() {
    final _$result = _$v ??
        _$FulfillmentArrangementVehicle._(
          vehicleIndex: BuiltValueNullFieldError.checkNotNull(
              vehicleIndex, r'FulfillmentArrangementVehicle', 'vehicleIndex'),
          name: name,
          vehicleType: vehicleType,
          numberOfVehicles: BuiltValueNullFieldError.checkNotNull(
              numberOfVehicles,
              r'FulfillmentArrangementVehicle',
              'numberOfVehicles'),
          totalVehicleTrips: BuiltValueNullFieldError.checkNotNull(
              totalVehicleTrips,
              r'FulfillmentArrangementVehicle',
              'totalVehicleTrips'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
