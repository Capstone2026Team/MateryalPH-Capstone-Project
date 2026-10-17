import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';
import '../../design_system/date_time.dart';
import '../map_discovery/discovery_models.dart';
import 'notification_inbox_controller.dart';
import 'notification_scope.dart';
import 'notifications_repository.dart';

String notificationMessage(Object error) => error is DiscoveryFailure
    ? error.message
    : 'This request could not be completed. Check your connection and retry.';

IconData _categoryIcon(String category) => switch (category) {
  'SECURITY' => LucideIcons.shieldCheck,
  'TEAM' => LucideIcons.users,
  'ORDERS' => LucideIcons.package,
  'INVOICES' => LucideIcons.fileText,
  'PAYMENT' => LucideIcons.creditCard,
  'REFUND' => LucideIcons.rotateCcw,
  'FINANCE_MANDATORY' => LucideIcons.wallet,
  _ => LucideIcons.bell,
};

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({
    super.key,
    required this.repository,
    required this.open,
    this.initialNotice,
  });
  final NotificationsRepository repository;
  final Future<void> Function(String path) open;
  final String? initialNotice;
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationInboxController get _inbox => widget.repository.inbox;
  final _scroll = ScrollController();
  bool _ownsInbox = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialNotice != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(_open(widget.initialNotice!));
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ownsInbox = NotificationScope.of(context) != widget.repository;
    if (_ownsInbox) _inbox.setActive(true);
  }

  @override
  void dispose() {
    _scroll.dispose();
    if (_ownsInbox) _inbox.setActive(false);
    super.dispose();
  }

  Future<void> _open(String id) async {
    // Resolve and mark read on the server before opening the current authorized record.
    final path = await _inbox.open(id);
    if (mounted && path != null) await widget.open(path);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: buyerAppBar(context, 'Notifications'),
    body: SafeArea(
      child: ListenableBuilder(
        listenable: _inbox,
        builder: (context, _) {
          final visible = _inbox.visible;
          final empty = _inbox.loaded && visible.isEmpty;
          // A cleared inbox drops the count row so the empty state stands alone.
          final showSummary = !empty || _inbox.filtersActive;
          return CustomScrollView(
            key: const PageStorageKey('notification-inbox'),
            controller: _scroll,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                sliver: SliverList.list(
                  children: [
                    if (showSummary) _summary(context),
                    if (_inbox.categories.length > 1) _filters(),
                    if (!_inbox.loaded && _inbox.error == null)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: LinearProgressIndicator(),
                      ),
                    if (_inbox.error != null) _failure(context),
                  ],
                ),
              ),
              if (empty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: _empty()),
                )
              else if (visible.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  sliver: SliverToBoxAdapter(
                    child: Material(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: BuyerTheme.border),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          for (var i = 0; i < visible.length; i++) ...[
                            if (i > 0) const Divider(height: 1),
                            _notice(visible[i]),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    ),
  );

  /// Unread count on the left, the single bulk action on the right.
  Widget _summary(BuildContext context) {
    final count = _inbox.filteredUnreadCount;
    final label = !_inbox.loaded
        ? 'Your inbox'
        : count == 0
        ? 'No unread notifications'
        : '$count unread';
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              liveRegion: true,
              child: Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: _inbox.canMarkAll ? _inbox.markAllRead : null,
            icon: const Icon(LucideIcons.checkCheck, size: 18),
            label: const Text('Mark all as read'),
            style: TextButton.styleFrom(
              foregroundColor: BuyerTheme.action,
              minimumSize: const Size(44, 44),
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filters() {
    final selected = _inbox.category;
    Widget chip(String label, bool active, VoidCallback onTap) => Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: active,
        showCheckmark: false,
        onSelected: (_) => onTap(),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: active ? Colors.white : BuyerTheme.ink,
        ),
        selectedColor: BuyerTheme.action,
        backgroundColor: Colors.white,
        side: BorderSide(color: active ? BuyerTheme.action : BuyerTheme.border),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            chip('All', selected == null, _inbox.clearFilters),
            for (final category in _inbox.categories)
              chip(
                notificationCategoryLabel(category),
                selected == category,
                () => _inbox.filter(type: category),
              ),
            if (selected != null && !_inbox.categories.contains(selected))
              chip('Unavailable type', true, _inbox.clearFilters),
          ],
        ),
      ),
    );
  }

  Widget _failure(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Semantics(
      liveRegion: true,
      child: Row(
        children: [
          Icon(
            LucideIcons.circleAlert,
            size: 20,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _inbox.error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
          TextButton(
            onPressed: () => unawaited(_inbox.retry()),
            child: const Text('Retry'),
          ),
        ],
      ),
    ),
  );

  Widget _empty() => _inbox.filtersActive
      ? StateMessage(
          kind: StateKind.empty,
          title: 'No notifications match this type',
          message: 'Try another type to see more.',
          secondaryLabel: 'Clear filters',
          onSecondary: _inbox.clearFilters,
        )
      : const StateMessage(
          kind: StateKind.empty,
          artwork: StateArtwork.notifications,
          title: "You're all caught up",
          message: 'New order, payment and account updates will show up here.',
        );

  Widget _notice(api.NotificationItem item) {
    final textTheme = Theme.of(context).textTheme;
    final busy = _inbox.opening || _inbox.marking;
    return Semantics(
      key: ValueKey(item.id),
      button: true,
      label:
          '${item.readAt == null ? 'Unread. ' : ''}${item.title}. ${notificationCategoryLabel(item.category)}',
      child: InkWell(
        onTap: busy ? null : () => _open(item.id),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: BuyerTheme.brandSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _categoryIcon(item.category),
                  size: 20,
                  color: BuyerTheme.action,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.body,
                      style: textTheme.bodyMedium?.copyWith(
                        color: BuyerTheme.muted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          formatManilaIsoDateTime(item.createdAt),
                          style: textTheme.bodySmall?.copyWith(
                            color: BuyerTheme.muted,
                          ),
                        ),
                        if (item.mandatory)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                LucideIcons.lock,
                                size: 12,
                                color: BuyerTheme.muted,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  'Required notice',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: BuyerTheme.muted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 4, top: 10),
                child: Icon(
                  LucideIcons.chevronRight,
                  size: 20,
                  color: BuyerTheme.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
