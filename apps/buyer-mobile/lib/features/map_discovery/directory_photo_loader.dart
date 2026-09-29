import 'dart:async';
import 'dart:collection';

import 'discovery_models.dart';
import 'discovery_repository.dart';

/// Load only mounted list rows, with two concurrent requests and at most 15
/// starts per minute. Leave room in the existing Places limit for user actions.
/// Media lives in the row, never in the discovery cache or saved locations.
class DirectoryPhotoLoader {
  DirectoryPhotoLoader(this.repository, {DateTime Function()? now})
    : _now = now ?? DateTime.now;
  final DateTime Function() _now;
  final DiscoveryRepository repository;
  final _pending = Queue<_PhotoRequest>();
  final _starts = Queue<DateTime>();
  Timer? _wake;
  int _running = 0;
  bool _disposed = false;
  DateTime? _suspendedUntil;

  Future<DirectoryPhotoView?> load(String id, bool Function() isVisible) {
    if (_disposed) return Future.value();
    final request = _PhotoRequest(id, isVisible);
    _pending.add(request);
    scheduleMicrotask(_pump);
    return request.result.future;
  }

  void _pump() {
    if (_disposed) return;
    _wake?.cancel();
    final now = _now();
    while (_starts.isNotEmpty &&
        now.difference(_starts.first).inSeconds >= 60) {
      _starts.removeFirst();
    }
    _pending.removeWhere((request) {
      if (request.isVisible() && !(_suspendedUntil?.isAfter(now) ?? false)) {
        return false;
      }
      request.result.complete();
      return true;
    });
    while (_pending.isNotEmpty && _running < 2 && _starts.length < 15) {
      final request = _pending.removeFirst();
      _starts.add(now);
      _running++;
      unawaited(_run(request));
    }
    if (_pending.isNotEmpty && _starts.length >= 15) {
      _wake = Timer(
        const Duration(seconds: 60) - now.difference(_starts.first),
        _pump,
      );
    }
  }

  Future<void> _run(_PhotoRequest request) async {
    DirectoryPhotoView? photo;
    try {
      photo = await repository.directoryPhoto(request.id);
    } on DiscoveryFailure catch (failure) {
      if (failure.kind == DiscoveryFailureKind.rateLimited ||
          failure.kind == DiscoveryFailureKind.provider ||
          failure.kind == DiscoveryFailureKind.offline) {
        _suspendedUntil = _now().add(const Duration(minutes: 1));
      }
    } catch (_) {
      // Missing media, quota, offline and provider errors keep the neutral icon.
      // No automatic retries that would amplify a provider outage.
    } finally {
      _running--;
      request.result.complete(_disposed || !request.isVisible() ? null : photo);
      _pump();
    }
  }

  void dispose() {
    _disposed = true;
    _wake?.cancel();
    for (final request in _pending) {
      request.result.complete();
    }
    _pending.clear();
  }
}

class _PhotoRequest {
  _PhotoRequest(this.id, this.isVisible);
  final String id;
  final bool Function() isVisible;
  final result = Completer<DirectoryPhotoView?>();
}
