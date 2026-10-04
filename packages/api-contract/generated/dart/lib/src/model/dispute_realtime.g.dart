// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_realtime.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputeRealtime extends DisputeRealtime {
  @override
  final String? channel;
  @override
  final bool enabled;
  @override
  final String? key;
  @override
  final String? host;
  @override
  final int? port;
  @override
  final String? scheme;

  factory _$DisputeRealtime([void Function(DisputeRealtimeBuilder)? updates]) =>
      (DisputeRealtimeBuilder()..update(updates))._build();

  _$DisputeRealtime._(
      {this.channel,
      required this.enabled,
      this.key,
      this.host,
      this.port,
      this.scheme})
      : super._();
  @override
  DisputeRealtime rebuild(void Function(DisputeRealtimeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeRealtimeBuilder toBuilder() => DisputeRealtimeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeRealtime &&
        channel == other.channel &&
        enabled == other.enabled &&
        key == other.key &&
        host == other.host &&
        port == other.port &&
        scheme == other.scheme;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, channel.hashCode);
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
    return (newBuiltValueToStringHelper(r'DisputeRealtime')
          ..add('channel', channel)
          ..add('enabled', enabled)
          ..add('key', key)
          ..add('host', host)
          ..add('port', port)
          ..add('scheme', scheme))
        .toString();
  }
}

class DisputeRealtimeBuilder
    implements Builder<DisputeRealtime, DisputeRealtimeBuilder> {
  _$DisputeRealtime? _$v;

  String? _channel;
  String? get channel => _$this._channel;
  set channel(String? channel) => _$this._channel = channel;

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

  DisputeRealtimeBuilder() {
    DisputeRealtime._defaults(this);
  }

  DisputeRealtimeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _channel = $v.channel;
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
  void replace(DisputeRealtime other) {
    _$v = other as _$DisputeRealtime;
  }

  @override
  void update(void Function(DisputeRealtimeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeRealtime build() => _build();

  _$DisputeRealtime _build() {
    final _$result = _$v ??
        _$DisputeRealtime._(
          channel: channel,
          enabled: BuiltValueNullFieldError.checkNotNull(
              enabled, r'DisputeRealtime', 'enabled'),
          key: key,
          host: host,
          port: port,
          scheme: scheme,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
