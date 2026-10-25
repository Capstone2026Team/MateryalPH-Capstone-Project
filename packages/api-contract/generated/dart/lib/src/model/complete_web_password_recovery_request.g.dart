// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_web_password_recovery_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CompleteWebPasswordRecoveryRequest
    extends CompleteWebPasswordRecoveryRequest {
  @override
  final String email;
  @override
  final WebPasswordRecoveryPortal portal;
  @override
  final String password;
  @override
  final String passwordConfirmation;

  factory _$CompleteWebPasswordRecoveryRequest(
          [void Function(CompleteWebPasswordRecoveryRequestBuilder)?
              updates]) =>
      (CompleteWebPasswordRecoveryRequestBuilder()..update(updates))._build();

  _$CompleteWebPasswordRecoveryRequest._(
      {required this.email,
      required this.portal,
      required this.password,
      required this.passwordConfirmation})
      : super._();
  @override
  CompleteWebPasswordRecoveryRequest rebuild(
          void Function(CompleteWebPasswordRecoveryRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CompleteWebPasswordRecoveryRequestBuilder toBuilder() =>
      CompleteWebPasswordRecoveryRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CompleteWebPasswordRecoveryRequest &&
        email == other.email &&
        portal == other.portal &&
        password == other.password &&
        passwordConfirmation == other.passwordConfirmation;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, portal.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, passwordConfirmation.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CompleteWebPasswordRecoveryRequest')
          ..add('email', email)
          ..add('portal', portal)
          ..add('password', password)
          ..add('passwordConfirmation', passwordConfirmation))
        .toString();
  }
}

class CompleteWebPasswordRecoveryRequestBuilder
    implements
        Builder<CompleteWebPasswordRecoveryRequest,
            CompleteWebPasswordRecoveryRequestBuilder> {
  _$CompleteWebPasswordRecoveryRequest? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  WebPasswordRecoveryPortal? _portal;
  WebPasswordRecoveryPortal? get portal => _$this._portal;
  set portal(WebPasswordRecoveryPortal? portal) => _$this._portal = portal;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  String? _passwordConfirmation;
  String? get passwordConfirmation => _$this._passwordConfirmation;
  set passwordConfirmation(String? passwordConfirmation) =>
      _$this._passwordConfirmation = passwordConfirmation;

  CompleteWebPasswordRecoveryRequestBuilder() {
    CompleteWebPasswordRecoveryRequest._defaults(this);
  }

  CompleteWebPasswordRecoveryRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _portal = $v.portal;
      _password = $v.password;
      _passwordConfirmation = $v.passwordConfirmation;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CompleteWebPasswordRecoveryRequest other) {
    _$v = other as _$CompleteWebPasswordRecoveryRequest;
  }

  @override
  void update(
      void Function(CompleteWebPasswordRecoveryRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CompleteWebPasswordRecoveryRequest build() => _build();

  _$CompleteWebPasswordRecoveryRequest _build() {
    final _$result = _$v ??
        _$CompleteWebPasswordRecoveryRequest._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'CompleteWebPasswordRecoveryRequest', 'email'),
          portal: BuiltValueNullFieldError.checkNotNull(
              portal, r'CompleteWebPasswordRecoveryRequest', 'portal'),
          password: BuiltValueNullFieldError.checkNotNull(
              password, r'CompleteWebPasswordRecoveryRequest', 'password'),
          passwordConfirmation: BuiltValueNullFieldError.checkNotNull(
              passwordConfirmation,
              r'CompleteWebPasswordRecoveryRequest',
              'passwordConfirmation'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
