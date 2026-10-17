// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_team_performance_activity.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorTeamPerformanceActivity extends VendorTeamPerformanceActivity {
  @override
  final int total;
  @override
  final int succeeded;
  @override
  final int unsuccessful;

  factory _$VendorTeamPerformanceActivity(
          [void Function(VendorTeamPerformanceActivityBuilder)? updates]) =>
      (VendorTeamPerformanceActivityBuilder()..update(updates))._build();

  _$VendorTeamPerformanceActivity._(
      {required this.total,
      required this.succeeded,
      required this.unsuccessful})
      : super._();
  @override
  VendorTeamPerformanceActivity rebuild(
          void Function(VendorTeamPerformanceActivityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTeamPerformanceActivityBuilder toBuilder() =>
      VendorTeamPerformanceActivityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTeamPerformanceActivity &&
        total == other.total &&
        succeeded == other.succeeded &&
        unsuccessful == other.unsuccessful;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, succeeded.hashCode);
    _$hash = $jc(_$hash, unsuccessful.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorTeamPerformanceActivity')
          ..add('total', total)
          ..add('succeeded', succeeded)
          ..add('unsuccessful', unsuccessful))
        .toString();
  }
}

class VendorTeamPerformanceActivityBuilder
    implements
        Builder<VendorTeamPerformanceActivity,
            VendorTeamPerformanceActivityBuilder> {
  _$VendorTeamPerformanceActivity? _$v;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _succeeded;
  int? get succeeded => _$this._succeeded;
  set succeeded(int? succeeded) => _$this._succeeded = succeeded;

  int? _unsuccessful;
  int? get unsuccessful => _$this._unsuccessful;
  set unsuccessful(int? unsuccessful) => _$this._unsuccessful = unsuccessful;

  VendorTeamPerformanceActivityBuilder() {
    VendorTeamPerformanceActivity._defaults(this);
  }

  VendorTeamPerformanceActivityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _total = $v.total;
      _succeeded = $v.succeeded;
      _unsuccessful = $v.unsuccessful;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorTeamPerformanceActivity other) {
    _$v = other as _$VendorTeamPerformanceActivity;
  }

  @override
  void update(void Function(VendorTeamPerformanceActivityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTeamPerformanceActivity build() => _build();

  _$VendorTeamPerformanceActivity _build() {
    final _$result = _$v ??
        _$VendorTeamPerformanceActivity._(
          total: BuiltValueNullFieldError.checkNotNull(
              total, r'VendorTeamPerformanceActivity', 'total'),
          succeeded: BuiltValueNullFieldError.checkNotNull(
              succeeded, r'VendorTeamPerformanceActivity', 'succeeded'),
          unsuccessful: BuiltValueNullFieldError.checkNotNull(
              unsuccessful, r'VendorTeamPerformanceActivity', 'unsuccessful'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
