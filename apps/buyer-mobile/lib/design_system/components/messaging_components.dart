import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import '../theme.dart';
import 'order_components.dart';

String chatRole(String role) => switch (role) {
  'STORE_MANAGER' => 'Store Manager',
  'STORE_STAFF' => 'Store Staff',
  'CUSTOMER_SERVICE' => 'Customer Service',
  'FULFILLMENT' => 'Fulfillment Staff',
  'OWNER' => 'Owner',
  'BUYER' => 'Buyer',
  _ => 'Store team',
};
String chatMoney(int cents) => '₱${(cents / 100).toStringAsFixed(2)}';

class ChatProductCard extends StatelessWidget {
  const ChatProductCard({super.key, required this.product, this.onOpen});
  final api.ChatProduct product;
  final VoidCallback? onOpen;
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    onTap: product.available ? onOpen : null,
    leading: product.imageUrl == null
        ? const Icon(Icons.inventory_2_outlined)
        : Image.network(
            product.imageUrl!,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (_, error, stack) =>
                const Icon(Icons.inventory_2_outlined),
          ),
    title: Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis),
    subtitle: Text(
      '${chatMoney(product.priceCentavos)}${product.available ? '' : '\nNo longer available'}',
    ),
    trailing: product.available && onOpen != null
        ? const Icon(Icons.chevron_right)
        : null,
  );
}

DateTime chatManilaTime(String value) =>
    DateTime.parse(value).toUtc().add(const Duration(hours: 8));

String chatTime(String value) {
  final date = chatManilaTime(value);
  return '${date.hour % 12 == 0 ? 12 : date.hour % 12}:${date.minute.toString().padLeft(2, '0')} ${date.hour < 12 ? 'AM' : 'PM'}';
}

String chatDate(String value) {
  final date = chatManilaTime(value);
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

class ConversationAvatar extends StatelessWidget {
  const ConversationAvatar({super.key, required this.store, this.size = 48});
  final api.ChatStore store;
  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: ClipOval(
      child: SizedBox.square(
        dimension: size,
        child: store.logoUrl == null
            ? _fallback()
            : Image.network(
                store.logoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, error, stack) => _fallback(),
              ),
      ),
    ),
  );

  Widget _fallback() => ColoredBox(
    color: BuyerTheme.canvas,
    child: Icon(
      Icons.storefront_outlined,
      color: BuyerTheme.muted,
      size: size / 2,
    ),
  );
}

class ConversationInboxTile extends StatelessWidget {
  const ConversationInboxTile({
    super.key,
    required this.conversation,
    required this.onTap,
  });
  final api.ConversationView conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = conversation;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConversationAvatar(store: c.store, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.store.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: c.unreadCount > 0
                          ? FontWeight.w700
                          : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    c.lastMessagePreview?.isNotEmpty == true
                        ? c.lastMessagePreview!
                        : c.purpose.name == 'FULFILLMENT'
                        ? 'Order coordination'
                        : 'Sales & quotations',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                Tooltip(
                  message:
                      'Updated ${chatDate(c.updatedAt)}, ${chatTime(c.updatedAt)} Manila',
                  child: Text(
                    '${chatManilaTime(c.updatedAt).day}/${chatManilaTime(c.updatedAt).month}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: BuyerTheme.muted,
                    ),
                  ),
                ),
                if (c.unreadCount > 0) ...[
                  const SizedBox(height: 8),
                  Semantics(
                    label: '${c.unreadCount} unread messages',
                    child: ExcludeSemantics(
                      child: Badge(
                        backgroundColor: BuyerTheme.action,
                        label: Text(
                          c.unreadCount > 99 ? '99+' : '${c.unreadCount}',
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ConversationMessageBubble extends StatelessWidget {
  const ConversationMessageBubble({
    super.key,
    required this.message,
    required this.onOpenFile,
    this.busy = false,
    this.onOpenProduct,
  });
  final api.ChatMessage message;
  final ValueChanged<api.ChatAttachment> onOpenFile;
  final bool busy;
  final ValueChanged<String>? onOpenProduct;

  @override
  Widget build(BuildContext context) {
    final m = message;
    if (m.kind.name == 'SYSTEM') {
      return Semantics(
        liveRegion: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Text(
            '${m.body}\n${chatTime(m.sentAt)} Manila',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
          ),
        ),
      );
    }
    return Align(
      alignment: m.mine ? Alignment.centerRight : Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: .86,
        child: Column(
          crossAxisAlignment: m.mine
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: m.mine ? BuyerTheme.brandSoft : BuyerTheme.canvas,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(m.mine ? 16 : 4),
                  bottomRight: Radius.circular(m.mine ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!m.mine) ...[
                    Text(
                      '${m.sender.displayName} · ${chatRole(m.sender.role)}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  if (m.body.isNotEmpty)
                    Text(
                      m.body,
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                  if (m.product != null)
                    ChatProductCard(
                      product: m.product!,
                      onOpen: onOpenProduct == null
                          ? null
                          : () => onOpenProduct!(m.product!.listingId),
                    ),
                  for (final file in m.attachments)
                    TextButton.icon(
                      onPressed: busy || file.scanState.name != 'CLEAN'
                          ? null
                          : () => onOpenFile(file),
                      icon: const Icon(Icons.description_outlined, size: 20),
                      label: Text(
                        '${file.displayName}\n${(file.sizeBytes / 1024).ceil()} KB · ${file.scanState.name}',
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                '${chatTime(m.sentAt)} Manila${m.mine
                    ? m.readByRecipient
                          ? ' · Read'
                          : ' · Sent'
                    : ''}',
                style: const TextStyle(fontSize: 11, color: BuyerTheme.muted),
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

/// Three bouncing dots in a received-message bubble, shown while the store is
/// typing. Motion is replaced by static dots when the system disables animations.
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key, this.name});
  final String? name;

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final who = widget.name == null || widget.name!.isEmpty
        ? 'The store'
        : widget.name!;
    return Semantics(
      liveRegion: true,
      label: '$who is typing',
      child: ExcludeSemantics(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(top: 6, bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              color: BuyerTheme.canvas,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < 3; i++)
                    Padding(
                      padding: EdgeInsets.only(right: i < 2 ? 5 : 0),
                      child: Transform.translate(
                        offset: Offset(
                          0,
                          _controller.isAnimating
                              ? -4 *
                                    math.max(
                                      0,
                                      math.sin(
                                        (_controller.value - i * .15) *
                                            2 *
                                            math.pi,
                                      ),
                                    )
                              : 0,
                        ),
                        child: const SizedBox.square(
                          dimension: 8,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: BuyerTheme.muted,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
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

class ConversationHeader extends StatelessWidget {
  const ConversationHeader({
    super.key,
    required this.conversation,
    this.avatar,
    this.compact = false,
  });
  final api.ConversationView conversation;
  final Uint8List? avatar;
  final bool compact;
  @override
  Widget build(BuildContext context) {
    final handler = conversation.handler;
    return Padding(
      padding: compact ? EdgeInsets.zero : const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ConversationAvatar(store: conversation.store, size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      conversation.store.name,
                      maxLines: compact ? 1 : null,
                      overflow: compact ? TextOverflow.ellipsis : null,
                      style: TextStyle(
                        fontSize: compact ? 14 : 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (conversation.store.verified)
                      const Text(
                        '✓ Verified Vendor',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11, color: BuyerTheme.muted),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (handler != null && !compact) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: avatar == null ? null : MemoryImage(avatar!),
                  child: avatar == null
                      ? Text(
                          handler.displayName.isEmpty
                              ? 'S'
                              : handler.displayName[0],
                        )
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Handled by ${handler.displayName}\n${chatRole(handler.role)}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class QuotationVersionCard extends StatelessWidget {
  const QuotationVersionCard({
    super.key,
    required this.version,
    this.onAction,
    this.busy = false,
  });
  final api.ChatQuotationVersion version;
  final void Function(String action)? onAction;
  final bool busy;
  @override
  Widget build(BuildContext context) {
    final c = version.content;
    final due = DateTime.parse(version.expiresAt);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: BuyerTheme.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ORDER FROM CHAT',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 1,
              color: BuyerTheme.muted,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              Text(
                'Quotation v${version.version}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                version.state == 'ACCEPTED'
                    ? 'Accepted'
                    : version.latest
                    ? 'Latest version'
                    : 'Superseded',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${version.state.replaceAll('_', ' ')} · ${version.viewed ? 'Viewed' : 'Not yet viewed'}',
            style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
          ),
          const Divider(height: 28),
          for (final line in c.lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    line.description,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${line.quantity} ${line.unitCode} × ${chatMoney(line.unitPriceCentavos)}',
                    style: const TextStyle(color: BuyerTheme.muted),
                  ),
                ],
              ),
            ),
          const Divider(),
          Text('Materials ${chatMoney(c.commercial.materialsPayableCentavos)}'),
          Text('Included VAT ${chatMoney(c.commercial.materialsVatCentavos)}'),
          Text('Delivery ${chatMoney(c.commercial.deliveryCentavos)}'),
          const SizedBox(height: 8),
          Text(
            'Total before processing fee\n${chatMoney(c.commercial.commercialTotalCentavos)}',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Processing fee pending payment channel selection.',
            style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
          ),
          const SizedBox(height: 12),
          Text(
            '${c.fulfillmentMethod == 'PICKUP' ? 'Self-Pickup' : 'Site Delivery'} · ${c.fulfillmentDate}',
          ),
          if (c.commercial.nrpcCentavos > 0)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'NRPC ${chatMoney(c.commercial.nrpcCentavos)} is included in this total.',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          Material(
            color: Colors.transparent,
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Text('What changed · ${c.changes.length} fields'),
              children: [
                for (final change in c.changes)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(change.label),
                  ),
              ],
            ),
          ),
          if (version.state != 'ACCEPTED')
            DeadlineCountdown(
              deadline: due,
              label: 'Buyer deadline · Asia/Manila',
              endedLabel: 'Quotation deadline passed',
            ),
          if (!version.latest && version.state != 'ACCEPTED')
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                'A newer version replaces these terms. Open the latest quotation to respond.',
              ),
            ),
          if (version.latest && onAction != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final action in version.actions.where(
                    (a) => a != 'view',
                  ))
                    action == 'accept'
                        ? FilledButton(
                            onPressed: busy || !due.isAfter(DateTime.now())
                                ? null
                                : () => onAction!(action),
                            child: const Text('Review & accept'),
                          )
                        : OutlinedButton(
                            onPressed: busy || !due.isAfter(DateTime.now())
                                ? null
                                : () => onAction!(action),
                            child: Text(
                              action == 'counter' ? 'Counter-offer' : 'Reject',
                            ),
                          ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
