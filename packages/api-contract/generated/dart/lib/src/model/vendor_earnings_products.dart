//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/vendor_earnings_product.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_earnings_products.g.dart';

/// Sales value per product for the same orders and dates as commercial sales: each product's share of the latest snapshot's line amounts (after vendor discount, VAT included). Delivery belongs to no product, so the products plus delivery equal commercial sales. Largest value first, at most 50 products; total counts all of them.
///
/// Properties:
/// * [items]
/// * [total]
/// * [truncated]
@BuiltValue()
abstract class VendorEarningsProducts implements Built<VendorEarningsProducts, VendorEarningsProductsBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<VendorEarningsProduct> get items;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'truncated')
  bool get truncated;

  VendorEarningsProducts._();

  factory VendorEarningsProducts([void updates(VendorEarningsProductsBuilder b)]) = _$VendorEarningsProducts;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorEarningsProductsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorEarningsProducts> get serializer => _$VendorEarningsProductsSerializer();
}

class _$VendorEarningsProductsSerializer implements PrimitiveSerializer<VendorEarningsProducts> {
  @override
  final Iterable<Type> types = const [VendorEarningsProducts, _$VendorEarningsProducts];

  @override
  final String wireName = r'VendorEarningsProducts';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorEarningsProducts object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(VendorEarningsProduct)]),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'truncated';
    yield serializers.serialize(
      object.truncated,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorEarningsProducts object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorEarningsProductsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorEarningsProduct)]),
          ) as BuiltList<VendorEarningsProduct>;
          result.items.replace(valueDes);
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'truncated':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.truncated = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorEarningsProducts deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorEarningsProductsBuilder();
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


