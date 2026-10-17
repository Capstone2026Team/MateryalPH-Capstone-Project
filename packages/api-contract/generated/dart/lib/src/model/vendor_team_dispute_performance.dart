//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_team_dispute_performance.g.dart';

/// VendorTeamDisputePerformance
///
/// Properties:
/// * [handled]
/// * [resolved]
/// * [open] - Currently active cases this member handles.
@BuiltValue()
abstract class VendorTeamDisputePerformance implements Built<VendorTeamDisputePerformance, VendorTeamDisputePerformanceBuilder> {
  @BuiltValueField(wireName: r'handled')
  int get handled;

  @BuiltValueField(wireName: r'resolved')
  int get resolved;

  /// Currently active cases this member handles.
  @BuiltValueField(wireName: r'open')
  int get open;

  VendorTeamDisputePerformance._();

  factory VendorTeamDisputePerformance([void updates(VendorTeamDisputePerformanceBuilder b)]) = _$VendorTeamDisputePerformance;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorTeamDisputePerformanceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorTeamDisputePerformance> get serializer => _$VendorTeamDisputePerformanceSerializer();
}

class _$VendorTeamDisputePerformanceSerializer implements PrimitiveSerializer<VendorTeamDisputePerformance> {
  @override
  final Iterable<Type> types = const [VendorTeamDisputePerformance, _$VendorTeamDisputePerformance];

  @override
  final String wireName = r'VendorTeamDisputePerformance';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorTeamDisputePerformance object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'handled';
    yield serializers.serialize(
      object.handled,
      specifiedType: const FullType(int),
    );
    yield r'resolved';
    yield serializers.serialize(
      object.resolved,
      specifiedType: const FullType(int),
    );
    yield r'open';
    yield serializers.serialize(
      object.open,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorTeamDisputePerformance object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorTeamDisputePerformanceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'handled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.handled = valueDes;
          break;
        case r'resolved':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.resolved = valueDes;
          break;
        case r'open':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.open = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorTeamDisputePerformance deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorTeamDisputePerformanceBuilder();
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


