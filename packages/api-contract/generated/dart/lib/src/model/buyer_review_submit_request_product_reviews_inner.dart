//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_review_submit_request_product_reviews_inner.g.dart';

/// BuyerReviewSubmitRequestProductReviewsInner
///
/// Properties:
/// * [orderLineId]
/// * [rating]
/// * [comment]
@BuiltValue()
abstract class BuyerReviewSubmitRequestProductReviewsInner implements Built<BuyerReviewSubmitRequestProductReviewsInner, BuyerReviewSubmitRequestProductReviewsInnerBuilder> {
  @BuiltValueField(wireName: r'order_line_id')
  String get orderLineId;

  @BuiltValueField(wireName: r'rating')
  int get rating;

  @BuiltValueField(wireName: r'comment')
  String? get comment;

  BuyerReviewSubmitRequestProductReviewsInner._();

  factory BuyerReviewSubmitRequestProductReviewsInner([void updates(BuyerReviewSubmitRequestProductReviewsInnerBuilder b)]) = _$BuyerReviewSubmitRequestProductReviewsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerReviewSubmitRequestProductReviewsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerReviewSubmitRequestProductReviewsInner> get serializer => _$BuyerReviewSubmitRequestProductReviewsInnerSerializer();
}

class _$BuyerReviewSubmitRequestProductReviewsInnerSerializer implements PrimitiveSerializer<BuyerReviewSubmitRequestProductReviewsInner> {
  @override
  final Iterable<Type> types = const [BuyerReviewSubmitRequestProductReviewsInner, _$BuyerReviewSubmitRequestProductReviewsInner];

  @override
  final String wireName = r'BuyerReviewSubmitRequestProductReviewsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerReviewSubmitRequestProductReviewsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'order_line_id';
    yield serializers.serialize(
      object.orderLineId,
      specifiedType: const FullType(String),
    );
    yield r'rating';
    yield serializers.serialize(
      object.rating,
      specifiedType: const FullType(int),
    );
    if (object.comment != null) {
      yield r'comment';
      yield serializers.serialize(
        object.comment,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerReviewSubmitRequestProductReviewsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerReviewSubmitRequestProductReviewsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'order_line_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderLineId = valueDes;
          break;
        case r'rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rating = valueDes;
          break;
        case r'comment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.comment = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerReviewSubmitRequestProductReviewsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerReviewSubmitRequestProductReviewsInnerBuilder();
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


