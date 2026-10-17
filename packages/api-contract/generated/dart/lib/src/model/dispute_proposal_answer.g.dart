// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_proposal_answer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DisputeProposalAnswerDecisionEnum
    _$disputeProposalAnswerDecisionEnum_ACCEPT =
    const DisputeProposalAnswerDecisionEnum._('ACCEPT');
const DisputeProposalAnswerDecisionEnum
    _$disputeProposalAnswerDecisionEnum_REJECT =
    const DisputeProposalAnswerDecisionEnum._('REJECT');

DisputeProposalAnswerDecisionEnum _$disputeProposalAnswerDecisionEnumValueOf(
    String name) {
  switch (name) {
    case 'ACCEPT':
      return _$disputeProposalAnswerDecisionEnum_ACCEPT;
    case 'REJECT':
      return _$disputeProposalAnswerDecisionEnum_REJECT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeProposalAnswerDecisionEnum>
    _$disputeProposalAnswerDecisionEnumValues = BuiltSet<
        DisputeProposalAnswerDecisionEnum>(const <DisputeProposalAnswerDecisionEnum>[
  _$disputeProposalAnswerDecisionEnum_ACCEPT,
  _$disputeProposalAnswerDecisionEnum_REJECT,
]);

Serializer<DisputeProposalAnswerDecisionEnum>
    _$disputeProposalAnswerDecisionEnumSerializer =
    _$DisputeProposalAnswerDecisionEnumSerializer();

class _$DisputeProposalAnswerDecisionEnumSerializer
    implements PrimitiveSerializer<DisputeProposalAnswerDecisionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACCEPT': 'ACCEPT',
    'REJECT': 'REJECT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACCEPT': 'ACCEPT',
    'REJECT': 'REJECT',
  };

  @override
  final Iterable<Type> types = const <Type>[DisputeProposalAnswerDecisionEnum];
  @override
  final String wireName = 'DisputeProposalAnswerDecisionEnum';

  @override
  Object serialize(
          Serializers serializers, DisputeProposalAnswerDecisionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeProposalAnswerDecisionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeProposalAnswerDecisionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeProposalAnswer extends DisputeProposalAnswer {
  @override
  final DisputeProposalAnswerDecisionEnum decision;

  factory _$DisputeProposalAnswer(
          [void Function(DisputeProposalAnswerBuilder)? updates]) =>
      (DisputeProposalAnswerBuilder()..update(updates))._build();

  _$DisputeProposalAnswer._({required this.decision}) : super._();
  @override
  DisputeProposalAnswer rebuild(
          void Function(DisputeProposalAnswerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeProposalAnswerBuilder toBuilder() =>
      DisputeProposalAnswerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeProposalAnswer && decision == other.decision;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, decision.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeProposalAnswer')
          ..add('decision', decision))
        .toString();
  }
}

class DisputeProposalAnswerBuilder
    implements Builder<DisputeProposalAnswer, DisputeProposalAnswerBuilder> {
  _$DisputeProposalAnswer? _$v;

  DisputeProposalAnswerDecisionEnum? _decision;
  DisputeProposalAnswerDecisionEnum? get decision => _$this._decision;
  set decision(DisputeProposalAnswerDecisionEnum? decision) =>
      _$this._decision = decision;

  DisputeProposalAnswerBuilder() {
    DisputeProposalAnswer._defaults(this);
  }

  DisputeProposalAnswerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _decision = $v.decision;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeProposalAnswer other) {
    _$v = other as _$DisputeProposalAnswer;
  }

  @override
  void update(void Function(DisputeProposalAnswerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeProposalAnswer build() => _build();

  _$DisputeProposalAnswer _build() {
    final _$result = _$v ??
        _$DisputeProposalAnswer._(
          decision: BuiltValueNullFieldError.checkNotNull(
              decision, r'DisputeProposalAnswer', 'decision'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
