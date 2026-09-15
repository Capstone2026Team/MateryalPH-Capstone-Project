// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_vehicle.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const VendorVehicleVehicleTypeEnum _$vendorVehicleVehicleTypeEnum_MOTORCYCLE =
    const VendorVehicleVehicleTypeEnum._('MOTORCYCLE');
const VendorVehicleVehicleTypeEnum _$vendorVehicleVehicleTypeEnum_PICKUP =
    const VendorVehicleVehicleTypeEnum._('PICKUP');
const VendorVehicleVehicleTypeEnum _$vendorVehicleVehicleTypeEnum_VAN =
    const VendorVehicleVehicleTypeEnum._('VAN');
const VendorVehicleVehicleTypeEnum _$vendorVehicleVehicleTypeEnum_TRUCK =
    const VendorVehicleVehicleTypeEnum._('TRUCK');
const VendorVehicleVehicleTypeEnum _$vendorVehicleVehicleTypeEnum_CUSTOM =
    const VendorVehicleVehicleTypeEnum._('CUSTOM');

VendorVehicleVehicleTypeEnum _$vendorVehicleVehicleTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'MOTORCYCLE':
      return _$vendorVehicleVehicleTypeEnum_MOTORCYCLE;
    case 'PICKUP':
      return _$vendorVehicleVehicleTypeEnum_PICKUP;
    case 'VAN':
      return _$vendorVehicleVehicleTypeEnum_VAN;
    case 'TRUCK':
      return _$vendorVehicleVehicleTypeEnum_TRUCK;
    case 'CUSTOM':
      return _$vendorVehicleVehicleTypeEnum_CUSTOM;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorVehicleVehicleTypeEnum>
    _$vendorVehicleVehicleTypeEnumValues =
    BuiltSet<VendorVehicleVehicleTypeEnum>(const <VendorVehicleVehicleTypeEnum>[
  _$vendorVehicleVehicleTypeEnum_MOTORCYCLE,
  _$vendorVehicleVehicleTypeEnum_PICKUP,
  _$vendorVehicleVehicleTypeEnum_VAN,
  _$vendorVehicleVehicleTypeEnum_TRUCK,
  _$vendorVehicleVehicleTypeEnum_CUSTOM,
]);

const VendorVehicleVehicleSubtypeEnum
    _$vendorVehicleVehicleSubtypeEnum_OPEN_TRUCK =
    const VendorVehicleVehicleSubtypeEnum._('OPEN_TRUCK');
const VendorVehicleVehicleSubtypeEnum
    _$vendorVehicleVehicleSubtypeEnum_FLATBED_TRUCK =
    const VendorVehicleVehicleSubtypeEnum._('FLATBED_TRUCK');
const VendorVehicleVehicleSubtypeEnum
    _$vendorVehicleVehicleSubtypeEnum_WING_VAN =
    const VendorVehicleVehicleSubtypeEnum._('WING_VAN');

VendorVehicleVehicleSubtypeEnum _$vendorVehicleVehicleSubtypeEnumValueOf(
    String name) {
  switch (name) {
    case 'OPEN_TRUCK':
      return _$vendorVehicleVehicleSubtypeEnum_OPEN_TRUCK;
    case 'FLATBED_TRUCK':
      return _$vendorVehicleVehicleSubtypeEnum_FLATBED_TRUCK;
    case 'WING_VAN':
      return _$vendorVehicleVehicleSubtypeEnum_WING_VAN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VendorVehicleVehicleSubtypeEnum>
    _$vendorVehicleVehicleSubtypeEnumValues = BuiltSet<
        VendorVehicleVehicleSubtypeEnum>(const <VendorVehicleVehicleSubtypeEnum>[
  _$vendorVehicleVehicleSubtypeEnum_OPEN_TRUCK,
  _$vendorVehicleVehicleSubtypeEnum_FLATBED_TRUCK,
  _$vendorVehicleVehicleSubtypeEnum_WING_VAN,
]);

Serializer<VendorVehicleVehicleTypeEnum>
    _$vendorVehicleVehicleTypeEnumSerializer =
    _$VendorVehicleVehicleTypeEnumSerializer();
Serializer<VendorVehicleVehicleSubtypeEnum>
    _$vendorVehicleVehicleSubtypeEnumSerializer =
    _$VendorVehicleVehicleSubtypeEnumSerializer();

class _$VendorVehicleVehicleTypeEnumSerializer
    implements PrimitiveSerializer<VendorVehicleVehicleTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'MOTORCYCLE': 'MOTORCYCLE',
    'PICKUP': 'PICKUP',
    'VAN': 'VAN',
    'TRUCK': 'TRUCK',
    'CUSTOM': 'CUSTOM',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'MOTORCYCLE': 'MOTORCYCLE',
    'PICKUP': 'PICKUP',
    'VAN': 'VAN',
    'TRUCK': 'TRUCK',
    'CUSTOM': 'CUSTOM',
  };

  @override
  final Iterable<Type> types = const <Type>[VendorVehicleVehicleTypeEnum];
  @override
  final String wireName = 'VendorVehicleVehicleTypeEnum';

  @override
  Object serialize(Serializers serializers, VendorVehicleVehicleTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorVehicleVehicleTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorVehicleVehicleTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorVehicleVehicleSubtypeEnumSerializer
    implements PrimitiveSerializer<VendorVehicleVehicleSubtypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OPEN_TRUCK': 'OPEN_TRUCK',
    'FLATBED_TRUCK': 'FLATBED_TRUCK',
    'WING_VAN': 'WING_VAN',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OPEN_TRUCK': 'OPEN_TRUCK',
    'FLATBED_TRUCK': 'FLATBED_TRUCK',
    'WING_VAN': 'WING_VAN',
  };

  @override
  final Iterable<Type> types = const <Type>[VendorVehicleVehicleSubtypeEnum];
  @override
  final String wireName = 'VendorVehicleVehicleSubtypeEnum';

  @override
  Object serialize(
          Serializers serializers, VendorVehicleVehicleSubtypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  VendorVehicleVehicleSubtypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VendorVehicleVehicleSubtypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$VendorVehicle extends VendorVehicle {
  @override
  final String? id;
  @override
  final VendorVehicleVehicleTypeEnum vehicleType;
  @override
  final VendorVehicleVehicleSubtypeEnum? vehicleSubtype;
  @override
  final String? customVehicleType;
  @override
  final String name;
  @override
  final int numberAvailable;
  @override
  final num capacityKg;
  @override
  final num cargoLengthM;
  @override
  final num cargoWidthM;
  @override
  final num cargoHeightM;
  @override
  final String heavyVehicleClassification;
  @override
  final int baseFeeCentavos;
  @override
  final int perKmCentavos;
  @override
  final int maximumDistanceKm;

  factory _$VendorVehicle([void Function(VendorVehicleBuilder)? updates]) =>
      (VendorVehicleBuilder()..update(updates))._build();

  _$VendorVehicle._(
      {this.id,
      required this.vehicleType,
      this.vehicleSubtype,
      this.customVehicleType,
      required this.name,
      required this.numberAvailable,
      required this.capacityKg,
      required this.cargoLengthM,
      required this.cargoWidthM,
      required this.cargoHeightM,
      required this.heavyVehicleClassification,
      required this.baseFeeCentavos,
      required this.perKmCentavos,
      required this.maximumDistanceKm})
      : super._();
  @override
  VendorVehicle rebuild(void Function(VendorVehicleBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorVehicleBuilder toBuilder() => VendorVehicleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorVehicle &&
        id == other.id &&
        vehicleType == other.vehicleType &&
        vehicleSubtype == other.vehicleSubtype &&
        customVehicleType == other.customVehicleType &&
        name == other.name &&
        numberAvailable == other.numberAvailable &&
        capacityKg == other.capacityKg &&
        cargoLengthM == other.cargoLengthM &&
        cargoWidthM == other.cargoWidthM &&
        cargoHeightM == other.cargoHeightM &&
        heavyVehicleClassification == other.heavyVehicleClassification &&
        baseFeeCentavos == other.baseFeeCentavos &&
        perKmCentavos == other.perKmCentavos &&
        maximumDistanceKm == other.maximumDistanceKm;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, vehicleType.hashCode);
    _$hash = $jc(_$hash, vehicleSubtype.hashCode);
    _$hash = $jc(_$hash, customVehicleType.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, numberAvailable.hashCode);
    _$hash = $jc(_$hash, capacityKg.hashCode);
    _$hash = $jc(_$hash, cargoLengthM.hashCode);
    _$hash = $jc(_$hash, cargoWidthM.hashCode);
    _$hash = $jc(_$hash, cargoHeightM.hashCode);
    _$hash = $jc(_$hash, heavyVehicleClassification.hashCode);
    _$hash = $jc(_$hash, baseFeeCentavos.hashCode);
    _$hash = $jc(_$hash, perKmCentavos.hashCode);
    _$hash = $jc(_$hash, maximumDistanceKm.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorVehicle')
          ..add('id', id)
          ..add('vehicleType', vehicleType)
          ..add('vehicleSubtype', vehicleSubtype)
          ..add('customVehicleType', customVehicleType)
          ..add('name', name)
          ..add('numberAvailable', numberAvailable)
          ..add('capacityKg', capacityKg)
          ..add('cargoLengthM', cargoLengthM)
          ..add('cargoWidthM', cargoWidthM)
          ..add('cargoHeightM', cargoHeightM)
          ..add('heavyVehicleClassification', heavyVehicleClassification)
          ..add('baseFeeCentavos', baseFeeCentavos)
          ..add('perKmCentavos', perKmCentavos)
          ..add('maximumDistanceKm', maximumDistanceKm))
        .toString();
  }
}

class VendorVehicleBuilder
    implements Builder<VendorVehicle, VendorVehicleBuilder> {
  _$VendorVehicle? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  VendorVehicleVehicleTypeEnum? _vehicleType;
  VendorVehicleVehicleTypeEnum? get vehicleType => _$this._vehicleType;
  set vehicleType(VendorVehicleVehicleTypeEnum? vehicleType) =>
      _$this._vehicleType = vehicleType;

  VendorVehicleVehicleSubtypeEnum? _vehicleSubtype;
  VendorVehicleVehicleSubtypeEnum? get vehicleSubtype => _$this._vehicleSubtype;
  set vehicleSubtype(VendorVehicleVehicleSubtypeEnum? vehicleSubtype) =>
      _$this._vehicleSubtype = vehicleSubtype;

  String? _customVehicleType;
  String? get customVehicleType => _$this._customVehicleType;
  set customVehicleType(String? customVehicleType) =>
      _$this._customVehicleType = customVehicleType;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

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

  String? _heavyVehicleClassification;
  String? get heavyVehicleClassification => _$this._heavyVehicleClassification;
  set heavyVehicleClassification(String? heavyVehicleClassification) =>
      _$this._heavyVehicleClassification = heavyVehicleClassification;

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

  VendorVehicleBuilder() {
    VendorVehicle._defaults(this);
  }

  VendorVehicleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _vehicleType = $v.vehicleType;
      _vehicleSubtype = $v.vehicleSubtype;
      _customVehicleType = $v.customVehicleType;
      _name = $v.name;
      _numberAvailable = $v.numberAvailable;
      _capacityKg = $v.capacityKg;
      _cargoLengthM = $v.cargoLengthM;
      _cargoWidthM = $v.cargoWidthM;
      _cargoHeightM = $v.cargoHeightM;
      _heavyVehicleClassification = $v.heavyVehicleClassification;
      _baseFeeCentavos = $v.baseFeeCentavos;
      _perKmCentavos = $v.perKmCentavos;
      _maximumDistanceKm = $v.maximumDistanceKm;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorVehicle other) {
    _$v = other as _$VendorVehicle;
  }

  @override
  void update(void Function(VendorVehicleBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorVehicle build() => _build();

  _$VendorVehicle _build() {
    final _$result = _$v ??
        _$VendorVehicle._(
          id: id,
          vehicleType: BuiltValueNullFieldError.checkNotNull(
              vehicleType, r'VendorVehicle', 'vehicleType'),
          vehicleSubtype: vehicleSubtype,
          customVehicleType: customVehicleType,
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'VendorVehicle', 'name'),
          numberAvailable: BuiltValueNullFieldError.checkNotNull(
              numberAvailable, r'VendorVehicle', 'numberAvailable'),
          capacityKg: BuiltValueNullFieldError.checkNotNull(
              capacityKg, r'VendorVehicle', 'capacityKg'),
          cargoLengthM: BuiltValueNullFieldError.checkNotNull(
              cargoLengthM, r'VendorVehicle', 'cargoLengthM'),
          cargoWidthM: BuiltValueNullFieldError.checkNotNull(
              cargoWidthM, r'VendorVehicle', 'cargoWidthM'),
          cargoHeightM: BuiltValueNullFieldError.checkNotNull(
              cargoHeightM, r'VendorVehicle', 'cargoHeightM'),
          heavyVehicleClassification: BuiltValueNullFieldError.checkNotNull(
              heavyVehicleClassification,
              r'VendorVehicle',
              'heavyVehicleClassification'),
          baseFeeCentavos: BuiltValueNullFieldError.checkNotNull(
              baseFeeCentavos, r'VendorVehicle', 'baseFeeCentavos'),
          perKmCentavos: BuiltValueNullFieldError.checkNotNull(
              perKmCentavos, r'VendorVehicle', 'perKmCentavos'),
          maximumDistanceKm: BuiltValueNullFieldError.checkNotNull(
              maximumDistanceKm, r'VendorVehicle', 'maximumDistanceKm'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
