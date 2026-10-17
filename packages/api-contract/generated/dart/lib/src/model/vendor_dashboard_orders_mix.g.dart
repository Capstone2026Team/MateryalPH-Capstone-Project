// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_orders_mix.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDashboardOrdersMix extends VendorDashboardOrdersMix {
  @override
  final BuiltList<DashboardCount> procurement;
  @override
  final BuiltList<DashboardCount> fulfillment;
  @override
  final BuiltList<DashboardCount> payment;

  factory _$VendorDashboardOrdersMix(
          [void Function(VendorDashboardOrdersMixBuilder)? updates]) =>
      (VendorDashboardOrdersMixBuilder()..update(updates))._build();

  _$VendorDashboardOrdersMix._(
      {required this.procurement,
      required this.fulfillment,
      required this.payment})
      : super._();
  @override
  VendorDashboardOrdersMix rebuild(
          void Function(VendorDashboardOrdersMixBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDashboardOrdersMixBuilder toBuilder() =>
      VendorDashboardOrdersMixBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDashboardOrdersMix &&
        procurement == other.procurement &&
        fulfillment == other.fulfillment &&
        payment == other.payment;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, procurement.hashCode);
    _$hash = $jc(_$hash, fulfillment.hashCode);
    _$hash = $jc(_$hash, payment.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorDashboardOrdersMix')
          ..add('procurement', procurement)
          ..add('fulfillment', fulfillment)
          ..add('payment', payment))
        .toString();
  }
}

class VendorDashboardOrdersMixBuilder
    implements
        Builder<VendorDashboardOrdersMix, VendorDashboardOrdersMixBuilder> {
  _$VendorDashboardOrdersMix? _$v;

  ListBuilder<DashboardCount>? _procurement;
  ListBuilder<DashboardCount> get procurement =>
      _$this._procurement ??= ListBuilder<DashboardCount>();
  set procurement(ListBuilder<DashboardCount>? procurement) =>
      _$this._procurement = procurement;

  ListBuilder<DashboardCount>? _fulfillment;
  ListBuilder<DashboardCount> get fulfillment =>
      _$this._fulfillment ??= ListBuilder<DashboardCount>();
  set fulfillment(ListBuilder<DashboardCount>? fulfillment) =>
      _$this._fulfillment = fulfillment;

  ListBuilder<DashboardCount>? _payment;
  ListBuilder<DashboardCount> get payment =>
      _$this._payment ??= ListBuilder<DashboardCount>();
  set payment(ListBuilder<DashboardCount>? payment) =>
      _$this._payment = payment;

  VendorDashboardOrdersMixBuilder() {
    VendorDashboardOrdersMix._defaults(this);
  }

  VendorDashboardOrdersMixBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _procurement = $v.procurement.toBuilder();
      _fulfillment = $v.fulfillment.toBuilder();
      _payment = $v.payment.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDashboardOrdersMix other) {
    _$v = other as _$VendorDashboardOrdersMix;
  }

  @override
  void update(void Function(VendorDashboardOrdersMixBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDashboardOrdersMix build() => _build();

  _$VendorDashboardOrdersMix _build() {
    _$VendorDashboardOrdersMix _$result;
    try {
      _$result = _$v ??
          _$VendorDashboardOrdersMix._(
            procurement: procurement.build(),
            fulfillment: fulfillment.build(),
            payment: payment.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'procurement';
        procurement.build();
        _$failedField = 'fulfillment';
        fulfillment.build();
        _$failedField = 'payment';
        payment.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorDashboardOrdersMix', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
