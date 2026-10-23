import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import 'cart_controller.dart';
import 'delivery_widgets.dart';
import 'procurement_models.dart';
import 'procurement_repository.dart';

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
    required this.repository,
    required this.cart,
    required this.savedLocations,
    this.chooseDropOff,
  });
  final ProcurementRepository repository;
  final CartController cart;
  final List<SavedLocationView> Function() savedLocations;
  final Future<DiscoveryOrigin?> Function(
    BuildContext context, {
    required bool useCurrent,
  })?
  chooseDropOff;
  final ListingDetailView Function() detail;
  final String variantId;

  /// Decimal quantity text; ready-mixed concrete is a volume in m³.
  final String quantity;
  final String? fulfillment;
  final bool buy;
  final Future<String?> Function(
    String variantId,
    String quantity,
    String? fulfillment,
  )
  onConfirm;
  @override
  State<ProductFinalizationSheet> createState() =>
      _ProductFinalizationSheetState();
}

class _ProductFinalizationSheetState extends State<ProductFinalizationSheet> {
  late String _variantId = widget.variantId;
  late String _quantity = widget.quantity;
  late String? _fulfillment = widget.fulfillment;
  bool _busy = false;
  String? _error;
  DeliveryPreviewView? _delivery;
  String? _deliveryError;
  bool _deliveryLoading = false;
  Timer? _deliveryDebounce;
  int _deliverySequence = 0;
  int? _cartVersion;

  @override
  void initState() {
    super.initState();
    _cartVersion = widget.cart.cart?.lockVersion;
    widget.cart.addListener(_cartChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await widget.cart.load();
      if (mounted) _refreshDelivery();
    });
  }

  void _cartChanged() {
    if (!mounted) return;
    final version = widget.cart.cart?.lockVersion;
    if (_cartVersion != version) {
      _cartVersion = version;
      _refreshDelivery();
    }
    setState(() {});
  }

  Future<void> _refreshDelivery() async {
    _deliveryDebounce?.cancel();
    final sequence = ++_deliverySequence;
    setState(() {
      _delivery = null;
      _deliveryError = null;
      _deliveryLoading =
          _fulfillment == 'DELIVERY' && validDecimalQuantity(_quantity, 4);
    });
    if (!_deliveryLoading) return;
    _deliveryDebounce = Timer(const Duration(milliseconds: 300), () async {
      try {
        final result = await widget.repository.productDeliveryPreview(
          variantId: _variantId,
          quantity: _quantity,
        );
        if (!mounted || sequence != _deliverySequence) return;
        setState(() => _delivery = result);
      } on DiscoveryFailure catch (error) {
        if (!mounted || sequence != _deliverySequence) return;
        setState(() => _deliveryError = error.message);
      } finally {
        if (mounted && sequence == _deliverySequence) {
          setState(() => _deliveryLoading = false);
        }
      }
    });
  }

  void _setQuantity(Object value) {
    setState(() {
      _quantity = '$value';
      _error = null;
    });
    _refreshDelivery();
  }

  @override
  void dispose() {
    _deliverySequence++;
    _deliveryDebounce?.cancel();
    widget.cart.removeListener(_cartChanged);
    super.dispose();
  }

  String _range(int min, int max) =>
      min == max ? formatPeso(min) : '${formatPeso(min)}–${formatPeso(max)}';

  @override
  Widget build(BuildContext context) {
    final detail = widget.detail();
    final variant = detail.variants
        .where((item) => item.variantId == _variantId)
        .firstOrNull;
    final quantity = validDecimalQuantity(_quantity, 4) ? _quantity : null;
    final price = quantity == null
        ? null
        : variant?.priceForQuantity(num.parse(quantity));
    final materials = price == null
        ? null
        : lineAmountCentavos(quantity!, price);
    final readyMixed = detail.readyMixed;
    final estimate = _fulfillment == 'DELIVERY' ? _delivery?.estimate : null;
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
                        SpecificationRow(
                          detail.attributeLabel(entry.key),
                          entry.value,
                        ),
                      if (variant?.sku != null)
                        SpecificationRow('SKU', variant!.sku!),
                      if (variant != null)
                        SpecificationRow(
                          'Quantity',
                          quantity == null
                              ? 'Not entered'
                              : '${formatQuantity(quantity)} ${variant.unitName}',
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
                      if (materials != null) ...[
                        if (_fulfillment == 'DELIVERY') ...[
                          SpecificationRow(
                            'Materials subtotal',
                            formatPeso(materials),
                          ),
                          SpecificationRow(
                            'Estimated delivery fee',
                            _deliveryLoading
                                ? 'Calculating…'
                                : estimate == null
                                ? 'Estimate unavailable'
                                : _range(
                                    estimate.feeMinCentavos,
                                    estimate.feeMaxCentavos,
                                  ),
                          ),
                        ],
                        const Divider(height: 12),
                        SpecificationRow(
                          estimate != null
                              ? 'Estimated total'
                              : _fulfillment == 'DELIVERY'
                              ? 'Total before delivery'
                              : 'Total amount',
                          estimate == null
                              ? formatPeso(materials)
                              : _range(
                                  materials + estimate.feeMinCentavos,
                                  materials + estimate.feeMaxCentavos,
                                ),
                          strong: true,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _Label(readyMixed?.strengthLabel ?? 'Options'),
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
                            : () {
                                setState(() {
                                  _variantId = option.variantId;
                                  _error = null;
                                });
                                _refreshDelivery();
                              },
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
                      if (variant.wholeUnits) ...[
                        const _Label('Quantity', bottom: 0),
                        QuantityStepper(
                          compact: true,
                          quantity: int.tryParse(_quantity) ?? 1,
                          unitName: variant.unitName,
                          enabled: !_busy && variant.available,
                          onChanged: _setQuantity,
                        ),
                      ] else
                        DecimalQuantityField(
                          label: readyMixed?.quantityLabel ?? 'Quantity',
                          value: _quantity,
                          unitName: variant.unitName,
                          decimals: stepDecimals(variant.quantityStep),
                          enabled: !_busy && variant.available,
                          onChanged: _setQuantity,
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
                            : () {
                                setState(() => _fulfillment = 'PICKUP');
                                _refreshDelivery();
                              },
                      ),
                    if (detail.deliveryOffered)
                      FilterPill(
                        label: 'Site Delivery',
                        selected: _fulfillment == 'DELIVERY',
                        onTap: _busy
                            ? null
                            : () {
                                setState(() => _fulfillment = 'DELIVERY');
                                _refreshDelivery();
                              },
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                if (readyMixed != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      readyMixed.notice,
                      style: const TextStyle(
                        fontSize: 12,
                        color: BuyerTheme.muted,
                      ),
                    ),
                  ),
                if (_fulfillment == 'DELIVERY') ...[
                  if (widget.cart.cart != null)
                    CartDestinationSection(
                      controller: widget.cart,
                      destination: widget.cart.cart!.destination,
                      savedLocations: widget.savedLocations(),
                      chooseDropOff: widget.chooseDropOff,
                      onSaved: _refreshDelivery,
                    )
                  else if (widget.cart.failure != null)
                    StatusBand(
                      tone: BandTone.warning,
                      title: widget.cart.failure!.message,
                      action: TextButton(
                        onPressed: widget.cart.load,
                        child: const Text('Retry destination'),
                      ),
                    ),
                  if (_deliveryLoading) const LinearProgressIndicator(),
                  if (_delivery != null)
                    DeliveryPreviewPanel(delivery: _delivery!),
                  if (_deliveryError != null || _delivery?.status == 'BLOCKED')
                    StatusBand(
                      tone: BandTone.warning,
                      title:
                          _deliveryError ??
                          'Review the delivery details or retry the calculation.',
                      action: TextButton(
                        onPressed: _refreshDelivery,
                        child: const Text('Retry delivery estimate'),
                      ),
                    ),
                  const SizedBox(height: 8),
                ],
                const Text(
                  'Stock and price are checked when you continue. Estimated totals include delivery when available; the payment processing fee is shown at payment. The Vendor confirms the final delivery fee before you pay.',
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
                          widget.cart.busy ||
                          (widget.buy && _deliveryLoading) ||
                          variant?.available != true ||
                          quantity == null ||
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
