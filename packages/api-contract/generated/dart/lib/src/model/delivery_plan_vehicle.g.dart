// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_plan_vehicle.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeliveryPlanVehicle extends DeliveryPlanVehicle {
  @override
  final String vehicleId;
  @override
  final String name;
  @override
  final String? vehicleCategory;
  @override
  final String vehicleType;
  @override
  final String? customTypeName;
  @override
  final String? brand;
  @override
  final int numberAvailable;
  @override
  final String capacityKg;
  @override
  final String? mixerCapacityM3;
  @override
  final String heavyClassification;
  @override
  final int maximumDistanceKm;
  @override
  final int baseFeeCentavos;
  @override
  final int perKmCentavos;
  @override
  final int perTripCentavos;
  @override
  final bool withinRange;
  @override
  final int rateVersion;
  @override
  final int configurationVersion;
  @override
  final int? numberOfVehicles;
  @override
  final int? totalVehicleTrips;
  @override
  final int? estimatedChargeCentavos;
  @override
  final String? limitingFactor;

  factory _$DeliveryPlanVehicle(
          [void Function(DeliveryPlanVehicleBuilder)? updates]) =>
      (DeliveryPlanVehicleBuilder()..update(updates))._build();

  _$DeliveryPlanVehicle._(
      {required this.vehicleId,
      required this.name,
      this.vehicleCategory,
      required this.vehicleType,
      this.customTypeName,
      this.brand,
      required this.numberAvailable,
      required this.capacityKg,
      this.mixerCapacityM3,
      required this.heavyClassification,
      required this.maximumDistanceKm,
      required this.baseFeeCentavos,
      required this.perKmCentavos,
      required this.perTripCentavos,
      required this.withinRange,
      required this.rateVersion,
      required this.configurationVersion,
      this.numberOfVehicles,
      this.totalVehicleTrips,
      this.estimatedChargeCentavos,
      this.limitingFactor})
      : super._();
  @override
  DeliveryPlanVehicle rebuild(
          void Function(DeliveryPlanVehicleBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeliveryPlanVehicleBuilder toBuilder() =>
      DeliveryPlanVehicleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeliveryPlanVehicle &&
        vehicleId == other.vehicleId &&
        name == other.name &&
        vehicleCategory == other.vehicleCategory &&
        vehicleType == other.vehicleType &&
        customTypeName == other.customTypeName &&
        brand == other.brand &&
        numberAvailable == other.numberAvailable &&
        capacityKg == other.capacityKg &&
        mixerCapacityM3 == other.mixerCapacityM3 &&
        heavyClassification == other.heavyClassification &&
        maximumDistanceKm == other.maximumDistanceKm &&
        baseFeeCentavos == other.baseFeeCentavos &&
        perKmCentavos == other.perKmCentavos &&
        perTripCentavos == other.perTripCentavos &&
        withinRange == other.withinRange &&
        rateVersion == other.rateVersion &&
        configurationVersion == other.configurationVersion &&
        numberOfVehicles == other.numberOfVehicles &&
        totalVehicleTrips == other.totalVehicleTrips &&
        estimatedChargeCentavos == other.estimatedChargeCentavos &&
        limitingFactor == other.limitingFactor;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vehicleId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, vehicleCategory.hashCode);
    _$hash = $jc(_$hash, vehicleType.hashCode);
    _$hash = $jc(_$hash, customTypeName.hashCode);
    _$hash = $jc(_$hash, brand.hashCode);
    _$hash = $jc(_$hash, numberAvailable.hashCode);
    _$hash = $jc(_$hash, capacityKg.hashCode);
    _$hash = $jc(_$hash, mixerCapacityM3.hashCode);
    _$hash = $jc(_$hash, heavyClassification.hashCode);
    _$hash = $jc(_$hash, maximumDistanceKm.hashCode);
    _$hash = $jc(_$hash, baseFeeCentavos.hashCode);
    _$hash = $jc(_$hash, perKmCentavos.hashCode);
    _$hash = $jc(_$hash, perTripCentavos.hashCode);
    _$hash = $jc(_$hash, withinRange.hashCode);
    _$hash = $jc(_$hash, rateVersion.hashCode);
    _$hash = $jc(_$hash, configurationVersion.hashCode);
    _$hash = $jc(_$hash, numberOfVehicles.hashCode);
    _$hash = $jc(_$hash, totalVehicleTrips.hashCode);
    _$hash = $jc(_$hash, estimatedChargeCentavos.hashCode);
    _$hash = $jc(_$hash, limitingFactor.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeliveryPlanVehicle')
          ..add('vehicleId', vehicleId)
          ..add('name', name)
          ..add('vehicleCategory', vehicleCategory)
          ..add('vehicleType', vehicleType)
          ..add('customTypeName', customTypeName)
          ..add('brand', brand)
          ..add('numberAvailable', numberAvailable)
          ..add('capacityKg', capacityKg)
          ..add('mixerCapacityM3', mixerCapacityM3)
          ..add('heavyClassification', heavyClassification)
          ..add('maximumDistanceKm', maximumDistanceKm)
          ..add('baseFeeCentavos', baseFeeCentavos)
          ..add('perKmCentavos', perKmCentavos)
          ..add('perTripCentavos', perTripCentavos)
          ..add('withinRange', withinRange)
          ..add('rateVersion', rateVersion)
          ..add('configurationVersion', configurationVersion)
          ..add('numberOfVehicles', numberOfVehicles)
          ..add('totalVehicleTrips', totalVehicleTrips)
          ..add('estimatedChargeCentavos', estimatedChargeCentavos)
          ..add('limitingFactor', limitingFactor))
        .toString();
  }
}

class DeliveryPlanVehicleBuilder
    implements Builder<DeliveryPlanVehicle, DeliveryPlanVehicleBuilder> {
  _$DeliveryPlanVehicle? _$v;

  String? _vehicleId;
  String? get vehicleId => _$this._vehicleId;
  set vehicleId(String? vehicleId) => _$this._vehicleId = vehicleId;

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

  int? _numberAvailable;
  int? get numberAvailable => _$this._numberAvailable;
  set numberAvailable(int? numberAvailable) =>
      _$this._numberAvailable = numberAvailable;

  String? _capacityKg;
  String? get capacityKg => _$this._capacityKg;
  set capacityKg(String? capacityKg) => _$this._capacityKg = capacityKg;

  String? _mixerCapacityM3;
  String? get mixerCapacityM3 => _$this._mixerCapacityM3;
  set mixerCapacityM3(String? mixerCapacityM3) =>
      _$this._mixerCapacityM3 = mixerCapacityM3;

  String? _heavyClassification;
  String? get heavyClassification => _$this._heavyClassification;
  set heavyClassification(String? heavyClassification) =>
      _$this._heavyClassification = heavyClassification;

  int? _maximumDistanceKm;
  int? get maximumDistanceKm => _$this._maximumDistanceKm;
  set maximumDistanceKm(int? maximumDistanceKm) =>
      _$this._maximumDistanceKm = maximumDistanceKm;

  int? _baseFeeCentavos;
  int? get baseFeeCentavos => _$this._baseFeeCentavos;
  set baseFeeCentavos(int? baseFeeCentavos) =>
      _$this._baseFeeCentavos = baseFeeCentavos;

  int? _perKmCentavos;
  int? get perKmCentavos => _$this._perKmCentavos;
  set perKmCentavos(int? perKmCentavos) =>
      _$this._perKmCentavos = perKmCentavos;

  int? _perTripCentavos;
  int? get perTripCentavos => _$this._perTripCentavos;
  set perTripCentavos(int? perTripCentavos) =>
      _$this._perTripCentavos = perTripCentavos;

  bool? _withinRange;
  bool? get withinRange => _$this._withinRange;
  set withinRange(bool? withinRange) => _$this._withinRange = withinRange;

  int? _rateVersion;
  int? get rateVersion => _$this._rateVersion;
  set rateVersion(int? rateVersion) => _$this._rateVersion = rateVersion;

  int? _configurationVersion;
  int? get configurationVersion => _$this._configurationVersion;
  set configurationVersion(int? configurationVersion) =>
      _$this._configurationVersion = configurationVersion;

  int? _numberOfVehicles;
  int? get numberOfVehicles => _$this._numberOfVehicles;
  set numberOfVehicles(int? numberOfVehicles) =>
      _$this._numberOfVehicles = numberOfVehicles;

  int? _totalVehicleTrips;
  int? get totalVehicleTrips => _$this._totalVehicleTrips;
  set totalVehicleTrips(int? totalVehicleTrips) =>
      _$this._totalVehicleTrips = totalVehicleTrips;

  int? _estimatedChargeCentavos;
  int? get estimatedChargeCentavos => _$this._estimatedChargeCentavos;
  set estimatedChargeCentavos(int? estimatedChargeCentavos) =>
      _$this._estimatedChargeCentavos = estimatedChargeCentavos;

  String? _limitingFactor;
  String? get limitingFactor => _$this._limitingFactor;
  set limitingFactor(String? limitingFactor) =>
      _$this._limitingFactor = limitingFactor;

  DeliveryPlanVehicleBuilder() {
    DeliveryPlanVehicle._defaults(this);
  }

  DeliveryPlanVehicleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vehicleId = $v.vehicleId;
      _name = $v.name;
      _vehicleCategory = $v.vehicleCategory;
      _vehicleType = $v.vehicleType;
      _customTypeName = $v.customTypeName;
      _brand = $v.brand;
      _numberAvailable = $v.numberAvailable;
      _capacityKg = $v.capacityKg;
      _mixerCapacityM3 = $v.mixerCapacityM3;
      _heavyClassification = $v.heavyClassification;
      _maximumDistanceKm = $v.maximumDistanceKm;
      _baseFeeCentavos = $v.baseFeeCentavos;
      _perKmCentavos = $v.perKmCentavos;
      _perTripCentavos = $v.perTripCentavos;
      _withinRange = $v.withinRange;
      _rateVersion = $v.rateVersion;
      _configurationVersion = $v.configurationVersion;
      _numberOfVehicles = $v.numberOfVehicles;
      _totalVehicleTrips = $v.totalVehicleTrips;
      _estimatedChargeCentavos = $v.estimatedChargeCentavos;
      _limitingFactor = $v.limitingFactor;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeliveryPlanVehicle other) {
    _$v = other as _$DeliveryPlanVehicle;
  }

  @override
  void update(void Function(DeliveryPlanVehicleBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeliveryPlanVehicle build() => _build();

  _$DeliveryPlanVehicle _build() {
    final _$result = _$v ??
        _$DeliveryPlanVehicle._(
          vehicleId: BuiltValueNullFieldError.checkNotNull(
              vehicleId, r'DeliveryPlanVehicle', 'vehicleId'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'DeliveryPlanVehicle', 'name'),
          vehicleCategory: vehicleCategory,
          vehicleType: BuiltValueNullFieldError.checkNotNull(
              vehicleType, r'DeliveryPlanVehicle', 'vehicleType'),
          customTypeName: customTypeName,
          brand: brand,
          numberAvailable: BuiltValueNullFieldError.checkNotNull(
              numberAvailable, r'DeliveryPlanVehicle', 'numberAvailable'),
          capacityKg: BuiltValueNullFieldError.checkNotNull(
              capacityKg, r'DeliveryPlanVehicle', 'capacityKg'),
          mixerCapacityM3: mixerCapacityM3,
          heavyClassification: BuiltValueNullFieldError.checkNotNull(
              heavyClassification,
              r'DeliveryPlanVehicle',
              'heavyClassification'),
          maximumDistanceKm: BuiltValueNullFieldError.checkNotNull(
              maximumDistanceKm, r'DeliveryPlanVehicle', 'maximumDistanceKm'),
          baseFeeCentavos: BuiltValueNullFieldError.checkNotNull(
              baseFeeCentavos, r'DeliveryPlanVehicle', 'baseFeeCentavos'),
          perKmCentavos: BuiltValueNullFieldError.checkNotNull(
              perKmCentavos, r'DeliveryPlanVehicle', 'perKmCentavos'),
          perTripCentavos: BuiltValueNullFieldError.checkNotNull(
              perTripCentavos, r'DeliveryPlanVehicle', 'perTripCentavos'),
          withinRange: BuiltValueNullFieldError.checkNotNull(
              withinRange, r'DeliveryPlanVehicle', 'withinRange'),
          rateVersion: BuiltValueNullFieldError.checkNotNull(
              rateVersion, r'DeliveryPlanVehicle', 'rateVersion'),
          configurationVersion: BuiltValueNullFieldError.checkNotNull(
              configurationVersion,
              r'DeliveryPlanVehicle',
              'configurationVersion'),
          numberOfVehicles: numberOfVehicles,
          totalVehicleTrips: totalVehicleTrips,
          estimatedChargeCentavos: estimatedChargeCentavos,
          limitingFactor: limitingFactor,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
