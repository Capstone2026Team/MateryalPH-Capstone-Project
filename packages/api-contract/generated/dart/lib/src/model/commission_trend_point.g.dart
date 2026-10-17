// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commission_trend_point.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CommissionTrendPoint extends CommissionTrendPoint {
  @override
  final Date period;
  @override
  final int earnedCentavos;
  @override
  final int creditsCentavos;
  @override
  final int collectedCentavos;
  @override
  final int refundedCentavos;
  @override
  final int netEarningsCentavos;

  factory _$CommissionTrendPoint(
          [void Function(CommissionTrendPointBuilder)? updates]) =>
      (CommissionTrendPointBuilder()..update(updates))._build();

  _$CommissionTrendPoint._(
      {required this.period,
      required this.earnedCentavos,
      required this.creditsCentavos,
      required this.collectedCentavos,
      required this.refundedCentavos,
      required this.netEarningsCentavos})
      : super._();
  @override
  CommissionTrendPoint rebuild(
          void Function(CommissionTrendPointBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CommissionTrendPointBuilder toBuilder() =>
      CommissionTrendPointBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommissionTrendPoint &&
        period == other.period &&
        earnedCentavos == other.earnedCentavos &&
        creditsCentavos == other.creditsCentavos &&
        collectedCentavos == other.collectedCentavos &&
        refundedCentavos == other.refundedCentavos &&
        netEarningsCentavos == other.netEarningsCentavos;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, period.hashCode);
    _$hash = $jc(_$hash, earnedCentavos.hashCode);
    _$hash = $jc(_$hash, creditsCentavos.hashCode);
    _$hash = $jc(_$hash, collectedCentavos.hashCode);
    _$hash = $jc(_$hash, refundedCentavos.hashCode);
    _$hash = $jc(_$hash, netEarningsCentavos.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CommissionTrendPoint')
          ..add('period', period)
          ..add('earnedCentavos', earnedCentavos)
          ..add('creditsCentavos', creditsCentavos)
          ..add('collectedCentavos', collectedCentavos)
          ..add('refundedCentavos', refundedCentavos)
          ..add('netEarningsCentavos', netEarningsCentavos))
        .toString();
  }
}

class CommissionTrendPointBuilder
    implements Builder<CommissionTrendPoint, CommissionTrendPointBuilder> {
  _$CommissionTrendPoint? _$v;

  Date? _period;
  Date? get period => _$this._period;
  set period(Date? period) => _$this._period = period;

  int? _earnedCentavos;
  int? get earnedCentavos => _$this._earnedCentavos;
  set earnedCentavos(int? earnedCentavos) =>
      _$this._earnedCentavos = earnedCentavos;

  int? _creditsCentavos;
  int? get creditsCentavos => _$this._creditsCentavos;
  set creditsCentavos(int? creditsCentavos) =>
      _$this._creditsCentavos = creditsCentavos;

  int? _collectedCentavos;
  int? get collectedCentavos => _$this._collectedCentavos;
  set collectedCentavos(int? collectedCentavos) =>
      _$this._collectedCentavos = collectedCentavos;

  int? _refundedCentavos;
  int? get refundedCentavos => _$this._refundedCentavos;
  set refundedCentavos(int? refundedCentavos) =>
      _$this._refundedCentavos = refundedCentavos;

  int? _netEarningsCentavos;
  int? get netEarningsCentavos => _$this._netEarningsCentavos;
  set netEarningsCentavos(int? netEarningsCentavos) =>
      _$this._netEarningsCentavos = netEarningsCentavos;

  CommissionTrendPointBuilder() {
    CommissionTrendPoint._defaults(this);
  }

  CommissionTrendPointBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _period = $v.period;
      _earnedCentavos = $v.earnedCentavos;
      _creditsCentavos = $v.creditsCentavos;
      _collectedCentavos = $v.collectedCentavos;
      _refundedCentavos = $v.refundedCentavos;
      _netEarningsCentavos = $v.netEarningsCentavos;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CommissionTrendPoint other) {
    _$v = other as _$CommissionTrendPoint;
  }

  @override
  void update(void Function(CommissionTrendPointBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CommissionTrendPoint build() => _build();

  _$CommissionTrendPoint _build() {
    final _$result = _$v ??
        _$CommissionTrendPoint._(
          period: BuiltValueNullFieldError.checkNotNull(
              period, r'CommissionTrendPoint', 'period'),
          earnedCentavos: BuiltValueNullFieldError.checkNotNull(
              earnedCentavos, r'CommissionTrendPoint', 'earnedCentavos'),
          creditsCentavos: BuiltValueNullFieldError.checkNotNull(
              creditsCentavos, r'CommissionTrendPoint', 'creditsCentavos'),
          collectedCentavos: BuiltValueNullFieldError.checkNotNull(
              collectedCentavos, r'CommissionTrendPoint', 'collectedCentavos'),
          refundedCentavos: BuiltValueNullFieldError.checkNotNull(
              refundedCentavos, r'CommissionTrendPoint', 'refundedCentavos'),
          netEarningsCentavos: BuiltValueNullFieldError.checkNotNull(
              netEarningsCentavos,
              r'CommissionTrendPoint',
              'netEarningsCentavos'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
