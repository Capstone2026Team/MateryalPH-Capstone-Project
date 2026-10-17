// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_decision.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DisputeDecisionKindEnum _$disputeDecisionKindEnum_ADMIN_DECISION =
    const DisputeDecisionKindEnum._('ADMIN_DECISION');
const DisputeDecisionKindEnum _$disputeDecisionKindEnum_APPEAL_DECISION =
    const DisputeDecisionKindEnum._('APPEAL_DECISION');
const DisputeDecisionKindEnum _$disputeDecisionKindEnum_MUTUAL_AGREEMENT =
    const DisputeDecisionKindEnum._('MUTUAL_AGREEMENT');

DisputeDecisionKindEnum _$disputeDecisionKindEnumValueOf(String name) {
  switch (name) {
    case 'ADMIN_DECISION':
      return _$disputeDecisionKindEnum_ADMIN_DECISION;
    case 'APPEAL_DECISION':
      return _$disputeDecisionKindEnum_APPEAL_DECISION;
    case 'MUTUAL_AGREEMENT':
      return _$disputeDecisionKindEnum_MUTUAL_AGREEMENT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeDecisionKindEnum> _$disputeDecisionKindEnumValues =
    BuiltSet<DisputeDecisionKindEnum>(const <DisputeDecisionKindEnum>[
  _$disputeDecisionKindEnum_ADMIN_DECISION,
  _$disputeDecisionKindEnum_APPEAL_DECISION,
  _$disputeDecisionKindEnum_MUTUAL_AGREEMENT,
]);

const DisputeDecisionOutcomeEnum _$disputeDecisionOutcomeEnum_DISMISSED =
    const DisputeDecisionOutcomeEnum._('DISMISSED');
const DisputeDecisionOutcomeEnum _$disputeDecisionOutcomeEnum_REPLACEMENT =
    const DisputeDecisionOutcomeEnum._('REPLACEMENT');
const DisputeDecisionOutcomeEnum _$disputeDecisionOutcomeEnum_FULL_REFUND =
    const DisputeDecisionOutcomeEnum._('FULL_REFUND');
const DisputeDecisionOutcomeEnum _$disputeDecisionOutcomeEnum_PARTIAL_REFUND =
    const DisputeDecisionOutcomeEnum._('PARTIAL_REFUND');
const DisputeDecisionOutcomeEnum _$disputeDecisionOutcomeEnum_INCONCLUSIVE =
    const DisputeDecisionOutcomeEnum._('INCONCLUSIVE');
const DisputeDecisionOutcomeEnum
    _$disputeDecisionOutcomeEnum_NO_FURTHER_ACTION =
    const DisputeDecisionOutcomeEnum._('NO_FURTHER_ACTION');

DisputeDecisionOutcomeEnum _$disputeDecisionOutcomeEnumValueOf(String name) {
  switch (name) {
    case 'DISMISSED':
      return _$disputeDecisionOutcomeEnum_DISMISSED;
    case 'REPLACEMENT':
      return _$disputeDecisionOutcomeEnum_REPLACEMENT;
    case 'FULL_REFUND':
      return _$disputeDecisionOutcomeEnum_FULL_REFUND;
    case 'PARTIAL_REFUND':
      return _$disputeDecisionOutcomeEnum_PARTIAL_REFUND;
    case 'INCONCLUSIVE':
      return _$disputeDecisionOutcomeEnum_INCONCLUSIVE;
    case 'NO_FURTHER_ACTION':
      return _$disputeDecisionOutcomeEnum_NO_FURTHER_ACTION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeDecisionOutcomeEnum> _$disputeDecisionOutcomeEnumValues =
    BuiltSet<DisputeDecisionOutcomeEnum>(const <DisputeDecisionOutcomeEnum>[
  _$disputeDecisionOutcomeEnum_DISMISSED,
  _$disputeDecisionOutcomeEnum_REPLACEMENT,
  _$disputeDecisionOutcomeEnum_FULL_REFUND,
  _$disputeDecisionOutcomeEnum_PARTIAL_REFUND,
  _$disputeDecisionOutcomeEnum_INCONCLUSIVE,
  _$disputeDecisionOutcomeEnum_NO_FURTHER_ACTION,
]);

const DisputeDecisionAppealResultEnum
    _$disputeDecisionAppealResultEnum_AFFIRMED =
    const DisputeDecisionAppealResultEnum._('AFFIRMED');
const DisputeDecisionAppealResultEnum
    _$disputeDecisionAppealResultEnum_MODIFIED =
    const DisputeDecisionAppealResultEnum._('MODIFIED');
const DisputeDecisionAppealResultEnum
    _$disputeDecisionAppealResultEnum_REVERSED =
    const DisputeDecisionAppealResultEnum._('REVERSED');

DisputeDecisionAppealResultEnum _$disputeDecisionAppealResultEnumValueOf(
    String name) {
  switch (name) {
    case 'AFFIRMED':
      return _$disputeDecisionAppealResultEnum_AFFIRMED;
    case 'MODIFIED':
      return _$disputeDecisionAppealResultEnum_MODIFIED;
    case 'REVERSED':
      return _$disputeDecisionAppealResultEnum_REVERSED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeDecisionAppealResultEnum>
    _$disputeDecisionAppealResultEnumValues = BuiltSet<
        DisputeDecisionAppealResultEnum>(const <DisputeDecisionAppealResultEnum>[
  _$disputeDecisionAppealResultEnum_AFFIRMED,
  _$disputeDecisionAppealResultEnum_MODIFIED,
  _$disputeDecisionAppealResultEnum_REVERSED,
]);

Serializer<DisputeDecisionKindEnum> _$disputeDecisionKindEnumSerializer =
    _$DisputeDecisionKindEnumSerializer();
Serializer<DisputeDecisionOutcomeEnum> _$disputeDecisionOutcomeEnumSerializer =
    _$DisputeDecisionOutcomeEnumSerializer();
Serializer<DisputeDecisionAppealResultEnum>
    _$disputeDecisionAppealResultEnumSerializer =
    _$DisputeDecisionAppealResultEnumSerializer();

class _$DisputeDecisionKindEnumSerializer
    implements PrimitiveSerializer<DisputeDecisionKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ADMIN_DECISION': 'ADMIN_DECISION',
    'APPEAL_DECISION': 'APPEAL_DECISION',
    'MUTUAL_AGREEMENT': 'MUTUAL_AGREEMENT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ADMIN_DECISION': 'ADMIN_DECISION',
    'APPEAL_DECISION': 'APPEAL_DECISION',
    'MUTUAL_AGREEMENT': 'MUTUAL_AGREEMENT',
  };

  @override
  final Iterable<Type> types = const <Type>[DisputeDecisionKindEnum];
  @override
  final String wireName = 'DisputeDecisionKindEnum';

  @override
  Object serialize(Serializers serializers, DisputeDecisionKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeDecisionKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeDecisionKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeDecisionOutcomeEnumSerializer
    implements PrimitiveSerializer<DisputeDecisionOutcomeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DISMISSED': 'DISMISSED',
    'REPLACEMENT': 'REPLACEMENT',
    'FULL_REFUND': 'FULL_REFUND',
    'PARTIAL_REFUND': 'PARTIAL_REFUND',
    'INCONCLUSIVE': 'INCONCLUSIVE',
    'NO_FURTHER_ACTION': 'NO_FURTHER_ACTION',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DISMISSED': 'DISMISSED',
    'REPLACEMENT': 'REPLACEMENT',
    'FULL_REFUND': 'FULL_REFUND',
    'PARTIAL_REFUND': 'PARTIAL_REFUND',
    'INCONCLUSIVE': 'INCONCLUSIVE',
    'NO_FURTHER_ACTION': 'NO_FURTHER_ACTION',
  };

  @override
  final Iterable<Type> types = const <Type>[DisputeDecisionOutcomeEnum];
  @override
  final String wireName = 'DisputeDecisionOutcomeEnum';

  @override
  Object serialize(Serializers serializers, DisputeDecisionOutcomeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeDecisionOutcomeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeDecisionOutcomeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeDecisionAppealResultEnumSerializer
    implements PrimitiveSerializer<DisputeDecisionAppealResultEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'AFFIRMED': 'AFFIRMED',
    'MODIFIED': 'MODIFIED',
    'REVERSED': 'REVERSED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'AFFIRMED': 'AFFIRMED',
    'MODIFIED': 'MODIFIED',
    'REVERSED': 'REVERSED',
  };

  @override
  final Iterable<Type> types = const <Type>[DisputeDecisionAppealResultEnum];
  @override
  final String wireName = 'DisputeDecisionAppealResultEnum';

  @override
  Object serialize(
          Serializers serializers, DisputeDecisionAppealResultEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeDecisionAppealResultEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeDecisionAppealResultEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeDecision extends DisputeDecision {
  @override
  final String id;
  @override
  final int version;
  @override
  final DisputeDecisionKindEnum kind;
  @override
  final DisputeDecisionOutcomeEnum outcome;
  @override
  final DisputeDecisionAppealResultEnum? appealResult;
  @override
  final int awardedCentavos;
  @override
  final String? reason;
  @override
  final String? evidenceLimitation;
  @override
  final bool enforceable;
  @override
  final DateTime? decidedAt;
  @override
  final DateTime? appealDueAt;
  @override
  final String? supersedesDecisionId;
  @override
  final String deciderRole;
  @override
  final String? deciderName;
  @override
  final BuiltMap<String, JsonObject?>? sanctions;
  @override
  final bool current;

  factory _$DisputeDecision([void Function(DisputeDecisionBuilder)? updates]) =>
      (DisputeDecisionBuilder()..update(updates))._build();

  _$DisputeDecision._(
      {required this.id,
      required this.version,
      required this.kind,
      required this.outcome,
      this.appealResult,
      required this.awardedCentavos,
      this.reason,
      this.evidenceLimitation,
      required this.enforceable,
      this.decidedAt,
      this.appealDueAt,
      this.supersedesDecisionId,
      required this.deciderRole,
      this.deciderName,
      this.sanctions,
      required this.current})
      : super._();
  @override
  DisputeDecision rebuild(void Function(DisputeDecisionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeDecisionBuilder toBuilder() => DisputeDecisionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeDecision &&
        id == other.id &&
        version == other.version &&
        kind == other.kind &&
        outcome == other.outcome &&
        appealResult == other.appealResult &&
        awardedCentavos == other.awardedCentavos &&
        reason == other.reason &&
        evidenceLimitation == other.evidenceLimitation &&
        enforceable == other.enforceable &&
        decidedAt == other.decidedAt &&
        appealDueAt == other.appealDueAt &&
        supersedesDecisionId == other.supersedesDecisionId &&
        deciderRole == other.deciderRole &&
        deciderName == other.deciderName &&
        sanctions == other.sanctions &&
        current == other.current;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, outcome.hashCode);
    _$hash = $jc(_$hash, appealResult.hashCode);
    _$hash = $jc(_$hash, awardedCentavos.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, evidenceLimitation.hashCode);
    _$hash = $jc(_$hash, enforceable.hashCode);
    _$hash = $jc(_$hash, decidedAt.hashCode);
    _$hash = $jc(_$hash, appealDueAt.hashCode);
    _$hash = $jc(_$hash, supersedesDecisionId.hashCode);
    _$hash = $jc(_$hash, deciderRole.hashCode);
    _$hash = $jc(_$hash, deciderName.hashCode);
    _$hash = $jc(_$hash, sanctions.hashCode);
    _$hash = $jc(_$hash, current.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeDecision')
          ..add('id', id)
          ..add('version', version)
          ..add('kind', kind)
          ..add('outcome', outcome)
          ..add('appealResult', appealResult)
          ..add('awardedCentavos', awardedCentavos)
          ..add('reason', reason)
          ..add('evidenceLimitation', evidenceLimitation)
          ..add('enforceable', enforceable)
          ..add('decidedAt', decidedAt)
          ..add('appealDueAt', appealDueAt)
          ..add('supersedesDecisionId', supersedesDecisionId)
          ..add('deciderRole', deciderRole)
          ..add('deciderName', deciderName)
          ..add('sanctions', sanctions)
          ..add('current', current))
        .toString();
  }
}

class DisputeDecisionBuilder
    implements Builder<DisputeDecision, DisputeDecisionBuilder> {
  _$DisputeDecision? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  DisputeDecisionKindEnum? _kind;
  DisputeDecisionKindEnum? get kind => _$this._kind;
  set kind(DisputeDecisionKindEnum? kind) => _$this._kind = kind;

  DisputeDecisionOutcomeEnum? _outcome;
  DisputeDecisionOutcomeEnum? get outcome => _$this._outcome;
  set outcome(DisputeDecisionOutcomeEnum? outcome) => _$this._outcome = outcome;

  DisputeDecisionAppealResultEnum? _appealResult;
  DisputeDecisionAppealResultEnum? get appealResult => _$this._appealResult;
  set appealResult(DisputeDecisionAppealResultEnum? appealResult) =>
      _$this._appealResult = appealResult;

  int? _awardedCentavos;
  int? get awardedCentavos => _$this._awardedCentavos;
  set awardedCentavos(int? awardedCentavos) =>
      _$this._awardedCentavos = awardedCentavos;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _evidenceLimitation;
  String? get evidenceLimitation => _$this._evidenceLimitation;
  set evidenceLimitation(String? evidenceLimitation) =>
      _$this._evidenceLimitation = evidenceLimitation;

  bool? _enforceable;
  bool? get enforceable => _$this._enforceable;
  set enforceable(bool? enforceable) => _$this._enforceable = enforceable;

  DateTime? _decidedAt;
  DateTime? get decidedAt => _$this._decidedAt;
  set decidedAt(DateTime? decidedAt) => _$this._decidedAt = decidedAt;

  DateTime? _appealDueAt;
  DateTime? get appealDueAt => _$this._appealDueAt;
  set appealDueAt(DateTime? appealDueAt) => _$this._appealDueAt = appealDueAt;

  String? _supersedesDecisionId;
  String? get supersedesDecisionId => _$this._supersedesDecisionId;
  set supersedesDecisionId(String? supersedesDecisionId) =>
      _$this._supersedesDecisionId = supersedesDecisionId;

  String? _deciderRole;
  String? get deciderRole => _$this._deciderRole;
  set deciderRole(String? deciderRole) => _$this._deciderRole = deciderRole;

  String? _deciderName;
  String? get deciderName => _$this._deciderName;
  set deciderName(String? deciderName) => _$this._deciderName = deciderName;

  MapBuilder<String, JsonObject?>? _sanctions;
  MapBuilder<String, JsonObject?> get sanctions =>
      _$this._sanctions ??= MapBuilder<String, JsonObject?>();
  set sanctions(MapBuilder<String, JsonObject?>? sanctions) =>
      _$this._sanctions = sanctions;

  bool? _current;
  bool? get current => _$this._current;
  set current(bool? current) => _$this._current = current;

  DisputeDecisionBuilder() {
    DisputeDecision._defaults(this);
  }

  DisputeDecisionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _version = $v.version;
      _kind = $v.kind;
      _outcome = $v.outcome;
      _appealResult = $v.appealResult;
      _awardedCentavos = $v.awardedCentavos;
      _reason = $v.reason;
      _evidenceLimitation = $v.evidenceLimitation;
      _enforceable = $v.enforceable;
      _decidedAt = $v.decidedAt;
      _appealDueAt = $v.appealDueAt;
      _supersedesDecisionId = $v.supersedesDecisionId;
      _deciderRole = $v.deciderRole;
      _deciderName = $v.deciderName;
      _sanctions = $v.sanctions?.toBuilder();
      _current = $v.current;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeDecision other) {
    _$v = other as _$DisputeDecision;
  }

  @override
  void update(void Function(DisputeDecisionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeDecision build() => _build();

  _$DisputeDecision _build() {
    _$DisputeDecision _$result;
    try {
      _$result = _$v ??
          _$DisputeDecision._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'DisputeDecision', 'id'),
            version: BuiltValueNullFieldError.checkNotNull(
                version, r'DisputeDecision', 'version'),
            kind: BuiltValueNullFieldError.checkNotNull(
                kind, r'DisputeDecision', 'kind'),
            outcome: BuiltValueNullFieldError.checkNotNull(
                outcome, r'DisputeDecision', 'outcome'),
            appealResult: appealResult,
            awardedCentavos: BuiltValueNullFieldError.checkNotNull(
                awardedCentavos, r'DisputeDecision', 'awardedCentavos'),
            reason: reason,
            evidenceLimitation: evidenceLimitation,
            enforceable: BuiltValueNullFieldError.checkNotNull(
                enforceable, r'DisputeDecision', 'enforceable'),
            decidedAt: decidedAt,
            appealDueAt: appealDueAt,
            supersedesDecisionId: supersedesDecisionId,
            deciderRole: BuiltValueNullFieldError.checkNotNull(
                deciderRole, r'DisputeDecision', 'deciderRole'),
            deciderName: deciderName,
            sanctions: _sanctions?.build(),
            current: BuiltValueNullFieldError.checkNotNull(
                current, r'DisputeDecision', 'current'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sanctions';
        _sanctions?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DisputeDecision', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
