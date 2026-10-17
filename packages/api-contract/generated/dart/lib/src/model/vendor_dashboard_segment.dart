//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_dashboard_segment.g.dart';

/// VendorDashboardSegment
///
/// Properties:
/// * [id]
/// * [label]
/// * [size]
/// * [averageOrders]
/// * [averageBuyers]
/// * [averageValueCentavos]
/// * [examples]
@BuiltValue()
abstract class VendorDashboardSegment implements Built<VendorDashboardSegment, VendorDashboardSegmentBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'size')
  int get size;

  @BuiltValueField(wireName: r'average_orders')
  num get averageOrders;

  @BuiltValueField(wireName: r'average_buyers')
  num get averageBuyers;

  @BuiltValueField(wireName: r'average_value_centavos')
  int? get averageValueCentavos;

  @BuiltValueField(wireName: r'examples')
  BuiltList<String> get examples;

  VendorDashboardSegment._();

  factory VendorDashboardSegment([void updates(VendorDashboardSegmentBuilder b)]) = _$VendorDashboardSegment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDashboardSegmentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDashboardSegment> get serializer => _$VendorDashboardSegmentSerializer();
}

class _$VendorDashboardSegmentSerializer implements PrimitiveSerializer<VendorDashboardSegment> {
  @override
  final Iterable<Type> types = const [VendorDashboardSegment, _$VendorDashboardSegment];

  @override
  final String wireName = r'VendorDashboardSegment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDashboardSegment object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'size';
    yield serializers.serialize(
      object.size,
      specifiedType: const FullType(int),
    );
    yield r'average_orders';
    yield serializers.serialize(
      object.averageOrders,
      specifiedType: const FullType(num),
    );
    yield r'average_buyers';
    yield serializers.serialize(
      object.averageBuyers,
      specifiedType: const FullType(num),
    );
    if (object.averageValueCentavos != null) {
      yield r'average_value_centavos';
      yield serializers.serialize(
        object.averageValueCentavos,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'examples';
    yield serializers.serialize(
      object.examples,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDashboardSegment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDashboardSegmentBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'size':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.size = valueDes;
          break;
        case r'average_orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.averageOrders = valueDes;
          break;
        case r'average_buyers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.averageBuyers = valueDes;
          break;
        case r'average_value_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.averageValueCentavos = valueDes;
          break;
        case r'examples':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.examples.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDashboardSegment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDashboardSegmentBuilder();
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


