//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'discovery_preferences.g.dart';

/// DiscoveryPreferences
///
/// Properties:
/// * [radiusKm] - One of 5, 10, 20, 30, 40 or 50.
@BuiltValue()
abstract class DiscoveryPreferences implements Built<DiscoveryPreferences, DiscoveryPreferencesBuilder> {
  /// One of 5, 10, 20, 30, 40 or 50.
  @BuiltValueField(wireName: r'radius_km')
  int get radiusKm;

  DiscoveryPreferences._();

  factory DiscoveryPreferences([void updates(DiscoveryPreferencesBuilder b)]) = _$DiscoveryPreferences;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DiscoveryPreferencesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DiscoveryPreferences> get serializer => _$DiscoveryPreferencesSerializer();
}

class _$DiscoveryPreferencesSerializer implements PrimitiveSerializer<DiscoveryPreferences> {
  @override
  final Iterable<Type> types = const [DiscoveryPreferences, _$DiscoveryPreferences];

  @override
  final String wireName = r'DiscoveryPreferences';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DiscoveryPreferences object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'radius_km';
    yield serializers.serialize(
      object.radiusKm,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DiscoveryPreferences object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DiscoveryPreferencesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'radius_km':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.radiusKm = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DiscoveryPreferences deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DiscoveryPreferencesBuilder();
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


