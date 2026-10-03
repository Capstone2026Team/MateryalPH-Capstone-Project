// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_quotation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatQuotation extends ChatQuotation {
  @override
  final String id;
  @override
  final String state;
  @override
  final int lockVersion;
  @override
  final String? currentVersionId;
  @override
  final String? acceptedOrderId;
  @override
  final String? responseDueAt;
  @override
  final BuiltMap<String, JsonObject?>? draft;
  @override
  final bool canDraft;
  @override
  final bool canPublish;

  factory _$ChatQuotation([void Function(ChatQuotationBuilder)? updates]) =>
      (ChatQuotationBuilder()..update(updates))._build();

  _$ChatQuotation._(
      {required this.id,
      required this.state,
      required this.lockVersion,
      this.currentVersionId,
      this.acceptedOrderId,
      this.responseDueAt,
      this.draft,
      required this.canDraft,
      required this.canPublish})
      : super._();
  @override
  ChatQuotation rebuild(void Function(ChatQuotationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatQuotationBuilder toBuilder() => ChatQuotationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatQuotation &&
        id == other.id &&
        state == other.state &&
        lockVersion == other.lockVersion &&
        currentVersionId == other.currentVersionId &&
        acceptedOrderId == other.acceptedOrderId &&
        responseDueAt == other.responseDueAt &&
        draft == other.draft &&
        canDraft == other.canDraft &&
        canPublish == other.canPublish;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, currentVersionId.hashCode);
    _$hash = $jc(_$hash, acceptedOrderId.hashCode);
    _$hash = $jc(_$hash, responseDueAt.hashCode);
    _$hash = $jc(_$hash, draft.hashCode);
    _$hash = $jc(_$hash, canDraft.hashCode);
    _$hash = $jc(_$hash, canPublish.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatQuotation')
          ..add('id', id)
          ..add('state', state)
          ..add('lockVersion', lockVersion)
          ..add('currentVersionId', currentVersionId)
          ..add('acceptedOrderId', acceptedOrderId)
          ..add('responseDueAt', responseDueAt)
          ..add('draft', draft)
          ..add('canDraft', canDraft)
          ..add('canPublish', canPublish))
        .toString();
  }
}

class ChatQuotationBuilder
    implements Builder<ChatQuotation, ChatQuotationBuilder> {
  _$ChatQuotation? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _state;
  String? get state => _$this._state;
  set state(String? state) => _$this._state = state;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _currentVersionId;
  String? get currentVersionId => _$this._currentVersionId;
  set currentVersionId(String? currentVersionId) =>
      _$this._currentVersionId = currentVersionId;

  String? _acceptedOrderId;
  String? get acceptedOrderId => _$this._acceptedOrderId;
  set acceptedOrderId(String? acceptedOrderId) =>
      _$this._acceptedOrderId = acceptedOrderId;

  String? _responseDueAt;
  String? get responseDueAt => _$this._responseDueAt;
  set responseDueAt(String? responseDueAt) =>
      _$this._responseDueAt = responseDueAt;

  MapBuilder<String, JsonObject?>? _draft;
  MapBuilder<String, JsonObject?> get draft =>
      _$this._draft ??= MapBuilder<String, JsonObject?>();
  set draft(MapBuilder<String, JsonObject?>? draft) => _$this._draft = draft;

  bool? _canDraft;
  bool? get canDraft => _$this._canDraft;
  set canDraft(bool? canDraft) => _$this._canDraft = canDraft;

  bool? _canPublish;
  bool? get canPublish => _$this._canPublish;
  set canPublish(bool? canPublish) => _$this._canPublish = canPublish;

  ChatQuotationBuilder() {
    ChatQuotation._defaults(this);
  }

  ChatQuotationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _state = $v.state;
      _lockVersion = $v.lockVersion;
      _currentVersionId = $v.currentVersionId;
      _acceptedOrderId = $v.acceptedOrderId;
      _responseDueAt = $v.responseDueAt;
      _draft = $v.draft?.toBuilder();
      _canDraft = $v.canDraft;
      _canPublish = $v.canPublish;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatQuotation other) {
    _$v = other as _$ChatQuotation;
  }

  @override
  void update(void Function(ChatQuotationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatQuotation build() => _build();

  _$ChatQuotation _build() {
    _$ChatQuotation _$result;
    try {
      _$result = _$v ??
          _$ChatQuotation._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ChatQuotation', 'id'),
            state: BuiltValueNullFieldError.checkNotNull(
                state, r'ChatQuotation', 'state'),
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'ChatQuotation', 'lockVersion'),
            currentVersionId: currentVersionId,
            acceptedOrderId: acceptedOrderId,
            responseDueAt: responseDueAt,
            draft: _draft?.build(),
            canDraft: BuiltValueNullFieldError.checkNotNull(
                canDraft, r'ChatQuotation', 'canDraft'),
            canPublish: BuiltValueNullFieldError.checkNotNull(
                canPublish, r'ChatQuotation', 'canPublish'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'draft';
        _draft?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ChatQuotation', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
