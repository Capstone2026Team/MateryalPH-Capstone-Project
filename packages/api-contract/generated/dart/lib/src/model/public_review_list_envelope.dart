//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:materyalph_api_client/src/model/public_review.dart';
import 'package:materyalph_api_client/src/model/review_list_meta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_review_list_envelope.g.dart';

/// PublicReviewListEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class PublicReviewListEnvelope implements Built<PublicReviewListEnvelope, PublicReviewListEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<PublicReview> get data;

  @BuiltValueField(wireName: r'meta')
  ReviewListMeta get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError> get errors;

  PublicReviewListEnvelope._();

  factory PublicReviewListEnvelope([void updates(PublicReviewListEnvelopeBuilder b)]) = _$PublicReviewListEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicReviewListEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicReviewListEnvelope> get serializer => _$PublicReviewListEnvelopeSerializer();
}

class _$PublicReviewListEnvelopeSerializer implements PrimitiveSerializer<PublicReviewListEnvelope> {
  @override
  final Iterable<Type> types = const [PublicReviewListEnvelope, _$PublicReviewListEnvelope];

  @override
  final String wireName = r'PublicReviewListEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicReviewListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(PublicReview)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(ReviewListMeta),
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
    PublicReviewListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicReviewListEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PublicReview)]),
          ) as BuiltList<PublicReview>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReviewListMeta),
          ) as ReviewListMeta;
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
  PublicReviewListEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicReviewListEnvelopeBuilder();
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


