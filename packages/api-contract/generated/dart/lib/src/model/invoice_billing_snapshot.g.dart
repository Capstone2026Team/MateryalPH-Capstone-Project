// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_billing_snapshot.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InvoiceBillingSnapshot extends InvoiceBillingSnapshot {
  @override
  final String billingName;
  @override
  final String billingAddress;
  @override
  final String? tinMasked;

  factory _$InvoiceBillingSnapshot(
          [void Function(InvoiceBillingSnapshotBuilder)? updates]) =>
      (InvoiceBillingSnapshotBuilder()..update(updates))._build();

  _$InvoiceBillingSnapshot._(
      {required this.billingName, required this.billingAddress, this.tinMasked})
      : super._();
  @override
  InvoiceBillingSnapshot rebuild(
          void Function(InvoiceBillingSnapshotBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InvoiceBillingSnapshotBuilder toBuilder() =>
      InvoiceBillingSnapshotBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InvoiceBillingSnapshot &&
        billingName == other.billingName &&
        billingAddress == other.billingAddress &&
        tinMasked == other.tinMasked;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, billingName.hashCode);
    _$hash = $jc(_$hash, billingAddress.hashCode);
    _$hash = $jc(_$hash, tinMasked.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InvoiceBillingSnapshot')
          ..add('billingName', billingName)
          ..add('billingAddress', billingAddress)
          ..add('tinMasked', tinMasked))
        .toString();
  }
}

class InvoiceBillingSnapshotBuilder
    implements Builder<InvoiceBillingSnapshot, InvoiceBillingSnapshotBuilder> {
  _$InvoiceBillingSnapshot? _$v;

  String? _billingName;
  String? get billingName => _$this._billingName;
  set billingName(String? billingName) => _$this._billingName = billingName;

  String? _billingAddress;
  String? get billingAddress => _$this._billingAddress;
  set billingAddress(String? billingAddress) =>
      _$this._billingAddress = billingAddress;

  String? _tinMasked;
  String? get tinMasked => _$this._tinMasked;
  set tinMasked(String? tinMasked) => _$this._tinMasked = tinMasked;

  InvoiceBillingSnapshotBuilder() {
    InvoiceBillingSnapshot._defaults(this);
  }

  InvoiceBillingSnapshotBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _billingName = $v.billingName;
      _billingAddress = $v.billingAddress;
      _tinMasked = $v.tinMasked;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InvoiceBillingSnapshot other) {
    _$v = other as _$InvoiceBillingSnapshot;
  }

  @override
  void update(void Function(InvoiceBillingSnapshotBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InvoiceBillingSnapshot build() => _build();

  _$InvoiceBillingSnapshot _build() {
    final _$result = _$v ??
        _$InvoiceBillingSnapshot._(
          billingName: BuiltValueNullFieldError.checkNotNull(
              billingName, r'InvoiceBillingSnapshot', 'billingName'),
          billingAddress: BuiltValueNullFieldError.checkNotNull(
              billingAddress, r'InvoiceBillingSnapshot', 'billingAddress'),
          tinMasked: tinMasked,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
