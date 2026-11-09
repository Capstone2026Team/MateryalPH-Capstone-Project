// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_threshold_payments.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorThresholdPayments extends VendorThresholdPayments {
  @override
  final int taxableYear;
  @override
  final BuiltList<AssessedOnlinePayment> payments;
  @override
  final AssessedOnlinePaymentTotals totals;
  @override
  final AssessedOnlinePaymentTotals? otherStoreTotals;

  factory _$VendorThresholdPayments(
          [void Function(VendorThresholdPaymentsBuilder)? updates]) =>
      (VendorThresholdPaymentsBuilder()..update(updates))._build();

  _$VendorThresholdPayments._(
      {required this.taxableYear,
      required this.payments,
      required this.totals,
      this.otherStoreTotals})
      : super._();
  @override
  VendorThresholdPayments rebuild(
          void Function(VendorThresholdPaymentsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorThresholdPaymentsBuilder toBuilder() =>
      VendorThresholdPaymentsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorThresholdPayments &&
        taxableYear == other.taxableYear &&
        payments == other.payments &&
        totals == other.totals &&
        otherStoreTotals == other.otherStoreTotals;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, taxableYear.hashCode);
    _$hash = $jc(_$hash, payments.hashCode);
    _$hash = $jc(_$hash, totals.hashCode);
    _$hash = $jc(_$hash, otherStoreTotals.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorThresholdPayments')
          ..add('taxableYear', taxableYear)
          ..add('payments', payments)
          ..add('totals', totals)
          ..add('otherStoreTotals', otherStoreTotals))
        .toString();
  }
}

class VendorThresholdPaymentsBuilder
    implements
        Builder<VendorThresholdPayments, VendorThresholdPaymentsBuilder> {
  _$VendorThresholdPayments? _$v;

  int? _taxableYear;
  int? get taxableYear => _$this._taxableYear;
  set taxableYear(int? taxableYear) => _$this._taxableYear = taxableYear;

  ListBuilder<AssessedOnlinePayment>? _payments;
  ListBuilder<AssessedOnlinePayment> get payments =>
      _$this._payments ??= ListBuilder<AssessedOnlinePayment>();
  set payments(ListBuilder<AssessedOnlinePayment>? payments) =>
      _$this._payments = payments;

  AssessedOnlinePaymentTotalsBuilder? _totals;
  AssessedOnlinePaymentTotalsBuilder get totals =>
      _$this._totals ??= AssessedOnlinePaymentTotalsBuilder();
  set totals(AssessedOnlinePaymentTotalsBuilder? totals) =>
      _$this._totals = totals;

  AssessedOnlinePaymentTotalsBuilder? _otherStoreTotals;
  AssessedOnlinePaymentTotalsBuilder get otherStoreTotals =>
      _$this._otherStoreTotals ??= AssessedOnlinePaymentTotalsBuilder();
  set otherStoreTotals(AssessedOnlinePaymentTotalsBuilder? otherStoreTotals) =>
      _$this._otherStoreTotals = otherStoreTotals;

  VendorThresholdPaymentsBuilder() {
    VendorThresholdPayments._defaults(this);
  }

  VendorThresholdPaymentsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _taxableYear = $v.taxableYear;
      _payments = $v.payments.toBuilder();
      _totals = $v.totals.toBuilder();
      _otherStoreTotals = $v.otherStoreTotals?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorThresholdPayments other) {
    _$v = other as _$VendorThresholdPayments;
  }

  @override
  void update(void Function(VendorThresholdPaymentsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorThresholdPayments build() => _build();

  _$VendorThresholdPayments _build() {
    _$VendorThresholdPayments _$result;
    try {
      _$result = _$v ??
          _$VendorThresholdPayments._(
            taxableYear: BuiltValueNullFieldError.checkNotNull(
                taxableYear, r'VendorThresholdPayments', 'taxableYear'),
            payments: payments.build(),
            totals: totals.build(),
            otherStoreTotals: _otherStoreTotals?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'payments';
        payments.build();
        _$failedField = 'totals';
        totals.build();
        _$failedField = 'otherStoreTotals';
        _otherStoreTotals?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorThresholdPayments', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
