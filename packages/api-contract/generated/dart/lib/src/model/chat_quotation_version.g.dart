// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_quotation_version.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatQuotationVersion extends ChatQuotationVersion {
  @override
  final String id;
  @override
  final int version;
  @override
  final bool latest;
  @override
  final String state;
  @override
  final String publishedAt;
  @override
  final String expiresAt;
  @override
  final String contentHash;
  @override
  final ChatQuotationContent content;
  @override
  final bool viewed;
  @override
  final BuiltList<String> actions;
  @override
  final String? quotationId;
  @override
  final String? acceptedOrderId;

  factory _$ChatQuotationVersion(
          [void Function(ChatQuotationVersionBuilder)? updates]) =>
      (ChatQuotationVersionBuilder()..update(updates))._build();

  _$ChatQuotationVersion._(
      {required this.id,
      required this.version,
      required this.latest,
      required this.state,
      required this.publishedAt,
      required this.expiresAt,
      required this.contentHash,
      required this.content,
      required this.viewed,
      required this.actions,
      this.quotationId,
      this.acceptedOrderId})
      : super._();
  @override
  ChatQuotationVersion rebuild(
          void Function(ChatQuotationVersionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatQuotationVersionBuilder toBuilder() =>
      ChatQuotationVersionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatQuotationVersion &&
        id == other.id &&
        version == other.version &&
        latest == other.latest &&
        state == other.state &&
        publishedAt == other.publishedAt &&
        expiresAt == other.expiresAt &&
        contentHash == other.contentHash &&
        content == other.content &&
        viewed == other.viewed &&
        actions == other.actions &&
        quotationId == other.quotationId &&
        acceptedOrderId == other.acceptedOrderId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, latest.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, publishedAt.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, contentHash.hashCode);
    _$hash = $jc(_$hash, content.hashCode);
    _$hash = $jc(_$hash, viewed.hashCode);
    _$hash = $jc(_$hash, actions.hashCode);
    _$hash = $jc(_$hash, quotationId.hashCode);
    _$hash = $jc(_$hash, acceptedOrderId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatQuotationVersion')
          ..add('id', id)
          ..add('version', version)
          ..add('latest', latest)
          ..add('state', state)
          ..add('publishedAt', publishedAt)
          ..add('expiresAt', expiresAt)
          ..add('contentHash', contentHash)
          ..add('content', content)
          ..add('viewed', viewed)
          ..add('actions', actions)
          ..add('quotationId', quotationId)
          ..add('acceptedOrderId', acceptedOrderId))
        .toString();
  }
}

class ChatQuotationVersionBuilder
    implements Builder<ChatQuotationVersion, ChatQuotationVersionBuilder> {
  _$ChatQuotationVersion? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  bool? _latest;
  bool? get latest => _$this._latest;
  set latest(bool? latest) => _$this._latest = latest;

  String? _state;
  String? get state => _$this._state;
  set state(String? state) => _$this._state = state;

  String? _publishedAt;
  String? get publishedAt => _$this._publishedAt;
  set publishedAt(String? publishedAt) => _$this._publishedAt = publishedAt;

  String? _expiresAt;
  String? get expiresAt => _$this._expiresAt;
  set expiresAt(String? expiresAt) => _$this._expiresAt = expiresAt;

  String? _contentHash;
  String? get contentHash => _$this._contentHash;
  set contentHash(String? contentHash) => _$this._contentHash = contentHash;

  ChatQuotationContentBuilder? _content;
  ChatQuotationContentBuilder get content =>
      _$this._content ??= ChatQuotationContentBuilder();
  set content(ChatQuotationContentBuilder? content) =>
      _$this._content = content;

  bool? _viewed;
  bool? get viewed => _$this._viewed;
  set viewed(bool? viewed) => _$this._viewed = viewed;

  ListBuilder<String>? _actions;
  ListBuilder<String> get actions => _$this._actions ??= ListBuilder<String>();
  set actions(ListBuilder<String>? actions) => _$this._actions = actions;

  String? _quotationId;
  String? get quotationId => _$this._quotationId;
  set quotationId(String? quotationId) => _$this._quotationId = quotationId;

  String? _acceptedOrderId;
  String? get acceptedOrderId => _$this._acceptedOrderId;
  set acceptedOrderId(String? acceptedOrderId) =>
      _$this._acceptedOrderId = acceptedOrderId;

  ChatQuotationVersionBuilder() {
    ChatQuotationVersion._defaults(this);
  }

  ChatQuotationVersionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _version = $v.version;
      _latest = $v.latest;
      _state = $v.state;
      _publishedAt = $v.publishedAt;
      _expiresAt = $v.expiresAt;
      _contentHash = $v.contentHash;
      _content = $v.content.toBuilder();
      _viewed = $v.viewed;
      _actions = $v.actions.toBuilder();
      _quotationId = $v.quotationId;
      _acceptedOrderId = $v.acceptedOrderId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatQuotationVersion other) {
    _$v = other as _$ChatQuotationVersion;
  }

  @override
  void update(void Function(ChatQuotationVersionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatQuotationVersion build() => _build();

  _$ChatQuotationVersion _build() {
    _$ChatQuotationVersion _$result;
    try {
      _$result = _$v ??
          _$ChatQuotationVersion._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ChatQuotationVersion', 'id'),
            version: BuiltValueNullFieldError.checkNotNull(
                version, r'ChatQuotationVersion', 'version'),
            latest: BuiltValueNullFieldError.checkNotNull(
                latest, r'ChatQuotationVersion', 'latest'),
            state: BuiltValueNullFieldError.checkNotNull(
                state, r'ChatQuotationVersion', 'state'),
            publishedAt: BuiltValueNullFieldError.checkNotNull(
                publishedAt, r'ChatQuotationVersion', 'publishedAt'),
            expiresAt: BuiltValueNullFieldError.checkNotNull(
                expiresAt, r'ChatQuotationVersion', 'expiresAt'),
            contentHash: BuiltValueNullFieldError.checkNotNull(
                contentHash, r'ChatQuotationVersion', 'contentHash'),
            content: content.build(),
            viewed: BuiltValueNullFieldError.checkNotNull(
                viewed, r'ChatQuotationVersion', 'viewed'),
            actions: actions.build(),
            quotationId: quotationId,
            acceptedOrderId: acceptedOrderId,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'content';
        content.build();

        _$failedField = 'actions';
        actions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ChatQuotationVersion', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
