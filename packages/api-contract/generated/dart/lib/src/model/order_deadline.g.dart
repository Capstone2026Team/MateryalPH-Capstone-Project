// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_deadline.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OrderDeadlineKindEnum _$orderDeadlineKindEnum_VENDOR_RESPONSE =
    const OrderDeadlineKindEnum._('VENDOR_RESPONSE');
const OrderDeadlineKindEnum _$orderDeadlineKindEnum_BUYER_RESPONSE =
    const OrderDeadlineKindEnum._('BUYER_RESPONSE');
const OrderDeadlineKindEnum _$orderDeadlineKindEnum_PAYMENT =
    const OrderDeadlineKindEnum._('PAYMENT');

OrderDeadlineKindEnum _$orderDeadlineKindEnumValueOf(String name) {
  switch (name) {
    case 'VENDOR_RESPONSE':
      return _$orderDeadlineKindEnum_VENDOR_RESPONSE;
    case 'BUYER_RESPONSE':
      return _$orderDeadlineKindEnum_BUYER_RESPONSE;
    case 'PAYMENT':
      return _$orderDeadlineKindEnum_PAYMENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderDeadlineKindEnum> _$orderDeadlineKindEnumValues =
    BuiltSet<OrderDeadlineKindEnum>(const <OrderDeadlineKindEnum>[
  _$orderDeadlineKindEnum_VENDOR_RESPONSE,
  _$orderDeadlineKindEnum_BUYER_RESPONSE,
  _$orderDeadlineKindEnum_PAYMENT,
]);

Serializer<OrderDeadlineKindEnum> _$orderDeadlineKindEnumSerializer =
    _$OrderDeadlineKindEnumSerializer();

class _$OrderDeadlineKindEnumSerializer
    implements PrimitiveSerializer<OrderDeadlineKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VENDOR_RESPONSE': 'VENDOR_RESPONSE',
    'BUYER_RESPONSE': 'BUYER_RESPONSE',
    'PAYMENT': 'PAYMENT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VENDOR_RESPONSE': 'VENDOR_RESPONSE',
    'BUYER_RESPONSE': 'BUYER_RESPONSE',
    'PAYMENT': 'PAYMENT',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderDeadlineKindEnum];
  @override
  final String wireName = 'OrderDeadlineKindEnum';

  @override
  Object serialize(Serializers serializers, OrderDeadlineKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderDeadlineKindEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderDeadlineKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderDeadline extends OrderDeadline {
  @override
  final OrderDeadlineKindEnum kind;
  @override
  final DateTime at;

  factory _$OrderDeadline([void Function(OrderDeadlineBuilder)? updates]) =>
      (OrderDeadlineBuilder()..update(updates))._build();

  _$OrderDeadline._({required this.kind, required this.at}) : super._();
  @override
  OrderDeadline rebuild(void Function(OrderDeadlineBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderDeadlineBuilder toBuilder() => OrderDeadlineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderDeadline && kind == other.kind && at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderDeadline')
          ..add('kind', kind)
          ..add('at', at))
        .toString();
  }
}

class OrderDeadlineBuilder
    implements Builder<OrderDeadline, OrderDeadlineBuilder> {
  _$OrderDeadline? _$v;

  OrderDeadlineKindEnum? _kind;
  OrderDeadlineKindEnum? get kind => _$this._kind;
  set kind(OrderDeadlineKindEnum? kind) => _$this._kind = kind;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  OrderDeadlineBuilder() {
    OrderDeadline._defaults(this);
  }

  OrderDeadlineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderDeadline other) {
    _$v = other as _$OrderDeadline;
  }

  @override
  void update(void Function(OrderDeadlineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderDeadline build() => _build();

  _$OrderDeadline _build() {
    final _$result = _$v ??
        _$OrderDeadline._(
          kind: BuiltValueNullFieldError.checkNotNull(
              kind, r'OrderDeadline', 'kind'),
          at: BuiltValueNullFieldError.checkNotNull(at, r'OrderDeadline', 'at'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
