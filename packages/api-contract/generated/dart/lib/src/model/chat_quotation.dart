//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_quotation.g.dart';

/// ChatQuotation
///
/// Properties:
/// * [id]
/// * [state]
/// * [lockVersion]
/// * [currentVersionId]
/// * [acceptedOrderId]
/// * [responseDueAt]
/// * [draft]
/// * [canDraft]
/// * [canPublish]
@BuiltValue()
abstract class ChatQuotation implements Built<ChatQuotation, ChatQuotationBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'state')
  String get state;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'current_version_id')
  String? get currentVersionId;

  @BuiltValueField(wireName: r'accepted_order_id')
  String? get acceptedOrderId;

  @BuiltValueField(wireName: r'response_due_at')
  String? get responseDueAt;

  @BuiltValueField(wireName: r'draft')
  BuiltMap<String, JsonObject?>? get draft;

  @BuiltValueField(wireName: r'can_draft')
  bool get canDraft;

  @BuiltValueField(wireName: r'can_publish')
  bool get canPublish;

  ChatQuotation._();

  factory ChatQuotation([void updates(ChatQuotationBuilder b)]) = _$ChatQuotation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatQuotationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatQuotation> get serializer => _$ChatQuotationSerializer();
}

class _$ChatQuotationSerializer implements PrimitiveSerializer<ChatQuotation> {
  @override
  final Iterable<Type> types = const [ChatQuotation, _$ChatQuotation];

  @override
  final String wireName = r'ChatQuotation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatQuotation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(String),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    if (object.currentVersionId != null) {
      yield r'current_version_id';
      yield serializers.serialize(
        object.currentVersionId,
        specifiedType: const FullType(String),
      );
    }
    if (object.acceptedOrderId != null) {
      yield r'accepted_order_id';
      yield serializers.serialize(
        object.acceptedOrderId,
        specifiedType: const FullType(String),
      );
    }
    if (object.responseDueAt != null) {
      yield r'response_due_at';
      yield serializers.serialize(
        object.responseDueAt,
        specifiedType: const FullType(String),
      );
    }
    if (object.draft != null) {
      yield r'draft';
      yield serializers.serialize(
        object.draft,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    yield r'can_draft';
    yield serializers.serialize(
      object.canDraft,
      specifiedType: const FullType(bool),
    );
    yield r'can_publish';
    yield serializers.serialize(
      object.canPublish,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatQuotation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatQuotationBuilder result,
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
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.state = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'current_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.currentVersionId = valueDes;
          break;
        case r'accepted_order_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.acceptedOrderId = valueDes;
          break;
        case r'response_due_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.responseDueAt = valueDes;
          break;
        case r'draft':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.draft.replace(valueDes);
          break;
        case r'can_draft':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canDraft = valueDes;
          break;
        case r'can_publish':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canPublish = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatQuotation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatQuotationBuilder();
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


