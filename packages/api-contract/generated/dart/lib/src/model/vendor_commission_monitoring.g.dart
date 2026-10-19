// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_commission_monitoring.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorCommissionMonitoring extends VendorCommissionMonitoring {
  @override
  final bool termsAccepted;
  @override
  final CommissionPolicy? currentPolicy;
  @override
  final CommissionPolicy? nextPolicy;
  @override
  final VendorCommissionSummary summary;
  @override
  final BuiltList<VendorCommissionAssessment> assessments;

  factory _$VendorCommissionMonitoring(
          [void Function(VendorCommissionMonitoringBuilder)? updates]) =>
      (VendorCommissionMonitoringBuilder()..update(updates))._build();

  _$VendorCommissionMonitoring._(
      {required this.termsAccepted,
      this.currentPolicy,
      this.nextPolicy,
      required this.summary,
      required this.assessments})
      : super._();
  @override
  VendorCommissionMonitoring rebuild(
          void Function(VendorCommissionMonitoringBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorCommissionMonitoringBuilder toBuilder() =>
      VendorCommissionMonitoringBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorCommissionMonitoring &&
        termsAccepted == other.termsAccepted &&
        currentPolicy == other.currentPolicy &&
        nextPolicy == other.nextPolicy &&
        summary == other.summary &&
        assessments == other.assessments;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, termsAccepted.hashCode);
    _$hash = $jc(_$hash, currentPolicy.hashCode);
    _$hash = $jc(_$hash, nextPolicy.hashCode);
    _$hash = $jc(_$hash, summary.hashCode);
    _$hash = $jc(_$hash, assessments.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorCommissionMonitoring')
          ..add('termsAccepted', termsAccepted)
          ..add('currentPolicy', currentPolicy)
          ..add('nextPolicy', nextPolicy)
          ..add('summary', summary)
          ..add('assessments', assessments))
        .toString();
  }
}

class VendorCommissionMonitoringBuilder
    implements
        Builder<VendorCommissionMonitoring, VendorCommissionMonitoringBuilder> {
  _$VendorCommissionMonitoring? _$v;

  bool? _termsAccepted;
  bool? get termsAccepted => _$this._termsAccepted;
  set termsAccepted(bool? termsAccepted) =>
      _$this._termsAccepted = termsAccepted;

  CommissionPolicyBuilder? _currentPolicy;
  CommissionPolicyBuilder get currentPolicy =>
      _$this._currentPolicy ??= CommissionPolicyBuilder();
  set currentPolicy(CommissionPolicyBuilder? currentPolicy) =>
      _$this._currentPolicy = currentPolicy;

  CommissionPolicyBuilder? _nextPolicy;
  CommissionPolicyBuilder get nextPolicy =>
      _$this._nextPolicy ??= CommissionPolicyBuilder();
  set nextPolicy(CommissionPolicyBuilder? nextPolicy) =>
      _$this._nextPolicy = nextPolicy;

  VendorCommissionSummaryBuilder? _summary;
  VendorCommissionSummaryBuilder get summary =>
      _$this._summary ??= VendorCommissionSummaryBuilder();
  set summary(VendorCommissionSummaryBuilder? summary) =>
      _$this._summary = summary;

  ListBuilder<VendorCommissionAssessment>? _assessments;
  ListBuilder<VendorCommissionAssessment> get assessments =>
      _$this._assessments ??= ListBuilder<VendorCommissionAssessment>();
  set assessments(ListBuilder<VendorCommissionAssessment>? assessments) =>
      _$this._assessments = assessments;

  VendorCommissionMonitoringBuilder() {
    VendorCommissionMonitoring._defaults(this);
  }

  VendorCommissionMonitoringBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _termsAccepted = $v.termsAccepted;
      _currentPolicy = $v.currentPolicy?.toBuilder();
      _nextPolicy = $v.nextPolicy?.toBuilder();
      _summary = $v.summary.toBuilder();
      _assessments = $v.assessments.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorCommissionMonitoring other) {
    _$v = other as _$VendorCommissionMonitoring;
  }

  @override
  void update(void Function(VendorCommissionMonitoringBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorCommissionMonitoring build() => _build();

  _$VendorCommissionMonitoring _build() {
    _$VendorCommissionMonitoring _$result;
    try {
      _$result = _$v ??
          _$VendorCommissionMonitoring._(
            termsAccepted: BuiltValueNullFieldError.checkNotNull(
                termsAccepted, r'VendorCommissionMonitoring', 'termsAccepted'),
            currentPolicy: _currentPolicy?.build(),
            nextPolicy: _nextPolicy?.build(),
            summary: summary.build(),
            assessments: assessments.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'currentPolicy';
        _currentPolicy?.build();
        _$failedField = 'nextPolicy';
        _nextPolicy?.build();
        _$failedField = 'summary';
        summary.build();
        _$failedField = 'assessments';
        assessments.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorCommissionMonitoring', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
