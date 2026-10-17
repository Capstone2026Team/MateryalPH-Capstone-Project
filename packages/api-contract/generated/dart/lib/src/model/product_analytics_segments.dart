//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/product_analytics_segments_segments_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/product_analytics_segments_points_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'product_analytics_segments.g.dart';

/// K-Means groups over product views, conversion % and orders; names compare each centre with the store average.
///
/// Properties:
/// * [state]
/// * [reason]
/// * [k]
/// * [silhouette]
/// * [features]
/// * [segments]
/// * [points]
/// * [meanConversionPercent]
@BuiltValue()
abstract class ProductAnalyticsSegments implements Built<ProductAnalyticsSegments, ProductAnalyticsSegmentsBuilder> {
  @BuiltValueField(wireName: r'state')
  ProductAnalyticsSegmentsStateEnum get state;
  // enum stateEnum {  OK,  INSUFFICIENT_DATA,  };

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'k')
  int? get k;

  @BuiltValueField(wireName: r'silhouette')
  num? get silhouette;

  @BuiltValueField(wireName: r'features')
  BuiltList<String> get features;

  @BuiltValueField(wireName: r'segments')
  BuiltList<ProductAnalyticsSegmentsSegmentsInner> get segments;

  @BuiltValueField(wireName: r'points')
  BuiltList<ProductAnalyticsSegmentsPointsInner> get points;

  @BuiltValueField(wireName: r'mean_conversion_percent')
  num? get meanConversionPercent;

  ProductAnalyticsSegments._();

  factory ProductAnalyticsSegments([void updates(ProductAnalyticsSegmentsBuilder b)]) = _$ProductAnalyticsSegments;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProductAnalyticsSegmentsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProductAnalyticsSegments> get serializer => _$ProductAnalyticsSegmentsSerializer();
}

class _$ProductAnalyticsSegmentsSerializer implements PrimitiveSerializer<ProductAnalyticsSegments> {
  @override
  final Iterable<Type> types = const [ProductAnalyticsSegments, _$ProductAnalyticsSegments];

  @override
  final String wireName = r'ProductAnalyticsSegments';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProductAnalyticsSegments object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(ProductAnalyticsSegmentsStateEnum),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.k != null) {
      yield r'k';
      yield serializers.serialize(
        object.k,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.silhouette != null) {
      yield r'silhouette';
      yield serializers.serialize(
        object.silhouette,
        specifiedType: const FullType.nullable(num),
      );
    }
    yield r'features';
    yield serializers.serialize(
      object.features,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'segments';
    yield serializers.serialize(
      object.segments,
      specifiedType: const FullType(BuiltList, [FullType(ProductAnalyticsSegmentsSegmentsInner)]),
    );
    yield r'points';
    yield serializers.serialize(
      object.points,
      specifiedType: const FullType(BuiltList, [FullType(ProductAnalyticsSegmentsPointsInner)]),
    );
    if (object.meanConversionPercent != null) {
      yield r'mean_conversion_percent';
      yield serializers.serialize(
        object.meanConversionPercent,
        specifiedType: const FullType.nullable(num),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProductAnalyticsSegments object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProductAnalyticsSegmentsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProductAnalyticsSegmentsStateEnum),
          ) as ProductAnalyticsSegmentsStateEnum;
          result.state = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'k':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.k = valueDes;
          break;
        case r'silhouette':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.silhouette = valueDes;
          break;
        case r'features':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.features.replace(valueDes);
          break;
        case r'segments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProductAnalyticsSegmentsSegmentsInner)]),
          ) as BuiltList<ProductAnalyticsSegmentsSegmentsInner>;
          result.segments.replace(valueDes);
          break;
        case r'points':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProductAnalyticsSegmentsPointsInner)]),
          ) as BuiltList<ProductAnalyticsSegmentsPointsInner>;
          result.points.replace(valueDes);
          break;
        case r'mean_conversion_percent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.meanConversionPercent = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProductAnalyticsSegments deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProductAnalyticsSegmentsBuilder();
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


class ProductAnalyticsSegmentsStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OK')
  static const ProductAnalyticsSegmentsStateEnum OK = _$productAnalyticsSegmentsStateEnum_OK;
  @BuiltValueEnumConst(wireName: r'INSUFFICIENT_DATA')
  static const ProductAnalyticsSegmentsStateEnum INSUFFICIENT_DATA = _$productAnalyticsSegmentsStateEnum_INSUFFICIENT_DATA;

  static Serializer<ProductAnalyticsSegmentsStateEnum> get serializer => _$productAnalyticsSegmentsStateEnumSerializer;

  const ProductAnalyticsSegmentsStateEnum._(String name): super(name);

  static BuiltSet<ProductAnalyticsSegmentsStateEnum> get values => _$productAnalyticsSegmentsStateEnumValues;
  static ProductAnalyticsSegmentsStateEnum valueOf(String name) => _$productAnalyticsSegmentsStateEnumValueOf(name);
}

