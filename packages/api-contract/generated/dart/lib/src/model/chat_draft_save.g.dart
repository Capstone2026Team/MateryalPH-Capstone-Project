// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_draft_save.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatDraftSave extends ChatDraftSave {
  @override
  final int lockVersion;
  @override
  final ChatDraftContent draft;

  factory _$ChatDraftSave([void Function(ChatDraftSaveBuilder)? updates]) =>
      (ChatDraftSaveBuilder()..update(updates))._build();

  _$ChatDraftSave._({required this.lockVersion, required this.draft})
      : super._();
  @override
  ChatDraftSave rebuild(void Function(ChatDraftSaveBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatDraftSaveBuilder toBuilder() => ChatDraftSaveBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatDraftSave &&
        lockVersion == other.lockVersion &&
        draft == other.draft;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, draft.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatDraftSave')
          ..add('lockVersion', lockVersion)
          ..add('draft', draft))
        .toString();
  }
}

class ChatDraftSaveBuilder
    implements Builder<ChatDraftSave, ChatDraftSaveBuilder> {
  _$ChatDraftSave? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  ChatDraftContentBuilder? _draft;
  ChatDraftContentBuilder get draft =>
      _$this._draft ??= ChatDraftContentBuilder();
  set draft(ChatDraftContentBuilder? draft) => _$this._draft = draft;

  ChatDraftSaveBuilder() {
    ChatDraftSave._defaults(this);
  }

  ChatDraftSaveBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _draft = $v.draft.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatDraftSave other) {
    _$v = other as _$ChatDraftSave;
  }

  @override
  void update(void Function(ChatDraftSaveBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatDraftSave build() => _build();

  _$ChatDraftSave _build() {
    _$ChatDraftSave _$result;
    try {
      _$result = _$v ??
          _$ChatDraftSave._(
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'ChatDraftSave', 'lockVersion'),
            draft: draft.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'draft';
        draft.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ChatDraftSave', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
