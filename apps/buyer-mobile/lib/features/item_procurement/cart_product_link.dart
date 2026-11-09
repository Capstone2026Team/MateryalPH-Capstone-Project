import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';
import 'procurement_models.dart';

/// The same compact product link in Cart and Checkout. Editing opens Product Details.
class CartProductLink extends StatelessWidget {
  const CartProductLink({super.key, required this.line, this.onTap});

  final CartLineView line;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: onTap != null,
    label: 'View ${line.displayName} details and options',
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 56,
                height: 56,
                child: line.imageUrl == null
                    ? const ColoredBox(
                        color: BuyerTheme.canvas,
                        child: Icon(
                          LucideIcons.package,
                          color: BuyerTheme.muted,
                        ),
                      )
                    : Image.network(
                        line.imageUrl!,
                        fit: BoxFit.cover,
                        cacheWidth: 168,
                        errorBuilder: (_, _, _) =>
                            const Icon(LucideIcons.imageOff),
                      ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    line.displayName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (line.variantLabel != null)
                    Text(
                      line.variantLabel!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: BuyerTheme.muted,
                      ),
                    ),
                  Text(
                    '${formatQuantity(line.quantity)} ${line.unitName}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  if (line.appliedUnitPriceCentavos != null)
                    Text(
                      '${formatPeso(line.appliedUnitPriceCentavos!)} / ${line.unitName}${line.volumeTierApplied ? ' · volume price' : ''}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: BuyerTheme.action,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  if (line.stockLabel != null)
                    StockLabelText(label: line.stockLabel, compact: true),
                  if (line.lineTotalCentavos != null)
                    Text(
                      'Line total ${formatPeso(line.lineTotalCentavos!)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
            ),
            if (onTap != null)
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  LucideIcons.chevronRight,
                  size: 16,
                  color: BuyerTheme.muted,
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
