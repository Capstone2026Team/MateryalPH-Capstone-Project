// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_review_submit_request_vendor_rating.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerReviewSubmitRequestVendorRating
    extends BuyerReviewSubmitRequestVendorRating {
  @override
  final int serviceQuality;
  @override
  final int speedRating;
  @override
  final String? comment;

  factory _$BuyerReviewSubmitRequestVendorRating(
          [void Function(BuyerReviewSubmitRequestVendorRatingBuilder)?
              updates]) =>
      (BuyerReviewSubmitRequestVendorRatingBuilder()..update(updates))._build();

  _$BuyerReviewSubmitRequestVendorRating._(
      {required this.serviceQuality, required this.speedRating, this.comment})
      : super._();
  @override
  BuyerReviewSubmitRequestVendorRating rebuild(
          void Function(BuyerReviewSubmitRequestVendorRatingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerReviewSubmitRequestVendorRatingBuilder toBuilder() =>
      BuyerReviewSubmitRequestVendorRatingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerReviewSubmitRequestVendorRating &&
        serviceQuality == other.serviceQuality &&
        speedRating == other.speedRating &&
        comment == other.comment;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, serviceQuality.hashCode);
    _$hash = $jc(_$hash, speedRating.hashCode);
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerReviewSubmitRequestVendorRating')
          ..add('serviceQuality', serviceQuality)
          ..add('speedRating', speedRating)
          ..add('comment', comment))
        .toString();
  }
}

class BuyerReviewSubmitRequestVendorRatingBuilder
    implements
        Builder<BuyerReviewSubmitRequestVendorRating,
            BuyerReviewSubmitRequestVendorRatingBuilder> {
  _$BuyerReviewSubmitRequestVendorRating? _$v;

  int? _serviceQuality;
  int? get serviceQuality => _$this._serviceQuality;
  set serviceQuality(int? serviceQuality) =>
      _$this._serviceQuality = serviceQuality;

  int? _speedRating;
  int? get speedRating => _$this._speedRating;
  set speedRating(int? speedRating) => _$this._speedRating = speedRating;

  String? _comment;
  String? get comment => _$this._comment;
  set comment(String? comment) => _$this._comment = comment;

  BuyerReviewSubmitRequestVendorRatingBuilder() {
    BuyerReviewSubmitRequestVendorRating._defaults(this);
  }

  BuyerReviewSubmitRequestVendorRatingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _serviceQuality = $v.serviceQuality;
      _speedRating = $v.speedRating;
      _comment = $v.comment;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerReviewSubmitRequestVendorRating other) {
    _$v = other as _$BuyerReviewSubmitRequestVendorRating;
  }

  @override
  void update(
      void Function(BuyerReviewSubmitRequestVendorRatingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerReviewSubmitRequestVendorRating build() => _build();

  _$BuyerReviewSubmitRequestVendorRating _build() {
    final _$result = _$v ??
        _$BuyerReviewSubmitRequestVendorRating._(
          serviceQuality: BuiltValueNullFieldError.checkNotNull(serviceQuality,
              r'BuyerReviewSubmitRequestVendorRating', 'serviceQuality'),
          speedRating: BuiltValueNullFieldError.checkNotNull(speedRating,
              r'BuyerReviewSubmitRequestVendorRating', 'speedRating'),
          comment: comment,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
