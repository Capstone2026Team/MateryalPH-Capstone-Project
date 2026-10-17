import 'package:flutter/widgets.dart';
import 'notifications_repository.dart';

/// Owns foreground realtime/polling once for the authenticated app, including
/// while the inbox is closed. Private snapshots are cleared when access ends.
class NotificationScope extends StatefulWidget {
  const NotificationScope({
    super.key,
    required this.repository,
    required this.child,
    this.active = true,
  });
  final NotificationsRepository repository;
  final Widget child;
  final bool active;
  static NotificationsRepository? of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_NotificationProvider>()
      ?.repository;
  @override
  State<NotificationScope> createState() => _NotificationScopeState();
}

class _NotificationScopeState extends State<NotificationScope>
    with WidgetsBindingObserver {
  bool _foreground = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
  }

  @override
  void didUpdateWidget(NotificationScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.repository != widget.repository) {
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
    WidgetsBinding.instance.removeObserver(this);
    widget.repository.inbox.setActive(false, clear: true);
    widget.repository.navigation.setActive(false, clear: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _NotificationProvider(repository: widget.repository, child: widget.child);
}

class _NotificationProvider extends InheritedWidget {
  const _NotificationProvider({required this.repository, required super.child});
  final NotificationsRepository repository;
  @override
  bool updateShouldNotify(_NotificationProvider oldWidget) =>
      oldWidget.repository != repository;
}
