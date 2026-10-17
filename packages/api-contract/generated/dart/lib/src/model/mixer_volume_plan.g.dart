// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mixer_volume_plan.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MixerVolumePlan extends MixerVolumePlan {
  @override
  final num totalM3;
  @override
  final num fullLoadM3;
  @override
  final int fullTrips;
  @override
  final num lastTripM3;

  factory _$MixerVolumePlan([void Function(MixerVolumePlanBuilder)? updates]) =>
      (MixerVolumePlanBuilder()..update(updates))._build();

  _$MixerVolumePlan._(
      {required this.totalM3,
      required this.fullLoadM3,
      required this.fullTrips,
      required this.lastTripM3})
      : super._();
  @override
  MixerVolumePlan rebuild(void Function(MixerVolumePlanBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MixerVolumePlanBuilder toBuilder() => MixerVolumePlanBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MixerVolumePlan &&
        totalM3 == other.totalM3 &&
        fullLoadM3 == other.fullLoadM3 &&
        fullTrips == other.fullTrips &&
        lastTripM3 == other.lastTripM3;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, totalM3.hashCode);
    _$hash = $jc(_$hash, fullLoadM3.hashCode);
    _$hash = $jc(_$hash, fullTrips.hashCode);
    _$hash = $jc(_$hash, lastTripM3.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MixerVolumePlan')
          ..add('totalM3', totalM3)
          ..add('fullLoadM3', fullLoadM3)
          ..add('fullTrips', fullTrips)
          ..add('lastTripM3', lastTripM3))
        .toString();
  }
}

class MixerVolumePlanBuilder
    implements Builder<MixerVolumePlan, MixerVolumePlanBuilder> {
  _$MixerVolumePlan? _$v;

  num? _totalM3;
  num? get totalM3 => _$this._totalM3;
  set totalM3(num? totalM3) => _$this._totalM3 = totalM3;

  num? _fullLoadM3;
  num? get fullLoadM3 => _$this._fullLoadM3;
  set fullLoadM3(num? fullLoadM3) => _$this._fullLoadM3 = fullLoadM3;

  int? _fullTrips;
  int? get fullTrips => _$this._fullTrips;
  set fullTrips(int? fullTrips) => _$this._fullTrips = fullTrips;

  num? _lastTripM3;
  num? get lastTripM3 => _$this._lastTripM3;
  set lastTripM3(num? lastTripM3) => _$this._lastTripM3 = lastTripM3;

  MixerVolumePlanBuilder() {
    MixerVolumePlan._defaults(this);
  }

  MixerVolumePlanBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _totalM3 = $v.totalM3;
      _fullLoadM3 = $v.fullLoadM3;
      _fullTrips = $v.fullTrips;
      _lastTripM3 = $v.lastTripM3;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MixerVolumePlan other) {
    _$v = other as _$MixerVolumePlan;
  }

  @override
  void update(void Function(MixerVolumePlanBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MixerVolumePlan build() => _build();

  _$MixerVolumePlan _build() {
    final _$result = _$v ??
        _$MixerVolumePlan._(
          totalM3: BuiltValueNullFieldError.checkNotNull(
              totalM3, r'MixerVolumePlan', 'totalM3'),
          fullLoadM3: BuiltValueNullFieldError.checkNotNull(
              fullLoadM3, r'MixerVolumePlan', 'fullLoadM3'),
          fullTrips: BuiltValueNullFieldError.checkNotNull(
              fullTrips, r'MixerVolumePlan', 'fullTrips'),
          lastTripM3: BuiltValueNullFieldError.checkNotNull(
              lastTripM3, r'MixerVolumePlan', 'lastTripM3'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
