// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_rating_bucket.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReviewRatingBucket extends ReviewRatingBucket {
  @override
  final int stars;
  @override
  final int count;

  factory _$ReviewRatingBucket(
          [void Function(ReviewRatingBucketBuilder)? updates]) =>
      (ReviewRatingBucketBuilder()..update(updates))._build();

  _$ReviewRatingBucket._({required this.stars, required this.count})
      : super._();
  @override
  ReviewRatingBucket rebuild(
          void Function(ReviewRatingBucketBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReviewRatingBucketBuilder toBuilder() =>
      ReviewRatingBucketBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReviewRatingBucket &&
        stars == other.stars &&
        count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, stars.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReviewRatingBucket')
          ..add('stars', stars)
          ..add('count', count))
        .toString();
  }
}

class ReviewRatingBucketBuilder
    implements Builder<ReviewRatingBucket, ReviewRatingBucketBuilder> {
  _$ReviewRatingBucket? _$v;

  int? _stars;
  int? get stars => _$this._stars;
  set stars(int? stars) => _$this._stars = stars;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  ReviewRatingBucketBuilder() {
    ReviewRatingBucket._defaults(this);
  }

  ReviewRatingBucketBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _stars = $v.stars;
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReviewRatingBucket other) {
    _$v = other as _$ReviewRatingBucket;
  }

  @override
  void update(void Function(ReviewRatingBucketBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReviewRatingBucket build() => _build();

  _$ReviewRatingBucket _build() {
    final _$result = _$v ??
        _$ReviewRatingBucket._(
          stars: BuiltValueNullFieldError.checkNotNull(
              stars, r'ReviewRatingBucket', 'stars'),
          count: BuiltValueNullFieldError.checkNotNull(
              count, r'ReviewRatingBucket', 'count'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
