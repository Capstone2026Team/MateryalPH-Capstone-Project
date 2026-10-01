// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_handler.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatHandler extends ChatHandler {
  @override
  final int id;
  @override
  final String displayName;
  @override
  final String role;

  factory _$ChatHandler([void Function(ChatHandlerBuilder)? updates]) =>
      (ChatHandlerBuilder()..update(updates))._build();

  _$ChatHandler._(
      {required this.id, required this.displayName, required this.role})
      : super._();
  @override
  ChatHandler rebuild(void Function(ChatHandlerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatHandlerBuilder toBuilder() => ChatHandlerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatHandler &&
        id == other.id &&
        displayName == other.displayName &&
        role == other.role;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatHandler')
          ..add('id', id)
          ..add('displayName', displayName)
          ..add('role', role))
        .toString();
  }
}

class ChatHandlerBuilder implements Builder<ChatHandler, ChatHandlerBuilder> {
  _$ChatHandler? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _role;
  String? get role => _$this._role;
  set role(String? role) => _$this._role = role;

  ChatHandlerBuilder() {
    ChatHandler._defaults(this);
  }

  ChatHandlerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _displayName = $v.displayName;
      _role = $v.role;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatHandler other) {
    _$v = other as _$ChatHandler;
  }

  @override
  void update(void Function(ChatHandlerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatHandler build() => _build();

  _$ChatHandler _build() {
    final _$result = _$v ??
        _$ChatHandler._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ChatHandler', 'id'),
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'ChatHandler', 'displayName'),
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'ChatHandler', 'role'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
