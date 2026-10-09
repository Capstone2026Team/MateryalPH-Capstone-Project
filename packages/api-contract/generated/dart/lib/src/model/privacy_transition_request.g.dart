// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_transition_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PrivacyTransitionRequestVerificationMethodEnum
    _$privacyTransitionRequestVerificationMethodEnum_REGISTERED_EMAIL_CONFIRMATION =
    const PrivacyTransitionRequestVerificationMethodEnum._(
        'REGISTERED_EMAIL_CONFIRMATION');
const PrivacyTransitionRequestVerificationMethodEnum
    _$privacyTransitionRequestVerificationMethodEnum_SIGNED_IN_ACCOUNT_CONFIRMATION =
    const PrivacyTransitionRequestVerificationMethodEnum._(
        'SIGNED_IN_ACCOUNT_CONFIRMATION');
const PrivacyTransitionRequestVerificationMethodEnum
    _$privacyTransitionRequestVerificationMethodEnum_GOVERNMENT_ID_SIGHTED =
    const PrivacyTransitionRequestVerificationMethodEnum._(
        'GOVERNMENT_ID_SIGHTED');
const PrivacyTransitionRequestVerificationMethodEnum
    _$privacyTransitionRequestVerificationMethodEnum_AUTHORIZED_REPRESENTATIVE_DOCUMENT_SIGHTED =
    const PrivacyTransitionRequestVerificationMethodEnum._(
        'AUTHORIZED_REPRESENTATIVE_DOCUMENT_SIGHTED');

PrivacyTransitionRequestVerificationMethodEnum
    _$privacyTransitionRequestVerificationMethodEnumValueOf(String name) {
  switch (name) {
    case 'REGISTERED_EMAIL_CONFIRMATION':
      return _$privacyTransitionRequestVerificationMethodEnum_REGISTERED_EMAIL_CONFIRMATION;
    case 'SIGNED_IN_ACCOUNT_CONFIRMATION':
      return _$privacyTransitionRequestVerificationMethodEnum_SIGNED_IN_ACCOUNT_CONFIRMATION;
    case 'GOVERNMENT_ID_SIGHTED':
      return _$privacyTransitionRequestVerificationMethodEnum_GOVERNMENT_ID_SIGHTED;
    case 'AUTHORIZED_REPRESENTATIVE_DOCUMENT_SIGHTED':
      return _$privacyTransitionRequestVerificationMethodEnum_AUTHORIZED_REPRESENTATIVE_DOCUMENT_SIGHTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PrivacyTransitionRequestVerificationMethodEnum>
    _$privacyTransitionRequestVerificationMethodEnumValues = BuiltSet<
        PrivacyTransitionRequestVerificationMethodEnum>(const <PrivacyTransitionRequestVerificationMethodEnum>[
  _$privacyTransitionRequestVerificationMethodEnum_REGISTERED_EMAIL_CONFIRMATION,
  _$privacyTransitionRequestVerificationMethodEnum_SIGNED_IN_ACCOUNT_CONFIRMATION,
  _$privacyTransitionRequestVerificationMethodEnum_GOVERNMENT_ID_SIGHTED,
  _$privacyTransitionRequestVerificationMethodEnum_AUTHORIZED_REPRESENTATIVE_DOCUMENT_SIGHTED,
]);

Serializer<PrivacyTransitionRequestVerificationMethodEnum>
    _$privacyTransitionRequestVerificationMethodEnumSerializer =
    _$PrivacyTransitionRequestVerificationMethodEnumSerializer();

class _$PrivacyTransitionRequestVerificationMethodEnumSerializer
    implements
        PrimitiveSerializer<PrivacyTransitionRequestVerificationMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'REGISTERED_EMAIL_CONFIRMATION': 'REGISTERED_EMAIL_CONFIRMATION',
    'SIGNED_IN_ACCOUNT_CONFIRMATION': 'SIGNED_IN_ACCOUNT_CONFIRMATION',
    'GOVERNMENT_ID_SIGHTED': 'GOVERNMENT_ID_SIGHTED',
    'AUTHORIZED_REPRESENTATIVE_DOCUMENT_SIGHTED':
        'AUTHORIZED_REPRESENTATIVE_DOCUMENT_SIGHTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'REGISTERED_EMAIL_CONFIRMATION': 'REGISTERED_EMAIL_CONFIRMATION',
    'SIGNED_IN_ACCOUNT_CONFIRMATION': 'SIGNED_IN_ACCOUNT_CONFIRMATION',
    'GOVERNMENT_ID_SIGHTED': 'GOVERNMENT_ID_SIGHTED',
    'AUTHORIZED_REPRESENTATIVE_DOCUMENT_SIGHTED':
        'AUTHORIZED_REPRESENTATIVE_DOCUMENT_SIGHTED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PrivacyTransitionRequestVerificationMethodEnum
  ];
  @override
  final String wireName = 'PrivacyTransitionRequestVerificationMethodEnum';

  @override
  Object serialize(Serializers serializers,
          PrivacyTransitionRequestVerificationMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PrivacyTransitionRequestVerificationMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PrivacyTransitionRequestVerificationMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PrivacyTransitionRequest extends PrivacyTransitionRequest {
  @override
  final int lockVersion;
  @override
  final String note;
  @override
  final int? handlerUserId;
  @override
  final Date? targetDate;
  @override
  final PrivacyTransitionRequestVerificationMethodEnum? verificationMethod;
  @override
  final String? legalException;

  factory _$PrivacyTransitionRequest(
          [void Function(PrivacyTransitionRequestBuilder)? updates]) =>
      (PrivacyTransitionRequestBuilder()..update(updates))._build();

  _$PrivacyTransitionRequest._(
      {required this.lockVersion,
      required this.note,
      this.handlerUserId,
      this.targetDate,
      this.verificationMethod,
      this.legalException})
      : super._();
  @override
  PrivacyTransitionRequest rebuild(
          void Function(PrivacyTransitionRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PrivacyTransitionRequestBuilder toBuilder() =>
      PrivacyTransitionRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PrivacyTransitionRequest &&
        lockVersion == other.lockVersion &&
        note == other.note &&
        handlerUserId == other.handlerUserId &&
        targetDate == other.targetDate &&
        verificationMethod == other.verificationMethod &&
        legalException == other.legalException;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, handlerUserId.hashCode);
    _$hash = $jc(_$hash, targetDate.hashCode);
    _$hash = $jc(_$hash, verificationMethod.hashCode);
    _$hash = $jc(_$hash, legalException.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PrivacyTransitionRequest')
          ..add('lockVersion', lockVersion)
          ..add('note', note)
          ..add('handlerUserId', handlerUserId)
          ..add('targetDate', targetDate)
          ..add('verificationMethod', verificationMethod)
          ..add('legalException', legalException))
        .toString();
  }
}

class PrivacyTransitionRequestBuilder
    implements
        Builder<PrivacyTransitionRequest, PrivacyTransitionRequestBuilder> {
  _$PrivacyTransitionRequest? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  int? _handlerUserId;
  int? get handlerUserId => _$this._handlerUserId;
  set handlerUserId(int? handlerUserId) =>
      _$this._handlerUserId = handlerUserId;

  Date? _targetDate;
  Date? get targetDate => _$this._targetDate;
  set targetDate(Date? targetDate) => _$this._targetDate = targetDate;

  PrivacyTransitionRequestVerificationMethodEnum? _verificationMethod;
  PrivacyTransitionRequestVerificationMethodEnum? get verificationMethod =>
      _$this._verificationMethod;
  set verificationMethod(
          PrivacyTransitionRequestVerificationMethodEnum? verificationMethod) =>
      _$this._verificationMethod = verificationMethod;

  String? _legalException;
  String? get legalException => _$this._legalException;
  set legalException(String? legalException) =>
      _$this._legalException = legalException;

  PrivacyTransitionRequestBuilder() {
    PrivacyTransitionRequest._defaults(this);
  }

  PrivacyTransitionRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _note = $v.note;
      _handlerUserId = $v.handlerUserId;
      _targetDate = $v.targetDate;
      _verificationMethod = $v.verificationMethod;
      _legalException = $v.legalException;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PrivacyTransitionRequest other) {
    _$v = other as _$PrivacyTransitionRequest;
  }

  @override
  void update(void Function(PrivacyTransitionRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PrivacyTransitionRequest build() => _build();

  _$PrivacyTransitionRequest _build() {
    final _$result = _$v ??
        _$PrivacyTransitionRequest._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'PrivacyTransitionRequest', 'lockVersion'),
          note: BuiltValueNullFieldError.checkNotNull(
              note, r'PrivacyTransitionRequest', 'note'),
          handlerUserId: handlerUserId,
          targetDate: targetDate,
          verificationMethod: verificationMethod,
          legalException: legalException,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
