import 'package:flutter/material.dart';

/// Reads canonical API field errors, including indexed errors on array inputs.
String? fieldErrorText(Map<String, Object?> errors, String field) {
  final messages = <String>{};
  for (final entry in errors.entries) {
    if (entry.key != field && !entry.key.startsWith('$field.')) continue;
    final value = entry.value;
    if (value is String && value.isNotEmpty) messages.add(value);
    if (value is List) {
      messages.addAll(
        value.whereType<String>().where((text) => text.isNotEmpty),
      );
    }
  }
  return messages.isEmpty ? null : messages.join('\n');
}

/// Inline validation for controls such as item checklists and attachment pickers.
class FormFieldError extends StatelessWidget {
  const FormFieldError(this.message, {super.key});

  final String? message;

  @override
  Widget build(BuildContext context) => message == null
      ? const SizedBox.shrink()
      : Semantics(
          liveRegion: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              message!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        );
}
