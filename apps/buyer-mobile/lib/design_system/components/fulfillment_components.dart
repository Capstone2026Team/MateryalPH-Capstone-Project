import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../features/item_procurement/procurement_models.dart'
    show formatPeso;
import '../../features/orders/order_models.dart';
import '../generated/color_tokens.dart';
import '../theme.dart';

/// Fulfillment and refund building blocks. Status is always text plus an icon, never color alone.
/// Proof is attached to the step that required it; refund initiation and refund success never share
/// a label, icon or color.

String fulfillmentRoleLabel(String? role) => switch (role) {
  'OWNER' => 'Vendor Owner',
  'STORE_MANAGER' => 'Store Manager',
  'STORE_STAFF' => 'Store Staff',
  'FULFILLMENT' => 'Fulfillment Staff',
  'BUYER' => 'You',
  'SYSTEM' => 'MateryalPH',
  null => '',
  _ => role.toLowerCase().replaceAll('_', ' '),
};

/// The ordered milestones from the server. [proofBuilder] renders the proof card under the step that
/// required it, so the photo and receiver are read in context instead of in a separate list.
class MilestoneTracker extends StatelessWidget {
  const MilestoneTracker({super.key, required this.steps, this.proofBuilder});

  final List<FulfillmentStepView> steps;
  final Widget Function(FulfillmentProofView proof)? proofBuilder;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: BuyerTheme.border),
    ),
    child: Column(
      children: [
        for (var index = 0; index < steps.length; index++)
          _MilestoneRow(
            step: steps[index],
            last: index == steps.length - 1,
            proof: steps[index].proof == null || proofBuilder == null
                ? null
                : proofBuilder!(steps[index].proof!),
          ),
      ],
    ),
  );
}

class _MilestoneRow extends StatelessWidget {
  const _MilestoneRow({required this.step, required this.last, this.proof});

  final FulfillmentStepView step;
  final bool last;
  final Widget? proof;

  @override
  Widget build(BuildContext context) {
    final complete = step.status == 'COMPLETE';
    final current = step.status == 'CURRENT';
    final color = complete
        ? BuyerTheme.successStrong
        : current
        ? BuyerTheme.action
        : BuyerTheme.muted;
    final statusText = complete
        ? 'Done'
        : current
        ? 'In progress'
        : 'Upcoming';
    final detail = [
      if (step.at != null) formatManilaDateTime(step.at!),
      if (complete && step.actorRole != null && step.actorRole != 'BUYER')
        'by ${fulfillmentRoleLabel(step.actorRole)}',
      if (!complete && step.proofRequired) 'Proof is recorded at this step',
    ].join(' · ');
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: complete
                        ? BuyerTheme.successStrong
                        : current
                        ? const Color(MateryalColorTokens.brandOrange50)
                        : Colors.white,
                    border: Border.all(color: color, width: 2),
                  ),
                  child: Icon(
                    complete
                        ? LucideIcons.check
                        : current
                        ? LucideIcons.circleDot
                        : LucideIcons.circleDashed,
                    size: 14,
                    color: complete ? Colors.white : color,
                  ),
                ),
                if (!last)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      color: complete
                          ? BuyerTheme.successStrong
                          : BuyerTheme.border,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    label: '${step.label}: $statusText',
                    excludeSemantics: true,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            step.label,
                            style: TextStyle(
                              fontWeight: current || complete
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              color: complete || current
                                  ? BuyerTheme.ink
                                  : BuyerTheme.muted,
                            ),
                          ),
                        ),
                        Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (detail.isNotEmpty)
                    Text(
                      detail,
                      style: const TextStyle(
                        fontSize: 12,
                        color: BuyerTheme.muted,
                      ),
                    ),
                  if (proof != null) ...[const SizedBox(height: 8), proof!],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Delivery or pickup proof attached to its milestone. [photo] is supplied by the screen, which reads
/// the private file through the API; nothing here holds a storage URL.
class ProofCard extends StatelessWidget {
  const ProofCard({super.key, required this.proof, this.photo});

  final FulfillmentProofView proof;
  final Widget? photo;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: BuyerTheme.canvas,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: BuyerTheme.border),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (photo != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(width: 64, height: 64, child: photo),
          ),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                proof.milestone == 'DELIVERED'
                    ? 'Proof of delivery'
                    : 'Proof of pickup',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              if (proof.receiverName != null)
                Text(
                  'Received by ${proof.receiverName}${proof.receiverKind == 'AUTHORIZED_RECEIVER' ? ' (authorized receiver)' : ''}',
                  style: const TextStyle(fontSize: 13),
                ),
              if (proof.handoverConfirmed)
                const Text(
                  'Handover confirmed by the Vendor',
                  style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
                ),
              if (proof.signaturePath != null)
                const Text(
                  'Signature on file',
                  style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// Refunds, Vendor cash reimbursements and amounts no longer due after a cancellation. A refund that
/// was only sent to the provider reads "Refund initiated"; only a verified provider result reads
/// "Refund processed".
class RefundTimelineCard extends StatelessWidget {
  const RefundTimelineCard({
    super.key,
    required this.timeline,
    this.busy = false,
    this.onAcknowledge,
  });

  final RefundTimelineView timeline;
  final bool busy;
  final ValueChanged<ReimbursementItemView>? onAcknowledge;

  @override
  Widget build(BuildContext context) {
    final decision = timeline.decision;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BuyerTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (decision != null) ...[
            Text(
              decision.cause == 'VENDOR'
                  ? 'Cancelled by the Vendor'
                  : decision.decidedBy == 'SYSTEM'
                  ? 'Cancelled — the Vendor did not respond in time'
                  : 'Cancelled at your request',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            if (decision.reason != null)
              Text(
                decision.reason!,
                style: const TextStyle(fontSize: 13, color: BuyerTheme.muted),
              ),
            if (decision.nrpcRetainedCentavos > 0)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'The Vendor kept ${formatPeso(decision.nrpcRetainedCentavos)} of the accepted preparation cost, with evidence on file.',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            const Divider(height: 20, color: BuyerTheme.border),
          ],
          for (final refund in timeline.refunds) _RefundRow(refund: refund),
          for (final item in timeline.reimbursements)
            _ReimbursementRow(
              item: item,
              busy: busy,
              onAcknowledge: onAcknowledge,
            ),
          if (timeline.noLongerDueCentavos > 0)
            _TimelineLine(
              icon: LucideIcons.ban,
              color: BuyerTheme.muted,
              title: 'No longer due',
              amount: timeline.noLongerDueCentavos,
              detail:
                  'This unpaid amount was released. It is not a refund because you never paid it.',
            ),
        ],
      ),
    );
  }
}

class _RefundRow extends StatelessWidget {
  const _RefundRow({required this.refund});

  final RefundItemView refund;

  @override
  Widget build(BuildContext context) {
    final (
      IconData icon,
      Color color,
      String title,
    ) = switch (refund.displayState) {
      'PROCESSED' => (
        LucideIcons.badgeCheck,
        BuyerTheme.successStrong,
        'Refund processed',
      ),
      'FAILED' => (
        LucideIcons.circleAlert,
        const Color(MateryalColorTokens.statusError),
        'Refund delayed — the Vendor is resolving it',
      ),
      'QUEUED' => (
        LucideIcons.clock,
        BuyerTheme.actionPressed,
        'Refund queued',
      ),
      _ => (
        LucideIcons.hourglass,
        BuyerTheme.actionPressed,
        'Refund initiated — not yet received',
      ),
    };
    final when = refund.displayState == 'PROCESSED'
        ? refund.completedAt
        : refund.requestedAt;
    return _TimelineLine(
      icon: icon,
      color: color,
      title: title,
      amount: refund.amountCentavos,
      detail: [
        'To your original ${refund.originalMethod}',
        if (refund.processingFeeCentavos > 0)
          'includes ${formatPeso(refund.processingFeeCentavos)} Payment Processing Fee',
        if (when != null) formatManilaDateTime(when),
      ].join(' · '),
      note: refund.displayState == 'PROCESSED'
          ? refund.arrivalNote ?? refund.message
          : refund.message,
    );
  }
}

class _ReimbursementRow extends StatelessWidget {
  const _ReimbursementRow({
    required this.item,
    required this.busy,
    this.onAcknowledge,
  });

  final ReimbursementItemView item;
  final bool busy;
  final ValueChanged<ReimbursementItemView>? onAcknowledge;

  @override
  Widget build(BuildContext context) {
    final confirmed = item.state == 'REIMBURSEMENT_CONFIRMED';
    return _TimelineLine(
      icon: confirmed ? LucideIcons.handCoins : LucideIcons.banknote,
      color: confirmed ? BuyerTheme.successStrong : BuyerTheme.actionPressed,
      title: confirmed
          ? 'Cash reimbursement confirmed'
          : 'Cash reimbursement from the Vendor',
      amount: item.amountCentavos,
      detail: item.message,
      trailing:
          !confirmed &&
              item.hasEvidence &&
              item.buyerAcknowledgedAt == null &&
              onAcknowledge != null
          ? TextButton(
              onPressed: busy ? null : () => onAcknowledge!(item),
              style: TextButton.styleFrom(minimumSize: const Size(44, 44)),
              child: const Text('I received it'),
            )
          : null,
    );
  }
}

class _TimelineLine extends StatelessWidget {
  const _TimelineLine({
    required this.icon,
    required this.color,
    required this.title,
    required this.amount,
    required this.detail,
    this.note,
    this.trailing,
  });

  final IconData icon;
  final Color color;
  final String title;
  final int amount;
  final String detail;
  final String? note;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formatPeso(amount),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
              Text(
                detail,
                style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
              ),
              if (note != null && note!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(note!, style: const TextStyle(fontSize: 13)),
                ),
              if (trailing != null)
                Align(alignment: Alignment.centerLeft, child: trailing),
            ],
          ),
        ),
      ],
    ),
  );
}
