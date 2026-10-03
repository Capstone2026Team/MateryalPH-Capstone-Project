// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fleet_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FleetSummary extends FleetSummary {
  @override
  final int configurations;
  @override
  final int totalVehicles;
  @override
  final int activeVehicles;
  @override
  final int availableVehicles;
  @override
  final int outForDeliveryVehicleAssignments;
  @override
  final int outForDeliveryOrders;

  factory _$FleetSummary([void Function(FleetSummaryBuilder)? updates]) =>
      (FleetSummaryBuilder()..update(updates))._build();

  _$FleetSummary._(
      {required this.configurations,
      required this.totalVehicles,
      required this.activeVehicles,
      required this.availableVehicles,
      required this.outForDeliveryVehicleAssignments,
      required this.outForDeliveryOrders})
      : super._();
  @override
  FleetSummary rebuild(void Function(FleetSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FleetSummaryBuilder toBuilder() => FleetSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FleetSummary &&
        configurations == other.configurations &&
        totalVehicles == other.totalVehicles &&
        activeVehicles == other.activeVehicles &&
        availableVehicles == other.availableVehicles &&
        outForDeliveryVehicleAssignments ==
            other.outForDeliveryVehicleAssignments &&
        outForDeliveryOrders == other.outForDeliveryOrders;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, configurations.hashCode);
    _$hash = $jc(_$hash, totalVehicles.hashCode);
    _$hash = $jc(_$hash, activeVehicles.hashCode);
    _$hash = $jc(_$hash, availableVehicles.hashCode);
    _$hash = $jc(_$hash, outForDeliveryVehicleAssignments.hashCode);
    _$hash = $jc(_$hash, outForDeliveryOrders.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FleetSummary')
          ..add('configurations', configurations)
          ..add('totalVehicles', totalVehicles)
          ..add('activeVehicles', activeVehicles)
          ..add('availableVehicles', availableVehicles)
          ..add('outForDeliveryVehicleAssignments',
              outForDeliveryVehicleAssignments)
          ..add('outForDeliveryOrders', outForDeliveryOrders))
        .toString();
  }
}

class FleetSummaryBuilder
    implements Builder<FleetSummary, FleetSummaryBuilder> {
  _$FleetSummary? _$v;

  int? _configurations;
  int? get configurations => _$this._configurations;
  set configurations(int? configurations) =>
      _$this._configurations = configurations;

  int? _totalVehicles;
  int? get totalVehicles => _$this._totalVehicles;
  set totalVehicles(int? totalVehicles) =>
      _$this._totalVehicles = totalVehicles;

  int? _activeVehicles;
  int? get activeVehicles => _$this._activeVehicles;
  set activeVehicles(int? activeVehicles) =>
      _$this._activeVehicles = activeVehicles;

  int? _availableVehicles;
  int? get availableVehicles => _$this._availableVehicles;
  set availableVehicles(int? availableVehicles) =>
      _$this._availableVehicles = availableVehicles;

  int? _outForDeliveryVehicleAssignments;
  int? get outForDeliveryVehicleAssignments =>
      _$this._outForDeliveryVehicleAssignments;
  set outForDeliveryVehicleAssignments(int? outForDeliveryVehicleAssignments) =>
      _$this._outForDeliveryVehicleAssignments =
          outForDeliveryVehicleAssignments;

  int? _outForDeliveryOrders;
  int? get outForDeliveryOrders => _$this._outForDeliveryOrders;
  set outForDeliveryOrders(int? outForDeliveryOrders) =>
      _$this._outForDeliveryOrders = outForDeliveryOrders;

  FleetSummaryBuilder() {
    FleetSummary._defaults(this);
  }

  FleetSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _configurations = $v.configurations;
      _totalVehicles = $v.totalVehicles;
      _activeVehicles = $v.activeVehicles;
      _availableVehicles = $v.availableVehicles;
      _outForDeliveryVehicleAssignments = $v.outForDeliveryVehicleAssignments;
      _outForDeliveryOrders = $v.outForDeliveryOrders;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FleetSummary other) {
    _$v = other as _$FleetSummary;
  }

  @override
  void update(void Function(FleetSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FleetSummary build() => _build();

  _$FleetSummary _build() {
    final _$result = _$v ??
        _$FleetSummary._(
          configurations: BuiltValueNullFieldError.checkNotNull(
              configurations, r'FleetSummary', 'configurations'),
          totalVehicles: BuiltValueNullFieldError.checkNotNull(
              totalVehicles, r'FleetSummary', 'totalVehicles'),
          activeVehicles: BuiltValueNullFieldError.checkNotNull(
              activeVehicles, r'FleetSummary', 'activeVehicles'),
          availableVehicles: BuiltValueNullFieldError.checkNotNull(
              availableVehicles, r'FleetSummary', 'availableVehicles'),
          outForDeliveryVehicleAssignments:
              BuiltValueNullFieldError.checkNotNull(
                  outForDeliveryVehicleAssignments,
                  r'FleetSummary',
                  'outForDeliveryVehicleAssignments'),
          outForDeliveryOrders: BuiltValueNullFieldError.checkNotNull(
              outForDeliveryOrders, r'FleetSummary', 'outForDeliveryOrders'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
