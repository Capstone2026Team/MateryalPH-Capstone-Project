//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/buyer_received_rating.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/api_error.dart';
import 'package:materyalph_api_client/src/model/buyer_received_ratings_meta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_received_ratings_envelope.g.dart';

/// BuyerReceivedRatingsEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class BuyerReceivedRatingsEnvelope implements Built<BuyerReceivedRatingsEnvelope, BuyerReceivedRatingsEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<BuyerReceivedRating> get data;

  @BuiltValueField(wireName: r'meta')
  BuyerReceivedRatingsMeta get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<ApiError> get errors;

  BuyerReceivedRatingsEnvelope._();

  factory BuyerReceivedRatingsEnvelope([void updates(BuyerReceivedRatingsEnvelopeBuilder b)]) = _$BuyerReceivedRatingsEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerReceivedRatingsEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerReceivedRatingsEnvelope> get serializer => _$BuyerReceivedRatingsEnvelopeSerializer();
}

class _$BuyerReceivedRatingsEnvelopeSerializer implements PrimitiveSerializer<BuyerReceivedRatingsEnvelope> {
  @override
  final Iterable<Type> types = const [BuyerReceivedRatingsEnvelope, _$BuyerReceivedRatingsEnvelope];

  @override
  final String wireName = r'BuyerReceivedRatingsEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerReceivedRatingsEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(BuyerReceivedRating)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(BuyerReceivedRatingsMeta),
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
    BuyerReceivedRatingsEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerReceivedRatingsEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuyerReceivedRating)]),
          ) as BuiltList<BuyerReceivedRating>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerReceivedRatingsMeta),
          ) as BuyerReceivedRatingsMeta;
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
  BuyerReceivedRatingsEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerReceivedRatingsEnvelopeBuilder();
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


