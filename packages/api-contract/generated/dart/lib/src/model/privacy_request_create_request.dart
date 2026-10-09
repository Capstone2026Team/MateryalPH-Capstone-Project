//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'privacy_request_create_request.g.dart';

/// PrivacyRequestCreateRequest
///
/// Properties:
/// * [subjectEmail]
/// * [requestType]
/// * [intakeChannel]
/// * [receivedOn]
/// * [scope]
/// * [note]
@BuiltValue()
abstract class PrivacyRequestCreateRequest implements Built<PrivacyRequestCreateRequest, PrivacyRequestCreateRequestBuilder> {
  @BuiltValueField(wireName: r'subject_email')
  String get subjectEmail;

  @BuiltValueField(wireName: r'request_type')
  PrivacyRequestCreateRequestRequestTypeEnum get requestType;
  // enum requestTypeEnum {  ACCESS,  CORRECTION,  OBJECTION,  DELETION,  RESTRICTION,  PORTABILITY,  OTHER,  };

  @BuiltValueField(wireName: r'intake_channel')
  PrivacyRequestCreateRequestIntakeChannelEnum get intakeChannel;
  // enum intakeChannelEnum {  DPO_EMAIL,  SUPPORT_CASE,  WRITTEN_LETTER,  IN_APP,  };

  @BuiltValueField(wireName: r'received_on')
  Date get receivedOn;

  @BuiltValueField(wireName: r'scope')
  String get scope;

  @BuiltValueField(wireName: r'note')
  String get note;

  PrivacyRequestCreateRequest._();

  factory PrivacyRequestCreateRequest([void updates(PrivacyRequestCreateRequestBuilder b)]) = _$PrivacyRequestCreateRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PrivacyRequestCreateRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PrivacyRequestCreateRequest> get serializer => _$PrivacyRequestCreateRequestSerializer();
}

class _$PrivacyRequestCreateRequestSerializer implements PrimitiveSerializer<PrivacyRequestCreateRequest> {
  @override
  final Iterable<Type> types = const [PrivacyRequestCreateRequest, _$PrivacyRequestCreateRequest];

  @override
  final String wireName = r'PrivacyRequestCreateRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PrivacyRequestCreateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'subject_email';
    yield serializers.serialize(
      object.subjectEmail,
      specifiedType: const FullType(String),
    );
    yield r'request_type';
    yield serializers.serialize(
      object.requestType,
      specifiedType: const FullType(PrivacyRequestCreateRequestRequestTypeEnum),
    );
    yield r'intake_channel';
    yield serializers.serialize(
      object.intakeChannel,
      specifiedType: const FullType(PrivacyRequestCreateRequestIntakeChannelEnum),
    );
    yield r'received_on';
    yield serializers.serialize(
      object.receivedOn,
      specifiedType: const FullType(Date),
    );
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(String),
    );
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PrivacyRequestCreateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PrivacyRequestCreateRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'subject_email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subjectEmail = valueDes;
          break;
        case r'request_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PrivacyRequestCreateRequestRequestTypeEnum),
          ) as PrivacyRequestCreateRequestRequestTypeEnum;
          result.requestType = valueDes;
          break;
        case r'intake_channel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PrivacyRequestCreateRequestIntakeChannelEnum),
          ) as PrivacyRequestCreateRequestIntakeChannelEnum;
          result.intakeChannel = valueDes;
          break;
        case r'received_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.receivedOn = valueDes;
          break;
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.scope = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PrivacyRequestCreateRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PrivacyRequestCreateRequestBuilder();
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


class PrivacyRequestCreateRequestRequestTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACCESS')
  static const PrivacyRequestCreateRequestRequestTypeEnum ACCESS = _$privacyRequestCreateRequestRequestTypeEnum_ACCESS;
  @BuiltValueEnumConst(wireName: r'CORRECTION')
  static const PrivacyRequestCreateRequestRequestTypeEnum CORRECTION = _$privacyRequestCreateRequestRequestTypeEnum_CORRECTION;
  @BuiltValueEnumConst(wireName: r'OBJECTION')
  static const PrivacyRequestCreateRequestRequestTypeEnum OBJECTION = _$privacyRequestCreateRequestRequestTypeEnum_OBJECTION;
  @BuiltValueEnumConst(wireName: r'DELETION')
  static const PrivacyRequestCreateRequestRequestTypeEnum DELETION = _$privacyRequestCreateRequestRequestTypeEnum_DELETION;
  @BuiltValueEnumConst(wireName: r'RESTRICTION')
  static const PrivacyRequestCreateRequestRequestTypeEnum RESTRICTION = _$privacyRequestCreateRequestRequestTypeEnum_RESTRICTION;
  @BuiltValueEnumConst(wireName: r'PORTABILITY')
  static const PrivacyRequestCreateRequestRequestTypeEnum PORTABILITY = _$privacyRequestCreateRequestRequestTypeEnum_PORTABILITY;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const PrivacyRequestCreateRequestRequestTypeEnum OTHER = _$privacyRequestCreateRequestRequestTypeEnum_OTHER;

  static Serializer<PrivacyRequestCreateRequestRequestTypeEnum> get serializer => _$privacyRequestCreateRequestRequestTypeEnumSerializer;

  const PrivacyRequestCreateRequestRequestTypeEnum._(String name): super(name);

  static BuiltSet<PrivacyRequestCreateRequestRequestTypeEnum> get values => _$privacyRequestCreateRequestRequestTypeEnumValues;
  static PrivacyRequestCreateRequestRequestTypeEnum valueOf(String name) => _$privacyRequestCreateRequestRequestTypeEnumValueOf(name);
}

class PrivacyRequestCreateRequestIntakeChannelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DPO_EMAIL')
  static const PrivacyRequestCreateRequestIntakeChannelEnum DPO_EMAIL = _$privacyRequestCreateRequestIntakeChannelEnum_DPO_EMAIL;
  @BuiltValueEnumConst(wireName: r'SUPPORT_CASE')
  static const PrivacyRequestCreateRequestIntakeChannelEnum SUPPORT_CASE = _$privacyRequestCreateRequestIntakeChannelEnum_SUPPORT_CASE;
  @BuiltValueEnumConst(wireName: r'WRITTEN_LETTER')
  static const PrivacyRequestCreateRequestIntakeChannelEnum WRITTEN_LETTER = _$privacyRequestCreateRequestIntakeChannelEnum_WRITTEN_LETTER;
  @BuiltValueEnumConst(wireName: r'IN_APP')
  static const PrivacyRequestCreateRequestIntakeChannelEnum IN_APP = _$privacyRequestCreateRequestIntakeChannelEnum_IN_APP;

  static Serializer<PrivacyRequestCreateRequestIntakeChannelEnum> get serializer => _$privacyRequestCreateRequestIntakeChannelEnumSerializer;

  const PrivacyRequestCreateRequestIntakeChannelEnum._(String name): super(name);

  static BuiltSet<PrivacyRequestCreateRequestIntakeChannelEnum> get values => _$privacyRequestCreateRequestIntakeChannelEnumValues;
  static PrivacyRequestCreateRequestIntakeChannelEnum valueOf(String name) => _$privacyRequestCreateRequestIntakeChannelEnumValueOf(name);
}

