// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_plan_formula.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeliveryPlanFormula extends DeliveryPlanFormula {
  @override
  final String calculationVersion;
  @override
  final String rounding;
  @override
  final String finalFeeRule;

  factory _$DeliveryPlanFormula(
          [void Function(DeliveryPlanFormulaBuilder)? updates]) =>
      (DeliveryPlanFormulaBuilder()..update(updates))._build();

  _$DeliveryPlanFormula._(
      {required this.calculationVersion,
      required this.rounding,
      required this.finalFeeRule})
      : super._();
  @override
  DeliveryPlanFormula rebuild(
          void Function(DeliveryPlanFormulaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeliveryPlanFormulaBuilder toBuilder() =>
      DeliveryPlanFormulaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeliveryPlanFormula &&
        calculationVersion == other.calculationVersion &&
        rounding == other.rounding &&
        finalFeeRule == other.finalFeeRule;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, calculationVersion.hashCode);
    _$hash = $jc(_$hash, rounding.hashCode);
    _$hash = $jc(_$hash, finalFeeRule.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeliveryPlanFormula')
          ..add('calculationVersion', calculationVersion)
          ..add('rounding', rounding)
          ..add('finalFeeRule', finalFeeRule))
        .toString();
  }
}

class DeliveryPlanFormulaBuilder
    implements Builder<DeliveryPlanFormula, DeliveryPlanFormulaBuilder> {
  _$DeliveryPlanFormula? _$v;

  String? _calculationVersion;
  String? get calculationVersion => _$this._calculationVersion;
  set calculationVersion(String? calculationVersion) =>
      _$this._calculationVersion = calculationVersion;

  String? _rounding;
  String? get rounding => _$this._rounding;
  set rounding(String? rounding) => _$this._rounding = rounding;

  String? _finalFeeRule;
  String? get finalFeeRule => _$this._finalFeeRule;
  set finalFeeRule(String? finalFeeRule) => _$this._finalFeeRule = finalFeeRule;

  DeliveryPlanFormulaBuilder() {
    DeliveryPlanFormula._defaults(this);
  }

  DeliveryPlanFormulaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _calculationVersion = $v.calculationVersion;
      _rounding = $v.rounding;
      _finalFeeRule = $v.finalFeeRule;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeliveryPlanFormula other) {
    _$v = other as _$DeliveryPlanFormula;
  }

  @override
  void update(void Function(DeliveryPlanFormulaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeliveryPlanFormula build() => _build();

  _$DeliveryPlanFormula _build() {
    final _$result = _$v ??
        _$DeliveryPlanFormula._(
          calculationVersion: BuiltValueNullFieldError.checkNotNull(
              calculationVersion, r'DeliveryPlanFormula', 'calculationVersion'),
          rounding: BuiltValueNullFieldError.checkNotNull(
              rounding, r'DeliveryPlanFormula', 'rounding'),
          finalFeeRule: BuiltValueNullFieldError.checkNotNull(
              finalFeeRule, r'DeliveryPlanFormula', 'finalFeeRule'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
