// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_listing_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CatalogListingCreate extends CatalogListingCreate {
  @override
  final String displayName;
  @override
  final String vendorSku;

  factory _$CatalogListingCreate(
          [void Function(CatalogListingCreateBuilder)? updates]) =>
      (CatalogListingCreateBuilder()..update(updates))._build();

  _$CatalogListingCreate._({required this.displayName, required this.vendorSku})
      : super._();
  @override
  CatalogListingCreate rebuild(
          void Function(CatalogListingCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CatalogListingCreateBuilder toBuilder() =>
      CatalogListingCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CatalogListingCreate &&
        displayName == other.displayName &&
        vendorSku == other.vendorSku;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, vendorSku.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CatalogListingCreate')
          ..add('displayName', displayName)
          ..add('vendorSku', vendorSku))
        .toString();
  }
}

class CatalogListingCreateBuilder
    implements Builder<CatalogListingCreate, CatalogListingCreateBuilder> {
  _$CatalogListingCreate? _$v;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _vendorSku;
  String? get vendorSku => _$this._vendorSku;
  set vendorSku(String? vendorSku) => _$this._vendorSku = vendorSku;

  CatalogListingCreateBuilder() {
    CatalogListingCreate._defaults(this);
  }

  CatalogListingCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _displayName = $v.displayName;
      _vendorSku = $v.vendorSku;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CatalogListingCreate other) {
    _$v = other as _$CatalogListingCreate;
  }

  @override
  void update(void Function(CatalogListingCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CatalogListingCreate build() => _build();

  _$CatalogListingCreate _build() {
    final _$result = _$v ??
        _$CatalogListingCreate._(
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'CatalogListingCreate', 'displayName'),
          vendorSku: BuiltValueNullFieldError.checkNotNull(
              vendorSku, r'CatalogListingCreate', 'vendorSku'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
