//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/inventory_movement.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/page_meta.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inventory_movement_list_envelope.g.dart';

/// InventoryMovementListEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class InventoryMovementListEnvelope implements Built<InventoryMovementListEnvelope, InventoryMovementListEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<InventoryMovement> get data;

  @BuiltValueField(wireName: r'meta')
  PageMeta get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<BuiltMap<String, JsonObject?>> get errors;

  InventoryMovementListEnvelope._();

  factory InventoryMovementListEnvelope([void updates(InventoryMovementListEnvelopeBuilder b)]) = _$InventoryMovementListEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InventoryMovementListEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InventoryMovementListEnvelope> get serializer => _$InventoryMovementListEnvelopeSerializer();
}

class _$InventoryMovementListEnvelopeSerializer implements PrimitiveSerializer<InventoryMovementListEnvelope> {
  @override
  final Iterable<Type> types = const [InventoryMovementListEnvelope, _$InventoryMovementListEnvelope];

  @override
  final String wireName = r'InventoryMovementListEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InventoryMovementListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(InventoryMovement)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(PageMeta),
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
    InventoryMovementListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InventoryMovementListEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(InventoryMovement)]),
          ) as BuiltList<InventoryMovement>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PageMeta),
          ) as PageMeta;
          result.meta = valueDes.toBuilder();
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
  InventoryMovementListEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InventoryMovementListEnvelopeBuilder();
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


