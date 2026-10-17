//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_decision.g.dart';

/// Immutable decision versions. An appeal decision supersedes without erasing the original.
///
/// Properties:
/// * [id]
/// * [version]
/// * [kind]
/// * [outcome]
/// * [appealResult]
/// * [awardedCentavos]
/// * [reason]
/// * [evidenceLimitation]
/// * [enforceable]
/// * [decidedAt]
/// * [appealDueAt]
/// * [supersedesDecisionId]
/// * [deciderRole]
/// * [deciderName]
/// * [sanctions]
/// * [current]
@BuiltValue()
abstract class DisputeDecision implements Built<DisputeDecision, DisputeDecisionBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'kind')
  DisputeDecisionKindEnum get kind;
  // enum kindEnum {  ADMIN_DECISION,  APPEAL_DECISION,  MUTUAL_AGREEMENT,  };

  @BuiltValueField(wireName: r'outcome')
  DisputeDecisionOutcomeEnum get outcome;
  // enum outcomeEnum {  DISMISSED,  REPLACEMENT,  FULL_REFUND,  PARTIAL_REFUND,  INCONCLUSIVE,  NO_FURTHER_ACTION,  };

  @BuiltValueField(wireName: r'appeal_result')
  DisputeDecisionAppealResultEnum? get appealResult;
  // enum appealResultEnum {  AFFIRMED,  MODIFIED,  REVERSED,  };

  @BuiltValueField(wireName: r'awarded_centavos')
  int get awardedCentavos;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'evidence_limitation')
  String? get evidenceLimitation;

  @BuiltValueField(wireName: r'enforceable')
  bool get enforceable;

  @BuiltValueField(wireName: r'decided_at')
  DateTime? get decidedAt;

  @BuiltValueField(wireName: r'appeal_due_at')
  DateTime? get appealDueAt;

  @BuiltValueField(wireName: r'supersedes_decision_id')
  String? get supersedesDecisionId;

  @BuiltValueField(wireName: r'decider_role')
  String get deciderRole;

  @BuiltValueField(wireName: r'decider_name')
  String? get deciderName;

  @BuiltValueField(wireName: r'sanctions')
  BuiltMap<String, JsonObject?>? get sanctions;

  @BuiltValueField(wireName: r'current')
  bool get current;

  DisputeDecision._();

  factory DisputeDecision([void updates(DisputeDecisionBuilder b)]) = _$DisputeDecision;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeDecisionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeDecision> get serializer => _$DisputeDecisionSerializer();
}

class _$DisputeDecisionSerializer implements PrimitiveSerializer<DisputeDecision> {
  @override
  final Iterable<Type> types = const [DisputeDecision, _$DisputeDecision];

  @override
  final String wireName = r'DisputeDecision';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeDecision object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(DisputeDecisionKindEnum),
    );
    yield r'outcome';
    yield serializers.serialize(
      object.outcome,
      specifiedType: const FullType(DisputeDecisionOutcomeEnum),
    );
    if (object.appealResult != null) {
      yield r'appeal_result';
      yield serializers.serialize(
        object.appealResult,
        specifiedType: const FullType(DisputeDecisionAppealResultEnum),
      );
    }
    yield r'awarded_centavos';
    yield serializers.serialize(
      object.awardedCentavos,
      specifiedType: const FullType(int),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
    if (object.evidenceLimitation != null) {
      yield r'evidence_limitation';
      yield serializers.serialize(
        object.evidenceLimitation,
        specifiedType: const FullType(String),
      );
    }
    yield r'enforceable';
    yield serializers.serialize(
      object.enforceable,
      specifiedType: const FullType(bool),
    );
    if (object.decidedAt != null) {
      yield r'decided_at';
      yield serializers.serialize(
        object.decidedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.appealDueAt != null) {
      yield r'appeal_due_at';
      yield serializers.serialize(
        object.appealDueAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.supersedesDecisionId != null) {
      yield r'supersedes_decision_id';
      yield serializers.serialize(
        object.supersedesDecisionId,
        specifiedType: const FullType(String),
      );
    }
    yield r'decider_role';
    yield serializers.serialize(
      object.deciderRole,
      specifiedType: const FullType(String),
    );
    if (object.deciderName != null) {
      yield r'decider_name';
      yield serializers.serialize(
        object.deciderName,
        specifiedType: const FullType(String),
      );
    }
    if (object.sanctions != null) {
      yield r'sanctions';
      yield serializers.serialize(
        object.sanctions,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    yield r'current';
    yield serializers.serialize(
      object.current,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeDecision object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeDecisionBuilder result,
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
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeDecisionKindEnum),
          ) as DisputeDecisionKindEnum;
          result.kind = valueDes;
          break;
        case r'outcome':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeDecisionOutcomeEnum),
          ) as DisputeDecisionOutcomeEnum;
          result.outcome = valueDes;
          break;
        case r'appeal_result':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DisputeDecisionAppealResultEnum),
          ) as DisputeDecisionAppealResultEnum?;
          if (valueDes == null) continue;
          result.appealResult = valueDes;
          break;
        case r'awarded_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.awardedCentavos = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'evidence_limitation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.evidenceLimitation = valueDes;
          break;
        case r'enforceable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enforceable = valueDes;
          break;
        case r'decided_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.decidedAt = valueDes;
          break;
        case r'appeal_due_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.appealDueAt = valueDes;
          break;
        case r'supersedes_decision_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.supersedesDecisionId = valueDes;
          break;
        case r'decider_role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.deciderRole = valueDes;
          break;
        case r'decider_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.deciderName = valueDes;
          break;
        case r'sanctions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.sanctions.replace(valueDes);
          break;
        case r'current':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.current = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeDecision deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeDecisionBuilder();
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


class DisputeDecisionKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ADMIN_DECISION')
  static const DisputeDecisionKindEnum ADMIN_DECISION = _$disputeDecisionKindEnum_ADMIN_DECISION;
  @BuiltValueEnumConst(wireName: r'APPEAL_DECISION')
  static const DisputeDecisionKindEnum APPEAL_DECISION = _$disputeDecisionKindEnum_APPEAL_DECISION;
  @BuiltValueEnumConst(wireName: r'MUTUAL_AGREEMENT')
  static const DisputeDecisionKindEnum MUTUAL_AGREEMENT = _$disputeDecisionKindEnum_MUTUAL_AGREEMENT;

  static Serializer<DisputeDecisionKindEnum> get serializer => _$disputeDecisionKindEnumSerializer;

  const DisputeDecisionKindEnum._(String name): super(name);

  static BuiltSet<DisputeDecisionKindEnum> get values => _$disputeDecisionKindEnumValues;
  static DisputeDecisionKindEnum valueOf(String name) => _$disputeDecisionKindEnumValueOf(name);
}

class DisputeDecisionOutcomeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DISMISSED')
  static const DisputeDecisionOutcomeEnum DISMISSED = _$disputeDecisionOutcomeEnum_DISMISSED;
  @BuiltValueEnumConst(wireName: r'REPLACEMENT')
  static const DisputeDecisionOutcomeEnum REPLACEMENT = _$disputeDecisionOutcomeEnum_REPLACEMENT;
  @BuiltValueEnumConst(wireName: r'FULL_REFUND')
  static const DisputeDecisionOutcomeEnum FULL_REFUND = _$disputeDecisionOutcomeEnum_FULL_REFUND;
  @BuiltValueEnumConst(wireName: r'PARTIAL_REFUND')
  static const DisputeDecisionOutcomeEnum PARTIAL_REFUND = _$disputeDecisionOutcomeEnum_PARTIAL_REFUND;
  @BuiltValueEnumConst(wireName: r'INCONCLUSIVE')
  static const DisputeDecisionOutcomeEnum INCONCLUSIVE = _$disputeDecisionOutcomeEnum_INCONCLUSIVE;
  @BuiltValueEnumConst(wireName: r'NO_FURTHER_ACTION')
  static const DisputeDecisionOutcomeEnum NO_FURTHER_ACTION = _$disputeDecisionOutcomeEnum_NO_FURTHER_ACTION;

  static Serializer<DisputeDecisionOutcomeEnum> get serializer => _$disputeDecisionOutcomeEnumSerializer;

  const DisputeDecisionOutcomeEnum._(String name): super(name);

  static BuiltSet<DisputeDecisionOutcomeEnum> get values => _$disputeDecisionOutcomeEnumValues;
  static DisputeDecisionOutcomeEnum valueOf(String name) => _$disputeDecisionOutcomeEnumValueOf(name);
}

class DisputeDecisionAppealResultEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'AFFIRMED')
  static const DisputeDecisionAppealResultEnum AFFIRMED = _$disputeDecisionAppealResultEnum_AFFIRMED;
  @BuiltValueEnumConst(wireName: r'MODIFIED')
  static const DisputeDecisionAppealResultEnum MODIFIED = _$disputeDecisionAppealResultEnum_MODIFIED;
  @BuiltValueEnumConst(wireName: r'REVERSED')
  static const DisputeDecisionAppealResultEnum REVERSED = _$disputeDecisionAppealResultEnum_REVERSED;

  static Serializer<DisputeDecisionAppealResultEnum> get serializer => _$disputeDecisionAppealResultEnumSerializer;

  const DisputeDecisionAppealResultEnum._(String name): super(name);

  static BuiltSet<DisputeDecisionAppealResultEnum> get values => _$disputeDecisionAppealResultEnumValues;
  static DisputeDecisionAppealResultEnum valueOf(String name) => _$disputeDecisionAppealResultEnumValueOf(name);
}

