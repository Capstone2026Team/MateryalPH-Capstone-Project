// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_listing_permissions.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CatalogListingPermissions extends CatalogListingPermissions {
  @override
  final bool canManage;
  @override
  final bool canSubmitCompliance;

  factory _$CatalogListingPermissions(
          [void Function(CatalogListingPermissionsBuilder)? updates]) =>
      (CatalogListingPermissionsBuilder()..update(updates))._build();

  _$CatalogListingPermissions._(
      {required this.canManage, required this.canSubmitCompliance})
      : super._();
  @override
  CatalogListingPermissions rebuild(
          void Function(CatalogListingPermissionsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogListingPermissionsBuilder toBuilder() =>
      CatalogListingPermissionsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogListingPermissions &&
        canManage == other.canManage &&
        canSubmitCompliance == other.canSubmitCompliance;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, canManage.hashCode);
    _$hash = $jc(_$hash, canSubmitCompliance.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogListingPermissions')
          ..add('canManage', canManage)
          ..add('canSubmitCompliance', canSubmitCompliance))
        .toString();
  }
}

class CatalogListingPermissionsBuilder
    implements
        Builder<CatalogListingPermissions, CatalogListingPermissionsBuilder> {
  _$CatalogListingPermissions? _$v;

  bool? _canManage;
  bool? get canManage => _$this._canManage;
  set canManage(bool? canManage) => _$this._canManage = canManage;

  bool? _canSubmitCompliance;
  bool? get canSubmitCompliance => _$this._canSubmitCompliance;
  set canSubmitCompliance(bool? canSubmitCompliance) =>
      _$this._canSubmitCompliance = canSubmitCompliance;

  CatalogListingPermissionsBuilder() {
    CatalogListingPermissions._defaults(this);
  }

  CatalogListingPermissionsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _canManage = $v.canManage;
      _canSubmitCompliance = $v.canSubmitCompliance;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogListingPermissions other) {
    _$v = other as _$CatalogListingPermissions;
  }

  @override
  void update(void Function(CatalogListingPermissionsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogListingPermissions build() => _build();

  _$CatalogListingPermissions _build() {
    final _$result = _$v ??
        _$CatalogListingPermissions._(
          canManage: BuiltValueNullFieldError.checkNotNull(
              canManage, r'CatalogListingPermissions', 'canManage'),
          canSubmitCompliance: BuiltValueNullFieldError.checkNotNull(
              canSubmitCompliance,
              r'CatalogListingPermissions',
              'canSubmitCompliance'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
