// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_search_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ListingSearchResultStockLabelEnum
    _$listingSearchResultStockLabelEnum_IN_STOCK =
    const ListingSearchResultStockLabelEnum._('IN_STOCK');
const ListingSearchResultStockLabelEnum
    _$listingSearchResultStockLabelEnum_LIMITED_STOCK =
    const ListingSearchResultStockLabelEnum._('LIMITED_STOCK');

ListingSearchResultStockLabelEnum _$listingSearchResultStockLabelEnumValueOf(
    String name) {
  switch (name) {
    case 'IN_STOCK':
      return _$listingSearchResultStockLabelEnum_IN_STOCK;
    case 'LIMITED_STOCK':
      return _$listingSearchResultStockLabelEnum_LIMITED_STOCK;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ListingSearchResultStockLabelEnum>
    _$listingSearchResultStockLabelEnumValues = BuiltSet<
        ListingSearchResultStockLabelEnum>(const <ListingSearchResultStockLabelEnum>[
  _$listingSearchResultStockLabelEnum_IN_STOCK,
  _$listingSearchResultStockLabelEnum_LIMITED_STOCK,
]);

const ListingSearchResultBadgesEnum _$listingSearchResultBadgesEnum_BEST_PRICE =
    const ListingSearchResultBadgesEnum._('BEST_PRICE');
const ListingSearchResultBadgesEnum
    _$listingSearchResultBadgesEnum_PS_ICC_VERIFIED =
    const ListingSearchResultBadgesEnum._('PS_ICC_VERIFIED');

ListingSearchResultBadgesEnum _$listingSearchResultBadgesEnumValueOf(
    String name) {
  switch (name) {
    case 'BEST_PRICE':
      return _$listingSearchResultBadgesEnum_BEST_PRICE;
    case 'PS_ICC_VERIFIED':
      return _$listingSearchResultBadgesEnum_PS_ICC_VERIFIED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ListingSearchResultBadgesEnum>
    _$listingSearchResultBadgesEnumValues = BuiltSet<
        ListingSearchResultBadgesEnum>(const <ListingSearchResultBadgesEnum>[
  _$listingSearchResultBadgesEnum_BEST_PRICE,
  _$listingSearchResultBadgesEnum_PS_ICC_VERIFIED,
]);

Serializer<ListingSearchResultStockLabelEnum>
    _$listingSearchResultStockLabelEnumSerializer =
    _$ListingSearchResultStockLabelEnumSerializer();
Serializer<ListingSearchResultBadgesEnum>
    _$listingSearchResultBadgesEnumSerializer =
    _$ListingSearchResultBadgesEnumSerializer();

class _$ListingSearchResultStockLabelEnumSerializer
    implements PrimitiveSerializer<ListingSearchResultStockLabelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'IN_STOCK': 'IN_STOCK',
    'LIMITED_STOCK': 'LIMITED_STOCK',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'IN_STOCK': 'IN_STOCK',
    'LIMITED_STOCK': 'LIMITED_STOCK',
  };

  @override
  final Iterable<Type> types = const <Type>[ListingSearchResultStockLabelEnum];
  @override
  final String wireName = 'ListingSearchResultStockLabelEnum';

  @override
  Object serialize(
          Serializers serializers, ListingSearchResultStockLabelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ListingSearchResultStockLabelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ListingSearchResultStockLabelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ListingSearchResultBadgesEnumSerializer
    implements PrimitiveSerializer<ListingSearchResultBadgesEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BEST_PRICE': 'BEST_PRICE',
    'PS_ICC_VERIFIED': 'PS_ICC_VERIFIED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BEST_PRICE': 'BEST_PRICE',
    'PS_ICC_VERIFIED': 'PS_ICC_VERIFIED',
  };

  @override
  final Iterable<Type> types = const <Type>[ListingSearchResultBadgesEnum];
  @override
  final String wireName = 'ListingSearchResultBadgesEnum';

  @override
  Object serialize(
          Serializers serializers, ListingSearchResultBadgesEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ListingSearchResultBadgesEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ListingSearchResultBadgesEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ListingSearchResult extends ListingSearchResult {
  @override
  final String listingId;
  @override
  final String variantId;
  @override
  final int rank;
  @override
  final String displayName;
  @override
  final String? brand;
  @override
  final ListingCategoryRef? category;
  @override
  final String? variantLabel;
  @override
  final int optionsCount;
  @override
  final ListingImage? image;
  @override
  final ListingPrice price;
  @override
  final ComparableStatus comparable;
  @override
  final ListingSearchResultStockLabelEnum stockLabel;
  @override
  final DateTime stockConfirmedAt;
  @override
  final ProductRatingSummary productRating;
  @override
  final String unitsSold;
  @override
  final int distanceMeters;
  @override
  final BuiltList<ListingSearchResultBadgesEnum> badges;
  @override
  final bool isFavorite;
  @override
  final ListingVendorCard vendor;
  @override
  final ListingFulfillmentSummary fulfillment;
  @override
  final RankingExplanation ranking;

  factory _$ListingSearchResult(
          [void Function(ListingSearchResultBuilder)? updates]) =>
      (ListingSearchResultBuilder()..update(updates))._build();

  _$ListingSearchResult._(
      {required this.listingId,
      required this.variantId,
      required this.rank,
      required this.displayName,
      this.brand,
      this.category,
      this.variantLabel,
      required this.optionsCount,
      this.image,
      required this.price,
      required this.comparable,
      required this.stockLabel,
      required this.stockConfirmedAt,
      required this.productRating,
      required this.unitsSold,
      required this.distanceMeters,
      required this.badges,
      required this.isFavorite,
      required this.vendor,
      required this.fulfillment,
      required this.ranking})
      : super._();
  @override
  ListingSearchResult rebuild(
          void Function(ListingSearchResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListingSearchResultBuilder toBuilder() =>
      ListingSearchResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListingSearchResult &&
        listingId == other.listingId &&
        variantId == other.variantId &&
        rank == other.rank &&
        displayName == other.displayName &&
        brand == other.brand &&
        category == other.category &&
        variantLabel == other.variantLabel &&
        optionsCount == other.optionsCount &&
        image == other.image &&
        price == other.price &&
        comparable == other.comparable &&
        stockLabel == other.stockLabel &&
        stockConfirmedAt == other.stockConfirmedAt &&
        productRating == other.productRating &&
        unitsSold == other.unitsSold &&
        distanceMeters == other.distanceMeters &&
        badges == other.badges &&
        isFavorite == other.isFavorite &&
        vendor == other.vendor &&
        fulfillment == other.fulfillment &&
        ranking == other.ranking;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, listingId.hashCode);
    _$hash = $jc(_$hash, variantId.hashCode);
    _$hash = $jc(_$hash, rank.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, brand.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, variantLabel.hashCode);
    _$hash = $jc(_$hash, optionsCount.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jc(_$hash, comparable.hashCode);
    _$hash = $jc(_$hash, stockLabel.hashCode);
    _$hash = $jc(_$hash, stockConfirmedAt.hashCode);
    _$hash = $jc(_$hash, productRating.hashCode);
    _$hash = $jc(_$hash, unitsSold.hashCode);
    _$hash = $jc(_$hash, distanceMeters.hashCode);
    _$hash = $jc(_$hash, badges.hashCode);
    _$hash = $jc(_$hash, isFavorite.hashCode);
    _$hash = $jc(_$hash, vendor.hashCode);
    _$hash = $jc(_$hash, fulfillment.hashCode);
    _$hash = $jc(_$hash, ranking.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListingSearchResult')
          ..add('listingId', listingId)
          ..add('variantId', variantId)
          ..add('rank', rank)
          ..add('displayName', displayName)
          ..add('brand', brand)
          ..add('category', category)
          ..add('variantLabel', variantLabel)
          ..add('optionsCount', optionsCount)
          ..add('image', image)
          ..add('price', price)
          ..add('comparable', comparable)
          ..add('stockLabel', stockLabel)
          ..add('stockConfirmedAt', stockConfirmedAt)
          ..add('productRating', productRating)
          ..add('unitsSold', unitsSold)
          ..add('distanceMeters', distanceMeters)
          ..add('badges', badges)
          ..add('isFavorite', isFavorite)
          ..add('vendor', vendor)
          ..add('fulfillment', fulfillment)
          ..add('ranking', ranking))
        .toString();
  }
}

class ListingSearchResultBuilder
    implements Builder<ListingSearchResult, ListingSearchResultBuilder> {
  _$ListingSearchResult? _$v;

  String? _listingId;
  String? get listingId => _$this._listingId;
  set listingId(String? listingId) => _$this._listingId = listingId;

  String? _variantId;
  String? get variantId => _$this._variantId;
  set variantId(String? variantId) => _$this._variantId = variantId;

  int? _rank;
  int? get rank => _$this._rank;
  set rank(int? rank) => _$this._rank = rank;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _brand;
  String? get brand => _$this._brand;
  set brand(String? brand) => _$this._brand = brand;

  ListingCategoryRefBuilder? _category;
  ListingCategoryRefBuilder get category =>
      _$this._category ??= ListingCategoryRefBuilder();
  set category(ListingCategoryRefBuilder? category) =>
      _$this._category = category;

  String? _variantLabel;
  String? get variantLabel => _$this._variantLabel;
  set variantLabel(String? variantLabel) => _$this._variantLabel = variantLabel;

  int? _optionsCount;
  int? get optionsCount => _$this._optionsCount;
  set optionsCount(int? optionsCount) => _$this._optionsCount = optionsCount;

  ListingImageBuilder? _image;
  ListingImageBuilder get image => _$this._image ??= ListingImageBuilder();
  set image(ListingImageBuilder? image) => _$this._image = image;

  ListingPriceBuilder? _price;
  ListingPriceBuilder get price => _$this._price ??= ListingPriceBuilder();
  set price(ListingPriceBuilder? price) => _$this._price = price;

  ComparableStatusBuilder? _comparable;
  ComparableStatusBuilder get comparable =>
      _$this._comparable ??= ComparableStatusBuilder();
  set comparable(ComparableStatusBuilder? comparable) =>
      _$this._comparable = comparable;

  ListingSearchResultStockLabelEnum? _stockLabel;
  ListingSearchResultStockLabelEnum? get stockLabel => _$this._stockLabel;
  set stockLabel(ListingSearchResultStockLabelEnum? stockLabel) =>
      _$this._stockLabel = stockLabel;

  DateTime? _stockConfirmedAt;
  DateTime? get stockConfirmedAt => _$this._stockConfirmedAt;
  set stockConfirmedAt(DateTime? stockConfirmedAt) =>
      _$this._stockConfirmedAt = stockConfirmedAt;

  ProductRatingSummaryBuilder? _productRating;
  ProductRatingSummaryBuilder get productRating =>
      _$this._productRating ??= ProductRatingSummaryBuilder();
  set productRating(ProductRatingSummaryBuilder? productRating) =>
      _$this._productRating = productRating;

  String? _unitsSold;
  String? get unitsSold => _$this._unitsSold;
  set unitsSold(String? unitsSold) => _$this._unitsSold = unitsSold;

  int? _distanceMeters;
  int? get distanceMeters => _$this._distanceMeters;
  set distanceMeters(int? distanceMeters) =>
      _$this._distanceMeters = distanceMeters;

  ListBuilder<ListingSearchResultBadgesEnum>? _badges;
  ListBuilder<ListingSearchResultBadgesEnum> get badges =>
      _$this._badges ??= ListBuilder<ListingSearchResultBadgesEnum>();
  set badges(ListBuilder<ListingSearchResultBadgesEnum>? badges) =>
      _$this._badges = badges;

  bool? _isFavorite;
  bool? get isFavorite => _$this._isFavorite;
  set isFavorite(bool? isFavorite) => _$this._isFavorite = isFavorite;

  ListingVendorCardBuilder? _vendor;
  ListingVendorCardBuilder get vendor =>
      _$this._vendor ??= ListingVendorCardBuilder();
  set vendor(ListingVendorCardBuilder? vendor) => _$this._vendor = vendor;

  ListingFulfillmentSummaryBuilder? _fulfillment;
  ListingFulfillmentSummaryBuilder get fulfillment =>
      _$this._fulfillment ??= ListingFulfillmentSummaryBuilder();
  set fulfillment(ListingFulfillmentSummaryBuilder? fulfillment) =>
      _$this._fulfillment = fulfillment;

  RankingExplanationBuilder? _ranking;
  RankingExplanationBuilder get ranking =>
      _$this._ranking ??= RankingExplanationBuilder();
  set ranking(RankingExplanationBuilder? ranking) => _$this._ranking = ranking;

  ListingSearchResultBuilder() {
    ListingSearchResult._defaults(this);
  }

  ListingSearchResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _listingId = $v.listingId;
      _variantId = $v.variantId;
      _rank = $v.rank;
      _displayName = $v.displayName;
      _brand = $v.brand;
      _category = $v.category?.toBuilder();
      _variantLabel = $v.variantLabel;
      _optionsCount = $v.optionsCount;
      _image = $v.image?.toBuilder();
      _price = $v.price.toBuilder();
      _comparable = $v.comparable.toBuilder();
      _stockLabel = $v.stockLabel;
      _stockConfirmedAt = $v.stockConfirmedAt;
      _productRating = $v.productRating.toBuilder();
      _unitsSold = $v.unitsSold;
      _distanceMeters = $v.distanceMeters;
      _badges = $v.badges.toBuilder();
      _isFavorite = $v.isFavorite;
      _vendor = $v.vendor.toBuilder();
      _fulfillment = $v.fulfillment.toBuilder();
      _ranking = $v.ranking.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListingSearchResult other) {
    _$v = other as _$ListingSearchResult;
  }

  @override
  void update(void Function(ListingSearchResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListingSearchResult build() => _build();

  _$ListingSearchResult _build() {
    _$ListingSearchResult _$result;
    try {
      _$result = _$v ??
          _$ListingSearchResult._(
            listingId: BuiltValueNullFieldError.checkNotNull(
                listingId, r'ListingSearchResult', 'listingId'),
            variantId: BuiltValueNullFieldError.checkNotNull(
                variantId, r'ListingSearchResult', 'variantId'),
            rank: BuiltValueNullFieldError.checkNotNull(
                rank, r'ListingSearchResult', 'rank'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'ListingSearchResult', 'displayName'),
            brand: brand,
            category: _category?.build(),
            variantLabel: variantLabel,
            optionsCount: BuiltValueNullFieldError.checkNotNull(
                optionsCount, r'ListingSearchResult', 'optionsCount'),
            image: _image?.build(),
            price: price.build(),
            comparable: comparable.build(),
            stockLabel: BuiltValueNullFieldError.checkNotNull(
                stockLabel, r'ListingSearchResult', 'stockLabel'),
            stockConfirmedAt: BuiltValueNullFieldError.checkNotNull(
                stockConfirmedAt, r'ListingSearchResult', 'stockConfirmedAt'),
            productRating: productRating.build(),
            unitsSold: BuiltValueNullFieldError.checkNotNull(
                unitsSold, r'ListingSearchResult', 'unitsSold'),
            distanceMeters: BuiltValueNullFieldError.checkNotNull(
                distanceMeters, r'ListingSearchResult', 'distanceMeters'),
            badges: badges.build(),
            isFavorite: BuiltValueNullFieldError.checkNotNull(
                isFavorite, r'ListingSearchResult', 'isFavorite'),
            vendor: vendor.build(),
            fulfillment: fulfillment.build(),
            ranking: ranking.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'category';
        _category?.build();

        _$failedField = 'image';
        _image?.build();
        _$failedField = 'price';
        price.build();
        _$failedField = 'comparable';
        comparable.build();

        _$failedField = 'productRating';
        productRating.build();

        _$failedField = 'badges';
        badges.build();

        _$failedField = 'vendor';
        vendor.build();
        _$failedField = 'fulfillment';
        fulfillment.build();
        _$failedField = 'ranking';
        ranking.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ListingSearchResult', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
