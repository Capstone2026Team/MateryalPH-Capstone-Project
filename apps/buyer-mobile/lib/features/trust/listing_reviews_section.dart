import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/star_rating.dart';
import '../../design_system/theme.dart';
import '../item_procurement/procurement_models.dart' show formatManilaTimestamp;
import '../map_discovery/discovery_models.dart';
import '../map_discovery/discovery_repository.dart' show newIdempotencyKey;
import 'reviews_repository.dart';
import 'trust_models.dart';

const _reasons = {
  'OFFENSIVE': 'Offensive language',
  'PERSONAL_INFORMATION': 'Personal information',
  'SPAM': 'Spam',
  'IRRELEVANT': 'Not about this purchase',
  'FALSE_CLAIM': 'False claim',
  'OTHER': 'Other',
};

/// Published verified-purchase Product Reviews of one listing (its own product average, separate from
/// the seller's MQS) with Report Review. Hidden, withheld or removed reviews never reach this list.
class ListingReviewsSection extends StatefulWidget {
  const ListingReviewsSection({
    super.key,
    required this.repository,
    required this.listingId,
  });

  final ReviewsRepository repository;
  final String listingId;

  @override
  State<ListingReviewsSection> createState() => _ListingReviewsSectionState();
}

class _ListingReviewsSectionState extends State<ListingReviewsSection> {
  ListingReviewsView? _reviews;
  DiscoveryFailure? _failure;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _failure = null);
    try {
      final reviews = await widget.repository.listingReviews(widget.listingId);
      if (mounted) setState(() => _reviews = reviews);
    } on DiscoveryFailure catch (failure) {
      if (mounted) setState(() => _failure = failure);
    }
  }

  Future<void> _report(PublicReviewView review) async {
    final reason = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const ListTile(
              title: Text(
                'Report this review',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            for (final entry in _reasons.entries)
              ListTile(
                title: Text(entry.value),
                minTileHeight: 48,
                onTap: () => Navigator.pop(context, entry.key),
              ),
          ],
        ),
      ),
    );
    if (reason == null || !mounted) return;
    try {
      await widget.repository.report(
        reviewId: review.id,
        reasonCode: reason,
        idempotencyKey: newIdempotencyKey(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report sent. Our moderation team will review it.'),
          ),
        );
      }
    } on DiscoveryFailure catch (failure) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_failure != null) {
      return Row(
        children: [
          Expanded(
            child: Text(
              _failure!.message,
              style: const TextStyle(color: BuyerTheme.muted),
            ),
          ),
          TextButton(onPressed: _load, child: const Text('Retry')),
        ],
      );
    }
    final reviews = _reviews;
    if (reviews == null) return const LinearProgressIndicator();
    if (reviews.items.isEmpty) {
      return const Text(
        'No written reviews yet. Reviews come only from completed, verified purchases.',
        style: TextStyle(color: BuyerTheme.muted),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${reviews.count} verified review${reviews.count == 1 ? '' : 's'}',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        for (final review in reviews.items)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: BuyerTheme.border)),
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
                        '${review.displayName} · Verified purchase',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Report review by ${review.displayName}',
                      constraints: const BoxConstraints(
                        minWidth: 44,
                        minHeight: 44,
                      ),
                      onPressed: () => _report(review),
                      icon: const Icon(LucideIcons.flag, size: 16),
                    ),
                  ],
                ),
                if (review.ratings.productQuality != null)
                  StarRatingLine(
                    label: 'Product Quality',
                    value: review.ratings.productQuality!,
                  ),
                if (review.comment != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(review.comment!),
                  ),
                Text(
                  [
                    if (review.variantLabel != null) review.variantLabel!,
                    if (review.submittedAt != null)
                      formatManilaTimestamp(review.submittedAt!),
                    if (review.edited) 'Edited',
                  ].join(' · '),
                  style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
