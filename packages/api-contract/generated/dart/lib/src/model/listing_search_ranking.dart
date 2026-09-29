//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/ranking_weight_set.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'listing_search_ranking.g.dart';

/// ListingSearchRanking
///
/// Properties:
/// * [weights]
/// * [personalized]
/// * [defaultWeights]
/// * [tieBreakers]
@BuiltValue()
abstract class ListingSearchRanking implements Built<ListingSearchRanking, ListingSearchRankingBuilder> {
  @BuiltValueField(wireName: r'weights')
  RankingWeightSet get weights;

  @BuiltValueField(wireName: r'personalized')
  bool get personalized;

  @BuiltValueField(wireName: r'default_weights')
  RankingWeightSet get defaultWeights;

  @BuiltValueField(wireName: r'tie_breakers')
  BuiltList<String> get tieBreakers;

  ListingSearchRanking._();

  factory ListingSearchRanking([void updates(ListingSearchRankingBuilder b)]) = _$ListingSearchRanking;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListingSearchRankingBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListingSearchRanking> get serializer => _$ListingSearchRankingSerializer();
}

class _$ListingSearchRankingSerializer implements PrimitiveSerializer<ListingSearchRanking> {
  @override
  final Iterable<Type> types = const [ListingSearchRanking, _$ListingSearchRanking];

  @override
  final String wireName = r'ListingSearchRanking';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListingSearchRanking object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'weights';
    yield serializers.serialize(
      object.weights,
      specifiedType: const FullType(RankingWeightSet),
    );
    yield r'personalized';
    yield serializers.serialize(
      object.personalized,
      specifiedType: const FullType(bool),
    );
    yield r'default_weights';
    yield serializers.serialize(
      object.defaultWeights,
      specifiedType: const FullType(RankingWeightSet),
    );
    yield r'tie_breakers';
    yield serializers.serialize(
      object.tieBreakers,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ListingSearchRanking object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ListingSearchRankingBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'weights':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RankingWeightSet),
          ) as RankingWeightSet;
          result.weights.replace(valueDes);
          break;
        case r'personalized':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.personalized = valueDes;
          break;
        case r'default_weights':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RankingWeightSet),
          ) as RankingWeightSet;
          result.defaultWeights.replace(valueDes);
          break;
        case r'tie_breakers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.tieBreakers.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListingSearchRanking deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListingSearchRankingBuilder();
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


