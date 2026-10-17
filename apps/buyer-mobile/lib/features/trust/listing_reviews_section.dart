import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/buyer_overlays.dart';
import '../../design_system/components/product_reviews.dart';
import '../../design_system/theme.dart';
import '../item_procurement/procurement_models.dart' show formatManilaTimestamp;
import '../map_discovery/discovery_models.dart';
import '../map_discovery/discovery_repository.dart' show newIdempotencyKey;
import 'reviews_repository.dart';
import 'review_media_section.dart';
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
    this.soldLabel,
    this.onCountChanged,
  });

  final ReviewsRepository repository;
  final String listingId;
  final String? soldLabel;
  final ValueChanged<int>? onCountChanged;

  @override
  State<ListingReviewsSection> createState() => _ListingReviewsSectionState();
}

class _ListingReviewsSectionState extends State<ListingReviewsSection> {
  ListingReviewsView? _reviews;
  DiscoveryFailure? _failure;
  DiscoveryFailure? _pageFailure;
  bool _loadingMore = false;
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant ListingReviewsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.listingId != widget.listingId ||
        oldWidget.repository != widget.repository) {
      _load();
    }
  }

  Future<void> _load() async {
    final generation = ++_generation;
    setState(() {
      _reviews = null;
      _failure = null;
      _pageFailure = null;
      _loadingMore = false;
    });
    try {
      final reviews = await widget.repository.listingReviews(widget.listingId);
      if (mounted && generation == _generation) {
        setState(() => _reviews = reviews);
        widget.onCountChanged?.call(reviews.count);
      }
    } on DiscoveryFailure catch (failure) {
      if (mounted && generation == _generation) {
        setState(() => _failure = failure);
      }
    }
  }

  Future<void> _loadMore() async {
    final current = _reviews;
    if (current == null || !current.hasMore || _loadingMore) return;
    final generation = _generation;
    setState(() {
      _loadingMore = true;
      _pageFailure = null;
    });
    try {
      final next = await widget.repository.listingReviews(
        widget.listingId,
        page: current.page + 1,
      );
      if (!mounted || generation != _generation) return;
      final items = {
        for (final review in [...current.items, ...next.items])
          review.id: review,
      };
      setState(
        () => _reviews = ListingReviewsView(
          average: next.average,
          count: next.count,
          distribution: next.distribution,
          page: next.page,
          perPage: next.perPage,
          items: items.values.toList(growable: false),
        ),
      );
      widget.onCountChanged?.call(next.count);
    } on DiscoveryFailure catch (failure) {
      if (mounted && generation == _generation) {
        setState(() => _pageFailure = failure);
      }
    } finally {
      if (mounted && generation == _generation) {
        setState(() => _loadingMore = false);
      }
    }
  }

  Future<void> _report(PublicReviewView review) async {
    final reason = await showBuyerBottomSheet<String>(
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
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Product reviews could not load',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            _failure!.message,
            style: const TextStyle(color: BuyerTheme.muted),
          ),
          TextButton(onPressed: _load, child: const Text('Retry')),
        ],
      );
    }
    final reviews = _reviews;
    if (reviews == null) {
      return Semantics(
        label: 'Loading product reviews',
        child: const LinearProgressIndicator(),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductRatingSummary(
          average: reviews.average,
          count: reviews.count,
          distribution: reviews.distribution,
          soldLabel: widget.soldLabel,
        ),
        const SizedBox(height: 16),
        if (reviews.items.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(color: BuyerTheme.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                Icon(
                  LucideIcons.messageSquare,
                  size: 28,
                  color: BuyerTheme.muted,
                ),
                SizedBox(height: 8),
                Text(
                  'No reviews yet',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4),
                Text(
                  'Reviews appear after completed, verified purchases.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
                ),
              ],
            ),
          ),
        for (final review in reviews.items)
          Padding(
            key: ValueKey(review.id),
            padding: const EdgeInsets.only(bottom: 12),
            child: ProductReviewCard(
              displayName: review.displayName,
              rating: review.ratings.productQuality,
              comment: review.comment,
              variantLabel: review.variantLabel,
              edited: review.edited,
              timestamp: review.submittedAt == null
                  ? null
                  : _reviewAge(review.submittedAt!),
              timestampDetails: review.submittedAt == null
                  ? null
                  : formatManilaTimestamp(review.submittedAt!),
              onReport: () => _report(review),
              mediaTrailing: review.media.firstOrNull?.video ?? false,
              media: review.media.isEmpty
                  ? null
                  : ReviewMediaSection(
                      repository: widget.repository,
                      reviewId: review.id,
                      media: review.media,
                      onRefresh: _load,
                      compact: true,
                    ),
            ),
          ),
        if (_pageFailure != null)
          Text(
            _pageFailure!.message,
            style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
          ),
        if (reviews.hasMore)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _loadingMore ? null : _loadMore,
              child: Text(
                _loadingMore
                    ? 'Loading reviews…'
                    : _pageFailure != null
                    ? 'Retry loading reviews'
                    : 'Load more reviews',
              ),
            ),
          ),
      ],
    );
  }
}

String _reviewAge(DateTime submittedAt) {
  final elapsed = DateTime.now().difference(submittedAt);
  if (elapsed.inMinutes < 1) return 'Just now';
  if (elapsed.inHours < 1) {
    return '${elapsed.inMinutes} minute${elapsed.inMinutes == 1 ? '' : 's'} ago';
  }
  if (elapsed.inDays < 1) {
    return '${elapsed.inHours} hour${elapsed.inHours == 1 ? '' : 's'} ago';
  }
  if (elapsed.inDays < 7) {
    return '${elapsed.inDays} day${elapsed.inDays == 1 ? '' : 's'} ago';
  }
  return formatManilaTimestamp(submittedAt);
}
