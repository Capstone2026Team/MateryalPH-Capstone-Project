// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_operations_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderOperationsSummary extends AdminOrderOperationsSummary {
  @override
  final int refundsFailed;
  @override
  final int refundsPending;
  @override
  final int reimbursementsPending;
  @override
  final int cancellationRequestsOpen;
  @override
  final int nfrEvents30Days;

  factory _$AdminOrderOperationsSummary(
          [void Function(AdminOrderOperationsSummaryBuilder)? updates]) =>
      (AdminOrderOperationsSummaryBuilder()..update(updates))._build();

  _$AdminOrderOperationsSummary._(
      {required this.refundsFailed,
      required this.refundsPending,
      required this.reimbursementsPending,
      required this.cancellationRequestsOpen,
      required this.nfrEvents30Days})
      : super._();
  @override
  AdminOrderOperationsSummary rebuild(
          void Function(AdminOrderOperationsSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminOrderOperationsSummaryBuilder toBuilder() =>
      AdminOrderOperationsSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderOperationsSummary &&
        refundsFailed == other.refundsFailed &&
        refundsPending == other.refundsPending &&
        reimbursementsPending == other.reimbursementsPending &&
        cancellationRequestsOpen == other.cancellationRequestsOpen &&
        nfrEvents30Days == other.nfrEvents30Days;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, refundsFailed.hashCode);
    _$hash = $jc(_$hash, refundsPending.hashCode);
    _$hash = $jc(_$hash, reimbursementsPending.hashCode);
    _$hash = $jc(_$hash, cancellationRequestsOpen.hashCode);
    _$hash = $jc(_$hash, nfrEvents30Days.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOrderOperationsSummary')
          ..add('refundsFailed', refundsFailed)
          ..add('refundsPending', refundsPending)
          ..add('reimbursementsPending', reimbursementsPending)
          ..add('cancellationRequestsOpen', cancellationRequestsOpen)
          ..add('nfrEvents30Days', nfrEvents30Days))
        .toString();
  }
}

class AdminOrderOperationsSummaryBuilder
    implements
        Builder<AdminOrderOperationsSummary,
            AdminOrderOperationsSummaryBuilder> {
  _$AdminOrderOperationsSummary? _$v;

  int? _refundsFailed;
  int? get refundsFailed => _$this._refundsFailed;
  set refundsFailed(int? refundsFailed) =>
      _$this._refundsFailed = refundsFailed;

  int? _refundsPending;
  int? get refundsPending => _$this._refundsPending;
  set refundsPending(int? refundsPending) =>
      _$this._refundsPending = refundsPending;

  int? _reimbursementsPending;
  int? get reimbursementsPending => _$this._reimbursementsPending;
  set reimbursementsPending(int? reimbursementsPending) =>
      _$this._reimbursementsPending = reimbursementsPending;

  int? _cancellationRequestsOpen;
  int? get cancellationRequestsOpen => _$this._cancellationRequestsOpen;
  set cancellationRequestsOpen(int? cancellationRequestsOpen) =>
      _$this._cancellationRequestsOpen = cancellationRequestsOpen;

  int? _nfrEvents30Days;
  int? get nfrEvents30Days => _$this._nfrEvents30Days;
  set nfrEvents30Days(int? nfrEvents30Days) =>
      _$this._nfrEvents30Days = nfrEvents30Days;

  AdminOrderOperationsSummaryBuilder() {
    AdminOrderOperationsSummary._defaults(this);
  }

  AdminOrderOperationsSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _refundsFailed = $v.refundsFailed;
      _refundsPending = $v.refundsPending;
      _reimbursementsPending = $v.reimbursementsPending;
      _cancellationRequestsOpen = $v.cancellationRequestsOpen;
      _nfrEvents30Days = $v.nfrEvents30Days;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderOperationsSummary other) {
    _$v = other as _$AdminOrderOperationsSummary;
  }

  @override
  void update(void Function(AdminOrderOperationsSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderOperationsSummary build() => _build();

  _$AdminOrderOperationsSummary _build() {
    final _$result = _$v ??
        _$AdminOrderOperationsSummary._(
          refundsFailed: BuiltValueNullFieldError.checkNotNull(
              refundsFailed, r'AdminOrderOperationsSummary', 'refundsFailed'),
          refundsPending: BuiltValueNullFieldError.checkNotNull(
              refundsPending, r'AdminOrderOperationsSummary', 'refundsPending'),
          reimbursementsPending: BuiltValueNullFieldError.checkNotNull(
              reimbursementsPending,
              r'AdminOrderOperationsSummary',
              'reimbursementsPending'),
          cancellationRequestsOpen: BuiltValueNullFieldError.checkNotNull(
              cancellationRequestsOpen,
              r'AdminOrderOperationsSummary',
              'cancellationRequestsOpen'),
          nfrEvents30Days: BuiltValueNullFieldError.checkNotNull(
              nfrEvents30Days,
              r'AdminOrderOperationsSummary',
              'nfrEvents30Days'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
