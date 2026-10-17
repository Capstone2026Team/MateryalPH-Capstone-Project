// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fulfillment_conversation_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FulfillmentConversationSummaryFulfillmentMethodEnum
    _$fulfillmentConversationSummaryFulfillmentMethodEnum_PICKUP =
    const FulfillmentConversationSummaryFulfillmentMethodEnum._('PICKUP');
const FulfillmentConversationSummaryFulfillmentMethodEnum
    _$fulfillmentConversationSummaryFulfillmentMethodEnum_DELIVERY =
    const FulfillmentConversationSummaryFulfillmentMethodEnum._('DELIVERY');

FulfillmentConversationSummaryFulfillmentMethodEnum
    _$fulfillmentConversationSummaryFulfillmentMethodEnumValueOf(String name) {
  switch (name) {
    case 'PICKUP':
      return _$fulfillmentConversationSummaryFulfillmentMethodEnum_PICKUP;
    case 'DELIVERY':
      return _$fulfillmentConversationSummaryFulfillmentMethodEnum_DELIVERY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FulfillmentConversationSummaryFulfillmentMethodEnum>
    _$fulfillmentConversationSummaryFulfillmentMethodEnumValues = BuiltSet<
        FulfillmentConversationSummaryFulfillmentMethodEnum>(const <FulfillmentConversationSummaryFulfillmentMethodEnum>[
  _$fulfillmentConversationSummaryFulfillmentMethodEnum_PICKUP,
  _$fulfillmentConversationSummaryFulfillmentMethodEnum_DELIVERY,
]);

const FulfillmentConversationSummaryReadOnlyReasonEnum
    _$fulfillmentConversationSummaryReadOnlyReasonEnum_ORDER_COMPLETED =
    const FulfillmentConversationSummaryReadOnlyReasonEnum._('ORDER_COMPLETED');
const FulfillmentConversationSummaryReadOnlyReasonEnum
    _$fulfillmentConversationSummaryReadOnlyReasonEnum_ORDER_CANCELLED =
    const FulfillmentConversationSummaryReadOnlyReasonEnum._('ORDER_CANCELLED');
const FulfillmentConversationSummaryReadOnlyReasonEnum
    _$fulfillmentConversationSummaryReadOnlyReasonEnum_ORDER_NOT_IN_FULFILLMENT =
    const FulfillmentConversationSummaryReadOnlyReasonEnum._(
        'ORDER_NOT_IN_FULFILLMENT');

FulfillmentConversationSummaryReadOnlyReasonEnum
    _$fulfillmentConversationSummaryReadOnlyReasonEnumValueOf(String name) {
  switch (name) {
    case 'ORDER_COMPLETED':
      return _$fulfillmentConversationSummaryReadOnlyReasonEnum_ORDER_COMPLETED;
    case 'ORDER_CANCELLED':
      return _$fulfillmentConversationSummaryReadOnlyReasonEnum_ORDER_CANCELLED;
    case 'ORDER_NOT_IN_FULFILLMENT':
      return _$fulfillmentConversationSummaryReadOnlyReasonEnum_ORDER_NOT_IN_FULFILLMENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FulfillmentConversationSummaryReadOnlyReasonEnum>
    _$fulfillmentConversationSummaryReadOnlyReasonEnumValues = BuiltSet<
        FulfillmentConversationSummaryReadOnlyReasonEnum>(const <FulfillmentConversationSummaryReadOnlyReasonEnum>[
  _$fulfillmentConversationSummaryReadOnlyReasonEnum_ORDER_COMPLETED,
  _$fulfillmentConversationSummaryReadOnlyReasonEnum_ORDER_CANCELLED,
  _$fulfillmentConversationSummaryReadOnlyReasonEnum_ORDER_NOT_IN_FULFILLMENT,
]);

Serializer<FulfillmentConversationSummaryFulfillmentMethodEnum>
    _$fulfillmentConversationSummaryFulfillmentMethodEnumSerializer =
    _$FulfillmentConversationSummaryFulfillmentMethodEnumSerializer();
Serializer<FulfillmentConversationSummaryReadOnlyReasonEnum>
    _$fulfillmentConversationSummaryReadOnlyReasonEnumSerializer =
    _$FulfillmentConversationSummaryReadOnlyReasonEnumSerializer();

class _$FulfillmentConversationSummaryFulfillmentMethodEnumSerializer
    implements
        PrimitiveSerializer<
            FulfillmentConversationSummaryFulfillmentMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PICKUP': 'PICKUP',
    'DELIVERY': 'DELIVERY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PICKUP': 'PICKUP',
    'DELIVERY': 'DELIVERY',
  };

  @override
  final Iterable<Type> types = const <Type>[
    FulfillmentConversationSummaryFulfillmentMethodEnum
  ];
  @override
  final String wireName = 'FulfillmentConversationSummaryFulfillmentMethodEnum';

  @override
  Object serialize(Serializers serializers,
          FulfillmentConversationSummaryFulfillmentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FulfillmentConversationSummaryFulfillmentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FulfillmentConversationSummaryFulfillmentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FulfillmentConversationSummaryReadOnlyReasonEnumSerializer
    implements
        PrimitiveSerializer<FulfillmentConversationSummaryReadOnlyReasonEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ORDER_COMPLETED': 'ORDER_COMPLETED',
    'ORDER_CANCELLED': 'ORDER_CANCELLED',
    'ORDER_NOT_IN_FULFILLMENT': 'ORDER_NOT_IN_FULFILLMENT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ORDER_COMPLETED': 'ORDER_COMPLETED',
    'ORDER_CANCELLED': 'ORDER_CANCELLED',
    'ORDER_NOT_IN_FULFILLMENT': 'ORDER_NOT_IN_FULFILLMENT',
  };

  @override
  final Iterable<Type> types = const <Type>[
    FulfillmentConversationSummaryReadOnlyReasonEnum
  ];
  @override
  final String wireName = 'FulfillmentConversationSummaryReadOnlyReasonEnum';

  @override
  Object serialize(Serializers serializers,
          FulfillmentConversationSummaryReadOnlyReasonEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FulfillmentConversationSummaryReadOnlyReasonEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FulfillmentConversationSummaryReadOnlyReasonEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FulfillmentConversationSummary extends FulfillmentConversationSummary {
  @override
  final String conversationId;
  @override
  final String orderId;
  @override
  final String orderReference;
  @override
  final String orderState;
  @override
  final FulfillmentConversationSummaryFulfillmentMethodEnum fulfillmentMethod;
  @override
  final int unreadCount;
  @override
  final DateTime updatedAt;
  @override
  final bool readOnly;
  @override
  final FulfillmentConversationSummaryReadOnlyReasonEnum? readOnlyReason;

  factory _$FulfillmentConversationSummary(
          [void Function(FulfillmentConversationSummaryBuilder)? updates]) =>
      (FulfillmentConversationSummaryBuilder()..update(updates))._build();

  _$FulfillmentConversationSummary._(
      {required this.conversationId,
      required this.orderId,
      required this.orderReference,
      required this.orderState,
      required this.fulfillmentMethod,
      required this.unreadCount,
      required this.updatedAt,
      required this.readOnly,
      this.readOnlyReason})
      : super._();
  @override
  FulfillmentConversationSummary rebuild(
          void Function(FulfillmentConversationSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FulfillmentConversationSummaryBuilder toBuilder() =>
      FulfillmentConversationSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FulfillmentConversationSummary &&
        conversationId == other.conversationId &&
        orderId == other.orderId &&
        orderReference == other.orderReference &&
        orderState == other.orderState &&
        fulfillmentMethod == other.fulfillmentMethod &&
        unreadCount == other.unreadCount &&
        updatedAt == other.updatedAt &&
        readOnly == other.readOnly &&
        readOnlyReason == other.readOnlyReason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, conversationId.hashCode);
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, orderReference.hashCode);
    _$hash = $jc(_$hash, orderState.hashCode);
    _$hash = $jc(_$hash, fulfillmentMethod.hashCode);
    _$hash = $jc(_$hash, unreadCount.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, readOnly.hashCode);
    _$hash = $jc(_$hash, readOnlyReason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FulfillmentConversationSummary')
          ..add('conversationId', conversationId)
          ..add('orderId', orderId)
          ..add('orderReference', orderReference)
          ..add('orderState', orderState)
          ..add('fulfillmentMethod', fulfillmentMethod)
          ..add('unreadCount', unreadCount)
          ..add('updatedAt', updatedAt)
          ..add('readOnly', readOnly)
          ..add('readOnlyReason', readOnlyReason))
        .toString();
  }
}

class FulfillmentConversationSummaryBuilder
    implements
        Builder<FulfillmentConversationSummary,
            FulfillmentConversationSummaryBuilder> {
  _$FulfillmentConversationSummary? _$v;

  String? _conversationId;
  String? get conversationId => _$this._conversationId;
  set conversationId(String? conversationId) =>
      _$this._conversationId = conversationId;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _orderReference;
  String? get orderReference => _$this._orderReference;
  set orderReference(String? orderReference) =>
      _$this._orderReference = orderReference;

  String? _orderState;
  String? get orderState => _$this._orderState;
  set orderState(String? orderState) => _$this._orderState = orderState;

  FulfillmentConversationSummaryFulfillmentMethodEnum? _fulfillmentMethod;
  FulfillmentConversationSummaryFulfillmentMethodEnum? get fulfillmentMethod =>
      _$this._fulfillmentMethod;
  set fulfillmentMethod(
          FulfillmentConversationSummaryFulfillmentMethodEnum?
              fulfillmentMethod) =>
      _$this._fulfillmentMethod = fulfillmentMethod;

  int? _unreadCount;
  int? get unreadCount => _$this._unreadCount;
  set unreadCount(int? unreadCount) => _$this._unreadCount = unreadCount;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  bool? _readOnly;
  bool? get readOnly => _$this._readOnly;
  set readOnly(bool? readOnly) => _$this._readOnly = readOnly;

  FulfillmentConversationSummaryReadOnlyReasonEnum? _readOnlyReason;
  FulfillmentConversationSummaryReadOnlyReasonEnum? get readOnlyReason =>
      _$this._readOnlyReason;
  set readOnlyReason(
          FulfillmentConversationSummaryReadOnlyReasonEnum? readOnlyReason) =>
      _$this._readOnlyReason = readOnlyReason;

  FulfillmentConversationSummaryBuilder() {
    FulfillmentConversationSummary._defaults(this);
  }

  FulfillmentConversationSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _conversationId = $v.conversationId;
      _orderId = $v.orderId;
      _orderReference = $v.orderReference;
      _orderState = $v.orderState;
      _fulfillmentMethod = $v.fulfillmentMethod;
      _unreadCount = $v.unreadCount;
      _updatedAt = $v.updatedAt;
      _readOnly = $v.readOnly;
      _readOnlyReason = $v.readOnlyReason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FulfillmentConversationSummary other) {
    _$v = other as _$FulfillmentConversationSummary;
  }

  @override
  void update(void Function(FulfillmentConversationSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FulfillmentConversationSummary build() => _build();

  _$FulfillmentConversationSummary _build() {
    final _$result = _$v ??
        _$FulfillmentConversationSummary._(
          conversationId: BuiltValueNullFieldError.checkNotNull(conversationId,
              r'FulfillmentConversationSummary', 'conversationId'),
          orderId: BuiltValueNullFieldError.checkNotNull(
              orderId, r'FulfillmentConversationSummary', 'orderId'),
          orderReference: BuiltValueNullFieldError.checkNotNull(orderReference,
              r'FulfillmentConversationSummary', 'orderReference'),
          orderState: BuiltValueNullFieldError.checkNotNull(
              orderState, r'FulfillmentConversationSummary', 'orderState'),
          fulfillmentMethod: BuiltValueNullFieldError.checkNotNull(
              fulfillmentMethod,
              r'FulfillmentConversationSummary',
              'fulfillmentMethod'),
          unreadCount: BuiltValueNullFieldError.checkNotNull(
              unreadCount, r'FulfillmentConversationSummary', 'unreadCount'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'FulfillmentConversationSummary', 'updatedAt'),
          readOnly: BuiltValueNullFieldError.checkNotNull(
              readOnly, r'FulfillmentConversationSummary', 'readOnly'),
          readOnlyReason: readOnlyReason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
