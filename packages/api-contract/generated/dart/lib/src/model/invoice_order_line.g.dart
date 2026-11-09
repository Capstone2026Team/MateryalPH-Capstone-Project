// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_order_line.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InvoiceOrderLine extends InvoiceOrderLine {
  @override
  final String orderLineId;
  @override
  final String displayName;
  @override
  final String? category;
  @override
  final String? quantity;
  @override
  final String? unitName;
  @override
  final int? unitPriceCentavos;
  @override
  final int? lineTotalCentavos;

  factory _$InvoiceOrderLine(
          [void Function(InvoiceOrderLineBuilder)? updates]) =>
      (InvoiceOrderLineBuilder()..update(updates))._build();

  _$InvoiceOrderLine._(
      {required this.orderLineId,
      required this.displayName,
      this.category,
      this.quantity,
      this.unitName,
      this.unitPriceCentavos,
      this.lineTotalCentavos})
      : super._();
  @override
  InvoiceOrderLine rebuild(void Function(InvoiceOrderLineBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InvoiceOrderLineBuilder toBuilder() =>
      InvoiceOrderLineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InvoiceOrderLine &&
        orderLineId == other.orderLineId &&
        displayName == other.displayName &&
        category == other.category &&
        quantity == other.quantity &&
        unitName == other.unitName &&
        unitPriceCentavos == other.unitPriceCentavos &&
        lineTotalCentavos == other.lineTotalCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderLineId.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, unitName.hashCode);
    _$hash = $jc(_$hash, unitPriceCentavos.hashCode);
    _$hash = $jc(_$hash, lineTotalCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InvoiceOrderLine')
          ..add('orderLineId', orderLineId)
          ..add('displayName', displayName)
          ..add('category', category)
          ..add('quantity', quantity)
          ..add('unitName', unitName)
          ..add('unitPriceCentavos', unitPriceCentavos)
          ..add('lineTotalCentavos', lineTotalCentavos))
        .toString();
  }
}

class InvoiceOrderLineBuilder
    implements Builder<InvoiceOrderLine, InvoiceOrderLineBuilder> {
  _$InvoiceOrderLine? _$v;

  String? _orderLineId;
  String? get orderLineId => _$this._orderLineId;
  set orderLineId(String? orderLineId) => _$this._orderLineId = orderLineId;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  String? _quantity;
  String? get quantity => _$this._quantity;
  set quantity(String? quantity) => _$this._quantity = quantity;

  String? _unitName;
  String? get unitName => _$this._unitName;
  set unitName(String? unitName) => _$this._unitName = unitName;

  int? _unitPriceCentavos;
  int? get unitPriceCentavos => _$this._unitPriceCentavos;
  set unitPriceCentavos(int? unitPriceCentavos) =>
      _$this._unitPriceCentavos = unitPriceCentavos;

  int? _lineTotalCentavos;
  int? get lineTotalCentavos => _$this._lineTotalCentavos;
  set lineTotalCentavos(int? lineTotalCentavos) =>
      _$this._lineTotalCentavos = lineTotalCentavos;

  InvoiceOrderLineBuilder() {
    InvoiceOrderLine._defaults(this);
  }

  InvoiceOrderLineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderLineId = $v.orderLineId;
      _displayName = $v.displayName;
      _category = $v.category;
      _quantity = $v.quantity;
      _unitName = $v.unitName;
      _unitPriceCentavos = $v.unitPriceCentavos;
      _lineTotalCentavos = $v.lineTotalCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InvoiceOrderLine other) {
    _$v = other as _$InvoiceOrderLine;
  }

  @override
  void update(void Function(InvoiceOrderLineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InvoiceOrderLine build() => _build();

  _$InvoiceOrderLine _build() {
    final _$result = _$v ??
        _$InvoiceOrderLine._(
          orderLineId: BuiltValueNullFieldError.checkNotNull(
              orderLineId, r'InvoiceOrderLine', 'orderLineId'),
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'InvoiceOrderLine', 'displayName'),
          category: category,
          quantity: quantity,
          unitName: unitName,
          unitPriceCentavos: unitPriceCentavos,
          lineTotalCentavos: lineTotalCentavos,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
