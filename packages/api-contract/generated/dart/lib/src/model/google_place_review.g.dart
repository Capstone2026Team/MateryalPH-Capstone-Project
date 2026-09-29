// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_place_review.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GooglePlaceReview extends GooglePlaceReview {
  @override
  final GoogleContentAuthor author;
  @override
  final double rating;
  @override
  final String? text;
  @override
  final String? relativeTime;
  @override
  final String? googleMapsUri;

  factory _$GooglePlaceReview(
          [void Function(GooglePlaceReviewBuilder)? updates]) =>
      (GooglePlaceReviewBuilder()..update(updates))._build();

  _$GooglePlaceReview._(
      {required this.author,
      required this.rating,
      this.text,
      this.relativeTime,
      this.googleMapsUri})
      : super._();
  @override
  GooglePlaceReview rebuild(void Function(GooglePlaceReviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GooglePlaceReviewBuilder toBuilder() =>
      GooglePlaceReviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GooglePlaceReview &&
        author == other.author &&
        rating == other.rating &&
        text == other.text &&
        relativeTime == other.relativeTime &&
        googleMapsUri == other.googleMapsUri;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, author.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, relativeTime.hashCode);
    _$hash = $jc(_$hash, googleMapsUri.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GooglePlaceReview')
          ..add('author', author)
          ..add('rating', rating)
          ..add('text', text)
          ..add('relativeTime', relativeTime)
          ..add('googleMapsUri', googleMapsUri))
        .toString();
  }
}

class GooglePlaceReviewBuilder
    implements Builder<GooglePlaceReview, GooglePlaceReviewBuilder> {
  _$GooglePlaceReview? _$v;

  GoogleContentAuthorBuilder? _author;
  GoogleContentAuthorBuilder get author =>
      _$this._author ??= GoogleContentAuthorBuilder();
  set author(GoogleContentAuthorBuilder? author) => _$this._author = author;

  double? _rating;
  double? get rating => _$this._rating;
  set rating(double? rating) => _$this._rating = rating;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  String? _relativeTime;
  String? get relativeTime => _$this._relativeTime;
  set relativeTime(String? relativeTime) => _$this._relativeTime = relativeTime;

  String? _googleMapsUri;
  String? get googleMapsUri => _$this._googleMapsUri;
  set googleMapsUri(String? googleMapsUri) =>
      _$this._googleMapsUri = googleMapsUri;

  GooglePlaceReviewBuilder() {
    GooglePlaceReview._defaults(this);
  }

  GooglePlaceReviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _author = $v.author.toBuilder();
      _rating = $v.rating;
      _text = $v.text;
      _relativeTime = $v.relativeTime;
      _googleMapsUri = $v.googleMapsUri;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GooglePlaceReview other) {
    _$v = other as _$GooglePlaceReview;
  }

  @override
  void update(void Function(GooglePlaceReviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GooglePlaceReview build() => _build();

  _$GooglePlaceReview _build() {
    _$GooglePlaceReview _$result;
    try {
      _$result = _$v ??
          _$GooglePlaceReview._(
            author: author.build(),
            rating: BuiltValueNullFieldError.checkNotNull(
                rating, r'GooglePlaceReview', 'rating'),
            text: text,
            relativeTime: relativeTime,
            googleMapsUri: googleMapsUri,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'author';
        author.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GooglePlaceReview', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
