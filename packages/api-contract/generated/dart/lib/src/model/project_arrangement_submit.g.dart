// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_arrangement_submit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProjectArrangementSubmit extends ProjectArrangementSubmit {
  @override
  final int version;
  @override
  final String fingerprint;
  @override
  final bool acknowledged;
  @override
  final BuiltList<ProjectArrangementSubmitPaymentsInner> payments;
  @override
  final String? note;
  @override
  final String? budgetOverrideReason;

  factory _$ProjectArrangementSubmit(
          [void Function(ProjectArrangementSubmitBuilder)? updates]) =>
      (ProjectArrangementSubmitBuilder()..update(updates))._build();

  _$ProjectArrangementSubmit._(
      {required this.version,
      required this.fingerprint,
      required this.acknowledged,
      required this.payments,
      this.note,
      this.budgetOverrideReason})
      : super._();
  @override
  ProjectArrangementSubmit rebuild(
          void Function(ProjectArrangementSubmitBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectArrangementSubmitBuilder toBuilder() =>
      ProjectArrangementSubmitBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectArrangementSubmit &&
        version == other.version &&
        fingerprint == other.fingerprint &&
        acknowledged == other.acknowledged &&
        payments == other.payments &&
        note == other.note &&
        budgetOverrideReason == other.budgetOverrideReason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, fingerprint.hashCode);
    _$hash = $jc(_$hash, acknowledged.hashCode);
    _$hash = $jc(_$hash, payments.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, budgetOverrideReason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectArrangementSubmit')
          ..add('version', version)
          ..add('fingerprint', fingerprint)
          ..add('acknowledged', acknowledged)
          ..add('payments', payments)
          ..add('note', note)
          ..add('budgetOverrideReason', budgetOverrideReason))
        .toString();
  }
}

class ProjectArrangementSubmitBuilder
    implements
        Builder<ProjectArrangementSubmit, ProjectArrangementSubmitBuilder> {
  _$ProjectArrangementSubmit? _$v;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  String? _fingerprint;
  String? get fingerprint => _$this._fingerprint;
  set fingerprint(String? fingerprint) => _$this._fingerprint = fingerprint;

  bool? _acknowledged;
  bool? get acknowledged => _$this._acknowledged;
  set acknowledged(bool? acknowledged) => _$this._acknowledged = acknowledged;

  ListBuilder<ProjectArrangementSubmitPaymentsInner>? _payments;
  ListBuilder<ProjectArrangementSubmitPaymentsInner> get payments =>
      _$this._payments ??= ListBuilder<ProjectArrangementSubmitPaymentsInner>();
  set payments(ListBuilder<ProjectArrangementSubmitPaymentsInner>? payments) =>
      _$this._payments = payments;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  String? _budgetOverrideReason;
  String? get budgetOverrideReason => _$this._budgetOverrideReason;
  set budgetOverrideReason(String? budgetOverrideReason) =>
      _$this._budgetOverrideReason = budgetOverrideReason;

  ProjectArrangementSubmitBuilder() {
    ProjectArrangementSubmit._defaults(this);
  }

  ProjectArrangementSubmitBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _version = $v.version;
      _fingerprint = $v.fingerprint;
      _acknowledged = $v.acknowledged;
      _payments = $v.payments.toBuilder();
      _note = $v.note;
      _budgetOverrideReason = $v.budgetOverrideReason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectArrangementSubmit other) {
    _$v = other as _$ProjectArrangementSubmit;
  }

  @override
  void update(void Function(ProjectArrangementSubmitBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectArrangementSubmit build() => _build();

  _$ProjectArrangementSubmit _build() {
    _$ProjectArrangementSubmit _$result;
    try {
      _$result = _$v ??
          _$ProjectArrangementSubmit._(
            version: BuiltValueNullFieldError.checkNotNull(
                version, r'ProjectArrangementSubmit', 'version'),
            fingerprint: BuiltValueNullFieldError.checkNotNull(
                fingerprint, r'ProjectArrangementSubmit', 'fingerprint'),
            acknowledged: BuiltValueNullFieldError.checkNotNull(
                acknowledged, r'ProjectArrangementSubmit', 'acknowledged'),
            payments: payments.build(),
            note: note,
            budgetOverrideReason: budgetOverrideReason,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'payments';
        payments.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProjectArrangementSubmit', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
