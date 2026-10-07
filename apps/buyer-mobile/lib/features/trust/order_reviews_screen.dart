import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/buyer_overlays.dart';
import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/components/procurement_components.dart';
import '../../design_system/components/star_rating.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import '../map_discovery/discovery_repository.dart' show newIdempotencyKey;
import 'reviews_repository.dart';
import 'trust_models.dart';

/// Verified-purchase review of a completed order: separate Vendor (Service Quality and Delivery or
/// Processing Speed) and per-line Product Quality ratings, the privacy-safe public name, a preview
/// before submitting, and corrections within 24 hours. Ratings stay hidden until both sides submit or
/// the 14-day window ends.
class OrderReviewsScreen extends StatefulWidget {
  const OrderReviewsScreen({
    super.key,
    required this.repository,
    required this.orderId,
  });

  final ReviewsRepository repository;
  final String orderId;

  @override
  State<OrderReviewsScreen> createState() => _OrderReviewsScreenState();
}

class _OrderReviewsScreenState extends State<OrderReviewsScreen> {
  OrderReviewsView? _view;
  DiscoveryFailure? _failure;
  bool _busy = false;
  String _choice = 'FIRST_NAME_LAST_INITIAL';
  int? _service;
  int? _speed;
  final _vendorComment = TextEditingController();
  final Map<String, int> _lineRatings = {};
  final Map<String, TextEditingController> _lineComments = {};
  String? _error;
  String? _key;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _vendorComment.dispose();
    for (final controller in _lineComments.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _failure = null);
    try {
      final view = await widget.repository.orderReviews(widget.orderId);
      if (mounted) setState(() => _view = view);
    } on DiscoveryFailure catch (failure) {
      if (mounted) setState(() => _failure = failure);
    }
  }

  TextEditingController _comment(String lineId) =>
      _lineComments.putIfAbsent(lineId, TextEditingController.new);

  Future<void> _submit() async {
    final view = _view!;
    final vendor =
        view.canSubmitVendorRating && (_service != null || _speed != null);
    if (vendor && (_service == null || _speed == null)) {
      setState(
        () => _error = 'Rate both Service Quality and ${view.speedLabel}.',
      );
      return;
    }
    final products = [
      for (final line in view.lines)
        if (line.canReview && _lineRatings[line.orderLineId] != null)
          (
            orderLineId: line.orderLineId,
            rating: _lineRatings[line.orderLineId]!,
            comment: _comment(line.orderLineId).text.trim().isEmpty
                ? null
                : _comment(line.orderLineId).text.trim(),
          ),
    ];
    if (!vendor && products.isEmpty) {
      setState(() => _error = 'Rate the seller or at least one product.');
      return;
    }
    final name = view.displayOptions
        .firstWhere(
          (option) => option.choice == _choice,
          orElse: () => (choice: _choice, preview: 'Verified Buyer'),
        )
        .preview;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => BuyerDialog(
        title: const Text('Submit your ratings?'),
        content: Text(
          'They will appear as “$name”, marked Verified purchase, once the seller also rates or the 14-day window ends. You can correct them for 24 hours after submitting.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Review again'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    _key ??= newIdempotencyKey();
    try {
      final next = await widget.repository.submit(
        orderId: widget.orderId,
        displayChoice: _choice,
        vendorRating: vendor
            ? (
                service: _service!,
                speed: _speed!,
                comment: _vendorComment.text.trim().isEmpty
                    ? null
                    : _vendorComment.text.trim(),
              )
            : null,
        productReviews: products,
        idempotencyKey: _key!,
      );
      if (!mounted) return;
      _key = null;
      setState(() {
        _view = next;
        _service = null;
        _speed = null;
        _lineRatings.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you. Your ratings were submitted.'),
        ),
      );
    } on DiscoveryFailure catch (failure) {
      if (mounted) setState(() => _error = failure.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _edit(OwnReviewView review, {required bool product}) async {
    int? first = product
        ? review.ratings.productQuality
        : review.ratings.serviceQuality;
    int? second = review.ratings.speedRating;
    final comment = TextEditingController(text: review.comment ?? '');
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialog) => BuyerDialog(
          title: Text(
            review.correctionRequested
                ? 'Submit the requested correction'
                : 'Correct your review',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StarRatingField(
                  label: product ? 'Product Quality' : 'Service Quality',
                  value: first,
                  onChanged: (value) => setDialog(() => first = value),
                ),
                if (!product)
                  StarRatingField(
                    label: _view!.speedLabel,
                    value: second,
                    onChanged: (value) => setDialog(() => second = value),
                  ),
                TextField(
                  controller: comment,
                  maxLength: 1000,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Comment (optional)',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    final text = comment.text.trim();
    comment.dispose();
    if (saved != true || !mounted) return;
    try {
      final next = await widget.repository.edit(
        reviewId: review.id,
        lockVersion: review.lockVersion,
        serviceQuality: product ? null : first,
        speedRating: product ? null : second,
        productQuality: product ? first : null,
        comment: text,
      );
      if (mounted) setState(() => _view = next);
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
    final view = _view;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buyerAppBar(context, 'Rate your order'),
      body: SafeArea(
        child: _failure != null
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: StatusBand(
                  tone: BandTone.warning,
                  title: 'Ratings are unavailable',
                  message: _failure!.message,
                  action: TextButton(
                    onPressed: _load,
                    child: const Text('Retry'),
                  ),
                ),
              )
            : view == null
            ? const Padding(
                padding: EdgeInsets.all(16),
                child: SkeletonBox(height: 280),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  Text(
                    'Order ${view.orderReference}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    view.state == 'NOT_COMPLETED'
                        ? 'Ratings open when the order is completed.'
                        : view.open
                        ? 'Rate within 14 days of completion${view.closesAtLabel == null ? '' : ' — until ${view.closesAtLabel}'}.'
                        : 'The 14-day rating period has ended.',
                    style: const TextStyle(
                      fontSize: 13,
                      color: BuyerTheme.muted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    view.blindRevealText,
                    style: const TextStyle(
                      fontSize: 12,
                      color: BuyerTheme.muted,
                    ),
                  ),
                  if (view.withheldForDispute)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: StatusBand(
                        tone: BandTone.info,
                        title: 'Publication is withheld',
                        message:
                            'A related dispute is active. Your ratings are kept and appear after it is resolved.',
                      ),
                    ),
                  const SizedBox(height: 16),
                  const SectionHeading('Seller rating'),
                  if (view.vendorRating != null)
                    _OwnReviewTile(
                      review: view.vendorRating!,
                      speedLabel: view.speedLabel,
                      onEdit: () => _edit(view.vendorRating!, product: false),
                    )
                  else if (view.canSubmitVendorRating) ...[
                    StarRatingField(
                      label: 'Service Quality',
                      value: _service,
                      onChanged: _busy
                          ? null
                          : (value) => setState(() => _service = value),
                    ),
                    StarRatingField(
                      label: view.speedLabel,
                      value: _speed,
                      onChanged: _busy
                          ? null
                          : (value) => setState(() => _speed = value),
                    ),
                    TextField(
                      controller: _vendorComment,
                      maxLength: 1000,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Comment about the seller (optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ] else
                    const Text(
                      'Seller rating is not available for this order.',
                      style: TextStyle(color: BuyerTheme.muted),
                    ),
                  const SizedBox(height: 16),
                  const SectionHeading('Product reviews'),
                  for (final line in view.lines)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${line.displayName}${line.variantLabel == null ? '' : ' · ${line.variantLabel}'}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          if (line.review != null)
                            _OwnReviewTile(
                              review: line.review!,
                              speedLabel: view.speedLabel,
                              onEdit: () => _edit(line.review!, product: true),
                            )
                          else if (line.canReview) ...[
                            StarRatingField(
                              label: 'Product Quality',
                              value: _lineRatings[line.orderLineId],
                              onChanged: _busy
                                  ? null
                                  : (value) => setState(
                                      () => _lineRatings[line.orderLineId] =
                                          value,
                                    ),
                            ),
                            TextField(
                              controller: _comment(line.orderLineId),
                              maxLength: 1000,
                              maxLines: 2,
                              decoration: const InputDecoration(
                                labelText: 'Comment (optional)',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  if (view.canSubmitVendorRating ||
                      view.lines.any((line) => line.canReview)) ...[
                    const SectionHeading('How your name appears'),
                    RadioGroup<String>(
                      groupValue: _choice,
                      onChanged: (value) =>
                          setState(() => _choice = value ?? _choice),
                      child: Column(
                        children: [
                          for (final option in view.displayOptions)
                            RadioListTile<String>(
                              value: option.choice,
                              contentPadding: EdgeInsets.zero,
                              title: Text(option.preview),
                              subtitle: Text(
                                option.choice == 'VERIFIED_BUYER'
                                    ? 'More private: no name shown'
                                    : 'First name and last initial',
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Color(0xFFB91C1C)),
                        ),
                      ),
                    FilledButton(
                      onPressed: _busy || !view.open ? null : _submit,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: Text(_busy ? 'Submitting…' : 'Preview and submit'),
                    ),
                  ],
                  if (view.counterpartRating != null) ...[
                    const SizedBox(height: 20),
                    const SectionHeading('How the seller rated you'),
                    if (view.counterpartRating!.inquirySeriousness != null)
                      StarRatingLine(
                        label: 'Inquiry Seriousness',
                        value: view.counterpartRating!.inquirySeriousness!,
                      ),
                    if (view.counterpartRating!.communicationQuality != null)
                      StarRatingLine(
                        label: 'Communication Quality',
                        value: view.counterpartRating!.communicationQuality!,
                      ),
                    if (view.counterpartRating!.paymentReliability != null)
                      StarRatingLine(
                        label: 'Payment Reliability',
                        value: view.counterpartRating!.paymentReliability!,
                      ),
                  ],
                ],
              ),
      ),
    );
  }
}

class _OwnReviewTile extends StatelessWidget {
  const _OwnReviewTile({
    required this.review,
    required this.speedLabel,
    required this.onEdit,
  });

  final OwnReviewView review;
  final String speedLabel;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final status = switch (review.visibility) {
      'PUBLIC' => 'Published',
      'HIDDEN_UNTIL_REVEAL' => 'Hidden until the seller rates or 14 days pass',
      'WITHHELD_ACTIVE_DISPUTE' => 'Withheld while a dispute is active',
      'HIDDEN_BY_MODERATION' =>
        review.correctionRequested
            ? 'Correction requested by moderation'
            : 'Under moderation review',
      'REMOVED' => 'Removed by moderation',
      _ => review.visibility,
    };
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BuyerTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.badgeCheck,
                size: 16,
                color: BuyerTheme.action,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  status,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (review.ratings.serviceQuality != null)
            StarRatingLine(
              label: 'Service Quality',
              value: review.ratings.serviceQuality!,
            ),
          if (review.ratings.speedRating != null)
            StarRatingLine(
              label: speedLabel,
              value: review.ratings.speedRating!,
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
            'Shown as ${review.displayName}',
            style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
          ),
          if (review.canEdit)
            TextButton(
              onPressed: onEdit,
              style: TextButton.styleFrom(minimumSize: const Size(44, 44)),
              child: Text(
                review.correctionRequested
                    ? 'Submit correction'
                    : 'Correct${review.editableUntilLabel == null ? '' : ' (until ${review.editableUntilLabel})'}',
              ),
            ),
        ],
      ),
    );
  }
}
