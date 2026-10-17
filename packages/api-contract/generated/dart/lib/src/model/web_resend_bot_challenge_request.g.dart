// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_resend_bot_challenge_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const WebResendBotChallengeRequestPortalEnum
    _$webResendBotChallengeRequestPortalEnum_VENDOR =
    const WebResendBotChallengeRequestPortalEnum._('VENDOR');
const WebResendBotChallengeRequestPortalEnum
    _$webResendBotChallengeRequestPortalEnum_ADMIN =
    const WebResendBotChallengeRequestPortalEnum._('ADMIN');

WebResendBotChallengeRequestPortalEnum
    _$webResendBotChallengeRequestPortalEnumValueOf(String name) {
  switch (name) {
    case 'VENDOR':
      return _$webResendBotChallengeRequestPortalEnum_VENDOR;
    case 'ADMIN':
      return _$webResendBotChallengeRequestPortalEnum_ADMIN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WebResendBotChallengeRequestPortalEnum>
    _$webResendBotChallengeRequestPortalEnumValues = BuiltSet<
        WebResendBotChallengeRequestPortalEnum>(const <WebResendBotChallengeRequestPortalEnum>[
  _$webResendBotChallengeRequestPortalEnum_VENDOR,
  _$webResendBotChallengeRequestPortalEnum_ADMIN,
]);

Serializer<WebResendBotChallengeRequestPortalEnum>
    _$webResendBotChallengeRequestPortalEnumSerializer =
    _$WebResendBotChallengeRequestPortalEnumSerializer();

class _$WebResendBotChallengeRequestPortalEnumSerializer
    implements PrimitiveSerializer<WebResendBotChallengeRequestPortalEnum> {
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
    WebResendBotChallengeRequestPortalEnum
  ];
  @override
  final String wireName = 'WebResendBotChallengeRequestPortalEnum';

  @override
  Object serialize(Serializers serializers,
          WebResendBotChallengeRequestPortalEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WebResendBotChallengeRequestPortalEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WebResendBotChallengeRequestPortalEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WebResendBotChallengeRequest extends WebResendBotChallengeRequest {
  @override
  final String email;
  @override
  final WebResendBotChallengeRequestPortalEnum? portal;

  factory _$WebResendBotChallengeRequest(
          [void Function(WebResendBotChallengeRequestBuilder)? updates]) =>
      (WebResendBotChallengeRequestBuilder()..update(updates))._build();

  _$WebResendBotChallengeRequest._({required this.email, this.portal})
      : super._();
  @override
  WebResendBotChallengeRequest rebuild(
          void Function(WebResendBotChallengeRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WebResendBotChallengeRequestBuilder toBuilder() =>
      WebResendBotChallengeRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WebResendBotChallengeRequest &&
        email == other.email &&
        portal == other.portal;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, portal.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WebResendBotChallengeRequest')
          ..add('email', email)
          ..add('portal', portal))
        .toString();
  }
}

class WebResendBotChallengeRequestBuilder
    implements
        Builder<WebResendBotChallengeRequest,
            WebResendBotChallengeRequestBuilder> {
  _$WebResendBotChallengeRequest? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  WebResendBotChallengeRequestPortalEnum? _portal;
  WebResendBotChallengeRequestPortalEnum? get portal => _$this._portal;
  set portal(WebResendBotChallengeRequestPortalEnum? portal) =>
      _$this._portal = portal;

  WebResendBotChallengeRequestBuilder() {
    WebResendBotChallengeRequest._defaults(this);
  }

  WebResendBotChallengeRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _portal = $v.portal;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WebResendBotChallengeRequest other) {
    _$v = other as _$WebResendBotChallengeRequest;
  }

  @override
  void update(void Function(WebResendBotChallengeRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WebResendBotChallengeRequest build() => _build();

  _$WebResendBotChallengeRequest _build() {
    final _$result = _$v ??
        _$WebResendBotChallengeRequest._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'WebResendBotChallengeRequest', 'email'),
          portal: portal,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
