// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_quotation_line.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatQuotationLine extends ChatQuotationLine {
  @override
  final QuantityPolicy? quantityPolicy;
  @override
  final String variantId;
  @override
  final String quantity;
  @override
  final int unitPriceCentavos;
  @override
  final String description;
  @override
  final String? brand;
  @override
  final String? variantLabel;
  @override
  final BuiltMap<String, String>? specifications;
  @override
  final String unitCode;
  @override
  final String taxCategory;
  @override
  final String sourcePriceVersionId;
  @override
  final String sourceTaxVersionId;

  factory _$ChatQuotationLine(
          [void Function(ChatQuotationLineBuilder)? updates]) =>
      (ChatQuotationLineBuilder()..update(updates))._build();

  _$ChatQuotationLine._(
      {this.quantityPolicy,
      required this.variantId,
      required this.quantity,
      required this.unitPriceCentavos,
      required this.description,
      this.brand,
      this.variantLabel,
      this.specifications,
      required this.unitCode,
      required this.taxCategory,
      required this.sourcePriceVersionId,
      required this.sourceTaxVersionId})
      : super._();
  @override
  ChatQuotationLine rebuild(void Function(ChatQuotationLineBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatQuotationLineBuilder toBuilder() =>
      ChatQuotationLineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatQuotationLine &&
        quantityPolicy == other.quantityPolicy &&
        variantId == other.variantId &&
        quantity == other.quantity &&
        unitPriceCentavos == other.unitPriceCentavos &&
        description == other.description &&
        brand == other.brand &&
        variantLabel == other.variantLabel &&
        specifications == other.specifications &&
        unitCode == other.unitCode &&
        taxCategory == other.taxCategory &&
        sourcePriceVersionId == other.sourcePriceVersionId &&
        sourceTaxVersionId == other.sourceTaxVersionId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, quantityPolicy.hashCode);
    _$hash = $jc(_$hash, variantId.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, unitPriceCentavos.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, brand.hashCode);
    _$hash = $jc(_$hash, variantLabel.hashCode);
    _$hash = $jc(_$hash, specifications.hashCode);
    _$hash = $jc(_$hash, unitCode.hashCode);
    _$hash = $jc(_$hash, taxCategory.hashCode);
    _$hash = $jc(_$hash, sourcePriceVersionId.hashCode);
    _$hash = $jc(_$hash, sourceTaxVersionId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatQuotationLine')
          ..add('quantityPolicy', quantityPolicy)
          ..add('variantId', variantId)
          ..add('quantity', quantity)
          ..add('unitPriceCentavos', unitPriceCentavos)
          ..add('description', description)
          ..add('brand', brand)
          ..add('variantLabel', variantLabel)
          ..add('specifications', specifications)
          ..add('unitCode', unitCode)
          ..add('taxCategory', taxCategory)
          ..add('sourcePriceVersionId', sourcePriceVersionId)
          ..add('sourceTaxVersionId', sourceTaxVersionId))
        .toString();
  }
}

class ChatQuotationLineBuilder
    implements Builder<ChatQuotationLine, ChatQuotationLineBuilder> {
  _$ChatQuotationLine? _$v;

  QuantityPolicyBuilder? _quantityPolicy;
  QuantityPolicyBuilder get quantityPolicy =>
      _$this._quantityPolicy ??= QuantityPolicyBuilder();
  set quantityPolicy(QuantityPolicyBuilder? quantityPolicy) =>
      _$this._quantityPolicy = quantityPolicy;

  String? _variantId;
  String? get variantId => _$this._variantId;
  set variantId(String? variantId) => _$this._variantId = variantId;

  String? _quantity;
  String? get quantity => _$this._quantity;
  set quantity(String? quantity) => _$this._quantity = quantity;

  int? _unitPriceCentavos;
  int? get unitPriceCentavos => _$this._unitPriceCentavos;
  set unitPriceCentavos(int? unitPriceCentavos) =>
      _$this._unitPriceCentavos = unitPriceCentavos;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _brand;
  String? get brand => _$this._brand;
  set brand(String? brand) => _$this._brand = brand;

  String? _variantLabel;
  String? get variantLabel => _$this._variantLabel;
  set variantLabel(String? variantLabel) => _$this._variantLabel = variantLabel;

  MapBuilder<String, String>? _specifications;
  MapBuilder<String, String> get specifications =>
      _$this._specifications ??= MapBuilder<String, String>();
  set specifications(MapBuilder<String, String>? specifications) =>
      _$this._specifications = specifications;

  String? _unitCode;
  String? get unitCode => _$this._unitCode;
  set unitCode(String? unitCode) => _$this._unitCode = unitCode;

  String? _taxCategory;
  String? get taxCategory => _$this._taxCategory;
  set taxCategory(String? taxCategory) => _$this._taxCategory = taxCategory;

  String? _sourcePriceVersionId;
  String? get sourcePriceVersionId => _$this._sourcePriceVersionId;
  set sourcePriceVersionId(String? sourcePriceVersionId) =>
      _$this._sourcePriceVersionId = sourcePriceVersionId;

  String? _sourceTaxVersionId;
  String? get sourceTaxVersionId => _$this._sourceTaxVersionId;
  set sourceTaxVersionId(String? sourceTaxVersionId) =>
      _$this._sourceTaxVersionId = sourceTaxVersionId;

  ChatQuotationLineBuilder() {
    ChatQuotationLine._defaults(this);
  }

  ChatQuotationLineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _quantityPolicy = $v.quantityPolicy?.toBuilder();
      _variantId = $v.variantId;
      _quantity = $v.quantity;
      _unitPriceCentavos = $v.unitPriceCentavos;
      _description = $v.description;
      _brand = $v.brand;
      _variantLabel = $v.variantLabel;
      _specifications = $v.specifications?.toBuilder();
      _unitCode = $v.unitCode;
      _taxCategory = $v.taxCategory;
      _sourcePriceVersionId = $v.sourcePriceVersionId;
      _sourceTaxVersionId = $v.sourceTaxVersionId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatQuotationLine other) {
    _$v = other as _$ChatQuotationLine;
  }

  @override
  void update(void Function(ChatQuotationLineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatQuotationLine build() => _build();

  _$ChatQuotationLine _build() {
    _$ChatQuotationLine _$result;
    try {
      _$result = _$v ??
          _$ChatQuotationLine._(
            quantityPolicy: _quantityPolicy?.build(),
            variantId: BuiltValueNullFieldError.checkNotNull(
                variantId, r'ChatQuotationLine', 'variantId'),
            quantity: BuiltValueNullFieldError.checkNotNull(
                quantity, r'ChatQuotationLine', 'quantity'),
            unitPriceCentavos: BuiltValueNullFieldError.checkNotNull(
                unitPriceCentavos, r'ChatQuotationLine', 'unitPriceCentavos'),
            description: BuiltValueNullFieldError.checkNotNull(
                description, r'ChatQuotationLine', 'description'),
            brand: brand,
            variantLabel: variantLabel,
            specifications: _specifications?.build(),
            unitCode: BuiltValueNullFieldError.checkNotNull(
                unitCode, r'ChatQuotationLine', 'unitCode'),
            taxCategory: BuiltValueNullFieldError.checkNotNull(
                taxCategory, r'ChatQuotationLine', 'taxCategory'),
            sourcePriceVersionId: BuiltValueNullFieldError.checkNotNull(
                sourcePriceVersionId,
                r'ChatQuotationLine',
                'sourcePriceVersionId'),
            sourceTaxVersionId: BuiltValueNullFieldError.checkNotNull(
                sourceTaxVersionId, r'ChatQuotationLine', 'sourceTaxVersionId'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'quantityPolicy';
        _quantityPolicy?.build();

        _$failedField = 'specifications';
        _specifications?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ChatQuotationLine', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
