// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_override_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BudgetOverrideRecord extends BudgetOverrideRecord {
  @override
  final String id;
  @override
  final String project;
  @override
  final String workPackage;
  @override
  final String? orderReference;
  @override
  final int priorBudgetCentavos;
  @override
  final int orderAmountCentavos;
  @override
  final int overageCentavos;
  @override
  final String reason;
  @override
  final String actor;
  @override
  final DateTime recordedAt;

  factory _$BudgetOverrideRecord(
          [void Function(BudgetOverrideRecordBuilder)? updates]) =>
      (BudgetOverrideRecordBuilder()..update(updates))._build();

  _$BudgetOverrideRecord._(
      {required this.id,
      required this.project,
      required this.workPackage,
      this.orderReference,
      required this.priorBudgetCentavos,
      required this.orderAmountCentavos,
      required this.overageCentavos,
      required this.reason,
      required this.actor,
      required this.recordedAt})
      : super._();
  @override
  BudgetOverrideRecord rebuild(
          void Function(BudgetOverrideRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BudgetOverrideRecordBuilder toBuilder() =>
      BudgetOverrideRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BudgetOverrideRecord &&
        id == other.id &&
        project == other.project &&
        workPackage == other.workPackage &&
        orderReference == other.orderReference &&
        priorBudgetCentavos == other.priorBudgetCentavos &&
        orderAmountCentavos == other.orderAmountCentavos &&
        overageCentavos == other.overageCentavos &&
        reason == other.reason &&
        actor == other.actor &&
        recordedAt == other.recordedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, project.hashCode);
    _$hash = $jc(_$hash, workPackage.hashCode);
    _$hash = $jc(_$hash, orderReference.hashCode);
    _$hash = $jc(_$hash, priorBudgetCentavos.hashCode);
    _$hash = $jc(_$hash, orderAmountCentavos.hashCode);
    _$hash = $jc(_$hash, overageCentavos.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, actor.hashCode);
    _$hash = $jc(_$hash, recordedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BudgetOverrideRecord')
          ..add('id', id)
          ..add('project', project)
          ..add('workPackage', workPackage)
          ..add('orderReference', orderReference)
          ..add('priorBudgetCentavos', priorBudgetCentavos)
          ..add('orderAmountCentavos', orderAmountCentavos)
          ..add('overageCentavos', overageCentavos)
          ..add('reason', reason)
          ..add('actor', actor)
          ..add('recordedAt', recordedAt))
        .toString();
  }
}

class BudgetOverrideRecordBuilder
    implements Builder<BudgetOverrideRecord, BudgetOverrideRecordBuilder> {
  _$BudgetOverrideRecord? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _project;
  String? get project => _$this._project;
  set project(String? project) => _$this._project = project;

  String? _workPackage;
  String? get workPackage => _$this._workPackage;
  set workPackage(String? workPackage) => _$this._workPackage = workPackage;

  String? _orderReference;
  String? get orderReference => _$this._orderReference;
  set orderReference(String? orderReference) =>
      _$this._orderReference = orderReference;

  int? _priorBudgetCentavos;
  int? get priorBudgetCentavos => _$this._priorBudgetCentavos;
  set priorBudgetCentavos(int? priorBudgetCentavos) =>
      _$this._priorBudgetCentavos = priorBudgetCentavos;

  int? _orderAmountCentavos;
  int? get orderAmountCentavos => _$this._orderAmountCentavos;
  set orderAmountCentavos(int? orderAmountCentavos) =>
      _$this._orderAmountCentavos = orderAmountCentavos;

  int? _overageCentavos;
  int? get overageCentavos => _$this._overageCentavos;
  set overageCentavos(int? overageCentavos) =>
      _$this._overageCentavos = overageCentavos;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _actor;
  String? get actor => _$this._actor;
  set actor(String? actor) => _$this._actor = actor;

  DateTime? _recordedAt;
  DateTime? get recordedAt => _$this._recordedAt;
  set recordedAt(DateTime? recordedAt) => _$this._recordedAt = recordedAt;

  BudgetOverrideRecordBuilder() {
    BudgetOverrideRecord._defaults(this);
  }

  BudgetOverrideRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _project = $v.project;
      _workPackage = $v.workPackage;
      _orderReference = $v.orderReference;
      _priorBudgetCentavos = $v.priorBudgetCentavos;
      _orderAmountCentavos = $v.orderAmountCentavos;
      _overageCentavos = $v.overageCentavos;
      _reason = $v.reason;
      _actor = $v.actor;
      _recordedAt = $v.recordedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BudgetOverrideRecord other) {
    _$v = other as _$BudgetOverrideRecord;
  }

  @override
  void update(void Function(BudgetOverrideRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BudgetOverrideRecord build() => _build();

  _$BudgetOverrideRecord _build() {
    final _$result = _$v ??
        _$BudgetOverrideRecord._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'BudgetOverrideRecord', 'id'),
          project: BuiltValueNullFieldError.checkNotNull(
              project, r'BudgetOverrideRecord', 'project'),
          workPackage: BuiltValueNullFieldError.checkNotNull(
              workPackage, r'BudgetOverrideRecord', 'workPackage'),
          orderReference: orderReference,
          priorBudgetCentavos: BuiltValueNullFieldError.checkNotNull(
              priorBudgetCentavos,
              r'BudgetOverrideRecord',
              'priorBudgetCentavos'),
          orderAmountCentavos: BuiltValueNullFieldError.checkNotNull(
              orderAmountCentavos,
              r'BudgetOverrideRecord',
              'orderAmountCentavos'),
          overageCentavos: BuiltValueNullFieldError.checkNotNull(
              overageCentavos, r'BudgetOverrideRecord', 'overageCentavos'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'BudgetOverrideRecord', 'reason'),
          actor: BuiltValueNullFieldError.checkNotNull(
              actor, r'BudgetOverrideRecord', 'actor'),
          recordedAt: BuiltValueNullFieldError.checkNotNull(
              recordedAt, r'BudgetOverrideRecord', 'recordedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
