// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_two_factor_enrollment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerTwoFactorEnrollment extends BuyerTwoFactorEnrollment {
  @override
  final String secret;
  @override
  final String provisioningUri;
  @override
  final String issuer;
  @override
  final String accountName;

  factory _$BuyerTwoFactorEnrollment(
          [void Function(BuyerTwoFactorEnrollmentBuilder)? updates]) =>
      (BuyerTwoFactorEnrollmentBuilder()..update(updates))._build();

  _$BuyerTwoFactorEnrollment._(
      {required this.secret,
      required this.provisioningUri,
      required this.issuer,
      required this.accountName})
      : super._();
  @override
  BuyerTwoFactorEnrollment rebuild(
          void Function(BuyerTwoFactorEnrollmentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerTwoFactorEnrollmentBuilder toBuilder() =>
      BuyerTwoFactorEnrollmentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerTwoFactorEnrollment &&
        secret == other.secret &&
        provisioningUri == other.provisioningUri &&
        issuer == other.issuer &&
        accountName == other.accountName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, secret.hashCode);
    _$hash = $jc(_$hash, provisioningUri.hashCode);
    _$hash = $jc(_$hash, issuer.hashCode);
    _$hash = $jc(_$hash, accountName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerTwoFactorEnrollment')
          ..add('secret', secret)
          ..add('provisioningUri', provisioningUri)
          ..add('issuer', issuer)
          ..add('accountName', accountName))
        .toString();
  }
}

class BuyerTwoFactorEnrollmentBuilder
    implements
        Builder<BuyerTwoFactorEnrollment, BuyerTwoFactorEnrollmentBuilder> {
  _$BuyerTwoFactorEnrollment? _$v;

  String? _secret;
  String? get secret => _$this._secret;
  set secret(String? secret) => _$this._secret = secret;

  String? _provisioningUri;
  String? get provisioningUri => _$this._provisioningUri;
  set provisioningUri(String? provisioningUri) =>
      _$this._provisioningUri = provisioningUri;

  String? _issuer;
  String? get issuer => _$this._issuer;
  set issuer(String? issuer) => _$this._issuer = issuer;

  String? _accountName;
  String? get accountName => _$this._accountName;
  set accountName(String? accountName) => _$this._accountName = accountName;

  BuyerTwoFactorEnrollmentBuilder() {
    BuyerTwoFactorEnrollment._defaults(this);
  }

  BuyerTwoFactorEnrollmentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _secret = $v.secret;
      _provisioningUri = $v.provisioningUri;
      _issuer = $v.issuer;
      _accountName = $v.accountName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerTwoFactorEnrollment other) {
    _$v = other as _$BuyerTwoFactorEnrollment;
  }

  @override
  void update(void Function(BuyerTwoFactorEnrollmentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerTwoFactorEnrollment build() => _build();

  _$BuyerTwoFactorEnrollment _build() {
    final _$result = _$v ??
        _$BuyerTwoFactorEnrollment._(
          secret: BuiltValueNullFieldError.checkNotNull(
              secret, r'BuyerTwoFactorEnrollment', 'secret'),
          provisioningUri: BuiltValueNullFieldError.checkNotNull(
              provisioningUri, r'BuyerTwoFactorEnrollment', 'provisioningUri'),
          issuer: BuiltValueNullFieldError.checkNotNull(
              issuer, r'BuyerTwoFactorEnrollment', 'issuer'),
          accountName: BuiltValueNullFieldError.checkNotNull(
              accountName, r'BuyerTwoFactorEnrollment', 'accountName'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
