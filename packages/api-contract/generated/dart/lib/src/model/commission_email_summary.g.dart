// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commission_email_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CommissionEmailSummary extends CommissionEmailSummary {
  @override
  final int total;
  @override
  final int sent;
  @override
  final int failed;
  @override
  final int queued;
  @override
  final int blocked;

  factory _$CommissionEmailSummary(
          [void Function(CommissionEmailSummaryBuilder)? updates]) =>
      (CommissionEmailSummaryBuilder()..update(updates))._build();

  _$CommissionEmailSummary._(
      {required this.total,
      required this.sent,
      required this.failed,
      required this.queued,
      required this.blocked})
      : super._();
  @override
  CommissionEmailSummary rebuild(
          void Function(CommissionEmailSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CommissionEmailSummaryBuilder toBuilder() =>
      CommissionEmailSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommissionEmailSummary &&
        total == other.total &&
        sent == other.sent &&
        failed == other.failed &&
        queued == other.queued &&
        blocked == other.blocked;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, sent.hashCode);
    _$hash = $jc(_$hash, failed.hashCode);
    _$hash = $jc(_$hash, queued.hashCode);
    _$hash = $jc(_$hash, blocked.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CommissionEmailSummary')
          ..add('total', total)
          ..add('sent', sent)
          ..add('failed', failed)
          ..add('queued', queued)
          ..add('blocked', blocked))
        .toString();
  }
}

class CommissionEmailSummaryBuilder
    implements Builder<CommissionEmailSummary, CommissionEmailSummaryBuilder> {
  _$CommissionEmailSummary? _$v;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _sent;
  int? get sent => _$this._sent;
  set sent(int? sent) => _$this._sent = sent;

  int? _failed;
  int? get failed => _$this._failed;
  set failed(int? failed) => _$this._failed = failed;

  int? _queued;
  int? get queued => _$this._queued;
  set queued(int? queued) => _$this._queued = queued;

  int? _blocked;
  int? get blocked => _$this._blocked;
  set blocked(int? blocked) => _$this._blocked = blocked;

  CommissionEmailSummaryBuilder() {
    CommissionEmailSummary._defaults(this);
  }

  CommissionEmailSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _total = $v.total;
      _sent = $v.sent;
      _failed = $v.failed;
      _queued = $v.queued;
      _blocked = $v.blocked;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CommissionEmailSummary other) {
    _$v = other as _$CommissionEmailSummary;
  }

  @override
  void update(void Function(CommissionEmailSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CommissionEmailSummary build() => _build();

  _$CommissionEmailSummary _build() {
    final _$result = _$v ??
        _$CommissionEmailSummary._(
          total: BuiltValueNullFieldError.checkNotNull(
              total, r'CommissionEmailSummary', 'total'),
          sent: BuiltValueNullFieldError.checkNotNull(
              sent, r'CommissionEmailSummary', 'sent'),
          failed: BuiltValueNullFieldError.checkNotNull(
              failed, r'CommissionEmailSummary', 'failed'),
          queued: BuiltValueNullFieldError.checkNotNull(
              queued, r'CommissionEmailSummary', 'queued'),
          blocked: BuiltValueNullFieldError.checkNotNull(
              blocked, r'CommissionEmailSummary', 'blocked'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
