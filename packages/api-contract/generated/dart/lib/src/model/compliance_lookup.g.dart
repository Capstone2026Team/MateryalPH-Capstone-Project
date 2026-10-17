// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compliance_lookup.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ComplianceLookupReasonEnum
    _$complianceLookupReasonEnum_NO_ACTIVE_REGISTER =
    const ComplianceLookupReasonEnum._('NO_ACTIVE_REGISTER');
const ComplianceLookupReasonEnum _$complianceLookupReasonEnum_NUMBER_FORMAT =
    const ComplianceLookupReasonEnum._('NUMBER_FORMAT');
const ComplianceLookupReasonEnum
    _$complianceLookupReasonEnum_CERTIFICATE_NUMBER_GIVEN =
    const ComplianceLookupReasonEnum._('CERTIFICATE_NUMBER_GIVEN');
const ComplianceLookupReasonEnum _$complianceLookupReasonEnum_NUMBER_NOT_FOUND =
    const ComplianceLookupReasonEnum._('NUMBER_NOT_FOUND');
const ComplianceLookupReasonEnum
    _$complianceLookupReasonEnum_PRODUCT_NOT_COVERED =
    const ComplianceLookupReasonEnum._('PRODUCT_NOT_COVERED');
const ComplianceLookupReasonEnum _$complianceLookupReasonEnum_RECORD_EXPIRED =
    const ComplianceLookupReasonEnum._('RECORD_EXPIRED');

ComplianceLookupReasonEnum _$complianceLookupReasonEnumValueOf(String name) {
  switch (name) {
    case 'NO_ACTIVE_REGISTER':
      return _$complianceLookupReasonEnum_NO_ACTIVE_REGISTER;
    case 'NUMBER_FORMAT':
      return _$complianceLookupReasonEnum_NUMBER_FORMAT;
    case 'CERTIFICATE_NUMBER_GIVEN':
      return _$complianceLookupReasonEnum_CERTIFICATE_NUMBER_GIVEN;
    case 'NUMBER_NOT_FOUND':
      return _$complianceLookupReasonEnum_NUMBER_NOT_FOUND;
    case 'PRODUCT_NOT_COVERED':
      return _$complianceLookupReasonEnum_PRODUCT_NOT_COVERED;
    case 'RECORD_EXPIRED':
      return _$complianceLookupReasonEnum_RECORD_EXPIRED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ComplianceLookupReasonEnum> _$complianceLookupReasonEnumValues =
    BuiltSet<ComplianceLookupReasonEnum>(const <ComplianceLookupReasonEnum>[
  _$complianceLookupReasonEnum_NO_ACTIVE_REGISTER,
  _$complianceLookupReasonEnum_NUMBER_FORMAT,
  _$complianceLookupReasonEnum_CERTIFICATE_NUMBER_GIVEN,
  _$complianceLookupReasonEnum_NUMBER_NOT_FOUND,
  _$complianceLookupReasonEnum_PRODUCT_NOT_COVERED,
  _$complianceLookupReasonEnum_RECORD_EXPIRED,
]);

Serializer<ComplianceLookupReasonEnum> _$complianceLookupReasonEnumSerializer =
    _$ComplianceLookupReasonEnumSerializer();

class _$ComplianceLookupReasonEnumSerializer
    implements PrimitiveSerializer<ComplianceLookupReasonEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'NO_ACTIVE_REGISTER': 'NO_ACTIVE_REGISTER',
    'NUMBER_FORMAT': 'NUMBER_FORMAT',
    'CERTIFICATE_NUMBER_GIVEN': 'CERTIFICATE_NUMBER_GIVEN',
    'NUMBER_NOT_FOUND': 'NUMBER_NOT_FOUND',
    'PRODUCT_NOT_COVERED': 'PRODUCT_NOT_COVERED',
    'RECORD_EXPIRED': 'RECORD_EXPIRED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'NO_ACTIVE_REGISTER': 'NO_ACTIVE_REGISTER',
    'NUMBER_FORMAT': 'NUMBER_FORMAT',
    'CERTIFICATE_NUMBER_GIVEN': 'CERTIFICATE_NUMBER_GIVEN',
    'NUMBER_NOT_FOUND': 'NUMBER_NOT_FOUND',
    'PRODUCT_NOT_COVERED': 'PRODUCT_NOT_COVERED',
    'RECORD_EXPIRED': 'RECORD_EXPIRED',
  };

  @override
  final Iterable<Type> types = const <Type>[ComplianceLookupReasonEnum];
  @override
  final String wireName = 'ComplianceLookupReasonEnum';

  @override
  Object serialize(Serializers serializers, ComplianceLookupReasonEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ComplianceLookupReasonEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ComplianceLookupReasonEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ComplianceLookup extends ComplianceLookup {
  @override
  final MarkingType markingType;
  @override
  final String number;
  @override
  final ComplianceReferenceResult result;
  @override
  final ComplianceLookupReasonEnum? reason;
  @override
  final String message;
  @override
  final bool canVerifyAutomatically;
  @override
  final ComplianceLookupRegister? register;
  @override
  final ComplianceRegisterRecord? record;

  factory _$ComplianceLookup(
          [void Function(ComplianceLookupBuilder)? updates]) =>
      (ComplianceLookupBuilder()..update(updates))._build();

  _$ComplianceLookup._(
      {required this.markingType,
      required this.number,
      required this.result,
      this.reason,
      required this.message,
      required this.canVerifyAutomatically,
      this.register,
      this.record})
      : super._();
  @override
  ComplianceLookup rebuild(void Function(ComplianceLookupBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ComplianceLookupBuilder toBuilder() =>
      ComplianceLookupBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ComplianceLookup &&
        markingType == other.markingType &&
        number == other.number &&
        result == other.result &&
        reason == other.reason &&
        message == other.message &&
        canVerifyAutomatically == other.canVerifyAutomatically &&
        register == other.register &&
        record == other.record;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, markingType.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, result.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, canVerifyAutomatically.hashCode);
    _$hash = $jc(_$hash, register.hashCode);
    _$hash = $jc(_$hash, record.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ComplianceLookup')
          ..add('markingType', markingType)
          ..add('number', number)
          ..add('result', result)
          ..add('reason', reason)
          ..add('message', message)
          ..add('canVerifyAutomatically', canVerifyAutomatically)
          ..add('register', register)
          ..add('record', record))
        .toString();
  }
}

class ComplianceLookupBuilder
    implements Builder<ComplianceLookup, ComplianceLookupBuilder> {
  _$ComplianceLookup? _$v;

  MarkingType? _markingType;
  MarkingType? get markingType => _$this._markingType;
  set markingType(MarkingType? markingType) =>
      _$this._markingType = markingType;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  ComplianceReferenceResult? _result;
  ComplianceReferenceResult? get result => _$this._result;
  set result(ComplianceReferenceResult? result) => _$this._result = result;

  ComplianceLookupReasonEnum? _reason;
  ComplianceLookupReasonEnum? get reason => _$this._reason;
  set reason(ComplianceLookupReasonEnum? reason) => _$this._reason = reason;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  bool? _canVerifyAutomatically;
  bool? get canVerifyAutomatically => _$this._canVerifyAutomatically;
  set canVerifyAutomatically(bool? canVerifyAutomatically) =>
      _$this._canVerifyAutomatically = canVerifyAutomatically;

  ComplianceLookupRegisterBuilder? _register;
  ComplianceLookupRegisterBuilder get register =>
      _$this._register ??= ComplianceLookupRegisterBuilder();
  set register(ComplianceLookupRegisterBuilder? register) =>
      _$this._register = register;

  ComplianceRegisterRecordBuilder? _record;
  ComplianceRegisterRecordBuilder get record =>
      _$this._record ??= ComplianceRegisterRecordBuilder();
  set record(ComplianceRegisterRecordBuilder? record) =>
      _$this._record = record;

  ComplianceLookupBuilder() {
    ComplianceLookup._defaults(this);
  }

  ComplianceLookupBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _markingType = $v.markingType;
      _number = $v.number;
      _result = $v.result;
      _reason = $v.reason;
      _message = $v.message;
      _canVerifyAutomatically = $v.canVerifyAutomatically;
      _register = $v.register?.toBuilder();
      _record = $v.record?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ComplianceLookup other) {
    _$v = other as _$ComplianceLookup;
  }

  @override
  void update(void Function(ComplianceLookupBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ComplianceLookup build() => _build();

  _$ComplianceLookup _build() {
    _$ComplianceLookup _$result;
    try {
      _$result = _$v ??
          _$ComplianceLookup._(
            markingType: BuiltValueNullFieldError.checkNotNull(
                markingType, r'ComplianceLookup', 'markingType'),
            number: BuiltValueNullFieldError.checkNotNull(
                number, r'ComplianceLookup', 'number'),
            result: BuiltValueNullFieldError.checkNotNull(
                result, r'ComplianceLookup', 'result'),
            reason: reason,
            message: BuiltValueNullFieldError.checkNotNull(
                message, r'ComplianceLookup', 'message'),
            canVerifyAutomatically: BuiltValueNullFieldError.checkNotNull(
                canVerifyAutomatically,
                r'ComplianceLookup',
                'canVerifyAutomatically'),
            register: _register?.build(),
            record: _record?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'register';
        _register?.build();
        _$failedField = 'record';
        _record?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ComplianceLookup', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
