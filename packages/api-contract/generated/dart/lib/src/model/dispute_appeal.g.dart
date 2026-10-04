// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_appeal.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DisputeAppealAppellantPartyEnum _$disputeAppealAppellantPartyEnum_BUYER =
    const DisputeAppealAppellantPartyEnum._('BUYER');
const DisputeAppealAppellantPartyEnum _$disputeAppealAppellantPartyEnum_VENDOR =
    const DisputeAppealAppellantPartyEnum._('VENDOR');

DisputeAppealAppellantPartyEnum _$disputeAppealAppellantPartyEnumValueOf(
    String name) {
  switch (name) {
    case 'BUYER':
      return _$disputeAppealAppellantPartyEnum_BUYER;
    case 'VENDOR':
      return _$disputeAppealAppellantPartyEnum_VENDOR;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeAppealAppellantPartyEnum>
    _$disputeAppealAppellantPartyEnumValues = BuiltSet<
        DisputeAppealAppellantPartyEnum>(const <DisputeAppealAppellantPartyEnum>[
  _$disputeAppealAppellantPartyEnum_BUYER,
  _$disputeAppealAppellantPartyEnum_VENDOR,
]);

const DisputeAppealGroundsEnum _$disputeAppealGroundsEnum_NEW_EVIDENCE =
    const DisputeAppealGroundsEnum._('NEW_EVIDENCE');
const DisputeAppealGroundsEnum
    _$disputeAppealGroundsEnum_MATERIAL_PROCESS_ERROR =
    const DisputeAppealGroundsEnum._('MATERIAL_PROCESS_ERROR');

DisputeAppealGroundsEnum _$disputeAppealGroundsEnumValueOf(String name) {
  switch (name) {
    case 'NEW_EVIDENCE':
      return _$disputeAppealGroundsEnum_NEW_EVIDENCE;
    case 'MATERIAL_PROCESS_ERROR':
      return _$disputeAppealGroundsEnum_MATERIAL_PROCESS_ERROR;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeAppealGroundsEnum> _$disputeAppealGroundsEnumValues =
    BuiltSet<DisputeAppealGroundsEnum>(const <DisputeAppealGroundsEnum>[
  _$disputeAppealGroundsEnum_NEW_EVIDENCE,
  _$disputeAppealGroundsEnum_MATERIAL_PROCESS_ERROR,
]);

const DisputeAppealStateEnum _$disputeAppealStateEnum_OPEN =
    const DisputeAppealStateEnum._('OPEN');
const DisputeAppealStateEnum _$disputeAppealStateEnum_DECIDED =
    const DisputeAppealStateEnum._('DECIDED');

DisputeAppealStateEnum _$disputeAppealStateEnumValueOf(String name) {
  switch (name) {
    case 'OPEN':
      return _$disputeAppealStateEnum_OPEN;
    case 'DECIDED':
      return _$disputeAppealStateEnum_DECIDED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeAppealStateEnum> _$disputeAppealStateEnumValues =
    BuiltSet<DisputeAppealStateEnum>(const <DisputeAppealStateEnum>[
  _$disputeAppealStateEnum_OPEN,
  _$disputeAppealStateEnum_DECIDED,
]);

Serializer<DisputeAppealAppellantPartyEnum>
    _$disputeAppealAppellantPartyEnumSerializer =
    _$DisputeAppealAppellantPartyEnumSerializer();
Serializer<DisputeAppealGroundsEnum> _$disputeAppealGroundsEnumSerializer =
    _$DisputeAppealGroundsEnumSerializer();
Serializer<DisputeAppealStateEnum> _$disputeAppealStateEnumSerializer =
    _$DisputeAppealStateEnumSerializer();

class _$DisputeAppealAppellantPartyEnumSerializer
    implements PrimitiveSerializer<DisputeAppealAppellantPartyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
  };

  @override
  final Iterable<Type> types = const <Type>[DisputeAppealAppellantPartyEnum];
  @override
  final String wireName = 'DisputeAppealAppellantPartyEnum';

  @override
  Object serialize(
          Serializers serializers, DisputeAppealAppellantPartyEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeAppealAppellantPartyEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeAppealAppellantPartyEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeAppealGroundsEnumSerializer
    implements PrimitiveSerializer<DisputeAppealGroundsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NEW_EVIDENCE': 'NEW_EVIDENCE',
    'MATERIAL_PROCESS_ERROR': 'MATERIAL_PROCESS_ERROR',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NEW_EVIDENCE': 'NEW_EVIDENCE',
    'MATERIAL_PROCESS_ERROR': 'MATERIAL_PROCESS_ERROR',
  };

  @override
  final Iterable<Type> types = const <Type>[DisputeAppealGroundsEnum];
  @override
  final String wireName = 'DisputeAppealGroundsEnum';

  @override
  Object serialize(Serializers serializers, DisputeAppealGroundsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeAppealGroundsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeAppealGroundsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeAppealStateEnumSerializer
    implements PrimitiveSerializer<DisputeAppealStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OPEN': 'OPEN',
    'DECIDED': 'DECIDED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OPEN': 'OPEN',
    'DECIDED': 'DECIDED',
  };

  @override
  final Iterable<Type> types = const <Type>[DisputeAppealStateEnum];
  @override
  final String wireName = 'DisputeAppealStateEnum';

  @override
  Object serialize(Serializers serializers, DisputeAppealStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeAppealStateEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeAppealStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeAppeal extends DisputeAppeal {
  @override
  final String id;
  @override
  final DisputeAppealAppellantPartyEnum appellantParty;
  @override
  final DisputeAppealGroundsEnum grounds;
  @override
  final String statement;
  @override
  final DisputeAppealStateEnum state;
  @override
  final DateTime? filedAt;
  @override
  final DateTime? decidedAt;
  @override
  final String appealedDecisionId;
  @override
  final String? resultDecisionId;

  factory _$DisputeAppeal([void Function(DisputeAppealBuilder)? updates]) =>
      (DisputeAppealBuilder()..update(updates))._build();

  _$DisputeAppeal._(
      {required this.id,
      required this.appellantParty,
      required this.grounds,
      required this.statement,
      required this.state,
      this.filedAt,
      this.decidedAt,
      required this.appealedDecisionId,
      this.resultDecisionId})
      : super._();
  @override
  DisputeAppeal rebuild(void Function(DisputeAppealBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeAppealBuilder toBuilder() => DisputeAppealBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeAppeal &&
        id == other.id &&
        appellantParty == other.appellantParty &&
        grounds == other.grounds &&
        statement == other.statement &&
        state == other.state &&
        filedAt == other.filedAt &&
        decidedAt == other.decidedAt &&
        appealedDecisionId == other.appealedDecisionId &&
        resultDecisionId == other.resultDecisionId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, appellantParty.hashCode);
    _$hash = $jc(_$hash, grounds.hashCode);
    _$hash = $jc(_$hash, statement.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, filedAt.hashCode);
    _$hash = $jc(_$hash, decidedAt.hashCode);
    _$hash = $jc(_$hash, appealedDecisionId.hashCode);
    _$hash = $jc(_$hash, resultDecisionId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeAppeal')
          ..add('id', id)
          ..add('appellantParty', appellantParty)
          ..add('grounds', grounds)
          ..add('statement', statement)
          ..add('state', state)
          ..add('filedAt', filedAt)
          ..add('decidedAt', decidedAt)
          ..add('appealedDecisionId', appealedDecisionId)
          ..add('resultDecisionId', resultDecisionId))
        .toString();
  }
}

class DisputeAppealBuilder
    implements Builder<DisputeAppeal, DisputeAppealBuilder> {
  _$DisputeAppeal? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DisputeAppealAppellantPartyEnum? _appellantParty;
  DisputeAppealAppellantPartyEnum? get appellantParty => _$this._appellantParty;
  set appellantParty(DisputeAppealAppellantPartyEnum? appellantParty) =>
      _$this._appellantParty = appellantParty;

  DisputeAppealGroundsEnum? _grounds;
  DisputeAppealGroundsEnum? get grounds => _$this._grounds;
  set grounds(DisputeAppealGroundsEnum? grounds) => _$this._grounds = grounds;

  String? _statement;
  String? get statement => _$this._statement;
  set statement(String? statement) => _$this._statement = statement;

  DisputeAppealStateEnum? _state;
  DisputeAppealStateEnum? get state => _$this._state;
  set state(DisputeAppealStateEnum? state) => _$this._state = state;

  DateTime? _filedAt;
  DateTime? get filedAt => _$this._filedAt;
  set filedAt(DateTime? filedAt) => _$this._filedAt = filedAt;

  DateTime? _decidedAt;
  DateTime? get decidedAt => _$this._decidedAt;
  set decidedAt(DateTime? decidedAt) => _$this._decidedAt = decidedAt;

  String? _appealedDecisionId;
  String? get appealedDecisionId => _$this._appealedDecisionId;
  set appealedDecisionId(String? appealedDecisionId) =>
      _$this._appealedDecisionId = appealedDecisionId;

  String? _resultDecisionId;
  String? get resultDecisionId => _$this._resultDecisionId;
  set resultDecisionId(String? resultDecisionId) =>
      _$this._resultDecisionId = resultDecisionId;

  DisputeAppealBuilder() {
    DisputeAppeal._defaults(this);
  }

  DisputeAppealBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _appellantParty = $v.appellantParty;
      _grounds = $v.grounds;
      _statement = $v.statement;
      _state = $v.state;
      _filedAt = $v.filedAt;
      _decidedAt = $v.decidedAt;
      _appealedDecisionId = $v.appealedDecisionId;
      _resultDecisionId = $v.resultDecisionId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeAppeal other) {
    _$v = other as _$DisputeAppeal;
  }

  @override
  void update(void Function(DisputeAppealBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeAppeal build() => _build();

  _$DisputeAppeal _build() {
    final _$result = _$v ??
        _$DisputeAppeal._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'DisputeAppeal', 'id'),
          appellantParty: BuiltValueNullFieldError.checkNotNull(
              appellantParty, r'DisputeAppeal', 'appellantParty'),
          grounds: BuiltValueNullFieldError.checkNotNull(
              grounds, r'DisputeAppeal', 'grounds'),
          statement: BuiltValueNullFieldError.checkNotNull(
              statement, r'DisputeAppeal', 'statement'),
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'DisputeAppeal', 'state'),
          filedAt: filedAt,
          decidedAt: decidedAt,
          appealedDecisionId: BuiltValueNullFieldError.checkNotNull(
              appealedDecisionId, r'DisputeAppeal', 'appealedDecisionId'),
          resultDecisionId: resultDecisionId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
