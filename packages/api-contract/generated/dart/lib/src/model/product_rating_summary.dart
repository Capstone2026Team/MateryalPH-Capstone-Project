//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'product_rating_summary.g.dart';

/// ProductRatingSummary
///
/// Properties:
/// * [average] - Revealed Product Review average; null means New.
/// * [count]
/// * [label]
@BuiltValue()
abstract class ProductRatingSummary implements Built<ProductRatingSummary, ProductRatingSummaryBuilder> {
  /// Revealed Product Review average; null means New.
  @BuiltValueField(wireName: r'average')
  String? get average;

  @BuiltValueField(wireName: r'count')
  int get count;

  @BuiltValueField(wireName: r'label')
  String get label;

  ProductRatingSummary._();

  factory ProductRatingSummary([void updates(ProductRatingSummaryBuilder b)]) = _$ProductRatingSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProductRatingSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProductRatingSummary> get serializer => _$ProductRatingSummarySerializer();
}

class _$ProductRatingSummarySerializer implements PrimitiveSerializer<ProductRatingSummary> {
  @override
  final Iterable<Type> types = const [ProductRatingSummary, _$ProductRatingSummary];

  @override
  final String wireName = r'ProductRatingSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProductRatingSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'average';
    yield object.average == null ? null : serializers.serialize(
      object.average,
      specifiedType: const FullType.nullable(String),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProductRatingSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProductRatingSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'average':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.average = valueDes;
          break;
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProductRatingSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProductRatingSummaryBuilder();
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


