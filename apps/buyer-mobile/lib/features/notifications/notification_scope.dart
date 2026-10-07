import 'package:flutter/widgets.dart';
import 'notifications_repository.dart';

class NotificationScope extends InheritedWidget {
  const NotificationScope({
    super.key,
    required this.repository,
    required super.child,
  });
  final NotificationsRepository repository;
  static NotificationsRepository? of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<NotificationScope>()
      ?.repository;
  @override
  bool updateShouldNotify(NotificationScope oldWidget) =>
      repository != oldWidget.repository;
}
