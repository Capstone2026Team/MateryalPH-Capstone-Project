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

  factory _$InvoiceOrderLine(
          [void Function(InvoiceOrderLineBuilder)? updates]) =>
      (InvoiceOrderLineBuilder()..update(updates))._build();

  _$InvoiceOrderLine._({required this.orderLineId, required this.displayName})
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
        displayName == other.displayName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderLineId.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InvoiceOrderLine')
          ..add('orderLineId', orderLineId)
          ..add('displayName', displayName))
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

  InvoiceOrderLineBuilder() {
    InvoiceOrderLine._defaults(this);
  }

  InvoiceOrderLineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderLineId = $v.orderLineId;
      _displayName = $v.displayName;
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
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
