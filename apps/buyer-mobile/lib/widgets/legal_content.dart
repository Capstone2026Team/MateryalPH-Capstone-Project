import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class LegalContent extends StatelessWidget {
  const LegalContent(this.content, {super.key});
  final String content;

  @override
  Widget build(BuildContext context) => MarkdownBody(
    data: content,
    selectable: true,
    styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
      h1: Theme.of(context).textTheme.titleLarge,
      h2: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      h3: Theme.of(context).textTheme.titleSmall,
      p: Theme.of(context).textTheme.bodyLarge,
      blockSpacing: 20,
    ),
    onTapLink: (text, href, title) async {
      final uri = href == null ? null : Uri.tryParse(href);
      if (uri == null || !['https', 'mailto'].contains(uri.scheme)) return;
      try {
        if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return;
      } catch (_) {
        /* Report a safe, actionable message below. */
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This link could not be opened.')),
        );
      }
    },
  );
}
