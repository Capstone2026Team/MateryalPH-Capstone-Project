import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/theme.dart';
import 'discovery_models.dart';

/// Attribution stays beside a list thumbnail; links remain separate from row
/// selection and retain accessible touch targets even on a narrow screen.
class GooglePlacePhotoCredit extends StatelessWidget {
  const GooglePlacePhotoCredit({
    super.key,
    required this.photo,
    required this.providerAttributions,
    this.onOpenLink,
  });
  final PlacePhotoView photo;
  final List<PlaceAuthorView> providerAttributions;
  final Future<void> Function(Uri)? onOpenLink;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _credit('Google Maps', photo.googleMapsUri),
      for (final author in [...photo.authors, ...providerAttributions])
        _credit(author.name, author.uri),
    ],
  );

  Widget _credit(String name, String? uri) => uri == null || onOpenLink == null
      ? Text(
          name,
          style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
        )
      : TextButton(
          style: TextButton.styleFrom(
            minimumSize: const Size(44, 44),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            alignment: Alignment.centerLeft,
            textStyle: const TextStyle(fontSize: 12),
          ),
          onPressed: () => onOpenLink!(Uri.parse(uri)),
          child: Text(name),
        );
}

/// On-demand Google media. No disk cache; evict transient image entries when details close.
class GooglePlacePhotos extends StatefulWidget {
  const GooglePlacePhotos({
    super.key,
    required this.photos,
    required this.onOpenLink,
  });
  final List<PlacePhotoView> photos;
  final Future<void> Function(Uri) onOpenLink;

  @override
  State<GooglePlacePhotos> createState() => _GooglePlacePhotosState();
}

class _GooglePlacePhotosState extends State<GooglePlacePhotos> {
  int _index = 0;

  @override
  void dispose() {
    for (final photo in widget.photos) {
      NetworkImage(photo.uri).evict();
      for (final author in photo.authors) {
        if (author.photoUri != null) NetworkImage(author.photoUri!).evict();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.photos.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Icon(LucideIcons.image, color: BuyerTheme.muted),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'No business photos available.',
                style: TextStyle(color: BuyerTheme.muted),
              ),
            ),
          ],
        ),
      );
    }
    final photo = widget.photos[_index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: 1.65,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: PageView.builder(
              itemCount: widget.photos.length,
              onPageChanged: (value) => setState(() => _index = value),
              itemBuilder: (_, index) => Image.network(
                widget.photos[index].uri,
                fit: BoxFit.cover,
                semanticLabel: 'Google Maps business photo ${index + 1}',
                errorBuilder: (_, _, _) => const ColoredBox(
                  color: BuyerTheme.canvas,
                  child: Center(child: Text('Photo unavailable')),
                ),
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : const ColoredBox(
                        color: BuyerTheme.canvas,
                        child: Center(child: CircularProgressIndicator()),
                      ),
              ),
            ),
          ),
        ),
        if (widget.photos.length > 1)
          Text(
            'Photo ${_index + 1} of ${widget.photos.length} · Swipe for more',
            style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
          ),
        const Text(
          'Google Maps',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        for (final author in photo.authors)
          GooglePlaceAuthor(author: author, onOpenLink: widget.onOpenLink),
        if (photo.googleMapsUri != null)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () =>
                  widget.onOpenLink(Uri.parse(photo.googleMapsUri!)),
              child: const Text('View photo on Google Maps'),
            ),
          ),
      ],
    );
  }
}

class GooglePlaceAuthor extends StatelessWidget {
  const GooglePlaceAuthor({
    super.key,
    required this.author,
    required this.onOpenLink,
  });
  final PlaceAuthorView author;
  final Future<void> Function(Uri) onOpenLink;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      if (author.photoUri != null) ...[
        ClipOval(
          child: Image.network(
            author.photoUri!,
            width: 28,
            height: 28,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const Icon(LucideIcons.user, size: 28),
          ),
        ),
        const SizedBox(width: 8),
      ],
      Expanded(
        child: author.uri == null
            ? Text(author.name)
            : Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => onOpenLink(Uri.parse(author.uri!)),
                  child: Text(author.name),
                ),
              ),
      ),
    ],
  );
}

class GooglePlaceReviews extends StatelessWidget {
  const GooglePlaceReviews({
    super.key,
    required this.reviews,
    required this.onOpenLink,
  });
  final List<PlaceReviewView> reviews;
  final Future<void> Function(Uri) onOpenLink;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Text(
        'Google reviews',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      const Text(
        'Reviews provided by Google Maps, sorted by relevance.',
        style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
      ),
      if (reviews.isEmpty)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text('No review excerpts available.'),
        ),
      for (final review in reviews) ...[
        const Divider(height: 24),
        GooglePlaceAuthor(author: review.author, onOpenLink: onOpenLink),
        Text(
          '★ ${review.rating.toStringAsFixed(1)}${review.relativeTime == null ? '' : ' · ${review.relativeTime}'}',
        ),
        if (review.text != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(review.text!),
          ),
        if (review.googleMapsUri != null)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => onOpenLink(Uri.parse(review.googleMapsUri!)),
              child: const Text('View review on Google Maps'),
            ),
          ),
      ],
      Align(
        alignment: Alignment.centerLeft,
        child: TextButton(
          onPressed: () => onOpenLink(
            Uri.parse(
              'https://support.google.com/contributionpolicy/answer/7400114',
            ),
          ),
          child: const Text('Google review policy'),
        ),
      ),
    ],
  );
}
