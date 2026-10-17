// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_bulk_read_action.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NotificationBulkReadAction extends NotificationBulkReadAction {
  @override
  final bool read;
  @override
  final int readCount;
  @override
  final String readAt;

  factory _$NotificationBulkReadAction(
          [void Function(NotificationBulkReadActionBuilder)? updates]) =>
      (NotificationBulkReadActionBuilder()..update(updates))._build();

  _$NotificationBulkReadAction._(
      {required this.read, required this.readCount, required this.readAt})
      : super._();
  @override
  NotificationBulkReadAction rebuild(
          void Function(NotificationBulkReadActionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationBulkReadActionBuilder toBuilder() =>
      NotificationBulkReadActionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationBulkReadAction &&
        read == other.read &&
        readCount == other.readCount &&
        readAt == other.readAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, read.hashCode);
    _$hash = $jc(_$hash, readCount.hashCode);
    _$hash = $jc(_$hash, readAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificationBulkReadAction')
          ..add('read', read)
          ..add('readCount', readCount)
          ..add('readAt', readAt))
        .toString();
  }
}

class NotificationBulkReadActionBuilder
    implements
        Builder<NotificationBulkReadAction, NotificationBulkReadActionBuilder> {
  _$NotificationBulkReadAction? _$v;

  bool? _read;
  bool? get read => _$this._read;
  set read(bool? read) => _$this._read = read;

  int? _readCount;
  int? get readCount => _$this._readCount;
  set readCount(int? readCount) => _$this._readCount = readCount;

  String? _readAt;
  String? get readAt => _$this._readAt;
  set readAt(String? readAt) => _$this._readAt = readAt;

  NotificationBulkReadActionBuilder() {
    NotificationBulkReadAction._defaults(this);
  }

  NotificationBulkReadActionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _read = $v.read;
      _readCount = $v.readCount;
      _readAt = $v.readAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationBulkReadAction other) {
    _$v = other as _$NotificationBulkReadAction;
  }

  @override
  void update(void Function(NotificationBulkReadActionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationBulkReadAction build() => _build();

  _$NotificationBulkReadAction _build() {
    final _$result = _$v ??
        _$NotificationBulkReadAction._(
          read: BuiltValueNullFieldError.checkNotNull(
              read, r'NotificationBulkReadAction', 'read'),
          readCount: BuiltValueNullFieldError.checkNotNull(
              readCount, r'NotificationBulkReadAction', 'readCount'),
          readAt: BuiltValueNullFieldError.checkNotNull(
              readAt, r'NotificationBulkReadAction', 'readAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
