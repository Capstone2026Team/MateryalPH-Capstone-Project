// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withholding_threshold_calculation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WithholdingThresholdCalculation
    extends WithholdingThresholdCalculation {
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

  factory _$WithholdingThresholdCalculation(
          [void Function(WithholdingThresholdCalculationBuilder)? updates]) =>
      (WithholdingThresholdCalculationBuilder()..update(updates))._build();

  _$WithholdingThresholdCalculation._(
      {required this.collectionsCentavos,
      required this.refundsCentavos,
      required this.deliveryCentavos,
      required this.materialVatCentavos,
      required this.providerChargesCentavos,
      required this.grossBasisCentavos,
      required this.withheldCentavos,
      required this.assessedCashCentavos})
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
        collectionsCentavos == other.collectionsCentavos &&
        refundsCentavos == other.refundsCentavos &&
        deliveryCentavos == other.deliveryCentavos &&
        materialVatCentavos == other.materialVatCentavos &&
        providerChargesCentavos == other.providerChargesCentavos &&
        grossBasisCentavos == other.grossBasisCentavos &&
        withheldCentavos == other.withheldCentavos &&
        assessedCashCentavos == other.assessedCashCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, collectionsCentavos.hashCode);
    _$hash = $jc(_$hash, refundsCentavos.hashCode);
    _$hash = $jc(_$hash, deliveryCentavos.hashCode);
    _$hash = $jc(_$hash, materialVatCentavos.hashCode);
    _$hash = $jc(_$hash, providerChargesCentavos.hashCode);
    _$hash = $jc(_$hash, grossBasisCentavos.hashCode);
    _$hash = $jc(_$hash, withheldCentavos.hashCode);
    _$hash = $jc(_$hash, assessedCashCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WithholdingThresholdCalculation')
          ..add('collectionsCentavos', collectionsCentavos)
          ..add('refundsCentavos', refundsCentavos)
          ..add('deliveryCentavos', deliveryCentavos)
          ..add('materialVatCentavos', materialVatCentavos)
          ..add('providerChargesCentavos', providerChargesCentavos)
          ..add('grossBasisCentavos', grossBasisCentavos)
          ..add('withheldCentavos', withheldCentavos)
          ..add('assessedCashCentavos', assessedCashCentavos))
        .toString();
  }
}

class WithholdingThresholdCalculationBuilder
    implements
        Builder<WithholdingThresholdCalculation,
            WithholdingThresholdCalculationBuilder> {
  _$WithholdingThresholdCalculation? _$v;

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

  WithholdingThresholdCalculationBuilder() {
    WithholdingThresholdCalculation._defaults(this);
  }

  WithholdingThresholdCalculationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _collectionsCentavos = $v.collectionsCentavos;
      _refundsCentavos = $v.refundsCentavos;
      _deliveryCentavos = $v.deliveryCentavos;
      _materialVatCentavos = $v.materialVatCentavos;
      _providerChargesCentavos = $v.providerChargesCentavos;
      _grossBasisCentavos = $v.grossBasisCentavos;
      _withheldCentavos = $v.withheldCentavos;
      _assessedCashCentavos = $v.assessedCashCentavos;
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
    final _$result = _$v ??
        _$WithholdingThresholdCalculation._(
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
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
