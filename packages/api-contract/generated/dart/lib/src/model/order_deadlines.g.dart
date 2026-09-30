// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_deadlines.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OrderDeadlinesTimezoneEnum _$orderDeadlinesTimezoneEnum_asiaSlashManila =
    const OrderDeadlinesTimezoneEnum._('asiaSlashManila');

OrderDeadlinesTimezoneEnum _$orderDeadlinesTimezoneEnumValueOf(String name) {
  switch (name) {
    case 'asiaSlashManila':
      return _$orderDeadlinesTimezoneEnum_asiaSlashManila;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderDeadlinesTimezoneEnum> _$orderDeadlinesTimezoneEnumValues =
    BuiltSet<OrderDeadlinesTimezoneEnum>(const <OrderDeadlinesTimezoneEnum>[
  _$orderDeadlinesTimezoneEnum_asiaSlashManila,
]);

Serializer<OrderDeadlinesTimezoneEnum> _$orderDeadlinesTimezoneEnumSerializer =
    _$OrderDeadlinesTimezoneEnumSerializer();

class _$OrderDeadlinesTimezoneEnumSerializer
    implements PrimitiveSerializer<OrderDeadlinesTimezoneEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'asiaSlashManila': 'Asia/Manila',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Asia/Manila': 'asiaSlashManila',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderDeadlinesTimezoneEnum];
  @override
  final String wireName = 'OrderDeadlinesTimezoneEnum';

  @override
  Object serialize(Serializers serializers, OrderDeadlinesTimezoneEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderDeadlinesTimezoneEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderDeadlinesTimezoneEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderDeadlines extends OrderDeadlines {
  @override
  final DateTime? vendorResponseDueAt;
  @override
  final DateTime? buyerResponseDueAt;
  @override
  final DateTime? paymentExpiresAt;
  @override
  final DateTime serverTime;
  @override
  final OrderDeadlinesTimezoneEnum timezone;

  factory _$OrderDeadlines([void Function(OrderDeadlinesBuilder)? updates]) =>
      (OrderDeadlinesBuilder()..update(updates))._build();

  _$OrderDeadlines._(
      {this.vendorResponseDueAt,
      this.buyerResponseDueAt,
      this.paymentExpiresAt,
      required this.serverTime,
      required this.timezone})
      : super._();
  @override
  OrderDeadlines rebuild(void Function(OrderDeadlinesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderDeadlinesBuilder toBuilder() => OrderDeadlinesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderDeadlines &&
        vendorResponseDueAt == other.vendorResponseDueAt &&
        buyerResponseDueAt == other.buyerResponseDueAt &&
        paymentExpiresAt == other.paymentExpiresAt &&
        serverTime == other.serverTime &&
        timezone == other.timezone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vendorResponseDueAt.hashCode);
    _$hash = $jc(_$hash, buyerResponseDueAt.hashCode);
    _$hash = $jc(_$hash, paymentExpiresAt.hashCode);
    _$hash = $jc(_$hash, serverTime.hashCode);
    _$hash = $jc(_$hash, timezone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderDeadlines')
          ..add('vendorResponseDueAt', vendorResponseDueAt)
          ..add('buyerResponseDueAt', buyerResponseDueAt)
          ..add('paymentExpiresAt', paymentExpiresAt)
          ..add('serverTime', serverTime)
          ..add('timezone', timezone))
        .toString();
  }
}

class OrderDeadlinesBuilder
    implements Builder<OrderDeadlines, OrderDeadlinesBuilder> {
  _$OrderDeadlines? _$v;

  DateTime? _vendorResponseDueAt;
  DateTime? get vendorResponseDueAt => _$this._vendorResponseDueAt;
  set vendorResponseDueAt(DateTime? vendorResponseDueAt) =>
      _$this._vendorResponseDueAt = vendorResponseDueAt;

  DateTime? _buyerResponseDueAt;
  DateTime? get buyerResponseDueAt => _$this._buyerResponseDueAt;
  set buyerResponseDueAt(DateTime? buyerResponseDueAt) =>
      _$this._buyerResponseDueAt = buyerResponseDueAt;

  DateTime? _paymentExpiresAt;
  DateTime? get paymentExpiresAt => _$this._paymentExpiresAt;
  set paymentExpiresAt(DateTime? paymentExpiresAt) =>
      _$this._paymentExpiresAt = paymentExpiresAt;

  DateTime? _serverTime;
  DateTime? get serverTime => _$this._serverTime;
  set serverTime(DateTime? serverTime) => _$this._serverTime = serverTime;

  OrderDeadlinesTimezoneEnum? _timezone;
  OrderDeadlinesTimezoneEnum? get timezone => _$this._timezone;
  set timezone(OrderDeadlinesTimezoneEnum? timezone) =>
      _$this._timezone = timezone;

  OrderDeadlinesBuilder() {
    OrderDeadlines._defaults(this);
  }

  OrderDeadlinesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vendorResponseDueAt = $v.vendorResponseDueAt;
      _buyerResponseDueAt = $v.buyerResponseDueAt;
      _paymentExpiresAt = $v.paymentExpiresAt;
      _serverTime = $v.serverTime;
      _timezone = $v.timezone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderDeadlines other) {
    _$v = other as _$OrderDeadlines;
  }

  @override
  void update(void Function(OrderDeadlinesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderDeadlines build() => _build();

  _$OrderDeadlines _build() {
    final _$result = _$v ??
        _$OrderDeadlines._(
          vendorResponseDueAt: vendorResponseDueAt,
          buyerResponseDueAt: buyerResponseDueAt,
          paymentExpiresAt: paymentExpiresAt,
          serverTime: BuiltValueNullFieldError.checkNotNull(
              serverTime, r'OrderDeadlines', 'serverTime'),
          timezone: BuiltValueNullFieldError.checkNotNull(
              timezone, r'OrderDeadlines', 'timezone'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
