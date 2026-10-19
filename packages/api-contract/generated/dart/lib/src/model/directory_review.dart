//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/directory_review_ratings_value.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'directory_review.g.dart';

/// DirectoryReview
///
/// Properties:
/// * [id]
/// * [type]
/// * [ratings] - Criterion scores by name; their keys depend on the review type.
/// * [comment] - Withheld for a hidden or removed review unless the caller holds reviews.moderate.
/// * [authorName]
/// * [orderReference]
/// * [storeName]
/// * [productName]
/// * [moderationState]
/// * [visibility]
/// * [submittedAt]
@BuiltValue()
abstract class DirectoryReview implements Built<DirectoryReview, DirectoryReviewBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'type')
  DirectoryReviewTypeEnum get type;
  // enum typeEnum {  VENDOR,  PRODUCT,  BUYER,  };

  /// Criterion scores by name; their keys depend on the review type.
  @BuiltValueField(wireName: r'ratings')
  BuiltMap<String, DirectoryReviewRatingsValue?> get ratings;

  /// Withheld for a hidden or removed review unless the caller holds reviews.moderate.
  @BuiltValueField(wireName: r'comment')
  String? get comment;

  @BuiltValueField(wireName: r'author_name')
  String get authorName;

  @BuiltValueField(wireName: r'order_reference')
  String get orderReference;

  @BuiltValueField(wireName: r'store_name')
  String get storeName;

  @BuiltValueField(wireName: r'product_name')
  String? get productName;

  @BuiltValueField(wireName: r'moderation_state')
  String get moderationState;

  @BuiltValueField(wireName: r'visibility')
  String get visibility;

  @BuiltValueField(wireName: r'submitted_at')
  DateTime get submittedAt;

  DirectoryReview._();

  factory DirectoryReview([void updates(DirectoryReviewBuilder b)]) = _$DirectoryReview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectoryReviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectoryReview> get serializer => _$DirectoryReviewSerializer();
}

class _$DirectoryReviewSerializer implements PrimitiveSerializer<DirectoryReview> {
  @override
  final Iterable<Type> types = const [DirectoryReview, _$DirectoryReview];

  @override
  final String wireName = r'DirectoryReview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectoryReview object, {
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
      specifiedType: const FullType(DirectoryReviewTypeEnum),
    );
    yield r'ratings';
    yield serializers.serialize(
      object.ratings,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(DirectoryReviewRatingsValue)]),
    );
    yield r'comment';
    yield object.comment == null ? null : serializers.serialize(
      object.comment,
      specifiedType: const FullType.nullable(String),
    );
    yield r'author_name';
    yield serializers.serialize(
      object.authorName,
      specifiedType: const FullType(String),
    );
    yield r'order_reference';
    yield serializers.serialize(
      object.orderReference,
      specifiedType: const FullType(String),
    );
    yield r'store_name';
    yield serializers.serialize(
      object.storeName,
      specifiedType: const FullType(String),
    );
    yield r'product_name';
    yield object.productName == null ? null : serializers.serialize(
      object.productName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'moderation_state';
    yield serializers.serialize(
      object.moderationState,
      specifiedType: const FullType(String),
    );
    yield r'visibility';
    yield serializers.serialize(
      object.visibility,
      specifiedType: const FullType(String),
    );
    yield r'submitted_at';
    yield serializers.serialize(
      object.submittedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DirectoryReview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DirectoryReviewBuilder result,
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
            specifiedType: const FullType(DirectoryReviewTypeEnum),
          ) as DirectoryReviewTypeEnum;
          result.type = valueDes;
          break;
        case r'ratings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(DirectoryReviewRatingsValue)]),
          ) as BuiltMap<String, DirectoryReviewRatingsValue?>;
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
        case r'author_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.authorName = valueDes;
          break;
        case r'order_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderReference = valueDes;
          break;
        case r'store_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.storeName = valueDes;
          break;
        case r'product_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.productName = valueDes;
          break;
        case r'moderation_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.moderationState = valueDes;
          break;
        case r'visibility':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.visibility = valueDes;
          break;
        case r'submitted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.submittedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DirectoryReview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectoryReviewBuilder();
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


class DirectoryReviewTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const DirectoryReviewTypeEnum VENDOR = _$directoryReviewTypeEnum_VENDOR;
  @BuiltValueEnumConst(wireName: r'PRODUCT')
  static const DirectoryReviewTypeEnum PRODUCT = _$directoryReviewTypeEnum_PRODUCT;
  @BuiltValueEnumConst(wireName: r'BUYER')
  static const DirectoryReviewTypeEnum BUYER = _$directoryReviewTypeEnum_BUYER;

  static Serializer<DirectoryReviewTypeEnum> get serializer => _$directoryReviewTypeEnumSerializer;

  const DirectoryReviewTypeEnum._(String name): super(name);

  static BuiltSet<DirectoryReviewTypeEnum> get values => _$directoryReviewTypeEnumValues;
  static DirectoryReviewTypeEnum valueOf(String name) => _$directoryReviewTypeEnumValueOf(name);
}

