//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_product_sales_breakdown.g.dart';

/// Materials after discounts, VAT included, plus delivery less completed partial refunds reconcile to Net sales.
///
/// Properties:
/// * [productSalesCentavos]
/// * [deliveryCentavos]
/// * [refundsCentavos]
/// * [netSalesCentavos]
@BuiltValue()
abstract class VendorProductSalesBreakdown implements Built<VendorProductSalesBreakdown, VendorProductSalesBreakdownBuilder> {
  @BuiltValueField(wireName: r'product_sales_centavos')
  int get productSalesCentavos;

  @BuiltValueField(wireName: r'delivery_centavos')
  int get deliveryCentavos;

  @BuiltValueField(wireName: r'refunds_centavos')
  int get refundsCentavos;

  @BuiltValueField(wireName: r'net_sales_centavos')
  int get netSalesCentavos;

  VendorProductSalesBreakdown._();

  factory VendorProductSalesBreakdown([void updates(VendorProductSalesBreakdownBuilder b)]) = _$VendorProductSalesBreakdown;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorProductSalesBreakdownBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorProductSalesBreakdown> get serializer => _$VendorProductSalesBreakdownSerializer();
}

class _$VendorProductSalesBreakdownSerializer implements PrimitiveSerializer<VendorProductSalesBreakdown> {
  @override
  final Iterable<Type> types = const [VendorProductSalesBreakdown, _$VendorProductSalesBreakdown];

  @override
  final String wireName = r'VendorProductSalesBreakdown';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorProductSalesBreakdown object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'product_sales_centavos';
    yield serializers.serialize(
      object.productSalesCentavos,
      specifiedType: const FullType(int),
    );
    yield r'delivery_centavos';
    yield serializers.serialize(
      object.deliveryCentavos,
      specifiedType: const FullType(int),
    );
    yield r'refunds_centavos';
    yield serializers.serialize(
      object.refundsCentavos,
      specifiedType: const FullType(int),
    );
    yield r'net_sales_centavos';
    yield serializers.serialize(
      object.netSalesCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorProductSalesBreakdown object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorProductSalesBreakdownBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'product_sales_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.productSalesCentavos = valueDes;
          break;
        case r'delivery_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.deliveryCentavos = valueDes;
          break;
        case r'refunds_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.refundsCentavos = valueDes;
          break;
        case r'net_sales_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.netSalesCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorProductSalesBreakdown deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorProductSalesBreakdownBuilder();
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


