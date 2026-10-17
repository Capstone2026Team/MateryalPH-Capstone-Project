// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dispute_decision_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminDisputeDecisionRequestOutcomeEnum
    _$adminDisputeDecisionRequestOutcomeEnum_DISMISSED =
    const AdminDisputeDecisionRequestOutcomeEnum._('DISMISSED');
const AdminDisputeDecisionRequestOutcomeEnum
    _$adminDisputeDecisionRequestOutcomeEnum_REPLACEMENT =
    const AdminDisputeDecisionRequestOutcomeEnum._('REPLACEMENT');
const AdminDisputeDecisionRequestOutcomeEnum
    _$adminDisputeDecisionRequestOutcomeEnum_FULL_REFUND =
    const AdminDisputeDecisionRequestOutcomeEnum._('FULL_REFUND');
const AdminDisputeDecisionRequestOutcomeEnum
    _$adminDisputeDecisionRequestOutcomeEnum_PARTIAL_REFUND =
    const AdminDisputeDecisionRequestOutcomeEnum._('PARTIAL_REFUND');
const AdminDisputeDecisionRequestOutcomeEnum
    _$adminDisputeDecisionRequestOutcomeEnum_INCONCLUSIVE =
    const AdminDisputeDecisionRequestOutcomeEnum._('INCONCLUSIVE');

AdminDisputeDecisionRequestOutcomeEnum
    _$adminDisputeDecisionRequestOutcomeEnumValueOf(String name) {
  switch (name) {
    case 'DISMISSED':
      return _$adminDisputeDecisionRequestOutcomeEnum_DISMISSED;
    case 'REPLACEMENT':
      return _$adminDisputeDecisionRequestOutcomeEnum_REPLACEMENT;
    case 'FULL_REFUND':
      return _$adminDisputeDecisionRequestOutcomeEnum_FULL_REFUND;
    case 'PARTIAL_REFUND':
      return _$adminDisputeDecisionRequestOutcomeEnum_PARTIAL_REFUND;
    case 'INCONCLUSIVE':
      return _$adminDisputeDecisionRequestOutcomeEnum_INCONCLUSIVE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDisputeDecisionRequestOutcomeEnum>
    _$adminDisputeDecisionRequestOutcomeEnumValues = BuiltSet<
        AdminDisputeDecisionRequestOutcomeEnum>(const <AdminDisputeDecisionRequestOutcomeEnum>[
  _$adminDisputeDecisionRequestOutcomeEnum_DISMISSED,
  _$adminDisputeDecisionRequestOutcomeEnum_REPLACEMENT,
  _$adminDisputeDecisionRequestOutcomeEnum_FULL_REFUND,
  _$adminDisputeDecisionRequestOutcomeEnum_PARTIAL_REFUND,
  _$adminDisputeDecisionRequestOutcomeEnum_INCONCLUSIVE,
]);

const AdminDisputeDecisionRequestMetricEventEnum
    _$adminDisputeDecisionRequestMetricEventEnum_VALIDATED_DEFECT_RETURN =
    const AdminDisputeDecisionRequestMetricEventEnum._(
        'VALIDATED_DEFECT_RETURN');
const AdminDisputeDecisionRequestMetricEventEnum
    _$adminDisputeDecisionRequestMetricEventEnum_VENDOR_NON_FULFILLMENT =
    const AdminDisputeDecisionRequestMetricEventEnum._(
        'VENDOR_NON_FULFILLMENT');
const AdminDisputeDecisionRequestMetricEventEnum
    _$adminDisputeDecisionRequestMetricEventEnum_MISREPRESENTED_LISTING =
    const AdminDisputeDecisionRequestMetricEventEnum._(
        'MISREPRESENTED_LISTING');

AdminDisputeDecisionRequestMetricEventEnum
    _$adminDisputeDecisionRequestMetricEventEnumValueOf(String name) {
  switch (name) {
    case 'VALIDATED_DEFECT_RETURN':
      return _$adminDisputeDecisionRequestMetricEventEnum_VALIDATED_DEFECT_RETURN;
    case 'VENDOR_NON_FULFILLMENT':
      return _$adminDisputeDecisionRequestMetricEventEnum_VENDOR_NON_FULFILLMENT;
    case 'MISREPRESENTED_LISTING':
      return _$adminDisputeDecisionRequestMetricEventEnum_MISREPRESENTED_LISTING;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDisputeDecisionRequestMetricEventEnum>
    _$adminDisputeDecisionRequestMetricEventEnumValues = BuiltSet<
        AdminDisputeDecisionRequestMetricEventEnum>(const <AdminDisputeDecisionRequestMetricEventEnum>[
  _$adminDisputeDecisionRequestMetricEventEnum_VALIDATED_DEFECT_RETURN,
  _$adminDisputeDecisionRequestMetricEventEnum_VENDOR_NON_FULFILLMENT,
  _$adminDisputeDecisionRequestMetricEventEnum_MISREPRESENTED_LISTING,
]);

Serializer<AdminDisputeDecisionRequestOutcomeEnum>
    _$adminDisputeDecisionRequestOutcomeEnumSerializer =
    _$AdminDisputeDecisionRequestOutcomeEnumSerializer();
Serializer<AdminDisputeDecisionRequestMetricEventEnum>
    _$adminDisputeDecisionRequestMetricEventEnumSerializer =
    _$AdminDisputeDecisionRequestMetricEventEnumSerializer();

class _$AdminDisputeDecisionRequestOutcomeEnumSerializer
    implements PrimitiveSerializer<AdminDisputeDecisionRequestOutcomeEnum> {
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
    AdminDisputeDecisionRequestOutcomeEnum
  ];
  @override
  final String wireName = 'AdminDisputeDecisionRequestOutcomeEnum';

  @override
  Object serialize(Serializers serializers,
          AdminDisputeDecisionRequestOutcomeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminDisputeDecisionRequestOutcomeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminDisputeDecisionRequestOutcomeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminDisputeDecisionRequestMetricEventEnumSerializer
    implements PrimitiveSerializer<AdminDisputeDecisionRequestMetricEventEnum> {
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
    AdminDisputeDecisionRequestMetricEventEnum
  ];
  @override
  final String wireName = 'AdminDisputeDecisionRequestMetricEventEnum';

  @override
  Object serialize(Serializers serializers,
          AdminDisputeDecisionRequestMetricEventEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminDisputeDecisionRequestMetricEventEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminDisputeDecisionRequestMetricEventEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminDisputeDecisionRequest extends AdminDisputeDecisionRequest {
  @override
  final AdminDisputeDecisionRequestOutcomeEnum outcome;
  @override
  final String reason;
  @override
  final int? amountCentavos;
  @override
  final BuiltList<String>? affectedLineIds;
  @override
  final bool enforceable;
  @override
  final bool conflictCheckConfirmed;
  @override
  final String? evidenceLimitation;
  @override
  final BuiltList<DisputeSanctionInput>? sanctions;
  @override
  final AdminDisputeDecisionRequestMetricEventEnum? metricEvent;
  @override
  final int lockVersion;

  factory _$AdminDisputeDecisionRequest(
          [void Function(AdminDisputeDecisionRequestBuilder)? updates]) =>
      (AdminDisputeDecisionRequestBuilder()..update(updates))._build();

  _$AdminDisputeDecisionRequest._(
      {required this.outcome,
      required this.reason,
      this.amountCentavos,
      this.affectedLineIds,
      required this.enforceable,
      required this.conflictCheckConfirmed,
      this.evidenceLimitation,
      this.sanctions,
      this.metricEvent,
      required this.lockVersion})
      : super._();
  @override
  AdminDisputeDecisionRequest rebuild(
          void Function(AdminDisputeDecisionRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDisputeDecisionRequestBuilder toBuilder() =>
      AdminDisputeDecisionRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDisputeDecisionRequest &&
        outcome == other.outcome &&
        reason == other.reason &&
        amountCentavos == other.amountCentavos &&
        affectedLineIds == other.affectedLineIds &&
        enforceable == other.enforceable &&
        conflictCheckConfirmed == other.conflictCheckConfirmed &&
        evidenceLimitation == other.evidenceLimitation &&
        sanctions == other.sanctions &&
        metricEvent == other.metricEvent &&
        lockVersion == other.lockVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, outcome.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, amountCentavos.hashCode);
    _$hash = $jc(_$hash, affectedLineIds.hashCode);
    _$hash = $jc(_$hash, enforceable.hashCode);
    _$hash = $jc(_$hash, conflictCheckConfirmed.hashCode);
    _$hash = $jc(_$hash, evidenceLimitation.hashCode);
    _$hash = $jc(_$hash, sanctions.hashCode);
    _$hash = $jc(_$hash, metricEvent.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDisputeDecisionRequest')
          ..add('outcome', outcome)
          ..add('reason', reason)
          ..add('amountCentavos', amountCentavos)
          ..add('affectedLineIds', affectedLineIds)
          ..add('enforceable', enforceable)
          ..add('conflictCheckConfirmed', conflictCheckConfirmed)
          ..add('evidenceLimitation', evidenceLimitation)
          ..add('sanctions', sanctions)
          ..add('metricEvent', metricEvent)
          ..add('lockVersion', lockVersion))
        .toString();
  }
}

class AdminDisputeDecisionRequestBuilder
    implements
        Builder<AdminDisputeDecisionRequest,
            AdminDisputeDecisionRequestBuilder> {
  _$AdminDisputeDecisionRequest? _$v;

  AdminDisputeDecisionRequestOutcomeEnum? _outcome;
  AdminDisputeDecisionRequestOutcomeEnum? get outcome => _$this._outcome;
  set outcome(AdminDisputeDecisionRequestOutcomeEnum? outcome) =>
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

  bool? _enforceable;
  bool? get enforceable => _$this._enforceable;
  set enforceable(bool? enforceable) => _$this._enforceable = enforceable;

  bool? _conflictCheckConfirmed;
  bool? get conflictCheckConfirmed => _$this._conflictCheckConfirmed;
  set conflictCheckConfirmed(bool? conflictCheckConfirmed) =>
      _$this._conflictCheckConfirmed = conflictCheckConfirmed;

  String? _evidenceLimitation;
  String? get evidenceLimitation => _$this._evidenceLimitation;
  set evidenceLimitation(String? evidenceLimitation) =>
      _$this._evidenceLimitation = evidenceLimitation;

  ListBuilder<DisputeSanctionInput>? _sanctions;
  ListBuilder<DisputeSanctionInput> get sanctions =>
      _$this._sanctions ??= ListBuilder<DisputeSanctionInput>();
  set sanctions(ListBuilder<DisputeSanctionInput>? sanctions) =>
      _$this._sanctions = sanctions;

  AdminDisputeDecisionRequestMetricEventEnum? _metricEvent;
  AdminDisputeDecisionRequestMetricEventEnum? get metricEvent =>
      _$this._metricEvent;
  set metricEvent(AdminDisputeDecisionRequestMetricEventEnum? metricEvent) =>
      _$this._metricEvent = metricEvent;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  AdminDisputeDecisionRequestBuilder() {
    AdminDisputeDecisionRequest._defaults(this);
  }

  AdminDisputeDecisionRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _outcome = $v.outcome;
      _reason = $v.reason;
      _amountCentavos = $v.amountCentavos;
      _affectedLineIds = $v.affectedLineIds?.toBuilder();
      _enforceable = $v.enforceable;
      _conflictCheckConfirmed = $v.conflictCheckConfirmed;
      _evidenceLimitation = $v.evidenceLimitation;
      _sanctions = $v.sanctions?.toBuilder();
      _metricEvent = $v.metricEvent;
      _lockVersion = $v.lockVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDisputeDecisionRequest other) {
    _$v = other as _$AdminDisputeDecisionRequest;
  }

  @override
  void update(void Function(AdminDisputeDecisionRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDisputeDecisionRequest build() => _build();

  _$AdminDisputeDecisionRequest _build() {
    _$AdminDisputeDecisionRequest _$result;
    try {
      _$result = _$v ??
          _$AdminDisputeDecisionRequest._(
            outcome: BuiltValueNullFieldError.checkNotNull(
                outcome, r'AdminDisputeDecisionRequest', 'outcome'),
            reason: BuiltValueNullFieldError.checkNotNull(
                reason, r'AdminDisputeDecisionRequest', 'reason'),
            amountCentavos: amountCentavos,
            affectedLineIds: _affectedLineIds?.build(),
            enforceable: BuiltValueNullFieldError.checkNotNull(
                enforceable, r'AdminDisputeDecisionRequest', 'enforceable'),
            conflictCheckConfirmed: BuiltValueNullFieldError.checkNotNull(
                conflictCheckConfirmed,
                r'AdminDisputeDecisionRequest',
                'conflictCheckConfirmed'),
            evidenceLimitation: evidenceLimitation,
            sanctions: _sanctions?.build(),
            metricEvent: metricEvent,
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'AdminDisputeDecisionRequest', 'lockVersion'),
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
            r'AdminDisputeDecisionRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
