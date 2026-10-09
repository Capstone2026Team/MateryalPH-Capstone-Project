// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_handler.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PrivacyHandler extends PrivacyHandler {
  @override
  final int userId;
  @override
  final String name;
  @override
  final String role;

  factory _$PrivacyHandler([void Function(PrivacyHandlerBuilder)? updates]) =>
      (PrivacyHandlerBuilder()..update(updates))._build();

  _$PrivacyHandler._(
      {required this.userId, required this.name, required this.role})
      : super._();
  @override
  PrivacyHandler rebuild(void Function(PrivacyHandlerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PrivacyHandlerBuilder toBuilder() => PrivacyHandlerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PrivacyHandler &&
        userId == other.userId &&
        name == other.name &&
        role == other.role;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PrivacyHandler')
          ..add('userId', userId)
          ..add('name', name)
          ..add('role', role))
        .toString();
  }
}

class PrivacyHandlerBuilder
    implements Builder<PrivacyHandler, PrivacyHandlerBuilder> {
  _$PrivacyHandler? _$v;

  int? _userId;
  int? get userId => _$this._userId;
  set userId(int? userId) => _$this._userId = userId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _role;
  String? get role => _$this._role;
  set role(String? role) => _$this._role = role;

  PrivacyHandlerBuilder() {
    PrivacyHandler._defaults(this);
  }

  PrivacyHandlerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _name = $v.name;
      _role = $v.role;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PrivacyHandler other) {
    _$v = other as _$PrivacyHandler;
  }

  @override
  void update(void Function(PrivacyHandlerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PrivacyHandler build() => _build();

  _$PrivacyHandler _build() {
    final _$result = _$v ??
        _$PrivacyHandler._(
          userId: BuiltValueNullFieldError.checkNotNull(
              userId, r'PrivacyHandler', 'userId'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'PrivacyHandler', 'name'),
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'PrivacyHandler', 'role'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
