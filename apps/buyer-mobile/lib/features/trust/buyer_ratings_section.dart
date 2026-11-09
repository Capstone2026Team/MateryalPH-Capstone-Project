import '../../design_system/components/async_state.dart';
import 'package:flutter/material.dart';

import '../../design_system/components/star_rating.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import '../orders/order_models.dart' show formatManilaDateTime;
import 'reviews_repository.dart';
import 'trust_models.dart';

/// The Buyer's received ratings live in Profile; submitted product/store reviews keep their own entry.
class BuyerRatingsSection extends StatefulWidget {
  const BuyerRatingsSection({
    super.key,
    required this.repository,
    this.active = true,
    this.refreshRevision = 0,
  });
  final ReviewsRepository repository;
  final bool active;
  final int refreshRevision;
  @override
  State<BuyerRatingsSection> createState() => _BuyerRatingsSectionState();
}

class _BuyerRatingsSectionState extends State<BuyerRatingsSection> {
  BuyerReceivedRatingsView? _data;
  String? _error;
  bool _loading = true;
  bool _expanded = false;
  int _revision = 0;
  int _requestedPage = 1;

  @override
  void initState() {
    super.initState();
    if (widget.active) _load();
  }

  @override
  void didUpdateWidget(covariant BuyerRatingsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active &&
        (!oldWidget.active ||
            widget.refreshRevision != oldWidget.refreshRevision ||
            widget.repository != oldWidget.repository)) {
      _load();
    }
  }

  Future<void> _load([int page = 1]) async {
    final revision = ++_revision;
    _requestedPage = page;
    setState(() {
      _loading = true;
      _error = null;
      _data = null;
    });
    try {
      final data = await widget.repository.receivedRatings(page: page);
      if (mounted && revision == _revision) setState(() => _data = data);
    } catch (error) {
      if (mounted && revision == _revision) {
        setState(
          () => _error = error is DiscoveryFailure
              ? error.message
              : 'Could not load your ratings. Please retry.',
        );
      }
    } finally {
      if (mounted && revision == _revision) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;
    final summary = data?.summary;
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: BuyerTheme.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Buyer rating',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          if (_loading)
            Semantics(
              label: 'Loading your ratings',
              child: const BuyerLoadingProgress(),
            ),
          if (_error != null) ...[
            Text(_error!, style: const TextStyle(color: BuyerTheme.ink)),
            TextButton(
              onPressed: () => _load(_requestedPage),
              child: const Text('Retry ratings'),
            ),
          ],
          if (data != null && summary != null) ...[
            StarRatingDisplay(value: summary.score, label: 'Your Buyer rating'),
            const SizedBox(height: 6),
            Text(
              summary.score == null
                  ? 'Building your rating'
                  : 'Contractor Community Score (CCS)',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              '${summary.count} eligible ${summary.count == 1 ? 'rating' : 'ratings'} in the last ${summary.windowDays} days.',
              style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
            ),
            if (summary.score == null)
              Text(
                'Your score appears after ${summary.minimumCount} eligible completed transactions.',
                style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
              ),
            TextButton.icon(
              onPressed: () => setState(() => _expanded = !_expanded),
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              label: Text(
                _expanded
                    ? 'Hide ratings from stores'
                    : 'View ratings from stores',
              ),
            ),
            if (_expanded) ...[
              const Text(
                'Ratings from stores',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              if (data.items.isEmpty)
                const Text(
                  'No published ratings from stores yet. Ratings appear after both sides submit or the review window ends.',
                ),
              for (final row in data.items) _ReceivedRating(row: row),
              if (data.total > data.perPage)
                Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Page ${data.page} of ${(data.total / data.perPage).ceil()}',
                    ),
                    TextButton(
                      onPressed: data.page > 1
                          ? () => _load(data.page - 1)
                          : null,
                      child: const Text('Previous ratings'),
                    ),
                    TextButton(
                      onPressed: data.page * data.perPage < data.total
                          ? () => _load(data.page + 1)
                          : null,
                      child: const Text('Next ratings'),
                    ),
                  ],
                ),
            ],
          ],
        ],
      ),
    );
  }
}

class _ReceivedRating extends StatelessWidget {
  const _ReceivedRating({required this.row});
  final BuyerReceivedRatingView row;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: BuyerTheme.border)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          row.storeName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          '${row.orderReference} · ${formatManilaDateTime(row.submittedAt)}',
          style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
        ),
        const SizedBox(height: 8),
        if (row.ratings.inquirySeriousness != null)
          StarRatingLine(
            label: 'Inquiry Seriousness',
            value: row.ratings.inquirySeriousness!,
          ),
        if (row.ratings.communicationQuality != null)
          StarRatingLine(
            label: 'Communication Quality',
            value: row.ratings.communicationQuality!,
          ),
        if (row.ratings.paymentReliability != null)
          StarRatingLine(
            label: 'Payment Reliability',
            value: row.ratings.paymentReliability!,
          ),
        if (row.comment?.trim().isNotEmpty == true) ...[
          const SizedBox(height: 8),
          Text(row.comment!),
        ],
      ],
    ),
  );
}
