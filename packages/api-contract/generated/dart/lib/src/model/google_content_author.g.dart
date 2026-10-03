// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_content_author.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GoogleContentAuthor extends GoogleContentAuthor {
  @override
  final String name;
  @override
  final String? uri;
  @override
  final String? photoUri;

  factory _$GoogleContentAuthor(
          [void Function(GoogleContentAuthorBuilder)? updates]) =>
      (GoogleContentAuthorBuilder()..update(updates))._build();

  _$GoogleContentAuthor._({required this.name, this.uri, this.photoUri})
      : super._();
  @override
  GoogleContentAuthor rebuild(
          void Function(GoogleContentAuthorBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoogleContentAuthorBuilder toBuilder() =>
      GoogleContentAuthorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GoogleContentAuthor &&
        name == other.name &&
        uri == other.uri &&
        photoUri == other.photoUri;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, uri.hashCode);
    _$hash = $jc(_$hash, photoUri.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GoogleContentAuthor')
          ..add('name', name)
          ..add('uri', uri)
          ..add('photoUri', photoUri))
        .toString();
  }
}

class GoogleContentAuthorBuilder
    implements Builder<GoogleContentAuthor, GoogleContentAuthorBuilder> {
  _$GoogleContentAuthor? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _uri;
  String? get uri => _$this._uri;
  set uri(String? uri) => _$this._uri = uri;

  String? _photoUri;
  String? get photoUri => _$this._photoUri;
  set photoUri(String? photoUri) => _$this._photoUri = photoUri;

  GoogleContentAuthorBuilder() {
    GoogleContentAuthor._defaults(this);
  }

  GoogleContentAuthorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _uri = $v.uri;
      _photoUri = $v.photoUri;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GoogleContentAuthor other) {
    _$v = other as _$GoogleContentAuthor;
  }

  @override
  void update(void Function(GoogleContentAuthorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GoogleContentAuthor build() => _build();

  _$GoogleContentAuthor _build() {
    final _$result = _$v ??
        _$GoogleContentAuthor._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'GoogleContentAuthor', 'name'),
          uri: uri,
          photoUri: photoUri,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
