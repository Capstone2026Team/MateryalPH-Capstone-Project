//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_dashboard_orders_products_segments.dart';
import 'package:materyalph_api_client/src/model/vendor_dashboard_orders_products_basket_rules.dart';
import 'package:materyalph_api_client/src/model/vendor_dashboard_orders_products_categories_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/vendor_dashboard_product.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_dashboard_orders_products.g.dart';

/// VendorDashboardOrdersProducts
///
/// Properties:
/// * [top]
/// * [categories]
/// * [segments]
/// * [basketRules]
@BuiltValue()
abstract class VendorDashboardOrdersProducts implements Built<VendorDashboardOrdersProducts, VendorDashboardOrdersProductsBuilder> {
  @BuiltValueField(wireName: r'top')
  BuiltList<VendorDashboardProduct> get top;

  @BuiltValueField(wireName: r'categories')
  BuiltList<VendorDashboardOrdersProductsCategoriesInner> get categories;

  @BuiltValueField(wireName: r'segments')
  VendorDashboardOrdersProductsSegments get segments;

  @BuiltValueField(wireName: r'basket_rules')
  VendorDashboardOrdersProductsBasketRules get basketRules;

  VendorDashboardOrdersProducts._();

  factory VendorDashboardOrdersProducts([void updates(VendorDashboardOrdersProductsBuilder b)]) = _$VendorDashboardOrdersProducts;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDashboardOrdersProductsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDashboardOrdersProducts> get serializer => _$VendorDashboardOrdersProductsSerializer();
}

class _$VendorDashboardOrdersProductsSerializer implements PrimitiveSerializer<VendorDashboardOrdersProducts> {
  @override
  final Iterable<Type> types = const [VendorDashboardOrdersProducts, _$VendorDashboardOrdersProducts];

  @override
  final String wireName = r'VendorDashboardOrdersProducts';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDashboardOrdersProducts object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'top';
    yield serializers.serialize(
      object.top,
      specifiedType: const FullType(BuiltList, [FullType(VendorDashboardProduct)]),
    );
    yield r'categories';
    yield serializers.serialize(
      object.categories,
      specifiedType: const FullType(BuiltList, [FullType(VendorDashboardOrdersProductsCategoriesInner)]),
    );
    yield r'segments';
    yield serializers.serialize(
      object.segments,
      specifiedType: const FullType(VendorDashboardOrdersProductsSegments),
    );
    yield r'basket_rules';
    yield serializers.serialize(
      object.basketRules,
      specifiedType: const FullType(VendorDashboardOrdersProductsBasketRules),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDashboardOrdersProducts object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDashboardOrdersProductsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'top':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorDashboardProduct)]),
          ) as BuiltList<VendorDashboardProduct>;
          result.top.replace(valueDes);
          break;
        case r'categories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorDashboardOrdersProductsCategoriesInner)]),
          ) as BuiltList<VendorDashboardOrdersProductsCategoriesInner>;
          result.categories.replace(valueDes);
          break;
        case r'segments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorDashboardOrdersProductsSegments),
          ) as VendorDashboardOrdersProductsSegments;
          result.segments.replace(valueDes);
          break;
        case r'basket_rules':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorDashboardOrdersProductsBasketRules),
          ) as VendorDashboardOrdersProductsBasketRules;
          result.basketRules.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDashboardOrdersProducts deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDashboardOrdersProductsBuilder();
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


