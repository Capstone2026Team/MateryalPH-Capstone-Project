// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withholding_recorded_payment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WithholdingRecordedPayment extends WithholdingRecordedPayment {
  @override
  final String id;
  @override
  final String orderReference;
  @override
  final String collectedAt;
  @override
  final int amountCentavos;
  @override
  final int? taxableCentavos;
  @override
  final int? taxCentavos;

  factory _$WithholdingRecordedPayment(
          [void Function(WithholdingRecordedPaymentBuilder)? updates]) =>
      (WithholdingRecordedPaymentBuilder()..update(updates))._build();

  _$WithholdingRecordedPayment._(
      {required this.id,
      required this.orderReference,
      required this.collectedAt,
      required this.amountCentavos,
      this.taxableCentavos,
      this.taxCentavos})
      : super._();
  @override
  WithholdingRecordedPayment rebuild(
          void Function(WithholdingRecordedPaymentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WithholdingRecordedPaymentBuilder toBuilder() =>
      WithholdingRecordedPaymentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WithholdingRecordedPayment &&
        id == other.id &&
        orderReference == other.orderReference &&
        collectedAt == other.collectedAt &&
        amountCentavos == other.amountCentavos &&
        taxableCentavos == other.taxableCentavos &&
        taxCentavos == other.taxCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, orderReference.hashCode);
    _$hash = $jc(_$hash, collectedAt.hashCode);
    _$hash = $jc(_$hash, amountCentavos.hashCode);
    _$hash = $jc(_$hash, taxableCentavos.hashCode);
    _$hash = $jc(_$hash, taxCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WithholdingRecordedPayment')
          ..add('id', id)
          ..add('orderReference', orderReference)
          ..add('collectedAt', collectedAt)
          ..add('amountCentavos', amountCentavos)
          ..add('taxableCentavos', taxableCentavos)
          ..add('taxCentavos', taxCentavos))
        .toString();
  }
}

class WithholdingRecordedPaymentBuilder
    implements
        Builder<WithholdingRecordedPayment, WithholdingRecordedPaymentBuilder> {
  _$WithholdingRecordedPayment? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _orderReference;
  String? get orderReference => _$this._orderReference;
  set orderReference(String? orderReference) =>
      _$this._orderReference = orderReference;

  String? _collectedAt;
  String? get collectedAt => _$this._collectedAt;
  set collectedAt(String? collectedAt) => _$this._collectedAt = collectedAt;

  int? _amountCentavos;
  int? get amountCentavos => _$this._amountCentavos;
  set amountCentavos(int? amountCentavos) =>
      _$this._amountCentavos = amountCentavos;

  int? _taxableCentavos;
  int? get taxableCentavos => _$this._taxableCentavos;
  set taxableCentavos(int? taxableCentavos) =>
      _$this._taxableCentavos = taxableCentavos;

  int? _taxCentavos;
  int? get taxCentavos => _$this._taxCentavos;
  set taxCentavos(int? taxCentavos) => _$this._taxCentavos = taxCentavos;

  WithholdingRecordedPaymentBuilder() {
    WithholdingRecordedPayment._defaults(this);
  }

  WithholdingRecordedPaymentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _orderReference = $v.orderReference;
      _collectedAt = $v.collectedAt;
      _amountCentavos = $v.amountCentavos;
      _taxableCentavos = $v.taxableCentavos;
      _taxCentavos = $v.taxCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WithholdingRecordedPayment other) {
    _$v = other as _$WithholdingRecordedPayment;
  }

  @override
  void update(void Function(WithholdingRecordedPaymentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WithholdingRecordedPayment build() => _build();

  _$WithholdingRecordedPayment _build() {
    final _$result = _$v ??
        _$WithholdingRecordedPayment._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'WithholdingRecordedPayment', 'id'),
          orderReference: BuiltValueNullFieldError.checkNotNull(
              orderReference, r'WithholdingRecordedPayment', 'orderReference'),
          collectedAt: BuiltValueNullFieldError.checkNotNull(
              collectedAt, r'WithholdingRecordedPayment', 'collectedAt'),
          amountCentavos: BuiltValueNullFieldError.checkNotNull(
              amountCentavos, r'WithholdingRecordedPayment', 'amountCentavos'),
          taxableCentavos: taxableCentavos,
          taxCentavos: taxCentavos,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
