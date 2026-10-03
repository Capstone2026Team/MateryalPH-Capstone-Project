import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/procurement_components.dart';
import '../../design_system/generated/color_tokens.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import '../map_discovery/discovery_repository.dart' show newIdempotencyKey;
import 'cart_controller.dart';
import 'explore_controller.dart';
import 'procurement_models.dart';
import 'procurement_navigation.dart';
import 'procurement_repository.dart';
import 'product_finalization_sheet.dart';

/// Product Details for one Tier 2 listing. Add to Cart records the price version shown here; the
/// server rejects a changed price instead of silently accepting it. Nothing here reserves stock.
class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({
    super.key,
    required this.listingId,
    required this.repository,
    required this.explore,
    required this.cart,
    required this.navigation,
  });

  final String listingId;
  final ProcurementRepository repository;
  final ExploreController explore;
  final CartController cart;
  final ProcurementNavigation navigation;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  ListingDetailView? _detail;
  DiscoveryFailure? _failure;
  bool _loading = true;
  bool _adding = false;
  String? _variantId;
  int _quantity = 1;
  String? _fulfillment;
  String? _notice;
  bool _favorite = false;
  bool _descriptionExpanded = false;
  int _tab = 0;
  bool _finalizing = false;
  String? _pendingAddPayload;

  /// One key per add attempt, reused for its retries so a retry never adds twice.
  String? _pendingAddKey;

  @override
  void initState() {
    super.initState();
    _load();
    widget.explore.addListener(_syncFavorite);
  }

  void _syncFavorite() {
    final detail = _detail;
    if (detail == null || !mounted) return;
    setState(
      () => _favorite =
          widget.explore.discovery.favoriteUpdates[detail.vendorId] ??
          _favorite,
    );
  }

  @override
  void dispose() {
    widget.explore.removeListener(_syncFavorite);
    super.dispose();
  }

  Future<void> _finalize({required bool buy}) async {
    final variant = _variant;
    if (_finalizing || variant == null) return;
    _finalizing = true;
    String? addedConfiguration;
    final completed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => ProductFinalizationSheet(
        detail: () => _detail!,
        variantId: variant.variantId,
        quantity: _quantity,
        fulfillment: _fulfillment,
        buy: buy,
        onConfirm: (variantId, quantity, fulfillment) async {
          setState(() {
            _variantId = variantId;
            _quantity = quantity;
            _fulfillment = fulfillment;
          });
          final configuration = '$variantId|$quantity|$fulfillment';
          if (addedConfiguration != configuration) {
            await _addToCart();
            if (_notice != null) return _notice;
            addedConfiguration = configuration;
          }
          if (buy) {
            final line = widget.cart.cart?.groups
                .expand((group) => group.lines)
                .where((line) => line.variantId == variantId)
                .firstOrNull;
            if (line == null) {
              return 'Review this item in your cart before continuing.';
            }
            if (formatQuantity(line.quantity) != '$quantity') {
              await widget.cart.changeQuantity(line, '$quantity');
              if (widget.cart.notice != null) return widget.cart.notice;
            }
          }
          if (buy && !await widget.cart.selectOnlyVariant(variantId)) {
            return widget.cart.notice ?? 'Review your cart before continuing.';
          }
          return null;
        },
      ),
    );
    _finalizing = false;
    if (completed == true && buy && mounted) {
      await widget.navigation.openCheckout(context);
    }
  }

  Future<void> _load() async {
    final origin = widget.explore.origin;
    if (origin == null) {
      setState(() {
        _loading = false;
        _failure = const DiscoveryFailure(
          DiscoveryFailureKind.validation,
          'Choose a location on the Map first.',
        );
      });
      return;
    }
    setState(() {
      _loading = true;
      _failure = null;
    });
    try {
      final detail = await widget.repository.listing(
        listingId: widget.listingId,
        origin: origin,
        radiusKm: widget.explore.radiusKm,
      );
      if (!mounted) return;
      final available = detail.variants.where((variant) => variant.available);
      setState(() {
        _detail = detail;
        _favorite =
            widget.explore.discovery.favoriteUpdates[detail.vendorId] ??
            detail.isFavorite;
        _variantId = available.any((variant) => variant.variantId == _variantId)
            ? _variantId
            : available.isEmpty
            ? null
            : available.first.variantId;
        _fulfillment ??= detail.pickupAvailable && !detail.deliveryOffered
            ? 'PICKUP'
            : !detail.pickupAvailable && detail.deliveryOffered
            ? 'DELIVERY'
            : null;
        _loading = false;
      });
    } on DiscoveryFailure catch (error) {
      if (!mounted) return;
      setState(() {
        _failure = error;
        _loading = false;
      });
    }
  }

  VariantOfferView? get _variant {
    final detail = _detail;
    if (detail == null) return null;
    for (final variant in detail.variants) {
      if (variant.variantId == _variantId) return variant;
    }
    return null;
  }

  Future<void> _toggleFavorite() async {
    final detail = _detail;
    if (detail == null || widget.explore.favoriteBusy(detail.vendorId)) return;
    final next = !_favorite;
    setState(() => _favorite = next);
    try {
      await widget.explore.setFavorite(detail.vendorId, favorite: next);
      // A Favorite is personal: it marks cards but never re-ranks Best Deal.
      widget.explore.markFavorite(detail.vendorId, favorite: next);
    } on DiscoveryFailure catch (error) {
      if (!mounted) return;
      setState(() {
        _favorite = !next;
        _notice = error.message;
      });
    }
  }

  Future<void> _addToCart() async {
    if (_adding) return;
    final detail = _detail;
    final variant = _variant;
    final origin = widget.explore.origin;
    if (detail == null ||
        variant == null ||
        origin == null ||
        variant.priceVersionId == null) {
      setState(
        () => _notice =
            'This selection is no longer available. Refresh the product.',
      );
      return;
    }
    if (detail.pickupAvailable &&
        detail.deliveryOffered &&
        _fulfillment == null) {
      setState(
        () => _notice = 'Choose Site Delivery or Self-Pickup before adding.',
      );
      return;
    }
    final payload =
        '${variant.variantId}|${variant.priceVersionId}|$_quantity|$_fulfillment|${origin.identity}|${widget.explore.radiusKm}';
    if (_pendingAddPayload != payload) _pendingAddKey = null;
    _pendingAddPayload = payload;
    final key = _pendingAddKey ??= newIdempotencyKey();
    setState(() {
      _adding = true;
      _notice = null;
    });
    try {
      final cart = await widget.repository.addToCart(
        variantId: variant.variantId,
        expectedPriceVersionId: variant.priceVersionId!,
        quantity: '$_quantity',
        origin: origin,
        radiusKm: widget.explore.radiusKm,
        idempotencyKey: key,
        fulfillmentMethod: _fulfillment,
      );
      _pendingAddKey = null;
      widget.cart.replace(cart);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Added to cart. Nothing is reserved until the Vendor confirms.',
          ),
          action: SnackBarAction(
            label: 'View cart',
            onPressed: () => widget.navigation.openCart(context),
          ),
        ),
      );
    } on DiscoveryFailure catch (error) {
      if (!mounted) return;
      if (error.kind != DiscoveryFailureKind.offline &&
          error.kind != DiscoveryFailureKind.provider) {
        // Only an unconfirmed network attempt may reuse its key; any server decision ends it.
        _pendingAddKey = null;
      }
      setState(() => _notice = error.message);
      if (error.code == 'PRICE_CHANGED' ||
          error.code == 'LISTING_UNAVAILABLE') {
        await _load();
        if (mounted) setState(() => _notice = error.message);
      }
    } finally {
      if (mounted) setState(() => _adding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = _detail;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: detail == null ? null : _actions(detail),
      body: SafeArea(bottom: false, child: _body()),
    );
  }

  /// Back, store and cart controls; drawn over the photo so the product fills the top.
  Widget _topBar(ListingDetailView? detail) => ListenableBuilder(
    listenable: widget.cart,
    builder: (context, _) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          RoundIconButton(
            icon: LucideIcons.arrowLeft,
            tooltip: 'Back',
            filled: true,
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const Spacer(),
          if (detail != null)
            RoundIconButton(
              icon: LucideIcons.mapPin,
              tooltip: 'Open Store Profile for ${detail.vendorName}',
              onPressed: () =>
                  widget.navigation.openStoreProfile(context, detail.vendorId),
            ),
          RoundIconButton(
            icon: LucideIcons.shoppingCart,
            tooltip: 'Cart',
            badgeCount: widget.cart.lineCount,
            onPressed: () => widget.navigation.openCart(context),
          ),
        ],
      ),
    ),
  );

  Widget _body() {
    if (_loading && _detail == null) {
      return ListView(
        children: [
          _topBar(null),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(height: 240),
                SizedBox(height: 16),
                SkeletonBox(height: 24, width: 240),
                SizedBox(height: 8),
                SkeletonBox(height: 20, width: 140),
              ],
            ),
          ),
        ],
      );
    }
    final failure = _failure;
    if (_detail == null) {
      return ListView(
        children: [
          _topBar(null),
          StateMessage(
            kind: failure?.kind == DiscoveryFailureKind.offline
                ? StateKind.offline
                : failure?.kind == DiscoveryFailureKind.notFound
                ? StateKind.empty
                : StateKind.error,
            title: failure?.kind == DiscoveryFailureKind.notFound
                ? 'This product is no longer available'
                : 'Product details could not load',
            message: failure?.message ?? 'Please retry.',
            actionLabel: failure?.kind == DiscoveryFailureKind.notFound
                ? 'Back to results'
                : 'Retry',
            onAction: failure?.kind == DiscoveryFailureKind.notFound
                ? () => Navigator.of(context).maybePop()
                : _load,
          ),
        ],
      );
    }
    final detail = _detail!;
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Stack(
            children: [
              _Gallery(images: detail.images),
              Positioned(left: 0, right: 0, top: 0, child: _topBar(detail)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: SegmentedTabs(
              labels: const ['Overview', 'Related', 'Reviews'],
              selected: _tab,
              onChanged: (index) => setState(() => _tab = index),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: switch (_tab) {
                1 => _related(detail),
                2 => _reviews(detail),
                _ => _overview(detail),
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _overview(ListingDetailView detail) {
    final variant = _variant;
    final sold = formatQuantity(detail.unitsSold);
    return [
      const SizedBox(height: 8),
      Wrap(
        spacing: 10,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (detail.deliveryOffered)
            _FulfillmentNote(
              icon: LucideIcons.truck,
              text: detail.delivery == 'WITHIN_STATED_AREA'
                  ? 'Site Delivery'
                  : 'Site Delivery (outside stated area)',
            ),
          if (detail.pickupAvailable)
            const _FulfillmentNote(
              icon: LucideIcons.store,
              text: 'Self-Pickup',
            ),
          if (detail.complianceBadge != null)
            const ListingBadge(code: 'PS_ICC_VERIFIED', solid: true),
        ],
      ),
      const SizedBox(height: 10),
      Text(
        detail.displayName,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
      ),
      if (detail.brand != null || detail.categoryName != null)
        Text(
          [?detail.brand, ?detail.categoryName].join(' · '),
          style: const TextStyle(fontSize: 13, color: BuyerTheme.muted),
        ),
      const SizedBox(height: 8),
      if (variant?.unitPriceCentavos != null)
        Text(
          '${formatPeso(variant!.unitPriceCentavos!)} / ${variant.unitName}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: BuyerTheme.action,
          ),
        ),
      if (variant?.vatLabel != null)
        Text(
          variant!.includedVatCentavos != null &&
                  variant.includedVatCentavos! > 0
              ? '${variant.vatLabel} · includes ${formatPeso(variant.includedVatCentavos!)} VAT'
              : variant.vatLabel!,
          style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
        ),
      const SizedBox(height: 6),
      Wrap(
        spacing: 12,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          StockLabelText(label: variant?.stockLabel),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                LucideIcons.star,
                size: 15,
                color: Color(MateryalColorTokens.statusWarning),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  '${detail.ratingLabel}${sold == '0' ? '' : ' | $sold sold'}',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
          if (variant?.bestPrice == true)
            const ListingBadge(code: 'BEST_PRICE', solid: true),
        ],
      ),
      if (!detail.purchasable) ...[
        const SizedBox(height: 12),
        StatusBand(
          tone: BandTone.warning,
          title: detail.notPurchasableReason == 'STORE_PAUSED'
              ? 'This store has paused new procurement'
              : 'Outside your selected radius',
          message: detail.notPurchasableReason == 'STORE_PAUSED'
              ? 'You can still message the store. New orders are paused.'
              : 'This store is ${formatDistance(detail.distanceMeters)} away. Change the radius on the Map to buy from it.',
        ),
      ],
      if (_notice != null) ...[
        const SizedBox(height: 12),
        StatusBand(tone: BandTone.warning, title: _notice!),
      ],
      const Divider(height: 28),
      const _Label('Options'),
      Wrap(
        spacing: 8,
        runSpacing: 0,
        children: [
          for (final option in detail.variants)
            FilterPill(
              selected: option.variantId == _variantId,
              maxLines: 2,
              label: option.available
                  ? '${option.label} · ${formatPeso(option.unitPriceCentavos!)}'
                  : '${option.label} · ${option.availabilityNote ?? 'Unavailable'}',
              onTap: option.available
                  ? () => setState(() {
                      _variantId = option.variantId;
                      _notice = null;
                    })
                  : null,
            ),
        ],
      ),
      if (variant != null && variant.volumeTiers.isNotEmpty) ...[
        const SizedBox(height: 6),
        for (final tier in variant.volumeTiers)
          Text(
            'Buy ${formatQuantity(tier.minimumQuantity)}+ ${variant.unitName}: ${formatPeso(tier.amountCentavos)} each',
            style: const TextStyle(fontSize: 13),
          ),
      ],
      const SizedBox(height: 12),
      Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        children: [
          const _Label('Quantity', bottom: 0),
          if (variant == null || variant.wholeUnits)
            QuantityStepper(
              compact: true,
              quantity: _quantity,
              unitName: variant?.unitName ?? '',
              enabled: variant != null,
              onChanged: (value) => setState(() => _quantity = value),
            )
          else
            Text(
              'Sold in steps of ${variant.quantityStep} ${variant.unitName}. Adjust the exact quantity in the cart.',
            ),
        ],
      ),
      if (detail.pickupAvailable || detail.deliveryOffered) ...[
        const SizedBox(height: 12),
        const _Label('Fulfillment'),
        Wrap(
          spacing: 8,
          children: [
            if (detail.deliveryOffered)
              FilterPill(
                selected: _fulfillment == 'DELIVERY',
                label: detail.delivery == 'WITHIN_STATED_AREA'
                    ? 'Site Delivery'
                    : 'Site Delivery (outside stated area)',
                onTap: () => setState(() => _fulfillment = 'DELIVERY'),
              ),
            if (detail.pickupAvailable)
              FilterPill(
                selected: _fulfillment == 'PICKUP',
                label: 'Self-Pickup',
                onTap: () => setState(() => _fulfillment = 'PICKUP'),
              ),
          ],
        ),
        Text(
          detail.fulfillmentNotice,
          style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
        ),
      ],
      const SizedBox(height: 16),
      _vendor(detail),
      if (detail.attributes.isNotEmpty ||
          (variant?.attributes.isNotEmpty ?? false) ||
          detail.manufacturer != null ||
          detail.countryOfManufacture != null) ...[
        const SizedBox(height: 20),
        const _Label('Specification'),
        if (detail.manufacturer != null)
          SpecificationRow('Manufacturer', detail.manufacturer!),
        if (detail.countryOfManufacture != null)
          SpecificationRow(
            'Country of manufacture',
            detail.countryOfManufacture!,
          ),
        for (final entry in {
          ...detail.attributes,
          ...?variant?.attributes,
        }.entries)
          SpecificationRow(_attributeLabel(entry.key), entry.value),
        if (variant?.sku != null) SpecificationRow('SKU', variant!.sku!),
      ],
      if (detail.description != null) ...[
        const SizedBox(height: 20),
        const _Label('Description'),
        Text(
          detail.description!,
          maxLines: _descriptionExpanded ? null : 5,
          overflow: _descriptionExpanded
              ? TextOverflow.visible
              : TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13),
        ),
        if (detail.description!.length > 240)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () =>
                  setState(() => _descriptionExpanded = !_descriptionExpanded),
              child: Text(_descriptionExpanded ? 'Read less' : 'Read more'),
            ),
          ),
      ],
      const SizedBox(height: 20),
      const _Label('Compliance'),
      Text(detail.complianceNotice, style: const TextStyle(fontSize: 13)),
      const SizedBox(height: 12),
      Text(
        'Details current as of ${formatManilaTimestamp(detail.currentAsOf)}',
        style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
      ),
    ];
  }

  List<Widget> _related(ListingDetailView detail) => [
    const SizedBox(height: 16),
    _vendor(detail),
    const SizedBox(height: 16),
    Text(
      'More from ${detail.vendorName}',
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    ),
    const SizedBox(height: 4),
    Text(
      'See this store’s other products within your ${widget.explore.radiusKm} km radius.',
      style: const TextStyle(color: BuyerTheme.muted),
    ),
    const SizedBox(height: 12),
    OutlinedButton.icon(
      onPressed: () => widget.navigation.browseStore(
        context,
        vendorId: detail.vendorId,
        vendorName: detail.vendorName,
      ),
      icon: const Icon(LucideIcons.store),
      label: const Text('Browse store products'),
    ),
  ];

  List<Widget> _reviews(ListingDetailView detail) {
    final sold = formatQuantity(detail.unitsSold);
    return [
      const SizedBox(height: 16),
      Row(
        children: [
          Text(
            detail.ratingLabel,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(width: 6),
          const Icon(
            LucideIcons.star,
            color: Color(MateryalColorTokens.statusWarning),
          ),
          const SizedBox(width: 12),
          if (sold != '0')
            Text('$sold sold', style: const TextStyle(color: BuyerTheme.muted)),
        ],
      ),
      const SizedBox(height: 8),
      const Text(
        'Product ratings come from completed orders. Written reviews are not shown in this version.',
        style: TextStyle(color: BuyerTheme.muted),
      ),
    ];
  }

  Widget _vendor(ListingDetailView detail) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: BuyerTheme.border),
    ),
    child: Row(
      children: [
        Expanded(
          child: Semantics(
            button: true,
            label:
                '${detail.vendorName}, ${detail.vendorScore}, ${formatDistance(detail.distanceMeters)} away. Open Store Profile',
            excludeSemantics: true,
            child: InkWell(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12),
              ),
              onTap: () =>
                  widget.navigation.openStoreProfile(context, detail.vendorId),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: BuyerTheme.brandSoft,
                      child: Icon(
                        LucideIcons.store,
                        size: 20,
                        color: BuyerTheme.action,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail.vendorName,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '${detail.vendorScore} · ${formatDistance(detail.distanceMeters)} away · ${switch (detail.vendorOpenStatus) {
                              'OPEN' => 'Open now',
                              'CLOSED' => 'Closed now',
                              _ => 'Hours unavailable',
                            }}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          if (detail.vendorAddress != null)
                            Text(
                              detail.vendorAddress!,
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
        IconButton(
          tooltip: _favorite
              ? 'Remove Favorite Supplier'
              : 'Save as Favorite Supplier',
          isSelected: _favorite,
          onPressed: widget.explore.favoriteBusy(detail.vendorId)
              ? null
              : _toggleFavorite,
          icon: Icon(
            _favorite ? LucideIcons.heartOff : LucideIcons.heart,
            color: BuyerTheme.action,
          ),
        ),
      ],
    ),
  );

  Widget _actions(ListingDetailView detail) {
    final variant = _variant;
    final canAdd =
        detail.purchasable &&
        variant != null &&
        variant.available &&
        !_adding &&
        !_loading;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: BuyerTheme.border)),
        ),
        child: Row(
          children: [
            if (widget.navigation.messaging != null)
              IconButton(
                tooltip: 'Message Vendor',
                onPressed: variant == null
                    ? null
                    : () => widget.navigation.openMessage(
                        context,
                        detail.vendorId,
                        variant.variantId,
                      ),
                icon: const Icon(Icons.chat_bubble_outline),
              ),
            Expanded(
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: BuyerTheme.brandSoft,
                  foregroundColor: BuyerTheme.actionPressed,
                ),
                onPressed: canAdd ? () => _finalize(buy: false) : null,
                icon: _adding
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(LucideIcons.shoppingCart),
                label: const Text('Add to Cart'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton(
                onPressed: canAdd ? () => _finalize(buy: true) : null,
                child: const Text('Buy'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _attributeLabel(String key) {
    final words = key.split('_');
    return words
        .map(
          (word) => word.isEmpty
              ? word
              : word == 'mm' || word == 'kg' || word == 'cm'
              ? '($word)'
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }
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
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),
  );
}

class _FulfillmentNote extends StatelessWidget {
  const _FulfillmentNote({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 16, color: BuyerTheme.successStrong),
      const SizedBox(width: 4),
      Flexible(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: BuyerTheme.successStrong,
          ),
        ),
      ),
    ],
  );
}

class _Gallery extends StatefulWidget {
  const _Gallery({required this.images});

  final List<({String url, String? alt})> images;

  @override
  State<_Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<_Gallery> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final landscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    final height = landscape ? 200.0 : 300.0;
    if (widget.images.isEmpty) {
      return Container(
        height: height,
        color: BuyerTheme.canvas,
        alignment: Alignment.center,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.package, size: 48, color: BuyerTheme.muted),
            SizedBox(height: 4),
            Text('No product photo', style: TextStyle(color: BuyerTheme.muted)),
          ],
        ),
      );
    }
    return Column(
      children: [
        Container(
          height: height,
          color: BuyerTheme.canvas,
          child: PageView.builder(
            itemCount: widget.images.length,
            onPageChanged: (value) => setState(() => _page = value),
            itemBuilder: (_, index) => Image.network(
              widget.images[index].url,
              fit: BoxFit.contain,
              semanticLabel: widget.images[index].alt ?? 'Product photo',
              errorBuilder: (_, _, _) =>
                  const Center(child: Icon(LucideIcons.imageOff)),
            ),
          ),
        ),
        if (widget.images.length > 1)
          Semantics(
            label: 'Photo ${_page + 1} of ${widget.images.length}',
            excludeSemantics: true,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var index = 0; index < widget.images.length; index++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: index == _page ? 16 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: index == _page
                            ? BuyerTheme.action
                            : BuyerTheme.border,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
