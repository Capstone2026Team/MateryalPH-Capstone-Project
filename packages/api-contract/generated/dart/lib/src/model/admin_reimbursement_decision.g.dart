// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_reimbursement_decision.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminReimbursementDecision extends AdminReimbursementDecision {
  @override
  final String reason;

  factory _$AdminReimbursementDecision(
          [void Function(AdminReimbursementDecisionBuilder)? updates]) =>
      (AdminReimbursementDecisionBuilder()..update(updates))._build();

  _$AdminReimbursementDecision._({required this.reason}) : super._();
  @override
  AdminReimbursementDecision rebuild(
          void Function(AdminReimbursementDecisionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminReimbursementDecisionBuilder toBuilder() =>
      AdminReimbursementDecisionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminReimbursementDecision && reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminReimbursementDecision')
          ..add('reason', reason))
        .toString();
  }
}

class AdminReimbursementDecisionBuilder
    implements
        Builder<AdminReimbursementDecision, AdminReimbursementDecisionBuilder> {
  _$AdminReimbursementDecision? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminReimbursementDecisionBuilder() {
    AdminReimbursementDecision._defaults(this);
  }

  AdminReimbursementDecisionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminReimbursementDecision other) {
    _$v = other as _$AdminReimbursementDecision;
  }

  @override
  void update(void Function(AdminReimbursementDecisionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminReimbursementDecision build() => _build();

  _$AdminReimbursementDecision _build() {
    final _$result = _$v ??
        _$AdminReimbursementDecision._(
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'AdminReimbursementDecision', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
