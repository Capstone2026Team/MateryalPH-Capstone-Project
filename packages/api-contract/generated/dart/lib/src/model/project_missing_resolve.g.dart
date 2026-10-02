// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_missing_resolve.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectMissingResolve extends ProjectMissingResolve {
  @override
  final int lockVersion;
  @override
  final String? orderId;
  @override
  final String? reason;
  @override
  final String? budgetOverrideReason;

  factory _$ProjectMissingResolve(
          [void Function(ProjectMissingResolveBuilder)? updates]) =>
      (ProjectMissingResolveBuilder()..update(updates))._build();

  _$ProjectMissingResolve._(
      {required this.lockVersion,
      this.orderId,
      this.reason,
      this.budgetOverrideReason})
      : super._();
  @override
  ProjectMissingResolve rebuild(
          void Function(ProjectMissingResolveBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectMissingResolveBuilder toBuilder() =>
      ProjectMissingResolveBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectMissingResolve &&
        lockVersion == other.lockVersion &&
        orderId == other.orderId &&
        reason == other.reason &&
        budgetOverrideReason == other.budgetOverrideReason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, budgetOverrideReason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectMissingResolve')
          ..add('lockVersion', lockVersion)
          ..add('orderId', orderId)
          ..add('reason', reason)
          ..add('budgetOverrideReason', budgetOverrideReason))
        .toString();
  }
}

class ProjectMissingResolveBuilder
    implements Builder<ProjectMissingResolve, ProjectMissingResolveBuilder> {
  _$ProjectMissingResolve? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _budgetOverrideReason;
  String? get budgetOverrideReason => _$this._budgetOverrideReason;
  set budgetOverrideReason(String? budgetOverrideReason) =>
      _$this._budgetOverrideReason = budgetOverrideReason;

  ProjectMissingResolveBuilder() {
    ProjectMissingResolve._defaults(this);
  }

  ProjectMissingResolveBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _orderId = $v.orderId;
      _reason = $v.reason;
      _budgetOverrideReason = $v.budgetOverrideReason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectMissingResolve other) {
    _$v = other as _$ProjectMissingResolve;
  }

  @override
  void update(void Function(ProjectMissingResolveBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectMissingResolve build() => _build();

  _$ProjectMissingResolve _build() {
    final _$result = _$v ??
        _$ProjectMissingResolve._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'ProjectMissingResolve', 'lockVersion'),
          orderId: orderId,
          reason: reason,
          budgetOverrideReason: budgetOverrideReason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
