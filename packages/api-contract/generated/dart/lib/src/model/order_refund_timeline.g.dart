// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_refund_timeline.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OrderRefundTimeline extends OrderRefundTimeline {
  @override
  final BuiltList<RefundTimelineItem> refunds;
  @override
  final BuiltList<ReimbursementTimelineItem> reimbursements;
  @override
  final int noLongerDueCentavos;
  @override
  final CancellationDecisionView? decision;

  factory _$OrderRefundTimeline(
          [void Function(OrderRefundTimelineBuilder)? updates]) =>
      (OrderRefundTimelineBuilder()..update(updates))._build();

  _$OrderRefundTimeline._(
      {required this.refunds,
      required this.reimbursements,
      required this.noLongerDueCentavos,
      this.decision})
      : super._();
  @override
  OrderRefundTimeline rebuild(
          void Function(OrderRefundTimelineBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderRefundTimelineBuilder toBuilder() =>
      OrderRefundTimelineBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderRefundTimeline &&
        refunds == other.refunds &&
        reimbursements == other.reimbursements &&
        noLongerDueCentavos == other.noLongerDueCentavos &&
        decision == other.decision;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, refunds.hashCode);
    _$hash = $jc(_$hash, reimbursements.hashCode);
    _$hash = $jc(_$hash, noLongerDueCentavos.hashCode);
    _$hash = $jc(_$hash, decision.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderRefundTimeline')
          ..add('refunds', refunds)
          ..add('reimbursements', reimbursements)
          ..add('noLongerDueCentavos', noLongerDueCentavos)
          ..add('decision', decision))
        .toString();
  }
}

class OrderRefundTimelineBuilder
    implements Builder<OrderRefundTimeline, OrderRefundTimelineBuilder> {
  _$OrderRefundTimeline? _$v;

  ListBuilder<RefundTimelineItem>? _refunds;
  ListBuilder<RefundTimelineItem> get refunds =>
      _$this._refunds ??= ListBuilder<RefundTimelineItem>();
  set refunds(ListBuilder<RefundTimelineItem>? refunds) =>
      _$this._refunds = refunds;

  ListBuilder<ReimbursementTimelineItem>? _reimbursements;
  ListBuilder<ReimbursementTimelineItem> get reimbursements =>
      _$this._reimbursements ??= ListBuilder<ReimbursementTimelineItem>();
  set reimbursements(ListBuilder<ReimbursementTimelineItem>? reimbursements) =>
      _$this._reimbursements = reimbursements;

  int? _noLongerDueCentavos;
  int? get noLongerDueCentavos => _$this._noLongerDueCentavos;
  set noLongerDueCentavos(int? noLongerDueCentavos) =>
      _$this._noLongerDueCentavos = noLongerDueCentavos;

  CancellationDecisionViewBuilder? _decision;
  CancellationDecisionViewBuilder get decision =>
      _$this._decision ??= CancellationDecisionViewBuilder();
  set decision(CancellationDecisionViewBuilder? decision) =>
      _$this._decision = decision;

  OrderRefundTimelineBuilder() {
    OrderRefundTimeline._defaults(this);
  }

  OrderRefundTimelineBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _refunds = $v.refunds.toBuilder();
      _reimbursements = $v.reimbursements.toBuilder();
      _noLongerDueCentavos = $v.noLongerDueCentavos;
      _decision = $v.decision?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderRefundTimeline other) {
    _$v = other as _$OrderRefundTimeline;
  }

  @override
  void update(void Function(OrderRefundTimelineBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderRefundTimeline build() => _build();

  _$OrderRefundTimeline _build() {
    _$OrderRefundTimeline _$result;
    try {
      _$result = _$v ??
          _$OrderRefundTimeline._(
            refunds: refunds.build(),
            reimbursements: reimbursements.build(),
            noLongerDueCentavos: BuiltValueNullFieldError.checkNotNull(
                noLongerDueCentavos,
                r'OrderRefundTimeline',
                'noLongerDueCentavos'),
            decision: _decision?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'refunds';
        refunds.build();
        _$failedField = 'reimbursements';
        reimbursements.build();

        _$failedField = 'decision';
        _decision?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OrderRefundTimeline', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
