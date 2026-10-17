// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_affected_line.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputeAffectedLine extends DisputeAffectedLine {
  @override
  final String orderLineId;
  @override
  final String displayName;
  @override
  final String? variantLabel;
  @override
  final String quantity;
  @override
  final int lineTotalCentavos;
  @override
  final int refundableCentavos;

  factory _$DisputeAffectedLine(
          [void Function(DisputeAffectedLineBuilder)? updates]) =>
      (DisputeAffectedLineBuilder()..update(updates))._build();

  _$DisputeAffectedLine._(
      {required this.orderLineId,
      required this.displayName,
      this.variantLabel,
      required this.quantity,
      required this.lineTotalCentavos,
      required this.refundableCentavos})
      : super._();
  @override
  DisputeAffectedLine rebuild(
          void Function(DisputeAffectedLineBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeAffectedLineBuilder toBuilder() =>
      DisputeAffectedLineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeAffectedLine &&
        orderLineId == other.orderLineId &&
        displayName == other.displayName &&
        variantLabel == other.variantLabel &&
        quantity == other.quantity &&
        lineTotalCentavos == other.lineTotalCentavos &&
        refundableCentavos == other.refundableCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderLineId.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, variantLabel.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, lineTotalCentavos.hashCode);
    _$hash = $jc(_$hash, refundableCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeAffectedLine')
          ..add('orderLineId', orderLineId)
          ..add('displayName', displayName)
          ..add('variantLabel', variantLabel)
          ..add('quantity', quantity)
          ..add('lineTotalCentavos', lineTotalCentavos)
          ..add('refundableCentavos', refundableCentavos))
        .toString();
  }
}

class DisputeAffectedLineBuilder
    implements Builder<DisputeAffectedLine, DisputeAffectedLineBuilder> {
  _$DisputeAffectedLine? _$v;

  String? _orderLineId;
  String? get orderLineId => _$this._orderLineId;
  set orderLineId(String? orderLineId) => _$this._orderLineId = orderLineId;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _variantLabel;
  String? get variantLabel => _$this._variantLabel;
  set variantLabel(String? variantLabel) => _$this._variantLabel = variantLabel;

  String? _quantity;
  String? get quantity => _$this._quantity;
  set quantity(String? quantity) => _$this._quantity = quantity;

  int? _lineTotalCentavos;
  int? get lineTotalCentavos => _$this._lineTotalCentavos;
  set lineTotalCentavos(int? lineTotalCentavos) =>
      _$this._lineTotalCentavos = lineTotalCentavos;

  int? _refundableCentavos;
  int? get refundableCentavos => _$this._refundableCentavos;
  set refundableCentavos(int? refundableCentavos) =>
      _$this._refundableCentavos = refundableCentavos;

  DisputeAffectedLineBuilder() {
    DisputeAffectedLine._defaults(this);
  }

  DisputeAffectedLineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderLineId = $v.orderLineId;
      _displayName = $v.displayName;
      _variantLabel = $v.variantLabel;
      _quantity = $v.quantity;
      _lineTotalCentavos = $v.lineTotalCentavos;
      _refundableCentavos = $v.refundableCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeAffectedLine other) {
    _$v = other as _$DisputeAffectedLine;
  }

  @override
  void update(void Function(DisputeAffectedLineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeAffectedLine build() => _build();

  _$DisputeAffectedLine _build() {
    final _$result = _$v ??
        _$DisputeAffectedLine._(
          orderLineId: BuiltValueNullFieldError.checkNotNull(
              orderLineId, r'DisputeAffectedLine', 'orderLineId'),
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'DisputeAffectedLine', 'displayName'),
          variantLabel: variantLabel,
          quantity: BuiltValueNullFieldError.checkNotNull(
              quantity, r'DisputeAffectedLine', 'quantity'),
          lineTotalCentavos: BuiltValueNullFieldError.checkNotNull(
              lineTotalCentavos, r'DisputeAffectedLine', 'lineTotalCentavos'),
          refundableCentavos: BuiltValueNullFieldError.checkNotNull(
              refundableCentavos, r'DisputeAffectedLine', 'refundableCentavos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
