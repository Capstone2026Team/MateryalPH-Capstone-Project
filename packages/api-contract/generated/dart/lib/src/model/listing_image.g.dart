// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_image.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ListingImage extends ListingImage {
  @override
  final String url;
  @override
  final String? altText;

  factory _$ListingImage([void Function(ListingImageBuilder)? updates]) =>
      (ListingImageBuilder()..update(updates))._build();

  _$ListingImage._({required this.url, this.altText}) : super._();
  @override
  ListingImage rebuild(void Function(ListingImageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListingImageBuilder toBuilder() => ListingImageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListingImage &&
        url == other.url &&
        altText == other.altText;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, altText.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListingImage')
          ..add('url', url)
          ..add('altText', altText))
        .toString();
  }
}

class ListingImageBuilder
    implements Builder<ListingImage, ListingImageBuilder> {
  _$ListingImage? _$v;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  String? _altText;
  String? get altText => _$this._altText;
  set altText(String? altText) => _$this._altText = altText;

  ListingImageBuilder() {
    ListingImage._defaults(this);
  }

  ListingImageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _url = $v.url;
      _altText = $v.altText;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListingImage other) {
    _$v = other as _$ListingImage;
  }

  @override
  void update(void Function(ListingImageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListingImage build() => _build();

  _$ListingImage _build() {
    final _$result = _$v ??
        _$ListingImage._(
          url: BuiltValueNullFieldError.checkNotNull(
              url, r'ListingImage', 'url'),
          altText: altText,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
