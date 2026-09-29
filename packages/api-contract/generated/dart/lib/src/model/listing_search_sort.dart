//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'listing_search_sort.g.dart';

class ListingSearchSort extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BEST_DEAL')
  static const ListingSearchSort BEST_DEAL = _$BEST_DEAL;
  @BuiltValueEnumConst(wireName: r'DISTANCE')
  static const ListingSearchSort DISTANCE = _$DISTANCE;
  @BuiltValueEnumConst(wireName: r'PRICE')
  static const ListingSearchSort PRICE = _$PRICE;
  @BuiltValueEnumConst(wireName: r'RATING')
  static const ListingSearchSort RATING = _$RATING;
  @BuiltValueEnumConst(wireName: r'FAVORITES_FIRST')
  static const ListingSearchSort FAVORITES_FIRST = _$FAVORITES_FIRST;
  @BuiltValueEnumConst(wireName: r'DISTANCE_DESC')
  static const ListingSearchSort DISTANCE_DESC = _$DISTANCE_DESC;
  @BuiltValueEnumConst(wireName: r'PRICE_DESC')
  static const ListingSearchSort PRICE_DESC = _$PRICE_DESC;
  @BuiltValueEnumConst(wireName: r'RATING_ASC')
  static const ListingSearchSort RATING_ASC = _$RATING_ASC;

  static Serializer<ListingSearchSort> get serializer => _$listingSearchSortSerializer;

  const ListingSearchSort._(String name): super(name);

  static BuiltSet<ListingSearchSort> get values => _$values;
  static ListingSearchSort valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class ListingSearchSortMixin = Object with _$ListingSearchSortMixin;

