// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_factor_enrollment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountFactorEnrollment extends AccountFactorEnrollment {
  @override
  final String id;
  @override
  final String expiresAt;
  @override
  final String secret;
  @override
  final String provisioningUri;

  factory _$AccountFactorEnrollment(
          [void Function(AccountFactorEnrollmentBuilder)? updates]) =>
      (AccountFactorEnrollmentBuilder()..update(updates))._build();

  _$AccountFactorEnrollment._(
      {required this.id,
      required this.expiresAt,
      required this.secret,
      required this.provisioningUri})
      : super._();
  @override
  AccountFactorEnrollment rebuild(
          void Function(AccountFactorEnrollmentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountFactorEnrollmentBuilder toBuilder() =>
      AccountFactorEnrollmentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountFactorEnrollment &&
        id == other.id &&
        expiresAt == other.expiresAt &&
        secret == other.secret &&
        provisioningUri == other.provisioningUri;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, secret.hashCode);
    _$hash = $jc(_$hash, provisioningUri.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AccountFactorEnrollment')
          ..add('id', id)
          ..add('expiresAt', expiresAt)
          ..add('secret', secret)
          ..add('provisioningUri', provisioningUri))
        .toString();
  }
}

class AccountFactorEnrollmentBuilder
    implements
        Builder<AccountFactorEnrollment, AccountFactorEnrollmentBuilder> {
  _$AccountFactorEnrollment? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _expiresAt;
  String? get expiresAt => _$this._expiresAt;
  set expiresAt(String? expiresAt) => _$this._expiresAt = expiresAt;

  String? _secret;
  String? get secret => _$this._secret;
  set secret(String? secret) => _$this._secret = secret;

  String? _provisioningUri;
  String? get provisioningUri => _$this._provisioningUri;
  set provisioningUri(String? provisioningUri) =>
      _$this._provisioningUri = provisioningUri;

  AccountFactorEnrollmentBuilder() {
    AccountFactorEnrollment._defaults(this);
  }

  AccountFactorEnrollmentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _expiresAt = $v.expiresAt;
      _secret = $v.secret;
      _provisioningUri = $v.provisioningUri;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountFactorEnrollment other) {
    _$v = other as _$AccountFactorEnrollment;
  }

  @override
  void update(void Function(AccountFactorEnrollmentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountFactorEnrollment build() => _build();

  _$AccountFactorEnrollment _build() {
    final _$result = _$v ??
        _$AccountFactorEnrollment._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AccountFactorEnrollment', 'id'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'AccountFactorEnrollment', 'expiresAt'),
          secret: BuiltValueNullFieldError.checkNotNull(
              secret, r'AccountFactorEnrollment', 'secret'),
          provisioningUri: BuiltValueNullFieldError.checkNotNull(
              provisioningUri, r'AccountFactorEnrollment', 'provisioningUri'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
