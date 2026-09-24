// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_file.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorFile extends VendorFile {
  @override
  final String url;
  @override
  final DateTime expiresAt;

  factory _$VendorFile([void Function(VendorFileBuilder)? updates]) =>
      (VendorFileBuilder()..update(updates))._build();

  _$VendorFile._({required this.url, required this.expiresAt}) : super._();
  @override
  VendorFile rebuild(void Function(VendorFileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorFileBuilder toBuilder() => VendorFileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorFile &&
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
    return (newBuiltValueToStringHelper(r'VendorFile')
          ..add('url', url)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class VendorFileBuilder implements Builder<VendorFile, VendorFileBuilder> {
  _$VendorFile? _$v;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  VendorFileBuilder() {
    VendorFile._defaults(this);
  }

  VendorFileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _url = $v.url;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorFile other) {
    _$v = other as _$VendorFile;
  }

  @override
  void update(void Function(VendorFileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorFile build() => _build();

  _$VendorFile _build() {
    final _$result = _$v ??
        _$VendorFile._(
          url: BuiltValueNullFieldError.checkNotNull(url, r'VendorFile', 'url'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'VendorFile', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
