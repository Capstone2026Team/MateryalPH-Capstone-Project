//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/own_review.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/review_window_rules.dart';
import 'package:materyalph_api_client/src/model/review_display_option.dart';
import 'package:materyalph_api_client/src/model/counterpart_rating.dart';
import 'package:materyalph_api_client/src/model/review_line.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_order_reviews.g.dart';

/// The Vendor's rating of the Buyer appears only after the blind reveal and while visible.
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
/// * [speedKind]
/// * [speedLabel]
/// * [displayNameOptions]
/// * [vendorRating]
/// * [canSubmitVendorRating]
/// * [lines]
/// * [counterpartRating]
@BuiltValue()
abstract class BuyerOrderReviews implements Built<BuyerOrderReviews, BuyerOrderReviewsBuilder> {
  @BuiltValueField(wireName: r'order_id')
  String get orderId;

  @BuiltValueField(wireName: r'order_reference')
  String get orderReference;

  @BuiltValueField(wireName: r'state')
  BuyerOrderReviewsStateEnum get state;
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
  BuyerOrderReviewsRevealReasonEnum? get revealReason;
  // enum revealReasonEnum {  BOTH_SUBMITTED,  WINDOW_EXPIRED,  };

  @BuiltValueField(wireName: r'withheld_for_dispute')
  bool get withheldForDispute;

  @BuiltValueField(wireName: r'rules')
  ReviewWindowRules get rules;

  @BuiltValueField(wireName: r'party')
  BuyerOrderReviewsPartyEnum get party;
  // enum partyEnum {  BUYER,  };

  @BuiltValueField(wireName: r'speed_kind')
  BuyerOrderReviewsSpeedKindEnum get speedKind;
  // enum speedKindEnum {  DELIVERY_SPEED,  PROCESSING_SPEED,  };

  @BuiltValueField(wireName: r'speed_label')
  String get speedLabel;

  @BuiltValueField(wireName: r'display_name_options')
  BuiltList<ReviewDisplayOption> get displayNameOptions;

  @BuiltValueField(wireName: r'vendor_rating')
  OwnReview? get vendorRating;

  @BuiltValueField(wireName: r'can_submit_vendor_rating')
  bool get canSubmitVendorRating;

  @BuiltValueField(wireName: r'lines')
  BuiltList<ReviewLine> get lines;

  @BuiltValueField(wireName: r'counterpart_rating')
  CounterpartRating? get counterpartRating;

  BuyerOrderReviews._();

  factory BuyerOrderReviews([void updates(BuyerOrderReviewsBuilder b)]) = _$BuyerOrderReviews;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerOrderReviewsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerOrderReviews> get serializer => _$BuyerOrderReviewsSerializer();
}

class _$BuyerOrderReviewsSerializer implements PrimitiveSerializer<BuyerOrderReviews> {
  @override
  final Iterable<Type> types = const [BuyerOrderReviews, _$BuyerOrderReviews];

  @override
  final String wireName = r'BuyerOrderReviews';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerOrderReviews object, {
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
      specifiedType: const FullType(BuyerOrderReviewsStateEnum),
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
        specifiedType: const FullType(BuyerOrderReviewsRevealReasonEnum),
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
      specifiedType: const FullType(BuyerOrderReviewsPartyEnum),
    );
    yield r'speed_kind';
    yield serializers.serialize(
      object.speedKind,
      specifiedType: const FullType(BuyerOrderReviewsSpeedKindEnum),
    );
    yield r'speed_label';
    yield serializers.serialize(
      object.speedLabel,
      specifiedType: const FullType(String),
    );
    yield r'display_name_options';
    yield serializers.serialize(
      object.displayNameOptions,
      specifiedType: const FullType(BuiltList, [FullType(ReviewDisplayOption)]),
    );
    if (object.vendorRating != null) {
      yield r'vendor_rating';
      yield serializers.serialize(
        object.vendorRating,
        specifiedType: const FullType.nullable(OwnReview),
      );
    }
    yield r'can_submit_vendor_rating';
    yield serializers.serialize(
      object.canSubmitVendorRating,
      specifiedType: const FullType(bool),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(ReviewLine)]),
    );
    if (object.counterpartRating != null) {
      yield r'counterpart_rating';
      yield serializers.serialize(
        object.counterpartRating,
        specifiedType: const FullType.nullable(CounterpartRating),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerOrderReviews object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerOrderReviewsBuilder result,
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
            specifiedType: const FullType(BuyerOrderReviewsStateEnum),
          ) as BuyerOrderReviewsStateEnum;
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
            specifiedType: const FullType.nullable(BuyerOrderReviewsRevealReasonEnum),
          ) as BuyerOrderReviewsRevealReasonEnum?;
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
            specifiedType: const FullType(BuyerOrderReviewsPartyEnum),
          ) as BuyerOrderReviewsPartyEnum;
          result.party = valueDes;
          break;
        case r'speed_kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerOrderReviewsSpeedKindEnum),
          ) as BuyerOrderReviewsSpeedKindEnum;
          result.speedKind = valueDes;
          break;
        case r'speed_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.speedLabel = valueDes;
          break;
        case r'display_name_options':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ReviewDisplayOption)]),
          ) as BuiltList<ReviewDisplayOption>;
          result.displayNameOptions.replace(valueDes);
          break;
        case r'vendor_rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(OwnReview),
          ) as OwnReview?;
          if (valueDes == null) continue;
          result.vendorRating.replace(valueDes);
          break;
        case r'can_submit_vendor_rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canSubmitVendorRating = valueDes;
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ReviewLine)]),
          ) as BuiltList<ReviewLine>;
          result.lines.replace(valueDes);
          break;
        case r'counterpart_rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(CounterpartRating),
          ) as CounterpartRating?;
          if (valueDes == null) continue;
          result.counterpartRating.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerOrderReviews deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerOrderReviewsBuilder();
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


class BuyerOrderReviewsStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NOT_COMPLETED')
  static const BuyerOrderReviewsStateEnum NOT_COMPLETED = _$buyerOrderReviewsStateEnum_NOT_COMPLETED;
  @BuiltValueEnumConst(wireName: r'OPEN')
  static const BuyerOrderReviewsStateEnum OPEN = _$buyerOrderReviewsStateEnum_OPEN;
  @BuiltValueEnumConst(wireName: r'CLOSED')
  static const BuyerOrderReviewsStateEnum CLOSED = _$buyerOrderReviewsStateEnum_CLOSED;

  static Serializer<BuyerOrderReviewsStateEnum> get serializer => _$buyerOrderReviewsStateEnumSerializer;

  const BuyerOrderReviewsStateEnum._(String name): super(name);

  static BuiltSet<BuyerOrderReviewsStateEnum> get values => _$buyerOrderReviewsStateEnumValues;
  static BuyerOrderReviewsStateEnum valueOf(String name) => _$buyerOrderReviewsStateEnumValueOf(name);
}

class BuyerOrderReviewsRevealReasonEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BOTH_SUBMITTED')
  static const BuyerOrderReviewsRevealReasonEnum BOTH_SUBMITTED = _$buyerOrderReviewsRevealReasonEnum_BOTH_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'WINDOW_EXPIRED')
  static const BuyerOrderReviewsRevealReasonEnum WINDOW_EXPIRED = _$buyerOrderReviewsRevealReasonEnum_WINDOW_EXPIRED;

  static Serializer<BuyerOrderReviewsRevealReasonEnum> get serializer => _$buyerOrderReviewsRevealReasonEnumSerializer;

  const BuyerOrderReviewsRevealReasonEnum._(String name): super(name);

  static BuiltSet<BuyerOrderReviewsRevealReasonEnum> get values => _$buyerOrderReviewsRevealReasonEnumValues;
  static BuyerOrderReviewsRevealReasonEnum valueOf(String name) => _$buyerOrderReviewsRevealReasonEnumValueOf(name);
}

class BuyerOrderReviewsPartyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const BuyerOrderReviewsPartyEnum BUYER = _$buyerOrderReviewsPartyEnum_BUYER;

  static Serializer<BuyerOrderReviewsPartyEnum> get serializer => _$buyerOrderReviewsPartyEnumSerializer;

  const BuyerOrderReviewsPartyEnum._(String name): super(name);

  static BuiltSet<BuyerOrderReviewsPartyEnum> get values => _$buyerOrderReviewsPartyEnumValues;
  static BuyerOrderReviewsPartyEnum valueOf(String name) => _$buyerOrderReviewsPartyEnumValueOf(name);
}

class BuyerOrderReviewsSpeedKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELIVERY_SPEED')
  static const BuyerOrderReviewsSpeedKindEnum DELIVERY_SPEED = _$buyerOrderReviewsSpeedKindEnum_DELIVERY_SPEED;
  @BuiltValueEnumConst(wireName: r'PROCESSING_SPEED')
  static const BuyerOrderReviewsSpeedKindEnum PROCESSING_SPEED = _$buyerOrderReviewsSpeedKindEnum_PROCESSING_SPEED;

  static Serializer<BuyerOrderReviewsSpeedKindEnum> get serializer => _$buyerOrderReviewsSpeedKindEnumSerializer;

  const BuyerOrderReviewsSpeedKindEnum._(String name): super(name);

  static BuiltSet<BuyerOrderReviewsSpeedKindEnum> get values => _$buyerOrderReviewsSpeedKindEnumValues;
  static BuyerOrderReviewsSpeedKindEnum valueOf(String name) => _$buyerOrderReviewsSpeedKindEnumValueOf(name);
}

