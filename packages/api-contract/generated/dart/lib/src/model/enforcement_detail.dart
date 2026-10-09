//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/subject_review.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/enforcement_summary.dart';
import 'package:materyalph_api_client/src/model/enforcement_event.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'enforcement_detail.g.dart';

/// EnforcementDetail
///
/// Properties:
/// * [id]
/// * [subjectType]
/// * [subjectId]
/// * [subjectName]
/// * [action]
/// * [actionLabel]
/// * [state]
/// * [source_]
/// * [caseId]
/// * [caseReference]
/// * [reason]
/// * [durationDays]
/// * [continuationPlan]
/// * [issuedRole]
/// * [appliedRole]
/// * [createdAt]
/// * [appliedAt]
/// * [expiresAt]
/// * [liftedAt]
/// * [liftReason]
/// * [lockVersion]
/// * [scope]
/// * [restorationCondition]
/// * [continuationNote]
/// * [priorSubjectState]
/// * [subjectReview]
/// * [events]
/// * [allowedActions]
@BuiltValue()
abstract class EnforcementDetail implements EnforcementSummary, Built<EnforcementDetail, EnforcementDetailBuilder> {
  @BuiltValueField(wireName: r'continuation_note')
  String? get continuationNote;

  @BuiltValueField(wireName: r'restoration_condition')
  String? get restorationCondition;

  @BuiltValueField(wireName: r'scope')
  String get scope;

  @BuiltValueField(wireName: r'subject_review')
  SubjectReview get subjectReview;

  @BuiltValueField(wireName: r'allowed_actions')
  BuiltList<EnforcementDetailAllowedActionsEnum> get allowedActions;
  // enum allowedActionsEnum {  APPLY,  DECLINE,  LIFT,  };

  @BuiltValueField(wireName: r'prior_subject_state')
  BuiltMap<String, JsonObject?>? get priorSubjectState;

  @BuiltValueField(wireName: r'events')
  BuiltList<EnforcementEvent> get events;

  EnforcementDetail._();

  factory EnforcementDetail([void updates(EnforcementDetailBuilder b)]) = _$EnforcementDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EnforcementDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EnforcementDetail> get serializer => _$EnforcementDetailSerializer();
}

class _$EnforcementDetailSerializer implements PrimitiveSerializer<EnforcementDetail> {
  @override
  final Iterable<Type> types = const [EnforcementDetail, _$EnforcementDetail];

  @override
  final String wireName = r'EnforcementDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EnforcementDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    if (object.restorationCondition != null) {
      yield r'restoration_condition';
      yield serializers.serialize(
        object.restorationCondition,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.caseReference != null) {
      yield r'case_reference';
      yield serializers.serialize(
        object.caseReference,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'allowed_actions';
    yield serializers.serialize(
      object.allowedActions,
      specifiedType: const FullType(BuiltList, [FullType(EnforcementDetailAllowedActionsEnum)]),
    );
    yield r'subject_type';
    yield serializers.serialize(
      object.subjectType,
      specifiedType: const FullType(EnforcementSummarySubjectTypeEnum),
    );
    yield r'subject_id';
    yield serializers.serialize(
      object.subjectId,
      specifiedType: const FullType(String),
    );
    yield r'action_label';
    yield serializers.serialize(
      object.actionLabel,
      specifiedType: const FullType(String),
    );
    if (object.durationDays != null) {
      yield r'duration_days';
      yield serializers.serialize(
        object.durationDays,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(String),
    );
    if (object.caseId != null) {
      yield r'case_id';
      yield serializers.serialize(
        object.caseId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'source';
    yield serializers.serialize(
      object.source_,
      specifiedType: const FullType(EnforcementSummarySource_Enum),
    );
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(EnforcementSummaryActionEnum),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(EnforcementSummaryStateEnum),
    );
    if (object.priorSubjectState != null) {
      yield r'prior_subject_state';
      yield serializers.serialize(
        object.priorSubjectState,
        specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    yield r'events';
    yield serializers.serialize(
      object.events,
      specifiedType: const FullType(BuiltList, [FullType(EnforcementEvent)]),
    );
    yield r'subject_name';
    yield serializers.serialize(
      object.subjectName,
      specifiedType: const FullType(String),
    );
    if (object.continuationNote != null) {
      yield r'continuation_note';
      yield serializers.serialize(
        object.continuationNote,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.continuationPlan != null) {
      yield r'continuation_plan';
      yield serializers.serialize(
        object.continuationPlan,
        specifiedType: const FullType.nullable(EnforcementSummaryContinuationPlanEnum),
      );
    }
    if (object.liftReason != null) {
      yield r'lift_reason';
      yield serializers.serialize(
        object.liftReason,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.expiresAt != null) {
      yield r'expires_at';
      yield serializers.serialize(
        object.expiresAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.liftedAt != null) {
      yield r'lifted_at';
      yield serializers.serialize(
        object.liftedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'subject_review';
    yield serializers.serialize(
      object.subjectReview,
      specifiedType: const FullType(SubjectReview),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    if (object.appliedRole != null) {
      yield r'applied_role';
      yield serializers.serialize(
        object.appliedRole,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.issuedRole != null) {
      yield r'issued_role';
      yield serializers.serialize(
        object.issuedRole,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.appliedAt != null) {
      yield r'applied_at';
      yield serializers.serialize(
        object.appliedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    EnforcementDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EnforcementDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'restoration_condition':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.restorationCondition = valueDes;
          break;
        case r'case_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.caseReference = valueDes;
          break;
        case r'allowed_actions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(EnforcementDetailAllowedActionsEnum)]),
          ) as BuiltList<EnforcementDetailAllowedActionsEnum>;
          result.allowedActions.replace(valueDes);
          break;
        case r'subject_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EnforcementSummarySubjectTypeEnum),
          ) as EnforcementSummarySubjectTypeEnum;
          result.subjectType = valueDes;
          break;
        case r'subject_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subjectId = valueDes;
          break;
        case r'action_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.actionLabel = valueDes;
          break;
        case r'duration_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.durationDays = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.scope = valueDes;
          break;
        case r'case_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.caseId = valueDes;
          break;
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EnforcementSummarySource_Enum),
          ) as EnforcementSummarySource_Enum;
          result.source_ = valueDes;
          break;
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EnforcementSummaryActionEnum),
          ) as EnforcementSummaryActionEnum;
          result.action = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EnforcementSummaryStateEnum),
          ) as EnforcementSummaryStateEnum;
          result.state = valueDes;
          break;
        case r'prior_subject_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.priorSubjectState.replace(valueDes);
          break;
        case r'events':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(EnforcementEvent)]),
          ) as BuiltList<EnforcementEvent>;
          result.events.replace(valueDes);
          break;
        case r'subject_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subjectName = valueDes;
          break;
        case r'continuation_note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.continuationNote = valueDes;
          break;
        case r'continuation_plan':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(EnforcementSummaryContinuationPlanEnum),
          ) as EnforcementSummaryContinuationPlanEnum?;
          if (valueDes == null) continue;
          result.continuationPlan = valueDes;
          break;
        case r'lift_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.liftReason = valueDes;
          break;
        case r'expires_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.expiresAt = valueDes;
          break;
        case r'lifted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.liftedAt = valueDes;
          break;
        case r'subject_review':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SubjectReview),
          ) as SubjectReview;
          result.subjectReview = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'applied_role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.appliedRole = valueDes;
          break;
        case r'issued_role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.issuedRole = valueDes;
          break;
        case r'applied_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.appliedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EnforcementDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EnforcementDetailBuilder();
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


class EnforcementDetailSubjectTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const EnforcementDetailSubjectTypeEnum BUYER = _$enforcementDetailSubjectTypeEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'VENDOR_ORGANIZATION')
  static const EnforcementDetailSubjectTypeEnum VENDOR_ORGANIZATION = _$enforcementDetailSubjectTypeEnum_VENDOR_ORGANIZATION;

  static Serializer<EnforcementDetailSubjectTypeEnum> get serializer => _$enforcementDetailSubjectTypeEnumSerializer;

  const EnforcementDetailSubjectTypeEnum._(String name): super(name);

  static BuiltSet<EnforcementDetailSubjectTypeEnum> get values => _$enforcementDetailSubjectTypeEnumValues;
  static EnforcementDetailSubjectTypeEnum valueOf(String name) => _$enforcementDetailSubjectTypeEnumValueOf(name);
}

class EnforcementDetailActionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'WARNING')
  static const EnforcementDetailActionEnum WARNING = _$enforcementDetailActionEnum_WARNING;
  @BuiltValueEnumConst(wireName: r'TEMPORARY_RESTRICTION')
  static const EnforcementDetailActionEnum TEMPORARY_RESTRICTION = _$enforcementDetailActionEnum_TEMPORARY_RESTRICTION;
  @BuiltValueEnumConst(wireName: r'SUSPENSION')
  static const EnforcementDetailActionEnum SUSPENSION = _$enforcementDetailActionEnum_SUSPENSION;
  @BuiltValueEnumConst(wireName: r'PERMANENT_BAN')
  static const EnforcementDetailActionEnum PERMANENT_BAN = _$enforcementDetailActionEnum_PERMANENT_BAN;

  static Serializer<EnforcementDetailActionEnum> get serializer => _$enforcementDetailActionEnumSerializer;

  const EnforcementDetailActionEnum._(String name): super(name);

  static BuiltSet<EnforcementDetailActionEnum> get values => _$enforcementDetailActionEnumValues;
  static EnforcementDetailActionEnum valueOf(String name) => _$enforcementDetailActionEnumValueOf(name);
}

class EnforcementDetailStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'EFFECTIVE')
  static const EnforcementDetailStateEnum EFFECTIVE = _$enforcementDetailStateEnum_EFFECTIVE;
  @BuiltValueEnumConst(wireName: r'REFERRED')
  static const EnforcementDetailStateEnum REFERRED = _$enforcementDetailStateEnum_REFERRED;
  @BuiltValueEnumConst(wireName: r'APPLIED')
  static const EnforcementDetailStateEnum APPLIED = _$enforcementDetailStateEnum_APPLIED;
  @BuiltValueEnumConst(wireName: r'LIFTED')
  static const EnforcementDetailStateEnum LIFTED = _$enforcementDetailStateEnum_LIFTED;
  @BuiltValueEnumConst(wireName: r'DECLINED')
  static const EnforcementDetailStateEnum DECLINED = _$enforcementDetailStateEnum_DECLINED;

  static Serializer<EnforcementDetailStateEnum> get serializer => _$enforcementDetailStateEnumSerializer;

  const EnforcementDetailStateEnum._(String name): super(name);

  static BuiltSet<EnforcementDetailStateEnum> get values => _$enforcementDetailStateEnumValues;
  static EnforcementDetailStateEnum valueOf(String name) => _$enforcementDetailStateEnumValueOf(name);
}

class EnforcementDetailSource_Enum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DISPUTE_REFERRAL')
  static const EnforcementDetailSource_Enum DISPUTE_REFERRAL = _$enforcementDetailSourceEnum_DISPUTE_REFERRAL;
  @BuiltValueEnumConst(wireName: r'DIRECT')
  static const EnforcementDetailSource_Enum DIRECT = _$enforcementDetailSourceEnum_DIRECT;

  static Serializer<EnforcementDetailSource_Enum> get serializer => _$enforcementDetailSourceEnumSerializer;

  const EnforcementDetailSource_Enum._(String name): super(name);

  static BuiltSet<EnforcementDetailSource_Enum> get values => _$enforcementDetailSourceEnumValues;
  static EnforcementDetailSource_Enum valueOf(String name) => _$enforcementDetailSourceEnumValueOf(name);
}

class EnforcementDetailContinuationPlanEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CONTINUE')
  static const EnforcementDetailContinuationPlanEnum CONTINUE = _$enforcementDetailContinuationPlanEnum_CONTINUE;
  @BuiltValueEnumConst(wireName: r'MONITORED_FULFILLMENT')
  static const EnforcementDetailContinuationPlanEnum MONITORED_FULFILLMENT = _$enforcementDetailContinuationPlanEnum_MONITORED_FULFILLMENT;
  @BuiltValueEnumConst(wireName: r'CANCELLATION_REVIEW')
  static const EnforcementDetailContinuationPlanEnum CANCELLATION_REVIEW = _$enforcementDetailContinuationPlanEnum_CANCELLATION_REVIEW;
  @BuiltValueEnumConst(wireName: r'REPLACEMENT')
  static const EnforcementDetailContinuationPlanEnum REPLACEMENT = _$enforcementDetailContinuationPlanEnum_REPLACEMENT;
  @BuiltValueEnumConst(wireName: r'REFUND')
  static const EnforcementDetailContinuationPlanEnum REFUND = _$enforcementDetailContinuationPlanEnum_REFUND;
  @BuiltValueEnumConst(wireName: r'NO_OPEN_ORDERS')
  static const EnforcementDetailContinuationPlanEnum NO_OPEN_ORDERS = _$enforcementDetailContinuationPlanEnum_NO_OPEN_ORDERS;

  static Serializer<EnforcementDetailContinuationPlanEnum> get serializer => _$enforcementDetailContinuationPlanEnumSerializer;

  const EnforcementDetailContinuationPlanEnum._(String name): super(name);

  static BuiltSet<EnforcementDetailContinuationPlanEnum> get values => _$enforcementDetailContinuationPlanEnumValues;
  static EnforcementDetailContinuationPlanEnum valueOf(String name) => _$enforcementDetailContinuationPlanEnumValueOf(name);
}

class EnforcementDetailAllowedActionsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'APPLY')
  static const EnforcementDetailAllowedActionsEnum APPLY = _$enforcementDetailAllowedActionsEnum_APPLY;
  @BuiltValueEnumConst(wireName: r'DECLINE')
  static const EnforcementDetailAllowedActionsEnum DECLINE = _$enforcementDetailAllowedActionsEnum_DECLINE;
  @BuiltValueEnumConst(wireName: r'LIFT')
  static const EnforcementDetailAllowedActionsEnum LIFT = _$enforcementDetailAllowedActionsEnum_LIFT;

  static Serializer<EnforcementDetailAllowedActionsEnum> get serializer => _$enforcementDetailAllowedActionsEnumSerializer;

  const EnforcementDetailAllowedActionsEnum._(String name): super(name);

  static BuiltSet<EnforcementDetailAllowedActionsEnum> get values => _$enforcementDetailAllowedActionsEnumValues;
  static EnforcementDetailAllowedActionsEnum valueOf(String name) => _$enforcementDetailAllowedActionsEnumValueOf(name);
}

