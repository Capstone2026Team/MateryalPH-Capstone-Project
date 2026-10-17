// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_delivery_preview_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProductDeliveryPreviewRequest extends ProductDeliveryPreviewRequest {
  @override
  final String listingVariantId;
  @override
  final String quantity;

  factory _$ProductDeliveryPreviewRequest(
          [void Function(ProductDeliveryPreviewRequestBuilder)? updates]) =>
      (ProductDeliveryPreviewRequestBuilder()..update(updates))._build();

  _$ProductDeliveryPreviewRequest._(
      {required this.listingVariantId, required this.quantity})
      : super._();
  @override
  ProductDeliveryPreviewRequest rebuild(
          void Function(ProductDeliveryPreviewRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProductDeliveryPreviewRequestBuilder toBuilder() =>
      ProductDeliveryPreviewRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProductDeliveryPreviewRequest &&
        listingVariantId == other.listingVariantId &&
        quantity == other.quantity;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, listingVariantId.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProductDeliveryPreviewRequest')
          ..add('listingVariantId', listingVariantId)
          ..add('quantity', quantity))
        .toString();
  }
}

class ProductDeliveryPreviewRequestBuilder
    implements
        Builder<ProductDeliveryPreviewRequest,
            ProductDeliveryPreviewRequestBuilder> {
  _$ProductDeliveryPreviewRequest? _$v;

  String? _listingVariantId;
  String? get listingVariantId => _$this._listingVariantId;
  set listingVariantId(String? listingVariantId) =>
      _$this._listingVariantId = listingVariantId;

  String? _quantity;
  String? get quantity => _$this._quantity;
  set quantity(String? quantity) => _$this._quantity = quantity;

  ProductDeliveryPreviewRequestBuilder() {
    ProductDeliveryPreviewRequest._defaults(this);
  }

  ProductDeliveryPreviewRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _listingVariantId = $v.listingVariantId;
      _quantity = $v.quantity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProductDeliveryPreviewRequest other) {
    _$v = other as _$ProductDeliveryPreviewRequest;
  }

  @override
  void update(void Function(ProductDeliveryPreviewRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProductDeliveryPreviewRequest build() => _build();

  _$ProductDeliveryPreviewRequest _build() {
    final _$result = _$v ??
        _$ProductDeliveryPreviewRequest._(
          listingVariantId: BuiltValueNullFieldError.checkNotNull(
              listingVariantId,
              r'ProductDeliveryPreviewRequest',
              'listingVariantId'),
          quantity: BuiltValueNullFieldError.checkNotNull(
              quantity, r'ProductDeliveryPreviewRequest', 'quantity'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
