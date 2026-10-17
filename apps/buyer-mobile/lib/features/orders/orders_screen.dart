import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/components/buyer_overlays.dart';
import '../../design_system/components/count_badge.dart';
import '../../design_system/components/order_components.dart';
import '../../design_system/components/procurement_components.dart';
import '../../design_system/generated/color_tokens.dart';
import '../../design_system/theme.dart';
import '../disputes/dispute_models.dart' show DisputeDetailView;
import '../disputes/dispute_screens.dart';
import '../item_procurement/procurement_models.dart'
    show PaymentMethodView, formatPeso;
import '../map_discovery/discovery_models.dart';
import '../map_discovery/discovery_repository.dart' show newIdempotencyKey;
import '../trust/order_reviews_screen.dart';
import '../notifications/notification_scope.dart';
import '../notifications/navigation_refresh_binding.dart';
import 'order_details_screen.dart';
import 'order_fulfillment_sections.dart';
import 'order_models.dart';
import 'order_payment_screen.dart';
import 'orders_repository.dart';

enum BuyerOrdersView { orders, cancellationsAndRefunds, reviews }

/// My Orders and the Profile purchase histories. My Orders has Item and Project tabs, the status
/// chips (Confirmation, Processing, To ship, To receive, Completed, Cancelled, Disputed; open
/// ones show their order count for the selected tab) and one card per
/// order with its reference, store, dates, item count, payment and total. Every card opens the
/// order's Fulfillment Messages thread, which is separate from inquiry conversations, and offers
/// only the actions the server listed for that order.
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({
    super.key,
    required this.repository,
    this.initialGroup,
    this.view = BuyerOrdersView.orders,
    this.paymentLauncher = launchPaymentPage,
    this.openConversation,
    this.onOpenCart,
    this.problemPhotoPicker = pickProblemPhoto,
    this.now,
  });

  final OrdersRepository repository;
  final String? initialGroup;
  final BuyerOrdersView view;
  final PaymentLauncher paymentLauncher;

  /// Opens a conversation by id; null disables the card message buttons.
  final OpenOrderConversation? openConversation;

  /// Opens the cart after Buy Again; null leaves the Buyer here with a confirmation.
  final VoidCallback? onOpenCart;
  final ProblemPhotoPicker problemPhotoPicker;
  final DateTime Function()? now;

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  static const _types = [('ITEM_BASED', 'Item'), ('PROJECT_BASED', 'Project')];
  static const _groups = [
    ('CONFIRMATION', 'Confirmation'),
    ('PROCESSING', 'Processing'),
    ('TO_SHIP', 'To ship'),
    ('TO_RECEIVE', 'To receive'),
    ('COMPLETED', 'Completed'),
    ('CANCELLED', 'Cancelled'),
    ('DISPUTED', 'Disputed'),
  ];

  /// Chips whose orders are still open carry a count badge; Completed and Cancelled are history.
  static const _activeGroups = {
    'CONFIRMATION',
    'PROCESSING',
    'TO_SHIP',
    'TO_RECEIVE',
    'DISPUTED',
  };

  late String _group = switch (widget.view) {
    BuyerOrdersView.reviews => 'COMPLETED',
    BuyerOrdersView.cancellationsAndRefunds => 'CANCELLED_REFUNDED',
    BuyerOrdersView.orders => widget.initialGroup ?? _groups.first.$1,
  };
  String _type = 'ITEM_BASED';

  /// Order counts per chip for the selected tab, from the latest list response.
  Map<String, int> _counts = const {};

  bool get _hub => widget.view == BuyerOrdersView.orders;

  String get _title => switch (widget.view) {
    BuyerOrdersView.orders => 'My orders',
    BuyerOrdersView.cancellationsAndRefunds => 'Cancellations & Refunds',
    BuyerOrdersView.reviews => 'My Reviews',
  };

  final List<OrderSummaryView> _items = [];
  bool _loading = true;
  bool _hasMore = false;
  int _page = 1;
  DiscoveryFailure? _failure;
  int _sequence = 0;
  String? _loadedScope;
  String? _busyOrderId;
  bool _started = false;
  bool _refreshPending = false;
  late final _navigation = NavigationRefreshBinding(
    _refreshForNavigation,
    _clearPrivateOrders,
  );

  /// Idempotency keys of card actions that failed offline, reused when the same action is retried.
  final Map<String, String> _retryKeys = {};

  String get _scope => '$_type:$_group';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final changed = _navigation.bind(NotificationScope.of(context)?.navigation);
    if (!_started || changed) {
      if (_started) _clearPrivateOrders();
      _started = true;
      unawaited(_load());
    }
  }

  @override
  void dispose() {
    _navigation.dispose();
    super.dispose();
  }

  void _clearPrivateOrders() {
    if (!mounted) return;
    setState(() {
      _sequence++;
      _items.clear();
      _counts = const {};
      _retryKeys.clear();
      _loadedScope = null;
      _busyOrderId = null;
      _refreshPending = false;
      _page = 1;
      _hasMore = false;
      _loading = true;
    });
  }

  Future<void> _refreshForNavigation() async {
    if (_busyOrderId != null || _loading) {
      _refreshPending = true;
      return;
    }
    _refreshPending = false;
    await _load(background: true);
  }

  Future<void> _load({bool more = false, bool background = false}) async {
    final sequence = ++_sequence;
    final stamp = _navigation.stamp;
    final scope = _scope;
    final page = more ? _page + 1 : 1;
    setState(() {
      if (!background) {
        _loading = true;
        _failure = null;
      }
      if (_loadedScope != _scope) _items.clear();
    });
    try {
      // The Profile histories cover both Item and Project orders.
      final lastPage = background ? _page : page;
      final pages = <OrderListPage>[];
      for (var current = page; current <= lastPage; current++) {
        pages.add(
          await widget.repository.orders(
            group: _group,
            procurementType: _hub ? _type : null,
            page: current,
          ),
        );
        if (!mounted ||
            sequence != _sequence ||
            !_navigation.isCurrent(stamp) ||
            scope != _scope) {
          return;
        }
        if (!pages.last.hasMore) break;
      }
      final result = pages.last;
      setState(() {
        _failure = null;
        if (!more) _items.clear();
        final refreshed = {
          for (final row in pages.expand((value) => value.items)) row.id: row,
        };
        _items.addAll(refreshed.values);
        _counts = result.counts;
        _loadedScope = _scope;
        _hasMore = result.hasMore;
        _page = result.page;
      });
    } on DiscoveryFailure catch (error) {
      if (mounted && sequence == _sequence && _navigation.isCurrent(stamp)) {
        final denied =
            error.kind == DiscoveryFailureKind.sessionExpired ||
            error.kind == DiscoveryFailureKind.forbidden;
        setState(() {
          if (!background || denied) _failure = error;
          if (denied) {
            _items.clear();
            _counts = const {};
          }
        });
      }
    } finally {
      if (mounted && sequence == _sequence) {
        setState(() => _loading = false);
        if (_refreshPending && _busyOrderId == null && _navigation.active) {
          _refreshPending = false;
          _navigation.invalidate();
        }
      }
    }
  }

  void _select({String? type, String? group}) {
    if ((type ?? _type) == _type && (group ?? _group) == _group) return;
    setState(() {
      // Counts belong to one tab; never show the other tab's numbers while it loads.
      if ((type ?? _type) != _type) _counts = const {};
      _type = type ?? _type;
      _group = group ?? _group;
    });
    _load();
  }

  void _notify(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Runs one card action. Only one runs at a time; an offline failure keeps the action's key so a
  /// retry can never be applied twice, and any other result clears it.
  Future<T?> _run<T>(
    OrderSummaryView order,
    String action,
    Future<T> Function(String key) call,
  ) async {
    if (_busyOrderId != null) return null;
    final scope = '$action:${order.id}';
    final key = _retryKeys[scope] ??= newIdempotencyKey();
    final stamp = _navigation.stamp;
    setState(() {
      _sequence++;
      if (_loading) _refreshPending = true;
      _loading = false;
      _busyOrderId = order.id;
    });
    try {
      final result = await call(key);
      if (!mounted || !_navigation.isCurrent(stamp)) return null;
      _retryKeys.remove(scope);
      return result;
    } on DiscoveryFailure catch (error) {
      if (!mounted || !_navigation.isCurrent(stamp)) return null;
      if (error.kind != DiscoveryFailureKind.offline) _retryKeys.remove(scope);
      _notify(error.message);
      return null;
    } finally {
      if (mounted && _navigation.isSameScope(stamp)) {
        setState(() => _busyOrderId = null);
        if (_refreshPending) {
          _refreshPending = false;
          _navigation.invalidate();
        }
      }
    }
  }

  Future<void> _push(Widget screen) async {
    await Navigator.of(
      context,
    ).push<void>(MaterialPageRoute(builder: (_) => screen));
    if (mounted) await _load();
  }

  Future<void> _open(OrderSummaryView order) => _push(
    widget.view == BuyerOrdersView.reviews
        ? OrderReviewsScreen(
            orderId: order.id,
            repository: widget.repository.reviews,
          )
        : OrderDetailsScreen(
            orderId: order.id,
            repository: widget.repository,
            paymentLauncher: widget.paymentLauncher,
            openConversation: widget.openConversation,
            problemPhotoPicker: widget.problemPhotoPicker,
            now: widget.now,
          ),
  );

  /// Pay now from the list: the payment page resumes a checkout that is already open instead of
  /// starting a second one, so the same order and amount are never charged twice.
  Future<void> _pay(OrderSummaryView order) => _push(
    OrderPaymentScreen(
      orderId: order.id,
      repository: widget.repository,
      launcher: widget.paymentLauncher,
    ),
  );

  /// Opens the order's Fulfillment Messages, starting it for an older open order that has none.
  Future<void> _openThread(OrderSummaryView order) async {
    final open = widget.openConversation;
    if (open == null) return;
    final id =
        order.fulfillmentConversation?.id ??
        (await _run(
          order,
          'openThread',
          (key) => widget.repository.openFulfillmentConversation(
            order.id,
            idempotencyKey: key,
          ),
        ))?.id;
    if (id == null || !mounted) return;
    await open(context, id);
    if (mounted) await _load();
  }

  Future<void> _confirmReceipt(OrderSummaryView order) async {
    if (!await confirmReceiptPrompt(
          context,
          pickup: order.fulfillmentMethod == 'PICKUP',
        ) ||
        !mounted) {
      return;
    }
    final updated = await _run(
      order,
      'confirmReceipt',
      (key) => widget.repository.confirmReceipt(order.id, idempotencyKey: key),
    );
    if (updated == null || !mounted) return;
    _notify('Receipt confirmed. Your order is completed.');
    if (updated.state('ORDER') == 'COMPLETED') {
      await _push(
        OrderReviewsScreen(
          repository: widget.repository.reviews,
          orderId: order.id,
          orderLines: updated.lines,
        ),
      );
    } else {
      await _load();
    }
  }

  Future<void> _reportProblem(OrderSummaryView order) async {
    final input = await showProblemSheet(
      context,
      picker: widget.problemPhotoPicker,
    );
    if (input == null || !mounted) return;
    final updated = await _run(
      order,
      'reportProblem',
      (key) => widget.repository.reportProblem(
        order.id,
        category: input.category,
        description: input.description,
        photo: input.photo,
        idempotencyKey: key,
      ),
    );
    if (updated == null || !mounted) return;
    _notify(
      'Problem reported. The Vendor was notified and automatic confirmation is paused.',
    );
    await _load();
  }

  Future<void> _fileDispute(OrderSummaryView order) async {
    final created = await Navigator.of(context).push<DisputeDetailView>(
      MaterialPageRoute(
        builder: (_) => FileDisputeScreen(
          orderId: order.id,
          repository: widget.repository.disputes,
        ),
      ),
    );
    if (!mounted) return;
    if (created == null) {
      await _load();
      return;
    }
    _notify(
      'Case ${created.reference} filed. Filing does not refund automatically.',
    );
    await _viewCase(created.id);
  }

  Future<void> _viewCase(String caseId) => _push(
    DisputeDetailScreen(
      caseId: caseId,
      repository: widget.repository.disputes,
      now: widget.now,
    ),
  );

  Future<void> _buyAgain(OrderSummaryView order) async {
    final result = await _run(
      order,
      'buyAgain',
      (key) => widget.repository.buyAgain(order.id, idempotencyKey: key),
    );
    if (result == null || !mounted) return;
    if (result.skipped.isNotEmpty) {
      await showDialog<void>(
        context: context,
        builder: (context) => BuyerDialog(
          title: Text(
            result.added.isEmpty
                ? 'Nothing was added to your cart'
                : 'Some items were not added',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final line in result.skipped)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text('${line.displayName}: ${line.message}'),
                ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    if (!mounted || result.added.isEmpty) return;
    final count = result.added.length;
    _notify(
      '$count ${count == 1 ? 'item' : 'items'} added to your cart at today’s prices.',
    );
    widget.onOpenCart?.call();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: BuyerTheme.canvas,
    appBar: buyerAppBar(
      context,
      _title,
      centerTitle: true,
      titleWidget: widget.view == BuyerOrdersView.cancellationsAndRefunds
          ? Text(
              _title,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            )
          : null,
      toolbarHeight: widget.view == BuyerOrdersView.cancellationsAndRefunds
          ? 12 + MediaQuery.textScalerOf(context).scale(18) * 2
          : null,
      actions: !_hub
          ? const []
          : [
              IconButton(
                tooltip: 'Disputes',
                icon: const Icon(LucideIcons.scale),
                onPressed: () => Navigator.of(context).push<void>(
                  MaterialPageRoute(
                    builder: (_) =>
                        DisputesScreen(repository: widget.repository.disputes),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
    ),
    body: SafeArea(
      top: false,
      child: Column(
        children: [
          if (_hub) ...[
            ColoredBox(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: SegmentedTabs(
                  labels: [for (final (_, label) in _types) label],
                  selected: _types.indexWhere((type) => type.$1 == _type),
                  onChanged: (index) => _select(type: _types[index].$1),
                ),
              ),
            ),
            ColoredBox(
              color: Colors.white,
              child: FilterPillRow(
                pills: [
                  for (final (value, label) in _groups)
                    FilterPill(
                      label: label,
                      selected: _group == value,
                      onTap: () => _select(group: value),
                      count: _activeGroups.contains(value)
                          ? _counts[value] ?? 0
                          : 0,
                      countNoun: 'orders',
                    ),
                ],
              ),
            ),
          ],
          const Divider(height: 1, color: BuyerTheme.border),
          Expanded(child: _body()),
        ],
      ),
    ),
  );

  Widget _body() {
    if (_loading && _items.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SkeletonBox(height: 200),
          SizedBox(height: 12),
          SkeletonBox(height: 200),
        ],
      );
    }
    if (_failure != null && _items.isEmpty) {
      final kind = _failure!.kind;
      return StateMessage(
        kind: kind == DiscoveryFailureKind.offline
            ? StateKind.offline
            : kind == DiscoveryFailureKind.forbidden
            ? StateKind.forbidden
            : StateKind.error,
        title: _hub ? 'Your orders could not load' : '$_title could not load',
        message: _failure!.message,
        actionLabel: 'Retry',
        onAction: _load,
      );
    }
    if (_items.isEmpty) {
      if (!_hub) {
        final reviews = widget.view == BuyerOrdersView.reviews;
        return StatePage(
          onRefresh: _load,
          child: StateMessage(
            kind: StateKind.empty,
            artwork: reviews ? StateArtwork.favorites : StateArtwork.cart,
            title: reviews ? 'No reviews yet' : 'No cancellations or refunds',
            message: reviews
                ? 'Completed purchases will appear here for you to view or write reviews.'
                : 'Your cancelled and refunded orders will appear here.',
          ),
        );
      }
      final (title, message) = _emptyCopy();
      return StatePage(
        onRefresh: _load,
        child: StateMessage(
          kind: StateKind.empty,
          artwork: StateArtwork.cart,
          title: title,
          message: message,
        ),
      );
    }
    final notice = _hub && _group == 'COMPLETED';
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        itemCount: _items.length + (notice ? 1 : 0) + (_hasMore ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (notice && index == 0) {
            return const StatusBand(
              tone: BandTone.info,
              title: 'Return/Refund closes with each order’s return window',
              message:
                  'Each card shows its deadline. After it, the Return/Refund button is removed; non-waivable statutory rights remain.',
            );
          }
          final position = index - (notice ? 1 : 0);
          if (position == _items.length) {
            return Center(
              child: TextButton(
                onPressed: _loading ? null : () => _load(more: true),
                child: Text(_loading ? 'Loading…' : 'Show more orders'),
              ),
            );
          }
          return _card(_items[position]);
        },
      ),
    );
  }

  Widget _card(OrderSummaryView order) {
    final review = widget.view == BuyerOrdersView.reviews;
    final actions = review ? const <String>{} : order.cardActions;
    return _OrderCard(
      order: order,
      busy: _busyOrderId == order.id,
      review: review,
      onOpen: () => _open(order),
      onDeadline: _load,
      onMessage: review || widget.openConversation == null
          ? null
          : () => _openThread(order),
      onPay:
          _hub &&
              order.state('ORDER') == 'AWAITING_PAYMENT' &&
              order.nextAction == 'PAY'
          ? () => _pay(order)
          : null,
      onConfirmReceipt: actions.contains('CONFIRM_RECEIPT')
          ? () => _confirmReceipt(order)
          : null,
      onReportProblem: actions.contains('REPORT_PROBLEM')
          ? () => _reportProblem(order)
          : null,
      onReturnRefund: actions.contains('FILE_DISPUTE')
          ? () => _fileDispute(order)
          : null,
      onViewCase:
          actions.contains('VIEW_DISPUTE') && order.disputeCaseId != null
          ? () => _viewCase(order.disputeCaseId!)
          : null,
      onBuyAgain: actions.contains('BUY_AGAIN') ? () => _buyAgain(order) : null,
      onCancellationDetails: actions.contains('VIEW_CANCELLATION')
          ? () => _open(order)
          : null,
      now: widget.now,
    );
  }

  (String, String) _emptyCopy() => switch (_group) {
    'CONFIRMATION' => (
      'Nothing awaiting confirmation',
      'Orders waiting for the Vendor, for your approval or for payment appear here.',
    ),
    'PROCESSING' => (
      'Nothing is being processed',
      'Confirmed orders being prepared appear here.',
    ),
    'TO_SHIP' => (
      'Nothing to ship yet',
      'Orders ready for pickup or out for delivery appear here.',
    ),
    'TO_RECEIVE' => (
      'Nothing to receive',
      'Delivered or picked-up orders waiting for your confirmation appear here.',
    ),
    'COMPLETED' => (
      'No completed orders',
      'Orders you have received appear here.',
    ),
    'CANCELLED' => (
      'No cancelled orders',
      'Cancelled, declined and expired orders appear here.',
    ),
    'DISPUTED' => (
      'No disputed orders',
      'Orders with an open case while awaiting receipt appear here.',
    ),
    _ => (
      'No orders here yet',
      _type == 'PROJECT_BASED'
          ? 'Orders from your project work packages appear here with their status.'
          : 'Orders you submit from your cart appear here with their status.',
    ),
  };
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
    required this.busy,
    required this.onOpen,
    required this.onDeadline,
    this.review = false,
    this.onMessage,
    this.onPay,
    this.onConfirmReceipt,
    this.onReportProblem,
    this.onReturnRefund,
    this.onViewCase,
    this.onBuyAgain,
    this.onCancellationDetails,
    this.now,
  });

  final OrderSummaryView order;
  final bool busy;
  final VoidCallback onOpen;
  final VoidCallback onDeadline;

  /// The My Reviews history: the card opens the order's reviews and offers no other actions.
  final bool review;
  final VoidCallback? onMessage;

  /// Present only while the order is Pending Payment.
  final VoidCallback? onPay;
  final VoidCallback? onConfirmReceipt;
  final VoidCallback? onReportProblem;
  final VoidCallback? onReturnRefund;
  final VoidCallback? onViewCase;
  final VoidCallback? onBuyAgain;
  final VoidCallback? onCancellationDetails;
  final DateTime Function()? now;

  String? get _next => switch (order.nextAction) {
    'REVIEW_REVISION' => 'Review the Vendor’s confirmed version',
    'REVIEW_NRPC' => 'Review the preparation cost',
    'PAY' => 'Payment needed',
    _ => null,
  };

  String? get _deadline {
    final deadline = order.deadline;
    if (deadline == null) return null;
    final prefix = switch (deadline.kind) {
      'VENDOR_RESPONSE' => 'Vendor responds by',
      'BUYER_RESPONSE' => 'Respond by',
      'RECEIPT_CONFIRMATION' => 'Confirmed automatically on',
      'CANCELLATION_RESPONSE' => 'Vendor decides by',
      _ => 'Pay before',
    };
    return '$prefix ${formatManilaDateTime(deadline.at)}';
  }

  String get _payment => order.paymentMethod == 'ONLINE'
      ? order.paymentChannelName ?? 'Online payment'
      : PaymentMethodView(method: order.paymentMethod, available: true).label;

  @override
  Widget build(BuildContext context) {
    final state = order.state('ORDER');
    final closedBeforeFulfillment = const {
      'CANCELLED',
      'DECLINED',
      'EXPIRED',
    }.contains(state);
    final refund = order.state('REFUND');
    final secondary = _secondary();
    final primary = _primary();
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _next == null ? BuyerTheme.border : BuyerTheme.action,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    order.reference,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  OrderStateChip(state: state, tinted: true),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                order.vendorName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: BuyerTheme.muted),
              ),
              const SizedBox(height: 10),
              if (order.submittedAt != null)
                _Fact('Order date', formatManilaDate(order.submittedAt!)),
              if (order.expectedFulfillmentDate != null &&
                  !closedBeforeFulfillment)
                _Fact(
                  order.fulfillmentMethod == 'PICKUP'
                      ? 'Pickup date'
                      : 'Delivery date',
                  formatCalendarDate(order.expectedFulfillmentDate!),
                ),
              _Fact(
                'Items',
                '${order.lineCount} ${order.lineCount == 1 ? 'item' : 'items'}',
              ),
              _Fact('Payment', _payment),
              if (!const {'NONE', 'NOT_REQUESTED'}.contains(refund))
                _Fact('Refund', orderStateLabel(refund)),
              if (order.closureReason != null) ...[
                const SizedBox(height: 8),
                _ReasonBox(reason: order.closureReason!),
              ],
              const Divider(height: 24, color: BuyerTheme.border),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Text(
                      'Total amount',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatPeso(order.commercialTotalCentavos),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: BuyerTheme.action,
                        ),
                      ),
                      if (order.deliveryPending)
                        const Text(
                          '+ delivery fee',
                          style: TextStyle(
                            fontSize: 12,
                            color: BuyerTheme.muted,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              if (!review && (_next != null || _deadline != null)) ...[
                const SizedBox(height: 10),
                _NextStepBand(next: _next, deadline: _deadline),
              ],
              if (onPay != null) ...[
                if (order.deadline != null) ...[
                  const SizedBox(height: 10),
                  DeadlineCountdown(
                    deadline: order.deadline!.at,
                    label: 'Pay before',
                    onExpired: onDeadline,
                    now: now,
                  ),
                ],
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: busy ? null : onPay,
                  icon: const Icon(LucideIcons.creditCard, size: 18),
                  label: Text(
                    order.paymentRetryable ? 'Re-process payment' : 'Pay now',
                  ),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                  ),
                ),
              ],
              if (!review && order.returnRefundDueAt != null) ...[
                const SizedBox(height: 10),
                Text(
                  'Return/Refund available until ${formatManilaDateTime(order.returnRefundDueAt!)}',
                  style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
                ),
              ],
              const SizedBox(height: 12),
              if (review)
                const Row(
                  children: [
                    Icon(LucideIcons.star, size: 16, color: BuyerTheme.action),
                    SizedBox(width: 8),
                    Expanded(child: Text('View or write reviews')),
                    Icon(LucideIcons.chevronRight, size: 18),
                  ],
                )
              else
                Row(
                  children: [
                    if (onMessage != null)
                      _MessageButton(
                        conversation: order.fulfillmentConversation,
                        closed: closedBeforeFulfillment || state == 'COMPLETED',
                        onPressed: busy ? null : onMessage,
                      ),
                    if (secondary != null) ...[
                      const SizedBox(width: 8),
                      Expanded(child: secondary),
                    ],
                    if (primary != null) ...[
                      const SizedBox(width: 8),
                      Expanded(child: primary),
                    ],
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _secondary() {
    final (String, VoidCallback?)? choice = switch (true) {
      _ when onReportProblem != null => ('Report a problem', onReportProblem),
      _ when onReturnRefund != null => ('Return/Refund', onReturnRefund),
      _ when onViewCase != null => ('View case', onViewCase),
      _ when onCancellationDetails != null => (
        'Cancellation details',
        onCancellationDetails,
      ),
      _ => null,
    };
    if (choice == null) return null;
    return FilledButton(
      onPressed: busy ? null : choice.$2,
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 44),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        backgroundColor: BuyerTheme.brandSoft,
        foregroundColor: BuyerTheme.actionPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(choice.$1, textAlign: TextAlign.center, maxLines: 2),
    );
  }

  Widget? _primary() {
    final (String, VoidCallback?)? choice = switch (true) {
      _ when onConfirmReceipt != null => ('Confirm receipt', onConfirmReceipt),
      _ when onBuyAgain != null => ('Buy again', onBuyAgain),
      _ => null,
    };
    if (choice == null) return null;
    return FilledButton(
      onPressed: busy ? null : choice.$2,
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 44),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(choice.$1, textAlign: TextAlign.center, maxLines: 2),
    );
  }
}

/// A label/value line of the card: label on the left, value right-aligned and wrapping.
class _Fact extends StatelessWidget {
  const _Fact(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: BuyerTheme.muted),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ),
  );
}

class _ReasonBox extends StatelessWidget {
  const _ReasonBox({required this.reason});

  final String reason;

  static const _error = Color(MateryalColorTokens.statusError);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: Color.lerp(Colors.white, _error, 0.06),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(LucideIcons.circleAlert, size: 16, color: _error),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            'Reason: $reason',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: BuyerTheme.ink,
            ),
          ),
        ),
      ],
    ),
  );
}

class _NextStepBand extends StatelessWidget {
  const _NextStepBand({required this.next, required this.deadline});

  final String? next;
  final String? deadline;

  @override
  Widget build(BuildContext context) {
    final color = next == null ? BuyerTheme.muted : BuyerTheme.actionPressed;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: next == null ? BuyerTheme.canvas : BuyerTheme.brandSoft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            next == null ? LucideIcons.clock : LucideIcons.bellRing,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              [?next, ?deadline].join(' · '),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The card's Fulfillment Messages button with its unread count. It is unavailable only for a
/// closed order that never had a thread.
class _MessageButton extends StatelessWidget {
  const _MessageButton({
    required this.conversation,
    required this.closed,
    required this.onPressed,
  });

  final OrderConversationRefView? conversation;
  final bool closed;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final unavailable = conversation == null && closed;
    final unread = conversation?.unreadCount ?? 0;
    final tooltip = unavailable
        ? 'No fulfillment messages for this order'
        : 'Fulfillment messages${conversation?.readOnly ?? false ? ' (read-only)' : ''}${unread > 0 ? ', $unread unread' : ''}';
    return IconButton(
      tooltip: tooltip,
      onPressed: unavailable ? null : onPressed,
      style: IconButton.styleFrom(
        minimumSize: const Size(44, 44),
        foregroundColor: BuyerTheme.action,
        side: const BorderSide(color: BuyerTheme.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: CountBadge(
        quantity: '$unread',
        child: const Icon(LucideIcons.messageSquareText, size: 22),
      ),
    );
  }
}
