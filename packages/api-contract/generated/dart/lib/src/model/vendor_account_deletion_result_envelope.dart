//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:materyalph_api_client/src/model/vendor_account_deletion_result.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_account_deletion_result_envelope.g.dart';

/// VendorAccountDeletionResultEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class VendorAccountDeletionResultEnvelope implements Built<VendorAccountDeletionResultEnvelope, VendorAccountDeletionResultEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  VendorAccountDeletionResult get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?> get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<BuiltMap<String, JsonObject?>> get errors;

  VendorAccountDeletionResultEnvelope._();

  factory VendorAccountDeletionResultEnvelope([void updates(VendorAccountDeletionResultEnvelopeBuilder b)]) = _$VendorAccountDeletionResultEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorAccountDeletionResultEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorAccountDeletionResultEnvelope> get serializer => _$VendorAccountDeletionResultEnvelopeSerializer();
}

class _$VendorAccountDeletionResultEnvelopeSerializer implements PrimitiveSerializer<VendorAccountDeletionResultEnvelope> {
  @override
  final Iterable<Type> types = const [VendorAccountDeletionResultEnvelope, _$VendorAccountDeletionResultEnvelope];

  @override
  final String wireName = r'VendorAccountDeletionResultEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorAccountDeletionResultEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(VendorAccountDeletionResult),
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
    VendorAccountDeletionResultEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorAccountDeletionResultEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorAccountDeletionResult),
          ) as VendorAccountDeletionResult;
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
  VendorAccountDeletionResultEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorAccountDeletionResultEnvelopeBuilder();
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


