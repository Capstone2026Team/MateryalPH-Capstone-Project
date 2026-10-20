import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../features/disputes/dispute_models.dart';
import '../../features/item_procurement/procurement_models.dart'
    show formatPeso;
import '../../features/orders/order_models.dart' show formatManilaDateTime;
import '../generated/color_tokens.dart';
import '../theme.dart';
import 'order_components.dart' show DeadlineCountdown;

/// Dispute building blocks shared by the case list, the case workspace, filing and Order Details.
/// Status is always text plus an icon; deadlines are a live countdown plus the exact Asia/Manila
/// date and time; refunds are described only as returning to the original payment method.

/// Matches the web complaint fields and attributes the saved text to its filing party.
class DisputeComplaintDetails extends StatelessWidget {
  const DisputeComplaintDetails({super.key, required this.detail});

  final DisputeDetailView detail;

  @override
  Widget build(BuildContext context) {
    final filer = detail.filedByParty == 'VENDOR' ? 'Vendor' : 'Buyer';
    final description = detail.description;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ComplaintField(
          label: 'Issue',
          value: disputeIssueLabel(detail.issueType),
        ),
        const SizedBox(height: 12),
        _ComplaintField(
          label: 'Requested remedy',
          value:
              '${disputeRemedyLabel(detail.requestedRemedy)}${detail.requestedAmountCentavos != null ? ' · ${formatPeso(detail.requestedAmountCentavos!)}' : ''}',
        ),
        const SizedBox(height: 12),
        _ComplaintField(
          label: "$filer's description of the problem",
          value: description != null && description.trim().isNotEmpty
              ? description
              : 'No problem description was recorded.',
        ),
      ],
    );
  }
}

class _ComplaintField extends StatelessWidget {
  const _ComplaintField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: BuyerTheme.muted,
        ),
      ),
      const SizedBox(height: 4),
      Text(value),
    ],
  );
}

(IconData, Color, Color) _statusStyle(String status) => switch (status) {
  'RESOLVED' => (
    LucideIcons.circleCheck,
    BuyerTheme.successStrong,
    BuyerTheme.canvas,
  ),
  'CLOSED_INCONCLUSIVE' => (
    LucideIcons.circleSlash,
    BuyerTheme.muted,
    BuyerTheme.canvas,
  ),
  'DECIDED' ||
  'APPEAL_OPEN' => (LucideIcons.gavel, BuyerTheme.ink, BuyerTheme.canvas),
  'ESCALATED_ADMIN_REVIEW' || 'AWAITING_CLARIFICATION' => (
    LucideIcons.scale,
    const Color(MateryalColorTokens.actionPrimaryPressed),
    const Color(MateryalColorTokens.brandOrange50),
  ),
  _ => (
    LucideIcons.messageSquareWarning,
    const Color(MateryalColorTokens.actionPrimaryPressed),
    const Color(MateryalColorTokens.brandOrange50),
  ),
};

class DisputeStatusChip extends StatelessWidget {
  const DisputeStatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (icon, foreground, background) = _statusStyle(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: BuyerTheme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foreground),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              disputeStatusLabel(status),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: foreground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _whoActs(DisputeDeadlineView deadline) =>
    switch (deadline.responsibleParty) {
      'BUYER' => 'You must act before this time.',
      'VENDOR' => 'Waiting for the store.',
      'REQUESTED_PARTY' => 'The requested party must answer.',
      'EITHER' => 'Either party may appeal once until this time.',
      _ => 'Both parties may act until this time.',
    };

/// Every open case deadline with its countdown, exact Manila time and who must act.
class DisputeDeadlines extends StatelessWidget {
  const DisputeDeadlines({
    super.key,
    required this.deadlines,
    this.onExpired,
    this.now,
  });

  final List<DisputeDeadlineView> deadlines;
  final VoidCallback? onExpired;
  final DateTime Function()? now;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (final deadline in deadlines) ...[
        DeadlineCountdown(
          deadline: deadline.at,
          label: disputeDeadlineLabels[deadline.kind] ?? 'Due in',
          endedLabel: 'This window ended',
          onExpired: onExpired,
          now: now,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 10),
          child: Text(
            _whoActs(deadline),
            style: const TextStyle(fontSize: 13, color: BuyerTheme.muted),
          ),
        ),
      ],
    ],
  );
}

/// The masked original payment method, read-only. Refunds can only return here.
class OriginalPaymentMethodCard extends StatelessWidget {
  const OriginalPaymentMethodCard({
    super.key,
    required this.label,
    required this.notice,
  });

  final String label;
  final String notice;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: 'Original payment method, read only',
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: BuyerTheme.canvas,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: BuyerTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(LucideIcons.lock, size: 18, color: BuyerTheme.muted),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  notice,
                  style: const TextStyle(fontSize: 13, color: BuyerTheme.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

const _eventLabels = <String, String>{
  'CASE_FILED': 'Case filed',
  'RESPONSE_SUBMITTED': 'Response',
  'EVIDENCE_ADDED': 'Evidence added',
  'MESSAGE': 'Message',
  'PROPOSAL_MADE': 'Resolution proposed',
  'PROPOSAL_ACCEPTED': 'Proposal accepted',
  'PROPOSAL_REJECTED': 'Proposal rejected',
  'AGREEMENT_RECORDED': 'Agreement recorded',
  'ESCALATED': 'Escalated to MateryalPH',
  'CLARIFICATION_REQUESTED': 'Clarification requested',
  'CLARIFICATION_ANSWERED': 'Clarification answered',
  'CLARIFICATION_EXPIRED': 'Clarification window ended',
  'DECISION_ISSUED': 'Decision issued',
  'DECISION_ENFORCEABLE': 'Decision final',
  'APPEAL_FILED': 'Appeal filed',
  'APPEAL_DECIDED': 'Appeal decided',
  'REMEDY_CREATED': 'Remedy started',
  'REMEDY_UPDATED': 'Remedy updated',
  'REMEDY_COMPLETED': 'Remedy completed',
  'REFUND_UPDATED': 'Refund updated',
  'SANCTION_RECORDED': 'Account action recorded',
  'HANDLER_ASSIGNED': 'Handler assigned',
  'HANDLER_REASSIGNED': 'Handler changed',
  'CASE_RESOLVED': 'Case resolved',
  'CASE_CLOSED_INCONCLUSIVE': 'Closed as inconclusive',
  'ORDER_HOLD_CHANGED': 'Order hold changed',
};

String _actor(DisputeTimelineEntryView entry) => switch (entry.actorParty) {
  'BUYER' => 'You',
  'VENDOR' => entry.actorName,
  'ADMIN' => 'MateryalPH',
  _ => 'System',
};

/// One chronological surface: actor, role, Manila time, statement and evidence.
class DisputeTimelineList extends StatelessWidget {
  const DisputeTimelineList({
    super.key,
    required this.entries,
    required this.onOpenEvidence,
  });

  final List<DisputeTimelineEntryView> entries;
  final ValueChanged<DisputeEvidenceView> onOpenEvidence;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (var index = 0; index < entries.length; index++)
        _TimelineEntry(
          entry: entries[index],
          last: index == entries.length - 1,
          onOpenEvidence: onOpenEvidence,
        ),
    ],
  );
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({
    required this.entry,
    required this.last,
    required this.onOpenEvidence,
  });

  final DisputeTimelineEntryView entry;
  final bool last;
  final ValueChanged<DisputeEvidenceView> onOpenEvidence;

  @override
  Widget build(BuildContext context) {
    final admin = entry.actorParty == 'ADMIN';
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 20,
            child: Column(
              children: [
                const SizedBox(height: 4),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: admin ? BuyerTheme.action : BuyerTheme.border,
                  ),
                ),
                if (!last)
                  Expanded(
                    child: Container(width: 2, color: BuyerTheme.border),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _eventLabels[entry.type] ??
                        entry.type.replaceAll('_', ' ').toLowerCase(),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    [
                      _actor(entry),
                      if (entry.at != null) formatManilaDateTime(entry.at!),
                    ].join(' · '),
                    style: const TextStyle(
                      fontSize: 12,
                      color: BuyerTheme.muted,
                    ),
                  ),
                  if (entry.body != null && entry.body!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(entry.body!),
                  ],
                  if (entry.evidence.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final file in entry.evidence)
                          ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 44),
                            child: OutlinedButton.icon(
                              onPressed: () => onOpenEvidence(file),
                              icon: Icon(
                                file.isImage
                                    ? LucideIcons.image
                                    : LucideIcons.fileText,
                                size: 16,
                              ),
                              label: Text(
                                file.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// MateryalPH purchase-order and payment documents, always labelled as not the Vendor's invoice.
class PlatformDocumentsNotice extends StatelessWidget {
  const PlatformDocumentsNotice({super.key, required this.documents});

  final List<PlatformDocumentItem> documents;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (final document in documents)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(LucideIcons.fileX, size: 18, color: BuyerTheme.muted),
              const SizedBox(width: 8),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: document.title,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text:
                            ' · ${document.notTaxInvoice ? 'Not a tax invoice' : document.label}. ${document.availability}',
                      ),
                    ],
                  ),
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
    ],
  );
}

/// A Vendor invoice copy with its origin label, compliance note and reconciliation state.
class InvoiceRecordTile extends StatelessWidget {
  const InvoiceRecordTile({super.key, required this.record, this.onOpen});

  final InvoiceRecordItem record;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: BuyerTheme.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${record.invoiceType == 'VENDOR_ADJUSTMENT_DOCUMENT' ? 'Adjustment document' : 'Sales invoice'} ${record.invoiceNumber}',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        Text(
          '${record.issuer} · ${record.issuedOn} · ${formatPeso(record.amountCentavos)}',
          style: const TextStyle(fontSize: 13, color: BuyerTheme.muted),
        ),
        const SizedBox(height: 6),
        Text(
          record.originLabel,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(MateryalColorTokens.actionPrimaryPressed),
          ),
        ),
        Text(record.complianceNote, style: const TextStyle(fontSize: 12)),
        if (record.differs) ...[
          const SizedBox(height: 6),
          Text(
            'This copy differs from your accepted total by ${formatPeso(record.reconciliationDifferenceCentavos)}. What you pay does not change.',
            style: const TextStyle(fontSize: 13),
          ),
        ],
        if (record.reconciliationNote != null)
          Text(
            'Store explanation: ${record.reconciliationNote}',
            style: const TextStyle(fontSize: 13, color: BuyerTheme.muted),
          ),
        if (onOpen != null) ...[
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: OutlinedButton.icon(
              onPressed: onOpen,
              icon: const Icon(LucideIcons.fileDown, size: 16),
              label: const Text('Open invoice copy'),
            ),
          ),
        ],
      ],
    ),
  );
}
