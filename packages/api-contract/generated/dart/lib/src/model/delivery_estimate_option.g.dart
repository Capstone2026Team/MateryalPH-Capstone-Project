// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_estimate_option.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeliveryEstimateOption extends DeliveryEstimateOption {
  @override
  final String loadKey;
  @override
  final String vehicleName;
  @override
  final String vehicleType;
  @override
  final int vehicles;
  @override
  final int trips;
  @override
  final int feeCentavos;
  @override
  final int feePerTripCentavos;

  factory _$DeliveryEstimateOption(
          [void Function(DeliveryEstimateOptionBuilder)? updates]) =>
      (DeliveryEstimateOptionBuilder()..update(updates))._build();

  _$DeliveryEstimateOption._(
      {required this.loadKey,
      required this.vehicleName,
      required this.vehicleType,
      required this.vehicles,
      required this.trips,
      required this.feeCentavos,
      required this.feePerTripCentavos})
      : super._();
  @override
  DeliveryEstimateOption rebuild(
          void Function(DeliveryEstimateOptionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeliveryEstimateOptionBuilder toBuilder() =>
      DeliveryEstimateOptionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeliveryEstimateOption &&
        loadKey == other.loadKey &&
        vehicleName == other.vehicleName &&
        vehicleType == other.vehicleType &&
        vehicles == other.vehicles &&
        trips == other.trips &&
        feeCentavos == other.feeCentavos &&
        feePerTripCentavos == other.feePerTripCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, loadKey.hashCode);
    _$hash = $jc(_$hash, vehicleName.hashCode);
    _$hash = $jc(_$hash, vehicleType.hashCode);
    _$hash = $jc(_$hash, vehicles.hashCode);
    _$hash = $jc(_$hash, trips.hashCode);
    _$hash = $jc(_$hash, feeCentavos.hashCode);
    _$hash = $jc(_$hash, feePerTripCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeliveryEstimateOption')
          ..add('loadKey', loadKey)
          ..add('vehicleName', vehicleName)
          ..add('vehicleType', vehicleType)
          ..add('vehicles', vehicles)
          ..add('trips', trips)
          ..add('feeCentavos', feeCentavos)
          ..add('feePerTripCentavos', feePerTripCentavos))
        .toString();
  }
}

class DeliveryEstimateOptionBuilder
    implements Builder<DeliveryEstimateOption, DeliveryEstimateOptionBuilder> {
  _$DeliveryEstimateOption? _$v;

  String? _loadKey;
  String? get loadKey => _$this._loadKey;
  set loadKey(String? loadKey) => _$this._loadKey = loadKey;

  String? _vehicleName;
  String? get vehicleName => _$this._vehicleName;
  set vehicleName(String? vehicleName) => _$this._vehicleName = vehicleName;

  String? _vehicleType;
  String? get vehicleType => _$this._vehicleType;
  set vehicleType(String? vehicleType) => _$this._vehicleType = vehicleType;

  int? _vehicles;
  int? get vehicles => _$this._vehicles;
  set vehicles(int? vehicles) => _$this._vehicles = vehicles;

  int? _trips;
  int? get trips => _$this._trips;
  set trips(int? trips) => _$this._trips = trips;

  int? _feeCentavos;
  int? get feeCentavos => _$this._feeCentavos;
  set feeCentavos(int? feeCentavos) => _$this._feeCentavos = feeCentavos;

  int? _feePerTripCentavos;
  int? get feePerTripCentavos => _$this._feePerTripCentavos;
  set feePerTripCentavos(int? feePerTripCentavos) =>
      _$this._feePerTripCentavos = feePerTripCentavos;

  DeliveryEstimateOptionBuilder() {
    DeliveryEstimateOption._defaults(this);
  }

  DeliveryEstimateOptionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _loadKey = $v.loadKey;
      _vehicleName = $v.vehicleName;
      _vehicleType = $v.vehicleType;
      _vehicles = $v.vehicles;
      _trips = $v.trips;
      _feeCentavos = $v.feeCentavos;
      _feePerTripCentavos = $v.feePerTripCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeliveryEstimateOption other) {
    _$v = other as _$DeliveryEstimateOption;
  }

  @override
  void update(void Function(DeliveryEstimateOptionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeliveryEstimateOption build() => _build();

  _$DeliveryEstimateOption _build() {
    final _$result = _$v ??
        _$DeliveryEstimateOption._(
          loadKey: BuiltValueNullFieldError.checkNotNull(
              loadKey, r'DeliveryEstimateOption', 'loadKey'),
          vehicleName: BuiltValueNullFieldError.checkNotNull(
              vehicleName, r'DeliveryEstimateOption', 'vehicleName'),
          vehicleType: BuiltValueNullFieldError.checkNotNull(
              vehicleType, r'DeliveryEstimateOption', 'vehicleType'),
          vehicles: BuiltValueNullFieldError.checkNotNull(
              vehicles, r'DeliveryEstimateOption', 'vehicles'),
          trips: BuiltValueNullFieldError.checkNotNull(
              trips, r'DeliveryEstimateOption', 'trips'),
          feeCentavos: BuiltValueNullFieldError.checkNotNull(
              feeCentavos, r'DeliveryEstimateOption', 'feeCentavos'),
          feePerTripCentavos: BuiltValueNullFieldError.checkNotNull(
              feePerTripCentavos,
              r'DeliveryEstimateOption',
              'feePerTripCentavos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
