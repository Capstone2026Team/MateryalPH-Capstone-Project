//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/directory_supplier_detail.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'directory_supplier_detail_envelope.g.dart';

/// DirectorySupplierDetailEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class DirectorySupplierDetailEnvelope implements Built<DirectorySupplierDetailEnvelope, DirectorySupplierDetailEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  DirectorySupplierDetail get data;

  @BuiltValueField(wireName: r'meta')
  BuiltMap<String, JsonObject?> get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<BuiltMap<String, JsonObject?>> get errors;

  DirectorySupplierDetailEnvelope._();

  factory DirectorySupplierDetailEnvelope([void updates(DirectorySupplierDetailEnvelopeBuilder b)]) = _$DirectorySupplierDetailEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectorySupplierDetailEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectorySupplierDetailEnvelope> get serializer => _$DirectorySupplierDetailEnvelopeSerializer();
}

class _$DirectorySupplierDetailEnvelopeSerializer implements PrimitiveSerializer<DirectorySupplierDetailEnvelope> {
  @override
  final Iterable<Type> types = const [DirectorySupplierDetailEnvelope, _$DirectorySupplierDetailEnvelope];

  @override
  final String wireName = r'DirectorySupplierDetailEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectorySupplierDetailEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(DirectorySupplierDetail),
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
    DirectorySupplierDetailEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DirectorySupplierDetailEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DirectorySupplierDetail),
          ) as DirectorySupplierDetail;
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
  DirectorySupplierDetailEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectorySupplierDetailEnvelopeBuilder();
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


