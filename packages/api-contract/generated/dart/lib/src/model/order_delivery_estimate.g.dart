// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_delivery_estimate.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OrderDeliveryEstimate extends OrderDeliveryEstimate {
  @override
  final int feeMinCentavos;
  @override
  final int feeMaxCentavos;
  @override
  final int tripsMin;
  @override
  final int tripsMax;

  factory _$OrderDeliveryEstimate(
          [void Function(OrderDeliveryEstimateBuilder)? updates]) =>
      (OrderDeliveryEstimateBuilder()..update(updates))._build();

  _$OrderDeliveryEstimate._(
      {required this.feeMinCentavos,
      required this.feeMaxCentavos,
      required this.tripsMin,
      required this.tripsMax})
      : super._();
  @override
  OrderDeliveryEstimate rebuild(
          void Function(OrderDeliveryEstimateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderDeliveryEstimateBuilder toBuilder() =>
      OrderDeliveryEstimateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderDeliveryEstimate &&
        feeMinCentavos == other.feeMinCentavos &&
        feeMaxCentavos == other.feeMaxCentavos &&
        tripsMin == other.tripsMin &&
        tripsMax == other.tripsMax;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, feeMinCentavos.hashCode);
    _$hash = $jc(_$hash, feeMaxCentavos.hashCode);
    _$hash = $jc(_$hash, tripsMin.hashCode);
    _$hash = $jc(_$hash, tripsMax.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderDeliveryEstimate')
          ..add('feeMinCentavos', feeMinCentavos)
          ..add('feeMaxCentavos', feeMaxCentavos)
          ..add('tripsMin', tripsMin)
          ..add('tripsMax', tripsMax))
        .toString();
  }
}

class OrderDeliveryEstimateBuilder
    implements Builder<OrderDeliveryEstimate, OrderDeliveryEstimateBuilder> {
  _$OrderDeliveryEstimate? _$v;

  int? _feeMinCentavos;
  int? get feeMinCentavos => _$this._feeMinCentavos;
  set feeMinCentavos(int? feeMinCentavos) =>
      _$this._feeMinCentavos = feeMinCentavos;

  int? _feeMaxCentavos;
  int? get feeMaxCentavos => _$this._feeMaxCentavos;
  set feeMaxCentavos(int? feeMaxCentavos) =>
      _$this._feeMaxCentavos = feeMaxCentavos;

  int? _tripsMin;
  int? get tripsMin => _$this._tripsMin;
  set tripsMin(int? tripsMin) => _$this._tripsMin = tripsMin;

  int? _tripsMax;
  int? get tripsMax => _$this._tripsMax;
  set tripsMax(int? tripsMax) => _$this._tripsMax = tripsMax;

  OrderDeliveryEstimateBuilder() {
    OrderDeliveryEstimate._defaults(this);
  }

  OrderDeliveryEstimateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _feeMinCentavos = $v.feeMinCentavos;
      _feeMaxCentavos = $v.feeMaxCentavos;
      _tripsMin = $v.tripsMin;
      _tripsMax = $v.tripsMax;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderDeliveryEstimate other) {
    _$v = other as _$OrderDeliveryEstimate;
  }

  @override
  void update(void Function(OrderDeliveryEstimateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderDeliveryEstimate build() => _build();

  _$OrderDeliveryEstimate _build() {
    final _$result = _$v ??
        _$OrderDeliveryEstimate._(
          feeMinCentavos: BuiltValueNullFieldError.checkNotNull(
              feeMinCentavos, r'OrderDeliveryEstimate', 'feeMinCentavos'),
          feeMaxCentavos: BuiltValueNullFieldError.checkNotNull(
              feeMaxCentavos, r'OrderDeliveryEstimate', 'feeMaxCentavos'),
          tripsMin: BuiltValueNullFieldError.checkNotNull(
              tripsMin, r'OrderDeliveryEstimate', 'tripsMin'),
          tripsMax: BuiltValueNullFieldError.checkNotNull(
              tripsMax, r'OrderDeliveryEstimate', 'tripsMax'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
