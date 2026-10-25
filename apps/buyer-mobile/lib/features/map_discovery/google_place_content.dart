import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/page_dots.dart';
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
  final _pages = PageController();
  int _index = 0;

  void _goTo(int index) => _pages.animateToPage(
    index,
    duration: const Duration(milliseconds: 260),
    curve: Curves.easeOutCubic,
  );

  @override
  void dispose() {
    _pages.dispose();
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
    final count = widget.photos.length;
    // Flat bordered card like the Opening hours / Contact groups below it.
    // Attribution sits in the footer, never over the photo.
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: BuyerTheme.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1.6,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Only the visible page loads, keeping provider media lazy.
                  PageView.builder(
                    controller: _pages,
                    itemCount: count,
                    onPageChanged: (value) => setState(() => _index = value),
                    itemBuilder: (_, index) => _PlacePhotoImage(
                      uri: widget.photos[index].uri,
                      semanticLabel: 'Google Maps business photo ${index + 1}',
                    ),
                  ),
                  if (count > 1) ...[
                    Positioned(
                      top: 10,
                      right: 10,
                      child: _PhotoCountPill('${_index + 1} / $count'),
                    ),
                    // Buttons give a single-pointer alternative to swiping.
                    if (_index > 0)
                      Positioned(
                        left: 6,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: _PhotoStepButton(
                            icon: LucideIcons.chevronLeft,
                            tooltip: 'Previous photo',
                            onPressed: () => _goTo(_index - 1),
                          ),
                        ),
                      ),
                    if (_index < count - 1)
                      Positioned(
                        right: 6,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: _PhotoStepButton(
                            icon: LucideIcons.chevronRight,
                            tooltip: 'Next photo',
                            onPressed: () => _goTo(_index + 1),
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
            if (count > 1)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: PageDots(count: count, index: _index),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
              child: _PlacePhotoCredit(
                photo: photo,
                onOpenLink: widget.onOpenLink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlacePhotoImage extends StatelessWidget {
  const _PlacePhotoImage({required this.uri, required this.semanticLabel});
  final String uri;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: BuyerTheme.canvas,
    child: Image.network(
      uri,
      fit: BoxFit.cover,
      semanticLabel: semanticLabel,
      frameBuilder: (_, child, frame, synchronous) => synchronous
          ? child
          : AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: const Duration(milliseconds: 220),
              child: child,
            ),
      loadingBuilder: (_, child, progress) => progress == null
          ? child
          : const Center(
              child: SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ),
      errorBuilder: (_, _, _) => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.imageOff, color: BuyerTheme.muted),
            SizedBox(height: 6),
            Text(
              'Photo unavailable',
              style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
            ),
          ],
        ),
      ),
    ),
  );
}

class _PhotoCountPill extends StatelessWidget {
  const _PhotoCountPill(this.text);
  final String text;

  // The dots below carry the announced position.
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

class _PhotoStepButton extends StatelessWidget {
  const _PhotoStepButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    onPressed: onPressed,
    constraints: const BoxConstraints.tightFor(width: 44, height: 44),
    padding: EdgeInsets.zero,
    style: IconButton.styleFrom(
      backgroundColor: Colors.white.withValues(alpha: 0.9),
      foregroundColor: BuyerTheme.ink,
      shadowColor: Colors.black26,
      elevation: 2,
    ),
    icon: Icon(icon, size: 20),
  );
}

/// One compact row: contributor avatar and name, the Google Maps source, and
/// a trailing link to the photo on Google Maps.
class _PlacePhotoCredit extends StatelessWidget {
  const _PlacePhotoCredit({required this.photo, required this.onOpenLink});
  final PlacePhotoView photo;
  final Future<void> Function(Uri) onOpenLink;

  @override
  Widget build(BuildContext context) {
    final avatar = photo.authors
        .map((author) => author.photoUri)
        .whereType<String>()
        .firstOrNull;
    return Row(
      children: [
        ClipOval(
          child: SizedBox.square(
            dimension: 32,
            child: avatar == null
                ? const ColoredBox(
                    color: BuyerTheme.canvas,
                    child: Icon(
                      LucideIcons.user,
                      size: 18,
                      color: BuyerTheme.muted,
                    ),
                  )
                : Image.network(
                    avatar,
                    fit: BoxFit.cover,
                    excludeFromSemantics: true,
                    errorBuilder: (_, _, _) => const ColoredBox(
                      color: BuyerTheme.canvas,
                      child: Icon(
                        LucideIcons.user,
                        size: 18,
                        color: BuyerTheme.muted,
                      ),
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                children: [
                  for (final author in photo.authors)
                    author.uri == null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 12,
                            ),
                            child: Text(
                              author.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: const Size(44, 44),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onPressed: () => onOpenLink(Uri.parse(author.uri!)),
                            child: Text(author.name),
                          ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  4,
                  photo.authors.isEmpty ? 12 : 0,
                  4,
                  photo.authors.isEmpty ? 12 : 6,
                ),
                child: const Text(
                  'Google Maps',
                  style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
                ),
              ),
            ],
          ),
        ),
        if (photo.googleMapsUri != null)
          IconButton(
            tooltip: 'View photo on Google Maps',
            color: BuyerTheme.action,
            onPressed: () => onOpenLink(Uri.parse(photo.googleMapsUri!)),
            icon: const Icon(LucideIcons.externalLink, size: 20),
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
