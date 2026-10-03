// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_weight_set.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RankingWeightSet extends RankingWeightSet {
  @override
  final int distance;
  @override
  final int price;
  @override
  final int vps;
  @override
  final int stock;
  @override
  final int productRating;

  factory _$RankingWeightSet(
          [void Function(RankingWeightSetBuilder)? updates]) =>
      (RankingWeightSetBuilder()..update(updates))._build();

  _$RankingWeightSet._(
      {required this.distance,
      required this.price,
      required this.vps,
      required this.stock,
      required this.productRating})
      : super._();
  @override
  RankingWeightSet rebuild(void Function(RankingWeightSetBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RankingWeightSetBuilder toBuilder() =>
      RankingWeightSetBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RankingWeightSet &&
        distance == other.distance &&
        price == other.price &&
        vps == other.vps &&
        stock == other.stock &&
        productRating == other.productRating;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, distance.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jc(_$hash, vps.hashCode);
    _$hash = $jc(_$hash, stock.hashCode);
    _$hash = $jc(_$hash, productRating.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RankingWeightSet')
          ..add('distance', distance)
          ..add('price', price)
          ..add('vps', vps)
          ..add('stock', stock)
          ..add('productRating', productRating))
        .toString();
  }
}

class RankingWeightSetBuilder
    implements Builder<RankingWeightSet, RankingWeightSetBuilder> {
  _$RankingWeightSet? _$v;

  int? _distance;
  int? get distance => _$this._distance;
  set distance(int? distance) => _$this._distance = distance;

  int? _price;
  int? get price => _$this._price;
  set price(int? price) => _$this._price = price;

  int? _vps;
  int? get vps => _$this._vps;
  set vps(int? vps) => _$this._vps = vps;

  int? _stock;
  int? get stock => _$this._stock;
  set stock(int? stock) => _$this._stock = stock;

  int? _productRating;
  int? get productRating => _$this._productRating;
  set productRating(int? productRating) =>
      _$this._productRating = productRating;

  RankingWeightSetBuilder() {
    RankingWeightSet._defaults(this);
  }

  RankingWeightSetBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _distance = $v.distance;
      _price = $v.price;
      _vps = $v.vps;
      _stock = $v.stock;
      _productRating = $v.productRating;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RankingWeightSet other) {
    _$v = other as _$RankingWeightSet;
  }

  @override
  void update(void Function(RankingWeightSetBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RankingWeightSet build() => _build();

  _$RankingWeightSet _build() {
    final _$result = _$v ??
        _$RankingWeightSet._(
          distance: BuiltValueNullFieldError.checkNotNull(
              distance, r'RankingWeightSet', 'distance'),
          price: BuiltValueNullFieldError.checkNotNull(
              price, r'RankingWeightSet', 'price'),
          vps: BuiltValueNullFieldError.checkNotNull(
              vps, r'RankingWeightSet', 'vps'),
          stock: BuiltValueNullFieldError.checkNotNull(
              stock, r'RankingWeightSet', 'stock'),
          productRating: BuiltValueNullFieldError.checkNotNull(
              productRating, r'RankingWeightSet', 'productRating'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
