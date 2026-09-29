// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_place_photo.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GooglePlacePhoto extends GooglePlacePhoto {
  @override
  final String uri;
  @override
  final BuiltList<GoogleContentAuthor> authors;
  @override
  final String? googleMapsUri;

  factory _$GooglePlacePhoto(
          [void Function(GooglePlacePhotoBuilder)? updates]) =>
      (GooglePlacePhotoBuilder()..update(updates))._build();

  _$GooglePlacePhoto._(
      {required this.uri, required this.authors, this.googleMapsUri})
      : super._();
  @override
  GooglePlacePhoto rebuild(void Function(GooglePlacePhotoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GooglePlacePhotoBuilder toBuilder() =>
      GooglePlacePhotoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GooglePlacePhoto &&
        uri == other.uri &&
        authors == other.authors &&
        googleMapsUri == other.googleMapsUri;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, uri.hashCode);
    _$hash = $jc(_$hash, authors.hashCode);
    _$hash = $jc(_$hash, googleMapsUri.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GooglePlacePhoto')
          ..add('uri', uri)
          ..add('authors', authors)
          ..add('googleMapsUri', googleMapsUri))
        .toString();
  }
}

class GooglePlacePhotoBuilder
    implements Builder<GooglePlacePhoto, GooglePlacePhotoBuilder> {
  _$GooglePlacePhoto? _$v;

  String? _uri;
  String? get uri => _$this._uri;
  set uri(String? uri) => _$this._uri = uri;

  ListBuilder<GoogleContentAuthor>? _authors;
  ListBuilder<GoogleContentAuthor> get authors =>
      _$this._authors ??= ListBuilder<GoogleContentAuthor>();
  set authors(ListBuilder<GoogleContentAuthor>? authors) =>
      _$this._authors = authors;

  String? _googleMapsUri;
  String? get googleMapsUri => _$this._googleMapsUri;
  set googleMapsUri(String? googleMapsUri) =>
      _$this._googleMapsUri = googleMapsUri;

  GooglePlacePhotoBuilder() {
    GooglePlacePhoto._defaults(this);
  }

  GooglePlacePhotoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _uri = $v.uri;
      _authors = $v.authors.toBuilder();
      _googleMapsUri = $v.googleMapsUri;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GooglePlacePhoto other) {
    _$v = other as _$GooglePlacePhoto;
  }

  @override
  void update(void Function(GooglePlacePhotoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GooglePlacePhoto build() => _build();

  _$GooglePlacePhoto _build() {
    _$GooglePlacePhoto _$result;
    try {
      _$result = _$v ??
          _$GooglePlacePhoto._(
            uri: BuiltValueNullFieldError.checkNotNull(
                uri, r'GooglePlacePhoto', 'uri'),
            authors: authors.build(),
            googleMapsUri: googleMapsUri,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'authors';
        authors.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GooglePlacePhoto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
