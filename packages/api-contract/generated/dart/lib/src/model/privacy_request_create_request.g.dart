// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_request_create_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PrivacyRequestCreateRequestRequestTypeEnum
    _$privacyRequestCreateRequestRequestTypeEnum_ACCESS =
    const PrivacyRequestCreateRequestRequestTypeEnum._('ACCESS');
const PrivacyRequestCreateRequestRequestTypeEnum
    _$privacyRequestCreateRequestRequestTypeEnum_CORRECTION =
    const PrivacyRequestCreateRequestRequestTypeEnum._('CORRECTION');
const PrivacyRequestCreateRequestRequestTypeEnum
    _$privacyRequestCreateRequestRequestTypeEnum_OBJECTION =
    const PrivacyRequestCreateRequestRequestTypeEnum._('OBJECTION');
const PrivacyRequestCreateRequestRequestTypeEnum
    _$privacyRequestCreateRequestRequestTypeEnum_DELETION =
    const PrivacyRequestCreateRequestRequestTypeEnum._('DELETION');
const PrivacyRequestCreateRequestRequestTypeEnum
    _$privacyRequestCreateRequestRequestTypeEnum_RESTRICTION =
    const PrivacyRequestCreateRequestRequestTypeEnum._('RESTRICTION');
const PrivacyRequestCreateRequestRequestTypeEnum
    _$privacyRequestCreateRequestRequestTypeEnum_PORTABILITY =
    const PrivacyRequestCreateRequestRequestTypeEnum._('PORTABILITY');
const PrivacyRequestCreateRequestRequestTypeEnum
    _$privacyRequestCreateRequestRequestTypeEnum_OTHER =
    const PrivacyRequestCreateRequestRequestTypeEnum._('OTHER');

PrivacyRequestCreateRequestRequestTypeEnum
    _$privacyRequestCreateRequestRequestTypeEnumValueOf(String name) {
  switch (name) {
    case 'ACCESS':
      return _$privacyRequestCreateRequestRequestTypeEnum_ACCESS;
    case 'CORRECTION':
      return _$privacyRequestCreateRequestRequestTypeEnum_CORRECTION;
    case 'OBJECTION':
      return _$privacyRequestCreateRequestRequestTypeEnum_OBJECTION;
    case 'DELETION':
      return _$privacyRequestCreateRequestRequestTypeEnum_DELETION;
    case 'RESTRICTION':
      return _$privacyRequestCreateRequestRequestTypeEnum_RESTRICTION;
    case 'PORTABILITY':
      return _$privacyRequestCreateRequestRequestTypeEnum_PORTABILITY;
    case 'OTHER':
      return _$privacyRequestCreateRequestRequestTypeEnum_OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PrivacyRequestCreateRequestRequestTypeEnum>
    _$privacyRequestCreateRequestRequestTypeEnumValues = BuiltSet<
        PrivacyRequestCreateRequestRequestTypeEnum>(const <PrivacyRequestCreateRequestRequestTypeEnum>[
  _$privacyRequestCreateRequestRequestTypeEnum_ACCESS,
  _$privacyRequestCreateRequestRequestTypeEnum_CORRECTION,
  _$privacyRequestCreateRequestRequestTypeEnum_OBJECTION,
  _$privacyRequestCreateRequestRequestTypeEnum_DELETION,
  _$privacyRequestCreateRequestRequestTypeEnum_RESTRICTION,
  _$privacyRequestCreateRequestRequestTypeEnum_PORTABILITY,
  _$privacyRequestCreateRequestRequestTypeEnum_OTHER,
]);

const PrivacyRequestCreateRequestIntakeChannelEnum
    _$privacyRequestCreateRequestIntakeChannelEnum_DPO_EMAIL =
    const PrivacyRequestCreateRequestIntakeChannelEnum._('DPO_EMAIL');
const PrivacyRequestCreateRequestIntakeChannelEnum
    _$privacyRequestCreateRequestIntakeChannelEnum_SUPPORT_CASE =
    const PrivacyRequestCreateRequestIntakeChannelEnum._('SUPPORT_CASE');
const PrivacyRequestCreateRequestIntakeChannelEnum
    _$privacyRequestCreateRequestIntakeChannelEnum_WRITTEN_LETTER =
    const PrivacyRequestCreateRequestIntakeChannelEnum._('WRITTEN_LETTER');
const PrivacyRequestCreateRequestIntakeChannelEnum
    _$privacyRequestCreateRequestIntakeChannelEnum_IN_APP =
    const PrivacyRequestCreateRequestIntakeChannelEnum._('IN_APP');

PrivacyRequestCreateRequestIntakeChannelEnum
    _$privacyRequestCreateRequestIntakeChannelEnumValueOf(String name) {
  switch (name) {
    case 'DPO_EMAIL':
      return _$privacyRequestCreateRequestIntakeChannelEnum_DPO_EMAIL;
    case 'SUPPORT_CASE':
      return _$privacyRequestCreateRequestIntakeChannelEnum_SUPPORT_CASE;
    case 'WRITTEN_LETTER':
      return _$privacyRequestCreateRequestIntakeChannelEnum_WRITTEN_LETTER;
    case 'IN_APP':
      return _$privacyRequestCreateRequestIntakeChannelEnum_IN_APP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PrivacyRequestCreateRequestIntakeChannelEnum>
    _$privacyRequestCreateRequestIntakeChannelEnumValues = BuiltSet<
        PrivacyRequestCreateRequestIntakeChannelEnum>(const <PrivacyRequestCreateRequestIntakeChannelEnum>[
  _$privacyRequestCreateRequestIntakeChannelEnum_DPO_EMAIL,
  _$privacyRequestCreateRequestIntakeChannelEnum_SUPPORT_CASE,
  _$privacyRequestCreateRequestIntakeChannelEnum_WRITTEN_LETTER,
  _$privacyRequestCreateRequestIntakeChannelEnum_IN_APP,
]);

Serializer<PrivacyRequestCreateRequestRequestTypeEnum>
    _$privacyRequestCreateRequestRequestTypeEnumSerializer =
    _$PrivacyRequestCreateRequestRequestTypeEnumSerializer();
Serializer<PrivacyRequestCreateRequestIntakeChannelEnum>
    _$privacyRequestCreateRequestIntakeChannelEnumSerializer =
    _$PrivacyRequestCreateRequestIntakeChannelEnumSerializer();

class _$PrivacyRequestCreateRequestRequestTypeEnumSerializer
    implements PrimitiveSerializer<PrivacyRequestCreateRequestRequestTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ACCESS': 'ACCESS',
    'CORRECTION': 'CORRECTION',
    'OBJECTION': 'OBJECTION',
    'DELETION': 'DELETION',
    'RESTRICTION': 'RESTRICTION',
    'PORTABILITY': 'PORTABILITY',
    'OTHER': 'OTHER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ACCESS': 'ACCESS',
    'CORRECTION': 'CORRECTION',
    'OBJECTION': 'OBJECTION',
    'DELETION': 'DELETION',
    'RESTRICTION': 'RESTRICTION',
    'PORTABILITY': 'PORTABILITY',
    'OTHER': 'OTHER',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PrivacyRequestCreateRequestRequestTypeEnum
  ];
  @override
  final String wireName = 'PrivacyRequestCreateRequestRequestTypeEnum';

  @override
  Object serialize(Serializers serializers,
          PrivacyRequestCreateRequestRequestTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PrivacyRequestCreateRequestRequestTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PrivacyRequestCreateRequestRequestTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PrivacyRequestCreateRequestIntakeChannelEnumSerializer
    implements
        PrimitiveSerializer<PrivacyRequestCreateRequestIntakeChannelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DPO_EMAIL': 'DPO_EMAIL',
    'SUPPORT_CASE': 'SUPPORT_CASE',
    'WRITTEN_LETTER': 'WRITTEN_LETTER',
    'IN_APP': 'IN_APP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DPO_EMAIL': 'DPO_EMAIL',
    'SUPPORT_CASE': 'SUPPORT_CASE',
    'WRITTEN_LETTER': 'WRITTEN_LETTER',
    'IN_APP': 'IN_APP',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PrivacyRequestCreateRequestIntakeChannelEnum
  ];
  @override
  final String wireName = 'PrivacyRequestCreateRequestIntakeChannelEnum';

  @override
  Object serialize(Serializers serializers,
          PrivacyRequestCreateRequestIntakeChannelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PrivacyRequestCreateRequestIntakeChannelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PrivacyRequestCreateRequestIntakeChannelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PrivacyRequestCreateRequest extends PrivacyRequestCreateRequest {
  @override
  final String subjectEmail;
  @override
  final PrivacyRequestCreateRequestRequestTypeEnum requestType;
  @override
  final PrivacyRequestCreateRequestIntakeChannelEnum intakeChannel;
  @override
  final Date receivedOn;
  @override
  final String scope;
  @override
  final String note;

  factory _$PrivacyRequestCreateRequest(
          [void Function(PrivacyRequestCreateRequestBuilder)? updates]) =>
      (PrivacyRequestCreateRequestBuilder()..update(updates))._build();

  _$PrivacyRequestCreateRequest._(
      {required this.subjectEmail,
      required this.requestType,
      required this.intakeChannel,
      required this.receivedOn,
      required this.scope,
      required this.note})
      : super._();
  @override
  PrivacyRequestCreateRequest rebuild(
          void Function(PrivacyRequestCreateRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PrivacyRequestCreateRequestBuilder toBuilder() =>
      PrivacyRequestCreateRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PrivacyRequestCreateRequest &&
        subjectEmail == other.subjectEmail &&
        requestType == other.requestType &&
        intakeChannel == other.intakeChannel &&
        receivedOn == other.receivedOn &&
        scope == other.scope &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, subjectEmail.hashCode);
    _$hash = $jc(_$hash, requestType.hashCode);
    _$hash = $jc(_$hash, intakeChannel.hashCode);
    _$hash = $jc(_$hash, receivedOn.hashCode);
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PrivacyRequestCreateRequest')
          ..add('subjectEmail', subjectEmail)
          ..add('requestType', requestType)
          ..add('intakeChannel', intakeChannel)
          ..add('receivedOn', receivedOn)
          ..add('scope', scope)
          ..add('note', note))
        .toString();
  }
}

class PrivacyRequestCreateRequestBuilder
    implements
        Builder<PrivacyRequestCreateRequest,
            PrivacyRequestCreateRequestBuilder> {
  _$PrivacyRequestCreateRequest? _$v;

  String? _subjectEmail;
  String? get subjectEmail => _$this._subjectEmail;
  set subjectEmail(String? subjectEmail) => _$this._subjectEmail = subjectEmail;

  PrivacyRequestCreateRequestRequestTypeEnum? _requestType;
  PrivacyRequestCreateRequestRequestTypeEnum? get requestType =>
      _$this._requestType;
  set requestType(PrivacyRequestCreateRequestRequestTypeEnum? requestType) =>
      _$this._requestType = requestType;

  PrivacyRequestCreateRequestIntakeChannelEnum? _intakeChannel;
  PrivacyRequestCreateRequestIntakeChannelEnum? get intakeChannel =>
      _$this._intakeChannel;
  set intakeChannel(
          PrivacyRequestCreateRequestIntakeChannelEnum? intakeChannel) =>
      _$this._intakeChannel = intakeChannel;

  Date? _receivedOn;
  Date? get receivedOn => _$this._receivedOn;
  set receivedOn(Date? receivedOn) => _$this._receivedOn = receivedOn;

  String? _scope;
  String? get scope => _$this._scope;
  set scope(String? scope) => _$this._scope = scope;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  PrivacyRequestCreateRequestBuilder() {
    PrivacyRequestCreateRequest._defaults(this);
  }

  PrivacyRequestCreateRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _subjectEmail = $v.subjectEmail;
      _requestType = $v.requestType;
      _intakeChannel = $v.intakeChannel;
      _receivedOn = $v.receivedOn;
      _scope = $v.scope;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PrivacyRequestCreateRequest other) {
    _$v = other as _$PrivacyRequestCreateRequest;
  }

  @override
  void update(void Function(PrivacyRequestCreateRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PrivacyRequestCreateRequest build() => _build();

  _$PrivacyRequestCreateRequest _build() {
    final _$result = _$v ??
        _$PrivacyRequestCreateRequest._(
          subjectEmail: BuiltValueNullFieldError.checkNotNull(
              subjectEmail, r'PrivacyRequestCreateRequest', 'subjectEmail'),
          requestType: BuiltValueNullFieldError.checkNotNull(
              requestType, r'PrivacyRequestCreateRequest', 'requestType'),
          intakeChannel: BuiltValueNullFieldError.checkNotNull(
              intakeChannel, r'PrivacyRequestCreateRequest', 'intakeChannel'),
          receivedOn: BuiltValueNullFieldError.checkNotNull(
              receivedOn, r'PrivacyRequestCreateRequest', 'receivedOn'),
          scope: BuiltValueNullFieldError.checkNotNull(
              scope, r'PrivacyRequestCreateRequest', 'scope'),
          note: BuiltValueNullFieldError.checkNotNull(
              note, r'PrivacyRequestCreateRequest', 'note'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
