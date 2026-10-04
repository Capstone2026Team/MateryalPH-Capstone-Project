// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_proposal.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DisputeProposalProposedByPartyEnum
    _$disputeProposalProposedByPartyEnum_BUYER =
    const DisputeProposalProposedByPartyEnum._('BUYER');
const DisputeProposalProposedByPartyEnum
    _$disputeProposalProposedByPartyEnum_VENDOR =
    const DisputeProposalProposedByPartyEnum._('VENDOR');

DisputeProposalProposedByPartyEnum _$disputeProposalProposedByPartyEnumValueOf(
    String name) {
  switch (name) {
    case 'BUYER':
      return _$disputeProposalProposedByPartyEnum_BUYER;
    case 'VENDOR':
      return _$disputeProposalProposedByPartyEnum_VENDOR;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeProposalProposedByPartyEnum>
    _$disputeProposalProposedByPartyEnumValues = BuiltSet<
        DisputeProposalProposedByPartyEnum>(const <DisputeProposalProposedByPartyEnum>[
  _$disputeProposalProposedByPartyEnum_BUYER,
  _$disputeProposalProposedByPartyEnum_VENDOR,
]);

const DisputeProposalRemedyEnum _$disputeProposalRemedyEnum_REPLACEMENT =
    const DisputeProposalRemedyEnum._('REPLACEMENT');
const DisputeProposalRemedyEnum _$disputeProposalRemedyEnum_FULL_REFUND =
    const DisputeProposalRemedyEnum._('FULL_REFUND');
const DisputeProposalRemedyEnum _$disputeProposalRemedyEnum_PARTIAL_REFUND =
    const DisputeProposalRemedyEnum._('PARTIAL_REFUND');
const DisputeProposalRemedyEnum _$disputeProposalRemedyEnum_NO_FURTHER_ACTION =
    const DisputeProposalRemedyEnum._('NO_FURTHER_ACTION');

DisputeProposalRemedyEnum _$disputeProposalRemedyEnumValueOf(String name) {
  switch (name) {
    case 'REPLACEMENT':
      return _$disputeProposalRemedyEnum_REPLACEMENT;
    case 'FULL_REFUND':
      return _$disputeProposalRemedyEnum_FULL_REFUND;
    case 'PARTIAL_REFUND':
      return _$disputeProposalRemedyEnum_PARTIAL_REFUND;
    case 'NO_FURTHER_ACTION':
      return _$disputeProposalRemedyEnum_NO_FURTHER_ACTION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeProposalRemedyEnum> _$disputeProposalRemedyEnumValues =
    BuiltSet<DisputeProposalRemedyEnum>(const <DisputeProposalRemedyEnum>[
  _$disputeProposalRemedyEnum_REPLACEMENT,
  _$disputeProposalRemedyEnum_FULL_REFUND,
  _$disputeProposalRemedyEnum_PARTIAL_REFUND,
  _$disputeProposalRemedyEnum_NO_FURTHER_ACTION,
]);

const DisputeProposalStateEnum _$disputeProposalStateEnum_PROPOSED =
    const DisputeProposalStateEnum._('PROPOSED');
const DisputeProposalStateEnum _$disputeProposalStateEnum_ACCEPTED =
    const DisputeProposalStateEnum._('ACCEPTED');
const DisputeProposalStateEnum _$disputeProposalStateEnum_REJECTED =
    const DisputeProposalStateEnum._('REJECTED');
const DisputeProposalStateEnum _$disputeProposalStateEnum_SUPERSEDED =
    const DisputeProposalStateEnum._('SUPERSEDED');
const DisputeProposalStateEnum _$disputeProposalStateEnum_EXPIRED =
    const DisputeProposalStateEnum._('EXPIRED');

DisputeProposalStateEnum _$disputeProposalStateEnumValueOf(String name) {
  switch (name) {
    case 'PROPOSED':
      return _$disputeProposalStateEnum_PROPOSED;
    case 'ACCEPTED':
      return _$disputeProposalStateEnum_ACCEPTED;
    case 'REJECTED':
      return _$disputeProposalStateEnum_REJECTED;
    case 'SUPERSEDED':
      return _$disputeProposalStateEnum_SUPERSEDED;
    case 'EXPIRED':
      return _$disputeProposalStateEnum_EXPIRED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeProposalStateEnum> _$disputeProposalStateEnumValues =
    BuiltSet<DisputeProposalStateEnum>(const <DisputeProposalStateEnum>[
  _$disputeProposalStateEnum_PROPOSED,
  _$disputeProposalStateEnum_ACCEPTED,
  _$disputeProposalStateEnum_REJECTED,
  _$disputeProposalStateEnum_SUPERSEDED,
  _$disputeProposalStateEnum_EXPIRED,
]);

Serializer<DisputeProposalProposedByPartyEnum>
    _$disputeProposalProposedByPartyEnumSerializer =
    _$DisputeProposalProposedByPartyEnumSerializer();
Serializer<DisputeProposalRemedyEnum> _$disputeProposalRemedyEnumSerializer =
    _$DisputeProposalRemedyEnumSerializer();
Serializer<DisputeProposalStateEnum> _$disputeProposalStateEnumSerializer =
    _$DisputeProposalStateEnumSerializer();

class _$DisputeProposalProposedByPartyEnumSerializer
    implements PrimitiveSerializer<DisputeProposalProposedByPartyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
  };

  @override
  final Iterable<Type> types = const <Type>[DisputeProposalProposedByPartyEnum];
  @override
  final String wireName = 'DisputeProposalProposedByPartyEnum';

  @override
  Object serialize(
          Serializers serializers, DisputeProposalProposedByPartyEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeProposalProposedByPartyEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeProposalProposedByPartyEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeProposalRemedyEnumSerializer
    implements PrimitiveSerializer<DisputeProposalRemedyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'REPLACEMENT': 'REPLACEMENT',
    'FULL_REFUND': 'FULL_REFUND',
    'PARTIAL_REFUND': 'PARTIAL_REFUND',
    'NO_FURTHER_ACTION': 'NO_FURTHER_ACTION',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'REPLACEMENT': 'REPLACEMENT',
    'FULL_REFUND': 'FULL_REFUND',
    'PARTIAL_REFUND': 'PARTIAL_REFUND',
    'NO_FURTHER_ACTION': 'NO_FURTHER_ACTION',
  };

  @override
  final Iterable<Type> types = const <Type>[DisputeProposalRemedyEnum];
  @override
  final String wireName = 'DisputeProposalRemedyEnum';

  @override
  Object serialize(Serializers serializers, DisputeProposalRemedyEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeProposalRemedyEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeProposalRemedyEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeProposalStateEnumSerializer
    implements PrimitiveSerializer<DisputeProposalStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PROPOSED': 'PROPOSED',
    'ACCEPTED': 'ACCEPTED',
    'REJECTED': 'REJECTED',
    'SUPERSEDED': 'SUPERSEDED',
    'EXPIRED': 'EXPIRED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PROPOSED': 'PROPOSED',
    'ACCEPTED': 'ACCEPTED',
    'REJECTED': 'REJECTED',
    'SUPERSEDED': 'SUPERSEDED',
    'EXPIRED': 'EXPIRED',
  };

  @override
  final Iterable<Type> types = const <Type>[DisputeProposalStateEnum];
  @override
  final String wireName = 'DisputeProposalStateEnum';

  @override
  Object serialize(Serializers serializers, DisputeProposalStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeProposalStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeProposalStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeProposal extends DisputeProposal {
  @override
  final String id;
  @override
  final DisputeProposalProposedByPartyEnum proposedByParty;
  @override
  final DisputeProposalRemedyEnum remedy;
  @override
  final int? amountCentavos;
  @override
  final String terms;
  @override
  final DisputeProposalStateEnum state;
  @override
  final DateTime? proposedAt;
  @override
  final DateTime? answeredAt;
  @override
  final bool canAnswer;

  factory _$DisputeProposal([void Function(DisputeProposalBuilder)? updates]) =>
      (DisputeProposalBuilder()..update(updates))._build();

  _$DisputeProposal._(
      {required this.id,
      required this.proposedByParty,
      required this.remedy,
      this.amountCentavos,
      required this.terms,
      required this.state,
      this.proposedAt,
      this.answeredAt,
      required this.canAnswer})
      : super._();
  @override
  DisputeProposal rebuild(void Function(DisputeProposalBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeProposalBuilder toBuilder() => DisputeProposalBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeProposal &&
        id == other.id &&
        proposedByParty == other.proposedByParty &&
        remedy == other.remedy &&
        amountCentavos == other.amountCentavos &&
        terms == other.terms &&
        state == other.state &&
        proposedAt == other.proposedAt &&
        answeredAt == other.answeredAt &&
        canAnswer == other.canAnswer;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, proposedByParty.hashCode);
    _$hash = $jc(_$hash, remedy.hashCode);
    _$hash = $jc(_$hash, amountCentavos.hashCode);
    _$hash = $jc(_$hash, terms.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, proposedAt.hashCode);
    _$hash = $jc(_$hash, answeredAt.hashCode);
    _$hash = $jc(_$hash, canAnswer.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeProposal')
          ..add('id', id)
          ..add('proposedByParty', proposedByParty)
          ..add('remedy', remedy)
          ..add('amountCentavos', amountCentavos)
          ..add('terms', terms)
          ..add('state', state)
          ..add('proposedAt', proposedAt)
          ..add('answeredAt', answeredAt)
          ..add('canAnswer', canAnswer))
        .toString();
  }
}

class DisputeProposalBuilder
    implements Builder<DisputeProposal, DisputeProposalBuilder> {
  _$DisputeProposal? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DisputeProposalProposedByPartyEnum? _proposedByParty;
  DisputeProposalProposedByPartyEnum? get proposedByParty =>
      _$this._proposedByParty;
  set proposedByParty(DisputeProposalProposedByPartyEnum? proposedByParty) =>
      _$this._proposedByParty = proposedByParty;

  DisputeProposalRemedyEnum? _remedy;
  DisputeProposalRemedyEnum? get remedy => _$this._remedy;
  set remedy(DisputeProposalRemedyEnum? remedy) => _$this._remedy = remedy;

  int? _amountCentavos;
  int? get amountCentavos => _$this._amountCentavos;
  set amountCentavos(int? amountCentavos) =>
      _$this._amountCentavos = amountCentavos;

  String? _terms;
  String? get terms => _$this._terms;
  set terms(String? terms) => _$this._terms = terms;

  DisputeProposalStateEnum? _state;
  DisputeProposalStateEnum? get state => _$this._state;
  set state(DisputeProposalStateEnum? state) => _$this._state = state;

  DateTime? _proposedAt;
  DateTime? get proposedAt => _$this._proposedAt;
  set proposedAt(DateTime? proposedAt) => _$this._proposedAt = proposedAt;

  DateTime? _answeredAt;
  DateTime? get answeredAt => _$this._answeredAt;
  set answeredAt(DateTime? answeredAt) => _$this._answeredAt = answeredAt;

  bool? _canAnswer;
  bool? get canAnswer => _$this._canAnswer;
  set canAnswer(bool? canAnswer) => _$this._canAnswer = canAnswer;

  DisputeProposalBuilder() {
    DisputeProposal._defaults(this);
  }

  DisputeProposalBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _proposedByParty = $v.proposedByParty;
      _remedy = $v.remedy;
      _amountCentavos = $v.amountCentavos;
      _terms = $v.terms;
      _state = $v.state;
      _proposedAt = $v.proposedAt;
      _answeredAt = $v.answeredAt;
      _canAnswer = $v.canAnswer;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeProposal other) {
    _$v = other as _$DisputeProposal;
  }

  @override
  void update(void Function(DisputeProposalBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeProposal build() => _build();

  _$DisputeProposal _build() {
    final _$result = _$v ??
        _$DisputeProposal._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'DisputeProposal', 'id'),
          proposedByParty: BuiltValueNullFieldError.checkNotNull(
              proposedByParty, r'DisputeProposal', 'proposedByParty'),
          remedy: BuiltValueNullFieldError.checkNotNull(
              remedy, r'DisputeProposal', 'remedy'),
          amountCentavos: amountCentavos,
          terms: BuiltValueNullFieldError.checkNotNull(
              terms, r'DisputeProposal', 'terms'),
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'DisputeProposal', 'state'),
          proposedAt: proposedAt,
          answeredAt: answeredAt,
          canAnswer: BuiltValueNullFieldError.checkNotNull(
              canAnswer, r'DisputeProposal', 'canAnswer'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
