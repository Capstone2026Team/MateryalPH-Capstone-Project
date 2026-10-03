import 'dart:async';

import 'package:flutter/material.dart';
import '../../design_system/components/work_package_attachment.dart';
import '../projects/projects_repository.dart';
import '../projects/projects_screen.dart' show ProjectBudgetCard;
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/fulfillment_components.dart';
import '../../design_system/components/order_components.dart';
import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';
import '../item_procurement/procurement_models.dart'
    show formatPeso, formatQuantity;
import '../map_discovery/discovery_models.dart';
import '../map_discovery/discovery_repository.dart' show newIdempotencyKey;
import 'nrpc_disclosure_screen.dart';
import 'order_fulfillment_sections.dart';
import 'order_models.dart';
import 'order_payment_screen.dart';
import 'orders_repository.dart';
import '../../design_system/components/buyer_app_bar.dart';

typedef OpenOrderConversation =
    Future<void> Function(BuildContext context, String conversationId);

/// Order Details. Server-calculated actions only: approve or reject the Vendor's exact version,
/// review an NRPC on its own disclosure page, or flag it. The confirmed drop-off, vehicles, trips and
/// fee are shown before any approval; the intended destination and the actual drop-off stay separate.
/// After confirmation it tracks milestones without live GPS, confirms receipt, reports problems, and
/// cancels or requests cancellation exactly as the server allows.
class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({
    super.key,
    required this.orderId,
    required this.repository,
    this.now,
    this.paymentLauncher = launchPaymentPage,
    this.openConversation,
    this.problemPhotoPicker = pickProblemPhoto,
  });

  final String orderId;
  final OrdersRepository repository;
  final DateTime Function()? now;
  final PaymentLauncher paymentLauncher;

  /// Opens the order's Fulfillment Messages thread. Null hides the entry's action.
  final OpenOrderConversation? openConversation;
  final ProblemPhotoPicker problemPhotoPicker;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  OrderDetailView? _order;
  DiscoveryFailure? _failure;
  String? _notice;
  bool _busy = false;
  String? _decisionKey;
  String? _decisionScope;
  final _budgetReason = TextEditingController();
  final _scroll = ScrollController();
  @override
  void dispose() {
    _budgetReason.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _failure = null);
    try {
      final order = await widget.repository.order(widget.orderId);
      if (mounted) setState(() => _order = order);
    } on DiscoveryFailure catch (error) {
      if (mounted) setState(() => _failure = error);
    }
  }

  Future<void> _decide(
    Future<OrderDetailView> Function(String key) action,
    String success, {
    String scope = 'decision',
    String Function(OrderDetailView order)? describe,
  }) async {
    if (_busy) return;
    // An offline retry reuses the key of the same action only; another action gets a fresh key.
    if (_decisionScope != scope) _decisionKey = null;
    _decisionScope = scope;
    final key = _decisionKey ??= newIdempotencyKey();
    setState(() {
      _busy = true;
      _notice = null;
    });
    try {
      final order = await action(key);
      _decisionKey = null;
      if (mounted) {
        setState(() {
          _order = order;
          _notice = describe?.call(order) ?? success;
        });
        // The result notice is at the top; bring it into view after acting lower on the page.
        if (_scroll.hasClients) {
          unawaited(
            _scroll.animateTo(
              0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
            ),
          );
        }
      }
    } on DiscoveryFailure catch (error) {
      if (error.kind != DiscoveryFailureKind.offline) _decisionKey = null;
      if (mounted) setState(() => _notice = error.message);
      if (error.kind == DiscoveryFailureKind.conflict) await _load();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _confirmReject(OrderDetailView order) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject this version?'),
        content: const Text(
          'The order request is cancelled and the reserved stock is released. You are not charged.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep reviewing'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _decide(
        (key) => widget.repository.rejectRevision(
          order.id,
          snapshotVersion: order.snapshotVersion,
          idempotencyKey: key,
        ),
        'You rejected the Vendor’s version. The request is cancelled.',
      );
    }
  }

  Future<void> _openNrpc(OrderDetailView order) async {
    final updated = await Navigator.of(context).push<OrderDetailView>(
      MaterialPageRoute(
        builder: (_) =>
            NrpcDisclosureScreen(order: order, repository: widget.repository),
      ),
    );
    if (!mounted) return;
    if (updated != null) {
      setState(() => _order = updated);
    } else {
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = _order;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buyerAppBar(context, 'Order details'),
      bottomNavigationBar: order == null ? null : _actionBar(order),
      body: SafeArea(
        child: order == null
            ? (_failure == null
                  ? ListView(
                      padding: const EdgeInsets.all(16),
                      children: const [
                        SkeletonBox(height: 90),
                        SizedBox(height: 12),
                        SkeletonBox(height: 220),
                      ],
                    )
                  : StateMessage(
                      kind: _failure!.kind == DiscoveryFailureKind.offline
                          ? StateKind.offline
                          : _failure!.kind == DiscoveryFailureKind.notFound
                          ? StateKind.forbidden
                          : StateKind.error,
                      title: 'This order could not load',
                      message: _failure!.message,
                      actionLabel: 'Retry',
                      onAction: _load,
                    ))
            : RefreshIndicator(onRefresh: _load, child: _content(order)),
      ),
    );
  }

  Widget? _actionBar(OrderDetailView order) {
    if (order.actions.contains('APPROVE_REVISION')) {
      return _Bar(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _busy ? null : () => _confirmReject(order),
              child: const Text('Reject'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: FilledButton(
              onPressed: _busy
                  ? null
                  : () => _decide(
                      (key) => widget.repository.approveRevision(
                        order.id,
                        snapshotVersion: order.snapshotVersion,
                        budgetOverrideReason: _budgetReason.text.trim().isEmpty
                            ? null
                            : _budgetReason.text.trim(),
                        idempotencyKey: key,
                      ),
                      'Approved. Your order moves to the next step.',
                    ),
              child: Text(_busy ? 'Saving…' : 'Approve this version'),
            ),
          ),
        ],
      );
    }
    if (order.actions.contains('ACCEPT_NRPC')) {
      return _Bar(
        children: [
          Expanded(
            child: FilledButton.icon(
              onPressed: _busy ? null : () => _openNrpc(order),
              icon: const Icon(LucideIcons.fileText, size: 18),
              label: const Text('Review preparation cost'),
            ),
          ),
        ],
      );
    }
    final payingBalance = order.payment?.purpose == 'ORDER_BALANCE_PAYMENT';
    if (order.actions.contains('PAY') &&
        (order.state('ORDER') == 'AWAITING_PAYMENT' || payingBalance)) {
      final latest = order.payment?.latestAttempt;
      final pending = latest?.pending ?? false;
      // After a failed or abandoned checkout the same order and amount can be paid again.
      final retry = latest?.retryable ?? false;
      return _Bar(
        children: [
          Expanded(
            child: FilledButton.icon(
              onPressed: _busy
                  ? null
                  : pending
                  ? () => _openPending(order.payment!.latestAttempt!)
                  : () => _openPayment(order),
              icon: Icon(
                pending
                    ? LucideIcons.hourglass
                    : retry
                    ? LucideIcons.rotateCcw
                    : LucideIcons.creditCard,
                size: 18,
              ),
              label: Text(
                pending
                    ? 'View pending payment'
                    : payingBalance
                    ? 'Pay remaining balance'
                    : retry
                    ? 'Re-process payment'
                    : 'Pay now',
              ),
            ),
          ),
        ],
      );
    }
    final canReport = order.actions.contains('REPORT_PROBLEM');
    if (order.actions.contains('CONFIRM_RECEIPT') || canReport) {
      return _Bar(
        children: [
          if (canReport)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _busy ? null : () => _reportProblem(order),
                icon: const Icon(LucideIcons.triangleAlert, size: 18),
                label: const Text('Report a problem'),
              ),
            ),
          if (canReport && order.actions.contains('CONFIRM_RECEIPT'))
            const SizedBox(width: 10),
          if (order.actions.contains('CONFIRM_RECEIPT'))
            Expanded(
              child: FilledButton.icon(
                onPressed: _busy ? null : () => _confirmReceipt(order),
                icon: const Icon(LucideIcons.packageCheck, size: 18),
                label: Text(_busy ? 'Saving…' : 'Confirm receipt'),
              ),
            ),
        ],
      );
    }
    return null;
  }

  Future<void> _openPayment(OrderDetailView order) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => OrderPaymentScreen(
          orderId: order.id,
          repository: widget.repository,
          launcher: widget.paymentLauncher,
        ),
      ),
    );
    if (mounted) await _load();
  }

  Future<void> _openPending(PaymentAttemptView attempt) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => PaymentPendingScreen(
          paymentId: attempt.id,
          repository: widget.repository,
          initial: attempt,
          launcher: widget.paymentLauncher,
        ),
      ),
    );
    if (mounted) await _load();
  }

  Future<void> _acknowledge(OrderDetailView order, PhysicalRecordView record) =>
      _decide((key) async {
        await widget.repository.acknowledgePhysicalPayment(
          order.id,
          recordId: record.id,
          idempotencyKey: key,
        );
        return widget.repository.order(order.id);
      }, 'Thanks — you confirmed the Vendor’s payment record.');

  Future<bool> _confirm({
    required String title,
    required String message,
    required String confirmLabel,
    String keepLabel = 'Not now',
  }) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(keepLabel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(confirmLabel),
            ),
          ],
        ),
      ) ??
      false;

  Future<void> _confirmReceipt(OrderDetailView order) async {
    final pickup = order.fulfillment?.method == 'PICKUP';
    if (!await _confirm(
      title: 'Confirm you received this order?',
      message:
          'Confirm only after checking the ${pickup ? 'items you picked up' : 'delivered items'}. This completes the order. For a later concern, use the return, warranty or dispute process.',
      confirmLabel: 'Confirm receipt',
    )) {
      return;
    }
    await _decide(
      (key) => widget.repository.confirmReceipt(order.id, idempotencyKey: key),
      'Receipt confirmed. Your order is completed.',
      scope: 'confirmReceipt',
    );
  }

  Future<void> _reportProblem(OrderDetailView order) async {
    final input = await showProblemSheet(
      context,
      picker: widget.problemPhotoPicker,
    );
    if (input == null || !mounted) return;
    await _decide(
      (key) => widget.repository.reportProblem(
        order.id,
        category: input.category,
        description: input.description,
        photo: input.photo,
        idempotencyKey: key,
      ),
      'Problem reported. The Vendor was notified and automatic confirmation is paused.',
      scope: 'reportProblem',
    );
  }

  Future<void> _resolveProblem(
    OrderDetailView order,
    FulfillmentIssueView issue,
  ) async {
    if (!await _confirm(
      title: 'Mark this problem as resolved?',
      message:
          'The automatic confirmation window resumes with the time that remained. You can still confirm receipt yourself.',
      confirmLabel: 'Mark as resolved',
    )) {
      return;
    }
    await _decide(
      (key) => widget.repository.resolveProblem(
        order.id,
        issueId: issue.id,
        idempotencyKey: key,
      ),
      'Problem marked as resolved.',
      scope: 'resolveProblem',
    );
  }

  Future<void> _cancel(OrderDetailView order) async {
    final input = await showCancellationSheet(
      context,
      order: order,
      repository: widget.repository,
    );
    if (input == null || !mounted) return;
    await _decide(
      (key) => widget.repository.cancelOrder(
        order.id,
        lockVersion: order.lockVersion,
        reasonCode: input.reasonCode,
        reason: input.reason,
        idempotencyKey: key,
      ),
      'Your order was cancelled.',
      scope: 'cancel',
      describe: (updated) {
        if (updated.cancellation?.mode == 'REQUEST_OPEN') {
          return 'Cancellation request sent. The Vendor responds within 24 hours; your order continues until then.';
        }
        final timeline = updated.refundTimeline;
        if (timeline != null && timeline.refunds.isNotEmpty) {
          return 'Order cancelled. Your refund was initiated to your original payment method — it is not received yet. We will show when it is processed.';
        }
        return 'Order cancelled. Any reserved stock was released and you were not charged.';
      },
    );
  }

  Future<void> _withdrawRequest(OrderDetailView order) async {
    if (!await _confirm(
      title: 'Keep your order?',
      message:
          'Your cancellation request is withdrawn and the Vendor continues preparing your order.',
      confirmLabel: 'Withdraw request',
      keepLabel: 'Keep request',
    )) {
      return;
    }
    await _decide(
      (key) => widget.repository.withdrawCancellationRequest(
        order.id,
        idempotencyKey: key,
      ),
      'Cancellation request withdrawn. Your order continues.',
      scope: 'withdrawCancellationRequest',
    );
  }

  Future<void> _acknowledgeReimbursement(
    OrderDetailView order,
    ReimbursementItemView item,
  ) async {
    if (!await _confirm(
      title: 'Did you receive ${formatPeso(item.amountCentavos)}?',
      message:
          'Confirm only after the Vendor’s cash reimbursement reached you.',
      confirmLabel: 'I received it',
    )) {
      return;
    }
    await _decide(
      (key) => widget.repository.acknowledgeReimbursement(
        order.id,
        reimbursementId: item.id,
        idempotencyKey: key,
      ),
      'Thanks — you confirmed the cash reimbursement.',
      scope: 'acknowledgeReimbursement:${item.id}',
    );
  }

  Future<void> _openThread(String conversationId) async {
    final open = widget.openConversation;
    if (open == null) return;
    await open(context, conversationId);
    if (mounted) await _load();
  }

  Widget _content(OrderDetailView order) {
    final state = order.state('ORDER');
    final (DateTime? deadline, String label) = switch (state) {
      'AWAITING_VENDOR_CONFIRMATION' => (
        order.vendorResponseDueAt,
        'Vendor responds within',
      ),
      'AWAITING_BUYER_APPROVAL' || 'AWAITING_NRPC_ACCEPTANCE' => (
        order.buyerResponseDueAt,
        'Respond within',
      ),
      'AWAITING_PAYMENT' => (order.paymentExpiresAt, 'Pay before'),
      _ => (null, ''),
    };
    return ListView(
      controller: _scroll,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      children: [
        if (order.projectContext != null) ...[
          WorkPackageAttachment(
            original: projectObject(order.projectContext!['work_package']),
            version: order.projectContext!['version'],
          ),
          ProjectBudgetCard(
            budget: projectObject(order.projectContext!['budget']),
          ),
          if (order.projectContext!['note'] != null)
            Text(
              'Informational Note: ${order.projectContext!['note']} · No Vendor response required',
            ),
          if (order.actions.contains('APPROVE_REVISION'))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: TextField(
                controller: _budgetReason,
                maxLength: 2000,
                decoration: const InputDecoration(
                  labelText: 'Written budget override reason',
                  helperText: 'Required when either budget is exceeded',
                ),
              ),
            ),
        ],
        _Header(order: order),
        const SizedBox(height: 10),
        if (_notice != null) ...[
          StatusBand(tone: BandTone.info, title: _notice!),
          const SizedBox(height: 10),
        ],
        if (deadline != null) ...[
          DeadlineCountdown(
            deadline: deadline,
            label: label,
            endedLabel: state == 'AWAITING_PAYMENT'
                ? 'Payment window ended'
                : 'Response window ended',
            onExpired: _load,
            now: widget.now,
          ),
          const SizedBox(height: 10),
        ],
        _StateBand(order: order),
        const SizedBox(height: 12),
        if (order.fulfillment != null &&
            _trackedStates.contains(state) &&
            order.fulfillment!.steps.isNotEmpty) ...[
          _Heading(
            order.fulfillment!.method == 'PICKUP'
                ? 'Pickup progress'
                : 'Delivery progress',
          ),
          OrderFulfillmentPanel(
            order: order,
            fulfillment: order.fulfillment!,
            repository: widget.repository,
            busy: _busy,
            onResolveProblem: (issue) => _resolveProblem(order, issue),
            onReload: _load,
            onOpenThread: widget.openConversation == null ? null : _openThread,
            now: widget.now,
          ),
          const SizedBox(height: 16),
        ],
        if (order.refundTimeline != null && !order.refundTimeline!.isEmpty) ...[
          const _Heading('Refunds and reimbursements'),
          RefundTimelineCard(
            timeline: order.refundTimeline!,
            busy: _busy,
            onAcknowledge: order.actions.contains('ACKNOWLEDGE_REIMBURSEMENT')
                ? (item) => _acknowledgeReimbursement(order, item)
                : null,
          ),
          const SizedBox(height: 16),
        ],
        const _Heading('Status'),
        OrderStateRows(states: order.states),
        if (order.changes.isNotEmpty) ...[
          const SizedBox(height: 16),
          const _Heading('What the Vendor changed'),
          for (final change in order.changes)
            _Bullet(switch (change.type) {
              'LINE_REMOVED' => '${change.label}: removed',
              'QUANTITY_REDUCED' =>
                '${change.label}: ${formatQuantity(change.from)} → ${formatQuantity(change.to)}',
              _ =>
                'Vendor discount of ${formatPeso(int.tryParse(change.to) ?? 0)}',
            }),
        ],
        const SizedBox(height: 16),
        const _Heading('Items'),
        for (final line in order.lines) _LineTile(line: line),
        const SizedBox(height: 16),
        _Heading(order.fulfillmentMethod == 'DELIVERY' ? 'Delivery' : 'Pickup'),
        _FulfillmentSection(order: order),
        const SizedBox(height: 16),
        MoneyBreakdownCard(money: order.money),
        if (order.payment != null && _hasPaymentDetail(order.payment!)) ...[
          const SizedBox(height: 16),
          const _Heading('Payment'),
          _PaymentSection(
            payment: order.payment!,
            busy: _busy,
            onAcknowledge: (record) => _acknowledge(order, record),
          ),
        ],
        if (order.nrpc != null) ...[
          const SizedBox(height: 16),
          _NrpcSummary(
            nrpc: order.nrpc!,
            canFlag: order.actions.contains('FLAG_NRPC'),
            onOpen: () => _openNrpc(order),
          ),
        ],
        if (order.cancellation != null &&
            order.cancellation!.mode != 'CLOSED') ...[
          const SizedBox(height: 16),
          const _Heading('Cancellation'),
          CancellationPanel(
            order: order,
            cancellation: order.cancellation!,
            busy: _busy,
            onCancel: () => _cancel(order),
            onWithdrawRequest: () => _withdrawRequest(order),
            now: widget.now,
          ),
        ],
        const SizedBox(height: 16),
        const _Heading('History'),
        for (final event in order.timeline) _EventTile(event: event),
      ],
    );
  }
}

const _trackedStates = {
  'CONFIRMED',
  'PROCESSING',
  'READY_FOR_PICKUP',
  'OUT_FOR_DELIVERY',
  'DELIVERED',
  'PICKED_UP',
  'COMPLETED',
  'DISPUTED',
};

bool _hasPaymentDetail(OrderPaymentView payment) =>
    payment.latestAttempt != null ||
    payment.verifiedPayment != null ||
    payment.physicalApplicable;

/// Verified online payment, the latest attempt and the Vendor's physical payment records. A record is
/// the Vendor's statement of what it collected; the Buyer may confirm it once and nothing else.
class _PaymentSection extends StatelessWidget {
  const _PaymentSection({
    required this.payment,
    required this.busy,
    required this.onAcknowledge,
  });

  final OrderPaymentView payment;
  final bool busy;
  final ValueChanged<PhysicalRecordView> onAcknowledge;

  @override
  Widget build(BuildContext context) {
    final verified = payment.verifiedPayment;
    final latest = payment.latestAttempt;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: BuyerTheme.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (verified != null)
            _PaymentLine(
              icon: LucideIcons.badgeCheck,
              title: '${paymentPurposeLabel(verified.purpose)} · verified',
              detail:
                  '${formatPeso(verified.totalCentavos)} incl. ${formatPeso(verified.processingFeeCentavos)} Payment Processing Fee${verified.channelName == null ? '' : ' · ${verified.channelName}'}',
            ),
          if (latest != null && latest.id != verified?.id)
            _PaymentLine(
              icon: latest.pending ? LucideIcons.hourglass : LucideIcons.info,
              title: switch (latest.status) {
                'PENDING' => 'Payment pending verification',
                'FAILED' => 'Last payment attempt failed',
                'EXPIRED' => 'Last payment attempt expired',
                'CAPTURED_LATE_REFUND_PENDING' =>
                  'Late payment — refund queued',
                _ => paymentPurposeLabel(latest.purpose),
              },
              detail: latest.message,
            ),
          if (payment.physicalApplicable) ...[
            _PaymentLine(
              icon: LucideIcons.banknote,
              title: switch (payment.physicalMethod) {
                'CASH_ON_DELIVERY' => 'Cash on delivery',
                'CASH_ON_PICKUP' => 'Cash on pickup',
                'BANK_DEPOSIT' => 'Bank deposit',
                _ => 'Physical payment',
              },
              detail: payment.physicalRemainingCentavos == null
                  ? 'Pay the Vendor directly as agreed.'
                  : 'Remaining per the Vendor’s records: ${formatPeso(payment.physicalRemainingCentavos!)}',
            ),
            for (final record in payment.physicalRecords.where(
              (record) =>
                  record.kind == 'COLLECTION' ||
                  record.kind == 'ONLINE_BALANCE_CREDIT',
            ))
              Padding(
                padding: const EdgeInsets.only(left: 30, bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${record.kind == 'COLLECTION' ? 'Vendor recorded' : 'Online balance credited'} ${formatPeso(record.amountCentavos)}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    if (record.kind == 'COLLECTION' &&
                        record.acknowledgedAt == null)
                      TextButton(
                        onPressed: busy ? null : () => onAcknowledge(record),
                        style: TextButton.styleFrom(
                          minimumSize: const Size(44, 44),
                        ),
                        child: const Text('Confirm'),
                      )
                    else if (record.acknowledgedAt != null)
                      Text(
                        'Confirmed',
                        style: TextStyle(
                          fontSize: 12,
                          color: BuyerTheme.successStrong,
                        ),
                      ),
                  ],
                ),
              ),
          ],
          if (payment.notice != null)
            Text(
              payment.notice!,
              style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
            ),
        ],
      ),
    );
  }
}

class _PaymentLine extends StatelessWidget {
  const _PaymentLine({
    required this.icon,
    required this.title,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: BuyerTheme.ink),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(
                detail,
                style: const TextStyle(fontSize: 13, color: BuyerTheme.muted),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _Bar extends StatelessWidget {
  const _Bar({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: BuyerTheme.border)),
      ),
      child: Row(children: children),
    ),
  );
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Semantics(
      header: true,
      child: Text(
        text,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
      ),
    ),
  );
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 3),
          child: Icon(LucideIcons.dot, size: 14, color: BuyerTheme.action),
        ),
        const SizedBox(width: 6),
        Expanded(child: Text(text)),
      ],
    ),
  );
}

class _Header extends StatelessWidget {
  const _Header({required this.order});

  final OrderDetailView order;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: BuyerTheme.canvas,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: BuyerTheme.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(LucideIcons.store, size: 18, color: BuyerTheme.action),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                order.vendorName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            OrderStateChip(state: order.state('ORDER')),
            if (order.autoAccepted)
              const _Tag(icon: LucideIcons.zap, text: 'Accepted automatically'),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          order.reference,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        if (order.submittedAt != null)
          Text(
            'Submitted ${formatManilaDateTime(order.submittedAt!)}',
            style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
          ),
      ],
    ),
  );
}

class _Tag extends StatelessWidget {
  const _Tag({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 14, color: BuyerTheme.muted),
      const SizedBox(width: 4),
      Flexible(
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
        ),
      ),
    ],
  );
}

class _StateBand extends StatelessWidget {
  const _StateBand({required this.order});

  final OrderDetailView order;

  @override
  Widget build(BuildContext context) => switch (order.state('ORDER')) {
    'AWAITING_VENDOR_CONFIRMATION' => const StatusBand(
      tone: BandTone.info,
      title: 'Waiting for the Vendor',
      message:
          'The Vendor confirms stock, the date and any delivery arrangement. Totals stay advisory and nothing is charged until you accept the final amount.',
    ),
    'AWAITING_BUYER_APPROVAL' => const StatusBand(
      tone: BandTone.warning,
      title: 'Review the Vendor’s confirmed version',
      message:
          'Check the quantities, delivery drop-off, vehicles and fee below. The stock stays reserved while you decide.',
    ),
    'AWAITING_NRPC_ACCEPTANCE' => const StatusBand(
      tone: BandTone.warning,
      title: 'The Vendor proposed a preparation cost',
      message:
          'Open the disclosure to see the amount, reason, affected items and Terms before you decide.',
    ),
    'AWAITING_PAYMENT' => StatusBand(
      tone: BandTone.info,
      title: 'Pending payment — the Vendor confirmed your order',
      message:
          order.paymentNotice ??
          'Pay before the deadline to keep the reserved stock. If a payment fails or you leave the payment page, you can pay again until then.',
    ),
    'CONFIRMED' => const StatusBand(
      tone: BandTone.success,
      title: 'Order confirmed',
      message: 'The Vendor prepares your order for the confirmed date.',
    ),
    'PROCESSING' => const StatusBand(
      tone: BandTone.info,
      title: 'The Vendor is preparing your order',
      message:
          'You are notified when it is ready for pickup or out for delivery.',
    ),
    'READY_FOR_PICKUP' => const StatusBand(
      tone: BandTone.info,
      title: 'Ready for pickup',
      message:
          'Collect it at the store and show your order reference. Fulfillment Messages are open for pickup details.',
    ),
    'OUT_FOR_DELIVERY' => const StatusBand(
      tone: BandTone.info,
      title: 'Out for delivery',
      message:
          'Updates come from the Vendor’s recorded milestones; there is no live GPS tracking.',
    ),
    'DELIVERED' || 'PICKED_UP' => StatusBand(
      tone: BandTone.warning,
      title: order.state('ORDER') == 'DELIVERED'
          ? 'Delivered — check your order'
          : 'Picked up — check your order',
      message:
          'Confirm receipt when everything is correct, or report a problem before the window ends.',
    ),
    'COMPLETED' => const StatusBand(
      tone: BandTone.success,
      title: 'Order completed',
      message: 'Thank you. The order history and proof stay available here.',
    ),
    'DECLINED' => const StatusBand(
      tone: BandTone.danger,
      title: 'The Vendor declined this request',
      message: 'You were not charged. Your other orders are unaffected.',
    ),
    'EXPIRED' => StatusBand(
      tone: BandTone.danger,
      title: order.terminalReasonCode == 'PAYMENT_WINDOW_EXPIRED'
          ? 'Cancelled — payment expired'
          : 'This order expired',
      message: order.terminalReasonCode == 'PAYMENT_WINDOW_EXPIRED'
          ? 'Payment was not completed within 24 hours, so the order was cancelled automatically and the reserved stock was released. You were not charged.'
          : 'A response window ended, so the request expired. You were not charged.',
    ),
    'CANCELLED' => StatusBand(
      tone: BandTone.danger,
      title: 'This order was cancelled',
      message:
          order.refundTimeline == null ||
              (order.refundTimeline!.refunds.isEmpty &&
                  order.refundTimeline!.reimbursements.isEmpty)
          ? 'Any reserved stock was released. You were not charged.'
          : 'Any reserved stock was released. See Refunds and reimbursements below for what happens to your payment.',
    ),
    _ => const SizedBox.shrink(),
  };
}

class _LineTile extends StatelessWidget {
  const _LineTile({required this.line});

  final OrderLineView line;

  @override
  Widget build(BuildContext context) {
    final confirmed = line.confirmedQuantity;
    final changed = line.change != null;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: changed ? BuyerTheme.action : BuyerTheme.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 52,
              height: 52,
              color: BuyerTheme.canvas,
              child: line.imageUrl == null
                  ? const Icon(LucideIcons.package, color: BuyerTheme.muted)
                  : Image.network(
                      line.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(
                        LucideIcons.package,
                        color: BuyerTheme.muted,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.displayName,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                if (line.variantLabel != null)
                  Text(
                    line.variantLabel!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: BuyerTheme.muted,
                    ),
                  ),
                const SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    children: [
                      if (changed)
                        TextSpan(
                          text: '${formatQuantity(line.requestedQuantity)} ',
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: BuyerTheme.muted,
                          ),
                        ),
                      TextSpan(
                        text: line.change == 'LINE_REMOVED'
                            ? 'Removed by the Vendor'
                            : '${formatQuantity(confirmed ?? line.requestedQuantity)} ${line.unitName} × ${formatPeso(line.unitPriceCentavos)}',
                        style: TextStyle(
                          fontWeight: changed
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: changed
                              ? BuyerTheme.actionPressed
                              : BuyerTheme.ink,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  [
                    line.vatLabel,
                    if (line.volumeTierApplied) 'volume price',
                  ].join(' · '),
                  style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            line.change == 'LINE_REMOVED'
                ? '—'
                : formatPeso(line.lineTotalCentavos),
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _FulfillmentSection extends StatelessWidget {
  const _FulfillmentSection({required this.order});

  final OrderDetailView order;

  @override
  Widget build(BuildContext context) {
    final destination = order.destination;
    final confirmed = order.confirmedDelivery;
    Widget point(
      String caption,
      OrderPointView? value, {
      bool emphasize = false,
    }) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            caption,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: emphasize ? BuyerTheme.action : BuyerTheme.muted,
            ),
          ),
          Text(
            value?.label ?? '—',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          if (value?.formattedAddress != null)
            Text(
              value!.formattedAddress!,
              style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
            ),
        ],
      ),
    );
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BuyerTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (destination?.type == 'PICKUP') ...[
            const Text(
              'You collect at the store',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            if (destination?.storeAddress != null)
              Text(
                destination!.storeAddress!,
                style: const TextStyle(color: BuyerTheme.muted),
              ),
            const SizedBox(height: 6),
            Text(
              order.expectedFulfillmentDate == null
                  ? 'The Vendor confirms the ready-for-pickup date.'
                  : 'Ready for pickup on ${order.expectedFulfillmentDate} (Philippine date)',
              style: const TextStyle(fontSize: 13),
            ),
          ],
          if (destination?.type == 'DELIVERY') ...[
            point('Intended destination / Project site', destination!.intended),
            if (destination.alternateDropOff != null)
              point(
                'Actual vehicle drop-off',
                destination.alternateDropOff,
                emphasize: true,
              )
            else
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Vehicles drop off at the intended destination.',
                  style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
                ),
              ),
            if (destination.accessInstructions != null)
              Text(
                'Access: ${destination.accessInstructions}',
                style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
              ),
            const Divider(height: 20, color: BuyerTheme.border),
            if (confirmed == null)
              Text(
                order.money.deliveryEstimateMin == null
                    ? 'The Vendor reviews the load and confirms vehicles, trips and the delivery fee before you pay.'
                    : 'Estimate only. The Vendor confirms vehicles, trips and the final fee before you pay.',
                style: const TextStyle(fontSize: 13),
              )
            else ...[
              const Text(
                'Confirmed by the Vendor',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              for (final vehicle in confirmed.vehicles)
                Text(
                  '${vehicle.name}${vehicle.brand == null ? '' : ' (${vehicle.brand})'} · ${vehicle.vehicles} vehicle${vehicle.vehicles == 1 ? '' : 's'}, ${vehicle.trips} trip${vehicle.trips == 1 ? '' : 's'}',
                ),
              Text(
                'Route ${(confirmed.distanceMeters / 1000).toStringAsFixed(1)} km to the ${confirmed.endpoint == 'ALTERNATE_DROP_OFF' ? 'alternate drop-off' : 'intended destination'}',
                style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
              ),
              if (confirmed.fulfillmentDate != null)
                Text(
                  'Delivery date ${confirmed.fulfillmentDate} (Philippine date)',
                ),
              if (confirmed.arrangement != null)
                Text(
                  confirmed.arrangement!,
                  style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
                ),
              const SizedBox(height: 4),
              Text(
                'Delivery fee ${formatPeso(confirmed.finalFeeCentavos)}',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _NrpcSummary extends StatelessWidget {
  const _NrpcSummary({
    required this.nrpc,
    required this.canFlag,
    required this.onOpen,
  });

  final NrpcView nrpc;
  final bool canFlag;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: BuyerTheme.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Preparation cost (NRPC)',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            Text(
              formatPeso(nrpc.amountCentavos),
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(switch (nrpc.status) {
          'ACCEPTED' =>
            nrpc.acceptedAt == null
                ? 'Accepted'
                : 'Accepted ${formatManilaDateTime(nrpc.acceptedAt!)}',
          'REJECTED' => 'Rejected',
          _ => 'Waiting for your decision',
        }, style: const TextStyle(fontSize: 12, color: BuyerTheme.muted)),
        if (nrpc.flagged)
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: _Tag(
              icon: LucideIcons.flag,
              text:
                  'You flagged this for review. It is being reviewed separately.',
            ),
          ),
        TextButton(
          onPressed: onOpen,
          child: Text(
            canFlag && nrpc.status == 'ACCEPTED' && !nrpc.flagged
                ? 'View details or raise a concern'
                : 'View details',
          ),
        ),
      ],
    ),
  );
}

class _EventTile extends StatelessWidget {
  const _EventTile({required this.event});

  final OrderEventView event;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Icon(
            LucideIcons.circleDot,
            size: 12,
            color: BuyerTheme.action,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${event.family == 'ORDER' ? '' : '${orderFamilyLabel(event.family)}: '}${orderStateLabel(event.toState)}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                [
                  if (event.at != null) formatManilaDateTime(event.at!),
                  switch (event.source) {
                    'BUYER' => 'You',
                    'VENDOR' => 'Vendor',
                    'AUTO_ACCEPT' => 'Automatic',
                    _ => 'System',
                  },
                ].join(' · '),
                style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
