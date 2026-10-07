import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme.dart';

/// One layout for confirmations and forms, including large-text and keyboard use.
class BuyerDialog extends StatelessWidget {
  const BuyerDialog({
    super.key,
    required this.title,
    this.content,
    this.actions = const [],
  });

  final Widget title;
  final Widget? content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) => AlertDialog(
    scrollable: true,
    constraints: const BoxConstraints(minWidth: 280, maxWidth: 560),
    insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
    titlePadding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
    contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
    actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
    buttonPadding: EdgeInsets.zero,
    title: Semantics(header: true, child: title),
    content: content,
    actions: actions.isEmpty
        ? null
        : [
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var index = 0; index < actions.length; index++) ...[
                    if (index > 0) const SizedBox(height: 8),
                    actions[index],
                  ],
                ],
              ),
            ),
          ],
  );
}

/// Keeps feature-owned scrolling and keyboard padding, with a shared safe shell.
Future<T?> showBuyerBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isDismissible = true,
  bool enableDrag = true,
}) => showModalBottomSheet<T>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  isDismissible: isDismissible,
  enableDrag: enableDrag,
  showDragHandle: enableDrag,
  constraints: BoxConstraints(
    maxWidth: 640,
    maxHeight: MediaQuery.sizeOf(context).height * .9,
  ),
  builder: (context) => SafeArea(
    top: false,
    child: Theme(
      data: Theme.of(context).copyWith(
        listTileTheme: const ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          minTileHeight: 48,
          iconColor: BuyerTheme.muted,
          textColor: BuyerTheme.ink,
          selectedColor: BuyerTheme.action,
          selectedTileColor: BuyerTheme.brandSoft,
          titleTextStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            height: 1.5,
            fontWeight: FontWeight.w600,
          ),
          subtitleTextStyle: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            height: 1.5,
            color: BuyerTheme.muted,
          ),
        ),
      ),
      child: Builder(builder: builder),
    ),
  ),
);

/// Private image bytes stay in memory; opening a preview never publishes a URL.
class BuyerImageDialog extends StatelessWidget {
  const BuyerImageDialog({super.key, required this.bytes, required this.label});

  final Uint8List bytes;
  final String label;

  @override
  Widget build(BuildContext context) => Dialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    constraints: const BoxConstraints(maxWidth: 640),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
          child: Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Close',
                onPressed: () => Navigator.pop(context),
                icon: const Icon(LucideIcons.x),
              ),
            ],
          ),
        ),
        Flexible(
          child: ColoredBox(
            color: BuyerTheme.canvas,
            child: InteractiveViewer(
              child: Image.memory(
                bytes,
                fit: BoxFit.contain,
                semanticLabel: label,
                errorBuilder: (_, _, _) => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('This image could not be displayed.'),
                ),
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Pinch to zoom',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
          ),
        ),
      ],
    ),
  );
}
