import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/components/messaging_components.dart';
import '../../design_system/components/procurement_components.dart';

typedef QuotationDecision =
    Future<String?> Function(String action, api.ChatQuotationVersion version);

/// A list of published quotations, with full terms on a separate route.
class ConversationQuotationsScreen extends StatefulWidget {
  const ConversationQuotationsScreen({
    super.key,
    required this.quotations,
    required this.onDecide,
    required this.onLoadOlder,
    this.onOpenOrder,
    this.embedded = false,
  });

  final ValueListenable<api.ChatQuotationPage?> quotations;
  final QuotationDecision onDecide;
  final Future<void> Function() onLoadOlder;
  final void Function(String orderId)? onOpenOrder;
  final bool embedded;

  @override
  State<ConversationQuotationsScreen> createState() =>
      _ConversationQuotationsScreenState();
}

class _ConversationQuotationsScreenState
    extends State<ConversationQuotationsScreen> {
  bool _loadingOlder = false;
  bool _olderFailed = false;

  Future<void> _older() async {
    if (_loadingOlder) return;
    setState(() {
      _loadingOlder = true;
      _olderFailed = false;
    });
    try {
      await widget.onLoadOlder();
    } catch (_) {
      if (mounted) setState(() => _olderFailed = true);
    } finally {
      if (mounted) setState(() => _loadingOlder = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: widget.embedded ? null : buyerAppBar(context, 'Quotations'),
    body: SafeArea(
      child: ValueListenableBuilder<api.ChatQuotationPage?>(
        valueListenable: widget.quotations,
        builder: (context, page, _) {
          if (page == null) return const _QuotationUnavailable();
          if (page.versions.isEmpty) {
            return const StateMessage(
              kind: StateKind.empty,
              artwork: StateArtwork.inbox,
              title: 'No quotation yet',
              message:
                  'When the store sends a quotation for your request, it appears here.',
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              for (final version in page.versions)
                QuotationSummaryTile(
                  key: ValueKey(version.id),
                  version: version,
                  onOpen: () => Navigator.of(context).push<void>(
                    MaterialPageRoute(
                      builder: (_) => ConversationQuotationDetailScreen(
                        quotations: widget.quotations,
                        versionId: version.id,
                        onDecide: widget.onDecide,
                        onOpenOrder: widget.onOpenOrder,
                        embedded: widget.embedded,
                      ),
                    ),
                  ),
                ),
              if (_olderFailed)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('Unable to load older quotations. Please retry.'),
                ),
              if (page.hasMore)
                TextButton(
                  onPressed: _loadingOlder ? null : _older,
                  child: Text(
                    _loadingOlder
                        ? 'Loading older quotations…'
                        : _olderFailed
                        ? 'Retry older quotations'
                        : 'Older quotations',
                  ),
                ),
            ],
          );
        },
      ),
    ),
  );
}

class ConversationQuotationDetailScreen extends StatefulWidget {
  const ConversationQuotationDetailScreen({
    super.key,
    required this.quotations,
    required this.versionId,
    required this.onDecide,
    this.onOpenOrder,
    this.embedded = false,
  });

  final ValueListenable<api.ChatQuotationPage?> quotations;
  final String versionId;
  final QuotationDecision onDecide;
  final void Function(String orderId)? onOpenOrder;
  final bool embedded;

  @override
  State<ConversationQuotationDetailScreen> createState() =>
      _ConversationQuotationDetailScreenState();
}

class _ConversationQuotationDetailScreenState
    extends State<ConversationQuotationDetailScreen> {
  bool _busy = false;

  Future<void> _decide(String action, api.ChatQuotationVersion version) async {
    if (_busy) return;
    setState(() => _busy = true);
    String? message;
    try {
      message = await widget.onDecide(action, version);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
    if (!mounted || message == null) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_busy,
    child: Scaffold(
      appBar: buyerAppBar(
        context,
        'Quotation details',
        showBackButton: !widget.embedded,
      ),
      body: SafeArea(
        child: ValueListenableBuilder<api.ChatQuotationPage?>(
          valueListenable: widget.quotations,
          builder: (context, page, _) {
            final version = page?.versions
                .where((v) => v.id == widget.versionId)
                .firstOrNull;
            if (version == null) return const _QuotationUnavailable();
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              children: [
                QuotationVersionCard(
                  key: ValueKey(version.id),
                  version: version,
                  busy: _busy,
                  onAction: (action) => _decide(action, version),
                ),
                if (version.acceptedOrderId != null &&
                    widget.onOpenOrder != null)
                  FilledButton.tonalIcon(
                    icon: const Icon(Icons.receipt_long_outlined),
                    label: const Text('Open Order Details'),
                    onPressed: _busy
                        ? null
                        : () => widget.onOpenOrder!(version.acceptedOrderId!),
                  ),
              ],
            );
          },
        ),
      ),
    ),
  );
}

class _QuotationUnavailable extends StatelessWidget {
  const _QuotationUnavailable();

  @override
  Widget build(BuildContext context) => const StateMessage(
    kind: StateKind.error,
    title: 'Quotation unavailable',
    message: 'Return to the conversation and retry to check your access.',
  );
}
