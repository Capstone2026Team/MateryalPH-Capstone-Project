// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withholding_payment_calculation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WithholdingPaymentCalculation extends WithholdingPaymentCalculation {
  @override
  final String id;
  @override
  final String orderReference;
  @override
  final int grossBasisCentavos;
  @override
  final int rateBasisPoints;
  @override
  final int withheldCentavos;

  factory _$WithholdingPaymentCalculation(
          [void Function(WithholdingPaymentCalculationBuilder)? updates]) =>
      (WithholdingPaymentCalculationBuilder()..update(updates))._build();

  _$WithholdingPaymentCalculation._(
      {required this.id,
      required this.orderReference,
      required this.grossBasisCentavos,
      required this.rateBasisPoints,
      required this.withheldCentavos})
      : super._();
  @override
  WithholdingPaymentCalculation rebuild(
          void Function(WithholdingPaymentCalculationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WithholdingPaymentCalculationBuilder toBuilder() =>
      WithholdingPaymentCalculationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WithholdingPaymentCalculation &&
        id == other.id &&
        orderReference == other.orderReference &&
        grossBasisCentavos == other.grossBasisCentavos &&
        rateBasisPoints == other.rateBasisPoints &&
        withheldCentavos == other.withheldCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, orderReference.hashCode);
    _$hash = $jc(_$hash, grossBasisCentavos.hashCode);
    _$hash = $jc(_$hash, rateBasisPoints.hashCode);
    _$hash = $jc(_$hash, withheldCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WithholdingPaymentCalculation')
          ..add('id', id)
          ..add('orderReference', orderReference)
          ..add('grossBasisCentavos', grossBasisCentavos)
          ..add('rateBasisPoints', rateBasisPoints)
          ..add('withheldCentavos', withheldCentavos))
        .toString();
  }
}

class WithholdingPaymentCalculationBuilder
    implements
        Builder<WithholdingPaymentCalculation,
            WithholdingPaymentCalculationBuilder> {
  _$WithholdingPaymentCalculation? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _orderReference;
  String? get orderReference => _$this._orderReference;
  set orderReference(String? orderReference) =>
      _$this._orderReference = orderReference;

  int? _grossBasisCentavos;
  int? get grossBasisCentavos => _$this._grossBasisCentavos;
  set grossBasisCentavos(int? grossBasisCentavos) =>
      _$this._grossBasisCentavos = grossBasisCentavos;

  int? _rateBasisPoints;
  int? get rateBasisPoints => _$this._rateBasisPoints;
  set rateBasisPoints(int? rateBasisPoints) =>
      _$this._rateBasisPoints = rateBasisPoints;

  int? _withheldCentavos;
  int? get withheldCentavos => _$this._withheldCentavos;
  set withheldCentavos(int? withheldCentavos) =>
      _$this._withheldCentavos = withheldCentavos;

  WithholdingPaymentCalculationBuilder() {
    WithholdingPaymentCalculation._defaults(this);
  }

  WithholdingPaymentCalculationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _orderReference = $v.orderReference;
      _grossBasisCentavos = $v.grossBasisCentavos;
      _rateBasisPoints = $v.rateBasisPoints;
      _withheldCentavos = $v.withheldCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WithholdingPaymentCalculation other) {
    _$v = other as _$WithholdingPaymentCalculation;
  }

  @override
  void update(void Function(WithholdingPaymentCalculationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WithholdingPaymentCalculation build() => _build();

  _$WithholdingPaymentCalculation _build() {
    final _$result = _$v ??
        _$WithholdingPaymentCalculation._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'WithholdingPaymentCalculation', 'id'),
          orderReference: BuiltValueNullFieldError.checkNotNull(orderReference,
              r'WithholdingPaymentCalculation', 'orderReference'),
          grossBasisCentavos: BuiltValueNullFieldError.checkNotNull(
              grossBasisCentavos,
              r'WithholdingPaymentCalculation',
              'grossBasisCentavos'),
          rateBasisPoints: BuiltValueNullFieldError.checkNotNull(
              rateBasisPoints,
              r'WithholdingPaymentCalculation',
              'rateBasisPoints'),
          withheldCentavos: BuiltValueNullFieldError.checkNotNull(
              withheldCentavos,
              r'WithholdingPaymentCalculation',
              'withheldCentavos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
