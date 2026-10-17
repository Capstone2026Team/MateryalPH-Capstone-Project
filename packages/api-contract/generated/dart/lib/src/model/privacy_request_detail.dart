//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/privacy_request_event.dart';
import 'package:materyalph_api_client/src/model/privacy_request_summary.dart';
import 'package:materyalph_api_client/src/model/privacy_handler.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'privacy_request_detail.g.dart';

/// PrivacyRequestDetail
///
/// Properties:
/// * [id]
/// * [reference]
/// * [requestType]
/// * [state]
/// * [subjectAccountType]
/// * [subjectDisplay]
/// * [intakeChannel]
/// * [receivedAt]
/// * [targetDate]
/// * [handler]
/// * [handlerUserId]
/// * [identityVerified]
/// * [lockVersion]
/// * [createdAt]
/// * [scope]
/// * [responseSummary]
/// * [legalException]
/// * [identityVerificationMethod]
/// * [identityVerifiedAt]
/// * [subjectMaskedEmail]
/// * [completedAt]
/// * [events]
/// * [allowedActions]
/// * [handlers]
@BuiltValue()
abstract class PrivacyRequestDetail implements PrivacyRequestSummary, Built<PrivacyRequestDetail, PrivacyRequestDetailBuilder> {
  @BuiltValueField(wireName: r'completed_at')
  DateTime? get completedAt;

  @BuiltValueField(wireName: r'response_summary')
  String? get responseSummary;

  @BuiltValueField(wireName: r'handlers')
  BuiltList<PrivacyHandler> get handlers;

  @BuiltValueField(wireName: r'scope')
  String? get scope;

  @BuiltValueField(wireName: r'legal_exception')
  String? get legalException;

  @BuiltValueField(wireName: r'identity_verified_at')
  DateTime? get identityVerifiedAt;

  @BuiltValueField(wireName: r'allowed_actions')
  BuiltList<PrivacyRequestDetailAllowedActionsEnum> get allowedActions;
  // enum allowedActionsEnum {  ASSIGN,  VERIFY,  START,  COMPLETE,  REJECT,  WITHDRAW,  };

  @BuiltValueField(wireName: r'subject_masked_email')
  String get subjectMaskedEmail;

  @BuiltValueField(wireName: r'events')
  BuiltList<PrivacyRequestEvent> get events;

  @BuiltValueField(wireName: r'identity_verification_method')
  String? get identityVerificationMethod;

  PrivacyRequestDetail._();

  factory PrivacyRequestDetail([void updates(PrivacyRequestDetailBuilder b)]) = _$PrivacyRequestDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PrivacyRequestDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PrivacyRequestDetail> get serializer => _$PrivacyRequestDetailSerializer();
}

class _$PrivacyRequestDetailSerializer implements PrimitiveSerializer<PrivacyRequestDetail> {
  @override
  final Iterable<Type> types = const [PrivacyRequestDetail, _$PrivacyRequestDetail];

  @override
  final String wireName = r'PrivacyRequestDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PrivacyRequestDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.handler != null) {
      yield r'handler';
      yield serializers.serialize(
        object.handler,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.completedAt != null) {
      yield r'completed_at';
      yield serializers.serialize(
        object.completedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'request_type';
    yield serializers.serialize(
      object.requestType,
      specifiedType: const FullType(PrivacyRequestSummaryRequestTypeEnum),
    );
    if (object.targetDate != null) {
      yield r'target_date';
      yield serializers.serialize(
        object.targetDate,
        specifiedType: const FullType.nullable(Date),
      );
    }
    if (object.identityVerifiedAt != null) {
      yield r'identity_verified_at';
      yield serializers.serialize(
        object.identityVerifiedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'allowed_actions';
    yield serializers.serialize(
      object.allowedActions,
      specifiedType: const FullType(BuiltList, [FullType(PrivacyRequestDetailAllowedActionsEnum)]),
    );
    yield r'subject_account_type';
    yield serializers.serialize(
      object.subjectAccountType,
      specifiedType: const FullType(String),
    );
    if (object.intakeChannel != null) {
      yield r'intake_channel';
      yield serializers.serialize(
        object.intakeChannel,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.receivedAt != null) {
      yield r'received_at';
      yield serializers.serialize(
        object.receivedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'reference';
    yield serializers.serialize(
      object.reference,
      specifiedType: const FullType(String),
    );
    if (object.createdAt != null) {
      yield r'created_at';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.responseSummary != null) {
      yield r'response_summary';
      yield serializers.serialize(
        object.responseSummary,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'handlers';
    yield serializers.serialize(
      object.handlers,
      specifiedType: const FullType(BuiltList, [FullType(PrivacyHandler)]),
    );
    if (object.scope != null) {
      yield r'scope';
      yield serializers.serialize(
        object.scope,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.legalException != null) {
      yield r'legal_exception';
      yield serializers.serialize(
        object.legalException,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(PrivacyRequestSummaryStateEnum),
    );
    yield r'subject_display';
    yield serializers.serialize(
      object.subjectDisplay,
      specifiedType: const FullType(String),
    );
    if (object.handlerUserId != null) {
      yield r'handler_user_id';
      yield serializers.serialize(
        object.handlerUserId,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'identity_verified';
    yield serializers.serialize(
      object.identityVerified,
      specifiedType: const FullType(bool),
    );
    yield r'subject_masked_email';
    yield serializers.serialize(
      object.subjectMaskedEmail,
      specifiedType: const FullType(String),
    );
    yield r'events';
    yield serializers.serialize(
      object.events,
      specifiedType: const FullType(BuiltList, [FullType(PrivacyRequestEvent)]),
    );
    if (object.identityVerificationMethod != null) {
      yield r'identity_verification_method';
      yield serializers.serialize(
        object.identityVerificationMethod,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PrivacyRequestDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PrivacyRequestDetailBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'handler':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.handler = valueDes;
          break;
        case r'completed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.completedAt = valueDes;
          break;
        case r'request_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PrivacyRequestSummaryRequestTypeEnum),
          ) as PrivacyRequestSummaryRequestTypeEnum;
          result.requestType = valueDes;
          break;
        case r'target_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.targetDate = valueDes;
          break;
        case r'identity_verified_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.identityVerifiedAt = valueDes;
          break;
        case r'allowed_actions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PrivacyRequestDetailAllowedActionsEnum)]),
          ) as BuiltList<PrivacyRequestDetailAllowedActionsEnum>;
          result.allowedActions.replace(valueDes);
          break;
        case r'subject_account_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subjectAccountType = valueDes;
          break;
        case r'intake_channel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.intakeChannel = valueDes;
          break;
        case r'received_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.receivedAt = valueDes;
          break;
        case r'reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reference = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        case r'response_summary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.responseSummary = valueDes;
          break;
        case r'handlers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PrivacyHandler)]),
          ) as BuiltList<PrivacyHandler>;
          result.handlers.replace(valueDes);
          break;
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.scope = valueDes;
          break;
        case r'legal_exception':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.legalException = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
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
            specifiedType: const FullType(PrivacyRequestSummaryStateEnum),
          ) as PrivacyRequestSummaryStateEnum;
          result.state = valueDes;
          break;
        case r'subject_display':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subjectDisplay = valueDes;
          break;
        case r'handler_user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.handlerUserId = valueDes;
          break;
        case r'identity_verified':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.identityVerified = valueDes;
          break;
        case r'subject_masked_email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subjectMaskedEmail = valueDes;
          break;
        case r'events':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PrivacyRequestEvent)]),
          ) as BuiltList<PrivacyRequestEvent>;
          result.events.replace(valueDes);
          break;
        case r'identity_verification_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.identityVerificationMethod = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PrivacyRequestDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PrivacyRequestDetailBuilder();
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


class PrivacyRequestDetailRequestTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACCESS')
  static const PrivacyRequestDetailRequestTypeEnum ACCESS = _$privacyRequestDetailRequestTypeEnum_ACCESS;
  @BuiltValueEnumConst(wireName: r'CORRECTION')
  static const PrivacyRequestDetailRequestTypeEnum CORRECTION = _$privacyRequestDetailRequestTypeEnum_CORRECTION;
  @BuiltValueEnumConst(wireName: r'OBJECTION')
  static const PrivacyRequestDetailRequestTypeEnum OBJECTION = _$privacyRequestDetailRequestTypeEnum_OBJECTION;
  @BuiltValueEnumConst(wireName: r'DELETION')
  static const PrivacyRequestDetailRequestTypeEnum DELETION = _$privacyRequestDetailRequestTypeEnum_DELETION;
  @BuiltValueEnumConst(wireName: r'RESTRICTION')
  static const PrivacyRequestDetailRequestTypeEnum RESTRICTION = _$privacyRequestDetailRequestTypeEnum_RESTRICTION;
  @BuiltValueEnumConst(wireName: r'PORTABILITY')
  static const PrivacyRequestDetailRequestTypeEnum PORTABILITY = _$privacyRequestDetailRequestTypeEnum_PORTABILITY;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const PrivacyRequestDetailRequestTypeEnum OTHER = _$privacyRequestDetailRequestTypeEnum_OTHER;

  static Serializer<PrivacyRequestDetailRequestTypeEnum> get serializer => _$privacyRequestDetailRequestTypeEnumSerializer;

  const PrivacyRequestDetailRequestTypeEnum._(String name): super(name);

  static BuiltSet<PrivacyRequestDetailRequestTypeEnum> get values => _$privacyRequestDetailRequestTypeEnumValues;
  static PrivacyRequestDetailRequestTypeEnum valueOf(String name) => _$privacyRequestDetailRequestTypeEnumValueOf(name);
}

class PrivacyRequestDetailStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'RECEIVED')
  static const PrivacyRequestDetailStateEnum RECEIVED = _$privacyRequestDetailStateEnum_RECEIVED;
  @BuiltValueEnumConst(wireName: r'IDENTITY_VERIFIED')
  static const PrivacyRequestDetailStateEnum IDENTITY_VERIFIED = _$privacyRequestDetailStateEnum_IDENTITY_VERIFIED;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const PrivacyRequestDetailStateEnum IN_PROGRESS = _$privacyRequestDetailStateEnum_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const PrivacyRequestDetailStateEnum COMPLETED = _$privacyRequestDetailStateEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const PrivacyRequestDetailStateEnum REJECTED = _$privacyRequestDetailStateEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'WITHDRAWN')
  static const PrivacyRequestDetailStateEnum WITHDRAWN = _$privacyRequestDetailStateEnum_WITHDRAWN;

  static Serializer<PrivacyRequestDetailStateEnum> get serializer => _$privacyRequestDetailStateEnumSerializer;

  const PrivacyRequestDetailStateEnum._(String name): super(name);

  static BuiltSet<PrivacyRequestDetailStateEnum> get values => _$privacyRequestDetailStateEnumValues;
  static PrivacyRequestDetailStateEnum valueOf(String name) => _$privacyRequestDetailStateEnumValueOf(name);
}

class PrivacyRequestDetailAllowedActionsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ASSIGN')
  static const PrivacyRequestDetailAllowedActionsEnum ASSIGN = _$privacyRequestDetailAllowedActionsEnum_ASSIGN;
  @BuiltValueEnumConst(wireName: r'VERIFY')
  static const PrivacyRequestDetailAllowedActionsEnum VERIFY = _$privacyRequestDetailAllowedActionsEnum_VERIFY;
  @BuiltValueEnumConst(wireName: r'START')
  static const PrivacyRequestDetailAllowedActionsEnum START = _$privacyRequestDetailAllowedActionsEnum_START;
  @BuiltValueEnumConst(wireName: r'COMPLETE')
  static const PrivacyRequestDetailAllowedActionsEnum COMPLETE = _$privacyRequestDetailAllowedActionsEnum_COMPLETE;
  @BuiltValueEnumConst(wireName: r'REJECT')
  static const PrivacyRequestDetailAllowedActionsEnum REJECT = _$privacyRequestDetailAllowedActionsEnum_REJECT;
  @BuiltValueEnumConst(wireName: r'WITHDRAW')
  static const PrivacyRequestDetailAllowedActionsEnum WITHDRAW = _$privacyRequestDetailAllowedActionsEnum_WITHDRAW;

  static Serializer<PrivacyRequestDetailAllowedActionsEnum> get serializer => _$privacyRequestDetailAllowedActionsEnumSerializer;

  const PrivacyRequestDetailAllowedActionsEnum._(String name): super(name);

  static BuiltSet<PrivacyRequestDetailAllowedActionsEnum> get values => _$privacyRequestDetailAllowedActionsEnumValues;
  static PrivacyRequestDetailAllowedActionsEnum valueOf(String name) => _$privacyRequestDetailAllowedActionsEnumValueOf(name);
}

