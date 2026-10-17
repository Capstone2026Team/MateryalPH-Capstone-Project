//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'product_analytics_series_point.g.dart';

/// ProductAnalyticsSeriesPoint
///
/// Properties:
/// * [date]
/// * [views]
/// * [orders]
/// * [valueCentavos]
@BuiltValue()
abstract class ProductAnalyticsSeriesPoint implements Built<ProductAnalyticsSeriesPoint, ProductAnalyticsSeriesPointBuilder> {
  @BuiltValueField(wireName: r'date')
  Date get date;

  @BuiltValueField(wireName: r'views')
  int get views;

  @BuiltValueField(wireName: r'orders')
  int get orders;

  @BuiltValueField(wireName: r'value_centavos')
  int? get valueCentavos;

  ProductAnalyticsSeriesPoint._();

  factory ProductAnalyticsSeriesPoint([void updates(ProductAnalyticsSeriesPointBuilder b)]) = _$ProductAnalyticsSeriesPoint;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProductAnalyticsSeriesPointBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProductAnalyticsSeriesPoint> get serializer => _$ProductAnalyticsSeriesPointSerializer();
}

class _$ProductAnalyticsSeriesPointSerializer implements PrimitiveSerializer<ProductAnalyticsSeriesPoint> {
  @override
  final Iterable<Type> types = const [ProductAnalyticsSeriesPoint, _$ProductAnalyticsSeriesPoint];

  @override
  final String wireName = r'ProductAnalyticsSeriesPoint';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProductAnalyticsSeriesPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(Date),
    );
    yield r'views';
    yield serializers.serialize(
      object.views,
      specifiedType: const FullType(int),
    );
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(int),
    );
    if (object.valueCentavos != null) {
      yield r'value_centavos';
      yield serializers.serialize(
        object.valueCentavos,
        specifiedType: const FullType.nullable(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProductAnalyticsSeriesPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProductAnalyticsSeriesPointBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.date = valueDes;
          break;
        case r'views':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.views = valueDes;
          break;
        case r'orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.orders = valueDes;
          break;
        case r'value_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.valueCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProductAnalyticsSeriesPoint deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProductAnalyticsSeriesPointBuilder();
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


