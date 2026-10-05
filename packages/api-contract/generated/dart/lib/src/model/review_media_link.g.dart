// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_media_link.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReviewMediaLink extends ReviewMediaLink {
  @override
  final String id;
  @override
  final String url;
  @override
  final DateTime expiresAt;

  factory _$ReviewMediaLink([void Function(ReviewMediaLinkBuilder)? updates]) =>
      (ReviewMediaLinkBuilder()..update(updates))._build();

  _$ReviewMediaLink._(
      {required this.id, required this.url, required this.expiresAt})
      : super._();
  @override
  ReviewMediaLink rebuild(void Function(ReviewMediaLinkBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReviewMediaLinkBuilder toBuilder() => ReviewMediaLinkBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReviewMediaLink &&
        id == other.id &&
        url == other.url &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReviewMediaLink')
          ..add('id', id)
          ..add('url', url)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class ReviewMediaLinkBuilder
    implements Builder<ReviewMediaLink, ReviewMediaLinkBuilder> {
  _$ReviewMediaLink? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  ReviewMediaLinkBuilder() {
    ReviewMediaLink._defaults(this);
  }

  ReviewMediaLinkBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _url = $v.url;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReviewMediaLink other) {
    _$v = other as _$ReviewMediaLink;
  }

  @override
  void update(void Function(ReviewMediaLinkBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReviewMediaLink build() => _build();

  _$ReviewMediaLink _build() {
    final _$result = _$v ??
        _$ReviewMediaLink._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ReviewMediaLink', 'id'),
          url: BuiltValueNullFieldError.checkNotNull(
              url, r'ReviewMediaLink', 'url'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'ReviewMediaLink', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
