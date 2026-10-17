//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'privacy_request_summary.g.dart';

/// PrivacyRequestSummary
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
@BuiltValue(instantiable: false)
abstract class PrivacyRequestSummary  {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'reference')
  String get reference;

  @BuiltValueField(wireName: r'request_type')
  PrivacyRequestSummaryRequestTypeEnum get requestType;
  // enum requestTypeEnum {  ACCESS,  CORRECTION,  OBJECTION,  DELETION,  RESTRICTION,  PORTABILITY,  OTHER,  };

  @BuiltValueField(wireName: r'state')
  PrivacyRequestSummaryStateEnum get state;
  // enum stateEnum {  RECEIVED,  IDENTITY_VERIFIED,  IN_PROGRESS,  COMPLETED,  REJECTED,  WITHDRAWN,  };

  @BuiltValueField(wireName: r'subject_account_type')
  String get subjectAccountType;

  @BuiltValueField(wireName: r'subject_display')
  String get subjectDisplay;

  @BuiltValueField(wireName: r'intake_channel')
  String? get intakeChannel;

  @BuiltValueField(wireName: r'received_at')
  DateTime? get receivedAt;

  @BuiltValueField(wireName: r'target_date')
  Date? get targetDate;

  @BuiltValueField(wireName: r'handler')
  String? get handler;

  @BuiltValueField(wireName: r'handler_user_id')
  int? get handlerUserId;

  @BuiltValueField(wireName: r'identity_verified')
  bool get identityVerified;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueSerializer(custom: true)
  static Serializer<PrivacyRequestSummary> get serializer => _$PrivacyRequestSummarySerializer();
}

class _$PrivacyRequestSummarySerializer implements PrimitiveSerializer<PrivacyRequestSummary> {
  @override
  final Iterable<Type> types = const [PrivacyRequestSummary];

  @override
  final String wireName = r'PrivacyRequestSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PrivacyRequestSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'reference';
    yield serializers.serialize(
      object.reference,
      specifiedType: const FullType(String),
    );
    yield r'request_type';
    yield serializers.serialize(
      object.requestType,
      specifiedType: const FullType(PrivacyRequestSummaryRequestTypeEnum),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(PrivacyRequestSummaryStateEnum),
    );
    yield r'subject_account_type';
    yield serializers.serialize(
      object.subjectAccountType,
      specifiedType: const FullType(String),
    );
    yield r'subject_display';
    yield serializers.serialize(
      object.subjectDisplay,
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
    if (object.targetDate != null) {
      yield r'target_date';
      yield serializers.serialize(
        object.targetDate,
        specifiedType: const FullType.nullable(Date),
      );
    }
    if (object.handler != null) {
      yield r'handler';
      yield serializers.serialize(
        object.handler,
        specifiedType: const FullType.nullable(String),
      );
    }
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
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    if (object.createdAt != null) {
      yield r'created_at';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PrivacyRequestSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  @override
  PrivacyRequestSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.deserialize(serialized, specifiedType: FullType($PrivacyRequestSummary)) as $PrivacyRequestSummary;
  }
}


/// a concrete implementation of [PrivacyRequestSummary], since [PrivacyRequestSummary] is not instantiable
@BuiltValue(instantiable: true)
abstract class $PrivacyRequestSummary implements PrivacyRequestSummary, Built<$PrivacyRequestSummary, $PrivacyRequestSummaryBuilder> {
  $PrivacyRequestSummary._();

  factory $PrivacyRequestSummary([void Function($PrivacyRequestSummaryBuilder)? updates]) = _$$PrivacyRequestSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($PrivacyRequestSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<$PrivacyRequestSummary> get serializer => _$$PrivacyRequestSummarySerializer();
}

class _$$PrivacyRequestSummarySerializer implements PrimitiveSerializer<$PrivacyRequestSummary> {
  @override
  final Iterable<Type> types = const [$PrivacyRequestSummary, _$$PrivacyRequestSummary];

  @override
  final String wireName = r'$PrivacyRequestSummary';

  @override
  Object serialize(
    Serializers serializers,
    $PrivacyRequestSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.serialize(object, specifiedType: FullType(PrivacyRequestSummary))!;
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PrivacyRequestSummaryBuilder result,
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
        case r'reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reference = valueDes;
          break;
        case r'request_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PrivacyRequestSummaryRequestTypeEnum),
          ) as PrivacyRequestSummaryRequestTypeEnum;
          result.requestType = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PrivacyRequestSummaryStateEnum),
          ) as PrivacyRequestSummaryStateEnum;
          result.state = valueDes;
          break;
        case r'subject_account_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subjectAccountType = valueDes;
          break;
        case r'subject_display':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subjectDisplay = valueDes;
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
        case r'target_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.targetDate = valueDes;
          break;
        case r'handler':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.handler = valueDes;
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
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  $PrivacyRequestSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = $PrivacyRequestSummaryBuilder();
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

class PrivacyRequestSummaryRequestTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACCESS')
  static const PrivacyRequestSummaryRequestTypeEnum ACCESS = _$privacyRequestSummaryRequestTypeEnum_ACCESS;
  @BuiltValueEnumConst(wireName: r'CORRECTION')
  static const PrivacyRequestSummaryRequestTypeEnum CORRECTION = _$privacyRequestSummaryRequestTypeEnum_CORRECTION;
  @BuiltValueEnumConst(wireName: r'OBJECTION')
  static const PrivacyRequestSummaryRequestTypeEnum OBJECTION = _$privacyRequestSummaryRequestTypeEnum_OBJECTION;
  @BuiltValueEnumConst(wireName: r'DELETION')
  static const PrivacyRequestSummaryRequestTypeEnum DELETION = _$privacyRequestSummaryRequestTypeEnum_DELETION;
  @BuiltValueEnumConst(wireName: r'RESTRICTION')
  static const PrivacyRequestSummaryRequestTypeEnum RESTRICTION = _$privacyRequestSummaryRequestTypeEnum_RESTRICTION;
  @BuiltValueEnumConst(wireName: r'PORTABILITY')
  static const PrivacyRequestSummaryRequestTypeEnum PORTABILITY = _$privacyRequestSummaryRequestTypeEnum_PORTABILITY;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const PrivacyRequestSummaryRequestTypeEnum OTHER = _$privacyRequestSummaryRequestTypeEnum_OTHER;

  static Serializer<PrivacyRequestSummaryRequestTypeEnum> get serializer => _$privacyRequestSummaryRequestTypeEnumSerializer;

  const PrivacyRequestSummaryRequestTypeEnum._(String name): super(name);

  static BuiltSet<PrivacyRequestSummaryRequestTypeEnum> get values => _$privacyRequestSummaryRequestTypeEnumValues;
  static PrivacyRequestSummaryRequestTypeEnum valueOf(String name) => _$privacyRequestSummaryRequestTypeEnumValueOf(name);
}

class PrivacyRequestSummaryStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'RECEIVED')
  static const PrivacyRequestSummaryStateEnum RECEIVED = _$privacyRequestSummaryStateEnum_RECEIVED;
  @BuiltValueEnumConst(wireName: r'IDENTITY_VERIFIED')
  static const PrivacyRequestSummaryStateEnum IDENTITY_VERIFIED = _$privacyRequestSummaryStateEnum_IDENTITY_VERIFIED;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const PrivacyRequestSummaryStateEnum IN_PROGRESS = _$privacyRequestSummaryStateEnum_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const PrivacyRequestSummaryStateEnum COMPLETED = _$privacyRequestSummaryStateEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const PrivacyRequestSummaryStateEnum REJECTED = _$privacyRequestSummaryStateEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'WITHDRAWN')
  static const PrivacyRequestSummaryStateEnum WITHDRAWN = _$privacyRequestSummaryStateEnum_WITHDRAWN;

  static Serializer<PrivacyRequestSummaryStateEnum> get serializer => _$privacyRequestSummaryStateEnumSerializer;

  const PrivacyRequestSummaryStateEnum._(String name): super(name);

  static BuiltSet<PrivacyRequestSummaryStateEnum> get values => _$privacyRequestSummaryStateEnumValues;
  static PrivacyRequestSummaryStateEnum valueOf(String name) => _$privacyRequestSummaryStateEnumValueOf(name);
}

