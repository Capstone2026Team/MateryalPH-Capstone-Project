//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_team_performance_activity.g.dart';

/// VendorTeamPerformanceActivity
///
/// Properties:
/// * [total]
/// * [succeeded]
/// * [unsuccessful]
@BuiltValue()
abstract class VendorTeamPerformanceActivity implements Built<VendorTeamPerformanceActivity, VendorTeamPerformanceActivityBuilder> {
  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'succeeded')
  int get succeeded;

  @BuiltValueField(wireName: r'unsuccessful')
  int get unsuccessful;

  VendorTeamPerformanceActivity._();

  factory VendorTeamPerformanceActivity([void updates(VendorTeamPerformanceActivityBuilder b)]) = _$VendorTeamPerformanceActivity;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorTeamPerformanceActivityBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorTeamPerformanceActivity> get serializer => _$VendorTeamPerformanceActivitySerializer();
}

class _$VendorTeamPerformanceActivitySerializer implements PrimitiveSerializer<VendorTeamPerformanceActivity> {
  @override
  final Iterable<Type> types = const [VendorTeamPerformanceActivity, _$VendorTeamPerformanceActivity];

  @override
  final String wireName = r'VendorTeamPerformanceActivity';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorTeamPerformanceActivity object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'succeeded';
    yield serializers.serialize(
      object.succeeded,
      specifiedType: const FullType(int),
    );
    yield r'unsuccessful';
    yield serializers.serialize(
      object.unsuccessful,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorTeamPerformanceActivity object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorTeamPerformanceActivityBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'succeeded':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.succeeded = valueDes;
          break;
        case r'unsuccessful':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unsuccessful = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorTeamPerformanceActivity deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorTeamPerformanceActivityBuilder();
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


