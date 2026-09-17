// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_store_email_confirmation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorStoreEmailConfirmation extends VendorStoreEmailConfirmation {
  @override
  final String email;
  @override
  final String code;

  factory _$VendorStoreEmailConfirmation(
          [void Function(VendorStoreEmailConfirmationBuilder)? updates]) =>
      (VendorStoreEmailConfirmationBuilder()..update(updates))._build();

  _$VendorStoreEmailConfirmation._({required this.email, required this.code})
      : super._();
  @override
  VendorStoreEmailConfirmation rebuild(
          void Function(VendorStoreEmailConfirmationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorStoreEmailConfirmationBuilder toBuilder() =>
      VendorStoreEmailConfirmationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorStoreEmailConfirmation &&
        email == other.email &&
        code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorStoreEmailConfirmation')
          ..add('email', email)
          ..add('code', code))
        .toString();
  }
}

class VendorStoreEmailConfirmationBuilder
    implements
        Builder<VendorStoreEmailConfirmation,
            VendorStoreEmailConfirmationBuilder> {
  _$VendorStoreEmailConfirmation? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  VendorStoreEmailConfirmationBuilder() {
    VendorStoreEmailConfirmation._defaults(this);
  }

  VendorStoreEmailConfirmationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorStoreEmailConfirmation other) {
    _$v = other as _$VendorStoreEmailConfirmation;
  }

  @override
  void update(void Function(VendorStoreEmailConfirmationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorStoreEmailConfirmation build() => _build();

  _$VendorStoreEmailConfirmation _build() {
    final _$result = _$v ??
        _$VendorStoreEmailConfirmation._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'VendorStoreEmailConfirmation', 'email'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'VendorStoreEmailConfirmation', 'code'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
