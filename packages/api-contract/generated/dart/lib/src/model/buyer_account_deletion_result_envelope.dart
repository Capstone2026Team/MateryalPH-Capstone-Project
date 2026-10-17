//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/buyer_account_deletion_result.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_account_deletion_result_envelope.g.dart';

/// BuyerAccountDeletionResultEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class BuyerAccountDeletionResultEnvelope implements Built<BuyerAccountDeletionResultEnvelope, BuyerAccountDeletionResultEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuyerAccountDeletionResult get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?> get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<BuiltMap<String, JsonObject?>> get errors;

  BuyerAccountDeletionResultEnvelope._();

  factory BuyerAccountDeletionResultEnvelope([void updates(BuyerAccountDeletionResultEnvelopeBuilder b)]) = _$BuyerAccountDeletionResultEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerAccountDeletionResultEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerAccountDeletionResultEnvelope> get serializer => _$BuyerAccountDeletionResultEnvelopeSerializer();
}

class _$BuyerAccountDeletionResultEnvelopeSerializer implements PrimitiveSerializer<BuyerAccountDeletionResultEnvelope> {
  @override
  final Iterable<Type> types = const [BuyerAccountDeletionResultEnvelope, _$BuyerAccountDeletionResultEnvelope];

  @override
  final String wireName = r'BuyerAccountDeletionResultEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerAccountDeletionResultEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuyerAccountDeletionResult),
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
    BuyerAccountDeletionResultEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerAccountDeletionResultEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerAccountDeletionResult),
          ) as BuyerAccountDeletionResult;
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
  BuyerAccountDeletionResultEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerAccountDeletionResultEnvelopeBuilder();
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


