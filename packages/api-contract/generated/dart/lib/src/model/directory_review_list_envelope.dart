//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:materyalph_api_client/src/model/directory_review.dart';
import 'package:materyalph_api_client/src/model/directory_page_meta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'directory_review_list_envelope.g.dart';

/// DirectoryReviewListEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class DirectoryReviewListEnvelope implements Built<DirectoryReviewListEnvelope, DirectoryReviewListEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<DirectoryReview> get data;

  @BuiltValueField(wireName: r'meta')
  DirectoryPageMeta get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError> get errors;

  DirectoryReviewListEnvelope._();

  factory DirectoryReviewListEnvelope([void updates(DirectoryReviewListEnvelopeBuilder b)]) = _$DirectoryReviewListEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectoryReviewListEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectoryReviewListEnvelope> get serializer => _$DirectoryReviewListEnvelopeSerializer();
}

class _$DirectoryReviewListEnvelopeSerializer implements PrimitiveSerializer<DirectoryReviewListEnvelope> {
  @override
  final Iterable<Type> types = const [DirectoryReviewListEnvelope, _$DirectoryReviewListEnvelope];

  @override
  final String wireName = r'DirectoryReviewListEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectoryReviewListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(DirectoryReview)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(DirectoryPageMeta),
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
    DirectoryReviewListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DirectoryReviewListEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DirectoryReview)]),
          ) as BuiltList<DirectoryReview>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DirectoryPageMeta),
          ) as DirectoryPageMeta;
          result.meta = valueDes.toBuilder();
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
  DirectoryReviewListEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectoryReviewListEnvelopeBuilder();
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


