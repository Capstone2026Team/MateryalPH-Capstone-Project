// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_device_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NotificationDeviceResult extends NotificationDeviceResult {
  @override
  final String id;

  factory _$NotificationDeviceResult(
          [void Function(NotificationDeviceResultBuilder)? updates]) =>
      (NotificationDeviceResultBuilder()..update(updates))._build();

  _$NotificationDeviceResult._({required this.id}) : super._();
  @override
  NotificationDeviceResult rebuild(
          void Function(NotificationDeviceResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationDeviceResultBuilder toBuilder() =>
      NotificationDeviceResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationDeviceResult && id == other.id;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificationDeviceResult')
          ..add('id', id))
        .toString();
  }
}

class NotificationDeviceResultBuilder
    implements
        Builder<NotificationDeviceResult, NotificationDeviceResultBuilder> {
  _$NotificationDeviceResult? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  NotificationDeviceResultBuilder() {
    NotificationDeviceResult._defaults(this);
  }

  NotificationDeviceResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationDeviceResult other) {
    _$v = other as _$NotificationDeviceResult;
  }

  @override
  void update(void Function(NotificationDeviceResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationDeviceResult build() => _build();

  _$NotificationDeviceResult _build() {
    final _$result = _$v ??
        _$NotificationDeviceResult._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'NotificationDeviceResult', 'id'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
