// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_timeline_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OrderTimelineEventFamilyEnum _$orderTimelineEventFamilyEnum_ORDER =
    const OrderTimelineEventFamilyEnum._('ORDER');
const OrderTimelineEventFamilyEnum _$orderTimelineEventFamilyEnum_PAYMENT =
    const OrderTimelineEventFamilyEnum._('PAYMENT');
const OrderTimelineEventFamilyEnum _$orderTimelineEventFamilyEnum_FULFILLMENT =
    const OrderTimelineEventFamilyEnum._('FULFILLMENT');
const OrderTimelineEventFamilyEnum _$orderTimelineEventFamilyEnum_REFUND =
    const OrderTimelineEventFamilyEnum._('REFUND');
const OrderTimelineEventFamilyEnum _$orderTimelineEventFamilyEnum_DISPUTE =
    const OrderTimelineEventFamilyEnum._('DISPUTE');

OrderTimelineEventFamilyEnum _$orderTimelineEventFamilyEnumValueOf(
    String name) {
  switch (name) {
    case 'ORDER':
      return _$orderTimelineEventFamilyEnum_ORDER;
    case 'PAYMENT':
      return _$orderTimelineEventFamilyEnum_PAYMENT;
    case 'FULFILLMENT':
      return _$orderTimelineEventFamilyEnum_FULFILLMENT;
    case 'REFUND':
      return _$orderTimelineEventFamilyEnum_REFUND;
    case 'DISPUTE':
      return _$orderTimelineEventFamilyEnum_DISPUTE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderTimelineEventFamilyEnum>
    _$orderTimelineEventFamilyEnumValues =
    BuiltSet<OrderTimelineEventFamilyEnum>(const <OrderTimelineEventFamilyEnum>[
  _$orderTimelineEventFamilyEnum_ORDER,
  _$orderTimelineEventFamilyEnum_PAYMENT,
  _$orderTimelineEventFamilyEnum_FULFILLMENT,
  _$orderTimelineEventFamilyEnum_REFUND,
  _$orderTimelineEventFamilyEnum_DISPUTE,
]);

const OrderTimelineEventSource_Enum _$orderTimelineEventSourceEnum_BUYER =
    const OrderTimelineEventSource_Enum._('BUYER');
const OrderTimelineEventSource_Enum _$orderTimelineEventSourceEnum_VENDOR =
    const OrderTimelineEventSource_Enum._('VENDOR');
const OrderTimelineEventSource_Enum _$orderTimelineEventSourceEnum_SYSTEM =
    const OrderTimelineEventSource_Enum._('SYSTEM');
const OrderTimelineEventSource_Enum _$orderTimelineEventSourceEnum_AUTO_ACCEPT =
    const OrderTimelineEventSource_Enum._('AUTO_ACCEPT');

OrderTimelineEventSource_Enum _$orderTimelineEventSourceEnumValueOf(
    String name) {
  switch (name) {
    case 'BUYER':
      return _$orderTimelineEventSourceEnum_BUYER;
    case 'VENDOR':
      return _$orderTimelineEventSourceEnum_VENDOR;
    case 'SYSTEM':
      return _$orderTimelineEventSourceEnum_SYSTEM;
    case 'AUTO_ACCEPT':
      return _$orderTimelineEventSourceEnum_AUTO_ACCEPT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderTimelineEventSource_Enum>
    _$orderTimelineEventSourceEnumValues = BuiltSet<
        OrderTimelineEventSource_Enum>(const <OrderTimelineEventSource_Enum>[
  _$orderTimelineEventSourceEnum_BUYER,
  _$orderTimelineEventSourceEnum_VENDOR,
  _$orderTimelineEventSourceEnum_SYSTEM,
  _$orderTimelineEventSourceEnum_AUTO_ACCEPT,
]);

Serializer<OrderTimelineEventFamilyEnum>
    _$orderTimelineEventFamilyEnumSerializer =
    _$OrderTimelineEventFamilyEnumSerializer();
Serializer<OrderTimelineEventSource_Enum>
    _$orderTimelineEventSourceEnumSerializer =
    _$OrderTimelineEventSource_EnumSerializer();

class _$OrderTimelineEventFamilyEnumSerializer
    implements PrimitiveSerializer<OrderTimelineEventFamilyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ORDER': 'ORDER',
    'PAYMENT': 'PAYMENT',
    'FULFILLMENT': 'FULFILLMENT',
    'REFUND': 'REFUND',
    'DISPUTE': 'DISPUTE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ORDER': 'ORDER',
    'PAYMENT': 'PAYMENT',
    'FULFILLMENT': 'FULFILLMENT',
    'REFUND': 'REFUND',
    'DISPUTE': 'DISPUTE',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderTimelineEventFamilyEnum];
  @override
  final String wireName = 'OrderTimelineEventFamilyEnum';

  @override
  Object serialize(Serializers serializers, OrderTimelineEventFamilyEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderTimelineEventFamilyEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderTimelineEventFamilyEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderTimelineEventSource_EnumSerializer
    implements PrimitiveSerializer<OrderTimelineEventSource_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
    'SYSTEM': 'SYSTEM',
    'AUTO_ACCEPT': 'AUTO_ACCEPT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
    'SYSTEM': 'SYSTEM',
    'AUTO_ACCEPT': 'AUTO_ACCEPT',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderTimelineEventSource_Enum];
  @override
  final String wireName = 'OrderTimelineEventSource_Enum';

  @override
  Object serialize(
          Serializers serializers, OrderTimelineEventSource_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderTimelineEventSource_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderTimelineEventSource_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderTimelineEvent extends OrderTimelineEvent {
  @override
  final OrderTimelineEventFamilyEnum family;
  @override
  final String? fromState;
  @override
  final String toState;
  @override
  final OrderTimelineEventSource_Enum source_;
  @override
  final String? actorRole;
  @override
  final String? reasonCode;
  @override
  final int? snapshotVersion;
  @override
  final DateTime? at;

  factory _$OrderTimelineEvent(
          [void Function(OrderTimelineEventBuilder)? updates]) =>
      (OrderTimelineEventBuilder()..update(updates))._build();

  _$OrderTimelineEvent._(
      {required this.family,
      this.fromState,
      required this.toState,
      required this.source_,
      this.actorRole,
      this.reasonCode,
      this.snapshotVersion,
      this.at})
      : super._();
  @override
  OrderTimelineEvent rebuild(
          void Function(OrderTimelineEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderTimelineEventBuilder toBuilder() =>
      OrderTimelineEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderTimelineEvent &&
        family == other.family &&
        fromState == other.fromState &&
        toState == other.toState &&
        source_ == other.source_ &&
        actorRole == other.actorRole &&
        reasonCode == other.reasonCode &&
        snapshotVersion == other.snapshotVersion &&
        at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, family.hashCode);
    _$hash = $jc(_$hash, fromState.hashCode);
    _$hash = $jc(_$hash, toState.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jc(_$hash, actorRole.hashCode);
    _$hash = $jc(_$hash, reasonCode.hashCode);
    _$hash = $jc(_$hash, snapshotVersion.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderTimelineEvent')
          ..add('family', family)
          ..add('fromState', fromState)
          ..add('toState', toState)
          ..add('source_', source_)
          ..add('actorRole', actorRole)
          ..add('reasonCode', reasonCode)
          ..add('snapshotVersion', snapshotVersion)
          ..add('at', at))
        .toString();
  }
}

class OrderTimelineEventBuilder
    implements Builder<OrderTimelineEvent, OrderTimelineEventBuilder> {
  _$OrderTimelineEvent? _$v;

  OrderTimelineEventFamilyEnum? _family;
  OrderTimelineEventFamilyEnum? get family => _$this._family;
  set family(OrderTimelineEventFamilyEnum? family) => _$this._family = family;

  String? _fromState;
  String? get fromState => _$this._fromState;
  set fromState(String? fromState) => _$this._fromState = fromState;

  String? _toState;
  String? get toState => _$this._toState;
  set toState(String? toState) => _$this._toState = toState;

  OrderTimelineEventSource_Enum? _source_;
  OrderTimelineEventSource_Enum? get source_ => _$this._source_;
  set source_(OrderTimelineEventSource_Enum? source_) =>
      _$this._source_ = source_;

  String? _actorRole;
  String? get actorRole => _$this._actorRole;
  set actorRole(String? actorRole) => _$this._actorRole = actorRole;

  String? _reasonCode;
  String? get reasonCode => _$this._reasonCode;
  set reasonCode(String? reasonCode) => _$this._reasonCode = reasonCode;

  int? _snapshotVersion;
  int? get snapshotVersion => _$this._snapshotVersion;
  set snapshotVersion(int? snapshotVersion) =>
      _$this._snapshotVersion = snapshotVersion;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  OrderTimelineEventBuilder() {
    OrderTimelineEvent._defaults(this);
  }

  OrderTimelineEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _family = $v.family;
      _fromState = $v.fromState;
      _toState = $v.toState;
      _source_ = $v.source_;
      _actorRole = $v.actorRole;
      _reasonCode = $v.reasonCode;
      _snapshotVersion = $v.snapshotVersion;
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderTimelineEvent other) {
    _$v = other as _$OrderTimelineEvent;
  }

  @override
  void update(void Function(OrderTimelineEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderTimelineEvent build() => _build();

  _$OrderTimelineEvent _build() {
    final _$result = _$v ??
        _$OrderTimelineEvent._(
          family: BuiltValueNullFieldError.checkNotNull(
              family, r'OrderTimelineEvent', 'family'),
          fromState: fromState,
          toState: BuiltValueNullFieldError.checkNotNull(
              toState, r'OrderTimelineEvent', 'toState'),
          source_: BuiltValueNullFieldError.checkNotNull(
              source_, r'OrderTimelineEvent', 'source_'),
          actorRole: actorRole,
          reasonCode: reasonCode,
          snapshotVersion: snapshotVersion,
          at: at,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
