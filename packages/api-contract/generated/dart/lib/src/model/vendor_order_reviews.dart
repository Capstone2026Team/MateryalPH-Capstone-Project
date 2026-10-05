//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/own_review.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/review_window_rules.dart';
import 'package:materyalph_api_client/src/model/public_review.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_order_reviews.g.dart';

/// VendorOrderReviews
///
/// Properties:
/// * [orderId]
/// * [orderReference]
/// * [state]
/// * [completedAt]
/// * [closesAt]
/// * [closesAtLabel]
/// * [revealed]
/// * [revealedAt]
/// * [revealReason]
/// * [withheldForDispute]
/// * [rules]
/// * [party]
/// * [buyerRating]
/// * [canSubmitBuyerRating]
/// * [received]
@BuiltValue()
abstract class VendorOrderReviews implements Built<VendorOrderReviews, VendorOrderReviewsBuilder> {
  @BuiltValueField(wireName: r'order_id')
  String get orderId;

  @BuiltValueField(wireName: r'order_reference')
  String get orderReference;

  @BuiltValueField(wireName: r'state')
  VendorOrderReviewsStateEnum get state;
  // enum stateEnum {  NOT_COMPLETED,  OPEN,  CLOSED,  };

  @BuiltValueField(wireName: r'completed_at')
  DateTime? get completedAt;

  @BuiltValueField(wireName: r'closes_at')
  DateTime? get closesAt;

  @BuiltValueField(wireName: r'closes_at_label')
  String? get closesAtLabel;

  @BuiltValueField(wireName: r'revealed')
  bool get revealed;

  @BuiltValueField(wireName: r'revealed_at')
  DateTime? get revealedAt;

  @BuiltValueField(wireName: r'reveal_reason')
  VendorOrderReviewsRevealReasonEnum? get revealReason;
  // enum revealReasonEnum {  BOTH_SUBMITTED,  WINDOW_EXPIRED,  };

  @BuiltValueField(wireName: r'withheld_for_dispute')
  bool get withheldForDispute;

  @BuiltValueField(wireName: r'rules')
  ReviewWindowRules get rules;

  @BuiltValueField(wireName: r'party')
  VendorOrderReviewsPartyEnum get party;
  // enum partyEnum {  VENDOR,  };

  @BuiltValueField(wireName: r'buyer_rating')
  OwnReview? get buyerRating;

  @BuiltValueField(wireName: r'can_submit_buyer_rating')
  bool get canSubmitBuyerRating;

  @BuiltValueField(wireName: r'received')
  BuiltList<PublicReview> get received;

  VendorOrderReviews._();

  factory VendorOrderReviews([void updates(VendorOrderReviewsBuilder b)]) = _$VendorOrderReviews;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorOrderReviewsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorOrderReviews> get serializer => _$VendorOrderReviewsSerializer();
}

class _$VendorOrderReviewsSerializer implements PrimitiveSerializer<VendorOrderReviews> {
  @override
  final Iterable<Type> types = const [VendorOrderReviews, _$VendorOrderReviews];

  @override
  final String wireName = r'VendorOrderReviews';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorOrderReviews object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'order_id';
    yield serializers.serialize(
      object.orderId,
      specifiedType: const FullType(String),
    );
    yield r'order_reference';
    yield serializers.serialize(
      object.orderReference,
      specifiedType: const FullType(String),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(VendorOrderReviewsStateEnum),
    );
    if (object.completedAt != null) {
      yield r'completed_at';
      yield serializers.serialize(
        object.completedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.closesAt != null) {
      yield r'closes_at';
      yield serializers.serialize(
        object.closesAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.closesAtLabel != null) {
      yield r'closes_at_label';
      yield serializers.serialize(
        object.closesAtLabel,
        specifiedType: const FullType(String),
      );
    }
    yield r'revealed';
    yield serializers.serialize(
      object.revealed,
      specifiedType: const FullType(bool),
    );
    if (object.revealedAt != null) {
      yield r'revealed_at';
      yield serializers.serialize(
        object.revealedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.revealReason != null) {
      yield r'reveal_reason';
      yield serializers.serialize(
        object.revealReason,
        specifiedType: const FullType(VendorOrderReviewsRevealReasonEnum),
      );
    }
    yield r'withheld_for_dispute';
    yield serializers.serialize(
      object.withheldForDispute,
      specifiedType: const FullType(bool),
    );
    yield r'rules';
    yield serializers.serialize(
      object.rules,
      specifiedType: const FullType(ReviewWindowRules),
    );
    yield r'party';
    yield serializers.serialize(
      object.party,
      specifiedType: const FullType(VendorOrderReviewsPartyEnum),
    );
    if (object.buyerRating != null) {
      yield r'buyer_rating';
      yield serializers.serialize(
        object.buyerRating,
        specifiedType: const FullType.nullable(OwnReview),
      );
    }
    yield r'can_submit_buyer_rating';
    yield serializers.serialize(
      object.canSubmitBuyerRating,
      specifiedType: const FullType(bool),
    );
    yield r'received';
    yield serializers.serialize(
      object.received,
      specifiedType: const FullType(BuiltList, [FullType(PublicReview)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorOrderReviews object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorOrderReviewsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'order_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderId = valueDes;
          break;
        case r'order_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderReference = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorOrderReviewsStateEnum),
          ) as VendorOrderReviewsStateEnum;
          result.state = valueDes;
          break;
        case r'completed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.completedAt = valueDes;
          break;
        case r'closes_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.closesAt = valueDes;
          break;
        case r'closes_at_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.closesAtLabel = valueDes;
          break;
        case r'revealed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.revealed = valueDes;
          break;
        case r'revealed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.revealedAt = valueDes;
          break;
        case r'reveal_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorOrderReviewsRevealReasonEnum),
          ) as VendorOrderReviewsRevealReasonEnum?;
          if (valueDes == null) continue;
          result.revealReason = valueDes;
          break;
        case r'withheld_for_dispute':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.withheldForDispute = valueDes;
          break;
        case r'rules':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReviewWindowRules),
          ) as ReviewWindowRules;
          result.rules.replace(valueDes);
          break;
        case r'party':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorOrderReviewsPartyEnum),
          ) as VendorOrderReviewsPartyEnum;
          result.party = valueDes;
          break;
        case r'buyer_rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OwnReview),
          ) as OwnReview?;
          if (valueDes == null) continue;
          result.buyerRating.replace(valueDes);
          break;
        case r'can_submit_buyer_rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canSubmitBuyerRating = valueDes;
          break;
        case r'received':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PublicReview)]),
          ) as BuiltList<PublicReview>;
          result.received.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorOrderReviews deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorOrderReviewsBuilder();
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


class VendorOrderReviewsStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NOT_COMPLETED')
  static const VendorOrderReviewsStateEnum NOT_COMPLETED = _$vendorOrderReviewsStateEnum_NOT_COMPLETED;
  @BuiltValueEnumConst(wireName: r'OPEN')
  static const VendorOrderReviewsStateEnum OPEN = _$vendorOrderReviewsStateEnum_OPEN;
  @BuiltValueEnumConst(wireName: r'CLOSED')
  static const VendorOrderReviewsStateEnum CLOSED = _$vendorOrderReviewsStateEnum_CLOSED;

  static Serializer<VendorOrderReviewsStateEnum> get serializer => _$vendorOrderReviewsStateEnumSerializer;

  const VendorOrderReviewsStateEnum._(String name): super(name);

  static BuiltSet<VendorOrderReviewsStateEnum> get values => _$vendorOrderReviewsStateEnumValues;
  static VendorOrderReviewsStateEnum valueOf(String name) => _$vendorOrderReviewsStateEnumValueOf(name);
}

class VendorOrderReviewsRevealReasonEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BOTH_SUBMITTED')
  static const VendorOrderReviewsRevealReasonEnum BOTH_SUBMITTED = _$vendorOrderReviewsRevealReasonEnum_BOTH_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'WINDOW_EXPIRED')
  static const VendorOrderReviewsRevealReasonEnum WINDOW_EXPIRED = _$vendorOrderReviewsRevealReasonEnum_WINDOW_EXPIRED;

  static Serializer<VendorOrderReviewsRevealReasonEnum> get serializer => _$vendorOrderReviewsRevealReasonEnumSerializer;

  const VendorOrderReviewsRevealReasonEnum._(String name): super(name);

  static BuiltSet<VendorOrderReviewsRevealReasonEnum> get values => _$vendorOrderReviewsRevealReasonEnumValues;
  static VendorOrderReviewsRevealReasonEnum valueOf(String name) => _$vendorOrderReviewsRevealReasonEnumValueOf(name);
}

class VendorOrderReviewsPartyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const VendorOrderReviewsPartyEnum VENDOR = _$vendorOrderReviewsPartyEnum_VENDOR;

  static Serializer<VendorOrderReviewsPartyEnum> get serializer => _$vendorOrderReviewsPartyEnumSerializer;

  const VendorOrderReviewsPartyEnum._(String name): super(name);

  static BuiltSet<VendorOrderReviewsPartyEnum> get values => _$vendorOrderReviewsPartyEnumValues;
  static VendorOrderReviewsPartyEnum valueOf(String name) => _$vendorOrderReviewsPartyEnumValueOf(name);
}

