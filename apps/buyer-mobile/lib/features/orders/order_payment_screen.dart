import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/components/order_components.dart';
import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';
import '../item_procurement/procurement_models.dart' show formatPeso;
import '../map_discovery/discovery_models.dart';
import '../map_discovery/discovery_repository.dart' show newIdempotencyKey;
import 'order_models.dart';
import 'orders_repository.dart';

/// Opens an external payment page. Injectable so tests never leave the app.
typedef PaymentLauncher = Future<bool> Function(Uri url);

Future<bool> launchPaymentPage(Uri url) =>
    launchUrl(url, mode: LaunchMode.externalApplication);

/// Choose an online channel and pay. Every amount comes from the server: the Payment Processing Fee
/// is the configured DEMO channel rate with no markup, and the total is re-checked by the server.
class OrderPaymentScreen extends StatefulWidget {
  const OrderPaymentScreen({
    super.key,
    required this.orderId,
    required this.repository,
    this.launcher = launchPaymentPage,
  });

  final String orderId;
  final OrdersRepository repository;
  final PaymentLauncher launcher;

  @override
  State<OrderPaymentScreen> createState() => _OrderPaymentScreenState();
}

class _OrderPaymentScreenState extends State<OrderPaymentScreen> {
  PaymentOptionsView? _options;
  DiscoveryFailure? _failure;
  String? _channel;
  String? _error;
  bool _busy = false;
  String? _key;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _failure = null);
    try {
      final options = await widget.repository.paymentOptions(widget.orderId);
      if (!mounted) return;
      setState(() {
        _options = options;
        _channel ??= options.channels
            .where((channel) => channel.available)
            .map((channel) => channel.code)
            .firstOrNull;
      });
    } on DiscoveryFailure catch (error) {
      if (mounted) setState(() => _failure = error);
    }
  }

  Future<void> _pay(PaymentChannelView channel) async {
    if (_busy || channel.totalCentavos == null) return;
    final key = _key ??= newIdempotencyKey();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final attempt = await widget.repository.startPayment(
        widget.orderId,
        channelCode: channel.code,
        expectedTotalCentavos: channel.totalCentavos!,
        idempotencyKey: key,
      );
      _key = null;
      final url = attempt.checkoutUrl;
      if (url != null) await widget.launcher(Uri.parse(url));
      if (!mounted) return;
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => PaymentPendingScreen(
            paymentId: attempt.id,
            repository: widget.repository,
            initial: attempt,
            launcher: widget.launcher,
          ),
        ),
      );
    } on DiscoveryFailure catch (error) {
      // A checkout for this order is already open (for example started earlier or from another screen).
      // Resume it rather than showing an error; a second charge for the same order is never started.
      final open = error.details['payment_id'];
      if (error.code == 'PAYMENT_ATTEMPT_IN_PROGRESS' &&
          open is String &&
          mounted) {
        _key = null;
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => PaymentPendingScreen(
              paymentId: open,
              repository: widget.repository,
              launcher: widget.launcher,
            ),
          ),
        );
        return;
      }
      // Keep the key only when the outcome is unknown, so a retry replays the same attempt.
      if (error.kind != DiscoveryFailureKind.offline) _key = null;
      if (mounted) setState(() => _error = error.message);
      if (error.kind == DiscoveryFailureKind.conflict) await _load();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = _options;
    final selected = options?.channels
        .where((channel) => channel.code == _channel && channel.available)
        .firstOrNull;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buyerAppBar(context, 'Pay for order'),
      bottomNavigationBar: options == null || !options.paymentDue
          ? null
          : SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: FilledButton(
                  onPressed: _busy || selected == null
                      ? null
                      : () => _pay(selected),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                  child: Text(
                    _busy
                        ? 'Opening payment…'
                        : selected == null
                        ? 'Choose a payment channel'
                        : 'Pay ${formatPeso(selected.totalCentavos!)} — TEST',
                  ),
                ),
              ),
            ),
      body: SafeArea(
        child: options == null
            ? (_failure == null
                  ? ListView(
                      padding: const EdgeInsets.all(16),
                      children: const [
                        SkeletonBox(height: 80),
                        SizedBox(height: 12),
                        SkeletonBox(height: 260),
                      ],
                    )
                  : StateMessage(
                      kind: _failure!.kind == DiscoveryFailureKind.offline
                          ? StateKind.offline
                          : StateKind.error,
                      title: 'Payment options could not load',
                      message: _failure!.message,
                      actionLabel: 'Retry',
                      onAction: _load,
                    ))
            : RefreshIndicator(onRefresh: _load, child: _content(options)),
      ),
    );
  }

  Widget _content(PaymentOptionsView options) {
    if (!options.paymentDue) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          StatusBand(
            tone: BandTone.info,
            title: 'No online payment is due',
            message:
                options.latestAttempt?.message ??
                'This order has no payment due right now. Pull to refresh.',
          ),
        ],
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        _TestBanner(notice: options.notice),
        const SizedBox(height: 14),
        Text(
          paymentPurposeLabel(options.purpose),
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          'Order ${options.orderReference} · ${formatPeso(options.principalCentavos ?? 0)} before the processing fee',
          style: const TextStyle(color: BuyerTheme.muted),
        ),
        if (options.payBy != null) ...[
          const SizedBox(height: 12),
          DeadlineCountdown(
            deadline: options.payBy!,
            label: 'Pay before',
            endedLabel: 'Payment window ended',
            onExpired: _load,
          ),
        ],
        const SizedBox(height: 18),
        const SectionHeading('Payment channel'),
        const SizedBox(height: 8),
        for (final channel in options.channels)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ChannelTile(
              channel: channel,
              selected: channel.code == _channel,
              onTap: channel.available && !_busy
                  ? () => setState(() => _channel = channel.code)
                  : null,
            ),
          ),
        if (_error != null) ...[
          const SizedBox(height: 4),
          StatusBand(
            tone: BandTone.danger,
            title: 'Payment did not start',
            message: _error,
          ),
        ],
        const SizedBox(height: 8),
        const Text(
          'The fee is the provider’s charge for the channel you choose, shown before you pay. Your order is confirmed only after the payment provider verifies the payment.',
          style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
        ),
      ],
    );
  }
}

class _TestBanner extends StatelessWidget {
  const _TestBanner({required this.notice});

  final String notice;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: BuyerTheme.brandSoft,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(LucideIcons.flaskConical, size: 18, color: BuyerTheme.ink),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            notice,
            style: const TextStyle(fontSize: 13, color: BuyerTheme.ink),
          ),
        ),
      ],
    ),
  );
}

class _ChannelTile extends StatelessWidget {
  const _ChannelTile({
    required this.channel,
    required this.selected,
    required this.onTap,
  });

  final PaymentChannelView channel;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final available = channel.available;
    final detail = available
        ? '${channel.rateLabel} · DEMO rate'
        : channel.unavailableText;
    return Semantics(
      button: true,
      inMutuallyExclusiveGroup: true,
      checked: selected && available,
      enabled: onTap != null,
      label: available
          ? '${channel.displayName}. Fee ${formatPeso(channel.feeCentavos ?? 0)}. Total ${formatPeso(channel.totalCentavos ?? 0)}.'
          : '${channel.displayName}. $detail',
      excludeSemantics: true,
      child: Material(
        color: selected && available ? BuyerTheme.brandSoft : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: selected && available
                ? BuyerTheme.action
                : BuyerTheme.border,
            width: selected && available ? 1.5 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    !available
                        ? LucideIcons.circleSlash
                        : channel.kind == 'CARD'
                        ? LucideIcons.creditCard
                        : LucideIcons.wallet,
                    size: 20,
                    color: available ? BuyerTheme.ink : BuyerTheme.muted,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          channel.displayName,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: available
                                ? BuyerTheme.ink
                                : BuyerTheme.muted,
                          ),
                        ),
                        Text(
                          detail,
                          style: const TextStyle(
                            fontSize: 12,
                            color: BuyerTheme.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (available && channel.totalCentavos != null)
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatPeso(channel.totalCentavos!),
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          Text(
                            '+${formatPeso(channel.feeCentavos ?? 0)} fee',
                            style: const TextStyle(
                              fontSize: 12,
                              color: BuyerTheme.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shown after the Buyer leaves for the hosted payment page. It reads Pending until the provider has
/// verified the payment; returning to the app re-checks the status but never confirms it on its own.
class PaymentPendingScreen extends StatefulWidget {
  const PaymentPendingScreen({
    super.key,
    required this.paymentId,
    required this.repository,
    this.initial,
    this.launcher = launchPaymentPage,
    this.pollInterval = const Duration(seconds: 10),
  });

  final String paymentId;
  final OrdersRepository repository;
  final PaymentAttemptView? initial;
  final PaymentLauncher launcher;
  final Duration pollInterval;

  @override
  State<PaymentPendingScreen> createState() => _PaymentPendingScreenState();
}

class _PaymentPendingScreenState extends State<PaymentPendingScreen>
    with WidgetsBindingObserver {
  PaymentAttemptView? _attempt;
  OrderDetailView? _order;
  String? _error;
  bool _checking = false;
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    _attempt = widget.initial;
    WidgetsBinding.instance.addObserver(this);
    if (_attempt == null || _attempt!.retryable) {
      unawaited(_read());
    }
    _schedule();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _poll?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Returning from the payment page re-checks with the provider; it never marks the payment paid.
    if (state == AppLifecycleState.resumed) unawaited(_check());
  }

  void _schedule() {
    _poll?.cancel();
    if (_attempt?.pending ?? true) {
      _poll = Timer.periodic(widget.pollInterval, (_) => _read());
    }
  }

  Future<void> _read() async {
    try {
      final attempt = await widget.repository.payment(widget.paymentId);
      final order = attempt.retryable && attempt.orderId != null
          ? await widget.repository.order(attempt.orderId!)
          : null;
      if (!mounted) return;
      setState(() {
        _attempt = attempt;
        _order = order;
      });
      if (!attempt.pending) _poll?.cancel();
    } on DiscoveryFailure catch (error) {
      if (mounted) setState(() => _error = error.message);
    }
  }

  Future<void> _check() async {
    if (_checking) return;
    setState(() {
      _checking = true;
      _error = null;
    });
    try {
      final attempt = await widget.repository.refreshPayment(widget.paymentId);
      final order = attempt.retryable && attempt.orderId != null
          ? await widget.repository.order(attempt.orderId!)
          : null;
      if (!mounted) return;
      setState(() {
        _attempt = attempt;
        _order = order;
      });
      if (!attempt.pending) _poll?.cancel();
    } on DiscoveryFailure catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final attempt = _attempt;
    final payingBalance = attempt?.purpose == 'ORDER_BALANCE_PAYMENT';
    final canRetry =
        _order?.actions.contains('PAY') == true &&
        (_order?.state('ORDER') == 'AWAITING_PAYMENT' || payingBalance);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buyerAppBar(context, 'Payment status'),
      body: SafeArea(
        child: attempt == null
            ? (_error == null
                  ? ListView(
                      padding: const EdgeInsets.all(16),
                      children: const [SkeletonBox(height: 160)],
                    )
                  : StateMessage(
                      kind: StateKind.error,
                      title: 'Payment status could not load',
                      message: _error!,
                      actionLabel: 'Retry',
                      onAction: _read,
                    ))
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  _StatusHero(attempt: attempt),
                  if (_order?.terminalReasonCode == 'PAYMENT_WINDOW_EXPIRED')
                    const StatusBand(
                      tone: BandTone.danger,
                      title: 'Cancelled — payment expired',
                      message:
                          'The order’s payment deadline passed and its reserved stock was released.',
                    ),
                  const SizedBox(height: 16),
                  _AmountCard(attempt: attempt),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    StatusBand(
                      tone: BandTone.warning,
                      title: 'Could not check right now',
                      message: _error,
                    ),
                  ],
                  const SizedBox(height: 16),
                  if (attempt.pending && attempt.checkoutUrl != null)
                    OutlinedButton.icon(
                      onPressed: () =>
                          widget.launcher(Uri.parse(attempt.checkoutUrl!)),
                      icon: const Icon(LucideIcons.externalLink, size: 18),
                      label: const Text('Open payment page again'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  if (attempt.pending) ...[
                    const SizedBox(height: 10),
                    FilledButton.icon(
                      onPressed: _checking ? null : _check,
                      icon: const Icon(LucideIcons.refreshCw, size: 18),
                      label: Text(
                        _checking ? 'Checking…' : 'Check payment status',
                      ),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                  ] else if (attempt.retryable &&
                      attempt.orderId != null &&
                      canRetry) ...[
                    // The order stays Pending Payment until its deadline, so the Buyer can pay again for the
                    // same order and amount. Only one checkout can be open at a time.
                    StatusBand(
                      tone: BandTone.info,
                      title: payingBalance
                          ? 'Your remaining balance is payable'
                          : 'Your order is still Pending Payment',
                      message: payingBalance
                          ? 'You were not charged for this attempt. The Vendor-approved remaining balance can be paid online.'
                          : 'You were not charged for this attempt. You can pay again before the order’s payment deadline.',
                    ),
                    const SizedBox(height: 12),
                    if (_order?.paymentExpiresAt != null)
                      DeadlineCountdown(
                        deadline: _order!.paymentExpiresAt!,
                        label: 'Pay before',
                        onExpired: _read,
                      ),
                    FilledButton.icon(
                      onPressed: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) => OrderPaymentScreen(
                            orderId: attempt.orderId!,
                            repository: widget.repository,
                            launcher: widget.launcher,
                          ),
                        ),
                      ),
                      icon: const Icon(LucideIcons.rotateCcw, size: 18),
                      label: Text(
                        payingBalance
                            ? 'Pay remaining balance'
                            : 'Re-process payment',
                      ),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: const Text('Back to order'),
                    ),
                  ] else
                    FilledButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: const Text('Back to order'),
                    ),
                ],
              ),
      ),
    );
  }
}

class _StatusHero extends StatelessWidget {
  const _StatusHero({required this.attempt});

  final PaymentAttemptView attempt;

  @override
  Widget build(BuildContext context) {
    final (tone, title, icon) = switch (attempt.status) {
      'PAID' => (BandTone.success, 'Payment verified', LucideIcons.badgeCheck),
      'FAILED' => (
        BandTone.danger,
        'Payment did not go through',
        LucideIcons.circleX,
      ),
      'EXPIRED' => (
        BandTone.warning,
        'Payment expired — not charged',
        LucideIcons.clock,
      ),
      'CAPTURED_LATE_REFUND_PENDING' => (
        BandTone.info,
        'Late payment — refund queued',
        LucideIcons.undo2,
      ),
      _ => (
        BandTone.warning,
        'Payment pending verification',
        LucideIcons.hourglass,
      ),
    };
    return Semantics(
      liveRegion: true,
      child: StatusBand(
        tone: tone,
        title: title,
        message: attempt.message,
        action: Icon(icon, size: 22, color: BuyerTheme.ink),
      ),
    );
  }
}

class _AmountCard extends StatelessWidget {
  const _AmountCard({required this.attempt});

  final PaymentAttemptView attempt;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: BuyerTheme.canvas,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        _row(
          paymentPurposeLabel(attempt.purpose),
          formatPeso(attempt.principalCentavos),
        ),
        _row(
          'Payment Processing Fee${attempt.channelName == null ? '' : ' (${attempt.channelName})'}',
          formatPeso(attempt.processingFeeCentavos),
        ),
        const Divider(height: 18),
        _row('Total', formatPeso(attempt.totalCentavos), strong: true),
        const SizedBox(height: 6),
        Text(
          attempt.evidenceOrigin == 'SIMULATED'
              ? 'SIMULATED payment — no provider call and no real charge.'
              : 'Xendit TEST payment — no real charge.',
          style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
        ),
      ],
    ),
  );

  Widget _row(String label, String value, {bool strong = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: strong ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: strong ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
