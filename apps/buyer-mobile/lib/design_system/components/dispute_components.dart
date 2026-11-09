import 'async_state.dart';
import 'dart:typed_data';

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

/// A sent Vendor invoice: attachment first, then its preserved document and order facts.
class InvoiceRecordTile extends StatelessWidget {
  const InvoiceRecordTile({
    super.key,
    required this.record,
    this.onOpen,
    this.loadFile,
    this.onRefresh,
  });
  final InvoiceRecordItem record;
  final VoidCallback? onOpen;
  final Future<Uint8List> Function()? loadFile;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final summary = record.orderSummary;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BuyerTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.receiptText,
                size: 18,
                color: BuyerTheme.muted,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  record.invoiceType == 'VENDOR_ADJUSTMENT_DOCUMENT'
                      ? 'Adjustment document'
                      : 'Sales invoice',
                  style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
                ),
              ),
              const Icon(
                LucideIcons.circleCheck,
                size: 16,
                color: BuyerTheme.action,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            record.invoiceNumber,
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          InvoiceAttachmentPreview(
            record: record,
            loadFile: loadFile,
            onOpen: onOpen,
            onRefresh: onRefresh,
          ),
          const SizedBox(height: 20),
          const Text(
            'Invoice details',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _InvoiceFact(label: 'Issued by', value: record.issuer),
          if (summary?.billingName != null)
            _InvoiceFact(label: 'Bill to', value: summary!.billingName!),
          if (summary?.billingAddress != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                summary!.billingAddress!,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: BuyerTheme.muted,
                ),
              ),
            ),
          _InvoiceFact(label: 'Invoice date', value: record.issuedOn),
          if (record.sentAt != null)
            _InvoiceFact(
              label: 'Sent',
              value: formatManilaDateTime(record.sentAt!),
            ),
          if (record.sourceSystem != null)
            _InvoiceFact(
              label: 'Issued through',
              value:
                  const {
                    'REGISTERED_CAS': 'Registered CAS / accounting system',
                    'BIR_EIS': 'BIR EIS',
                    'LOOSE_LEAF_OR_PRINTED': 'Loose-leaf or printed (ATP)',
                    'OTHER_REGISTERED': 'Other registered process',
                  }[record.sourceSystem] ??
                  record.sourceSystem!,
            ),
          if (record.invoicingMethod != null)
            _InvoiceFact(
              label: 'Invoicing method',
              value:
                  const {
                    'ELECTRONIC': 'Electronic',
                    'COMPUTERIZED': 'Computerized',
                    'MANUAL': 'Manual',
                  }[record.invoicingMethod] ??
                  record.invoicingMethod!,
            ),
          if (record.vatCentavos != null)
            _InvoiceFact(
              label: 'VAT shown on invoice',
              value: formatPeso(record.vatCentavos!),
            ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: BuyerTheme.canvas,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Invoice total',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Flexible(
                  child: Text(
                    formatPeso(record.amountCentavos),
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (summary != null && summary.lines.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 16),
            const Text(
              'Accepted order breakdown',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            for (final line in summary.lines)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            line.name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${line.quantity.contains('.') ? line.quantity.replaceFirst(RegExp(r'\.?0+$'), '') : line.quantity} ${line.unit}${line.unitPriceCentavos == null ? '' : ' × ${formatPeso(line.unitPriceCentavos!)}'}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: BuyerTheme.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      line.totalCentavos == null
                          ? '—'
                          : formatPeso(line.totalCentavos!),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            const Divider(height: 20),
            if (summary.materialsCentavos != null)
              _InvoiceFact(
                label: 'Materials after discount',
                value: formatPeso(summary.materialsCentavos!),
              ),
            if (summary.deliveryCentavos != null)
              _InvoiceFact(
                label: 'Delivery fee',
                value: formatPeso(summary.deliveryCentavos!),
              ),
            if ((summary.discountCentavos ?? 0) > 0)
              _InvoiceFact(
                label: 'Discount (already applied)',
                value: formatPeso(summary.discountCentavos!),
              ),
            if (summary.vatCentavos != null)
              _InvoiceFact(
                label: 'VAT (included)',
                value: formatPeso(summary.vatCentavos!),
              ),
            if (summary.totalCentavos != null)
              _InvoiceFact(
                label: 'Accepted order total',
                value: formatPeso(summary.totalCentavos!),
              ),
          ],
          if (record.differs) ...[
            const SizedBox(height: 12),
            Text(
              'This copy differs from your accepted total by ${formatPeso(record.reconciliationDifferenceCentavos)}. What you pay does not change.',
              style: const TextStyle(fontSize: 13, height: 1.5),
            ),
          ],
          if (record.reconciliationNote != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Store explanation: ${record.reconciliationNote}',
                style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
              ),
            ),
          const SizedBox(height: 16),
          Text(
            record.originLabel,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(MateryalColorTokens.actionPrimaryPressed),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            record.complianceNote,
            style: const TextStyle(
              fontSize: 11,
              height: 1.5,
              color: BuyerTheme.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceFact extends StatelessWidget {
  const _InvoiceFact({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 6,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ),
      ],
    ),
  );
}

/// Images are loaded as authorized bytes; PDFs retain the existing secure open/save action.
class InvoiceAttachmentPreview extends StatefulWidget {
  const InvoiceAttachmentPreview({
    super.key,
    required this.record,
    this.loadFile,
    this.onOpen,
    this.onRefresh,
  });
  final InvoiceRecordItem record;
  final Future<Uint8List> Function()? loadFile;
  final VoidCallback? onOpen;
  final Future<void> Function()? onRefresh;
  @override
  State<InvoiceAttachmentPreview> createState() =>
      _InvoiceAttachmentPreviewState();
}

class _InvoiceAttachmentPreviewState extends State<InvoiceAttachmentPreview> {
  Future<Uint8List>? _preview;
  void _prepare() {
    _preview = widget.record.contentType?.startsWith('image/') == true
        ? widget.loadFile?.call()
        : null;
  }

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  @override
  void didUpdateWidget(covariant InvoiceAttachmentPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.record.id != widget.record.id ||
        oldWidget.record.downloadUrl != widget.record.downloadUrl) {
      _prepare();
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: BuyerTheme.canvas,
      border: Border.all(color: BuyerTheme.border),
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.all(14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_preview != null) ...[
          FutureBuilder<Uint8List>(
            future: _preview,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Column(
                  children: [
                    const Icon(
                      LucideIcons.imageOff,
                      size: 30,
                      color: BuyerTheme.muted,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Preview unavailable. Refresh to try again.',
                      style: TextStyle(fontSize: 12),
                    ),
                    if (widget.onRefresh != null)
                      TextButton(
                        onPressed: widget.onRefresh,
                        child: const Text('Refresh invoice'),
                      ),
                  ],
                );
              }
              if (!snapshot.hasData) {
                return const SizedBox(
                  height: 180,
                  child: Center(child: BuyerLoadingIndicator()),
                );
              }
              return Semantics(
                label: 'Uploaded invoice image',
                image: true,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.memory(
                    snapshot.data!,
                    height: 220,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'This image could not be previewed. Open the invoice copy to view it.',
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              LucideIcons.fileText,
              size: 30,
              color: BuyerTheme.action,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.record.fileName ?? 'Invoice document',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.record.contentType == 'application/pdf'
                        ? 'PDF document'
                        : widget.record.contentType?.startsWith('image/') == true
                        ? 'Image copy'
                        : 'Uploaded copy'}${widget.record.fileSizeBytes == null ? '' : ' · ${(widget.record.fileSizeBytes! / 1024).ceil()} KB'}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: BuyerTheme.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (widget.onOpen != null) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: widget.onOpen,
              icon: const Icon(LucideIcons.fileDown, size: 17),
              label: const Text('Open invoice copy'),
            ),
          ),
        ],
      ],
    ),
  );
}
