//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/psgc_area_list_meta.dart';
import 'package:materyalph_api_client/src/model/psgc_area_option.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'psgc_area_list_envelope.g.dart';

/// PsgcAreaListEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class PsgcAreaListEnvelope implements Built<PsgcAreaListEnvelope, PsgcAreaListEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<PsgcAreaOption> get data;

  @BuiltValueField(wireName: r'meta')
  PsgcAreaListMeta get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<BuiltMap<String, JsonObject?>> get errors;

  PsgcAreaListEnvelope._();

  factory PsgcAreaListEnvelope([void updates(PsgcAreaListEnvelopeBuilder b)]) = _$PsgcAreaListEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PsgcAreaListEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PsgcAreaListEnvelope> get serializer => _$PsgcAreaListEnvelopeSerializer();
}

class _$PsgcAreaListEnvelopeSerializer implements PrimitiveSerializer<PsgcAreaListEnvelope> {
  @override
  final Iterable<Type> types = const [PsgcAreaListEnvelope, _$PsgcAreaListEnvelope];

  @override
  final String wireName = r'PsgcAreaListEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PsgcAreaListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(PsgcAreaOption)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(PsgcAreaListMeta),
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
    PsgcAreaListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PsgcAreaListEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PsgcAreaOption)]),
          ) as BuiltList<PsgcAreaOption>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PsgcAreaListMeta),
          ) as PsgcAreaListMeta;
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
  PsgcAreaListEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PsgcAreaListEnvelopeBuilder();
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


