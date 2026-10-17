//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_dashboard_orders_products_segments_points_inner.g.dart';

/// VendorDashboardOrdersProductsSegmentsPointsInner
///
/// Properties:
/// * [name]
/// * [orders]
/// * [buyers]
/// * [segment]
@BuiltValue()
abstract class VendorDashboardOrdersProductsSegmentsPointsInner implements Built<VendorDashboardOrdersProductsSegmentsPointsInner, VendorDashboardOrdersProductsSegmentsPointsInnerBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'orders')
  int get orders;

  @BuiltValueField(wireName: r'buyers')
  int get buyers;

  @BuiltValueField(wireName: r'segment')
  String get segment;

  VendorDashboardOrdersProductsSegmentsPointsInner._();

  factory VendorDashboardOrdersProductsSegmentsPointsInner([void updates(VendorDashboardOrdersProductsSegmentsPointsInnerBuilder b)]) = _$VendorDashboardOrdersProductsSegmentsPointsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDashboardOrdersProductsSegmentsPointsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDashboardOrdersProductsSegmentsPointsInner> get serializer => _$VendorDashboardOrdersProductsSegmentsPointsInnerSerializer();
}

class _$VendorDashboardOrdersProductsSegmentsPointsInnerSerializer implements PrimitiveSerializer<VendorDashboardOrdersProductsSegmentsPointsInner> {
  @override
  final Iterable<Type> types = const [VendorDashboardOrdersProductsSegmentsPointsInner, _$VendorDashboardOrdersProductsSegmentsPointsInner];

  @override
  final String wireName = r'VendorDashboardOrdersProductsSegmentsPointsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDashboardOrdersProductsSegmentsPointsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(int),
    );
    yield r'buyers';
    yield serializers.serialize(
      object.buyers,
      specifiedType: const FullType(int),
    );
    yield r'segment';
    yield serializers.serialize(
      object.segment,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDashboardOrdersProductsSegmentsPointsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDashboardOrdersProductsSegmentsPointsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.orders = valueDes;
          break;
        case r'buyers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.buyers = valueDes;
          break;
        case r'segment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.segment = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDashboardOrdersProductsSegmentsPointsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDashboardOrdersProductsSegmentsPointsInnerBuilder();
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


