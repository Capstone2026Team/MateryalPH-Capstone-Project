// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_file_link.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisputeFileLink extends DisputeFileLink {
  @override
  final String url;
  @override
  final DateTime expiresAt;

  factory _$DisputeFileLink([void Function(DisputeFileLinkBuilder)? updates]) =>
      (DisputeFileLinkBuilder()..update(updates))._build();

  _$DisputeFileLink._({required this.url, required this.expiresAt}) : super._();
  @override
  DisputeFileLink rebuild(void Function(DisputeFileLinkBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeFileLinkBuilder toBuilder() => DisputeFileLinkBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeFileLink &&
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
    return (newBuiltValueToStringHelper(r'DisputeFileLink')
          ..add('url', url)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class DisputeFileLinkBuilder
    implements Builder<DisputeFileLink, DisputeFileLinkBuilder> {
  _$DisputeFileLink? _$v;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  DisputeFileLinkBuilder() {
    DisputeFileLink._defaults(this);
  }

  DisputeFileLinkBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _url = $v.url;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeFileLink other) {
    _$v = other as _$DisputeFileLink;
  }

  @override
  void update(void Function(DisputeFileLinkBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeFileLink build() => _build();

  _$DisputeFileLink _build() {
    final _$result = _$v ??
        _$DisputeFileLink._(
          url: BuiltValueNullFieldError.checkNotNull(
              url, r'DisputeFileLink', 'url'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'DisputeFileLink', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
