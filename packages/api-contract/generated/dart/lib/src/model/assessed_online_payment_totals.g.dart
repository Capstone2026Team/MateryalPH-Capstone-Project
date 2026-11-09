// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessed_online_payment_totals.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AssessedOnlinePaymentTotals extends AssessedOnlinePaymentTotals {
  @override
  final int assessedPayments;
  @override
  final int paymentPrincipalCentavos;
  @override
  final int buyerProcessingFeesCentavos;
  @override
  final int collectionsCentavos;
  @override
  final int withheldCentavos;

  factory _$AssessedOnlinePaymentTotals(
          [void Function(AssessedOnlinePaymentTotalsBuilder)? updates]) =>
      (AssessedOnlinePaymentTotalsBuilder()..update(updates))._build();

  _$AssessedOnlinePaymentTotals._(
      {required this.assessedPayments,
      required this.paymentPrincipalCentavos,
      required this.buyerProcessingFeesCentavos,
      required this.collectionsCentavos,
      required this.withheldCentavos})
      : super._();
  @override
  AssessedOnlinePaymentTotals rebuild(
          void Function(AssessedOnlinePaymentTotalsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AssessedOnlinePaymentTotalsBuilder toBuilder() =>
      AssessedOnlinePaymentTotalsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AssessedOnlinePaymentTotals &&
        assessedPayments == other.assessedPayments &&
        paymentPrincipalCentavos == other.paymentPrincipalCentavos &&
        buyerProcessingFeesCentavos == other.buyerProcessingFeesCentavos &&
        collectionsCentavos == other.collectionsCentavos &&
        withheldCentavos == other.withheldCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, assessedPayments.hashCode);
    _$hash = $jc(_$hash, paymentPrincipalCentavos.hashCode);
    _$hash = $jc(_$hash, buyerProcessingFeesCentavos.hashCode);
    _$hash = $jc(_$hash, collectionsCentavos.hashCode);
    _$hash = $jc(_$hash, withheldCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AssessedOnlinePaymentTotals')
          ..add('assessedPayments', assessedPayments)
          ..add('paymentPrincipalCentavos', paymentPrincipalCentavos)
          ..add('buyerProcessingFeesCentavos', buyerProcessingFeesCentavos)
          ..add('collectionsCentavos', collectionsCentavos)
          ..add('withheldCentavos', withheldCentavos))
        .toString();
  }
}

class AssessedOnlinePaymentTotalsBuilder
    implements
        Builder<AssessedOnlinePaymentTotals,
            AssessedOnlinePaymentTotalsBuilder> {
  _$AssessedOnlinePaymentTotals? _$v;

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

  int? _withheldCentavos;
  int? get withheldCentavos => _$this._withheldCentavos;
  set withheldCentavos(int? withheldCentavos) =>
      _$this._withheldCentavos = withheldCentavos;

  AssessedOnlinePaymentTotalsBuilder() {
    AssessedOnlinePaymentTotals._defaults(this);
  }

  AssessedOnlinePaymentTotalsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _assessedPayments = $v.assessedPayments;
      _paymentPrincipalCentavos = $v.paymentPrincipalCentavos;
      _buyerProcessingFeesCentavos = $v.buyerProcessingFeesCentavos;
      _collectionsCentavos = $v.collectionsCentavos;
      _withheldCentavos = $v.withheldCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AssessedOnlinePaymentTotals other) {
    _$v = other as _$AssessedOnlinePaymentTotals;
  }

  @override
  void update(void Function(AssessedOnlinePaymentTotalsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AssessedOnlinePaymentTotals build() => _build();

  _$AssessedOnlinePaymentTotals _build() {
    final _$result = _$v ??
        _$AssessedOnlinePaymentTotals._(
          assessedPayments: BuiltValueNullFieldError.checkNotNull(
              assessedPayments,
              r'AssessedOnlinePaymentTotals',
              'assessedPayments'),
          paymentPrincipalCentavos: BuiltValueNullFieldError.checkNotNull(
              paymentPrincipalCentavos,
              r'AssessedOnlinePaymentTotals',
              'paymentPrincipalCentavos'),
          buyerProcessingFeesCentavos: BuiltValueNullFieldError.checkNotNull(
              buyerProcessingFeesCentavos,
              r'AssessedOnlinePaymentTotals',
              'buyerProcessingFeesCentavos'),
          collectionsCentavos: BuiltValueNullFieldError.checkNotNull(
              collectionsCentavos,
              r'AssessedOnlinePaymentTotals',
              'collectionsCentavos'),
          withheldCentavos: BuiltValueNullFieldError.checkNotNull(
              withheldCentavos,
              r'AssessedOnlinePaymentTotals',
              'withheldCentavos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
