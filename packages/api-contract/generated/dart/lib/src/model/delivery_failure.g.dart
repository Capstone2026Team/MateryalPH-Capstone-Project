// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_failure.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeliveryFailure extends DeliveryFailure {
  @override
  final String id;
  @override
  final String channel;
  @override
  final String state;
  @override
  final int attemptCount;
  @override
  final String? failureCode;
  @override
  final String updatedAt;

  factory _$DeliveryFailure([void Function(DeliveryFailureBuilder)? updates]) =>
      (DeliveryFailureBuilder()..update(updates))._build();

  _$DeliveryFailure._(
      {required this.id,
      required this.channel,
      required this.state,
      required this.attemptCount,
      this.failureCode,
      required this.updatedAt})
      : super._();
  @override
  DeliveryFailure rebuild(void Function(DeliveryFailureBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeliveryFailureBuilder toBuilder() => DeliveryFailureBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeliveryFailure &&
        id == other.id &&
        channel == other.channel &&
        state == other.state &&
        attemptCount == other.attemptCount &&
        failureCode == other.failureCode &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, channel.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, attemptCount.hashCode);
    _$hash = $jc(_$hash, failureCode.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeliveryFailure')
          ..add('id', id)
          ..add('channel', channel)
          ..add('state', state)
          ..add('attemptCount', attemptCount)
          ..add('failureCode', failureCode)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class DeliveryFailureBuilder
    implements Builder<DeliveryFailure, DeliveryFailureBuilder> {
  _$DeliveryFailure? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _channel;
  String? get channel => _$this._channel;
  set channel(String? channel) => _$this._channel = channel;

  String? _state;
  String? get state => _$this._state;
  set state(String? state) => _$this._state = state;

  int? _attemptCount;
  int? get attemptCount => _$this._attemptCount;
  set attemptCount(int? attemptCount) => _$this._attemptCount = attemptCount;

  String? _failureCode;
  String? get failureCode => _$this._failureCode;
  set failureCode(String? failureCode) => _$this._failureCode = failureCode;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  DeliveryFailureBuilder() {
    DeliveryFailure._defaults(this);
  }

  DeliveryFailureBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _channel = $v.channel;
      _state = $v.state;
      _attemptCount = $v.attemptCount;
      _failureCode = $v.failureCode;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeliveryFailure other) {
    _$v = other as _$DeliveryFailure;
  }

  @override
  void update(void Function(DeliveryFailureBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeliveryFailure build() => _build();

  _$DeliveryFailure _build() {
    final _$result = _$v ??
        _$DeliveryFailure._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'DeliveryFailure', 'id'),
          channel: BuiltValueNullFieldError.checkNotNull(
              channel, r'DeliveryFailure', 'channel'),
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'DeliveryFailure', 'state'),
          attemptCount: BuiltValueNullFieldError.checkNotNull(
              attemptCount, r'DeliveryFailure', 'attemptCount'),
          failureCode: failureCode,
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'DeliveryFailure', 'updatedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
