// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_earnings_breakdown_physical.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorEarningsBreakdownPhysical
    extends VendorEarningsBreakdownPhysical {
  @override
  final int records;
  @override
  final int cashOnDeliveryCentavos;
  @override
  final int inStoreCentavos;
  @override
  final int unrecordedCentavos;
  @override
  final int unrecordedOrders;

  factory _$VendorEarningsBreakdownPhysical(
          [void Function(VendorEarningsBreakdownPhysicalBuilder)? updates]) =>
      (VendorEarningsBreakdownPhysicalBuilder()..update(updates))._build();

  _$VendorEarningsBreakdownPhysical._(
      {required this.records,
      required this.cashOnDeliveryCentavos,
      required this.inStoreCentavos,
      required this.unrecordedCentavos,
      required this.unrecordedOrders})
      : super._();
  @override
  VendorEarningsBreakdownPhysical rebuild(
          void Function(VendorEarningsBreakdownPhysicalBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorEarningsBreakdownPhysicalBuilder toBuilder() =>
      VendorEarningsBreakdownPhysicalBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorEarningsBreakdownPhysical &&
        records == other.records &&
        cashOnDeliveryCentavos == other.cashOnDeliveryCentavos &&
        inStoreCentavos == other.inStoreCentavos &&
        unrecordedCentavos == other.unrecordedCentavos &&
        unrecordedOrders == other.unrecordedOrders;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, records.hashCode);
    _$hash = $jc(_$hash, cashOnDeliveryCentavos.hashCode);
    _$hash = $jc(_$hash, inStoreCentavos.hashCode);
    _$hash = $jc(_$hash, unrecordedCentavos.hashCode);
    _$hash = $jc(_$hash, unrecordedOrders.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorEarningsBreakdownPhysical')
          ..add('records', records)
          ..add('cashOnDeliveryCentavos', cashOnDeliveryCentavos)
          ..add('inStoreCentavos', inStoreCentavos)
          ..add('unrecordedCentavos', unrecordedCentavos)
          ..add('unrecordedOrders', unrecordedOrders))
        .toString();
  }
}

class VendorEarningsBreakdownPhysicalBuilder
    implements
        Builder<VendorEarningsBreakdownPhysical,
            VendorEarningsBreakdownPhysicalBuilder> {
  _$VendorEarningsBreakdownPhysical? _$v;

  int? _records;
  int? get records => _$this._records;
  set records(int? records) => _$this._records = records;

  int? _cashOnDeliveryCentavos;
  int? get cashOnDeliveryCentavos => _$this._cashOnDeliveryCentavos;
  set cashOnDeliveryCentavos(int? cashOnDeliveryCentavos) =>
      _$this._cashOnDeliveryCentavos = cashOnDeliveryCentavos;

  int? _inStoreCentavos;
  int? get inStoreCentavos => _$this._inStoreCentavos;
  set inStoreCentavos(int? inStoreCentavos) =>
      _$this._inStoreCentavos = inStoreCentavos;

  int? _unrecordedCentavos;
  int? get unrecordedCentavos => _$this._unrecordedCentavos;
  set unrecordedCentavos(int? unrecordedCentavos) =>
      _$this._unrecordedCentavos = unrecordedCentavos;

  int? _unrecordedOrders;
  int? get unrecordedOrders => _$this._unrecordedOrders;
  set unrecordedOrders(int? unrecordedOrders) =>
      _$this._unrecordedOrders = unrecordedOrders;

  VendorEarningsBreakdownPhysicalBuilder() {
    VendorEarningsBreakdownPhysical._defaults(this);
  }

  VendorEarningsBreakdownPhysicalBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _records = $v.records;
      _cashOnDeliveryCentavos = $v.cashOnDeliveryCentavos;
      _inStoreCentavos = $v.inStoreCentavos;
      _unrecordedCentavos = $v.unrecordedCentavos;
      _unrecordedOrders = $v.unrecordedOrders;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorEarningsBreakdownPhysical other) {
    _$v = other as _$VendorEarningsBreakdownPhysical;
  }

  @override
  void update(void Function(VendorEarningsBreakdownPhysicalBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorEarningsBreakdownPhysical build() => _build();

  _$VendorEarningsBreakdownPhysical _build() {
    final _$result = _$v ??
        _$VendorEarningsBreakdownPhysical._(
          records: BuiltValueNullFieldError.checkNotNull(
              records, r'VendorEarningsBreakdownPhysical', 'records'),
          cashOnDeliveryCentavos: BuiltValueNullFieldError.checkNotNull(
              cashOnDeliveryCentavos,
              r'VendorEarningsBreakdownPhysical',
              'cashOnDeliveryCentavos'),
          inStoreCentavos: BuiltValueNullFieldError.checkNotNull(
              inStoreCentavos,
              r'VendorEarningsBreakdownPhysical',
              'inStoreCentavos'),
          unrecordedCentavos: BuiltValueNullFieldError.checkNotNull(
              unrecordedCentavos,
              r'VendorEarningsBreakdownPhysical',
              'unrecordedCentavos'),
          unrecordedOrders: BuiltValueNullFieldError.checkNotNull(
              unrecordedOrders,
              r'VendorEarningsBreakdownPhysical',
              'unrecordedOrders'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
