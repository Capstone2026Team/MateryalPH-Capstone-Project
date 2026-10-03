// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_child_order.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CheckoutChildOrderFulfillmentMethodEnum
    _$checkoutChildOrderFulfillmentMethodEnum_DELIVERY =
    const CheckoutChildOrderFulfillmentMethodEnum._('DELIVERY');
const CheckoutChildOrderFulfillmentMethodEnum
    _$checkoutChildOrderFulfillmentMethodEnum_PICKUP =
    const CheckoutChildOrderFulfillmentMethodEnum._('PICKUP');

CheckoutChildOrderFulfillmentMethodEnum
    _$checkoutChildOrderFulfillmentMethodEnumValueOf(String name) {
  switch (name) {
    case 'DELIVERY':
      return _$checkoutChildOrderFulfillmentMethodEnum_DELIVERY;
    case 'PICKUP':
      return _$checkoutChildOrderFulfillmentMethodEnum_PICKUP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CheckoutChildOrderFulfillmentMethodEnum>
    _$checkoutChildOrderFulfillmentMethodEnumValues = BuiltSet<
        CheckoutChildOrderFulfillmentMethodEnum>(const <CheckoutChildOrderFulfillmentMethodEnum>[
  _$checkoutChildOrderFulfillmentMethodEnum_DELIVERY,
  _$checkoutChildOrderFulfillmentMethodEnum_PICKUP,
]);

const CheckoutChildOrderPaymentMethodEnum
    _$checkoutChildOrderPaymentMethodEnum_ONLINE =
    const CheckoutChildOrderPaymentMethodEnum._('ONLINE');
const CheckoutChildOrderPaymentMethodEnum
    _$checkoutChildOrderPaymentMethodEnum_CASH_ON_DELIVERY =
    const CheckoutChildOrderPaymentMethodEnum._('CASH_ON_DELIVERY');
const CheckoutChildOrderPaymentMethodEnum
    _$checkoutChildOrderPaymentMethodEnum_IN_STORE =
    const CheckoutChildOrderPaymentMethodEnum._('IN_STORE');

CheckoutChildOrderPaymentMethodEnum
    _$checkoutChildOrderPaymentMethodEnumValueOf(String name) {
  switch (name) {
    case 'ONLINE':
      return _$checkoutChildOrderPaymentMethodEnum_ONLINE;
    case 'CASH_ON_DELIVERY':
      return _$checkoutChildOrderPaymentMethodEnum_CASH_ON_DELIVERY;
    case 'IN_STORE':
      return _$checkoutChildOrderPaymentMethodEnum_IN_STORE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CheckoutChildOrderPaymentMethodEnum>
    _$checkoutChildOrderPaymentMethodEnumValues = BuiltSet<
        CheckoutChildOrderPaymentMethodEnum>(const <CheckoutChildOrderPaymentMethodEnum>[
  _$checkoutChildOrderPaymentMethodEnum_ONLINE,
  _$checkoutChildOrderPaymentMethodEnum_CASH_ON_DELIVERY,
  _$checkoutChildOrderPaymentMethodEnum_IN_STORE,
]);

const CheckoutChildOrderConfirmationSourceEnum
    _$checkoutChildOrderConfirmationSourceEnum_MANUAL =
    const CheckoutChildOrderConfirmationSourceEnum._('MANUAL');
const CheckoutChildOrderConfirmationSourceEnum
    _$checkoutChildOrderConfirmationSourceEnum_AUTO_ACCEPT =
    const CheckoutChildOrderConfirmationSourceEnum._('AUTO_ACCEPT');

CheckoutChildOrderConfirmationSourceEnum
    _$checkoutChildOrderConfirmationSourceEnumValueOf(String name) {
  switch (name) {
    case 'MANUAL':
      return _$checkoutChildOrderConfirmationSourceEnum_MANUAL;
    case 'AUTO_ACCEPT':
      return _$checkoutChildOrderConfirmationSourceEnum_AUTO_ACCEPT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CheckoutChildOrderConfirmationSourceEnum>
    _$checkoutChildOrderConfirmationSourceEnumValues = BuiltSet<
        CheckoutChildOrderConfirmationSourceEnum>(const <CheckoutChildOrderConfirmationSourceEnum>[
  _$checkoutChildOrderConfirmationSourceEnum_MANUAL,
  _$checkoutChildOrderConfirmationSourceEnum_AUTO_ACCEPT,
]);

Serializer<CheckoutChildOrderFulfillmentMethodEnum>
    _$checkoutChildOrderFulfillmentMethodEnumSerializer =
    _$CheckoutChildOrderFulfillmentMethodEnumSerializer();
Serializer<CheckoutChildOrderPaymentMethodEnum>
    _$checkoutChildOrderPaymentMethodEnumSerializer =
    _$CheckoutChildOrderPaymentMethodEnumSerializer();
Serializer<CheckoutChildOrderConfirmationSourceEnum>
    _$checkoutChildOrderConfirmationSourceEnumSerializer =
    _$CheckoutChildOrderConfirmationSourceEnumSerializer();

class _$CheckoutChildOrderFulfillmentMethodEnumSerializer
    implements PrimitiveSerializer<CheckoutChildOrderFulfillmentMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DELIVERY': 'DELIVERY',
    'PICKUP': 'PICKUP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DELIVERY': 'DELIVERY',
    'PICKUP': 'PICKUP',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CheckoutChildOrderFulfillmentMethodEnum
  ];
  @override
  final String wireName = 'CheckoutChildOrderFulfillmentMethodEnum';

  @override
  Object serialize(Serializers serializers,
          CheckoutChildOrderFulfillmentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CheckoutChildOrderFulfillmentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CheckoutChildOrderFulfillmentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CheckoutChildOrderPaymentMethodEnumSerializer
    implements PrimitiveSerializer<CheckoutChildOrderPaymentMethodEnum> {
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
    CheckoutChildOrderPaymentMethodEnum
  ];
  @override
  final String wireName = 'CheckoutChildOrderPaymentMethodEnum';

  @override
  Object serialize(
          Serializers serializers, CheckoutChildOrderPaymentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CheckoutChildOrderPaymentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CheckoutChildOrderPaymentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CheckoutChildOrderConfirmationSourceEnumSerializer
    implements PrimitiveSerializer<CheckoutChildOrderConfirmationSourceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'MANUAL': 'MANUAL',
    'AUTO_ACCEPT': 'AUTO_ACCEPT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'MANUAL': 'MANUAL',
    'AUTO_ACCEPT': 'AUTO_ACCEPT',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CheckoutChildOrderConfirmationSourceEnum
  ];
  @override
  final String wireName = 'CheckoutChildOrderConfirmationSourceEnum';

  @override
  Object serialize(Serializers serializers,
          CheckoutChildOrderConfirmationSourceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CheckoutChildOrderConfirmationSourceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CheckoutChildOrderConfirmationSourceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CheckoutChildOrder extends CheckoutChildOrder {
  @override
  final String id;
  @override
  final String reference;
  @override
  final OrderVendorRef vendor;
  @override
  final OrderState orderState;
  @override
  final OrderPaymentState paymentState;
  @override
  final CheckoutChildOrderFulfillmentMethodEnum fulfillmentMethod;
  @override
  final CheckoutChildOrderPaymentMethodEnum paymentMethod;
  @override
  final CheckoutChildOrderConfirmationSourceEnum? confirmationSource;
  @override
  final int materialsCentavos;
  @override
  final int? deliveryCentavos;
  @override
  final int commercialTotalCentavos;
  @override
  final DateTime? vendorResponseDueAt;
  @override
  final DateTime? paymentExpiresAt;

  factory _$CheckoutChildOrder(
          [void Function(CheckoutChildOrderBuilder)? updates]) =>
      (CheckoutChildOrderBuilder()..update(updates))._build();

  _$CheckoutChildOrder._(
      {required this.id,
      required this.reference,
      required this.vendor,
      required this.orderState,
      required this.paymentState,
      required this.fulfillmentMethod,
      required this.paymentMethod,
      this.confirmationSource,
      required this.materialsCentavos,
      this.deliveryCentavos,
      required this.commercialTotalCentavos,
      this.vendorResponseDueAt,
      this.paymentExpiresAt})
      : super._();
  @override
  CheckoutChildOrder rebuild(
          void Function(CheckoutChildOrderBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CheckoutChildOrderBuilder toBuilder() =>
      CheckoutChildOrderBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CheckoutChildOrder &&
        id == other.id &&
        reference == other.reference &&
        vendor == other.vendor &&
        orderState == other.orderState &&
        paymentState == other.paymentState &&
        fulfillmentMethod == other.fulfillmentMethod &&
        paymentMethod == other.paymentMethod &&
        confirmationSource == other.confirmationSource &&
        materialsCentavos == other.materialsCentavos &&
        deliveryCentavos == other.deliveryCentavos &&
        commercialTotalCentavos == other.commercialTotalCentavos &&
        vendorResponseDueAt == other.vendorResponseDueAt &&
        paymentExpiresAt == other.paymentExpiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, vendor.hashCode);
    _$hash = $jc(_$hash, orderState.hashCode);
    _$hash = $jc(_$hash, paymentState.hashCode);
    _$hash = $jc(_$hash, fulfillmentMethod.hashCode);
    _$hash = $jc(_$hash, paymentMethod.hashCode);
    _$hash = $jc(_$hash, confirmationSource.hashCode);
    _$hash = $jc(_$hash, materialsCentavos.hashCode);
    _$hash = $jc(_$hash, deliveryCentavos.hashCode);
    _$hash = $jc(_$hash, commercialTotalCentavos.hashCode);
    _$hash = $jc(_$hash, vendorResponseDueAt.hashCode);
    _$hash = $jc(_$hash, paymentExpiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CheckoutChildOrder')
          ..add('id', id)
          ..add('reference', reference)
          ..add('vendor', vendor)
          ..add('orderState', orderState)
          ..add('paymentState', paymentState)
          ..add('fulfillmentMethod', fulfillmentMethod)
          ..add('paymentMethod', paymentMethod)
          ..add('confirmationSource', confirmationSource)
          ..add('materialsCentavos', materialsCentavos)
          ..add('deliveryCentavos', deliveryCentavos)
          ..add('commercialTotalCentavos', commercialTotalCentavos)
          ..add('vendorResponseDueAt', vendorResponseDueAt)
          ..add('paymentExpiresAt', paymentExpiresAt))
        .toString();
  }
}

class CheckoutChildOrderBuilder
    implements Builder<CheckoutChildOrder, CheckoutChildOrderBuilder> {
  _$CheckoutChildOrder? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  OrderVendorRefBuilder? _vendor;
  OrderVendorRefBuilder get vendor =>
      _$this._vendor ??= OrderVendorRefBuilder();
  set vendor(OrderVendorRefBuilder? vendor) => _$this._vendor = vendor;

  OrderState? _orderState;
  OrderState? get orderState => _$this._orderState;
  set orderState(OrderState? orderState) => _$this._orderState = orderState;

  OrderPaymentState? _paymentState;
  OrderPaymentState? get paymentState => _$this._paymentState;
  set paymentState(OrderPaymentState? paymentState) =>
      _$this._paymentState = paymentState;

  CheckoutChildOrderFulfillmentMethodEnum? _fulfillmentMethod;
  CheckoutChildOrderFulfillmentMethodEnum? get fulfillmentMethod =>
      _$this._fulfillmentMethod;
  set fulfillmentMethod(
          CheckoutChildOrderFulfillmentMethodEnum? fulfillmentMethod) =>
      _$this._fulfillmentMethod = fulfillmentMethod;

  CheckoutChildOrderPaymentMethodEnum? _paymentMethod;
  CheckoutChildOrderPaymentMethodEnum? get paymentMethod =>
      _$this._paymentMethod;
  set paymentMethod(CheckoutChildOrderPaymentMethodEnum? paymentMethod) =>
      _$this._paymentMethod = paymentMethod;

  CheckoutChildOrderConfirmationSourceEnum? _confirmationSource;
  CheckoutChildOrderConfirmationSourceEnum? get confirmationSource =>
      _$this._confirmationSource;
  set confirmationSource(
          CheckoutChildOrderConfirmationSourceEnum? confirmationSource) =>
      _$this._confirmationSource = confirmationSource;

  int? _materialsCentavos;
  int? get materialsCentavos => _$this._materialsCentavos;
  set materialsCentavos(int? materialsCentavos) =>
      _$this._materialsCentavos = materialsCentavos;

  int? _deliveryCentavos;
  int? get deliveryCentavos => _$this._deliveryCentavos;
  set deliveryCentavos(int? deliveryCentavos) =>
      _$this._deliveryCentavos = deliveryCentavos;

  int? _commercialTotalCentavos;
  int? get commercialTotalCentavos => _$this._commercialTotalCentavos;
  set commercialTotalCentavos(int? commercialTotalCentavos) =>
      _$this._commercialTotalCentavos = commercialTotalCentavos;

  DateTime? _vendorResponseDueAt;
  DateTime? get vendorResponseDueAt => _$this._vendorResponseDueAt;
  set vendorResponseDueAt(DateTime? vendorResponseDueAt) =>
      _$this._vendorResponseDueAt = vendorResponseDueAt;

  DateTime? _paymentExpiresAt;
  DateTime? get paymentExpiresAt => _$this._paymentExpiresAt;
  set paymentExpiresAt(DateTime? paymentExpiresAt) =>
      _$this._paymentExpiresAt = paymentExpiresAt;

  CheckoutChildOrderBuilder() {
    CheckoutChildOrder._defaults(this);
  }

  CheckoutChildOrderBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _reference = $v.reference;
      _vendor = $v.vendor.toBuilder();
      _orderState = $v.orderState;
      _paymentState = $v.paymentState;
      _fulfillmentMethod = $v.fulfillmentMethod;
      _paymentMethod = $v.paymentMethod;
      _confirmationSource = $v.confirmationSource;
      _materialsCentavos = $v.materialsCentavos;
      _deliveryCentavos = $v.deliveryCentavos;
      _commercialTotalCentavos = $v.commercialTotalCentavos;
      _vendorResponseDueAt = $v.vendorResponseDueAt;
      _paymentExpiresAt = $v.paymentExpiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CheckoutChildOrder other) {
    _$v = other as _$CheckoutChildOrder;
  }

  @override
  void update(void Function(CheckoutChildOrderBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CheckoutChildOrder build() => _build();

  _$CheckoutChildOrder _build() {
    _$CheckoutChildOrder _$result;
    try {
      _$result = _$v ??
          _$CheckoutChildOrder._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'CheckoutChildOrder', 'id'),
            reference: BuiltValueNullFieldError.checkNotNull(
                reference, r'CheckoutChildOrder', 'reference'),
            vendor: vendor.build(),
            orderState: BuiltValueNullFieldError.checkNotNull(
                orderState, r'CheckoutChildOrder', 'orderState'),
            paymentState: BuiltValueNullFieldError.checkNotNull(
                paymentState, r'CheckoutChildOrder', 'paymentState'),
            fulfillmentMethod: BuiltValueNullFieldError.checkNotNull(
                fulfillmentMethod, r'CheckoutChildOrder', 'fulfillmentMethod'),
            paymentMethod: BuiltValueNullFieldError.checkNotNull(
                paymentMethod, r'CheckoutChildOrder', 'paymentMethod'),
            confirmationSource: confirmationSource,
            materialsCentavos: BuiltValueNullFieldError.checkNotNull(
                materialsCentavos, r'CheckoutChildOrder', 'materialsCentavos'),
            deliveryCentavos: deliveryCentavos,
            commercialTotalCentavos: BuiltValueNullFieldError.checkNotNull(
                commercialTotalCentavos,
                r'CheckoutChildOrder',
                'commercialTotalCentavos'),
            vendorResponseDueAt: vendorResponseDueAt,
            paymentExpiresAt: paymentExpiresAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'vendor';
        vendor.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CheckoutChildOrder', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
