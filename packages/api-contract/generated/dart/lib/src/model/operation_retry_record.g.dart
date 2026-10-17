// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation_retry_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OperationRetryRecord extends OperationRetryRecord {
  @override
  final String targetType;
  @override
  final String label;
  @override
  final String reason;
  @override
  final String outcome;
  @override
  final String actor;
  @override
  final String actorRole;
  @override
  final String correlationId;
  @override
  final DateTime createdAt;

  factory _$OperationRetryRecord(
          [void Function(OperationRetryRecordBuilder)? updates]) =>
      (OperationRetryRecordBuilder()..update(updates))._build();

  _$OperationRetryRecord._(
      {required this.targetType,
      required this.label,
      required this.reason,
      required this.outcome,
      required this.actor,
      required this.actorRole,
      required this.correlationId,
      required this.createdAt})
      : super._();
  @override
  OperationRetryRecord rebuild(
          void Function(OperationRetryRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OperationRetryRecordBuilder toBuilder() =>
      OperationRetryRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OperationRetryRecord &&
        targetType == other.targetType &&
        label == other.label &&
        reason == other.reason &&
        outcome == other.outcome &&
        actor == other.actor &&
        actorRole == other.actorRole &&
        correlationId == other.correlationId &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, targetType.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, outcome.hashCode);
    _$hash = $jc(_$hash, actor.hashCode);
    _$hash = $jc(_$hash, actorRole.hashCode);
    _$hash = $jc(_$hash, correlationId.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OperationRetryRecord')
          ..add('targetType', targetType)
          ..add('label', label)
          ..add('reason', reason)
          ..add('outcome', outcome)
          ..add('actor', actor)
          ..add('actorRole', actorRole)
          ..add('correlationId', correlationId)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class OperationRetryRecordBuilder
    implements Builder<OperationRetryRecord, OperationRetryRecordBuilder> {
  _$OperationRetryRecord? _$v;

  String? _targetType;
  String? get targetType => _$this._targetType;
  set targetType(String? targetType) => _$this._targetType = targetType;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _outcome;
  String? get outcome => _$this._outcome;
  set outcome(String? outcome) => _$this._outcome = outcome;

  String? _actor;
  String? get actor => _$this._actor;
  set actor(String? actor) => _$this._actor = actor;

  String? _actorRole;
  String? get actorRole => _$this._actorRole;
  set actorRole(String? actorRole) => _$this._actorRole = actorRole;

  String? _correlationId;
  String? get correlationId => _$this._correlationId;
  set correlationId(String? correlationId) =>
      _$this._correlationId = correlationId;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  OperationRetryRecordBuilder() {
    OperationRetryRecord._defaults(this);
  }

  OperationRetryRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _targetType = $v.targetType;
      _label = $v.label;
      _reason = $v.reason;
      _outcome = $v.outcome;
      _actor = $v.actor;
      _actorRole = $v.actorRole;
      _correlationId = $v.correlationId;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OperationRetryRecord other) {
    _$v = other as _$OperationRetryRecord;
  }

  @override
  void update(void Function(OperationRetryRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OperationRetryRecord build() => _build();

  _$OperationRetryRecord _build() {
    final _$result = _$v ??
        _$OperationRetryRecord._(
          targetType: BuiltValueNullFieldError.checkNotNull(
              targetType, r'OperationRetryRecord', 'targetType'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'OperationRetryRecord', 'label'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'OperationRetryRecord', 'reason'),
          outcome: BuiltValueNullFieldError.checkNotNull(
              outcome, r'OperationRetryRecord', 'outcome'),
          actor: BuiltValueNullFieldError.checkNotNull(
              actor, r'OperationRetryRecord', 'actor'),
          actorRole: BuiltValueNullFieldError.checkNotNull(
              actorRole, r'OperationRetryRecord', 'actorRole'),
          correlationId: BuiltValueNullFieldError.checkNotNull(
              correlationId, r'OperationRetryRecord', 'correlationId'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'OperationRetryRecord', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
