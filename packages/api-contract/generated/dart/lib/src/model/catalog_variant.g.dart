// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_variant.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CatalogVariantPublicAvailabilityEnum
    _$catalogVariantPublicAvailabilityEnum_IN_STOCK =
    const CatalogVariantPublicAvailabilityEnum._('IN_STOCK');
const CatalogVariantPublicAvailabilityEnum
    _$catalogVariantPublicAvailabilityEnum_OUT_OF_STOCK =
    const CatalogVariantPublicAvailabilityEnum._('OUT_OF_STOCK');

CatalogVariantPublicAvailabilityEnum
    _$catalogVariantPublicAvailabilityEnumValueOf(String name) {
  switch (name) {
    case 'IN_STOCK':
      return _$catalogVariantPublicAvailabilityEnum_IN_STOCK;
    case 'OUT_OF_STOCK':
      return _$catalogVariantPublicAvailabilityEnum_OUT_OF_STOCK;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CatalogVariantPublicAvailabilityEnum>
    _$catalogVariantPublicAvailabilityEnumValues = BuiltSet<
        CatalogVariantPublicAvailabilityEnum>(const <CatalogVariantPublicAvailabilityEnum>[
  _$catalogVariantPublicAvailabilityEnum_IN_STOCK,
  _$catalogVariantPublicAvailabilityEnum_OUT_OF_STOCK,
]);

const CatalogVariantComparabilityEnum
    _$catalogVariantComparabilityEnum_COMPARABLE =
    const CatalogVariantComparabilityEnum._('COMPARABLE');
const CatalogVariantComparabilityEnum
    _$catalogVariantComparabilityEnum_NOT_YET_COMPARABLE =
    const CatalogVariantComparabilityEnum._('NOT_YET_COMPARABLE');

CatalogVariantComparabilityEnum _$catalogVariantComparabilityEnumValueOf(
    String name) {
  switch (name) {
    case 'COMPARABLE':
      return _$catalogVariantComparabilityEnum_COMPARABLE;
    case 'NOT_YET_COMPARABLE':
      return _$catalogVariantComparabilityEnum_NOT_YET_COMPARABLE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CatalogVariantComparabilityEnum>
    _$catalogVariantComparabilityEnumValues = BuiltSet<
        CatalogVariantComparabilityEnum>(const <CatalogVariantComparabilityEnum>[
  _$catalogVariantComparabilityEnum_COMPARABLE,
  _$catalogVariantComparabilityEnum_NOT_YET_COMPARABLE,
]);

Serializer<CatalogVariantPublicAvailabilityEnum>
    _$catalogVariantPublicAvailabilityEnumSerializer =
    _$CatalogVariantPublicAvailabilityEnumSerializer();
Serializer<CatalogVariantComparabilityEnum>
    _$catalogVariantComparabilityEnumSerializer =
    _$CatalogVariantComparabilityEnumSerializer();

class _$CatalogVariantPublicAvailabilityEnumSerializer
    implements PrimitiveSerializer<CatalogVariantPublicAvailabilityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'IN_STOCK': 'IN_STOCK',
    'OUT_OF_STOCK': 'OUT_OF_STOCK',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'IN_STOCK': 'IN_STOCK',
    'OUT_OF_STOCK': 'OUT_OF_STOCK',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CatalogVariantPublicAvailabilityEnum
  ];
  @override
  final String wireName = 'CatalogVariantPublicAvailabilityEnum';

  @override
  Object serialize(
          Serializers serializers, CatalogVariantPublicAvailabilityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CatalogVariantPublicAvailabilityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CatalogVariantPublicAvailabilityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CatalogVariantComparabilityEnumSerializer
    implements PrimitiveSerializer<CatalogVariantComparabilityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'COMPARABLE': 'COMPARABLE',
    'NOT_YET_COMPARABLE': 'NOT_YET_COMPARABLE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'COMPARABLE': 'COMPARABLE',
    'NOT_YET_COMPARABLE': 'NOT_YET_COMPARABLE',
  };

  @override
  final Iterable<Type> types = const <Type>[CatalogVariantComparabilityEnum];
  @override
  final String wireName = 'CatalogVariantComparabilityEnum';

  @override
  Object serialize(
          Serializers serializers, CatalogVariantComparabilityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CatalogVariantComparabilityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CatalogVariantComparabilityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CatalogVariant extends CatalogVariant {
  @override
  final String id;
  @override
  final String sku;
  @override
  final String? label;
  @override
  final String unitId;
  @override
  final String unitCode;
  @override
  final String packQuantity;
  @override
  final BuiltMap<String, String> attributes;
  @override
  final bool active;
  @override
  final String? weightKg;
  @override
  final String? lengthCm;
  @override
  final String? widthCm;
  @override
  final String? heightCm;
  @override
  final int lockVersion;
  @override
  final CatalogPrice? price;
  @override
  final BuiltList<CatalogVolumeTier> volumeTiers;
  @override
  final CatalogInventory? inventory;
  @override
  final CatalogVariantPublicAvailabilityEnum publicAvailability;
  @override
  final CatalogVariantComparabilityEnum comparability;

  factory _$CatalogVariant([void Function(CatalogVariantBuilder)? updates]) =>
      (CatalogVariantBuilder()..update(updates))._build();

  _$CatalogVariant._(
      {required this.id,
      required this.sku,
      this.label,
      required this.unitId,
      required this.unitCode,
      required this.packQuantity,
      required this.attributes,
      required this.active,
      this.weightKg,
      this.lengthCm,
      this.widthCm,
      this.heightCm,
      required this.lockVersion,
      this.price,
      required this.volumeTiers,
      this.inventory,
      required this.publicAvailability,
      required this.comparability})
      : super._();
  @override
  CatalogVariant rebuild(void Function(CatalogVariantBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogVariantBuilder toBuilder() => CatalogVariantBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogVariant &&
        id == other.id &&
        sku == other.sku &&
        label == other.label &&
        unitId == other.unitId &&
        unitCode == other.unitCode &&
        packQuantity == other.packQuantity &&
        attributes == other.attributes &&
        active == other.active &&
        weightKg == other.weightKg &&
        lengthCm == other.lengthCm &&
        widthCm == other.widthCm &&
        heightCm == other.heightCm &&
        lockVersion == other.lockVersion &&
        price == other.price &&
        volumeTiers == other.volumeTiers &&
        inventory == other.inventory &&
        publicAvailability == other.publicAvailability &&
        comparability == other.comparability;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, sku.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, unitId.hashCode);
    _$hash = $jc(_$hash, unitCode.hashCode);
    _$hash = $jc(_$hash, packQuantity.hashCode);
    _$hash = $jc(_$hash, attributes.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jc(_$hash, weightKg.hashCode);
    _$hash = $jc(_$hash, lengthCm.hashCode);
    _$hash = $jc(_$hash, widthCm.hashCode);
    _$hash = $jc(_$hash, heightCm.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jc(_$hash, volumeTiers.hashCode);
    _$hash = $jc(_$hash, inventory.hashCode);
    _$hash = $jc(_$hash, publicAvailability.hashCode);
    _$hash = $jc(_$hash, comparability.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogVariant')
          ..add('id', id)
          ..add('sku', sku)
          ..add('label', label)
          ..add('unitId', unitId)
          ..add('unitCode', unitCode)
          ..add('packQuantity', packQuantity)
          ..add('attributes', attributes)
          ..add('active', active)
          ..add('weightKg', weightKg)
          ..add('lengthCm', lengthCm)
          ..add('widthCm', widthCm)
          ..add('heightCm', heightCm)
          ..add('lockVersion', lockVersion)
          ..add('price', price)
          ..add('volumeTiers', volumeTiers)
          ..add('inventory', inventory)
          ..add('publicAvailability', publicAvailability)
          ..add('comparability', comparability))
        .toString();
  }
}

class CatalogVariantBuilder
    implements Builder<CatalogVariant, CatalogVariantBuilder> {
  _$CatalogVariant? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _sku;
  String? get sku => _$this._sku;
  set sku(String? sku) => _$this._sku = sku;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _unitId;
  String? get unitId => _$this._unitId;
  set unitId(String? unitId) => _$this._unitId = unitId;

  String? _unitCode;
  String? get unitCode => _$this._unitCode;
  set unitCode(String? unitCode) => _$this._unitCode = unitCode;

  String? _packQuantity;
  String? get packQuantity => _$this._packQuantity;
  set packQuantity(String? packQuantity) => _$this._packQuantity = packQuantity;

  MapBuilder<String, String>? _attributes;
  MapBuilder<String, String> get attributes =>
      _$this._attributes ??= MapBuilder<String, String>();
  set attributes(MapBuilder<String, String>? attributes) =>
      _$this._attributes = attributes;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  String? _weightKg;
  String? get weightKg => _$this._weightKg;
  set weightKg(String? weightKg) => _$this._weightKg = weightKg;

  String? _lengthCm;
  String? get lengthCm => _$this._lengthCm;
  set lengthCm(String? lengthCm) => _$this._lengthCm = lengthCm;

  String? _widthCm;
  String? get widthCm => _$this._widthCm;
  set widthCm(String? widthCm) => _$this._widthCm = widthCm;

  String? _heightCm;
  String? get heightCm => _$this._heightCm;
  set heightCm(String? heightCm) => _$this._heightCm = heightCm;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  CatalogPriceBuilder? _price;
  CatalogPriceBuilder get price => _$this._price ??= CatalogPriceBuilder();
  set price(CatalogPriceBuilder? price) => _$this._price = price;

  ListBuilder<CatalogVolumeTier>? _volumeTiers;
  ListBuilder<CatalogVolumeTier> get volumeTiers =>
      _$this._volumeTiers ??= ListBuilder<CatalogVolumeTier>();
  set volumeTiers(ListBuilder<CatalogVolumeTier>? volumeTiers) =>
      _$this._volumeTiers = volumeTiers;

  CatalogInventoryBuilder? _inventory;
  CatalogInventoryBuilder get inventory =>
      _$this._inventory ??= CatalogInventoryBuilder();
  set inventory(CatalogInventoryBuilder? inventory) =>
      _$this._inventory = inventory;

  CatalogVariantPublicAvailabilityEnum? _publicAvailability;
  CatalogVariantPublicAvailabilityEnum? get publicAvailability =>
      _$this._publicAvailability;
  set publicAvailability(
          CatalogVariantPublicAvailabilityEnum? publicAvailability) =>
      _$this._publicAvailability = publicAvailability;

  CatalogVariantComparabilityEnum? _comparability;
  CatalogVariantComparabilityEnum? get comparability => _$this._comparability;
  set comparability(CatalogVariantComparabilityEnum? comparability) =>
      _$this._comparability = comparability;

  CatalogVariantBuilder() {
    CatalogVariant._defaults(this);
  }

  CatalogVariantBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _sku = $v.sku;
      _label = $v.label;
      _unitId = $v.unitId;
      _unitCode = $v.unitCode;
      _packQuantity = $v.packQuantity;
      _attributes = $v.attributes.toBuilder();
      _active = $v.active;
      _weightKg = $v.weightKg;
      _lengthCm = $v.lengthCm;
      _widthCm = $v.widthCm;
      _heightCm = $v.heightCm;
      _lockVersion = $v.lockVersion;
      _price = $v.price?.toBuilder();
      _volumeTiers = $v.volumeTiers.toBuilder();
      _inventory = $v.inventory?.toBuilder();
      _publicAvailability = $v.publicAvailability;
      _comparability = $v.comparability;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogVariant other) {
    _$v = other as _$CatalogVariant;
  }

  @override
  void update(void Function(CatalogVariantBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogVariant build() => _build();

  _$CatalogVariant _build() {
    _$CatalogVariant _$result;
    try {
      _$result = _$v ??
          _$CatalogVariant._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'CatalogVariant', 'id'),
            sku: BuiltValueNullFieldError.checkNotNull(
                sku, r'CatalogVariant', 'sku'),
            label: label,
            unitId: BuiltValueNullFieldError.checkNotNull(
                unitId, r'CatalogVariant', 'unitId'),
            unitCode: BuiltValueNullFieldError.checkNotNull(
                unitCode, r'CatalogVariant', 'unitCode'),
            packQuantity: BuiltValueNullFieldError.checkNotNull(
                packQuantity, r'CatalogVariant', 'packQuantity'),
            attributes: attributes.build(),
            active: BuiltValueNullFieldError.checkNotNull(
                active, r'CatalogVariant', 'active'),
            weightKg: weightKg,
            lengthCm: lengthCm,
            widthCm: widthCm,
            heightCm: heightCm,
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'CatalogVariant', 'lockVersion'),
            price: _price?.build(),
            volumeTiers: volumeTiers.build(),
            inventory: _inventory?.build(),
            publicAvailability: BuiltValueNullFieldError.checkNotNull(
                publicAvailability, r'CatalogVariant', 'publicAvailability'),
            comparability: BuiltValueNullFieldError.checkNotNull(
                comparability, r'CatalogVariant', 'comparability'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'attributes';
        attributes.build();

        _$failedField = 'price';
        _price?.build();
        _$failedField = 'volumeTiers';
        volumeTiers.build();
        _$failedField = 'inventory';
        _inventory?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CatalogVariant', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
