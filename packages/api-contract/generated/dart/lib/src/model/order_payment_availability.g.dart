// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_payment_availability.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OrderPaymentAvailability extends OrderPaymentAvailability {
  @override
  final bool available;
  @override
  final String? reason;
  @override
  final String? notice;

  factory _$OrderPaymentAvailability(
          [void Function(OrderPaymentAvailabilityBuilder)? updates]) =>
      (OrderPaymentAvailabilityBuilder()..update(updates))._build();

  _$OrderPaymentAvailability._(
      {required this.available, this.reason, this.notice})
      : super._();
  @override
  OrderPaymentAvailability rebuild(
          void Function(OrderPaymentAvailabilityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderPaymentAvailabilityBuilder toBuilder() =>
      OrderPaymentAvailabilityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderPaymentAvailability &&
        available == other.available &&
        reason == other.reason &&
        notice == other.notice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, notice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderPaymentAvailability')
          ..add('available', available)
          ..add('reason', reason)
          ..add('notice', notice))
        .toString();
  }
}

class OrderPaymentAvailabilityBuilder
    implements
        Builder<OrderPaymentAvailability, OrderPaymentAvailabilityBuilder> {
  _$OrderPaymentAvailability? _$v;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _notice;
  String? get notice => _$this._notice;
  set notice(String? notice) => _$this._notice = notice;

  OrderPaymentAvailabilityBuilder() {
    OrderPaymentAvailability._defaults(this);
  }

  OrderPaymentAvailabilityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _available = $v.available;
      _reason = $v.reason;
      _notice = $v.notice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderPaymentAvailability other) {
    _$v = other as _$OrderPaymentAvailability;
  }

  @override
  void update(void Function(OrderPaymentAvailabilityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderPaymentAvailability build() => _build();

  _$OrderPaymentAvailability _build() {
    final _$result = _$v ??
        _$OrderPaymentAvailability._(
          available: BuiltValueNullFieldError.checkNotNull(
              available, r'OrderPaymentAvailability', 'available'),
          reason: reason,
          notice: notice,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
