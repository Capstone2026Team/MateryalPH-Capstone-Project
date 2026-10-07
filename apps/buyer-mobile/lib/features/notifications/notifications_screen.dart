import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import 'package:share_plus/share_plus.dart';
import '../../design_system/components/buyer_app_bar.dart';
import '../map_discovery/discovery_models.dart';
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
  final _items = <api.NotificationItem>[];
  List<api.NotificationPreference> _preferences = [];
  String? _cursor, _error;
  bool _busy = false, _loaded = false;
  int _tab = 0;
  @override
  void initState() {
    super.initState();
    if (widget.initialNotice == null) {
      _load();
    } else {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _open(widget.initialNotice!),
      );
    }
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
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

  Future<void> _load([bool more = false]) => _run(() async {
    final page = await widget.repository.list(more ? _cursor : null);
    if (mounted) {
      setState(() {
        if (!more) _items.clear();
        _items.addAll(page.data);
        _cursor = page.meta['next_cursor']?.value as String?;
        _loaded = true;
      });
    }
  });
  Future<void> _open(String id) async {
    // A push is only an opaque notice ID. The server authenticates and authorizes its destination now.
    await _run(() async {
      final path = await widget.repository.resolve(id);
      if (mounted) await widget.open(path);
    });
  }

  Future<void> _prefs() => _run(() async {
    final result = await widget.repository.preferences();
    if (mounted) setState(() => _preferences = result);
  });
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: buyerAppBar(context, 'Notifications'),
    body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Inbox'),
                  selected: _tab == 0,
                  onSelected: (_) => setState(() => _tab = 0),
                ),
                ChoiceChip(
                  label: const Text('Preferences'),
                  selected: _tab == 1,
                  onSelected: (_) {
                    setState(() => _tab = 1);
                    _prefs();
                  },
                ),
                ActionChip(
                  label: const Text('Documents'),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          BuyerReportsScreen(repository: widget.repository),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_busy) const LinearProgressIndicator(),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Semantics(
                liveRegion: true,
                child: Column(
                  children: [
                    Text(_error!),
                    TextButton(
                      onPressed: _busy
                          ? null
                          : () => _tab == 0 ? _load() : _prefs(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: _tab == 0
                ? RefreshIndicator(
                    onRefresh: _load,
                    child: ListView(
                      children: [
                        if (_loaded && _items.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(24),
                            child: Text(
                              'You’re up to date. New account and transaction updates will appear here.',
                            ),
                          ),
                        for (final item in _items)
                          Column(
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                title: Text(item.title),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 6),
                                    Text(item.body),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${item.mandatory ? 'Required notice · ' : ''}${item.readAt == null ? 'Unread · ' : ''}${_manila(item.createdAt)}',
                                    ),
                                  ],
                                ),
                                onTap: _busy ? null : () => _open(item.id),
                              ),
                              const Divider(height: 1),
                            ],
                          ),
                        if (_cursor != null)
                          TextButton(
                            onPressed: _busy ? null : () => _load(true),
                            child: const Text('Load more'),
                          ),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      Text(
                        'Delivery preferences',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Required notices remain in your inbox. Push also needs permission on this device.',
                      ),
                      if (widget.enablePush != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: OutlinedButton(
                            onPressed: _busy
                                ? null
                                : () => _run(widget.enablePush!),
                            child: const Text('Enable device notifications'),
                          ),
                        ),
                      for (final p in _preferences)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.category.toLowerCase().replaceAll('_', ' '),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(p.explanation),
                              if (p.mandatory)
                                const Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    'Always enabled · In-app, email and registered push devices',
                                  ),
                                )
                              else
                                for (final channel in [
                                  'inApp',
                                  'email',
                                  'push',
                                ])
                                  SwitchListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(
                                      channel == 'inApp' ? 'In-app' : channel,
                                    ),
                                    value: channel == 'inApp'
                                        ? p.inApp
                                        : channel == 'email'
                                        ? p.email
                                        : p.push,
                                    onChanged: _busy
                                        ? null
                                        : (value) => _run(() async {
                                            await widget.repository.preference(
                                              p,
                                              channel,
                                              value,
                                            );
                                            final prefs = await widget
                                                .repository
                                                .preferences();
                                            if (mounted) {
                                              setState(
                                                () => _preferences = prefs,
                                              );
                                            }
                                          }),
                                  ),
                              const Divider(),
                            ],
                          ),
                        ),
                    ],
                  ),
          ),
        ],
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
