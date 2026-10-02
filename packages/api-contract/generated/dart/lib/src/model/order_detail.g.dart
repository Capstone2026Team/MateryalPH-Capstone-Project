// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OrderDetailProcurementTypeEnum
    _$orderDetailProcurementTypeEnum_ITEM_BASED =
    const OrderDetailProcurementTypeEnum._('ITEM_BASED');
const OrderDetailProcurementTypeEnum
    _$orderDetailProcurementTypeEnum_PROJECT_BASED =
    const OrderDetailProcurementTypeEnum._('PROJECT_BASED');

OrderDetailProcurementTypeEnum _$orderDetailProcurementTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'ITEM_BASED':
      return _$orderDetailProcurementTypeEnum_ITEM_BASED;
    case 'PROJECT_BASED':
      return _$orderDetailProcurementTypeEnum_PROJECT_BASED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderDetailProcurementTypeEnum>
    _$orderDetailProcurementTypeEnumValues = BuiltSet<
        OrderDetailProcurementTypeEnum>(const <OrderDetailProcurementTypeEnum>[
  _$orderDetailProcurementTypeEnum_ITEM_BASED,
  _$orderDetailProcurementTypeEnum_PROJECT_BASED,
]);

const OrderDetailFulfillmentMethodEnum
    _$orderDetailFulfillmentMethodEnum_DELIVERY =
    const OrderDetailFulfillmentMethodEnum._('DELIVERY');
const OrderDetailFulfillmentMethodEnum
    _$orderDetailFulfillmentMethodEnum_PICKUP =
    const OrderDetailFulfillmentMethodEnum._('PICKUP');

OrderDetailFulfillmentMethodEnum _$orderDetailFulfillmentMethodEnumValueOf(
    String name) {
  switch (name) {
    case 'DELIVERY':
      return _$orderDetailFulfillmentMethodEnum_DELIVERY;
    case 'PICKUP':
      return _$orderDetailFulfillmentMethodEnum_PICKUP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderDetailFulfillmentMethodEnum>
    _$orderDetailFulfillmentMethodEnumValues = BuiltSet<
        OrderDetailFulfillmentMethodEnum>(const <OrderDetailFulfillmentMethodEnum>[
  _$orderDetailFulfillmentMethodEnum_DELIVERY,
  _$orderDetailFulfillmentMethodEnum_PICKUP,
]);

const OrderDetailPaymentMethodEnum _$orderDetailPaymentMethodEnum_ONLINE =
    const OrderDetailPaymentMethodEnum._('ONLINE');
const OrderDetailPaymentMethodEnum
    _$orderDetailPaymentMethodEnum_CASH_ON_DELIVERY =
    const OrderDetailPaymentMethodEnum._('CASH_ON_DELIVERY');
const OrderDetailPaymentMethodEnum _$orderDetailPaymentMethodEnum_IN_STORE =
    const OrderDetailPaymentMethodEnum._('IN_STORE');

OrderDetailPaymentMethodEnum _$orderDetailPaymentMethodEnumValueOf(
    String name) {
  switch (name) {
    case 'ONLINE':
      return _$orderDetailPaymentMethodEnum_ONLINE;
    case 'CASH_ON_DELIVERY':
      return _$orderDetailPaymentMethodEnum_CASH_ON_DELIVERY;
    case 'IN_STORE':
      return _$orderDetailPaymentMethodEnum_IN_STORE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderDetailPaymentMethodEnum>
    _$orderDetailPaymentMethodEnumValues =
    BuiltSet<OrderDetailPaymentMethodEnum>(const <OrderDetailPaymentMethodEnum>[
  _$orderDetailPaymentMethodEnum_ONLINE,
  _$orderDetailPaymentMethodEnum_CASH_ON_DELIVERY,
  _$orderDetailPaymentMethodEnum_IN_STORE,
]);

const OrderDetailConfirmationSourceEnum
    _$orderDetailConfirmationSourceEnum_MANUAL =
    const OrderDetailConfirmationSourceEnum._('MANUAL');
const OrderDetailConfirmationSourceEnum
    _$orderDetailConfirmationSourceEnum_AUTO_ACCEPT =
    const OrderDetailConfirmationSourceEnum._('AUTO_ACCEPT');

OrderDetailConfirmationSourceEnum _$orderDetailConfirmationSourceEnumValueOf(
    String name) {
  switch (name) {
    case 'MANUAL':
      return _$orderDetailConfirmationSourceEnum_MANUAL;
    case 'AUTO_ACCEPT':
      return _$orderDetailConfirmationSourceEnum_AUTO_ACCEPT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderDetailConfirmationSourceEnum>
    _$orderDetailConfirmationSourceEnumValues = BuiltSet<
        OrderDetailConfirmationSourceEnum>(const <OrderDetailConfirmationSourceEnum>[
  _$orderDetailConfirmationSourceEnum_MANUAL,
  _$orderDetailConfirmationSourceEnum_AUTO_ACCEPT,
]);

const OrderDetailAvailableActionsEnum
    _$orderDetailAvailableActionsEnum_APPROVE_REVISION =
    const OrderDetailAvailableActionsEnum._('APPROVE_REVISION');
const OrderDetailAvailableActionsEnum
    _$orderDetailAvailableActionsEnum_REJECT_REVISION =
    const OrderDetailAvailableActionsEnum._('REJECT_REVISION');
const OrderDetailAvailableActionsEnum
    _$orderDetailAvailableActionsEnum_ACCEPT_NRPC =
    const OrderDetailAvailableActionsEnum._('ACCEPT_NRPC');
const OrderDetailAvailableActionsEnum
    _$orderDetailAvailableActionsEnum_REJECT_NRPC =
    const OrderDetailAvailableActionsEnum._('REJECT_NRPC');
const OrderDetailAvailableActionsEnum
    _$orderDetailAvailableActionsEnum_FLAG_NRPC =
    const OrderDetailAvailableActionsEnum._('FLAG_NRPC');
const OrderDetailAvailableActionsEnum _$orderDetailAvailableActionsEnum_PAY =
    const OrderDetailAvailableActionsEnum._('PAY');

OrderDetailAvailableActionsEnum _$orderDetailAvailableActionsEnumValueOf(
    String name) {
  switch (name) {
    case 'APPROVE_REVISION':
      return _$orderDetailAvailableActionsEnum_APPROVE_REVISION;
    case 'REJECT_REVISION':
      return _$orderDetailAvailableActionsEnum_REJECT_REVISION;
    case 'ACCEPT_NRPC':
      return _$orderDetailAvailableActionsEnum_ACCEPT_NRPC;
    case 'REJECT_NRPC':
      return _$orderDetailAvailableActionsEnum_REJECT_NRPC;
    case 'FLAG_NRPC':
      return _$orderDetailAvailableActionsEnum_FLAG_NRPC;
    case 'PAY':
      return _$orderDetailAvailableActionsEnum_PAY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderDetailAvailableActionsEnum>
    _$orderDetailAvailableActionsEnumValues = BuiltSet<
        OrderDetailAvailableActionsEnum>(const <OrderDetailAvailableActionsEnum>[
  _$orderDetailAvailableActionsEnum_APPROVE_REVISION,
  _$orderDetailAvailableActionsEnum_REJECT_REVISION,
  _$orderDetailAvailableActionsEnum_ACCEPT_NRPC,
  _$orderDetailAvailableActionsEnum_REJECT_NRPC,
  _$orderDetailAvailableActionsEnum_FLAG_NRPC,
  _$orderDetailAvailableActionsEnum_PAY,
]);

Serializer<OrderDetailProcurementTypeEnum>
    _$orderDetailProcurementTypeEnumSerializer =
    _$OrderDetailProcurementTypeEnumSerializer();
Serializer<OrderDetailFulfillmentMethodEnum>
    _$orderDetailFulfillmentMethodEnumSerializer =
    _$OrderDetailFulfillmentMethodEnumSerializer();
Serializer<OrderDetailPaymentMethodEnum>
    _$orderDetailPaymentMethodEnumSerializer =
    _$OrderDetailPaymentMethodEnumSerializer();
Serializer<OrderDetailConfirmationSourceEnum>
    _$orderDetailConfirmationSourceEnumSerializer =
    _$OrderDetailConfirmationSourceEnumSerializer();
Serializer<OrderDetailAvailableActionsEnum>
    _$orderDetailAvailableActionsEnumSerializer =
    _$OrderDetailAvailableActionsEnumSerializer();

class _$OrderDetailProcurementTypeEnumSerializer
    implements PrimitiveSerializer<OrderDetailProcurementTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ITEM_BASED': 'ITEM_BASED',
    'PROJECT_BASED': 'PROJECT_BASED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ITEM_BASED': 'ITEM_BASED',
    'PROJECT_BASED': 'PROJECT_BASED',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderDetailProcurementTypeEnum];
  @override
  final String wireName = 'OrderDetailProcurementTypeEnum';

  @override
  Object serialize(
          Serializers serializers, OrderDetailProcurementTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderDetailProcurementTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderDetailProcurementTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderDetailFulfillmentMethodEnumSerializer
    implements PrimitiveSerializer<OrderDetailFulfillmentMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DELIVERY': 'DELIVERY',
    'PICKUP': 'PICKUP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DELIVERY': 'DELIVERY',
    'PICKUP': 'PICKUP',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderDetailFulfillmentMethodEnum];
  @override
  final String wireName = 'OrderDetailFulfillmentMethodEnum';

  @override
  Object serialize(
          Serializers serializers, OrderDetailFulfillmentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderDetailFulfillmentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderDetailFulfillmentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderDetailPaymentMethodEnumSerializer
    implements PrimitiveSerializer<OrderDetailPaymentMethodEnum> {
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
  final Iterable<Type> types = const <Type>[OrderDetailPaymentMethodEnum];
  @override
  final String wireName = 'OrderDetailPaymentMethodEnum';

  @override
  Object serialize(Serializers serializers, OrderDetailPaymentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderDetailPaymentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderDetailPaymentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderDetailConfirmationSourceEnumSerializer
    implements PrimitiveSerializer<OrderDetailConfirmationSourceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'MANUAL': 'MANUAL',
    'AUTO_ACCEPT': 'AUTO_ACCEPT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'MANUAL': 'MANUAL',
    'AUTO_ACCEPT': 'AUTO_ACCEPT',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderDetailConfirmationSourceEnum];
  @override
  final String wireName = 'OrderDetailConfirmationSourceEnum';

  @override
  Object serialize(
          Serializers serializers, OrderDetailConfirmationSourceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderDetailConfirmationSourceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderDetailConfirmationSourceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderDetailAvailableActionsEnumSerializer
    implements PrimitiveSerializer<OrderDetailAvailableActionsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'APPROVE_REVISION': 'APPROVE_REVISION',
    'REJECT_REVISION': 'REJECT_REVISION',
    'ACCEPT_NRPC': 'ACCEPT_NRPC',
    'REJECT_NRPC': 'REJECT_NRPC',
    'FLAG_NRPC': 'FLAG_NRPC',
    'PAY': 'PAY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'APPROVE_REVISION': 'APPROVE_REVISION',
    'REJECT_REVISION': 'REJECT_REVISION',
    'ACCEPT_NRPC': 'ACCEPT_NRPC',
    'REJECT_NRPC': 'REJECT_NRPC',
    'FLAG_NRPC': 'FLAG_NRPC',
    'PAY': 'PAY',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderDetailAvailableActionsEnum];
  @override
  final String wireName = 'OrderDetailAvailableActionsEnum';

  @override
  Object serialize(
          Serializers serializers, OrderDetailAvailableActionsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderDetailAvailableActionsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderDetailAvailableActionsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderDetail extends OrderDetail {
  @override
  final BuiltMap<String, JsonObject?>? projectContext;
  @override
  final String id;
  @override
  final String reference;
  @override
  final OrderCheckoutRef? checkout;
  @override
  final OrderVendorRef vendor;
  @override
  final OrderDetailProcurementTypeEnum procurementType;
  @override
  final OrderDetailFulfillmentMethodEnum fulfillmentMethod;
  @override
  final OrderDetailPaymentMethodEnum paymentMethod;
  @override
  final DateTime? submittedAt;
  @override
  final DateTime? acceptedAt;
  @override
  final DateTime? closedAt;
  @override
  final String? terminalReasonCode;
  @override
  final OrderDetailConfirmationSourceEnum? confirmationSource;
  @override
  final BuiltList<OrderStateRow> states;
  @override
  final OrderDeadlines deadlines;
  @override
  final OrderCommercialVersion commercialVersion;
  @override
  final BuiltList<OrderChange> changes;
  @override
  final Date? expectedFulfillmentDate;
  @override
  final BuiltList<OrderLine> lines;
  @override
  final OrderDestination? destination;
  @override
  final OrderDelivery delivery;
  @override
  final MoneyBreakdown money;
  @override
  final OrderNrpc? nrpc;
  @override
  final BuiltList<OrderTimelineEvent> timeline;
  @override
  final int lockVersion;
  @override
  final BuiltList<OrderDetailAvailableActionsEnum>? availableActions;
  @override
  final OrderPaymentAvailability? payment;
  @override
  final OrderBuyerRef? buyer;
  @override
  final AutoAcceptOutcome? autoAccept;
  @override
  final BuiltList<OrderReservation>? reservations;
  @override
  final VendorOrderPermissions? permissions;
  @override
  final VendorOrderPrimaryAction? primaryAction;
  @override
  final NrpcTermsRef? nrpcTerms;
  @override
  final BuiltList<VendorOrderDeclineReason>? declineReasons;

  factory _$OrderDetail([void Function(OrderDetailBuilder)? updates]) =>
      (OrderDetailBuilder()..update(updates))._build();

  _$OrderDetail._(
      {this.projectContext,
      required this.id,
      required this.reference,
      this.checkout,
      required this.vendor,
      required this.procurementType,
      required this.fulfillmentMethod,
      required this.paymentMethod,
      this.submittedAt,
      this.acceptedAt,
      this.closedAt,
      this.terminalReasonCode,
      this.confirmationSource,
      required this.states,
      required this.deadlines,
      required this.commercialVersion,
      required this.changes,
      this.expectedFulfillmentDate,
      required this.lines,
      this.destination,
      required this.delivery,
      required this.money,
      this.nrpc,
      required this.timeline,
      required this.lockVersion,
      this.availableActions,
      this.payment,
      this.buyer,
      this.autoAccept,
      this.reservations,
      this.permissions,
      this.primaryAction,
      this.nrpcTerms,
      this.declineReasons})
      : super._();
  @override
  OrderDetail rebuild(void Function(OrderDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderDetailBuilder toBuilder() => OrderDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderDetail &&
        projectContext == other.projectContext &&
        id == other.id &&
        reference == other.reference &&
        checkout == other.checkout &&
        vendor == other.vendor &&
        procurementType == other.procurementType &&
        fulfillmentMethod == other.fulfillmentMethod &&
        paymentMethod == other.paymentMethod &&
        submittedAt == other.submittedAt &&
        acceptedAt == other.acceptedAt &&
        closedAt == other.closedAt &&
        terminalReasonCode == other.terminalReasonCode &&
        confirmationSource == other.confirmationSource &&
        states == other.states &&
        deadlines == other.deadlines &&
        commercialVersion == other.commercialVersion &&
        changes == other.changes &&
        expectedFulfillmentDate == other.expectedFulfillmentDate &&
        lines == other.lines &&
        destination == other.destination &&
        delivery == other.delivery &&
        money == other.money &&
        nrpc == other.nrpc &&
        timeline == other.timeline &&
        lockVersion == other.lockVersion &&
        availableActions == other.availableActions &&
        payment == other.payment &&
        buyer == other.buyer &&
        autoAccept == other.autoAccept &&
        reservations == other.reservations &&
        permissions == other.permissions &&
        primaryAction == other.primaryAction &&
        nrpcTerms == other.nrpcTerms &&
        declineReasons == other.declineReasons;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, projectContext.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, checkout.hashCode);
    _$hash = $jc(_$hash, vendor.hashCode);
    _$hash = $jc(_$hash, procurementType.hashCode);
    _$hash = $jc(_$hash, fulfillmentMethod.hashCode);
    _$hash = $jc(_$hash, paymentMethod.hashCode);
    _$hash = $jc(_$hash, submittedAt.hashCode);
    _$hash = $jc(_$hash, acceptedAt.hashCode);
    _$hash = $jc(_$hash, closedAt.hashCode);
    _$hash = $jc(_$hash, terminalReasonCode.hashCode);
    _$hash = $jc(_$hash, confirmationSource.hashCode);
    _$hash = $jc(_$hash, states.hashCode);
    _$hash = $jc(_$hash, deadlines.hashCode);
    _$hash = $jc(_$hash, commercialVersion.hashCode);
    _$hash = $jc(_$hash, changes.hashCode);
    _$hash = $jc(_$hash, expectedFulfillmentDate.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, destination.hashCode);
    _$hash = $jc(_$hash, delivery.hashCode);
    _$hash = $jc(_$hash, money.hashCode);
    _$hash = $jc(_$hash, nrpc.hashCode);
    _$hash = $jc(_$hash, timeline.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, availableActions.hashCode);
    _$hash = $jc(_$hash, payment.hashCode);
    _$hash = $jc(_$hash, buyer.hashCode);
    _$hash = $jc(_$hash, autoAccept.hashCode);
    _$hash = $jc(_$hash, reservations.hashCode);
    _$hash = $jc(_$hash, permissions.hashCode);
    _$hash = $jc(_$hash, primaryAction.hashCode);
    _$hash = $jc(_$hash, nrpcTerms.hashCode);
    _$hash = $jc(_$hash, declineReasons.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderDetail')
          ..add('projectContext', projectContext)
          ..add('id', id)
          ..add('reference', reference)
          ..add('checkout', checkout)
          ..add('vendor', vendor)
          ..add('procurementType', procurementType)
          ..add('fulfillmentMethod', fulfillmentMethod)
          ..add('paymentMethod', paymentMethod)
          ..add('submittedAt', submittedAt)
          ..add('acceptedAt', acceptedAt)
          ..add('closedAt', closedAt)
          ..add('terminalReasonCode', terminalReasonCode)
          ..add('confirmationSource', confirmationSource)
          ..add('states', states)
          ..add('deadlines', deadlines)
          ..add('commercialVersion', commercialVersion)
          ..add('changes', changes)
          ..add('expectedFulfillmentDate', expectedFulfillmentDate)
          ..add('lines', lines)
          ..add('destination', destination)
          ..add('delivery', delivery)
          ..add('money', money)
          ..add('nrpc', nrpc)
          ..add('timeline', timeline)
          ..add('lockVersion', lockVersion)
          ..add('availableActions', availableActions)
          ..add('payment', payment)
          ..add('buyer', buyer)
          ..add('autoAccept', autoAccept)
          ..add('reservations', reservations)
          ..add('permissions', permissions)
          ..add('primaryAction', primaryAction)
          ..add('nrpcTerms', nrpcTerms)
          ..add('declineReasons', declineReasons))
        .toString();
  }
}

class OrderDetailBuilder implements Builder<OrderDetail, OrderDetailBuilder> {
  _$OrderDetail? _$v;

  MapBuilder<String, JsonObject?>? _projectContext;
  MapBuilder<String, JsonObject?> get projectContext =>
      _$this._projectContext ??= MapBuilder<String, JsonObject?>();
  set projectContext(MapBuilder<String, JsonObject?>? projectContext) =>
      _$this._projectContext = projectContext;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(String? reference) => _$this._reference = reference;

  OrderCheckoutRefBuilder? _checkout;
  OrderCheckoutRefBuilder get checkout =>
      _$this._checkout ??= OrderCheckoutRefBuilder();
  set checkout(OrderCheckoutRefBuilder? checkout) =>
      _$this._checkout = checkout;

  OrderVendorRefBuilder? _vendor;
  OrderVendorRefBuilder get vendor =>
      _$this._vendor ??= OrderVendorRefBuilder();
  set vendor(OrderVendorRefBuilder? vendor) => _$this._vendor = vendor;

  OrderDetailProcurementTypeEnum? _procurementType;
  OrderDetailProcurementTypeEnum? get procurementType =>
      _$this._procurementType;
  set procurementType(OrderDetailProcurementTypeEnum? procurementType) =>
      _$this._procurementType = procurementType;

  OrderDetailFulfillmentMethodEnum? _fulfillmentMethod;
  OrderDetailFulfillmentMethodEnum? get fulfillmentMethod =>
      _$this._fulfillmentMethod;
  set fulfillmentMethod(OrderDetailFulfillmentMethodEnum? fulfillmentMethod) =>
      _$this._fulfillmentMethod = fulfillmentMethod;

  OrderDetailPaymentMethodEnum? _paymentMethod;
  OrderDetailPaymentMethodEnum? get paymentMethod => _$this._paymentMethod;
  set paymentMethod(OrderDetailPaymentMethodEnum? paymentMethod) =>
      _$this._paymentMethod = paymentMethod;

  DateTime? _submittedAt;
  DateTime? get submittedAt => _$this._submittedAt;
  set submittedAt(DateTime? submittedAt) => _$this._submittedAt = submittedAt;

  DateTime? _acceptedAt;
  DateTime? get acceptedAt => _$this._acceptedAt;
  set acceptedAt(DateTime? acceptedAt) => _$this._acceptedAt = acceptedAt;

  DateTime? _closedAt;
  DateTime? get closedAt => _$this._closedAt;
  set closedAt(DateTime? closedAt) => _$this._closedAt = closedAt;

  String? _terminalReasonCode;
  String? get terminalReasonCode => _$this._terminalReasonCode;
  set terminalReasonCode(String? terminalReasonCode) =>
      _$this._terminalReasonCode = terminalReasonCode;

  OrderDetailConfirmationSourceEnum? _confirmationSource;
  OrderDetailConfirmationSourceEnum? get confirmationSource =>
      _$this._confirmationSource;
  set confirmationSource(
          OrderDetailConfirmationSourceEnum? confirmationSource) =>
      _$this._confirmationSource = confirmationSource;

  ListBuilder<OrderStateRow>? _states;
  ListBuilder<OrderStateRow> get states =>
      _$this._states ??= ListBuilder<OrderStateRow>();
  set states(ListBuilder<OrderStateRow>? states) => _$this._states = states;

  OrderDeadlinesBuilder? _deadlines;
  OrderDeadlinesBuilder get deadlines =>
      _$this._deadlines ??= OrderDeadlinesBuilder();
  set deadlines(OrderDeadlinesBuilder? deadlines) =>
      _$this._deadlines = deadlines;

  OrderCommercialVersionBuilder? _commercialVersion;
  OrderCommercialVersionBuilder get commercialVersion =>
      _$this._commercialVersion ??= OrderCommercialVersionBuilder();
  set commercialVersion(OrderCommercialVersionBuilder? commercialVersion) =>
      _$this._commercialVersion = commercialVersion;

  ListBuilder<OrderChange>? _changes;
  ListBuilder<OrderChange> get changes =>
      _$this._changes ??= ListBuilder<OrderChange>();
  set changes(ListBuilder<OrderChange>? changes) => _$this._changes = changes;

  Date? _expectedFulfillmentDate;
  Date? get expectedFulfillmentDate => _$this._expectedFulfillmentDate;
  set expectedFulfillmentDate(Date? expectedFulfillmentDate) =>
      _$this._expectedFulfillmentDate = expectedFulfillmentDate;

  ListBuilder<OrderLine>? _lines;
  ListBuilder<OrderLine> get lines =>
      _$this._lines ??= ListBuilder<OrderLine>();
  set lines(ListBuilder<OrderLine>? lines) => _$this._lines = lines;

  OrderDestinationBuilder? _destination;
  OrderDestinationBuilder get destination =>
      _$this._destination ??= OrderDestinationBuilder();
  set destination(OrderDestinationBuilder? destination) =>
      _$this._destination = destination;

  OrderDeliveryBuilder? _delivery;
  OrderDeliveryBuilder get delivery =>
      _$this._delivery ??= OrderDeliveryBuilder();
  set delivery(OrderDeliveryBuilder? delivery) => _$this._delivery = delivery;

  MoneyBreakdownBuilder? _money;
  MoneyBreakdownBuilder get money => _$this._money ??= MoneyBreakdownBuilder();
  set money(MoneyBreakdownBuilder? money) => _$this._money = money;

  OrderNrpcBuilder? _nrpc;
  OrderNrpcBuilder get nrpc => _$this._nrpc ??= OrderNrpcBuilder();
  set nrpc(OrderNrpcBuilder? nrpc) => _$this._nrpc = nrpc;

  ListBuilder<OrderTimelineEvent>? _timeline;
  ListBuilder<OrderTimelineEvent> get timeline =>
      _$this._timeline ??= ListBuilder<OrderTimelineEvent>();
  set timeline(ListBuilder<OrderTimelineEvent>? timeline) =>
      _$this._timeline = timeline;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  ListBuilder<OrderDetailAvailableActionsEnum>? _availableActions;
  ListBuilder<OrderDetailAvailableActionsEnum> get availableActions =>
      _$this._availableActions ??=
          ListBuilder<OrderDetailAvailableActionsEnum>();
  set availableActions(
          ListBuilder<OrderDetailAvailableActionsEnum>? availableActions) =>
      _$this._availableActions = availableActions;

  OrderPaymentAvailabilityBuilder? _payment;
  OrderPaymentAvailabilityBuilder get payment =>
      _$this._payment ??= OrderPaymentAvailabilityBuilder();
  set payment(OrderPaymentAvailabilityBuilder? payment) =>
      _$this._payment = payment;

  OrderBuyerRefBuilder? _buyer;
  OrderBuyerRefBuilder get buyer => _$this._buyer ??= OrderBuyerRefBuilder();
  set buyer(OrderBuyerRefBuilder? buyer) => _$this._buyer = buyer;

  AutoAcceptOutcomeBuilder? _autoAccept;
  AutoAcceptOutcomeBuilder get autoAccept =>
      _$this._autoAccept ??= AutoAcceptOutcomeBuilder();
  set autoAccept(AutoAcceptOutcomeBuilder? autoAccept) =>
      _$this._autoAccept = autoAccept;

  ListBuilder<OrderReservation>? _reservations;
  ListBuilder<OrderReservation> get reservations =>
      _$this._reservations ??= ListBuilder<OrderReservation>();
  set reservations(ListBuilder<OrderReservation>? reservations) =>
      _$this._reservations = reservations;

  VendorOrderPermissionsBuilder? _permissions;
  VendorOrderPermissionsBuilder get permissions =>
      _$this._permissions ??= VendorOrderPermissionsBuilder();
  set permissions(VendorOrderPermissionsBuilder? permissions) =>
      _$this._permissions = permissions;

  VendorOrderPrimaryAction? _primaryAction;
  VendorOrderPrimaryAction? get primaryAction => _$this._primaryAction;
  set primaryAction(VendorOrderPrimaryAction? primaryAction) =>
      _$this._primaryAction = primaryAction;

  NrpcTermsRefBuilder? _nrpcTerms;
  NrpcTermsRefBuilder get nrpcTerms =>
      _$this._nrpcTerms ??= NrpcTermsRefBuilder();
  set nrpcTerms(NrpcTermsRefBuilder? nrpcTerms) =>
      _$this._nrpcTerms = nrpcTerms;

  ListBuilder<VendorOrderDeclineReason>? _declineReasons;
  ListBuilder<VendorOrderDeclineReason> get declineReasons =>
      _$this._declineReasons ??= ListBuilder<VendorOrderDeclineReason>();
  set declineReasons(ListBuilder<VendorOrderDeclineReason>? declineReasons) =>
      _$this._declineReasons = declineReasons;

  OrderDetailBuilder() {
    OrderDetail._defaults(this);
  }

  OrderDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _projectContext = $v.projectContext?.toBuilder();
      _id = $v.id;
      _reference = $v.reference;
      _checkout = $v.checkout?.toBuilder();
      _vendor = $v.vendor.toBuilder();
      _procurementType = $v.procurementType;
      _fulfillmentMethod = $v.fulfillmentMethod;
      _paymentMethod = $v.paymentMethod;
      _submittedAt = $v.submittedAt;
      _acceptedAt = $v.acceptedAt;
      _closedAt = $v.closedAt;
      _terminalReasonCode = $v.terminalReasonCode;
      _confirmationSource = $v.confirmationSource;
      _states = $v.states.toBuilder();
      _deadlines = $v.deadlines.toBuilder();
      _commercialVersion = $v.commercialVersion.toBuilder();
      _changes = $v.changes.toBuilder();
      _expectedFulfillmentDate = $v.expectedFulfillmentDate;
      _lines = $v.lines.toBuilder();
      _destination = $v.destination?.toBuilder();
      _delivery = $v.delivery.toBuilder();
      _money = $v.money.toBuilder();
      _nrpc = $v.nrpc?.toBuilder();
      _timeline = $v.timeline.toBuilder();
      _lockVersion = $v.lockVersion;
      _availableActions = $v.availableActions?.toBuilder();
      _payment = $v.payment?.toBuilder();
      _buyer = $v.buyer?.toBuilder();
      _autoAccept = $v.autoAccept?.toBuilder();
      _reservations = $v.reservations?.toBuilder();
      _permissions = $v.permissions?.toBuilder();
      _primaryAction = $v.primaryAction;
      _nrpcTerms = $v.nrpcTerms?.toBuilder();
      _declineReasons = $v.declineReasons?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderDetail other) {
    _$v = other as _$OrderDetail;
  }

  @override
  void update(void Function(OrderDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderDetail build() => _build();

  _$OrderDetail _build() {
    _$OrderDetail _$result;
    try {
      _$result = _$v ??
          _$OrderDetail._(
            projectContext: _projectContext?.build(),
            id: BuiltValueNullFieldError.checkNotNull(id, r'OrderDetail', 'id'),
            reference: BuiltValueNullFieldError.checkNotNull(
                reference, r'OrderDetail', 'reference'),
            checkout: _checkout?.build(),
            vendor: vendor.build(),
            procurementType: BuiltValueNullFieldError.checkNotNull(
                procurementType, r'OrderDetail', 'procurementType'),
            fulfillmentMethod: BuiltValueNullFieldError.checkNotNull(
                fulfillmentMethod, r'OrderDetail', 'fulfillmentMethod'),
            paymentMethod: BuiltValueNullFieldError.checkNotNull(
                paymentMethod, r'OrderDetail', 'paymentMethod'),
            submittedAt: submittedAt,
            acceptedAt: acceptedAt,
            closedAt: closedAt,
            terminalReasonCode: terminalReasonCode,
            confirmationSource: confirmationSource,
            states: states.build(),
            deadlines: deadlines.build(),
            commercialVersion: commercialVersion.build(),
            changes: changes.build(),
            expectedFulfillmentDate: expectedFulfillmentDate,
            lines: lines.build(),
            destination: _destination?.build(),
            delivery: delivery.build(),
            money: money.build(),
            nrpc: _nrpc?.build(),
            timeline: timeline.build(),
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'OrderDetail', 'lockVersion'),
            availableActions: _availableActions?.build(),
            payment: _payment?.build(),
            buyer: _buyer?.build(),
            autoAccept: _autoAccept?.build(),
            reservations: _reservations?.build(),
            permissions: _permissions?.build(),
            primaryAction: primaryAction,
            nrpcTerms: _nrpcTerms?.build(),
            declineReasons: _declineReasons?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'projectContext';
        _projectContext?.build();

        _$failedField = 'checkout';
        _checkout?.build();
        _$failedField = 'vendor';
        vendor.build();

        _$failedField = 'states';
        states.build();
        _$failedField = 'deadlines';
        deadlines.build();
        _$failedField = 'commercialVersion';
        commercialVersion.build();
        _$failedField = 'changes';
        changes.build();

        _$failedField = 'lines';
        lines.build();
        _$failedField = 'destination';
        _destination?.build();
        _$failedField = 'delivery';
        delivery.build();
        _$failedField = 'money';
        money.build();
        _$failedField = 'nrpc';
        _nrpc?.build();
        _$failedField = 'timeline';
        timeline.build();

        _$failedField = 'availableActions';
        _availableActions?.build();
        _$failedField = 'payment';
        _payment?.build();
        _$failedField = 'buyer';
        _buyer?.build();
        _$failedField = 'autoAccept';
        _autoAccept?.build();
        _$failedField = 'reservations';
        _reservations?.build();
        _$failedField = 'permissions';
        _permissions?.build();

        _$failedField = 'nrpcTerms';
        _nrpcTerms?.build();
        _$failedField = 'declineReasons';
        _declineReasons?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OrderDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
