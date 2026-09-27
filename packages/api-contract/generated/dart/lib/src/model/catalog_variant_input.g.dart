// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_variant_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CatalogVariantInput extends CatalogVariantInput {
  @override
  final String? id;
  @override
  final String sku;
  @override
  final String? label;
  @override
  final String unitId;
  @override
  final String packQuantity;
  @override
  final int priceCentavos;
  @override
  final TaxCategory taxCategory;
  @override
  final String? taxBasis;
  @override
  final String? weightKg;
  @override
  final String? lengthCm;
  @override
  final String? widthCm;
  @override
  final String? heightCm;
  @override
  final String? quantityOnHand;
  @override
  final bool? active;
  @override
  final BuiltMap<String, String>? attributes;
  @override
  final BuiltList<CatalogVolumeTierInput>? volumeTiers;

  factory _$CatalogVariantInput(
          [void Function(CatalogVariantInputBuilder)? updates]) =>
      (CatalogVariantInputBuilder()..update(updates))._build();

  _$CatalogVariantInput._(
      {this.id,
      required this.sku,
      this.label,
      required this.unitId,
      required this.packQuantity,
      required this.priceCentavos,
      required this.taxCategory,
      this.taxBasis,
      this.weightKg,
      this.lengthCm,
      this.widthCm,
      this.heightCm,
      this.quantityOnHand,
      this.active,
      this.attributes,
      this.volumeTiers})
      : super._();
  @override
  CatalogVariantInput rebuild(
          void Function(CatalogVariantInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogVariantInputBuilder toBuilder() =>
      CatalogVariantInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogVariantInput &&
        id == other.id &&
        sku == other.sku &&
        label == other.label &&
        unitId == other.unitId &&
        packQuantity == other.packQuantity &&
        priceCentavos == other.priceCentavos &&
        taxCategory == other.taxCategory &&
        taxBasis == other.taxBasis &&
        weightKg == other.weightKg &&
        lengthCm == other.lengthCm &&
        widthCm == other.widthCm &&
        heightCm == other.heightCm &&
        quantityOnHand == other.quantityOnHand &&
        active == other.active &&
        attributes == other.attributes &&
        volumeTiers == other.volumeTiers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, sku.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, unitId.hashCode);
    _$hash = $jc(_$hash, packQuantity.hashCode);
    _$hash = $jc(_$hash, priceCentavos.hashCode);
    _$hash = $jc(_$hash, taxCategory.hashCode);
    _$hash = $jc(_$hash, taxBasis.hashCode);
    _$hash = $jc(_$hash, weightKg.hashCode);
    _$hash = $jc(_$hash, lengthCm.hashCode);
    _$hash = $jc(_$hash, widthCm.hashCode);
    _$hash = $jc(_$hash, heightCm.hashCode);
    _$hash = $jc(_$hash, quantityOnHand.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jc(_$hash, attributes.hashCode);
    _$hash = $jc(_$hash, volumeTiers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogVariantInput')
          ..add('id', id)
          ..add('sku', sku)
          ..add('label', label)
          ..add('unitId', unitId)
          ..add('packQuantity', packQuantity)
          ..add('priceCentavos', priceCentavos)
          ..add('taxCategory', taxCategory)
          ..add('taxBasis', taxBasis)
          ..add('weightKg', weightKg)
          ..add('lengthCm', lengthCm)
          ..add('widthCm', widthCm)
          ..add('heightCm', heightCm)
          ..add('quantityOnHand', quantityOnHand)
          ..add('active', active)
          ..add('attributes', attributes)
          ..add('volumeTiers', volumeTiers))
        .toString();
  }
}

class CatalogVariantInputBuilder
    implements Builder<CatalogVariantInput, CatalogVariantInputBuilder> {
  _$CatalogVariantInput? _$v;

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

  String? _packQuantity;
  String? get packQuantity => _$this._packQuantity;
  set packQuantity(String? packQuantity) => _$this._packQuantity = packQuantity;

  int? _priceCentavos;
  int? get priceCentavos => _$this._priceCentavos;
  set priceCentavos(int? priceCentavos) =>
      _$this._priceCentavos = priceCentavos;

  TaxCategory? _taxCategory;
  TaxCategory? get taxCategory => _$this._taxCategory;
  set taxCategory(TaxCategory? taxCategory) =>
      _$this._taxCategory = taxCategory;

  String? _taxBasis;
  String? get taxBasis => _$this._taxBasis;
  set taxBasis(String? taxBasis) => _$this._taxBasis = taxBasis;

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

  String? _quantityOnHand;
  String? get quantityOnHand => _$this._quantityOnHand;
  set quantityOnHand(String? quantityOnHand) =>
      _$this._quantityOnHand = quantityOnHand;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  MapBuilder<String, String>? _attributes;
  MapBuilder<String, String> get attributes =>
      _$this._attributes ??= MapBuilder<String, String>();
  set attributes(MapBuilder<String, String>? attributes) =>
      _$this._attributes = attributes;

  ListBuilder<CatalogVolumeTierInput>? _volumeTiers;
  ListBuilder<CatalogVolumeTierInput> get volumeTiers =>
      _$this._volumeTiers ??= ListBuilder<CatalogVolumeTierInput>();
  set volumeTiers(ListBuilder<CatalogVolumeTierInput>? volumeTiers) =>
      _$this._volumeTiers = volumeTiers;

  CatalogVariantInputBuilder() {
    CatalogVariantInput._defaults(this);
  }

  CatalogVariantInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _sku = $v.sku;
      _label = $v.label;
      _unitId = $v.unitId;
      _packQuantity = $v.packQuantity;
      _priceCentavos = $v.priceCentavos;
      _taxCategory = $v.taxCategory;
      _taxBasis = $v.taxBasis;
      _weightKg = $v.weightKg;
      _lengthCm = $v.lengthCm;
      _widthCm = $v.widthCm;
      _heightCm = $v.heightCm;
      _quantityOnHand = $v.quantityOnHand;
      _active = $v.active;
      _attributes = $v.attributes?.toBuilder();
      _volumeTiers = $v.volumeTiers?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogVariantInput other) {
    _$v = other as _$CatalogVariantInput;
  }

  @override
  void update(void Function(CatalogVariantInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogVariantInput build() => _build();

  _$CatalogVariantInput _build() {
    _$CatalogVariantInput _$result;
    try {
      _$result = _$v ??
          _$CatalogVariantInput._(
            id: id,
            sku: BuiltValueNullFieldError.checkNotNull(
                sku, r'CatalogVariantInput', 'sku'),
            label: label,
            unitId: BuiltValueNullFieldError.checkNotNull(
                unitId, r'CatalogVariantInput', 'unitId'),
            packQuantity: BuiltValueNullFieldError.checkNotNull(
                packQuantity, r'CatalogVariantInput', 'packQuantity'),
            priceCentavos: BuiltValueNullFieldError.checkNotNull(
                priceCentavos, r'CatalogVariantInput', 'priceCentavos'),
            taxCategory: BuiltValueNullFieldError.checkNotNull(
                taxCategory, r'CatalogVariantInput', 'taxCategory'),
            taxBasis: taxBasis,
            weightKg: weightKg,
            lengthCm: lengthCm,
            widthCm: widthCm,
            heightCm: heightCm,
            quantityOnHand: quantityOnHand,
            active: active,
            attributes: _attributes?.build(),
            volumeTiers: _volumeTiers?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'attributes';
        _attributes?.build();
        _$failedField = 'volumeTiers';
        _volumeTiers?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CatalogVariantInput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
