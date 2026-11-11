// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commission_payment_period.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CommissionPaymentPeriod extends CommissionPaymentPeriod {
  @override
  final String label;
  @override
  final Date startsOn;
  @override
  final Date endsOn;
  @override
  final DateTime resetsAt;
  @override
  final int collectedCentavos;
  @override
  final int refundedCentavos;
  @override
  final int netCollectedCentavos;

  factory _$CommissionPaymentPeriod(
          [void Function(CommissionPaymentPeriodBuilder)? updates]) =>
      (CommissionPaymentPeriodBuilder()..update(updates))._build();

  _$CommissionPaymentPeriod._(
      {required this.label,
      required this.startsOn,
      required this.endsOn,
      required this.resetsAt,
      required this.collectedCentavos,
      required this.refundedCentavos,
      required this.netCollectedCentavos})
      : super._();
  @override
  CommissionPaymentPeriod rebuild(
          void Function(CommissionPaymentPeriodBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CommissionPaymentPeriodBuilder toBuilder() =>
      CommissionPaymentPeriodBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommissionPaymentPeriod &&
        label == other.label &&
        startsOn == other.startsOn &&
        endsOn == other.endsOn &&
        resetsAt == other.resetsAt &&
        collectedCentavos == other.collectedCentavos &&
        refundedCentavos == other.refundedCentavos &&
        netCollectedCentavos == other.netCollectedCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, startsOn.hashCode);
    _$hash = $jc(_$hash, endsOn.hashCode);
    _$hash = $jc(_$hash, resetsAt.hashCode);
    _$hash = $jc(_$hash, collectedCentavos.hashCode);
    _$hash = $jc(_$hash, refundedCentavos.hashCode);
    _$hash = $jc(_$hash, netCollectedCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CommissionPaymentPeriod')
          ..add('label', label)
          ..add('startsOn', startsOn)
          ..add('endsOn', endsOn)
          ..add('resetsAt', resetsAt)
          ..add('collectedCentavos', collectedCentavos)
          ..add('refundedCentavos', refundedCentavos)
          ..add('netCollectedCentavos', netCollectedCentavos))
        .toString();
  }
}

class CommissionPaymentPeriodBuilder
    implements
        Builder<CommissionPaymentPeriod, CommissionPaymentPeriodBuilder> {
  _$CommissionPaymentPeriod? _$v;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  Date? _startsOn;
  Date? get startsOn => _$this._startsOn;
  set startsOn(Date? startsOn) => _$this._startsOn = startsOn;

  Date? _endsOn;
  Date? get endsOn => _$this._endsOn;
  set endsOn(Date? endsOn) => _$this._endsOn = endsOn;

  DateTime? _resetsAt;
  DateTime? get resetsAt => _$this._resetsAt;
  set resetsAt(DateTime? resetsAt) => _$this._resetsAt = resetsAt;

  int? _collectedCentavos;
  int? get collectedCentavos => _$this._collectedCentavos;
  set collectedCentavos(int? collectedCentavos) =>
      _$this._collectedCentavos = collectedCentavos;

  int? _refundedCentavos;
  int? get refundedCentavos => _$this._refundedCentavos;
  set refundedCentavos(int? refundedCentavos) =>
      _$this._refundedCentavos = refundedCentavos;

  int? _netCollectedCentavos;
  int? get netCollectedCentavos => _$this._netCollectedCentavos;
  set netCollectedCentavos(int? netCollectedCentavos) =>
      _$this._netCollectedCentavos = netCollectedCentavos;

  CommissionPaymentPeriodBuilder() {
    CommissionPaymentPeriod._defaults(this);
  }

  CommissionPaymentPeriodBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _label = $v.label;
      _startsOn = $v.startsOn;
      _endsOn = $v.endsOn;
      _resetsAt = $v.resetsAt;
      _collectedCentavos = $v.collectedCentavos;
      _refundedCentavos = $v.refundedCentavos;
      _netCollectedCentavos = $v.netCollectedCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CommissionPaymentPeriod other) {
    _$v = other as _$CommissionPaymentPeriod;
  }

  @override
  void update(void Function(CommissionPaymentPeriodBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CommissionPaymentPeriod build() => _build();

  _$CommissionPaymentPeriod _build() {
    final _$result = _$v ??
        _$CommissionPaymentPeriod._(
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'CommissionPaymentPeriod', 'label'),
          startsOn: BuiltValueNullFieldError.checkNotNull(
              startsOn, r'CommissionPaymentPeriod', 'startsOn'),
          endsOn: BuiltValueNullFieldError.checkNotNull(
              endsOn, r'CommissionPaymentPeriod', 'endsOn'),
          resetsAt: BuiltValueNullFieldError.checkNotNull(
              resetsAt, r'CommissionPaymentPeriod', 'resetsAt'),
          collectedCentavos: BuiltValueNullFieldError.checkNotNull(
              collectedCentavos,
              r'CommissionPaymentPeriod',
              'collectedCentavos'),
          refundedCentavos: BuiltValueNullFieldError.checkNotNull(
              refundedCentavos, r'CommissionPaymentPeriod', 'refundedCentavos'),
          netCollectedCentavos: BuiltValueNullFieldError.checkNotNull(
              netCollectedCentavos,
              r'CommissionPaymentPeriod',
              'netCollectedCentavos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
