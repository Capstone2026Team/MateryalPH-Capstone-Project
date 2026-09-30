// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_delivery.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OrderDeliveryStatusEnum _$orderDeliveryStatusEnum_NOT_APPLICABLE =
    const OrderDeliveryStatusEnum._('NOT_APPLICABLE');
const OrderDeliveryStatusEnum _$orderDeliveryStatusEnum_ADVISORY_ESTIMATE =
    const OrderDeliveryStatusEnum._('ADVISORY_ESTIMATE');
const OrderDeliveryStatusEnum _$orderDeliveryStatusEnum_PENDING_VENDOR_REVIEW =
    const OrderDeliveryStatusEnum._('PENDING_VENDOR_REVIEW');
const OrderDeliveryStatusEnum _$orderDeliveryStatusEnum_CONFIRMED =
    const OrderDeliveryStatusEnum._('CONFIRMED');

OrderDeliveryStatusEnum _$orderDeliveryStatusEnumValueOf(String name) {
  switch (name) {
    case 'NOT_APPLICABLE':
      return _$orderDeliveryStatusEnum_NOT_APPLICABLE;
    case 'ADVISORY_ESTIMATE':
      return _$orderDeliveryStatusEnum_ADVISORY_ESTIMATE;
    case 'PENDING_VENDOR_REVIEW':
      return _$orderDeliveryStatusEnum_PENDING_VENDOR_REVIEW;
    case 'CONFIRMED':
      return _$orderDeliveryStatusEnum_CONFIRMED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OrderDeliveryStatusEnum> _$orderDeliveryStatusEnumValues =
    BuiltSet<OrderDeliveryStatusEnum>(const <OrderDeliveryStatusEnum>[
  _$orderDeliveryStatusEnum_NOT_APPLICABLE,
  _$orderDeliveryStatusEnum_ADVISORY_ESTIMATE,
  _$orderDeliveryStatusEnum_PENDING_VENDOR_REVIEW,
  _$orderDeliveryStatusEnum_CONFIRMED,
]);

Serializer<OrderDeliveryStatusEnum> _$orderDeliveryStatusEnumSerializer =
    _$OrderDeliveryStatusEnumSerializer();

class _$OrderDeliveryStatusEnumSerializer
    implements PrimitiveSerializer<OrderDeliveryStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NOT_APPLICABLE': 'NOT_APPLICABLE',
    'ADVISORY_ESTIMATE': 'ADVISORY_ESTIMATE',
    'PENDING_VENDOR_REVIEW': 'PENDING_VENDOR_REVIEW',
    'CONFIRMED': 'CONFIRMED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NOT_APPLICABLE': 'NOT_APPLICABLE',
    'ADVISORY_ESTIMATE': 'ADVISORY_ESTIMATE',
    'PENDING_VENDOR_REVIEW': 'PENDING_VENDOR_REVIEW',
    'CONFIRMED': 'CONFIRMED',
  };

  @override
  final Iterable<Type> types = const <Type>[OrderDeliveryStatusEnum];
  @override
  final String wireName = 'OrderDeliveryStatusEnum';

  @override
  Object serialize(Serializers serializers, OrderDeliveryStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OrderDeliveryStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OrderDeliveryStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OrderDelivery extends OrderDelivery {
  @override
  final OrderDeliveryStatusEnum status;
  @override
  final OrderDeliveryEstimate? estimate;
  @override
  final OrderConfirmedDelivery? confirmed;

  factory _$OrderDelivery([void Function(OrderDeliveryBuilder)? updates]) =>
      (OrderDeliveryBuilder()..update(updates))._build();

  _$OrderDelivery._({required this.status, this.estimate, this.confirmed})
      : super._();
  @override
  OrderDelivery rebuild(void Function(OrderDeliveryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderDeliveryBuilder toBuilder() => OrderDeliveryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderDelivery &&
        status == other.status &&
        estimate == other.estimate &&
        confirmed == other.confirmed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, estimate.hashCode);
    _$hash = $jc(_$hash, confirmed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderDelivery')
          ..add('status', status)
          ..add('estimate', estimate)
          ..add('confirmed', confirmed))
        .toString();
  }
}

class OrderDeliveryBuilder
    implements Builder<OrderDelivery, OrderDeliveryBuilder> {
  _$OrderDelivery? _$v;

  OrderDeliveryStatusEnum? _status;
  OrderDeliveryStatusEnum? get status => _$this._status;
  set status(OrderDeliveryStatusEnum? status) => _$this._status = status;

  OrderDeliveryEstimateBuilder? _estimate;
  OrderDeliveryEstimateBuilder get estimate =>
      _$this._estimate ??= OrderDeliveryEstimateBuilder();
  set estimate(OrderDeliveryEstimateBuilder? estimate) =>
      _$this._estimate = estimate;

  OrderConfirmedDeliveryBuilder? _confirmed;
  OrderConfirmedDeliveryBuilder get confirmed =>
      _$this._confirmed ??= OrderConfirmedDeliveryBuilder();
  set confirmed(OrderConfirmedDeliveryBuilder? confirmed) =>
      _$this._confirmed = confirmed;

  OrderDeliveryBuilder() {
    OrderDelivery._defaults(this);
  }

  OrderDeliveryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _estimate = $v.estimate?.toBuilder();
      _confirmed = $v.confirmed?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderDelivery other) {
    _$v = other as _$OrderDelivery;
  }

  @override
  void update(void Function(OrderDeliveryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderDelivery build() => _build();

  _$OrderDelivery _build() {
    _$OrderDelivery _$result;
    try {
      _$result = _$v ??
          _$OrderDelivery._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'OrderDelivery', 'status'),
            estimate: _estimate?.build(),
            confirmed: _confirmed?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'estimate';
        _estimate?.build();
        _$failedField = 'confirmed';
        _confirmed?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OrderDelivery', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
