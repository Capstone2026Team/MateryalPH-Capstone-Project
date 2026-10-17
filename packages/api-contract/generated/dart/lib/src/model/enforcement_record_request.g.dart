// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enforcement_record_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const EnforcementRecordRequestSubjectTypeEnum
    _$enforcementRecordRequestSubjectTypeEnum_BUYER =
    const EnforcementRecordRequestSubjectTypeEnum._('BUYER');
const EnforcementRecordRequestSubjectTypeEnum
    _$enforcementRecordRequestSubjectTypeEnum_VENDOR_ORGANIZATION =
    const EnforcementRecordRequestSubjectTypeEnum._('VENDOR_ORGANIZATION');

EnforcementRecordRequestSubjectTypeEnum
    _$enforcementRecordRequestSubjectTypeEnumValueOf(String name) {
  switch (name) {
    case 'BUYER':
      return _$enforcementRecordRequestSubjectTypeEnum_BUYER;
    case 'VENDOR_ORGANIZATION':
      return _$enforcementRecordRequestSubjectTypeEnum_VENDOR_ORGANIZATION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EnforcementRecordRequestSubjectTypeEnum>
    _$enforcementRecordRequestSubjectTypeEnumValues = BuiltSet<
        EnforcementRecordRequestSubjectTypeEnum>(const <EnforcementRecordRequestSubjectTypeEnum>[
  _$enforcementRecordRequestSubjectTypeEnum_BUYER,
  _$enforcementRecordRequestSubjectTypeEnum_VENDOR_ORGANIZATION,
]);

const EnforcementRecordRequestActionEnum
    _$enforcementRecordRequestActionEnum_WARNING =
    const EnforcementRecordRequestActionEnum._('WARNING');
const EnforcementRecordRequestActionEnum
    _$enforcementRecordRequestActionEnum_TEMPORARY_RESTRICTION =
    const EnforcementRecordRequestActionEnum._('TEMPORARY_RESTRICTION');
const EnforcementRecordRequestActionEnum
    _$enforcementRecordRequestActionEnum_SUSPENSION =
    const EnforcementRecordRequestActionEnum._('SUSPENSION');
const EnforcementRecordRequestActionEnum
    _$enforcementRecordRequestActionEnum_PERMANENT_BAN =
    const EnforcementRecordRequestActionEnum._('PERMANENT_BAN');

EnforcementRecordRequestActionEnum _$enforcementRecordRequestActionEnumValueOf(
    String name) {
  switch (name) {
    case 'WARNING':
      return _$enforcementRecordRequestActionEnum_WARNING;
    case 'TEMPORARY_RESTRICTION':
      return _$enforcementRecordRequestActionEnum_TEMPORARY_RESTRICTION;
    case 'SUSPENSION':
      return _$enforcementRecordRequestActionEnum_SUSPENSION;
    case 'PERMANENT_BAN':
      return _$enforcementRecordRequestActionEnum_PERMANENT_BAN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EnforcementRecordRequestActionEnum>
    _$enforcementRecordRequestActionEnumValues = BuiltSet<
        EnforcementRecordRequestActionEnum>(const <EnforcementRecordRequestActionEnum>[
  _$enforcementRecordRequestActionEnum_WARNING,
  _$enforcementRecordRequestActionEnum_TEMPORARY_RESTRICTION,
  _$enforcementRecordRequestActionEnum_SUSPENSION,
  _$enforcementRecordRequestActionEnum_PERMANENT_BAN,
]);

const EnforcementRecordRequestContinuationPlanEnum
    _$enforcementRecordRequestContinuationPlanEnum_CONTINUE =
    const EnforcementRecordRequestContinuationPlanEnum._('CONTINUE');
const EnforcementRecordRequestContinuationPlanEnum
    _$enforcementRecordRequestContinuationPlanEnum_MONITORED_FULFILLMENT =
    const EnforcementRecordRequestContinuationPlanEnum._(
        'MONITORED_FULFILLMENT');
const EnforcementRecordRequestContinuationPlanEnum
    _$enforcementRecordRequestContinuationPlanEnum_CANCELLATION_REVIEW =
    const EnforcementRecordRequestContinuationPlanEnum._('CANCELLATION_REVIEW');
const EnforcementRecordRequestContinuationPlanEnum
    _$enforcementRecordRequestContinuationPlanEnum_REPLACEMENT =
    const EnforcementRecordRequestContinuationPlanEnum._('REPLACEMENT');
const EnforcementRecordRequestContinuationPlanEnum
    _$enforcementRecordRequestContinuationPlanEnum_REFUND =
    const EnforcementRecordRequestContinuationPlanEnum._('REFUND');
const EnforcementRecordRequestContinuationPlanEnum
    _$enforcementRecordRequestContinuationPlanEnum_NO_OPEN_ORDERS =
    const EnforcementRecordRequestContinuationPlanEnum._('NO_OPEN_ORDERS');

EnforcementRecordRequestContinuationPlanEnum
    _$enforcementRecordRequestContinuationPlanEnumValueOf(String name) {
  switch (name) {
    case 'CONTINUE':
      return _$enforcementRecordRequestContinuationPlanEnum_CONTINUE;
    case 'MONITORED_FULFILLMENT':
      return _$enforcementRecordRequestContinuationPlanEnum_MONITORED_FULFILLMENT;
    case 'CANCELLATION_REVIEW':
      return _$enforcementRecordRequestContinuationPlanEnum_CANCELLATION_REVIEW;
    case 'REPLACEMENT':
      return _$enforcementRecordRequestContinuationPlanEnum_REPLACEMENT;
    case 'REFUND':
      return _$enforcementRecordRequestContinuationPlanEnum_REFUND;
    case 'NO_OPEN_ORDERS':
      return _$enforcementRecordRequestContinuationPlanEnum_NO_OPEN_ORDERS;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EnforcementRecordRequestContinuationPlanEnum>
    _$enforcementRecordRequestContinuationPlanEnumValues = BuiltSet<
        EnforcementRecordRequestContinuationPlanEnum>(const <EnforcementRecordRequestContinuationPlanEnum>[
  _$enforcementRecordRequestContinuationPlanEnum_CONTINUE,
  _$enforcementRecordRequestContinuationPlanEnum_MONITORED_FULFILLMENT,
  _$enforcementRecordRequestContinuationPlanEnum_CANCELLATION_REVIEW,
  _$enforcementRecordRequestContinuationPlanEnum_REPLACEMENT,
  _$enforcementRecordRequestContinuationPlanEnum_REFUND,
  _$enforcementRecordRequestContinuationPlanEnum_NO_OPEN_ORDERS,
]);

Serializer<EnforcementRecordRequestSubjectTypeEnum>
    _$enforcementRecordRequestSubjectTypeEnumSerializer =
    _$EnforcementRecordRequestSubjectTypeEnumSerializer();
Serializer<EnforcementRecordRequestActionEnum>
    _$enforcementRecordRequestActionEnumSerializer =
    _$EnforcementRecordRequestActionEnumSerializer();
Serializer<EnforcementRecordRequestContinuationPlanEnum>
    _$enforcementRecordRequestContinuationPlanEnumSerializer =
    _$EnforcementRecordRequestContinuationPlanEnumSerializer();

class _$EnforcementRecordRequestSubjectTypeEnumSerializer
    implements PrimitiveSerializer<EnforcementRecordRequestSubjectTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER': 'BUYER',
    'VENDOR_ORGANIZATION': 'VENDOR_ORGANIZATION',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER': 'BUYER',
    'VENDOR_ORGANIZATION': 'VENDOR_ORGANIZATION',
  };

  @override
  final Iterable<Type> types = const <Type>[
    EnforcementRecordRequestSubjectTypeEnum
  ];
  @override
  final String wireName = 'EnforcementRecordRequestSubjectTypeEnum';

  @override
  Object serialize(Serializers serializers,
          EnforcementRecordRequestSubjectTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  EnforcementRecordRequestSubjectTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      EnforcementRecordRequestSubjectTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$EnforcementRecordRequestActionEnumSerializer
    implements PrimitiveSerializer<EnforcementRecordRequestActionEnum> {
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
  final Iterable<Type> types = const <Type>[EnforcementRecordRequestActionEnum];
  @override
  final String wireName = 'EnforcementRecordRequestActionEnum';

  @override
  Object serialize(
          Serializers serializers, EnforcementRecordRequestActionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  EnforcementRecordRequestActionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      EnforcementRecordRequestActionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$EnforcementRecordRequestContinuationPlanEnumSerializer
    implements
        PrimitiveSerializer<EnforcementRecordRequestContinuationPlanEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CONTINUE': 'CONTINUE',
    'MONITORED_FULFILLMENT': 'MONITORED_FULFILLMENT',
    'CANCELLATION_REVIEW': 'CANCELLATION_REVIEW',
    'REPLACEMENT': 'REPLACEMENT',
    'REFUND': 'REFUND',
    'NO_OPEN_ORDERS': 'NO_OPEN_ORDERS',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CONTINUE': 'CONTINUE',
    'MONITORED_FULFILLMENT': 'MONITORED_FULFILLMENT',
    'CANCELLATION_REVIEW': 'CANCELLATION_REVIEW',
    'REPLACEMENT': 'REPLACEMENT',
    'REFUND': 'REFUND',
    'NO_OPEN_ORDERS': 'NO_OPEN_ORDERS',
  };

  @override
  final Iterable<Type> types = const <Type>[
    EnforcementRecordRequestContinuationPlanEnum
  ];
  @override
  final String wireName = 'EnforcementRecordRequestContinuationPlanEnum';

  @override
  Object serialize(Serializers serializers,
          EnforcementRecordRequestContinuationPlanEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  EnforcementRecordRequestContinuationPlanEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      EnforcementRecordRequestContinuationPlanEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$EnforcementRecordRequest extends EnforcementRecordRequest {
  @override
  final EnforcementRecordRequestSubjectTypeEnum subjectType;
  @override
  final String subjectId;
  @override
  final EnforcementRecordRequestActionEnum action;
  @override
  final String reason;
  @override
  final String? scope;
  @override
  final int? durationDays;
  @override
  final String? restorationCondition;
  @override
  final EnforcementRecordRequestContinuationPlanEnum? continuationPlan;
  @override
  final String? continuationNote;

  factory _$EnforcementRecordRequest(
          [void Function(EnforcementRecordRequestBuilder)? updates]) =>
      (EnforcementRecordRequestBuilder()..update(updates))._build();

  _$EnforcementRecordRequest._(
      {required this.subjectType,
      required this.subjectId,
      required this.action,
      required this.reason,
      this.scope,
      this.durationDays,
      this.restorationCondition,
      this.continuationPlan,
      this.continuationNote})
      : super._();
  @override
  EnforcementRecordRequest rebuild(
          void Function(EnforcementRecordRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EnforcementRecordRequestBuilder toBuilder() =>
      EnforcementRecordRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EnforcementRecordRequest &&
        subjectType == other.subjectType &&
        subjectId == other.subjectId &&
        action == other.action &&
        reason == other.reason &&
        scope == other.scope &&
        durationDays == other.durationDays &&
        restorationCondition == other.restorationCondition &&
        continuationPlan == other.continuationPlan &&
        continuationNote == other.continuationNote;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, subjectType.hashCode);
    _$hash = $jc(_$hash, subjectId.hashCode);
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, durationDays.hashCode);
    _$hash = $jc(_$hash, restorationCondition.hashCode);
    _$hash = $jc(_$hash, continuationPlan.hashCode);
    _$hash = $jc(_$hash, continuationNote.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EnforcementRecordRequest')
          ..add('subjectType', subjectType)
          ..add('subjectId', subjectId)
          ..add('action', action)
          ..add('reason', reason)
          ..add('scope', scope)
          ..add('durationDays', durationDays)
          ..add('restorationCondition', restorationCondition)
          ..add('continuationPlan', continuationPlan)
          ..add('continuationNote', continuationNote))
        .toString();
  }
}

class EnforcementRecordRequestBuilder
    implements
        Builder<EnforcementRecordRequest, EnforcementRecordRequestBuilder> {
  _$EnforcementRecordRequest? _$v;

  EnforcementRecordRequestSubjectTypeEnum? _subjectType;
  EnforcementRecordRequestSubjectTypeEnum? get subjectType =>
      _$this._subjectType;
  set subjectType(EnforcementRecordRequestSubjectTypeEnum? subjectType) =>
      _$this._subjectType = subjectType;

  String? _subjectId;
  String? get subjectId => _$this._subjectId;
  set subjectId(String? subjectId) => _$this._subjectId = subjectId;

  EnforcementRecordRequestActionEnum? _action;
  EnforcementRecordRequestActionEnum? get action => _$this._action;
  set action(EnforcementRecordRequestActionEnum? action) =>
      _$this._action = action;

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

  EnforcementRecordRequestContinuationPlanEnum? _continuationPlan;
  EnforcementRecordRequestContinuationPlanEnum? get continuationPlan =>
      _$this._continuationPlan;
  set continuationPlan(
          EnforcementRecordRequestContinuationPlanEnum? continuationPlan) =>
      _$this._continuationPlan = continuationPlan;

  String? _continuationNote;
  String? get continuationNote => _$this._continuationNote;
  set continuationNote(String? continuationNote) =>
      _$this._continuationNote = continuationNote;

  EnforcementRecordRequestBuilder() {
    EnforcementRecordRequest._defaults(this);
  }

  EnforcementRecordRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _subjectType = $v.subjectType;
      _subjectId = $v.subjectId;
      _action = $v.action;
      _reason = $v.reason;
      _scope = $v.scope;
      _durationDays = $v.durationDays;
      _restorationCondition = $v.restorationCondition;
      _continuationPlan = $v.continuationPlan;
      _continuationNote = $v.continuationNote;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EnforcementRecordRequest other) {
    _$v = other as _$EnforcementRecordRequest;
  }

  @override
  void update(void Function(EnforcementRecordRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EnforcementRecordRequest build() => _build();

  _$EnforcementRecordRequest _build() {
    final _$result = _$v ??
        _$EnforcementRecordRequest._(
          subjectType: BuiltValueNullFieldError.checkNotNull(
              subjectType, r'EnforcementRecordRequest', 'subjectType'),
          subjectId: BuiltValueNullFieldError.checkNotNull(
              subjectId, r'EnforcementRecordRequest', 'subjectId'),
          action: BuiltValueNullFieldError.checkNotNull(
              action, r'EnforcementRecordRequest', 'action'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'EnforcementRecordRequest', 'reason'),
          scope: scope,
          durationDays: durationDays,
          restorationCondition: restorationCondition,
          continuationPlan: continuationPlan,
          continuationNote: continuationNote,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
