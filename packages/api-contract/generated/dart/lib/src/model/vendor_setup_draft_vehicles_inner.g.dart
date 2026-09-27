// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_setup_draft_vehicles_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorSetupDraftVehiclesInnerVehicleCategoryEnum
    _$vendorSetupDraftVehiclesInnerVehicleCategoryEnum_MOTORCYCLE =
    const VendorSetupDraftVehiclesInnerVehicleCategoryEnum._('MOTORCYCLE');
const VendorSetupDraftVehiclesInnerVehicleCategoryEnum
    _$vendorSetupDraftVehiclesInnerVehicleCategoryEnum_PICKUP =
    const VendorSetupDraftVehiclesInnerVehicleCategoryEnum._('PICKUP');
const VendorSetupDraftVehiclesInnerVehicleCategoryEnum
    _$vendorSetupDraftVehiclesInnerVehicleCategoryEnum_VAN =
    const VendorSetupDraftVehiclesInnerVehicleCategoryEnum._('VAN');
const VendorSetupDraftVehiclesInnerVehicleCategoryEnum
    _$vendorSetupDraftVehiclesInnerVehicleCategoryEnum_TRUCK =
    const VendorSetupDraftVehiclesInnerVehicleCategoryEnum._('TRUCK');

VendorSetupDraftVehiclesInnerVehicleCategoryEnum
    _$vendorSetupDraftVehiclesInnerVehicleCategoryEnumValueOf(String name) {
  switch (name) {
    case 'MOTORCYCLE':
      return _$vendorSetupDraftVehiclesInnerVehicleCategoryEnum_MOTORCYCLE;
    case 'PICKUP':
      return _$vendorSetupDraftVehiclesInnerVehicleCategoryEnum_PICKUP;
    case 'VAN':
      return _$vendorSetupDraftVehiclesInnerVehicleCategoryEnum_VAN;
    case 'TRUCK':
      return _$vendorSetupDraftVehiclesInnerVehicleCategoryEnum_TRUCK;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorSetupDraftVehiclesInnerVehicleCategoryEnum>
    _$vendorSetupDraftVehiclesInnerVehicleCategoryEnumValues = BuiltSet<
        VendorSetupDraftVehiclesInnerVehicleCategoryEnum>(const <VendorSetupDraftVehiclesInnerVehicleCategoryEnum>[
  _$vendorSetupDraftVehiclesInnerVehicleCategoryEnum_MOTORCYCLE,
  _$vendorSetupDraftVehiclesInnerVehicleCategoryEnum_PICKUP,
  _$vendorSetupDraftVehiclesInnerVehicleCategoryEnum_VAN,
  _$vendorSetupDraftVehiclesInnerVehicleCategoryEnum_TRUCK,
]);

Serializer<VendorSetupDraftVehiclesInnerVehicleCategoryEnum>
    _$vendorSetupDraftVehiclesInnerVehicleCategoryEnumSerializer =
    _$VendorSetupDraftVehiclesInnerVehicleCategoryEnumSerializer();

class _$VendorSetupDraftVehiclesInnerVehicleCategoryEnumSerializer
    implements
        PrimitiveSerializer<VendorSetupDraftVehiclesInnerVehicleCategoryEnum> {
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
    VendorSetupDraftVehiclesInnerVehicleCategoryEnum
  ];
  @override
  final String wireName = 'VendorSetupDraftVehiclesInnerVehicleCategoryEnum';

  @override
  Object serialize(Serializers serializers,
          VendorSetupDraftVehiclesInnerVehicleCategoryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorSetupDraftVehiclesInnerVehicleCategoryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorSetupDraftVehiclesInnerVehicleCategoryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorSetupDraftVehiclesInner extends VendorSetupDraftVehiclesInner {
  @override
  final String? id;
  @override
  final VendorSetupDraftVehiclesInnerVehicleCategoryEnum? vehicleCategory;
  @override
  final String? vehicleType;
  @override
  final String? customTypeName;
  @override
  final String? brand;
  @override
  final num? mixerCapacityM3;
  @override
  final String? imageFileId;
  @override
  final bool? active;
  @override
  final String? name;
  @override
  final num? capacityKg;
  @override
  final int? numberAvailable;
  @override
  final num? cargoLengthM;
  @override
  final num? cargoWidthM;
  @override
  final num? cargoHeightM;
  @override
  final String? heavyClassification;
  @override
  final int? baseFeeCentavos;
  @override
  final int? perKmCentavos;
  @override
  final int? maximumDistanceKm;

  factory _$VendorSetupDraftVehiclesInner(
          [void Function(VendorSetupDraftVehiclesInnerBuilder)? updates]) =>
      (VendorSetupDraftVehiclesInnerBuilder()..update(updates))._build();

  _$VendorSetupDraftVehiclesInner._(
      {this.id,
      this.vehicleCategory,
      this.vehicleType,
      this.customTypeName,
      this.brand,
      this.mixerCapacityM3,
      this.imageFileId,
      this.active,
      this.name,
      this.capacityKg,
      this.numberAvailable,
      this.cargoLengthM,
      this.cargoWidthM,
      this.cargoHeightM,
      this.heavyClassification,
      this.baseFeeCentavos,
      this.perKmCentavos,
      this.maximumDistanceKm})
      : super._();
  @override
  VendorSetupDraftVehiclesInner rebuild(
          void Function(VendorSetupDraftVehiclesInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorSetupDraftVehiclesInnerBuilder toBuilder() =>
      VendorSetupDraftVehiclesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorSetupDraftVehiclesInner &&
        id == other.id &&
        vehicleCategory == other.vehicleCategory &&
        vehicleType == other.vehicleType &&
        customTypeName == other.customTypeName &&
        brand == other.brand &&
        mixerCapacityM3 == other.mixerCapacityM3 &&
        imageFileId == other.imageFileId &&
        active == other.active &&
        name == other.name &&
        capacityKg == other.capacityKg &&
        numberAvailable == other.numberAvailable &&
        cargoLengthM == other.cargoLengthM &&
        cargoWidthM == other.cargoWidthM &&
        cargoHeightM == other.cargoHeightM &&
        heavyClassification == other.heavyClassification &&
        baseFeeCentavos == other.baseFeeCentavos &&
        perKmCentavos == other.perKmCentavos &&
        maximumDistanceKm == other.maximumDistanceKm;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, vehicleCategory.hashCode);
    _$hash = $jc(_$hash, vehicleType.hashCode);
    _$hash = $jc(_$hash, customTypeName.hashCode);
    _$hash = $jc(_$hash, brand.hashCode);
    _$hash = $jc(_$hash, mixerCapacityM3.hashCode);
    _$hash = $jc(_$hash, imageFileId.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, capacityKg.hashCode);
    _$hash = $jc(_$hash, numberAvailable.hashCode);
    _$hash = $jc(_$hash, cargoLengthM.hashCode);
    _$hash = $jc(_$hash, cargoWidthM.hashCode);
    _$hash = $jc(_$hash, cargoHeightM.hashCode);
    _$hash = $jc(_$hash, heavyClassification.hashCode);
    _$hash = $jc(_$hash, baseFeeCentavos.hashCode);
    _$hash = $jc(_$hash, perKmCentavos.hashCode);
    _$hash = $jc(_$hash, maximumDistanceKm.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorSetupDraftVehiclesInner')
          ..add('id', id)
          ..add('vehicleCategory', vehicleCategory)
          ..add('vehicleType', vehicleType)
          ..add('customTypeName', customTypeName)
          ..add('brand', brand)
          ..add('mixerCapacityM3', mixerCapacityM3)
          ..add('imageFileId', imageFileId)
          ..add('active', active)
          ..add('name', name)
          ..add('capacityKg', capacityKg)
          ..add('numberAvailable', numberAvailable)
          ..add('cargoLengthM', cargoLengthM)
          ..add('cargoWidthM', cargoWidthM)
          ..add('cargoHeightM', cargoHeightM)
          ..add('heavyClassification', heavyClassification)
          ..add('baseFeeCentavos', baseFeeCentavos)
          ..add('perKmCentavos', perKmCentavos)
          ..add('maximumDistanceKm', maximumDistanceKm))
        .toString();
  }
}

class VendorSetupDraftVehiclesInnerBuilder
    implements
        Builder<VendorSetupDraftVehiclesInner,
            VendorSetupDraftVehiclesInnerBuilder> {
  _$VendorSetupDraftVehiclesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  VendorSetupDraftVehiclesInnerVehicleCategoryEnum? _vehicleCategory;
  VendorSetupDraftVehiclesInnerVehicleCategoryEnum? get vehicleCategory =>
      _$this._vehicleCategory;
  set vehicleCategory(
          VendorSetupDraftVehiclesInnerVehicleCategoryEnum? vehicleCategory) =>
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

  num? _mixerCapacityM3;
  num? get mixerCapacityM3 => _$this._mixerCapacityM3;
  set mixerCapacityM3(num? mixerCapacityM3) =>
      _$this._mixerCapacityM3 = mixerCapacityM3;

  String? _imageFileId;
  String? get imageFileId => _$this._imageFileId;
  set imageFileId(String? imageFileId) => _$this._imageFileId = imageFileId;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  num? _capacityKg;
  num? get capacityKg => _$this._capacityKg;
  set capacityKg(num? capacityKg) => _$this._capacityKg = capacityKg;

  int? _numberAvailable;
  int? get numberAvailable => _$this._numberAvailable;
  set numberAvailable(int? numberAvailable) =>
      _$this._numberAvailable = numberAvailable;

  num? _cargoLengthM;
  num? get cargoLengthM => _$this._cargoLengthM;
  set cargoLengthM(num? cargoLengthM) => _$this._cargoLengthM = cargoLengthM;

  num? _cargoWidthM;
  num? get cargoWidthM => _$this._cargoWidthM;
  set cargoWidthM(num? cargoWidthM) => _$this._cargoWidthM = cargoWidthM;

  num? _cargoHeightM;
  num? get cargoHeightM => _$this._cargoHeightM;
  set cargoHeightM(num? cargoHeightM) => _$this._cargoHeightM = cargoHeightM;

  String? _heavyClassification;
  String? get heavyClassification => _$this._heavyClassification;
  set heavyClassification(String? heavyClassification) =>
      _$this._heavyClassification = heavyClassification;

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

  VendorSetupDraftVehiclesInnerBuilder() {
    VendorSetupDraftVehiclesInner._defaults(this);
  }

  VendorSetupDraftVehiclesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _vehicleCategory = $v.vehicleCategory;
      _vehicleType = $v.vehicleType;
      _customTypeName = $v.customTypeName;
      _brand = $v.brand;
      _mixerCapacityM3 = $v.mixerCapacityM3;
      _imageFileId = $v.imageFileId;
      _active = $v.active;
      _name = $v.name;
      _capacityKg = $v.capacityKg;
      _numberAvailable = $v.numberAvailable;
      _cargoLengthM = $v.cargoLengthM;
      _cargoWidthM = $v.cargoWidthM;
      _cargoHeightM = $v.cargoHeightM;
      _heavyClassification = $v.heavyClassification;
      _baseFeeCentavos = $v.baseFeeCentavos;
      _perKmCentavos = $v.perKmCentavos;
      _maximumDistanceKm = $v.maximumDistanceKm;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorSetupDraftVehiclesInner other) {
    _$v = other as _$VendorSetupDraftVehiclesInner;
  }

  @override
  void update(void Function(VendorSetupDraftVehiclesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorSetupDraftVehiclesInner build() => _build();

  _$VendorSetupDraftVehiclesInner _build() {
    final _$result = _$v ??
        _$VendorSetupDraftVehiclesInner._(
          id: id,
          vehicleCategory: vehicleCategory,
          vehicleType: vehicleType,
          customTypeName: customTypeName,
          brand: brand,
          mixerCapacityM3: mixerCapacityM3,
          imageFileId: imageFileId,
          active: active,
          name: name,
          capacityKg: capacityKg,
          numberAvailable: numberAvailable,
          cargoLengthM: cargoLengthM,
          cargoWidthM: cargoWidthM,
          cargoHeightM: cargoHeightM,
          heavyClassification: heavyClassification,
          baseFeeCentavos: baseFeeCentavos,
          perKmCentavos: perKmCentavos,
          maximumDistanceKm: maximumDistanceKm,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
