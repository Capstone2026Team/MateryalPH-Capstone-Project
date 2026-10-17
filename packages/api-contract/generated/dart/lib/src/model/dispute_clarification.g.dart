// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_clarification.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DisputeClarificationRequestedPartyEnum
    _$disputeClarificationRequestedPartyEnum_BUYER =
    const DisputeClarificationRequestedPartyEnum._('BUYER');
const DisputeClarificationRequestedPartyEnum
    _$disputeClarificationRequestedPartyEnum_VENDOR =
    const DisputeClarificationRequestedPartyEnum._('VENDOR');

DisputeClarificationRequestedPartyEnum
    _$disputeClarificationRequestedPartyEnumValueOf(String name) {
  switch (name) {
    case 'BUYER':
      return _$disputeClarificationRequestedPartyEnum_BUYER;
    case 'VENDOR':
      return _$disputeClarificationRequestedPartyEnum_VENDOR;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeClarificationRequestedPartyEnum>
    _$disputeClarificationRequestedPartyEnumValues = BuiltSet<
        DisputeClarificationRequestedPartyEnum>(const <DisputeClarificationRequestedPartyEnum>[
  _$disputeClarificationRequestedPartyEnum_BUYER,
  _$disputeClarificationRequestedPartyEnum_VENDOR,
]);

const DisputeClarificationStateEnum _$disputeClarificationStateEnum_OPEN =
    const DisputeClarificationStateEnum._('OPEN');
const DisputeClarificationStateEnum _$disputeClarificationStateEnum_ANSWERED =
    const DisputeClarificationStateEnum._('ANSWERED');
const DisputeClarificationStateEnum _$disputeClarificationStateEnum_EXPIRED =
    const DisputeClarificationStateEnum._('EXPIRED');

DisputeClarificationStateEnum _$disputeClarificationStateEnumValueOf(
    String name) {
  switch (name) {
    case 'OPEN':
      return _$disputeClarificationStateEnum_OPEN;
    case 'ANSWERED':
      return _$disputeClarificationStateEnum_ANSWERED;
    case 'EXPIRED':
      return _$disputeClarificationStateEnum_EXPIRED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeClarificationStateEnum>
    _$disputeClarificationStateEnumValues = BuiltSet<
        DisputeClarificationStateEnum>(const <DisputeClarificationStateEnum>[
  _$disputeClarificationStateEnum_OPEN,
  _$disputeClarificationStateEnum_ANSWERED,
  _$disputeClarificationStateEnum_EXPIRED,
]);

Serializer<DisputeClarificationRequestedPartyEnum>
    _$disputeClarificationRequestedPartyEnumSerializer =
    _$DisputeClarificationRequestedPartyEnumSerializer();
Serializer<DisputeClarificationStateEnum>
    _$disputeClarificationStateEnumSerializer =
    _$DisputeClarificationStateEnumSerializer();

class _$DisputeClarificationRequestedPartyEnumSerializer
    implements PrimitiveSerializer<DisputeClarificationRequestedPartyEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
  };

  @override
  final Iterable<Type> types = const <Type>[
    DisputeClarificationRequestedPartyEnum
  ];
  @override
  final String wireName = 'DisputeClarificationRequestedPartyEnum';

  @override
  Object serialize(Serializers serializers,
          DisputeClarificationRequestedPartyEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeClarificationRequestedPartyEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeClarificationRequestedPartyEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeClarificationStateEnumSerializer
    implements PrimitiveSerializer<DisputeClarificationStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OPEN': 'OPEN',
    'ANSWERED': 'ANSWERED',
    'EXPIRED': 'EXPIRED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OPEN': 'OPEN',
    'ANSWERED': 'ANSWERED',
    'EXPIRED': 'EXPIRED',
  };

  @override
  final Iterable<Type> types = const <Type>[DisputeClarificationStateEnum];
  @override
  final String wireName = 'DisputeClarificationStateEnum';

  @override
  Object serialize(
          Serializers serializers, DisputeClarificationStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeClarificationStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeClarificationStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeClarification extends DisputeClarification {
  @override
  final String id;
  @override
  final DisputeClarificationRequestedPartyEnum requestedParty;
  @override
  final String question;
  @override
  final DateTime? dueAt;
  @override
  final DisputeClarificationStateEnum state;
  @override
  final String? response;
  @override
  final DateTime? respondedAt;
  @override
  final bool canAnswer;

  factory _$DisputeClarification(
          [void Function(DisputeClarificationBuilder)? updates]) =>
      (DisputeClarificationBuilder()..update(updates))._build();

  _$DisputeClarification._(
      {required this.id,
      required this.requestedParty,
      required this.question,
      this.dueAt,
      required this.state,
      this.response,
      this.respondedAt,
      required this.canAnswer})
      : super._();
  @override
  DisputeClarification rebuild(
          void Function(DisputeClarificationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeClarificationBuilder toBuilder() =>
      DisputeClarificationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeClarification &&
        id == other.id &&
        requestedParty == other.requestedParty &&
        question == other.question &&
        dueAt == other.dueAt &&
        state == other.state &&
        response == other.response &&
        respondedAt == other.respondedAt &&
        canAnswer == other.canAnswer;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, requestedParty.hashCode);
    _$hash = $jc(_$hash, question.hashCode);
    _$hash = $jc(_$hash, dueAt.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, response.hashCode);
    _$hash = $jc(_$hash, respondedAt.hashCode);
    _$hash = $jc(_$hash, canAnswer.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeClarification')
          ..add('id', id)
          ..add('requestedParty', requestedParty)
          ..add('question', question)
          ..add('dueAt', dueAt)
          ..add('state', state)
          ..add('response', response)
          ..add('respondedAt', respondedAt)
          ..add('canAnswer', canAnswer))
        .toString();
  }
}

class DisputeClarificationBuilder
    implements Builder<DisputeClarification, DisputeClarificationBuilder> {
  _$DisputeClarification? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DisputeClarificationRequestedPartyEnum? _requestedParty;
  DisputeClarificationRequestedPartyEnum? get requestedParty =>
      _$this._requestedParty;
  set requestedParty(DisputeClarificationRequestedPartyEnum? requestedParty) =>
      _$this._requestedParty = requestedParty;

  String? _question;
  String? get question => _$this._question;
  set question(String? question) => _$this._question = question;

  DateTime? _dueAt;
  DateTime? get dueAt => _$this._dueAt;
  set dueAt(DateTime? dueAt) => _$this._dueAt = dueAt;

  DisputeClarificationStateEnum? _state;
  DisputeClarificationStateEnum? get state => _$this._state;
  set state(DisputeClarificationStateEnum? state) => _$this._state = state;

  String? _response;
  String? get response => _$this._response;
  set response(String? response) => _$this._response = response;

  DateTime? _respondedAt;
  DateTime? get respondedAt => _$this._respondedAt;
  set respondedAt(DateTime? respondedAt) => _$this._respondedAt = respondedAt;

  bool? _canAnswer;
  bool? get canAnswer => _$this._canAnswer;
  set canAnswer(bool? canAnswer) => _$this._canAnswer = canAnswer;

  DisputeClarificationBuilder() {
    DisputeClarification._defaults(this);
  }

  DisputeClarificationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _requestedParty = $v.requestedParty;
      _question = $v.question;
      _dueAt = $v.dueAt;
      _state = $v.state;
      _response = $v.response;
      _respondedAt = $v.respondedAt;
      _canAnswer = $v.canAnswer;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeClarification other) {
    _$v = other as _$DisputeClarification;
  }

  @override
  void update(void Function(DisputeClarificationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeClarification build() => _build();

  _$DisputeClarification _build() {
    final _$result = _$v ??
        _$DisputeClarification._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'DisputeClarification', 'id'),
          requestedParty: BuiltValueNullFieldError.checkNotNull(
              requestedParty, r'DisputeClarification', 'requestedParty'),
          question: BuiltValueNullFieldError.checkNotNull(
              question, r'DisputeClarification', 'question'),
          dueAt: dueAt,
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'DisputeClarification', 'state'),
          response: response,
          respondedAt: respondedAt,
          canAnswer: BuiltValueNullFieldError.checkNotNull(
              canAnswer, r'DisputeClarification', 'canAnswer'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
