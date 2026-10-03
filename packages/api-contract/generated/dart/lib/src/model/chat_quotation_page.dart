//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/chat_quotation_version.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/chat_quotation.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_quotation_page.g.dart';

/// ChatQuotationPage
///
/// Properties:
/// * [quotation]
/// * [versions]
/// * [hasMore]
/// * [page]
@BuiltValue()
abstract class ChatQuotationPage implements Built<ChatQuotationPage, ChatQuotationPageBuilder> {
  @BuiltValueField(wireName: r'quotation')
  ChatQuotation? get quotation;

  @BuiltValueField(wireName: r'versions')
  BuiltList<ChatQuotationVersion> get versions;

  @BuiltValueField(wireName: r'has_more')
  bool get hasMore;

  @BuiltValueField(wireName: r'page')
  int? get page;

  ChatQuotationPage._();

  factory ChatQuotationPage([void updates(ChatQuotationPageBuilder b)]) = _$ChatQuotationPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatQuotationPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatQuotationPage> get serializer => _$ChatQuotationPageSerializer();
}

class _$ChatQuotationPageSerializer implements PrimitiveSerializer<ChatQuotationPage> {
  @override
  final Iterable<Type> types = const [ChatQuotationPage, _$ChatQuotationPage];

  @override
  final String wireName = r'ChatQuotationPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatQuotationPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.quotation != null) {
      yield r'quotation';
      yield serializers.serialize(
        object.quotation,
        specifiedType: const FullType(ChatQuotation),
      );
    }
    yield r'versions';
    yield serializers.serialize(
      object.versions,
      specifiedType: const FullType(BuiltList, [FullType(ChatQuotationVersion)]),
    );
    yield r'has_more';
    yield serializers.serialize(
      object.hasMore,
      specifiedType: const FullType(bool),
    );
    if (object.page != null) {
      yield r'page';
      yield serializers.serialize(
        object.page,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatQuotationPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatQuotationPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'quotation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ChatQuotation),
          ) as ChatQuotation?;
          if (valueDes == null) continue;
          result.quotation.replace(valueDes);
          break;
        case r'versions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ChatQuotationVersion)]),
          ) as BuiltList<ChatQuotationVersion>;
          result.versions.replace(valueDes);
          break;
        case r'has_more':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasMore = valueDes;
          break;
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.page = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatQuotationPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatQuotationPageBuilder();
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


