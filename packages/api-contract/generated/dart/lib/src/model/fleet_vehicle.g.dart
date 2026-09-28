// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fleet_vehicle.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FleetVehicleVehicleCategoryEnum
    _$fleetVehicleVehicleCategoryEnum_MOTORCYCLE =
    const FleetVehicleVehicleCategoryEnum._('MOTORCYCLE');
const FleetVehicleVehicleCategoryEnum _$fleetVehicleVehicleCategoryEnum_PICKUP =
    const FleetVehicleVehicleCategoryEnum._('PICKUP');
const FleetVehicleVehicleCategoryEnum _$fleetVehicleVehicleCategoryEnum_VAN =
    const FleetVehicleVehicleCategoryEnum._('VAN');
const FleetVehicleVehicleCategoryEnum _$fleetVehicleVehicleCategoryEnum_TRUCK =
    const FleetVehicleVehicleCategoryEnum._('TRUCK');

FleetVehicleVehicleCategoryEnum _$fleetVehicleVehicleCategoryEnumValueOf(
    String name) {
  switch (name) {
    case 'MOTORCYCLE':
      return _$fleetVehicleVehicleCategoryEnum_MOTORCYCLE;
    case 'PICKUP':
      return _$fleetVehicleVehicleCategoryEnum_PICKUP;
    case 'VAN':
      return _$fleetVehicleVehicleCategoryEnum_VAN;
    case 'TRUCK':
      return _$fleetVehicleVehicleCategoryEnum_TRUCK;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FleetVehicleVehicleCategoryEnum>
    _$fleetVehicleVehicleCategoryEnumValues = BuiltSet<
        FleetVehicleVehicleCategoryEnum>(const <FleetVehicleVehicleCategoryEnum>[
  _$fleetVehicleVehicleCategoryEnum_MOTORCYCLE,
  _$fleetVehicleVehicleCategoryEnum_PICKUP,
  _$fleetVehicleVehicleCategoryEnum_VAN,
  _$fleetVehicleVehicleCategoryEnum_TRUCK,
]);

const FleetVehicleHeavyClassificationEnum
    _$fleetVehicleHeavyClassificationEnum_HEAVY =
    const FleetVehicleHeavyClassificationEnum._('HEAVY');
const FleetVehicleHeavyClassificationEnum
    _$fleetVehicleHeavyClassificationEnum_NOT_HEAVY =
    const FleetVehicleHeavyClassificationEnum._('NOT_HEAVY');

FleetVehicleHeavyClassificationEnum
    _$fleetVehicleHeavyClassificationEnumValueOf(String name) {
  switch (name) {
    case 'HEAVY':
      return _$fleetVehicleHeavyClassificationEnum_HEAVY;
    case 'NOT_HEAVY':
      return _$fleetVehicleHeavyClassificationEnum_NOT_HEAVY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FleetVehicleHeavyClassificationEnum>
    _$fleetVehicleHeavyClassificationEnumValues = BuiltSet<
        FleetVehicleHeavyClassificationEnum>(const <FleetVehicleHeavyClassificationEnum>[
  _$fleetVehicleHeavyClassificationEnum_HEAVY,
  _$fleetVehicleHeavyClassificationEnum_NOT_HEAVY,
]);

Serializer<FleetVehicleVehicleCategoryEnum>
    _$fleetVehicleVehicleCategoryEnumSerializer =
    _$FleetVehicleVehicleCategoryEnumSerializer();
Serializer<FleetVehicleHeavyClassificationEnum>
    _$fleetVehicleHeavyClassificationEnumSerializer =
    _$FleetVehicleHeavyClassificationEnumSerializer();

class _$FleetVehicleVehicleCategoryEnumSerializer
    implements PrimitiveSerializer<FleetVehicleVehicleCategoryEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'MOTORCYCLE': 'MOTORCYCLE',
    'PICKUP': 'PICKUP',
    'VAN': 'VAN',
    'TRUCK': 'TRUCK',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'MOTORCYCLE': 'MOTORCYCLE',
    'PICKUP': 'PICKUP',
    'VAN': 'VAN',
    'TRUCK': 'TRUCK',
  };

  @override
  final Iterable<Type> types = const <Type>[FleetVehicleVehicleCategoryEnum];
  @override
  final String wireName = 'FleetVehicleVehicleCategoryEnum';

  @override
  Object serialize(
          Serializers serializers, FleetVehicleVehicleCategoryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FleetVehicleVehicleCategoryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FleetVehicleVehicleCategoryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FleetVehicleHeavyClassificationEnumSerializer
    implements PrimitiveSerializer<FleetVehicleHeavyClassificationEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'HEAVY': 'HEAVY',
    'NOT_HEAVY': 'NOT_HEAVY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'HEAVY': 'HEAVY',
    'NOT_HEAVY': 'NOT_HEAVY',
  };

  @override
  final Iterable<Type> types = const <Type>[
    FleetVehicleHeavyClassificationEnum
  ];
  @override
  final String wireName = 'FleetVehicleHeavyClassificationEnum';

  @override
  Object serialize(
          Serializers serializers, FleetVehicleHeavyClassificationEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FleetVehicleHeavyClassificationEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FleetVehicleHeavyClassificationEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FleetVehicle extends FleetVehicle {
  @override
  final String id;
  @override
  final int lockVersion;
  @override
  final int configurationVersion;
  @override
  final FleetVehicleVehicleCategoryEnum? vehicleCategory;
  @override
  final String vehicleType;
  @override
  final String? customTypeName;
  @override
  final String name;
  @override
  final String? brand;
  @override
  final String? imageFileId;
  @override
  final int numberAvailable;
  @override
  final num capacityKg;
  @override
  final num? cargoLengthM;
  @override
  final num? cargoWidthM;
  @override
  final num? cargoHeightM;
  @override
  final num? mixerCapacityM3;
  @override
  final FleetVehicleHeavyClassificationEnum? heavyClassification;
  @override
  final bool active;
  @override
  final bool available;
  @override
  final int? rateVersion;
  @override
  final int? baseFeeCentavos;
  @override
  final int? perKmCentavos;
  @override
  final int? maximumDistanceKm;
  @override
  final FleetVehicleEligibility eligibility;
  @override
  final String? updatedAt;

  factory _$FleetVehicle([void Function(FleetVehicleBuilder)? updates]) =>
      (FleetVehicleBuilder()..update(updates))._build();

  _$FleetVehicle._(
      {required this.id,
      required this.lockVersion,
      required this.configurationVersion,
      this.vehicleCategory,
      required this.vehicleType,
      this.customTypeName,
      required this.name,
      this.brand,
      this.imageFileId,
      required this.numberAvailable,
      required this.capacityKg,
      this.cargoLengthM,
      this.cargoWidthM,
      this.cargoHeightM,
      this.mixerCapacityM3,
      this.heavyClassification,
      required this.active,
      required this.available,
      this.rateVersion,
      this.baseFeeCentavos,
      this.perKmCentavos,
      this.maximumDistanceKm,
      required this.eligibility,
      this.updatedAt})
      : super._();
  @override
  FleetVehicle rebuild(void Function(FleetVehicleBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FleetVehicleBuilder toBuilder() => FleetVehicleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FleetVehicle &&
        id == other.id &&
        lockVersion == other.lockVersion &&
        configurationVersion == other.configurationVersion &&
        vehicleCategory == other.vehicleCategory &&
        vehicleType == other.vehicleType &&
        customTypeName == other.customTypeName &&
        name == other.name &&
        brand == other.brand &&
        imageFileId == other.imageFileId &&
        numberAvailable == other.numberAvailable &&
        capacityKg == other.capacityKg &&
        cargoLengthM == other.cargoLengthM &&
        cargoWidthM == other.cargoWidthM &&
        cargoHeightM == other.cargoHeightM &&
        mixerCapacityM3 == other.mixerCapacityM3 &&
        heavyClassification == other.heavyClassification &&
        active == other.active &&
        available == other.available &&
        rateVersion == other.rateVersion &&
        baseFeeCentavos == other.baseFeeCentavos &&
        perKmCentavos == other.perKmCentavos &&
        maximumDistanceKm == other.maximumDistanceKm &&
        eligibility == other.eligibility &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, configurationVersion.hashCode);
    _$hash = $jc(_$hash, vehicleCategory.hashCode);
    _$hash = $jc(_$hash, vehicleType.hashCode);
    _$hash = $jc(_$hash, customTypeName.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, brand.hashCode);
    _$hash = $jc(_$hash, imageFileId.hashCode);
    _$hash = $jc(_$hash, numberAvailable.hashCode);
    _$hash = $jc(_$hash, capacityKg.hashCode);
    _$hash = $jc(_$hash, cargoLengthM.hashCode);
    _$hash = $jc(_$hash, cargoWidthM.hashCode);
    _$hash = $jc(_$hash, cargoHeightM.hashCode);
    _$hash = $jc(_$hash, mixerCapacityM3.hashCode);
    _$hash = $jc(_$hash, heavyClassification.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jc(_$hash, rateVersion.hashCode);
    _$hash = $jc(_$hash, baseFeeCentavos.hashCode);
    _$hash = $jc(_$hash, perKmCentavos.hashCode);
    _$hash = $jc(_$hash, maximumDistanceKm.hashCode);
    _$hash = $jc(_$hash, eligibility.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FleetVehicle')
          ..add('id', id)
          ..add('lockVersion', lockVersion)
          ..add('configurationVersion', configurationVersion)
          ..add('vehicleCategory', vehicleCategory)
          ..add('vehicleType', vehicleType)
          ..add('customTypeName', customTypeName)
          ..add('name', name)
          ..add('brand', brand)
          ..add('imageFileId', imageFileId)
          ..add('numberAvailable', numberAvailable)
          ..add('capacityKg', capacityKg)
          ..add('cargoLengthM', cargoLengthM)
          ..add('cargoWidthM', cargoWidthM)
          ..add('cargoHeightM', cargoHeightM)
          ..add('mixerCapacityM3', mixerCapacityM3)
          ..add('heavyClassification', heavyClassification)
          ..add('active', active)
          ..add('available', available)
          ..add('rateVersion', rateVersion)
          ..add('baseFeeCentavos', baseFeeCentavos)
          ..add('perKmCentavos', perKmCentavos)
          ..add('maximumDistanceKm', maximumDistanceKm)
          ..add('eligibility', eligibility)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class FleetVehicleBuilder
    implements Builder<FleetVehicle, FleetVehicleBuilder> {
  _$FleetVehicle? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  int? _configurationVersion;
  int? get configurationVersion => _$this._configurationVersion;
  set configurationVersion(int? configurationVersion) =>
      _$this._configurationVersion = configurationVersion;

  FleetVehicleVehicleCategoryEnum? _vehicleCategory;
  FleetVehicleVehicleCategoryEnum? get vehicleCategory =>
      _$this._vehicleCategory;
  set vehicleCategory(FleetVehicleVehicleCategoryEnum? vehicleCategory) =>
      _$this._vehicleCategory = vehicleCategory;

  String? _vehicleType;
  String? get vehicleType => _$this._vehicleType;
  set vehicleType(String? vehicleType) => _$this._vehicleType = vehicleType;

  String? _customTypeName;
  String? get customTypeName => _$this._customTypeName;
  set customTypeName(String? customTypeName) =>
      _$this._customTypeName = customTypeName;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _brand;
  String? get brand => _$this._brand;
  set brand(String? brand) => _$this._brand = brand;

  String? _imageFileId;
  String? get imageFileId => _$this._imageFileId;
  set imageFileId(String? imageFileId) => _$this._imageFileId = imageFileId;

  int? _numberAvailable;
  int? get numberAvailable => _$this._numberAvailable;
  set numberAvailable(int? numberAvailable) =>
      _$this._numberAvailable = numberAvailable;

  num? _capacityKg;
  num? get capacityKg => _$this._capacityKg;
  set capacityKg(num? capacityKg) => _$this._capacityKg = capacityKg;

  num? _cargoLengthM;
  num? get cargoLengthM => _$this._cargoLengthM;
  set cargoLengthM(num? cargoLengthM) => _$this._cargoLengthM = cargoLengthM;

  num? _cargoWidthM;
  num? get cargoWidthM => _$this._cargoWidthM;
  set cargoWidthM(num? cargoWidthM) => _$this._cargoWidthM = cargoWidthM;

  num? _cargoHeightM;
  num? get cargoHeightM => _$this._cargoHeightM;
  set cargoHeightM(num? cargoHeightM) => _$this._cargoHeightM = cargoHeightM;

  num? _mixerCapacityM3;
  num? get mixerCapacityM3 => _$this._mixerCapacityM3;
  set mixerCapacityM3(num? mixerCapacityM3) =>
      _$this._mixerCapacityM3 = mixerCapacityM3;

  FleetVehicleHeavyClassificationEnum? _heavyClassification;
  FleetVehicleHeavyClassificationEnum? get heavyClassification =>
      _$this._heavyClassification;
  set heavyClassification(
          FleetVehicleHeavyClassificationEnum? heavyClassification) =>
      _$this._heavyClassification = heavyClassification;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  int? _rateVersion;
  int? get rateVersion => _$this._rateVersion;
  set rateVersion(int? rateVersion) => _$this._rateVersion = rateVersion;

  int? _baseFeeCentavos;
  int? get baseFeeCentavos => _$this._baseFeeCentavos;
  set baseFeeCentavos(int? baseFeeCentavos) =>
      _$this._baseFeeCentavos = baseFeeCentavos;

  int? _perKmCentavos;
  int? get perKmCentavos => _$this._perKmCentavos;
  set perKmCentavos(int? perKmCentavos) =>
      _$this._perKmCentavos = perKmCentavos;

  int? _maximumDistanceKm;
  int? get maximumDistanceKm => _$this._maximumDistanceKm;
  set maximumDistanceKm(int? maximumDistanceKm) =>
      _$this._maximumDistanceKm = maximumDistanceKm;

  FleetVehicleEligibilityBuilder? _eligibility;
  FleetVehicleEligibilityBuilder get eligibility =>
      _$this._eligibility ??= FleetVehicleEligibilityBuilder();
  set eligibility(FleetVehicleEligibilityBuilder? eligibility) =>
      _$this._eligibility = eligibility;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  FleetVehicleBuilder() {
    FleetVehicle._defaults(this);
  }

  FleetVehicleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _lockVersion = $v.lockVersion;
      _configurationVersion = $v.configurationVersion;
      _vehicleCategory = $v.vehicleCategory;
      _vehicleType = $v.vehicleType;
      _customTypeName = $v.customTypeName;
      _name = $v.name;
      _brand = $v.brand;
      _imageFileId = $v.imageFileId;
      _numberAvailable = $v.numberAvailable;
      _capacityKg = $v.capacityKg;
      _cargoLengthM = $v.cargoLengthM;
      _cargoWidthM = $v.cargoWidthM;
      _cargoHeightM = $v.cargoHeightM;
      _mixerCapacityM3 = $v.mixerCapacityM3;
      _heavyClassification = $v.heavyClassification;
      _active = $v.active;
      _available = $v.available;
      _rateVersion = $v.rateVersion;
      _baseFeeCentavos = $v.baseFeeCentavos;
      _perKmCentavos = $v.perKmCentavos;
      _maximumDistanceKm = $v.maximumDistanceKm;
      _eligibility = $v.eligibility.toBuilder();
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FleetVehicle other) {
    _$v = other as _$FleetVehicle;
  }

  @override
  void update(void Function(FleetVehicleBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FleetVehicle build() => _build();

  _$FleetVehicle _build() {
    _$FleetVehicle _$result;
    try {
      _$result = _$v ??
          _$FleetVehicle._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'FleetVehicle', 'id'),
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'FleetVehicle', 'lockVersion'),
            configurationVersion: BuiltValueNullFieldError.checkNotNull(
                configurationVersion, r'FleetVehicle', 'configurationVersion'),
            vehicleCategory: vehicleCategory,
            vehicleType: BuiltValueNullFieldError.checkNotNull(
                vehicleType, r'FleetVehicle', 'vehicleType'),
            customTypeName: customTypeName,
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'FleetVehicle', 'name'),
            brand: brand,
            imageFileId: imageFileId,
            numberAvailable: BuiltValueNullFieldError.checkNotNull(
                numberAvailable, r'FleetVehicle', 'numberAvailable'),
            capacityKg: BuiltValueNullFieldError.checkNotNull(
                capacityKg, r'FleetVehicle', 'capacityKg'),
            cargoLengthM: cargoLengthM,
            cargoWidthM: cargoWidthM,
            cargoHeightM: cargoHeightM,
            mixerCapacityM3: mixerCapacityM3,
            heavyClassification: heavyClassification,
            active: BuiltValueNullFieldError.checkNotNull(
                active, r'FleetVehicle', 'active'),
            available: BuiltValueNullFieldError.checkNotNull(
                available, r'FleetVehicle', 'available'),
            rateVersion: rateVersion,
            baseFeeCentavos: baseFeeCentavos,
            perKmCentavos: perKmCentavos,
            maximumDistanceKm: maximumDistanceKm,
            eligibility: eligibility.build(),
            updatedAt: updatedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'eligibility';
        eligibility.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'FleetVehicle', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
