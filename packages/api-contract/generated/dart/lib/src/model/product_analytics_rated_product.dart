//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'product_analytics_rated_product.g.dart';

/// One of the authenticated store's published products, using the existing all-time visible Product Quality average. Contains no reviewer identity.
///
/// Properties:
/// * [listingId]
/// * [name]
/// * [category]
/// * [average] - Existing two-decimal product average on the 1–5 scale. No Vendor MQS sample gate is applied to an individual product average.
/// * [count]
@BuiltValue()
abstract class ProductAnalyticsRatedProduct implements Built<ProductAnalyticsRatedProduct, ProductAnalyticsRatedProductBuilder> {
  @BuiltValueField(wireName: r'listing_id')
  String get listingId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'category')
  String get category;

  /// Existing two-decimal product average on the 1–5 scale. No Vendor MQS sample gate is applied to an individual product average.
  @BuiltValueField(wireName: r'average')
  String get average;

  @BuiltValueField(wireName: r'count')
  int get count;

  ProductAnalyticsRatedProduct._();

  factory ProductAnalyticsRatedProduct([void updates(ProductAnalyticsRatedProductBuilder b)]) = _$ProductAnalyticsRatedProduct;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProductAnalyticsRatedProductBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProductAnalyticsRatedProduct> get serializer => _$ProductAnalyticsRatedProductSerializer();
}

class _$ProductAnalyticsRatedProductSerializer implements PrimitiveSerializer<ProductAnalyticsRatedProduct> {
  @override
  final Iterable<Type> types = const [ProductAnalyticsRatedProduct, _$ProductAnalyticsRatedProduct];

  @override
  final String wireName = r'ProductAnalyticsRatedProduct';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProductAnalyticsRatedProduct object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'listing_id';
    yield serializers.serialize(
      object.listingId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(String),
    );
    yield r'average';
    yield serializers.serialize(
      object.average,
      specifiedType: const FullType(String),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProductAnalyticsRatedProduct object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProductAnalyticsRatedProductBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'listing_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.listingId = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.category = valueDes;
          break;
        case r'average':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.average = valueDes;
          break;
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProductAnalyticsRatedProduct deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProductAnalyticsRatedProductBuilder();
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


