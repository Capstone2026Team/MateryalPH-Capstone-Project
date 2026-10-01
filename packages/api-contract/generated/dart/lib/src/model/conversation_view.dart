//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/chat_identity.dart';
import 'package:materyalph_api_client/src/model/chat_store.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'conversation_view.g.dart';

/// ConversationView
///
/// Properties:
/// * [id]
/// * [purpose]
/// * [contextType]
/// * [orderId]
/// * [lockVersion]
/// * [store]
/// * [handler]
/// * [unreadCount]
/// * [channel]
/// * [lockedReference]
/// * [updatedAt]
/// * [canTransfer]
/// * [fulfillmentEntryEnabled]
@BuiltValue()
abstract class ConversationView implements Built<ConversationView, ConversationViewBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'purpose')
  ConversationViewPurposeEnum get purpose;
  // enum purposeEnum {  SALES,  FULFILLMENT,  };

  @BuiltValueField(wireName: r'context_type')
  ConversationViewContextTypeEnum get contextType;
  // enum contextTypeEnum {  ITEM_BASED,  PROJECT_BASED,  };

  @BuiltValueField(wireName: r'order_id')
  String? get orderId;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'store')
  ChatStore get store;

  @BuiltValueField(wireName: r'handler')
  ChatIdentity? get handler;

  @BuiltValueField(wireName: r'unread_count')
  int get unreadCount;

  @BuiltValueField(wireName: r'channel')
  String get channel;

  @BuiltValueField(wireName: r'locked_reference')
  BuiltMap<String, JsonObject?> get lockedReference;

  @BuiltValueField(wireName: r'updated_at')
  String get updatedAt;

  @BuiltValueField(wireName: r'can_transfer')
  bool get canTransfer;

  @BuiltValueField(wireName: r'fulfillment_entry_enabled')
  bool get fulfillmentEntryEnabled;

  ConversationView._();

  factory ConversationView([void updates(ConversationViewBuilder b)]) = _$ConversationView;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ConversationViewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ConversationView> get serializer => _$ConversationViewSerializer();
}

class _$ConversationViewSerializer implements PrimitiveSerializer<ConversationView> {
  @override
  final Iterable<Type> types = const [ConversationView, _$ConversationView];

  @override
  final String wireName = r'ConversationView';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ConversationView object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'purpose';
    yield serializers.serialize(
      object.purpose,
      specifiedType: const FullType(ConversationViewPurposeEnum),
    );
    yield r'context_type';
    yield serializers.serialize(
      object.contextType,
      specifiedType: const FullType(ConversationViewContextTypeEnum),
    );
    if (object.orderId != null) {
      yield r'order_id';
      yield serializers.serialize(
        object.orderId,
        specifiedType: const FullType(String),
      );
    }
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'store';
    yield serializers.serialize(
      object.store,
      specifiedType: const FullType(ChatStore),
    );
    if (object.handler != null) {
      yield r'handler';
      yield serializers.serialize(
        object.handler,
        specifiedType: const FullType(ChatIdentity),
      );
    }
    yield r'unread_count';
    yield serializers.serialize(
      object.unreadCount,
      specifiedType: const FullType(int),
    );
    yield r'channel';
    yield serializers.serialize(
      object.channel,
      specifiedType: const FullType(String),
    );
    yield r'locked_reference';
    yield serializers.serialize(
      object.lockedReference,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'updated_at';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(String),
    );
    yield r'can_transfer';
    yield serializers.serialize(
      object.canTransfer,
      specifiedType: const FullType(bool),
    );
    yield r'fulfillment_entry_enabled';
    yield serializers.serialize(
      object.fulfillmentEntryEnabled,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ConversationView object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ConversationViewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'purpose':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ConversationViewPurposeEnum),
          ) as ConversationViewPurposeEnum;
          result.purpose = valueDes;
          break;
        case r'context_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ConversationViewContextTypeEnum),
          ) as ConversationViewContextTypeEnum;
          result.contextType = valueDes;
          break;
        case r'order_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.orderId = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'store':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ChatStore),
          ) as ChatStore;
          result.store.replace(valueDes);
          break;
        case r'handler':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ChatIdentity),
          ) as ChatIdentity?;
          if (valueDes == null) continue;
          result.handler.replace(valueDes);
          break;
        case r'unread_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unreadCount = valueDes;
          break;
        case r'channel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.channel = valueDes;
          break;
        case r'locked_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.lockedReference.replace(valueDes);
          break;
        case r'updated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.updatedAt = valueDes;
          break;
        case r'can_transfer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canTransfer = valueDes;
          break;
        case r'fulfillment_entry_enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.fulfillmentEntryEnabled = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ConversationView deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ConversationViewBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


class ConversationViewPurposeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SALES')
  static const ConversationViewPurposeEnum SALES = _$conversationViewPurposeEnum_SALES;
  @BuiltValueEnumConst(wireName: r'FULFILLMENT')
  static const ConversationViewPurposeEnum FULFILLMENT = _$conversationViewPurposeEnum_FULFILLMENT;

  static Serializer<ConversationViewPurposeEnum> get serializer => _$conversationViewPurposeEnumSerializer;

  const ConversationViewPurposeEnum._(String name): super(name);

  static BuiltSet<ConversationViewPurposeEnum> get values => _$conversationViewPurposeEnumValues;
  static ConversationViewPurposeEnum valueOf(String name) => _$conversationViewPurposeEnumValueOf(name);
}

class ConversationViewContextTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ITEM_BASED')
  static const ConversationViewContextTypeEnum ITEM_BASED = _$conversationViewContextTypeEnum_ITEM_BASED;
  @BuiltValueEnumConst(wireName: r'PROJECT_BASED')
  static const ConversationViewContextTypeEnum PROJECT_BASED = _$conversationViewContextTypeEnum_PROJECT_BASED;

  static Serializer<ConversationViewContextTypeEnum> get serializer => _$conversationViewContextTypeEnumSerializer;

  const ConversationViewContextTypeEnum._(String name): super(name);

  static BuiltSet<ConversationViewContextTypeEnum> get values => _$conversationViewContextTypeEnumValues;
  static ConversationViewContextTypeEnum valueOf(String name) => _$conversationViewContextTypeEnumValueOf(name);
}

