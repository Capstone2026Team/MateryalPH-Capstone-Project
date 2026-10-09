import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../design_system/components/media_attachment_field.dart';
import '../map_discovery/discovery_models.dart';
import 'reviews_repository.dart';
import 'trust_models.dart';

/// Both own and published reviews fetch bytes through the authenticated, signed API route.
class ReviewMediaSection extends StatefulWidget {
  const ReviewMediaSection({
    super.key,
    required this.repository,
    required this.reviewId,
    required this.media,
    this.onRemove,
    required this.onRefresh,
  });
  final ReviewsRepository repository;
  final String reviewId;
  final List<ReviewMediaView> media;
  final Future<void> Function(ReviewMediaView)? onRemove;
  final Future<void> Function() onRefresh;
  @override
  State<ReviewMediaSection> createState() => _ReviewMediaSectionState();
}

class _ReviewMediaSectionState extends State<ReviewMediaSection> {
  bool _busy = false;
  String? _error;

  Future<void> _preview(ReviewMediaView media) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    Directory? temporary;
    try {
      final bytes = await widget.repository.media(widget.reviewId, media);
      if (!mounted) return;
      if (media.video) {
        temporary = await (await getTemporaryDirectory()).createTemp(
          'review-preview-',
        );
        final file = File(
          '${temporary.path}/preview.${media.contentType == 'video/quicktime' ? 'mov' : 'mp4'}',
        );
        await file.writeAsBytes(bytes, flush: true);
        if (mounted) {
          await showMediaPreview(context, path: file.path, video: true);
        }
      } else {
        await showMediaPreview(context, bytes: bytes, video: false);
      }
    } on DiscoveryFailure catch (failure) {
      if (mounted) setState(() => _error = failure.message);
    } catch (_) {
      if (mounted) {
        setState(
          () => _error =
              'This attachment could not open. Refresh its link and retry.',
        );
      }
    } finally {
      // VideoPlayer releases its file asynchronously when the preview closes.
      if (temporary != null) {
        try {
          await temporary.delete(recursive: true);
        } catch (_) {
          /* OS cache eviction remains the fallback. */
        }
      }
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (_busy) const LinearProgressIndicator(),
      for (final (index, media) in widget.media.indexed)
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            media.video ? Icons.play_circle_outline : Icons.image_outlined,
          ),
          title: Text('${media.video ? 'Video' : 'Photo'} ${index + 1}'),
          subtitle: const Text('Tap to view'),
          onTap: _busy ? null : () => _preview(media),
          trailing: widget.onRemove == null
              ? null
              : IconButton(
                  tooltip:
                      'Remove ${media.video ? 'video' : 'photo'} ${index + 1}',
                  onPressed: _busy ? null : () => widget.onRemove!(media),
                  icon: const Icon(Icons.close),
                ),
        ),
      if (_error != null) ...[
        Text(
          _error!,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
        TextButton(
          onPressed: _busy ? null : widget.onRefresh,
          child: const Text('Refresh media links'),
        ),
      ],
    ],
  );
}
