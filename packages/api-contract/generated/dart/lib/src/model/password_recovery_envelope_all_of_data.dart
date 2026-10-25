//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'password_recovery_envelope_all_of_data.g.dart';

/// PasswordRecoveryEnvelopeAllOfData
///
/// Properties:
/// * [message]
/// * [resendAfterSeconds]
/// * [expiresIn]
@BuiltValue()
abstract class PasswordRecoveryEnvelopeAllOfData implements Built<PasswordRecoveryEnvelopeAllOfData, PasswordRecoveryEnvelopeAllOfDataBuilder> {
  @BuiltValueField(wireName: r'message')
  String get message;

  @BuiltValueField(wireName: r'resend_after_seconds')
  int get resendAfterSeconds;

  @BuiltValueField(wireName: r'expires_in')
  int get expiresIn;

  PasswordRecoveryEnvelopeAllOfData._();

  factory PasswordRecoveryEnvelopeAllOfData([void updates(PasswordRecoveryEnvelopeAllOfDataBuilder b)]) = _$PasswordRecoveryEnvelopeAllOfData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PasswordRecoveryEnvelopeAllOfDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PasswordRecoveryEnvelopeAllOfData> get serializer => _$PasswordRecoveryEnvelopeAllOfDataSerializer();
}

class _$PasswordRecoveryEnvelopeAllOfDataSerializer implements PrimitiveSerializer<PasswordRecoveryEnvelopeAllOfData> {
  @override
  final Iterable<Type> types = const [PasswordRecoveryEnvelopeAllOfData, _$PasswordRecoveryEnvelopeAllOfData];

  @override
  final String wireName = r'PasswordRecoveryEnvelopeAllOfData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PasswordRecoveryEnvelopeAllOfData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
    yield r'resend_after_seconds';
    yield serializers.serialize(
      object.resendAfterSeconds,
      specifiedType: const FullType(int),
    );
    yield r'expires_in';
    yield serializers.serialize(
      object.expiresIn,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PasswordRecoveryEnvelopeAllOfData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PasswordRecoveryEnvelopeAllOfDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        case r'resend_after_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.resendAfterSeconds = valueDes;
          break;
        case r'expires_in':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expiresIn = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PasswordRecoveryEnvelopeAllOfData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PasswordRecoveryEnvelopeAllOfDataBuilder();
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


