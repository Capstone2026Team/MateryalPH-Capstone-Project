// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remittance_reconciliation_approval.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RemittanceReconciliationApproval
    extends RemittanceReconciliationApproval {
  @override
  final String sourceVersion;
  @override
  final String reason;

  factory _$RemittanceReconciliationApproval(
          [void Function(RemittanceReconciliationApprovalBuilder)? updates]) =>
      (RemittanceReconciliationApprovalBuilder()..update(updates))._build();

  _$RemittanceReconciliationApproval._(
      {required this.sourceVersion, required this.reason})
      : super._();
  @override
  RemittanceReconciliationApproval rebuild(
          void Function(RemittanceReconciliationApprovalBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RemittanceReconciliationApprovalBuilder toBuilder() =>
      RemittanceReconciliationApprovalBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RemittanceReconciliationApproval &&
        sourceVersion == other.sourceVersion &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sourceVersion.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RemittanceReconciliationApproval')
          ..add('sourceVersion', sourceVersion)
          ..add('reason', reason))
        .toString();
  }
}

class RemittanceReconciliationApprovalBuilder
    implements
        Builder<RemittanceReconciliationApproval,
            RemittanceReconciliationApprovalBuilder> {
  _$RemittanceReconciliationApproval? _$v;

  String? _sourceVersion;
  String? get sourceVersion => _$this._sourceVersion;
  set sourceVersion(String? sourceVersion) =>
      _$this._sourceVersion = sourceVersion;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  RemittanceReconciliationApprovalBuilder() {
    RemittanceReconciliationApproval._defaults(this);
  }

  RemittanceReconciliationApprovalBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sourceVersion = $v.sourceVersion;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RemittanceReconciliationApproval other) {
    _$v = other as _$RemittanceReconciliationApproval;
  }

  @override
  void update(void Function(RemittanceReconciliationApprovalBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RemittanceReconciliationApproval build() => _build();

  _$RemittanceReconciliationApproval _build() {
    final _$result = _$v ??
        _$RemittanceReconciliationApproval._(
          sourceVersion: BuiltValueNullFieldError.checkNotNull(sourceVersion,
              r'RemittanceReconciliationApproval', 'sourceVersion'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'RemittanceReconciliationApproval', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
