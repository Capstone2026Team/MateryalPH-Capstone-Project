// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_adjustment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TaxAdjustmentStateEnum _$taxAdjustmentStateEnum_ADJUSTMENT_REQUIRED =
    const TaxAdjustmentStateEnum._('ADJUSTMENT_REQUIRED');
const TaxAdjustmentStateEnum _$taxAdjustmentStateEnum_UNDER_REVIEW =
    const TaxAdjustmentStateEnum._('UNDER_REVIEW');
const TaxAdjustmentStateEnum _$taxAdjustmentStateEnum_APPROVED =
    const TaxAdjustmentStateEnum._('APPROVED');
const TaxAdjustmentStateEnum _$taxAdjustmentStateEnum_POSTED =
    const TaxAdjustmentStateEnum._('POSTED');
const TaxAdjustmentStateEnum _$taxAdjustmentStateEnum_REJECTED =
    const TaxAdjustmentStateEnum._('REJECTED');
const TaxAdjustmentStateEnum _$taxAdjustmentStateEnum_NOT_REQUIRED =
    const TaxAdjustmentStateEnum._('NOT_REQUIRED');

TaxAdjustmentStateEnum _$taxAdjustmentStateEnumValueOf(String name) {
  switch (name) {
    case 'ADJUSTMENT_REQUIRED':
      return _$taxAdjustmentStateEnum_ADJUSTMENT_REQUIRED;
    case 'UNDER_REVIEW':
      return _$taxAdjustmentStateEnum_UNDER_REVIEW;
    case 'APPROVED':
      return _$taxAdjustmentStateEnum_APPROVED;
    case 'POSTED':
      return _$taxAdjustmentStateEnum_POSTED;
    case 'REJECTED':
      return _$taxAdjustmentStateEnum_REJECTED;
    case 'NOT_REQUIRED':
      return _$taxAdjustmentStateEnum_NOT_REQUIRED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TaxAdjustmentStateEnum> _$taxAdjustmentStateEnumValues =
    BuiltSet<TaxAdjustmentStateEnum>(const <TaxAdjustmentStateEnum>[
  _$taxAdjustmentStateEnum_ADJUSTMENT_REQUIRED,
  _$taxAdjustmentStateEnum_UNDER_REVIEW,
  _$taxAdjustmentStateEnum_APPROVED,
  _$taxAdjustmentStateEnum_POSTED,
  _$taxAdjustmentStateEnum_REJECTED,
  _$taxAdjustmentStateEnum_NOT_REQUIRED,
]);

const TaxAdjustmentOpenedByEnum _$taxAdjustmentOpenedByEnum_USER =
    const TaxAdjustmentOpenedByEnum._('USER');
const TaxAdjustmentOpenedByEnum _$taxAdjustmentOpenedByEnum_SYSTEM =
    const TaxAdjustmentOpenedByEnum._('SYSTEM');

TaxAdjustmentOpenedByEnum _$taxAdjustmentOpenedByEnumValueOf(String name) {
  switch (name) {
    case 'USER':
      return _$taxAdjustmentOpenedByEnum_USER;
    case 'SYSTEM':
      return _$taxAdjustmentOpenedByEnum_SYSTEM;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TaxAdjustmentOpenedByEnum> _$taxAdjustmentOpenedByEnumValues =
    BuiltSet<TaxAdjustmentOpenedByEnum>(const <TaxAdjustmentOpenedByEnum>[
  _$taxAdjustmentOpenedByEnum_USER,
  _$taxAdjustmentOpenedByEnum_SYSTEM,
]);

const TaxAdjustmentAllowedActionsEnum
    _$taxAdjustmentAllowedActionsEnum_PREPARE =
    const TaxAdjustmentAllowedActionsEnum._('PREPARE');
const TaxAdjustmentAllowedActionsEnum
    _$taxAdjustmentAllowedActionsEnum_APPROVE =
    const TaxAdjustmentAllowedActionsEnum._('APPROVE');
const TaxAdjustmentAllowedActionsEnum _$taxAdjustmentAllowedActionsEnum_REJECT =
    const TaxAdjustmentAllowedActionsEnum._('REJECT');
const TaxAdjustmentAllowedActionsEnum _$taxAdjustmentAllowedActionsEnum_POST =
    const TaxAdjustmentAllowedActionsEnum._('POST');

TaxAdjustmentAllowedActionsEnum _$taxAdjustmentAllowedActionsEnumValueOf(
    String name) {
  switch (name) {
    case 'PREPARE':
      return _$taxAdjustmentAllowedActionsEnum_PREPARE;
    case 'APPROVE':
      return _$taxAdjustmentAllowedActionsEnum_APPROVE;
    case 'REJECT':
      return _$taxAdjustmentAllowedActionsEnum_REJECT;
    case 'POST':
      return _$taxAdjustmentAllowedActionsEnum_POST;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TaxAdjustmentAllowedActionsEnum>
    _$taxAdjustmentAllowedActionsEnumValues = BuiltSet<
        TaxAdjustmentAllowedActionsEnum>(const <TaxAdjustmentAllowedActionsEnum>[
  _$taxAdjustmentAllowedActionsEnum_PREPARE,
  _$taxAdjustmentAllowedActionsEnum_APPROVE,
  _$taxAdjustmentAllowedActionsEnum_REJECT,
  _$taxAdjustmentAllowedActionsEnum_POST,
]);

Serializer<TaxAdjustmentStateEnum> _$taxAdjustmentStateEnumSerializer =
    _$TaxAdjustmentStateEnumSerializer();
Serializer<TaxAdjustmentOpenedByEnum> _$taxAdjustmentOpenedByEnumSerializer =
    _$TaxAdjustmentOpenedByEnumSerializer();
Serializer<TaxAdjustmentAllowedActionsEnum>
    _$taxAdjustmentAllowedActionsEnumSerializer =
    _$TaxAdjustmentAllowedActionsEnumSerializer();

class _$TaxAdjustmentStateEnumSerializer
    implements PrimitiveSerializer<TaxAdjustmentStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ADJUSTMENT_REQUIRED': 'ADJUSTMENT_REQUIRED',
    'UNDER_REVIEW': 'UNDER_REVIEW',
    'APPROVED': 'APPROVED',
    'POSTED': 'POSTED',
    'REJECTED': 'REJECTED',
    'NOT_REQUIRED': 'NOT_REQUIRED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ADJUSTMENT_REQUIRED': 'ADJUSTMENT_REQUIRED',
    'UNDER_REVIEW': 'UNDER_REVIEW',
    'APPROVED': 'APPROVED',
    'POSTED': 'POSTED',
    'REJECTED': 'REJECTED',
    'NOT_REQUIRED': 'NOT_REQUIRED',
  };

  @override
  final Iterable<Type> types = const <Type>[TaxAdjustmentStateEnum];
  @override
  final String wireName = 'TaxAdjustmentStateEnum';

  @override
  Object serialize(Serializers serializers, TaxAdjustmentStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TaxAdjustmentStateEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TaxAdjustmentStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TaxAdjustmentOpenedByEnumSerializer
    implements PrimitiveSerializer<TaxAdjustmentOpenedByEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'USER': 'USER',
    'SYSTEM': 'SYSTEM',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'USER': 'USER',
    'SYSTEM': 'SYSTEM',
  };

  @override
  final Iterable<Type> types = const <Type>[TaxAdjustmentOpenedByEnum];
  @override
  final String wireName = 'TaxAdjustmentOpenedByEnum';

  @override
  Object serialize(Serializers serializers, TaxAdjustmentOpenedByEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TaxAdjustmentOpenedByEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TaxAdjustmentOpenedByEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TaxAdjustmentAllowedActionsEnumSerializer
    implements PrimitiveSerializer<TaxAdjustmentAllowedActionsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PREPARE': 'PREPARE',
    'APPROVE': 'APPROVE',
    'REJECT': 'REJECT',
    'POST': 'POST',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PREPARE': 'PREPARE',
    'APPROVE': 'APPROVE',
    'REJECT': 'REJECT',
    'POST': 'POST',
  };

  @override
  final Iterable<Type> types = const <Type>[TaxAdjustmentAllowedActionsEnum];
  @override
  final String wireName = 'TaxAdjustmentAllowedActionsEnum';

  @override
  Object serialize(
          Serializers serializers, TaxAdjustmentAllowedActionsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TaxAdjustmentAllowedActionsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TaxAdjustmentAllowedActionsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TaxAdjustment extends TaxAdjustment {
  @override
  final String id;
  @override
  final String kind;
  @override
  final TaxAdjustmentStateEnum state;
  @override
  final String environment;
  @override
  final TaxAdjustmentOpenedByEnum openedBy;
  @override
  final String? orderReference;
  @override
  final String? vendorName;
  @override
  final String originalRecordType;
  @override
  final String originalRecordId;
  @override
  final Date periodStart;
  @override
  final Date periodEnd;
  @override
  final int amountCentavos;
  @override
  final BuiltMap<String, JsonObject?> beforeValues;
  @override
  final BuiltMap<String, JsonObject?> afterValues;
  @override
  final String reason;
  @override
  final String? preparer;
  @override
  final String? reviewer;
  @override
  final DateTime? reviewedAt;
  @override
  final DateTime? postedAt;
  @override
  final DateTime? createdAt;
  @override
  final BuiltList<TaxAdjustmentAllowedActionsEnum> allowedActions;
  @override
  final String? separationNote;

  factory _$TaxAdjustment([void Function(TaxAdjustmentBuilder)? updates]) =>
      (TaxAdjustmentBuilder()..update(updates))._build();

  _$TaxAdjustment._(
      {required this.id,
      required this.kind,
      required this.state,
      required this.environment,
      required this.openedBy,
      this.orderReference,
      this.vendorName,
      required this.originalRecordType,
      required this.originalRecordId,
      required this.periodStart,
      required this.periodEnd,
      required this.amountCentavos,
      required this.beforeValues,
      required this.afterValues,
      required this.reason,
      this.preparer,
      this.reviewer,
      this.reviewedAt,
      this.postedAt,
      this.createdAt,
      required this.allowedActions,
      this.separationNote})
      : super._();
  @override
  TaxAdjustment rebuild(void Function(TaxAdjustmentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TaxAdjustmentBuilder toBuilder() => TaxAdjustmentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TaxAdjustment &&
        id == other.id &&
        kind == other.kind &&
        state == other.state &&
        environment == other.environment &&
        openedBy == other.openedBy &&
        orderReference == other.orderReference &&
        vendorName == other.vendorName &&
        originalRecordType == other.originalRecordType &&
        originalRecordId == other.originalRecordId &&
        periodStart == other.periodStart &&
        periodEnd == other.periodEnd &&
        amountCentavos == other.amountCentavos &&
        beforeValues == other.beforeValues &&
        afterValues == other.afterValues &&
        reason == other.reason &&
        preparer == other.preparer &&
        reviewer == other.reviewer &&
        reviewedAt == other.reviewedAt &&
        postedAt == other.postedAt &&
        createdAt == other.createdAt &&
        allowedActions == other.allowedActions &&
        separationNote == other.separationNote;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, environment.hashCode);
    _$hash = $jc(_$hash, openedBy.hashCode);
    _$hash = $jc(_$hash, orderReference.hashCode);
    _$hash = $jc(_$hash, vendorName.hashCode);
    _$hash = $jc(_$hash, originalRecordType.hashCode);
    _$hash = $jc(_$hash, originalRecordId.hashCode);
    _$hash = $jc(_$hash, periodStart.hashCode);
    _$hash = $jc(_$hash, periodEnd.hashCode);
    _$hash = $jc(_$hash, amountCentavos.hashCode);
    _$hash = $jc(_$hash, beforeValues.hashCode);
    _$hash = $jc(_$hash, afterValues.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, preparer.hashCode);
    _$hash = $jc(_$hash, reviewer.hashCode);
    _$hash = $jc(_$hash, reviewedAt.hashCode);
    _$hash = $jc(_$hash, postedAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, allowedActions.hashCode);
    _$hash = $jc(_$hash, separationNote.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TaxAdjustment')
          ..add('id', id)
          ..add('kind', kind)
          ..add('state', state)
          ..add('environment', environment)
          ..add('openedBy', openedBy)
          ..add('orderReference', orderReference)
          ..add('vendorName', vendorName)
          ..add('originalRecordType', originalRecordType)
          ..add('originalRecordId', originalRecordId)
          ..add('periodStart', periodStart)
          ..add('periodEnd', periodEnd)
          ..add('amountCentavos', amountCentavos)
          ..add('beforeValues', beforeValues)
          ..add('afterValues', afterValues)
          ..add('reason', reason)
          ..add('preparer', preparer)
          ..add('reviewer', reviewer)
          ..add('reviewedAt', reviewedAt)
          ..add('postedAt', postedAt)
          ..add('createdAt', createdAt)
          ..add('allowedActions', allowedActions)
          ..add('separationNote', separationNote))
        .toString();
  }
}

class TaxAdjustmentBuilder
    implements Builder<TaxAdjustment, TaxAdjustmentBuilder> {
  _$TaxAdjustment? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _kind;
  String? get kind => _$this._kind;
  set kind(String? kind) => _$this._kind = kind;

  TaxAdjustmentStateEnum? _state;
  TaxAdjustmentStateEnum? get state => _$this._state;
  set state(TaxAdjustmentStateEnum? state) => _$this._state = state;

  String? _environment;
  String? get environment => _$this._environment;
  set environment(String? environment) => _$this._environment = environment;

  TaxAdjustmentOpenedByEnum? _openedBy;
  TaxAdjustmentOpenedByEnum? get openedBy => _$this._openedBy;
  set openedBy(TaxAdjustmentOpenedByEnum? openedBy) =>
      _$this._openedBy = openedBy;

  String? _orderReference;
  String? get orderReference => _$this._orderReference;
  set orderReference(String? orderReference) =>
      _$this._orderReference = orderReference;

  String? _vendorName;
  String? get vendorName => _$this._vendorName;
  set vendorName(String? vendorName) => _$this._vendorName = vendorName;

  String? _originalRecordType;
  String? get originalRecordType => _$this._originalRecordType;
  set originalRecordType(String? originalRecordType) =>
      _$this._originalRecordType = originalRecordType;

  String? _originalRecordId;
  String? get originalRecordId => _$this._originalRecordId;
  set originalRecordId(String? originalRecordId) =>
      _$this._originalRecordId = originalRecordId;

  Date? _periodStart;
  Date? get periodStart => _$this._periodStart;
  set periodStart(Date? periodStart) => _$this._periodStart = periodStart;

  Date? _periodEnd;
  Date? get periodEnd => _$this._periodEnd;
  set periodEnd(Date? periodEnd) => _$this._periodEnd = periodEnd;

  int? _amountCentavos;
  int? get amountCentavos => _$this._amountCentavos;
  set amountCentavos(int? amountCentavos) =>
      _$this._amountCentavos = amountCentavos;

  MapBuilder<String, JsonObject?>? _beforeValues;
  MapBuilder<String, JsonObject?> get beforeValues =>
      _$this._beforeValues ??= MapBuilder<String, JsonObject?>();
  set beforeValues(MapBuilder<String, JsonObject?>? beforeValues) =>
      _$this._beforeValues = beforeValues;

  MapBuilder<String, JsonObject?>? _afterValues;
  MapBuilder<String, JsonObject?> get afterValues =>
      _$this._afterValues ??= MapBuilder<String, JsonObject?>();
  set afterValues(MapBuilder<String, JsonObject?>? afterValues) =>
      _$this._afterValues = afterValues;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _preparer;
  String? get preparer => _$this._preparer;
  set preparer(String? preparer) => _$this._preparer = preparer;

  String? _reviewer;
  String? get reviewer => _$this._reviewer;
  set reviewer(String? reviewer) => _$this._reviewer = reviewer;

  DateTime? _reviewedAt;
  DateTime? get reviewedAt => _$this._reviewedAt;
  set reviewedAt(DateTime? reviewedAt) => _$this._reviewedAt = reviewedAt;

  DateTime? _postedAt;
  DateTime? get postedAt => _$this._postedAt;
  set postedAt(DateTime? postedAt) => _$this._postedAt = postedAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ListBuilder<TaxAdjustmentAllowedActionsEnum>? _allowedActions;
  ListBuilder<TaxAdjustmentAllowedActionsEnum> get allowedActions =>
      _$this._allowedActions ??= ListBuilder<TaxAdjustmentAllowedActionsEnum>();
  set allowedActions(
          ListBuilder<TaxAdjustmentAllowedActionsEnum>? allowedActions) =>
      _$this._allowedActions = allowedActions;

  String? _separationNote;
  String? get separationNote => _$this._separationNote;
  set separationNote(String? separationNote) =>
      _$this._separationNote = separationNote;

  TaxAdjustmentBuilder() {
    TaxAdjustment._defaults(this);
  }

  TaxAdjustmentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _kind = $v.kind;
      _state = $v.state;
      _environment = $v.environment;
      _openedBy = $v.openedBy;
      _orderReference = $v.orderReference;
      _vendorName = $v.vendorName;
      _originalRecordType = $v.originalRecordType;
      _originalRecordId = $v.originalRecordId;
      _periodStart = $v.periodStart;
      _periodEnd = $v.periodEnd;
      _amountCentavos = $v.amountCentavos;
      _beforeValues = $v.beforeValues.toBuilder();
      _afterValues = $v.afterValues.toBuilder();
      _reason = $v.reason;
      _preparer = $v.preparer;
      _reviewer = $v.reviewer;
      _reviewedAt = $v.reviewedAt;
      _postedAt = $v.postedAt;
      _createdAt = $v.createdAt;
      _allowedActions = $v.allowedActions.toBuilder();
      _separationNote = $v.separationNote;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TaxAdjustment other) {
    _$v = other as _$TaxAdjustment;
  }

  @override
  void update(void Function(TaxAdjustmentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TaxAdjustment build() => _build();

  _$TaxAdjustment _build() {
    _$TaxAdjustment _$result;
    try {
      _$result = _$v ??
          _$TaxAdjustment._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'TaxAdjustment', 'id'),
            kind: BuiltValueNullFieldError.checkNotNull(
                kind, r'TaxAdjustment', 'kind'),
            state: BuiltValueNullFieldError.checkNotNull(
                state, r'TaxAdjustment', 'state'),
            environment: BuiltValueNullFieldError.checkNotNull(
                environment, r'TaxAdjustment', 'environment'),
            openedBy: BuiltValueNullFieldError.checkNotNull(
                openedBy, r'TaxAdjustment', 'openedBy'),
            orderReference: orderReference,
            vendorName: vendorName,
            originalRecordType: BuiltValueNullFieldError.checkNotNull(
                originalRecordType, r'TaxAdjustment', 'originalRecordType'),
            originalRecordId: BuiltValueNullFieldError.checkNotNull(
                originalRecordId, r'TaxAdjustment', 'originalRecordId'),
            periodStart: BuiltValueNullFieldError.checkNotNull(
                periodStart, r'TaxAdjustment', 'periodStart'),
            periodEnd: BuiltValueNullFieldError.checkNotNull(
                periodEnd, r'TaxAdjustment', 'periodEnd'),
            amountCentavos: BuiltValueNullFieldError.checkNotNull(
                amountCentavos, r'TaxAdjustment', 'amountCentavos'),
            beforeValues: beforeValues.build(),
            afterValues: afterValues.build(),
            reason: BuiltValueNullFieldError.checkNotNull(
                reason, r'TaxAdjustment', 'reason'),
            preparer: preparer,
            reviewer: reviewer,
            reviewedAt: reviewedAt,
            postedAt: postedAt,
            createdAt: createdAt,
            allowedActions: allowedActions.build(),
            separationNote: separationNote,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'beforeValues';
        beforeValues.build();
        _$failedField = 'afterValues';
        afterValues.build();

        _$failedField = 'allowedActions';
        allowedActions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TaxAdjustment', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
