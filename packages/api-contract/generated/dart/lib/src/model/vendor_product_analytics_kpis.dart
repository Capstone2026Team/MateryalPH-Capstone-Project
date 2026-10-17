//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/dashboard_rate.dart';
import 'package:materyalph_api_client/src/model/dashboard_delta.dart';
import 'package:materyalph_api_client/src/model/vendor_product_analytics_kpis_products_viewed.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_product_analytics_kpis.g.dart';

/// VendorProductAnalyticsKpis
///
/// Properties:
/// * [views]
/// * [viewers]
/// * [productsViewed]
/// * [orders]
/// * [conversion]
/// * [valueCentavos]
@BuiltValue()
abstract class VendorProductAnalyticsKpis implements Built<VendorProductAnalyticsKpis, VendorProductAnalyticsKpisBuilder> {
  @BuiltValueField(wireName: r'views')
  DashboardDelta get views;

  @BuiltValueField(wireName: r'viewers')
  DashboardDelta get viewers;

  @BuiltValueField(wireName: r'products_viewed')
  VendorProductAnalyticsKpisProductsViewed get productsViewed;

  @BuiltValueField(wireName: r'orders')
  DashboardDelta get orders;

  @BuiltValueField(wireName: r'conversion')
  DashboardRate get conversion;

  @BuiltValueField(wireName: r'value_centavos')
  DashboardDelta? get valueCentavos;

  VendorProductAnalyticsKpis._();

  factory VendorProductAnalyticsKpis([void updates(VendorProductAnalyticsKpisBuilder b)]) = _$VendorProductAnalyticsKpis;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorProductAnalyticsKpisBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorProductAnalyticsKpis> get serializer => _$VendorProductAnalyticsKpisSerializer();
}

class _$VendorProductAnalyticsKpisSerializer implements PrimitiveSerializer<VendorProductAnalyticsKpis> {
  @override
  final Iterable<Type> types = const [VendorProductAnalyticsKpis, _$VendorProductAnalyticsKpis];

  @override
  final String wireName = r'VendorProductAnalyticsKpis';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorProductAnalyticsKpis object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'views';
    yield serializers.serialize(
      object.views,
      specifiedType: const FullType(DashboardDelta),
    );
    yield r'viewers';
    yield serializers.serialize(
      object.viewers,
      specifiedType: const FullType(DashboardDelta),
    );
    yield r'products_viewed';
    yield serializers.serialize(
      object.productsViewed,
      specifiedType: const FullType(VendorProductAnalyticsKpisProductsViewed),
    );
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(DashboardDelta),
    );
    yield r'conversion';
    yield serializers.serialize(
      object.conversion,
      specifiedType: const FullType(DashboardRate),
    );
    if (object.valueCentavos != null) {
      yield r'value_centavos';
      yield serializers.serialize(
        object.valueCentavos,
        specifiedType: const FullType.nullable(DashboardDelta),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorProductAnalyticsKpis object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorProductAnalyticsKpisBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'views':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DashboardDelta),
          ) as DashboardDelta;
          result.views.replace(valueDes);
          break;
        case r'viewers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DashboardDelta),
          ) as DashboardDelta;
          result.viewers.replace(valueDes);
          break;
        case r'products_viewed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorProductAnalyticsKpisProductsViewed),
          ) as VendorProductAnalyticsKpisProductsViewed;
          result.productsViewed.replace(valueDes);
          break;
        case r'orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DashboardDelta),
          ) as DashboardDelta;
          result.orders.replace(valueDes);
          break;
        case r'conversion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DashboardRate),
          ) as DashboardRate;
          result.conversion.replace(valueDes);
          break;
        case r'value_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DashboardDelta),
          ) as DashboardDelta?;
          if (valueDes == null) continue;
          result.valueCentavos.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorProductAnalyticsKpis deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorProductAnalyticsKpisBuilder();
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


