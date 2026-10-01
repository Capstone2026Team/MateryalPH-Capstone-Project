// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_quotation_line.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatQuotationLine extends ChatQuotationLine {
  @override
  final String variantId;
  @override
  final String quantity;
  @override
  final int unitPriceCentavos;
  @override
  final String description;
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
      {required this.variantId,
      required this.quantity,
      required this.unitPriceCentavos,
      required this.description,
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
        variantId == other.variantId &&
        quantity == other.quantity &&
        unitPriceCentavos == other.unitPriceCentavos &&
        description == other.description &&
        unitCode == other.unitCode &&
        taxCategory == other.taxCategory &&
        sourcePriceVersionId == other.sourcePriceVersionId &&
        sourceTaxVersionId == other.sourceTaxVersionId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, variantId.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, unitPriceCentavos.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
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
          ..add('variantId', variantId)
          ..add('quantity', quantity)
          ..add('unitPriceCentavos', unitPriceCentavos)
          ..add('description', description)
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
      _variantId = $v.variantId;
      _quantity = $v.quantity;
      _unitPriceCentavos = $v.unitPriceCentavos;
      _description = $v.description;
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
    final _$result = _$v ??
        _$ChatQuotationLine._(
          variantId: BuiltValueNullFieldError.checkNotNull(
              variantId, r'ChatQuotationLine', 'variantId'),
          quantity: BuiltValueNullFieldError.checkNotNull(
              quantity, r'ChatQuotationLine', 'quantity'),
          unitPriceCentavos: BuiltValueNullFieldError.checkNotNull(
              unitPriceCentavos, r'ChatQuotationLine', 'unitPriceCentavos'),
          description: BuiltValueNullFieldError.checkNotNull(
              description, r'ChatQuotationLine', 'description'),
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
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
