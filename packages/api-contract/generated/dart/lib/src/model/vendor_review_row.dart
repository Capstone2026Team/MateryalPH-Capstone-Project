//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/review_ratings.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/review_media_link.dart';
import 'package:materyalph_api_client/src/model/review_product.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_review_row.g.dart';

/// VendorReviewRow
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
/// * [product] - Purchased-product identity from the immutable order line snapshot; null for Store and Buyer ratings.
/// * [media]
/// * [visibility]
/// * [orderId]
/// * [orderReference]
/// * [canReport]
@BuiltValue()
abstract class VendorReviewRow implements Built<VendorReviewRow, VendorReviewRowBuilder> {
  @BuiltValueField(wireName: r'id')
  String? get id;

  @BuiltValueField(wireName: r'type')
  VendorReviewRowTypeEnum? get type;
  // enum typeEnum {  VENDOR,  PRODUCT,  BUYER,  };

  @BuiltValueField(wireName: r'ratings')
  ReviewRatings? get ratings;

  @BuiltValueField(wireName: r'comment')
  String? get comment;

  @BuiltValueField(wireName: r'display_name')
  String? get displayName;

  @BuiltValueField(wireName: r'verified_purchase')
  bool? get verifiedPurchase;

  @BuiltValueField(wireName: r'submitted_at')
  DateTime? get submittedAt;

  @BuiltValueField(wireName: r'edited')
  bool? get edited;

  @BuiltValueField(wireName: r'variant_label')
  String? get variantLabel;

  /// Purchased-product identity from the immutable order line snapshot; null for Store and Buyer ratings.
  @BuiltValueField(wireName: r'product')
  ReviewProduct? get product;

  @BuiltValueField(wireName: r'media')
  BuiltList<ReviewMediaLink>? get media;

  @BuiltValueField(wireName: r'visibility')
  VendorReviewRowVisibilityEnum? get visibility;
  // enum visibilityEnum {  PUBLIC,  HIDDEN_UNTIL_REVEAL,  WITHHELD_ACTIVE_DISPUTE,  HIDDEN_BY_MODERATION,  REMOVED,  EXCLUDED_BY_INVESTIGATION,  };

  @BuiltValueField(wireName: r'order_id')
  String? get orderId;

  @BuiltValueField(wireName: r'order_reference')
  String? get orderReference;

  @BuiltValueField(wireName: r'can_report')
  bool? get canReport;

  VendorReviewRow._();

  factory VendorReviewRow([void updates(VendorReviewRowBuilder b)]) = _$VendorReviewRow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorReviewRowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorReviewRow> get serializer => _$VendorReviewRowSerializer();
}

class _$VendorReviewRowSerializer implements PrimitiveSerializer<VendorReviewRow> {
  @override
  final Iterable<Type> types = const [VendorReviewRow, _$VendorReviewRow];

  @override
  final String wireName = r'VendorReviewRow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorReviewRow object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(String),
      );
    }
    if (object.type != null) {
      yield r'type';
      yield serializers.serialize(
        object.type,
        specifiedType: const FullType(VendorReviewRowTypeEnum),
      );
    }
    if (object.ratings != null) {
      yield r'ratings';
      yield serializers.serialize(
        object.ratings,
        specifiedType: const FullType(ReviewRatings),
      );
    }
    if (object.comment != null) {
      yield r'comment';
      yield serializers.serialize(
        object.comment,
        specifiedType: const FullType(String),
      );
    }
    if (object.displayName != null) {
      yield r'display_name';
      yield serializers.serialize(
        object.displayName,
        specifiedType: const FullType(String),
      );
    }
    if (object.verifiedPurchase != null) {
      yield r'verified_purchase';
      yield serializers.serialize(
        object.verifiedPurchase,
        specifiedType: const FullType(bool),
      );
    }
    if (object.submittedAt != null) {
      yield r'submitted_at';
      yield serializers.serialize(
        object.submittedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.edited != null) {
      yield r'edited';
      yield serializers.serialize(
        object.edited,
        specifiedType: const FullType(bool),
      );
    }
    if (object.variantLabel != null) {
      yield r'variant_label';
      yield serializers.serialize(
        object.variantLabel,
        specifiedType: const FullType(String),
      );
    }
    if (object.product != null) {
      yield r'product';
      yield serializers.serialize(
        object.product,
        specifiedType: const FullType.nullable(ReviewProduct),
      );
    }
    if (object.media != null) {
      yield r'media';
      yield serializers.serialize(
        object.media,
        specifiedType: const FullType(BuiltList, [FullType(ReviewMediaLink)]),
      );
    }
    if (object.visibility != null) {
      yield r'visibility';
      yield serializers.serialize(
        object.visibility,
        specifiedType: const FullType(VendorReviewRowVisibilityEnum),
      );
    }
    if (object.orderId != null) {
      yield r'order_id';
      yield serializers.serialize(
        object.orderId,
        specifiedType: const FullType(String),
      );
    }
    if (object.orderReference != null) {
      yield r'order_reference';
      yield serializers.serialize(
        object.orderReference,
        specifiedType: const FullType(String),
      );
    }
    if (object.canReport != null) {
      yield r'can_report';
      yield serializers.serialize(
        object.canReport,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorReviewRow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorReviewRowBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.id = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorReviewRowTypeEnum),
          ) as VendorReviewRowTypeEnum?;
          if (valueDes == null) continue;
          result.type = valueDes;
          break;
        case r'ratings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ReviewRatings),
          ) as ReviewRatings?;
          if (valueDes == null) continue;
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.displayName = valueDes;
          break;
        case r'verified_purchase':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
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
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
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
        case r'product':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ReviewProduct),
          ) as ReviewProduct?;
          if (valueDes == null) continue;
          result.product.replace(valueDes);
          break;
        case r'media':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(ReviewMediaLink)]),
          ) as BuiltList<ReviewMediaLink>?;
          if (valueDes == null) continue;
          result.media.replace(valueDes);
          break;
        case r'visibility':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorReviewRowVisibilityEnum),
          ) as VendorReviewRowVisibilityEnum?;
          if (valueDes == null) continue;
          result.visibility = valueDes;
          break;
        case r'order_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.orderId = valueDes;
          break;
        case r'order_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.orderReference = valueDes;
          break;
        case r'can_report':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.canReport = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorReviewRow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorReviewRowBuilder();
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


class VendorReviewRowTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const VendorReviewRowTypeEnum VENDOR = _$vendorReviewRowTypeEnum_VENDOR;
  @BuiltValueEnumConst(wireName: r'PRODUCT')
  static const VendorReviewRowTypeEnum PRODUCT = _$vendorReviewRowTypeEnum_PRODUCT;
  @BuiltValueEnumConst(wireName: r'BUYER')
  static const VendorReviewRowTypeEnum BUYER = _$vendorReviewRowTypeEnum_BUYER;

  static Serializer<VendorReviewRowTypeEnum> get serializer => _$vendorReviewRowTypeEnumSerializer;

  const VendorReviewRowTypeEnum._(String name): super(name);

  static BuiltSet<VendorReviewRowTypeEnum> get values => _$vendorReviewRowTypeEnumValues;
  static VendorReviewRowTypeEnum valueOf(String name) => _$vendorReviewRowTypeEnumValueOf(name);
}

class VendorReviewRowVisibilityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PUBLIC')
  static const VendorReviewRowVisibilityEnum PUBLIC = _$vendorReviewRowVisibilityEnum_PUBLIC;
  @BuiltValueEnumConst(wireName: r'HIDDEN_UNTIL_REVEAL')
  static const VendorReviewRowVisibilityEnum HIDDEN_UNTIL_REVEAL = _$vendorReviewRowVisibilityEnum_HIDDEN_UNTIL_REVEAL;
  @BuiltValueEnumConst(wireName: r'WITHHELD_ACTIVE_DISPUTE')
  static const VendorReviewRowVisibilityEnum WITHHELD_ACTIVE_DISPUTE = _$vendorReviewRowVisibilityEnum_WITHHELD_ACTIVE_DISPUTE;
  @BuiltValueEnumConst(wireName: r'HIDDEN_BY_MODERATION')
  static const VendorReviewRowVisibilityEnum HIDDEN_BY_MODERATION = _$vendorReviewRowVisibilityEnum_HIDDEN_BY_MODERATION;
  @BuiltValueEnumConst(wireName: r'REMOVED')
  static const VendorReviewRowVisibilityEnum REMOVED = _$vendorReviewRowVisibilityEnum_REMOVED;
  @BuiltValueEnumConst(wireName: r'EXCLUDED_BY_INVESTIGATION')
  static const VendorReviewRowVisibilityEnum EXCLUDED_BY_INVESTIGATION = _$vendorReviewRowVisibilityEnum_EXCLUDED_BY_INVESTIGATION;

  static Serializer<VendorReviewRowVisibilityEnum> get serializer => _$vendorReviewRowVisibilityEnumSerializer;

  const VendorReviewRowVisibilityEnum._(String name): super(name);

  static BuiltSet<VendorReviewRowVisibilityEnum> get values => _$vendorReviewRowVisibilityEnumValues;
  static VendorReviewRowVisibilityEnum valueOf(String name) => _$vendorReviewRowVisibilityEnumValueOf(name);
}

