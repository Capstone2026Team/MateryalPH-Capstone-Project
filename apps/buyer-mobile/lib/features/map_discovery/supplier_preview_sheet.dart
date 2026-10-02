import 'package:flutter/material.dart';
import '../../design_system/components/discovery_controls.dart';
import '../../design_system/theme.dart';

/// Shared accessible, internally scrolling map preview. Motion follows Flutter's reduced-motion setting.
class SupplierPreviewSheet extends StatelessWidget {
  const SupplierPreviewSheet({
    super.key,
    required this.builder,
    this.controller,
    this.initialSize = .42,
    this.minSize = .28,
    this.maxSize = .82,
    this.snapSizes = const [.42, .7],
    this.showHandle = true,
    this.cornerRadius = 20,
  });
  final DraggableScrollableController? controller;
  final double initialSize, minSize, maxSize;
  final List<double> snapSizes;
  final bool showHandle;
  final double cornerRadius;
  final Widget Function(BuildContext, ScrollController) builder;
  @override
  Widget build(BuildContext context) => DraggableScrollableSheet(
    controller: controller,
    initialChildSize: initialSize,
    minChildSize: minSize,
    maxChildSize: maxSize,
    snap: !MediaQuery.disableAnimationsOf(context),
    snapSizes: snapSizes,
    builder: (context, controller) => Material(
      color: Colors.white,
      elevation: 8,
      shadowColor: MapFloatingSurface.shadowColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(cornerRadius))),
      child: Column(
        children: [
          if (showHandle) Semantics(
            label: 'Vendor comparison sheet',
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: BuyerTheme.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          Expanded(child: builder(context, controller)),
        ],
      ),
    ),
  );
}
