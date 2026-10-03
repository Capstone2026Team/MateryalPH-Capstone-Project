// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_fulfillment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OrderFulfillmentMethodEnum _$orderFulfillmentMethodEnum_DELIVERY =
    const OrderFulfillmentMethodEnum._('DELIVERY');
const OrderFulfillmentMethodEnum _$orderFulfillmentMethodEnum_PICKUP =
    const OrderFulfillmentMethodEnum._('PICKUP');

OrderFulfillmentMethodEnum _$orderFulfillmentMethodEnumValueOf(String name) {
  switch (name) {
    case 'DELIVERY':
      return _$orderFulfillmentMethodEnum_DELIVERY;
    case 'PICKUP':
      return _$orderFulfillmentMethodEnum_PICKUP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderFulfillmentMethodEnum> _$orderFulfillmentMethodEnumValues =
    BuiltSet<OrderFulfillmentMethodEnum>(const <OrderFulfillmentMethodEnum>[
  _$orderFulfillmentMethodEnum_DELIVERY,
  _$orderFulfillmentMethodEnum_PICKUP,
]);

const OrderFulfillmentNextActionEnum
    _$orderFulfillmentNextActionEnum_START_PREPARATION =
    const OrderFulfillmentNextActionEnum._('START_PREPARATION');
const OrderFulfillmentNextActionEnum
    _$orderFulfillmentNextActionEnum_MARK_READY =
    const OrderFulfillmentNextActionEnum._('MARK_READY');
const OrderFulfillmentNextActionEnum _$orderFulfillmentNextActionEnum_DISPATCH =
    const OrderFulfillmentNextActionEnum._('DISPATCH');
const OrderFulfillmentNextActionEnum
    _$orderFulfillmentNextActionEnum_RECORD_PICKUP =
    const OrderFulfillmentNextActionEnum._('RECORD_PICKUP');
const OrderFulfillmentNextActionEnum
    _$orderFulfillmentNextActionEnum_RECORD_DELIVERY =
    const OrderFulfillmentNextActionEnum._('RECORD_DELIVERY');
const OrderFulfillmentNextActionEnum
    _$orderFulfillmentNextActionEnum_AWAIT_RECEIPT =
    const OrderFulfillmentNextActionEnum._('AWAIT_RECEIPT');
const OrderFulfillmentNextActionEnum
    _$orderFulfillmentNextActionEnum_RESPOND_TO_CANCELLATION =
    const OrderFulfillmentNextActionEnum._('RESPOND_TO_CANCELLATION');
const OrderFulfillmentNextActionEnum _$orderFulfillmentNextActionEnum_NONE =
    const OrderFulfillmentNextActionEnum._('NONE');
const OrderFulfillmentNextActionEnum
    _$orderFulfillmentNextActionEnum_CONFIRM_RECEIPT =
    const OrderFulfillmentNextActionEnum._('CONFIRM_RECEIPT');

OrderFulfillmentNextActionEnum _$orderFulfillmentNextActionEnumValueOf(
    String name) {
  switch (name) {
    case 'START_PREPARATION':
      return _$orderFulfillmentNextActionEnum_START_PREPARATION;
    case 'MARK_READY':
      return _$orderFulfillmentNextActionEnum_MARK_READY;
    case 'DISPATCH':
      return _$orderFulfillmentNextActionEnum_DISPATCH;
    case 'RECORD_PICKUP':
      return _$orderFulfillmentNextActionEnum_RECORD_PICKUP;
    case 'RECORD_DELIVERY':
      return _$orderFulfillmentNextActionEnum_RECORD_DELIVERY;
    case 'AWAIT_RECEIPT':
      return _$orderFulfillmentNextActionEnum_AWAIT_RECEIPT;
    case 'RESPOND_TO_CANCELLATION':
      return _$orderFulfillmentNextActionEnum_RESPOND_TO_CANCELLATION;
    case 'NONE':
      return _$orderFulfillmentNextActionEnum_NONE;
    case 'CONFIRM_RECEIPT':
      return _$orderFulfillmentNextActionEnum_CONFIRM_RECEIPT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderFulfillmentNextActionEnum>
    _$orderFulfillmentNextActionEnumValues = BuiltSet<
        OrderFulfillmentNextActionEnum>(const <OrderFulfillmentNextActionEnum>[
  _$orderFulfillmentNextActionEnum_START_PREPARATION,
  _$orderFulfillmentNextActionEnum_MARK_READY,
  _$orderFulfillmentNextActionEnum_DISPATCH,
  _$orderFulfillmentNextActionEnum_RECORD_PICKUP,
  _$orderFulfillmentNextActionEnum_RECORD_DELIVERY,
  _$orderFulfillmentNextActionEnum_AWAIT_RECEIPT,
  _$orderFulfillmentNextActionEnum_RESPOND_TO_CANCELLATION,
  _$orderFulfillmentNextActionEnum_NONE,
  _$orderFulfillmentNextActionEnum_CONFIRM_RECEIPT,
]);

Serializer<OrderFulfillmentMethodEnum> _$orderFulfillmentMethodEnumSerializer =
    _$OrderFulfillmentMethodEnumSerializer();
Serializer<OrderFulfillmentNextActionEnum>
    _$orderFulfillmentNextActionEnumSerializer =
    _$OrderFulfillmentNextActionEnumSerializer();

class _$OrderFulfillmentMethodEnumSerializer
    implements PrimitiveSerializer<OrderFulfillmentMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DELIVERY': 'DELIVERY',
    'PICKUP': 'PICKUP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DELIVERY': 'DELIVERY',
    'PICKUP': 'PICKUP',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderFulfillmentMethodEnum];
  @override
  final String wireName = 'OrderFulfillmentMethodEnum';

  @override
  Object serialize(Serializers serializers, OrderFulfillmentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderFulfillmentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderFulfillmentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderFulfillmentNextActionEnumSerializer
    implements PrimitiveSerializer<OrderFulfillmentNextActionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'START_PREPARATION': 'START_PREPARATION',
    'MARK_READY': 'MARK_READY',
    'DISPATCH': 'DISPATCH',
    'RECORD_PICKUP': 'RECORD_PICKUP',
    'RECORD_DELIVERY': 'RECORD_DELIVERY',
    'AWAIT_RECEIPT': 'AWAIT_RECEIPT',
    'RESPOND_TO_CANCELLATION': 'RESPOND_TO_CANCELLATION',
    'NONE': 'NONE',
    'CONFIRM_RECEIPT': 'CONFIRM_RECEIPT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'START_PREPARATION': 'START_PREPARATION',
    'MARK_READY': 'MARK_READY',
    'DISPATCH': 'DISPATCH',
    'RECORD_PICKUP': 'RECORD_PICKUP',
    'RECORD_DELIVERY': 'RECORD_DELIVERY',
    'AWAIT_RECEIPT': 'AWAIT_RECEIPT',
    'RESPOND_TO_CANCELLATION': 'RESPOND_TO_CANCELLATION',
    'NONE': 'NONE',
    'CONFIRM_RECEIPT': 'CONFIRM_RECEIPT',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderFulfillmentNextActionEnum];
  @override
  final String wireName = 'OrderFulfillmentNextActionEnum';

  @override
  Object serialize(
          Serializers serializers, OrderFulfillmentNextActionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderFulfillmentNextActionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderFulfillmentNextActionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderFulfillment extends OrderFulfillment {
  @override
  final OrderFulfillmentMethodEnum method;
  @override
  final String state;
  @override
  final String? expectedDate;
  @override
  final bool late_;
  @override
  final BuiltList<FulfillmentStep> steps;
  @override
  final FulfillmentProof? proof;
  @override
  final String trackingNotice;
  @override
  final BuiltList<FulfillmentTrip> trips;
  @override
  final FulfillmentArrangement? acceptedArrangement;
  @override
  final FulfillmentReceipt receipt;
  @override
  final FulfillmentIssue? issue;
  @override
  final FulfillmentAssignment? assignment;
  @override
  final BuiltList<FulfillmentVehicleIssue> vehicleIssues;
  @override
  final FulfillmentThreadRef thread;
  @override
  final OrderFulfillmentNextActionEnum nextAction;

  factory _$OrderFulfillment(
          [void Function(OrderFulfillmentBuilder)? updates]) =>
      (OrderFulfillmentBuilder()..update(updates))._build();

  _$OrderFulfillment._(
      {required this.method,
      required this.state,
      this.expectedDate,
      required this.late_,
      required this.steps,
      this.proof,
      required this.trackingNotice,
      required this.trips,
      this.acceptedArrangement,
      required this.receipt,
      this.issue,
      this.assignment,
      required this.vehicleIssues,
      required this.thread,
      required this.nextAction})
      : super._();
  @override
  OrderFulfillment rebuild(void Function(OrderFulfillmentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderFulfillmentBuilder toBuilder() =>
      OrderFulfillmentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderFulfillment &&
        method == other.method &&
        state == other.state &&
        expectedDate == other.expectedDate &&
        late_ == other.late_ &&
        steps == other.steps &&
        proof == other.proof &&
        trackingNotice == other.trackingNotice &&
        trips == other.trips &&
        acceptedArrangement == other.acceptedArrangement &&
        receipt == other.receipt &&
        issue == other.issue &&
        assignment == other.assignment &&
        vehicleIssues == other.vehicleIssues &&
        thread == other.thread &&
        nextAction == other.nextAction;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, method.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, expectedDate.hashCode);
    _$hash = $jc(_$hash, late_.hashCode);
    _$hash = $jc(_$hash, steps.hashCode);
    _$hash = $jc(_$hash, proof.hashCode);
    _$hash = $jc(_$hash, trackingNotice.hashCode);
    _$hash = $jc(_$hash, trips.hashCode);
    _$hash = $jc(_$hash, acceptedArrangement.hashCode);
    _$hash = $jc(_$hash, receipt.hashCode);
    _$hash = $jc(_$hash, issue.hashCode);
    _$hash = $jc(_$hash, assignment.hashCode);
    _$hash = $jc(_$hash, vehicleIssues.hashCode);
    _$hash = $jc(_$hash, thread.hashCode);
    _$hash = $jc(_$hash, nextAction.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderFulfillment')
          ..add('method', method)
          ..add('state', state)
          ..add('expectedDate', expectedDate)
          ..add('late_', late_)
          ..add('steps', steps)
          ..add('proof', proof)
          ..add('trackingNotice', trackingNotice)
          ..add('trips', trips)
          ..add('acceptedArrangement', acceptedArrangement)
          ..add('receipt', receipt)
          ..add('issue', issue)
          ..add('assignment', assignment)
          ..add('vehicleIssues', vehicleIssues)
          ..add('thread', thread)
          ..add('nextAction', nextAction))
        .toString();
  }
}

class OrderFulfillmentBuilder
    implements Builder<OrderFulfillment, OrderFulfillmentBuilder> {
  _$OrderFulfillment? _$v;

  OrderFulfillmentMethodEnum? _method;
  OrderFulfillmentMethodEnum? get method => _$this._method;
  set method(OrderFulfillmentMethodEnum? method) => _$this._method = method;

  String? _state;
  String? get state => _$this._state;
  set state(String? state) => _$this._state = state;

  String? _expectedDate;
  String? get expectedDate => _$this._expectedDate;
  set expectedDate(String? expectedDate) => _$this._expectedDate = expectedDate;

  bool? _late_;
  bool? get late_ => _$this._late_;
  set late_(bool? late_) => _$this._late_ = late_;

  ListBuilder<FulfillmentStep>? _steps;
  ListBuilder<FulfillmentStep> get steps =>
      _$this._steps ??= ListBuilder<FulfillmentStep>();
  set steps(ListBuilder<FulfillmentStep>? steps) => _$this._steps = steps;

  FulfillmentProofBuilder? _proof;
  FulfillmentProofBuilder get proof =>
      _$this._proof ??= FulfillmentProofBuilder();
  set proof(FulfillmentProofBuilder? proof) => _$this._proof = proof;

  String? _trackingNotice;
  String? get trackingNotice => _$this._trackingNotice;
  set trackingNotice(String? trackingNotice) =>
      _$this._trackingNotice = trackingNotice;

  ListBuilder<FulfillmentTrip>? _trips;
  ListBuilder<FulfillmentTrip> get trips =>
      _$this._trips ??= ListBuilder<FulfillmentTrip>();
  set trips(ListBuilder<FulfillmentTrip>? trips) => _$this._trips = trips;

  FulfillmentArrangementBuilder? _acceptedArrangement;
  FulfillmentArrangementBuilder get acceptedArrangement =>
      _$this._acceptedArrangement ??= FulfillmentArrangementBuilder();
  set acceptedArrangement(FulfillmentArrangementBuilder? acceptedArrangement) =>
      _$this._acceptedArrangement = acceptedArrangement;

  FulfillmentReceiptBuilder? _receipt;
  FulfillmentReceiptBuilder get receipt =>
      _$this._receipt ??= FulfillmentReceiptBuilder();
  set receipt(FulfillmentReceiptBuilder? receipt) => _$this._receipt = receipt;

  FulfillmentIssueBuilder? _issue;
  FulfillmentIssueBuilder get issue =>
      _$this._issue ??= FulfillmentIssueBuilder();
  set issue(FulfillmentIssueBuilder? issue) => _$this._issue = issue;

  FulfillmentAssignmentBuilder? _assignment;
  FulfillmentAssignmentBuilder get assignment =>
      _$this._assignment ??= FulfillmentAssignmentBuilder();
  set assignment(FulfillmentAssignmentBuilder? assignment) =>
      _$this._assignment = assignment;

  ListBuilder<FulfillmentVehicleIssue>? _vehicleIssues;
  ListBuilder<FulfillmentVehicleIssue> get vehicleIssues =>
      _$this._vehicleIssues ??= ListBuilder<FulfillmentVehicleIssue>();
  set vehicleIssues(ListBuilder<FulfillmentVehicleIssue>? vehicleIssues) =>
      _$this._vehicleIssues = vehicleIssues;

  FulfillmentThreadRefBuilder? _thread;
  FulfillmentThreadRefBuilder get thread =>
      _$this._thread ??= FulfillmentThreadRefBuilder();
  set thread(FulfillmentThreadRefBuilder? thread) => _$this._thread = thread;

  OrderFulfillmentNextActionEnum? _nextAction;
  OrderFulfillmentNextActionEnum? get nextAction => _$this._nextAction;
  set nextAction(OrderFulfillmentNextActionEnum? nextAction) =>
      _$this._nextAction = nextAction;

  OrderFulfillmentBuilder() {
    OrderFulfillment._defaults(this);
  }

  OrderFulfillmentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _method = $v.method;
      _state = $v.state;
      _expectedDate = $v.expectedDate;
      _late_ = $v.late_;
      _steps = $v.steps.toBuilder();
      _proof = $v.proof?.toBuilder();
      _trackingNotice = $v.trackingNotice;
      _trips = $v.trips.toBuilder();
      _acceptedArrangement = $v.acceptedArrangement?.toBuilder();
      _receipt = $v.receipt.toBuilder();
      _issue = $v.issue?.toBuilder();
      _assignment = $v.assignment?.toBuilder();
      _vehicleIssues = $v.vehicleIssues.toBuilder();
      _thread = $v.thread.toBuilder();
      _nextAction = $v.nextAction;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderFulfillment other) {
    _$v = other as _$OrderFulfillment;
  }

  @override
  void update(void Function(OrderFulfillmentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderFulfillment build() => _build();

  _$OrderFulfillment _build() {
    _$OrderFulfillment _$result;
    try {
      _$result = _$v ??
          _$OrderFulfillment._(
            method: BuiltValueNullFieldError.checkNotNull(
                method, r'OrderFulfillment', 'method'),
            state: BuiltValueNullFieldError.checkNotNull(
                state, r'OrderFulfillment', 'state'),
            expectedDate: expectedDate,
            late_: BuiltValueNullFieldError.checkNotNull(
                late_, r'OrderFulfillment', 'late_'),
            steps: steps.build(),
            proof: _proof?.build(),
            trackingNotice: BuiltValueNullFieldError.checkNotNull(
                trackingNotice, r'OrderFulfillment', 'trackingNotice'),
            trips: trips.build(),
            acceptedArrangement: _acceptedArrangement?.build(),
            receipt: receipt.build(),
            issue: _issue?.build(),
            assignment: _assignment?.build(),
            vehicleIssues: vehicleIssues.build(),
            thread: thread.build(),
            nextAction: BuiltValueNullFieldError.checkNotNull(
                nextAction, r'OrderFulfillment', 'nextAction'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'steps';
        steps.build();
        _$failedField = 'proof';
        _proof?.build();

        _$failedField = 'trips';
        trips.build();
        _$failedField = 'acceptedArrangement';
        _acceptedArrangement?.build();
        _$failedField = 'receipt';
        receipt.build();
        _$failedField = 'issue';
        _issue?.build();
        _$failedField = 'assignment';
        _assignment?.build();
        _$failedField = 'vehicleIssues';
        vehicleIssues.build();
        _$failedField = 'thread';
        thread.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OrderFulfillment', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
