//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:materyalph_api_client/src/model/fulfillment_conversation_page.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fulfillment_conversation_page_response.g.dart';

/// FulfillmentConversationPageResponse
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class FulfillmentConversationPageResponse implements Built<FulfillmentConversationPageResponse, FulfillmentConversationPageResponseBuilder> {
  @BuiltValueField(wireName: r'data')
  FulfillmentConversationPage get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?> get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError> get errors;

  FulfillmentConversationPageResponse._();

  factory FulfillmentConversationPageResponse([void updates(FulfillmentConversationPageResponseBuilder b)]) = _$FulfillmentConversationPageResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FulfillmentConversationPageResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FulfillmentConversationPageResponse> get serializer => _$FulfillmentConversationPageResponseSerializer();
}

class _$FulfillmentConversationPageResponseSerializer implements PrimitiveSerializer<FulfillmentConversationPageResponse> {
  @override
  final Iterable<Type> types = const [FulfillmentConversationPageResponse, _$FulfillmentConversationPageResponse];

  @override
  final String wireName = r'FulfillmentConversationPageResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FulfillmentConversationPageResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(FulfillmentConversationPage),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'errors';
    yield serializers.serialize(
      object.errors,
      specifiedType: const FullType(BuiltList, [FullType(ApiError)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FulfillmentConversationPageResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FulfillmentConversationPageResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FulfillmentConversationPage),
          ) as FulfillmentConversationPage;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.meta.replace(valueDes);
          break;
        case r'errors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ApiError)]),
          ) as BuiltList<ApiError>;
          result.errors.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FulfillmentConversationPageResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FulfillmentConversationPageResponseBuilder();
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


