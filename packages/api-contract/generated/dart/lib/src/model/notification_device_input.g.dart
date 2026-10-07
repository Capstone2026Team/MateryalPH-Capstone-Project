// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_device_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const NotificationDeviceInputPlatformEnum
    _$notificationDeviceInputPlatformEnum_ANDROID =
    const NotificationDeviceInputPlatformEnum._('ANDROID');
const NotificationDeviceInputPlatformEnum
    _$notificationDeviceInputPlatformEnum_IOS =
    const NotificationDeviceInputPlatformEnum._('IOS');
const NotificationDeviceInputPlatformEnum
    _$notificationDeviceInputPlatformEnum_WEB =
    const NotificationDeviceInputPlatformEnum._('WEB');

NotificationDeviceInputPlatformEnum
    _$notificationDeviceInputPlatformEnumValueOf(String name) {
  switch (name) {
    case 'ANDROID':
      return _$notificationDeviceInputPlatformEnum_ANDROID;
    case 'IOS':
      return _$notificationDeviceInputPlatformEnum_IOS;
    case 'WEB':
      return _$notificationDeviceInputPlatformEnum_WEB;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<NotificationDeviceInputPlatformEnum>
    _$notificationDeviceInputPlatformEnumValues = BuiltSet<
        NotificationDeviceInputPlatformEnum>(const <NotificationDeviceInputPlatformEnum>[
  _$notificationDeviceInputPlatformEnum_ANDROID,
  _$notificationDeviceInputPlatformEnum_IOS,
  _$notificationDeviceInputPlatformEnum_WEB,
]);

Serializer<NotificationDeviceInputPlatformEnum>
    _$notificationDeviceInputPlatformEnumSerializer =
    _$NotificationDeviceInputPlatformEnumSerializer();

class _$NotificationDeviceInputPlatformEnumSerializer
    implements PrimitiveSerializer<NotificationDeviceInputPlatformEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ANDROID': 'ANDROID',
    'IOS': 'IOS',
    'WEB': 'WEB',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ANDROID': 'ANDROID',
    'IOS': 'IOS',
    'WEB': 'WEB',
  };

  @override
  final Iterable<Type> types = const <Type>[
    NotificationDeviceInputPlatformEnum
  ];
  @override
  final String wireName = 'NotificationDeviceInputPlatformEnum';

  @override
  Object serialize(
          Serializers serializers, NotificationDeviceInputPlatformEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  NotificationDeviceInputPlatformEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      NotificationDeviceInputPlatformEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$NotificationDeviceInput extends NotificationDeviceInput {
  @override
  final NotificationDeviceInputPlatformEnum platform;
  @override
  final String token;

  factory _$NotificationDeviceInput(
          [void Function(NotificationDeviceInputBuilder)? updates]) =>
      (NotificationDeviceInputBuilder()..update(updates))._build();

  _$NotificationDeviceInput._({required this.platform, required this.token})
      : super._();
  @override
  NotificationDeviceInput rebuild(
          void Function(NotificationDeviceInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationDeviceInputBuilder toBuilder() =>
      NotificationDeviceInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationDeviceInput &&
        platform == other.platform &&
        token == other.token;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, platform.hashCode);
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificationDeviceInput')
          ..add('platform', platform)
          ..add('token', token))
        .toString();
  }
}

class NotificationDeviceInputBuilder
    implements
        Builder<NotificationDeviceInput, NotificationDeviceInputBuilder> {
  _$NotificationDeviceInput? _$v;

  NotificationDeviceInputPlatformEnum? _platform;
  NotificationDeviceInputPlatformEnum? get platform => _$this._platform;
  set platform(NotificationDeviceInputPlatformEnum? platform) =>
      _$this._platform = platform;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  NotificationDeviceInputBuilder() {
    NotificationDeviceInput._defaults(this);
  }

  NotificationDeviceInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _platform = $v.platform;
      _token = $v.token;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationDeviceInput other) {
    _$v = other as _$NotificationDeviceInput;
  }

  @override
  void update(void Function(NotificationDeviceInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationDeviceInput build() => _build();

  _$NotificationDeviceInput _build() {
    final _$result = _$v ??
        _$NotificationDeviceInput._(
          platform: BuiltValueNullFieldError.checkNotNull(
              platform, r'NotificationDeviceInput', 'platform'),
          token: BuiltValueNullFieldError.checkNotNull(
              token, r'NotificationDeviceInput', 'token'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
