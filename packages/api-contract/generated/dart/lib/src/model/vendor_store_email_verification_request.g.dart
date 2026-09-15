// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_store_email_verification_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorStoreEmailVerificationRequest
    extends VendorStoreEmailVerificationRequest {
  @override
  final int lockVersion;
  @override
  final String email;

  factory _$VendorStoreEmailVerificationRequest(
          [void Function(VendorStoreEmailVerificationRequestBuilder)?
              updates]) =>
      (VendorStoreEmailVerificationRequestBuilder()..update(updates))._build();

  _$VendorStoreEmailVerificationRequest._(
      {required this.lockVersion, required this.email})
      : super._();
  @override
  VendorStoreEmailVerificationRequest rebuild(
          void Function(VendorStoreEmailVerificationRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorStoreEmailVerificationRequestBuilder toBuilder() =>
      VendorStoreEmailVerificationRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorStoreEmailVerificationRequest &&
        lockVersion == other.lockVersion &&
        email == other.email;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorStoreEmailVerificationRequest')
          ..add('lockVersion', lockVersion)
          ..add('email', email))
        .toString();
  }
}

class VendorStoreEmailVerificationRequestBuilder
    implements
        Builder<VendorStoreEmailVerificationRequest,
            VendorStoreEmailVerificationRequestBuilder> {
  _$VendorStoreEmailVerificationRequest? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  VendorStoreEmailVerificationRequestBuilder() {
    VendorStoreEmailVerificationRequest._defaults(this);
  }

  VendorStoreEmailVerificationRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _email = $v.email;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorStoreEmailVerificationRequest other) {
    _$v = other as _$VendorStoreEmailVerificationRequest;
  }

  @override
  void update(
      void Function(VendorStoreEmailVerificationRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorStoreEmailVerificationRequest build() => _build();

  _$VendorStoreEmailVerificationRequest _build() {
    final _$result = _$v ??
        _$VendorStoreEmailVerificationRequest._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(lockVersion,
              r'VendorStoreEmailVerificationRequest', 'lockVersion'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'VendorStoreEmailVerificationRequest', 'email'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
