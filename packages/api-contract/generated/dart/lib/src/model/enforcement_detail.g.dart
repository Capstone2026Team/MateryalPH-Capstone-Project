// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enforcement_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const EnforcementDetailSubjectTypeEnum
    _$enforcementDetailSubjectTypeEnum_BUYER =
    const EnforcementDetailSubjectTypeEnum._('BUYER');
const EnforcementDetailSubjectTypeEnum
    _$enforcementDetailSubjectTypeEnum_VENDOR_ORGANIZATION =
    const EnforcementDetailSubjectTypeEnum._('VENDOR_ORGANIZATION');

EnforcementDetailSubjectTypeEnum _$enforcementDetailSubjectTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'BUYER':
      return _$enforcementDetailSubjectTypeEnum_BUYER;
    case 'VENDOR_ORGANIZATION':
      return _$enforcementDetailSubjectTypeEnum_VENDOR_ORGANIZATION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EnforcementDetailSubjectTypeEnum>
    _$enforcementDetailSubjectTypeEnumValues = BuiltSet<
        EnforcementDetailSubjectTypeEnum>(const <EnforcementDetailSubjectTypeEnum>[
  _$enforcementDetailSubjectTypeEnum_BUYER,
  _$enforcementDetailSubjectTypeEnum_VENDOR_ORGANIZATION,
]);

const EnforcementDetailActionEnum _$enforcementDetailActionEnum_WARNING =
    const EnforcementDetailActionEnum._('WARNING');
const EnforcementDetailActionEnum
    _$enforcementDetailActionEnum_TEMPORARY_RESTRICTION =
    const EnforcementDetailActionEnum._('TEMPORARY_RESTRICTION');
const EnforcementDetailActionEnum _$enforcementDetailActionEnum_SUSPENSION =
    const EnforcementDetailActionEnum._('SUSPENSION');
const EnforcementDetailActionEnum _$enforcementDetailActionEnum_PERMANENT_BAN =
    const EnforcementDetailActionEnum._('PERMANENT_BAN');

EnforcementDetailActionEnum _$enforcementDetailActionEnumValueOf(String name) {
  switch (name) {
    case 'WARNING':
      return _$enforcementDetailActionEnum_WARNING;
    case 'TEMPORARY_RESTRICTION':
      return _$enforcementDetailActionEnum_TEMPORARY_RESTRICTION;
    case 'SUSPENSION':
      return _$enforcementDetailActionEnum_SUSPENSION;
    case 'PERMANENT_BAN':
      return _$enforcementDetailActionEnum_PERMANENT_BAN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EnforcementDetailActionEnum>
    _$enforcementDetailActionEnumValues =
    BuiltSet<EnforcementDetailActionEnum>(const <EnforcementDetailActionEnum>[
  _$enforcementDetailActionEnum_WARNING,
  _$enforcementDetailActionEnum_TEMPORARY_RESTRICTION,
  _$enforcementDetailActionEnum_SUSPENSION,
  _$enforcementDetailActionEnum_PERMANENT_BAN,
]);

const EnforcementDetailStateEnum _$enforcementDetailStateEnum_EFFECTIVE =
    const EnforcementDetailStateEnum._('EFFECTIVE');
const EnforcementDetailStateEnum _$enforcementDetailStateEnum_REFERRED =
    const EnforcementDetailStateEnum._('REFERRED');
const EnforcementDetailStateEnum _$enforcementDetailStateEnum_APPLIED =
    const EnforcementDetailStateEnum._('APPLIED');
const EnforcementDetailStateEnum _$enforcementDetailStateEnum_LIFTED =
    const EnforcementDetailStateEnum._('LIFTED');
const EnforcementDetailStateEnum _$enforcementDetailStateEnum_DECLINED =
    const EnforcementDetailStateEnum._('DECLINED');

EnforcementDetailStateEnum _$enforcementDetailStateEnumValueOf(String name) {
  switch (name) {
    case 'EFFECTIVE':
      return _$enforcementDetailStateEnum_EFFECTIVE;
    case 'REFERRED':
      return _$enforcementDetailStateEnum_REFERRED;
    case 'APPLIED':
      return _$enforcementDetailStateEnum_APPLIED;
    case 'LIFTED':
      return _$enforcementDetailStateEnum_LIFTED;
    case 'DECLINED':
      return _$enforcementDetailStateEnum_DECLINED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EnforcementDetailStateEnum> _$enforcementDetailStateEnumValues =
    BuiltSet<EnforcementDetailStateEnum>(const <EnforcementDetailStateEnum>[
  _$enforcementDetailStateEnum_EFFECTIVE,
  _$enforcementDetailStateEnum_REFERRED,
  _$enforcementDetailStateEnum_APPLIED,
  _$enforcementDetailStateEnum_LIFTED,
  _$enforcementDetailStateEnum_DECLINED,
]);

const EnforcementDetailSource_Enum
    _$enforcementDetailSourceEnum_DISPUTE_REFERRAL =
    const EnforcementDetailSource_Enum._('DISPUTE_REFERRAL');
const EnforcementDetailSource_Enum _$enforcementDetailSourceEnum_DIRECT =
    const EnforcementDetailSource_Enum._('DIRECT');

EnforcementDetailSource_Enum _$enforcementDetailSourceEnumValueOf(String name) {
  switch (name) {
    case 'DISPUTE_REFERRAL':
      return _$enforcementDetailSourceEnum_DISPUTE_REFERRAL;
    case 'DIRECT':
      return _$enforcementDetailSourceEnum_DIRECT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EnforcementDetailSource_Enum>
    _$enforcementDetailSourceEnumValues =
    BuiltSet<EnforcementDetailSource_Enum>(const <EnforcementDetailSource_Enum>[
  _$enforcementDetailSourceEnum_DISPUTE_REFERRAL,
  _$enforcementDetailSourceEnum_DIRECT,
]);

const EnforcementDetailContinuationPlanEnum
    _$enforcementDetailContinuationPlanEnum_CONTINUE =
    const EnforcementDetailContinuationPlanEnum._('CONTINUE');
const EnforcementDetailContinuationPlanEnum
    _$enforcementDetailContinuationPlanEnum_MONITORED_FULFILLMENT =
    const EnforcementDetailContinuationPlanEnum._('MONITORED_FULFILLMENT');
const EnforcementDetailContinuationPlanEnum
    _$enforcementDetailContinuationPlanEnum_CANCELLATION_REVIEW =
    const EnforcementDetailContinuationPlanEnum._('CANCELLATION_REVIEW');
const EnforcementDetailContinuationPlanEnum
    _$enforcementDetailContinuationPlanEnum_REPLACEMENT =
    const EnforcementDetailContinuationPlanEnum._('REPLACEMENT');
const EnforcementDetailContinuationPlanEnum
    _$enforcementDetailContinuationPlanEnum_REFUND =
    const EnforcementDetailContinuationPlanEnum._('REFUND');
const EnforcementDetailContinuationPlanEnum
    _$enforcementDetailContinuationPlanEnum_NO_OPEN_ORDERS =
    const EnforcementDetailContinuationPlanEnum._('NO_OPEN_ORDERS');

EnforcementDetailContinuationPlanEnum
    _$enforcementDetailContinuationPlanEnumValueOf(String name) {
  switch (name) {
    case 'CONTINUE':
      return _$enforcementDetailContinuationPlanEnum_CONTINUE;
    case 'MONITORED_FULFILLMENT':
      return _$enforcementDetailContinuationPlanEnum_MONITORED_FULFILLMENT;
    case 'CANCELLATION_REVIEW':
      return _$enforcementDetailContinuationPlanEnum_CANCELLATION_REVIEW;
    case 'REPLACEMENT':
      return _$enforcementDetailContinuationPlanEnum_REPLACEMENT;
    case 'REFUND':
      return _$enforcementDetailContinuationPlanEnum_REFUND;
    case 'NO_OPEN_ORDERS':
      return _$enforcementDetailContinuationPlanEnum_NO_OPEN_ORDERS;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EnforcementDetailContinuationPlanEnum>
    _$enforcementDetailContinuationPlanEnumValues = BuiltSet<
        EnforcementDetailContinuationPlanEnum>(const <EnforcementDetailContinuationPlanEnum>[
  _$enforcementDetailContinuationPlanEnum_CONTINUE,
  _$enforcementDetailContinuationPlanEnum_MONITORED_FULFILLMENT,
  _$enforcementDetailContinuationPlanEnum_CANCELLATION_REVIEW,
  _$enforcementDetailContinuationPlanEnum_REPLACEMENT,
  _$enforcementDetailContinuationPlanEnum_REFUND,
  _$enforcementDetailContinuationPlanEnum_NO_OPEN_ORDERS,
]);

const EnforcementDetailAllowedActionsEnum
    _$enforcementDetailAllowedActionsEnum_APPLY =
    const EnforcementDetailAllowedActionsEnum._('APPLY');
const EnforcementDetailAllowedActionsEnum
    _$enforcementDetailAllowedActionsEnum_DECLINE =
    const EnforcementDetailAllowedActionsEnum._('DECLINE');
const EnforcementDetailAllowedActionsEnum
    _$enforcementDetailAllowedActionsEnum_LIFT =
    const EnforcementDetailAllowedActionsEnum._('LIFT');

EnforcementDetailAllowedActionsEnum
    _$enforcementDetailAllowedActionsEnumValueOf(String name) {
  switch (name) {
    case 'APPLY':
      return _$enforcementDetailAllowedActionsEnum_APPLY;
    case 'DECLINE':
      return _$enforcementDetailAllowedActionsEnum_DECLINE;
    case 'LIFT':
      return _$enforcementDetailAllowedActionsEnum_LIFT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EnforcementDetailAllowedActionsEnum>
    _$enforcementDetailAllowedActionsEnumValues = BuiltSet<
        EnforcementDetailAllowedActionsEnum>(const <EnforcementDetailAllowedActionsEnum>[
  _$enforcementDetailAllowedActionsEnum_APPLY,
  _$enforcementDetailAllowedActionsEnum_DECLINE,
  _$enforcementDetailAllowedActionsEnum_LIFT,
]);

Serializer<EnforcementDetailSubjectTypeEnum>
    _$enforcementDetailSubjectTypeEnumSerializer =
    _$EnforcementDetailSubjectTypeEnumSerializer();
Serializer<EnforcementDetailActionEnum>
    _$enforcementDetailActionEnumSerializer =
    _$EnforcementDetailActionEnumSerializer();
Serializer<EnforcementDetailStateEnum> _$enforcementDetailStateEnumSerializer =
    _$EnforcementDetailStateEnumSerializer();
Serializer<EnforcementDetailSource_Enum>
    _$enforcementDetailSourceEnumSerializer =
    _$EnforcementDetailSource_EnumSerializer();
Serializer<EnforcementDetailContinuationPlanEnum>
    _$enforcementDetailContinuationPlanEnumSerializer =
    _$EnforcementDetailContinuationPlanEnumSerializer();
Serializer<EnforcementDetailAllowedActionsEnum>
    _$enforcementDetailAllowedActionsEnumSerializer =
    _$EnforcementDetailAllowedActionsEnumSerializer();

class _$EnforcementDetailSubjectTypeEnumSerializer
    implements PrimitiveSerializer<EnforcementDetailSubjectTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BUYER': 'BUYER',
    'VENDOR_ORGANIZATION': 'VENDOR_ORGANIZATION',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BUYER': 'BUYER',
    'VENDOR_ORGANIZATION': 'VENDOR_ORGANIZATION',
  };

  @override
  final Iterable<Type> types = const <Type>[EnforcementDetailSubjectTypeEnum];
  @override
  final String wireName = 'EnforcementDetailSubjectTypeEnum';

  @override
  Object serialize(
          Serializers serializers, EnforcementDetailSubjectTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  EnforcementDetailSubjectTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      EnforcementDetailSubjectTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$EnforcementDetailActionEnumSerializer
    implements PrimitiveSerializer<EnforcementDetailActionEnum> {
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
  final Iterable<Type> types = const <Type>[EnforcementDetailActionEnum];
  @override
  final String wireName = 'EnforcementDetailActionEnum';

  @override
  Object serialize(Serializers serializers, EnforcementDetailActionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  EnforcementDetailActionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      EnforcementDetailActionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$EnforcementDetailStateEnumSerializer
    implements PrimitiveSerializer<EnforcementDetailStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'EFFECTIVE': 'EFFECTIVE',
    'REFERRED': 'REFERRED',
    'APPLIED': 'APPLIED',
    'LIFTED': 'LIFTED',
    'DECLINED': 'DECLINED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'EFFECTIVE': 'EFFECTIVE',
    'REFERRED': 'REFERRED',
    'APPLIED': 'APPLIED',
    'LIFTED': 'LIFTED',
    'DECLINED': 'DECLINED',
  };

  @override
  final Iterable<Type> types = const <Type>[EnforcementDetailStateEnum];
  @override
  final String wireName = 'EnforcementDetailStateEnum';

  @override
  Object serialize(Serializers serializers, EnforcementDetailStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  EnforcementDetailStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      EnforcementDetailStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$EnforcementDetailSource_EnumSerializer
    implements PrimitiveSerializer<EnforcementDetailSource_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DISPUTE_REFERRAL': 'DISPUTE_REFERRAL',
    'DIRECT': 'DIRECT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DISPUTE_REFERRAL': 'DISPUTE_REFERRAL',
    'DIRECT': 'DIRECT',
  };

  @override
  final Iterable<Type> types = const <Type>[EnforcementDetailSource_Enum];
  @override
  final String wireName = 'EnforcementDetailSource_Enum';

  @override
  Object serialize(Serializers serializers, EnforcementDetailSource_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  EnforcementDetailSource_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      EnforcementDetailSource_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$EnforcementDetailContinuationPlanEnumSerializer
    implements PrimitiveSerializer<EnforcementDetailContinuationPlanEnum> {
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
    EnforcementDetailContinuationPlanEnum
  ];
  @override
  final String wireName = 'EnforcementDetailContinuationPlanEnum';

  @override
  Object serialize(
          Serializers serializers, EnforcementDetailContinuationPlanEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  EnforcementDetailContinuationPlanEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      EnforcementDetailContinuationPlanEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$EnforcementDetailAllowedActionsEnumSerializer
    implements PrimitiveSerializer<EnforcementDetailAllowedActionsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'APPLY': 'APPLY',
    'DECLINE': 'DECLINE',
    'LIFT': 'LIFT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'APPLY': 'APPLY',
    'DECLINE': 'DECLINE',
    'LIFT': 'LIFT',
  };

  @override
  final Iterable<Type> types = const <Type>[
    EnforcementDetailAllowedActionsEnum
  ];
  @override
  final String wireName = 'EnforcementDetailAllowedActionsEnum';

  @override
  Object serialize(
          Serializers serializers, EnforcementDetailAllowedActionsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  EnforcementDetailAllowedActionsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      EnforcementDetailAllowedActionsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$EnforcementDetail extends EnforcementDetail {
  @override
  final String? continuationNote;
  @override
  final String? restorationCondition;
  @override
  final String scope;
  @override
  final SubjectReview subjectReview;
  @override
  final BuiltList<EnforcementDetailAllowedActionsEnum> allowedActions;
  @override
  final BuiltMap<String, JsonObject?>? priorSubjectState;
  @override
  final BuiltList<EnforcementEvent> events;
  @override
  final String id;
  @override
  final EnforcementSummarySubjectTypeEnum subjectType;
  @override
  final String subjectId;
  @override
  final String subjectName;
  @override
  final EnforcementSummaryActionEnum action;
  @override
  final String actionLabel;
  @override
  final EnforcementSummaryStateEnum state;
  @override
  final EnforcementSummarySource_Enum source_;
  @override
  final String? caseId;
  @override
  final String? caseReference;
  @override
  final String reason;
  @override
  final int? durationDays;
  @override
  final EnforcementSummaryContinuationPlanEnum? continuationPlan;
  @override
  final String? issuedRole;
  @override
  final String? appliedRole;
  @override
  final DateTime createdAt;
  @override
  final DateTime? appliedAt;
  @override
  final DateTime? expiresAt;
  @override
  final DateTime? liftedAt;
  @override
  final String? liftReason;
  @override
  final int lockVersion;

  factory _$EnforcementDetail(
          [void Function(EnforcementDetailBuilder)? updates]) =>
      (EnforcementDetailBuilder()..update(updates))._build();

  _$EnforcementDetail._(
      {this.continuationNote,
      this.restorationCondition,
      required this.scope,
      required this.subjectReview,
      required this.allowedActions,
      this.priorSubjectState,
      required this.events,
      required this.id,
      required this.subjectType,
      required this.subjectId,
      required this.subjectName,
      required this.action,
      required this.actionLabel,
      required this.state,
      required this.source_,
      this.caseId,
      this.caseReference,
      required this.reason,
      this.durationDays,
      this.continuationPlan,
      this.issuedRole,
      this.appliedRole,
      required this.createdAt,
      this.appliedAt,
      this.expiresAt,
      this.liftedAt,
      this.liftReason,
      required this.lockVersion})
      : super._();
  @override
  EnforcementDetail rebuild(void Function(EnforcementDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EnforcementDetailBuilder toBuilder() =>
      EnforcementDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EnforcementDetail &&
        continuationNote == other.continuationNote &&
        restorationCondition == other.restorationCondition &&
        scope == other.scope &&
        subjectReview == other.subjectReview &&
        allowedActions == other.allowedActions &&
        priorSubjectState == other.priorSubjectState &&
        events == other.events &&
        id == other.id &&
        subjectType == other.subjectType &&
        subjectId == other.subjectId &&
        subjectName == other.subjectName &&
        action == other.action &&
        actionLabel == other.actionLabel &&
        state == other.state &&
        source_ == other.source_ &&
        caseId == other.caseId &&
        caseReference == other.caseReference &&
        reason == other.reason &&
        durationDays == other.durationDays &&
        continuationPlan == other.continuationPlan &&
        issuedRole == other.issuedRole &&
        appliedRole == other.appliedRole &&
        createdAt == other.createdAt &&
        appliedAt == other.appliedAt &&
        expiresAt == other.expiresAt &&
        liftedAt == other.liftedAt &&
        liftReason == other.liftReason &&
        lockVersion == other.lockVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, continuationNote.hashCode);
    _$hash = $jc(_$hash, restorationCondition.hashCode);
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, subjectReview.hashCode);
    _$hash = $jc(_$hash, allowedActions.hashCode);
    _$hash = $jc(_$hash, priorSubjectState.hashCode);
    _$hash = $jc(_$hash, events.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, subjectType.hashCode);
    _$hash = $jc(_$hash, subjectId.hashCode);
    _$hash = $jc(_$hash, subjectName.hashCode);
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, actionLabel.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jc(_$hash, caseId.hashCode);
    _$hash = $jc(_$hash, caseReference.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, durationDays.hashCode);
    _$hash = $jc(_$hash, continuationPlan.hashCode);
    _$hash = $jc(_$hash, issuedRole.hashCode);
    _$hash = $jc(_$hash, appliedRole.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, appliedAt.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, liftedAt.hashCode);
    _$hash = $jc(_$hash, liftReason.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EnforcementDetail')
          ..add('continuationNote', continuationNote)
          ..add('restorationCondition', restorationCondition)
          ..add('scope', scope)
          ..add('subjectReview', subjectReview)
          ..add('allowedActions', allowedActions)
          ..add('priorSubjectState', priorSubjectState)
          ..add('events', events)
          ..add('id', id)
          ..add('subjectType', subjectType)
          ..add('subjectId', subjectId)
          ..add('subjectName', subjectName)
          ..add('action', action)
          ..add('actionLabel', actionLabel)
          ..add('state', state)
          ..add('source_', source_)
          ..add('caseId', caseId)
          ..add('caseReference', caseReference)
          ..add('reason', reason)
          ..add('durationDays', durationDays)
          ..add('continuationPlan', continuationPlan)
          ..add('issuedRole', issuedRole)
          ..add('appliedRole', appliedRole)
          ..add('createdAt', createdAt)
          ..add('appliedAt', appliedAt)
          ..add('expiresAt', expiresAt)
          ..add('liftedAt', liftedAt)
          ..add('liftReason', liftReason)
          ..add('lockVersion', lockVersion))
        .toString();
  }
}

class EnforcementDetailBuilder
    implements
        Builder<EnforcementDetail, EnforcementDetailBuilder>,
        EnforcementSummaryBuilder {
  _$EnforcementDetail? _$v;

  String? _continuationNote;
  String? get continuationNote => _$this._continuationNote;
  set continuationNote(covariant String? continuationNote) =>
      _$this._continuationNote = continuationNote;

  String? _restorationCondition;
  String? get restorationCondition => _$this._restorationCondition;
  set restorationCondition(covariant String? restorationCondition) =>
      _$this._restorationCondition = restorationCondition;

  String? _scope;
  String? get scope => _$this._scope;
  set scope(covariant String? scope) => _$this._scope = scope;

  SubjectReview? _subjectReview;
  SubjectReview? get subjectReview => _$this._subjectReview;
  set subjectReview(covariant SubjectReview? subjectReview) =>
      _$this._subjectReview = subjectReview;

  ListBuilder<EnforcementDetailAllowedActionsEnum>? _allowedActions;
  ListBuilder<EnforcementDetailAllowedActionsEnum> get allowedActions =>
      _$this._allowedActions ??=
          ListBuilder<EnforcementDetailAllowedActionsEnum>();
  set allowedActions(
          covariant ListBuilder<EnforcementDetailAllowedActionsEnum>?
              allowedActions) =>
      _$this._allowedActions = allowedActions;

  MapBuilder<String, JsonObject?>? _priorSubjectState;
  MapBuilder<String, JsonObject?> get priorSubjectState =>
      _$this._priorSubjectState ??= MapBuilder<String, JsonObject?>();
  set priorSubjectState(
          covariant MapBuilder<String, JsonObject?>? priorSubjectState) =>
      _$this._priorSubjectState = priorSubjectState;

  ListBuilder<EnforcementEvent>? _events;
  ListBuilder<EnforcementEvent> get events =>
      _$this._events ??= ListBuilder<EnforcementEvent>();
  set events(covariant ListBuilder<EnforcementEvent>? events) =>
      _$this._events = events;

  String? _id;
  String? get id => _$this._id;
  set id(covariant String? id) => _$this._id = id;

  EnforcementSummarySubjectTypeEnum? _subjectType;
  EnforcementSummarySubjectTypeEnum? get subjectType => _$this._subjectType;
  set subjectType(covariant EnforcementSummarySubjectTypeEnum? subjectType) =>
      _$this._subjectType = subjectType;

  String? _subjectId;
  String? get subjectId => _$this._subjectId;
  set subjectId(covariant String? subjectId) => _$this._subjectId = subjectId;

  String? _subjectName;
  String? get subjectName => _$this._subjectName;
  set subjectName(covariant String? subjectName) =>
      _$this._subjectName = subjectName;

  EnforcementSummaryActionEnum? _action;
  EnforcementSummaryActionEnum? get action => _$this._action;
  set action(covariant EnforcementSummaryActionEnum? action) =>
      _$this._action = action;

  String? _actionLabel;
  String? get actionLabel => _$this._actionLabel;
  set actionLabel(covariant String? actionLabel) =>
      _$this._actionLabel = actionLabel;

  EnforcementSummaryStateEnum? _state;
  EnforcementSummaryStateEnum? get state => _$this._state;
  set state(covariant EnforcementSummaryStateEnum? state) =>
      _$this._state = state;

  EnforcementSummarySource_Enum? _source_;
  EnforcementSummarySource_Enum? get source_ => _$this._source_;
  set source_(covariant EnforcementSummarySource_Enum? source_) =>
      _$this._source_ = source_;

  String? _caseId;
  String? get caseId => _$this._caseId;
  set caseId(covariant String? caseId) => _$this._caseId = caseId;

  String? _caseReference;
  String? get caseReference => _$this._caseReference;
  set caseReference(covariant String? caseReference) =>
      _$this._caseReference = caseReference;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(covariant String? reason) => _$this._reason = reason;

  int? _durationDays;
  int? get durationDays => _$this._durationDays;
  set durationDays(covariant int? durationDays) =>
      _$this._durationDays = durationDays;

  EnforcementSummaryContinuationPlanEnum? _continuationPlan;
  EnforcementSummaryContinuationPlanEnum? get continuationPlan =>
      _$this._continuationPlan;
  set continuationPlan(
          covariant EnforcementSummaryContinuationPlanEnum? continuationPlan) =>
      _$this._continuationPlan = continuationPlan;

  String? _issuedRole;
  String? get issuedRole => _$this._issuedRole;
  set issuedRole(covariant String? issuedRole) =>
      _$this._issuedRole = issuedRole;

  String? _appliedRole;
  String? get appliedRole => _$this._appliedRole;
  set appliedRole(covariant String? appliedRole) =>
      _$this._appliedRole = appliedRole;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(covariant DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _appliedAt;
  DateTime? get appliedAt => _$this._appliedAt;
  set appliedAt(covariant DateTime? appliedAt) => _$this._appliedAt = appliedAt;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(covariant DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  DateTime? _liftedAt;
  DateTime? get liftedAt => _$this._liftedAt;
  set liftedAt(covariant DateTime? liftedAt) => _$this._liftedAt = liftedAt;

  String? _liftReason;
  String? get liftReason => _$this._liftReason;
  set liftReason(covariant String? liftReason) =>
      _$this._liftReason = liftReason;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(covariant int? lockVersion) =>
      _$this._lockVersion = lockVersion;

  EnforcementDetailBuilder() {
    EnforcementDetail._defaults(this);
  }

  EnforcementDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _continuationNote = $v.continuationNote;
      _restorationCondition = $v.restorationCondition;
      _scope = $v.scope;
      _subjectReview = $v.subjectReview;
      _allowedActions = $v.allowedActions.toBuilder();
      _priorSubjectState = $v.priorSubjectState?.toBuilder();
      _events = $v.events.toBuilder();
      _id = $v.id;
      _subjectType = $v.subjectType;
      _subjectId = $v.subjectId;
      _subjectName = $v.subjectName;
      _action = $v.action;
      _actionLabel = $v.actionLabel;
      _state = $v.state;
      _source_ = $v.source_;
      _caseId = $v.caseId;
      _caseReference = $v.caseReference;
      _reason = $v.reason;
      _durationDays = $v.durationDays;
      _continuationPlan = $v.continuationPlan;
      _issuedRole = $v.issuedRole;
      _appliedRole = $v.appliedRole;
      _createdAt = $v.createdAt;
      _appliedAt = $v.appliedAt;
      _expiresAt = $v.expiresAt;
      _liftedAt = $v.liftedAt;
      _liftReason = $v.liftReason;
      _lockVersion = $v.lockVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant EnforcementDetail other) {
    _$v = other as _$EnforcementDetail;
  }

  @override
  void update(void Function(EnforcementDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EnforcementDetail build() => _build();

  _$EnforcementDetail _build() {
    _$EnforcementDetail _$result;
    try {
      _$result = _$v ??
          _$EnforcementDetail._(
            continuationNote: continuationNote,
            restorationCondition: restorationCondition,
            scope: BuiltValueNullFieldError.checkNotNull(
                scope, r'EnforcementDetail', 'scope'),
            subjectReview: BuiltValueNullFieldError.checkNotNull(
                subjectReview, r'EnforcementDetail', 'subjectReview'),
            allowedActions: allowedActions.build(),
            priorSubjectState: _priorSubjectState?.build(),
            events: events.build(),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'EnforcementDetail', 'id'),
            subjectType: BuiltValueNullFieldError.checkNotNull(
                subjectType, r'EnforcementDetail', 'subjectType'),
            subjectId: BuiltValueNullFieldError.checkNotNull(
                subjectId, r'EnforcementDetail', 'subjectId'),
            subjectName: BuiltValueNullFieldError.checkNotNull(
                subjectName, r'EnforcementDetail', 'subjectName'),
            action: BuiltValueNullFieldError.checkNotNull(
                action, r'EnforcementDetail', 'action'),
            actionLabel: BuiltValueNullFieldError.checkNotNull(
                actionLabel, r'EnforcementDetail', 'actionLabel'),
            state: BuiltValueNullFieldError.checkNotNull(
                state, r'EnforcementDetail', 'state'),
            source_: BuiltValueNullFieldError.checkNotNull(
                source_, r'EnforcementDetail', 'source_'),
            caseId: caseId,
            caseReference: caseReference,
            reason: BuiltValueNullFieldError.checkNotNull(
                reason, r'EnforcementDetail', 'reason'),
            durationDays: durationDays,
            continuationPlan: continuationPlan,
            issuedRole: issuedRole,
            appliedRole: appliedRole,
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'EnforcementDetail', 'createdAt'),
            appliedAt: appliedAt,
            expiresAt: expiresAt,
            liftedAt: liftedAt,
            liftReason: liftReason,
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'EnforcementDetail', 'lockVersion'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'allowedActions';
        allowedActions.build();
        _$failedField = 'priorSubjectState';
        _priorSubjectState?.build();
        _$failedField = 'events';
        events.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'EnforcementDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
