//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mixer_volume_plan.g.dart';

/// Ready-mixed concrete trip plan. Each full load is limited by Mixer Capacity and by payload at the concrete's density; the last trip carries the rest.
///
/// Properties:
/// * [totalM3]
/// * [fullLoadM3]
/// * [fullTrips]
/// * [lastTripM3]
@BuiltValue()
abstract class MixerVolumePlan implements Built<MixerVolumePlan, MixerVolumePlanBuilder> {
  @BuiltValueField(wireName: r'total_m3')
  num get totalM3;

  @BuiltValueField(wireName: r'full_load_m3')
  num get fullLoadM3;

  @BuiltValueField(wireName: r'full_trips')
  int get fullTrips;

  @BuiltValueField(wireName: r'last_trip_m3')
  num get lastTripM3;

  MixerVolumePlan._();

  factory MixerVolumePlan([void updates(MixerVolumePlanBuilder b)]) = _$MixerVolumePlan;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MixerVolumePlanBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MixerVolumePlan> get serializer => _$MixerVolumePlanSerializer();
}

class _$MixerVolumePlanSerializer implements PrimitiveSerializer<MixerVolumePlan> {
  @override
  final Iterable<Type> types = const [MixerVolumePlan, _$MixerVolumePlan];

  @override
  final String wireName = r'MixerVolumePlan';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MixerVolumePlan object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'total_m3';
    yield serializers.serialize(
      object.totalM3,
      specifiedType: const FullType(num),
    );
    yield r'full_load_m3';
    yield serializers.serialize(
      object.fullLoadM3,
      specifiedType: const FullType(num),
    );
    yield r'full_trips';
    yield serializers.serialize(
      object.fullTrips,
      specifiedType: const FullType(int),
    );
    yield r'last_trip_m3';
    yield serializers.serialize(
      object.lastTripM3,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MixerVolumePlan object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MixerVolumePlanBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'total_m3':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.totalM3 = valueDes;
          break;
        case r'full_load_m3':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.fullLoadM3 = valueDes;
          break;
        case r'full_trips':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.fullTrips = valueDes;
          break;
        case r'last_trip_m3':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.lastTripM3 = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MixerVolumePlan deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MixerVolumePlanBuilder();
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


