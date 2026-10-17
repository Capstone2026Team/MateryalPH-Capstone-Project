//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'enforcement_record_request.g.dart';

/// A Warning is effective at once; other sanctions are applied at once. Permanent Ban needs enforcement.ban and recent re-authentication.
///
/// Properties:
/// * [subjectType]
/// * [subjectId]
/// * [action]
/// * [reason]
/// * [scope]
/// * [durationDays]
/// * [restorationCondition]
/// * [continuationPlan]
/// * [continuationNote]
@BuiltValue()
abstract class EnforcementRecordRequest implements Built<EnforcementRecordRequest, EnforcementRecordRequestBuilder> {
  @BuiltValueField(wireName: r'subject_type')
  EnforcementRecordRequestSubjectTypeEnum get subjectType;
  // enum subjectTypeEnum {  BUYER,  VENDOR_ORGANIZATION,  };

  @BuiltValueField(wireName: r'subject_id')
  String get subjectId;

  @BuiltValueField(wireName: r'action')
  EnforcementRecordRequestActionEnum get action;
  // enum actionEnum {  WARNING,  TEMPORARY_RESTRICTION,  SUSPENSION,  PERMANENT_BAN,  };

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'scope')
  String? get scope;

  @BuiltValueField(wireName: r'duration_days')
  int? get durationDays;

  @BuiltValueField(wireName: r'restoration_condition')
  String? get restorationCondition;

  @BuiltValueField(wireName: r'continuation_plan')
  EnforcementRecordRequestContinuationPlanEnum? get continuationPlan;
  // enum continuationPlanEnum {  CONTINUE,  MONITORED_FULFILLMENT,  CANCELLATION_REVIEW,  REPLACEMENT,  REFUND,  NO_OPEN_ORDERS,  ,  };

  @BuiltValueField(wireName: r'continuation_note')
  String? get continuationNote;

  EnforcementRecordRequest._();

  factory EnforcementRecordRequest([void updates(EnforcementRecordRequestBuilder b)]) = _$EnforcementRecordRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EnforcementRecordRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EnforcementRecordRequest> get serializer => _$EnforcementRecordRequestSerializer();
}

class _$EnforcementRecordRequestSerializer implements PrimitiveSerializer<EnforcementRecordRequest> {
  @override
  final Iterable<Type> types = const [EnforcementRecordRequest, _$EnforcementRecordRequest];

  @override
  final String wireName = r'EnforcementRecordRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EnforcementRecordRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'subject_type';
    yield serializers.serialize(
      object.subjectType,
      specifiedType: const FullType(EnforcementRecordRequestSubjectTypeEnum),
    );
    yield r'subject_id';
    yield serializers.serialize(
      object.subjectId,
      specifiedType: const FullType(String),
    );
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(EnforcementRecordRequestActionEnum),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    if (object.scope != null) {
      yield r'scope';
      yield serializers.serialize(
        object.scope,
        specifiedType: const FullType(String),
      );
    }
    if (object.durationDays != null) {
      yield r'duration_days';
      yield serializers.serialize(
        object.durationDays,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.restorationCondition != null) {
      yield r'restoration_condition';
      yield serializers.serialize(
        object.restorationCondition,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.continuationPlan != null) {
      yield r'continuation_plan';
      yield serializers.serialize(
        object.continuationPlan,
        specifiedType: const FullType.nullable(EnforcementRecordRequestContinuationPlanEnum),
      );
    }
    if (object.continuationNote != null) {
      yield r'continuation_note';
      yield serializers.serialize(
        object.continuationNote,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    EnforcementRecordRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EnforcementRecordRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'subject_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EnforcementRecordRequestSubjectTypeEnum),
          ) as EnforcementRecordRequestSubjectTypeEnum;
          result.subjectType = valueDes;
          break;
        case r'subject_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subjectId = valueDes;
          break;
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(EnforcementRecordRequestActionEnum),
          ) as EnforcementRecordRequestActionEnum;
          result.action = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.scope = valueDes;
          break;
        case r'duration_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.durationDays = valueDes;
          break;
        case r'restoration_condition':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.restorationCondition = valueDes;
          break;
        case r'continuation_plan':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(EnforcementRecordRequestContinuationPlanEnum),
          ) as EnforcementRecordRequestContinuationPlanEnum?;
          if (valueDes == null) continue;
          result.continuationPlan = valueDes;
          break;
        case r'continuation_note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.continuationNote = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EnforcementRecordRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EnforcementRecordRequestBuilder();
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


class EnforcementRecordRequestSubjectTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const EnforcementRecordRequestSubjectTypeEnum BUYER = _$enforcementRecordRequestSubjectTypeEnum_BUYER;
  @BuiltValueEnumConst(wireName: r'VENDOR_ORGANIZATION')
  static const EnforcementRecordRequestSubjectTypeEnum VENDOR_ORGANIZATION = _$enforcementRecordRequestSubjectTypeEnum_VENDOR_ORGANIZATION;

  static Serializer<EnforcementRecordRequestSubjectTypeEnum> get serializer => _$enforcementRecordRequestSubjectTypeEnumSerializer;

  const EnforcementRecordRequestSubjectTypeEnum._(String name): super(name);

  static BuiltSet<EnforcementRecordRequestSubjectTypeEnum> get values => _$enforcementRecordRequestSubjectTypeEnumValues;
  static EnforcementRecordRequestSubjectTypeEnum valueOf(String name) => _$enforcementRecordRequestSubjectTypeEnumValueOf(name);
}

class EnforcementRecordRequestActionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'WARNING')
  static const EnforcementRecordRequestActionEnum WARNING = _$enforcementRecordRequestActionEnum_WARNING;
  @BuiltValueEnumConst(wireName: r'TEMPORARY_RESTRICTION')
  static const EnforcementRecordRequestActionEnum TEMPORARY_RESTRICTION = _$enforcementRecordRequestActionEnum_TEMPORARY_RESTRICTION;
  @BuiltValueEnumConst(wireName: r'SUSPENSION')
  static const EnforcementRecordRequestActionEnum SUSPENSION = _$enforcementRecordRequestActionEnum_SUSPENSION;
  @BuiltValueEnumConst(wireName: r'PERMANENT_BAN')
  static const EnforcementRecordRequestActionEnum PERMANENT_BAN = _$enforcementRecordRequestActionEnum_PERMANENT_BAN;

  static Serializer<EnforcementRecordRequestActionEnum> get serializer => _$enforcementRecordRequestActionEnumSerializer;

  const EnforcementRecordRequestActionEnum._(String name): super(name);

  static BuiltSet<EnforcementRecordRequestActionEnum> get values => _$enforcementRecordRequestActionEnumValues;
  static EnforcementRecordRequestActionEnum valueOf(String name) => _$enforcementRecordRequestActionEnumValueOf(name);
}

class EnforcementRecordRequestContinuationPlanEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CONTINUE')
  static const EnforcementRecordRequestContinuationPlanEnum CONTINUE = _$enforcementRecordRequestContinuationPlanEnum_CONTINUE;
  @BuiltValueEnumConst(wireName: r'MONITORED_FULFILLMENT')
  static const EnforcementRecordRequestContinuationPlanEnum MONITORED_FULFILLMENT = _$enforcementRecordRequestContinuationPlanEnum_MONITORED_FULFILLMENT;
  @BuiltValueEnumConst(wireName: r'CANCELLATION_REVIEW')
  static const EnforcementRecordRequestContinuationPlanEnum CANCELLATION_REVIEW = _$enforcementRecordRequestContinuationPlanEnum_CANCELLATION_REVIEW;
  @BuiltValueEnumConst(wireName: r'REPLACEMENT')
  static const EnforcementRecordRequestContinuationPlanEnum REPLACEMENT = _$enforcementRecordRequestContinuationPlanEnum_REPLACEMENT;
  @BuiltValueEnumConst(wireName: r'REFUND')
  static const EnforcementRecordRequestContinuationPlanEnum REFUND = _$enforcementRecordRequestContinuationPlanEnum_REFUND;
  @BuiltValueEnumConst(wireName: r'NO_OPEN_ORDERS')
  static const EnforcementRecordRequestContinuationPlanEnum NO_OPEN_ORDERS = _$enforcementRecordRequestContinuationPlanEnum_NO_OPEN_ORDERS;

  static Serializer<EnforcementRecordRequestContinuationPlanEnum> get serializer => _$enforcementRecordRequestContinuationPlanEnumSerializer;

  const EnforcementRecordRequestContinuationPlanEnum._(String name): super(name);

  static BuiltSet<EnforcementRecordRequestContinuationPlanEnum> get values => _$enforcementRecordRequestContinuationPlanEnumValues;
  static EnforcementRecordRequestContinuationPlanEnum valueOf(String name) => _$enforcementRecordRequestContinuationPlanEnumValueOf(name);
}

