//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'product_analytics_segments_points_inner.g.dart';

/// ProductAnalyticsSegmentsPointsInner
///
/// Properties:
/// * [listingId]
/// * [name]
/// * [views]
/// * [conversionPercent]
/// * [orders]
/// * [segment]
@BuiltValue()
abstract class ProductAnalyticsSegmentsPointsInner implements Built<ProductAnalyticsSegmentsPointsInner, ProductAnalyticsSegmentsPointsInnerBuilder> {
  @BuiltValueField(wireName: r'listing_id')
  String get listingId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'views')
  int get views;

  @BuiltValueField(wireName: r'conversion_percent')
  num get conversionPercent;

  @BuiltValueField(wireName: r'orders')
  int get orders;

  @BuiltValueField(wireName: r'segment')
  String get segment;

  ProductAnalyticsSegmentsPointsInner._();

  factory ProductAnalyticsSegmentsPointsInner([void updates(ProductAnalyticsSegmentsPointsInnerBuilder b)]) = _$ProductAnalyticsSegmentsPointsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProductAnalyticsSegmentsPointsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProductAnalyticsSegmentsPointsInner> get serializer => _$ProductAnalyticsSegmentsPointsInnerSerializer();
}

class _$ProductAnalyticsSegmentsPointsInnerSerializer implements PrimitiveSerializer<ProductAnalyticsSegmentsPointsInner> {
  @override
  final Iterable<Type> types = const [ProductAnalyticsSegmentsPointsInner, _$ProductAnalyticsSegmentsPointsInner];

  @override
  final String wireName = r'ProductAnalyticsSegmentsPointsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProductAnalyticsSegmentsPointsInner object, {
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
    yield r'views';
    yield serializers.serialize(
      object.views,
      specifiedType: const FullType(int),
    );
    yield r'conversion_percent';
    yield serializers.serialize(
      object.conversionPercent,
      specifiedType: const FullType(num),
    );
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(int),
    );
    yield r'segment';
    yield serializers.serialize(
      object.segment,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProductAnalyticsSegmentsPointsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProductAnalyticsSegmentsPointsInnerBuilder result,
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
        case r'views':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.views = valueDes;
          break;
        case r'conversion_percent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.conversionPercent = valueDes;
          break;
        case r'orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.orders = valueDes;
          break;
        case r'segment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.segment = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProductAnalyticsSegmentsPointsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProductAnalyticsSegmentsPointsInnerBuilder();
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


