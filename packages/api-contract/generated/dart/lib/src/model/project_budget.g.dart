// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_budget.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectBudget extends ProjectBudget {
  @override
  final int budgetCentavos;
  @override
  final int pendingCentavos;
  @override
  final int actualCentavos;
  @override
  final int awaitingRecoveryCentavos;
  @override
  final int committedCentavos;
  @override
  final int remainingCentavos;
  @override
  final String utilizationPercent;
  @override
  final bool warning;
  @override
  final String label;
  @override
  final int allocatedCentavos;
  @override
  final int unallocatedCentavos;
  @override
  final int pendingConfirmationCount;
  @override
  final String processingFeeStatus;

  factory _$ProjectBudget([void Function(ProjectBudgetBuilder)? updates]) =>
      (ProjectBudgetBuilder()..update(updates))._build();

  _$ProjectBudget._(
      {required this.budgetCentavos,
      required this.pendingCentavos,
      required this.actualCentavos,
      required this.awaitingRecoveryCentavos,
      required this.committedCentavos,
      required this.remainingCentavos,
      required this.utilizationPercent,
      required this.warning,
      required this.label,
      required this.allocatedCentavos,
      required this.unallocatedCentavos,
      required this.pendingConfirmationCount,
      required this.processingFeeStatus})
      : super._();
  @override
  ProjectBudget rebuild(void Function(ProjectBudgetBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectBudgetBuilder toBuilder() => ProjectBudgetBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectBudget &&
        budgetCentavos == other.budgetCentavos &&
        pendingCentavos == other.pendingCentavos &&
        actualCentavos == other.actualCentavos &&
        awaitingRecoveryCentavos == other.awaitingRecoveryCentavos &&
        committedCentavos == other.committedCentavos &&
        remainingCentavos == other.remainingCentavos &&
        utilizationPercent == other.utilizationPercent &&
        warning == other.warning &&
        label == other.label &&
        allocatedCentavos == other.allocatedCentavos &&
        unallocatedCentavos == other.unallocatedCentavos &&
        pendingConfirmationCount == other.pendingConfirmationCount &&
        processingFeeStatus == other.processingFeeStatus;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, budgetCentavos.hashCode);
    _$hash = $jc(_$hash, pendingCentavos.hashCode);
    _$hash = $jc(_$hash, actualCentavos.hashCode);
    _$hash = $jc(_$hash, awaitingRecoveryCentavos.hashCode);
    _$hash = $jc(_$hash, committedCentavos.hashCode);
    _$hash = $jc(_$hash, remainingCentavos.hashCode);
    _$hash = $jc(_$hash, utilizationPercent.hashCode);
    _$hash = $jc(_$hash, warning.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, allocatedCentavos.hashCode);
    _$hash = $jc(_$hash, unallocatedCentavos.hashCode);
    _$hash = $jc(_$hash, pendingConfirmationCount.hashCode);
    _$hash = $jc(_$hash, processingFeeStatus.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectBudget')
          ..add('budgetCentavos', budgetCentavos)
          ..add('pendingCentavos', pendingCentavos)
          ..add('actualCentavos', actualCentavos)
          ..add('awaitingRecoveryCentavos', awaitingRecoveryCentavos)
          ..add('committedCentavos', committedCentavos)
          ..add('remainingCentavos', remainingCentavos)
          ..add('utilizationPercent', utilizationPercent)
          ..add('warning', warning)
          ..add('label', label)
          ..add('allocatedCentavos', allocatedCentavos)
          ..add('unallocatedCentavos', unallocatedCentavos)
          ..add('pendingConfirmationCount', pendingConfirmationCount)
          ..add('processingFeeStatus', processingFeeStatus))
        .toString();
  }
}

class ProjectBudgetBuilder
    implements Builder<ProjectBudget, ProjectBudgetBuilder> {
  _$ProjectBudget? _$v;

  int? _budgetCentavos;
  int? get budgetCentavos => _$this._budgetCentavos;
  set budgetCentavos(int? budgetCentavos) =>
      _$this._budgetCentavos = budgetCentavos;

  int? _pendingCentavos;
  int? get pendingCentavos => _$this._pendingCentavos;
  set pendingCentavos(int? pendingCentavos) =>
      _$this._pendingCentavos = pendingCentavos;

  int? _actualCentavos;
  int? get actualCentavos => _$this._actualCentavos;
  set actualCentavos(int? actualCentavos) =>
      _$this._actualCentavos = actualCentavos;

  int? _awaitingRecoveryCentavos;
  int? get awaitingRecoveryCentavos => _$this._awaitingRecoveryCentavos;
  set awaitingRecoveryCentavos(int? awaitingRecoveryCentavos) =>
      _$this._awaitingRecoveryCentavos = awaitingRecoveryCentavos;

  int? _committedCentavos;
  int? get committedCentavos => _$this._committedCentavos;
  set committedCentavos(int? committedCentavos) =>
      _$this._committedCentavos = committedCentavos;

  int? _remainingCentavos;
  int? get remainingCentavos => _$this._remainingCentavos;
  set remainingCentavos(int? remainingCentavos) =>
      _$this._remainingCentavos = remainingCentavos;

  String? _utilizationPercent;
  String? get utilizationPercent => _$this._utilizationPercent;
  set utilizationPercent(String? utilizationPercent) =>
      _$this._utilizationPercent = utilizationPercent;

  bool? _warning;
  bool? get warning => _$this._warning;
  set warning(bool? warning) => _$this._warning = warning;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  int? _allocatedCentavos;
  int? get allocatedCentavos => _$this._allocatedCentavos;
  set allocatedCentavos(int? allocatedCentavos) =>
      _$this._allocatedCentavos = allocatedCentavos;

  int? _unallocatedCentavos;
  int? get unallocatedCentavos => _$this._unallocatedCentavos;
  set unallocatedCentavos(int? unallocatedCentavos) =>
      _$this._unallocatedCentavos = unallocatedCentavos;

  int? _pendingConfirmationCount;
  int? get pendingConfirmationCount => _$this._pendingConfirmationCount;
  set pendingConfirmationCount(int? pendingConfirmationCount) =>
      _$this._pendingConfirmationCount = pendingConfirmationCount;

  String? _processingFeeStatus;
  String? get processingFeeStatus => _$this._processingFeeStatus;
  set processingFeeStatus(String? processingFeeStatus) =>
      _$this._processingFeeStatus = processingFeeStatus;

  ProjectBudgetBuilder() {
    ProjectBudget._defaults(this);
  }

  ProjectBudgetBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _budgetCentavos = $v.budgetCentavos;
      _pendingCentavos = $v.pendingCentavos;
      _actualCentavos = $v.actualCentavos;
      _awaitingRecoveryCentavos = $v.awaitingRecoveryCentavos;
      _committedCentavos = $v.committedCentavos;
      _remainingCentavos = $v.remainingCentavos;
      _utilizationPercent = $v.utilizationPercent;
      _warning = $v.warning;
      _label = $v.label;
      _allocatedCentavos = $v.allocatedCentavos;
      _unallocatedCentavos = $v.unallocatedCentavos;
      _pendingConfirmationCount = $v.pendingConfirmationCount;
      _processingFeeStatus = $v.processingFeeStatus;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectBudget other) {
    _$v = other as _$ProjectBudget;
  }

  @override
  void update(void Function(ProjectBudgetBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectBudget build() => _build();

  _$ProjectBudget _build() {
    final _$result = _$v ??
        _$ProjectBudget._(
          budgetCentavos: BuiltValueNullFieldError.checkNotNull(
              budgetCentavos, r'ProjectBudget', 'budgetCentavos'),
          pendingCentavos: BuiltValueNullFieldError.checkNotNull(
              pendingCentavos, r'ProjectBudget', 'pendingCentavos'),
          actualCentavos: BuiltValueNullFieldError.checkNotNull(
              actualCentavos, r'ProjectBudget', 'actualCentavos'),
          awaitingRecoveryCentavos: BuiltValueNullFieldError.checkNotNull(
              awaitingRecoveryCentavos,
              r'ProjectBudget',
              'awaitingRecoveryCentavos'),
          committedCentavos: BuiltValueNullFieldError.checkNotNull(
              committedCentavos, r'ProjectBudget', 'committedCentavos'),
          remainingCentavos: BuiltValueNullFieldError.checkNotNull(
              remainingCentavos, r'ProjectBudget', 'remainingCentavos'),
          utilizationPercent: BuiltValueNullFieldError.checkNotNull(
              utilizationPercent, r'ProjectBudget', 'utilizationPercent'),
          warning: BuiltValueNullFieldError.checkNotNull(
              warning, r'ProjectBudget', 'warning'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'ProjectBudget', 'label'),
          allocatedCentavos: BuiltValueNullFieldError.checkNotNull(
              allocatedCentavos, r'ProjectBudget', 'allocatedCentavos'),
          unallocatedCentavos: BuiltValueNullFieldError.checkNotNull(
              unallocatedCentavos, r'ProjectBudget', 'unallocatedCentavos'),
          pendingConfirmationCount: BuiltValueNullFieldError.checkNotNull(
              pendingConfirmationCount,
              r'ProjectBudget',
              'pendingConfirmationCount'),
          processingFeeStatus: BuiltValueNullFieldError.checkNotNull(
              processingFeeStatus, r'ProjectBudget', 'processingFeeStatus'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
