// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dispute_appeal_decision_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminDisputeAppealDecisionRequestResultEnum
    _$adminDisputeAppealDecisionRequestResultEnum_AFFIRMED =
    const AdminDisputeAppealDecisionRequestResultEnum._('AFFIRMED');
const AdminDisputeAppealDecisionRequestResultEnum
    _$adminDisputeAppealDecisionRequestResultEnum_MODIFIED =
    const AdminDisputeAppealDecisionRequestResultEnum._('MODIFIED');
const AdminDisputeAppealDecisionRequestResultEnum
    _$adminDisputeAppealDecisionRequestResultEnum_REVERSED =
    const AdminDisputeAppealDecisionRequestResultEnum._('REVERSED');

AdminDisputeAppealDecisionRequestResultEnum
    _$adminDisputeAppealDecisionRequestResultEnumValueOf(String name) {
  switch (name) {
    case 'AFFIRMED':
      return _$adminDisputeAppealDecisionRequestResultEnum_AFFIRMED;
    case 'MODIFIED':
      return _$adminDisputeAppealDecisionRequestResultEnum_MODIFIED;
    case 'REVERSED':
      return _$adminDisputeAppealDecisionRequestResultEnum_REVERSED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDisputeAppealDecisionRequestResultEnum>
    _$adminDisputeAppealDecisionRequestResultEnumValues = BuiltSet<
        AdminDisputeAppealDecisionRequestResultEnum>(const <AdminDisputeAppealDecisionRequestResultEnum>[
  _$adminDisputeAppealDecisionRequestResultEnum_AFFIRMED,
  _$adminDisputeAppealDecisionRequestResultEnum_MODIFIED,
  _$adminDisputeAppealDecisionRequestResultEnum_REVERSED,
]);

const AdminDisputeAppealDecisionRequestOutcomeEnum
    _$adminDisputeAppealDecisionRequestOutcomeEnum_DISMISSED =
    const AdminDisputeAppealDecisionRequestOutcomeEnum._('DISMISSED');
const AdminDisputeAppealDecisionRequestOutcomeEnum
    _$adminDisputeAppealDecisionRequestOutcomeEnum_REPLACEMENT =
    const AdminDisputeAppealDecisionRequestOutcomeEnum._('REPLACEMENT');
const AdminDisputeAppealDecisionRequestOutcomeEnum
    _$adminDisputeAppealDecisionRequestOutcomeEnum_FULL_REFUND =
    const AdminDisputeAppealDecisionRequestOutcomeEnum._('FULL_REFUND');
const AdminDisputeAppealDecisionRequestOutcomeEnum
    _$adminDisputeAppealDecisionRequestOutcomeEnum_PARTIAL_REFUND =
    const AdminDisputeAppealDecisionRequestOutcomeEnum._('PARTIAL_REFUND');
const AdminDisputeAppealDecisionRequestOutcomeEnum
    _$adminDisputeAppealDecisionRequestOutcomeEnum_INCONCLUSIVE =
    const AdminDisputeAppealDecisionRequestOutcomeEnum._('INCONCLUSIVE');

AdminDisputeAppealDecisionRequestOutcomeEnum
    _$adminDisputeAppealDecisionRequestOutcomeEnumValueOf(String name) {
  switch (name) {
    case 'DISMISSED':
      return _$adminDisputeAppealDecisionRequestOutcomeEnum_DISMISSED;
    case 'REPLACEMENT':
      return _$adminDisputeAppealDecisionRequestOutcomeEnum_REPLACEMENT;
    case 'FULL_REFUND':
      return _$adminDisputeAppealDecisionRequestOutcomeEnum_FULL_REFUND;
    case 'PARTIAL_REFUND':
      return _$adminDisputeAppealDecisionRequestOutcomeEnum_PARTIAL_REFUND;
    case 'INCONCLUSIVE':
      return _$adminDisputeAppealDecisionRequestOutcomeEnum_INCONCLUSIVE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDisputeAppealDecisionRequestOutcomeEnum>
    _$adminDisputeAppealDecisionRequestOutcomeEnumValues = BuiltSet<
        AdminDisputeAppealDecisionRequestOutcomeEnum>(const <AdminDisputeAppealDecisionRequestOutcomeEnum>[
  _$adminDisputeAppealDecisionRequestOutcomeEnum_DISMISSED,
  _$adminDisputeAppealDecisionRequestOutcomeEnum_REPLACEMENT,
  _$adminDisputeAppealDecisionRequestOutcomeEnum_FULL_REFUND,
  _$adminDisputeAppealDecisionRequestOutcomeEnum_PARTIAL_REFUND,
  _$adminDisputeAppealDecisionRequestOutcomeEnum_INCONCLUSIVE,
]);

const AdminDisputeAppealDecisionRequestMetricEventEnum
    _$adminDisputeAppealDecisionRequestMetricEventEnum_VALIDATED_DEFECT_RETURN =
    const AdminDisputeAppealDecisionRequestMetricEventEnum._(
        'VALIDATED_DEFECT_RETURN');
const AdminDisputeAppealDecisionRequestMetricEventEnum
    _$adminDisputeAppealDecisionRequestMetricEventEnum_VENDOR_NON_FULFILLMENT =
    const AdminDisputeAppealDecisionRequestMetricEventEnum._(
        'VENDOR_NON_FULFILLMENT');
const AdminDisputeAppealDecisionRequestMetricEventEnum
    _$adminDisputeAppealDecisionRequestMetricEventEnum_MISREPRESENTED_LISTING =
    const AdminDisputeAppealDecisionRequestMetricEventEnum._(
        'MISREPRESENTED_LISTING');

AdminDisputeAppealDecisionRequestMetricEventEnum
    _$adminDisputeAppealDecisionRequestMetricEventEnumValueOf(String name) {
  switch (name) {
    case 'VALIDATED_DEFECT_RETURN':
      return _$adminDisputeAppealDecisionRequestMetricEventEnum_VALIDATED_DEFECT_RETURN;
    case 'VENDOR_NON_FULFILLMENT':
      return _$adminDisputeAppealDecisionRequestMetricEventEnum_VENDOR_NON_FULFILLMENT;
    case 'MISREPRESENTED_LISTING':
      return _$adminDisputeAppealDecisionRequestMetricEventEnum_MISREPRESENTED_LISTING;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDisputeAppealDecisionRequestMetricEventEnum>
    _$adminDisputeAppealDecisionRequestMetricEventEnumValues = BuiltSet<
        AdminDisputeAppealDecisionRequestMetricEventEnum>(const <AdminDisputeAppealDecisionRequestMetricEventEnum>[
  _$adminDisputeAppealDecisionRequestMetricEventEnum_VALIDATED_DEFECT_RETURN,
  _$adminDisputeAppealDecisionRequestMetricEventEnum_VENDOR_NON_FULFILLMENT,
  _$adminDisputeAppealDecisionRequestMetricEventEnum_MISREPRESENTED_LISTING,
]);

Serializer<AdminDisputeAppealDecisionRequestResultEnum>
    _$adminDisputeAppealDecisionRequestResultEnumSerializer =
    _$AdminDisputeAppealDecisionRequestResultEnumSerializer();
Serializer<AdminDisputeAppealDecisionRequestOutcomeEnum>
    _$adminDisputeAppealDecisionRequestOutcomeEnumSerializer =
    _$AdminDisputeAppealDecisionRequestOutcomeEnumSerializer();
Serializer<AdminDisputeAppealDecisionRequestMetricEventEnum>
    _$adminDisputeAppealDecisionRequestMetricEventEnumSerializer =
    _$AdminDisputeAppealDecisionRequestMetricEventEnumSerializer();

class _$AdminDisputeAppealDecisionRequestResultEnumSerializer
    implements
        PrimitiveSerializer<AdminDisputeAppealDecisionRequestResultEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'AFFIRMED': 'AFFIRMED',
    'MODIFIED': 'MODIFIED',
    'REVERSED': 'REVERSED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'AFFIRMED': 'AFFIRMED',
    'MODIFIED': 'MODIFIED',
    'REVERSED': 'REVERSED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminDisputeAppealDecisionRequestResultEnum
  ];
  @override
  final String wireName = 'AdminDisputeAppealDecisionRequestResultEnum';

  @override
  Object serialize(Serializers serializers,
          AdminDisputeAppealDecisionRequestResultEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminDisputeAppealDecisionRequestResultEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminDisputeAppealDecisionRequestResultEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminDisputeAppealDecisionRequestOutcomeEnumSerializer
    implements
        PrimitiveSerializer<AdminDisputeAppealDecisionRequestOutcomeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DISMISSED': 'DISMISSED',
    'REPLACEMENT': 'REPLACEMENT',
    'FULL_REFUND': 'FULL_REFUND',
    'PARTIAL_REFUND': 'PARTIAL_REFUND',
    'INCONCLUSIVE': 'INCONCLUSIVE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DISMISSED': 'DISMISSED',
    'REPLACEMENT': 'REPLACEMENT',
    'FULL_REFUND': 'FULL_REFUND',
    'PARTIAL_REFUND': 'PARTIAL_REFUND',
    'INCONCLUSIVE': 'INCONCLUSIVE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminDisputeAppealDecisionRequestOutcomeEnum
  ];
  @override
  final String wireName = 'AdminDisputeAppealDecisionRequestOutcomeEnum';

  @override
  Object serialize(Serializers serializers,
          AdminDisputeAppealDecisionRequestOutcomeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminDisputeAppealDecisionRequestOutcomeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminDisputeAppealDecisionRequestOutcomeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminDisputeAppealDecisionRequestMetricEventEnumSerializer
    implements
        PrimitiveSerializer<AdminDisputeAppealDecisionRequestMetricEventEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VALIDATED_DEFECT_RETURN': 'VALIDATED_DEFECT_RETURN',
    'VENDOR_NON_FULFILLMENT': 'VENDOR_NON_FULFILLMENT',
    'MISREPRESENTED_LISTING': 'MISREPRESENTED_LISTING',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VALIDATED_DEFECT_RETURN': 'VALIDATED_DEFECT_RETURN',
    'VENDOR_NON_FULFILLMENT': 'VENDOR_NON_FULFILLMENT',
    'MISREPRESENTED_LISTING': 'MISREPRESENTED_LISTING',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminDisputeAppealDecisionRequestMetricEventEnum
  ];
  @override
  final String wireName = 'AdminDisputeAppealDecisionRequestMetricEventEnum';

  @override
  Object serialize(Serializers serializers,
          AdminDisputeAppealDecisionRequestMetricEventEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminDisputeAppealDecisionRequestMetricEventEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminDisputeAppealDecisionRequestMetricEventEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminDisputeAppealDecisionRequest
    extends AdminDisputeAppealDecisionRequest {
  @override
  final AdminDisputeAppealDecisionRequestResultEnum result;
  @override
  final AdminDisputeAppealDecisionRequestOutcomeEnum? outcome;
  @override
  final String reason;
  @override
  final int? amountCentavos;
  @override
  final BuiltList<String>? affectedLineIds;
  @override
  final bool conflictCheckConfirmed;
  @override
  final BuiltList<DisputeSanctionInput>? sanctions;
  @override
  final AdminDisputeAppealDecisionRequestMetricEventEnum? metricEvent;
  @override
  final int lockVersion;

  factory _$AdminDisputeAppealDecisionRequest(
          [void Function(AdminDisputeAppealDecisionRequestBuilder)? updates]) =>
      (AdminDisputeAppealDecisionRequestBuilder()..update(updates))._build();

  _$AdminDisputeAppealDecisionRequest._(
      {required this.result,
      this.outcome,
      required this.reason,
      this.amountCentavos,
      this.affectedLineIds,
      required this.conflictCheckConfirmed,
      this.sanctions,
      this.metricEvent,
      required this.lockVersion})
      : super._();
  @override
  AdminDisputeAppealDecisionRequest rebuild(
          void Function(AdminDisputeAppealDecisionRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDisputeAppealDecisionRequestBuilder toBuilder() =>
      AdminDisputeAppealDecisionRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDisputeAppealDecisionRequest &&
        result == other.result &&
        outcome == other.outcome &&
        reason == other.reason &&
        amountCentavos == other.amountCentavos &&
        affectedLineIds == other.affectedLineIds &&
        conflictCheckConfirmed == other.conflictCheckConfirmed &&
        sanctions == other.sanctions &&
        metricEvent == other.metricEvent &&
        lockVersion == other.lockVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, result.hashCode);
    _$hash = $jc(_$hash, outcome.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, amountCentavos.hashCode);
    _$hash = $jc(_$hash, affectedLineIds.hashCode);
    _$hash = $jc(_$hash, conflictCheckConfirmed.hashCode);
    _$hash = $jc(_$hash, sanctions.hashCode);
    _$hash = $jc(_$hash, metricEvent.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDisputeAppealDecisionRequest')
          ..add('result', result)
          ..add('outcome', outcome)
          ..add('reason', reason)
          ..add('amountCentavos', amountCentavos)
          ..add('affectedLineIds', affectedLineIds)
          ..add('conflictCheckConfirmed', conflictCheckConfirmed)
          ..add('sanctions', sanctions)
          ..add('metricEvent', metricEvent)
          ..add('lockVersion', lockVersion))
        .toString();
  }
}

class AdminDisputeAppealDecisionRequestBuilder
    implements
        Builder<AdminDisputeAppealDecisionRequest,
            AdminDisputeAppealDecisionRequestBuilder> {
  _$AdminDisputeAppealDecisionRequest? _$v;

  AdminDisputeAppealDecisionRequestResultEnum? _result;
  AdminDisputeAppealDecisionRequestResultEnum? get result => _$this._result;
  set result(AdminDisputeAppealDecisionRequestResultEnum? result) =>
      _$this._result = result;

  AdminDisputeAppealDecisionRequestOutcomeEnum? _outcome;
  AdminDisputeAppealDecisionRequestOutcomeEnum? get outcome => _$this._outcome;
  set outcome(AdminDisputeAppealDecisionRequestOutcomeEnum? outcome) =>
      _$this._outcome = outcome;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  int? _amountCentavos;
  int? get amountCentavos => _$this._amountCentavos;
  set amountCentavos(int? amountCentavos) =>
      _$this._amountCentavos = amountCentavos;

  ListBuilder<String>? _affectedLineIds;
  ListBuilder<String> get affectedLineIds =>
      _$this._affectedLineIds ??= ListBuilder<String>();
  set affectedLineIds(ListBuilder<String>? affectedLineIds) =>
      _$this._affectedLineIds = affectedLineIds;

  bool? _conflictCheckConfirmed;
  bool? get conflictCheckConfirmed => _$this._conflictCheckConfirmed;
  set conflictCheckConfirmed(bool? conflictCheckConfirmed) =>
      _$this._conflictCheckConfirmed = conflictCheckConfirmed;

  ListBuilder<DisputeSanctionInput>? _sanctions;
  ListBuilder<DisputeSanctionInput> get sanctions =>
      _$this._sanctions ??= ListBuilder<DisputeSanctionInput>();
  set sanctions(ListBuilder<DisputeSanctionInput>? sanctions) =>
      _$this._sanctions = sanctions;

  AdminDisputeAppealDecisionRequestMetricEventEnum? _metricEvent;
  AdminDisputeAppealDecisionRequestMetricEventEnum? get metricEvent =>
      _$this._metricEvent;
  set metricEvent(
          AdminDisputeAppealDecisionRequestMetricEventEnum? metricEvent) =>
      _$this._metricEvent = metricEvent;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  AdminDisputeAppealDecisionRequestBuilder() {
    AdminDisputeAppealDecisionRequest._defaults(this);
  }

  AdminDisputeAppealDecisionRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _result = $v.result;
      _outcome = $v.outcome;
      _reason = $v.reason;
      _amountCentavos = $v.amountCentavos;
      _affectedLineIds = $v.affectedLineIds?.toBuilder();
      _conflictCheckConfirmed = $v.conflictCheckConfirmed;
      _sanctions = $v.sanctions?.toBuilder();
      _metricEvent = $v.metricEvent;
      _lockVersion = $v.lockVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDisputeAppealDecisionRequest other) {
    _$v = other as _$AdminDisputeAppealDecisionRequest;
  }

  @override
  void update(
      void Function(AdminDisputeAppealDecisionRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDisputeAppealDecisionRequest build() => _build();

  _$AdminDisputeAppealDecisionRequest _build() {
    _$AdminDisputeAppealDecisionRequest _$result;
    try {
      _$result = _$v ??
          _$AdminDisputeAppealDecisionRequest._(
            result: BuiltValueNullFieldError.checkNotNull(
                result, r'AdminDisputeAppealDecisionRequest', 'result'),
            outcome: outcome,
            reason: BuiltValueNullFieldError.checkNotNull(
                reason, r'AdminDisputeAppealDecisionRequest', 'reason'),
            amountCentavos: amountCentavos,
            affectedLineIds: _affectedLineIds?.build(),
            conflictCheckConfirmed: BuiltValueNullFieldError.checkNotNull(
                conflictCheckConfirmed,
                r'AdminDisputeAppealDecisionRequest',
                'conflictCheckConfirmed'),
            sanctions: _sanctions?.build(),
            metricEvent: metricEvent,
            lockVersion: BuiltValueNullFieldError.checkNotNull(lockVersion,
                r'AdminDisputeAppealDecisionRequest', 'lockVersion'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'affectedLineIds';
        _affectedLineIds?.build();

        _$failedField = 'sanctions';
        _sanctions?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminDisputeAppealDecisionRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
