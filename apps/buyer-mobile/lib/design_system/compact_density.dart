import 'package:flutter/material.dart';

/// Dense form density for long authoring screens (the Work Package editor and
/// its Edit Material sheet): smaller gaps, 44–48 dp fields and a bounded text
/// scale. Visible controls may shrink, but every target stays at least 44 dp.
abstract final class CompactDensity {
  static const gap = 8.0;
  static const gapLarge = 12.0;
  static const cardPadding = 12.0;
  static const sheetPadding = 16.0;
  static const cardRadius = 16.0;
  static const icon = 20.0;
  static const target = 44.0;

  /// Large system text sizes still grow the layout, up to this bound.
  static const minTextScale = 1.0;
  static const maxTextScale = 1.2;

  static ThemeData theme(ThemeData base) {
    final text = base.textTheme;
    final ink = text.bodyLarge?.color;
    return base.copyWith(
      textTheme: text.copyWith(
        titleMedium: text.titleMedium?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: ink,
        ),
        bodyLarge: text.bodyLarge?.copyWith(fontSize: 15),
        bodyMedium: text.bodyMedium?.copyWith(fontSize: 14),
        bodySmall: text.bodySmall?.copyWith(fontSize: 12),
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        helperMaxLines: 2,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: (base.filledButtonTheme.style ?? const ButtonStyle()).copyWith(
          minimumSize: const WidgetStatePropertyAll(Size(64, target)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: (base.outlinedButtonTheme.style ?? const ButtonStyle()).copyWith(
          minimumSize: const WidgetStatePropertyAll(Size(64, target)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(target, target),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(target, target),
          iconSize: icon,
          padding: EdgeInsets.zero,
        ),
      ),
      dividerTheme: base.dividerTheme.copyWith(space: 16),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.zero,
        minVerticalPadding: 4,
      ),
      expansionTileTheme: const ExpansionTileThemeData(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        shape: Border(),
        collapsedShape: Border(),
      ),
    );
  }
}

/// Applies [CompactDensity] and clamps the system text scale for [child].
/// Each route (page or sheet) needs its own scope.
class CompactScope extends StatelessWidget {
  const CompactScope({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => MediaQuery.withClampedTextScaling(
    minScaleFactor: CompactDensity.minTextScale,
    maxScaleFactor: CompactDensity.maxTextScale,
    child: Theme(data: CompactDensity.theme(Theme.of(context)), child: child),
  );
}

/// `buildCounter` that shows "n/max" only while the field is focused or the
/// text reaches 80% of its limit, so idle fields carry no counter line.
Widget? nearLimitCounter(
  BuildContext context, {
  required int currentLength,
  required bool isFocused,
  required int? maxLength,
}) {
  if (maxLength == null) return null;
  if (!isFocused && currentLength < maxLength * 0.8) return null;
  return Text(
    '$currentLength/$maxLength',
    style: Theme.of(context).textTheme.bodySmall,
  );
}

/// `buildCounter` for fields whose limit is enforced silently.
Widget? noCounter(
  BuildContext context, {
  required int currentLength,
  required bool isFocused,
  required int? maxLength,
}) => null;
