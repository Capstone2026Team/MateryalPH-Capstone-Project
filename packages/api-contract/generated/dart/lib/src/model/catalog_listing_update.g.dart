// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_listing_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CatalogListingUpdateMaterialMatchEnum
    _$catalogListingUpdateMaterialMatchEnum_EXACT =
    const CatalogListingUpdateMaterialMatchEnum._('EXACT');
const CatalogListingUpdateMaterialMatchEnum
    _$catalogListingUpdateMaterialMatchEnum_ALIAS =
    const CatalogListingUpdateMaterialMatchEnum._('ALIAS');
const CatalogListingUpdateMaterialMatchEnum
    _$catalogListingUpdateMaterialMatchEnum_FUZZY_CONFIRMED =
    const CatalogListingUpdateMaterialMatchEnum._('FUZZY_CONFIRMED');

CatalogListingUpdateMaterialMatchEnum
    _$catalogListingUpdateMaterialMatchEnumValueOf(String name) {
  switch (name) {
    case 'EXACT':
      return _$catalogListingUpdateMaterialMatchEnum_EXACT;
    case 'ALIAS':
      return _$catalogListingUpdateMaterialMatchEnum_ALIAS;
    case 'FUZZY_CONFIRMED':
      return _$catalogListingUpdateMaterialMatchEnum_FUZZY_CONFIRMED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CatalogListingUpdateMaterialMatchEnum>
    _$catalogListingUpdateMaterialMatchEnumValues = BuiltSet<
        CatalogListingUpdateMaterialMatchEnum>(const <CatalogListingUpdateMaterialMatchEnum>[
  _$catalogListingUpdateMaterialMatchEnum_EXACT,
  _$catalogListingUpdateMaterialMatchEnum_ALIAS,
  _$catalogListingUpdateMaterialMatchEnum_FUZZY_CONFIRMED,
]);

Serializer<CatalogListingUpdateMaterialMatchEnum>
    _$catalogListingUpdateMaterialMatchEnumSerializer =
    _$CatalogListingUpdateMaterialMatchEnumSerializer();

class _$CatalogListingUpdateMaterialMatchEnumSerializer
    implements PrimitiveSerializer<CatalogListingUpdateMaterialMatchEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'EXACT': 'EXACT',
    'ALIAS': 'ALIAS',
    'FUZZY_CONFIRMED': 'FUZZY_CONFIRMED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'EXACT': 'EXACT',
    'ALIAS': 'ALIAS',
    'FUZZY_CONFIRMED': 'FUZZY_CONFIRMED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CatalogListingUpdateMaterialMatchEnum
  ];
  @override
  final String wireName = 'CatalogListingUpdateMaterialMatchEnum';

  @override
  Object serialize(
          Serializers serializers, CatalogListingUpdateMaterialMatchEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CatalogListingUpdateMaterialMatchEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CatalogListingUpdateMaterialMatchEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CatalogListingUpdate extends CatalogListingUpdate {
  @override
  final int lockVersion;
  @override
  final String? displayName;
  @override
  final String? vendorSku;
  @override
  final String? description;
  @override
  final String? materialId;
  @override
  final CatalogListingUpdateMaterialMatchEnum? materialMatch;
  @override
  final String? otherLabel;
  @override
  final String? materialCategoryId;
  @override
  final BuiltList<String>? tagIds;
  @override
  final String? brand;
  @override
  final String? model;
  @override
  final String? manufacturer;
  @override
  final String? manufacturerAddress;
  @override
  final String? countryOfManufacture;
  @override
  final BuiltMap<String, String>? technicalAttributes;

  factory _$CatalogListingUpdate(
          [void Function(CatalogListingUpdateBuilder)? updates]) =>
      (CatalogListingUpdateBuilder()..update(updates))._build();

  _$CatalogListingUpdate._(
      {required this.lockVersion,
      this.displayName,
      this.vendorSku,
      this.description,
      this.materialId,
      this.materialMatch,
      this.otherLabel,
      this.materialCategoryId,
      this.tagIds,
      this.brand,
      this.model,
      this.manufacturer,
      this.manufacturerAddress,
      this.countryOfManufacture,
      this.technicalAttributes})
      : super._();
  @override
  CatalogListingUpdate rebuild(
          void Function(CatalogListingUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogListingUpdateBuilder toBuilder() =>
      CatalogListingUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogListingUpdate &&
        lockVersion == other.lockVersion &&
        displayName == other.displayName &&
        vendorSku == other.vendorSku &&
        description == other.description &&
        materialId == other.materialId &&
        materialMatch == other.materialMatch &&
        otherLabel == other.otherLabel &&
        materialCategoryId == other.materialCategoryId &&
        tagIds == other.tagIds &&
        brand == other.brand &&
        model == other.model &&
        manufacturer == other.manufacturer &&
        manufacturerAddress == other.manufacturerAddress &&
        countryOfManufacture == other.countryOfManufacture &&
        technicalAttributes == other.technicalAttributes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, vendorSku.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, materialId.hashCode);
    _$hash = $jc(_$hash, materialMatch.hashCode);
    _$hash = $jc(_$hash, otherLabel.hashCode);
    _$hash = $jc(_$hash, materialCategoryId.hashCode);
    _$hash = $jc(_$hash, tagIds.hashCode);
    _$hash = $jc(_$hash, brand.hashCode);
    _$hash = $jc(_$hash, model.hashCode);
    _$hash = $jc(_$hash, manufacturer.hashCode);
    _$hash = $jc(_$hash, manufacturerAddress.hashCode);
    _$hash = $jc(_$hash, countryOfManufacture.hashCode);
    _$hash = $jc(_$hash, technicalAttributes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogListingUpdate')
          ..add('lockVersion', lockVersion)
          ..add('displayName', displayName)
          ..add('vendorSku', vendorSku)
          ..add('description', description)
          ..add('materialId', materialId)
          ..add('materialMatch', materialMatch)
          ..add('otherLabel', otherLabel)
          ..add('materialCategoryId', materialCategoryId)
          ..add('tagIds', tagIds)
          ..add('brand', brand)
          ..add('model', model)
          ..add('manufacturer', manufacturer)
          ..add('manufacturerAddress', manufacturerAddress)
          ..add('countryOfManufacture', countryOfManufacture)
          ..add('technicalAttributes', technicalAttributes))
        .toString();
  }
}

class CatalogListingUpdateBuilder
    implements Builder<CatalogListingUpdate, CatalogListingUpdateBuilder> {
  _$CatalogListingUpdate? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _vendorSku;
  String? get vendorSku => _$this._vendorSku;
  set vendorSku(String? vendorSku) => _$this._vendorSku = vendorSku;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _materialId;
  String? get materialId => _$this._materialId;
  set materialId(String? materialId) => _$this._materialId = materialId;

  CatalogListingUpdateMaterialMatchEnum? _materialMatch;
  CatalogListingUpdateMaterialMatchEnum? get materialMatch =>
      _$this._materialMatch;
  set materialMatch(CatalogListingUpdateMaterialMatchEnum? materialMatch) =>
      _$this._materialMatch = materialMatch;

  String? _otherLabel;
  String? get otherLabel => _$this._otherLabel;
  set otherLabel(String? otherLabel) => _$this._otherLabel = otherLabel;

  String? _materialCategoryId;
  String? get materialCategoryId => _$this._materialCategoryId;
  set materialCategoryId(String? materialCategoryId) =>
      _$this._materialCategoryId = materialCategoryId;

  ListBuilder<String>? _tagIds;
  ListBuilder<String> get tagIds => _$this._tagIds ??= ListBuilder<String>();
  set tagIds(ListBuilder<String>? tagIds) => _$this._tagIds = tagIds;

  String? _brand;
  String? get brand => _$this._brand;
  set brand(String? brand) => _$this._brand = brand;

  String? _model;
  String? get model => _$this._model;
  set model(String? model) => _$this._model = model;

  String? _manufacturer;
  String? get manufacturer => _$this._manufacturer;
  set manufacturer(String? manufacturer) => _$this._manufacturer = manufacturer;

  String? _manufacturerAddress;
  String? get manufacturerAddress => _$this._manufacturerAddress;
  set manufacturerAddress(String? manufacturerAddress) =>
      _$this._manufacturerAddress = manufacturerAddress;

  String? _countryOfManufacture;
  String? get countryOfManufacture => _$this._countryOfManufacture;
  set countryOfManufacture(String? countryOfManufacture) =>
      _$this._countryOfManufacture = countryOfManufacture;

  MapBuilder<String, String>? _technicalAttributes;
  MapBuilder<String, String> get technicalAttributes =>
      _$this._technicalAttributes ??= MapBuilder<String, String>();
  set technicalAttributes(MapBuilder<String, String>? technicalAttributes) =>
      _$this._technicalAttributes = technicalAttributes;

  CatalogListingUpdateBuilder() {
    CatalogListingUpdate._defaults(this);
  }

  CatalogListingUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _displayName = $v.displayName;
      _vendorSku = $v.vendorSku;
      _description = $v.description;
      _materialId = $v.materialId;
      _materialMatch = $v.materialMatch;
      _otherLabel = $v.otherLabel;
      _materialCategoryId = $v.materialCategoryId;
      _tagIds = $v.tagIds?.toBuilder();
      _brand = $v.brand;
      _model = $v.model;
      _manufacturer = $v.manufacturer;
      _manufacturerAddress = $v.manufacturerAddress;
      _countryOfManufacture = $v.countryOfManufacture;
      _technicalAttributes = $v.technicalAttributes?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogListingUpdate other) {
    _$v = other as _$CatalogListingUpdate;
  }

  @override
  void update(void Function(CatalogListingUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogListingUpdate build() => _build();

  _$CatalogListingUpdate _build() {
    _$CatalogListingUpdate _$result;
    try {
      _$result = _$v ??
          _$CatalogListingUpdate._(
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'CatalogListingUpdate', 'lockVersion'),
            displayName: displayName,
            vendorSku: vendorSku,
            description: description,
            materialId: materialId,
            materialMatch: materialMatch,
            otherLabel: otherLabel,
            materialCategoryId: materialCategoryId,
            tagIds: _tagIds?.build(),
            brand: brand,
            model: model,
            manufacturer: manufacturer,
            manufacturerAddress: manufacturerAddress,
            countryOfManufacture: countryOfManufacture,
            technicalAttributes: _technicalAttributes?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tagIds';
        _tagIds?.build();

        _$failedField = 'technicalAttributes';
        _technicalAttributes?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CatalogListingUpdate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
