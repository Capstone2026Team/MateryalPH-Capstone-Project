// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_realtime.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatRealtime extends ChatRealtime {
  @override
  final String? inboxChannel;
  @override
  final bool enabled;
  @override
  final String? key;
  @override
  final String? host;
  @override
  final int port;
  @override
  final String scheme;

  factory _$ChatRealtime([void Function(ChatRealtimeBuilder)? updates]) =>
      (ChatRealtimeBuilder()..update(updates))._build();

  _$ChatRealtime._(
      {this.inboxChannel,
      required this.enabled,
      this.key,
      this.host,
      required this.port,
      required this.scheme})
      : super._();
  @override
  ChatRealtime rebuild(void Function(ChatRealtimeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatRealtimeBuilder toBuilder() => ChatRealtimeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatRealtime &&
        inboxChannel == other.inboxChannel &&
        enabled == other.enabled &&
        key == other.key &&
        host == other.host &&
        port == other.port &&
        scheme == other.scheme;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, inboxChannel.hashCode);
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, host.hashCode);
    _$hash = $jc(_$hash, port.hashCode);
    _$hash = $jc(_$hash, scheme.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatRealtime')
          ..add('inboxChannel', inboxChannel)
          ..add('enabled', enabled)
          ..add('key', key)
          ..add('host', host)
          ..add('port', port)
          ..add('scheme', scheme))
        .toString();
  }
}

class ChatRealtimeBuilder
    implements Builder<ChatRealtime, ChatRealtimeBuilder> {
  _$ChatRealtime? _$v;

  String? _inboxChannel;
  String? get inboxChannel => _$this._inboxChannel;
  set inboxChannel(String? inboxChannel) => _$this._inboxChannel = inboxChannel;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  String? _host;
  String? get host => _$this._host;
  set host(String? host) => _$this._host = host;

  int? _port;
  int? get port => _$this._port;
  set port(int? port) => _$this._port = port;

  String? _scheme;
  String? get scheme => _$this._scheme;
  set scheme(String? scheme) => _$this._scheme = scheme;

  ChatRealtimeBuilder() {
    ChatRealtime._defaults(this);
  }

  ChatRealtimeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _inboxChannel = $v.inboxChannel;
      _enabled = $v.enabled;
      _key = $v.key;
      _host = $v.host;
      _port = $v.port;
      _scheme = $v.scheme;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatRealtime other) {
    _$v = other as _$ChatRealtime;
  }

  @override
  void update(void Function(ChatRealtimeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatRealtime build() => _build();

  _$ChatRealtime _build() {
    final _$result = _$v ??
        _$ChatRealtime._(
          inboxChannel: inboxChannel,
          enabled: BuiltValueNullFieldError.checkNotNull(
              enabled, r'ChatRealtime', 'enabled'),
          key: key,
          host: host,
          port: BuiltValueNullFieldError.checkNotNull(
              port, r'ChatRealtime', 'port'),
          scheme: BuiltValueNullFieldError.checkNotNull(
              scheme, r'ChatRealtime', 'scheme'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
