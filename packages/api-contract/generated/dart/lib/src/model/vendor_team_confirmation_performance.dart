//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_team_confirmation_performance.g.dart';

/// VendorTeamConfirmationPerformance
///
/// Properties:
/// * [confirmed]
/// * [revised]
/// * [declined]
@BuiltValue()
abstract class VendorTeamConfirmationPerformance implements Built<VendorTeamConfirmationPerformance, VendorTeamConfirmationPerformanceBuilder> {
  @BuiltValueField(wireName: r'confirmed')
  int get confirmed;

  @BuiltValueField(wireName: r'revised')
  int get revised;

  @BuiltValueField(wireName: r'declined')
  int get declined;

  VendorTeamConfirmationPerformance._();

  factory VendorTeamConfirmationPerformance([void updates(VendorTeamConfirmationPerformanceBuilder b)]) = _$VendorTeamConfirmationPerformance;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorTeamConfirmationPerformanceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorTeamConfirmationPerformance> get serializer => _$VendorTeamConfirmationPerformanceSerializer();
}

class _$VendorTeamConfirmationPerformanceSerializer implements PrimitiveSerializer<VendorTeamConfirmationPerformance> {
  @override
  final Iterable<Type> types = const [VendorTeamConfirmationPerformance, _$VendorTeamConfirmationPerformance];

  @override
  final String wireName = r'VendorTeamConfirmationPerformance';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorTeamConfirmationPerformance object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'confirmed';
    yield serializers.serialize(
      object.confirmed,
      specifiedType: const FullType(int),
    );
    yield r'revised';
    yield serializers.serialize(
      object.revised,
      specifiedType: const FullType(int),
    );
    yield r'declined';
    yield serializers.serialize(
      object.declined,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorTeamConfirmationPerformance object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorTeamConfirmationPerformanceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'confirmed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.confirmed = valueDes;
          break;
        case r'revised':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.revised = valueDes;
          break;
        case r'declined':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.declined = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorTeamConfirmationPerformance deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorTeamConfirmationPerformanceBuilder();
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


