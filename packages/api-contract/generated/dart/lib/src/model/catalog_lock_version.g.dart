// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_lock_version.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CatalogLockVersion extends CatalogLockVersion {
  @override
  final int lockVersion;

  factory _$CatalogLockVersion(
          [void Function(CatalogLockVersionBuilder)? updates]) =>
      (CatalogLockVersionBuilder()..update(updates))._build();

  _$CatalogLockVersion._({required this.lockVersion}) : super._();
  @override
  CatalogLockVersion rebuild(
          void Function(CatalogLockVersionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogLockVersionBuilder toBuilder() =>
      CatalogLockVersionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogLockVersion && lockVersion == other.lockVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogLockVersion')
          ..add('lockVersion', lockVersion))
        .toString();
  }
}

class CatalogLockVersionBuilder
    implements Builder<CatalogLockVersion, CatalogLockVersionBuilder> {
  _$CatalogLockVersion? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  CatalogLockVersionBuilder() {
    CatalogLockVersion._defaults(this);
  }

  CatalogLockVersionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogLockVersion other) {
    _$v = other as _$CatalogLockVersion;
  }

  @override
  void update(void Function(CatalogLockVersionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogLockVersion build() => _build();

  _$CatalogLockVersion _build() {
    final _$result = _$v ??
        _$CatalogLockVersion._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'CatalogLockVersion', 'lockVersion'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
