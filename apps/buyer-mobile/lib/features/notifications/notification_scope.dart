import 'dart:async';
import 'package:flutter/material.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import 'notifications_repository.dart';

/// Owns foreground realtime/polling once for the authenticated app, including
/// while the inbox is closed. Private snapshots are cleared when access ends.
class NotificationScope extends StatefulWidget {
  const NotificationScope({
    super.key,
    required this.repository,
    required this.child,
    this.active = true,
    this.navigatorKey,
  });
  final NotificationsRepository repository;
  final Widget child;
  final bool active;
  final GlobalKey<NavigatorState>? navigatorKey;
  static NotificationsRepository? of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_NotificationProvider>()
      ?.repository;
  @override
  State<NotificationScope> createState() => _NotificationScopeState();
}

class _NotificationScopeState extends State<NotificationScope>
    with WidgetsBindingObserver {
  bool _foreground = true;
  final Set<String> _shown = {};
  DialogRoute<void>? _noticeRoute;
  bool _scheduled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.repository.inbox.addListener(_noticeChanged);
    _foreground =
        WidgetsBinding.instance.lifecycleState == null ||
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    _sync();
  }

  void _sync() {
    widget.repository.inbox.setActive(
      widget.active && _foreground,
      clear: !widget.active,
    );
    widget.repository.navigation.setActive(
      widget.active && _foreground,
      clear: !widget.active,
    );
    if (!widget.active || !_foreground) {
      _closeNotice();
      _shown.clear();
    } else {
      _noticeChanged();
    }
  }

  void _closeNotice() {
    final route = _noticeRoute;
    _noticeRoute = null;
    if (route == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (route.isActive) route.navigator?.removeRoute(route);
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  void _noticeChanged() {
    if (!mounted ||
        !widget.active ||
        !_foreground ||
        _noticeRoute != null ||
        _scheduled) {
      return;
    }
    final notice = widget.repository.inbox.items
        .where(
          (item) =>
              item.category == 'SUSPENSION' &&
              item.readAt == null &&
              !_shown.contains(item.id),
        )
        .firstOrNull;
    if (notice == null || widget.navigatorKey?.currentState == null) return;
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      if (!mounted || !widget.active || !_foreground || _noticeRoute != null) {
        return;
      }
      final navigator = widget.navigatorKey?.currentState;
      if (navigator == null) return;
      _shown.add(notice.id);
      final repository = widget.repository;
      final route = DialogRoute<void>(
        context: navigator.context,
        barrierDismissible: false,
        builder: (_) => _EnforcementNotice(
          notice: notice,
          acknowledge: () => repository.inbox.open(notice.id),
        ),
      );
      _noticeRoute = route;
      unawaited(
        navigator.push(route).then((_) {
          if (_noticeRoute == route) _noticeRoute = null;
          if (mounted && widget.repository == repository) _noticeChanged();
        }),
      );
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  @override
  void didUpdateWidget(NotificationScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.repository != widget.repository) {
      oldWidget.repository.inbox.removeListener(_noticeChanged);
      widget.repository.inbox.addListener(_noticeChanged);
      _shown.clear();
      _closeNotice();
      oldWidget.repository.inbox.setActive(false, clear: true);
      oldWidget.repository.navigation.setActive(false, clear: true);
    }
    _sync();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    _sync();
  }

  @override
  void dispose() {
    widget.repository.inbox.removeListener(_noticeChanged);
    WidgetsBinding.instance.removeObserver(this);
    widget.repository.inbox.setActive(false, clear: true);
    widget.repository.navigation.setActive(false, clear: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _NotificationProvider(repository: widget.repository, child: widget.child);
}

class _EnforcementNotice extends StatefulWidget {
  const _EnforcementNotice({required this.notice, required this.acknowledge});
  final api.NotificationItem notice;
  final Future<String?> Function() acknowledge;
  @override
  State<_EnforcementNotice> createState() => _EnforcementNoticeState();
}

class _EnforcementNoticeState extends State<_EnforcementNotice> {
  bool _busy = false;
  bool _failed = false;
  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_busy,
    child: AlertDialog(
      title: Text(widget.notice.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.notice.body),
            if (_failed)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  'Could not acknowledge this notice. Check your connection and retry.',
                ),
              ),
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: _busy
              ? null
              : () async {
                  setState(() {
                    _busy = true;
                    _failed = false;
                  });
                  final result = await widget.acknowledge();
                  if (!context.mounted) return;
                  if (result != null) {
                    Navigator.of(context).pop();
                  } else {
                    setState(() {
                      _busy = false;
                      _failed = true;
                    });
                  }
                },
          child: Text(_busy ? 'Saving…' : 'Acknowledge'),
        ),
      ],
    ),
  );
}

class _NotificationProvider extends InheritedWidget {
  const _NotificationProvider({required this.repository, required super.child});
  final NotificationsRepository repository;
  @override
  bool updateShouldNotify(_NotificationProvider oldWidget) =>
      oldWidget.repository != repository;
}
