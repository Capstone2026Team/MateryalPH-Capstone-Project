// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_request_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PrivacyRequestSummaryRequestTypeEnum
    _$privacyRequestSummaryRequestTypeEnum_ACCESS =
    const PrivacyRequestSummaryRequestTypeEnum._('ACCESS');
const PrivacyRequestSummaryRequestTypeEnum
    _$privacyRequestSummaryRequestTypeEnum_CORRECTION =
    const PrivacyRequestSummaryRequestTypeEnum._('CORRECTION');
const PrivacyRequestSummaryRequestTypeEnum
    _$privacyRequestSummaryRequestTypeEnum_OBJECTION =
    const PrivacyRequestSummaryRequestTypeEnum._('OBJECTION');
const PrivacyRequestSummaryRequestTypeEnum
    _$privacyRequestSummaryRequestTypeEnum_DELETION =
    const PrivacyRequestSummaryRequestTypeEnum._('DELETION');
const PrivacyRequestSummaryRequestTypeEnum
    _$privacyRequestSummaryRequestTypeEnum_RESTRICTION =
    const PrivacyRequestSummaryRequestTypeEnum._('RESTRICTION');
const PrivacyRequestSummaryRequestTypeEnum
    _$privacyRequestSummaryRequestTypeEnum_PORTABILITY =
    const PrivacyRequestSummaryRequestTypeEnum._('PORTABILITY');
const PrivacyRequestSummaryRequestTypeEnum
    _$privacyRequestSummaryRequestTypeEnum_OTHER =
    const PrivacyRequestSummaryRequestTypeEnum._('OTHER');

PrivacyRequestSummaryRequestTypeEnum
    _$privacyRequestSummaryRequestTypeEnumValueOf(String name) {
  switch (name) {
    case 'ACCESS':
      return _$privacyRequestSummaryRequestTypeEnum_ACCESS;
    case 'CORRECTION':
      return _$privacyRequestSummaryRequestTypeEnum_CORRECTION;
    case 'OBJECTION':
      return _$privacyRequestSummaryRequestTypeEnum_OBJECTION;
    case 'DELETION':
      return _$privacyRequestSummaryRequestTypeEnum_DELETION;
    case 'RESTRICTION':
      return _$privacyRequestSummaryRequestTypeEnum_RESTRICTION;
    case 'PORTABILITY':
      return _$privacyRequestSummaryRequestTypeEnum_PORTABILITY;
    case 'OTHER':
      return _$privacyRequestSummaryRequestTypeEnum_OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PrivacyRequestSummaryRequestTypeEnum>
    _$privacyRequestSummaryRequestTypeEnumValues = BuiltSet<
        PrivacyRequestSummaryRequestTypeEnum>(const <PrivacyRequestSummaryRequestTypeEnum>[
  _$privacyRequestSummaryRequestTypeEnum_ACCESS,
  _$privacyRequestSummaryRequestTypeEnum_CORRECTION,
  _$privacyRequestSummaryRequestTypeEnum_OBJECTION,
  _$privacyRequestSummaryRequestTypeEnum_DELETION,
  _$privacyRequestSummaryRequestTypeEnum_RESTRICTION,
  _$privacyRequestSummaryRequestTypeEnum_PORTABILITY,
  _$privacyRequestSummaryRequestTypeEnum_OTHER,
]);

const PrivacyRequestSummaryStateEnum _$privacyRequestSummaryStateEnum_RECEIVED =
    const PrivacyRequestSummaryStateEnum._('RECEIVED');
const PrivacyRequestSummaryStateEnum
    _$privacyRequestSummaryStateEnum_IDENTITY_VERIFIED =
    const PrivacyRequestSummaryStateEnum._('IDENTITY_VERIFIED');
const PrivacyRequestSummaryStateEnum
    _$privacyRequestSummaryStateEnum_IN_PROGRESS =
    const PrivacyRequestSummaryStateEnum._('IN_PROGRESS');
const PrivacyRequestSummaryStateEnum
    _$privacyRequestSummaryStateEnum_COMPLETED =
    const PrivacyRequestSummaryStateEnum._('COMPLETED');
const PrivacyRequestSummaryStateEnum _$privacyRequestSummaryStateEnum_REJECTED =
    const PrivacyRequestSummaryStateEnum._('REJECTED');
const PrivacyRequestSummaryStateEnum
    _$privacyRequestSummaryStateEnum_WITHDRAWN =
    const PrivacyRequestSummaryStateEnum._('WITHDRAWN');

PrivacyRequestSummaryStateEnum _$privacyRequestSummaryStateEnumValueOf(
    String name) {
  switch (name) {
    case 'RECEIVED':
      return _$privacyRequestSummaryStateEnum_RECEIVED;
    case 'IDENTITY_VERIFIED':
      return _$privacyRequestSummaryStateEnum_IDENTITY_VERIFIED;
    case 'IN_PROGRESS':
      return _$privacyRequestSummaryStateEnum_IN_PROGRESS;
    case 'COMPLETED':
      return _$privacyRequestSummaryStateEnum_COMPLETED;
    case 'REJECTED':
      return _$privacyRequestSummaryStateEnum_REJECTED;
    case 'WITHDRAWN':
      return _$privacyRequestSummaryStateEnum_WITHDRAWN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PrivacyRequestSummaryStateEnum>
    _$privacyRequestSummaryStateEnumValues = BuiltSet<
        PrivacyRequestSummaryStateEnum>(const <PrivacyRequestSummaryStateEnum>[
  _$privacyRequestSummaryStateEnum_RECEIVED,
  _$privacyRequestSummaryStateEnum_IDENTITY_VERIFIED,
  _$privacyRequestSummaryStateEnum_IN_PROGRESS,
  _$privacyRequestSummaryStateEnum_COMPLETED,
  _$privacyRequestSummaryStateEnum_REJECTED,
  _$privacyRequestSummaryStateEnum_WITHDRAWN,
]);

Serializer<PrivacyRequestSummaryRequestTypeEnum>
    _$privacyRequestSummaryRequestTypeEnumSerializer =
    _$PrivacyRequestSummaryRequestTypeEnumSerializer();
Serializer<PrivacyRequestSummaryStateEnum>
    _$privacyRequestSummaryStateEnumSerializer =
    _$PrivacyRequestSummaryStateEnumSerializer();

class _$PrivacyRequestSummaryRequestTypeEnumSerializer
    implements PrimitiveSerializer<PrivacyRequestSummaryRequestTypeEnum> {
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
    PrivacyRequestSummaryRequestTypeEnum
  ];
  @override
  final String wireName = 'PrivacyRequestSummaryRequestTypeEnum';

  @override
  Object serialize(
          Serializers serializers, PrivacyRequestSummaryRequestTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PrivacyRequestSummaryRequestTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PrivacyRequestSummaryRequestTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PrivacyRequestSummaryStateEnumSerializer
    implements PrimitiveSerializer<PrivacyRequestSummaryStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'RECEIVED': 'RECEIVED',
    'IDENTITY_VERIFIED': 'IDENTITY_VERIFIED',
    'IN_PROGRESS': 'IN_PROGRESS',
    'COMPLETED': 'COMPLETED',
    'REJECTED': 'REJECTED',
    'WITHDRAWN': 'WITHDRAWN',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'RECEIVED': 'RECEIVED',
    'IDENTITY_VERIFIED': 'IDENTITY_VERIFIED',
    'IN_PROGRESS': 'IN_PROGRESS',
    'COMPLETED': 'COMPLETED',
    'REJECTED': 'REJECTED',
    'WITHDRAWN': 'WITHDRAWN',
  };

  @override
  final Iterable<Type> types = const <Type>[PrivacyRequestSummaryStateEnum];
  @override
  final String wireName = 'PrivacyRequestSummaryStateEnum';

  @override
  Object serialize(
          Serializers serializers, PrivacyRequestSummaryStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PrivacyRequestSummaryStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PrivacyRequestSummaryStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

abstract class PrivacyRequestSummaryBuilder {
  void replace(PrivacyRequestSummary other);
  void update(void Function(PrivacyRequestSummaryBuilder) updates);
  String? get id;
  set id(String? id);

  String? get reference;
  set reference(String? reference);

  PrivacyRequestSummaryRequestTypeEnum? get requestType;
  set requestType(PrivacyRequestSummaryRequestTypeEnum? requestType);

  PrivacyRequestSummaryStateEnum? get state;
  set state(PrivacyRequestSummaryStateEnum? state);

  String? get subjectAccountType;
  set subjectAccountType(String? subjectAccountType);

  String? get subjectDisplay;
  set subjectDisplay(String? subjectDisplay);

  String? get intakeChannel;
  set intakeChannel(String? intakeChannel);

  DateTime? get receivedAt;
  set receivedAt(DateTime? receivedAt);

  Date? get targetDate;
  set targetDate(Date? targetDate);

  String? get handler;
  set handler(String? handler);

  int? get handlerUserId;
  set handlerUserId(int? handlerUserId);

  bool? get identityVerified;
  set identityVerified(bool? identityVerified);

  int? get lockVersion;
  set lockVersion(int? lockVersion);

  DateTime? get createdAt;
  set createdAt(DateTime? createdAt);
}

class _$$PrivacyRequestSummary extends $PrivacyRequestSummary {
  @override
  final String id;
  @override
  final String reference;
  @override
  final PrivacyRequestSummaryRequestTypeEnum requestType;
  @override
  final PrivacyRequestSummaryStateEnum state;
  @override
  final String subjectAccountType;
  @override
  final String subjectDisplay;
  @override
  final String? intakeChannel;
  @override
  final DateTime? receivedAt;
  @override
  final Date? targetDate;
  @override
  final String? handler;
  @override
  final int? handlerUserId;
  @override
  final bool identityVerified;
  @override
  final int lockVersion;
  @override
  final DateTime? createdAt;

  factory _$$PrivacyRequestSummary(
          [void Function($PrivacyRequestSummaryBuilder)? updates]) =>
      ($PrivacyRequestSummaryBuilder()..update(updates))._build();

  _$$PrivacyRequestSummary._(
      {required this.id,
      required this.reference,
      required this.requestType,
      required this.state,
      required this.subjectAccountType,
      required this.subjectDisplay,
      this.intakeChannel,
      this.receivedAt,
      this.targetDate,
      this.handler,
      this.handlerUserId,
      required this.identityVerified,
      required this.lockVersion,
      this.createdAt})
      : super._();
  @override
  $PrivacyRequestSummary rebuild(
          void Function($PrivacyRequestSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  $PrivacyRequestSummaryBuilder toBuilder() =>
      $PrivacyRequestSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is $PrivacyRequestSummary &&
        id == other.id &&
        reference == other.reference &&
        requestType == other.requestType &&
        state == other.state &&
        subjectAccountType == other.subjectAccountType &&
        subjectDisplay == other.subjectDisplay &&
        intakeChannel == other.intakeChannel &&
        receivedAt == other.receivedAt &&
        targetDate == other.targetDate &&
        handler == other.handler &&
        handlerUserId == other.handlerUserId &&
        identityVerified == other.identityVerified &&
        lockVersion == other.lockVersion &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reference.hashCode);
    _$hash = $jc(_$hash, requestType.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, subjectAccountType.hashCode);
    _$hash = $jc(_$hash, subjectDisplay.hashCode);
    _$hash = $jc(_$hash, intakeChannel.hashCode);
    _$hash = $jc(_$hash, receivedAt.hashCode);
    _$hash = $jc(_$hash, targetDate.hashCode);
    _$hash = $jc(_$hash, handler.hashCode);
    _$hash = $jc(_$hash, handlerUserId.hashCode);
    _$hash = $jc(_$hash, identityVerified.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'$PrivacyRequestSummary')
          ..add('id', id)
          ..add('reference', reference)
          ..add('requestType', requestType)
          ..add('state', state)
          ..add('subjectAccountType', subjectAccountType)
          ..add('subjectDisplay', subjectDisplay)
          ..add('intakeChannel', intakeChannel)
          ..add('receivedAt', receivedAt)
          ..add('targetDate', targetDate)
          ..add('handler', handler)
          ..add('handlerUserId', handlerUserId)
          ..add('identityVerified', identityVerified)
          ..add('lockVersion', lockVersion)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class $PrivacyRequestSummaryBuilder
    implements
        Builder<$PrivacyRequestSummary, $PrivacyRequestSummaryBuilder>,
        PrivacyRequestSummaryBuilder {
  _$$PrivacyRequestSummary? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(covariant String? id) => _$this._id = id;

  String? _reference;
  String? get reference => _$this._reference;
  set reference(covariant String? reference) => _$this._reference = reference;

  PrivacyRequestSummaryRequestTypeEnum? _requestType;
  PrivacyRequestSummaryRequestTypeEnum? get requestType => _$this._requestType;
  set requestType(
          covariant PrivacyRequestSummaryRequestTypeEnum? requestType) =>
      _$this._requestType = requestType;

  PrivacyRequestSummaryStateEnum? _state;
  PrivacyRequestSummaryStateEnum? get state => _$this._state;
  set state(covariant PrivacyRequestSummaryStateEnum? state) =>
      _$this._state = state;

  String? _subjectAccountType;
  String? get subjectAccountType => _$this._subjectAccountType;
  set subjectAccountType(covariant String? subjectAccountType) =>
      _$this._subjectAccountType = subjectAccountType;

  String? _subjectDisplay;
  String? get subjectDisplay => _$this._subjectDisplay;
  set subjectDisplay(covariant String? subjectDisplay) =>
      _$this._subjectDisplay = subjectDisplay;

  String? _intakeChannel;
  String? get intakeChannel => _$this._intakeChannel;
  set intakeChannel(covariant String? intakeChannel) =>
      _$this._intakeChannel = intakeChannel;

  DateTime? _receivedAt;
  DateTime? get receivedAt => _$this._receivedAt;
  set receivedAt(covariant DateTime? receivedAt) =>
      _$this._receivedAt = receivedAt;

  Date? _targetDate;
  Date? get targetDate => _$this._targetDate;
  set targetDate(covariant Date? targetDate) => _$this._targetDate = targetDate;

  String? _handler;
  String? get handler => _$this._handler;
  set handler(covariant String? handler) => _$this._handler = handler;

  int? _handlerUserId;
  int? get handlerUserId => _$this._handlerUserId;
  set handlerUserId(covariant int? handlerUserId) =>
      _$this._handlerUserId = handlerUserId;

  bool? _identityVerified;
  bool? get identityVerified => _$this._identityVerified;
  set identityVerified(covariant bool? identityVerified) =>
      _$this._identityVerified = identityVerified;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(covariant int? lockVersion) =>
      _$this._lockVersion = lockVersion;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(covariant DateTime? createdAt) => _$this._createdAt = createdAt;

  $PrivacyRequestSummaryBuilder() {
    $PrivacyRequestSummary._defaults(this);
  }

  $PrivacyRequestSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _reference = $v.reference;
      _requestType = $v.requestType;
      _state = $v.state;
      _subjectAccountType = $v.subjectAccountType;
      _subjectDisplay = $v.subjectDisplay;
      _intakeChannel = $v.intakeChannel;
      _receivedAt = $v.receivedAt;
      _targetDate = $v.targetDate;
      _handler = $v.handler;
      _handlerUserId = $v.handlerUserId;
      _identityVerified = $v.identityVerified;
      _lockVersion = $v.lockVersion;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant $PrivacyRequestSummary other) {
    _$v = other as _$$PrivacyRequestSummary;
  }

  @override
  void update(void Function($PrivacyRequestSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  $PrivacyRequestSummary build() => _build();

  _$$PrivacyRequestSummary _build() {
    final _$result = _$v ??
        _$$PrivacyRequestSummary._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'$PrivacyRequestSummary', 'id'),
          reference: BuiltValueNullFieldError.checkNotNull(
              reference, r'$PrivacyRequestSummary', 'reference'),
          requestType: BuiltValueNullFieldError.checkNotNull(
              requestType, r'$PrivacyRequestSummary', 'requestType'),
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'$PrivacyRequestSummary', 'state'),
          subjectAccountType: BuiltValueNullFieldError.checkNotNull(
              subjectAccountType,
              r'$PrivacyRequestSummary',
              'subjectAccountType'),
          subjectDisplay: BuiltValueNullFieldError.checkNotNull(
              subjectDisplay, r'$PrivacyRequestSummary', 'subjectDisplay'),
          intakeChannel: intakeChannel,
          receivedAt: receivedAt,
          targetDate: targetDate,
          handler: handler,
          handlerUserId: handlerUserId,
          identityVerified: BuiltValueNullFieldError.checkNotNull(
              identityVerified, r'$PrivacyRequestSummary', 'identityVerified'),
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'$PrivacyRequestSummary', 'lockVersion'),
          createdAt: createdAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
