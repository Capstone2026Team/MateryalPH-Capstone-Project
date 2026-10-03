//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ranking_weight_set.g.dart';

/// Whole percentages for the five Item-Based SRS components; they total exactly 100.
///
/// Properties:
/// * [distance]
/// * [price]
/// * [vps]
/// * [stock]
/// * [productRating]
@BuiltValue()
abstract class RankingWeightSet implements Built<RankingWeightSet, RankingWeightSetBuilder> {
  @BuiltValueField(wireName: r'distance')
  int get distance;

  @BuiltValueField(wireName: r'price')
  int get price;

  @BuiltValueField(wireName: r'vps')
  int get vps;

  @BuiltValueField(wireName: r'stock')
  int get stock;

  @BuiltValueField(wireName: r'product_rating')
  int get productRating;

  RankingWeightSet._();

  factory RankingWeightSet([void updates(RankingWeightSetBuilder b)]) = _$RankingWeightSet;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RankingWeightSetBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RankingWeightSet> get serializer => _$RankingWeightSetSerializer();
}

class _$RankingWeightSetSerializer implements PrimitiveSerializer<RankingWeightSet> {
  @override
  final Iterable<Type> types = const [RankingWeightSet, _$RankingWeightSet];

  @override
  final String wireName = r'RankingWeightSet';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RankingWeightSet object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'distance';
    yield serializers.serialize(
      object.distance,
      specifiedType: const FullType(int),
    );
    yield r'price';
    yield serializers.serialize(
      object.price,
      specifiedType: const FullType(int),
    );
    yield r'vps';
    yield serializers.serialize(
      object.vps,
      specifiedType: const FullType(int),
    );
    yield r'stock';
    yield serializers.serialize(
      object.stock,
      specifiedType: const FullType(int),
    );
    yield r'product_rating';
    yield serializers.serialize(
      object.productRating,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RankingWeightSet object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RankingWeightSetBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'distance':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.distance = valueDes;
          break;
        case r'price':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.price = valueDes;
          break;
        case r'vps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vps = valueDes;
          break;
        case r'stock':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.stock = valueDes;
          break;
        case r'product_rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.productRating = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RankingWeightSet deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RankingWeightSetBuilder();
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


