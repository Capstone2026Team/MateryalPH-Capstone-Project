//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/dispute_sanction_input.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dispute_appeal_decision_request.g.dart';

/// Reviewed by an Admin who did not make the appealed decision (409 CONFLICT_OF_INTEREST otherwise). Final and executed at once.
///
/// Properties:
/// * [result]
/// * [outcome]
/// * [reason]
/// * [amountCentavos]
/// * [affectedLineIds]
/// * [conflictCheckConfirmed]
/// * [sanctions]
/// * [metricEvent]
/// * [lockVersion]
@BuiltValue()
abstract class AdminDisputeAppealDecisionRequest implements Built<AdminDisputeAppealDecisionRequest, AdminDisputeAppealDecisionRequestBuilder> {
  @BuiltValueField(wireName: r'result')
  AdminDisputeAppealDecisionRequestResultEnum get result;
  // enum resultEnum {  AFFIRMED,  MODIFIED,  REVERSED,  };

  @BuiltValueField(wireName: r'outcome')
  AdminDisputeAppealDecisionRequestOutcomeEnum? get outcome;
  // enum outcomeEnum {  DISMISSED,  REPLACEMENT,  FULL_REFUND,  PARTIAL_REFUND,  INCONCLUSIVE,  };

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'amount_centavos')
  int? get amountCentavos;

  @BuiltValueField(wireName: r'affected_line_ids')
  BuiltList<String>? get affectedLineIds;

  @BuiltValueField(wireName: r'conflict_check_confirmed')
  bool get conflictCheckConfirmed;

  @BuiltValueField(wireName: r'sanctions')
  BuiltList<DisputeSanctionInput>? get sanctions;

  @BuiltValueField(wireName: r'metric_event')
  AdminDisputeAppealDecisionRequestMetricEventEnum? get metricEvent;
  // enum metricEventEnum {  VALIDATED_DEFECT_RETURN,  VENDOR_NON_FULFILLMENT,  MISREPRESENTED_LISTING,  };

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  AdminDisputeAppealDecisionRequest._();

  factory AdminDisputeAppealDecisionRequest([void updates(AdminDisputeAppealDecisionRequestBuilder b)]) = _$AdminDisputeAppealDecisionRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDisputeAppealDecisionRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDisputeAppealDecisionRequest> get serializer => _$AdminDisputeAppealDecisionRequestSerializer();
}

class _$AdminDisputeAppealDecisionRequestSerializer implements PrimitiveSerializer<AdminDisputeAppealDecisionRequest> {
  @override
  final Iterable<Type> types = const [AdminDisputeAppealDecisionRequest, _$AdminDisputeAppealDecisionRequest];

  @override
  final String wireName = r'AdminDisputeAppealDecisionRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDisputeAppealDecisionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'result';
    yield serializers.serialize(
      object.result,
      specifiedType: const FullType(AdminDisputeAppealDecisionRequestResultEnum),
    );
    if (object.outcome != null) {
      yield r'outcome';
      yield serializers.serialize(
        object.outcome,
        specifiedType: const FullType(AdminDisputeAppealDecisionRequestOutcomeEnum),
      );
    }
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    if (object.amountCentavos != null) {
      yield r'amount_centavos';
      yield serializers.serialize(
        object.amountCentavos,
        specifiedType: const FullType(int),
      );
    }
    if (object.affectedLineIds != null) {
      yield r'affected_line_ids';
      yield serializers.serialize(
        object.affectedLineIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    yield r'conflict_check_confirmed';
    yield serializers.serialize(
      object.conflictCheckConfirmed,
      specifiedType: const FullType(bool),
    );
    if (object.sanctions != null) {
      yield r'sanctions';
      yield serializers.serialize(
        object.sanctions,
        specifiedType: const FullType(BuiltList, [FullType(DisputeSanctionInput)]),
      );
    }
    if (object.metricEvent != null) {
      yield r'metric_event';
      yield serializers.serialize(
        object.metricEvent,
        specifiedType: const FullType(AdminDisputeAppealDecisionRequestMetricEventEnum),
      );
    }
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDisputeAppealDecisionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDisputeAppealDecisionRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'result':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminDisputeAppealDecisionRequestResultEnum),
          ) as AdminDisputeAppealDecisionRequestResultEnum;
          result.result = valueDes;
          break;
        case r'outcome':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AdminDisputeAppealDecisionRequestOutcomeEnum),
          ) as AdminDisputeAppealDecisionRequestOutcomeEnum?;
          if (valueDes == null) continue;
          result.outcome = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'amount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.amountCentavos = valueDes;
          break;
        case r'affected_line_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.affectedLineIds.replace(valueDes);
          break;
        case r'conflict_check_confirmed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.conflictCheckConfirmed = valueDes;
          break;
        case r'sanctions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(DisputeSanctionInput)]),
          ) as BuiltList<DisputeSanctionInput>?;
          if (valueDes == null) continue;
          result.sanctions.replace(valueDes);
          break;
        case r'metric_event':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AdminDisputeAppealDecisionRequestMetricEventEnum),
          ) as AdminDisputeAppealDecisionRequestMetricEventEnum?;
          if (valueDes == null) continue;
          result.metricEvent = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDisputeAppealDecisionRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDisputeAppealDecisionRequestBuilder();
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


class AdminDisputeAppealDecisionRequestResultEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'AFFIRMED')
  static const AdminDisputeAppealDecisionRequestResultEnum AFFIRMED = _$adminDisputeAppealDecisionRequestResultEnum_AFFIRMED;
  @BuiltValueEnumConst(wireName: r'MODIFIED')
  static const AdminDisputeAppealDecisionRequestResultEnum MODIFIED = _$adminDisputeAppealDecisionRequestResultEnum_MODIFIED;
  @BuiltValueEnumConst(wireName: r'REVERSED')
  static const AdminDisputeAppealDecisionRequestResultEnum REVERSED = _$adminDisputeAppealDecisionRequestResultEnum_REVERSED;

  static Serializer<AdminDisputeAppealDecisionRequestResultEnum> get serializer => _$adminDisputeAppealDecisionRequestResultEnumSerializer;

  const AdminDisputeAppealDecisionRequestResultEnum._(String name): super(name);

  static BuiltSet<AdminDisputeAppealDecisionRequestResultEnum> get values => _$adminDisputeAppealDecisionRequestResultEnumValues;
  static AdminDisputeAppealDecisionRequestResultEnum valueOf(String name) => _$adminDisputeAppealDecisionRequestResultEnumValueOf(name);
}

class AdminDisputeAppealDecisionRequestOutcomeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DISMISSED')
  static const AdminDisputeAppealDecisionRequestOutcomeEnum DISMISSED = _$adminDisputeAppealDecisionRequestOutcomeEnum_DISMISSED;
  @BuiltValueEnumConst(wireName: r'REPLACEMENT')
  static const AdminDisputeAppealDecisionRequestOutcomeEnum REPLACEMENT = _$adminDisputeAppealDecisionRequestOutcomeEnum_REPLACEMENT;
  @BuiltValueEnumConst(wireName: r'FULL_REFUND')
  static const AdminDisputeAppealDecisionRequestOutcomeEnum FULL_REFUND = _$adminDisputeAppealDecisionRequestOutcomeEnum_FULL_REFUND;
  @BuiltValueEnumConst(wireName: r'PARTIAL_REFUND')
  static const AdminDisputeAppealDecisionRequestOutcomeEnum PARTIAL_REFUND = _$adminDisputeAppealDecisionRequestOutcomeEnum_PARTIAL_REFUND;
  @BuiltValueEnumConst(wireName: r'INCONCLUSIVE')
  static const AdminDisputeAppealDecisionRequestOutcomeEnum INCONCLUSIVE = _$adminDisputeAppealDecisionRequestOutcomeEnum_INCONCLUSIVE;

  static Serializer<AdminDisputeAppealDecisionRequestOutcomeEnum> get serializer => _$adminDisputeAppealDecisionRequestOutcomeEnumSerializer;

  const AdminDisputeAppealDecisionRequestOutcomeEnum._(String name): super(name);

  static BuiltSet<AdminDisputeAppealDecisionRequestOutcomeEnum> get values => _$adminDisputeAppealDecisionRequestOutcomeEnumValues;
  static AdminDisputeAppealDecisionRequestOutcomeEnum valueOf(String name) => _$adminDisputeAppealDecisionRequestOutcomeEnumValueOf(name);
}

class AdminDisputeAppealDecisionRequestMetricEventEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VALIDATED_DEFECT_RETURN')
  static const AdminDisputeAppealDecisionRequestMetricEventEnum VALIDATED_DEFECT_RETURN = _$adminDisputeAppealDecisionRequestMetricEventEnum_VALIDATED_DEFECT_RETURN;
  @BuiltValueEnumConst(wireName: r'VENDOR_NON_FULFILLMENT')
  static const AdminDisputeAppealDecisionRequestMetricEventEnum VENDOR_NON_FULFILLMENT = _$adminDisputeAppealDecisionRequestMetricEventEnum_VENDOR_NON_FULFILLMENT;
  @BuiltValueEnumConst(wireName: r'MISREPRESENTED_LISTING')
  static const AdminDisputeAppealDecisionRequestMetricEventEnum MISREPRESENTED_LISTING = _$adminDisputeAppealDecisionRequestMetricEventEnum_MISREPRESENTED_LISTING;

  static Serializer<AdminDisputeAppealDecisionRequestMetricEventEnum> get serializer => _$adminDisputeAppealDecisionRequestMetricEventEnumSerializer;

  const AdminDisputeAppealDecisionRequestMetricEventEnum._(String name): super(name);

  static BuiltSet<AdminDisputeAppealDecisionRequestMetricEventEnum> get values => _$adminDisputeAppealDecisionRequestMetricEventEnumValues;
  static AdminDisputeAppealDecisionRequestMetricEventEnum valueOf(String name) => _$adminDisputeAppealDecisionRequestMetricEventEnumValueOf(name);
}

