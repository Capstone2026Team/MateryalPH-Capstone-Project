import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme.dart';
import 'specification_chips.dart';

/// A bounded thumbnail with the same fallback for missing and failed images.
class ProductThumbnail extends StatelessWidget {
  const ProductThumbnail({super.key, this.url, this.label, this.size = 56});
  final String? url, label;
  final double size;

  @override
  Widget build(BuildContext context) {
    final placeholder = ColoredBox(
      color: BuyerTheme.canvas,
      child: const Center(
        child: Icon(LucideIcons.package, color: BuyerTheme.muted),
      ),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox.square(
        dimension: size,
        child: url == null || url!.isEmpty
            ? placeholder
            : Image.network(
                url!,
                fit: BoxFit.cover,
                semanticLabel: label,
                errorBuilder: (_, _, _) => placeholder,
                loadingBuilder: (_, child, progress) =>
                    progress == null ? child : placeholder,
              ),
      ),
    );
  }
}

/// Shared compact material presentation for procurement review surfaces.
class ProductSummaryRow extends StatelessWidget {
  const ProductSummaryRow({
    super.key,
    required this.name,
    this.imageUrl,
    this.specifications = const [],
    this.details,
    this.price,
    this.status,
    this.statusIsSuccess = false,
    this.action,
    this.onOpen,
  });
  final String name;
  final String? imageUrl, details, price, status;

  /// Highlights a positive status with a green badge and check icon.
  final bool statusIsSuccess;
  final List<SpecificationDetail> specifications;
  final Widget? action;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductThumbnail(url: imageUrl, label: name),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (specifications.isNotEmpty)
                Text(
                  specifications.map(specificationText).join(' · '),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: BuyerTheme.muted,
                  ),
                ),
              if (details?.isNotEmpty == true)
                Text(
                  details!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: BuyerTheme.muted,
                  ),
                ),
              if (price != null)
                Text(
                  price!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              if (status != null)
                if (statusIsSuccess)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: BuyerTheme.successStrong.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          LucideIcons.circleCheck,
                          size: 16,
                          color: BuyerTheme.successStrong,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            status!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: BuyerTheme.successStrong,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Text(
                    status!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: BuyerTheme.actionPressed,
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (onOpen == null)
            product
          else
            InkWell(
              onTap: onOpen,
              child: Semantics(
                button: true,
                hint: 'Opens product details',
                child: product,
              ),
            ),
          if (action != null)
            Align(alignment: AlignmentDirectional.centerEnd, child: action),
        ],
      ),
    );
  }
}
