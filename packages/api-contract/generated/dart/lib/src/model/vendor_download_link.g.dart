// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_download_link.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDownloadLink extends VendorDownloadLink {
  @override
  final String url;
  @override
  final String expiresAt;

  factory _$VendorDownloadLink(
          [void Function(VendorDownloadLinkBuilder)? updates]) =>
      (VendorDownloadLinkBuilder()..update(updates))._build();

  _$VendorDownloadLink._({required this.url, required this.expiresAt})
      : super._();
  @override
  VendorDownloadLink rebuild(
          void Function(VendorDownloadLinkBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDownloadLinkBuilder toBuilder() =>
      VendorDownloadLinkBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDownloadLink &&
        url == other.url &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorDownloadLink')
          ..add('url', url)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class VendorDownloadLinkBuilder
    implements Builder<VendorDownloadLink, VendorDownloadLinkBuilder> {
  _$VendorDownloadLink? _$v;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  String? _expiresAt;
  String? get expiresAt => _$this._expiresAt;
  set expiresAt(String? expiresAt) => _$this._expiresAt = expiresAt;

  VendorDownloadLinkBuilder() {
    VendorDownloadLink._defaults(this);
  }

  VendorDownloadLinkBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _url = $v.url;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDownloadLink other) {
    _$v = other as _$VendorDownloadLink;
  }

  @override
  void update(void Function(VendorDownloadLinkBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDownloadLink build() => _build();

  _$VendorDownloadLink _build() {
    final _$result = _$v ??
        _$VendorDownloadLink._(
          url: BuiltValueNullFieldError.checkNotNull(
              url, r'VendorDownloadLink', 'url'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'VendorDownloadLink', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
