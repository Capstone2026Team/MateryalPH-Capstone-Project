// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_action.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NotificationAction extends NotificationAction {
  @override
  final bool? read;
  @override
  final bool? revoked;

  factory _$NotificationAction(
          [void Function(NotificationActionBuilder)? updates]) =>
      (NotificationActionBuilder()..update(updates))._build();

  _$NotificationAction._({this.read, this.revoked}) : super._();
  @override
  NotificationAction rebuild(
          void Function(NotificationActionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationActionBuilder toBuilder() =>
      NotificationActionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationAction &&
        read == other.read &&
        revoked == other.revoked;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, read.hashCode);
    _$hash = $jc(_$hash, revoked.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificationAction')
          ..add('read', read)
          ..add('revoked', revoked))
        .toString();
  }
}

class NotificationActionBuilder
    implements Builder<NotificationAction, NotificationActionBuilder> {
  _$NotificationAction? _$v;

  bool? _read;
  bool? get read => _$this._read;
  set read(bool? read) => _$this._read = read;

  bool? _revoked;
  bool? get revoked => _$this._revoked;
  set revoked(bool? revoked) => _$this._revoked = revoked;

  NotificationActionBuilder() {
    NotificationAction._defaults(this);
  }

  NotificationActionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _read = $v.read;
      _revoked = $v.revoked;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationAction other) {
    _$v = other as _$NotificationAction;
  }

  @override
  void update(void Function(NotificationActionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationAction build() => _build();

  _$NotificationAction _build() {
    final _$result = _$v ??
        _$NotificationAction._(
          read: read,
          revoked: revoked,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
