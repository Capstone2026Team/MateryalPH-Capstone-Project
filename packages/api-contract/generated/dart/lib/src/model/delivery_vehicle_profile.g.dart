// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_vehicle_profile.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeliveryVehicleProfile extends DeliveryVehicleProfile {
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
  final String? imageFileId;
  @override
  final String? capacityKg;
  @override
  final String? mixerCapacityM3;
  @override
  final String? cargoLengthM;
  @override
  final String? cargoWidthM;
  @override
  final String? cargoHeightM;
  @override
  final String? heavyClassification;

  factory _$DeliveryVehicleProfile(
          [void Function(DeliveryVehicleProfileBuilder)? updates]) =>
      (DeliveryVehicleProfileBuilder()..update(updates))._build();

  _$DeliveryVehicleProfile._(
      {this.name,
      this.vehicleCategory,
      this.vehicleType,
      this.customTypeName,
      this.brand,
      this.imageFileId,
      this.capacityKg,
      this.mixerCapacityM3,
      this.cargoLengthM,
      this.cargoWidthM,
      this.cargoHeightM,
      this.heavyClassification})
      : super._();
  @override
  DeliveryVehicleProfile rebuild(
          void Function(DeliveryVehicleProfileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeliveryVehicleProfileBuilder toBuilder() =>
      DeliveryVehicleProfileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeliveryVehicleProfile &&
        name == other.name &&
        vehicleCategory == other.vehicleCategory &&
        vehicleType == other.vehicleType &&
        customTypeName == other.customTypeName &&
        brand == other.brand &&
        imageFileId == other.imageFileId &&
        capacityKg == other.capacityKg &&
        mixerCapacityM3 == other.mixerCapacityM3 &&
        cargoLengthM == other.cargoLengthM &&
        cargoWidthM == other.cargoWidthM &&
        cargoHeightM == other.cargoHeightM &&
        heavyClassification == other.heavyClassification;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, vehicleCategory.hashCode);
    _$hash = $jc(_$hash, vehicleType.hashCode);
    _$hash = $jc(_$hash, customTypeName.hashCode);
    _$hash = $jc(_$hash, brand.hashCode);
    _$hash = $jc(_$hash, imageFileId.hashCode);
    _$hash = $jc(_$hash, capacityKg.hashCode);
    _$hash = $jc(_$hash, mixerCapacityM3.hashCode);
    _$hash = $jc(_$hash, cargoLengthM.hashCode);
    _$hash = $jc(_$hash, cargoWidthM.hashCode);
    _$hash = $jc(_$hash, cargoHeightM.hashCode);
    _$hash = $jc(_$hash, heavyClassification.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeliveryVehicleProfile')
          ..add('name', name)
          ..add('vehicleCategory', vehicleCategory)
          ..add('vehicleType', vehicleType)
          ..add('customTypeName', customTypeName)
          ..add('brand', brand)
          ..add('imageFileId', imageFileId)
          ..add('capacityKg', capacityKg)
          ..add('mixerCapacityM3', mixerCapacityM3)
          ..add('cargoLengthM', cargoLengthM)
          ..add('cargoWidthM', cargoWidthM)
          ..add('cargoHeightM', cargoHeightM)
          ..add('heavyClassification', heavyClassification))
        .toString();
  }
}

class DeliveryVehicleProfileBuilder
    implements Builder<DeliveryVehicleProfile, DeliveryVehicleProfileBuilder> {
  _$DeliveryVehicleProfile? _$v;

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

  String? _imageFileId;
  String? get imageFileId => _$this._imageFileId;
  set imageFileId(String? imageFileId) => _$this._imageFileId = imageFileId;

  String? _capacityKg;
  String? get capacityKg => _$this._capacityKg;
  set capacityKg(String? capacityKg) => _$this._capacityKg = capacityKg;

  String? _mixerCapacityM3;
  String? get mixerCapacityM3 => _$this._mixerCapacityM3;
  set mixerCapacityM3(String? mixerCapacityM3) =>
      _$this._mixerCapacityM3 = mixerCapacityM3;

  String? _cargoLengthM;
  String? get cargoLengthM => _$this._cargoLengthM;
  set cargoLengthM(String? cargoLengthM) => _$this._cargoLengthM = cargoLengthM;

  String? _cargoWidthM;
  String? get cargoWidthM => _$this._cargoWidthM;
  set cargoWidthM(String? cargoWidthM) => _$this._cargoWidthM = cargoWidthM;

  String? _cargoHeightM;
  String? get cargoHeightM => _$this._cargoHeightM;
  set cargoHeightM(String? cargoHeightM) => _$this._cargoHeightM = cargoHeightM;

  String? _heavyClassification;
  String? get heavyClassification => _$this._heavyClassification;
  set heavyClassification(String? heavyClassification) =>
      _$this._heavyClassification = heavyClassification;

  DeliveryVehicleProfileBuilder() {
    DeliveryVehicleProfile._defaults(this);
  }

  DeliveryVehicleProfileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _vehicleCategory = $v.vehicleCategory;
      _vehicleType = $v.vehicleType;
      _customTypeName = $v.customTypeName;
      _brand = $v.brand;
      _imageFileId = $v.imageFileId;
      _capacityKg = $v.capacityKg;
      _mixerCapacityM3 = $v.mixerCapacityM3;
      _cargoLengthM = $v.cargoLengthM;
      _cargoWidthM = $v.cargoWidthM;
      _cargoHeightM = $v.cargoHeightM;
      _heavyClassification = $v.heavyClassification;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeliveryVehicleProfile other) {
    _$v = other as _$DeliveryVehicleProfile;
  }

  @override
  void update(void Function(DeliveryVehicleProfileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeliveryVehicleProfile build() => _build();

  _$DeliveryVehicleProfile _build() {
    final _$result = _$v ??
        _$DeliveryVehicleProfile._(
          name: name,
          vehicleCategory: vehicleCategory,
          vehicleType: vehicleType,
          customTypeName: customTypeName,
          brand: brand,
          imageFileId: imageFileId,
          capacityKg: capacityKg,
          mixerCapacityM3: mixerCapacityM3,
          cargoLengthM: cargoLengthM,
          cargoWidthM: cargoWidthM,
          cargoHeightM: cargoHeightM,
          heavyClassification: heavyClassification,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
