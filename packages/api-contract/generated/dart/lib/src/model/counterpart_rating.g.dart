// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counterpart_rating.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CounterpartRating extends CounterpartRating {
  @override
  final ReviewRatings ratings;
  @override
  final String? comment;
  @override
  final String displayName;
  @override
  final DateTime? submittedAt;

  factory _$CounterpartRating(
          [void Function(CounterpartRatingBuilder)? updates]) =>
      (CounterpartRatingBuilder()..update(updates))._build();

  _$CounterpartRating._(
      {required this.ratings,
      this.comment,
      required this.displayName,
      this.submittedAt})
      : super._();
  @override
  CounterpartRating rebuild(void Function(CounterpartRatingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CounterpartRatingBuilder toBuilder() =>
      CounterpartRatingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounterpartRating &&
        ratings == other.ratings &&
        comment == other.comment &&
        displayName == other.displayName &&
        submittedAt == other.submittedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ratings.hashCode);
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, submittedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CounterpartRating')
          ..add('ratings', ratings)
          ..add('comment', comment)
          ..add('displayName', displayName)
          ..add('submittedAt', submittedAt))
        .toString();
  }
}

class CounterpartRatingBuilder
    implements Builder<CounterpartRating, CounterpartRatingBuilder> {
  _$CounterpartRating? _$v;

  ReviewRatingsBuilder? _ratings;
  ReviewRatingsBuilder get ratings =>
      _$this._ratings ??= ReviewRatingsBuilder();
  set ratings(ReviewRatingsBuilder? ratings) => _$this._ratings = ratings;

  String? _comment;
  String? get comment => _$this._comment;
  set comment(String? comment) => _$this._comment = comment;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  DateTime? _submittedAt;
  DateTime? get submittedAt => _$this._submittedAt;
  set submittedAt(DateTime? submittedAt) => _$this._submittedAt = submittedAt;

  CounterpartRatingBuilder() {
    CounterpartRating._defaults(this);
  }

  CounterpartRatingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ratings = $v.ratings.toBuilder();
      _comment = $v.comment;
      _displayName = $v.displayName;
      _submittedAt = $v.submittedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CounterpartRating other) {
    _$v = other as _$CounterpartRating;
  }

  @override
  void update(void Function(CounterpartRatingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CounterpartRating build() => _build();

  _$CounterpartRating _build() {
    _$CounterpartRating _$result;
    try {
      _$result = _$v ??
          _$CounterpartRating._(
            ratings: ratings.build(),
            comment: comment,
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'CounterpartRating', 'displayName'),
            submittedAt: submittedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ratings';
        ratings.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CounterpartRating', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
