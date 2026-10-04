// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_remedy.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DisputeRemedyKindEnum _$disputeRemedyKindEnum_ONLINE_REFUND =
    const DisputeRemedyKindEnum._('ONLINE_REFUND');
const DisputeRemedyKindEnum _$disputeRemedyKindEnum_CASH_REIMBURSEMENT =
    const DisputeRemedyKindEnum._('CASH_REIMBURSEMENT');
const DisputeRemedyKindEnum _$disputeRemedyKindEnum_REPLACEMENT =
    const DisputeRemedyKindEnum._('REPLACEMENT');
const DisputeRemedyKindEnum _$disputeRemedyKindEnum_FEE_CREDIT_REVIEW =
    const DisputeRemedyKindEnum._('FEE_CREDIT_REVIEW');
const DisputeRemedyKindEnum _$disputeRemedyKindEnum_ORDER_CANCELLATION =
    const DisputeRemedyKindEnum._('ORDER_CANCELLATION');

DisputeRemedyKindEnum _$disputeRemedyKindEnumValueOf(String name) {
  switch (name) {
    case 'ONLINE_REFUND':
      return _$disputeRemedyKindEnum_ONLINE_REFUND;
    case 'CASH_REIMBURSEMENT':
      return _$disputeRemedyKindEnum_CASH_REIMBURSEMENT;
    case 'REPLACEMENT':
      return _$disputeRemedyKindEnum_REPLACEMENT;
    case 'FEE_CREDIT_REVIEW':
      return _$disputeRemedyKindEnum_FEE_CREDIT_REVIEW;
    case 'ORDER_CANCELLATION':
      return _$disputeRemedyKindEnum_ORDER_CANCELLATION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeRemedyKindEnum> _$disputeRemedyKindEnumValues =
    BuiltSet<DisputeRemedyKindEnum>(const <DisputeRemedyKindEnum>[
  _$disputeRemedyKindEnum_ONLINE_REFUND,
  _$disputeRemedyKindEnum_CASH_REIMBURSEMENT,
  _$disputeRemedyKindEnum_REPLACEMENT,
  _$disputeRemedyKindEnum_FEE_CREDIT_REVIEW,
  _$disputeRemedyKindEnum_ORDER_CANCELLATION,
]);

const DisputeRemedyStateEnum _$disputeRemedyStateEnum_PENDING =
    const DisputeRemedyStateEnum._('PENDING');
const DisputeRemedyStateEnum _$disputeRemedyStateEnum_COMPLETED =
    const DisputeRemedyStateEnum._('COMPLETED');
const DisputeRemedyStateEnum _$disputeRemedyStateEnum_FAILED =
    const DisputeRemedyStateEnum._('FAILED');

DisputeRemedyStateEnum _$disputeRemedyStateEnumValueOf(String name) {
  switch (name) {
    case 'PENDING':
      return _$disputeRemedyStateEnum_PENDING;
    case 'COMPLETED':
      return _$disputeRemedyStateEnum_COMPLETED;
    case 'FAILED':
      return _$disputeRemedyStateEnum_FAILED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeRemedyStateEnum> _$disputeRemedyStateEnumValues =
    BuiltSet<DisputeRemedyStateEnum>(const <DisputeRemedyStateEnum>[
  _$disputeRemedyStateEnum_PENDING,
  _$disputeRemedyStateEnum_COMPLETED,
  _$disputeRemedyStateEnum_FAILED,
]);

Serializer<DisputeRemedyKindEnum> _$disputeRemedyKindEnumSerializer =
    _$DisputeRemedyKindEnumSerializer();
Serializer<DisputeRemedyStateEnum> _$disputeRemedyStateEnumSerializer =
    _$DisputeRemedyStateEnumSerializer();

class _$DisputeRemedyKindEnumSerializer
    implements PrimitiveSerializer<DisputeRemedyKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ONLINE_REFUND': 'ONLINE_REFUND',
    'CASH_REIMBURSEMENT': 'CASH_REIMBURSEMENT',
    'REPLACEMENT': 'REPLACEMENT',
    'FEE_CREDIT_REVIEW': 'FEE_CREDIT_REVIEW',
    'ORDER_CANCELLATION': 'ORDER_CANCELLATION',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ONLINE_REFUND': 'ONLINE_REFUND',
    'CASH_REIMBURSEMENT': 'CASH_REIMBURSEMENT',
    'REPLACEMENT': 'REPLACEMENT',
    'FEE_CREDIT_REVIEW': 'FEE_CREDIT_REVIEW',
    'ORDER_CANCELLATION': 'ORDER_CANCELLATION',
  };

  @override
  final Iterable<Type> types = const <Type>[DisputeRemedyKindEnum];
  @override
  final String wireName = 'DisputeRemedyKindEnum';

  @override
  Object serialize(Serializers serializers, DisputeRemedyKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeRemedyKindEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeRemedyKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeRemedyStateEnumSerializer
    implements PrimitiveSerializer<DisputeRemedyStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PENDING': 'PENDING',
    'COMPLETED': 'COMPLETED',
    'FAILED': 'FAILED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PENDING': 'PENDING',
    'COMPLETED': 'COMPLETED',
    'FAILED': 'FAILED',
  };

  @override
  final Iterable<Type> types = const <Type>[DisputeRemedyStateEnum];
  @override
  final String wireName = 'DisputeRemedyStateEnum';

  @override
  Object serialize(Serializers serializers, DisputeRemedyStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeRemedyStateEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeRemedyStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeRemedy extends DisputeRemedy {
  @override
  final String id;
  @override
  final DisputeRemedyKindEnum kind;
  @override
  final DisputeRemedyStateEnum state;
  @override
  final int amountCentavos;
  @override
  final String? note;
  @override
  final bool recorded;
  @override
  final DateTime? completedAt;
  @override
  final String? decisionId;
  @override
  final DisputeFileLink? evidence;
  @override
  final bool canRecord;
  @override
  final bool canConfirm;

  factory _$DisputeRemedy([void Function(DisputeRemedyBuilder)? updates]) =>
      (DisputeRemedyBuilder()..update(updates))._build();

  _$DisputeRemedy._(
      {required this.id,
      required this.kind,
      required this.state,
      required this.amountCentavos,
      this.note,
      required this.recorded,
      this.completedAt,
      this.decisionId,
      this.evidence,
      required this.canRecord,
      required this.canConfirm})
      : super._();
  @override
  DisputeRemedy rebuild(void Function(DisputeRemedyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeRemedyBuilder toBuilder() => DisputeRemedyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeRemedy &&
        id == other.id &&
        kind == other.kind &&
        state == other.state &&
        amountCentavos == other.amountCentavos &&
        note == other.note &&
        recorded == other.recorded &&
        completedAt == other.completedAt &&
        decisionId == other.decisionId &&
        evidence == other.evidence &&
        canRecord == other.canRecord &&
        canConfirm == other.canConfirm;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, amountCentavos.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, recorded.hashCode);
    _$hash = $jc(_$hash, completedAt.hashCode);
    _$hash = $jc(_$hash, decisionId.hashCode);
    _$hash = $jc(_$hash, evidence.hashCode);
    _$hash = $jc(_$hash, canRecord.hashCode);
    _$hash = $jc(_$hash, canConfirm.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeRemedy')
          ..add('id', id)
          ..add('kind', kind)
          ..add('state', state)
          ..add('amountCentavos', amountCentavos)
          ..add('note', note)
          ..add('recorded', recorded)
          ..add('completedAt', completedAt)
          ..add('decisionId', decisionId)
          ..add('evidence', evidence)
          ..add('canRecord', canRecord)
          ..add('canConfirm', canConfirm))
        .toString();
  }
}

class DisputeRemedyBuilder
    implements Builder<DisputeRemedy, DisputeRemedyBuilder> {
  _$DisputeRemedy? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DisputeRemedyKindEnum? _kind;
  DisputeRemedyKindEnum? get kind => _$this._kind;
  set kind(DisputeRemedyKindEnum? kind) => _$this._kind = kind;

  DisputeRemedyStateEnum? _state;
  DisputeRemedyStateEnum? get state => _$this._state;
  set state(DisputeRemedyStateEnum? state) => _$this._state = state;

  int? _amountCentavos;
  int? get amountCentavos => _$this._amountCentavos;
  set amountCentavos(int? amountCentavos) =>
      _$this._amountCentavos = amountCentavos;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  bool? _recorded;
  bool? get recorded => _$this._recorded;
  set recorded(bool? recorded) => _$this._recorded = recorded;

  DateTime? _completedAt;
  DateTime? get completedAt => _$this._completedAt;
  set completedAt(DateTime? completedAt) => _$this._completedAt = completedAt;

  String? _decisionId;
  String? get decisionId => _$this._decisionId;
  set decisionId(String? decisionId) => _$this._decisionId = decisionId;

  DisputeFileLinkBuilder? _evidence;
  DisputeFileLinkBuilder get evidence =>
      _$this._evidence ??= DisputeFileLinkBuilder();
  set evidence(DisputeFileLinkBuilder? evidence) => _$this._evidence = evidence;

  bool? _canRecord;
  bool? get canRecord => _$this._canRecord;
  set canRecord(bool? canRecord) => _$this._canRecord = canRecord;

  bool? _canConfirm;
  bool? get canConfirm => _$this._canConfirm;
  set canConfirm(bool? canConfirm) => _$this._canConfirm = canConfirm;

  DisputeRemedyBuilder() {
    DisputeRemedy._defaults(this);
  }

  DisputeRemedyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _kind = $v.kind;
      _state = $v.state;
      _amountCentavos = $v.amountCentavos;
      _note = $v.note;
      _recorded = $v.recorded;
      _completedAt = $v.completedAt;
      _decisionId = $v.decisionId;
      _evidence = $v.evidence?.toBuilder();
      _canRecord = $v.canRecord;
      _canConfirm = $v.canConfirm;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeRemedy other) {
    _$v = other as _$DisputeRemedy;
  }

  @override
  void update(void Function(DisputeRemedyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeRemedy build() => _build();

  _$DisputeRemedy _build() {
    _$DisputeRemedy _$result;
    try {
      _$result = _$v ??
          _$DisputeRemedy._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'DisputeRemedy', 'id'),
            kind: BuiltValueNullFieldError.checkNotNull(
                kind, r'DisputeRemedy', 'kind'),
            state: BuiltValueNullFieldError.checkNotNull(
                state, r'DisputeRemedy', 'state'),
            amountCentavos: BuiltValueNullFieldError.checkNotNull(
                amountCentavos, r'DisputeRemedy', 'amountCentavos'),
            note: note,
            recorded: BuiltValueNullFieldError.checkNotNull(
                recorded, r'DisputeRemedy', 'recorded'),
            completedAt: completedAt,
            decisionId: decisionId,
            evidence: _evidence?.build(),
            canRecord: BuiltValueNullFieldError.checkNotNull(
                canRecord, r'DisputeRemedy', 'canRecord'),
            canConfirm: BuiltValueNullFieldError.checkNotNull(
                canConfirm, r'DisputeRemedy', 'canConfirm'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'evidence';
        _evidence?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DisputeRemedy', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
