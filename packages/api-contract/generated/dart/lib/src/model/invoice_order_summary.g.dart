// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_order_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InvoiceOrderSummary extends InvoiceOrderSummary {
  @override
  final BuiltList<InvoiceOrderLine> lines;
  @override
  final InvoiceBillingSnapshot? billingDetails;
  @override
  final int? materialsSubtotalCentavos;
  @override
  final int? discountCentavos;
  @override
  final int? deliveryCentavos;
  @override
  final int? includedVatCentavos;
  @override
  final int? totalCentavos;

  factory _$InvoiceOrderSummary(
          [void Function(InvoiceOrderSummaryBuilder)? updates]) =>
      (InvoiceOrderSummaryBuilder()..update(updates))._build();

  _$InvoiceOrderSummary._(
      {required this.lines,
      this.billingDetails,
      this.materialsSubtotalCentavos,
      this.discountCentavos,
      this.deliveryCentavos,
      this.includedVatCentavos,
      this.totalCentavos})
      : super._();
  @override
  InvoiceOrderSummary rebuild(
          void Function(InvoiceOrderSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InvoiceOrderSummaryBuilder toBuilder() =>
      InvoiceOrderSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InvoiceOrderSummary &&
        lines == other.lines &&
        billingDetails == other.billingDetails &&
        materialsSubtotalCentavos == other.materialsSubtotalCentavos &&
        discountCentavos == other.discountCentavos &&
        deliveryCentavos == other.deliveryCentavos &&
        includedVatCentavos == other.includedVatCentavos &&
        totalCentavos == other.totalCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, billingDetails.hashCode);
    _$hash = $jc(_$hash, materialsSubtotalCentavos.hashCode);
    _$hash = $jc(_$hash, discountCentavos.hashCode);
    _$hash = $jc(_$hash, deliveryCentavos.hashCode);
    _$hash = $jc(_$hash, includedVatCentavos.hashCode);
    _$hash = $jc(_$hash, totalCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InvoiceOrderSummary')
          ..add('lines', lines)
          ..add('billingDetails', billingDetails)
          ..add('materialsSubtotalCentavos', materialsSubtotalCentavos)
          ..add('discountCentavos', discountCentavos)
          ..add('deliveryCentavos', deliveryCentavos)
          ..add('includedVatCentavos', includedVatCentavos)
          ..add('totalCentavos', totalCentavos))
        .toString();
  }
}

class InvoiceOrderSummaryBuilder
    implements Builder<InvoiceOrderSummary, InvoiceOrderSummaryBuilder> {
  _$InvoiceOrderSummary? _$v;

  ListBuilder<InvoiceOrderLine>? _lines;
  ListBuilder<InvoiceOrderLine> get lines =>
      _$this._lines ??= ListBuilder<InvoiceOrderLine>();
  set lines(ListBuilder<InvoiceOrderLine>? lines) => _$this._lines = lines;

  InvoiceBillingSnapshotBuilder? _billingDetails;
  InvoiceBillingSnapshotBuilder get billingDetails =>
      _$this._billingDetails ??= InvoiceBillingSnapshotBuilder();
  set billingDetails(InvoiceBillingSnapshotBuilder? billingDetails) =>
      _$this._billingDetails = billingDetails;

  int? _materialsSubtotalCentavos;
  int? get materialsSubtotalCentavos => _$this._materialsSubtotalCentavos;
  set materialsSubtotalCentavos(int? materialsSubtotalCentavos) =>
      _$this._materialsSubtotalCentavos = materialsSubtotalCentavos;

  int? _discountCentavos;
  int? get discountCentavos => _$this._discountCentavos;
  set discountCentavos(int? discountCentavos) =>
      _$this._discountCentavos = discountCentavos;

  int? _deliveryCentavos;
  int? get deliveryCentavos => _$this._deliveryCentavos;
  set deliveryCentavos(int? deliveryCentavos) =>
      _$this._deliveryCentavos = deliveryCentavos;

  int? _includedVatCentavos;
  int? get includedVatCentavos => _$this._includedVatCentavos;
  set includedVatCentavos(int? includedVatCentavos) =>
      _$this._includedVatCentavos = includedVatCentavos;

  int? _totalCentavos;
  int? get totalCentavos => _$this._totalCentavos;
  set totalCentavos(int? totalCentavos) =>
      _$this._totalCentavos = totalCentavos;

  InvoiceOrderSummaryBuilder() {
    InvoiceOrderSummary._defaults(this);
  }

  InvoiceOrderSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lines = $v.lines.toBuilder();
      _billingDetails = $v.billingDetails?.toBuilder();
      _materialsSubtotalCentavos = $v.materialsSubtotalCentavos;
      _discountCentavos = $v.discountCentavos;
      _deliveryCentavos = $v.deliveryCentavos;
      _includedVatCentavos = $v.includedVatCentavos;
      _totalCentavos = $v.totalCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InvoiceOrderSummary other) {
    _$v = other as _$InvoiceOrderSummary;
  }

  @override
  void update(void Function(InvoiceOrderSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InvoiceOrderSummary build() => _build();

  _$InvoiceOrderSummary _build() {
    _$InvoiceOrderSummary _$result;
    try {
      _$result = _$v ??
          _$InvoiceOrderSummary._(
            lines: lines.build(),
            billingDetails: _billingDetails?.build(),
            materialsSubtotalCentavos: materialsSubtotalCentavos,
            discountCentavos: discountCentavos,
            deliveryCentavos: deliveryCentavos,
            includedVatCentavos: includedVatCentavos,
            totalCentavos: totalCentavos,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
        _$failedField = 'billingDetails';
        _billingDetails?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'InvoiceOrderSummary', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
