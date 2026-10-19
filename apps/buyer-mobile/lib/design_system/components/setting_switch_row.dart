import 'package:flutter/material.dart';
import '../theme.dart';

/// A labelled on/off setting: the label on the left, the switch right-aligned
/// and vertically centred, and optional helper text underneath in a smaller,
/// muted style. The whole row toggles, so the target stays at least 48 dp.
///
/// The off state is an outlined track with a dark thumb, so an off switch
/// never reads as a disabled one.
class SettingSwitchRow extends StatelessWidget {
  const SettingSwitchRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.helper,
  });
  final String label;
  final String? helper;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = onChanged != null;
    return MergeSemantics(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: enabled ? () => onChanged!(!value) : null,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
                  const SizedBox(width: 12),
                  Switch(
                    value: value,
                    onChanged: onChanged,
                    thumbColor: WidgetStateProperty.resolveWith(
                      (states) => _fade(
                        states,
                        states.contains(WidgetState.selected)
                            ? Colors.white
                            : BuyerTheme.muted,
                      ),
                    ),
                    trackColor: WidgetStateProperty.resolveWith(
                      (states) => _fade(
                        states,
                        states.contains(WidgetState.selected)
                            ? BuyerTheme.action
                            : Colors.white,
                      ),
                    ),
                    trackOutlineColor: WidgetStateProperty.resolveWith(
                      (states) => states.contains(WidgetState.selected)
                          ? Colors.transparent
                          : _fade(states, BuyerTheme.muted),
                    ),
                    trackOutlineWidth: const WidgetStatePropertyAll(2),
                  ),
                ],
              ),
              if (helper != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    helper!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: BuyerTheme.muted,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  static Color _fade(Set<WidgetState> states, Color color) =>
      states.contains(WidgetState.disabled)
      ? color.withValues(alpha: 0.38)
      : color;
}
