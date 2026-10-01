//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/conversation_view.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'conversation_page.g.dart';

/// ConversationPage
///
/// Properties:
/// * [items]
/// * [page]
/// * [hasMore]
@BuiltValue()
abstract class ConversationPage implements Built<ConversationPage, ConversationPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<ConversationView> get items;

  @BuiltValueField(wireName: r'page')
  int get page;

  @BuiltValueField(wireName: r'has_more')
  bool get hasMore;

  ConversationPage._();

  factory ConversationPage([void updates(ConversationPageBuilder b)]) = _$ConversationPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ConversationPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ConversationPage> get serializer => _$ConversationPageSerializer();
}

class _$ConversationPageSerializer implements PrimitiveSerializer<ConversationPage> {
  @override
  final Iterable<Type> types = const [ConversationPage, _$ConversationPage];

  @override
  final String wireName = r'ConversationPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ConversationPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(ConversationView)]),
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
    ConversationPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ConversationPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ConversationView)]),
          ) as BuiltList<ConversationView>;
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
  ConversationPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ConversationPageBuilder();
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


