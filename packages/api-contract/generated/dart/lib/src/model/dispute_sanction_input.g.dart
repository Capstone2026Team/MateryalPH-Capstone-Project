// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_sanction_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DisputeSanctionInputSubjectEnum _$disputeSanctionInputSubjectEnum_BUYER =
    const DisputeSanctionInputSubjectEnum._('BUYER');
const DisputeSanctionInputSubjectEnum _$disputeSanctionInputSubjectEnum_VENDOR =
    const DisputeSanctionInputSubjectEnum._('VENDOR');

DisputeSanctionInputSubjectEnum _$disputeSanctionInputSubjectEnumValueOf(
    String name) {
  switch (name) {
    case 'BUYER':
      return _$disputeSanctionInputSubjectEnum_BUYER;
    case 'VENDOR':
      return _$disputeSanctionInputSubjectEnum_VENDOR;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeSanctionInputSubjectEnum>
    _$disputeSanctionInputSubjectEnumValues = BuiltSet<
        DisputeSanctionInputSubjectEnum>(const <DisputeSanctionInputSubjectEnum>[
  _$disputeSanctionInputSubjectEnum_BUYER,
  _$disputeSanctionInputSubjectEnum_VENDOR,
]);

const DisputeSanctionInputActionEnum _$disputeSanctionInputActionEnum_WARNING =
    const DisputeSanctionInputActionEnum._('WARNING');
const DisputeSanctionInputActionEnum
    _$disputeSanctionInputActionEnum_TEMPORARY_RESTRICTION =
    const DisputeSanctionInputActionEnum._('TEMPORARY_RESTRICTION');
const DisputeSanctionInputActionEnum
    _$disputeSanctionInputActionEnum_SUSPENSION =
    const DisputeSanctionInputActionEnum._('SUSPENSION');
const DisputeSanctionInputActionEnum
    _$disputeSanctionInputActionEnum_PERMANENT_BAN =
    const DisputeSanctionInputActionEnum._('PERMANENT_BAN');

DisputeSanctionInputActionEnum _$disputeSanctionInputActionEnumValueOf(
    String name) {
  switch (name) {
    case 'WARNING':
      return _$disputeSanctionInputActionEnum_WARNING;
    case 'TEMPORARY_RESTRICTION':
      return _$disputeSanctionInputActionEnum_TEMPORARY_RESTRICTION;
    case 'SUSPENSION':
      return _$disputeSanctionInputActionEnum_SUSPENSION;
    case 'PERMANENT_BAN':
      return _$disputeSanctionInputActionEnum_PERMANENT_BAN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeSanctionInputActionEnum>
    _$disputeSanctionInputActionEnumValues = BuiltSet<
        DisputeSanctionInputActionEnum>(const <DisputeSanctionInputActionEnum>[
  _$disputeSanctionInputActionEnum_WARNING,
  _$disputeSanctionInputActionEnum_TEMPORARY_RESTRICTION,
  _$disputeSanctionInputActionEnum_SUSPENSION,
  _$disputeSanctionInputActionEnum_PERMANENT_BAN,
]);

Serializer<DisputeSanctionInputSubjectEnum>
    _$disputeSanctionInputSubjectEnumSerializer =
    _$DisputeSanctionInputSubjectEnumSerializer();
Serializer<DisputeSanctionInputActionEnum>
    _$disputeSanctionInputActionEnumSerializer =
    _$DisputeSanctionInputActionEnumSerializer();

class _$DisputeSanctionInputSubjectEnumSerializer
    implements PrimitiveSerializer<DisputeSanctionInputSubjectEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER': 'BUYER',
    'VENDOR': 'VENDOR',
  };

  @override
  final Iterable<Type> types = const <Type>[DisputeSanctionInputSubjectEnum];
  @override
  final String wireName = 'DisputeSanctionInputSubjectEnum';

  @override
  Object serialize(
          Serializers serializers, DisputeSanctionInputSubjectEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeSanctionInputSubjectEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeSanctionInputSubjectEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeSanctionInputActionEnumSerializer
    implements PrimitiveSerializer<DisputeSanctionInputActionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'WARNING': 'WARNING',
    'TEMPORARY_RESTRICTION': 'TEMPORARY_RESTRICTION',
    'SUSPENSION': 'SUSPENSION',
    'PERMANENT_BAN': 'PERMANENT_BAN',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'WARNING': 'WARNING',
    'TEMPORARY_RESTRICTION': 'TEMPORARY_RESTRICTION',
    'SUSPENSION': 'SUSPENSION',
    'PERMANENT_BAN': 'PERMANENT_BAN',
  };

  @override
  final Iterable<Type> types = const <Type>[DisputeSanctionInputActionEnum];
  @override
  final String wireName = 'DisputeSanctionInputActionEnum';

  @override
  Object serialize(
          Serializers serializers, DisputeSanctionInputActionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeSanctionInputActionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeSanctionInputActionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeSanctionInput extends DisputeSanctionInput {
  @override
  final DisputeSanctionInputSubjectEnum subject;
  @override
  final DisputeSanctionInputActionEnum action;
  @override
  final String reason;
  @override
  final String? scope;
  @override
  final int? durationDays;
  @override
  final String? restorationCondition;

  factory _$DisputeSanctionInput(
          [void Function(DisputeSanctionInputBuilder)? updates]) =>
      (DisputeSanctionInputBuilder()..update(updates))._build();

  _$DisputeSanctionInput._(
      {required this.subject,
      required this.action,
      required this.reason,
      this.scope,
      this.durationDays,
      this.restorationCondition})
      : super._();
  @override
  DisputeSanctionInput rebuild(
          void Function(DisputeSanctionInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeSanctionInputBuilder toBuilder() =>
      DisputeSanctionInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeSanctionInput &&
        subject == other.subject &&
        action == other.action &&
        reason == other.reason &&
        scope == other.scope &&
        durationDays == other.durationDays &&
        restorationCondition == other.restorationCondition;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, subject.hashCode);
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, durationDays.hashCode);
    _$hash = $jc(_$hash, restorationCondition.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeSanctionInput')
          ..add('subject', subject)
          ..add('action', action)
          ..add('reason', reason)
          ..add('scope', scope)
          ..add('durationDays', durationDays)
          ..add('restorationCondition', restorationCondition))
        .toString();
  }
}

class DisputeSanctionInputBuilder
    implements Builder<DisputeSanctionInput, DisputeSanctionInputBuilder> {
  _$DisputeSanctionInput? _$v;

  DisputeSanctionInputSubjectEnum? _subject;
  DisputeSanctionInputSubjectEnum? get subject => _$this._subject;
  set subject(DisputeSanctionInputSubjectEnum? subject) =>
      _$this._subject = subject;

  DisputeSanctionInputActionEnum? _action;
  DisputeSanctionInputActionEnum? get action => _$this._action;
  set action(DisputeSanctionInputActionEnum? action) => _$this._action = action;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _scope;
  String? get scope => _$this._scope;
  set scope(String? scope) => _$this._scope = scope;

  int? _durationDays;
  int? get durationDays => _$this._durationDays;
  set durationDays(int? durationDays) => _$this._durationDays = durationDays;

  String? _restorationCondition;
  String? get restorationCondition => _$this._restorationCondition;
  set restorationCondition(String? restorationCondition) =>
      _$this._restorationCondition = restorationCondition;

  DisputeSanctionInputBuilder() {
    DisputeSanctionInput._defaults(this);
  }

  DisputeSanctionInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _subject = $v.subject;
      _action = $v.action;
      _reason = $v.reason;
      _scope = $v.scope;
      _durationDays = $v.durationDays;
      _restorationCondition = $v.restorationCondition;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeSanctionInput other) {
    _$v = other as _$DisputeSanctionInput;
  }

  @override
  void update(void Function(DisputeSanctionInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeSanctionInput build() => _build();

  _$DisputeSanctionInput _build() {
    final _$result = _$v ??
        _$DisputeSanctionInput._(
          subject: BuiltValueNullFieldError.checkNotNull(
              subject, r'DisputeSanctionInput', 'subject'),
          action: BuiltValueNullFieldError.checkNotNull(
              action, r'DisputeSanctionInput', 'action'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'DisputeSanctionInput', 'reason'),
          scope: scope,
          durationDays: durationDays,
          restorationCondition: restorationCondition,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
