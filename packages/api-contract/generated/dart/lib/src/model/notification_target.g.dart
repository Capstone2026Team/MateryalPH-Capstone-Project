// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_target.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NotificationTarget extends NotificationTarget {
  @override
  final String path;

  factory _$NotificationTarget(
          [void Function(NotificationTargetBuilder)? updates]) =>
      (NotificationTargetBuilder()..update(updates))._build();

  _$NotificationTarget._({required this.path}) : super._();
  @override
  NotificationTarget rebuild(
          void Function(NotificationTargetBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationTargetBuilder toBuilder() =>
      NotificationTargetBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationTarget && path == other.path;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, path.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificationTarget')
          ..add('path', path))
        .toString();
  }
}

class NotificationTargetBuilder
    implements Builder<NotificationTarget, NotificationTargetBuilder> {
  _$NotificationTarget? _$v;

  String? _path;
  String? get path => _$this._path;
  set path(String? path) => _$this._path = path;

  NotificationTargetBuilder() {
    NotificationTarget._defaults(this);
  }

  NotificationTargetBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _path = $v.path;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationTarget other) {
    _$v = other as _$NotificationTarget;
  }

  @override
  void update(void Function(NotificationTargetBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationTarget build() => _build();

  _$NotificationTarget _build() {
    final _$result = _$v ??
        _$NotificationTarget._(
          path: BuiltValueNullFieldError.checkNotNull(
              path, r'NotificationTarget', 'path'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
