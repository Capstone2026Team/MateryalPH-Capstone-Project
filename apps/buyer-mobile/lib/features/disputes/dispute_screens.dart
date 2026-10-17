import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';

import '../../design_system/components/buyer_overlays.dart';
import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/components/invoice_request_form.dart';
import '../../design_system/components/dispute_components.dart';
import '../../design_system/components/fulfillment_components.dart'
    show RefundTimelineCard;
import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';
import '../item_procurement/procurement_models.dart' show formatPeso;
import '../map_discovery/discovery_models.dart';
import '../map_discovery/discovery_repository.dart' show newIdempotencyKey;
import '../orders/order_models.dart' show formatManilaDateTime;
import 'dispute_models.dart';
import 'disputes_repository.dart';

typedef EvidencePicker = Future<EvidenceFile?> Function();
typedef CaseFileOpener =
    Future<void> Function(
      BuildContext context,
      Uint8List bytes,
      String name,
      String contentType,
    );

const _maxEvidenceBytes = 10 * 1024 * 1024;

/// JPG, PNG or PDF up to 10 MB, read into memory. Files are scanned and stored privately.
Future<EvidenceFile?> pickEvidenceFile() async {
  final file = await FilePicker.pickFile(
    type: FileType.custom,
    allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
  );
  if (file == null) return null;
  final bytes = await file.xFile.readAsBytes();
  if (bytes.isEmpty || bytes.length > _maxEvidenceBytes) return null;
  return EvidenceFile(bytes: bytes, filename: file.name);
}

/// Images open in place; other files go to the system share sheet to save or view.
Future<void> openCaseFile(
  BuildContext context,
  Uint8List bytes,
  String name,
  String contentType,
) async {
  if (contentType.startsWith('image/')) {
    await showDialog<void>(
      context: context,
      builder: (context) => BuyerImageDialog(bytes: bytes, label: name),
    );
    return;
  }
  await SharePlus.instance.share(
    ShareParams(
      files: [XFile.fromData(bytes, mimeType: contentType)],
      fileNameOverrides: [name],
    ),
  );
}

int? _pesoToCentavos(String input) {
  final text = input.trim().replaceAll(',', '');
  final match = RegExp(r'^(\d{1,11})(?:\.(\d{1,2}))?$').firstMatch(text);
  if (match == null) return null;
  final value =
      int.parse(match.group(1)!) * 100 +
      int.parse((match.group(2) ?? '').padRight(2, '0'));
  return value > 0 ? value : null;
}

StateKind _stateKind(DiscoveryFailure failure) => switch (failure.kind) {
  DiscoveryFailureKind.offline => StateKind.offline,
  DiscoveryFailureKind.forbidden ||
  DiscoveryFailureKind.notFound => StateKind.forbidden,
  _ => StateKind.error,
};

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.icon});

  final String title;
  final Widget child;
  final IconData? icon;

  @override
  // A Material surface (not a coloured box) so list tiles inside keep their ink feedback.
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: BuyerTheme.border),
      ),
      child: Padding(padding: const EdgeInsets.all(14), child: _body()),
    ),
  );

  Widget _body() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Semantics(
        header: true,
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: BuyerTheme.ink),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      child,
    ],
  );
}

class _PromptField {
  const _PromptField(this.label, {this.maxLines = 1, this.maxLength});

  final String label;
  final int maxLines;
  final int? maxLength;
}

/// A short text prompt that owns its controllers, so they outlive the closing animation and are
/// disposed with the dialog. Returns the trimmed values, or null when cancelled.
class _PromptDialog extends StatefulWidget {
  const _PromptDialog({
    required this.title,
    required this.fields,
    required this.confirmLabel,
    required this.cancelLabel,
    this.intro,
  });

  final String title;
  final String? intro;
  final List<_PromptField> fields;
  final String confirmLabel;
  final String cancelLabel;

  static Future<List<String>?> show(
    BuildContext context, {
    required String title,
    required List<_PromptField> fields,
    required String confirmLabel,
    String cancelLabel = 'Cancel',
    String? intro,
  }) => showDialog<List<String>>(
    context: context,
    builder: (_) => _PromptDialog(
      title: title,
      intro: intro,
      fields: fields,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
    ),
  );

  @override
  State<_PromptDialog> createState() => _PromptDialogState();
}

class _PromptDialogState extends State<_PromptDialog> {
  late final _controllers = [
    for (var index = 0; index < widget.fields.length; index++)
      TextEditingController(),
  ];

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BuyerDialog(
    title: Text(widget.title),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.intro != null)
            Text(widget.intro!, style: const TextStyle(fontSize: 13)),
          for (var index = 0; index < widget.fields.length; index++)
            TextField(
              controller: _controllers[index],
              minLines: widget.fields[index].maxLines > 1 ? 2 : 1,
              maxLines: widget.fields[index].maxLines,
              maxLength: widget.fields[index].maxLength,
              decoration: InputDecoration(
                labelText: widget.fields[index].label,
              ),
            ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(widget.cancelLabel),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, [
          for (final controller in _controllers) controller.text.trim(),
        ]),
        child: Text(widget.confirmLabel),
      ),
    ],
  );
}

/// One attached file with change and remove controls.
class _EvidenceField extends StatelessWidget {
  const _EvidenceField({
    required this.file,
    required this.onPick,
    required this.onClear,
    this.label = 'Attach evidence (optional)',
  });

  final EvidenceFile? file;
  final VoidCallback onPick;
  final VoidCallback onClear;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 44),
              child: OutlinedButton.icon(
                onPressed: onPick,
                icon: const Icon(LucideIcons.paperclip, size: 16),
                label: Text(
                  file?.filename ?? label,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          if (file != null)
            IconButton(
              tooltip: 'Remove file',
              onPressed: onClear,
              icon: const Icon(LucideIcons.x),
            ),
        ],
      ),
      const Padding(
        padding: EdgeInsets.only(top: 4),
        child: Text(
          'JPG, PNG or PDF up to 10 MB, one file per submission. Add more files from the case later.',
          style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
        ),
      ),
    ],
  );
}

// ── Case list ───────────────────────────────────────────────────────────────────────────────────

/// The Buyer's transaction cases, newest first, with each case's next deadline.
class DisputesScreen extends StatefulWidget {
  const DisputesScreen({super.key, required this.repository, this.now});

  final DisputesRepository repository;
  final DateTime Function()? now;

  @override
  State<DisputesScreen> createState() => _DisputesScreenState();
}

class _DisputesScreenState extends State<DisputesScreen> {
  final _items = <DisputeSummaryView>[];
  DiscoveryFailure? _failure;
  bool _loading = true;
  bool _hasMore = false;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool more = false}) async {
    setState(() {
      _loading = true;
      _failure = null;
    });
    try {
      final page = await widget.repository.disputes(page: more ? _page + 1 : 1);
      if (!mounted) return;
      setState(() {
        if (!more) _items.clear();
        _items.addAll(page.items);
        _page = page.page;
        _hasMore = page.hasMore;
      });
    } on DiscoveryFailure catch (error) {
      if (mounted) setState(() => _failure = error);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _open(DisputeSummaryView item) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => DisputeDetailScreen(
          caseId: item.id,
          repository: widget.repository,
          now: widget.now,
        ),
      ),
    );
    if (mounted) await _load();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: buyerAppBar(context, 'Disputes'),
    body: SafeArea(
      child: _failure != null && _items.isEmpty
          ? StateMessage(
              kind: _stateKind(_failure!),
              title: 'Your cases could not load',
              message: _failure!.message,
              actionLabel: 'Retry',
              onAction: _load,
            )
          : _loading && _items.isEmpty
          ? ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                SkeletonBox(height: 84),
                SizedBox(height: 10),
                SkeletonBox(height: 84),
              ],
            )
          : _items.isEmpty
          ? StatePage(
              onRefresh: _load,
              child: const StateMessage(
                kind: StateKind.empty,
                artwork: StateArtwork.inbox,
                title: 'No disputes',
                message: 'Your order disputes will appear here.',
              ),
            )
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                itemCount: _items.length + (_hasMore ? 1 : 0),
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  if (index == _items.length) {
                    return Center(
                      child: TextButton(
                        onPressed: _loading ? null : () => _load(more: true),
                        child: Text(_loading ? 'Loading…' : 'Load more'),
                      ),
                    );
                  }
                  final item = _items[index];
                  return _CaseCard(item: item, onTap: () => _open(item));
                },
              ),
            ),
    ),
  );
}

class _CaseCard extends StatelessWidget {
  const _CaseCard({required this.item, required this.onTap});

  final DisputeSummaryView item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: BuyerTheme.border),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.reference,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                DisputeStatusChip(status: item.status),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${disputeIssueLabel(item.issueType)} · ${item.vendorName}',
              style: const TextStyle(color: BuyerTheme.muted),
            ),
            Text(
              'Order ${item.orderReference} · requested ${disputeRemedyLabel(item.requestedRemedy).toLowerCase()}${item.requestedAmountCentavos != null ? ' ${formatPeso(item.requestedAmountCentavos!)}' : ''}',
              style: const TextStyle(fontSize: 13, color: BuyerTheme.muted),
            ),
            if (item.nextDeadline != null) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    LucideIcons.clock,
                    size: 14,
                    color: BuyerTheme.actionPressed,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${item.nextDeadline!.responsibleParty == 'BUYER' ? 'Your action' : 'Next deadline'} · ${item.nextDeadline!.label}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
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
  );
}

// ── Filing ─────────────────────────────────────────────────────────────────────────────────────

/// Files a transaction dispute. The original payment method is shown masked and read-only; there
/// is no refund-destination field. Filing creates a Case ID and dispute state only.
class FileDisputeScreen extends StatefulWidget {
  const FileDisputeScreen({
    super.key,
    required this.orderId,
    required this.repository,
    this.picker = pickEvidenceFile,
  });

  final String orderId;
  final DisputesRepository repository;
  final EvidencePicker picker;

  @override
  State<FileDisputeScreen> createState() => _FileDisputeScreenState();
}

class _FileDisputeScreenState extends State<FileDisputeScreen> {
  DisputeEligibilityView? _eligibility;
  DiscoveryFailure? _failure;
  String? _issue;
  String? _remedy;
  final _lines = <String>{};
  final _amount = TextEditingController();
  final _description = TextEditingController();
  EvidenceFile? _file;
  String? _error;
  bool _busy = false;
  String? _key;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _amount.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _failure = null);
    try {
      final value = await widget.repository.eligibility(widget.orderId);
      if (mounted) setState(() => _eligibility = value);
    } on DiscoveryFailure catch (error) {
      if (mounted) setState(() => _failure = error);
    }
  }

  Future<void> _pick() async {
    final file = await widget.picker();
    if (!mounted) return;
    if (file == null) return;
    setState(() => _file = file);
  }

  Future<void> _submit() async {
    final partial = _remedy == 'PARTIAL_REFUND';
    final centavos = partial ? _pesoToCentavos(_amount.text) : null;
    final problem = _issue == null
        ? 'Choose what went wrong.'
        : _remedy == null
        ? 'Choose the remedy you are asking for.'
        : partial && centavos == null
        ? 'Enter the partial refund amount you are asking for.'
        : partial && _lines.isEmpty
        ? 'Select the affected items for a partial refund.'
        : _description.text.trim().length < 20
        ? 'Describe the problem in at least 20 characters.'
        : null;
    if (problem != null) {
      setState(() => _error = problem);
      return;
    }
    // A retried tap after a dropped connection reuses the same key, so only one case is filed.
    final key = _key ??= newIdempotencyKey();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final created = await widget.repository.file(
        orderId: widget.orderId,
        issueType: _issue!,
        requestedRemedy: _remedy!,
        description: _description.text.trim(),
        requestedAmountCentavos: centavos,
        affectedLineIds: _lines.toList(),
        evidence: _file,
        idempotencyKey: key,
      );
      if (!mounted) return;
      Navigator.of(context).pop(created);
    } on DiscoveryFailure catch (error) {
      if (error.kind != DiscoveryFailureKind.offline) _key = null;
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final eligibility = _eligibility;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buyerAppBar(context, 'File a dispute'),
      body: SafeArea(
        child: _failure != null
            ? StateMessage(
                kind: _stateKind(_failure!),
                title: 'Filing is not available right now',
                message: _failure!.message,
                actionLabel: 'Retry',
                onAction: _load,
              )
            : eligibility == null
            ? ListView(
                padding: const EdgeInsets.all(16),
                children: const [SkeletonBox(height: 260)],
              )
            : !eligibility.available
            ? StateMessage(
                kind: StateKind.forbidden,
                title: 'You cannot file a dispute for this order',
                message: eligibility.reason,
              )
            : _form(eligibility),
      ),
    );
  }

  Widget _form(DisputeEligibilityView eligibility) => ListView(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
    children: [
      const StatusBand(
        tone: BandTone.info,
        title: 'Filing does not refund automatically',
        message:
            'Filing opens a case. The store has 48 hours to respond; then you both have 72 hours to agree before MateryalPH can review. Only a concluded decision creates a refund.',
      ),
      if (eligibility.caseKind == 'POST_COMPLETION_RETURN' &&
          eligibility.postCompletionDeadline != null) ...[
        const SizedBox(height: 10),
        Text(
          'Post-completion return · file by ${formatManilaDateTime(eligibility.postCompletionDeadline!)}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
      const SizedBox(height: 16),
      DropdownButtonFormField<String>(
        initialValue: _issue,
        isExpanded: true,
        decoration: const InputDecoration(labelText: 'What went wrong?'),
        items: [
          for (final code in eligibility.issueTypes)
            DropdownMenuItem(value: code, child: Text(disputeIssueLabel(code))),
        ],
        onChanged: _busy ? null : (value) => setState(() => _issue = value),
      ),
      const SizedBox(height: 14),
      DropdownButtonFormField<String>(
        initialValue: _remedy,
        isExpanded: true,
        decoration: const InputDecoration(labelText: 'Requested remedy'),
        items: [
          for (final code in eligibility.requestedRemedies)
            DropdownMenuItem(
              value: code,
              child: Text(disputeRemedyLabel(code)),
            ),
        ],
        onChanged: _busy ? null : (value) => setState(() => _remedy = value),
      ),
      if (_remedy == 'PARTIAL_REFUND') ...[
        const SizedBox(height: 14),
        TextField(
          controller: _amount,
          enabled: !_busy,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Partial amount you are asking for (₱)',
            hintText: '0.00',
          ),
        ),
      ],
      if (eligibility.lines.isNotEmpty) ...[
        const SizedBox(height: 16),
        Semantics(
          header: true,
          child: const Text(
            'Affected items',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        for (final line in eligibility.lines)
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: _lines.contains(line.orderLineId),
            onChanged: _busy
                ? null
                : (checked) => setState(
                    () => checked == true
                        ? _lines.add(line.orderLineId)
                        : _lines.remove(line.orderLineId),
                  ),
            title: Text(line.displayName),
            subtitle: Text(
              '${line.quantity} · ${formatPeso(line.lineTotalCentavos)}',
            ),
          ),
      ],
      const SizedBox(height: 14),
      TextField(
        controller: _description,
        enabled: !_busy,
        minLines: 4,
        maxLines: 8,
        maxLength: 4000,
        decoration: const InputDecoration(
          labelText: 'Describe the problem',
          alignLabelWithHint: true,
        ),
      ),
      const SizedBox(height: 4),
      _EvidenceField(
        file: _file,
        onPick: _busy ? () {} : _pick,
        onClear: () => setState(() => _file = null),
      ),
      const SizedBox(height: 16),
      OriginalPaymentMethodCard(
        label: eligibility.methodLabel,
        notice: eligibility.refundDestinationNotice,
      ),
      if (_error != null) ...[
        const SizedBox(height: 12),
        Semantics(
          liveRegion: true,
          child: Text(
            _error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ],
      const SizedBox(height: 16),
      ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: FilledButton(
          onPressed: _busy ? null : _submit,
          child: Text(_busy ? 'Filing…' : 'File dispute'),
        ),
      ),
    ],
  );
}

// ── Case workspace ──────────────────────────────────────────────────────────────────────────────

/// One case: deadlines, the original complaint, one chronological timeline with evidence, the
/// decisions, the remedy and its Dispute-Conclusion Refunds, and only the actions the server allows.
class DisputeDetailScreen extends StatefulWidget {
  const DisputeDetailScreen({
    super.key,
    required this.caseId,
    required this.repository,
    this.now,
    this.picker = pickEvidenceFile,
    this.openFile = openCaseFile,
  });

  final String caseId;
  final DisputesRepository repository;
  final DateTime Function()? now;
  final EvidencePicker picker;
  final CaseFileOpener openFile;

  @override
  State<DisputeDetailScreen> createState() => _DisputeDetailScreenState();
}

class _DisputeDetailScreenState extends State<DisputeDetailScreen> {
  DisputeDetailView? _case;
  DiscoveryFailure? _failure;
  String? _notice;
  bool _busy = false;
  String? _key;
  String? _scope;
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _failure = null);
    try {
      final value = await widget.repository.dispute(widget.caseId);
      if (mounted) setState(() => _case = value);
    } on DiscoveryFailure catch (error) {
      if (mounted) setState(() => _failure = error);
    }
  }

  /// Runs one case action. An offline retry of the same action reuses its key; a conflict
  /// (a deadline passed or the other party acted) reloads the server state.
  Future<bool> _act(
    String scope,
    Future<DisputeDetailView> Function(String key) action,
    String success,
  ) async {
    if (_busy) return false;
    if (_scope != scope) _key = null;
    _scope = scope;
    final key = _key ??= newIdempotencyKey();
    setState(() {
      _busy = true;
      _notice = null;
    });
    try {
      final updated = await action(key);
      _key = null;
      if (!mounted) return true;
      setState(() {
        _case = updated;
        _notice = success;
      });
      if (_scroll.hasClients) {
        unawaited(
          _scroll.animateTo(
            0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          ),
        );
      }
      return true;
    } on DiscoveryFailure catch (error) {
      if (error.kind != DiscoveryFailureKind.offline) _key = null;
      if (mounted) setState(() => _notice = error.message);
      if (error.kind == DiscoveryFailureKind.conflict) await _load();
      return false;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _openEvidence(DisputeEvidenceView file) async {
    if (file.expiresAt.isBefore((widget.now ?? DateTime.now)())) {
      await _load();
      if (mounted) {
        setState(() => _notice = 'File links refreshed. Open the file again.');
      }
      return;
    }
    try {
      final bytes = await widget.repository.evidenceFile(file.url);
      if (!mounted) return;
      await widget.openFile(context, bytes, file.name, file.contentType);
    } on DiscoveryFailure catch (error) {
      if (mounted) setState(() => _notice = error.message);
      if (error.kind == DiscoveryFailureKind.forbidden ||
          error.kind == DiscoveryFailureKind.notFound) {
        await _load();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = _case;
    return Scaffold(
      backgroundColor: BuyerTheme.canvas,
      appBar: buyerAppBar(context, detail?.reference ?? 'Dispute'),
      body: SafeArea(
        child: detail == null
            ? (_failure == null
                  ? ListView(
                      padding: const EdgeInsets.all(16),
                      children: const [
                        SkeletonBox(height: 90),
                        SizedBox(height: 12),
                        SkeletonBox(height: 260),
                      ],
                    )
                  : StateMessage(
                      kind: _stateKind(_failure!),
                      title: 'This case could not load',
                      message: _failure!.message,
                      actionLabel: 'Retry',
                      onAction: _load,
                    ))
            : RefreshIndicator(onRefresh: _load, child: _content(detail)),
      ),
    );
  }

  Widget _content(DisputeDetailView detail) => ListView(
    controller: _scroll,
    padding: const EdgeInsets.fromLTRB(12, 8, 12, 32),
    children: [
      _Header(detail: detail),
      const SizedBox(height: 10),
      if (_notice != null) ...[
        Semantics(
          liveRegion: true,
          child: StatusBand(tone: BandTone.info, title: _notice!),
        ),
        const SizedBox(height: 10),
      ],
      if (detail.deadlines.isNotEmpty)
        DisputeDeadlines(
          deadlines: detail.deadlines,
          onExpired: _load,
          now: widget.now,
        ),
      if (detail.concluded)
        StatusBand(
          tone: BandTone.success,
          title: detail.status == 'RESOLVED'
              ? 'This case is resolved'
              : 'This case closed as inconclusive',
          message: 'Its history stays on record.',
        )
      else if (detail.status == 'DECIDED' &&
          detail.remedies.any((remedy) => remedy.state == 'PENDING'))
        const StatusBand(
          tone: BandTone.warning,
          title: 'Remedy in progress',
          message:
              'The case is not resolved until the remedy completes. Refunds return only to your original payment method.',
        ),
      const SizedBox(height: 10),
      ..._actions(detail),
      _Section(
        title: 'Your complaint',
        icon: LucideIcons.fileWarning,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (detail.description != null) Text(detail.description!),
            for (final line in detail.affectedLines)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  '• ${line.displayName} · ${formatPeso(line.lineTotalCentavos)}',
                ),
              ),
            if (detail.originalMethodLabel != null) ...[
              const SizedBox(height: 12),
              OriginalPaymentMethodCard(
                label: detail.originalMethodLabel!,
                notice: detail.originalMethodNotice ?? '',
              ),
            ],
          ],
        ),
      ),
      if (detail.decisions.isNotEmpty)
        _Section(
          title: 'Decisions',
          icon: LucideIcons.gavel,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final decision in detail.decisions)
                _DecisionTile(decision: decision),
            ],
          ),
        ),
      if (!detail.refundTimeline.isEmpty)
        _Section(
          title: 'Dispute-Conclusion Refunds',
          icon: LucideIcons.rotateCcw,
          child: RefundTimelineCard(timeline: detail.refundTimeline),
        ),
      _Section(
        title: 'Case timeline',
        icon: LucideIcons.history,
        child: DisputeTimelineList(
          entries: detail.timeline,
          onOpenEvidence: _openEvidence,
        ),
      ),
    ],
  );

  List<Widget> _actions(DisputeDetailView detail) {
    final actions = detail.actions;
    return [
      for (final clarification in detail.clarifications.where(
        (item) => item.canAnswer,
      ))
        _ClarificationCard(
          clarification: clarification,
          busy: _busy,
          picker: widget.picker,
          now: widget.now,
          onSubmit: (response, file) => _act(
            'clarify:${clarification.id}',
            (key) => widget.repository.answerClarification(
              detail.id,
              clarificationId: clarification.id,
              response: response,
              evidence: file,
              idempotencyKey: key,
            ),
            'Answer sent to MateryalPH.',
          ),
        ),
      for (final proposal in detail.proposals.where((item) => item.canAnswer))
        _ProposalCard(
          proposal: proposal,
          busy: _busy,
          onAnswer: (accept) => _act(
            'proposal:${proposal.id}',
            (key) => widget.repository.answerProposal(
              detail.id,
              proposalId: proposal.id,
              accept: accept,
              idempotencyKey: key,
            ),
            accept
                ? 'You accepted the proposal. It is recorded as the agreed resolution.'
                : 'You rejected the proposal.',
          ),
        ),
      for (final remedy in detail.remedies.where((item) => item.canConfirm))
        _Section(
          title: 'Replacement delivered?',
          icon: LucideIcons.packageCheck,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                remedy.note ??
                    'The store recorded the replacement. Confirm once you have it.',
              ),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: _busy
                    ? null
                    : () => _act(
                        'replacement:${remedy.id}',
                        (key) => widget.repository.confirmReplacement(
                          detail.id,
                          remedyId: remedy.id,
                          idempotencyKey: key,
                        ),
                        'Replacement confirmed.',
                      ),
                child: const Text('I received the replacement'),
              ),
            ],
          ),
        ),
      if (actions.contains('APPEAL'))
        _AppealCard(
          busy: _busy,
          picker: widget.picker,
          onSubmit: (grounds, statement, file) => _act(
            'appeal',
            (key) => widget.repository.appeal(
              detail.id,
              grounds: grounds,
              statement: statement,
              evidence: file,
              idempotencyKey: key,
            ),
            'Appeal filed. A different reviewer decides it, and that decision is final.',
          ),
        ),
      if (actions.contains('PROPOSE'))
        _ProposeCard(
          busy: _busy,
          onSubmit: (remedy, amount, terms) => _act(
            'propose',
            (key) => widget.repository.propose(
              detail.id,
              remedy: remedy,
              amountCentavos: amount,
              terms: terms,
              idempotencyKey: key,
            ),
            'Proposal sent to the store.',
          ),
        ),
      if (actions.contains('ADD_EVIDENCE') || actions.contains('MESSAGE'))
        _ContributeCard(
          busy: _busy,
          picker: widget.picker,
          canMessage: actions.contains('MESSAGE'),
          canAddEvidence: actions.contains('ADD_EVIDENCE'),
          onMessage: (body) => _act(
            'message',
            (key) => widget.repository.message(
              detail.id,
              body: body,
              idempotencyKey: key,
            ),
            'Message added to the case.',
          ),
          onEvidence: (file, description) => _act(
            'evidence',
            (key) => widget.repository.addEvidence(
              detail.id,
              evidence: file,
              description: description,
              idempotencyKey: key,
            ),
            'Evidence added to the case.',
          ),
        ),
      if (actions.contains('ESCALATE'))
        _EscalateCard(
          busy: _busy,
          onSubmit: (reason) => _act(
            'escalate',
            (key) => widget.repository.escalate(
              detail.id,
              reason: reason,
              idempotencyKey: key,
            ),
            'Sent to MateryalPH for review.',
          ),
        ),
    ];
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.detail});

  final DisputeDetailView detail;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
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
            Expanded(
              child: Text(
                detail.reference,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            DisputeStatusChip(status: detail.status),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${disputeIssueLabel(detail.issueType)} · ${detail.vendorName}',
          style: const TextStyle(color: BuyerTheme.muted),
        ),
        Text(
          'Order ${detail.orderReference} · requested ${disputeRemedyLabel(detail.requestedRemedy).toLowerCase()}${detail.requestedAmountCentavos != null ? ' ${formatPeso(detail.requestedAmountCentavos!)}' : ''}',
          style: const TextStyle(fontSize: 13, color: BuyerTheme.muted),
        ),
        if (detail.filedAt != null)
          Text(
            '${detail.filedByParty == 'BUYER' ? 'Filed by you' : 'Filed by the store'} · ${formatManilaDateTime(detail.filedAt!)}',
            style: const TextStyle(fontSize: 13, color: BuyerTheme.muted),
          ),
      ],
    ),
  );
}

class _DecisionTile extends StatelessWidget {
  const _DecisionTile({required this.decision});

  final DisputeDecisionView decision;

  @override
  Widget build(BuildContext context) {
    final kind = switch (decision.kind) {
      'MUTUAL_AGREEMENT' => 'Agreement',
      'APPEAL_DECISION' =>
        'Appeal ${decision.appealResult?.toLowerCase() ?? 'decision'}',
      _ => 'MateryalPH decision',
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 3,
            color: decision.current ? BuyerTheme.action : BuyerTheme.border,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$kind · ${disputeRemedyLabel(decision.outcome)}${decision.awardedCentavos > 0 ? ' · ${formatPeso(decision.awardedCentavos)}' : ''}',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          if (decision.decidedAt != null)
            Text(
              '${formatManilaDateTime(decision.decidedAt!)}${decision.current ? '' : ' · superseded, kept on record'}',
              style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
            ),
          if (decision.reason != null) ...[
            const SizedBox(height: 4),
            Text(decision.reason!),
          ],
          if (decision.evidenceLimitation != null)
            Text(
              'Evidence limitation: ${decision.evidenceLimitation}',
              style: const TextStyle(fontSize: 13, color: BuyerTheme.muted),
            ),
          if (decision.current &&
              !decision.enforceable &&
              decision.appealDueAt != null &&
              decision.kind == 'ADMIN_DECISION')
            Text(
              'Becomes final if neither party appeals by ${formatManilaDateTime(decision.appealDueAt!)}.',
              style: const TextStyle(fontSize: 13),
            ),
        ],
      ),
    );
  }
}

class _ProposalCard extends StatelessWidget {
  const _ProposalCard({
    required this.proposal,
    required this.busy,
    required this.onAnswer,
  });

  final DisputeProposalView proposal;
  final bool busy;
  final Future<bool> Function(bool accept) onAnswer;

  Future<void> _confirm(BuildContext context, bool accept) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => BuyerDialog(
        title: Text(accept ? 'Accept this proposal?' : 'Reject this proposal?'),
        content: Text(
          accept
              ? 'It becomes the agreed resolution for this case. Any refund returns only to your original payment method.'
              : 'The case continues. You can still escalate to MateryalPH when allowed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Not now'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(accept ? 'Accept' : 'Reject'),
          ),
        ],
      ),
    );
    if (ok == true) await onAnswer(accept);
  }

  @override
  Widget build(BuildContext context) => _Section(
    title: 'The store proposed a resolution',
    icon: LucideIcons.handshake,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${disputeRemedyLabel(proposal.remedy)}${proposal.amountCentavos != null ? ' · ${formatPeso(proposal.amountCentavos!)}' : ''}',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(proposal.terms),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: busy ? null : () => _confirm(context, false),
                child: const Text('Reject'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton(
                onPressed: busy ? null : () => _confirm(context, true),
                child: const Text('Accept'),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _ClarificationCard extends StatefulWidget {
  const _ClarificationCard({
    required this.clarification,
    required this.busy,
    required this.picker,
    required this.onSubmit,
    this.now,
  });

  final DisputeClarificationView clarification;
  final bool busy;
  final EvidencePicker picker;
  final Future<bool> Function(String response, EvidenceFile? file) onSubmit;
  final DateTime Function()? now;

  @override
  State<_ClarificationCard> createState() => _ClarificationCardState();
}

class _ClarificationCardState extends State<_ClarificationCard> {
  final _response = TextEditingController();
  EvidenceFile? _file;
  String? _error;

  @override
  void dispose() {
    _response.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _Section(
    title: 'MateryalPH needs your answer',
    icon: LucideIcons.messageCircleQuestion,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.clarification.question),
        const SizedBox(height: 10),
        TextField(
          controller: _response,
          minLines: 3,
          maxLines: 6,
          maxLength: 4000,
          decoration: const InputDecoration(labelText: 'Your answer'),
        ),
        _EvidenceField(
          file: _file,
          onPick: () async {
            final file = await widget.picker();
            if (file != null && mounted) setState(() => _file = file);
          },
          onClear: () => setState(() => _file = null),
        ),
        if (_error != null)
          Text(
            _error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        const SizedBox(height: 10),
        FilledButton(
          onPressed: widget.busy
              ? null
              : () async {
                  if (_response.text.trim().length < 5) {
                    setState(() => _error = 'Write your answer.');
                    return;
                  }
                  setState(() => _error = null);
                  if (await widget.onSubmit(_response.text.trim(), _file) &&
                      mounted) {
                    _response.clear();
                    setState(() => _file = null);
                  }
                },
          child: const Text('Send answer'),
        ),
      ],
    ),
  );
}

class _AppealCard extends StatefulWidget {
  const _AppealCard({
    required this.busy,
    required this.picker,
    required this.onSubmit,
  });

  final bool busy;
  final EvidencePicker picker;
  final Future<bool> Function(
    String grounds,
    String statement,
    EvidenceFile? file,
  )
  onSubmit;

  @override
  State<_AppealCard> createState() => _AppealCardState();
}

class _AppealCardState extends State<_AppealCard> {
  bool _open = false;
  String _grounds = 'NEW_EVIDENCE';
  final _statement = TextEditingController();
  EvidenceFile? _file;
  String? _error;

  @override
  void dispose() {
    _statement.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _Section(
    title: 'Appeal this decision',
    icon: LucideIcons.scale,
    child: !_open
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Each case allows one appeal, on new evidence or a material process error. A different reviewer decides it and that decision is final.',
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: widget.busy
                    ? null
                    : () => setState(() => _open = true),
                child: const Text('Start an appeal'),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RadioGroup<String>(
                groupValue: _grounds,
                onChanged: (value) =>
                    setState(() => _grounds = value ?? _grounds),
                child: const Column(
                  children: [
                    RadioListTile<String>(
                      contentPadding: EdgeInsets.zero,
                      value: 'NEW_EVIDENCE',
                      title: Text('New evidence'),
                    ),
                    RadioListTile<String>(
                      contentPadding: EdgeInsets.zero,
                      value: 'MATERIAL_PROCESS_ERROR',
                      title: Text('Material process error'),
                    ),
                  ],
                ),
              ),
              TextField(
                controller: _statement,
                minLines: 3,
                maxLines: 6,
                maxLength: 4000,
                decoration: const InputDecoration(
                  labelText: 'Why the decision should change',
                ),
              ),
              _EvidenceField(
                file: _file,
                label: _grounds == 'NEW_EVIDENCE'
                    ? 'Attach the new evidence'
                    : 'Attach evidence (optional)',
                onPick: () async {
                  final file = await widget.picker();
                  if (file != null && mounted) setState(() => _file = file);
                },
                onClear: () => setState(() => _file = null),
              ),
              if (_error != null)
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: widget.busy
                    ? null
                    : () async {
                        final problem = _statement.text.trim().length < 20
                            ? 'Explain your appeal in at least 20 characters.'
                            : _grounds == 'NEW_EVIDENCE' && _file == null
                            ? 'Attach the new evidence.'
                            : null;
                        setState(() => _error = problem);
                        if (problem != null) return;
                        await widget.onSubmit(
                          _grounds,
                          _statement.text.trim(),
                          _file,
                        );
                      },
                child: const Text('File appeal'),
              ),
            ],
          ),
  );
}

class _ProposeCard extends StatefulWidget {
  const _ProposeCard({required this.busy, required this.onSubmit});

  final bool busy;
  final Future<bool> Function(String remedy, int? amount, String terms)
  onSubmit;

  @override
  State<_ProposeCard> createState() => _ProposeCardState();
}

class _ProposeCardState extends State<_ProposeCard> {
  bool _open = false;
  String _remedy = 'REPLACEMENT';
  final _amount = TextEditingController();
  final _terms = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _amount.dispose();
    _terms.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _Section(
    title: 'Propose a resolution',
    icon: LucideIcons.handshake,
    child: !_open
        ? OutlinedButton(
            onPressed: widget.busy ? null : () => setState(() => _open = true),
            child: const Text('Make a proposal'),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _remedy,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Remedy'),
                items: [
                  for (final code in const [
                    'REPLACEMENT',
                    'FULL_REFUND',
                    'PARTIAL_REFUND',
                    'NO_FURTHER_ACTION',
                  ])
                    DropdownMenuItem(
                      value: code,
                      child: Text(disputeRemedyLabel(code)),
                    ),
                ],
                onChanged: (value) =>
                    setState(() => _remedy = value ?? _remedy),
              ),
              if (_remedy == 'PARTIAL_REFUND')
                TextField(
                  controller: _amount,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Amount (₱)'),
                ),
              TextField(
                controller: _terms,
                minLines: 2,
                maxLines: 5,
                maxLength: 2000,
                decoration: const InputDecoration(labelText: 'Terms'),
              ),
              if (_error != null)
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: widget.busy
                    ? null
                    : () async {
                        final amount = _remedy == 'PARTIAL_REFUND'
                            ? _pesoToCentavos(_amount.text)
                            : null;
                        final problem =
                            _remedy == 'PARTIAL_REFUND' && amount == null
                            ? 'Enter the amount.'
                            : _terms.text.trim().length < 10
                            ? 'Describe the terms in at least 10 characters.'
                            : null;
                        setState(() => _error = problem);
                        if (problem != null) return;
                        if (await widget.onSubmit(
                              _remedy,
                              amount,
                              _terms.text.trim(),
                            ) &&
                            mounted) {
                          setState(() => _open = false);
                        }
                      },
                child: const Text('Send proposal'),
              ),
            ],
          ),
  );
}

class _ContributeCard extends StatefulWidget {
  const _ContributeCard({
    required this.busy,
    required this.picker,
    required this.canMessage,
    required this.canAddEvidence,
    required this.onMessage,
    required this.onEvidence,
  });

  final bool busy;
  final EvidencePicker picker;
  final bool canMessage;
  final bool canAddEvidence;
  final Future<bool> Function(String body) onMessage;
  final Future<bool> Function(EvidenceFile file, String? description)
  onEvidence;

  @override
  State<_ContributeCard> createState() => _ContributeCardState();
}

class _ContributeCardState extends State<_ContributeCard> {
  final _text = TextEditingController();
  EvidenceFile? _file;
  String? _error;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _text.text.trim();
    if (_file != null) {
      if (await widget.onEvidence(_file!, text.isEmpty ? null : text) &&
          mounted) {
        _text.clear();
        setState(() => _file = null);
      }
      return;
    }
    if (text.length < 2) {
      setState(() => _error = 'Write a message or attach a file.');
      return;
    }
    setState(() => _error = null);
    if (await widget.onMessage(text) && mounted) _text.clear();
  }

  @override
  Widget build(BuildContext context) => _Section(
    title: 'Add to the case',
    icon: LucideIcons.paperclip,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _text,
          minLines: 2,
          maxLines: 5,
          maxLength: 4000,
          decoration: InputDecoration(
            labelText: _file != null
                ? 'Describe the file (optional)'
                : 'Message',
          ),
        ),
        if (widget.canAddEvidence)
          _EvidenceField(
            file: _file,
            onPick: () async {
              final file = await widget.picker();
              if (file != null && mounted) setState(() => _file = file);
            },
            onClear: () => setState(() => _file = null),
          ),
        if (_error != null)
          Text(
            _error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        const SizedBox(height: 10),
        FilledButton(
          onPressed: widget.busy || (!widget.canMessage && _file == null)
              ? null
              : _send,
          child: Text(_file != null ? 'Add evidence' : 'Send message'),
        ),
      ],
    ),
  );
}

class _EscalateCard extends StatefulWidget {
  const _EscalateCard({required this.busy, required this.onSubmit});

  final bool busy;
  final Future<bool> Function(String reason) onSubmit;

  @override
  State<_EscalateCard> createState() => _EscalateCardState();
}

class _EscalateCardState extends State<_EscalateCard> {
  Future<void> _start() async {
    final values = await _PromptDialog.show(
      context,
      title: 'Ask MateryalPH to review?',
      confirmLabel: 'Request review',
      cancelLabel: 'Not now',
      fields: const [_PromptField('Reason', maxLines: 5, maxLength: 2000)],
    );
    final reason = values?.first;
    if (reason == null || reason.length < 10) {
      if (reason != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Give a reason of at least 10 characters.'),
          ),
        );
      }
      return;
    }
    await widget.onSubmit(reason);
  }

  @override
  Widget build(BuildContext context) => _Section(
    title: 'Need MateryalPH to decide?',
    icon: LucideIcons.shieldAlert,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Escalate when the store did not respond in time or you could not agree.',
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: widget.busy ? null : _start,
          child: const Text('Request MateryalPH review'),
        ),
      ],
    ),
  );
}

// ── Invoices ────────────────────────────────────────────────────────────────────────────────────

/// The Vendor's uploaded invoice copies and copy/correction requests for one order.
class OrderInvoicesScreen extends StatefulWidget {
  const OrderInvoicesScreen({
    super.key,
    required this.orderId,
    required this.repository,
    this.openFile = openCaseFile,
    this.now,
  });

  final String orderId;
  final DisputesRepository repository;
  final CaseFileOpener openFile;
  final DateTime Function()? now;

  @override
  State<OrderInvoicesScreen> createState() => _OrderInvoicesScreenState();
}

class _OrderInvoicesScreenState extends State<OrderInvoicesScreen> {
  BuyerInvoicesView? _data;
  DiscoveryFailure? _failure;
  String? _notice;
  bool _busy = false;
  String? _key;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _failure = null);
    try {
      final value = await widget.repository.invoices(widget.orderId);
      if (mounted) setState(() => _data = value);
    } on DiscoveryFailure catch (error) {
      if (mounted) setState(() => _failure = error);
    }
  }

  Future<void> _run(
    Future<BuyerInvoicesView> Function(String key) action,
    String success,
  ) async {
    if (_busy) return;
    final key = _key ??= newIdempotencyKey();
    setState(() {
      _busy = true;
      _notice = null;
    });
    try {
      final value = await action(key);
      _key = null;
      if (mounted) {
        setState(() {
          _data = value;
          _notice = success;
        });
      }
    } on DiscoveryFailure catch (error) {
      if (error.kind != DiscoveryFailureKind.offline) _key = null;
      if (mounted) setState(() => _notice = error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _request(String kind, {String? recordId}) async {
    final data = _data;
    if (data == null || _busy) return;
    var current = data;
    String? key;
    String? requestBody;
    final result = await Navigator.of(context).push<InvoiceBillingInput>(
      MaterialPageRoute(
        builder: (_) => InvoiceRequestFormScreen(
          initial: InvoiceBillingInput(
            name: data.billingName ?? '',
            address: data.billingAddress ?? '',
          ),
          tinMasked: data.tinMasked,
          requestKind: kind,
          submitLabel: 'Submit Request',
          notice:
              'The Vendor aims to provide the copy or correction within three business days. This service target never extends its legal issuance deadline. Business TIN is optional.',
          onSubmit: (input) async {
            final body = [
              input.name,
              input.address,
              input.tin,
              input.details,
            ].toString();
            if (requestBody != body) {
              key = null;
              requestBody = body;
            }
            key ??= newIdempotencyKey();
            current = await widget.repository.saveBillingDetails(
              widget.orderId,
              billingName: input.name,
              billingAddress: input.address,
              tin: input.tin,
              lockVersion: current.billingLockVersion,
            );
            if (mounted) setState(() => _data = current);
            current = await widget.repository.requestInvoice(
              widget.orderId,
              kind: kind,
              details: input.details!,
              invoiceRecordId: recordId,
              idempotencyKey: key!,
            );
            if (mounted) setState(() => _data = current);
          },
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() => _notice = 'Request sent to the store.');
    }
  }

  Future<void> _open(InvoiceRecordItem record) async {
    try {
      final bytes = await widget.repository.invoiceFile(record.downloadUrl!);
      if (!mounted) return;
      await widget.openFile(
        context,
        bytes,
        'invoice-${record.invoiceNumber}.pdf',
        'application/pdf',
      );
    } on DiscoveryFailure catch (error) {
      if (mounted) setState(() => _notice = error.message);
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;
    return Scaffold(
      backgroundColor: BuyerTheme.canvas,
      appBar: buyerAppBar(context, 'Invoices'),
      body: SafeArea(
        child: data == null
            ? (_failure == null
                  ? ListView(
                      padding: const EdgeInsets.all(16),
                      children: const [SkeletonBox(height: 200)],
                    )
                  : StateMessage(
                      kind: _stateKind(_failure!),
                      title: 'Invoices could not load',
                      message: _failure!.message,
                      actionLabel: 'Retry',
                      onAction: _load,
                    ))
            : RefreshIndicator(
                onRefresh: _load,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 32),
                  children: [
                    if (_notice != null) ...[
                      Semantics(
                        liveRegion: true,
                        child: StatusBand(tone: BandTone.info, title: _notice!),
                      ),
                      const SizedBox(height: 10),
                    ],
                    _Section(
                      title: 'Store invoice',
                      icon: LucideIcons.receiptText,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            data.issuanceNotice,
                            style: const TextStyle(fontSize: 13),
                          ),
                          const SizedBox(height: 10),
                          if (data.records.isEmpty)
                            const Text(
                              'No invoice copy uploaded yet.',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          for (final record in data.records)
                            InvoiceRecordTile(
                              record: record,
                              onOpen: record.downloadUrl == null || _busy
                                  ? null
                                  : () => _open(record),
                            ),
                          if (data.canRequestCopy)
                            OutlinedButton.icon(
                              onPressed: _busy ? null : () => _request('COPY'),
                              icon: const Icon(LucideIcons.filePlus, size: 16),
                              label: const Text('Request a copy'),
                            ),
                          if (data.canRequestCorrection &&
                              data.records.isNotEmpty)
                            OutlinedButton.icon(
                              onPressed: _busy
                                  ? null
                                  : () => _request(
                                      'CORRECTION',
                                      recordId: data.records.last.id,
                                    ),
                              icon: const Icon(LucideIcons.filePen, size: 16),
                              label: const Text('Request a correction'),
                            ),
                        ],
                      ),
                    ),
                    if (data.requests.isNotEmpty)
                      _Section(
                        title: 'Your requests',
                        icon: LucideIcons.listChecks,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (final request in data.requests)
                              _RequestTile(
                                request: request,
                                busy: _busy,
                                onAnswer: (close) {
                                  _key = null;
                                  return _run(
                                    (key) =>
                                        widget.repository.answerInvoiceRequest(
                                          widget.orderId,
                                          requestId: request.id,
                                          close: close,
                                          idempotencyKey: key,
                                        ),
                                    close
                                        ? 'Request closed.'
                                        : 'Returned to the store for correction.',
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _RequestTile extends StatelessWidget {
  const _RequestTile({
    required this.request,
    required this.busy,
    required this.onAnswer,
  });

  final InvoiceRequestItem request;
  final bool busy;
  final Future<void> Function(bool close) onAnswer;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${request.kind == 'CORRECTION' ? 'Correction' : 'Copy'} · ${request.state.replaceAll('_', ' ').toLowerCase()}',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        if (request.open)
          Text(
            request.overdue
                ? 'Past the service target (${request.serviceTargetLabel})'
                : 'Service target ${request.serviceTargetLabel}',
            style: TextStyle(
              fontSize: 13,
              color: request.overdue
                  ? Theme.of(context).colorScheme.error
                  : BuyerTheme.muted,
            ),
          ),
        if (request.details != null)
          Text(request.details!, style: const TextStyle(fontSize: 13)),
        if (request.canReturn || request.canClose)
          Wrap(
            spacing: 8,
            children: [
              if (request.canReturn)
                TextButton(
                  onPressed: busy ? null : () => onAnswer(false),
                  child: const Text('Return for correction'),
                ),
              if (request.canClose)
                TextButton(
                  onPressed: busy ? null : () => onAnswer(true),
                  child: const Text('Close request'),
                ),
            ],
          ),
      ],
    ),
  );
}
