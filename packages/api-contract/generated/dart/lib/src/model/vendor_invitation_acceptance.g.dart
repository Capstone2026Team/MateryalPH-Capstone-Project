// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_invitation_acceptance.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorInvitationAcceptance extends VendorInvitationAcceptance {
  @override
  final String token;
  @override
  final String email;
  @override
  final String fullName;
  @override
  final String password;
  @override
  final String passwordConfirmation;

  factory _$VendorInvitationAcceptance(
          [void Function(VendorInvitationAcceptanceBuilder)? updates]) =>
      (VendorInvitationAcceptanceBuilder()..update(updates))._build();

  _$VendorInvitationAcceptance._(
      {required this.token,
      required this.email,
      required this.fullName,
      required this.password,
      required this.passwordConfirmation})
      : super._();
  @override
  VendorInvitationAcceptance rebuild(
          void Function(VendorInvitationAcceptanceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorInvitationAcceptanceBuilder toBuilder() =>
      VendorInvitationAcceptanceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorInvitationAcceptance &&
        token == other.token &&
        email == other.email &&
        fullName == other.fullName &&
        password == other.password &&
        passwordConfirmation == other.passwordConfirmation;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, passwordConfirmation.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorInvitationAcceptance')
          ..add('token', token)
          ..add('email', email)
          ..add('fullName', fullName)
          ..add('password', password)
          ..add('passwordConfirmation', passwordConfirmation))
        .toString();
  }
}

class VendorInvitationAcceptanceBuilder
    implements
        Builder<VendorInvitationAcceptance, VendorInvitationAcceptanceBuilder> {
  _$VendorInvitationAcceptance? _$v;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  String? _passwordConfirmation;
  String? get passwordConfirmation => _$this._passwordConfirmation;
  set passwordConfirmation(String? passwordConfirmation) =>
      _$this._passwordConfirmation = passwordConfirmation;

  VendorInvitationAcceptanceBuilder() {
    VendorInvitationAcceptance._defaults(this);
  }

  VendorInvitationAcceptanceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _token = $v.token;
      _email = $v.email;
      _fullName = $v.fullName;
      _password = $v.password;
      _passwordConfirmation = $v.passwordConfirmation;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorInvitationAcceptance other) {
    _$v = other as _$VendorInvitationAcceptance;
  }

  @override
  void update(void Function(VendorInvitationAcceptanceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorInvitationAcceptance build() => _build();

  _$VendorInvitationAcceptance _build() {
    final _$result = _$v ??
        _$VendorInvitationAcceptance._(
          token: BuiltValueNullFieldError.checkNotNull(
              token, r'VendorInvitationAcceptance', 'token'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'VendorInvitationAcceptance', 'email'),
          fullName: BuiltValueNullFieldError.checkNotNull(
              fullName, r'VendorInvitationAcceptance', 'fullName'),
          password: BuiltValueNullFieldError.checkNotNull(
              password, r'VendorInvitationAcceptance', 'password'),
          passwordConfirmation: BuiltValueNullFieldError.checkNotNull(
              passwordConfirmation,
              r'VendorInvitationAcceptance',
              'passwordConfirmation'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
