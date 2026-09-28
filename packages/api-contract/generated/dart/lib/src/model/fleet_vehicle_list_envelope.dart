//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/fleet_vehicle_list_meta.dart';
import 'package:materyalph_api_client/src/model/fleet_vehicle.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fleet_vehicle_list_envelope.g.dart';

/// FleetVehicleListEnvelope
///
/// Properties:
/// * [data]
/// * [meta]
/// * [errors]
@BuiltValue()
abstract class FleetVehicleListEnvelope implements Built<FleetVehicleListEnvelope, FleetVehicleListEnvelopeBuilder> {
  @BuiltValueField(wireName: r'data')
  BuiltList<FleetVehicle> get data;

  @BuiltValueField(wireName: r'meta')
  FleetVehicleListMeta get meta;

  @BuiltValueField(wireName: r'errors')
  BuiltList<BuiltMap<String, JsonObject?>> get errors;

  FleetVehicleListEnvelope._();

  factory FleetVehicleListEnvelope([void updates(FleetVehicleListEnvelopeBuilder b)]) = _$FleetVehicleListEnvelope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FleetVehicleListEnvelopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FleetVehicleListEnvelope> get serializer => _$FleetVehicleListEnvelopeSerializer();
}

class _$FleetVehicleListEnvelopeSerializer implements PrimitiveSerializer<FleetVehicleListEnvelope> {
  @override
  final Iterable<Type> types = const [FleetVehicleListEnvelope, _$FleetVehicleListEnvelope];

  @override
  final String wireName = r'FleetVehicleListEnvelope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FleetVehicleListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'data';
    yield serializers.serialize(
      object.data,
      specifiedType: const FullType(BuiltList, [FullType(FleetVehicle)]),
    );
    yield r'meta';
    yield serializers.serialize(
      object.meta,
      specifiedType: const FullType(FleetVehicleListMeta),
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
    FleetVehicleListEnvelope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FleetVehicleListEnvelopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(FleetVehicle)]),
          ) as BuiltList<FleetVehicle>;
          result.data.replace(valueDes);
          break;
        case r'meta':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FleetVehicleListMeta),
          ) as FleetVehicleListMeta;
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
  FleetVehicleListEnvelope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FleetVehicleListEnvelopeBuilder();
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


