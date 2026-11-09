// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withholding_calculation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$WithholdingCalculation extends WithholdingCalculation {
  @override
  final int collectionsCentavos;
  @override
  final int refundsCentavos;
  @override
  final int deliveryCentavos;
  @override
  final int vatCentavos;
  @override
  final int providerChargeCentavos;
  @override
  final int grossBasisCentavos;
  @override
  final int taxableBasisCentavos;
  @override
  final int relievedBasisCentavos;

  factory _$WithholdingCalculation(
          [void Function(WithholdingCalculationBuilder)? updates]) =>
      (WithholdingCalculationBuilder()..update(updates))._build();

  _$WithholdingCalculation._(
      {required this.collectionsCentavos,
      required this.refundsCentavos,
      required this.deliveryCentavos,
      required this.vatCentavos,
      required this.providerChargeCentavos,
      required this.grossBasisCentavos,
      required this.taxableBasisCentavos,
      required this.relievedBasisCentavos})
      : super._();
  @override
  WithholdingCalculation rebuild(
          void Function(WithholdingCalculationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WithholdingCalculationBuilder toBuilder() =>
      WithholdingCalculationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WithholdingCalculation &&
        collectionsCentavos == other.collectionsCentavos &&
        refundsCentavos == other.refundsCentavos &&
        deliveryCentavos == other.deliveryCentavos &&
        vatCentavos == other.vatCentavos &&
        providerChargeCentavos == other.providerChargeCentavos &&
        grossBasisCentavos == other.grossBasisCentavos &&
        taxableBasisCentavos == other.taxableBasisCentavos &&
        relievedBasisCentavos == other.relievedBasisCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, collectionsCentavos.hashCode);
    _$hash = $jc(_$hash, refundsCentavos.hashCode);
    _$hash = $jc(_$hash, deliveryCentavos.hashCode);
    _$hash = $jc(_$hash, vatCentavos.hashCode);
    _$hash = $jc(_$hash, providerChargeCentavos.hashCode);
    _$hash = $jc(_$hash, grossBasisCentavos.hashCode);
    _$hash = $jc(_$hash, taxableBasisCentavos.hashCode);
    _$hash = $jc(_$hash, relievedBasisCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WithholdingCalculation')
          ..add('collectionsCentavos', collectionsCentavos)
          ..add('refundsCentavos', refundsCentavos)
          ..add('deliveryCentavos', deliveryCentavos)
          ..add('vatCentavos', vatCentavos)
          ..add('providerChargeCentavos', providerChargeCentavos)
          ..add('grossBasisCentavos', grossBasisCentavos)
          ..add('taxableBasisCentavos', taxableBasisCentavos)
          ..add('relievedBasisCentavos', relievedBasisCentavos))
        .toString();
  }
}

class WithholdingCalculationBuilder
    implements Builder<WithholdingCalculation, WithholdingCalculationBuilder> {
  _$WithholdingCalculation? _$v;

  int? _collectionsCentavos;
  int? get collectionsCentavos => _$this._collectionsCentavos;
  set collectionsCentavos(int? collectionsCentavos) =>
      _$this._collectionsCentavos = collectionsCentavos;

  int? _refundsCentavos;
  int? get refundsCentavos => _$this._refundsCentavos;
  set refundsCentavos(int? refundsCentavos) =>
      _$this._refundsCentavos = refundsCentavos;

  int? _deliveryCentavos;
  int? get deliveryCentavos => _$this._deliveryCentavos;
  set deliveryCentavos(int? deliveryCentavos) =>
      _$this._deliveryCentavos = deliveryCentavos;

  int? _vatCentavos;
  int? get vatCentavos => _$this._vatCentavos;
  set vatCentavos(int? vatCentavos) => _$this._vatCentavos = vatCentavos;

  int? _providerChargeCentavos;
  int? get providerChargeCentavos => _$this._providerChargeCentavos;
  set providerChargeCentavos(int? providerChargeCentavos) =>
      _$this._providerChargeCentavos = providerChargeCentavos;

  int? _grossBasisCentavos;
  int? get grossBasisCentavos => _$this._grossBasisCentavos;
  set grossBasisCentavos(int? grossBasisCentavos) =>
      _$this._grossBasisCentavos = grossBasisCentavos;

  int? _taxableBasisCentavos;
  int? get taxableBasisCentavos => _$this._taxableBasisCentavos;
  set taxableBasisCentavos(int? taxableBasisCentavos) =>
      _$this._taxableBasisCentavos = taxableBasisCentavos;

  int? _relievedBasisCentavos;
  int? get relievedBasisCentavos => _$this._relievedBasisCentavos;
  set relievedBasisCentavos(int? relievedBasisCentavos) =>
      _$this._relievedBasisCentavos = relievedBasisCentavos;

  WithholdingCalculationBuilder() {
    WithholdingCalculation._defaults(this);
  }

  WithholdingCalculationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _collectionsCentavos = $v.collectionsCentavos;
      _refundsCentavos = $v.refundsCentavos;
      _deliveryCentavos = $v.deliveryCentavos;
      _vatCentavos = $v.vatCentavos;
      _providerChargeCentavos = $v.providerChargeCentavos;
      _grossBasisCentavos = $v.grossBasisCentavos;
      _taxableBasisCentavos = $v.taxableBasisCentavos;
      _relievedBasisCentavos = $v.relievedBasisCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WithholdingCalculation other) {
    _$v = other as _$WithholdingCalculation;
  }

  @override
  void update(void Function(WithholdingCalculationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WithholdingCalculation build() => _build();

  _$WithholdingCalculation _build() {
    final _$result = _$v ??
        _$WithholdingCalculation._(
          collectionsCentavos: BuiltValueNullFieldError.checkNotNull(
              collectionsCentavos,
              r'WithholdingCalculation',
              'collectionsCentavos'),
          refundsCentavos: BuiltValueNullFieldError.checkNotNull(
              refundsCentavos, r'WithholdingCalculation', 'refundsCentavos'),
          deliveryCentavos: BuiltValueNullFieldError.checkNotNull(
              deliveryCentavos, r'WithholdingCalculation', 'deliveryCentavos'),
          vatCentavos: BuiltValueNullFieldError.checkNotNull(
              vatCentavos, r'WithholdingCalculation', 'vatCentavos'),
          providerChargeCentavos: BuiltValueNullFieldError.checkNotNull(
              providerChargeCentavos,
              r'WithholdingCalculation',
              'providerChargeCentavos'),
          grossBasisCentavos: BuiltValueNullFieldError.checkNotNull(
              grossBasisCentavos,
              r'WithholdingCalculation',
              'grossBasisCentavos'),
          taxableBasisCentavos: BuiltValueNullFieldError.checkNotNull(
              taxableBasisCentavos,
              r'WithholdingCalculation',
              'taxableBasisCentavos'),
          relievedBasisCentavos: BuiltValueNullFieldError.checkNotNull(
              relievedBasisCentavos,
              r'WithholdingCalculation',
              'relievedBasisCentavos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
