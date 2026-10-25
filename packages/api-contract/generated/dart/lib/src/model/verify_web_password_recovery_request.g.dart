// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_web_password_recovery_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VerifyWebPasswordRecoveryRequest
    extends VerifyWebPasswordRecoveryRequest {
  @override
  final String email;
  @override
  final WebPasswordRecoveryPortal portal;
  @override
  final String? code;
  @override
  final String? recoveryCode;
  @override
  final String? challengeId;

  factory _$VerifyWebPasswordRecoveryRequest(
          [void Function(VerifyWebPasswordRecoveryRequestBuilder)? updates]) =>
      (VerifyWebPasswordRecoveryRequestBuilder()..update(updates))._build();

  _$VerifyWebPasswordRecoveryRequest._(
      {required this.email,
      required this.portal,
      this.code,
      this.recoveryCode,
      this.challengeId})
      : super._();
  @override
  VerifyWebPasswordRecoveryRequest rebuild(
          void Function(VerifyWebPasswordRecoveryRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VerifyWebPasswordRecoveryRequestBuilder toBuilder() =>
      VerifyWebPasswordRecoveryRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VerifyWebPasswordRecoveryRequest &&
        email == other.email &&
        portal == other.portal &&
        code == other.code &&
        recoveryCode == other.recoveryCode &&
        challengeId == other.challengeId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, portal.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, recoveryCode.hashCode);
    _$hash = $jc(_$hash, challengeId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VerifyWebPasswordRecoveryRequest')
          ..add('email', email)
          ..add('portal', portal)
          ..add('code', code)
          ..add('recoveryCode', recoveryCode)
          ..add('challengeId', challengeId))
        .toString();
  }
}

class VerifyWebPasswordRecoveryRequestBuilder
    implements
        Builder<VerifyWebPasswordRecoveryRequest,
            VerifyWebPasswordRecoveryRequestBuilder> {
  _$VerifyWebPasswordRecoveryRequest? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  WebPasswordRecoveryPortal? _portal;
  WebPasswordRecoveryPortal? get portal => _$this._portal;
  set portal(WebPasswordRecoveryPortal? portal) => _$this._portal = portal;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _recoveryCode;
  String? get recoveryCode => _$this._recoveryCode;
  set recoveryCode(String? recoveryCode) => _$this._recoveryCode = recoveryCode;

  String? _challengeId;
  String? get challengeId => _$this._challengeId;
  set challengeId(String? challengeId) => _$this._challengeId = challengeId;

  VerifyWebPasswordRecoveryRequestBuilder() {
    VerifyWebPasswordRecoveryRequest._defaults(this);
  }

  VerifyWebPasswordRecoveryRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _portal = $v.portal;
      _code = $v.code;
      _recoveryCode = $v.recoveryCode;
      _challengeId = $v.challengeId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VerifyWebPasswordRecoveryRequest other) {
    _$v = other as _$VerifyWebPasswordRecoveryRequest;
  }

  @override
  void update(void Function(VerifyWebPasswordRecoveryRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VerifyWebPasswordRecoveryRequest build() => _build();

  _$VerifyWebPasswordRecoveryRequest _build() {
    final _$result = _$v ??
        _$VerifyWebPasswordRecoveryRequest._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'VerifyWebPasswordRecoveryRequest', 'email'),
          portal: BuiltValueNullFieldError.checkNotNull(
              portal, r'VerifyWebPasswordRecoveryRequest', 'portal'),
          code: code,
          recoveryCode: recoveryCode,
          challengeId: challengeId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
