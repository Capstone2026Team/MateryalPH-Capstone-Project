import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme.dart';

/// A local, unsubmitted attachment. Uploads use the file path rather than buffering a video.
class SelectedMedia {
  const SelectedMedia({
    required this.file,
    required this.video,
    required this.size,
  });
  final XFile file;
  final bool video;
  final int size;
}

/// Shared gallery/camera chooser with explicit limits, preview and removal.
class MediaAttachmentField extends StatefulWidget {
  const MediaAttachmentField({
    super.key,
    required this.files,
    required this.onAdd,
    required this.onRemove,
    required this.photoMaxBytes,
    required this.videoMaxBytes,
    required this.maxFiles,
    this.enabled = true,
    this.existingCount = 0,
    required this.recoveryKey,
  });
  final List<SelectedMedia> files;
  final ValueChanged<SelectedMedia> onAdd;
  final ValueChanged<SelectedMedia> onRemove;
  final int photoMaxBytes;
  final int videoMaxBytes;
  final int maxFiles;
  final bool enabled;
  final int existingCount;
  final String recoveryKey;

  @override
  State<MediaAttachmentField> createState() => _MediaAttachmentFieldState();
}

class _MediaAttachmentFieldState extends State<MediaAttachmentField> {
  bool _picking = false;
  String? _error;

  Future<void> _pick(bool video, ImageSource source) async {
    setState(() {
      _picking = true;
      _error = null;
    });
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(
        'pending_review_media',
        '${widget.recoveryKey}:${video ? 'video' : 'photo'}',
      );
      final picker = ImagePicker();
      final file = video
          ? await picker.pickVideo(source: source)
          : await picker.pickImage(source: source, imageQuality: 85);
      if (file == null || !mounted) {
        return;
      }
      final size = await file.length();
      final extension = file.name.split('.').last.toLowerCase();
      final allowed = video ? ['mp4', 'mov'] : ['jpg', 'jpeg', 'png'];
      final limit = video ? widget.videoMaxBytes : widget.photoMaxBytes;
      if (!allowed.contains(extension) || size < 1 || size > limit) {
        if (mounted) {
          setState(
            () => _error =
                'Choose ${video ? 'MP4/MOV' : 'JPG/PNG'} up to ${limit ~/ (1024 * 1024)} MB.',
          );
        }
        return;
      }
      if (mounted &&
          widget.enabled &&
          widget.files.length + widget.existingCount < widget.maxFiles) {
        widget.onAdd(SelectedMedia(file: file, video: video, size: size));
      }
    } on PlatformException {
      if (mounted) {
        setState(
          () => _error =
              'The camera or gallery could not open. Check its permission in Settings and retry.',
        );
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'This file could not be opened. Choose it again.',
        );
      }
    } finally {
      final preferences = await SharedPreferences.getInstance();
      final marker = preferences.getString('pending_review_media');
      if (marker?.startsWith('${widget.recoveryKey}:') ?? false) {
        await preferences.remove('pending_review_media');
      }
      if (mounted) {
        setState(() => _picking = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final canAdd =
        widget.enabled &&
        !_picking &&
        widget.files.length + widget.existingCount < widget.maxFiles;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photos and videos (optional)',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        for (final video in [false, true])
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: BuyerTheme.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video ? 'Add video' : 'Add photo',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    TextButton.icon(
                      onPressed: canAdd
                          ? () => _pick(video, ImageSource.gallery)
                          : null,
                      icon: const Icon(Icons.upload_outlined),
                      label: Text(video ? 'Choose video' : 'Choose photo'),
                    ),
                    TextButton.icon(
                      onPressed: canAdd
                          ? () => _pick(video, ImageSource.camera)
                          : null,
                      icon: Icon(
                        video
                            ? Icons.videocam_outlined
                            : Icons.camera_alt_outlined,
                      ),
                      label: Text(video ? 'Record video' : 'Take photo'),
                    ),
                  ],
                ),
                Text(
                  '${video ? 'MP4 / MOV' : 'JPG / PNG'} · Max ${(video ? widget.videoMaxBytes : widget.photoMaxBytes) ~/ (1024 * 1024)} MB',
                  style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
                ),
              ],
            ),
          ),
        Text(
          'Up to ${widget.maxFiles} attachments per product. Avoid faces, addresses and other personal information.',
          style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
        ),
        if (_picking) const LinearProgressIndicator(),
        if (_error != null)
          Text(
            _error!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        for (final media in widget.files)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: media.video
                ? const Icon(Icons.videocam_outlined)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(media.file.path),
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.image_outlined),
                    ),
                  ),
            title: Text(
              media.file.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '${(media.size / (1024 * 1024)).toStringAsFixed(1)} MB · Tap to preview',
            ),
            onTap: () => showMediaPreview(
              context,
              path: media.file.path,
              video: media.video,
            ),
            trailing: IconButton(
              tooltip: 'Remove ${media.file.name}',
              onPressed: widget.enabled && !_picking
                  ? () => widget.onRemove(media)
                  : null,
              icon: const Icon(Icons.close),
            ),
          ),
      ],
    );
  }
}

Future<void> showMediaPreview(
  BuildContext context, {
  String? path,
  Uint8List? bytes,
  required bool video,
}) => showDialog<void>(
  context: context,
  builder: (_) => _MediaPreview(path: path, bytes: bytes, video: video),
);

class _MediaPreview extends StatefulWidget {
  const _MediaPreview({this.path, this.bytes, required this.video});
  final String? path;
  final Uint8List? bytes;
  final bool video;
  @override
  State<_MediaPreview> createState() => _MediaPreviewState();
}

class _MediaPreviewState extends State<_MediaPreview> {
  VideoPlayerController? _video;
  bool _failed = false;
  @override
  void initState() {
    super.initState();
    if (widget.video) {
      _video = VideoPlayerController.file(File(widget.path!));
      _video!
          .initialize()
          .then((_) {
            if (mounted) setState(() {});
          })
          .catchError((Object _) {
            if (mounted) setState(() => _failed = true);
          });
    }
  }

  @override
  void dispose() {
    _video?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Dialog(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.video ? 'Video preview' : 'Photo preview',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: 'Close preview',
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          Flexible(
            child: widget.video
                ? _failed
                      ? const Text(
                          'This video could not play. Choose another MP4 or MOV.',
                        )
                      : _video!.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _video!.value.aspectRatio,
                          child: VideoPlayer(_video!),
                        )
                      : const Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(),
                        )
                : InteractiveViewer(
                    child: widget.bytes != null
                        ? Image.memory(
                            widget.bytes!,
                            errorBuilder: (_, _, _) =>
                                const Text('This photo could not open.'),
                          )
                        : Image.file(
                            File(widget.path!),
                            errorBuilder: (_, _, _) =>
                                const Text('This photo could not open.'),
                          ),
                  ),
          ),
          if (widget.video && _video!.value.isInitialized)
            TextButton.icon(
              onPressed: () async {
                _video!.value.isPlaying
                    ? await _video!.pause()
                    : await _video!.play();
                if (mounted) setState(() {});
              },
              icon: Icon(
                _video!.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              label: Text(_video!.value.isPlaying ? 'Pause' : 'Play'),
            ),
        ],
      ),
    ),
  );
}
