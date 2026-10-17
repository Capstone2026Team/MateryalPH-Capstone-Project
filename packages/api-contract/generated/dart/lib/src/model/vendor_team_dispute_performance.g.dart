// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_team_dispute_performance.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorTeamDisputePerformance extends VendorTeamDisputePerformance {
  @override
  final int handled;
  @override
  final int resolved;
  @override
  final int open;

  factory _$VendorTeamDisputePerformance(
          [void Function(VendorTeamDisputePerformanceBuilder)? updates]) =>
      (VendorTeamDisputePerformanceBuilder()..update(updates))._build();

  _$VendorTeamDisputePerformance._(
      {required this.handled, required this.resolved, required this.open})
      : super._();
  @override
  VendorTeamDisputePerformance rebuild(
          void Function(VendorTeamDisputePerformanceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTeamDisputePerformanceBuilder toBuilder() =>
      VendorTeamDisputePerformanceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTeamDisputePerformance &&
        handled == other.handled &&
        resolved == other.resolved &&
        open == other.open;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, handled.hashCode);
    _$hash = $jc(_$hash, resolved.hashCode);
    _$hash = $jc(_$hash, open.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorTeamDisputePerformance')
          ..add('handled', handled)
          ..add('resolved', resolved)
          ..add('open', open))
        .toString();
  }
}

class VendorTeamDisputePerformanceBuilder
    implements
        Builder<VendorTeamDisputePerformance,
            VendorTeamDisputePerformanceBuilder> {
  _$VendorTeamDisputePerformance? _$v;

  int? _handled;
  int? get handled => _$this._handled;
  set handled(int? handled) => _$this._handled = handled;

  int? _resolved;
  int? get resolved => _$this._resolved;
  set resolved(int? resolved) => _$this._resolved = resolved;

  int? _open;
  int? get open => _$this._open;
  set open(int? open) => _$this._open = open;

  VendorTeamDisputePerformanceBuilder() {
    VendorTeamDisputePerformance._defaults(this);
  }

  VendorTeamDisputePerformanceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _handled = $v.handled;
      _resolved = $v.resolved;
      _open = $v.open;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorTeamDisputePerformance other) {
    _$v = other as _$VendorTeamDisputePerformance;
  }

  @override
  void update(void Function(VendorTeamDisputePerformanceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTeamDisputePerformance build() => _build();

  _$VendorTeamDisputePerformance _build() {
    final _$result = _$v ??
        _$VendorTeamDisputePerformance._(
          handled: BuiltValueNullFieldError.checkNotNull(
              handled, r'VendorTeamDisputePerformance', 'handled'),
          resolved: BuiltValueNullFieldError.checkNotNull(
              resolved, r'VendorTeamDisputePerformance', 'resolved'),
          open: BuiltValueNullFieldError.checkNotNull(
              open, r'VendorTeamDisputePerformance', 'open'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
