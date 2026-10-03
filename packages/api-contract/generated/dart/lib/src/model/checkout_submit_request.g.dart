// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_submit_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CheckoutSubmitRequestPaymentMethodsEnum
    _$checkoutSubmitRequestPaymentMethodsEnum_ONLINE =
    const CheckoutSubmitRequestPaymentMethodsEnum._('ONLINE');
const CheckoutSubmitRequestPaymentMethodsEnum
    _$checkoutSubmitRequestPaymentMethodsEnum_CASH_ON_DELIVERY =
    const CheckoutSubmitRequestPaymentMethodsEnum._('CASH_ON_DELIVERY');
const CheckoutSubmitRequestPaymentMethodsEnum
    _$checkoutSubmitRequestPaymentMethodsEnum_IN_STORE =
    const CheckoutSubmitRequestPaymentMethodsEnum._('IN_STORE');

CheckoutSubmitRequestPaymentMethodsEnum
    _$checkoutSubmitRequestPaymentMethodsEnumValueOf(String name) {
  switch (name) {
    case 'ONLINE':
      return _$checkoutSubmitRequestPaymentMethodsEnum_ONLINE;
    case 'CASH_ON_DELIVERY':
      return _$checkoutSubmitRequestPaymentMethodsEnum_CASH_ON_DELIVERY;
    case 'IN_STORE':
      return _$checkoutSubmitRequestPaymentMethodsEnum_IN_STORE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CheckoutSubmitRequestPaymentMethodsEnum>
    _$checkoutSubmitRequestPaymentMethodsEnumValues = BuiltSet<
        CheckoutSubmitRequestPaymentMethodsEnum>(const <CheckoutSubmitRequestPaymentMethodsEnum>[
  _$checkoutSubmitRequestPaymentMethodsEnum_ONLINE,
  _$checkoutSubmitRequestPaymentMethodsEnum_CASH_ON_DELIVERY,
  _$checkoutSubmitRequestPaymentMethodsEnum_IN_STORE,
]);

Serializer<CheckoutSubmitRequestPaymentMethodsEnum>
    _$checkoutSubmitRequestPaymentMethodsEnumSerializer =
    _$CheckoutSubmitRequestPaymentMethodsEnumSerializer();

class _$CheckoutSubmitRequestPaymentMethodsEnumSerializer
    implements PrimitiveSerializer<CheckoutSubmitRequestPaymentMethodsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ONLINE': 'ONLINE',
    'CASH_ON_DELIVERY': 'CASH_ON_DELIVERY',
    'IN_STORE': 'IN_STORE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ONLINE': 'ONLINE',
    'CASH_ON_DELIVERY': 'CASH_ON_DELIVERY',
    'IN_STORE': 'IN_STORE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CheckoutSubmitRequestPaymentMethodsEnum
  ];
  @override
  final String wireName = 'CheckoutSubmitRequestPaymentMethodsEnum';

  @override
  Object serialize(Serializers serializers,
          CheckoutSubmitRequestPaymentMethodsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CheckoutSubmitRequestPaymentMethodsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CheckoutSubmitRequestPaymentMethodsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CheckoutSubmitRequest extends CheckoutSubmitRequest {
  @override
  final int cartLockVersion;
  @override
  final BuiltSet<String> vendorIds;
  @override
  final bool? splitConfirmed;
  @override
  final BuiltMap<String, CheckoutSubmitRequestPaymentMethodsEnum>?
      paymentMethods;

  factory _$CheckoutSubmitRequest(
          [void Function(CheckoutSubmitRequestBuilder)? updates]) =>
      (CheckoutSubmitRequestBuilder()..update(updates))._build();

  _$CheckoutSubmitRequest._(
      {required this.cartLockVersion,
      required this.vendorIds,
      this.splitConfirmed,
      this.paymentMethods})
      : super._();
  @override
  CheckoutSubmitRequest rebuild(
          void Function(CheckoutSubmitRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CheckoutSubmitRequestBuilder toBuilder() =>
      CheckoutSubmitRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CheckoutSubmitRequest &&
        cartLockVersion == other.cartLockVersion &&
        vendorIds == other.vendorIds &&
        splitConfirmed == other.splitConfirmed &&
        paymentMethods == other.paymentMethods;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cartLockVersion.hashCode);
    _$hash = $jc(_$hash, vendorIds.hashCode);
    _$hash = $jc(_$hash, splitConfirmed.hashCode);
    _$hash = $jc(_$hash, paymentMethods.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CheckoutSubmitRequest')
          ..add('cartLockVersion', cartLockVersion)
          ..add('vendorIds', vendorIds)
          ..add('splitConfirmed', splitConfirmed)
          ..add('paymentMethods', paymentMethods))
        .toString();
  }
}

class CheckoutSubmitRequestBuilder
    implements Builder<CheckoutSubmitRequest, CheckoutSubmitRequestBuilder> {
  _$CheckoutSubmitRequest? _$v;

  int? _cartLockVersion;
  int? get cartLockVersion => _$this._cartLockVersion;
  set cartLockVersion(int? cartLockVersion) =>
      _$this._cartLockVersion = cartLockVersion;

  SetBuilder<String>? _vendorIds;
  SetBuilder<String> get vendorIds =>
      _$this._vendorIds ??= SetBuilder<String>();
  set vendorIds(SetBuilder<String>? vendorIds) => _$this._vendorIds = vendorIds;

  bool? _splitConfirmed;
  bool? get splitConfirmed => _$this._splitConfirmed;
  set splitConfirmed(bool? splitConfirmed) =>
      _$this._splitConfirmed = splitConfirmed;

  MapBuilder<String, CheckoutSubmitRequestPaymentMethodsEnum>? _paymentMethods;
  MapBuilder<String, CheckoutSubmitRequestPaymentMethodsEnum>
      get paymentMethods => _$this._paymentMethods ??=
          MapBuilder<String, CheckoutSubmitRequestPaymentMethodsEnum>();
  set paymentMethods(
          MapBuilder<String, CheckoutSubmitRequestPaymentMethodsEnum>?
              paymentMethods) =>
      _$this._paymentMethods = paymentMethods;

  CheckoutSubmitRequestBuilder() {
    CheckoutSubmitRequest._defaults(this);
  }

  CheckoutSubmitRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cartLockVersion = $v.cartLockVersion;
      _vendorIds = $v.vendorIds.toBuilder();
      _splitConfirmed = $v.splitConfirmed;
      _paymentMethods = $v.paymentMethods?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CheckoutSubmitRequest other) {
    _$v = other as _$CheckoutSubmitRequest;
  }

  @override
  void update(void Function(CheckoutSubmitRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CheckoutSubmitRequest build() => _build();

  _$CheckoutSubmitRequest _build() {
    _$CheckoutSubmitRequest _$result;
    try {
      _$result = _$v ??
          _$CheckoutSubmitRequest._(
            cartLockVersion: BuiltValueNullFieldError.checkNotNull(
                cartLockVersion, r'CheckoutSubmitRequest', 'cartLockVersion'),
            vendorIds: vendorIds.build(),
            splitConfirmed: splitConfirmed,
            paymentMethods: _paymentMethods?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'vendorIds';
        vendorIds.build();

        _$failedField = 'paymentMethods';
        _paymentMethods?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CheckoutSubmitRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
