// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_team_reply_time.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorTeamReplyTime extends VendorTeamReplyTime {
  @override
  final int measured;
  @override
  final int? averageSeconds;
  @override
  final int? medianSeconds;

  factory _$VendorTeamReplyTime(
          [void Function(VendorTeamReplyTimeBuilder)? updates]) =>
      (VendorTeamReplyTimeBuilder()..update(updates))._build();

  _$VendorTeamReplyTime._(
      {required this.measured, this.averageSeconds, this.medianSeconds})
      : super._();
  @override
  VendorTeamReplyTime rebuild(
          void Function(VendorTeamReplyTimeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTeamReplyTimeBuilder toBuilder() =>
      VendorTeamReplyTimeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTeamReplyTime &&
        measured == other.measured &&
        averageSeconds == other.averageSeconds &&
        medianSeconds == other.medianSeconds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, measured.hashCode);
    _$hash = $jc(_$hash, averageSeconds.hashCode);
    _$hash = $jc(_$hash, medianSeconds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorTeamReplyTime')
          ..add('measured', measured)
          ..add('averageSeconds', averageSeconds)
          ..add('medianSeconds', medianSeconds))
        .toString();
  }
}

class VendorTeamReplyTimeBuilder
    implements Builder<VendorTeamReplyTime, VendorTeamReplyTimeBuilder> {
  _$VendorTeamReplyTime? _$v;

  int? _measured;
  int? get measured => _$this._measured;
  set measured(int? measured) => _$this._measured = measured;

  int? _averageSeconds;
  int? get averageSeconds => _$this._averageSeconds;
  set averageSeconds(int? averageSeconds) =>
      _$this._averageSeconds = averageSeconds;

  int? _medianSeconds;
  int? get medianSeconds => _$this._medianSeconds;
  set medianSeconds(int? medianSeconds) =>
      _$this._medianSeconds = medianSeconds;

  VendorTeamReplyTimeBuilder() {
    VendorTeamReplyTime._defaults(this);
  }

  VendorTeamReplyTimeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _measured = $v.measured;
      _averageSeconds = $v.averageSeconds;
      _medianSeconds = $v.medianSeconds;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorTeamReplyTime other) {
    _$v = other as _$VendorTeamReplyTime;
  }

  @override
  void update(void Function(VendorTeamReplyTimeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTeamReplyTime build() => _build();

  _$VendorTeamReplyTime _build() {
    final _$result = _$v ??
        _$VendorTeamReplyTime._(
          measured: BuiltValueNullFieldError.checkNotNull(
              measured, r'VendorTeamReplyTime', 'measured'),
          averageSeconds: averageSeconds,
          medianSeconds: medianSeconds,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
