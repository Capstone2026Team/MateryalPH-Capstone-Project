// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_mobile_mfa_recovery_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerMobileMfaRecoveryRequest extends BuyerMobileMfaRecoveryRequest {
  @override
  final String challengeToken;
  @override
  final String recoveryCode;

  factory _$BuyerMobileMfaRecoveryRequest(
          [void Function(BuyerMobileMfaRecoveryRequestBuilder)? updates]) =>
      (BuyerMobileMfaRecoveryRequestBuilder()..update(updates))._build();

  _$BuyerMobileMfaRecoveryRequest._(
      {required this.challengeToken, required this.recoveryCode})
      : super._();
  @override
  BuyerMobileMfaRecoveryRequest rebuild(
          void Function(BuyerMobileMfaRecoveryRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerMobileMfaRecoveryRequestBuilder toBuilder() =>
      BuyerMobileMfaRecoveryRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerMobileMfaRecoveryRequest &&
        challengeToken == other.challengeToken &&
        recoveryCode == other.recoveryCode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, challengeToken.hashCode);
    _$hash = $jc(_$hash, recoveryCode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerMobileMfaRecoveryRequest')
          ..add('challengeToken', challengeToken)
          ..add('recoveryCode', recoveryCode))
        .toString();
  }
}

class BuyerMobileMfaRecoveryRequestBuilder
    implements
        Builder<BuyerMobileMfaRecoveryRequest,
            BuyerMobileMfaRecoveryRequestBuilder> {
  _$BuyerMobileMfaRecoveryRequest? _$v;

  String? _challengeToken;
  String? get challengeToken => _$this._challengeToken;
  set challengeToken(String? challengeToken) =>
      _$this._challengeToken = challengeToken;

  String? _recoveryCode;
  String? get recoveryCode => _$this._recoveryCode;
  set recoveryCode(String? recoveryCode) => _$this._recoveryCode = recoveryCode;

  BuyerMobileMfaRecoveryRequestBuilder() {
    BuyerMobileMfaRecoveryRequest._defaults(this);
  }

  BuyerMobileMfaRecoveryRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _challengeToken = $v.challengeToken;
      _recoveryCode = $v.recoveryCode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerMobileMfaRecoveryRequest other) {
    _$v = other as _$BuyerMobileMfaRecoveryRequest;
  }

  @override
  void update(void Function(BuyerMobileMfaRecoveryRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerMobileMfaRecoveryRequest build() => _build();

  _$BuyerMobileMfaRecoveryRequest _build() {
    final _$result = _$v ??
        _$BuyerMobileMfaRecoveryRequest._(
          challengeToken: BuiltValueNullFieldError.checkNotNull(challengeToken,
              r'BuyerMobileMfaRecoveryRequest', 'challengeToken'),
          recoveryCode: BuiltValueNullFieldError.checkNotNull(
              recoveryCode, r'BuyerMobileMfaRecoveryRequest', 'recoveryCode'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
