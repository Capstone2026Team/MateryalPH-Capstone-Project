import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import 'package:share_plus/share_plus.dart';
import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import 'notification_inbox_controller.dart';
import 'notification_preferences_dialog.dart';
import 'notification_scope.dart';
import 'notifications_repository.dart';

String notificationMessage(Object error) => error is DiscoveryFailure
    ? error.message
    : 'This request could not be completed. Check your connection and retry.';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({
    super.key,
    required this.repository,
    required this.open,
    this.enablePush,
    this.initialNotice,
  });
  final NotificationsRepository repository;
  final Future<void> Function(String path) open;
  final Future<void> Function()? enablePush;
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

  void _preferences() => showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => NotificationPreferencesDialog(
      repository: widget.repository,
      enablePush: widget.enablePush,
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: buyerAppBar(
      context,
      'Notifications',
      actions: [
        BuyerHeaderIconButton(
          icon: LucideIcons.fileText,
          tooltip: 'Documents and exports',
          onPressed: () => Navigator.push<void>(
            context,
            MaterialPageRoute(
              builder: (_) => BuyerReportsScreen(repository: widget.repository),
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    ),
    body: SafeArea(
      child: ListenableBuilder(
        listenable: _inbox,
        builder: (context, _) {
          final visible = _inbox.visible;
          return ListView(
            key: const PageStorageKey('notification-inbox'),
            controller: _scroll,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Your inbox',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  BuyerHeaderIconButton(
                    icon: LucideIcons.settings2,
                    tooltip: 'Notification preferences',
                    onPressed: _preferences,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LayoutBuilder(
                builder: (context, constraints) {
                  final type = DropdownButtonFormField<String>(
                    initialValue: _inbox.category ?? '',
                    key: ValueKey('notification-type-${_inbox.category ?? ''}'),
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Type',
                      isDense: true,
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: '',
                        child: Text('All types'),
                      ),
                      for (final category in _inbox.categories)
                        DropdownMenuItem(
                          value: category,
                          child: Text(
                            notificationCategoryLabel(category),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      if (_inbox.category != null &&
                          !_inbox.categories.contains(_inbox.category))
                        DropdownMenuItem(
                          value: _inbox.category!,
                          child: const Text('Unavailable type'),
                        ),
                    ],
                    onChanged: (value) =>
                        _inbox.filter(type: value, clearType: value == ''),
                  );
                  final status =
                      DropdownButtonFormField<NotificationInboxStatus>(
                        initialValue: _inbox.status,
                        key: ValueKey(
                          'notification-status-${_inbox.status.name}',
                        ),
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          isDense: true,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: NotificationInboxStatus.unread,
                            child: Text(
                              'Unread (${_inbox.filteredUnreadCount})',
                            ),
                          ),
                          DropdownMenuItem(
                            value: NotificationInboxStatus.archived,
                            child: Text(
                              'Archived (${_inbox.filteredArchivedCount})',
                            ),
                          ),
                        ],
                        onChanged: (value) =>
                            _inbox.filter(selectedStatus: value),
                      );
                  return constraints.maxWidth < 420 ||
                          MediaQuery.textScalerOf(context).scale(14) > 20
                      ? Column(
                          children: [type, const SizedBox(height: 12), status],
                        )
                      : Row(
                          children: [
                            Expanded(flex: 3, child: type),
                            const SizedBox(width: 12),
                            Expanded(flex: 2, child: status),
                          ],
                        );
                },
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: _inbox.canMarkAll ? _inbox.markAllRead : null,
                    icon: const Icon(LucideIcons.checkCheck, size: 18),
                    label: const Text('Mark all as read'),
                  ),
                  if (_inbox.filtersActive)
                    TextButton(
                      onPressed: _inbox.clearFilters,
                      child: const Text('Clear filters'),
                    ),
                ],
              ),
              if (!_inbox.loaded && _inbox.error == null)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: LinearProgressIndicator(),
                ),
              if (_inbox.error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Semantics(
                    liveRegion: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _inbox.error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        TextButton(
                          onPressed: () => unawaited(_inbox.retry()),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              if (_inbox.loaded && visible.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      const Icon(
                        LucideIcons.bell,
                        color: BuyerTheme.muted,
                        size: 28,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _inbox.status == NotificationInboxStatus.unread
                            ? "You're all caught up."
                            : 'No notifications match your filters.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      if (_inbox.filtersActive)
                        TextButton(
                          onPressed: _inbox.clearFilters,
                          child: const Text('Clear filters'),
                        ),
                    ],
                  ),
                ),
              for (final item in visible) _notice(item),
            ],
          );
        },
      ),
    ),
  );

  Widget _notice(api.NotificationItem item) => Padding(
    key: ValueKey(item.id),
    padding: const EdgeInsets.only(bottom: 12),
    child: Material(
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: BuyerTheme.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                if (item.readAt == null)
                  const Text(
                    'Unread',
                    style: TextStyle(color: BuyerTheme.action, fontSize: 12),
                  ),
                if (item.mandatory)
                  const Text(
                    'Required notice',
                    style: TextStyle(color: BuyerTheme.muted, fontSize: 12),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(item.body, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            Text(
              _manila(item.createdAt),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: _inbox.opening || _inbox.marking
                    ? null
                    : () => _open(item.id),
                child: const Text('View details'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

String _manila(String date) {
  final value = DateTime.tryParse(date);
  if (value == null) return date;
  return '${value.toUtc().add(const Duration(hours: 8)).toIso8601String().replaceFirst('T', ' ').substring(0, 16)} Manila';
}

class BuyerReportsScreen extends StatefulWidget {
  const BuyerReportsScreen({
    super.key,
    required this.repository,
    this.resourceId,
    this.project = false,
  });
  final NotificationsRepository repository;
  final String? resourceId;
  final bool project;
  @override
  State<BuyerReportsScreen> createState() => _BuyerReportsScreenState();
}

class _BuyerReportsScreenState extends State<BuyerReportsScreen> {
  List<api.DocumentExport> _items = [];
  String? _error;
  bool _busy = false, _more = false;
  int _page = 1;
  final _purpose = TextEditingController();
  final _requestKeys = <String, String>{};
  var _format = api.DocumentExportInputFormatEnum.PDF;
  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _purpose.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() work) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await work();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = notificationMessage(e);
          if (e is DiscoveryFailure &&
              (e.kind == DiscoveryFailureKind.forbidden ||
                  e.kind == DiscoveryFailureKind.sessionExpired)) {
            _items.clear();
          }
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _load([int page = 1]) => _run(() async {
    final result = await widget.repository.reports(page);
    if (mounted) {
      setState(() {
        _items = page == 1 ? result.data.toList() : [..._items, ...result.data];
        _page = page;
        _more = result.meta['has_more']?.value == true;
      });
    }
  });
  Future<void> _download(api.DocumentExport item) => _run(() async {
    final Uint8List bytes = await widget.repository.download(item.id);
    if (!mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile.fromData(
            bytes,
            mimeType: item.format == 'PDF' ? 'application/pdf' : 'text/csv',
          ),
        ],
        fileNameOverrides: [
          'materyalph-${item.type.toLowerCase()}.${item.format.toLowerCase()}',
        ],
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      ),
    );
  });
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: buyerAppBar(context, 'Documents & exports'),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Private snapshots · Not tax invoices',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            'Exports show their source version and generation time. Downloads expire after 24 hours and require current access.',
          ),
          if (_busy) const LinearProgressIndicator(),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(_error!, semanticsLabel: 'Error: $_error'),
            ),
          if (widget.resourceId != null) ...[
            const SizedBox(height: 20),
            TextField(
              controller: _purpose,
              maxLength: 500,
              decoration: const InputDecoration(
                labelText: 'Purpose',
                helperText: 'At least 10 characters',
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                for (final format in [
                  api.DocumentExportInputFormatEnum.PDF,
                  api.DocumentExportInputFormatEnum.CSV,
                ])
                  ChoiceChip(
                    label: Text(format.name),
                    selected: _format == format,
                    onSelected: _busy
                        ? null
                        : (_) => setState(() => _format = format),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            for (final type
                in widget.project
                    ? [
                        api.DocumentExportInputTypeEnum.PROJECT_SUMMARY,
                        api.DocumentExportInputTypeEnum.BUDGET_REPORT,
                      ]
                    : [
                        api.DocumentExportInputTypeEnum.PURCHASE_ORDER,
                        api.DocumentExportInputTypeEnum.PAYMENT_CONFIRMATION,
                      ])
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OutlinedButton(
                  onPressed: _busy
                      ? null
                      : () => _run(() async {
                          if (_purpose.text.trim().length < 10) {
                            setState(
                              () => _error =
                                  'Describe your purpose in at least 10 characters.',
                            );
                            return;
                          }
                          final fingerprint =
                              '${type.name}/${_format.name}/${_purpose.text.trim()}';
                          final key = _requestKeys.putIfAbsent(
                            fingerprint,
                            widget.repository.newKey,
                          );
                          await widget.repository.requestReport(
                            widget.resourceId!,
                            type,
                            _format,
                            _purpose.text.trim(),
                            key,
                          );
                          final result = await widget.repository.reports();
                          if (mounted) {
                            setState(() => _items = result.data.toList());
                          }
                        }),
                  child: Text(
                    'Generate ${type.name.toLowerCase().replaceAll('_', ' ')}',
                  ),
                ),
              ),
          ],
          const SizedBox(height: 20),
          TextButton(
            onPressed: _busy ? null : _load,
            child: const Text('Refresh export status'),
          ),
          if (!_busy && _items.isEmpty)
            const Text(
              'No authorized exports to show. Open an order or Project to generate a document.',
            ),
          for (final item in _items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.type.replaceAll('_', ' ')} · ${item.state}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(item.purpose),
                  Text(
                    'Expires: ${item.expiresAt == null ? 'After generation' : _manila(item.expiresAt!)}',
                  ),
                  ExpansionTile(
                    title: const Text('Source & access record'),
                    children: [
                      SelectableText(
                        'Source: ${item.sourceHash}\nChecksum: ${item.checksum}\n${item.sourceVersions}\n${item.accessRecord.map((e) => '${e.action} ${e.occurredAt}').join('\n')}',
                      ),
                    ],
                  ),
                  if (item.state == 'READY')
                    OutlinedButton.icon(
                      onPressed: _busy ? null : () => _download(item),
                      icon: const Icon(Icons.download_outlined),
                      label: const Text('Download / share'),
                    ),
                  const Divider(),
                ],
              ),
            ),
          if (_more)
            TextButton(
              onPressed: _busy ? null : () => _load(_page + 1),
              child: const Text('Load more'),
            ),
        ],
      ),
    ),
  );
}
