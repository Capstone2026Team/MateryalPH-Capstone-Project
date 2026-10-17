// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReviewSummary extends ReviewSummary {
  @override
  final int count;
  @override
  final num? average;
  @override
  final BuiltList<ReviewRatingBucket> distribution;

  factory _$ReviewSummary([void Function(ReviewSummaryBuilder)? updates]) =>
      (ReviewSummaryBuilder()..update(updates))._build();

  _$ReviewSummary._(
      {required this.count, this.average, required this.distribution})
      : super._();
  @override
  ReviewSummary rebuild(void Function(ReviewSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReviewSummaryBuilder toBuilder() => ReviewSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReviewSummary &&
        count == other.count &&
        average == other.average &&
        distribution == other.distribution;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jc(_$hash, average.hashCode);
    _$hash = $jc(_$hash, distribution.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReviewSummary')
          ..add('count', count)
          ..add('average', average)
          ..add('distribution', distribution))
        .toString();
  }
}

class ReviewSummaryBuilder
    implements Builder<ReviewSummary, ReviewSummaryBuilder> {
  _$ReviewSummary? _$v;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  num? _average;
  num? get average => _$this._average;
  set average(num? average) => _$this._average = average;

  ListBuilder<ReviewRatingBucket>? _distribution;
  ListBuilder<ReviewRatingBucket> get distribution =>
      _$this._distribution ??= ListBuilder<ReviewRatingBucket>();
  set distribution(ListBuilder<ReviewRatingBucket>? distribution) =>
      _$this._distribution = distribution;

  ReviewSummaryBuilder() {
    ReviewSummary._defaults(this);
  }

  ReviewSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _count = $v.count;
      _average = $v.average;
      _distribution = $v.distribution.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReviewSummary other) {
    _$v = other as _$ReviewSummary;
  }

  @override
  void update(void Function(ReviewSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReviewSummary build() => _build();

  _$ReviewSummary _build() {
    _$ReviewSummary _$result;
    try {
      _$result = _$v ??
          _$ReviewSummary._(
            count: BuiltValueNullFieldError.checkNotNull(
                count, r'ReviewSummary', 'count'),
            average: average,
            distribution: distribution.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'distribution';
        distribution.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ReviewSummary', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
