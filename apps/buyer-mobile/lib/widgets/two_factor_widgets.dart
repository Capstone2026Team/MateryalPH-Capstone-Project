import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../design_system/theme.dart';

/// Six-digit authenticator code entry. Submits on its own once the sixth digit is typed or pasted.
class AuthenticatorCodeField extends StatelessWidget {
  const AuthenticatorCodeField({
    super.key,
    required this.controller,
    required this.onCompleted,
    this.enabled = true,
    this.autofocus = true,
    this.label = 'Authenticator code',
  });
  final TextEditingController controller;
  final VoidCallback onCompleted;
  final bool enabled;
  final bool autofocus;
  final String label;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    enabled: enabled,
    autofocus: autofocus,
    keyboardType: TextInputType.number,
    textAlign: TextAlign.center,
    autofillHints: const [AutofillHints.oneTimeCode],
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(6),
    ],
    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: 10,
      fontFeatures: const [FontFeature.tabularFigures()],
    ),
    onChanged: (value) {
      if (value.length == 6) onCompleted();
    },
    onSubmitted: (_) => onCompleted(),
    decoration: InputDecoration(labelText: label, hintText: '000000'),
  );
}

/// Shows single-use recovery codes once, with copy-all. The caller decides what "done" means.
class RecoveryCodesPanel extends StatelessWidget {
  const RecoveryCodesPanel({super.key, required this.codes});
  final List<String> codes;

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: codes.join('\n')));
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Recovery codes copied.')));
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: BuyerTheme.canvas,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: BuyerTheme.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          label: 'Recovery codes: ${codes.join(', ')}',
          excludeSemantics: true,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              for (final code in codes)
                Container(
                  width: 132,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: BuyerTheme.border),
                  ),
                  child: SelectableText(
                    code,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      color: BuyerTheme.ink,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => _copy(context),
          icon: const Icon(LucideIcons.copy, size: 18),
          label: const Text('Copy all codes'),
        ),
      ],
    ),
  );
}

/// One numbered step in the authenticator setup.
class TwoFactorStep extends StatelessWidget {
  const TwoFactorStep({
    super.key,
    required this.number,
    required this.title,
    required this.child,
  });
  final int number;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(
          child: Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: BuyerTheme.brandSoft,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              style: const TextStyle(
                color: BuyerTheme.action,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                header: true,
                label: 'Step $number: $title',
                excludeSemantics: true,
                child: Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 10),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              child,
            ],
          ),
        ),
      ],
    ),
  );
}
