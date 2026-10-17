// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_review_edit_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerReviewEditRequest extends BuyerReviewEditRequest {
  @override
  final int lockVersion;
  @override
  final int? serviceQuality;
  @override
  final int? speedRating;
  @override
  final int? rating;
  @override
  final String? comment;

  factory _$BuyerReviewEditRequest(
          [void Function(BuyerReviewEditRequestBuilder)? updates]) =>
      (BuyerReviewEditRequestBuilder()..update(updates))._build();

  _$BuyerReviewEditRequest._(
      {required this.lockVersion,
      this.serviceQuality,
      this.speedRating,
      this.rating,
      this.comment})
      : super._();
  @override
  BuyerReviewEditRequest rebuild(
          void Function(BuyerReviewEditRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerReviewEditRequestBuilder toBuilder() =>
      BuyerReviewEditRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerReviewEditRequest &&
        lockVersion == other.lockVersion &&
        serviceQuality == other.serviceQuality &&
        speedRating == other.speedRating &&
        rating == other.rating &&
        comment == other.comment;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, serviceQuality.hashCode);
    _$hash = $jc(_$hash, speedRating.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerReviewEditRequest')
          ..add('lockVersion', lockVersion)
          ..add('serviceQuality', serviceQuality)
          ..add('speedRating', speedRating)
          ..add('rating', rating)
          ..add('comment', comment))
        .toString();
  }
}

class BuyerReviewEditRequestBuilder
    implements Builder<BuyerReviewEditRequest, BuyerReviewEditRequestBuilder> {
  _$BuyerReviewEditRequest? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  int? _serviceQuality;
  int? get serviceQuality => _$this._serviceQuality;
  set serviceQuality(int? serviceQuality) =>
      _$this._serviceQuality = serviceQuality;

  int? _speedRating;
  int? get speedRating => _$this._speedRating;
  set speedRating(int? speedRating) => _$this._speedRating = speedRating;

  int? _rating;
  int? get rating => _$this._rating;
  set rating(int? rating) => _$this._rating = rating;

  String? _comment;
  String? get comment => _$this._comment;
  set comment(String? comment) => _$this._comment = comment;

  BuyerReviewEditRequestBuilder() {
    BuyerReviewEditRequest._defaults(this);
  }

  BuyerReviewEditRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _serviceQuality = $v.serviceQuality;
      _speedRating = $v.speedRating;
      _rating = $v.rating;
      _comment = $v.comment;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerReviewEditRequest other) {
    _$v = other as _$BuyerReviewEditRequest;
  }

  @override
  void update(void Function(BuyerReviewEditRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerReviewEditRequest build() => _build();

  _$BuyerReviewEditRequest _build() {
    final _$result = _$v ??
        _$BuyerReviewEditRequest._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'BuyerReviewEditRequest', 'lockVersion'),
          serviceQuality: serviceQuality,
          speedRating: speedRating,
          rating: rating,
          comment: comment,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
