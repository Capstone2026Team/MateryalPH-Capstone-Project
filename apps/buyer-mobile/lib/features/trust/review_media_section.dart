import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../design_system/components/media_attachment_field.dart';
import '../../design_system/components/buyer_overlays.dart';
import '../../design_system/components/product_reviews.dart';
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
    this.compact = false,
  });
  final ReviewsRepository repository;
  final String reviewId;
  final List<ReviewMediaView> media;
  final Future<void> Function(ReviewMediaView)? onRemove;
  final Future<void> Function() onRefresh;
  final bool compact;
  @override
  State<ReviewMediaSection> createState() => _ReviewMediaSectionState();
}

class _ReviewMediaSectionState extends State<ReviewMediaSection> {
  bool _busy = false;
  String? _error;
  Uint8List? _coverBytes;
  bool _coverLoading = false;
  bool _coverFailed = false;
  int _coverGeneration = 0;

  @override
  void initState() {
    super.initState();
    _loadCover();
  }

  @override
  void didUpdateWidget(covariant ReviewMediaSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.repository != widget.repository ||
        oldWidget.reviewId != widget.reviewId ||
        oldWidget.compact != widget.compact ||
        oldWidget.media.firstOrNull?.url != widget.media.firstOrNull?.url) {
      _loadCover();
    }
  }

  Future<void> _loadCover() async {
    final generation = ++_coverGeneration;
    final cover = widget.media.firstOrNull;
    _coverBytes = null;
    _coverFailed = false;
    _coverLoading = widget.compact && cover != null && !cover.video;
    // Fetch videos only when the Buyer opens the player.
    if (!_coverLoading) return;
    try {
      final bytes = await widget.repository.media(widget.reviewId, cover!);
      if (mounted && generation == _coverGeneration) {
        setState(() {
          _coverBytes = bytes;
          _coverLoading = false;
        });
      }
    } catch (_) {
      if (mounted && generation == _coverGeneration) {
        setState(() {
          _coverFailed = true;
          _coverLoading = false;
        });
      }
    }
  }

  Future<void> _chooseAttachment() async {
    final media = await showBuyerBottomSheet<ReviewMediaView>(
      context: context,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const ListTile(
              title: Text(
                'Review attachments',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            for (final (index, media) in widget.media.indexed)
              ListTile(
                leading: Icon(
                  media.video
                      ? Icons.play_circle_outline
                      : Icons.image_outlined,
                ),
                title: Text('${media.video ? 'Video' : 'Photo'} ${index + 1}'),
                minTileHeight: 48,
                onTap: () => Navigator.pop(context, media),
              ),
          ],
        ),
      ),
    );
    if (media != null && mounted) await _preview(media);
  }

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
      if (widget.compact && widget.media.isNotEmpty) ...[
        ReviewMediaTile(
          video: widget.media.first.video,
          bytes: _coverBytes,
          loading: _coverLoading,
          failed: _coverFailed,
          onPressed: _busy || _coverLoading
              ? null
              : _coverFailed
              ? widget.onRefresh
              : () => _preview(widget.media.first),
        ),
        if (_coverFailed)
          const Text(
            'Photo unavailable. Tap to refresh.',
            style: TextStyle(fontSize: 11),
          ),
        if (widget.media.length > 1)
          TextButton(
            onPressed: _busy ? null : _chooseAttachment,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            ),
            child: Text(
              'View all (${widget.media.length})',
              style: const TextStyle(fontSize: 12),
            ),
          ),
      ] else
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
