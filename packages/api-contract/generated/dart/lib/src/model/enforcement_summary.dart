//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'enforcement_summary.g.dart';

/// EnforcementSummary
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
@BuiltValue(instantiable: false)
abstract class EnforcementSummary  {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'subject_type')
  EnforcementSummarySubjectTypeEnum get subjectType;
  // enum subjectTypeEnum {  BUYER,  VENDOR_ORGANIZATION,  };

  @BuiltValueField(wireName: r'subject_id')
  String get subjectId;

  @BuiltValueField(wireName: r'subject_name')
  String get subjectName;

  @BuiltValueField(wireName: r'action')
  EnforcementSummaryActionEnum get action;
  // enum actionEnum {  WARNING,  TEMPORARY_RESTRICTION,  SUSPENSION,  PERMANENT_BAN,  };

  @BuiltValueField(wireName: r'action_label')
  String get actionLabel;

  @BuiltValueField(wireName: r'state')
  EnforcementSummaryStateEnum get state;
  // enum stateEnum {  EFFECTIVE,  REFERRED,  APPLIED,  LIFTED,  DECLINED,  };

  @BuiltValueField(wireName: r'source')
  EnforcementSummarySource_Enum get source_;
  // enum source_Enum {  DISPUTE_REFERRAL,  DIRECT,  };

  @BuiltValueField(wireName: r'case_id')
  String? get caseId;

  @BuiltValueField(wireName: r'case_reference')
  String? get caseReference;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'duration_days')
  int? get durationDays;

  @BuiltValueField(wireName: r'continuation_plan')
  EnforcementSummaryContinuationPlanEnum? get continuationPlan;
  // enum continuationPlanEnum {  CONTINUE,  MONITORED_FULFILLMENT,  CANCELLATION_REVIEW,  REPLACEMENT,  REFUND,  NO_OPEN_ORDERS,  ,  };

  @BuiltValueField(wireName: r'issued_role')
  String? get issuedRole;

  @BuiltValueField(wireName: r'applied_role')
  String? get appliedRole;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'applied_at')
  DateTime? get appliedAt;

  @BuiltValueField(wireName: r'expires_at')
  DateTime? get expiresAt;

  @BuiltValueField(wireName: r'lifted_at')
  DateTime? get liftedAt;

  @BuiltValueField(wireName: r'lift_reason')
  String? get liftReason;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueSerializer(custom: true)
  static Serializer<EnforcementSummary> get serializer => _$EnforcementSummarySerializer();
}

class _$EnforcementSummarySerializer implements PrimitiveSerializer<EnforcementSummary> {
  @override
  final Iterable<Type> types = const [EnforcementSummary];

  @override
  final String wireName = r'EnforcementSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EnforcementSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
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
    yield r'subject_name';
    yield serializers.serialize(
      object.subjectName,
      specifiedType: const FullType(String),
    );
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(EnforcementSummaryActionEnum),
    );
    yield r'action_label';
    yield serializers.serialize(
      object.actionLabel,
      specifiedType: const FullType(String),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(EnforcementSummaryStateEnum),
    );
    yield r'source';
    yield serializers.serialize(
      object.source_,
      specifiedType: const FullType(EnforcementSummarySource_Enum),
    );
    if (object.caseId != null) {
      yield r'case_id';
      yield serializers.serialize(
        object.caseId,
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
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    if (object.durationDays != null) {
      yield r'duration_days';
      yield serializers.serialize(
        object.durationDays,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.continuationPlan != null) {
      yield r'continuation_plan';
      yield serializers.serialize(
        object.continuationPlan,
        specifiedType: const FullType.nullable(EnforcementSummaryContinuationPlanEnum),
      );
    }
    if (object.issuedRole != null) {
      yield r'issued_role';
      yield serializers.serialize(
        object.issuedRole,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.appliedRole != null) {
      yield r'applied_role';
      yield serializers.serialize(
        object.appliedRole,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.appliedAt != null) {
      yield r'applied_at';
      yield serializers.serialize(
        object.appliedAt,
        specifiedType: const FullType.nullable(DateTime),
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
    if (object.liftReason != null) {
      yield r'lift_reason';
      yield serializers.serialize(
        object.liftReason,
        specifiedType: const FullType.nullable(String),
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
    EnforcementSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  @override
  EnforcementSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.deserialize(serialized, specifiedType: FullType($EnforcementSummary)) as $EnforcementSummary;
  }
}


/// a concrete implementation of [EnforcementSummary], since [EnforcementSummary] is not instantiable
@BuiltValue(instantiable: true)
abstract class $EnforcementSummary implements EnforcementSummary, Built<$EnforcementSummary, $EnforcementSummaryBuilder> {
  $EnforcementSummary._();

  factory $EnforcementSummary([void Function($EnforcementSummaryBuilder)? updates]) = _$$EnforcementSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($EnforcementSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<$EnforcementSummary> get serializer => _$$EnforcementSummarySerializer();
}

class _$$EnforcementSummarySerializer implements PrimitiveSerializer<$EnforcementSummary> {
  @override
  final Iterable<Type> types = const [$EnforcementSummary, _$$EnforcementSummary];

  @override
  final String wireName = r'$EnforcementSummary';

  @override
  Object serialize(
    Serializers serializers,
    $EnforcementSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.serialize(object, specifiedType: FullType(EnforcementSummary))!;
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EnforcementSummaryBuilder result,
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
        case r'subject_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subjectName = valueDes;
          break;
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EnforcementSummaryActionEnum),
          ) as EnforcementSummaryActionEnum;
          result.action = valueDes;
          break;
        case r'action_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.actionLabel = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EnforcementSummaryStateEnum),
          ) as EnforcementSummaryStateEnum;
          result.state = valueDes;
          break;
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EnforcementSummarySource_Enum),
          ) as EnforcementSummarySource_Enum;
          result.source_ = valueDes;
          break;
        case r'case_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.caseId = valueDes;
          break;
        case r'case_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.caseReference = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'duration_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.durationDays = valueDes;
          break;
        case r'continuation_plan':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(EnforcementSummaryContinuationPlanEnum),
          ) as EnforcementSummaryContinuationPlanEnum?;
          if (valueDes == null) continue;
          result.continuationPlan = valueDes;
          break;
        case r'issued_role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.issuedRole = valueDes;
          break;
        case r'applied_role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.appliedRole = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'applied_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.appliedAt = valueDes;
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
        case r'lift_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.liftReason = valueDes;
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
  $EnforcementSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = $EnforcementSummaryBuilder();
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

class EnforcementSummarySubjectTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const EnforcementSummarySubjectTypeEnum BUYER = _$enforcementSummarySubjectTypeEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'VENDOR_ORGANIZATION')
  static const EnforcementSummarySubjectTypeEnum VENDOR_ORGANIZATION = _$enforcementSummarySubjectTypeEnum_VENDOR_ORGANIZATION;

  static Serializer<EnforcementSummarySubjectTypeEnum> get serializer => _$enforcementSummarySubjectTypeEnumSerializer;

  const EnforcementSummarySubjectTypeEnum._(String name): super(name);

  static BuiltSet<EnforcementSummarySubjectTypeEnum> get values => _$enforcementSummarySubjectTypeEnumValues;
  static EnforcementSummarySubjectTypeEnum valueOf(String name) => _$enforcementSummarySubjectTypeEnumValueOf(name);
}

class EnforcementSummaryActionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'WARNING')
  static const EnforcementSummaryActionEnum WARNING = _$enforcementSummaryActionEnum_WARNING;
  @BuiltValueEnumConst(wireName: r'TEMPORARY_RESTRICTION')
  static const EnforcementSummaryActionEnum TEMPORARY_RESTRICTION = _$enforcementSummaryActionEnum_TEMPORARY_RESTRICTION;
  @BuiltValueEnumConst(wireName: r'SUSPENSION')
  static const EnforcementSummaryActionEnum SUSPENSION = _$enforcementSummaryActionEnum_SUSPENSION;
  @BuiltValueEnumConst(wireName: r'PERMANENT_BAN')
  static const EnforcementSummaryActionEnum PERMANENT_BAN = _$enforcementSummaryActionEnum_PERMANENT_BAN;

  static Serializer<EnforcementSummaryActionEnum> get serializer => _$enforcementSummaryActionEnumSerializer;

  const EnforcementSummaryActionEnum._(String name): super(name);

  static BuiltSet<EnforcementSummaryActionEnum> get values => _$enforcementSummaryActionEnumValues;
  static EnforcementSummaryActionEnum valueOf(String name) => _$enforcementSummaryActionEnumValueOf(name);
}

class EnforcementSummaryStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'EFFECTIVE')
  static const EnforcementSummaryStateEnum EFFECTIVE = _$enforcementSummaryStateEnum_EFFECTIVE;
  @BuiltValueEnumConst(wireName: r'REFERRED')
  static const EnforcementSummaryStateEnum REFERRED = _$enforcementSummaryStateEnum_REFERRED;
  @BuiltValueEnumConst(wireName: r'APPLIED')
  static const EnforcementSummaryStateEnum APPLIED = _$enforcementSummaryStateEnum_APPLIED;
  @BuiltValueEnumConst(wireName: r'LIFTED')
  static const EnforcementSummaryStateEnum LIFTED = _$enforcementSummaryStateEnum_LIFTED;
  @BuiltValueEnumConst(wireName: r'DECLINED')
  static const EnforcementSummaryStateEnum DECLINED = _$enforcementSummaryStateEnum_DECLINED;

  static Serializer<EnforcementSummaryStateEnum> get serializer => _$enforcementSummaryStateEnumSerializer;

  const EnforcementSummaryStateEnum._(String name): super(name);

  static BuiltSet<EnforcementSummaryStateEnum> get values => _$enforcementSummaryStateEnumValues;
  static EnforcementSummaryStateEnum valueOf(String name) => _$enforcementSummaryStateEnumValueOf(name);
}

class EnforcementSummarySource_Enum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DISPUTE_REFERRAL')
  static const EnforcementSummarySource_Enum DISPUTE_REFERRAL = _$enforcementSummarySourceEnum_DISPUTE_REFERRAL;
  @BuiltValueEnumConst(wireName: r'DIRECT')
  static const EnforcementSummarySource_Enum DIRECT = _$enforcementSummarySourceEnum_DIRECT;

  static Serializer<EnforcementSummarySource_Enum> get serializer => _$enforcementSummarySourceEnumSerializer;

  const EnforcementSummarySource_Enum._(String name): super(name);

  static BuiltSet<EnforcementSummarySource_Enum> get values => _$enforcementSummarySourceEnumValues;
  static EnforcementSummarySource_Enum valueOf(String name) => _$enforcementSummarySourceEnumValueOf(name);
}

class EnforcementSummaryContinuationPlanEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CONTINUE')
  static const EnforcementSummaryContinuationPlanEnum CONTINUE = _$enforcementSummaryContinuationPlanEnum_CONTINUE;
  @BuiltValueEnumConst(wireName: r'MONITORED_FULFILLMENT')
  static const EnforcementSummaryContinuationPlanEnum MONITORED_FULFILLMENT = _$enforcementSummaryContinuationPlanEnum_MONITORED_FULFILLMENT;
  @BuiltValueEnumConst(wireName: r'CANCELLATION_REVIEW')
  static const EnforcementSummaryContinuationPlanEnum CANCELLATION_REVIEW = _$enforcementSummaryContinuationPlanEnum_CANCELLATION_REVIEW;
  @BuiltValueEnumConst(wireName: r'REPLACEMENT')
  static const EnforcementSummaryContinuationPlanEnum REPLACEMENT = _$enforcementSummaryContinuationPlanEnum_REPLACEMENT;
  @BuiltValueEnumConst(wireName: r'REFUND')
  static const EnforcementSummaryContinuationPlanEnum REFUND = _$enforcementSummaryContinuationPlanEnum_REFUND;
  @BuiltValueEnumConst(wireName: r'NO_OPEN_ORDERS')
  static const EnforcementSummaryContinuationPlanEnum NO_OPEN_ORDERS = _$enforcementSummaryContinuationPlanEnum_NO_OPEN_ORDERS;

  static Serializer<EnforcementSummaryContinuationPlanEnum> get serializer => _$enforcementSummaryContinuationPlanEnumSerializer;

  const EnforcementSummaryContinuationPlanEnum._(String name): super(name);

  static BuiltSet<EnforcementSummaryContinuationPlanEnum> get values => _$enforcementSummaryContinuationPlanEnumValues;
  static EnforcementSummaryContinuationPlanEnum valueOf(String name) => _$enforcementSummaryContinuationPlanEnumValueOf(name);
}

