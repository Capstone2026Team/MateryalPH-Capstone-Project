import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';
import '../item_procurement/procurement_models.dart' show formatPeso;
import '../map_discovery/discovery_models.dart';
import '../map_discovery/discovery_repository.dart' show newIdempotencyKey;
import 'order_models.dart';
import 'orders_repository.dart';
import 'orders_screen.dart' show orderAppBar;

/// The dedicated NRPC disclosure. The acceptance control activates only after the amount, reason,
/// affected lines and the versioned Terms have all been shown (scrolled through) and the Buyer ticks
/// the acknowledgement. Rejecting cancels the request. Flagging it as disproportionate is separate: it
/// creates a review record and never accepts, rejects or changes the order.
class NrpcDisclosureScreen extends StatefulWidget {
  const NrpcDisclosureScreen({
    super.key,
    required this.order,
    required this.repository,
  });

  final OrderDetailView order;
  final OrdersRepository repository;

  @override
  State<NrpcDisclosureScreen> createState() => _NrpcDisclosureScreenState();
}

class _NrpcDisclosureScreenState extends State<NrpcDisclosureScreen> {
  final _scroll = ScrollController();
  bool _reachedEnd = false;
  bool _acknowledged = false;
  bool _busy = false;
  String? _error;
  String? _key;

  NrpcView get _nrpc => widget.order.nrpc!;
  bool get _pending => widget.order.actions.contains('ACCEPT_NRPC');
  bool get _termsAvailable => _nrpc.terms?.content != null;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_checkEnd);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkEnd());
  }

  void _checkEnd() {
    if (!_scroll.hasClients || _reachedEnd) return;
    final position = _scroll.position;
    if (position.pixels >= position.maxScrollExtent - 24) {
      setState(() => _reachedEnd = true);
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _run(Future<OrderDetailView> Function(String key) action) async {
    if (_busy) return;
    final key = _key ??= newIdempotencyKey();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final updated = await action(key);
      if (mounted) Navigator.of(context).pop(updated);
    } on DiscoveryFailure catch (error) {
      if (error.kind != DiscoveryFailureKind.offline) _key = null;
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _reject() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject the preparation cost?'),
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
            child: const Text('Reject and cancel'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _run(
        (key) => widget.repository.rejectNrpc(
          widget.order.id,
          snapshotVersion: widget.order.snapshotVersion,
          nrpcId: _nrpc.id,
          idempotencyKey: key,
        ),
      );
    }
  }

  Future<void> _flag() async {
    final reason = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _FlagSheet(),
    );
    if (reason == null) return;
    await _run(
      (key) => widget.repository.flagNrpc(
        widget.order.id,
        nrpcId: _nrpc.id,
        reason: reason,
        idempotencyKey: key,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nrpc = _nrpc;
    final canAccept =
        _pending && _termsAvailable && _reachedEnd && _acknowledged && !_busy;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: orderAppBar(context, 'Preparation cost'),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Material(
          color: Colors.white,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: BuyerTheme.border)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_pending) ...[
                  CheckboxListTile(
                    value: _acknowledged,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: BuyerTheme.action,
                    onChanged: !_reachedEnd || !_termsAvailable || _busy
                        ? null
                        : (value) =>
                              setState(() => _acknowledged = value ?? false),
                    title: Text(
                      _reachedEnd
                          ? 'I reviewed the amount, reason, affected items and NRPC Terms v${nrpc.terms?.version ?? '-'}.'
                          : 'Scroll through the full disclosure to continue.',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _busy ? null : _reject,
                          child: const Text('Reject'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: Semantics(
                          button: true,
                          enabled: canAccept,
                          hint: canAccept
                              ? null
                              : 'Available after you review the full disclosure and tick the acknowledgement',
                          child: FilledButton(
                            onPressed: canAccept
                                ? () => _run(
                                    (key) => widget.repository.acceptNrpc(
                                      widget.order.id,
                                      snapshotVersion:
                                          widget.order.snapshotVersion,
                                      nrpcId: nrpc.id,
                                      termsVersionId: nrpc.terms!.id,
                                      idempotencyKey: key,
                                    ),
                                  )
                                : null,
                            child: Text(
                              _busy ? 'Saving…' : 'Accept preparation cost',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (widget.order.actions.contains('FLAG_NRPC'))
                  TextButton.icon(
                    onPressed: _busy ? null : _flag,
                    icon: const Icon(LucideIcons.flag, size: 16),
                    label: const Text('Flag as disproportionate'),
                  ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          controller: _scroll,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            if (_error != null) ...[
              StatusBand(tone: BandTone.danger, title: _error!),
              const SizedBox(height: 10),
            ],
            if (!_termsAvailable)
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: StatusBand(
                  tone: BandTone.danger,
                  title: 'The NRPC Terms are unavailable right now',
                  message:
                      'You cannot accept until the approved text can be shown. Retry later or reject.',
                ),
              ),
            Text(
              widget.order.vendorName,
              style: const TextStyle(color: BuyerTheme.muted),
            ),
            const SizedBox(height: 4),
            Semantics(
              header: true,
              child: Text(
                formatPeso(nrpc.amountCentavos),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Text(
              'Non-Recoverable Preparation Cost — part of your order value, not an extra charge.',
              style: TextStyle(color: BuyerTheme.muted),
            ),
            const SizedBox(height: 16),
            const _Label('Why the Vendor needs it'),
            Text(nrpc.reason),
            const SizedBox(height: 16),
            const _Label('Affected items'),
            for (final line in nrpc.affectedLines)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Expanded(child: Text(line.label)),
                    Text(
                      '${formatPeso(line.principalCentavos)} of ${formatPeso(line.linePayableCentavos)}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            const _Label('If the order is cancelled'),
            Text(nrpc.cancellationEffect),
            const SizedBox(height: 16),
            _Label(
              nrpc.terms == null
                  ? 'NRPC Terms'
                  : '${nrpc.terms!.title} · version ${nrpc.terms!.version}',
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: BuyerTheme.canvas,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: BuyerTheme.border),
              ),
              child: Text(
                nrpc.terms?.content ?? 'Terms text unavailable.',
                style: const TextStyle(fontSize: 13, height: 1.4),
              ),
            ),
            const SizedBox(height: 12),
            if (nrpc.flagged)
              const StatusBand(
                tone: BandTone.info,
                title: 'You flagged this preparation cost',
                message:
                    'It is being reviewed separately. Your decision is recorded on its own.',
              ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Semantics(
      header: true,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          color: BuyerTheme.ink,
        ),
      ),
    ),
  );
}

class _FlagSheet extends StatefulWidget {
  const _FlagSheet();

  @override
  State<_FlagSheet> createState() => _FlagSheetState();
}

class _FlagSheetState extends State<_FlagSheet> {
  final _reason = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      16,
      16,
      16,
      16 + MediaQuery.viewInsetsOf(context).bottom,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Flag as disproportionate',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        const Text(
          'MateryalPH staff review the concern. Flagging does not accept or reject the preparation cost.',
          style: TextStyle(color: BuyerTheme.muted),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _reason,
          minLines: 3,
          maxLines: 5,
          maxLength: 1000,
          decoration: InputDecoration(
            labelText: 'What seems disproportionate?',
            errorText: _error,
          ),
        ),
        FilledButton(
          onPressed: () {
            final text = _reason.text.trim();
            if (text.length < 10) {
              setState(
                () =>
                    _error = 'Describe your concern in at least 10 characters.',
              );
              return;
            }
            Navigator.of(context).pop(text);
          },
          child: const Text('Send for review'),
        ),
      ],
    ),
  );
}
