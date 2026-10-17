import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme.dart';
import 'star_rating.dart';

/// A product's published average and distribution, supplied by the server across all review pages.
class ProductRatingSummary extends StatelessWidget {
  const ProductRatingSummary({
    super.key,
    required this.average,
    required this.count,
    required this.distribution,
    this.soldLabel,
  });

  final String? average;
  final int count;
  final Map<int, int> distribution;
  final String? soldLabel;

  @override
  Widget build(BuildContext context) {
    final score = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              count == 0 ? 'New' : average ?? '—',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: BuyerTheme.action,
              ),
            ),
            const Icon(
              LucideIcons.star,
              size: 18,
              color: BuyerTheme.action,
              fill: 1,
            ),
          ],
        ),
        Text(
          '$count rating${count == 1 ? '' : 's'}',
          style: const TextStyle(fontSize: 12, color: BuyerTheme.ink),
        ),
        if (soldLabel != null)
          Text(
            soldLabel!,
            style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
          ),
      ],
    );
    final bars = Column(
      children: [
        for (var stars = 5; stars >= 1; stars--)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Semantics(
              label:
                  '$stars stars: ${distribution[stars] ?? 0} rating${distribution[stars] == 1 ? '' : 's'}',
              excludeSemantics: true,
              child: Row(
                children: [
                  SizedBox(
                    width: 14,
                    child: Text(
                      '$stars',
                      style: const TextStyle(
                        fontSize: 11,
                        color: BuyerTheme.muted,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: count == 0
                          ? 0
                          : ((distribution[stars] ?? 0) / count).clamp(0, 1),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(4),
                      backgroundColor: BuyerTheme.brandSoft,
                      color: BuyerTheme.action,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 32,
                    child: Text(
                      '${distribution[stars] ?? 0}',
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 11,
                        color: BuyerTheme.muted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 280 ||
                MediaQuery.textScalerOf(context).scale(14) > 19) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [score, const SizedBox(height: 12), bars],
              );
            }
            return Row(
              children: [
                Expanded(flex: 2, child: score),
                const SizedBox(width: 20),
                Expanded(flex: 5, child: bars),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        const Text(
          'Product Quality from verified purchases. Separate from the seller’s score.',
          style: TextStyle(fontSize: 12, height: 1.5, color: BuyerTheme.muted),
        ),
      ],
    );
  }
}

/// A compact review surface with an optional media cover beside its written content.
class ProductReviewCard extends StatelessWidget {
  const ProductReviewCard({
    super.key,
    required this.displayName,
    required this.rating,
    required this.comment,
    required this.onReport,
    this.variantLabel,
    this.timestamp,
    this.timestampDetails,
    this.edited = false,
    this.media,
    this.mediaTrailing = false,
  });

  final String displayName;
  final int? rating;
  final String? comment;
  final String? variantLabel;
  final String? timestamp;
  final String? timestampDetails;
  final bool edited;
  final VoidCallback onReport;
  final Widget? media;
  final bool mediaTrailing;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (comment != null && comment!.trim().isNotEmpty)
          Text(
            comment!,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: BuyerTheme.ink,
            ),
          )
        else
          const Text(
            'Rated this product',
            style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
          ),
        if (variantLabel != null && variantLabel!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            variantLabel!,
            style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
          ),
        ],
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (rating != null)
              StarRatingLine(
                label: 'Product Quality',
                value: rating!,
                showLabel: false,
              ),
            if (timestamp != null)
              Tooltip(
                message: timestampDetails ?? timestamp!,
                child: Text(
                  timestamp!,
                  style: const TextStyle(fontSize: 11, color: BuyerTheme.muted),
                ),
              ),
            if (edited)
              const Text(
                'Edited',
                style: TextStyle(fontSize: 11, color: BuyerTheme.muted),
              ),
          ],
        ),
      ],
    );
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: BuyerTheme.brandSoft),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.badgeCheck,
                size: 14,
                color: BuyerTheme.action,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '$displayName · Verified purchase',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: BuyerTheme.muted,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Report review by $displayName',
                constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                onPressed: onReport,
                icon: const Icon(
                  LucideIcons.flag,
                  size: 16,
                  color: BuyerTheme.muted,
                ),
              ),
            ],
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              if (media == null) return content;
              if (constraints.maxWidth < 280 ||
                  MediaQuery.textScalerOf(context).scale(14) > 19) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    content,
                    const SizedBox(height: 12),
                    SizedBox(width: 104, child: media!),
                  ],
                );
              }
              final cover = SizedBox(width: 104, child: media!);
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: mediaTrailing
                    ? [
                        Expanded(child: content),
                        const SizedBox(width: 12),
                        cover,
                      ]
                    : [
                        cover,
                        const SizedBox(width: 12),
                        Expanded(child: content),
                      ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Authenticated photo bytes or a video play tile. The caller owns loading and opening private media.
class ReviewMediaTile extends StatelessWidget {
  const ReviewMediaTile({
    super.key,
    required this.video,
    required this.onPressed,
    this.bytes,
    this.loading = false,
    this.failed = false,
  });

  final bool video;
  final Uint8List? bytes;
  final bool loading;
  final bool failed;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: failed
        ? 'Refresh review attachment'
        : video
        ? 'Play review video'
        : 'Open review photo',
    child: AspectRatio(
      aspectRatio: 1,
      child: Material(
        color: BuyerTheme.canvas,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (bytes != null)
                Image.memory(
                  bytes!,
                  fit: BoxFit.cover,
                  cacheWidth: 256,
                  excludeFromSemantics: true,
                  errorBuilder: (_, _, _) => const Center(
                    child: Icon(LucideIcons.imageOff, color: BuyerTheme.muted),
                  ),
                )
              else
                Center(
                  child: loading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              failed
                                  ? LucideIcons.refreshCw
                                  : video
                                  ? LucideIcons.circlePlay
                                  : LucideIcons.image,
                              size: 32,
                              color: BuyerTheme.action,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              failed
                                  ? 'Refresh'
                                  : video
                                  ? 'Play video'
                                  : 'Photo',
                              style: const TextStyle(
                                fontSize: 11,
                                color: BuyerTheme.muted,
                              ),
                            ),
                          ],
                        ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
