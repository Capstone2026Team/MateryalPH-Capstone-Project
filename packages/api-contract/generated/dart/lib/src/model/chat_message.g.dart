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
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'TEXT': 'TEXT',
    'SYSTEM': 'SYSTEM',
    'ATTACHMENT': 'ATTACHMENT',
    'PRODUCT': 'PRODUCT',
    'TEXT_WITH_PRODUCT': 'TEXT_WITH_PRODUCT',
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

  factory _$ChatMessage([void Function(ChatMessageBuilder)? updates]) =>
      (ChatMessageBuilder()..update(updates))._build();

  _$ChatMessage._(
      {required this.id,
      required this.clientMessageId,
      required this.body,
      required this.kind,
      required this.sender,
      required this.sentAt,
      required this.mine,
      required this.attachments,
      required this.readByRecipient,
      this.product})
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
        id == other.id &&
        clientMessageId == other.clientMessageId &&
        body == other.body &&
        kind == other.kind &&
        sender == other.sender &&
        sentAt == other.sentAt &&
        mine == other.mine &&
        attachments == other.attachments &&
        readByRecipient == other.readByRecipient &&
        product == other.product;
  }

  @override
  int get hashCode {
    var _$hash = 0;
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
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatMessage')
          ..add('id', id)
          ..add('clientMessageId', clientMessageId)
          ..add('body', body)
          ..add('kind', kind)
          ..add('sender', sender)
          ..add('sentAt', sentAt)
          ..add('mine', mine)
          ..add('attachments', attachments)
          ..add('readByRecipient', readByRecipient)
          ..add('product', product))
        .toString();
  }
}

class ChatMessageBuilder implements Builder<ChatMessage, ChatMessageBuilder> {
  _$ChatMessage? _$v;

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

  ChatMessageBuilder() {
    ChatMessage._defaults(this);
  }

  ChatMessageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
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
