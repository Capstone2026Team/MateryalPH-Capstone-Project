// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_earnings_breakdown_online.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorEarningsBreakdownOnline extends VendorEarningsBreakdownOnline {
  @override
  final int payments;
  @override
  final int principalPaidCentavos;
  @override
  final int refundedPrincipalCentavos;

  factory _$VendorEarningsBreakdownOnline(
          [void Function(VendorEarningsBreakdownOnlineBuilder)? updates]) =>
      (VendorEarningsBreakdownOnlineBuilder()..update(updates))._build();

  _$VendorEarningsBreakdownOnline._(
      {required this.payments,
      required this.principalPaidCentavos,
      required this.refundedPrincipalCentavos})
      : super._();
  @override
  VendorEarningsBreakdownOnline rebuild(
          void Function(VendorEarningsBreakdownOnlineBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorEarningsBreakdownOnlineBuilder toBuilder() =>
      VendorEarningsBreakdownOnlineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorEarningsBreakdownOnline &&
        payments == other.payments &&
        principalPaidCentavos == other.principalPaidCentavos &&
        refundedPrincipalCentavos == other.refundedPrincipalCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, payments.hashCode);
    _$hash = $jc(_$hash, principalPaidCentavos.hashCode);
    _$hash = $jc(_$hash, refundedPrincipalCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorEarningsBreakdownOnline')
          ..add('payments', payments)
          ..add('principalPaidCentavos', principalPaidCentavos)
          ..add('refundedPrincipalCentavos', refundedPrincipalCentavos))
        .toString();
  }
}

class VendorEarningsBreakdownOnlineBuilder
    implements
        Builder<VendorEarningsBreakdownOnline,
            VendorEarningsBreakdownOnlineBuilder> {
  _$VendorEarningsBreakdownOnline? _$v;

  int? _payments;
  int? get payments => _$this._payments;
  set payments(int? payments) => _$this._payments = payments;

  int? _principalPaidCentavos;
  int? get principalPaidCentavos => _$this._principalPaidCentavos;
  set principalPaidCentavos(int? principalPaidCentavos) =>
      _$this._principalPaidCentavos = principalPaidCentavos;

  int? _refundedPrincipalCentavos;
  int? get refundedPrincipalCentavos => _$this._refundedPrincipalCentavos;
  set refundedPrincipalCentavos(int? refundedPrincipalCentavos) =>
      _$this._refundedPrincipalCentavos = refundedPrincipalCentavos;

  VendorEarningsBreakdownOnlineBuilder() {
    VendorEarningsBreakdownOnline._defaults(this);
  }

  VendorEarningsBreakdownOnlineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _payments = $v.payments;
      _principalPaidCentavos = $v.principalPaidCentavos;
      _refundedPrincipalCentavos = $v.refundedPrincipalCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorEarningsBreakdownOnline other) {
    _$v = other as _$VendorEarningsBreakdownOnline;
  }

  @override
  void update(void Function(VendorEarningsBreakdownOnlineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorEarningsBreakdownOnline build() => _build();

  _$VendorEarningsBreakdownOnline _build() {
    final _$result = _$v ??
        _$VendorEarningsBreakdownOnline._(
          payments: BuiltValueNullFieldError.checkNotNull(
              payments, r'VendorEarningsBreakdownOnline', 'payments'),
          principalPaidCentavos: BuiltValueNullFieldError.checkNotNull(
              principalPaidCentavos,
              r'VendorEarningsBreakdownOnline',
              'principalPaidCentavos'),
          refundedPrincipalCentavos: BuiltValueNullFieldError.checkNotNull(
              refundedPrincipalCentavos,
              r'VendorEarningsBreakdownOnline',
              'refundedPrincipalCentavos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
