//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_area_segment.g.dart';

/// AdminDashboardAreaSegment
///
/// Properties:
/// * [id]
/// * [label]
/// * [size]
/// * [averageVendors]
/// * [averageBuyers]
/// * [averageOrders]
/// * [averageGmvCentavos]
/// * [examples]
@BuiltValue()
abstract class AdminDashboardAreaSegment implements Built<AdminDashboardAreaSegment, AdminDashboardAreaSegmentBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'size')
  int get size;

  @BuiltValueField(wireName: r'average_vendors')
  num get averageVendors;

  @BuiltValueField(wireName: r'average_buyers')
  num get averageBuyers;

  @BuiltValueField(wireName: r'average_orders')
  num get averageOrders;

  @BuiltValueField(wireName: r'average_gmv_centavos')
  int get averageGmvCentavos;

  @BuiltValueField(wireName: r'examples')
  BuiltList<String> get examples;

  AdminDashboardAreaSegment._();

  factory AdminDashboardAreaSegment([void updates(AdminDashboardAreaSegmentBuilder b)]) = _$AdminDashboardAreaSegment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardAreaSegmentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardAreaSegment> get serializer => _$AdminDashboardAreaSegmentSerializer();
}

class _$AdminDashboardAreaSegmentSerializer implements PrimitiveSerializer<AdminDashboardAreaSegment> {
  @override
  final Iterable<Type> types = const [AdminDashboardAreaSegment, _$AdminDashboardAreaSegment];

  @override
  final String wireName = r'AdminDashboardAreaSegment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardAreaSegment object, {
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
    yield r'average_vendors';
    yield serializers.serialize(
      object.averageVendors,
      specifiedType: const FullType(num),
    );
    yield r'average_buyers';
    yield serializers.serialize(
      object.averageBuyers,
      specifiedType: const FullType(num),
    );
    yield r'average_orders';
    yield serializers.serialize(
      object.averageOrders,
      specifiedType: const FullType(num),
    );
    yield r'average_gmv_centavos';
    yield serializers.serialize(
      object.averageGmvCentavos,
      specifiedType: const FullType(int),
    );
    yield r'examples';
    yield serializers.serialize(
      object.examples,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardAreaSegment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDashboardAreaSegmentBuilder result,
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
        case r'average_vendors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.averageVendors = valueDes;
          break;
        case r'average_buyers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.averageBuyers = valueDes;
          break;
        case r'average_orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.averageOrders = valueDes;
          break;
        case r'average_gmv_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.averageGmvCentavos = valueDes;
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
  AdminDashboardAreaSegment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardAreaSegmentBuilder();
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


