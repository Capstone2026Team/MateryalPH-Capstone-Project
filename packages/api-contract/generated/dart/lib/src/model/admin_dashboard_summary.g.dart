// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardSummary extends AdminDashboardSummary {
  @override
  final DateTime generatedAt;
  @override
  final int? activeVendors;
  @override
  final int? inactiveVendors;
  @override
  final int? activeBuyers;
  @override
  final int? pendingDocumentReviews;
  @override
  final int? auditEvents;
  @override
  final bool canViewAudit;

  factory _$AdminDashboardSummary(
          [void Function(AdminDashboardSummaryBuilder)? updates]) =>
      (AdminDashboardSummaryBuilder()..update(updates))._build();

  _$AdminDashboardSummary._(
      {required this.generatedAt,
      this.activeVendors,
      this.inactiveVendors,
      this.activeBuyers,
      this.pendingDocumentReviews,
      this.auditEvents,
      required this.canViewAudit})
      : super._();
  @override
  AdminDashboardSummary rebuild(
          void Function(AdminDashboardSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDashboardSummaryBuilder toBuilder() =>
      AdminDashboardSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardSummary &&
        generatedAt == other.generatedAt &&
        activeVendors == other.activeVendors &&
        inactiveVendors == other.inactiveVendors &&
        activeBuyers == other.activeBuyers &&
        pendingDocumentReviews == other.pendingDocumentReviews &&
        auditEvents == other.auditEvents &&
        canViewAudit == other.canViewAudit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, generatedAt.hashCode);
    _$hash = $jc(_$hash, activeVendors.hashCode);
    _$hash = $jc(_$hash, inactiveVendors.hashCode);
    _$hash = $jc(_$hash, activeBuyers.hashCode);
    _$hash = $jc(_$hash, pendingDocumentReviews.hashCode);
    _$hash = $jc(_$hash, auditEvents.hashCode);
    _$hash = $jc(_$hash, canViewAudit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboardSummary')
          ..add('generatedAt', generatedAt)
          ..add('activeVendors', activeVendors)
          ..add('inactiveVendors', inactiveVendors)
          ..add('activeBuyers', activeBuyers)
          ..add('pendingDocumentReviews', pendingDocumentReviews)
          ..add('auditEvents', auditEvents)
          ..add('canViewAudit', canViewAudit))
        .toString();
  }
}

class AdminDashboardSummaryBuilder
    implements Builder<AdminDashboardSummary, AdminDashboardSummaryBuilder> {
  _$AdminDashboardSummary? _$v;

  DateTime? _generatedAt;
  DateTime? get generatedAt => _$this._generatedAt;
  set generatedAt(DateTime? generatedAt) => _$this._generatedAt = generatedAt;

  int? _activeVendors;
  int? get activeVendors => _$this._activeVendors;
  set activeVendors(int? activeVendors) =>
      _$this._activeVendors = activeVendors;

  int? _inactiveVendors;
  int? get inactiveVendors => _$this._inactiveVendors;
  set inactiveVendors(int? inactiveVendors) =>
      _$this._inactiveVendors = inactiveVendors;

  int? _activeBuyers;
  int? get activeBuyers => _$this._activeBuyers;
  set activeBuyers(int? activeBuyers) => _$this._activeBuyers = activeBuyers;

  int? _pendingDocumentReviews;
  int? get pendingDocumentReviews => _$this._pendingDocumentReviews;
  set pendingDocumentReviews(int? pendingDocumentReviews) =>
      _$this._pendingDocumentReviews = pendingDocumentReviews;

  int? _auditEvents;
  int? get auditEvents => _$this._auditEvents;
  set auditEvents(int? auditEvents) => _$this._auditEvents = auditEvents;

  bool? _canViewAudit;
  bool? get canViewAudit => _$this._canViewAudit;
  set canViewAudit(bool? canViewAudit) => _$this._canViewAudit = canViewAudit;

  AdminDashboardSummaryBuilder() {
    AdminDashboardSummary._defaults(this);
  }

  AdminDashboardSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _generatedAt = $v.generatedAt;
      _activeVendors = $v.activeVendors;
      _inactiveVendors = $v.inactiveVendors;
      _activeBuyers = $v.activeBuyers;
      _pendingDocumentReviews = $v.pendingDocumentReviews;
      _auditEvents = $v.auditEvents;
      _canViewAudit = $v.canViewAudit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardSummary other) {
    _$v = other as _$AdminDashboardSummary;
  }

  @override
  void update(void Function(AdminDashboardSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardSummary build() => _build();

  _$AdminDashboardSummary _build() {
    final _$result = _$v ??
        _$AdminDashboardSummary._(
          generatedAt: BuiltValueNullFieldError.checkNotNull(
              generatedAt, r'AdminDashboardSummary', 'generatedAt'),
          activeVendors: activeVendors,
          inactiveVendors: inactiveVendors,
          activeBuyers: activeBuyers,
          pendingDocumentReviews: pendingDocumentReviews,
          auditEvents: auditEvents,
          canViewAudit: BuiltValueNullFieldError.checkNotNull(
              canViewAudit, r'AdminDashboardSummary', 'canViewAudit'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
