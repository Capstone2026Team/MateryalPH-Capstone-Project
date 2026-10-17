// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_earnings_products.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorEarningsProducts extends VendorEarningsProducts {
  @override
  final BuiltList<VendorEarningsProduct> items;
  @override
  final int total;
  @override
  final bool truncated;

  factory _$VendorEarningsProducts(
          [void Function(VendorEarningsProductsBuilder)? updates]) =>
      (VendorEarningsProductsBuilder()..update(updates))._build();

  _$VendorEarningsProducts._(
      {required this.items, required this.total, required this.truncated})
      : super._();
  @override
  VendorEarningsProducts rebuild(
          void Function(VendorEarningsProductsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorEarningsProductsBuilder toBuilder() =>
      VendorEarningsProductsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorEarningsProducts &&
        items == other.items &&
        total == other.total &&
        truncated == other.truncated;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, truncated.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorEarningsProducts')
          ..add('items', items)
          ..add('total', total)
          ..add('truncated', truncated))
        .toString();
  }
}

class VendorEarningsProductsBuilder
    implements Builder<VendorEarningsProducts, VendorEarningsProductsBuilder> {
  _$VendorEarningsProducts? _$v;

  ListBuilder<VendorEarningsProduct>? _items;
  ListBuilder<VendorEarningsProduct> get items =>
      _$this._items ??= ListBuilder<VendorEarningsProduct>();
  set items(ListBuilder<VendorEarningsProduct>? items) => _$this._items = items;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  bool? _truncated;
  bool? get truncated => _$this._truncated;
  set truncated(bool? truncated) => _$this._truncated = truncated;

  VendorEarningsProductsBuilder() {
    VendorEarningsProducts._defaults(this);
  }

  VendorEarningsProductsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _total = $v.total;
      _truncated = $v.truncated;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorEarningsProducts other) {
    _$v = other as _$VendorEarningsProducts;
  }

  @override
  void update(void Function(VendorEarningsProductsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorEarningsProducts build() => _build();

  _$VendorEarningsProducts _build() {
    _$VendorEarningsProducts _$result;
    try {
      _$result = _$v ??
          _$VendorEarningsProducts._(
            items: items.build(),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'VendorEarningsProducts', 'total'),
            truncated: BuiltValueNullFieldError.checkNotNull(
                truncated, r'VendorEarningsProducts', 'truncated'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorEarningsProducts', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
