//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/fulfillment_conversation_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fulfillment_conversation_page.g.dart';

/// FulfillmentConversationPage
///
/// Properties:
/// * [items]
/// * [page]
/// * [hasMore]
@BuiltValue()
abstract class FulfillmentConversationPage implements Built<FulfillmentConversationPage, FulfillmentConversationPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<FulfillmentConversationSummary> get items;

  @BuiltValueField(wireName: r'page')
  int get page;

  @BuiltValueField(wireName: r'has_more')
  bool get hasMore;

  FulfillmentConversationPage._();

  factory FulfillmentConversationPage([void updates(FulfillmentConversationPageBuilder b)]) = _$FulfillmentConversationPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FulfillmentConversationPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FulfillmentConversationPage> get serializer => _$FulfillmentConversationPageSerializer();
}

class _$FulfillmentConversationPageSerializer implements PrimitiveSerializer<FulfillmentConversationPage> {
  @override
  final Iterable<Type> types = const [FulfillmentConversationPage, _$FulfillmentConversationPage];

  @override
  final String wireName = r'FulfillmentConversationPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FulfillmentConversationPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(FulfillmentConversationSummary)]),
    );
    yield r'page';
    yield serializers.serialize(
      object.page,
      specifiedType: const FullType(int),
    );
    yield r'has_more';
    yield serializers.serialize(
      object.hasMore,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FulfillmentConversationPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FulfillmentConversationPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(FulfillmentConversationSummary)]),
          ) as BuiltList<FulfillmentConversationSummary>;
          result.items.replace(valueDes);
          break;
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.page = valueDes;
          break;
        case r'has_more':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasMore = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FulfillmentConversationPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FulfillmentConversationPageBuilder();
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


