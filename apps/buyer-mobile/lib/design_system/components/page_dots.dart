import 'package:flutter/material.dart';

import '../theme.dart';

/// Swipeable-gallery position indicator; announced once as "Photo n of m".
class PageDots extends StatelessWidget {
  const PageDots({super.key, required this.count, required this.index});
  final int count;
  final int index;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Photo ${index + 1} of $count',
    excludeSemantics: true,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var dot = 0; dot < count; dot++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: dot == index ? 16 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: dot == index ? BuyerTheme.action : BuyerTheme.border,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
      ],
    ),
  );
}
