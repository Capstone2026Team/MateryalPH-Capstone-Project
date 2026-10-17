// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_product.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReviewProduct extends ReviewProduct {
  @override
  final String listingId;
  @override
  final String name;
  @override
  final String? variantLabel;

  factory _$ReviewProduct([void Function(ReviewProductBuilder)? updates]) =>
      (ReviewProductBuilder()..update(updates))._build();

  _$ReviewProduct._(
      {required this.listingId, required this.name, this.variantLabel})
      : super._();
  @override
  ReviewProduct rebuild(void Function(ReviewProductBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReviewProductBuilder toBuilder() => ReviewProductBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReviewProduct &&
        listingId == other.listingId &&
        name == other.name &&
        variantLabel == other.variantLabel;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, listingId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, variantLabel.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReviewProduct')
          ..add('listingId', listingId)
          ..add('name', name)
          ..add('variantLabel', variantLabel))
        .toString();
  }
}

class ReviewProductBuilder
    implements Builder<ReviewProduct, ReviewProductBuilder> {
  _$ReviewProduct? _$v;

  String? _listingId;
  String? get listingId => _$this._listingId;
  set listingId(String? listingId) => _$this._listingId = listingId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _variantLabel;
  String? get variantLabel => _$this._variantLabel;
  set variantLabel(String? variantLabel) => _$this._variantLabel = variantLabel;

  ReviewProductBuilder() {
    ReviewProduct._defaults(this);
  }

  ReviewProductBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _listingId = $v.listingId;
      _name = $v.name;
      _variantLabel = $v.variantLabel;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReviewProduct other) {
    _$v = other as _$ReviewProduct;
  }

  @override
  void update(void Function(ReviewProductBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReviewProduct build() => _build();

  _$ReviewProduct _build() {
    final _$result = _$v ??
        _$ReviewProduct._(
          listingId: BuiltValueNullFieldError.checkNotNull(
              listingId, r'ReviewProduct', 'listingId'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ReviewProduct', 'name'),
          variantLabel: variantLabel,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
