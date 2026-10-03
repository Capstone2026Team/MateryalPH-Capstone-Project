// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_revision_decision.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OrderRevisionDecision extends OrderRevisionDecision {
  @override
  final String? budgetOverrideReason;
  @override
  final int snapshotVersion;
  @override
  final String? reason;

  factory _$OrderRevisionDecision(
          [void Function(OrderRevisionDecisionBuilder)? updates]) =>
      (OrderRevisionDecisionBuilder()..update(updates))._build();

  _$OrderRevisionDecision._(
      {this.budgetOverrideReason, required this.snapshotVersion, this.reason})
      : super._();
  @override
  OrderRevisionDecision rebuild(
          void Function(OrderRevisionDecisionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderRevisionDecisionBuilder toBuilder() =>
      OrderRevisionDecisionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderRevisionDecision &&
        budgetOverrideReason == other.budgetOverrideReason &&
        snapshotVersion == other.snapshotVersion &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, budgetOverrideReason.hashCode);
    _$hash = $jc(_$hash, snapshotVersion.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderRevisionDecision')
          ..add('budgetOverrideReason', budgetOverrideReason)
          ..add('snapshotVersion', snapshotVersion)
          ..add('reason', reason))
        .toString();
  }
}

class OrderRevisionDecisionBuilder
    implements Builder<OrderRevisionDecision, OrderRevisionDecisionBuilder> {
  _$OrderRevisionDecision? _$v;

  String? _budgetOverrideReason;
  String? get budgetOverrideReason => _$this._budgetOverrideReason;
  set budgetOverrideReason(String? budgetOverrideReason) =>
      _$this._budgetOverrideReason = budgetOverrideReason;

  int? _snapshotVersion;
  int? get snapshotVersion => _$this._snapshotVersion;
  set snapshotVersion(int? snapshotVersion) =>
      _$this._snapshotVersion = snapshotVersion;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  OrderRevisionDecisionBuilder() {
    OrderRevisionDecision._defaults(this);
  }

  OrderRevisionDecisionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _budgetOverrideReason = $v.budgetOverrideReason;
      _snapshotVersion = $v.snapshotVersion;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderRevisionDecision other) {
    _$v = other as _$OrderRevisionDecision;
  }

  @override
  void update(void Function(OrderRevisionDecisionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderRevisionDecision build() => _build();

  _$OrderRevisionDecision _build() {
    final _$result = _$v ??
        _$OrderRevisionDecision._(
          budgetOverrideReason: budgetOverrideReason,
          snapshotVersion: BuiltValueNullFieldError.checkNotNull(
              snapshotVersion, r'OrderRevisionDecision', 'snapshotVersion'),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
