// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_received_rating.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerReceivedRating extends BuyerReceivedRating {
  @override
  final String id;
  @override
  final String storeName;
  @override
  final String orderId;
  @override
  final String orderReference;
  @override
  final ReviewRatings ratings;
  @override
  final String? comment;
  @override
  final DateTime submittedAt;

  factory _$BuyerReceivedRating(
          [void Function(BuyerReceivedRatingBuilder)? updates]) =>
      (BuyerReceivedRatingBuilder()..update(updates))._build();

  _$BuyerReceivedRating._(
      {required this.id,
      required this.storeName,
      required this.orderId,
      required this.orderReference,
      required this.ratings,
      this.comment,
      required this.submittedAt})
      : super._();
  @override
  BuyerReceivedRating rebuild(
          void Function(BuyerReceivedRatingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerReceivedRatingBuilder toBuilder() =>
      BuyerReceivedRatingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerReceivedRating &&
        id == other.id &&
        storeName == other.storeName &&
        orderId == other.orderId &&
        orderReference == other.orderReference &&
        ratings == other.ratings &&
        comment == other.comment &&
        submittedAt == other.submittedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, storeName.hashCode);
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, orderReference.hashCode);
    _$hash = $jc(_$hash, ratings.hashCode);
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jc(_$hash, submittedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerReceivedRating')
          ..add('id', id)
          ..add('storeName', storeName)
          ..add('orderId', orderId)
          ..add('orderReference', orderReference)
          ..add('ratings', ratings)
          ..add('comment', comment)
          ..add('submittedAt', submittedAt))
        .toString();
  }
}

class BuyerReceivedRatingBuilder
    implements Builder<BuyerReceivedRating, BuyerReceivedRatingBuilder> {
  _$BuyerReceivedRating? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _storeName;
  String? get storeName => _$this._storeName;
  set storeName(String? storeName) => _$this._storeName = storeName;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _orderReference;
  String? get orderReference => _$this._orderReference;
  set orderReference(String? orderReference) =>
      _$this._orderReference = orderReference;

  ReviewRatingsBuilder? _ratings;
  ReviewRatingsBuilder get ratings =>
      _$this._ratings ??= ReviewRatingsBuilder();
  set ratings(ReviewRatingsBuilder? ratings) => _$this._ratings = ratings;

  String? _comment;
  String? get comment => _$this._comment;
  set comment(String? comment) => _$this._comment = comment;

  DateTime? _submittedAt;
  DateTime? get submittedAt => _$this._submittedAt;
  set submittedAt(DateTime? submittedAt) => _$this._submittedAt = submittedAt;

  BuyerReceivedRatingBuilder() {
    BuyerReceivedRating._defaults(this);
  }

  BuyerReceivedRatingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _storeName = $v.storeName;
      _orderId = $v.orderId;
      _orderReference = $v.orderReference;
      _ratings = $v.ratings.toBuilder();
      _comment = $v.comment;
      _submittedAt = $v.submittedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerReceivedRating other) {
    _$v = other as _$BuyerReceivedRating;
  }

  @override
  void update(void Function(BuyerReceivedRatingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerReceivedRating build() => _build();

  _$BuyerReceivedRating _build() {
    _$BuyerReceivedRating _$result;
    try {
      _$result = _$v ??
          _$BuyerReceivedRating._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'BuyerReceivedRating', 'id'),
            storeName: BuiltValueNullFieldError.checkNotNull(
                storeName, r'BuyerReceivedRating', 'storeName'),
            orderId: BuiltValueNullFieldError.checkNotNull(
                orderId, r'BuyerReceivedRating', 'orderId'),
            orderReference: BuiltValueNullFieldError.checkNotNull(
                orderReference, r'BuyerReceivedRating', 'orderReference'),
            ratings: ratings.build(),
            comment: comment,
            submittedAt: BuiltValueNullFieldError.checkNotNull(
                submittedAt, r'BuyerReceivedRating', 'submittedAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ratings';
        ratings.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BuyerReceivedRating', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
