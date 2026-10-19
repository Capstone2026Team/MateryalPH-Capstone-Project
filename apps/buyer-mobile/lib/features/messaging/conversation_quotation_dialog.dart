import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

import '../../design_system/components/buyer_overlays.dart';
import 'conversation_quotations_screen.dart';

/// Keeps quotation list/detail navigation inside the modal above the thread.
class ConversationQuotationDialog extends StatefulWidget {
  const ConversationQuotationDialog({
    super.key,
    required this.quotations,
    required this.onDecide,
    required this.onLoadOlder,
    this.initialVersionId,
    this.onOpenOrder,
  });

  final ValueListenable<api.ChatQuotationPage?> quotations;
  final QuotationDecision onDecide;
  final Future<void> Function() onLoadOlder;
  final String? initialVersionId;
  final void Function(String)? onOpenOrder;

  @override
  State<ConversationQuotationDialog> createState() =>
      _ConversationQuotationDialogState();
}

class _ConversationQuotationDialogState
    extends State<ConversationQuotationDialog> {
  int _operations = 0;

  Future<T> _run<T>(Future<T> Function() action) async {
    setState(() => _operations++);
    try {
      return await action();
    } finally {
      if (mounted) setState(() => _operations--);
    }
  }

  Future<String?> _decide(String action, api.ChatQuotationVersion version) =>
      _run(() => widget.onDecide(action, version));

  Widget _details(String id) => ConversationQuotationDetailScreen(
    quotations: widget.quotations,
    versionId: id,
    onDecide: _decide,
    onOpenOrder: widget.onOpenOrder,
    embedded: true,
  );

  @override
  Widget build(BuildContext context) => BuyerContentDialog(
    title: 'Quotation history',
    busy: _operations > 0,
    child: HeroControllerScope.none(
      child: Navigator(
        onGenerateInitialRoutes: (_, _) => [
          MaterialPageRoute<void>(
            builder: (_) => ConversationQuotationsScreen(
              quotations: widget.quotations,
              onDecide: _decide,
              onLoadOlder: () => _run(widget.onLoadOlder),
              onOpenOrder: widget.onOpenOrder,
              embedded: true,
            ),
          ),
          if (widget.initialVersionId case final id?)
            MaterialPageRoute<void>(builder: (_) => _details(id)),
        ],
        onGenerateRoute: (_) => null,
      ),
    ),
  );
}
