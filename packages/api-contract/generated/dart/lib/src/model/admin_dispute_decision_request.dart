//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/dispute_sanction_input.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dispute_decision_request.g.dart';

/// The remedy, the reason and the conflict check are required. A stale lock_version returns 409.
///
/// Properties:
/// * [outcome]
/// * [reason]
/// * [amountCentavos]
/// * [affectedLineIds]
/// * [enforceable] - Immediately enforceable; otherwise the award executes when the five-business-day appeal window lapses unappealed.
/// * [conflictCheckConfirmed]
/// * [evidenceLimitation]
/// * [sanctions]
/// * [metricEvent]
/// * [lockVersion]
@BuiltValue()
abstract class AdminDisputeDecisionRequest implements Built<AdminDisputeDecisionRequest, AdminDisputeDecisionRequestBuilder> {
  @BuiltValueField(wireName: r'outcome')
  AdminDisputeDecisionRequestOutcomeEnum get outcome;
  // enum outcomeEnum {  DISMISSED,  REPLACEMENT,  FULL_REFUND,  PARTIAL_REFUND,  INCONCLUSIVE,  };

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'amount_centavos')
  int? get amountCentavos;

  @BuiltValueField(wireName: r'affected_line_ids')
  BuiltList<String>? get affectedLineIds;

  /// Immediately enforceable; otherwise the award executes when the five-business-day appeal window lapses unappealed.
  @BuiltValueField(wireName: r'enforceable')
  bool get enforceable;

  @BuiltValueField(wireName: r'conflict_check_confirmed')
  bool get conflictCheckConfirmed;

  @BuiltValueField(wireName: r'evidence_limitation')
  String? get evidenceLimitation;

  @BuiltValueField(wireName: r'sanctions')
  BuiltList<DisputeSanctionInput>? get sanctions;

  @BuiltValueField(wireName: r'metric_event')
  AdminDisputeDecisionRequestMetricEventEnum? get metricEvent;
  // enum metricEventEnum {  VALIDATED_DEFECT_RETURN,  VENDOR_NON_FULFILLMENT,  MISREPRESENTED_LISTING,  };

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  AdminDisputeDecisionRequest._();

  factory AdminDisputeDecisionRequest([void updates(AdminDisputeDecisionRequestBuilder b)]) = _$AdminDisputeDecisionRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDisputeDecisionRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDisputeDecisionRequest> get serializer => _$AdminDisputeDecisionRequestSerializer();
}

class _$AdminDisputeDecisionRequestSerializer implements PrimitiveSerializer<AdminDisputeDecisionRequest> {
  @override
  final Iterable<Type> types = const [AdminDisputeDecisionRequest, _$AdminDisputeDecisionRequest];

  @override
  final String wireName = r'AdminDisputeDecisionRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDisputeDecisionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'outcome';
    yield serializers.serialize(
      object.outcome,
      specifiedType: const FullType(AdminDisputeDecisionRequestOutcomeEnum),
    );
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
    yield r'enforceable';
    yield serializers.serialize(
      object.enforceable,
      specifiedType: const FullType(bool),
    );
    yield r'conflict_check_confirmed';
    yield serializers.serialize(
      object.conflictCheckConfirmed,
      specifiedType: const FullType(bool),
    );
    if (object.evidenceLimitation != null) {
      yield r'evidence_limitation';
      yield serializers.serialize(
        object.evidenceLimitation,
        specifiedType: const FullType(String),
      );
    }
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
        specifiedType: const FullType(AdminDisputeDecisionRequestMetricEventEnum),
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
    AdminDisputeDecisionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDisputeDecisionRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'outcome':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminDisputeDecisionRequestOutcomeEnum),
          ) as AdminDisputeDecisionRequestOutcomeEnum;
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
        case r'enforceable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enforceable = valueDes;
          break;
        case r'conflict_check_confirmed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.conflictCheckConfirmed = valueDes;
          break;
        case r'evidence_limitation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.evidenceLimitation = valueDes;
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
            specifiedType: const FullType.nullable(AdminDisputeDecisionRequestMetricEventEnum),
          ) as AdminDisputeDecisionRequestMetricEventEnum?;
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
  AdminDisputeDecisionRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDisputeDecisionRequestBuilder();
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


class AdminDisputeDecisionRequestOutcomeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DISMISSED')
  static const AdminDisputeDecisionRequestOutcomeEnum DISMISSED = _$adminDisputeDecisionRequestOutcomeEnum_DISMISSED;
  @BuiltValueEnumConst(wireName: r'REPLACEMENT')
  static const AdminDisputeDecisionRequestOutcomeEnum REPLACEMENT = _$adminDisputeDecisionRequestOutcomeEnum_REPLACEMENT;
  @BuiltValueEnumConst(wireName: r'FULL_REFUND')
  static const AdminDisputeDecisionRequestOutcomeEnum FULL_REFUND = _$adminDisputeDecisionRequestOutcomeEnum_FULL_REFUND;
  @BuiltValueEnumConst(wireName: r'PARTIAL_REFUND')
  static const AdminDisputeDecisionRequestOutcomeEnum PARTIAL_REFUND = _$adminDisputeDecisionRequestOutcomeEnum_PARTIAL_REFUND;
  @BuiltValueEnumConst(wireName: r'INCONCLUSIVE')
  static const AdminDisputeDecisionRequestOutcomeEnum INCONCLUSIVE = _$adminDisputeDecisionRequestOutcomeEnum_INCONCLUSIVE;

  static Serializer<AdminDisputeDecisionRequestOutcomeEnum> get serializer => _$adminDisputeDecisionRequestOutcomeEnumSerializer;

  const AdminDisputeDecisionRequestOutcomeEnum._(String name): super(name);

  static BuiltSet<AdminDisputeDecisionRequestOutcomeEnum> get values => _$adminDisputeDecisionRequestOutcomeEnumValues;
  static AdminDisputeDecisionRequestOutcomeEnum valueOf(String name) => _$adminDisputeDecisionRequestOutcomeEnumValueOf(name);
}

class AdminDisputeDecisionRequestMetricEventEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VALIDATED_DEFECT_RETURN')
  static const AdminDisputeDecisionRequestMetricEventEnum VALIDATED_DEFECT_RETURN = _$adminDisputeDecisionRequestMetricEventEnum_VALIDATED_DEFECT_RETURN;
  @BuiltValueEnumConst(wireName: r'VENDOR_NON_FULFILLMENT')
  static const AdminDisputeDecisionRequestMetricEventEnum VENDOR_NON_FULFILLMENT = _$adminDisputeDecisionRequestMetricEventEnum_VENDOR_NON_FULFILLMENT;
  @BuiltValueEnumConst(wireName: r'MISREPRESENTED_LISTING')
  static const AdminDisputeDecisionRequestMetricEventEnum MISREPRESENTED_LISTING = _$adminDisputeDecisionRequestMetricEventEnum_MISREPRESENTED_LISTING;

  static Serializer<AdminDisputeDecisionRequestMetricEventEnum> get serializer => _$adminDisputeDecisionRequestMetricEventEnumSerializer;

  const AdminDisputeDecisionRequestMetricEventEnum._(String name): super(name);

  static BuiltSet<AdminDisputeDecisionRequestMetricEventEnum> get values => _$adminDisputeDecisionRequestMetricEventEnumValues;
  static AdminDisputeDecisionRequestMetricEventEnum valueOf(String name) => _$adminDisputeDecisionRequestMetricEventEnumValueOf(name);
}

