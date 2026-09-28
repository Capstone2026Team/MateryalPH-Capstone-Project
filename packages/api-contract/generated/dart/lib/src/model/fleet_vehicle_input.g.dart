// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fleet_vehicle_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FleetVehicleInputVehicleCategoryEnum
    _$fleetVehicleInputVehicleCategoryEnum_MOTORCYCLE =
    const FleetVehicleInputVehicleCategoryEnum._('MOTORCYCLE');
const FleetVehicleInputVehicleCategoryEnum
    _$fleetVehicleInputVehicleCategoryEnum_PICKUP =
    const FleetVehicleInputVehicleCategoryEnum._('PICKUP');
const FleetVehicleInputVehicleCategoryEnum
    _$fleetVehicleInputVehicleCategoryEnum_VAN =
    const FleetVehicleInputVehicleCategoryEnum._('VAN');
const FleetVehicleInputVehicleCategoryEnum
    _$fleetVehicleInputVehicleCategoryEnum_TRUCK =
    const FleetVehicleInputVehicleCategoryEnum._('TRUCK');

FleetVehicleInputVehicleCategoryEnum
    _$fleetVehicleInputVehicleCategoryEnumValueOf(String name) {
  switch (name) {
    case 'MOTORCYCLE':
      return _$fleetVehicleInputVehicleCategoryEnum_MOTORCYCLE;
    case 'PICKUP':
      return _$fleetVehicleInputVehicleCategoryEnum_PICKUP;
    case 'VAN':
      return _$fleetVehicleInputVehicleCategoryEnum_VAN;
    case 'TRUCK':
      return _$fleetVehicleInputVehicleCategoryEnum_TRUCK;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FleetVehicleInputVehicleCategoryEnum>
    _$fleetVehicleInputVehicleCategoryEnumValues = BuiltSet<
        FleetVehicleInputVehicleCategoryEnum>(const <FleetVehicleInputVehicleCategoryEnum>[
  _$fleetVehicleInputVehicleCategoryEnum_MOTORCYCLE,
  _$fleetVehicleInputVehicleCategoryEnum_PICKUP,
  _$fleetVehicleInputVehicleCategoryEnum_VAN,
  _$fleetVehicleInputVehicleCategoryEnum_TRUCK,
]);

const FleetVehicleInputHeavyClassificationEnum
    _$fleetVehicleInputHeavyClassificationEnum_HEAVY =
    const FleetVehicleInputHeavyClassificationEnum._('HEAVY');
const FleetVehicleInputHeavyClassificationEnum
    _$fleetVehicleInputHeavyClassificationEnum_NOT_HEAVY =
    const FleetVehicleInputHeavyClassificationEnum._('NOT_HEAVY');

FleetVehicleInputHeavyClassificationEnum
    _$fleetVehicleInputHeavyClassificationEnumValueOf(String name) {
  switch (name) {
    case 'HEAVY':
      return _$fleetVehicleInputHeavyClassificationEnum_HEAVY;
    case 'NOT_HEAVY':
      return _$fleetVehicleInputHeavyClassificationEnum_NOT_HEAVY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FleetVehicleInputHeavyClassificationEnum>
    _$fleetVehicleInputHeavyClassificationEnumValues = BuiltSet<
        FleetVehicleInputHeavyClassificationEnum>(const <FleetVehicleInputHeavyClassificationEnum>[
  _$fleetVehicleInputHeavyClassificationEnum_HEAVY,
  _$fleetVehicleInputHeavyClassificationEnum_NOT_HEAVY,
]);

Serializer<FleetVehicleInputVehicleCategoryEnum>
    _$fleetVehicleInputVehicleCategoryEnumSerializer =
    _$FleetVehicleInputVehicleCategoryEnumSerializer();
Serializer<FleetVehicleInputHeavyClassificationEnum>
    _$fleetVehicleInputHeavyClassificationEnumSerializer =
    _$FleetVehicleInputHeavyClassificationEnumSerializer();

class _$FleetVehicleInputVehicleCategoryEnumSerializer
    implements PrimitiveSerializer<FleetVehicleInputVehicleCategoryEnum> {
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
  final Iterable<Type> types = const <Type>[
    FleetVehicleInputVehicleCategoryEnum
  ];
  @override
  final String wireName = 'FleetVehicleInputVehicleCategoryEnum';

  @override
  Object serialize(
          Serializers serializers, FleetVehicleInputVehicleCategoryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FleetVehicleInputVehicleCategoryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FleetVehicleInputVehicleCategoryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FleetVehicleInputHeavyClassificationEnumSerializer
    implements PrimitiveSerializer<FleetVehicleInputHeavyClassificationEnum> {
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
    FleetVehicleInputHeavyClassificationEnum
  ];
  @override
  final String wireName = 'FleetVehicleInputHeavyClassificationEnum';

  @override
  Object serialize(Serializers serializers,
          FleetVehicleInputHeavyClassificationEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FleetVehicleInputHeavyClassificationEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FleetVehicleInputHeavyClassificationEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FleetVehicleInput extends FleetVehicleInput {
  @override
  final String? id;
  @override
  final int? lockVersion;
  @override
  final bool? removed;
  @override
  final FleetVehicleInputVehicleCategoryEnum? vehicleCategory;
  @override
  final String? vehicleType;
  @override
  final String? customTypeName;
  @override
  final String? name;
  @override
  final String? brand;
  @override
  final String? imageFileId;
  @override
  final int? numberAvailable;
  @override
  final num? capacityKg;
  @override
  final num? cargoLengthM;
  @override
  final num? cargoWidthM;
  @override
  final num? cargoHeightM;
  @override
  final num? mixerCapacityM3;
  @override
  final FleetVehicleInputHeavyClassificationEnum? heavyClassification;
  @override
  final bool? active;
  @override
  final bool? available;
  @override
  final int? baseFeeCentavos;
  @override
  final int? perKmCentavos;
  @override
  final int? maximumDistanceKm;

  factory _$FleetVehicleInput(
          [void Function(FleetVehicleInputBuilder)? updates]) =>
      (FleetVehicleInputBuilder()..update(updates))._build();

  _$FleetVehicleInput._(
      {this.id,
      this.lockVersion,
      this.removed,
      this.vehicleCategory,
      this.vehicleType,
      this.customTypeName,
      this.name,
      this.brand,
      this.imageFileId,
      this.numberAvailable,
      this.capacityKg,
      this.cargoLengthM,
      this.cargoWidthM,
      this.cargoHeightM,
      this.mixerCapacityM3,
      this.heavyClassification,
      this.active,
      this.available,
      this.baseFeeCentavos,
      this.perKmCentavos,
      this.maximumDistanceKm})
      : super._();
  @override
  FleetVehicleInput rebuild(void Function(FleetVehicleInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FleetVehicleInputBuilder toBuilder() =>
      FleetVehicleInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FleetVehicleInput &&
        id == other.id &&
        lockVersion == other.lockVersion &&
        removed == other.removed &&
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
        baseFeeCentavos == other.baseFeeCentavos &&
        perKmCentavos == other.perKmCentavos &&
        maximumDistanceKm == other.maximumDistanceKm;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, removed.hashCode);
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
    _$hash = $jc(_$hash, baseFeeCentavos.hashCode);
    _$hash = $jc(_$hash, perKmCentavos.hashCode);
    _$hash = $jc(_$hash, maximumDistanceKm.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FleetVehicleInput')
          ..add('id', id)
          ..add('lockVersion', lockVersion)
          ..add('removed', removed)
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
          ..add('baseFeeCentavos', baseFeeCentavos)
          ..add('perKmCentavos', perKmCentavos)
          ..add('maximumDistanceKm', maximumDistanceKm))
        .toString();
  }
}

class FleetVehicleInputBuilder
    implements Builder<FleetVehicleInput, FleetVehicleInputBuilder> {
  _$FleetVehicleInput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  bool? _removed;
  bool? get removed => _$this._removed;
  set removed(bool? removed) => _$this._removed = removed;

  FleetVehicleInputVehicleCategoryEnum? _vehicleCategory;
  FleetVehicleInputVehicleCategoryEnum? get vehicleCategory =>
      _$this._vehicleCategory;
  set vehicleCategory(FleetVehicleInputVehicleCategoryEnum? vehicleCategory) =>
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

  FleetVehicleInputHeavyClassificationEnum? _heavyClassification;
  FleetVehicleInputHeavyClassificationEnum? get heavyClassification =>
      _$this._heavyClassification;
  set heavyClassification(
          FleetVehicleInputHeavyClassificationEnum? heavyClassification) =>
      _$this._heavyClassification = heavyClassification;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

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

  FleetVehicleInputBuilder() {
    FleetVehicleInput._defaults(this);
  }

  FleetVehicleInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _lockVersion = $v.lockVersion;
      _removed = $v.removed;
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
      _baseFeeCentavos = $v.baseFeeCentavos;
      _perKmCentavos = $v.perKmCentavos;
      _maximumDistanceKm = $v.maximumDistanceKm;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FleetVehicleInput other) {
    _$v = other as _$FleetVehicleInput;
  }

  @override
  void update(void Function(FleetVehicleInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FleetVehicleInput build() => _build();

  _$FleetVehicleInput _build() {
    final _$result = _$v ??
        _$FleetVehicleInput._(
          id: id,
          lockVersion: lockVersion,
          removed: removed,
          vehicleCategory: vehicleCategory,
          vehicleType: vehicleType,
          customTypeName: customTypeName,
          name: name,
          brand: brand,
          imageFileId: imageFileId,
          numberAvailable: numberAvailable,
          capacityKg: capacityKg,
          cargoLengthM: cargoLengthM,
          cargoWidthM: cargoWidthM,
          cargoHeightM: cargoHeightM,
          mixerCapacityM3: mixerCapacityM3,
          heavyClassification: heavyClassification,
          active: active,
          available: available,
          baseFeeCentavos: baseFeeCentavos,
          perKmCentavos: perKmCentavos,
          maximumDistanceKm: maximumDistanceKm,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
