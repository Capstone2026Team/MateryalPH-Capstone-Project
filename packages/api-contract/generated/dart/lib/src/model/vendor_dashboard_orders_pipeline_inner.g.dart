// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_orders_pipeline_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDashboardOrdersPipelineInner
    extends VendorDashboardOrdersPipelineInner {
  @override
  final String state;
  @override
  final int count;

  factory _$VendorDashboardOrdersPipelineInner(
          [void Function(VendorDashboardOrdersPipelineInnerBuilder)?
              updates]) =>
      (VendorDashboardOrdersPipelineInnerBuilder()..update(updates))._build();

  _$VendorDashboardOrdersPipelineInner._(
      {required this.state, required this.count})
      : super._();
  @override
  VendorDashboardOrdersPipelineInner rebuild(
          void Function(VendorDashboardOrdersPipelineInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDashboardOrdersPipelineInnerBuilder toBuilder() =>
      VendorDashboardOrdersPipelineInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDashboardOrdersPipelineInner &&
        state == other.state &&
        count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorDashboardOrdersPipelineInner')
          ..add('state', state)
          ..add('count', count))
        .toString();
  }
}

class VendorDashboardOrdersPipelineInnerBuilder
    implements
        Builder<VendorDashboardOrdersPipelineInner,
            VendorDashboardOrdersPipelineInnerBuilder> {
  _$VendorDashboardOrdersPipelineInner? _$v;

  String? _state;
  String? get state => _$this._state;
  set state(String? state) => _$this._state = state;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  VendorDashboardOrdersPipelineInnerBuilder() {
    VendorDashboardOrdersPipelineInner._defaults(this);
  }

  VendorDashboardOrdersPipelineInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _state = $v.state;
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDashboardOrdersPipelineInner other) {
    _$v = other as _$VendorDashboardOrdersPipelineInner;
  }

  @override
  void update(
      void Function(VendorDashboardOrdersPipelineInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDashboardOrdersPipelineInner build() => _build();

  _$VendorDashboardOrdersPipelineInner _build() {
    final _$result = _$v ??
        _$VendorDashboardOrdersPipelineInner._(
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'VendorDashboardOrdersPipelineInner', 'state'),
          count: BuiltValueNullFieldError.checkNotNull(
              count, r'VendorDashboardOrdersPipelineInner', 'count'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
