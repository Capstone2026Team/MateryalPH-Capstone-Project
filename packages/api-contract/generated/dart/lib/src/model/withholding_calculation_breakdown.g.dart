// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withholding_calculation_breakdown.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WithholdingCalculationBreakdown
    extends WithholdingCalculationBreakdown {
  @override
  final BuiltList<WithholdingPaymentCalculation> payments;
  @override
  final int remainingPayments;
  @override
  final int remainingBasisCentavos;
  @override
  final int remainingWithheldCentavos;

  factory _$WithholdingCalculationBreakdown(
          [void Function(WithholdingCalculationBreakdownBuilder)? updates]) =>
      (WithholdingCalculationBreakdownBuilder()..update(updates))._build();

  _$WithholdingCalculationBreakdown._(
      {required this.payments,
      required this.remainingPayments,
      required this.remainingBasisCentavos,
      required this.remainingWithheldCentavos})
      : super._();
  @override
  WithholdingCalculationBreakdown rebuild(
          void Function(WithholdingCalculationBreakdownBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WithholdingCalculationBreakdownBuilder toBuilder() =>
      WithholdingCalculationBreakdownBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WithholdingCalculationBreakdown &&
        payments == other.payments &&
        remainingPayments == other.remainingPayments &&
        remainingBasisCentavos == other.remainingBasisCentavos &&
        remainingWithheldCentavos == other.remainingWithheldCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, payments.hashCode);
    _$hash = $jc(_$hash, remainingPayments.hashCode);
    _$hash = $jc(_$hash, remainingBasisCentavos.hashCode);
    _$hash = $jc(_$hash, remainingWithheldCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WithholdingCalculationBreakdown')
          ..add('payments', payments)
          ..add('remainingPayments', remainingPayments)
          ..add('remainingBasisCentavos', remainingBasisCentavos)
          ..add('remainingWithheldCentavos', remainingWithheldCentavos))
        .toString();
  }
}

class WithholdingCalculationBreakdownBuilder
    implements
        Builder<WithholdingCalculationBreakdown,
            WithholdingCalculationBreakdownBuilder> {
  _$WithholdingCalculationBreakdown? _$v;

  ListBuilder<WithholdingPaymentCalculation>? _payments;
  ListBuilder<WithholdingPaymentCalculation> get payments =>
      _$this._payments ??= ListBuilder<WithholdingPaymentCalculation>();
  set payments(ListBuilder<WithholdingPaymentCalculation>? payments) =>
      _$this._payments = payments;

  int? _remainingPayments;
  int? get remainingPayments => _$this._remainingPayments;
  set remainingPayments(int? remainingPayments) =>
      _$this._remainingPayments = remainingPayments;

  int? _remainingBasisCentavos;
  int? get remainingBasisCentavos => _$this._remainingBasisCentavos;
  set remainingBasisCentavos(int? remainingBasisCentavos) =>
      _$this._remainingBasisCentavos = remainingBasisCentavos;

  int? _remainingWithheldCentavos;
  int? get remainingWithheldCentavos => _$this._remainingWithheldCentavos;
  set remainingWithheldCentavos(int? remainingWithheldCentavos) =>
      _$this._remainingWithheldCentavos = remainingWithheldCentavos;

  WithholdingCalculationBreakdownBuilder() {
    WithholdingCalculationBreakdown._defaults(this);
  }

  WithholdingCalculationBreakdownBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _payments = $v.payments.toBuilder();
      _remainingPayments = $v.remainingPayments;
      _remainingBasisCentavos = $v.remainingBasisCentavos;
      _remainingWithheldCentavos = $v.remainingWithheldCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WithholdingCalculationBreakdown other) {
    _$v = other as _$WithholdingCalculationBreakdown;
  }

  @override
  void update(void Function(WithholdingCalculationBreakdownBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WithholdingCalculationBreakdown build() => _build();

  _$WithholdingCalculationBreakdown _build() {
    _$WithholdingCalculationBreakdown _$result;
    try {
      _$result = _$v ??
          _$WithholdingCalculationBreakdown._(
            payments: payments.build(),
            remainingPayments: BuiltValueNullFieldError.checkNotNull(
                remainingPayments,
                r'WithholdingCalculationBreakdown',
                'remainingPayments'),
            remainingBasisCentavos: BuiltValueNullFieldError.checkNotNull(
                remainingBasisCentavos,
                r'WithholdingCalculationBreakdown',
                'remainingBasisCentavos'),
            remainingWithheldCentavos: BuiltValueNullFieldError.checkNotNull(
                remainingWithheldCentavos,
                r'WithholdingCalculationBreakdown',
                'remainingWithheldCentavos'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'payments';
        payments.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WithholdingCalculationBreakdown', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
