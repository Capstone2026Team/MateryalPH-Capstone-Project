// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nrpc_affected_line.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NrpcAffectedLine extends NrpcAffectedLine {
  @override
  final String orderLineId;
  @override
  final String label;
  @override
  final int principalCentavos;
  @override
  final int linePayableCentavos;
  @override
  final int includedVatCentavos;

  factory _$NrpcAffectedLine(
          [void Function(NrpcAffectedLineBuilder)? updates]) =>
      (NrpcAffectedLineBuilder()..update(updates))._build();

  _$NrpcAffectedLine._(
      {required this.orderLineId,
      required this.label,
      required this.principalCentavos,
      required this.linePayableCentavos,
      required this.includedVatCentavos})
      : super._();
  @override
  NrpcAffectedLine rebuild(void Function(NrpcAffectedLineBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NrpcAffectedLineBuilder toBuilder() =>
      NrpcAffectedLineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NrpcAffectedLine &&
        orderLineId == other.orderLineId &&
        label == other.label &&
        principalCentavos == other.principalCentavos &&
        linePayableCentavos == other.linePayableCentavos &&
        includedVatCentavos == other.includedVatCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderLineId.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, principalCentavos.hashCode);
    _$hash = $jc(_$hash, linePayableCentavos.hashCode);
    _$hash = $jc(_$hash, includedVatCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NrpcAffectedLine')
          ..add('orderLineId', orderLineId)
          ..add('label', label)
          ..add('principalCentavos', principalCentavos)
          ..add('linePayableCentavos', linePayableCentavos)
          ..add('includedVatCentavos', includedVatCentavos))
        .toString();
  }
}

class NrpcAffectedLineBuilder
    implements Builder<NrpcAffectedLine, NrpcAffectedLineBuilder> {
  _$NrpcAffectedLine? _$v;

  String? _orderLineId;
  String? get orderLineId => _$this._orderLineId;
  set orderLineId(String? orderLineId) => _$this._orderLineId = orderLineId;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  int? _principalCentavos;
  int? get principalCentavos => _$this._principalCentavos;
  set principalCentavos(int? principalCentavos) =>
      _$this._principalCentavos = principalCentavos;

  int? _linePayableCentavos;
  int? get linePayableCentavos => _$this._linePayableCentavos;
  set linePayableCentavos(int? linePayableCentavos) =>
      _$this._linePayableCentavos = linePayableCentavos;

  int? _includedVatCentavos;
  int? get includedVatCentavos => _$this._includedVatCentavos;
  set includedVatCentavos(int? includedVatCentavos) =>
      _$this._includedVatCentavos = includedVatCentavos;

  NrpcAffectedLineBuilder() {
    NrpcAffectedLine._defaults(this);
  }

  NrpcAffectedLineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderLineId = $v.orderLineId;
      _label = $v.label;
      _principalCentavos = $v.principalCentavos;
      _linePayableCentavos = $v.linePayableCentavos;
      _includedVatCentavos = $v.includedVatCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NrpcAffectedLine other) {
    _$v = other as _$NrpcAffectedLine;
  }

  @override
  void update(void Function(NrpcAffectedLineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NrpcAffectedLine build() => _build();

  _$NrpcAffectedLine _build() {
    final _$result = _$v ??
        _$NrpcAffectedLine._(
          orderLineId: BuiltValueNullFieldError.checkNotNull(
              orderLineId, r'NrpcAffectedLine', 'orderLineId'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'NrpcAffectedLine', 'label'),
          principalCentavos: BuiltValueNullFieldError.checkNotNull(
              principalCentavos, r'NrpcAffectedLine', 'principalCentavos'),
          linePayableCentavos: BuiltValueNullFieldError.checkNotNull(
              linePayableCentavos, r'NrpcAffectedLine', 'linePayableCentavos'),
          includedVatCentavos: BuiltValueNullFieldError.checkNotNull(
              includedVatCentavos, r'NrpcAffectedLine', 'includedVatCentavos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
