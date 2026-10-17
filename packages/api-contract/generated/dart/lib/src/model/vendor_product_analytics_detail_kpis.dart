//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/dashboard_rate.dart';
import 'package:materyalph_api_client/src/model/dashboard_delta.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_product_analytics_detail_kpis.g.dart';

/// VendorProductAnalyticsDetailKpis
///
/// Properties:
/// * [views]
/// * [viewers]
/// * [orders]
/// * [buyers]
/// * [conversion]
/// * [storeConversion]
/// * [valueCentavos]
/// * [products]
@BuiltValue()
abstract class VendorProductAnalyticsDetailKpis implements Built<VendorProductAnalyticsDetailKpis, VendorProductAnalyticsDetailKpisBuilder> {
  @BuiltValueField(wireName: r'views')
  DashboardDelta get views;

  @BuiltValueField(wireName: r'viewers')
  DashboardDelta get viewers;

  @BuiltValueField(wireName: r'orders')
  DashboardDelta get orders;

  @BuiltValueField(wireName: r'buyers')
  int get buyers;

  @BuiltValueField(wireName: r'conversion')
  DashboardRate get conversion;

  @BuiltValueField(wireName: r'store_conversion')
  DashboardRate get storeConversion;

  @BuiltValueField(wireName: r'value_centavos')
  DashboardDelta? get valueCentavos;

  @BuiltValueField(wireName: r'products')
  int get products;

  VendorProductAnalyticsDetailKpis._();

  factory VendorProductAnalyticsDetailKpis([void updates(VendorProductAnalyticsDetailKpisBuilder b)]) = _$VendorProductAnalyticsDetailKpis;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorProductAnalyticsDetailKpisBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorProductAnalyticsDetailKpis> get serializer => _$VendorProductAnalyticsDetailKpisSerializer();
}

class _$VendorProductAnalyticsDetailKpisSerializer implements PrimitiveSerializer<VendorProductAnalyticsDetailKpis> {
  @override
  final Iterable<Type> types = const [VendorProductAnalyticsDetailKpis, _$VendorProductAnalyticsDetailKpis];

  @override
  final String wireName = r'VendorProductAnalyticsDetailKpis';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorProductAnalyticsDetailKpis object, {
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
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(DashboardDelta),
    );
    yield r'buyers';
    yield serializers.serialize(
      object.buyers,
      specifiedType: const FullType(int),
    );
    yield r'conversion';
    yield serializers.serialize(
      object.conversion,
      specifiedType: const FullType(DashboardRate),
    );
    yield r'store_conversion';
    yield serializers.serialize(
      object.storeConversion,
      specifiedType: const FullType(DashboardRate),
    );
    if (object.valueCentavos != null) {
      yield r'value_centavos';
      yield serializers.serialize(
        object.valueCentavos,
        specifiedType: const FullType.nullable(DashboardDelta),
      );
    }
    yield r'products';
    yield serializers.serialize(
      object.products,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorProductAnalyticsDetailKpis object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorProductAnalyticsDetailKpisBuilder result,
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
        case r'orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DashboardDelta),
          ) as DashboardDelta;
          result.orders.replace(valueDes);
          break;
        case r'buyers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.buyers = valueDes;
          break;
        case r'conversion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DashboardRate),
          ) as DashboardRate;
          result.conversion.replace(valueDes);
          break;
        case r'store_conversion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DashboardRate),
          ) as DashboardRate;
          result.storeConversion.replace(valueDes);
          break;
        case r'value_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DashboardDelta),
          ) as DashboardDelta?;
          if (valueDes == null) continue;
          result.valueCentavos.replace(valueDes);
          break;
        case r'products':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.products = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorProductAnalyticsDetailKpis deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorProductAnalyticsDetailKpisBuilder();
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


