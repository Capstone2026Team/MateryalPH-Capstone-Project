// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nrpc_terms_version.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NrpcTermsVersion extends NrpcTermsVersion {
  @override
  final String id;
  @override
  final int version;
  @override
  final String title;
  @override
  final String? content;
  @override
  final String contentHash;

  factory _$NrpcTermsVersion(
          [void Function(NrpcTermsVersionBuilder)? updates]) =>
      (NrpcTermsVersionBuilder()..update(updates))._build();

  _$NrpcTermsVersion._(
      {required this.id,
      required this.version,
      required this.title,
      this.content,
      required this.contentHash})
      : super._();
  @override
  NrpcTermsVersion rebuild(void Function(NrpcTermsVersionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NrpcTermsVersionBuilder toBuilder() =>
      NrpcTermsVersionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NrpcTermsVersion &&
        id == other.id &&
        version == other.version &&
        title == other.title &&
        content == other.content &&
        contentHash == other.contentHash;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, content.hashCode);
    _$hash = $jc(_$hash, contentHash.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NrpcTermsVersion')
          ..add('id', id)
          ..add('version', version)
          ..add('title', title)
          ..add('content', content)
          ..add('contentHash', contentHash))
        .toString();
  }
}

class NrpcTermsVersionBuilder
    implements Builder<NrpcTermsVersion, NrpcTermsVersionBuilder> {
  _$NrpcTermsVersion? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _content;
  String? get content => _$this._content;
  set content(String? content) => _$this._content = content;

  String? _contentHash;
  String? get contentHash => _$this._contentHash;
  set contentHash(String? contentHash) => _$this._contentHash = contentHash;

  NrpcTermsVersionBuilder() {
    NrpcTermsVersion._defaults(this);
  }

  NrpcTermsVersionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _version = $v.version;
      _title = $v.title;
      _content = $v.content;
      _contentHash = $v.contentHash;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NrpcTermsVersion other) {
    _$v = other as _$NrpcTermsVersion;
  }

  @override
  void update(void Function(NrpcTermsVersionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NrpcTermsVersion build() => _build();

  _$NrpcTermsVersion _build() {
    final _$result = _$v ??
        _$NrpcTermsVersion._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'NrpcTermsVersion', 'id'),
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'NrpcTermsVersion', 'version'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'NrpcTermsVersion', 'title'),
          content: content,
          contentHash: BuiltValueNullFieldError.checkNotNull(
              contentHash, r'NrpcTermsVersion', 'contentHash'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
