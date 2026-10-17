// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dashboard_disputes.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorDashboardDisputes extends VendorDashboardDisputes {
  @override
  final int open;
  @override
  final int awaitingResponse;
  @override
  final DateTime? nextResponseDueAt;
  @override
  final int filedInPeriod;
  @override
  final BuiltList<VendorDashboardDisputesSeriesInner> series;
  @override
  final BuiltList<DashboardCount> issueTypes;
  @override
  final BuiltList<DashboardCount> statuses;
  @override
  final int fulfillmentIssues;
  @override
  final int validatedReturns;

  factory _$VendorDashboardDisputes(
          [void Function(VendorDashboardDisputesBuilder)? updates]) =>
      (VendorDashboardDisputesBuilder()..update(updates))._build();

  _$VendorDashboardDisputes._(
      {required this.open,
      required this.awaitingResponse,
      this.nextResponseDueAt,
      required this.filedInPeriod,
      required this.series,
      required this.issueTypes,
      required this.statuses,
      required this.fulfillmentIssues,
      required this.validatedReturns})
      : super._();
  @override
  VendorDashboardDisputes rebuild(
          void Function(VendorDashboardDisputesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorDashboardDisputesBuilder toBuilder() =>
      VendorDashboardDisputesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorDashboardDisputes &&
        open == other.open &&
        awaitingResponse == other.awaitingResponse &&
        nextResponseDueAt == other.nextResponseDueAt &&
        filedInPeriod == other.filedInPeriod &&
        series == other.series &&
        issueTypes == other.issueTypes &&
        statuses == other.statuses &&
        fulfillmentIssues == other.fulfillmentIssues &&
        validatedReturns == other.validatedReturns;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, open.hashCode);
    _$hash = $jc(_$hash, awaitingResponse.hashCode);
    _$hash = $jc(_$hash, nextResponseDueAt.hashCode);
    _$hash = $jc(_$hash, filedInPeriod.hashCode);
    _$hash = $jc(_$hash, series.hashCode);
    _$hash = $jc(_$hash, issueTypes.hashCode);
    _$hash = $jc(_$hash, statuses.hashCode);
    _$hash = $jc(_$hash, fulfillmentIssues.hashCode);
    _$hash = $jc(_$hash, validatedReturns.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorDashboardDisputes')
          ..add('open', open)
          ..add('awaitingResponse', awaitingResponse)
          ..add('nextResponseDueAt', nextResponseDueAt)
          ..add('filedInPeriod', filedInPeriod)
          ..add('series', series)
          ..add('issueTypes', issueTypes)
          ..add('statuses', statuses)
          ..add('fulfillmentIssues', fulfillmentIssues)
          ..add('validatedReturns', validatedReturns))
        .toString();
  }
}

class VendorDashboardDisputesBuilder
    implements
        Builder<VendorDashboardDisputes, VendorDashboardDisputesBuilder> {
  _$VendorDashboardDisputes? _$v;

  int? _open;
  int? get open => _$this._open;
  set open(int? open) => _$this._open = open;

  int? _awaitingResponse;
  int? get awaitingResponse => _$this._awaitingResponse;
  set awaitingResponse(int? awaitingResponse) =>
      _$this._awaitingResponse = awaitingResponse;

  DateTime? _nextResponseDueAt;
  DateTime? get nextResponseDueAt => _$this._nextResponseDueAt;
  set nextResponseDueAt(DateTime? nextResponseDueAt) =>
      _$this._nextResponseDueAt = nextResponseDueAt;

  int? _filedInPeriod;
  int? get filedInPeriod => _$this._filedInPeriod;
  set filedInPeriod(int? filedInPeriod) =>
      _$this._filedInPeriod = filedInPeriod;

  ListBuilder<VendorDashboardDisputesSeriesInner>? _series;
  ListBuilder<VendorDashboardDisputesSeriesInner> get series =>
      _$this._series ??= ListBuilder<VendorDashboardDisputesSeriesInner>();
  set series(ListBuilder<VendorDashboardDisputesSeriesInner>? series) =>
      _$this._series = series;

  ListBuilder<DashboardCount>? _issueTypes;
  ListBuilder<DashboardCount> get issueTypes =>
      _$this._issueTypes ??= ListBuilder<DashboardCount>();
  set issueTypes(ListBuilder<DashboardCount>? issueTypes) =>
      _$this._issueTypes = issueTypes;

  ListBuilder<DashboardCount>? _statuses;
  ListBuilder<DashboardCount> get statuses =>
      _$this._statuses ??= ListBuilder<DashboardCount>();
  set statuses(ListBuilder<DashboardCount>? statuses) =>
      _$this._statuses = statuses;

  int? _fulfillmentIssues;
  int? get fulfillmentIssues => _$this._fulfillmentIssues;
  set fulfillmentIssues(int? fulfillmentIssues) =>
      _$this._fulfillmentIssues = fulfillmentIssues;

  int? _validatedReturns;
  int? get validatedReturns => _$this._validatedReturns;
  set validatedReturns(int? validatedReturns) =>
      _$this._validatedReturns = validatedReturns;

  VendorDashboardDisputesBuilder() {
    VendorDashboardDisputes._defaults(this);
  }

  VendorDashboardDisputesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _open = $v.open;
      _awaitingResponse = $v.awaitingResponse;
      _nextResponseDueAt = $v.nextResponseDueAt;
      _filedInPeriod = $v.filedInPeriod;
      _series = $v.series.toBuilder();
      _issueTypes = $v.issueTypes.toBuilder();
      _statuses = $v.statuses.toBuilder();
      _fulfillmentIssues = $v.fulfillmentIssues;
      _validatedReturns = $v.validatedReturns;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorDashboardDisputes other) {
    _$v = other as _$VendorDashboardDisputes;
  }

  @override
  void update(void Function(VendorDashboardDisputesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorDashboardDisputes build() => _build();

  _$VendorDashboardDisputes _build() {
    _$VendorDashboardDisputes _$result;
    try {
      _$result = _$v ??
          _$VendorDashboardDisputes._(
            open: BuiltValueNullFieldError.checkNotNull(
                open, r'VendorDashboardDisputes', 'open'),
            awaitingResponse: BuiltValueNullFieldError.checkNotNull(
                awaitingResponse,
                r'VendorDashboardDisputes',
                'awaitingResponse'),
            nextResponseDueAt: nextResponseDueAt,
            filedInPeriod: BuiltValueNullFieldError.checkNotNull(
                filedInPeriod, r'VendorDashboardDisputes', 'filedInPeriod'),
            series: series.build(),
            issueTypes: issueTypes.build(),
            statuses: statuses.build(),
            fulfillmentIssues: BuiltValueNullFieldError.checkNotNull(
                fulfillmentIssues,
                r'VendorDashboardDisputes',
                'fulfillmentIssues'),
            validatedReturns: BuiltValueNullFieldError.checkNotNull(
                validatedReturns,
                r'VendorDashboardDisputes',
                'validatedReturns'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'series';
        series.build();
        _$failedField = 'issueTypes';
        issueTypes.build();
        _$failedField = 'statuses';
        statuses.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorDashboardDisputes', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
