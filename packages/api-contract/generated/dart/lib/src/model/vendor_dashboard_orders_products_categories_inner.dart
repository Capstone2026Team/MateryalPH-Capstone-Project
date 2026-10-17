//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_dashboard_orders_products_categories_inner.g.dart';

/// VendorDashboardOrdersProductsCategoriesInner
///
/// Properties:
/// * [category]
/// * [orders]
/// * [valueCentavos]
@BuiltValue()
abstract class VendorDashboardOrdersProductsCategoriesInner implements Built<VendorDashboardOrdersProductsCategoriesInner, VendorDashboardOrdersProductsCategoriesInnerBuilder> {
  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'orders')
  int get orders;

  @BuiltValueField(wireName: r'value_centavos')
  int? get valueCentavos;

  VendorDashboardOrdersProductsCategoriesInner._();

  factory VendorDashboardOrdersProductsCategoriesInner([void updates(VendorDashboardOrdersProductsCategoriesInnerBuilder b)]) = _$VendorDashboardOrdersProductsCategoriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDashboardOrdersProductsCategoriesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDashboardOrdersProductsCategoriesInner> get serializer => _$VendorDashboardOrdersProductsCategoriesInnerSerializer();
}

class _$VendorDashboardOrdersProductsCategoriesInnerSerializer implements PrimitiveSerializer<VendorDashboardOrdersProductsCategoriesInner> {
  @override
  final Iterable<Type> types = const [VendorDashboardOrdersProductsCategoriesInner, _$VendorDashboardOrdersProductsCategoriesInner];

  @override
  final String wireName = r'VendorDashboardOrdersProductsCategoriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDashboardOrdersProductsCategoriesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(String),
    );
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(int),
    );
    if (object.valueCentavos != null) {
      yield r'value_centavos';
      yield serializers.serialize(
        object.valueCentavos,
        specifiedType: const FullType.nullable(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDashboardOrdersProductsCategoriesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDashboardOrdersProductsCategoriesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.category = valueDes;
          break;
        case r'orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.orders = valueDes;
          break;
        case r'value_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.valueCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDashboardOrdersProductsCategoriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDashboardOrdersProductsCategoriesInnerBuilder();
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


