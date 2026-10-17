// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_vehicle_option.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeliveryVehicleOption extends DeliveryVehicleOption {
  @override
  final int vehicleIndex;
  @override
  final String vehicleId;
  @override
  final String name;
  @override
  final String vehicleType;
  @override
  final int numberOfVehicles;
  @override
  final int totalVehicleTrips;
  @override
  final bool available;
  @override
  final String unavailableReason;

  factory _$DeliveryVehicleOption(
          [void Function(DeliveryVehicleOptionBuilder)? updates]) =>
      (DeliveryVehicleOptionBuilder()..update(updates))._build();

  _$DeliveryVehicleOption._(
      {required this.vehicleIndex,
      required this.vehicleId,
      required this.name,
      required this.vehicleType,
      required this.numberOfVehicles,
      required this.totalVehicleTrips,
      required this.available,
      required this.unavailableReason})
      : super._();
  @override
  DeliveryVehicleOption rebuild(
          void Function(DeliveryVehicleOptionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeliveryVehicleOptionBuilder toBuilder() =>
      DeliveryVehicleOptionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeliveryVehicleOption &&
        vehicleIndex == other.vehicleIndex &&
        vehicleId == other.vehicleId &&
        name == other.name &&
        vehicleType == other.vehicleType &&
        numberOfVehicles == other.numberOfVehicles &&
        totalVehicleTrips == other.totalVehicleTrips &&
        available == other.available &&
        unavailableReason == other.unavailableReason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vehicleIndex.hashCode);
    _$hash = $jc(_$hash, vehicleId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, vehicleType.hashCode);
    _$hash = $jc(_$hash, numberOfVehicles.hashCode);
    _$hash = $jc(_$hash, totalVehicleTrips.hashCode);
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jc(_$hash, unavailableReason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeliveryVehicleOption')
          ..add('vehicleIndex', vehicleIndex)
          ..add('vehicleId', vehicleId)
          ..add('name', name)
          ..add('vehicleType', vehicleType)
          ..add('numberOfVehicles', numberOfVehicles)
          ..add('totalVehicleTrips', totalVehicleTrips)
          ..add('available', available)
          ..add('unavailableReason', unavailableReason))
        .toString();
  }
}

class DeliveryVehicleOptionBuilder
    implements Builder<DeliveryVehicleOption, DeliveryVehicleOptionBuilder> {
  _$DeliveryVehicleOption? _$v;

  int? _vehicleIndex;
  int? get vehicleIndex => _$this._vehicleIndex;
  set vehicleIndex(int? vehicleIndex) => _$this._vehicleIndex = vehicleIndex;

  String? _vehicleId;
  String? get vehicleId => _$this._vehicleId;
  set vehicleId(String? vehicleId) => _$this._vehicleId = vehicleId;

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

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  String? _unavailableReason;
  String? get unavailableReason => _$this._unavailableReason;
  set unavailableReason(String? unavailableReason) =>
      _$this._unavailableReason = unavailableReason;

  DeliveryVehicleOptionBuilder() {
    DeliveryVehicleOption._defaults(this);
  }

  DeliveryVehicleOptionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vehicleIndex = $v.vehicleIndex;
      _vehicleId = $v.vehicleId;
      _name = $v.name;
      _vehicleType = $v.vehicleType;
      _numberOfVehicles = $v.numberOfVehicles;
      _totalVehicleTrips = $v.totalVehicleTrips;
      _available = $v.available;
      _unavailableReason = $v.unavailableReason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeliveryVehicleOption other) {
    _$v = other as _$DeliveryVehicleOption;
  }

  @override
  void update(void Function(DeliveryVehicleOptionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeliveryVehicleOption build() => _build();

  _$DeliveryVehicleOption _build() {
    final _$result = _$v ??
        _$DeliveryVehicleOption._(
          vehicleIndex: BuiltValueNullFieldError.checkNotNull(
              vehicleIndex, r'DeliveryVehicleOption', 'vehicleIndex'),
          vehicleId: BuiltValueNullFieldError.checkNotNull(
              vehicleId, r'DeliveryVehicleOption', 'vehicleId'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'DeliveryVehicleOption', 'name'),
          vehicleType: BuiltValueNullFieldError.checkNotNull(
              vehicleType, r'DeliveryVehicleOption', 'vehicleType'),
          numberOfVehicles: BuiltValueNullFieldError.checkNotNull(
              numberOfVehicles, r'DeliveryVehicleOption', 'numberOfVehicles'),
          totalVehicleTrips: BuiltValueNullFieldError.checkNotNull(
              totalVehicleTrips, r'DeliveryVehicleOption', 'totalVehicleTrips'),
          available: BuiltValueNullFieldError.checkNotNull(
              available, r'DeliveryVehicleOption', 'available'),
          unavailableReason: BuiltValueNullFieldError.checkNotNull(
              unavailableReason, r'DeliveryVehicleOption', 'unavailableReason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
