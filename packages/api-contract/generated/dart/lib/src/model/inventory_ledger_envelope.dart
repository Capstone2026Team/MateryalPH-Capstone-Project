//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/inventory_ledger_meta.dart';
import 'package:materyalph_api_client/src/model/inventory_row.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'inventory_ledger_envelope.g.dart';

/// InventoryLedgerEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class InventoryLedgerEnvelope implements Built<InventoryLedgerEnvelope, InventoryLedgerEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<InventoryRow> get data;

  @BuiltValueField(wireName: r'meta')
  InventoryLedgerMeta get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<BuiltMap<String, JsonObject?>> get errors;

  InventoryLedgerEnvelope._();

  factory InventoryLedgerEnvelope([void updates(InventoryLedgerEnvelopeBuilder b)]) = _$InventoryLedgerEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InventoryLedgerEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InventoryLedgerEnvelope> get serializer => _$InventoryLedgerEnvelopeSerializer();
}

class _$InventoryLedgerEnvelopeSerializer implements PrimitiveSerializer<InventoryLedgerEnvelope> {
  @override
  final Iterable<Type> types = const [InventoryLedgerEnvelope, _$InventoryLedgerEnvelope];

  @override
  final String wireName = r'InventoryLedgerEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InventoryLedgerEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(InventoryRow)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(InventoryLedgerMeta),
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
    InventoryLedgerEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InventoryLedgerEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(InventoryRow)]),
          ) as BuiltList<InventoryRow>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InventoryLedgerMeta),
          ) as InventoryLedgerMeta;
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
  InventoryLedgerEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InventoryLedgerEnvelopeBuilder();
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


