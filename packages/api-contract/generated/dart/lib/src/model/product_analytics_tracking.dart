//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'product_analytics_tracking.g.dart';

/// The first Asia/Manila day a product view was recorded for this store; views before it were never collected.
///
/// Properties:
/// * [viewsSince]
@BuiltValue()
abstract class ProductAnalyticsTracking implements Built<ProductAnalyticsTracking, ProductAnalyticsTrackingBuilder> {
  @BuiltValueField(wireName: r'views_since')
  Date? get viewsSince;

  ProductAnalyticsTracking._();

  factory ProductAnalyticsTracking([void updates(ProductAnalyticsTrackingBuilder b)]) = _$ProductAnalyticsTracking;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProductAnalyticsTrackingBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProductAnalyticsTracking> get serializer => _$ProductAnalyticsTrackingSerializer();
}

class _$ProductAnalyticsTrackingSerializer implements PrimitiveSerializer<ProductAnalyticsTracking> {
  @override
  final Iterable<Type> types = const [ProductAnalyticsTracking, _$ProductAnalyticsTracking];

  @override
  final String wireName = r'ProductAnalyticsTracking';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProductAnalyticsTracking object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.viewsSince != null) {
      yield r'views_since';
      yield serializers.serialize(
        object.viewsSince,
        specifiedType: const FullType.nullable(Date),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProductAnalyticsTracking object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProductAnalyticsTrackingBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'views_since':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.viewsSince = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProductAnalyticsTracking deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProductAnalyticsTrackingBuilder();
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


