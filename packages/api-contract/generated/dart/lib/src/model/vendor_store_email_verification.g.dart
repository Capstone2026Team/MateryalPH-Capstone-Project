// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_store_email_verification.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorStoreEmailVerification extends VendorStoreEmailVerification {
  @override
  final String? email;
  @override
  final String? verifiedAt;
  @override
  final String? pendingEmail;

  factory _$VendorStoreEmailVerification(
          [void Function(VendorStoreEmailVerificationBuilder)? updates]) =>
      (VendorStoreEmailVerificationBuilder()..update(updates))._build();

  _$VendorStoreEmailVerification._(
      {this.email, this.verifiedAt, this.pendingEmail})
      : super._();
  @override
  VendorStoreEmailVerification rebuild(
          void Function(VendorStoreEmailVerificationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorStoreEmailVerificationBuilder toBuilder() =>
      VendorStoreEmailVerificationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorStoreEmailVerification &&
        email == other.email &&
        verifiedAt == other.verifiedAt &&
        pendingEmail == other.pendingEmail;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, verifiedAt.hashCode);
    _$hash = $jc(_$hash, pendingEmail.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorStoreEmailVerification')
          ..add('email', email)
          ..add('verifiedAt', verifiedAt)
          ..add('pendingEmail', pendingEmail))
        .toString();
  }
}

class VendorStoreEmailVerificationBuilder
    implements
        Builder<VendorStoreEmailVerification,
            VendorStoreEmailVerificationBuilder> {
  _$VendorStoreEmailVerification? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _verifiedAt;
  String? get verifiedAt => _$this._verifiedAt;
  set verifiedAt(String? verifiedAt) => _$this._verifiedAt = verifiedAt;

  String? _pendingEmail;
  String? get pendingEmail => _$this._pendingEmail;
  set pendingEmail(String? pendingEmail) => _$this._pendingEmail = pendingEmail;

  VendorStoreEmailVerificationBuilder() {
    VendorStoreEmailVerification._defaults(this);
  }

  VendorStoreEmailVerificationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _verifiedAt = $v.verifiedAt;
      _pendingEmail = $v.pendingEmail;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorStoreEmailVerification other) {
    _$v = other as _$VendorStoreEmailVerification;
  }

  @override
  void update(void Function(VendorStoreEmailVerificationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorStoreEmailVerification build() => _build();

  _$VendorStoreEmailVerification _build() {
    final _$result = _$v ??
        _$VendorStoreEmailVerification._(
          email: email,
          verifiedAt: verifiedAt,
          pendingEmail: pendingEmail,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
