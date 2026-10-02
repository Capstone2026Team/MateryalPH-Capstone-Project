// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OrderSummaryProcurementTypeEnum
    _$orderSummaryProcurementTypeEnum_ITEM_BASED =
    const OrderSummaryProcurementTypeEnum._('ITEM_BASED');
const OrderSummaryProcurementTypeEnum
    _$orderSummaryProcurementTypeEnum_PROJECT_BASED =
    const OrderSummaryProcurementTypeEnum._('PROJECT_BASED');

OrderSummaryProcurementTypeEnum _$orderSummaryProcurementTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'ITEM_BASED':
      return _$orderSummaryProcurementTypeEnum_ITEM_BASED;
    case 'PROJECT_BASED':
      return _$orderSummaryProcurementTypeEnum_PROJECT_BASED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderSummaryProcurementTypeEnum>
    _$orderSummaryProcurementTypeEnumValues = BuiltSet<
        OrderSummaryProcurementTypeEnum>(const <OrderSummaryProcurementTypeEnum>[
  _$orderSummaryProcurementTypeEnum_ITEM_BASED,
  _$orderSummaryProcurementTypeEnum_PROJECT_BASED,
]);

const OrderSummaryConfirmationSourceEnum
    _$orderSummaryConfirmationSourceEnum_MANUAL =
    const OrderSummaryConfirmationSourceEnum._('MANUAL');
const OrderSummaryConfirmationSourceEnum
    _$orderSummaryConfirmationSourceEnum_AUTO_ACCEPT =
    const OrderSummaryConfirmationSourceEnum._('AUTO_ACCEPT');

OrderSummaryConfirmationSourceEnum _$orderSummaryConfirmationSourceEnumValueOf(
    String name) {
  switch (name) {
    case 'MANUAL':
      return _$orderSummaryConfirmationSourceEnum_MANUAL;
    case 'AUTO_ACCEPT':
      return _$orderSummaryConfirmationSourceEnum_AUTO_ACCEPT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderSummaryConfirmationSourceEnum>
    _$orderSummaryConfirmationSourceEnumValues = BuiltSet<
        OrderSummaryConfirmationSourceEnum>(const <OrderSummaryConfirmationSourceEnum>[
  _$orderSummaryConfirmationSourceEnum_MANUAL,
  _$orderSummaryConfirmationSourceEnum_AUTO_ACCEPT,
]);

const OrderSummaryFulfillmentMethodEnum
    _$orderSummaryFulfillmentMethodEnum_DELIVERY =
    const OrderSummaryFulfillmentMethodEnum._('DELIVERY');
const OrderSummaryFulfillmentMethodEnum
    _$orderSummaryFulfillmentMethodEnum_PICKUP =
    const OrderSummaryFulfillmentMethodEnum._('PICKUP');

OrderSummaryFulfillmentMethodEnum _$orderSummaryFulfillmentMethodEnumValueOf(
    String name) {
  switch (name) {
    case 'DELIVERY':
      return _$orderSummaryFulfillmentMethodEnum_DELIVERY;
    case 'PICKUP':
      return _$orderSummaryFulfillmentMethodEnum_PICKUP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderSummaryFulfillmentMethodEnum>
    _$orderSummaryFulfillmentMethodEnumValues = BuiltSet<
        OrderSummaryFulfillmentMethodEnum>(const <OrderSummaryFulfillmentMethodEnum>[
  _$orderSummaryFulfillmentMethodEnum_DELIVERY,
  _$orderSummaryFulfillmentMethodEnum_PICKUP,
]);

const OrderSummaryPaymentMethodEnum _$orderSummaryPaymentMethodEnum_ONLINE =
    const OrderSummaryPaymentMethodEnum._('ONLINE');
const OrderSummaryPaymentMethodEnum
    _$orderSummaryPaymentMethodEnum_CASH_ON_DELIVERY =
    const OrderSummaryPaymentMethodEnum._('CASH_ON_DELIVERY');
const OrderSummaryPaymentMethodEnum _$orderSummaryPaymentMethodEnum_IN_STORE =
    const OrderSummaryPaymentMethodEnum._('IN_STORE');

OrderSummaryPaymentMethodEnum _$orderSummaryPaymentMethodEnumValueOf(
    String name) {
  switch (name) {
    case 'ONLINE':
      return _$orderSummaryPaymentMethodEnum_ONLINE;
    case 'CASH_ON_DELIVERY':
      return _$orderSummaryPaymentMethodEnum_CASH_ON_DELIVERY;
    case 'IN_STORE':
      return _$orderSummaryPaymentMethodEnum_IN_STORE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderSummaryPaymentMethodEnum>
    _$orderSummaryPaymentMethodEnumValues = BuiltSet<
        OrderSummaryPaymentMethodEnum>(const <OrderSummaryPaymentMethodEnum>[
  _$orderSummaryPaymentMethodEnum_ONLINE,
  _$orderSummaryPaymentMethodEnum_CASH_ON_DELIVERY,
  _$orderSummaryPaymentMethodEnum_IN_STORE,
]);

const OrderSummaryNextActionEnum _$orderSummaryNextActionEnum_REVIEW_REVISION =
    const OrderSummaryNextActionEnum._('REVIEW_REVISION');
const OrderSummaryNextActionEnum _$orderSummaryNextActionEnum_REVIEW_NRPC =
    const OrderSummaryNextActionEnum._('REVIEW_NRPC');
const OrderSummaryNextActionEnum _$orderSummaryNextActionEnum_PAY =
    const OrderSummaryNextActionEnum._('PAY');

OrderSummaryNextActionEnum _$orderSummaryNextActionEnumValueOf(String name) {
  switch (name) {
    case 'REVIEW_REVISION':
      return _$orderSummaryNextActionEnum_REVIEW_REVISION;
    case 'REVIEW_NRPC':
      return _$orderSummaryNextActionEnum_REVIEW_NRPC;
    case 'PAY':
      return _$orderSummaryNextActionEnum_PAY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderSummaryNextActionEnum> _$orderSummaryNextActionEnumValues =
    BuiltSet<OrderSummaryNextActionEnum>(const <OrderSummaryNextActionEnum>[
  _$orderSummaryNextActionEnum_REVIEW_REVISION,
  _$orderSummaryNextActionEnum_REVIEW_NRPC,
  _$orderSummaryNextActionEnum_PAY,
]);

Serializer<OrderSummaryProcurementTypeEnum>
    _$orderSummaryProcurementTypeEnumSerializer =
    _$OrderSummaryProcurementTypeEnumSerializer();
Serializer<OrderSummaryConfirmationSourceEnum>
    _$orderSummaryConfirmationSourceEnumSerializer =
    _$OrderSummaryConfirmationSourceEnumSerializer();
Serializer<OrderSummaryFulfillmentMethodEnum>
    _$orderSummaryFulfillmentMethodEnumSerializer =
    _$OrderSummaryFulfillmentMethodEnumSerializer();
Serializer<OrderSummaryPaymentMethodEnum>
    _$orderSummaryPaymentMethodEnumSerializer =
    _$OrderSummaryPaymentMethodEnumSerializer();
Serializer<OrderSummaryNextActionEnum> _$orderSummaryNextActionEnumSerializer =
    _$OrderSummaryNextActionEnumSerializer();

class _$OrderSummaryProcurementTypeEnumSerializer
    implements PrimitiveSerializer<OrderSummaryProcurementTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ITEM_BASED': 'ITEM_BASED',
    'PROJECT_BASED': 'PROJECT_BASED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ITEM_BASED': 'ITEM_BASED',
    'PROJECT_BASED': 'PROJECT_BASED',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderSummaryProcurementTypeEnum];
  @override
  final String wireName = 'OrderSummaryProcurementTypeEnum';

  @override
  Object serialize(
          Serializers serializers, OrderSummaryProcurementTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderSummaryProcurementTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderSummaryProcurementTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderSummaryConfirmationSourceEnumSerializer
    implements PrimitiveSerializer<OrderSummaryConfirmationSourceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'MANUAL': 'MANUAL',
    'AUTO_ACCEPT': 'AUTO_ACCEPT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'MANUAL': 'MANUAL',
    'AUTO_ACCEPT': 'AUTO_ACCEPT',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderSummaryConfirmationSourceEnum];
  @override
  final String wireName = 'OrderSummaryConfirmationSourceEnum';

  @override
  Object serialize(
          Serializers serializers, OrderSummaryConfirmationSourceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderSummaryConfirmationSourceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderSummaryConfirmationSourceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderSummaryFulfillmentMethodEnumSerializer
    implements PrimitiveSerializer<OrderSummaryFulfillmentMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DELIVERY': 'DELIVERY',
    'PICKUP': 'PICKUP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DELIVERY': 'DELIVERY',
    'PICKUP': 'PICKUP',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderSummaryFulfillmentMethodEnum];
  @override
  final String wireName = 'OrderSummaryFulfillmentMethodEnum';

  @override
  Object serialize(
          Serializers serializers, OrderSummaryFulfillmentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderSummaryFulfillmentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderSummaryFulfillmentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderSummaryPaymentMethodEnumSerializer
    implements PrimitiveSerializer<OrderSummaryPaymentMethodEnum> {
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
  final Iterable<Type> types = const <Type>[OrderSummaryPaymentMethodEnum];
  @override
  final String wireName = 'OrderSummaryPaymentMethodEnum';

  @override
  Object serialize(
          Serializers serializers, OrderSummaryPaymentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderSummaryPaymentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderSummaryPaymentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderSummaryNextActionEnumSerializer
    implements PrimitiveSerializer<OrderSummaryNextActionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'REVIEW_REVISION': 'REVIEW_REVISION',
    'REVIEW_NRPC': 'REVIEW_NRPC',
    'PAY': 'PAY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'REVIEW_REVISION': 'REVIEW_REVISION',
    'REVIEW_NRPC': 'REVIEW_NRPC',
    'PAY': 'PAY',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderSummaryNextActionEnum];
  @override
  final String wireName = 'OrderSummaryNextActionEnum';

  @override
  Object serialize(Serializers serializers, OrderSummaryNextActionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderSummaryNextActionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderSummaryNextActionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderSummary extends OrderSummary {
  @override
  final String id;
  @override
  final String reference;
  @override
  final OrderVendorRef vendor;
  @override
  final DateTime? submittedAt;
  @override
  final OrderSummaryProcurementTypeEnum procurementType;
  @override
  final OrderSummaryConfirmationSourceEnum? confirmationSource;
  @override
  final BuiltList<OrderStateRow> states;
  @override
  final OrderSummaryFulfillmentMethodEnum fulfillmentMethod;
  @override
  final OrderSummaryPaymentMethodEnum paymentMethod;
  @override
  final int lineCount;
  @override
  final OrderFirstLine firstLine;
  @override
  final int materialsCentavos;
  @override
  final int? deliveryCentavos;
  @override
  final int commercialTotalCentavos;
  @override
  final bool deliveryPending;
  @override
  final OrderDeadline? deadline;
  @override
  final Date? expectedFulfillmentDate;
  @override
  final OrderSummaryNextActionEnum? nextAction;
  @override
  final bool? paymentRetryable;
  @override
  final OrderBuyerRef? buyer;
  @override
  final VendorOrderPrimaryAction? primaryAction;
  @override
  final bool? nrpcIndicator;

  factory _$OrderSummary([void Function(OrderSummaryBuilder)? updates]) =>
      (OrderSummaryBuilder()..update(updates))._build();

  _$OrderSummary._(
      {required this.id,
      required this.reference,
      required this.vendor,
      this.submittedAt,
      required this.procurementType,
      this.confirmationSource,
      required this.states,
      required this.fulfillmentMethod,
      required this.paymentMethod,
      required this.lineCount,
      required this.firstLine,
      required this.materialsCentavos,
      this.deliveryCentavos,
      required this.commercialTotalCentavos,
      required this.deliveryPending,
      this.deadline,
      this.expectedFulfillmentDate,
      this.nextAction,
      this.paymentRetryable,
      this.buyer,
      this.primaryAction,
      this.nrpcIndicator})
      : super._();
  @override
  OrderSummary rebuild(void Function(OrderSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderSummaryBuilder toBuilder() => OrderSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderSummary &&
        id == other.id &&
        reference == other.reference &&
        vendor == other.vendor &&
        submittedAt == other.submittedAt &&
        procurementType == other.procurementType &&
        confirmationSource == other.confirmationSource &&
        states == other.states &&
        fulfillmentMethod == other.fulfillmentMethod &&
        paymentMethod == other.paymentMethod &&
        lineCount == other.lineCount &&
        firstLine == other.firstLine &&
        materialsCentavos == other.materialsCentavos &&
        deliveryCentavos == other.deliveryCentavos &&
        commercialTotalCentavos == other.commercialTotalCentavos &&
        deliveryPending == other.deliveryPending &&
        deadline == other.deadline &&
        expectedFulfillmentDate == other.expectedFulfillmentDate &&
        nextAction == other.nextAction &&
        paymentRetryable == other.paymentRetryable &&
        buyer == other.buyer &&
        primaryAction == other.primaryAction &&
        nrpcIndicator == other.nrpcIndicator;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, vendor.hashCode);
    _$hash = $jc(_$hash, submittedAt.hashCode);
    _$hash = $jc(_$hash, procurementType.hashCode);
    _$hash = $jc(_$hash, confirmationSource.hashCode);
    _$hash = $jc(_$hash, states.hashCode);
    _$hash = $jc(_$hash, fulfillmentMethod.hashCode);
    _$hash = $jc(_$hash, paymentMethod.hashCode);
    _$hash = $jc(_$hash, lineCount.hashCode);
    _$hash = $jc(_$hash, firstLine.hashCode);
    _$hash = $jc(_$hash, materialsCentavos.hashCode);
    _$hash = $jc(_$hash, deliveryCentavos.hashCode);
    _$hash = $jc(_$hash, commercialTotalCentavos.hashCode);
    _$hash = $jc(_$hash, deliveryPending.hashCode);
    _$hash = $jc(_$hash, deadline.hashCode);
    _$hash = $jc(_$hash, expectedFulfillmentDate.hashCode);
    _$hash = $jc(_$hash, nextAction.hashCode);
    _$hash = $jc(_$hash, paymentRetryable.hashCode);
    _$hash = $jc(_$hash, buyer.hashCode);
    _$hash = $jc(_$hash, primaryAction.hashCode);
    _$hash = $jc(_$hash, nrpcIndicator.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderSummary')
          ..add('id', id)
          ..add('reference', reference)
          ..add('vendor', vendor)
          ..add('submittedAt', submittedAt)
          ..add('procurementType', procurementType)
          ..add('confirmationSource', confirmationSource)
          ..add('states', states)
          ..add('fulfillmentMethod', fulfillmentMethod)
          ..add('paymentMethod', paymentMethod)
          ..add('lineCount', lineCount)
          ..add('firstLine', firstLine)
          ..add('materialsCentavos', materialsCentavos)
          ..add('deliveryCentavos', deliveryCentavos)
          ..add('commercialTotalCentavos', commercialTotalCentavos)
          ..add('deliveryPending', deliveryPending)
          ..add('deadline', deadline)
          ..add('expectedFulfillmentDate', expectedFulfillmentDate)
          ..add('nextAction', nextAction)
          ..add('paymentRetryable', paymentRetryable)
          ..add('buyer', buyer)
          ..add('primaryAction', primaryAction)
          ..add('nrpcIndicator', nrpcIndicator))
        .toString();
  }
}

class OrderSummaryBuilder
    implements Builder<OrderSummary, OrderSummaryBuilder> {
  _$OrderSummary? _$v;

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

  DateTime? _submittedAt;
  DateTime? get submittedAt => _$this._submittedAt;
  set submittedAt(DateTime? submittedAt) => _$this._submittedAt = submittedAt;

  OrderSummaryProcurementTypeEnum? _procurementType;
  OrderSummaryProcurementTypeEnum? get procurementType =>
      _$this._procurementType;
  set procurementType(OrderSummaryProcurementTypeEnum? procurementType) =>
      _$this._procurementType = procurementType;

  OrderSummaryConfirmationSourceEnum? _confirmationSource;
  OrderSummaryConfirmationSourceEnum? get confirmationSource =>
      _$this._confirmationSource;
  set confirmationSource(
          OrderSummaryConfirmationSourceEnum? confirmationSource) =>
      _$this._confirmationSource = confirmationSource;

  ListBuilder<OrderStateRow>? _states;
  ListBuilder<OrderStateRow> get states =>
      _$this._states ??= ListBuilder<OrderStateRow>();
  set states(ListBuilder<OrderStateRow>? states) => _$this._states = states;

  OrderSummaryFulfillmentMethodEnum? _fulfillmentMethod;
  OrderSummaryFulfillmentMethodEnum? get fulfillmentMethod =>
      _$this._fulfillmentMethod;
  set fulfillmentMethod(OrderSummaryFulfillmentMethodEnum? fulfillmentMethod) =>
      _$this._fulfillmentMethod = fulfillmentMethod;

  OrderSummaryPaymentMethodEnum? _paymentMethod;
  OrderSummaryPaymentMethodEnum? get paymentMethod => _$this._paymentMethod;
  set paymentMethod(OrderSummaryPaymentMethodEnum? paymentMethod) =>
      _$this._paymentMethod = paymentMethod;

  int? _lineCount;
  int? get lineCount => _$this._lineCount;
  set lineCount(int? lineCount) => _$this._lineCount = lineCount;

  OrderFirstLineBuilder? _firstLine;
  OrderFirstLineBuilder get firstLine =>
      _$this._firstLine ??= OrderFirstLineBuilder();
  set firstLine(OrderFirstLineBuilder? firstLine) =>
      _$this._firstLine = firstLine;

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

  bool? _deliveryPending;
  bool? get deliveryPending => _$this._deliveryPending;
  set deliveryPending(bool? deliveryPending) =>
      _$this._deliveryPending = deliveryPending;

  OrderDeadlineBuilder? _deadline;
  OrderDeadlineBuilder get deadline =>
      _$this._deadline ??= OrderDeadlineBuilder();
  set deadline(OrderDeadlineBuilder? deadline) => _$this._deadline = deadline;

  Date? _expectedFulfillmentDate;
  Date? get expectedFulfillmentDate => _$this._expectedFulfillmentDate;
  set expectedFulfillmentDate(Date? expectedFulfillmentDate) =>
      _$this._expectedFulfillmentDate = expectedFulfillmentDate;

  OrderSummaryNextActionEnum? _nextAction;
  OrderSummaryNextActionEnum? get nextAction => _$this._nextAction;
  set nextAction(OrderSummaryNextActionEnum? nextAction) =>
      _$this._nextAction = nextAction;

  bool? _paymentRetryable;
  bool? get paymentRetryable => _$this._paymentRetryable;
  set paymentRetryable(bool? paymentRetryable) =>
      _$this._paymentRetryable = paymentRetryable;

  OrderBuyerRefBuilder? _buyer;
  OrderBuyerRefBuilder get buyer => _$this._buyer ??= OrderBuyerRefBuilder();
  set buyer(OrderBuyerRefBuilder? buyer) => _$this._buyer = buyer;

  VendorOrderPrimaryAction? _primaryAction;
  VendorOrderPrimaryAction? get primaryAction => _$this._primaryAction;
  set primaryAction(VendorOrderPrimaryAction? primaryAction) =>
      _$this._primaryAction = primaryAction;

  bool? _nrpcIndicator;
  bool? get nrpcIndicator => _$this._nrpcIndicator;
  set nrpcIndicator(bool? nrpcIndicator) =>
      _$this._nrpcIndicator = nrpcIndicator;

  OrderSummaryBuilder() {
    OrderSummary._defaults(this);
  }

  OrderSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _reference = $v.reference;
      _vendor = $v.vendor.toBuilder();
      _submittedAt = $v.submittedAt;
      _procurementType = $v.procurementType;
      _confirmationSource = $v.confirmationSource;
      _states = $v.states.toBuilder();
      _fulfillmentMethod = $v.fulfillmentMethod;
      _paymentMethod = $v.paymentMethod;
      _lineCount = $v.lineCount;
      _firstLine = $v.firstLine.toBuilder();
      _materialsCentavos = $v.materialsCentavos;
      _deliveryCentavos = $v.deliveryCentavos;
      _commercialTotalCentavos = $v.commercialTotalCentavos;
      _deliveryPending = $v.deliveryPending;
      _deadline = $v.deadline?.toBuilder();
      _expectedFulfillmentDate = $v.expectedFulfillmentDate;
      _nextAction = $v.nextAction;
      _paymentRetryable = $v.paymentRetryable;
      _buyer = $v.buyer?.toBuilder();
      _primaryAction = $v.primaryAction;
      _nrpcIndicator = $v.nrpcIndicator;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderSummary other) {
    _$v = other as _$OrderSummary;
  }

  @override
  void update(void Function(OrderSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderSummary build() => _build();

  _$OrderSummary _build() {
    _$OrderSummary _$result;
    try {
      _$result = _$v ??
          _$OrderSummary._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'OrderSummary', 'id'),
            reference: BuiltValueNullFieldError.checkNotNull(
                reference, r'OrderSummary', 'reference'),
            vendor: vendor.build(),
            submittedAt: submittedAt,
            procurementType: BuiltValueNullFieldError.checkNotNull(
                procurementType, r'OrderSummary', 'procurementType'),
            confirmationSource: confirmationSource,
            states: states.build(),
            fulfillmentMethod: BuiltValueNullFieldError.checkNotNull(
                fulfillmentMethod, r'OrderSummary', 'fulfillmentMethod'),
            paymentMethod: BuiltValueNullFieldError.checkNotNull(
                paymentMethod, r'OrderSummary', 'paymentMethod'),
            lineCount: BuiltValueNullFieldError.checkNotNull(
                lineCount, r'OrderSummary', 'lineCount'),
            firstLine: firstLine.build(),
            materialsCentavos: BuiltValueNullFieldError.checkNotNull(
                materialsCentavos, r'OrderSummary', 'materialsCentavos'),
            deliveryCentavos: deliveryCentavos,
            commercialTotalCentavos: BuiltValueNullFieldError.checkNotNull(
                commercialTotalCentavos,
                r'OrderSummary',
                'commercialTotalCentavos'),
            deliveryPending: BuiltValueNullFieldError.checkNotNull(
                deliveryPending, r'OrderSummary', 'deliveryPending'),
            deadline: _deadline?.build(),
            expectedFulfillmentDate: expectedFulfillmentDate,
            nextAction: nextAction,
            paymentRetryable: paymentRetryable,
            buyer: _buyer?.build(),
            primaryAction: primaryAction,
            nrpcIndicator: nrpcIndicator,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'vendor';
        vendor.build();

        _$failedField = 'states';
        states.build();

        _$failedField = 'firstLine';
        firstLine.build();

        _$failedField = 'deadline';
        _deadline?.build();

        _$failedField = 'buyer';
        _buyer?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OrderSummary', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
