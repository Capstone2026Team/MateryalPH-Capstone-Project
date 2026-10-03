import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/components/order_components.dart';
import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';
import '../item_procurement/procurement_models.dart' show formatPeso;
import '../map_discovery/discovery_models.dart';
import 'order_details_screen.dart';
import 'order_models.dart';
import 'order_payment_screen.dart';
import 'orders_repository.dart';

/// The Buyer order hub: Needs action, Active, Completed, Cancelled and Disputed, each card showing
/// separate order and payment states, the next step and any deadline in Philippine time.
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({
    super.key,
    required this.repository,
    this.initialGroup = 'AWAITING_ACTION',
    this.paymentLauncher = launchPaymentPage,
    this.openConversation,
  });

  final OrdersRepository repository;
  final String initialGroup;
  final PaymentLauncher paymentLauncher;
  final OpenOrderConversation? openConversation;

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  static const _groups = [
    ('AWAITING_ACTION', 'Needs action'),
    ('ACTIVE', 'Active'),
    ('COMPLETED', 'Completed'),
    ('CANCELLED', 'Cancelled'),
    ('DISPUTED', 'Disputed'),
    ('ALL', 'All'),
  ];

  late String _group = widget.initialGroup;
  final List<OrderSummaryView> _items = [];
  Map<String, int> _counts = const {};
  bool _loading = true;
  bool _hasMore = false;
  int _page = 1;
  DiscoveryFailure? _failure;
  int _sequence = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool more = false}) async {
    final sequence = ++_sequence;
    final page = more ? _page + 1 : 1;
    setState(() {
      _loading = true;
      _failure = null;
      if (!more) _items.clear();
    });
    try {
      final result = await widget.repository.orders(group: _group, page: page);
      if (!mounted || sequence != _sequence) return;
      setState(() {
        _items.addAll(result.items);
        _counts = result.counts;
        _hasMore = result.hasMore;
        _page = result.page;
      });
    } on DiscoveryFailure catch (error) {
      if (mounted && sequence == _sequence) setState(() => _failure = error);
    } finally {
      if (mounted && sequence == _sequence) setState(() => _loading = false);
    }
  }

  Future<void> _open(OrderSummaryView order) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => OrderDetailsScreen(
          orderId: order.id,
          repository: widget.repository,
          paymentLauncher: widget.paymentLauncher,
          openConversation: widget.openConversation,
        ),
      ),
    );
    if (mounted) await _load();
  }

  /// Pay now from the list: the payment page resumes a checkout that is already open instead of
  /// starting a second one, so the same order and amount are never charged twice.
  Future<void> _pay(OrderSummaryView order) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => OrderPaymentScreen(
          orderId: order.id,
          repository: widget.repository,
          launcher: widget.paymentLauncher,
        ),
      ),
    );
    if (mounted) await _load();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: buyerAppBar(context, 'My orders'),
    body: SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
              children: [
                for (final (value, label) in _groups)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterPill(
                      label: _counts[value] == null || value == 'ALL'
                          ? label
                          : '$label (${_counts[value]})',
                      selected: _group == value,
                      onTap: () {
                        if (_group == value) return;
                        setState(() => _group = value);
                        _load();
                      },
                    ),
                  ),
              ],
            ),
          ),
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
          SkeletonBox(height: 120),
          SizedBox(height: 12),
          SkeletonBox(height: 120),
        ],
      );
    }
    if (_failure != null && _items.isEmpty) {
      return StateMessage(
        kind: _failure!.kind == DiscoveryFailureKind.offline
            ? StateKind.offline
            : StateKind.error,
        title: 'Your orders could not load',
        message: _failure!.message,
        actionLabel: 'Retry',
        onAction: _load,
      );
    }
    if (_items.isEmpty) {
      return StateMessage(
        kind: StateKind.empty,
        title: _group == 'AWAITING_ACTION'
            ? 'Nothing needs your action'
            : 'No orders here yet',
        message: _group == 'AWAITING_ACTION'
            ? 'Vendor revisions, preparation costs and payments that need you will appear here.'
            : 'Orders you submit from your cart appear here with their status.',
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        itemCount: _items.length + (_hasMore ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          if (index == _items.length) {
            return Center(
              child: TextButton(
                onPressed: _loading ? null : () => _load(more: true),
                child: Text(_loading ? 'Loading…' : 'Show more orders'),
              ),
            );
          }
          return _OrderCard(
            order: _items[index],
            onDeadline: _load,
            onTap: () => _open(_items[index]),
            onPay:
                _items[index].state('ORDER') == 'AWAITING_PAYMENT' &&
                    _items[index].nextAction == 'PAY'
                ? () => _pay(_items[index])
                : null,
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
    required this.onTap,
    required this.onDeadline,
    this.onPay,
  });

  final OrderSummaryView order;
  final VoidCallback onTap;
  final VoidCallback onDeadline;

  /// Present only while the order is Pending Payment.
  final VoidCallback? onPay;

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
      _ => 'Pay before',
    };
    return '$prefix ${formatManilaDateTime(deadline.at)}';
  }

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: BorderSide(
        color: order.nextAction == null ? BuyerTheme.border : BuyerTheme.action,
      ),
    ),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  LucideIcons.store,
                  size: 16,
                  color: BuyerTheme.muted,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    order.vendorName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(child: OrderStateChip(state: order.state('ORDER'))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 56,
                    height: 56,
                    color: BuyerTheme.canvas,
                    child: order.firstLineImageUrl == null
                        ? const Icon(
                            LucideIcons.package,
                            color: BuyerTheme.muted,
                          )
                        : Image.network(
                            order.firstLineImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Icon(
                              LucideIcons.package,
                              color: BuyerTheme.muted,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.lineCount > 1
                            ? '${order.firstLineName} + ${order.lineCount - 1} more'
                            : order.firstLineName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${order.reference} · ${order.fulfillmentMethod == 'DELIVERY' ? 'Site Delivery' : 'Self-Pickup'}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: BuyerTheme.muted,
                        ),
                      ),
                      Text(
                        'Payment: ${orderStateLabel(order.state('PAYMENT'))}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: BuyerTheme.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatPeso(order.commercialTotalCentavos),
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    if (order.deliveryPending)
                      const Text(
                        '+ delivery',
                        style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
                      ),
                  ],
                ),
              ],
            ),
            if (_next != null || _deadline != null) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _next == null
                      ? BuyerTheme.canvas
                      : BuyerTheme.brandSoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _next == null ? LucideIcons.clock : LucideIcons.bellRing,
                      size: 16,
                      color: _next == null
                          ? BuyerTheme.muted
                          : BuyerTheme.actionPressed,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        [?_next, ?_deadline].join(' · '),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _next == null
                              ? BuyerTheme.muted
                              : BuyerTheme.actionPressed,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (onPay != null) ...[
              if (order.deadline != null)
                DeadlineCountdown(
                  deadline: order.deadline!.at,
                  label: 'Pay before',
                  onExpired: onDeadline,
                ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onPay,
                  icon: const Icon(LucideIcons.creditCard, size: 18),
                  label: Text(
                    order.paymentRetryable ? 'Re-process payment' : 'Pay now',
                  ),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
