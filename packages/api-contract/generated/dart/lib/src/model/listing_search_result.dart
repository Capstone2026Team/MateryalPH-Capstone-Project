//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/listing_fulfillment_summary.dart';
import 'package:materyalph_api_client/src/model/comparable_status.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/listing_image.dart';
import 'package:materyalph_api_client/src/model/listing_vendor_card.dart';
import 'package:materyalph_api_client/src/model/ranking_explanation.dart';
import 'package:materyalph_api_client/src/model/product_rating_summary.dart';
import 'package:materyalph_api_client/src/model/listing_category_ref.dart';
import 'package:materyalph_api_client/src/model/listing_price.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'listing_search_result.g.dart';

/// ListingSearchResult
///
/// Properties:
/// * [listingId]
/// * [variantId] - The listing's best variant under the active sort.
/// * [rank]
/// * [displayName]
/// * [brand]
/// * [category]
/// * [variantLabel]
/// * [optionsCount]
/// * [image]
/// * [price]
/// * [comparable]
/// * [stockLabel]
/// * [stockConfirmedAt]
/// * [productRating]
/// * [unitsSold] - Quantity on completed orders.
/// * [distanceMeters] - Geodesic straight-line distance to the store.
/// * [badges]
/// * [isFavorite]
/// * [vendor]
/// * [fulfillment]
/// * [ranking]
@BuiltValue()
abstract class ListingSearchResult implements Built<ListingSearchResult, ListingSearchResultBuilder> {
  @BuiltValueField(wireName: r'listing_id')
  String get listingId;

  /// The listing's best variant under the active sort.
  @BuiltValueField(wireName: r'variant_id')
  String get variantId;

  @BuiltValueField(wireName: r'rank')
  int get rank;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'brand')
  String? get brand;

  @BuiltValueField(wireName: r'category')
  ListingCategoryRef? get category;

  @BuiltValueField(wireName: r'variant_label')
  String? get variantLabel;

  @BuiltValueField(wireName: r'options_count')
  int get optionsCount;

  @BuiltValueField(wireName: r'image')
  ListingImage? get image;

  @BuiltValueField(wireName: r'price')
  ListingPrice get price;

  @BuiltValueField(wireName: r'comparable')
  ComparableStatus get comparable;

  @BuiltValueField(wireName: r'stock_label')
  ListingSearchResultStockLabelEnum get stockLabel;
  // enum stockLabelEnum {  IN_STOCK,  LIMITED_STOCK,  };

  @BuiltValueField(wireName: r'stock_confirmed_at')
  DateTime get stockConfirmedAt;

  @BuiltValueField(wireName: r'product_rating')
  ProductRatingSummary get productRating;

  /// Quantity on completed orders.
  @BuiltValueField(wireName: r'units_sold')
  String get unitsSold;

  /// Geodesic straight-line distance to the store.
  @BuiltValueField(wireName: r'distance_meters')
  int get distanceMeters;

  @BuiltValueField(wireName: r'badges')
  BuiltList<ListingSearchResultBadgesEnum> get badges;
  // enum badgesEnum {  BEST_PRICE,  PS_ICC_VERIFIED,  };

  @BuiltValueField(wireName: r'is_favorite')
  bool get isFavorite;

  @BuiltValueField(wireName: r'vendor')
  ListingVendorCard get vendor;

  @BuiltValueField(wireName: r'fulfillment')
  ListingFulfillmentSummary get fulfillment;

  @BuiltValueField(wireName: r'ranking')
  RankingExplanation get ranking;

  ListingSearchResult._();

  factory ListingSearchResult([void updates(ListingSearchResultBuilder b)]) = _$ListingSearchResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListingSearchResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListingSearchResult> get serializer => _$ListingSearchResultSerializer();
}

class _$ListingSearchResultSerializer implements PrimitiveSerializer<ListingSearchResult> {
  @override
  final Iterable<Type> types = const [ListingSearchResult, _$ListingSearchResult];

  @override
  final String wireName = r'ListingSearchResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListingSearchResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'listing_id';
    yield serializers.serialize(
      object.listingId,
      specifiedType: const FullType(String),
    );
    yield r'variant_id';
    yield serializers.serialize(
      object.variantId,
      specifiedType: const FullType(String),
    );
    yield r'rank';
    yield serializers.serialize(
      object.rank,
      specifiedType: const FullType(int),
    );
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'brand';
    yield object.brand == null ? null : serializers.serialize(
      object.brand,
      specifiedType: const FullType.nullable(String),
    );
    yield r'category';
    yield object.category == null ? null : serializers.serialize(
      object.category,
      specifiedType: const FullType.nullable(ListingCategoryRef),
    );
    yield r'variant_label';
    yield object.variantLabel == null ? null : serializers.serialize(
      object.variantLabel,
      specifiedType: const FullType.nullable(String),
    );
    yield r'options_count';
    yield serializers.serialize(
      object.optionsCount,
      specifiedType: const FullType(int),
    );
    yield r'image';
    yield object.image == null ? null : serializers.serialize(
      object.image,
      specifiedType: const FullType.nullable(ListingImage),
    );
    yield r'price';
    yield serializers.serialize(
      object.price,
      specifiedType: const FullType(ListingPrice),
    );
    yield r'comparable';
    yield serializers.serialize(
      object.comparable,
      specifiedType: const FullType(ComparableStatus),
    );
    yield r'stock_label';
    yield serializers.serialize(
      object.stockLabel,
      specifiedType: const FullType(ListingSearchResultStockLabelEnum),
    );
    yield r'stock_confirmed_at';
    yield serializers.serialize(
      object.stockConfirmedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'product_rating';
    yield serializers.serialize(
      object.productRating,
      specifiedType: const FullType(ProductRatingSummary),
    );
    yield r'units_sold';
    yield serializers.serialize(
      object.unitsSold,
      specifiedType: const FullType(String),
    );
    yield r'distance_meters';
    yield serializers.serialize(
      object.distanceMeters,
      specifiedType: const FullType(int),
    );
    yield r'badges';
    yield serializers.serialize(
      object.badges,
      specifiedType: const FullType(BuiltList, [FullType(ListingSearchResultBadgesEnum)]),
    );
    yield r'is_favorite';
    yield serializers.serialize(
      object.isFavorite,
      specifiedType: const FullType(bool),
    );
    yield r'vendor';
    yield serializers.serialize(
      object.vendor,
      specifiedType: const FullType(ListingVendorCard),
    );
    yield r'fulfillment';
    yield serializers.serialize(
      object.fulfillment,
      specifiedType: const FullType(ListingFulfillmentSummary),
    );
    yield r'ranking';
    yield serializers.serialize(
      object.ranking,
      specifiedType: const FullType(RankingExplanation),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ListingSearchResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ListingSearchResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'listing_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.listingId = valueDes;
          break;
        case r'variant_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.variantId = valueDes;
          break;
        case r'rank':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.rank = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'brand':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.brand = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ListingCategoryRef),
          ) as ListingCategoryRef?;
          if (valueDes == null) continue;
          result.category.replace(valueDes);
          break;
        case r'variant_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.variantLabel = valueDes;
          break;
        case r'options_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.optionsCount = valueDes;
          break;
        case r'image':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ListingImage),
          ) as ListingImage?;
          if (valueDes == null) continue;
          result.image.replace(valueDes);
          break;
        case r'price':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListingPrice),
          ) as ListingPrice;
          result.price.replace(valueDes);
          break;
        case r'comparable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ComparableStatus),
          ) as ComparableStatus;
          result.comparable.replace(valueDes);
          break;
        case r'stock_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListingSearchResultStockLabelEnum),
          ) as ListingSearchResultStockLabelEnum;
          result.stockLabel = valueDes;
          break;
        case r'stock_confirmed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.stockConfirmedAt = valueDes;
          break;
        case r'product_rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProductRatingSummary),
          ) as ProductRatingSummary;
          result.productRating.replace(valueDes);
          break;
        case r'units_sold':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unitsSold = valueDes;
          break;
        case r'distance_meters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.distanceMeters = valueDes;
          break;
        case r'badges':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ListingSearchResultBadgesEnum)]),
          ) as BuiltList<ListingSearchResultBadgesEnum>;
          result.badges.replace(valueDes);
          break;
        case r'is_favorite':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isFavorite = valueDes;
          break;
        case r'vendor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListingVendorCard),
          ) as ListingVendorCard;
          result.vendor.replace(valueDes);
          break;
        case r'fulfillment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ListingFulfillmentSummary),
          ) as ListingFulfillmentSummary;
          result.fulfillment.replace(valueDes);
          break;
        case r'ranking':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RankingExplanation),
          ) as RankingExplanation;
          result.ranking.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListingSearchResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListingSearchResultBuilder();
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


class ListingSearchResultStockLabelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'IN_STOCK')
  static const ListingSearchResultStockLabelEnum IN_STOCK = _$listingSearchResultStockLabelEnum_IN_STOCK;
  @BuiltValueEnumConst(wireName: r'LIMITED_STOCK')
  static const ListingSearchResultStockLabelEnum LIMITED_STOCK = _$listingSearchResultStockLabelEnum_LIMITED_STOCK;

  static Serializer<ListingSearchResultStockLabelEnum> get serializer => _$listingSearchResultStockLabelEnumSerializer;

  const ListingSearchResultStockLabelEnum._(String name): super(name);

  static BuiltSet<ListingSearchResultStockLabelEnum> get values => _$listingSearchResultStockLabelEnumValues;
  static ListingSearchResultStockLabelEnum valueOf(String name) => _$listingSearchResultStockLabelEnumValueOf(name);
}

class ListingSearchResultBadgesEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BEST_PRICE')
  static const ListingSearchResultBadgesEnum BEST_PRICE = _$listingSearchResultBadgesEnum_BEST_PRICE;
  @BuiltValueEnumConst(wireName: r'PS_ICC_VERIFIED')
  static const ListingSearchResultBadgesEnum PS_ICC_VERIFIED = _$listingSearchResultBadgesEnum_PS_ICC_VERIFIED;

  static Serializer<ListingSearchResultBadgesEnum> get serializer => _$listingSearchResultBadgesEnumSerializer;

  const ListingSearchResultBadgesEnum._(String name): super(name);

  static BuiltSet<ListingSearchResultBadgesEnum> get values => _$listingSearchResultBadgesEnumValues;
  static ListingSearchResultBadgesEnum valueOf(String name) => _$listingSearchResultBadgesEnumValueOf(name);
}

