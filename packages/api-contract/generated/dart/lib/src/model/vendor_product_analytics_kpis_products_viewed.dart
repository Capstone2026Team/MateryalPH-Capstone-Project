//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_product_analytics_kpis_products_viewed.g.dart';

/// VendorProductAnalyticsKpisProductsViewed
///
/// Properties:
/// * [value]
/// * [total]
@BuiltValue()
abstract class VendorProductAnalyticsKpisProductsViewed implements Built<VendorProductAnalyticsKpisProductsViewed, VendorProductAnalyticsKpisProductsViewedBuilder> {
  @BuiltValueField(wireName: r'value')
  int get value;

  @BuiltValueField(wireName: r'total')
  int get total;

  VendorProductAnalyticsKpisProductsViewed._();

  factory VendorProductAnalyticsKpisProductsViewed([void updates(VendorProductAnalyticsKpisProductsViewedBuilder b)]) = _$VendorProductAnalyticsKpisProductsViewed;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorProductAnalyticsKpisProductsViewedBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorProductAnalyticsKpisProductsViewed> get serializer => _$VendorProductAnalyticsKpisProductsViewedSerializer();
}

class _$VendorProductAnalyticsKpisProductsViewedSerializer implements PrimitiveSerializer<VendorProductAnalyticsKpisProductsViewed> {
  @override
  final Iterable<Type> types = const [VendorProductAnalyticsKpisProductsViewed, _$VendorProductAnalyticsKpisProductsViewed];

  @override
  final String wireName = r'VendorProductAnalyticsKpisProductsViewed';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorProductAnalyticsKpisProductsViewed object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(int),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorProductAnalyticsKpisProductsViewed object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorProductAnalyticsKpisProductsViewedBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.value = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorProductAnalyticsKpisProductsViewed deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorProductAnalyticsKpisProductsViewedBuilder();
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


