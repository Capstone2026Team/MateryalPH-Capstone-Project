//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/dispute_timeline_actor.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/dispute_evidence.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_timeline_entry.g.dart';

/// One append-only, chronologically numbered event with its actor, role, exact time and evidence.
///
/// Properties:
/// * [id]
/// * [sequence]
/// * [type]
/// * [at]
/// * [actor]
/// * [body]
/// * [details]
/// * [evidence]
@BuiltValue()
abstract class DisputeTimelineEntry implements Built<DisputeTimelineEntry, DisputeTimelineEntryBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'sequence')
  int get sequence;

  @BuiltValueField(wireName: r'type')
  DisputeTimelineEntryTypeEnum get type;
  // enum typeEnum {  CASE_FILED,  RESPONSE_SUBMITTED,  EVIDENCE_ADDED,  MESSAGE,  PROPOSAL_MADE,  PROPOSAL_ACCEPTED,  PROPOSAL_REJECTED,  AGREEMENT_RECORDED,  ESCALATED,  CLARIFICATION_REQUESTED,  CLARIFICATION_ANSWERED,  CLARIFICATION_EXPIRED,  DECISION_ISSUED,  DECISION_ENFORCEABLE,  APPEAL_FILED,  APPEAL_DECIDED,  REMEDY_CREATED,  REMEDY_UPDATED,  REMEDY_COMPLETED,  REFUND_UPDATED,  SANCTION_RECORDED,  HANDLER_ASSIGNED,  HANDLER_REASSIGNED,  CASE_RESOLVED,  CASE_CLOSED_INCONCLUSIVE,  ORDER_HOLD_CHANGED,  };

  @BuiltValueField(wireName: r'at')
  DateTime? get at;

  @BuiltValueField(wireName: r'actor')
  DisputeTimelineActor get actor;

  @BuiltValueField(wireName: r'body')
  String? get body;

  @BuiltValueField(wireName: r'details')
  BuiltMap<String, JsonObject?> get details;

  @BuiltValueField(wireName: r'evidence')
  BuiltList<DisputeEvidence> get evidence;

  DisputeTimelineEntry._();

  factory DisputeTimelineEntry([void updates(DisputeTimelineEntryBuilder b)]) = _$DisputeTimelineEntry;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeTimelineEntryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeTimelineEntry> get serializer => _$DisputeTimelineEntrySerializer();
}

class _$DisputeTimelineEntrySerializer implements PrimitiveSerializer<DisputeTimelineEntry> {
  @override
  final Iterable<Type> types = const [DisputeTimelineEntry, _$DisputeTimelineEntry];

  @override
  final String wireName = r'DisputeTimelineEntry';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeTimelineEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'sequence';
    yield serializers.serialize(
      object.sequence,
      specifiedType: const FullType(int),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(DisputeTimelineEntryTypeEnum),
    );
    if (object.at != null) {
      yield r'at';
      yield serializers.serialize(
        object.at,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'actor';
    yield serializers.serialize(
      object.actor,
      specifiedType: const FullType(DisputeTimelineActor),
    );
    if (object.body != null) {
      yield r'body';
      yield serializers.serialize(
        object.body,
        specifiedType: const FullType(String),
      );
    }
    yield r'details';
    yield serializers.serialize(
      object.details,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'evidence';
    yield serializers.serialize(
      object.evidence,
      specifiedType: const FullType(BuiltList, [FullType(DisputeEvidence)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeTimelineEntry object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeTimelineEntryBuilder result,
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
        case r'sequence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sequence = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeTimelineEntryTypeEnum),
          ) as DisputeTimelineEntryTypeEnum;
          result.type = valueDes;
          break;
        case r'at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.at = valueDes;
          break;
        case r'actor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisputeTimelineActor),
          ) as DisputeTimelineActor;
          result.actor.replace(valueDes);
          break;
        case r'body':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.body = valueDes;
          break;
        case r'details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.details.replace(valueDes);
          break;
        case r'evidence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DisputeEvidence)]),
          ) as BuiltList<DisputeEvidence>;
          result.evidence.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeTimelineEntry deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeTimelineEntryBuilder();
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


class DisputeTimelineEntryTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CASE_FILED')
  static const DisputeTimelineEntryTypeEnum CASE_FILED = _$disputeTimelineEntryTypeEnum_CASE_FILED;
  @BuiltValueEnumConst(wireName: r'RESPONSE_SUBMITTED')
  static const DisputeTimelineEntryTypeEnum RESPONSE_SUBMITTED = _$disputeTimelineEntryTypeEnum_RESPONSE_SUBMITTED;
  @BuiltValueEnumConst(wireName: r'EVIDENCE_ADDED')
  static const DisputeTimelineEntryTypeEnum EVIDENCE_ADDED = _$disputeTimelineEntryTypeEnum_EVIDENCE_ADDED;
  @BuiltValueEnumConst(wireName: r'MESSAGE')
  static const DisputeTimelineEntryTypeEnum MESSAGE = _$disputeTimelineEntryTypeEnum_MESSAGE;
  @BuiltValueEnumConst(wireName: r'PROPOSAL_MADE')
  static const DisputeTimelineEntryTypeEnum PROPOSAL_MADE = _$disputeTimelineEntryTypeEnum_PROPOSAL_MADE;
  @BuiltValueEnumConst(wireName: r'PROPOSAL_ACCEPTED')
  static const DisputeTimelineEntryTypeEnum PROPOSAL_ACCEPTED = _$disputeTimelineEntryTypeEnum_PROPOSAL_ACCEPTED;
  @BuiltValueEnumConst(wireName: r'PROPOSAL_REJECTED')
  static const DisputeTimelineEntryTypeEnum PROPOSAL_REJECTED = _$disputeTimelineEntryTypeEnum_PROPOSAL_REJECTED;
  @BuiltValueEnumConst(wireName: r'AGREEMENT_RECORDED')
  static const DisputeTimelineEntryTypeEnum AGREEMENT_RECORDED = _$disputeTimelineEntryTypeEnum_AGREEMENT_RECORDED;
  @BuiltValueEnumConst(wireName: r'ESCALATED')
  static const DisputeTimelineEntryTypeEnum ESCALATED = _$disputeTimelineEntryTypeEnum_ESCALATED;
  @BuiltValueEnumConst(wireName: r'CLARIFICATION_REQUESTED')
  static const DisputeTimelineEntryTypeEnum CLARIFICATION_REQUESTED = _$disputeTimelineEntryTypeEnum_CLARIFICATION_REQUESTED;
  @BuiltValueEnumConst(wireName: r'CLARIFICATION_ANSWERED')
  static const DisputeTimelineEntryTypeEnum CLARIFICATION_ANSWERED = _$disputeTimelineEntryTypeEnum_CLARIFICATION_ANSWERED;
  @BuiltValueEnumConst(wireName: r'CLARIFICATION_EXPIRED')
  static const DisputeTimelineEntryTypeEnum CLARIFICATION_EXPIRED = _$disputeTimelineEntryTypeEnum_CLARIFICATION_EXPIRED;
  @BuiltValueEnumConst(wireName: r'DECISION_ISSUED')
  static const DisputeTimelineEntryTypeEnum DECISION_ISSUED = _$disputeTimelineEntryTypeEnum_DECISION_ISSUED;
  @BuiltValueEnumConst(wireName: r'DECISION_ENFORCEABLE')
  static const DisputeTimelineEntryTypeEnum DECISION_ENFORCEABLE = _$disputeTimelineEntryTypeEnum_DECISION_ENFORCEABLE;
  @BuiltValueEnumConst(wireName: r'APPEAL_FILED')
  static const DisputeTimelineEntryTypeEnum APPEAL_FILED = _$disputeTimelineEntryTypeEnum_APPEAL_FILED;
  @BuiltValueEnumConst(wireName: r'APPEAL_DECIDED')
  static const DisputeTimelineEntryTypeEnum APPEAL_DECIDED = _$disputeTimelineEntryTypeEnum_APPEAL_DECIDED;
  @BuiltValueEnumConst(wireName: r'REMEDY_CREATED')
  static const DisputeTimelineEntryTypeEnum REMEDY_CREATED = _$disputeTimelineEntryTypeEnum_REMEDY_CREATED;
  @BuiltValueEnumConst(wireName: r'REMEDY_UPDATED')
  static const DisputeTimelineEntryTypeEnum REMEDY_UPDATED = _$disputeTimelineEntryTypeEnum_REMEDY_UPDATED;
  @BuiltValueEnumConst(wireName: r'REMEDY_COMPLETED')
  static const DisputeTimelineEntryTypeEnum REMEDY_COMPLETED = _$disputeTimelineEntryTypeEnum_REMEDY_COMPLETED;
  @BuiltValueEnumConst(wireName: r'REFUND_UPDATED')
  static const DisputeTimelineEntryTypeEnum REFUND_UPDATED = _$disputeTimelineEntryTypeEnum_REFUND_UPDATED;
  @BuiltValueEnumConst(wireName: r'SANCTION_RECORDED')
  static const DisputeTimelineEntryTypeEnum SANCTION_RECORDED = _$disputeTimelineEntryTypeEnum_SANCTION_RECORDED;
  @BuiltValueEnumConst(wireName: r'HANDLER_ASSIGNED')
  static const DisputeTimelineEntryTypeEnum HANDLER_ASSIGNED = _$disputeTimelineEntryTypeEnum_HANDLER_ASSIGNED;
  @BuiltValueEnumConst(wireName: r'HANDLER_REASSIGNED')
  static const DisputeTimelineEntryTypeEnum HANDLER_REASSIGNED = _$disputeTimelineEntryTypeEnum_HANDLER_REASSIGNED;
  @BuiltValueEnumConst(wireName: r'CASE_RESOLVED')
  static const DisputeTimelineEntryTypeEnum CASE_RESOLVED = _$disputeTimelineEntryTypeEnum_CASE_RESOLVED;
  @BuiltValueEnumConst(wireName: r'CASE_CLOSED_INCONCLUSIVE')
  static const DisputeTimelineEntryTypeEnum CASE_CLOSED_INCONCLUSIVE = _$disputeTimelineEntryTypeEnum_CASE_CLOSED_INCONCLUSIVE;
  @BuiltValueEnumConst(wireName: r'ORDER_HOLD_CHANGED')
  static const DisputeTimelineEntryTypeEnum ORDER_HOLD_CHANGED = _$disputeTimelineEntryTypeEnum_ORDER_HOLD_CHANGED;

  static Serializer<DisputeTimelineEntryTypeEnum> get serializer => _$disputeTimelineEntryTypeEnumSerializer;

  const DisputeTimelineEntryTypeEnum._(String name): super(name);

  static BuiltSet<DisputeTimelineEntryTypeEnum> get values => _$disputeTimelineEntryTypeEnumValues;
  static DisputeTimelineEntryTypeEnum valueOf(String name) => _$disputeTimelineEntryTypeEnumValueOf(name);
}

