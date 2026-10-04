//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/dispute_admin_party.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/dispute_refundable.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_admin_context.g.dart';

/// Decision support for Order and Dispute Staff. Refundable amounts return only to the original payments; Admins never hold or disburse money.
///
/// Properties:
/// * [outcomes]
/// * [sanctions]
/// * [metricEvents]
/// * [refundable]
/// * [alreadyAwardedCentavos]
/// * [appealReviewerConflict]
/// * [unansweredClarification]
/// * [buyer]
/// * [vendor]
/// * [orderTimeline]
/// * [enforcement]
@BuiltValue()
abstract class DisputeAdminContext implements Built<DisputeAdminContext, DisputeAdminContextBuilder> {
  @BuiltValueField(wireName: r'outcomes')
  BuiltList<DisputeAdminContextOutcomesEnum> get outcomes;
  // enum outcomesEnum {  DISMISSED,  REPLACEMENT,  FULL_REFUND,  PARTIAL_REFUND,  INCONCLUSIVE,  NO_FURTHER_ACTION,  };

  @BuiltValueField(wireName: r'sanctions')
  BuiltList<DisputeAdminContextSanctionsEnum> get sanctions;
  // enum sanctionsEnum {  WARNING,  TEMPORARY_RESTRICTION,  SUSPENSION,  PERMANENT_BAN,  };

  @BuiltValueField(wireName: r'metric_events')
  BuiltList<DisputeAdminContextMetricEventsEnum> get metricEvents;
  // enum metricEventsEnum {  VALIDATED_DEFECT_RETURN,  VENDOR_NON_FULFILLMENT,  MISREPRESENTED_LISTING,  };

  @BuiltValueField(wireName: r'refundable')
  DisputeRefundable get refundable;

  @BuiltValueField(wireName: r'already_awarded_centavos')
  int get alreadyAwardedCentavos;

  @BuiltValueField(wireName: r'appeal_reviewer_conflict')
  bool get appealReviewerConflict;

  @BuiltValueField(wireName: r'unanswered_clarification')
  bool get unansweredClarification;

  @BuiltValueField(wireName: r'buyer')
  DisputeAdminParty get buyer;

  @BuiltValueField(wireName: r'vendor')
  DisputeAdminParty get vendor;

  @BuiltValueField(wireName: r'order_timeline')
  BuiltList<BuiltMap<String, JsonObject?>> get orderTimeline;

  @BuiltValueField(wireName: r'enforcement')
  BuiltList<BuiltMap<String, JsonObject?>> get enforcement;

  DisputeAdminContext._();

  factory DisputeAdminContext([void updates(DisputeAdminContextBuilder b)]) = _$DisputeAdminContext;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeAdminContextBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeAdminContext> get serializer => _$DisputeAdminContextSerializer();
}

class _$DisputeAdminContextSerializer implements PrimitiveSerializer<DisputeAdminContext> {
  @override
  final Iterable<Type> types = const [DisputeAdminContext, _$DisputeAdminContext];

  @override
  final String wireName = r'DisputeAdminContext';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeAdminContext object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'outcomes';
    yield serializers.serialize(
      object.outcomes,
      specifiedType: const FullType(BuiltList, [FullType(DisputeAdminContextOutcomesEnum)]),
    );
    yield r'sanctions';
    yield serializers.serialize(
      object.sanctions,
      specifiedType: const FullType(BuiltList, [FullType(DisputeAdminContextSanctionsEnum)]),
    );
    yield r'metric_events';
    yield serializers.serialize(
      object.metricEvents,
      specifiedType: const FullType(BuiltList, [FullType(DisputeAdminContextMetricEventsEnum)]),
    );
    yield r'refundable';
    yield serializers.serialize(
      object.refundable,
      specifiedType: const FullType(DisputeRefundable),
    );
    yield r'already_awarded_centavos';
    yield serializers.serialize(
      object.alreadyAwardedCentavos,
      specifiedType: const FullType(int),
    );
    yield r'appeal_reviewer_conflict';
    yield serializers.serialize(
      object.appealReviewerConflict,
      specifiedType: const FullType(bool),
    );
    yield r'unanswered_clarification';
    yield serializers.serialize(
      object.unansweredClarification,
      specifiedType: const FullType(bool),
    );
    yield r'buyer';
    yield serializers.serialize(
      object.buyer,
      specifiedType: const FullType(DisputeAdminParty),
    );
    yield r'vendor';
    yield serializers.serialize(
      object.vendor,
      specifiedType: const FullType(DisputeAdminParty),
    );
    yield r'order_timeline';
    yield serializers.serialize(
      object.orderTimeline,
      specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
    );
    yield r'enforcement';
    yield serializers.serialize(
      object.enforcement,
      specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeAdminContext object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeAdminContextBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'outcomes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DisputeAdminContextOutcomesEnum)]),
          ) as BuiltList<DisputeAdminContextOutcomesEnum>;
          result.outcomes.replace(valueDes);
          break;
        case r'sanctions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DisputeAdminContextSanctionsEnum)]),
          ) as BuiltList<DisputeAdminContextSanctionsEnum>;
          result.sanctions.replace(valueDes);
          break;
        case r'metric_events':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DisputeAdminContextMetricEventsEnum)]),
          ) as BuiltList<DisputeAdminContextMetricEventsEnum>;
          result.metricEvents.replace(valueDes);
          break;
        case r'refundable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeRefundable),
          ) as DisputeRefundable;
          result.refundable.replace(valueDes);
          break;
        case r'already_awarded_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.alreadyAwardedCentavos = valueDes;
          break;
        case r'appeal_reviewer_conflict':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.appealReviewerConflict = valueDes;
          break;
        case r'unanswered_clarification':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.unansweredClarification = valueDes;
          break;
        case r'buyer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeAdminParty),
          ) as DisputeAdminParty;
          result.buyer.replace(valueDes);
          break;
        case r'vendor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeAdminParty),
          ) as DisputeAdminParty;
          result.vendor.replace(valueDes);
          break;
        case r'order_timeline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>;
          result.orderTimeline.replace(valueDes);
          break;
        case r'enforcement':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>;
          result.enforcement.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeAdminContext deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeAdminContextBuilder();
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


class DisputeAdminContextOutcomesEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DISMISSED')
  static const DisputeAdminContextOutcomesEnum DISMISSED = _$disputeAdminContextOutcomesEnum_DISMISSED;
  @BuiltValueEnumConst(wireName: r'REPLACEMENT')
  static const DisputeAdminContextOutcomesEnum REPLACEMENT = _$disputeAdminContextOutcomesEnum_REPLACEMENT;
  @BuiltValueEnumConst(wireName: r'FULL_REFUND')
  static const DisputeAdminContextOutcomesEnum FULL_REFUND = _$disputeAdminContextOutcomesEnum_FULL_REFUND;
  @BuiltValueEnumConst(wireName: r'PARTIAL_REFUND')
  static const DisputeAdminContextOutcomesEnum PARTIAL_REFUND = _$disputeAdminContextOutcomesEnum_PARTIAL_REFUND;
  @BuiltValueEnumConst(wireName: r'INCONCLUSIVE')
  static const DisputeAdminContextOutcomesEnum INCONCLUSIVE = _$disputeAdminContextOutcomesEnum_INCONCLUSIVE;
  @BuiltValueEnumConst(wireName: r'NO_FURTHER_ACTION')
  static const DisputeAdminContextOutcomesEnum NO_FURTHER_ACTION = _$disputeAdminContextOutcomesEnum_NO_FURTHER_ACTION;

  static Serializer<DisputeAdminContextOutcomesEnum> get serializer => _$disputeAdminContextOutcomesEnumSerializer;

  const DisputeAdminContextOutcomesEnum._(String name): super(name);

  static BuiltSet<DisputeAdminContextOutcomesEnum> get values => _$disputeAdminContextOutcomesEnumValues;
  static DisputeAdminContextOutcomesEnum valueOf(String name) => _$disputeAdminContextOutcomesEnumValueOf(name);
}

class DisputeAdminContextSanctionsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'WARNING')
  static const DisputeAdminContextSanctionsEnum WARNING = _$disputeAdminContextSanctionsEnum_WARNING;
  @BuiltValueEnumConst(wireName: r'TEMPORARY_RESTRICTION')
  static const DisputeAdminContextSanctionsEnum TEMPORARY_RESTRICTION = _$disputeAdminContextSanctionsEnum_TEMPORARY_RESTRICTION;
  @BuiltValueEnumConst(wireName: r'SUSPENSION')
  static const DisputeAdminContextSanctionsEnum SUSPENSION = _$disputeAdminContextSanctionsEnum_SUSPENSION;
  @BuiltValueEnumConst(wireName: r'PERMANENT_BAN')
  static const DisputeAdminContextSanctionsEnum PERMANENT_BAN = _$disputeAdminContextSanctionsEnum_PERMANENT_BAN;

  static Serializer<DisputeAdminContextSanctionsEnum> get serializer => _$disputeAdminContextSanctionsEnumSerializer;

  const DisputeAdminContextSanctionsEnum._(String name): super(name);

  static BuiltSet<DisputeAdminContextSanctionsEnum> get values => _$disputeAdminContextSanctionsEnumValues;
  static DisputeAdminContextSanctionsEnum valueOf(String name) => _$disputeAdminContextSanctionsEnumValueOf(name);
}

class DisputeAdminContextMetricEventsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VALIDATED_DEFECT_RETURN')
  static const DisputeAdminContextMetricEventsEnum VALIDATED_DEFECT_RETURN = _$disputeAdminContextMetricEventsEnum_VALIDATED_DEFECT_RETURN;
  @BuiltValueEnumConst(wireName: r'VENDOR_NON_FULFILLMENT')
  static const DisputeAdminContextMetricEventsEnum VENDOR_NON_FULFILLMENT = _$disputeAdminContextMetricEventsEnum_VENDOR_NON_FULFILLMENT;
  @BuiltValueEnumConst(wireName: r'MISREPRESENTED_LISTING')
  static const DisputeAdminContextMetricEventsEnum MISREPRESENTED_LISTING = _$disputeAdminContextMetricEventsEnum_MISREPRESENTED_LISTING;

  static Serializer<DisputeAdminContextMetricEventsEnum> get serializer => _$disputeAdminContextMetricEventsEnumSerializer;

  const DisputeAdminContextMetricEventsEnum._(String name): super(name);

  static BuiltSet<DisputeAdminContextMetricEventsEnum> get values => _$disputeAdminContextMetricEventsEnumValues;
  static DisputeAdminContextMetricEventsEnum valueOf(String name) => _$disputeAdminContextMetricEventsEnumValueOf(name);
}

