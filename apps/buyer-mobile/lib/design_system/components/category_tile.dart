import 'package:flutter/material.dart';

import '../generated/color_tokens.dart';
import '../theme.dart';

/// Responsive grid for [CategoryTile]s: about 100 px columns (150 px under large text).
class CategoryTileGrid extends StatelessWidget {
  const CategoryTileGrid({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final scale = MediaQuery.textScalerOf(context).scale(1);
      final minimum = scale > 1.3 ? 150.0 : 100.0;
      final columns = (constraints.maxWidth / minimum).floor().clamp(1, 8);
      final width = (constraints.maxWidth - (columns - 1) * 10) / columns;
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final child in children) SizedBox(width: width, child: child),
        ],
      );
    },
  );
}

/// A category card: round icon, a two-line name and a count. [selected] marks the active filter.
class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.name,
    required this.icon,
    required this.countLabel,
    required this.semanticsLabel,
    required this.onTap,
    this.selected,
  });

  final String name;
  final IconData icon;
  final String countLabel;
  final String semanticsLabel;
  final VoidCallback onTap;

  /// Null for a navigation tile; true/false for a filter tile.
  final bool? selected;

  @override
  Widget build(BuildContext context) {
    final active = selected ?? false;
    return Semantics(
      container: true,
      button: true,
      selected: selected,
      label: semanticsLabel,
      excludeSemantics: true,
      child: Material(
        color: active
            ? const Color(MateryalColorTokens.brandOrange50)
            : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: active ? BuyerTheme.action : BuyerTheme.border,
            width: active ? 1.5 : 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 104),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 10),
              child: Column(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: active ? BuyerTheme.action : BuyerTheme.brandSoft,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 22,
                      color: active ? Colors.white : BuyerTheme.actionPressed,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height:
                        MediaQuery.textScalerOf(context).scale(12) * 1.25 * 2,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    countLabel,
                    style: const TextStyle(
                      fontSize: 11,
                      color: BuyerTheme.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
