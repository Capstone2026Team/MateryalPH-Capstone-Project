// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_delivery_vehicle.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OrderDeliveryVehicle extends OrderDeliveryVehicle {
  @override
  final String? name;
  @override
  final String? vehicleCategory;
  @override
  final String? vehicleType;
  @override
  final String? customTypeName;
  @override
  final String? brand;
  @override
  final String? capacityKg;
  @override
  final String? heavyClassification;
  @override
  final int? configurationVersion;
  @override
  final int? rateVersion;
  @override
  final int numberOfVehicles;
  @override
  final int totalVehicleTrips;
  @override
  final int perTripCentavos;
  @override
  final int tripTotalCentavos;

  factory _$OrderDeliveryVehicle(
          [void Function(OrderDeliveryVehicleBuilder)? updates]) =>
      (OrderDeliveryVehicleBuilder()..update(updates))._build();

  _$OrderDeliveryVehicle._(
      {this.name,
      this.vehicleCategory,
      this.vehicleType,
      this.customTypeName,
      this.brand,
      this.capacityKg,
      this.heavyClassification,
      this.configurationVersion,
      this.rateVersion,
      required this.numberOfVehicles,
      required this.totalVehicleTrips,
      required this.perTripCentavos,
      required this.tripTotalCentavos})
      : super._();
  @override
  OrderDeliveryVehicle rebuild(
          void Function(OrderDeliveryVehicleBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderDeliveryVehicleBuilder toBuilder() =>
      OrderDeliveryVehicleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderDeliveryVehicle &&
        name == other.name &&
        vehicleCategory == other.vehicleCategory &&
        vehicleType == other.vehicleType &&
        customTypeName == other.customTypeName &&
        brand == other.brand &&
        capacityKg == other.capacityKg &&
        heavyClassification == other.heavyClassification &&
        configurationVersion == other.configurationVersion &&
        rateVersion == other.rateVersion &&
        numberOfVehicles == other.numberOfVehicles &&
        totalVehicleTrips == other.totalVehicleTrips &&
        perTripCentavos == other.perTripCentavos &&
        tripTotalCentavos == other.tripTotalCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, vehicleCategory.hashCode);
    _$hash = $jc(_$hash, vehicleType.hashCode);
    _$hash = $jc(_$hash, customTypeName.hashCode);
    _$hash = $jc(_$hash, brand.hashCode);
    _$hash = $jc(_$hash, capacityKg.hashCode);
    _$hash = $jc(_$hash, heavyClassification.hashCode);
    _$hash = $jc(_$hash, configurationVersion.hashCode);
    _$hash = $jc(_$hash, rateVersion.hashCode);
    _$hash = $jc(_$hash, numberOfVehicles.hashCode);
    _$hash = $jc(_$hash, totalVehicleTrips.hashCode);
    _$hash = $jc(_$hash, perTripCentavos.hashCode);
    _$hash = $jc(_$hash, tripTotalCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderDeliveryVehicle')
          ..add('name', name)
          ..add('vehicleCategory', vehicleCategory)
          ..add('vehicleType', vehicleType)
          ..add('customTypeName', customTypeName)
          ..add('brand', brand)
          ..add('capacityKg', capacityKg)
          ..add('heavyClassification', heavyClassification)
          ..add('configurationVersion', configurationVersion)
          ..add('rateVersion', rateVersion)
          ..add('numberOfVehicles', numberOfVehicles)
          ..add('totalVehicleTrips', totalVehicleTrips)
          ..add('perTripCentavos', perTripCentavos)
          ..add('tripTotalCentavos', tripTotalCentavos))
        .toString();
  }
}

class OrderDeliveryVehicleBuilder
    implements Builder<OrderDeliveryVehicle, OrderDeliveryVehicleBuilder> {
  _$OrderDeliveryVehicle? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _vehicleCategory;
  String? get vehicleCategory => _$this._vehicleCategory;
  set vehicleCategory(String? vehicleCategory) =>
      _$this._vehicleCategory = vehicleCategory;

  String? _vehicleType;
  String? get vehicleType => _$this._vehicleType;
  set vehicleType(String? vehicleType) => _$this._vehicleType = vehicleType;

  String? _customTypeName;
  String? get customTypeName => _$this._customTypeName;
  set customTypeName(String? customTypeName) =>
      _$this._customTypeName = customTypeName;

  String? _brand;
  String? get brand => _$this._brand;
  set brand(String? brand) => _$this._brand = brand;

  String? _capacityKg;
  String? get capacityKg => _$this._capacityKg;
  set capacityKg(String? capacityKg) => _$this._capacityKg = capacityKg;

  String? _heavyClassification;
  String? get heavyClassification => _$this._heavyClassification;
  set heavyClassification(String? heavyClassification) =>
      _$this._heavyClassification = heavyClassification;

  int? _configurationVersion;
  int? get configurationVersion => _$this._configurationVersion;
  set configurationVersion(int? configurationVersion) =>
      _$this._configurationVersion = configurationVersion;

  int? _rateVersion;
  int? get rateVersion => _$this._rateVersion;
  set rateVersion(int? rateVersion) => _$this._rateVersion = rateVersion;

  int? _numberOfVehicles;
  int? get numberOfVehicles => _$this._numberOfVehicles;
  set numberOfVehicles(int? numberOfVehicles) =>
      _$this._numberOfVehicles = numberOfVehicles;

  int? _totalVehicleTrips;
  int? get totalVehicleTrips => _$this._totalVehicleTrips;
  set totalVehicleTrips(int? totalVehicleTrips) =>
      _$this._totalVehicleTrips = totalVehicleTrips;

  int? _perTripCentavos;
  int? get perTripCentavos => _$this._perTripCentavos;
  set perTripCentavos(int? perTripCentavos) =>
      _$this._perTripCentavos = perTripCentavos;

  int? _tripTotalCentavos;
  int? get tripTotalCentavos => _$this._tripTotalCentavos;
  set tripTotalCentavos(int? tripTotalCentavos) =>
      _$this._tripTotalCentavos = tripTotalCentavos;

  OrderDeliveryVehicleBuilder() {
    OrderDeliveryVehicle._defaults(this);
  }

  OrderDeliveryVehicleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _vehicleCategory = $v.vehicleCategory;
      _vehicleType = $v.vehicleType;
      _customTypeName = $v.customTypeName;
      _brand = $v.brand;
      _capacityKg = $v.capacityKg;
      _heavyClassification = $v.heavyClassification;
      _configurationVersion = $v.configurationVersion;
      _rateVersion = $v.rateVersion;
      _numberOfVehicles = $v.numberOfVehicles;
      _totalVehicleTrips = $v.totalVehicleTrips;
      _perTripCentavos = $v.perTripCentavos;
      _tripTotalCentavos = $v.tripTotalCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderDeliveryVehicle other) {
    _$v = other as _$OrderDeliveryVehicle;
  }

  @override
  void update(void Function(OrderDeliveryVehicleBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderDeliveryVehicle build() => _build();

  _$OrderDeliveryVehicle _build() {
    final _$result = _$v ??
        _$OrderDeliveryVehicle._(
          name: name,
          vehicleCategory: vehicleCategory,
          vehicleType: vehicleType,
          customTypeName: customTypeName,
          brand: brand,
          capacityKg: capacityKg,
          heavyClassification: heavyClassification,
          configurationVersion: configurationVersion,
          rateVersion: rateVersion,
          numberOfVehicles: BuiltValueNullFieldError.checkNotNull(
              numberOfVehicles, r'OrderDeliveryVehicle', 'numberOfVehicles'),
          totalVehicleTrips: BuiltValueNullFieldError.checkNotNull(
              totalVehicleTrips, r'OrderDeliveryVehicle', 'totalVehicleTrips'),
          perTripCentavos: BuiltValueNullFieldError.checkNotNull(
              perTripCentavos, r'OrderDeliveryVehicle', 'perTripCentavos'),
          tripTotalCentavos: BuiltValueNullFieldError.checkNotNull(
              tripTotalCentavos, r'OrderDeliveryVehicle', 'tripTotalCentavos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
