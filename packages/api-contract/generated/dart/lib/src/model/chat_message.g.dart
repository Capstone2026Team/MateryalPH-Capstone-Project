// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ChatMessageKindEnum _$chatMessageKindEnum_TEXT =
    const ChatMessageKindEnum._('TEXT');
const ChatMessageKindEnum _$chatMessageKindEnum_SYSTEM =
    const ChatMessageKindEnum._('SYSTEM');
const ChatMessageKindEnum _$chatMessageKindEnum_ATTACHMENT =
    const ChatMessageKindEnum._('ATTACHMENT');
const ChatMessageKindEnum _$chatMessageKindEnum_PRODUCT =
    const ChatMessageKindEnum._('PRODUCT');
const ChatMessageKindEnum _$chatMessageKindEnum_TEXT_WITH_PRODUCT =
    const ChatMessageKindEnum._('TEXT_WITH_PRODUCT');
const ChatMessageKindEnum _$chatMessageKindEnum_WORK_PACKAGE =
    const ChatMessageKindEnum._('WORK_PACKAGE');

ChatMessageKindEnum _$chatMessageKindEnumValueOf(String name) {
  switch (name) {
    case 'TEXT':
      return _$chatMessageKindEnum_TEXT;
    case 'SYSTEM':
      return _$chatMessageKindEnum_SYSTEM;
    case 'ATTACHMENT':
      return _$chatMessageKindEnum_ATTACHMENT;
    case 'PRODUCT':
      return _$chatMessageKindEnum_PRODUCT;
    case 'TEXT_WITH_PRODUCT':
      return _$chatMessageKindEnum_TEXT_WITH_PRODUCT;
    case 'WORK_PACKAGE':
      return _$chatMessageKindEnum_WORK_PACKAGE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ChatMessageKindEnum> _$chatMessageKindEnumValues =
    BuiltSet<ChatMessageKindEnum>(const <ChatMessageKindEnum>[
  _$chatMessageKindEnum_TEXT,
  _$chatMessageKindEnum_SYSTEM,
  _$chatMessageKindEnum_ATTACHMENT,
  _$chatMessageKindEnum_PRODUCT,
  _$chatMessageKindEnum_TEXT_WITH_PRODUCT,
  _$chatMessageKindEnum_WORK_PACKAGE,
]);

Serializer<ChatMessageKindEnum> _$chatMessageKindEnumSerializer =
    _$ChatMessageKindEnumSerializer();

class _$ChatMessageKindEnumSerializer
    implements PrimitiveSerializer<ChatMessageKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'TEXT': 'TEXT',
    'SYSTEM': 'SYSTEM',
    'ATTACHMENT': 'ATTACHMENT',
    'PRODUCT': 'PRODUCT',
    'TEXT_WITH_PRODUCT': 'TEXT_WITH_PRODUCT',
    'WORK_PACKAGE': 'WORK_PACKAGE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'TEXT': 'TEXT',
    'SYSTEM': 'SYSTEM',
    'ATTACHMENT': 'ATTACHMENT',
    'PRODUCT': 'PRODUCT',
    'TEXT_WITH_PRODUCT': 'TEXT_WITH_PRODUCT',
    'WORK_PACKAGE': 'WORK_PACKAGE',
  };

  @override
  final Iterable<Type> types = const <Type>[ChatMessageKindEnum];
  @override
  final String wireName = 'ChatMessageKindEnum';

  @override
  Object serialize(Serializers serializers, ChatMessageKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ChatMessageKindEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ChatMessageKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ChatMessage extends ChatMessage {
  @override
  final String? conversationId;
  @override
  final String id;
  @override
  final String clientMessageId;
  @override
  final String body;
  @override
  final ChatMessageKindEnum kind;
  @override
  final ChatIdentity sender;
  @override
  final String sentAt;
  @override
  final bool mine;
  @override
  final BuiltList<ChatAttachment> attachments;
  @override
  final bool readByRecipient;
  @override
  final ChatProduct? product;
  @override
  final ChatAutomatedReply? automatedReply;
  @override
  final ChatWorkPackageAttachment? workPackageAttachment;

  factory _$ChatMessage([void Function(ChatMessageBuilder)? updates]) =>
      (ChatMessageBuilder()..update(updates))._build();

  _$ChatMessage._(
      {this.conversationId,
      required this.id,
      required this.clientMessageId,
      required this.body,
      required this.kind,
      required this.sender,
      required this.sentAt,
      required this.mine,
      required this.attachments,
      required this.readByRecipient,
      this.product,
      this.automatedReply,
      this.workPackageAttachment})
      : super._();
  @override
  ChatMessage rebuild(void Function(ChatMessageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatMessageBuilder toBuilder() => ChatMessageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatMessage &&
        conversationId == other.conversationId &&
        id == other.id &&
        clientMessageId == other.clientMessageId &&
        body == other.body &&
        kind == other.kind &&
        sender == other.sender &&
        sentAt == other.sentAt &&
        mine == other.mine &&
        attachments == other.attachments &&
        readByRecipient == other.readByRecipient &&
        product == other.product &&
        automatedReply == other.automatedReply &&
        workPackageAttachment == other.workPackageAttachment;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, conversationId.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, clientMessageId.hashCode);
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, sender.hashCode);
    _$hash = $jc(_$hash, sentAt.hashCode);
    _$hash = $jc(_$hash, mine.hashCode);
    _$hash = $jc(_$hash, attachments.hashCode);
    _$hash = $jc(_$hash, readByRecipient.hashCode);
    _$hash = $jc(_$hash, product.hashCode);
    _$hash = $jc(_$hash, automatedReply.hashCode);
    _$hash = $jc(_$hash, workPackageAttachment.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatMessage')
          ..add('conversationId', conversationId)
          ..add('id', id)
          ..add('clientMessageId', clientMessageId)
          ..add('body', body)
          ..add('kind', kind)
          ..add('sender', sender)
          ..add('sentAt', sentAt)
          ..add('mine', mine)
          ..add('attachments', attachments)
          ..add('readByRecipient', readByRecipient)
          ..add('product', product)
          ..add('automatedReply', automatedReply)
          ..add('workPackageAttachment', workPackageAttachment))
        .toString();
  }
}

class ChatMessageBuilder implements Builder<ChatMessage, ChatMessageBuilder> {
  _$ChatMessage? _$v;

  String? _conversationId;
  String? get conversationId => _$this._conversationId;
  set conversationId(String? conversationId) =>
      _$this._conversationId = conversationId;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _clientMessageId;
  String? get clientMessageId => _$this._clientMessageId;
  set clientMessageId(String? clientMessageId) =>
      _$this._clientMessageId = clientMessageId;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  ChatMessageKindEnum? _kind;
  ChatMessageKindEnum? get kind => _$this._kind;
  set kind(ChatMessageKindEnum? kind) => _$this._kind = kind;

  ChatIdentityBuilder? _sender;
  ChatIdentityBuilder get sender => _$this._sender ??= ChatIdentityBuilder();
  set sender(ChatIdentityBuilder? sender) => _$this._sender = sender;

  String? _sentAt;
  String? get sentAt => _$this._sentAt;
  set sentAt(String? sentAt) => _$this._sentAt = sentAt;

  bool? _mine;
  bool? get mine => _$this._mine;
  set mine(bool? mine) => _$this._mine = mine;

  ListBuilder<ChatAttachment>? _attachments;
  ListBuilder<ChatAttachment> get attachments =>
      _$this._attachments ??= ListBuilder<ChatAttachment>();
  set attachments(ListBuilder<ChatAttachment>? attachments) =>
      _$this._attachments = attachments;

  bool? _readByRecipient;
  bool? get readByRecipient => _$this._readByRecipient;
  set readByRecipient(bool? readByRecipient) =>
      _$this._readByRecipient = readByRecipient;

  ChatProductBuilder? _product;
  ChatProductBuilder get product => _$this._product ??= ChatProductBuilder();
  set product(ChatProductBuilder? product) => _$this._product = product;

  ChatAutomatedReplyBuilder? _automatedReply;
  ChatAutomatedReplyBuilder get automatedReply =>
      _$this._automatedReply ??= ChatAutomatedReplyBuilder();
  set automatedReply(ChatAutomatedReplyBuilder? automatedReply) =>
      _$this._automatedReply = automatedReply;

  ChatWorkPackageAttachmentBuilder? _workPackageAttachment;
  ChatWorkPackageAttachmentBuilder get workPackageAttachment =>
      _$this._workPackageAttachment ??= ChatWorkPackageAttachmentBuilder();
  set workPackageAttachment(
          ChatWorkPackageAttachmentBuilder? workPackageAttachment) =>
      _$this._workPackageAttachment = workPackageAttachment;

  ChatMessageBuilder() {
    ChatMessage._defaults(this);
  }

  ChatMessageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _conversationId = $v.conversationId;
      _id = $v.id;
      _clientMessageId = $v.clientMessageId;
      _body = $v.body;
      _kind = $v.kind;
      _sender = $v.sender.toBuilder();
      _sentAt = $v.sentAt;
      _mine = $v.mine;
      _attachments = $v.attachments.toBuilder();
      _readByRecipient = $v.readByRecipient;
      _product = $v.product?.toBuilder();
      _automatedReply = $v.automatedReply?.toBuilder();
      _workPackageAttachment = $v.workPackageAttachment?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatMessage other) {
    _$v = other as _$ChatMessage;
  }

  @override
  void update(void Function(ChatMessageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatMessage build() => _build();

  _$ChatMessage _build() {
    _$ChatMessage _$result;
    try {
      _$result = _$v ??
          _$ChatMessage._(
            conversationId: conversationId,
            id: BuiltValueNullFieldError.checkNotNull(id, r'ChatMessage', 'id'),
            clientMessageId: BuiltValueNullFieldError.checkNotNull(
                clientMessageId, r'ChatMessage', 'clientMessageId'),
            body: BuiltValueNullFieldError.checkNotNull(
                body, r'ChatMessage', 'body'),
            kind: BuiltValueNullFieldError.checkNotNull(
                kind, r'ChatMessage', 'kind'),
            sender: sender.build(),
            sentAt: BuiltValueNullFieldError.checkNotNull(
                sentAt, r'ChatMessage', 'sentAt'),
            mine: BuiltValueNullFieldError.checkNotNull(
                mine, r'ChatMessage', 'mine'),
            attachments: attachments.build(),
            readByRecipient: BuiltValueNullFieldError.checkNotNull(
                readByRecipient, r'ChatMessage', 'readByRecipient'),
            product: _product?.build(),
            automatedReply: _automatedReply?.build(),
            workPackageAttachment: _workPackageAttachment?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sender';
        sender.build();

        _$failedField = 'attachments';
        attachments.build();

        _$failedField = 'product';
        _product?.build();
        _$failedField = 'automatedReply';
        _automatedReply?.build();
        _$failedField = 'workPackageAttachment';
        _workPackageAttachment?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ChatMessage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
