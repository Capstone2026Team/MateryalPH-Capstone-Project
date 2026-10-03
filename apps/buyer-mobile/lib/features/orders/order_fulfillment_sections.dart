import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/fulfillment_components.dart';
import '../../design_system/components/order_components.dart';
import '../../design_system/components/procurement_components.dart';
import '../../design_system/generated/color_tokens.dart';
import '../../design_system/theme.dart';
import '../item_procurement/procurement_models.dart' show formatPeso;
import '../map_discovery/discovery_models.dart';
import 'order_models.dart';
import 'orders_repository.dart';

/// Buyer fulfillment, receipt and cancellation sections of Order Details. Every action shown here is
/// one the server listed in `available_actions`; a missing action is explained, never just hidden.

final _buyerFilePath = RegExp(
  r'^/buyers/orders/[^/]+/files/([0-9a-fA-F-]{36})$',
);

/// The file id of an order-scoped Buyer evidence path, or null for anything else.
String? buyerEvidenceFileId(String? path) =>
    path == null ? null : _buyerFilePath.firstMatch(path)?.group(1);

class OrderFulfillmentPanel extends StatelessWidget {
  const OrderFulfillmentPanel({
    super.key,
    required this.order,
    required this.fulfillment,
    required this.repository,
    required this.busy,
    required this.onResolveProblem,
    required this.onReload,
    this.onOpenThread,
    this.now,
  });

  final OrderDetailView order;
  final FulfillmentView fulfillment;
  final OrdersRepository repository;
  final bool busy;
  final ValueChanged<FulfillmentIssueView> onResolveProblem;
  final VoidCallback onReload;
  final ValueChanged<String>? onOpenThread;
  final DateTime Function()? now;

  @override
  Widget build(BuildContext context) {
    final receipt = fulfillment.receipt;
    final issue = fulfillment.issue;
    final thread = fulfillment.thread;
    final pickup = fulfillment.method == 'PICKUP';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (fulfillment.late) ...[
          StatusBand(
            tone: BandTone.warning,
            title: pickup
                ? 'Not yet ready on the expected date'
                : 'Not yet delivered on the expected date',
            message:
                'The Vendor has been reminded. You can message them in Fulfillment Messages${order.actions.contains('REPORT_PROBLEM') ? ' or report a problem' : ''}.',
          ),
          const SizedBox(height: 10),
        ],
        if (fulfillment.expectedDate != null ||
            fulfillment.assigneeName != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Wrap(
              spacing: 16,
              runSpacing: 6,
              children: [
                if (fulfillment.expectedDate != null)
                  _Fact(
                    icon: LucideIcons.calendarDays,
                    text:
                        '${pickup ? 'Expected ready' : 'Expected delivery'}: ${fulfillment.expectedDate} (Philippine date)',
                  ),
                if (fulfillment.assigneeName != null)
                  _Fact(
                    icon: LucideIcons.userRound,
                    text:
                        '${fulfillment.assigneeName} · ${fulfillmentRoleLabel('FULFILLMENT')}',
                  ),
              ],
            ),
          ),
        MilestoneTracker(
          steps: fulfillment.steps,
          proofBuilder: (proof) => ProofCard(
            proof: proof,
            photo: buyerEvidenceFileId(proof.photoPath) == null
                ? null
                : EvidencePhoto(
                    orderId: order.id,
                    fileId: buyerEvidenceFileId(proof.photoPath)!,
                    repository: repository,
                    semanticLabel: proof.milestone == 'DELIVERED'
                        ? 'Delivery photo'
                        : 'Pickup photo',
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(LucideIcons.info, size: 14, color: BuyerTheme.muted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  fulfillment.trackingNotice,
                  style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
                ),
              ),
            ],
          ),
        ),
        if (receipt.confirmedAt != null) ...[
          const SizedBox(height: 10),
          StatusBand(
            tone: BandTone.success,
            title: receipt.confirmationSource == 'AUTO_CONFIRMATION'
                ? 'Receipt confirmed automatically'
                : 'You confirmed receipt',
            message:
                '${formatManilaDateTime(receipt.confirmedAt!)}. For a later concern, use the return, warranty or dispute process.',
          ),
        ] else if (receipt.paused) ...[
          const SizedBox(height: 10),
          StatusBand(
            tone: BandTone.warning,
            title: 'Automatic confirmation is paused',
            message:
                'Your open problem report or dispute pauses the ${receipt.windowHours}-hour window.${receipt.remainingSeconds == null ? '' : ' ${_duration(receipt.remainingSeconds!)} will remain when it resumes.'}',
          ),
        ] else if (receipt.dueAt != null) ...[
          const SizedBox(height: 10),
          DeadlineCountdown(
            deadline: receipt.dueAt!,
            label: 'Confirm receipt or report a problem within',
            endedLabel: 'Automatic confirmation is due',
            onExpired: onReload,
            now: now,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              'If you do nothing, the order is confirmed automatically when this window ends.',
              style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
            ),
          ),
        ],
        if (issue != null) ...[
          const SizedBox(height: 10),
          _IssueCard(
            issue: issue,
            canResolve: order.actions.contains('RESOLVE_PROBLEM'),
            busy: busy,
            onResolve: () => onResolveProblem(issue),
          ),
        ],
        const SizedBox(height: 10),
        _ThreadEntry(thread: thread, onOpen: onOpenThread),
      ],
    );
  }
}

String _duration(int seconds) {
  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  if (hours > 0) return '$hours h ${minutes.toString().padLeft(2, '0')} min';
  return '$minutes min';
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 16, color: BuyerTheme.muted),
      const SizedBox(width: 6),
      Flexible(child: Text(text, style: const TextStyle(fontSize: 13))),
    ],
  );
}

class _IssueCard extends StatelessWidget {
  const _IssueCard({
    required this.issue,
    required this.canResolve,
    required this.busy,
    required this.onResolve,
  });

  final FulfillmentIssueView issue;
  final bool canResolve;
  final bool busy;
  final VoidCallback onResolve;

  @override
  Widget build(BuildContext context) {
    final open = issue.state == 'OPEN';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: open ? BuyerTheme.brandSoft : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: open ? BuyerTheme.action : BuyerTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                open ? LucideIcons.triangleAlert : LucideIcons.circleCheck,
                size: 18,
                color: open
                    ? BuyerTheme.actionPressed
                    : BuyerTheme.successStrong,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${open ? 'Problem reported' : 'Problem resolved'} · ${problemCategoryLabels[issue.category] ?? issue.category}',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(issue.description),
          if (issue.reportedAt != null)
            Text(
              'Reported ${formatManilaDateTime(issue.reportedAt!)}',
              style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
            ),
          if (issue.vendorResponse != null) ...[
            const SizedBox(height: 6),
            Text(
              'Vendor response: ${issue.vendorResponse}',
              style: const TextStyle(fontSize: 13),
            ),
          ],
          if (open && canResolve)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: busy ? null : onResolve,
                style: TextButton.styleFrom(minimumSize: const Size(44, 44)),
                icon: const Icon(LucideIcons.check, size: 16),
                label: const Text('Mark as resolved'),
              ),
            ),
        ],
      ),
    );
  }
}

class _ThreadEntry extends StatelessWidget {
  const _ThreadEntry({required this.thread, this.onOpen});

  final FulfillmentThreadView thread;
  final ValueChanged<String>? onOpen;

  @override
  Widget build(BuildContext context) {
    final id = thread.conversationId;
    if (!thread.available || id == null) {
      return Text(
        thread.notice ??
            'Fulfillment Messages open when the order is ready for pickup or out for delivery.',
        style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: onOpen == null ? null : () => onOpen!(id),
          icon: Icon(
            thread.readOnly ? LucideIcons.lock : LucideIcons.messageSquareText,
            size: 18,
          ),
          label: Text(
            thread.readOnly
                ? 'View Fulfillment Messages (read-only)'
                : 'Fulfillment Messages',
          ),
        ),
        if (thread.notice != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              thread.notice!,
              style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
            ),
          ),
      ],
    );
  }
}

/// A private order photo read through the API with the Buyer's session. Tapping opens it full size.
class EvidencePhoto extends StatefulWidget {
  const EvidencePhoto({
    super.key,
    required this.orderId,
    required this.fileId,
    required this.repository,
    required this.semanticLabel,
  });

  final String orderId;
  final String fileId;
  final OrdersRepository repository;
  final String semanticLabel;

  @override
  State<EvidencePhoto> createState() => _EvidencePhotoState();
}

class _EvidencePhotoState extends State<EvidencePhoto> {
  late Future<Uint8List> _bytes = _read();

  Future<Uint8List> _read() =>
      widget.repository.orderFile(widget.orderId, widget.fileId);

  @override
  Widget build(BuildContext context) => FutureBuilder<Uint8List>(
    future: _bytes,
    builder: (context, snapshot) {
      final bytes = snapshot.data;
      if (snapshot.hasError || (bytes != null && bytes.isEmpty)) {
        return Semantics(
          button: true,
          label: '${widget.semanticLabel} could not load. Retry',
          excludeSemantics: true,
          child: InkWell(
            onTap: () => setState(() => _bytes = _read()),
            child: const ColoredBox(
              color: BuyerTheme.canvas,
              child: Icon(LucideIcons.imageOff, color: BuyerTheme.muted),
            ),
          ),
        );
      }
      if (bytes == null) {
        return const ColoredBox(color: BuyerTheme.canvas);
      }
      return Semantics(
        button: true,
        label: '${widget.semanticLabel}. Open full size',
        excludeSemantics: true,
        child: InkWell(
          onTap: () => showDialog<void>(
            context: context,
            builder: (context) => Dialog(
              insetPadding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: InteractiveViewer(
                      child: Image.memory(
                        bytes,
                        semanticLabel: widget.semanticLabel,
                        errorBuilder: (_, _, _) => const Padding(
                          padding: EdgeInsets.all(24),
                          child: Text('This photo could not be shown.'),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ),
          child: Image.memory(
            bytes,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                const Icon(LucideIcons.imageOff, color: BuyerTheme.muted),
          ),
        ),
      );
    },
  );
}

const _remedyLabels = {
  'REPORT_PROBLEM': 'Report a Problem',
  'DISPUTE': 'Dispute',
  'RETURN': 'Return',
  'WARRANTY': 'Warranty',
  'STATUTORY_REMEDIES': 'Statutory remedies',
};

/// Cancellation availability with its server explanation. When cancellation is not available, the
/// reason and the remedies that stay open are shown in text.
class CancellationPanel extends StatelessWidget {
  const CancellationPanel({
    super.key,
    required this.order,
    required this.cancellation,
    required this.busy,
    required this.onCancel,
    required this.onWithdrawRequest,
    this.now,
  });

  final OrderDetailView order;
  final CancellationView cancellation;
  final bool busy;
  final VoidCallback onCancel;
  final VoidCallback onWithdrawRequest;
  final DateTime Function()? now;

  @override
  Widget build(BuildContext context) {
    final actions = order.actions;
    final cancelAction = actions.contains('WITHDRAW')
        ? 'Withdraw order request'
        : actions.contains('REQUEST_CANCELLATION')
        ? 'Request cancellation'
        : actions.contains('CANCEL')
        ? 'Cancel order'
        : null;
    final open = cancellation.mode == 'REQUEST_OPEN';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: open ? BuyerTheme.action : BuyerTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                open
                    ? LucideIcons.hourglass
                    : cancellation.available
                    ? LucideIcons.circleX
                    : LucideIcons.lock,
                size: 18,
                color: open ? BuyerTheme.actionPressed : BuyerTheme.muted,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  cancellation.explanation,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
          if (open) ...[
            if (cancellation.openRequestReason != null)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 28),
                child: Text(
                  'Your reason: ${cancellation.openRequestReason}',
                  style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
                ),
              ),
            if (cancellation.responseDueAt != null) ...[
              const SizedBox(height: 10),
              DeadlineCountdown(
                deadline: cancellation.responseDueAt!,
                label: 'Vendor responds within',
                endedLabel: 'Vendor response window ended',
                now: now,
              ),
            ],
          ],
          if (!cancellation.available &&
              cancellation.remedies.any((remedy) => remedy.available)) ...[
            const SizedBox(height: 10),
            const Text(
              'Still available to you',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            for (final remedy in cancellation.remedies.where(
              (remedy) => remedy.available,
            ))
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '${_remedyLabels[remedy.code] ?? remedy.code}: ${remedy.note}',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
          ],
          if (cancelAction != null) ...[
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: busy ? null : onCancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(MateryalColorTokens.statusError),
              ),
              child: Text(cancelAction),
            ),
          ],
          if (actions.contains('WITHDRAW_CANCELLATION_REQUEST')) ...[
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: busy ? null : onWithdrawRequest,
              child: const Text('Keep my order — withdraw request'),
            ),
          ],
        ],
      ),
    );
  }
}

/// The Buyer's chosen cancellation reason. Null fields when the step needs no reason.
typedef CancellationInput = ({String? reasonCode, String? reason});

/// Shows the server refund plan and collects a reason when required. Returns null when dismissed.
Future<CancellationInput?> showCancellationSheet(
  BuildContext context, {
  required OrderDetailView order,
  required OrdersRepository repository,
}) => showModalBottomSheet<CancellationInput>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  backgroundColor: Colors.white,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  ),
  builder: (_) => _CancellationSheet(order: order, repository: repository),
);

class _CancellationSheet extends StatefulWidget {
  const _CancellationSheet({required this.order, required this.repository});

  final OrderDetailView order;
  final OrdersRepository repository;

  @override
  State<_CancellationSheet> createState() => _CancellationSheetState();
}

class _CancellationSheetState extends State<_CancellationSheet> {
  late Future<CancellationPreviewView> _preview = _load();
  final _reason = TextEditingController();
  String? _code;
  String? _error;

  Future<CancellationPreviewView> _load() =>
      widget.repository.cancellationPreview(widget.order.id);

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  void _submit(CancellationView availability) {
    if (availability.requiresReason) {
      if (_code == null) {
        setState(() => _error = 'Choose a cancellation reason.');
        return;
      }
      if (_code == 'OTHER' && _reason.text.trim().length < 5) {
        setState(() => _error = 'Explain the reason in at least 5 characters.');
        return;
      }
    }
    final text = _reason.text.trim();
    Navigator.pop<CancellationInput>(context, (
      reasonCode: availability.requiresReason ? _code : null,
      reason: availability.requiresReason && text.isNotEmpty ? text : null,
    ));
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    child: FutureBuilder<CancellationPreviewView>(
      future: _preview,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: StateMessage(
              kind:
                  error is DiscoveryFailure &&
                      error.kind == DiscoveryFailureKind.offline
                  ? StateKind.offline
                  : StateKind.error,
              title: 'The cancellation summary could not load',
              message: error is DiscoveryFailure
                  ? error.message
                  : 'Try again in a moment.',
              actionLabel: 'Retry',
              onAction: () => setState(() => _preview = _load()),
            ),
          );
        }
        final preview = snapshot.data;
        if (preview == null) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SkeletonBox(height: 24),
                SizedBox(height: 12),
                SkeletonBox(height: 120),
              ],
            ),
          );
        }
        final availability = preview.availability;
        final request = availability.mode == 'REQUEST';
        final title = switch (availability.mode) {
          'WITHDRAW' => 'Withdraw this order request?',
          'CANCEL_BEFORE_PAYMENT' => 'Cancel before payment?',
          'REQUEST' => 'Request cancellation',
          _ => 'Cancel this order?',
        };
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                header: true,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(availability.explanation),
              const SizedBox(height: 12),
              _PlanCard(
                title: request
                    ? 'If the Vendor accepts without a preparation cost'
                    : 'What happens to your money',
                plan: preview.fullRefund,
              ),
              if (request && preview.withNrpcRetained != null) ...[
                const SizedBox(height: 8),
                _PlanCard(
                  title:
                      'If the Vendor keeps the accepted preparation cost (up to ${formatPeso(preview.nrpcRetainableCentavos)}) with evidence',
                  plan: preview.withNrpcRetained!,
                ),
              ],
              const SizedBox(height: 8),
              Text(
                preview.notice,
                style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
              ),
              if (availability.requiresReason) ...[
                const SizedBox(height: 16),
                const Text(
                  'Reason',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final code in availability.reasonCodes)
                      ChoiceChip(
                        label: Text(
                          buyerCancellationReasonLabels[code] ?? code,
                        ),
                        selected: _code == code,
                        onSelected: (_) => setState(() {
                          _code = code;
                          _error = null;
                        }),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _reason,
                  maxLength: 1000,
                  minLines: 2,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: _code == 'OTHER'
                        ? 'Explain your reason (required)'
                        : 'Details for the Vendor (optional)',
                  ),
                ),
              ],
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Semantics(
                    liveRegion: true,
                    child: Text(
                      _error!,
                      style: const TextStyle(
                        color: Color(MateryalColorTokens.statusError),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () => _submit(availability),
                child: Text(switch (availability.mode) {
                  'WITHDRAW' => 'Withdraw request',
                  'REQUEST' => 'Send cancellation request',
                  _ => 'Cancel order',
                }),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Keep my order'),
              ),
            ],
          ),
        );
      },
    ),
  );
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.title, required this.plan});

  final String title;
  final CancellationPlanView plan;

  @override
  Widget build(BuildContext context) {
    Widget row(String label, int amount, {bool strong = false}) => Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          Text(
            formatPeso(amount),
            style: TextStyle(
              fontWeight: strong ? FontWeight.w800 : FontWeight.w600,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
    final nothingPaid =
        plan.paidTotalCentavos == 0 && plan.cashReimbursementCentavos == 0;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: BuyerTheme.canvas,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BuyerTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          if (nothingPaid)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'Nothing was paid, so there is nothing to refund.',
                style: TextStyle(fontSize: 13),
              ),
            ),
          for (final payment in plan.payments)
            if (payment.refundCentavos > 0)
              row(
                'Refund to your original ${payment.channelName ?? 'payment method'}${payment.processingFeeCentavos > 0 ? ' (incl. ${formatPeso(payment.processingFeeCentavos)} fee)' : ''}',
                payment.refundCentavos,
                strong: true,
              ),
          if (plan.cashReimbursementCentavos > 0)
            row(
              'Cash reimbursement from the Vendor',
              plan.cashReimbursementCentavos,
              strong: true,
            ),
          if (plan.nrpcRetainedCentavos > 0)
            row('Preparation cost the Vendor keeps', plan.nrpcRetainedCentavos),
          if (plan.releasedUnpaidCentavos > 0)
            row('Unpaid amount no longer due', plan.releasedUnpaidCentavos),
        ],
      ),
    );
  }
}

/// A Buyer problem report: category, description and at most one photo.
typedef ProblemInput = ({
  String category,
  String description,
  ProblemPhoto? photo,
});

/// Picks one JPG or PNG up to 10 MB; null when cancelled. Replaceable in widget tests.
typedef ProblemPhotoPicker = Future<ProblemPhoto?> Function();

Future<ProblemPhoto?> pickProblemPhoto() async {
  final file = await FilePicker.pickFile(
    type: FileType.custom,
    allowedExtensions: ['jpg', 'jpeg', 'png'],
  );
  if (file == null) return null;
  return ProblemPhoto(
    bytes: await file.xFile.readAsBytes(),
    filename: file.name,
  );
}

Future<ProblemInput?> showProblemSheet(
  BuildContext context, {
  ProblemPhotoPicker picker = pickProblemPhoto,
}) => showModalBottomSheet<ProblemInput>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  backgroundColor: Colors.white,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  ),
  builder: (_) => _ProblemSheet(picker: picker),
);

class _ProblemSheet extends StatefulWidget {
  const _ProblemSheet({required this.picker});

  final ProblemPhotoPicker picker;

  @override
  State<_ProblemSheet> createState() => _ProblemSheetState();
}

class _ProblemSheetState extends State<_ProblemSheet> {
  final _description = TextEditingController();
  String? _category;
  ProblemPhoto? _photo;
  String? _error;

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final photo = await widget.picker();
    if (!mounted || photo == null) return;
    if (photo.bytes.isEmpty || photo.bytes.length > 10 * 1024 * 1024) {
      setState(() => _error = 'Choose a JPG or PNG up to 10 MB.');
      return;
    }
    setState(() {
      _photo = photo;
      _error = null;
    });
  }

  void _submit() {
    final description = _description.text.trim();
    if (_category == null) {
      setState(() => _error = 'Choose what went wrong.');
      return;
    }
    if (description.length < 10) {
      setState(
        () => _error = 'Describe the problem in at least 10 characters.',
      );
      return;
    }
    Navigator.pop<ProblemInput>(context, (
      category: _category!,
      description: description,
      photo: _photo,
    ));
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            child: const Text(
              'Report a problem',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'The Vendor is notified and automatic confirmation pauses until the problem is resolved. A report does not open a dispute.',
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final entry in problemCategoryLabels.entries)
                ChoiceChip(
                  label: Text(entry.value),
                  selected: _category == entry.key,
                  onSelected: (_) => setState(() {
                    _category = entry.key;
                    _error = null;
                  }),
                ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _description,
            minLines: 3,
            maxLines: 6,
            maxLength: 2000,
            decoration: const InputDecoration(
              labelText: 'What happened?',
              helperText: 'At least 10 characters',
            ),
          ),
          const SizedBox(height: 4),
          OutlinedButton.icon(
            onPressed: _pick,
            icon: Icon(
              _photo == null ? LucideIcons.camera : LucideIcons.imagePlus,
              size: 18,
            ),
            label: Text(
              _photo == null
                  ? 'Add a photo (optional)'
                  : 'Photo: ${_photo!.filename} — replace',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  _error!,
                  style: const TextStyle(
                    color: Color(MateryalColorTokens.statusError),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 12),
          FilledButton(onPressed: _submit, child: const Text('Send report')),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    ),
  );
}
