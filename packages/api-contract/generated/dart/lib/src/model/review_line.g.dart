// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_line.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReviewLine extends ReviewLine {
  @override
  final String orderLineId;
  @override
  final String listingId;
  @override
  final String displayName;
  @override
  final String? variantLabel;
  @override
  final OwnReview? review;
  @override
  final bool canReview;

  factory _$ReviewLine([void Function(ReviewLineBuilder)? updates]) =>
      (ReviewLineBuilder()..update(updates))._build();

  _$ReviewLine._(
      {required this.orderLineId,
      required this.listingId,
      required this.displayName,
      this.variantLabel,
      this.review,
      required this.canReview})
      : super._();
  @override
  ReviewLine rebuild(void Function(ReviewLineBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReviewLineBuilder toBuilder() => ReviewLineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReviewLine &&
        orderLineId == other.orderLineId &&
        listingId == other.listingId &&
        displayName == other.displayName &&
        variantLabel == other.variantLabel &&
        review == other.review &&
        canReview == other.canReview;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderLineId.hashCode);
    _$hash = $jc(_$hash, listingId.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, variantLabel.hashCode);
    _$hash = $jc(_$hash, review.hashCode);
    _$hash = $jc(_$hash, canReview.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReviewLine')
          ..add('orderLineId', orderLineId)
          ..add('listingId', listingId)
          ..add('displayName', displayName)
          ..add('variantLabel', variantLabel)
          ..add('review', review)
          ..add('canReview', canReview))
        .toString();
  }
}

class ReviewLineBuilder implements Builder<ReviewLine, ReviewLineBuilder> {
  _$ReviewLine? _$v;

  String? _orderLineId;
  String? get orderLineId => _$this._orderLineId;
  set orderLineId(String? orderLineId) => _$this._orderLineId = orderLineId;

  String? _listingId;
  String? get listingId => _$this._listingId;
  set listingId(String? listingId) => _$this._listingId = listingId;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _variantLabel;
  String? get variantLabel => _$this._variantLabel;
  set variantLabel(String? variantLabel) => _$this._variantLabel = variantLabel;

  OwnReviewBuilder? _review;
  OwnReviewBuilder get review => _$this._review ??= OwnReviewBuilder();
  set review(OwnReviewBuilder? review) => _$this._review = review;

  bool? _canReview;
  bool? get canReview => _$this._canReview;
  set canReview(bool? canReview) => _$this._canReview = canReview;

  ReviewLineBuilder() {
    ReviewLine._defaults(this);
  }

  ReviewLineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderLineId = $v.orderLineId;
      _listingId = $v.listingId;
      _displayName = $v.displayName;
      _variantLabel = $v.variantLabel;
      _review = $v.review?.toBuilder();
      _canReview = $v.canReview;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReviewLine other) {
    _$v = other as _$ReviewLine;
  }

  @override
  void update(void Function(ReviewLineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReviewLine build() => _build();

  _$ReviewLine _build() {
    _$ReviewLine _$result;
    try {
      _$result = _$v ??
          _$ReviewLine._(
            orderLineId: BuiltValueNullFieldError.checkNotNull(
                orderLineId, r'ReviewLine', 'orderLineId'),
            listingId: BuiltValueNullFieldError.checkNotNull(
                listingId, r'ReviewLine', 'listingId'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'ReviewLine', 'displayName'),
            variantLabel: variantLabel,
            review: _review?.build(),
            canReview: BuiltValueNullFieldError.checkNotNull(
                canReview, r'ReviewLine', 'canReview'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'review';
        _review?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ReviewLine', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
