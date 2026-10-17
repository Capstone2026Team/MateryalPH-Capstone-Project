//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'product_analytics_period.g.dart';

/// ProductAnalyticsPeriod
///
/// Properties:
/// * [days]
/// * [from]
/// * [to]
/// * [timezone]
@BuiltValue()
abstract class ProductAnalyticsPeriod implements Built<ProductAnalyticsPeriod, ProductAnalyticsPeriodBuilder> {
  @BuiltValueField(wireName: r'days')
  int get days;

  @BuiltValueField(wireName: r'from')
  Date get from;

  @BuiltValueField(wireName: r'to')
  Date get to;

  @BuiltValueField(wireName: r'timezone')
  String get timezone;

  ProductAnalyticsPeriod._();

  factory ProductAnalyticsPeriod([void updates(ProductAnalyticsPeriodBuilder b)]) = _$ProductAnalyticsPeriod;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProductAnalyticsPeriodBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProductAnalyticsPeriod> get serializer => _$ProductAnalyticsPeriodSerializer();
}

class _$ProductAnalyticsPeriodSerializer implements PrimitiveSerializer<ProductAnalyticsPeriod> {
  @override
  final Iterable<Type> types = const [ProductAnalyticsPeriod, _$ProductAnalyticsPeriod];

  @override
  final String wireName = r'ProductAnalyticsPeriod';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProductAnalyticsPeriod object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'days';
    yield serializers.serialize(
      object.days,
      specifiedType: const FullType(int),
    );
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(Date),
    );
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(Date),
    );
    yield r'timezone';
    yield serializers.serialize(
      object.timezone,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProductAnalyticsPeriod object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProductAnalyticsPeriodBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.days = valueDes;
          break;
        case r'from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.from = valueDes;
          break;
        case r'to':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.to = valueDes;
          break;
        case r'timezone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.timezone = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProductAnalyticsPeriod deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProductAnalyticsPeriodBuilder();
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


