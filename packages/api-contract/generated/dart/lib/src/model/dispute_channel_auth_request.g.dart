// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_channel_auth_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputeChannelAuthRequest extends DisputeChannelAuthRequest {
  @override
  final String socketId;
  @override
  final String channelName;

  factory _$DisputeChannelAuthRequest(
          [void Function(DisputeChannelAuthRequestBuilder)? updates]) =>
      (DisputeChannelAuthRequestBuilder()..update(updates))._build();

  _$DisputeChannelAuthRequest._(
      {required this.socketId, required this.channelName})
      : super._();
  @override
  DisputeChannelAuthRequest rebuild(
          void Function(DisputeChannelAuthRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeChannelAuthRequestBuilder toBuilder() =>
      DisputeChannelAuthRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeChannelAuthRequest &&
        socketId == other.socketId &&
        channelName == other.channelName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, socketId.hashCode);
    _$hash = $jc(_$hash, channelName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeChannelAuthRequest')
          ..add('socketId', socketId)
          ..add('channelName', channelName))
        .toString();
  }
}

class DisputeChannelAuthRequestBuilder
    implements
        Builder<DisputeChannelAuthRequest, DisputeChannelAuthRequestBuilder> {
  _$DisputeChannelAuthRequest? _$v;

  String? _socketId;
  String? get socketId => _$this._socketId;
  set socketId(String? socketId) => _$this._socketId = socketId;

  String? _channelName;
  String? get channelName => _$this._channelName;
  set channelName(String? channelName) => _$this._channelName = channelName;

  DisputeChannelAuthRequestBuilder() {
    DisputeChannelAuthRequest._defaults(this);
  }

  DisputeChannelAuthRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _socketId = $v.socketId;
      _channelName = $v.channelName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeChannelAuthRequest other) {
    _$v = other as _$DisputeChannelAuthRequest;
  }

  @override
  void update(void Function(DisputeChannelAuthRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeChannelAuthRequest build() => _build();

  _$DisputeChannelAuthRequest _build() {
    final _$result = _$v ??
        _$DisputeChannelAuthRequest._(
          socketId: BuiltValueNullFieldError.checkNotNull(
              socketId, r'DisputeChannelAuthRequest', 'socketId'),
          channelName: BuiltValueNullFieldError.checkNotNull(
              channelName, r'DisputeChannelAuthRequest', 'channelName'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
