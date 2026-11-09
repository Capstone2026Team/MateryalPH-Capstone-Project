// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withholding_threshold_calculation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WithholdingThresholdCalculation
    extends WithholdingThresholdCalculation {
  @override
  final int assessedPayments;
  @override
  final int paymentPrincipalCentavos;
  @override
  final int buyerProcessingFeesCentavos;
  @override
  final int collectionsCentavos;
  @override
  final int refundsCentavos;
  @override
  final int deliveryCentavos;
  @override
  final int materialVatCentavos;
  @override
  final int providerChargesCentavos;
  @override
  final int grossBasisCentavos;
  @override
  final int withheldCentavos;
  @override
  final int assessedCashCentavos;
  @override
  final WithholdingCalculationBreakdown? withholdingBreakdown;

  factory _$WithholdingThresholdCalculation(
          [void Function(WithholdingThresholdCalculationBuilder)? updates]) =>
      (WithholdingThresholdCalculationBuilder()..update(updates))._build();

  _$WithholdingThresholdCalculation._(
      {required this.assessedPayments,
      required this.paymentPrincipalCentavos,
      required this.buyerProcessingFeesCentavos,
      required this.collectionsCentavos,
      required this.refundsCentavos,
      required this.deliveryCentavos,
      required this.materialVatCentavos,
      required this.providerChargesCentavos,
      required this.grossBasisCentavos,
      required this.withheldCentavos,
      required this.assessedCashCentavos,
      this.withholdingBreakdown})
      : super._();
  @override
  WithholdingThresholdCalculation rebuild(
          void Function(WithholdingThresholdCalculationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WithholdingThresholdCalculationBuilder toBuilder() =>
      WithholdingThresholdCalculationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WithholdingThresholdCalculation &&
        assessedPayments == other.assessedPayments &&
        paymentPrincipalCentavos == other.paymentPrincipalCentavos &&
        buyerProcessingFeesCentavos == other.buyerProcessingFeesCentavos &&
        collectionsCentavos == other.collectionsCentavos &&
        refundsCentavos == other.refundsCentavos &&
        deliveryCentavos == other.deliveryCentavos &&
        materialVatCentavos == other.materialVatCentavos &&
        providerChargesCentavos == other.providerChargesCentavos &&
        grossBasisCentavos == other.grossBasisCentavos &&
        withheldCentavos == other.withheldCentavos &&
        assessedCashCentavos == other.assessedCashCentavos &&
        withholdingBreakdown == other.withholdingBreakdown;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, assessedPayments.hashCode);
    _$hash = $jc(_$hash, paymentPrincipalCentavos.hashCode);
    _$hash = $jc(_$hash, buyerProcessingFeesCentavos.hashCode);
    _$hash = $jc(_$hash, collectionsCentavos.hashCode);
    _$hash = $jc(_$hash, refundsCentavos.hashCode);
    _$hash = $jc(_$hash, deliveryCentavos.hashCode);
    _$hash = $jc(_$hash, materialVatCentavos.hashCode);
    _$hash = $jc(_$hash, providerChargesCentavos.hashCode);
    _$hash = $jc(_$hash, grossBasisCentavos.hashCode);
    _$hash = $jc(_$hash, withheldCentavos.hashCode);
    _$hash = $jc(_$hash, assessedCashCentavos.hashCode);
    _$hash = $jc(_$hash, withholdingBreakdown.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WithholdingThresholdCalculation')
          ..add('assessedPayments', assessedPayments)
          ..add('paymentPrincipalCentavos', paymentPrincipalCentavos)
          ..add('buyerProcessingFeesCentavos', buyerProcessingFeesCentavos)
          ..add('collectionsCentavos', collectionsCentavos)
          ..add('refundsCentavos', refundsCentavos)
          ..add('deliveryCentavos', deliveryCentavos)
          ..add('materialVatCentavos', materialVatCentavos)
          ..add('providerChargesCentavos', providerChargesCentavos)
          ..add('grossBasisCentavos', grossBasisCentavos)
          ..add('withheldCentavos', withheldCentavos)
          ..add('assessedCashCentavos', assessedCashCentavos)
          ..add('withholdingBreakdown', withholdingBreakdown))
        .toString();
  }
}

class WithholdingThresholdCalculationBuilder
    implements
        Builder<WithholdingThresholdCalculation,
            WithholdingThresholdCalculationBuilder> {
  _$WithholdingThresholdCalculation? _$v;

  int? _assessedPayments;
  int? get assessedPayments => _$this._assessedPayments;
  set assessedPayments(int? assessedPayments) =>
      _$this._assessedPayments = assessedPayments;

  int? _paymentPrincipalCentavos;
  int? get paymentPrincipalCentavos => _$this._paymentPrincipalCentavos;
  set paymentPrincipalCentavos(int? paymentPrincipalCentavos) =>
      _$this._paymentPrincipalCentavos = paymentPrincipalCentavos;

  int? _buyerProcessingFeesCentavos;
  int? get buyerProcessingFeesCentavos => _$this._buyerProcessingFeesCentavos;
  set buyerProcessingFeesCentavos(int? buyerProcessingFeesCentavos) =>
      _$this._buyerProcessingFeesCentavos = buyerProcessingFeesCentavos;

  int? _collectionsCentavos;
  int? get collectionsCentavos => _$this._collectionsCentavos;
  set collectionsCentavos(int? collectionsCentavos) =>
      _$this._collectionsCentavos = collectionsCentavos;

  int? _refundsCentavos;
  int? get refundsCentavos => _$this._refundsCentavos;
  set refundsCentavos(int? refundsCentavos) =>
      _$this._refundsCentavos = refundsCentavos;

  int? _deliveryCentavos;
  int? get deliveryCentavos => _$this._deliveryCentavos;
  set deliveryCentavos(int? deliveryCentavos) =>
      _$this._deliveryCentavos = deliveryCentavos;

  int? _materialVatCentavos;
  int? get materialVatCentavos => _$this._materialVatCentavos;
  set materialVatCentavos(int? materialVatCentavos) =>
      _$this._materialVatCentavos = materialVatCentavos;

  int? _providerChargesCentavos;
  int? get providerChargesCentavos => _$this._providerChargesCentavos;
  set providerChargesCentavos(int? providerChargesCentavos) =>
      _$this._providerChargesCentavos = providerChargesCentavos;

  int? _grossBasisCentavos;
  int? get grossBasisCentavos => _$this._grossBasisCentavos;
  set grossBasisCentavos(int? grossBasisCentavos) =>
      _$this._grossBasisCentavos = grossBasisCentavos;

  int? _withheldCentavos;
  int? get withheldCentavos => _$this._withheldCentavos;
  set withheldCentavos(int? withheldCentavos) =>
      _$this._withheldCentavos = withheldCentavos;

  int? _assessedCashCentavos;
  int? get assessedCashCentavos => _$this._assessedCashCentavos;
  set assessedCashCentavos(int? assessedCashCentavos) =>
      _$this._assessedCashCentavos = assessedCashCentavos;

  WithholdingCalculationBreakdownBuilder? _withholdingBreakdown;
  WithholdingCalculationBreakdownBuilder get withholdingBreakdown =>
      _$this._withholdingBreakdown ??= WithholdingCalculationBreakdownBuilder();
  set withholdingBreakdown(
          WithholdingCalculationBreakdownBuilder? withholdingBreakdown) =>
      _$this._withholdingBreakdown = withholdingBreakdown;

  WithholdingThresholdCalculationBuilder() {
    WithholdingThresholdCalculation._defaults(this);
  }

  WithholdingThresholdCalculationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _assessedPayments = $v.assessedPayments;
      _paymentPrincipalCentavos = $v.paymentPrincipalCentavos;
      _buyerProcessingFeesCentavos = $v.buyerProcessingFeesCentavos;
      _collectionsCentavos = $v.collectionsCentavos;
      _refundsCentavos = $v.refundsCentavos;
      _deliveryCentavos = $v.deliveryCentavos;
      _materialVatCentavos = $v.materialVatCentavos;
      _providerChargesCentavos = $v.providerChargesCentavos;
      _grossBasisCentavos = $v.grossBasisCentavos;
      _withheldCentavos = $v.withheldCentavos;
      _assessedCashCentavos = $v.assessedCashCentavos;
      _withholdingBreakdown = $v.withholdingBreakdown?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WithholdingThresholdCalculation other) {
    _$v = other as _$WithholdingThresholdCalculation;
  }

  @override
  void update(void Function(WithholdingThresholdCalculationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WithholdingThresholdCalculation build() => _build();

  _$WithholdingThresholdCalculation _build() {
    _$WithholdingThresholdCalculation _$result;
    try {
      _$result = _$v ??
          _$WithholdingThresholdCalculation._(
            assessedPayments: BuiltValueNullFieldError.checkNotNull(
                assessedPayments,
                r'WithholdingThresholdCalculation',
                'assessedPayments'),
            paymentPrincipalCentavos: BuiltValueNullFieldError.checkNotNull(
                paymentPrincipalCentavos,
                r'WithholdingThresholdCalculation',
                'paymentPrincipalCentavos'),
            buyerProcessingFeesCentavos: BuiltValueNullFieldError.checkNotNull(
                buyerProcessingFeesCentavos,
                r'WithholdingThresholdCalculation',
                'buyerProcessingFeesCentavos'),
            collectionsCentavos: BuiltValueNullFieldError.checkNotNull(
                collectionsCentavos,
                r'WithholdingThresholdCalculation',
                'collectionsCentavos'),
            refundsCentavos: BuiltValueNullFieldError.checkNotNull(
                refundsCentavos,
                r'WithholdingThresholdCalculation',
                'refundsCentavos'),
            deliveryCentavos: BuiltValueNullFieldError.checkNotNull(
                deliveryCentavos,
                r'WithholdingThresholdCalculation',
                'deliveryCentavos'),
            materialVatCentavos: BuiltValueNullFieldError.checkNotNull(
                materialVatCentavos,
                r'WithholdingThresholdCalculation',
                'materialVatCentavos'),
            providerChargesCentavos: BuiltValueNullFieldError.checkNotNull(
                providerChargesCentavos,
                r'WithholdingThresholdCalculation',
                'providerChargesCentavos'),
            grossBasisCentavos: BuiltValueNullFieldError.checkNotNull(
                grossBasisCentavos,
                r'WithholdingThresholdCalculation',
                'grossBasisCentavos'),
            withheldCentavos: BuiltValueNullFieldError.checkNotNull(
                withheldCentavos,
                r'WithholdingThresholdCalculation',
                'withheldCentavos'),
            assessedCashCentavos: BuiltValueNullFieldError.checkNotNull(
                assessedCashCentavos,
                r'WithholdingThresholdCalculation',
                'assessedCashCentavos'),
            withholdingBreakdown: _withholdingBreakdown?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'withholdingBreakdown';
        _withholdingBreakdown?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WithholdingThresholdCalculation', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
