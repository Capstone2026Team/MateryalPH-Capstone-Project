//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/analytics_category_ref.dart';
import 'package:materyalph_api_client/src/model/buyer_analytics_product_row.dart';
import 'package:materyalph_api_client/src/model/analytics_unit.dart';
import 'package:materyalph_api_client/src/model/analytics_material_ref.dart';
import 'package:materyalph_api_client/src/model/analytics_price_range.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_analytics_product_detail_product.g.dart';

/// BuyerAnalyticsProductDetailProduct
///
/// Properties:
/// * [material]
/// * [category]
/// * [regulated] - True when the material is on the DTI-BPS mandatory PS/ICC list.
/// * [unit]
/// * [variantCount]
/// * [vendorCount] - Distinct Vendors with a current eligible offer of any variant.
/// * [price]
/// * [description]
@BuiltValue()
abstract class BuyerAnalyticsProductDetailProduct implements BuyerAnalyticsProductRow, Built<BuyerAnalyticsProductDetailProduct, BuyerAnalyticsProductDetailProductBuilder> {
  @BuiltValueField(wireName: r'description')
  String? get description;

  BuyerAnalyticsProductDetailProduct._();

  factory BuyerAnalyticsProductDetailProduct([void updates(BuyerAnalyticsProductDetailProductBuilder b)]) = _$BuyerAnalyticsProductDetailProduct;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerAnalyticsProductDetailProductBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerAnalyticsProductDetailProduct> get serializer => _$BuyerAnalyticsProductDetailProductSerializer();
}

class _$BuyerAnalyticsProductDetailProductSerializer implements PrimitiveSerializer<BuyerAnalyticsProductDetailProduct> {
  @override
  final Iterable<Type> types = const [BuyerAnalyticsProductDetailProduct, _$BuyerAnalyticsProductDetailProduct];

  @override
  final String wireName = r'BuyerAnalyticsProductDetailProduct';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerAnalyticsProductDetailProduct object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'unit';
    yield serializers.serialize(
      object.unit,
      specifiedType: const FullType(AnalyticsUnit),
    );
    yield r'material';
    yield serializers.serialize(
      object.material,
      specifiedType: const FullType(AnalyticsMaterialRef),
    );
    yield r'regulated';
    yield serializers.serialize(
      object.regulated,
      specifiedType: const FullType(bool),
    );
    yield r'vendor_count';
    yield serializers.serialize(
      object.vendorCount,
      specifiedType: const FullType(int),
    );
    yield r'price';
    yield serializers.serialize(
      object.price,
      specifiedType: const FullType(AnalyticsPriceRange),
    );
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(AnalyticsCategoryRef),
    );
    yield r'variant_count';
    yield serializers.serialize(
      object.variantCount,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerAnalyticsProductDetailProduct object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerAnalyticsProductDetailProductBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'unit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AnalyticsUnit),
          ) as AnalyticsUnit;
          result.unit.replace(valueDes);
          break;
        case r'material':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AnalyticsMaterialRef),
          ) as AnalyticsMaterialRef;
          result.material.replace(valueDes);
          break;
        case r'regulated':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.regulated = valueDes;
          break;
        case r'vendor_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vendorCount = valueDes;
          break;
        case r'price':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AnalyticsPriceRange),
          ) as AnalyticsPriceRange;
          result.price.replace(valueDes);
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AnalyticsCategoryRef),
          ) as AnalyticsCategoryRef;
          result.category.replace(valueDes);
          break;
        case r'variant_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.variantCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerAnalyticsProductDetailProduct deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerAnalyticsProductDetailProductBuilder();
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


