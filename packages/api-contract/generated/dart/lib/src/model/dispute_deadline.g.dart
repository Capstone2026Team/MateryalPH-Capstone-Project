// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_deadline.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DisputeDeadlineKindEnum _$disputeDeadlineKindEnum_RESPONSE =
    const DisputeDeadlineKindEnum._('RESPONSE');
const DisputeDeadlineKindEnum _$disputeDeadlineKindEnum_MUTUAL_RESOLUTION =
    const DisputeDeadlineKindEnum._('MUTUAL_RESOLUTION');
const DisputeDeadlineKindEnum _$disputeDeadlineKindEnum_CLARIFICATION =
    const DisputeDeadlineKindEnum._('CLARIFICATION');
const DisputeDeadlineKindEnum _$disputeDeadlineKindEnum_APPEAL =
    const DisputeDeadlineKindEnum._('APPEAL');

DisputeDeadlineKindEnum _$disputeDeadlineKindEnumValueOf(String name) {
  switch (name) {
    case 'RESPONSE':
      return _$disputeDeadlineKindEnum_RESPONSE;
    case 'MUTUAL_RESOLUTION':
      return _$disputeDeadlineKindEnum_MUTUAL_RESOLUTION;
    case 'CLARIFICATION':
      return _$disputeDeadlineKindEnum_CLARIFICATION;
    case 'APPEAL':
      return _$disputeDeadlineKindEnum_APPEAL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeDeadlineKindEnum> _$disputeDeadlineKindEnumValues =
    BuiltSet<DisputeDeadlineKindEnum>(const <DisputeDeadlineKindEnum>[
  _$disputeDeadlineKindEnum_RESPONSE,
  _$disputeDeadlineKindEnum_MUTUAL_RESOLUTION,
  _$disputeDeadlineKindEnum_CLARIFICATION,
  _$disputeDeadlineKindEnum_APPEAL,
]);

const DisputeDeadlineResponsiblePartyEnum
    _$disputeDeadlineResponsiblePartyEnum_BUYER =
    const DisputeDeadlineResponsiblePartyEnum._('BUYER');
const DisputeDeadlineResponsiblePartyEnum
    _$disputeDeadlineResponsiblePartyEnum_VENDOR =
    const DisputeDeadlineResponsiblePartyEnum._('VENDOR');
const DisputeDeadlineResponsiblePartyEnum
    _$disputeDeadlineResponsiblePartyEnum_BOTH =
    const DisputeDeadlineResponsiblePartyEnum._('BOTH');
const DisputeDeadlineResponsiblePartyEnum
    _$disputeDeadlineResponsiblePartyEnum_REQUESTED_PARTY =
    const DisputeDeadlineResponsiblePartyEnum._('REQUESTED_PARTY');
const DisputeDeadlineResponsiblePartyEnum
    _$disputeDeadlineResponsiblePartyEnum_EITHER =
    const DisputeDeadlineResponsiblePartyEnum._('EITHER');

DisputeDeadlineResponsiblePartyEnum
    _$disputeDeadlineResponsiblePartyEnumValueOf(String name) {
  switch (name) {
    case 'BUYER':
      return _$disputeDeadlineResponsiblePartyEnum_BUYER;
    case 'VENDOR':
      return _$disputeDeadlineResponsiblePartyEnum_VENDOR;
    case 'BOTH':
      return _$disputeDeadlineResponsiblePartyEnum_BOTH;
    case 'REQUESTED_PARTY':
      return _$disputeDeadlineResponsiblePartyEnum_REQUESTED_PARTY;
    case 'EITHER':
      return _$disputeDeadlineResponsiblePartyEnum_EITHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeDeadlineResponsiblePartyEnum>
    _$disputeDeadlineResponsiblePartyEnumValues = BuiltSet<
        DisputeDeadlineResponsiblePartyEnum>(const <DisputeDeadlineResponsiblePartyEnum>[
  _$disputeDeadlineResponsiblePartyEnum_BUYER,
  _$disputeDeadlineResponsiblePartyEnum_VENDOR,
  _$disputeDeadlineResponsiblePartyEnum_BOTH,
  _$disputeDeadlineResponsiblePartyEnum_REQUESTED_PARTY,
  _$disputeDeadlineResponsiblePartyEnum_EITHER,
]);

Serializer<DisputeDeadlineKindEnum> _$disputeDeadlineKindEnumSerializer =
    _$DisputeDeadlineKindEnumSerializer();
Serializer<DisputeDeadlineResponsiblePartyEnum>
    _$disputeDeadlineResponsiblePartyEnumSerializer =
    _$DisputeDeadlineResponsiblePartyEnumSerializer();

class _$DisputeDeadlineKindEnumSerializer
    implements PrimitiveSerializer<DisputeDeadlineKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'RESPONSE': 'RESPONSE',
    'MUTUAL_RESOLUTION': 'MUTUAL_RESOLUTION',
    'CLARIFICATION': 'CLARIFICATION',
    'APPEAL': 'APPEAL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'RESPONSE': 'RESPONSE',
    'MUTUAL_RESOLUTION': 'MUTUAL_RESOLUTION',
    'CLARIFICATION': 'CLARIFICATION',
    'APPEAL': 'APPEAL',
  };

  @override
  final Iterable<Type> types = const <Type>[DisputeDeadlineKindEnum];
  @override
  final String wireName = 'DisputeDeadlineKindEnum';

  @override
  Object serialize(Serializers serializers, DisputeDeadlineKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeDeadlineKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeDeadlineKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeDeadlineResponsiblePartyEnumSerializer
    implements PrimitiveSerializer<DisputeDeadlineResponsiblePartyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
    'BOTH': 'BOTH',
    'REQUESTED_PARTY': 'REQUESTED_PARTY',
    'EITHER': 'EITHER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
    'BOTH': 'BOTH',
    'REQUESTED_PARTY': 'REQUESTED_PARTY',
    'EITHER': 'EITHER',
  };

  @override
  final Iterable<Type> types = const <Type>[
    DisputeDeadlineResponsiblePartyEnum
  ];
  @override
  final String wireName = 'DisputeDeadlineResponsiblePartyEnum';

  @override
  Object serialize(
          Serializers serializers, DisputeDeadlineResponsiblePartyEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeDeadlineResponsiblePartyEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeDeadlineResponsiblePartyEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeDeadline extends DisputeDeadline {
  @override
  final DisputeDeadlineKindEnum kind;
  @override
  final DateTime at;
  @override
  final DisputeDeadlineResponsiblePartyEnum responsibleParty;
  @override
  final String label;

  factory _$DisputeDeadline([void Function(DisputeDeadlineBuilder)? updates]) =>
      (DisputeDeadlineBuilder()..update(updates))._build();

  _$DisputeDeadline._(
      {required this.kind,
      required this.at,
      required this.responsibleParty,
      required this.label})
      : super._();
  @override
  DisputeDeadline rebuild(void Function(DisputeDeadlineBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeDeadlineBuilder toBuilder() => DisputeDeadlineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeDeadline &&
        kind == other.kind &&
        at == other.at &&
        responsibleParty == other.responsibleParty &&
        label == other.label;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, responsibleParty.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeDeadline')
          ..add('kind', kind)
          ..add('at', at)
          ..add('responsibleParty', responsibleParty)
          ..add('label', label))
        .toString();
  }
}

class DisputeDeadlineBuilder
    implements Builder<DisputeDeadline, DisputeDeadlineBuilder> {
  _$DisputeDeadline? _$v;

  DisputeDeadlineKindEnum? _kind;
  DisputeDeadlineKindEnum? get kind => _$this._kind;
  set kind(DisputeDeadlineKindEnum? kind) => _$this._kind = kind;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  DisputeDeadlineResponsiblePartyEnum? _responsibleParty;
  DisputeDeadlineResponsiblePartyEnum? get responsibleParty =>
      _$this._responsibleParty;
  set responsibleParty(DisputeDeadlineResponsiblePartyEnum? responsibleParty) =>
      _$this._responsibleParty = responsibleParty;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  DisputeDeadlineBuilder() {
    DisputeDeadline._defaults(this);
  }

  DisputeDeadlineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _at = $v.at;
      _responsibleParty = $v.responsibleParty;
      _label = $v.label;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeDeadline other) {
    _$v = other as _$DisputeDeadline;
  }

  @override
  void update(void Function(DisputeDeadlineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeDeadline build() => _build();

  _$DisputeDeadline _build() {
    final _$result = _$v ??
        _$DisputeDeadline._(
          kind: BuiltValueNullFieldError.checkNotNull(
              kind, r'DisputeDeadline', 'kind'),
          at: BuiltValueNullFieldError.checkNotNull(
              at, r'DisputeDeadline', 'at'),
          responsibleParty: BuiltValueNullFieldError.checkNotNull(
              responsibleParty, r'DisputeDeadline', 'responsibleParty'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'DisputeDeadline', 'label'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
