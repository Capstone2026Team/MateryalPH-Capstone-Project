// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_store_email_verification_confirmation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorStoreEmailVerificationConfirmation
    extends VendorStoreEmailVerificationConfirmation {
  @override
  final int lockVersion;
  @override
  final String email;
  @override
  final String code;

  factory _$VendorStoreEmailVerificationConfirmation(
          [void Function(VendorStoreEmailVerificationConfirmationBuilder)?
              updates]) =>
      (VendorStoreEmailVerificationConfirmationBuilder()..update(updates))
          ._build();

  _$VendorStoreEmailVerificationConfirmation._(
      {required this.lockVersion, required this.email, required this.code})
      : super._();
  @override
  VendorStoreEmailVerificationConfirmation rebuild(
          void Function(VendorStoreEmailVerificationConfirmationBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorStoreEmailVerificationConfirmationBuilder toBuilder() =>
      VendorStoreEmailVerificationConfirmationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorStoreEmailVerificationConfirmation &&
        lockVersion == other.lockVersion &&
        email == other.email &&
        code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'VendorStoreEmailVerificationConfirmation')
          ..add('lockVersion', lockVersion)
          ..add('email', email)
          ..add('code', code))
        .toString();
  }
}

class VendorStoreEmailVerificationConfirmationBuilder
    implements
        Builder<VendorStoreEmailVerificationConfirmation,
            VendorStoreEmailVerificationConfirmationBuilder> {
  _$VendorStoreEmailVerificationConfirmation? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  VendorStoreEmailVerificationConfirmationBuilder() {
    VendorStoreEmailVerificationConfirmation._defaults(this);
  }

  VendorStoreEmailVerificationConfirmationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _email = $v.email;
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorStoreEmailVerificationConfirmation other) {
    _$v = other as _$VendorStoreEmailVerificationConfirmation;
  }

  @override
  void update(
      void Function(VendorStoreEmailVerificationConfirmationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorStoreEmailVerificationConfirmation build() => _build();

  _$VendorStoreEmailVerificationConfirmation _build() {
    final _$result = _$v ??
        _$VendorStoreEmailVerificationConfirmation._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(lockVersion,
              r'VendorStoreEmailVerificationConfirmation', 'lockVersion'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'VendorStoreEmailVerificationConfirmation', 'email'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'VendorStoreEmailVerificationConfirmation', 'code'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
