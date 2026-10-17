import 'dart:async';
import 'package:flutter/material.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/components/project_inquiry_list.dart';
import 'messaging_repository.dart';
import '../map_discovery/discovery_models.dart';

class ProjectInquiriesScreen extends StatefulWidget {
  const ProjectInquiriesScreen({
    super.key,
    required this.repository,
    required this.inquiryId,
    required this.onOpen,
  });
  final MessagingRepository repository;
  final String inquiryId;
  final Future<void> Function(String) onOpen;

  @override
  State<ProjectInquiriesScreen> createState() => _ProjectInquiriesScreenState();
}

class _ProjectInquiriesScreenState extends State<ProjectInquiriesScreen>
    with WidgetsBindingObserver {
  api.ConversationPage? _result;
  String? _error;
  String? _moreError;
  bool _running = false;
  bool _appending = false;
  bool _pending = false;
  Future<void>? _inFlight;
  int _generation = 0;
  bool _live = false;
  bool _opening = false;
  int _quiet = 0;
  Timer? _timer;
  void Function()? _stop;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_load());
    unawaited(_watch());
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      _quiet++;
      if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed &&
          ModalRoute.of(context)?.isCurrent == true &&
          (!_live || _quiet >= 11)) {
        _quiet = 0;
        unawaited(_load());
      }
    });
  }

  Future<void> _watch() async {
    final stop = await widget.repository.watchInbox(
      () => unawaited(_load()),
      onLive: (value) => _live = value,
    );
    if (mounted) {
      _stop = stop;
    } else {
      stop();
    }
  }

  Future<void> _load({bool append = false}) {
    if (!mounted) return Future.value();
    final running = _inFlight;
    if (running != null) {
      if (!append) _pending = true;
      return running;
    }
    if (append && (_result == null || !_result!.hasMore || _error != null)) {
      return Future.value();
    }
    final generation = _generation;
    final request = _fetch(append, generation);
    _inFlight = request;
    return request.whenComplete(() {
      if (!mounted || generation != _generation) return;
      _inFlight = null;
      if (_pending) {
        _pending = false;
        unawaited(_load());
      }
    });
  }

  Future<void> _fetch(bool append, int generation) async {
    setState(() {
      _running = true;
      _appending = append;
      _error = null;
      if (append) _moreError = null;
    });
    final source = widget.inquiryId;
    final lastPage = _result?.page ?? 1;
    final items = <String, api.ConversationView>{
      if (append)
        for (final item in _result!.items) item.id: item,
    };
    try {
      api.ConversationPage? latest;
      // Refresh the loaded range so activity reordering cannot leave stale or duplicate rows.
      for (
        var page = append ? lastPage + 1 : 1;
        page <= (append ? lastPage + 1 : lastPage);
        page++
      ) {
        latest = await widget.repository.projectInquiries(source, page: page);
        if (!mounted || generation != _generation) return;
        for (final item in latest.items) {
          items[item.id] = item;
        }
        if (!latest.hasMore) break;
      }
      setState(() {
        _result = latest!.rebuild((b) => b..items.replace(items.values));
        if (!_result!.hasMore) _moreError = null;
      });
    } catch (error) {
      if (mounted && generation == _generation) {
        setState(() {
          final message = error is DiscoveryFailure
              ? error.message
              : append
              ? 'Unable to load more project inquiries. Please retry.'
              : 'Unable to load project inquiries. Please retry.';
          final accessChanged =
              error is DiscoveryFailure &&
              const {
                DiscoveryFailureKind.sessionExpired,
                DiscoveryFailureKind.forbidden,
                DiscoveryFailureKind.notFound,
              }.contains(error.kind);
          if (accessChanged) {
            _result = null;
            _moreError = null;
          }
          if (append && !accessChanged) {
            _moreError = message;
          } else {
            _error = message;
          }
        });
      }
    } finally {
      if (mounted && generation == _generation) {
        setState(() {
          _running = false;
          _appending = false;
        });
      }
    }
  }

  @override
  void didUpdateWidget(covariant ProjectInquiriesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.inquiryId == widget.inquiryId) return;
    _generation++;
    _result = null;
    _error = _moreError = null;
    _inFlight = null;
    _running = _appending = _pending = false;
    unawaited(_load());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(_load());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _stop?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: buyerAppBar(context, 'Project inquiries'),
    body: _result == null
        ? Center(
            child: _error != null
                ? _failure()
                : const CircularProgressIndicator(),
          )
        : Column(
            children: [
              if (_error != null) _failure(),
              Expanded(
                child: ProjectInquiryList(
                  key: ValueKey(widget.inquiryId),
                  items: _result!.items.toList(),
                  hasMore: _result!.hasMore && !_running && _error == null,
                  loadingMore: _running && _appending,
                  loadMoreError: _moreError,
                  onLoadMore: () => unawaited(_load(append: true)),
                  onRefresh: () => _load(),
                  onSelect: (id) async {
                    if (_opening) return;
                    _opening = true;
                    try {
                      await widget.onOpen(id);
                    } finally {
                      _opening = false;
                      if (mounted) unawaited(_load());
                    }
                  },
                ),
              ),
            ],
          ),
  );

  Widget _failure() => Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Expanded(child: Text(_error!)),
        TextButton(
          onPressed: _running ? null : () => unawaited(_load()),
          child: const Text('Retry'),
        ),
      ],
    ),
  );
}
