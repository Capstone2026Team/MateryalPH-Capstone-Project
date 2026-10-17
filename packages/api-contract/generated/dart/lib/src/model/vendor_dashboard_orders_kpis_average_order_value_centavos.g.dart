// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_orders_kpis_average_order_value_centavos.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDashboardOrdersKpisAverageOrderValueCentavos
    extends VendorDashboardOrdersKpisAverageOrderValueCentavos {
  @override
  final int? value;
  @override
  final int? previous;

  factory _$VendorDashboardOrdersKpisAverageOrderValueCentavos(
          [void Function(
                  VendorDashboardOrdersKpisAverageOrderValueCentavosBuilder)?
              updates]) =>
      (VendorDashboardOrdersKpisAverageOrderValueCentavosBuilder()
            ..update(updates))
          ._build();

  _$VendorDashboardOrdersKpisAverageOrderValueCentavos._(
      {this.value, this.previous})
      : super._();
  @override
  VendorDashboardOrdersKpisAverageOrderValueCentavos rebuild(
          void Function(
                  VendorDashboardOrdersKpisAverageOrderValueCentavosBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDashboardOrdersKpisAverageOrderValueCentavosBuilder toBuilder() =>
      VendorDashboardOrdersKpisAverageOrderValueCentavosBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDashboardOrdersKpisAverageOrderValueCentavos &&
        value == other.value &&
        previous == other.previous;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, previous.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'VendorDashboardOrdersKpisAverageOrderValueCentavos')
          ..add('value', value)
          ..add('previous', previous))
        .toString();
  }
}

class VendorDashboardOrdersKpisAverageOrderValueCentavosBuilder
    implements
        Builder<VendorDashboardOrdersKpisAverageOrderValueCentavos,
            VendorDashboardOrdersKpisAverageOrderValueCentavosBuilder> {
  _$VendorDashboardOrdersKpisAverageOrderValueCentavos? _$v;

  int? _value;
  int? get value => _$this._value;
  set value(int? value) => _$this._value = value;

  int? _previous;
  int? get previous => _$this._previous;
  set previous(int? previous) => _$this._previous = previous;

  VendorDashboardOrdersKpisAverageOrderValueCentavosBuilder() {
    VendorDashboardOrdersKpisAverageOrderValueCentavos._defaults(this);
  }

  VendorDashboardOrdersKpisAverageOrderValueCentavosBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _value = $v.value;
      _previous = $v.previous;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDashboardOrdersKpisAverageOrderValueCentavos other) {
    _$v = other as _$VendorDashboardOrdersKpisAverageOrderValueCentavos;
  }

  @override
  void update(
      void Function(VendorDashboardOrdersKpisAverageOrderValueCentavosBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDashboardOrdersKpisAverageOrderValueCentavos build() => _build();

  _$VendorDashboardOrdersKpisAverageOrderValueCentavos _build() {
    final _$result = _$v ??
        _$VendorDashboardOrdersKpisAverageOrderValueCentavos._(
          value: value,
          previous: previous,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
