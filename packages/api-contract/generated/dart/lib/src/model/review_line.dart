//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/own_review.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'review_line.g.dart';

/// ReviewLine
///
/// Properties:
/// * [orderLineId]
/// * [listingId]
/// * [displayName]
/// * [variantLabel]
/// * [review]
/// * [canReview]
@BuiltValue()
abstract class ReviewLine implements Built<ReviewLine, ReviewLineBuilder> {
  @BuiltValueField(wireName: r'order_line_id')
  String get orderLineId;

  @BuiltValueField(wireName: r'listing_id')
  String get listingId;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'variant_label')
  String? get variantLabel;

  @BuiltValueField(wireName: r'review')
  OwnReview? get review;

  @BuiltValueField(wireName: r'can_review')
  bool get canReview;

  ReviewLine._();

  factory ReviewLine([void updates(ReviewLineBuilder b)]) = _$ReviewLine;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReviewLineBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReviewLine> get serializer => _$ReviewLineSerializer();
}

class _$ReviewLineSerializer implements PrimitiveSerializer<ReviewLine> {
  @override
  final Iterable<Type> types = const [ReviewLine, _$ReviewLine];

  @override
  final String wireName = r'ReviewLine';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReviewLine object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'order_line_id';
    yield serializers.serialize(
      object.orderLineId,
      specifiedType: const FullType(String),
    );
    yield r'listing_id';
    yield serializers.serialize(
      object.listingId,
      specifiedType: const FullType(String),
    );
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    if (object.variantLabel != null) {
      yield r'variant_label';
      yield serializers.serialize(
        object.variantLabel,
        specifiedType: const FullType(String),
      );
    }
    if (object.review != null) {
      yield r'review';
      yield serializers.serialize(
        object.review,
        specifiedType: const FullType.nullable(OwnReview),
      );
    }
    yield r'can_review';
    yield serializers.serialize(
      object.canReview,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ReviewLine object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReviewLineBuilder result,
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
        case r'listing_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.listingId = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'variant_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.variantLabel = valueDes;
          break;
        case r'review':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OwnReview),
          ) as OwnReview?;
          if (valueDes == null) continue;
          result.review.replace(valueDes);
          break;
        case r'can_review':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canReview = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReviewLine deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReviewLineBuilder();
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


