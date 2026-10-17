//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_vendor_health_segments_segments_inner.g.dart';

/// AdminDashboardVendorHealthSegmentsSegmentsInner
///
/// Properties:
/// * [id]
/// * [label]
/// * [size]
/// * [averageVps]
/// * [averageOhs]
/// * [averageCompletedOrders]
@BuiltValue()
abstract class AdminDashboardVendorHealthSegmentsSegmentsInner implements Built<AdminDashboardVendorHealthSegmentsSegmentsInner, AdminDashboardVendorHealthSegmentsSegmentsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'size')
  int get size;

  @BuiltValueField(wireName: r'average_vps')
  num get averageVps;

  @BuiltValueField(wireName: r'average_ohs')
  num get averageOhs;

  @BuiltValueField(wireName: r'average_completed_orders')
  num get averageCompletedOrders;

  AdminDashboardVendorHealthSegmentsSegmentsInner._();

  factory AdminDashboardVendorHealthSegmentsSegmentsInner([void updates(AdminDashboardVendorHealthSegmentsSegmentsInnerBuilder b)]) = _$AdminDashboardVendorHealthSegmentsSegmentsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardVendorHealthSegmentsSegmentsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardVendorHealthSegmentsSegmentsInner> get serializer => _$AdminDashboardVendorHealthSegmentsSegmentsInnerSerializer();
}

class _$AdminDashboardVendorHealthSegmentsSegmentsInnerSerializer implements PrimitiveSerializer<AdminDashboardVendorHealthSegmentsSegmentsInner> {
  @override
  final Iterable<Type> types = const [AdminDashboardVendorHealthSegmentsSegmentsInner, _$AdminDashboardVendorHealthSegmentsSegmentsInner];

  @override
  final String wireName = r'AdminDashboardVendorHealthSegmentsSegmentsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardVendorHealthSegmentsSegmentsInner object, {
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
    yield r'average_vps';
    yield serializers.serialize(
      object.averageVps,
      specifiedType: const FullType(num),
    );
    yield r'average_ohs';
    yield serializers.serialize(
      object.averageOhs,
      specifiedType: const FullType(num),
    );
    yield r'average_completed_orders';
    yield serializers.serialize(
      object.averageCompletedOrders,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardVendorHealthSegmentsSegmentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDashboardVendorHealthSegmentsSegmentsInnerBuilder result,
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
        case r'average_vps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.averageVps = valueDes;
          break;
        case r'average_ohs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.averageOhs = valueDes;
          break;
        case r'average_completed_orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.averageCompletedOrders = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardVendorHealthSegmentsSegmentsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardVendorHealthSegmentsSegmentsInnerBuilder();
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


