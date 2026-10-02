import 'dart:async';
import 'dart:convert';
import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/components/work_package_attachment.dart';
import '../projects/projects_repository.dart';

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../design_system/components/procurement_components.dart';
import '../../widgets/buyer_account_widgets.dart';

import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

import 'package:share_plus/share_plus.dart';

import '../../design_system/components/messaging_components.dart';

import '../../design_system/theme.dart';

import '../map_discovery/discovery_models.dart';

import '../map_discovery/discovery_repository.dart' show newIdempotencyKey;

import 'messaging_repository.dart';
import '../orders/orders_repository.dart';
import '../orders/order_details_screen.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({
    super.key,
    required this.repository,
    this.conversationId,
    this.orders,
    this.onOpenCart,
    this.onOpenNotifications,
  });

  final MessagingRepository repository;

  final String? conversationId;
  final OrdersRepository? orders;
  final VoidCallback? onOpenCart;
  final VoidCallback? onOpenNotifications;

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen>
    with WidgetsBindingObserver {
  final _text = TextEditingController();
  final _search = TextEditingController();

  api.ConversationDetail? _detail;

  api.ConversationPage? _inbox;

  Uint8List? _avatar;

  String? _error;

  String? _notice;

  String? _channel;

  String? _lastRead;

  String _sendKey = newIdempotencyKey();

  bool _loading = true;

  bool _busy = false;

  bool _refreshing = false;
  bool _reloadPending = false;
  bool _foreground = true;

  int _page = 1;

  Timer? _timer;

  void Function()? _stop;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    unawaited(_load());
    if (widget.conversationId == null) unawaited(_watchInbox());

    _timer = Timer.periodic(const Duration(seconds: 45), (_) {
      if (mounted &&
          _foreground &&
          ModalRoute.of(context)?.isCurrent != false) {
        unawaited(_load());
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _stop?.call();
    _text.dispose();
    _search.dispose();
    super.dispose();
  }

  Future<void> _watchInbox() async {
    final stop = await widget.repository.watchInbox(() => unawaited(_load()));
    if (!mounted || !_foreground) {
      stop();
      return;
    }
    _stop = stop;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    if (!_foreground) {
      _stop?.call();
      _stop = null;
      _channel = null;
    } else {
      unawaited(_load());
      if (widget.conversationId == null) unawaited(_watchInbox());
    }
  }

  String _message(Object error) => error is DiscoveryFailure
      ? error.message
      : 'Unable to load messages. Please retry.';

  Future<void> _load() async {
    if (!mounted || !_foreground) return;
    if (_refreshing) {
      _reloadPending = true;
      return;
    }

    _refreshing = true;

    try {
      final id = widget.conversationId;

      if (id == null) {
        final value = await widget.repository.inbox(page: _page);

        if (mounted) setState(() => _inbox = value);
      } else {
        final value = await widget.repository.conversation(id);

        if (!mounted) return;

        setState(() => _detail = value);

        final latest = value.messages.items.lastOrNull;

        if (latest != null &&
            _lastRead != latest.id &&
            value.conversation.unreadCount > 0) {
          _lastRead = latest.id;

          unawaited(
            widget.repository.read(id, latest.id).catchError((Object _) {
              _lastRead = null;
            }),
          );
        }

        final current = value.quotations.versions.firstOrNull;

        if (current != null &&
            current.actions.contains('view') &&
            !current.viewed) {
          await widget.repository.decide(
            id,
            'view',
            current,
            newIdempotencyKey(),
          );
        }

        if (_channel != value.conversation.channel) {
          _channel = value.conversation.channel;

          _stop?.call();

          final stop = await widget.repository.watch(
            _channel!,
            () => unawaited(_load()),
          );

          if (!mounted) {
            stop();
            return;
          }

          _stop = stop;

          final handler = value.conversation.handler;

          if (handler?.avatarPath != null) {
            try {
              final bytes = await widget.repository.avatar(
                id,
                int.parse(handler!.avatarPath!.split('/').last),
              );
              if (mounted) setState(() => _avatar = bytes);
            } catch (_) {
              if (mounted) setState(() => _avatar = null);
            }
          } else {
            setState(() => _avatar = null);
          }
        }
      }
      if (mounted) setState(() => _error = null);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = _message(e);
          if (e is DiscoveryFailure &&
              [
                DiscoveryFailureKind.forbidden,
                DiscoveryFailureKind.notFound,
                DiscoveryFailureKind.sessionExpired,
              ].contains(e.kind)) {
            _detail = null;
            _stop?.call();
          }
        });
      }
    } finally {
      _refreshing = false;
      if (mounted) setState(() => _loading = false);
      if (_reloadPending && mounted && _foreground) {
        _reloadPending = false;
        unawaited(_load());
      }
    }
  }

  Future<void> _mutate(
    Future<void> Function() action, {
    bool refresh = true,
  }) async {
    if (_busy) return;

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      await action();
      if (refresh) await _load();
    } catch (e) {
      if (mounted) setState(() => _error = _message(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _decide(String action, api.ChatQuotationVersion version) async {
    final reason = TextEditingController();
    final budgetOverride = TextEditingController();

    var acknowledged = false;

    final nrpc = version.content.nrpc;

    final terms = nrpc?['terms']?.value;

    final termsMap = terms is Map ? terms : const <String, Object?>{};

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, update) => AlertDialog(
          title: Text(
            action == 'accept'
                ? 'Review and accept quotation'
                : action == 'counter'
                ? 'Request changes'
                : 'Reject quotation',
          ),

          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Version ${version.version} · ${chatMoney(version.content.commercial.commercialTotalCentavos)}',
                  ),

                  if (action == 'accept') ...[
                    ...version.content.originalChanges.map(
                      (change) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(change.label),
                      ),
                    ),
                    if (_detail?.conversation.contextType.name ==
                        'PROJECT_BASED')
                      TextField(
                        controller: budgetOverride,
                        maxLength: 2000,
                        decoration: const InputDecoration(
                          labelText: 'Written budget override reason',
                          helperText:
                              'Required if either Project budget is exceeded',
                        ),
                      ),
                    const SizedBox(height: 12),
                    const Text(
                      'Acceptance reserves available stock and opens Order Details. Review the payment-channel fee before paying.',
                    ),

                    if (nrpc != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        'NRPC: ${chatMoney(version.content.commercial.nrpcCentavos)}\nReason: ${nrpc['reason']?.value ?? ''}',
                      ),
                      Text(
                        'Affected lines: ${nrpc['allocations']?.value ?? ''}',
                      ),
                      Text('${termsMap['content'] ?? ''}'),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        value: acknowledged,
                        onChanged: (value) =>
                            update(() => acknowledged = value ?? false),
                        title: const Text(
                          'I agree to the displayed NRPC amount, affected lines, reason and Terms.',
                        ),
                      ),
                    ],
                  ] else
                    TextField(
                      controller: reason,
                      maxLength: 2000,
                      minLines: 3,
                      maxLines: 6,
                      onChanged: (_) => update(() {}),
                      decoration: InputDecoration(
                        labelText: action == 'counter'
                            ? 'Requested changes'
                            : 'Reason (optional)',
                      ),
                    ),
                ],
              ),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed:
                  (action == 'accept' && nrpc != null && !acknowledged) ||
                      (action == 'counter' && reason.text.trim().length < 3)
                  ? null
                  : () => Navigator.pop(context, true),
              child: Text(
                action == 'accept'
                    ? 'Accept version ${version.version}'
                    : 'Confirm',
              ),
            ),
          ],
        ),
      ),
    );

    final explanation = reason.text.trim();
    final overrideReason = budgetOverride.text.trim();
    budgetOverride.dispose();

    reason.dispose();

    if (confirmed != true || !mounted) return;

    await _mutate(() async {
      final order = await widget.repository.decide(
        widget.conversationId!,
        action,
        version,
        newIdempotencyKey(),
        reason: explanation.isEmpty ? null : explanation,
        nrpcAcknowledged: acknowledged,
        termsId: termsMap['id'] as String?,
        budgetOverrideReason: overrideReason.isEmpty ? null : overrideReason,
      );

      if (mounted) {
        setState(
          () => _notice = order == null
              ? 'Your response was saved.'
              : 'Quotation accepted. Your order is now available in My Orders.',
        );
      }
    });
  }

  Future<void> _attach() => _mutate(() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: _detail?.conversation.purpose.name == 'FULFILLMENT'
          ? ['jpg', 'jpeg', 'png']
          : ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (file == null || !mounted) return;
    final bytes = await file.xFile.readAsBytes();
    if (!mounted) return;
    if (bytes.length > 10 * 1024 * 1024 || bytes.isEmpty) {
      setState(() => _error = 'Choose a JPG, PNG or PDF up to 10 MB.');
      return;
    }
    await widget.repository.upload(
      widget.conversationId!,
      bytes,
      file.name,
      newIdempotencyKey(),
    );
  });

  Future<void> _openFile(api.ChatAttachment file) => _mutate(() async {
    final bytes = await widget.repository.attachment(
      widget.conversationId!,
      file.id,
    );

    if (!mounted) return;

    if (file.mediaType.startsWith('image/')) {
      await showDialog<void>(
        context: context,
        builder: (context) => Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: InteractiveViewer(child: Image.memory(bytes))),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      );
    } else {
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile.fromData(bytes, mimeType: file.mediaType)],
          fileNameOverrides: [file.displayName],
        ),
      );
    }
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).colorScheme.surface,
    appBar: buyerAppBar(
      context,
      widget.conversationId == null ? 'Messages' : 'Conversation',
      toolbarHeight: _detail == null || widget.conversationId == null
          ? null
          : 64 + (MediaQuery.textScalerOf(context).scale(14) - 14) * 2,
      centerTitle: _detail == null || widget.conversationId == null,
      titleWidget: _detail == null || widget.conversationId == null
          ? null
          : ConversationHeader(
              conversation: _detail!.conversation,
              compact: true,
            ),
      actions: widget.conversationId == null ? null : _headerActions(),
    ),

    body: _loading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              if (_error != null)
                Flexible(
                  child: SingleChildScrollView(
                    child: Material(
                      color: Theme.of(context).colorScheme.errorContainer,
                      child: ListTile(
                        title: Text(_error!),
                        trailing: TextButton(
                          onPressed: () {
                            setState(() => _error = null);
                            unawaited(_load());
                          },
                          child: const Text('Retry'),
                        ),
                      ),
                    ),
                  ),
                ),

              if (_notice != null)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(_notice!),
                ),

              Expanded(
                child: widget.conversationId == null ? _inboxView() : _thread(),
              ),
            ],
          ),
  );

  List<Widget> _headerActions() => [
    if (widget.onOpenCart != null)
      RoundIconButton(
        icon: LucideIcons.shoppingCart,
        tooltip: 'Cart',
        onPressed: widget.onOpenCart,
      ),
    RoundIconButton(
      icon: LucideIcons.bell,
      tooltip: 'Notifications',
      onPressed:
          widget.onOpenNotifications ??
          () => Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (_) => const BuyerUnavailableScreen(
                title: 'Notifications',
                artwork: 'notifications',
              ),
            ),
          ),
    ),
  ];

  Widget _inboxView() {
    final query = _search.text.trim().toLowerCase();
    final items = (_inbox?.items ?? <api.ConversationView>[])
        .where(
          (c) => '${c.store.name} ${c.handler?.displayName ?? ''}'
              .toLowerCase()
              .contains(query),
        )
        .toList();
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 16),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 12, 16),
            child: Row(
              children: [
                Expanded(
                  child: PillSearchField(
                    controller: _search,
                    hintText: 'Search messages',
                    textStyle: const TextStyle(fontSize: 14),
                    onChanged: (_) => setState(() {}),
                    onSearch: () => FocusScope.of(context).unfocus(),
                    onClear: _search.text.isEmpty
                        ? null
                        : () => setState(_search.clear),
                  ),
                ),
                const SizedBox(width: 4),
                ..._headerActions(),
              ],
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              query.isEmpty ? 'All messages' : 'Search results',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
          if (_inbox?.hasMore == true || _page > 1)
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Text(
                'Search applies to this page.',
                style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
              ),
            ),
          const SizedBox(height: 8),
          if (items.isEmpty && _error == null)
            StateMessage(
              kind: StateKind.empty,
              artwork: 'assets/states/inbox.png',
              title: query.isEmpty
                  ? 'No conversations yet'
                  : 'No matching conversations',
              message: query.isEmpty
                  ? 'Message a Vendor from a product to ask questions or request a quotation.'
                  : 'Try a different store or handler name.',
            ),
          for (final c in items) ...[
            ConversationInboxTile(
              conversation: c,
              onTap: () async {
                await Navigator.of(context).push<void>(
                  MaterialPageRoute(
                    builder: (_) => MessagingScreen(
                      repository: widget.repository,
                      orders: widget.orders,
                      onOpenCart: widget.onOpenCart,
                      onOpenNotifications: widget.onOpenNotifications,
                      conversationId: c.id,
                    ),
                  ),
                );
                if (mounted) await _load();
              },
            ),
            const Padding(
              padding: EdgeInsets.only(left: 80, right: 20),
              child: Divider(height: 1),
            ),
          ],
          if (_page > 1 || _inbox?.hasMore == true)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _page == 1 || _refreshing
                      ? null
                      : () {
                          _page--;
                          unawaited(_load());
                        },
                  child: const Text('Previous'),
                ),
                Text(
                  'Page $_page',
                  style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
                ),
                TextButton(
                  onPressed: _inbox?.hasMore != true || _refreshing
                      ? null
                      : () {
                          _page++;
                          unawaited(_load());
                        },
                  child: const Text('Next'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _thread() {
    final d = _detail;

    if (d == null) {
      return const Center(child: Text('This conversation is unavailable.'));
    }

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              if (d.conversation.contextType.name == 'PROJECT_BASED')
                WorkPackageAttachment(
                  original: projectObject(
                    projectObject(
                      jsonDecode(
                        jsonEncode(
                          d.conversation.lockedReference
                              .map((k, v) => MapEntry(k, v?.value))
                              .toMap(),
                        ),
                      ),
                    )['work_package'],
                  ),
                  proposed: d.quotations.versions.isEmpty
                      ? projectObject(
                          jsonDecode(
                            jsonEncode(
                              d
                                  .conversation
                                  .lockedReference['working_duplicate']
                                  ?.value,
                            ),
                          ),
                        )
                      : projectObject(
                          jsonDecode(
                            jsonEncode(
                              api.standardSerializers.serializeWith(
                                api.ChatQuotationContent.serializer,
                                d.quotations.versions.first.content,
                              ),
                            ),
                          ),
                        ),
                ),
              if (d.conversation.handler != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: BuyerTheme.canvas,
                        backgroundImage: _avatar == null
                            ? null
                            : MemoryImage(_avatar!),
                        child: _avatar == null
                            ? const Icon(
                                Icons.person_outline,
                                size: 18,
                                color: BuyerTheme.muted,
                              )
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Handled by ${d.conversation.handler!.displayName} · ${chatRole(d.conversation.handler!.role)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: BuyerTheme.muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (d.messages.items.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 48, horizontal: 24),
                  child: Text(
                    'Start the conversation. Ask about materials, specifications or a quotation.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: BuyerTheme.muted),
                  ),
                ),
              if (d.quotations.quotation?.acceptedOrderId != null &&
                  widget.orders != null)
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.receipt_long_outlined),
                  label: const Text('Open Order Details'),
                  onPressed: () => Navigator.of(context).push<void>(
                    MaterialPageRoute(
                      builder: (_) => OrderDetailsScreen(
                        orderId: d.quotations.quotation!.acceptedOrderId!,
                        repository: widget.orders!,
                      ),
                    ),
                  ),
                ),

              if (d.messages.hasMore)
                TextButton(
                  onPressed: _busy
                      ? null
                      : () => _mutate(() async {
                          final older = await widget.repository.conversation(
                            widget.conversationId!,
                            before: d.messages.nextBefore,
                          );
                          if (mounted) {
                            setState(
                              () => _detail = d.rebuild(
                                (b) => b.messages.replace(
                                  older.messages.rebuild(
                                    (m) => m.items.addAll(d.messages.items),
                                  ),
                                ),
                              ),
                            );
                          }
                        }, refresh: false),
                  child: const Text('Earlier messages'),
                ),

              for (var index = 0; index < d.messages.items.length; index++) ...[
                if (index == 0 ||
                    chatDate(d.messages.items[index - 1].sentAt) !=
                        chatDate(d.messages.items[index].sentAt))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      chatDate(d.messages.items[index].sentAt),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: BuyerTheme.muted,
                      ),
                    ),
                  ),
                ConversationMessageBubble(
                  message: d.messages.items[index],
                  busy: _busy,
                  onOpenFile: (file) => unawaited(_openFile(file)),
                ),
              ],

              for (final version in d.quotations.versions)
                QuotationVersionCard(
                  version: version,
                  busy: _busy,
                  onAction: (action) => unawaited(_decide(action, version)),
                ),

              if (d.quotations.hasMore)
                TextButton(
                  onPressed: _busy
                      ? null
                      : () => _mutate(() async {
                          final older = await widget.repository.conversation(
                            widget.conversationId!,
                            page: (d.quotations.page ?? 1) + 1,
                          );
                          if (mounted) {
                            setState(
                              () => _detail = d.rebuild(
                                (b) => b.quotations.replace(
                                  older.quotations.rebuild(
                                    (q) => q.versions.replace([
                                      ...d.quotations.versions,
                                      ...older.quotations.versions,
                                    ]),
                                  ),
                                ),
                              ),
                            );
                          }
                        }, refresh: false),
                  child: const Text('Older quotations'),
                ),

              const SizedBox(height: 16),
            ],
          ),
        ),

        SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: BuyerTheme.border)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  tooltip: d.conversation.purpose.name == 'FULFILLMENT'
                      ? 'Attach JPG or PNG, up to 10 MB'
                      : 'Attach JPG, PNG or PDF, up to 10 MB',
                  onPressed: _busy ? null : () => unawaited(_attach()),
                  icon: const Icon(Icons.add, color: BuyerTheme.action),
                ),
                Expanded(
                  child: TextField(
                    controller: _text,
                    readOnly: _busy,
                    minLines: 1,
                    maxLines: 5,
                    maxLength: 5000,
                    onChanged: (_) {
                      _sendKey = newIdempotencyKey();
                      setState(() {});
                    },
                    decoration: const InputDecoration(
                      hintText: 'Write a message…',
                      counterText: '',
                      fillColor: BuyerTheme.canvas,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  tooltip: 'Send message',
                  onPressed: _busy || _text.text.trim().isEmpty
                      ? null
                      : () => unawaited(
                          _mutate(() async {
                            await widget.repository.send(
                              widget.conversationId!,
                              _text.text.trim(),
                              _sendKey,
                            );
                            _text.clear();
                            _sendKey = newIdempotencyKey();
                          }),
                        ),
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
