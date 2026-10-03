// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_search_sort.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ListingSearchSort _$BEST_DEAL = const ListingSearchSort._('BEST_DEAL');
const ListingSearchSort _$DISTANCE = const ListingSearchSort._('DISTANCE');
const ListingSearchSort _$PRICE = const ListingSearchSort._('PRICE');
const ListingSearchSort _$RATING = const ListingSearchSort._('RATING');
const ListingSearchSort _$FAVORITES_FIRST =
    const ListingSearchSort._('FAVORITES_FIRST');
const ListingSearchSort _$DISTANCE_DESC =
    const ListingSearchSort._('DISTANCE_DESC');
const ListingSearchSort _$PRICE_DESC = const ListingSearchSort._('PRICE_DESC');
const ListingSearchSort _$RATING_ASC = const ListingSearchSort._('RATING_ASC');

ListingSearchSort _$valueOf(String name) {
  switch (name) {
    case 'BEST_DEAL':
      return _$BEST_DEAL;
    case 'DISTANCE':
      return _$DISTANCE;
    case 'PRICE':
      return _$PRICE;
    case 'RATING':
      return _$RATING;
    case 'FAVORITES_FIRST':
      return _$FAVORITES_FIRST;
    case 'DISTANCE_DESC':
      return _$DISTANCE_DESC;
    case 'PRICE_DESC':
      return _$PRICE_DESC;
    case 'RATING_ASC':
      return _$RATING_ASC;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ListingSearchSort> _$values =
    BuiltSet<ListingSearchSort>(const <ListingSearchSort>[
  _$BEST_DEAL,
  _$DISTANCE,
  _$PRICE,
  _$RATING,
  _$FAVORITES_FIRST,
  _$DISTANCE_DESC,
  _$PRICE_DESC,
  _$RATING_ASC,
]);

class _$ListingSearchSortMeta {
  const _$ListingSearchSortMeta();
  ListingSearchSort get BEST_DEAL => _$BEST_DEAL;
  ListingSearchSort get DISTANCE => _$DISTANCE;
  ListingSearchSort get PRICE => _$PRICE;
  ListingSearchSort get RATING => _$RATING;
  ListingSearchSort get FAVORITES_FIRST => _$FAVORITES_FIRST;
  ListingSearchSort get DISTANCE_DESC => _$DISTANCE_DESC;
  ListingSearchSort get PRICE_DESC => _$PRICE_DESC;
  ListingSearchSort get RATING_ASC => _$RATING_ASC;
  ListingSearchSort valueOf(String name) => _$valueOf(name);
  BuiltSet<ListingSearchSort> get values => _$values;
}

abstract class _$ListingSearchSortMixin {
  // ignore: non_constant_identifier_names
  _$ListingSearchSortMeta get ListingSearchSort =>
      const _$ListingSearchSortMeta();
}

Serializer<ListingSearchSort> _$listingSearchSortSerializer =
    _$ListingSearchSortSerializer();

class _$ListingSearchSortSerializer
    implements PrimitiveSerializer<ListingSearchSort> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BEST_DEAL': 'BEST_DEAL',
    'DISTANCE': 'DISTANCE',
    'PRICE': 'PRICE',
    'RATING': 'RATING',
    'FAVORITES_FIRST': 'FAVORITES_FIRST',
    'DISTANCE_DESC': 'DISTANCE_DESC',
    'PRICE_DESC': 'PRICE_DESC',
    'RATING_ASC': 'RATING_ASC',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BEST_DEAL': 'BEST_DEAL',
    'DISTANCE': 'DISTANCE',
    'PRICE': 'PRICE',
    'RATING': 'RATING',
    'FAVORITES_FIRST': 'FAVORITES_FIRST',
    'DISTANCE_DESC': 'DISTANCE_DESC',
    'PRICE_DESC': 'PRICE_DESC',
    'RATING_ASC': 'RATING_ASC',
  };

  @override
  final Iterable<Type> types = const <Type>[ListingSearchSort];
  @override
  final String wireName = 'ListingSearchSort';

  @override
  Object serialize(Serializers serializers, ListingSearchSort object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ListingSearchSort deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ListingSearchSort.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
