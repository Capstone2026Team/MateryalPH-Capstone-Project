// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_review_submit_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BuyerReviewSubmitRequestDisplayNameChoiceEnum
    _$buyerReviewSubmitRequestDisplayNameChoiceEnum_FIRST_NAME_LAST_INITIAL =
    const BuyerReviewSubmitRequestDisplayNameChoiceEnum._(
        'FIRST_NAME_LAST_INITIAL');
const BuyerReviewSubmitRequestDisplayNameChoiceEnum
    _$buyerReviewSubmitRequestDisplayNameChoiceEnum_VERIFIED_BUYER =
    const BuyerReviewSubmitRequestDisplayNameChoiceEnum._('VERIFIED_BUYER');

BuyerReviewSubmitRequestDisplayNameChoiceEnum
    _$buyerReviewSubmitRequestDisplayNameChoiceEnumValueOf(String name) {
  switch (name) {
    case 'FIRST_NAME_LAST_INITIAL':
      return _$buyerReviewSubmitRequestDisplayNameChoiceEnum_FIRST_NAME_LAST_INITIAL;
    case 'VERIFIED_BUYER':
      return _$buyerReviewSubmitRequestDisplayNameChoiceEnum_VERIFIED_BUYER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerReviewSubmitRequestDisplayNameChoiceEnum>
    _$buyerReviewSubmitRequestDisplayNameChoiceEnumValues = BuiltSet<
        BuyerReviewSubmitRequestDisplayNameChoiceEnum>(const <BuyerReviewSubmitRequestDisplayNameChoiceEnum>[
  _$buyerReviewSubmitRequestDisplayNameChoiceEnum_FIRST_NAME_LAST_INITIAL,
  _$buyerReviewSubmitRequestDisplayNameChoiceEnum_VERIFIED_BUYER,
]);

Serializer<BuyerReviewSubmitRequestDisplayNameChoiceEnum>
    _$buyerReviewSubmitRequestDisplayNameChoiceEnumSerializer =
    _$BuyerReviewSubmitRequestDisplayNameChoiceEnumSerializer();

class _$BuyerReviewSubmitRequestDisplayNameChoiceEnumSerializer
    implements
        PrimitiveSerializer<BuyerReviewSubmitRequestDisplayNameChoiceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'FIRST_NAME_LAST_INITIAL': 'FIRST_NAME_LAST_INITIAL',
    'VERIFIED_BUYER': 'VERIFIED_BUYER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'FIRST_NAME_LAST_INITIAL': 'FIRST_NAME_LAST_INITIAL',
    'VERIFIED_BUYER': 'VERIFIED_BUYER',
  };

  @override
  final Iterable<Type> types = const <Type>[
    BuyerReviewSubmitRequestDisplayNameChoiceEnum
  ];
  @override
  final String wireName = 'BuyerReviewSubmitRequestDisplayNameChoiceEnum';

  @override
  Object serialize(Serializers serializers,
          BuyerReviewSubmitRequestDisplayNameChoiceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerReviewSubmitRequestDisplayNameChoiceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerReviewSubmitRequestDisplayNameChoiceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BuyerReviewSubmitRequest extends BuyerReviewSubmitRequest {
  @override
  final BuyerReviewSubmitRequestDisplayNameChoiceEnum displayNameChoice;
  @override
  final BuyerReviewSubmitRequestVendorRating? vendorRating;
  @override
  final BuiltList<BuyerReviewSubmitRequestProductReviewsInner>? productReviews;

  factory _$BuyerReviewSubmitRequest(
          [void Function(BuyerReviewSubmitRequestBuilder)? updates]) =>
      (BuyerReviewSubmitRequestBuilder()..update(updates))._build();

  _$BuyerReviewSubmitRequest._(
      {required this.displayNameChoice, this.vendorRating, this.productReviews})
      : super._();
  @override
  BuyerReviewSubmitRequest rebuild(
          void Function(BuyerReviewSubmitRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerReviewSubmitRequestBuilder toBuilder() =>
      BuyerReviewSubmitRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerReviewSubmitRequest &&
        displayNameChoice == other.displayNameChoice &&
        vendorRating == other.vendorRating &&
        productReviews == other.productReviews;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, displayNameChoice.hashCode);
    _$hash = $jc(_$hash, vendorRating.hashCode);
    _$hash = $jc(_$hash, productReviews.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerReviewSubmitRequest')
          ..add('displayNameChoice', displayNameChoice)
          ..add('vendorRating', vendorRating)
          ..add('productReviews', productReviews))
        .toString();
  }
}

class BuyerReviewSubmitRequestBuilder
    implements
        Builder<BuyerReviewSubmitRequest, BuyerReviewSubmitRequestBuilder> {
  _$BuyerReviewSubmitRequest? _$v;

  BuyerReviewSubmitRequestDisplayNameChoiceEnum? _displayNameChoice;
  BuyerReviewSubmitRequestDisplayNameChoiceEnum? get displayNameChoice =>
      _$this._displayNameChoice;
  set displayNameChoice(
          BuyerReviewSubmitRequestDisplayNameChoiceEnum? displayNameChoice) =>
      _$this._displayNameChoice = displayNameChoice;

  BuyerReviewSubmitRequestVendorRatingBuilder? _vendorRating;
  BuyerReviewSubmitRequestVendorRatingBuilder get vendorRating =>
      _$this._vendorRating ??= BuyerReviewSubmitRequestVendorRatingBuilder();
  set vendorRating(BuyerReviewSubmitRequestVendorRatingBuilder? vendorRating) =>
      _$this._vendorRating = vendorRating;

  ListBuilder<BuyerReviewSubmitRequestProductReviewsInner>? _productReviews;
  ListBuilder<BuyerReviewSubmitRequestProductReviewsInner> get productReviews =>
      _$this._productReviews ??=
          ListBuilder<BuyerReviewSubmitRequestProductReviewsInner>();
  set productReviews(
          ListBuilder<BuyerReviewSubmitRequestProductReviewsInner>?
              productReviews) =>
      _$this._productReviews = productReviews;

  BuyerReviewSubmitRequestBuilder() {
    BuyerReviewSubmitRequest._defaults(this);
  }

  BuyerReviewSubmitRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _displayNameChoice = $v.displayNameChoice;
      _vendorRating = $v.vendorRating?.toBuilder();
      _productReviews = $v.productReviews?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerReviewSubmitRequest other) {
    _$v = other as _$BuyerReviewSubmitRequest;
  }

  @override
  void update(void Function(BuyerReviewSubmitRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerReviewSubmitRequest build() => _build();

  _$BuyerReviewSubmitRequest _build() {
    _$BuyerReviewSubmitRequest _$result;
    try {
      _$result = _$v ??
          _$BuyerReviewSubmitRequest._(
            displayNameChoice: BuiltValueNullFieldError.checkNotNull(
                displayNameChoice,
                r'BuyerReviewSubmitRequest',
                'displayNameChoice'),
            vendorRating: _vendorRating?.build(),
            productReviews: _productReviews?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'vendorRating';
        _vendorRating?.build();
        _$failedField = 'productReviews';
        _productReviews?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BuyerReviewSubmitRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
