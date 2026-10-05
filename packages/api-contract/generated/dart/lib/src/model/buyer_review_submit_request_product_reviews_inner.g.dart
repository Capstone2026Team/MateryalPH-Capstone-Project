// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_review_submit_request_product_reviews_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerReviewSubmitRequestProductReviewsInner
    extends BuyerReviewSubmitRequestProductReviewsInner {
  @override
  final String orderLineId;
  @override
  final int rating;
  @override
  final String? comment;

  factory _$BuyerReviewSubmitRequestProductReviewsInner(
          [void Function(BuyerReviewSubmitRequestProductReviewsInnerBuilder)?
              updates]) =>
      (BuyerReviewSubmitRequestProductReviewsInnerBuilder()..update(updates))
          ._build();

  _$BuyerReviewSubmitRequestProductReviewsInner._(
      {required this.orderLineId, required this.rating, this.comment})
      : super._();
  @override
  BuyerReviewSubmitRequestProductReviewsInner rebuild(
          void Function(BuyerReviewSubmitRequestProductReviewsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerReviewSubmitRequestProductReviewsInnerBuilder toBuilder() =>
      BuyerReviewSubmitRequestProductReviewsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerReviewSubmitRequestProductReviewsInner &&
        orderLineId == other.orderLineId &&
        rating == other.rating &&
        comment == other.comment;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderLineId.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'BuyerReviewSubmitRequestProductReviewsInner')
          ..add('orderLineId', orderLineId)
          ..add('rating', rating)
          ..add('comment', comment))
        .toString();
  }
}

class BuyerReviewSubmitRequestProductReviewsInnerBuilder
    implements
        Builder<BuyerReviewSubmitRequestProductReviewsInner,
            BuyerReviewSubmitRequestProductReviewsInnerBuilder> {
  _$BuyerReviewSubmitRequestProductReviewsInner? _$v;

  String? _orderLineId;
  String? get orderLineId => _$this._orderLineId;
  set orderLineId(String? orderLineId) => _$this._orderLineId = orderLineId;

  int? _rating;
  int? get rating => _$this._rating;
  set rating(int? rating) => _$this._rating = rating;

  String? _comment;
  String? get comment => _$this._comment;
  set comment(String? comment) => _$this._comment = comment;

  BuyerReviewSubmitRequestProductReviewsInnerBuilder() {
    BuyerReviewSubmitRequestProductReviewsInner._defaults(this);
  }

  BuyerReviewSubmitRequestProductReviewsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderLineId = $v.orderLineId;
      _rating = $v.rating;
      _comment = $v.comment;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerReviewSubmitRequestProductReviewsInner other) {
    _$v = other as _$BuyerReviewSubmitRequestProductReviewsInner;
  }

  @override
  void update(
      void Function(BuyerReviewSubmitRequestProductReviewsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerReviewSubmitRequestProductReviewsInner build() => _build();

  _$BuyerReviewSubmitRequestProductReviewsInner _build() {
    final _$result = _$v ??
        _$BuyerReviewSubmitRequestProductReviewsInner._(
          orderLineId: BuiltValueNullFieldError.checkNotNull(orderLineId,
              r'BuyerReviewSubmitRequestProductReviewsInner', 'orderLineId'),
          rating: BuiltValueNullFieldError.checkNotNull(
              rating, r'BuyerReviewSubmitRequestProductReviewsInner', 'rating'),
          comment: comment,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
