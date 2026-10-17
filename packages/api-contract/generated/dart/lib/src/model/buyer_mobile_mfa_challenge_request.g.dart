// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_mobile_mfa_challenge_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerMobileMfaChallengeRequest extends BuyerMobileMfaChallengeRequest {
  @override
  final String challengeToken;
  @override
  final String code;

  factory _$BuyerMobileMfaChallengeRequest(
          [void Function(BuyerMobileMfaChallengeRequestBuilder)? updates]) =>
      (BuyerMobileMfaChallengeRequestBuilder()..update(updates))._build();

  _$BuyerMobileMfaChallengeRequest._(
      {required this.challengeToken, required this.code})
      : super._();
  @override
  BuyerMobileMfaChallengeRequest rebuild(
          void Function(BuyerMobileMfaChallengeRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerMobileMfaChallengeRequestBuilder toBuilder() =>
      BuyerMobileMfaChallengeRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerMobileMfaChallengeRequest &&
        challengeToken == other.challengeToken &&
        code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, challengeToken.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerMobileMfaChallengeRequest')
          ..add('challengeToken', challengeToken)
          ..add('code', code))
        .toString();
  }
}

class BuyerMobileMfaChallengeRequestBuilder
    implements
        Builder<BuyerMobileMfaChallengeRequest,
            BuyerMobileMfaChallengeRequestBuilder> {
  _$BuyerMobileMfaChallengeRequest? _$v;

  String? _challengeToken;
  String? get challengeToken => _$this._challengeToken;
  set challengeToken(String? challengeToken) =>
      _$this._challengeToken = challengeToken;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  BuyerMobileMfaChallengeRequestBuilder() {
    BuyerMobileMfaChallengeRequest._defaults(this);
  }

  BuyerMobileMfaChallengeRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _challengeToken = $v.challengeToken;
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerMobileMfaChallengeRequest other) {
    _$v = other as _$BuyerMobileMfaChallengeRequest;
  }

  @override
  void update(void Function(BuyerMobileMfaChallengeRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerMobileMfaChallengeRequest build() => _build();

  _$BuyerMobileMfaChallengeRequest _build() {
    final _$result = _$v ??
        _$BuyerMobileMfaChallengeRequest._(
          challengeToken: BuiltValueNullFieldError.checkNotNull(challengeToken,
              r'BuyerMobileMfaChallengeRequest', 'challengeToken'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'BuyerMobileMfaChallengeRequest', 'code'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
