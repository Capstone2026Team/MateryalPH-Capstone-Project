//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/review_ratings.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/review_media_link.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_review.g.dart';

/// Privacy-safe public review: first name and last initial or Verified Buyer; no reviewer id or contact.
///
/// Properties:
/// * [id]
/// * [type]
/// * [ratings]
/// * [comment]
/// * [displayName]
/// * [verifiedPurchase]
/// * [submittedAt]
/// * [edited]
/// * [variantLabel]
/// * [media]
@BuiltValue()
abstract class PublicReview implements Built<PublicReview, PublicReviewBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'type')
  PublicReviewTypeEnum get type;
  // enum typeEnum {  VENDOR,  PRODUCT,  BUYER,  };

  @BuiltValueField(wireName: r'ratings')
  ReviewRatings get ratings;

  @BuiltValueField(wireName: r'comment')
  String? get comment;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'verified_purchase')
  bool get verifiedPurchase;

  @BuiltValueField(wireName: r'submitted_at')
  DateTime? get submittedAt;

  @BuiltValueField(wireName: r'edited')
  bool get edited;

  @BuiltValueField(wireName: r'variant_label')
  String? get variantLabel;

  @BuiltValueField(wireName: r'media')
  BuiltList<ReviewMediaLink> get media;

  PublicReview._();

  factory PublicReview([void updates(PublicReviewBuilder b)]) = _$PublicReview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicReviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicReview> get serializer => _$PublicReviewSerializer();
}

class _$PublicReviewSerializer implements PrimitiveSerializer<PublicReview> {
  @override
  final Iterable<Type> types = const [PublicReview, _$PublicReview];

  @override
  final String wireName = r'PublicReview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicReview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(PublicReviewTypeEnum),
    );
    yield r'ratings';
    yield serializers.serialize(
      object.ratings,
      specifiedType: const FullType(ReviewRatings),
    );
    if (object.comment != null) {
      yield r'comment';
      yield serializers.serialize(
        object.comment,
        specifiedType: const FullType(String),
      );
    }
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'verified_purchase';
    yield serializers.serialize(
      object.verifiedPurchase,
      specifiedType: const FullType(bool),
    );
    if (object.submittedAt != null) {
      yield r'submitted_at';
      yield serializers.serialize(
        object.submittedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'edited';
    yield serializers.serialize(
      object.edited,
      specifiedType: const FullType(bool),
    );
    if (object.variantLabel != null) {
      yield r'variant_label';
      yield serializers.serialize(
        object.variantLabel,
        specifiedType: const FullType(String),
      );
    }
    yield r'media';
    yield serializers.serialize(
      object.media,
      specifiedType: const FullType(BuiltList, [FullType(ReviewMediaLink)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicReview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicReviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicReviewTypeEnum),
          ) as PublicReviewTypeEnum;
          result.type = valueDes;
          break;
        case r'ratings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReviewRatings),
          ) as ReviewRatings;
          result.ratings.replace(valueDes);
          break;
        case r'comment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.comment = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'verified_purchase':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.verifiedPurchase = valueDes;
          break;
        case r'submitted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.submittedAt = valueDes;
          break;
        case r'edited':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.edited = valueDes;
          break;
        case r'variant_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.variantLabel = valueDes;
          break;
        case r'media':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ReviewMediaLink)]),
          ) as BuiltList<ReviewMediaLink>;
          result.media.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicReview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicReviewBuilder();
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


class PublicReviewTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const PublicReviewTypeEnum VENDOR = _$publicReviewTypeEnum_VENDOR;
  @BuiltValueEnumConst(wireName: r'PRODUCT')
  static const PublicReviewTypeEnum PRODUCT = _$publicReviewTypeEnum_PRODUCT;
  @BuiltValueEnumConst(wireName: r'BUYER')
  static const PublicReviewTypeEnum BUYER = _$publicReviewTypeEnum_BUYER;

  static Serializer<PublicReviewTypeEnum> get serializer => _$publicReviewTypeEnumSerializer;

  const PublicReviewTypeEnum._(String name): super(name);

  static BuiltSet<PublicReviewTypeEnum> get values => _$publicReviewTypeEnumValues;
  static PublicReviewTypeEnum valueOf(String name) => _$publicReviewTypeEnumValueOf(name);
}

