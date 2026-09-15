//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/account_recovery_codes.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account_recovery_codes_envelope.g.dart';

/// AccountRecoveryCodesEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class AccountRecoveryCodesEnvelope implements Built<AccountRecoveryCodesEnvelope, AccountRecoveryCodesEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  AccountRecoveryCodes get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?> get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<BuiltMap<String, JsonObject?>> get errors;

  AccountRecoveryCodesEnvelope._();

  factory AccountRecoveryCodesEnvelope([void updates(AccountRecoveryCodesEnvelopeBuilder b)]) = _$AccountRecoveryCodesEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AccountRecoveryCodesEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AccountRecoveryCodesEnvelope> get serializer => _$AccountRecoveryCodesEnvelopeSerializer();
}

class _$AccountRecoveryCodesEnvelopeSerializer implements PrimitiveSerializer<AccountRecoveryCodesEnvelope> {
  @override
  final Iterable<Type> types = const [AccountRecoveryCodesEnvelope, _$AccountRecoveryCodesEnvelope];

  @override
  final String wireName = r'AccountRecoveryCodesEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AccountRecoveryCodesEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(AccountRecoveryCodes),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'errors';
    yield serializers.serialize(
      object.errors,
      specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AccountRecoveryCodesEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AccountRecoveryCodesEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AccountRecoveryCodes),
          ) as AccountRecoveryCodes;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.meta.replace(valueDes);
          break;
        case r'errors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)])]),
          ) as BuiltList<BuiltMap<String, JsonObject?>>;
          result.errors.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AccountRecoveryCodesEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AccountRecoveryCodesEnvelopeBuilder();
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


