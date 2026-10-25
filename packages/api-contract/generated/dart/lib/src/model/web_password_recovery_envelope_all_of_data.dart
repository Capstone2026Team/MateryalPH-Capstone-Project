//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'web_password_recovery_envelope_all_of_data.g.dart';

/// WebPasswordRecoveryEnvelopeAllOfData
///
/// Properties:
/// * [verified]
/// * [expiresIn]
/// * [recoveryCodes] - Replacement authenticator recovery codes, returned once after backup-code verification.
@BuiltValue()
abstract class WebPasswordRecoveryEnvelopeAllOfData implements Built<WebPasswordRecoveryEnvelopeAllOfData, WebPasswordRecoveryEnvelopeAllOfDataBuilder> {
  @BuiltValueField(wireName: r'verified')
  bool get verified;

  @BuiltValueField(wireName: r'expires_in')
  int get expiresIn;

  /// Replacement authenticator recovery codes, returned once after backup-code verification.
  @BuiltValueField(wireName: r'recovery_codes')
  BuiltList<String>? get recoveryCodes;

  WebPasswordRecoveryEnvelopeAllOfData._();

  factory WebPasswordRecoveryEnvelopeAllOfData([void updates(WebPasswordRecoveryEnvelopeAllOfDataBuilder b)]) = _$WebPasswordRecoveryEnvelopeAllOfData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WebPasswordRecoveryEnvelopeAllOfDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WebPasswordRecoveryEnvelopeAllOfData> get serializer => _$WebPasswordRecoveryEnvelopeAllOfDataSerializer();
}

class _$WebPasswordRecoveryEnvelopeAllOfDataSerializer implements PrimitiveSerializer<WebPasswordRecoveryEnvelopeAllOfData> {
  @override
  final Iterable<Type> types = const [WebPasswordRecoveryEnvelopeAllOfData, _$WebPasswordRecoveryEnvelopeAllOfData];

  @override
  final String wireName = r'WebPasswordRecoveryEnvelopeAllOfData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WebPasswordRecoveryEnvelopeAllOfData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'verified';
    yield serializers.serialize(
      object.verified,
      specifiedType: const FullType(bool),
    );
    yield r'expires_in';
    yield serializers.serialize(
      object.expiresIn,
      specifiedType: const FullType(int),
    );
    yield r'recovery_codes';
    yield object.recoveryCodes == null ? null : serializers.serialize(
      object.recoveryCodes,
      specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WebPasswordRecoveryEnvelopeAllOfData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WebPasswordRecoveryEnvelopeAllOfDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'verified':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.verified = valueDes;
          break;
        case r'expires_in':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expiresIn = valueDes;
          break;
        case r'recovery_codes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.recoveryCodes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WebPasswordRecoveryEnvelopeAllOfData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WebPasswordRecoveryEnvelopeAllOfDataBuilder();
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


