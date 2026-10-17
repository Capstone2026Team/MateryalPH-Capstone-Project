// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_invoice_ref.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OrderInvoiceRefStatusEnum _$orderInvoiceRefStatusEnum_ISSUED =
    const OrderInvoiceRefStatusEnum._('ISSUED');
const OrderInvoiceRefStatusEnum _$orderInvoiceRefStatusEnum_NOT_YET_UPLOADED =
    const OrderInvoiceRefStatusEnum._('NOT_YET_UPLOADED');
const OrderInvoiceRefStatusEnum _$orderInvoiceRefStatusEnum_NOT_DUE =
    const OrderInvoiceRefStatusEnum._('NOT_DUE');

OrderInvoiceRefStatusEnum _$orderInvoiceRefStatusEnumValueOf(String name) {
  switch (name) {
    case 'ISSUED':
      return _$orderInvoiceRefStatusEnum_ISSUED;
    case 'NOT_YET_UPLOADED':
      return _$orderInvoiceRefStatusEnum_NOT_YET_UPLOADED;
    case 'NOT_DUE':
      return _$orderInvoiceRefStatusEnum_NOT_DUE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderInvoiceRefStatusEnum> _$orderInvoiceRefStatusEnumValues =
    BuiltSet<OrderInvoiceRefStatusEnum>(const <OrderInvoiceRefStatusEnum>[
  _$orderInvoiceRefStatusEnum_ISSUED,
  _$orderInvoiceRefStatusEnum_NOT_YET_UPLOADED,
  _$orderInvoiceRefStatusEnum_NOT_DUE,
]);

Serializer<OrderInvoiceRefStatusEnum> _$orderInvoiceRefStatusEnumSerializer =
    _$OrderInvoiceRefStatusEnumSerializer();

class _$OrderInvoiceRefStatusEnumSerializer
    implements PrimitiveSerializer<OrderInvoiceRefStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ISSUED': 'ISSUED',
    'NOT_YET_UPLOADED': 'NOT_YET_UPLOADED',
    'NOT_DUE': 'NOT_DUE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ISSUED': 'ISSUED',
    'NOT_YET_UPLOADED': 'NOT_YET_UPLOADED',
    'NOT_DUE': 'NOT_DUE',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderInvoiceRefStatusEnum];
  @override
  final String wireName = 'OrderInvoiceRefStatusEnum';

  @override
  Object serialize(Serializers serializers, OrderInvoiceRefStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderInvoiceRefStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderInvoiceRefStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderInvoiceRef extends OrderInvoiceRef {
  @override
  final OrderInvoiceRefStatusEnum status;
  @override
  final int records;
  @override
  final int openRequests;

  factory _$OrderInvoiceRef([void Function(OrderInvoiceRefBuilder)? updates]) =>
      (OrderInvoiceRefBuilder()..update(updates))._build();

  _$OrderInvoiceRef._(
      {required this.status, required this.records, required this.openRequests})
      : super._();
  @override
  OrderInvoiceRef rebuild(void Function(OrderInvoiceRefBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderInvoiceRefBuilder toBuilder() => OrderInvoiceRefBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderInvoiceRef &&
        status == other.status &&
        records == other.records &&
        openRequests == other.openRequests;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, records.hashCode);
    _$hash = $jc(_$hash, openRequests.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderInvoiceRef')
          ..add('status', status)
          ..add('records', records)
          ..add('openRequests', openRequests))
        .toString();
  }
}

class OrderInvoiceRefBuilder
    implements Builder<OrderInvoiceRef, OrderInvoiceRefBuilder> {
  _$OrderInvoiceRef? _$v;

  OrderInvoiceRefStatusEnum? _status;
  OrderInvoiceRefStatusEnum? get status => _$this._status;
  set status(OrderInvoiceRefStatusEnum? status) => _$this._status = status;

  int? _records;
  int? get records => _$this._records;
  set records(int? records) => _$this._records = records;

  int? _openRequests;
  int? get openRequests => _$this._openRequests;
  set openRequests(int? openRequests) => _$this._openRequests = openRequests;

  OrderInvoiceRefBuilder() {
    OrderInvoiceRef._defaults(this);
  }

  OrderInvoiceRefBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _records = $v.records;
      _openRequests = $v.openRequests;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderInvoiceRef other) {
    _$v = other as _$OrderInvoiceRef;
  }

  @override
  void update(void Function(OrderInvoiceRefBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderInvoiceRef build() => _build();

  _$OrderInvoiceRef _build() {
    final _$result = _$v ??
        _$OrderInvoiceRef._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'OrderInvoiceRef', 'status'),
          records: BuiltValueNullFieldError.checkNotNull(
              records, r'OrderInvoiceRef', 'records'),
          openRequests: BuiltValueNullFieldError.checkNotNull(
              openRequests, r'OrderInvoiceRef', 'openRequests'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
