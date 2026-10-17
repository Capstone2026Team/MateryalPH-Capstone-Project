//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_earnings_breakdown_sales.g.dart';

/// VendorEarningsBreakdownSales
///
/// Properties:
/// * [orders]
/// * [materialsBeforeDiscountCentavos]
/// * [vendorDiscountsCentavos]
/// * [materialsAfterDiscountCentavos]
/// * [deliveryCentavos]
@BuiltValue()
abstract class VendorEarningsBreakdownSales implements Built<VendorEarningsBreakdownSales, VendorEarningsBreakdownSalesBuilder> {
  @BuiltValueField(wireName: r'orders')
  int get orders;

  @BuiltValueField(wireName: r'materials_before_discount_centavos')
  int get materialsBeforeDiscountCentavos;

  @BuiltValueField(wireName: r'vendor_discounts_centavos')
  int get vendorDiscountsCentavos;

  @BuiltValueField(wireName: r'materials_after_discount_centavos')
  int get materialsAfterDiscountCentavos;

  @BuiltValueField(wireName: r'delivery_centavos')
  int get deliveryCentavos;

  VendorEarningsBreakdownSales._();

  factory VendorEarningsBreakdownSales([void updates(VendorEarningsBreakdownSalesBuilder b)]) = _$VendorEarningsBreakdownSales;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorEarningsBreakdownSalesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorEarningsBreakdownSales> get serializer => _$VendorEarningsBreakdownSalesSerializer();
}

class _$VendorEarningsBreakdownSalesSerializer implements PrimitiveSerializer<VendorEarningsBreakdownSales> {
  @override
  final Iterable<Type> types = const [VendorEarningsBreakdownSales, _$VendorEarningsBreakdownSales];

  @override
  final String wireName = r'VendorEarningsBreakdownSales';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorEarningsBreakdownSales object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(int),
    );
    yield r'materials_before_discount_centavos';
    yield serializers.serialize(
      object.materialsBeforeDiscountCentavos,
      specifiedType: const FullType(int),
    );
    yield r'vendor_discounts_centavos';
    yield serializers.serialize(
      object.vendorDiscountsCentavos,
      specifiedType: const FullType(int),
    );
    yield r'materials_after_discount_centavos';
    yield serializers.serialize(
      object.materialsAfterDiscountCentavos,
      specifiedType: const FullType(int),
    );
    yield r'delivery_centavos';
    yield serializers.serialize(
      object.deliveryCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorEarningsBreakdownSales object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorEarningsBreakdownSalesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.orders = valueDes;
          break;
        case r'materials_before_discount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.materialsBeforeDiscountCentavos = valueDes;
          break;
        case r'vendor_discounts_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vendorDiscountsCentavos = valueDes;
          break;
        case r'materials_after_discount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.materialsAfterDiscountCentavos = valueDes;
          break;
        case r'delivery_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.deliveryCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorEarningsBreakdownSales deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorEarningsBreakdownSalesBuilder();
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


