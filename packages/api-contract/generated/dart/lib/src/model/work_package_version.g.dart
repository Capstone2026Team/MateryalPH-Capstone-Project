// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_package_version.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WorkPackageVersion extends WorkPackageVersion {
  @override
  final String id;
  @override
  final int version;
  @override
  final String contentHash;
  @override
  final String? lockedAt;
  @override
  final BuiltMap<String, JsonObject?> content;

  factory _$WorkPackageVersion(
          [void Function(WorkPackageVersionBuilder)? updates]) =>
      (WorkPackageVersionBuilder()..update(updates))._build();

  _$WorkPackageVersion._(
      {required this.id,
      required this.version,
      required this.contentHash,
      this.lockedAt,
      required this.content})
      : super._();
  @override
  WorkPackageVersion rebuild(
          void Function(WorkPackageVersionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WorkPackageVersionBuilder toBuilder() =>
      WorkPackageVersionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WorkPackageVersion &&
        id == other.id &&
        version == other.version &&
        contentHash == other.contentHash &&
        lockedAt == other.lockedAt &&
        content == other.content;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, contentHash.hashCode);
    _$hash = $jc(_$hash, lockedAt.hashCode);
    _$hash = $jc(_$hash, content.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WorkPackageVersion')
          ..add('id', id)
          ..add('version', version)
          ..add('contentHash', contentHash)
          ..add('lockedAt', lockedAt)
          ..add('content', content))
        .toString();
  }
}

class WorkPackageVersionBuilder
    implements Builder<WorkPackageVersion, WorkPackageVersionBuilder> {
  _$WorkPackageVersion? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  String? _contentHash;
  String? get contentHash => _$this._contentHash;
  set contentHash(String? contentHash) => _$this._contentHash = contentHash;

  String? _lockedAt;
  String? get lockedAt => _$this._lockedAt;
  set lockedAt(String? lockedAt) => _$this._lockedAt = lockedAt;

  MapBuilder<String, JsonObject?>? _content;
  MapBuilder<String, JsonObject?> get content =>
      _$this._content ??= MapBuilder<String, JsonObject?>();
  set content(MapBuilder<String, JsonObject?>? content) =>
      _$this._content = content;

  WorkPackageVersionBuilder() {
    WorkPackageVersion._defaults(this);
  }

  WorkPackageVersionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _version = $v.version;
      _contentHash = $v.contentHash;
      _lockedAt = $v.lockedAt;
      _content = $v.content.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WorkPackageVersion other) {
    _$v = other as _$WorkPackageVersion;
  }

  @override
  void update(void Function(WorkPackageVersionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WorkPackageVersion build() => _build();

  _$WorkPackageVersion _build() {
    _$WorkPackageVersion _$result;
    try {
      _$result = _$v ??
          _$WorkPackageVersion._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'WorkPackageVersion', 'id'),
            version: BuiltValueNullFieldError.checkNotNull(
                version, r'WorkPackageVersion', 'version'),
            contentHash: BuiltValueNullFieldError.checkNotNull(
                contentHash, r'WorkPackageVersion', 'contentHash'),
            lockedAt: lockedAt,
            content: content.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'content';
        content.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WorkPackageVersion', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
