// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remittance_queue_row.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RemittanceQueueRow extends RemittanceQueueRow {
  @override
  final String id;
  @override
  final String orderReference;
  @override
  final String vendorName;
  @override
  final String environment;
  @override
  final String taxpayerKeySuffix;
  @override
  final String? scenario;
  @override
  final BuiltMap<String, JsonObject?> components;
  @override
  final String? thresholdStatusBefore;
  @override
  final String? thresholdStatusAfter;
  @override
  final int? gEffectiveBeforeCentavos;
  @override
  final int? gEffectiveAfterCentavos;
  @override
  final String calculationState;
  @override
  final String deductionEvidenceState;
  @override
  final String reconciliationState;
  @override
  final String? reviewItemId;
  @override
  final String reason;
  @override
  final DateTime createdAt;

  factory _$RemittanceQueueRow(
          [void Function(RemittanceQueueRowBuilder)? updates]) =>
      (RemittanceQueueRowBuilder()..update(updates))._build();

  _$RemittanceQueueRow._(
      {required this.id,
      required this.orderReference,
      required this.vendorName,
      required this.environment,
      required this.taxpayerKeySuffix,
      this.scenario,
      required this.components,
      this.thresholdStatusBefore,
      this.thresholdStatusAfter,
      this.gEffectiveBeforeCentavos,
      this.gEffectiveAfterCentavos,
      required this.calculationState,
      required this.deductionEvidenceState,
      required this.reconciliationState,
      this.reviewItemId,
      required this.reason,
      required this.createdAt})
      : super._();
  @override
  RemittanceQueueRow rebuild(
          void Function(RemittanceQueueRowBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RemittanceQueueRowBuilder toBuilder() =>
      RemittanceQueueRowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RemittanceQueueRow &&
        id == other.id &&
        orderReference == other.orderReference &&
        vendorName == other.vendorName &&
        environment == other.environment &&
        taxpayerKeySuffix == other.taxpayerKeySuffix &&
        scenario == other.scenario &&
        components == other.components &&
        thresholdStatusBefore == other.thresholdStatusBefore &&
        thresholdStatusAfter == other.thresholdStatusAfter &&
        gEffectiveBeforeCentavos == other.gEffectiveBeforeCentavos &&
        gEffectiveAfterCentavos == other.gEffectiveAfterCentavos &&
        calculationState == other.calculationState &&
        deductionEvidenceState == other.deductionEvidenceState &&
        reconciliationState == other.reconciliationState &&
        reviewItemId == other.reviewItemId &&
        reason == other.reason &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, orderReference.hashCode);
    _$hash = $jc(_$hash, vendorName.hashCode);
    _$hash = $jc(_$hash, environment.hashCode);
    _$hash = $jc(_$hash, taxpayerKeySuffix.hashCode);
    _$hash = $jc(_$hash, scenario.hashCode);
    _$hash = $jc(_$hash, components.hashCode);
    _$hash = $jc(_$hash, thresholdStatusBefore.hashCode);
    _$hash = $jc(_$hash, thresholdStatusAfter.hashCode);
    _$hash = $jc(_$hash, gEffectiveBeforeCentavos.hashCode);
    _$hash = $jc(_$hash, gEffectiveAfterCentavos.hashCode);
    _$hash = $jc(_$hash, calculationState.hashCode);
    _$hash = $jc(_$hash, deductionEvidenceState.hashCode);
    _$hash = $jc(_$hash, reconciliationState.hashCode);
    _$hash = $jc(_$hash, reviewItemId.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RemittanceQueueRow')
          ..add('id', id)
          ..add('orderReference', orderReference)
          ..add('vendorName', vendorName)
          ..add('environment', environment)
          ..add('taxpayerKeySuffix', taxpayerKeySuffix)
          ..add('scenario', scenario)
          ..add('components', components)
          ..add('thresholdStatusBefore', thresholdStatusBefore)
          ..add('thresholdStatusAfter', thresholdStatusAfter)
          ..add('gEffectiveBeforeCentavos', gEffectiveBeforeCentavos)
          ..add('gEffectiveAfterCentavos', gEffectiveAfterCentavos)
          ..add('calculationState', calculationState)
          ..add('deductionEvidenceState', deductionEvidenceState)
          ..add('reconciliationState', reconciliationState)
          ..add('reviewItemId', reviewItemId)
          ..add('reason', reason)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class RemittanceQueueRowBuilder
    implements Builder<RemittanceQueueRow, RemittanceQueueRowBuilder> {
  _$RemittanceQueueRow? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _orderReference;
  String? get orderReference => _$this._orderReference;
  set orderReference(String? orderReference) =>
      _$this._orderReference = orderReference;

  String? _vendorName;
  String? get vendorName => _$this._vendorName;
  set vendorName(String? vendorName) => _$this._vendorName = vendorName;

  String? _environment;
  String? get environment => _$this._environment;
  set environment(String? environment) => _$this._environment = environment;

  String? _taxpayerKeySuffix;
  String? get taxpayerKeySuffix => _$this._taxpayerKeySuffix;
  set taxpayerKeySuffix(String? taxpayerKeySuffix) =>
      _$this._taxpayerKeySuffix = taxpayerKeySuffix;

  String? _scenario;
  String? get scenario => _$this._scenario;
  set scenario(String? scenario) => _$this._scenario = scenario;

  MapBuilder<String, JsonObject?>? _components;
  MapBuilder<String, JsonObject?> get components =>
      _$this._components ??= MapBuilder<String, JsonObject?>();
  set components(MapBuilder<String, JsonObject?>? components) =>
      _$this._components = components;

  String? _thresholdStatusBefore;
  String? get thresholdStatusBefore => _$this._thresholdStatusBefore;
  set thresholdStatusBefore(String? thresholdStatusBefore) =>
      _$this._thresholdStatusBefore = thresholdStatusBefore;

  String? _thresholdStatusAfter;
  String? get thresholdStatusAfter => _$this._thresholdStatusAfter;
  set thresholdStatusAfter(String? thresholdStatusAfter) =>
      _$this._thresholdStatusAfter = thresholdStatusAfter;

  int? _gEffectiveBeforeCentavos;
  int? get gEffectiveBeforeCentavos => _$this._gEffectiveBeforeCentavos;
  set gEffectiveBeforeCentavos(int? gEffectiveBeforeCentavos) =>
      _$this._gEffectiveBeforeCentavos = gEffectiveBeforeCentavos;

  int? _gEffectiveAfterCentavos;
  int? get gEffectiveAfterCentavos => _$this._gEffectiveAfterCentavos;
  set gEffectiveAfterCentavos(int? gEffectiveAfterCentavos) =>
      _$this._gEffectiveAfterCentavos = gEffectiveAfterCentavos;

  String? _calculationState;
  String? get calculationState => _$this._calculationState;
  set calculationState(String? calculationState) =>
      _$this._calculationState = calculationState;

  String? _deductionEvidenceState;
  String? get deductionEvidenceState => _$this._deductionEvidenceState;
  set deductionEvidenceState(String? deductionEvidenceState) =>
      _$this._deductionEvidenceState = deductionEvidenceState;

  String? _reconciliationState;
  String? get reconciliationState => _$this._reconciliationState;
  set reconciliationState(String? reconciliationState) =>
      _$this._reconciliationState = reconciliationState;

  String? _reviewItemId;
  String? get reviewItemId => _$this._reviewItemId;
  set reviewItemId(String? reviewItemId) => _$this._reviewItemId = reviewItemId;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  RemittanceQueueRowBuilder() {
    RemittanceQueueRow._defaults(this);
  }

  RemittanceQueueRowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _orderReference = $v.orderReference;
      _vendorName = $v.vendorName;
      _environment = $v.environment;
      _taxpayerKeySuffix = $v.taxpayerKeySuffix;
      _scenario = $v.scenario;
      _components = $v.components.toBuilder();
      _thresholdStatusBefore = $v.thresholdStatusBefore;
      _thresholdStatusAfter = $v.thresholdStatusAfter;
      _gEffectiveBeforeCentavos = $v.gEffectiveBeforeCentavos;
      _gEffectiveAfterCentavos = $v.gEffectiveAfterCentavos;
      _calculationState = $v.calculationState;
      _deductionEvidenceState = $v.deductionEvidenceState;
      _reconciliationState = $v.reconciliationState;
      _reviewItemId = $v.reviewItemId;
      _reason = $v.reason;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RemittanceQueueRow other) {
    _$v = other as _$RemittanceQueueRow;
  }

  @override
  void update(void Function(RemittanceQueueRowBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RemittanceQueueRow build() => _build();

  _$RemittanceQueueRow _build() {
    _$RemittanceQueueRow _$result;
    try {
      _$result = _$v ??
          _$RemittanceQueueRow._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'RemittanceQueueRow', 'id'),
            orderReference: BuiltValueNullFieldError.checkNotNull(
                orderReference, r'RemittanceQueueRow', 'orderReference'),
            vendorName: BuiltValueNullFieldError.checkNotNull(
                vendorName, r'RemittanceQueueRow', 'vendorName'),
            environment: BuiltValueNullFieldError.checkNotNull(
                environment, r'RemittanceQueueRow', 'environment'),
            taxpayerKeySuffix: BuiltValueNullFieldError.checkNotNull(
                taxpayerKeySuffix, r'RemittanceQueueRow', 'taxpayerKeySuffix'),
            scenario: scenario,
            components: components.build(),
            thresholdStatusBefore: thresholdStatusBefore,
            thresholdStatusAfter: thresholdStatusAfter,
            gEffectiveBeforeCentavos: gEffectiveBeforeCentavos,
            gEffectiveAfterCentavos: gEffectiveAfterCentavos,
            calculationState: BuiltValueNullFieldError.checkNotNull(
                calculationState, r'RemittanceQueueRow', 'calculationState'),
            deductionEvidenceState: BuiltValueNullFieldError.checkNotNull(
                deductionEvidenceState,
                r'RemittanceQueueRow',
                'deductionEvidenceState'),
            reconciliationState: BuiltValueNullFieldError.checkNotNull(
                reconciliationState,
                r'RemittanceQueueRow',
                'reconciliationState'),
            reviewItemId: reviewItemId,
            reason: BuiltValueNullFieldError.checkNotNull(
                reason, r'RemittanceQueueRow', 'reason'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'RemittanceQueueRow', 'createdAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'components';
        components.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RemittanceQueueRow', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
