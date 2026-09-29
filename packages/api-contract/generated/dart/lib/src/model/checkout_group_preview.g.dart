// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_group_preview.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CheckoutGroupPreviewFulfillmentMethodEnum
    _$checkoutGroupPreviewFulfillmentMethodEnum_DELIVERY =
    const CheckoutGroupPreviewFulfillmentMethodEnum._('DELIVERY');
const CheckoutGroupPreviewFulfillmentMethodEnum
    _$checkoutGroupPreviewFulfillmentMethodEnum_PICKUP =
    const CheckoutGroupPreviewFulfillmentMethodEnum._('PICKUP');

CheckoutGroupPreviewFulfillmentMethodEnum
    _$checkoutGroupPreviewFulfillmentMethodEnumValueOf(String name) {
  switch (name) {
    case 'DELIVERY':
      return _$checkoutGroupPreviewFulfillmentMethodEnum_DELIVERY;
    case 'PICKUP':
      return _$checkoutGroupPreviewFulfillmentMethodEnum_PICKUP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CheckoutGroupPreviewFulfillmentMethodEnum>
    _$checkoutGroupPreviewFulfillmentMethodEnumValues = BuiltSet<
        CheckoutGroupPreviewFulfillmentMethodEnum>(const <CheckoutGroupPreviewFulfillmentMethodEnum>[
  _$checkoutGroupPreviewFulfillmentMethodEnum_DELIVERY,
  _$checkoutGroupPreviewFulfillmentMethodEnum_PICKUP,
]);

const CheckoutGroupPreviewFulfillmentOptionsEnum
    _$checkoutGroupPreviewFulfillmentOptionsEnum_DELIVERY =
    const CheckoutGroupPreviewFulfillmentOptionsEnum._('DELIVERY');
const CheckoutGroupPreviewFulfillmentOptionsEnum
    _$checkoutGroupPreviewFulfillmentOptionsEnum_PICKUP =
    const CheckoutGroupPreviewFulfillmentOptionsEnum._('PICKUP');

CheckoutGroupPreviewFulfillmentOptionsEnum
    _$checkoutGroupPreviewFulfillmentOptionsEnumValueOf(String name) {
  switch (name) {
    case 'DELIVERY':
      return _$checkoutGroupPreviewFulfillmentOptionsEnum_DELIVERY;
    case 'PICKUP':
      return _$checkoutGroupPreviewFulfillmentOptionsEnum_PICKUP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CheckoutGroupPreviewFulfillmentOptionsEnum>
    _$checkoutGroupPreviewFulfillmentOptionsEnumValues = BuiltSet<
        CheckoutGroupPreviewFulfillmentOptionsEnum>(const <CheckoutGroupPreviewFulfillmentOptionsEnum>[
  _$checkoutGroupPreviewFulfillmentOptionsEnum_DELIVERY,
  _$checkoutGroupPreviewFulfillmentOptionsEnum_PICKUP,
]);

const CheckoutGroupPreviewStatusEnum _$checkoutGroupPreviewStatusEnum_READY =
    const CheckoutGroupPreviewStatusEnum._('READY');
const CheckoutGroupPreviewStatusEnum
    _$checkoutGroupPreviewStatusEnum_ACTION_REQUIRED =
    const CheckoutGroupPreviewStatusEnum._('ACTION_REQUIRED');
const CheckoutGroupPreviewStatusEnum _$checkoutGroupPreviewStatusEnum_BLOCKED =
    const CheckoutGroupPreviewStatusEnum._('BLOCKED');

CheckoutGroupPreviewStatusEnum _$checkoutGroupPreviewStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'READY':
      return _$checkoutGroupPreviewStatusEnum_READY;
    case 'ACTION_REQUIRED':
      return _$checkoutGroupPreviewStatusEnum_ACTION_REQUIRED;
    case 'BLOCKED':
      return _$checkoutGroupPreviewStatusEnum_BLOCKED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CheckoutGroupPreviewStatusEnum>
    _$checkoutGroupPreviewStatusEnumValues = BuiltSet<
        CheckoutGroupPreviewStatusEnum>(const <CheckoutGroupPreviewStatusEnum>[
  _$checkoutGroupPreviewStatusEnum_READY,
  _$checkoutGroupPreviewStatusEnum_ACTION_REQUIRED,
  _$checkoutGroupPreviewStatusEnum_BLOCKED,
]);

Serializer<CheckoutGroupPreviewFulfillmentMethodEnum>
    _$checkoutGroupPreviewFulfillmentMethodEnumSerializer =
    _$CheckoutGroupPreviewFulfillmentMethodEnumSerializer();
Serializer<CheckoutGroupPreviewFulfillmentOptionsEnum>
    _$checkoutGroupPreviewFulfillmentOptionsEnumSerializer =
    _$CheckoutGroupPreviewFulfillmentOptionsEnumSerializer();
Serializer<CheckoutGroupPreviewStatusEnum>
    _$checkoutGroupPreviewStatusEnumSerializer =
    _$CheckoutGroupPreviewStatusEnumSerializer();

class _$CheckoutGroupPreviewFulfillmentMethodEnumSerializer
    implements PrimitiveSerializer<CheckoutGroupPreviewFulfillmentMethodEnum> {
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
    CheckoutGroupPreviewFulfillmentMethodEnum
  ];
  @override
  final String wireName = 'CheckoutGroupPreviewFulfillmentMethodEnum';

  @override
  Object serialize(Serializers serializers,
          CheckoutGroupPreviewFulfillmentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CheckoutGroupPreviewFulfillmentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CheckoutGroupPreviewFulfillmentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CheckoutGroupPreviewFulfillmentOptionsEnumSerializer
    implements PrimitiveSerializer<CheckoutGroupPreviewFulfillmentOptionsEnum> {
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
    CheckoutGroupPreviewFulfillmentOptionsEnum
  ];
  @override
  final String wireName = 'CheckoutGroupPreviewFulfillmentOptionsEnum';

  @override
  Object serialize(Serializers serializers,
          CheckoutGroupPreviewFulfillmentOptionsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CheckoutGroupPreviewFulfillmentOptionsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CheckoutGroupPreviewFulfillmentOptionsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CheckoutGroupPreviewStatusEnumSerializer
    implements PrimitiveSerializer<CheckoutGroupPreviewStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'READY': 'READY',
    'ACTION_REQUIRED': 'ACTION_REQUIRED',
    'BLOCKED': 'BLOCKED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'READY': 'READY',
    'ACTION_REQUIRED': 'ACTION_REQUIRED',
    'BLOCKED': 'BLOCKED',
  };

  @override
  final Iterable<Type> types = const <Type>[CheckoutGroupPreviewStatusEnum];
  @override
  final String wireName = 'CheckoutGroupPreviewStatusEnum';

  @override
  Object serialize(
          Serializers serializers, CheckoutGroupPreviewStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CheckoutGroupPreviewStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CheckoutGroupPreviewStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CheckoutGroupPreview extends CheckoutGroupPreview {
  @override
  final CheckoutVendorRef vendor;
  @override
  final CheckoutGroupPreviewFulfillmentMethodEnum? fulfillmentMethod;
  @override
  final BuiltList<CheckoutGroupPreviewFulfillmentOptionsEnum>
      fulfillmentOptions;
  @override
  final CheckoutGroupPreviewStatusEnum status;
  @override
  final BuiltList<CartIssue> issues;
  @override
  final BuiltList<CartLine> lines;
  @override
  final DeliveryPreview delivery;
  @override
  final PickupPreview? pickup;
  @override
  final BuiltList<PaymentMethodEligibility> paymentMethods;
  @override
  final FinancialPreview amounts;

  factory _$CheckoutGroupPreview(
          [void Function(CheckoutGroupPreviewBuilder)? updates]) =>
      (CheckoutGroupPreviewBuilder()..update(updates))._build();

  _$CheckoutGroupPreview._(
      {required this.vendor,
      this.fulfillmentMethod,
      required this.fulfillmentOptions,
      required this.status,
      required this.issues,
      required this.lines,
      required this.delivery,
      this.pickup,
      required this.paymentMethods,
      required this.amounts})
      : super._();
  @override
  CheckoutGroupPreview rebuild(
          void Function(CheckoutGroupPreviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CheckoutGroupPreviewBuilder toBuilder() =>
      CheckoutGroupPreviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CheckoutGroupPreview &&
        vendor == other.vendor &&
        fulfillmentMethod == other.fulfillmentMethod &&
        fulfillmentOptions == other.fulfillmentOptions &&
        status == other.status &&
        issues == other.issues &&
        lines == other.lines &&
        delivery == other.delivery &&
        pickup == other.pickup &&
        paymentMethods == other.paymentMethods &&
        amounts == other.amounts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vendor.hashCode);
    _$hash = $jc(_$hash, fulfillmentMethod.hashCode);
    _$hash = $jc(_$hash, fulfillmentOptions.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, issues.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, delivery.hashCode);
    _$hash = $jc(_$hash, pickup.hashCode);
    _$hash = $jc(_$hash, paymentMethods.hashCode);
    _$hash = $jc(_$hash, amounts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CheckoutGroupPreview')
          ..add('vendor', vendor)
          ..add('fulfillmentMethod', fulfillmentMethod)
          ..add('fulfillmentOptions', fulfillmentOptions)
          ..add('status', status)
          ..add('issues', issues)
          ..add('lines', lines)
          ..add('delivery', delivery)
          ..add('pickup', pickup)
          ..add('paymentMethods', paymentMethods)
          ..add('amounts', amounts))
        .toString();
  }
}

class CheckoutGroupPreviewBuilder
    implements Builder<CheckoutGroupPreview, CheckoutGroupPreviewBuilder> {
  _$CheckoutGroupPreview? _$v;

  CheckoutVendorRefBuilder? _vendor;
  CheckoutVendorRefBuilder get vendor =>
      _$this._vendor ??= CheckoutVendorRefBuilder();
  set vendor(CheckoutVendorRefBuilder? vendor) => _$this._vendor = vendor;

  CheckoutGroupPreviewFulfillmentMethodEnum? _fulfillmentMethod;
  CheckoutGroupPreviewFulfillmentMethodEnum? get fulfillmentMethod =>
      _$this._fulfillmentMethod;
  set fulfillmentMethod(
          CheckoutGroupPreviewFulfillmentMethodEnum? fulfillmentMethod) =>
      _$this._fulfillmentMethod = fulfillmentMethod;

  ListBuilder<CheckoutGroupPreviewFulfillmentOptionsEnum>? _fulfillmentOptions;
  ListBuilder<CheckoutGroupPreviewFulfillmentOptionsEnum>
      get fulfillmentOptions => _$this._fulfillmentOptions ??=
          ListBuilder<CheckoutGroupPreviewFulfillmentOptionsEnum>();
  set fulfillmentOptions(
          ListBuilder<CheckoutGroupPreviewFulfillmentOptionsEnum>?
              fulfillmentOptions) =>
      _$this._fulfillmentOptions = fulfillmentOptions;

  CheckoutGroupPreviewStatusEnum? _status;
  CheckoutGroupPreviewStatusEnum? get status => _$this._status;
  set status(CheckoutGroupPreviewStatusEnum? status) => _$this._status = status;

  ListBuilder<CartIssue>? _issues;
  ListBuilder<CartIssue> get issues =>
      _$this._issues ??= ListBuilder<CartIssue>();
  set issues(ListBuilder<CartIssue>? issues) => _$this._issues = issues;

  ListBuilder<CartLine>? _lines;
  ListBuilder<CartLine> get lines => _$this._lines ??= ListBuilder<CartLine>();
  set lines(ListBuilder<CartLine>? lines) => _$this._lines = lines;

  DeliveryPreviewBuilder? _delivery;
  DeliveryPreviewBuilder get delivery =>
      _$this._delivery ??= DeliveryPreviewBuilder();
  set delivery(DeliveryPreviewBuilder? delivery) => _$this._delivery = delivery;

  PickupPreviewBuilder? _pickup;
  PickupPreviewBuilder get pickup => _$this._pickup ??= PickupPreviewBuilder();
  set pickup(PickupPreviewBuilder? pickup) => _$this._pickup = pickup;

  ListBuilder<PaymentMethodEligibility>? _paymentMethods;
  ListBuilder<PaymentMethodEligibility> get paymentMethods =>
      _$this._paymentMethods ??= ListBuilder<PaymentMethodEligibility>();
  set paymentMethods(ListBuilder<PaymentMethodEligibility>? paymentMethods) =>
      _$this._paymentMethods = paymentMethods;

  FinancialPreviewBuilder? _amounts;
  FinancialPreviewBuilder get amounts =>
      _$this._amounts ??= FinancialPreviewBuilder();
  set amounts(FinancialPreviewBuilder? amounts) => _$this._amounts = amounts;

  CheckoutGroupPreviewBuilder() {
    CheckoutGroupPreview._defaults(this);
  }

  CheckoutGroupPreviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vendor = $v.vendor.toBuilder();
      _fulfillmentMethod = $v.fulfillmentMethod;
      _fulfillmentOptions = $v.fulfillmentOptions.toBuilder();
      _status = $v.status;
      _issues = $v.issues.toBuilder();
      _lines = $v.lines.toBuilder();
      _delivery = $v.delivery.toBuilder();
      _pickup = $v.pickup?.toBuilder();
      _paymentMethods = $v.paymentMethods.toBuilder();
      _amounts = $v.amounts.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CheckoutGroupPreview other) {
    _$v = other as _$CheckoutGroupPreview;
  }

  @override
  void update(void Function(CheckoutGroupPreviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CheckoutGroupPreview build() => _build();

  _$CheckoutGroupPreview _build() {
    _$CheckoutGroupPreview _$result;
    try {
      _$result = _$v ??
          _$CheckoutGroupPreview._(
            vendor: vendor.build(),
            fulfillmentMethod: fulfillmentMethod,
            fulfillmentOptions: fulfillmentOptions.build(),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'CheckoutGroupPreview', 'status'),
            issues: issues.build(),
            lines: lines.build(),
            delivery: delivery.build(),
            pickup: _pickup?.build(),
            paymentMethods: paymentMethods.build(),
            amounts: amounts.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'vendor';
        vendor.build();

        _$failedField = 'fulfillmentOptions';
        fulfillmentOptions.build();

        _$failedField = 'issues';
        issues.build();
        _$failedField = 'lines';
        lines.build();
        _$failedField = 'delivery';
        delivery.build();
        _$failedField = 'pickup';
        _pickup?.build();
        _$failedField = 'paymentMethods';
        paymentMethods.build();
        _$failedField = 'amounts';
        amounts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CheckoutGroupPreview', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
