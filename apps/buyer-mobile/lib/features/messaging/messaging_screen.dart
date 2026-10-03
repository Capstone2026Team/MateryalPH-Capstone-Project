import 'dart:async';
import 'dart:convert';
import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/components/work_package_attachment.dart';
import '../projects/projects_repository.dart';

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart' show CustomSemanticsAction;
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
import 'chat_drafts.dart';
import 'chat_product_picker.dart';
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
    this.initialProductId,
    this.onOpenProduct,
    this.onSetDelivery,
  });

  final MessagingRepository repository;

  final String? conversationId;
  final OrdersRepository? orders;
  final VoidCallback? onOpenCart;
  final VoidCallback? onOpenNotifications;
  final String? initialProductId;
  final ValueChanged<String>? onOpenProduct;
  final Future<void> Function(String, int)? onSetDelivery;

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

/// Swipe left to archive (or restore) a conversation. The same action is
/// exposed to assistive technology because a swipe is not discoverable.
class _ArchiveSwipe extends StatelessWidget {
  const _ArchiveSwipe({
    required this.id,
    required this.archived,
    required this.confirm,
    required this.onDismissed,
    required this.child,
  });

  final String id;
  final bool archived;
  final Future<bool> Function() confirm;
  final VoidCallback onDismissed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final label = archived ? 'Unarchive' : 'Archive';
    return Semantics(
      customSemanticsActions: {
        CustomSemanticsAction(label: '$label conversation'): () async {
          if (await confirm()) onDismissed();
        },
      },
      child: Dismissible(
        key: ValueKey('archive-$id'),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) => confirm(),
        onDismissed: (_) => onDismissed(),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          color: BuyerTheme.action,
          child: ExcludeSemantics(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  archived ? Icons.unarchive_outlined : Icons.archive_outlined,
                  color: Colors.white,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        child: child,
      ),
    );
  }
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
  api.ChatProduct? _product;
  bool _draftLoaded = false;
  bool _typing = false;
  int _typingAt = 0;
  Timer? _typingExpiry;
  Timer? _typingDebounce;
  Timer? _draftTimer;
  DateTime? _lastTypingSent;
  final _pending =
      <String, ({String body, api.ChatProduct? product, bool failed})>{};

  int _page = 1;
  bool _showArchived = false;
  bool _actionsOpen = false;

  /// Whether the realtime subscription is established. While it is not (for
  /// example Reverb is unreachable from this device), REST polling keeps the
  /// thread current within a few seconds instead of waiting for a manual refresh.
  bool _live = false;
  DateTime _lastLoaded = DateTime.now();
  final _scroll = ScrollController();

  Timer? _timer;

  void Function()? _stop;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    unawaited(_load());
    if (widget.conversationId == null) unawaited(_watchInbox());

    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted ||
          !_foreground ||
          ModalRoute.of(context)?.isCurrent == false) {
        return;
      }
      final quiet = DateTime.now().difference(_lastLoaded);
      if (_live && quiet < const Duration(seconds: 45)) return;
      unawaited(_load());
    });
  }

  void _onLive(bool live) {
    if (!mounted) return;
    _live = live;
    if (!live) unawaited(_load());
  }

  /// Keeps the newest message in view. [force] is used for the first load and
  /// the Buyer's own sends; otherwise only a reader already at the bottom follows.
  void _scrollToEnd({bool force = false, bool animate = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scroll.hasClients) return;
      final position = _scroll.position;
      if (!force && position.maxScrollExtent - position.pixels > 160) return;
      if (animate) {
        unawaited(
          _scroll.animateTo(
            position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          ),
        );
      } else {
        _scroll.jumpTo(position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scroll.dispose();
    _timer?.cancel();
    _stop?.call();
    _typingExpiry?.cancel();
    _typingDebounce?.cancel();
    _draftTimer?.cancel();
    _saveDraft();
    _text.dispose();
    _search.dispose();
    super.dispose();
  }

  Future<void> _watchInbox() async {
    final stop = await widget.repository.watchInbox(
      () => unawaited(_load()),
      onLive: _onLive,
    );
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
      _live = false;
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
        final value = await widget.repository.inbox(
          page: _page,
          archived: _showArchived,
        );

        if (mounted) setState(() => _inbox = value);
      } else {
        var value = await widget.repository.conversation(id);
        final previous = _detail?.messages;
        final anchor = previous?.items.lastOrNull?.id;
        if (anchor != null && value.messages.items.isNotEmpty) {
          final incoming = value.messages.items.toList();
          var cursor = value.messages;
          while (!incoming.any((message) => message.id == anchor) &&
              cursor.hasMore &&
              cursor.nextBefore != null &&
              cursor.items.isNotEmpty &&
              cursor.items.first.id.compareTo(anchor) > 0) {
            final older = await widget.repository.conversation(
              id,
              before: cursor.nextBefore,
            );
            if (!mounted) return;
            cursor = older.messages;
            incoming.insertAll(0, cursor.items);
          }
          final merged = {
            for (final message in previous!.items) message.id: message,
            for (final message in incoming) message.id: message,
          }.values.toList()..sort((a, b) => a.id.compareTo(b.id));
          value = value.rebuild(
            (b) => b.messages.update(
              (m) => m
                ..items.replace(merged)
                ..hasMore = previous.hasMore
                ..nextBefore = previous.nextBefore,
            ),
          );
        }

        if (!mounted) return;

        final newTail = value.messages.items.lastOrNull?.id;
        final arrived =
            previous != null &&
            newTail != previous.items.lastOrNull?.id &&
            value.messages.items.lastOrNull?.mine == false;
        setState(() {
          _detail = value;
          // The store's message replaces its typing indicator immediately.
          if (arrived) _typing = false;
        });
        if (previous == null) {
          _scrollToEnd(force: true, animate: false);
        } else if (newTail != previous.items.lastOrNull?.id) {
          _scrollToEnd();
        }
        if (!_draftLoaded) {
          _draftLoaded = true;
          try {
            final draft = await ChatDrafts.read(id);
            if (mounted && draft != null) {
              _text.text = draft['text'] as String? ?? '';
              _product = api.standardSerializers.deserializeWith(
                api.ChatProduct.serializer,
                draft['product'],
              );
            }
          } catch (_) {
            /* Storage can be unavailable; keep the active draft in memory. */
          }
          if (widget.initialProductId != null &&
              widget.initialProductId != value.conversation.latestProductId &&
              _product == null) {
            try {
              final products = await widget.repository.products(
                id,
                productId: widget.initialProductId,
              );
              if (mounted) {
                setState(() => _product = products.items.firstOrNull);
              }
              _saveDraft();
            } catch (_) {
              if (mounted) {
                setState(
                  () => _notice =
                      'This product is no longer available to attach.',
                );
              }
            }
          }
        }
        if (!mounted) return;
        setState(
          () => _pending.removeWhere(
            (key, _) =>
                value.messages.items.any((m) => m.clientMessageId == key),
          ),
        );

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
          _live = false;

          final stop = await widget.repository.watch(
            _channel!,
            () => unawaited(_load()),
            onTyping: (typing, at) {
              if (!mounted || at <= _typingAt) return;
              _typingAt = at;
              _typingExpiry?.cancel();
              setState(() => _typing = typing);
              if (typing) _scrollToEnd();
              _typingExpiry = Timer(const Duration(seconds: 3), () {
                if (mounted) setState(() => _typing = false);
              });
            },
            onLive: _onLive,
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
      _lastLoaded = DateTime.now();
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

  void _saveDraft() {
    final id = widget.conversationId;
    if (id != null && _draftLoaded) {
      unawaited(
        ChatDrafts.save(id, _text.text, _product).catchError((Object _) {}),
      );
    }
  }

  void _edited() {
    _draftTimer?.cancel();
    _draftTimer = Timer(const Duration(milliseconds: 300), _saveDraft);
    final now = DateTime.now();
    if (_lastTypingSent == null ||
        now.difference(_lastTypingSent!).inMilliseconds > 1200) {
      _lastTypingSent = now;
      _typingDebounce?.cancel();
      _typingDebounce = Timer(
        const Duration(milliseconds: 200),
        () => unawaited(
          widget.repository
              .typing(widget.conversationId!, _text.text.trim().isNotEmpty)
              .catchError((Object _) {}),
        ),
      );
    }
    setState(() {});
  }

  Future<void> _pickProduct() async {
    final product = await Navigator.of(context).push<api.ChatProduct>(
      MaterialPageRoute(
        builder: (_) => ChatProductPicker(
          repository: widget.repository,
          conversationId: widget.conversationId!,
        ),
      ),
    );
    if (mounted && product != null) {
      setState(() => _product = product);
      _saveDraft();
    }
  }

  Future<void> _send([String? retryKey]) async {
    final key = retryKey ?? _sendKey;
    final message = retryKey == null
        ? (body: _text.text.trim(), product: _product, failed: false)
        : _pending[key];
    if (message == null || (message.body.isEmpty && message.product == null)) {
      return;
    }
    setState(() {
      _pending[key] = (
        body: message.body,
        product: message.product,
        failed: false,
      );
      if (retryKey == null) {
        _text.clear();
        _product = null;
        _sendKey = newIdempotencyKey();
      }
    });
    _scrollToEnd(force: true);
    _saveDraft();
    _typingDebounce?.cancel();
    unawaited(
      widget.repository
          .typing(widget.conversationId!, false)
          .catchError((Object _) {}),
    );
    try {
      await widget.repository.send(
        widget.conversationId!,
        message.body,
        key,
        productId: message.product?.productId,
      );
      await _load();
    } catch (_) {
      if (mounted && _pending.containsKey(key)) {
        setState(
          () => _pending[key] = (
            body: message.body,
            product: message.product,
            failed: true,
          ),
        );
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
                            setState(() {
                              _error = null;
                              _loading = _inbox == null && _detail == null;
                            });
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

  Future<void> _toggleArchived() async {
    setState(() {
      _showArchived = !_showArchived;
      _page = 1;
      _inbox = null;
      _loading = true;
      _search.clear();
    });
    await _load();
  }

  /// Archive hides the conversation from this Buyer's inbox only; nothing is deleted.
  Future<bool> _setArchived(api.ConversationView c, bool archive) async {
    try {
      if (archive) {
        await widget.repository.archive(c.id);
      } else {
        await widget.repository.restore(c.id);
      }
      return true;
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              archive
                  ? 'Unable to archive this conversation. Please retry.'
                  : 'Unable to restore this conversation. Please retry.',
            ),
          ),
        );
      }
      return false;
    }
  }

  void _removeFromInbox(api.ConversationView c, bool archived) {
    if (!mounted) return;
    setState(
      () => _inbox = _inbox?.rebuild(
        (b) => b.items.removeWhere((item) => item.id == c.id),
      ),
    );
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            archived ? 'Conversation archived' : 'Conversation moved back',
          ),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              await _setArchived(c, !archived);
              if (mounted) unawaited(_load());
            },
          ),
        ),
      );
  }

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
            padding: const EdgeInsets.only(left: 20, right: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    query.isNotEmpty
                        ? 'Search results'
                        : _showArchived
                        ? 'Archived messages'
                        : 'All messages',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: _refreshing ? null : _toggleArchived,
                  icon: Icon(
                    _showArchived
                        ? Icons.chat_bubble_outline
                        : Icons.archive_outlined,
                    size: 18,
                  ),
                  label: Text(_showArchived ? 'Back to messages' : 'Archived'),
                ),
              ],
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
              title: query.isNotEmpty
                  ? 'No matching conversations'
                  : _showArchived
                  ? 'No archived messages'
                  : 'No messages yet',
              message: query.isNotEmpty
                  ? 'Try a different store or handler name.'
                  : _showArchived
                  ? 'Conversations you archive appear here. New activity brings them back to your inbox.'
                  : 'Message a store or a product to ask questions or request a quotation.',
            ),
          for (final c in items) ...[
            _ArchiveSwipe(
              id: c.id,
              archived: _showArchived,
              confirm: () => _setArchived(c, !_showArchived),
              onDismissed: () => _removeFromInbox(c, !_showArchived),
              child: ConversationInboxTile(
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
                        onOpenProduct: widget.onOpenProduct,
                        onSetDelivery: widget.onSetDelivery,
                      ),
                    ),
                  );
                  if (mounted) await _load();
                },
              ),
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
            controller: _scroll,
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
              for (final accepted in d.quotations.versions.where(
                (version) =>
                    version.acceptedOrderId != null && widget.orders != null,
              ))
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.receipt_long_outlined),
                  label: const Text('Open Order Details'),
                  onPressed: () => Navigator.of(context).push<void>(
                    MaterialPageRoute(
                      builder: (_) => OrderDetailsScreen(
                        orderId: accepted.acceptedOrderId!,
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
                  onOpenProduct: widget.onOpenProduct,
                ),
              ],

              for (final item in _pending.entries)
                Align(
                  alignment: Alignment.centerRight,
                  child: FractionallySizedBox(
                    widthFactor: .86,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: const BoxDecoration(
                            color: BuyerTheme.brandSoft,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(4),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (item.value.body.isNotEmpty)
                                Text(
                                  item.value.body,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                ),
                              if (item.value.product != null)
                                ChatProductCard(product: item.value.product!),
                            ],
                          ),
                        ),
                        if (item.value.failed)
                          TextButton(
                            onPressed: () => _send(item.key),
                            child: const Text('Failed to send · Retry'),
                          )
                        else
                          const Padding(
                            padding: EdgeInsets.fromLTRB(4, 4, 4, 8),
                            child: Text(
                              'Sending…',
                              style: TextStyle(
                                fontSize: 11,
                                color: BuyerTheme.muted,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

              if (_typing)
                TypingIndicator(name: d.conversation.handler?.displayName),

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

        if (d.conversation.canonicalConversationId != null)
          TextButton(
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => MessagingScreen(
                  repository: widget.repository,
                  conversationId: d.conversation.canonicalConversationId,
                  orders: widget.orders,
                  onOpenProduct: widget.onOpenProduct,
                  onSetDelivery: widget.onSetDelivery,
                ),
              ),
            ),
            child: const Text('Open current conversation'),
          ),
        if (_product != null)
          Row(
            children: [
              Expanded(child: ChatProductCard(product: _product!)),
              IconButton(
                tooltip: 'Remove product',
                onPressed: () {
                  setState(() => _product = null);
                  _saveDraft();
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        if (_actionsOpen &&
            d.conversation.canonicalConversationId == null &&
            !d.conversation.readOnly)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                spacing: 4,
                children: [
                  TextButton.icon(
                    onPressed: _busy
                        ? null
                        : () {
                            setState(() => _actionsOpen = false);
                            unawaited(_attach());
                          },
                    icon: const Icon(Icons.attach_file),
                    label: Text(
                      d.conversation.purpose.name == 'FULFILLMENT'
                          ? 'Attach photo (JPG, PNG)'
                          : 'Attach file (JPG, PNG, PDF)',
                    ),
                  ),
                  if (d.conversation.purpose.name == 'SALES')
                    TextButton.icon(
                      onPressed: () {
                        setState(() => _actionsOpen = false);
                        unawaited(_pickProduct());
                      },
                      icon: const Icon(Icons.inventory_2_outlined),
                      label: const Text('Attach product'),
                    ),
                  if (d.conversation.purpose.name == 'SALES' &&
                      d.conversation.contextType.name == 'ITEM_BASED' &&
                      widget.onSetDelivery != null)
                    TextButton.icon(
                      onPressed: _busy
                          ? null
                          : () {
                              setState(() => _actionsOpen = false);
                              unawaited(
                                _mutate(
                                  () => widget.onSetDelivery!(
                                    d.conversation.id,
                                    d.conversation.lockVersion,
                                  ),
                                ),
                              );
                            },
                      icon: const Icon(Icons.local_shipping_outlined),
                      label: const Text('Delivery details'),
                    ),
                ],
              ),
            ),
          ),
        if (d.conversation.canonicalConversationId == null &&
            d.conversation.readOnly)
          SafeArea(
            top: false,
            child: Semantics(
              container: true,
              liveRegion: true,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: BuyerTheme.canvas,
                  border: Border(top: BorderSide(color: BuyerTheme.border)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock_outline, color: BuyerTheme.muted),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(switch (d.conversation.readOnlyReason) {
                        'ORDER_COMPLETED' =>
                          'This order is completed. The conversation history stays available, but new messages are closed.',
                        'ORDER_CANCELLED' =>
                          'This order was cancelled. The conversation history stays available, but new messages are closed.',
                        _ =>
                          'New messages are closed for this conversation. The history stays available.',
                      }, style: const TextStyle(color: BuyerTheme.muted)),
                    ),
                  ],
                ),
              ),
            ),
          )
        else if (d.conversation.canonicalConversationId == null)
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
                    tooltip: _actionsOpen ? 'Hide actions' : 'More actions',
                    onPressed: () =>
                        setState(() => _actionsOpen = !_actionsOpen),
                    icon: Icon(
                      _actionsOpen ? Icons.close : Icons.add,
                      color: BuyerTheme.action,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _text,
                      readOnly: _busy,
                      minLines: 1,
                      maxLines: 5,
                      maxLength: 5000,
                      onChanged: (_) => _edited(),
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
                    onPressed:
                        _busy || (_text.text.trim().isEmpty && _product == null)
                        ? null
                        : () => unawaited(_send()),
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
