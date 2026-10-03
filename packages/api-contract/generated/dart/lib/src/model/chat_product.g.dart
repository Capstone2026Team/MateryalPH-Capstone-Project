// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_product.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatProduct extends ChatProduct {
  @override
  final String productId;
  @override
  final String listingId;
  @override
  final String name;
  @override
  final int priceCentavos;
  @override
  final String? imageUrl;
  @override
  final bool available;

  factory _$ChatProduct([void Function(ChatProductBuilder)? updates]) =>
      (ChatProductBuilder()..update(updates))._build();

  _$ChatProduct._(
      {required this.productId,
      required this.listingId,
      required this.name,
      required this.priceCentavos,
      this.imageUrl,
      required this.available})
      : super._();
  @override
  ChatProduct rebuild(void Function(ChatProductBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatProductBuilder toBuilder() => ChatProductBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatProduct &&
        productId == other.productId &&
        listingId == other.listingId &&
        name == other.name &&
        priceCentavos == other.priceCentavos &&
        imageUrl == other.imageUrl &&
        available == other.available;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, productId.hashCode);
    _$hash = $jc(_$hash, listingId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, priceCentavos.hashCode);
    _$hash = $jc(_$hash, imageUrl.hashCode);
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatProduct')
          ..add('productId', productId)
          ..add('listingId', listingId)
          ..add('name', name)
          ..add('priceCentavos', priceCentavos)
          ..add('imageUrl', imageUrl)
          ..add('available', available))
        .toString();
  }
}

class ChatProductBuilder implements Builder<ChatProduct, ChatProductBuilder> {
  _$ChatProduct? _$v;

  String? _productId;
  String? get productId => _$this._productId;
  set productId(String? productId) => _$this._productId = productId;

  String? _listingId;
  String? get listingId => _$this._listingId;
  set listingId(String? listingId) => _$this._listingId = listingId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _priceCentavos;
  int? get priceCentavos => _$this._priceCentavos;
  set priceCentavos(int? priceCentavos) =>
      _$this._priceCentavos = priceCentavos;

  String? _imageUrl;
  String? get imageUrl => _$this._imageUrl;
  set imageUrl(String? imageUrl) => _$this._imageUrl = imageUrl;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  ChatProductBuilder() {
    ChatProduct._defaults(this);
  }

  ChatProductBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _productId = $v.productId;
      _listingId = $v.listingId;
      _name = $v.name;
      _priceCentavos = $v.priceCentavos;
      _imageUrl = $v.imageUrl;
      _available = $v.available;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatProduct other) {
    _$v = other as _$ChatProduct;
  }

  @override
  void update(void Function(ChatProductBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatProduct build() => _build();

  _$ChatProduct _build() {
    final _$result = _$v ??
        _$ChatProduct._(
          productId: BuiltValueNullFieldError.checkNotNull(
              productId, r'ChatProduct', 'productId'),
          listingId: BuiltValueNullFieldError.checkNotNull(
              listingId, r'ChatProduct', 'listingId'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ChatProduct', 'name'),
          priceCentavos: BuiltValueNullFieldError.checkNotNull(
              priceCentavos, r'ChatProduct', 'priceCentavos'),
          imageUrl: imageUrl,
          available: BuiltValueNullFieldError.checkNotNull(
              available, r'ChatProduct', 'available'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
