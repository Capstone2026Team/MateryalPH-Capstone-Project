// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_vendor_profile_ratings_product.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DirectoryVendorProfileRatingsProduct
    extends DirectoryVendorProfileRatingsProduct {
  @override
  final int count;
  @override
  final String? average;

  factory _$DirectoryVendorProfileRatingsProduct(
          [void Function(DirectoryVendorProfileRatingsProductBuilder)?
              updates]) =>
      (DirectoryVendorProfileRatingsProductBuilder()..update(updates))._build();

  _$DirectoryVendorProfileRatingsProduct._({required this.count, this.average})
      : super._();
  @override
  DirectoryVendorProfileRatingsProduct rebuild(
          void Function(DirectoryVendorProfileRatingsProductBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectoryVendorProfileRatingsProductBuilder toBuilder() =>
      DirectoryVendorProfileRatingsProductBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectoryVendorProfileRatingsProduct &&
        count == other.count &&
        average == other.average;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jc(_$hash, average.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DirectoryVendorProfileRatingsProduct')
          ..add('count', count)
          ..add('average', average))
        .toString();
  }
}

class DirectoryVendorProfileRatingsProductBuilder
    implements
        Builder<DirectoryVendorProfileRatingsProduct,
            DirectoryVendorProfileRatingsProductBuilder> {
  _$DirectoryVendorProfileRatingsProduct? _$v;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  String? _average;
  String? get average => _$this._average;
  set average(String? average) => _$this._average = average;

  DirectoryVendorProfileRatingsProductBuilder() {
    DirectoryVendorProfileRatingsProduct._defaults(this);
  }

  DirectoryVendorProfileRatingsProductBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _count = $v.count;
      _average = $v.average;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DirectoryVendorProfileRatingsProduct other) {
    _$v = other as _$DirectoryVendorProfileRatingsProduct;
  }

  @override
  void update(
      void Function(DirectoryVendorProfileRatingsProductBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectoryVendorProfileRatingsProduct build() => _build();

  _$DirectoryVendorProfileRatingsProduct _build() {
    final _$result = _$v ??
        _$DirectoryVendorProfileRatingsProduct._(
          count: BuiltValueNullFieldError.checkNotNull(
              count, r'DirectoryVendorProfileRatingsProduct', 'count'),
          average: average,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
