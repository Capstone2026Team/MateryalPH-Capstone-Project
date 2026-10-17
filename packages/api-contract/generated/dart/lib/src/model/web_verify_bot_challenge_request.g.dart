// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_verify_bot_challenge_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const WebVerifyBotChallengeRequestPortalEnum
    _$webVerifyBotChallengeRequestPortalEnum_VENDOR =
    const WebVerifyBotChallengeRequestPortalEnum._('VENDOR');
const WebVerifyBotChallengeRequestPortalEnum
    _$webVerifyBotChallengeRequestPortalEnum_ADMIN =
    const WebVerifyBotChallengeRequestPortalEnum._('ADMIN');

WebVerifyBotChallengeRequestPortalEnum
    _$webVerifyBotChallengeRequestPortalEnumValueOf(String name) {
  switch (name) {
    case 'VENDOR':
      return _$webVerifyBotChallengeRequestPortalEnum_VENDOR;
    case 'ADMIN':
      return _$webVerifyBotChallengeRequestPortalEnum_ADMIN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WebVerifyBotChallengeRequestPortalEnum>
    _$webVerifyBotChallengeRequestPortalEnumValues = BuiltSet<
        WebVerifyBotChallengeRequestPortalEnum>(const <WebVerifyBotChallengeRequestPortalEnum>[
  _$webVerifyBotChallengeRequestPortalEnum_VENDOR,
  _$webVerifyBotChallengeRequestPortalEnum_ADMIN,
]);

Serializer<WebVerifyBotChallengeRequestPortalEnum>
    _$webVerifyBotChallengeRequestPortalEnumSerializer =
    _$WebVerifyBotChallengeRequestPortalEnumSerializer();

class _$WebVerifyBotChallengeRequestPortalEnumSerializer
    implements PrimitiveSerializer<WebVerifyBotChallengeRequestPortalEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VENDOR': 'VENDOR',
    'ADMIN': 'ADMIN',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VENDOR': 'VENDOR',
    'ADMIN': 'ADMIN',
  };

  @override
  final Iterable<Type> types = const <Type>[
    WebVerifyBotChallengeRequestPortalEnum
  ];
  @override
  final String wireName = 'WebVerifyBotChallengeRequestPortalEnum';

  @override
  Object serialize(Serializers serializers,
          WebVerifyBotChallengeRequestPortalEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WebVerifyBotChallengeRequestPortalEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WebVerifyBotChallengeRequestPortalEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WebVerifyBotChallengeRequest extends WebVerifyBotChallengeRequest {
  @override
  final String email;
  @override
  final String code;
  @override
  final WebVerifyBotChallengeRequestPortalEnum? portal;

  factory _$WebVerifyBotChallengeRequest(
          [void Function(WebVerifyBotChallengeRequestBuilder)? updates]) =>
      (WebVerifyBotChallengeRequestBuilder()..update(updates))._build();

  _$WebVerifyBotChallengeRequest._(
      {required this.email, required this.code, this.portal})
      : super._();
  @override
  WebVerifyBotChallengeRequest rebuild(
          void Function(WebVerifyBotChallengeRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WebVerifyBotChallengeRequestBuilder toBuilder() =>
      WebVerifyBotChallengeRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WebVerifyBotChallengeRequest &&
        email == other.email &&
        code == other.code &&
        portal == other.portal;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, portal.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WebVerifyBotChallengeRequest')
          ..add('email', email)
          ..add('code', code)
          ..add('portal', portal))
        .toString();
  }
}

class WebVerifyBotChallengeRequestBuilder
    implements
        Builder<WebVerifyBotChallengeRequest,
            WebVerifyBotChallengeRequestBuilder> {
  _$WebVerifyBotChallengeRequest? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  WebVerifyBotChallengeRequestPortalEnum? _portal;
  WebVerifyBotChallengeRequestPortalEnum? get portal => _$this._portal;
  set portal(WebVerifyBotChallengeRequestPortalEnum? portal) =>
      _$this._portal = portal;

  WebVerifyBotChallengeRequestBuilder() {
    WebVerifyBotChallengeRequest._defaults(this);
  }

  WebVerifyBotChallengeRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _code = $v.code;
      _portal = $v.portal;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WebVerifyBotChallengeRequest other) {
    _$v = other as _$WebVerifyBotChallengeRequest;
  }

  @override
  void update(void Function(WebVerifyBotChallengeRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WebVerifyBotChallengeRequest build() => _build();

  _$WebVerifyBotChallengeRequest _build() {
    final _$result = _$v ??
        _$WebVerifyBotChallengeRequest._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'WebVerifyBotChallengeRequest', 'email'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'WebVerifyBotChallengeRequest', 'code'),
          portal: portal,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
