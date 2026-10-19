import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import '../theme.dart';
import 'order_components.dart';
import 'quotation_details.dart';
import 'procurement_components.dart' show BuyerDeliveryRecommendation;

class QuotationDeliveryTerms extends StatelessWidget {
  const QuotationDeliveryTerms({super.key, required this.content});
  final api.ChatQuotationContent content;

  @override
  Widget build(BuildContext context) {
    final delivery = content.delivery;
    if (delivery == null) return const SizedBox.shrink();
    final recommended = delivery['system_recommendation']?.value;
    final vehicles = delivery['vehicles']?.value;
    final explanation =
        delivery['change_reason']?.value ??
        delivery['manual_review_note']?.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (recommended is List && recommended.isNotEmpty)
          BuyerDeliveryRecommendation(
            lines: [
              for (final row in recommended)
                if (row is Map<String, Object?>)
                  '${row['vehicle_name']} · ${row['vehicles']} vehicle(s) · ${row['trips']} trip(s)',
            ],
          ),
        if (vehicles is List) ...[
          const Text(
            'Vendor delivery plan',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          for (final row in vehicles)
            if (row is Map<String, Object?>)
              Text(
                '${row['configuration'] is Map<String, Object?> ? (row['configuration'] as Map<String, Object?>)['name'] ?? 'Vehicle' : 'Vehicle'} · ${row['number_of_vehicles']} vehicle(s) · ${row['total_vehicle_trips']} trip(s)',
              ),
        ],
        if (explanation is String && explanation.isNotEmpty) ...[
          const Text(
            'Vendor explanation',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          Text(explanation),
          const Text(
            'Accepting this quotation approves this delivery plan and fee before payment.',
          ),
        ],
      ],
    );
  }
}

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

/// Quantities arrive with the unit's full precision ("1.0000"); show them without trailing zeros.
String chatQuantity(String value) {
  if (!value.contains('.')) return value;
  final trimmed = value
      .replaceFirst(RegExp(r'0+$'), '')
      .replaceFirst(RegExp(r'\.$'), '');
  return trimmed.isEmpty ? '0' : trimmed;
}

/// "PARTIALLY_PAID" -> "Partially paid".
String chatSentence(String value) {
  final words = value.replaceAll('_', ' ').toLowerCase();
  return words.isEmpty ? words : words[0].toUpperCase() + words.substring(1);
}

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
    this.loadImage,
    this.onSaveImage,
  });
  final api.ChatMessage message;
  final ValueChanged<api.ChatAttachment> onOpenFile;
  final bool busy;
  final ValueChanged<String>? onOpenProduct;

  /// Loads a clean image attachment's private bytes for an inline preview; it should return
  /// the same cached future for the same attachment. Null shows images as file rows.
  final Future<Uint8List> Function(api.ChatAttachment)? loadImage;
  final ValueChanged<api.ChatAttachment>? onSaveImage;

  /// The server's placeholder body for an attachment-only message adds nothing to a preview.
  bool get _placeholderBody =>
      message.kind.name == 'ATTACHMENT' &&
      message.body == 'Attachment' &&
      message.attachments.isNotEmpty;

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
                  if (m.body.isNotEmpty && !_placeholderBody)
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
                    if (loadImage != null &&
                        file.scanState.name == 'CLEAN' &&
                        file.mediaType.startsWith('image/'))
                      ChatImageAttachment(
                        file: file,
                        bytes: loadImage!(file),
                        busy: busy,
                        onOpen: () => onOpenFile(file),
                        onSave: onSaveImage == null
                            ? null
                            : () => onSaveImage!(file),
                      )
                    else
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

/// A clean chat photo shown inline from its private bytes (never a public URL). Tapping it
/// opens the zoomable preview; Download saves a copy to the device.
class ChatImageAttachment extends StatelessWidget {
  const ChatImageAttachment({
    super.key,
    required this.file,
    required this.bytes,
    required this.onOpen,
    this.onSave,
    this.busy = false,
  });

  final api.ChatAttachment file;
  final Future<Uint8List> bytes;
  final VoidCallback onOpen;
  final VoidCallback? onSave;
  final bool busy;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        FutureBuilder<Uint8List>(
          future: bytes,
          builder: (context, snapshot) {
            final data = snapshot.data;
            final Widget child;
            if (data != null) {
              child = Image.memory(
                data,
                fit: BoxFit.cover,
                cacheWidth: 720,
                gaplessPlayback: true,
                errorBuilder: (_, _, _) => const _ImageNotice(
                  icon: Icons.broken_image_outlined,
                  text: 'This image could not be displayed.',
                ),
              );
            } else if (snapshot.hasError) {
              child = const _ImageNotice(
                icon: Icons.image_not_supported_outlined,
                text: 'Image unavailable. Tap to retry.',
              );
            } else {
              child = const Center(
                child: SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }
            return Semantics(
              button: true,
              image: true,
              label: 'Photo ${file.displayName}. Open preview',
              excludeSemantics: true,
              child: Material(
                color: BuyerTheme.canvas,
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: busy ? null : onOpen,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 160,
                      minHeight: 120,
                      maxHeight: 260,
                    ),
                    child: child,
                  ),
                ),
              ),
            );
          },
        ),
        if (onSave != null)
          TextButton.icon(
            onPressed: busy ? null : onSave,
            style: TextButton.styleFrom(minimumSize: const Size(44, 44)),
            icon: const Icon(Icons.download_outlined, size: 20),
            label: const Text('Download'),
          ),
      ],
    ),
  );
}

class _ImageNotice extends StatelessWidget {
  const _ImageNotice({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: BuyerTheme.muted),
        const SizedBox(height: 6),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
        ),
      ],
    ),
  );
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
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
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
            version.state == 'VIEWED' && version.viewed
                ? 'Viewed by Buyer'
                : '${chatSentence(version.state)} · ${version.viewed ? 'Viewed by Buyer' : 'Not yet viewed'}',
            style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
          ),
          const Divider(height: 28),
          QuotationMaterialLines(lines: c.lines),
          QuotationPaymentBreakdown(
            content: c,
            selectedPaymentMethod: version.selectedPaymentMethod,
            accepted: version.state == 'ACCEPTED',
          ),
          QuotationDeliveryTerms(content: c),
          const Divider(height: 28),
          QuotationChangeList(
            notes: importantQuotationChanges(c, c.changes),
            emptyLabel: version.version == 1
                ? 'Matches the products, prices and schedule you requested.'
                : 'No change to products, prices or schedule from the previous version.',
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

/// A quotation the Buyer can still respond to: the latest version, not yet accepted or expired,
/// with a decision available.
bool quotationIsActive(api.ChatQuotationVersion version) =>
    version.latest &&
    version.state != 'ACCEPTED' &&
    version.actions.any((action) => action != 'view') &&
    DateTime.parse(version.expiresAt).isAfter(DateTime.now());

String quotationStatusLabel(api.ChatQuotationVersion version) {
  if (version.state == 'ACCEPTED') return 'Accepted';
  if (!version.latest || version.state == 'SUPERSEDED') return 'Superseded';
  if (quotationIsActive(version)) return 'Awaiting your response';
  if (!DateTime.parse(version.expiresAt).isAfter(DateTime.now())) {
    return 'Expired';
  }
  return chatSentence(version.state);
}

/// A shared quotation summary for the history list and conversation timeline.
class QuotationSummaryTile extends StatelessWidget {
  const QuotationSummaryTile({
    super.key,
    required this.version,
    required this.onOpen,
  });

  final api.ChatQuotationVersion version;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final active = quotationIsActive(version);
    final status = quotationStatusLabel(version);
    final total = chatMoney(version.content.commercial.commercialTotalCentavos);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: active ? BuyerTheme.brandSoft : BuyerTheme.canvas,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: active ? BuyerTheme.action : BuyerTheme.border,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          minVerticalPadding: 12,
          leading: const Icon(LucideIcons.fileText, color: BuyerTheme.action),
          title: Text(
            'Requested quotation v${version.version}',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                '$status · $total',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  color: active ? BuyerTheme.action : BuyerTheme.muted,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${chatDate(version.publishedAt)} · ${chatTime(version.publishedAt)} Manila',
                style: const TextStyle(fontSize: 11, color: BuyerTheme.muted),
              ),
            ],
          ),
          trailing: const Icon(
            LucideIcons.chevronRight,
            size: 20,
            color: BuyerTheme.muted,
          ),
          onTap: onOpen,
        ),
      ),
    );
  }
}

/// A quotation stays at its publication time and opens its full terms on tap.
class QuotationThreadButton extends StatelessWidget {
  const QuotationThreadButton({
    super.key,
    required this.version,
    required this.onOpen,
  });

  final api.ChatQuotationVersion version;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: QuotationSummaryTile(version: version, onOpen: onOpen),
    ),
  );
}

/// One decision-relevant difference in a quotation: a product, price, schedule or fee the Vendor
/// changed. Internal identifiers and derived figures never become notes.
class QuotationChangeNote {
  const QuotationChangeNote(this.title, {this.before, this.after});
  final String title;
  final String? before;
  final String? after;
}

const _fulfillmentLabels = {
  'PICKUP': 'Self-Pickup',
  'DELIVERY': 'Site Delivery',
  'BOTH': 'Self-Pickup or Site Delivery',
};
const _paymentLabels = {
  'ONLINE': 'Online payment',
  'CASH_ON_DELIVERY': 'Cash on Delivery',
  'IN_STORE': 'Pay in store',
};

/// Reduces the server's field-level diff to what a Buyer decides on: products added or removed,
/// quantity, brand, specification and unit price per product, fulfillment, date, payment method,
/// delivery fee, discount and NRPC. Everything else (line, listing, price-version and tax-version
/// identifiers, load dimensions, totals the card already shows) is dropped.
List<QuotationChangeNote> importantQuotationChanges(
  api.ChatQuotationContent content,
  Iterable<api.ChatQuotationChange> changes,
) {
  final notes = <QuotationChangeNote>[];
  final seen = <String>{};
  final wholeLine = RegExp(r'^lines\.(\d+)$');
  final lineField = RegExp(r'^lines\.(\d+)\.([^.]+)');

  String? money(Object? value) {
    if (value == null) return null;
    final centavos = int.tryParse('$value');
    return centavos == null ? '$value' : chatMoney(centavos);
  }

  void add(QuotationChangeNote note) {
    if (seen.add('${note.title}|${note.before}|${note.after}')) notes.add(note);
  }

  for (final change in changes) {
    final path = change.path;
    final before = change.before?.value;
    final after = change.after?.value;
    final line = wholeLine.firstMatch(path);
    if (line != null) {
      final source = before ?? after;
      final map = source is Map ? source : null;
      final name =
          '${map?['description'] ?? 'Product ${int.parse(line[1]!) + 1}'}';
      final quantity = map == null
          ? null
          : '${chatQuantity('${map['quantity']}')} ${map['unit_code'] ?? ''}'
                .trim();
      add(
        QuotationChangeNote(
          before == null ? 'Added · $name' : 'Removed · $name',
          after: quantity,
        ),
      );
      continue;
    }
    final field = lineField.firstMatch(path);
    if (field != null) {
      final index = int.parse(field[1]!);
      final known = index < content.lines.length ? content.lines[index] : null;
      final name = known?.description ?? 'Product ${index + 1}';
      final unit = known?.unitCode ?? '';
      String quantity(Object? value) =>
          '${chatQuantity('$value')} $unit'.trim();
      switch (field[2]) {
        case 'quantity':
          add(
            QuotationChangeNote(
              '$name · Quantity',
              before: before == null ? null : quantity(before),
              after: after == null ? null : quantity(after),
            ),
          );
        case 'unit_price_centavos':
          add(
            QuotationChangeNote(
              '$name · Unit price',
              before: money(before),
              after: money(after),
            ),
          );
        case 'description':
          add(
            QuotationChangeNote(
              '$name · Item',
              before: before == null ? null : '$before',
              after: after == null ? null : '$after',
            ),
          );
        case 'preferred_brand':
          add(
            QuotationChangeNote(
              '$name · Brand',
              before: before == null ? null : '$before',
              after: after == null ? null : '$after',
            ),
          );
        case 'specifications':
          add(QuotationChangeNote('$name · Specifications updated'));
      }
      continue;
    }
    switch (path) {
      case 'fulfillment_method':
        add(
          QuotationChangeNote(
            'Fulfillment',
            before: _fulfillmentLabels['$before'] ?? _optional(before),
            after: _fulfillmentLabels['$after'] ?? _optional(after),
          ),
        );
      case 'fulfillment_date':
        add(
          QuotationChangeNote(
            'Fulfillment date',
            before: _optional(before),
            after: _optional(after),
          ),
        );
      case 'payment_method':
        add(
          QuotationChangeNote(
            'Payment method',
            before: _paymentLabels['$before'] ?? _optional(before),
            after: _paymentLabels['$after'] ?? _optional(after),
          ),
        );
      case 'delivery':
        add(
          after == null
              ? const QuotationChangeNote('Delivery removed')
              : QuotationChangeNote(
                  'Delivery fee',
                  after: chatMoney(content.commercial.deliveryCentavos),
                ),
        );
      case 'delivery.final_charge_centavos' || 'delivery.final_fee_centavos':
        add(
          QuotationChangeNote(
            'Delivery fee',
            before: money(before),
            after: money(after),
          ),
        );
      case 'discount':
        add(
          QuotationChangeNote(
            'Vendor discount',
            after: after is Map ? '${after['percent']}%' : null,
          ),
        );
      case 'discount.percent':
        add(
          QuotationChangeNote(
            'Vendor discount',
            before: before == null ? null : '$before%',
            after: after == null ? null : '$after%',
          ),
        );
      case 'nrpc':
        add(
          QuotationChangeNote(
            'NRPC',
            after: after == null
                ? null
                : chatMoney(content.commercial.nrpcCentavos),
          ),
        );
      case 'nrpc.amount_centavos':
        add(
          QuotationChangeNote(
            'NRPC',
            before: money(before),
            after: money(after),
          ),
        );
    }
  }
  return notes;
}

String? _optional(Object? value) => value == null ? null : '$value';

/// The compact "What changed" list: only [QuotationChangeNote]s, long lists folded behind a toggle.
class QuotationChangeList extends StatefulWidget {
  const QuotationChangeList({
    super.key,
    required this.notes,
    required this.emptyLabel,
    this.collapsedCount = 5,
  });
  final List<QuotationChangeNote> notes;
  final String emptyLabel;
  final int collapsedCount;

  @override
  State<QuotationChangeList> createState() => _QuotationChangeListState();
}

class _QuotationChangeListState extends State<QuotationChangeList> {
  bool _all = false;

  @override
  Widget build(BuildContext context) {
    final notes = widget.notes;
    final folded = !_all && notes.length > widget.collapsedCount;
    final shown = folded ? notes.take(widget.collapsedCount) : notes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          notes.isEmpty ? 'What changed' : 'What changed · ${notes.length}',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        if (notes.isEmpty)
          Text(
            widget.emptyLabel,
            style: const TextStyle(fontSize: 13, color: BuyerTheme.muted),
          ),
        for (final note in shown)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Semantics(
              container: true,
              label: [
                note.title,
                if (note.before != null && note.after != null)
                  'changed from ${note.before} to ${note.after}'
                else if (note.after != null)
                  note.after!
                else if (note.before != null)
                  'was ${note.before}',
              ].join(', '),
              excludeSemantics: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (note.before != null || note.after != null)
                    Text.rich(
                      TextSpan(
                        children: [
                          if (note.before != null)
                            TextSpan(
                              text: note.before,
                              style: const TextStyle(
                                color: BuyerTheme.muted,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          if (note.before != null && note.after != null)
                            const TextSpan(
                              text: '  →  ',
                              style: TextStyle(color: BuyerTheme.muted),
                            ),
                          if (note.after != null)
                            TextSpan(
                              text: note.after,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                        ],
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                ],
              ),
            ),
          ),
        if (notes.length > widget.collapsedCount)
          TextButton(
            onPressed: () => setState(() => _all = !_all),
            child: Text(
              _all ? 'Show fewer' : 'Show all ${notes.length} changes',
            ),
          ),
      ],
    );
  }
}
