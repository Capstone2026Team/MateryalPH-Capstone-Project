// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_vendor_profile_ratings.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DirectoryVendorProfileRatings extends DirectoryVendorProfileRatings {
  @override
  final DirectoryVendorProfileRatingsStore store;
  @override
  final DirectoryVendorProfileRatingsProduct product;

  factory _$DirectoryVendorProfileRatings(
          [void Function(DirectoryVendorProfileRatingsBuilder)? updates]) =>
      (DirectoryVendorProfileRatingsBuilder()..update(updates))._build();

  _$DirectoryVendorProfileRatings._(
      {required this.store, required this.product})
      : super._();
  @override
  DirectoryVendorProfileRatings rebuild(
          void Function(DirectoryVendorProfileRatingsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectoryVendorProfileRatingsBuilder toBuilder() =>
      DirectoryVendorProfileRatingsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectoryVendorProfileRatings &&
        store == other.store &&
        product == other.product;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, store.hashCode);
    _$hash = $jc(_$hash, product.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DirectoryVendorProfileRatings')
          ..add('store', store)
          ..add('product', product))
        .toString();
  }
}

class DirectoryVendorProfileRatingsBuilder
    implements
        Builder<DirectoryVendorProfileRatings,
            DirectoryVendorProfileRatingsBuilder> {
  _$DirectoryVendorProfileRatings? _$v;

  DirectoryVendorProfileRatingsStoreBuilder? _store;
  DirectoryVendorProfileRatingsStoreBuilder get store =>
      _$this._store ??= DirectoryVendorProfileRatingsStoreBuilder();
  set store(DirectoryVendorProfileRatingsStoreBuilder? store) =>
      _$this._store = store;

  DirectoryVendorProfileRatingsProductBuilder? _product;
  DirectoryVendorProfileRatingsProductBuilder get product =>
      _$this._product ??= DirectoryVendorProfileRatingsProductBuilder();
  set product(DirectoryVendorProfileRatingsProductBuilder? product) =>
      _$this._product = product;

  DirectoryVendorProfileRatingsBuilder() {
    DirectoryVendorProfileRatings._defaults(this);
  }

  DirectoryVendorProfileRatingsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _store = $v.store.toBuilder();
      _product = $v.product.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DirectoryVendorProfileRatings other) {
    _$v = other as _$DirectoryVendorProfileRatings;
  }

  @override
  void update(void Function(DirectoryVendorProfileRatingsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectoryVendorProfileRatings build() => _build();

  _$DirectoryVendorProfileRatings _build() {
    _$DirectoryVendorProfileRatings _$result;
    try {
      _$result = _$v ??
          _$DirectoryVendorProfileRatings._(
            store: store.build(),
            product: product.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'store';
        store.build();
        _$failedField = 'product';
        product.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DirectoryVendorProfileRatings', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
