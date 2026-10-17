//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'product_analytics_segments_segments_inner.g.dart';

/// ProductAnalyticsSegmentsSegmentsInner
///
/// Properties:
/// * [id]
/// * [label]
/// * [kind]
/// * [size]
/// * [averageViews]
/// * [averageConversionPercent]
/// * [averageOrders]
/// * [examples]
@BuiltValue()
abstract class ProductAnalyticsSegmentsSegmentsInner implements Built<ProductAnalyticsSegmentsSegmentsInner, ProductAnalyticsSegmentsSegmentsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'kind')
  ProductAnalyticsSegmentsSegmentsInnerKindEnum get kind;
  // enum kindEnum {  POPULAR_CONVERTING,  VIEWED_NOT_ORDERED,  CONVERTS_WHEN_FOUND,  LOW_VISIBILITY,  };

  @BuiltValueField(wireName: r'size')
  int get size;

  @BuiltValueField(wireName: r'average_views')
  num get averageViews;

  @BuiltValueField(wireName: r'average_conversion_percent')
  num get averageConversionPercent;

  @BuiltValueField(wireName: r'average_orders')
  num get averageOrders;

  @BuiltValueField(wireName: r'examples')
  BuiltList<String> get examples;

  ProductAnalyticsSegmentsSegmentsInner._();

  factory ProductAnalyticsSegmentsSegmentsInner([void updates(ProductAnalyticsSegmentsSegmentsInnerBuilder b)]) = _$ProductAnalyticsSegmentsSegmentsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProductAnalyticsSegmentsSegmentsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProductAnalyticsSegmentsSegmentsInner> get serializer => _$ProductAnalyticsSegmentsSegmentsInnerSerializer();
}

class _$ProductAnalyticsSegmentsSegmentsInnerSerializer implements PrimitiveSerializer<ProductAnalyticsSegmentsSegmentsInner> {
  @override
  final Iterable<Type> types = const [ProductAnalyticsSegmentsSegmentsInner, _$ProductAnalyticsSegmentsSegmentsInner];

  @override
  final String wireName = r'ProductAnalyticsSegmentsSegmentsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProductAnalyticsSegmentsSegmentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(ProductAnalyticsSegmentsSegmentsInnerKindEnum),
    );
    yield r'size';
    yield serializers.serialize(
      object.size,
      specifiedType: const FullType(int),
    );
    yield r'average_views';
    yield serializers.serialize(
      object.averageViews,
      specifiedType: const FullType(num),
    );
    yield r'average_conversion_percent';
    yield serializers.serialize(
      object.averageConversionPercent,
      specifiedType: const FullType(num),
    );
    yield r'average_orders';
    yield serializers.serialize(
      object.averageOrders,
      specifiedType: const FullType(num),
    );
    yield r'examples';
    yield serializers.serialize(
      object.examples,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProductAnalyticsSegmentsSegmentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProductAnalyticsSegmentsSegmentsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProductAnalyticsSegmentsSegmentsInnerKindEnum),
          ) as ProductAnalyticsSegmentsSegmentsInnerKindEnum;
          result.kind = valueDes;
          break;
        case r'size':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.size = valueDes;
          break;
        case r'average_views':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.averageViews = valueDes;
          break;
        case r'average_conversion_percent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.averageConversionPercent = valueDes;
          break;
        case r'average_orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.averageOrders = valueDes;
          break;
        case r'examples':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.examples.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProductAnalyticsSegmentsSegmentsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProductAnalyticsSegmentsSegmentsInnerBuilder();
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


class ProductAnalyticsSegmentsSegmentsInnerKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'POPULAR_CONVERTING')
  static const ProductAnalyticsSegmentsSegmentsInnerKindEnum POPULAR_CONVERTING = _$productAnalyticsSegmentsSegmentsInnerKindEnum_POPULAR_CONVERTING;
  @BuiltValueEnumConst(wireName: r'VIEWED_NOT_ORDERED')
  static const ProductAnalyticsSegmentsSegmentsInnerKindEnum VIEWED_NOT_ORDERED = _$productAnalyticsSegmentsSegmentsInnerKindEnum_VIEWED_NOT_ORDERED;
  @BuiltValueEnumConst(wireName: r'CONVERTS_WHEN_FOUND')
  static const ProductAnalyticsSegmentsSegmentsInnerKindEnum CONVERTS_WHEN_FOUND = _$productAnalyticsSegmentsSegmentsInnerKindEnum_CONVERTS_WHEN_FOUND;
  @BuiltValueEnumConst(wireName: r'LOW_VISIBILITY')
  static const ProductAnalyticsSegmentsSegmentsInnerKindEnum LOW_VISIBILITY = _$productAnalyticsSegmentsSegmentsInnerKindEnum_LOW_VISIBILITY;

  static Serializer<ProductAnalyticsSegmentsSegmentsInnerKindEnum> get serializer => _$productAnalyticsSegmentsSegmentsInnerKindEnumSerializer;

  const ProductAnalyticsSegmentsSegmentsInnerKindEnum._(String name): super(name);

  static BuiltSet<ProductAnalyticsSegmentsSegmentsInnerKindEnum> get values => _$productAnalyticsSegmentsSegmentsInnerKindEnumValues;
  static ProductAnalyticsSegmentsSegmentsInnerKindEnum valueOf(String name) => _$productAnalyticsSegmentsSegmentsInnerKindEnumValueOf(name);
}

