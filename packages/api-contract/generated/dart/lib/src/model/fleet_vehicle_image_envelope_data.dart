//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fleet_vehicle_image_envelope_data.g.dart';

/// FleetVehicleImageEnvelopeData
///
/// Properties:
/// * [fileId]
/// * [status]
/// * [url]
/// * [expiresAt]
@BuiltValue()
abstract class FleetVehicleImageEnvelopeData implements Built<FleetVehicleImageEnvelopeData, FleetVehicleImageEnvelopeDataBuilder> {
  @BuiltValueField(wireName: r'file_id')
  String get fileId;

  @BuiltValueField(wireName: r'status')
  FleetVehicleImageEnvelopeDataStatusEnum get status;
  // enum statusEnum {  READY,  };

  @BuiltValueField(wireName: r'url')
  String get url;

  @BuiltValueField(wireName: r'expires_at')
  DateTime get expiresAt;

  FleetVehicleImageEnvelopeData._();

  factory FleetVehicleImageEnvelopeData([void updates(FleetVehicleImageEnvelopeDataBuilder b)]) = _$FleetVehicleImageEnvelopeData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FleetVehicleImageEnvelopeDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FleetVehicleImageEnvelopeData> get serializer => _$FleetVehicleImageEnvelopeDataSerializer();
}

class _$FleetVehicleImageEnvelopeDataSerializer implements PrimitiveSerializer<FleetVehicleImageEnvelopeData> {
  @override
  final Iterable<Type> types = const [FleetVehicleImageEnvelopeData, _$FleetVehicleImageEnvelopeData];

  @override
  final String wireName = r'FleetVehicleImageEnvelopeData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FleetVehicleImageEnvelopeData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'file_id';
    yield serializers.serialize(
      object.fileId,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(FleetVehicleImageEnvelopeDataStatusEnum),
    );
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
    );
    yield r'expires_at';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FleetVehicleImageEnvelopeData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FleetVehicleImageEnvelopeDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'file_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fileId = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FleetVehicleImageEnvelopeDataStatusEnum),
          ) as FleetVehicleImageEnvelopeDataStatusEnum;
          result.status = valueDes;
          break;
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        case r'expires_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FleetVehicleImageEnvelopeData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FleetVehicleImageEnvelopeDataBuilder();
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


class FleetVehicleImageEnvelopeDataStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'READY')
  static const FleetVehicleImageEnvelopeDataStatusEnum READY = _$fleetVehicleImageEnvelopeDataStatusEnum_READY;

  static Serializer<FleetVehicleImageEnvelopeDataStatusEnum> get serializer => _$fleetVehicleImageEnvelopeDataStatusEnumSerializer;

  const FleetVehicleImageEnvelopeDataStatusEnum._(String name): super(name);

  static BuiltSet<FleetVehicleImageEnvelopeDataStatusEnum> get values => _$fleetVehicleImageEnvelopeDataStatusEnumValues;
  static FleetVehicleImageEnvelopeDataStatusEnum valueOf(String name) => _$fleetVehicleImageEnvelopeDataStatusEnumValueOf(name);
}

