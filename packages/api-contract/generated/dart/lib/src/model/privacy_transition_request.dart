//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'privacy_transition_request.g.dart';

/// PrivacyTransitionRequest
///
/// Properties:
/// * [lockVersion]
/// * [note]
/// * [handlerUserId]
/// * [targetDate]
/// * [verificationMethod]
/// * [legalException]
@BuiltValue()
abstract class PrivacyTransitionRequest implements Built<PrivacyTransitionRequest, PrivacyTransitionRequestBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'note')
  String get note;

  @BuiltValueField(wireName: r'handler_user_id')
  int? get handlerUserId;

  @BuiltValueField(wireName: r'target_date')
  Date? get targetDate;

  @BuiltValueField(wireName: r'verification_method')
  PrivacyTransitionRequestVerificationMethodEnum? get verificationMethod;
  // enum verificationMethodEnum {  REGISTERED_EMAIL_CONFIRMATION,  SIGNED_IN_ACCOUNT_CONFIRMATION,  GOVERNMENT_ID_SIGHTED,  AUTHORIZED_REPRESENTATIVE_DOCUMENT_SIGHTED,  };

  @BuiltValueField(wireName: r'legal_exception')
  String? get legalException;

  PrivacyTransitionRequest._();

  factory PrivacyTransitionRequest([void updates(PrivacyTransitionRequestBuilder b)]) = _$PrivacyTransitionRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PrivacyTransitionRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PrivacyTransitionRequest> get serializer => _$PrivacyTransitionRequestSerializer();
}

class _$PrivacyTransitionRequestSerializer implements PrimitiveSerializer<PrivacyTransitionRequest> {
  @override
  final Iterable<Type> types = const [PrivacyTransitionRequest, _$PrivacyTransitionRequest];

  @override
  final String wireName = r'PrivacyTransitionRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PrivacyTransitionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(String),
    );
    if (object.handlerUserId != null) {
      yield r'handler_user_id';
      yield serializers.serialize(
        object.handlerUserId,
        specifiedType: const FullType(int),
      );
    }
    if (object.targetDate != null) {
      yield r'target_date';
      yield serializers.serialize(
        object.targetDate,
        specifiedType: const FullType.nullable(Date),
      );
    }
    if (object.verificationMethod != null) {
      yield r'verification_method';
      yield serializers.serialize(
        object.verificationMethod,
        specifiedType: const FullType(PrivacyTransitionRequestVerificationMethodEnum),
      );
    }
    if (object.legalException != null) {
      yield r'legal_exception';
      yield serializers.serialize(
        object.legalException,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PrivacyTransitionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PrivacyTransitionRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.note = valueDes;
          break;
        case r'handler_user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.handlerUserId = valueDes;
          break;
        case r'target_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.targetDate = valueDes;
          break;
        case r'verification_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PrivacyTransitionRequestVerificationMethodEnum),
          ) as PrivacyTransitionRequestVerificationMethodEnum?;
          if (valueDes == null) continue;
          result.verificationMethod = valueDes;
          break;
        case r'legal_exception':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.legalException = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PrivacyTransitionRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PrivacyTransitionRequestBuilder();
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


class PrivacyTransitionRequestVerificationMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REGISTERED_EMAIL_CONFIRMATION')
  static const PrivacyTransitionRequestVerificationMethodEnum REGISTERED_EMAIL_CONFIRMATION = _$privacyTransitionRequestVerificationMethodEnum_REGISTERED_EMAIL_CONFIRMATION;
  @BuiltValueEnumConst(wireName: r'SIGNED_IN_ACCOUNT_CONFIRMATION')
  static const PrivacyTransitionRequestVerificationMethodEnum SIGNED_IN_ACCOUNT_CONFIRMATION = _$privacyTransitionRequestVerificationMethodEnum_SIGNED_IN_ACCOUNT_CONFIRMATION;
  @BuiltValueEnumConst(wireName: r'GOVERNMENT_ID_SIGHTED')
  static const PrivacyTransitionRequestVerificationMethodEnum GOVERNMENT_ID_SIGHTED = _$privacyTransitionRequestVerificationMethodEnum_GOVERNMENT_ID_SIGHTED;
  @BuiltValueEnumConst(wireName: r'AUTHORIZED_REPRESENTATIVE_DOCUMENT_SIGHTED')
  static const PrivacyTransitionRequestVerificationMethodEnum AUTHORIZED_REPRESENTATIVE_DOCUMENT_SIGHTED = _$privacyTransitionRequestVerificationMethodEnum_AUTHORIZED_REPRESENTATIVE_DOCUMENT_SIGHTED;

  static Serializer<PrivacyTransitionRequestVerificationMethodEnum> get serializer => _$privacyTransitionRequestVerificationMethodEnumSerializer;

  const PrivacyTransitionRequestVerificationMethodEnum._(String name): super(name);

  static BuiltSet<PrivacyTransitionRequestVerificationMethodEnum> get values => _$privacyTransitionRequestVerificationMethodEnumValues;
  static PrivacyTransitionRequestVerificationMethodEnum valueOf(String name) => _$privacyTransitionRequestVerificationMethodEnumValueOf(name);
}

