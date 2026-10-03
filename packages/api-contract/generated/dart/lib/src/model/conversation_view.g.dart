// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_view.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ConversationViewPurposeEnum _$conversationViewPurposeEnum_SALES =
    const ConversationViewPurposeEnum._('SALES');
const ConversationViewPurposeEnum _$conversationViewPurposeEnum_FULFILLMENT =
    const ConversationViewPurposeEnum._('FULFILLMENT');

ConversationViewPurposeEnum _$conversationViewPurposeEnumValueOf(String name) {
  switch (name) {
    case 'SALES':
      return _$conversationViewPurposeEnum_SALES;
    case 'FULFILLMENT':
      return _$conversationViewPurposeEnum_FULFILLMENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ConversationViewPurposeEnum>
    _$conversationViewPurposeEnumValues =
    BuiltSet<ConversationViewPurposeEnum>(const <ConversationViewPurposeEnum>[
  _$conversationViewPurposeEnum_SALES,
  _$conversationViewPurposeEnum_FULFILLMENT,
]);

const ConversationViewContextTypeEnum
    _$conversationViewContextTypeEnum_ITEM_BASED =
    const ConversationViewContextTypeEnum._('ITEM_BASED');
const ConversationViewContextTypeEnum
    _$conversationViewContextTypeEnum_PROJECT_BASED =
    const ConversationViewContextTypeEnum._('PROJECT_BASED');

ConversationViewContextTypeEnum _$conversationViewContextTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'ITEM_BASED':
      return _$conversationViewContextTypeEnum_ITEM_BASED;
    case 'PROJECT_BASED':
      return _$conversationViewContextTypeEnum_PROJECT_BASED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ConversationViewContextTypeEnum>
    _$conversationViewContextTypeEnumValues = BuiltSet<
        ConversationViewContextTypeEnum>(const <ConversationViewContextTypeEnum>[
  _$conversationViewContextTypeEnum_ITEM_BASED,
  _$conversationViewContextTypeEnum_PROJECT_BASED,
]);

Serializer<ConversationViewPurposeEnum>
    _$conversationViewPurposeEnumSerializer =
    _$ConversationViewPurposeEnumSerializer();
Serializer<ConversationViewContextTypeEnum>
    _$conversationViewContextTypeEnumSerializer =
    _$ConversationViewContextTypeEnumSerializer();

class _$ConversationViewPurposeEnumSerializer
    implements PrimitiveSerializer<ConversationViewPurposeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SALES': 'SALES',
    'FULFILLMENT': 'FULFILLMENT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SALES': 'SALES',
    'FULFILLMENT': 'FULFILLMENT',
  };

  @override
  final Iterable<Type> types = const <Type>[ConversationViewPurposeEnum];
  @override
  final String wireName = 'ConversationViewPurposeEnum';

  @override
  Object serialize(Serializers serializers, ConversationViewPurposeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ConversationViewPurposeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ConversationViewPurposeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ConversationViewContextTypeEnumSerializer
    implements PrimitiveSerializer<ConversationViewContextTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ITEM_BASED': 'ITEM_BASED',
    'PROJECT_BASED': 'PROJECT_BASED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ITEM_BASED': 'ITEM_BASED',
    'PROJECT_BASED': 'PROJECT_BASED',
  };

  @override
  final Iterable<Type> types = const <Type>[ConversationViewContextTypeEnum];
  @override
  final String wireName = 'ConversationViewContextTypeEnum';

  @override
  Object serialize(
          Serializers serializers, ConversationViewContextTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ConversationViewContextTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ConversationViewContextTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ConversationView extends ConversationView {
  @override
  final String id;
  @override
  final ConversationViewPurposeEnum purpose;
  @override
  final ConversationViewContextTypeEnum contextType;
  @override
  final String? orderId;
  @override
  final int lockVersion;
  @override
  final ChatStore store;
  @override
  final ChatIdentity? handler;
  @override
  final int unreadCount;
  @override
  final String channel;
  @override
  final BuiltMap<String, JsonObject?> lockedReference;
  @override
  final String updatedAt;
  @override
  final bool canTransfer;
  @override
  final bool fulfillmentEntryEnabled;
  @override
  final bool readOnly;
  @override
  final String? readOnlyReason;
  @override
  final String? orderReference;
  @override
  final ChatIdentity? buyer;
  @override
  final String? lastMessagePreview;
  @override
  final String? latestProductId;
  @override
  final String? canonicalConversationId;
  @override
  final BuiltList<String>? legacyConversationIds;
  @override
  final bool? legacyHasMore;
  @override
  final int? legacyPage;

  factory _$ConversationView(
          [void Function(ConversationViewBuilder)? updates]) =>
      (ConversationViewBuilder()..update(updates))._build();

  _$ConversationView._(
      {required this.id,
      required this.purpose,
      required this.contextType,
      this.orderId,
      required this.lockVersion,
      required this.store,
      this.handler,
      required this.unreadCount,
      required this.channel,
      required this.lockedReference,
      required this.updatedAt,
      required this.canTransfer,
      required this.fulfillmentEntryEnabled,
      required this.readOnly,
      this.readOnlyReason,
      this.orderReference,
      this.buyer,
      this.lastMessagePreview,
      this.latestProductId,
      this.canonicalConversationId,
      this.legacyConversationIds,
      this.legacyHasMore,
      this.legacyPage})
      : super._();
  @override
  ConversationView rebuild(void Function(ConversationViewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConversationViewBuilder toBuilder() =>
      ConversationViewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConversationView &&
        id == other.id &&
        purpose == other.purpose &&
        contextType == other.contextType &&
        orderId == other.orderId &&
        lockVersion == other.lockVersion &&
        store == other.store &&
        handler == other.handler &&
        unreadCount == other.unreadCount &&
        channel == other.channel &&
        lockedReference == other.lockedReference &&
        updatedAt == other.updatedAt &&
        canTransfer == other.canTransfer &&
        fulfillmentEntryEnabled == other.fulfillmentEntryEnabled &&
        readOnly == other.readOnly &&
        readOnlyReason == other.readOnlyReason &&
        orderReference == other.orderReference &&
        buyer == other.buyer &&
        lastMessagePreview == other.lastMessagePreview &&
        latestProductId == other.latestProductId &&
        canonicalConversationId == other.canonicalConversationId &&
        legacyConversationIds == other.legacyConversationIds &&
        legacyHasMore == other.legacyHasMore &&
        legacyPage == other.legacyPage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, purpose.hashCode);
    _$hash = $jc(_$hash, contextType.hashCode);
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, store.hashCode);
    _$hash = $jc(_$hash, handler.hashCode);
    _$hash = $jc(_$hash, unreadCount.hashCode);
    _$hash = $jc(_$hash, channel.hashCode);
    _$hash = $jc(_$hash, lockedReference.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, canTransfer.hashCode);
    _$hash = $jc(_$hash, fulfillmentEntryEnabled.hashCode);
    _$hash = $jc(_$hash, readOnly.hashCode);
    _$hash = $jc(_$hash, readOnlyReason.hashCode);
    _$hash = $jc(_$hash, orderReference.hashCode);
    _$hash = $jc(_$hash, buyer.hashCode);
    _$hash = $jc(_$hash, lastMessagePreview.hashCode);
    _$hash = $jc(_$hash, latestProductId.hashCode);
    _$hash = $jc(_$hash, canonicalConversationId.hashCode);
    _$hash = $jc(_$hash, legacyConversationIds.hashCode);
    _$hash = $jc(_$hash, legacyHasMore.hashCode);
    _$hash = $jc(_$hash, legacyPage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ConversationView')
          ..add('id', id)
          ..add('purpose', purpose)
          ..add('contextType', contextType)
          ..add('orderId', orderId)
          ..add('lockVersion', lockVersion)
          ..add('store', store)
          ..add('handler', handler)
          ..add('unreadCount', unreadCount)
          ..add('channel', channel)
          ..add('lockedReference', lockedReference)
          ..add('updatedAt', updatedAt)
          ..add('canTransfer', canTransfer)
          ..add('fulfillmentEntryEnabled', fulfillmentEntryEnabled)
          ..add('readOnly', readOnly)
          ..add('readOnlyReason', readOnlyReason)
          ..add('orderReference', orderReference)
          ..add('buyer', buyer)
          ..add('lastMessagePreview', lastMessagePreview)
          ..add('latestProductId', latestProductId)
          ..add('canonicalConversationId', canonicalConversationId)
          ..add('legacyConversationIds', legacyConversationIds)
          ..add('legacyHasMore', legacyHasMore)
          ..add('legacyPage', legacyPage))
        .toString();
  }
}

class ConversationViewBuilder
    implements Builder<ConversationView, ConversationViewBuilder> {
  _$ConversationView? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ConversationViewPurposeEnum? _purpose;
  ConversationViewPurposeEnum? get purpose => _$this._purpose;
  set purpose(ConversationViewPurposeEnum? purpose) =>
      _$this._purpose = purpose;

  ConversationViewContextTypeEnum? _contextType;
  ConversationViewContextTypeEnum? get contextType => _$this._contextType;
  set contextType(ConversationViewContextTypeEnum? contextType) =>
      _$this._contextType = contextType;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  ChatStoreBuilder? _store;
  ChatStoreBuilder get store => _$this._store ??= ChatStoreBuilder();
  set store(ChatStoreBuilder? store) => _$this._store = store;

  ChatIdentityBuilder? _handler;
  ChatIdentityBuilder get handler => _$this._handler ??= ChatIdentityBuilder();
  set handler(ChatIdentityBuilder? handler) => _$this._handler = handler;

  int? _unreadCount;
  int? get unreadCount => _$this._unreadCount;
  set unreadCount(int? unreadCount) => _$this._unreadCount = unreadCount;

  String? _channel;
  String? get channel => _$this._channel;
  set channel(String? channel) => _$this._channel = channel;

  MapBuilder<String, JsonObject?>? _lockedReference;
  MapBuilder<String, JsonObject?> get lockedReference =>
      _$this._lockedReference ??= MapBuilder<String, JsonObject?>();
  set lockedReference(MapBuilder<String, JsonObject?>? lockedReference) =>
      _$this._lockedReference = lockedReference;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  bool? _canTransfer;
  bool? get canTransfer => _$this._canTransfer;
  set canTransfer(bool? canTransfer) => _$this._canTransfer = canTransfer;

  bool? _fulfillmentEntryEnabled;
  bool? get fulfillmentEntryEnabled => _$this._fulfillmentEntryEnabled;
  set fulfillmentEntryEnabled(bool? fulfillmentEntryEnabled) =>
      _$this._fulfillmentEntryEnabled = fulfillmentEntryEnabled;

  bool? _readOnly;
  bool? get readOnly => _$this._readOnly;
  set readOnly(bool? readOnly) => _$this._readOnly = readOnly;

  String? _readOnlyReason;
  String? get readOnlyReason => _$this._readOnlyReason;
  set readOnlyReason(String? readOnlyReason) =>
      _$this._readOnlyReason = readOnlyReason;

  String? _orderReference;
  String? get orderReference => _$this._orderReference;
  set orderReference(String? orderReference) =>
      _$this._orderReference = orderReference;

  ChatIdentityBuilder? _buyer;
  ChatIdentityBuilder get buyer => _$this._buyer ??= ChatIdentityBuilder();
  set buyer(ChatIdentityBuilder? buyer) => _$this._buyer = buyer;

  String? _lastMessagePreview;
  String? get lastMessagePreview => _$this._lastMessagePreview;
  set lastMessagePreview(String? lastMessagePreview) =>
      _$this._lastMessagePreview = lastMessagePreview;

  String? _latestProductId;
  String? get latestProductId => _$this._latestProductId;
  set latestProductId(String? latestProductId) =>
      _$this._latestProductId = latestProductId;

  String? _canonicalConversationId;
  String? get canonicalConversationId => _$this._canonicalConversationId;
  set canonicalConversationId(String? canonicalConversationId) =>
      _$this._canonicalConversationId = canonicalConversationId;

  ListBuilder<String>? _legacyConversationIds;
  ListBuilder<String> get legacyConversationIds =>
      _$this._legacyConversationIds ??= ListBuilder<String>();
  set legacyConversationIds(ListBuilder<String>? legacyConversationIds) =>
      _$this._legacyConversationIds = legacyConversationIds;

  bool? _legacyHasMore;
  bool? get legacyHasMore => _$this._legacyHasMore;
  set legacyHasMore(bool? legacyHasMore) =>
      _$this._legacyHasMore = legacyHasMore;

  int? _legacyPage;
  int? get legacyPage => _$this._legacyPage;
  set legacyPage(int? legacyPage) => _$this._legacyPage = legacyPage;

  ConversationViewBuilder() {
    ConversationView._defaults(this);
  }

  ConversationViewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _purpose = $v.purpose;
      _contextType = $v.contextType;
      _orderId = $v.orderId;
      _lockVersion = $v.lockVersion;
      _store = $v.store.toBuilder();
      _handler = $v.handler?.toBuilder();
      _unreadCount = $v.unreadCount;
      _channel = $v.channel;
      _lockedReference = $v.lockedReference.toBuilder();
      _updatedAt = $v.updatedAt;
      _canTransfer = $v.canTransfer;
      _fulfillmentEntryEnabled = $v.fulfillmentEntryEnabled;
      _readOnly = $v.readOnly;
      _readOnlyReason = $v.readOnlyReason;
      _orderReference = $v.orderReference;
      _buyer = $v.buyer?.toBuilder();
      _lastMessagePreview = $v.lastMessagePreview;
      _latestProductId = $v.latestProductId;
      _canonicalConversationId = $v.canonicalConversationId;
      _legacyConversationIds = $v.legacyConversationIds?.toBuilder();
      _legacyHasMore = $v.legacyHasMore;
      _legacyPage = $v.legacyPage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConversationView other) {
    _$v = other as _$ConversationView;
  }

  @override
  void update(void Function(ConversationViewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConversationView build() => _build();

  _$ConversationView _build() {
    _$ConversationView _$result;
    try {
      _$result = _$v ??
          _$ConversationView._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ConversationView', 'id'),
            purpose: BuiltValueNullFieldError.checkNotNull(
                purpose, r'ConversationView', 'purpose'),
            contextType: BuiltValueNullFieldError.checkNotNull(
                contextType, r'ConversationView', 'contextType'),
            orderId: orderId,
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'ConversationView', 'lockVersion'),
            store: store.build(),
            handler: _handler?.build(),
            unreadCount: BuiltValueNullFieldError.checkNotNull(
                unreadCount, r'ConversationView', 'unreadCount'),
            channel: BuiltValueNullFieldError.checkNotNull(
                channel, r'ConversationView', 'channel'),
            lockedReference: lockedReference.build(),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'ConversationView', 'updatedAt'),
            canTransfer: BuiltValueNullFieldError.checkNotNull(
                canTransfer, r'ConversationView', 'canTransfer'),
            fulfillmentEntryEnabled: BuiltValueNullFieldError.checkNotNull(
                fulfillmentEntryEnabled,
                r'ConversationView',
                'fulfillmentEntryEnabled'),
            readOnly: BuiltValueNullFieldError.checkNotNull(
                readOnly, r'ConversationView', 'readOnly'),
            readOnlyReason: readOnlyReason,
            orderReference: orderReference,
            buyer: _buyer?.build(),
            lastMessagePreview: lastMessagePreview,
            latestProductId: latestProductId,
            canonicalConversationId: canonicalConversationId,
            legacyConversationIds: _legacyConversationIds?.build(),
            legacyHasMore: legacyHasMore,
            legacyPage: legacyPage,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'store';
        store.build();
        _$failedField = 'handler';
        _handler?.build();

        _$failedField = 'lockedReference';
        lockedReference.build();

        _$failedField = 'buyer';
        _buyer?.build();

        _$failedField = 'legacyConversationIds';
        _legacyConversationIds?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ConversationView', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
