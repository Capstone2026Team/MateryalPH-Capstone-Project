//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/chat_draft_content.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_quotation_preview_request.g.dart';

/// ChatQuotationPreviewRequest
///
/// Properties:
/// * [draft]
@BuiltValue()
abstract class ChatQuotationPreviewRequest implements Built<ChatQuotationPreviewRequest, ChatQuotationPreviewRequestBuilder> {
  @BuiltValueField(wireName: r'draft')
  ChatDraftContent get draft;

  ChatQuotationPreviewRequest._();

  factory ChatQuotationPreviewRequest([void updates(ChatQuotationPreviewRequestBuilder b)]) = _$ChatQuotationPreviewRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatQuotationPreviewRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatQuotationPreviewRequest> get serializer => _$ChatQuotationPreviewRequestSerializer();
}

class _$ChatQuotationPreviewRequestSerializer implements PrimitiveSerializer<ChatQuotationPreviewRequest> {
  @override
  final Iterable<Type> types = const [ChatQuotationPreviewRequest, _$ChatQuotationPreviewRequest];

  @override
  final String wireName = r'ChatQuotationPreviewRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatQuotationPreviewRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'draft';
    yield serializers.serialize(
      object.draft,
      specifiedType: const FullType(ChatDraftContent),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatQuotationPreviewRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatQuotationPreviewRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'draft':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ChatDraftContent),
          ) as ChatDraftContent;
          result.draft.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatQuotationPreviewRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatQuotationPreviewRequestBuilder();
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


