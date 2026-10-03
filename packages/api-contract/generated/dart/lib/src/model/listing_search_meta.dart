//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/listing_search_sort.dart';
import 'package:materyalph_api_client/src/model/discovery_scope.dart';
import 'package:materyalph_api_client/src/model/listing_search_query.dart';
import 'package:materyalph_api_client/src/model/listing_search_ranking.dart';
import 'package:materyalph_api_client/src/model/listing_search_expansion.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'listing_search_meta.g.dart';

/// ListingSearchMeta
///
/// Properties:
/// * [correlationId]
/// * [scope]
/// * [currentAsOf]
/// * [eligibilityVersion]
/// * [algorithmVersion]
/// * [sort]
/// * [defaultSort]
/// * [query]
/// * [ranking]
/// * [total]
/// * [perPage]
/// * [hasMore]
/// * [nextCursor]
/// * [candidateLimitReached]
/// * [expansion]
/// * [tierNote]
@BuiltValue()
abstract class ListingSearchMeta implements Built<ListingSearchMeta, ListingSearchMetaBuilder> {
  @BuiltValueField(wireName: r'correlation_id')
  String? get correlationId;

  @BuiltValueField(wireName: r'scope')
  DiscoveryScope get scope;

  @BuiltValueField(wireName: r'current_as_of')
  DateTime get currentAsOf;

  @BuiltValueField(wireName: r'eligibility_version')
  String get eligibilityVersion;

  @BuiltValueField(wireName: r'algorithm_version')
  String get algorithmVersion;

  @BuiltValueField(wireName: r'sort')
  ListingSearchSort get sort;
  // enum sortEnum {  BEST_DEAL,  DISTANCE,  PRICE,  RATING,  FAVORITES_FIRST,  DISTANCE_DESC,  PRICE_DESC,  RATING_ASC,  };

  @BuiltValueField(wireName: r'default_sort')
  ListingSearchSort get defaultSort;
  // enum defaultSortEnum {  BEST_DEAL,  DISTANCE,  PRICE,  RATING,  FAVORITES_FIRST,  DISTANCE_DESC,  PRICE_DESC,  RATING_ASC,  };

  @BuiltValueField(wireName: r'query')
  ListingSearchQuery get query;

  @BuiltValueField(wireName: r'ranking')
  ListingSearchRanking get ranking;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'per_page')
  int get perPage;

  @BuiltValueField(wireName: r'has_more')
  bool get hasMore;

  @BuiltValueField(wireName: r'next_cursor')
  String? get nextCursor;

  @BuiltValueField(wireName: r'candidate_limit_reached')
  bool get candidateLimitReached;

  @BuiltValueField(wireName: r'expansion')
  ListingSearchExpansion? get expansion;

  @BuiltValueField(wireName: r'tier_note')
  String get tierNote;

  ListingSearchMeta._();

  factory ListingSearchMeta([void updates(ListingSearchMetaBuilder b)]) = _$ListingSearchMeta;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListingSearchMetaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListingSearchMeta> get serializer => _$ListingSearchMetaSerializer();
}

class _$ListingSearchMetaSerializer implements PrimitiveSerializer<ListingSearchMeta> {
  @override
  final Iterable<Type> types = const [ListingSearchMeta, _$ListingSearchMeta];

  @override
  final String wireName = r'ListingSearchMeta';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListingSearchMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.correlationId != null) {
      yield r'correlation_id';
      yield serializers.serialize(
        object.correlationId,
        specifiedType: const FullType(String),
      );
    }
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(DiscoveryScope),
    );
    yield r'current_as_of';
    yield serializers.serialize(
      object.currentAsOf,
      specifiedType: const FullType(DateTime),
    );
    yield r'eligibility_version';
    yield serializers.serialize(
      object.eligibilityVersion,
      specifiedType: const FullType(String),
    );
    yield r'algorithm_version';
    yield serializers.serialize(
      object.algorithmVersion,
      specifiedType: const FullType(String),
    );
    yield r'sort';
    yield serializers.serialize(
      object.sort,
      specifiedType: const FullType(ListingSearchSort),
    );
    yield r'default_sort';
    yield serializers.serialize(
      object.defaultSort,
      specifiedType: const FullType(ListingSearchSort),
    );
    yield r'query';
    yield serializers.serialize(
      object.query,
      specifiedType: const FullType(ListingSearchQuery),
    );
    yield r'ranking';
    yield serializers.serialize(
      object.ranking,
      specifiedType: const FullType(ListingSearchRanking),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'per_page';
    yield serializers.serialize(
      object.perPage,
      specifiedType: const FullType(int),
    );
    yield r'has_more';
    yield serializers.serialize(
      object.hasMore,
      specifiedType: const FullType(bool),
    );
    yield r'next_cursor';
    yield object.nextCursor == null ? null : serializers.serialize(
      object.nextCursor,
      specifiedType: const FullType.nullable(String),
    );
    yield r'candidate_limit_reached';
    yield serializers.serialize(
      object.candidateLimitReached,
      specifiedType: const FullType(bool),
    );
    yield r'expansion';
    yield object.expansion == null ? null : serializers.serialize(
      object.expansion,
      specifiedType: const FullType.nullable(ListingSearchExpansion),
    );
    yield r'tier_note';
    yield serializers.serialize(
      object.tierNote,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ListingSearchMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ListingSearchMetaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'correlation_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.correlationId = valueDes;
          break;
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DiscoveryScope),
          ) as DiscoveryScope;
          result.scope.replace(valueDes);
          break;
        case r'current_as_of':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.currentAsOf = valueDes;
          break;
        case r'eligibility_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.eligibilityVersion = valueDes;
          break;
        case r'algorithm_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.algorithmVersion = valueDes;
          break;
        case r'sort':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListingSearchSort),
          ) as ListingSearchSort;
          result.sort = valueDes;
          break;
        case r'default_sort':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListingSearchSort),
          ) as ListingSearchSort;
          result.defaultSort = valueDes;
          break;
        case r'query':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListingSearchQuery),
          ) as ListingSearchQuery;
          result.query.replace(valueDes);
          break;
        case r'ranking':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListingSearchRanking),
          ) as ListingSearchRanking;
          result.ranking.replace(valueDes);
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'per_page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.perPage = valueDes;
          break;
        case r'has_more':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasMore = valueDes;
          break;
        case r'next_cursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nextCursor = valueDes;
          break;
        case r'candidate_limit_reached':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.candidateLimitReached = valueDes;
          break;
        case r'expansion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ListingSearchExpansion),
          ) as ListingSearchExpansion?;
          if (valueDes == null) continue;
          result.expansion.replace(valueDes);
          break;
        case r'tier_note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tierNote = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListingSearchMeta deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListingSearchMetaBuilder();
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


