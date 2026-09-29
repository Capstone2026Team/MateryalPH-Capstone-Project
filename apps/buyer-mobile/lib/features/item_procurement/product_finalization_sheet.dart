import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';
import 'procurement_models.dart';

String _label(String key) {
  final text = key.replaceAll('_', ' ');
  return text.isEmpty ? text : '${text[0].toUpperCase()}${text.substring(1)}';
}

class _Label extends StatelessWidget {
  const _Label(this.text, {this.bottom = 6});

  final String text;
  final double bottom;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: bottom),
    child: Semantics(
      header: true,
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
    ),
  );
}

class ProductFinalizationSheet extends StatefulWidget {
  const ProductFinalizationSheet({
    super.key,
    required this.detail,
    required this.variantId,
    required this.quantity,
    required this.fulfillment,
    required this.buy,
    required this.onConfirm,
  });
  final ListingDetailView Function() detail;
  final String variantId;
  final int quantity;
  final String? fulfillment;
  final bool buy;
  final Future<String?> Function(
    String variantId,
    int quantity,
    String? fulfillment,
  )
  onConfirm;
  @override
  State<ProductFinalizationSheet> createState() =>
      _ProductFinalizationSheetState();
}

class _ProductFinalizationSheetState extends State<ProductFinalizationSheet> {
  late String _variantId = widget.variantId;
  late int _quantity = widget.quantity;
  late String? _fulfillment = widget.fulfillment;
  bool _busy = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final detail = widget.detail();
    final variant = detail.variants
        .where((item) => item.variantId == _variantId)
        .firstOrNull;
    final price = variant?.priceForQuantity(_quantity);
    return PopScope(
      canPop: !_busy,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            8,
            16,
            16 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 72,
                        height: 72,
                        color: BuyerTheme.canvas,
                        child: detail.images.isEmpty
                            ? const Icon(
                                LucideIcons.package,
                                color: BuyerTheme.muted,
                              )
                            : Image.network(
                                detail.images.first.url,
                                fit: BoxFit.cover,
                                cacheWidth: 240,
                                errorBuilder: (_, _, _) =>
                                    const Icon(LucideIcons.imageOff),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Semantics(
                            header: true,
                            child: Text(
                              detail.displayName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (variant != null && price != null)
                            Text(
                              '${formatPeso(price)} / ${variant.unitName}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: BuyerTheme.action,
                              ),
                            ),
                          if (variant != null)
                            StockLabelText(
                              label: variant.stockLabel,
                              compact: true,
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close',
                      onPressed: _busy
                          ? null
                          : () => Navigator.pop(context, false),
                      icon: const Icon(LucideIcons.x),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  decoration: BoxDecoration(
                    color: BuyerTheme.canvas,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: BuyerTheme.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Selected specification',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (variant != null)
                        SpecificationRow('Option', variant.label),
                      for (final entry in {
                        ...detail.attributes,
                        ...?variant?.attributes,
                      }.entries)
                        SpecificationRow(_label(entry.key), entry.value),
                      if (variant?.sku != null)
                        SpecificationRow('SKU', variant!.sku!),
                      if (variant != null)
                        SpecificationRow(
                          'Quantity',
                          '$_quantity ${variant.unitName}',
                        ),
                      if (variant != null && price != null)
                        SpecificationRow(
                          'Unit price',
                          '${formatPeso(price)} / ${variant.unitName}',
                        ),
                      if (_fulfillment != null)
                        SpecificationRow(
                          'Delivery mode',
                          _fulfillment == 'PICKUP'
                              ? 'Self-Pickup'
                              : 'Site Delivery',
                        ),
                      if (price != null) ...[
                        const Divider(height: 12),
                        SpecificationRow(
                          'Total amount',
                          formatPeso(price * _quantity),
                          strong: true,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const _Label('Options'),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final option in detail.variants)
                      FilterPill(
                        label: option.label,
                        maxLines: 2,
                        selected: _variantId == option.variantId,
                        onTap: _busy || !option.available
                            ? null
                            : () => setState(() {
                                _variantId = option.variantId;
                                _error = null;
                              }),
                      ),
                  ],
                ),
                if (variant != null) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    children: [
                      const _Label('Quantity', bottom: 0),
                      QuantityStepper(
                        compact: true,
                        quantity: _quantity,
                        unitName: variant.unitName,
                        enabled: !_busy && variant.available,
                        onChanged: (value) => setState(() {
                          _quantity = value;
                          _error = null;
                        }),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                const _Label('Delivery mode'),
                Wrap(
                  spacing: 8,
                  children: [
                    if (detail.pickupAvailable)
                      FilterPill(
                        label: 'Self-Pickup',
                        selected: _fulfillment == 'PICKUP',
                        onTap: _busy
                            ? null
                            : () => setState(() => _fulfillment = 'PICKUP'),
                      ),
                    if (detail.deliveryOffered)
                      FilterPill(
                        label: 'Site Delivery',
                        selected: _fulfillment == 'DELIVERY',
                        onTap: _busy
                            ? null
                            : () => setState(() => _fulfillment = 'DELIVERY'),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Stock and price are checked when you continue. Delivery is confirmed separately.',
                  style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
                ),
                if (widget.buy)
                  const Text(
                    'Checkout reviews this variant. Other cart items remain saved for later.',
                    style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
                  ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: StatusBand(tone: BandTone.warning, title: _error!),
                  ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed:
                      _busy ||
                          variant?.available != true ||
                          !detail.purchasable ||
                          _fulfillment == null
                      ? null
                      : () async {
                          setState(() {
                            _busy = true;
                            _error = null;
                          });
                          final error = await widget.onConfirm(
                            _variantId,
                            _quantity,
                            _fulfillment,
                          );
                          if (!mounted) return;
                          setState(() {
                            _busy = false;
                            _error = error;
                          });
                          if (error == null && context.mounted) {
                            Navigator.pop(context, true);
                          }
                        },
                  child: _busy
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(widget.buy ? 'Checkout' : 'Add to Cart'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
