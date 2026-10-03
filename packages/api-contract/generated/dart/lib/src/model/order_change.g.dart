// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_change.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OrderChangeTypeEnum _$orderChangeTypeEnum_QUANTITY_REDUCED =
    const OrderChangeTypeEnum._('QUANTITY_REDUCED');
const OrderChangeTypeEnum _$orderChangeTypeEnum_LINE_REMOVED =
    const OrderChangeTypeEnum._('LINE_REMOVED');
const OrderChangeTypeEnum _$orderChangeTypeEnum_VENDOR_DISCOUNT =
    const OrderChangeTypeEnum._('VENDOR_DISCOUNT');

OrderChangeTypeEnum _$orderChangeTypeEnumValueOf(String name) {
  switch (name) {
    case 'QUANTITY_REDUCED':
      return _$orderChangeTypeEnum_QUANTITY_REDUCED;
    case 'LINE_REMOVED':
      return _$orderChangeTypeEnum_LINE_REMOVED;
    case 'VENDOR_DISCOUNT':
      return _$orderChangeTypeEnum_VENDOR_DISCOUNT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderChangeTypeEnum> _$orderChangeTypeEnumValues =
    BuiltSet<OrderChangeTypeEnum>(const <OrderChangeTypeEnum>[
  _$orderChangeTypeEnum_QUANTITY_REDUCED,
  _$orderChangeTypeEnum_LINE_REMOVED,
  _$orderChangeTypeEnum_VENDOR_DISCOUNT,
]);

Serializer<OrderChangeTypeEnum> _$orderChangeTypeEnumSerializer =
    _$OrderChangeTypeEnumSerializer();

class _$OrderChangeTypeEnumSerializer
    implements PrimitiveSerializer<OrderChangeTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'QUANTITY_REDUCED': 'QUANTITY_REDUCED',
    'LINE_REMOVED': 'LINE_REMOVED',
    'VENDOR_DISCOUNT': 'VENDOR_DISCOUNT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'QUANTITY_REDUCED': 'QUANTITY_REDUCED',
    'LINE_REMOVED': 'LINE_REMOVED',
    'VENDOR_DISCOUNT': 'VENDOR_DISCOUNT',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderChangeTypeEnum];
  @override
  final String wireName = 'OrderChangeTypeEnum';

  @override
  Object serialize(Serializers serializers, OrderChangeTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderChangeTypeEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderChangeTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderChange extends OrderChange {
  @override
  final OrderChangeTypeEnum type;
  @override
  final String? orderLineId;
  @override
  final String label;
  @override
  final String from;
  @override
  final String to;

  factory _$OrderChange([void Function(OrderChangeBuilder)? updates]) =>
      (OrderChangeBuilder()..update(updates))._build();

  _$OrderChange._(
      {required this.type,
      this.orderLineId,
      required this.label,
      required this.from,
      required this.to})
      : super._();
  @override
  OrderChange rebuild(void Function(OrderChangeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderChangeBuilder toBuilder() => OrderChangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderChange &&
        type == other.type &&
        orderLineId == other.orderLineId &&
        label == other.label &&
        from == other.from &&
        to == other.to;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, orderLineId.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderChange')
          ..add('type', type)
          ..add('orderLineId', orderLineId)
          ..add('label', label)
          ..add('from', from)
          ..add('to', to))
        .toString();
  }
}

class OrderChangeBuilder implements Builder<OrderChange, OrderChangeBuilder> {
  _$OrderChange? _$v;

  OrderChangeTypeEnum? _type;
  OrderChangeTypeEnum? get type => _$this._type;
  set type(OrderChangeTypeEnum? type) => _$this._type = type;

  String? _orderLineId;
  String? get orderLineId => _$this._orderLineId;
  set orderLineId(String? orderLineId) => _$this._orderLineId = orderLineId;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _from;
  String? get from => _$this._from;
  set from(String? from) => _$this._from = from;

  String? _to;
  String? get to => _$this._to;
  set to(String? to) => _$this._to = to;

  OrderChangeBuilder() {
    OrderChange._defaults(this);
  }

  OrderChangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _orderLineId = $v.orderLineId;
      _label = $v.label;
      _from = $v.from;
      _to = $v.to;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderChange other) {
    _$v = other as _$OrderChange;
  }

  @override
  void update(void Function(OrderChangeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderChange build() => _build();

  _$OrderChange _build() {
    final _$result = _$v ??
        _$OrderChange._(
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'OrderChange', 'type'),
          orderLineId: orderLineId,
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'OrderChange', 'label'),
          from: BuiltValueNullFieldError.checkNotNull(
              from, r'OrderChange', 'from'),
          to: BuiltValueNullFieldError.checkNotNull(to, r'OrderChange', 'to'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
