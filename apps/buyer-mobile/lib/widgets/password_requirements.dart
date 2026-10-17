import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../design_system/theme.dart';

const buyerPasswordMinLength = 12;

class PasswordRequirement {
  const PasswordRequirement(this.label, this.met);

  final String label;
  final bool met;
}

/// Mirrors the API rule `Password::min(12)->mixedCase()->numbers()`; the server stays authoritative.
List<PasswordRequirement> passwordRequirements(String value) {
  return [
    PasswordRequirement(
      'Must be a minimum of $buyerPasswordMinLength characters in length',
      value.runes.length >= buyerPasswordMinLength,
    ),
    PasswordRequirement(
      'Must contain at least 1 uppercase letter',
      RegExp(r'\p{Lu}', unicode: true).hasMatch(value),
    ),
    PasswordRequirement(
      'Must contain at least 1 lowercase letter',
      RegExp(r'\p{Ll}', unicode: true).hasMatch(value),
    ),
    PasswordRequirement(
      'Must contain at least 1 number',
      RegExp(r'\p{N}', unicode: true).hasMatch(value),
    ),
  ];
}

bool passwordMeetsRequirements(String value) =>
    passwordRequirements(value).every((requirement) => requirement.met);

class PasswordRequirements extends StatelessWidget {
  const PasswordRequirements({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final requirements = passwordRequirements(controller.text);
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final requirement in requirements)
                Semantics(
                  label:
                      '${requirement.label}, ${requirement.met ? 'met' : 'not met'}',
                  excludeSemantics: true,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          margin: const EdgeInsets.only(top: 1),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: requirement.met
                                ? BuyerTheme.success
                                : Colors.transparent,
                            border: Border.all(
                              color: requirement.met
                                  ? BuyerTheme.success
                                  : BuyerTheme.border,
                              width: 1.5,
                            ),
                          ),
                          child: requirement.met
                              ? const Icon(
                                  LucideIcons.check,
                                  size: 13,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            requirement.label,
                            style: TextStyle(
                              fontSize: 14,
                              color: requirement.met
                                  ? BuyerTheme.ink
                                  : BuyerTheme.muted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
