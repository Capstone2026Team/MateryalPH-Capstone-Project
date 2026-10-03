// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nrpc_terms_ref.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NrpcTermsRef extends NrpcTermsRef {
  @override
  final String id;
  @override
  final int version;
  @override
  final String title;
  @override
  final bool available;

  factory _$NrpcTermsRef([void Function(NrpcTermsRefBuilder)? updates]) =>
      (NrpcTermsRefBuilder()..update(updates))._build();

  _$NrpcTermsRef._(
      {required this.id,
      required this.version,
      required this.title,
      required this.available})
      : super._();
  @override
  NrpcTermsRef rebuild(void Function(NrpcTermsRefBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NrpcTermsRefBuilder toBuilder() => NrpcTermsRefBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NrpcTermsRef &&
        id == other.id &&
        version == other.version &&
        title == other.title &&
        available == other.available;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NrpcTermsRef')
          ..add('id', id)
          ..add('version', version)
          ..add('title', title)
          ..add('available', available))
        .toString();
  }
}

class NrpcTermsRefBuilder
    implements Builder<NrpcTermsRef, NrpcTermsRefBuilder> {
  _$NrpcTermsRef? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  NrpcTermsRefBuilder() {
    NrpcTermsRef._defaults(this);
  }

  NrpcTermsRefBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _version = $v.version;
      _title = $v.title;
      _available = $v.available;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NrpcTermsRef other) {
    _$v = other as _$NrpcTermsRef;
  }

  @override
  void update(void Function(NrpcTermsRefBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NrpcTermsRef build() => _build();

  _$NrpcTermsRef _build() {
    final _$result = _$v ??
        _$NrpcTermsRef._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'NrpcTermsRef', 'id'),
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'NrpcTermsRef', 'version'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'NrpcTermsRef', 'title'),
          available: BuiltValueNullFieldError.checkNotNull(
              available, r'NrpcTermsRef', 'available'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
