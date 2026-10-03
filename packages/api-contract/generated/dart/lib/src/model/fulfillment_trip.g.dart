// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fulfillment_trip.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FulfillmentTrip extends FulfillmentTrip {
  @override
  final int vehicleIndex;
  @override
  final int tripNumber;
  @override
  final String? name;
  @override
  final int totalVehicleTrips;
  @override
  final DateTime? dispatchedAt;

  factory _$FulfillmentTrip([void Function(FulfillmentTripBuilder)? updates]) =>
      (FulfillmentTripBuilder()..update(updates))._build();

  _$FulfillmentTrip._(
      {required this.vehicleIndex,
      required this.tripNumber,
      this.name,
      required this.totalVehicleTrips,
      this.dispatchedAt})
      : super._();
  @override
  FulfillmentTrip rebuild(void Function(FulfillmentTripBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FulfillmentTripBuilder toBuilder() => FulfillmentTripBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FulfillmentTrip &&
        vehicleIndex == other.vehicleIndex &&
        tripNumber == other.tripNumber &&
        name == other.name &&
        totalVehicleTrips == other.totalVehicleTrips &&
        dispatchedAt == other.dispatchedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vehicleIndex.hashCode);
    _$hash = $jc(_$hash, tripNumber.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, totalVehicleTrips.hashCode);
    _$hash = $jc(_$hash, dispatchedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FulfillmentTrip')
          ..add('vehicleIndex', vehicleIndex)
          ..add('tripNumber', tripNumber)
          ..add('name', name)
          ..add('totalVehicleTrips', totalVehicleTrips)
          ..add('dispatchedAt', dispatchedAt))
        .toString();
  }
}

class FulfillmentTripBuilder
    implements Builder<FulfillmentTrip, FulfillmentTripBuilder> {
  _$FulfillmentTrip? _$v;

  int? _vehicleIndex;
  int? get vehicleIndex => _$this._vehicleIndex;
  set vehicleIndex(int? vehicleIndex) => _$this._vehicleIndex = vehicleIndex;

  int? _tripNumber;
  int? get tripNumber => _$this._tripNumber;
  set tripNumber(int? tripNumber) => _$this._tripNumber = tripNumber;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _totalVehicleTrips;
  int? get totalVehicleTrips => _$this._totalVehicleTrips;
  set totalVehicleTrips(int? totalVehicleTrips) =>
      _$this._totalVehicleTrips = totalVehicleTrips;

  DateTime? _dispatchedAt;
  DateTime? get dispatchedAt => _$this._dispatchedAt;
  set dispatchedAt(DateTime? dispatchedAt) =>
      _$this._dispatchedAt = dispatchedAt;

  FulfillmentTripBuilder() {
    FulfillmentTrip._defaults(this);
  }

  FulfillmentTripBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vehicleIndex = $v.vehicleIndex;
      _tripNumber = $v.tripNumber;
      _name = $v.name;
      _totalVehicleTrips = $v.totalVehicleTrips;
      _dispatchedAt = $v.dispatchedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FulfillmentTrip other) {
    _$v = other as _$FulfillmentTrip;
  }

  @override
  void update(void Function(FulfillmentTripBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FulfillmentTrip build() => _build();

  _$FulfillmentTrip _build() {
    final _$result = _$v ??
        _$FulfillmentTrip._(
          vehicleIndex: BuiltValueNullFieldError.checkNotNull(
              vehicleIndex, r'FulfillmentTrip', 'vehicleIndex'),
          tripNumber: BuiltValueNullFieldError.checkNotNull(
              tripNumber, r'FulfillmentTrip', 'tripNumber'),
          name: name,
          totalVehicleTrips: BuiltValueNullFieldError.checkNotNull(
              totalVehicleTrips, r'FulfillmentTrip', 'totalVehicleTrips'),
          dispatchedAt: dispatchedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
