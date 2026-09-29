import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import '../map_discovery/discovery_repository.dart' show newIdempotencyKey;
import 'cart_controller.dart';
import 'explore_controller.dart';
import 'procurement_models.dart';
import 'procurement_navigation.dart';
import 'procurement_repository.dart';

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

  /// One key per add attempt, reused for its retries so a retry never adds twice.
  String? _pendingAddKey;

  @override
  void initState() {
    super.initState();
    _load();
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
        _favorite = detail.isFavorite;
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
    if (detail == null) return;
    final next = !_favorite;
    setState(() => _favorite = next);
    try {
      await widget.explore.discovery.setFavorite(
        detail.vendorId,
        favorite: next,
      );
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
    final detail = _detail;
    final variant = _variant;
    final origin = widget.explore.origin;
    if (detail == null ||
        variant == null ||
        origin == null ||
        variant.priceVersionId == null) {
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
      appBar: AppBar(
        title: Text(detail?.displayName ?? 'Product details'),
        actions: [
          IconButton(
            tooltip: 'Cart',
            onPressed: () => widget.navigation.openCart(context),
            icon: const Icon(LucideIcons.shoppingCart),
          ),
        ],
      ),
      bottomNavigationBar: detail == null ? null : _actions(detail),
      body: SafeArea(child: _body()),
    );
  }

  Widget _body() {
    if (_loading && _detail == null) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SkeletonBox(height: 220),
          SizedBox(height: 16),
          SkeletonBox(height: 24, width: 240),
          SizedBox(height: 8),
          SkeletonBox(height: 20, width: 140),
        ],
      );
    }
    final failure = _failure;
    if (_detail == null) {
      return StateMessage(
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
      );
    }
    final detail = _detail!;
    final variant = _variant;
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          _Gallery(images: detail.images),
          const SizedBox(height: 12),
          Text(
            detail.displayName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (detail.brand != null || detail.categoryName != null)
            Text(
              [?detail.brand, ?detail.categoryName].join(' · '),
              style: const TextStyle(color: BuyerTheme.muted),
            ),
          const SizedBox(height: 8),
          if (variant?.unitPriceCentavos != null)
            Text(
              '${formatPeso(variant!.unitPriceCentavos!)} / ${variant.unitName}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: BuyerTheme.actionPressed,
              ),
            ),
          if (variant?.vatLabel != null)
            Text(
              variant!.includedVatCentavos != null &&
                      variant.includedVatCentavos! > 0
                  ? '${variant.vatLabel} · includes ${formatPeso(variant.includedVatCentavos!)} VAT'
                  : variant.vatLabel!,
              style: const TextStyle(fontSize: 13, color: BuyerTheme.muted),
            ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              StockLabelText(label: variant?.stockLabel),
              Text(
                '${detail.ratingLabel}${formatQuantity(detail.unitsSold) == '0' ? '' : ' · ${formatQuantity(detail.unitsSold)} sold'}',
              ),
              if (variant?.bestPrice == true)
                const ListingBadge(code: 'BEST_PRICE'),
              if (detail.complianceBadge != null)
                const ListingBadge(code: 'PS_ICC_VERIFIED'),
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
          SectionHeading('Options'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final option in detail.variants)
                ChoiceChip(
                  selected: option.variantId == _variantId,
                  showCheckmark: true,
                  label: Text(
                    option.available
                        ? '${option.label} · ${formatPeso(option.unitPriceCentavos!)}'
                        : '${option.label} · ${option.availabilityNote ?? 'Unavailable'}',
                  ),
                  onSelected: option.available
                      ? (_) => setState(() {
                          _variantId = option.variantId;
                          _notice = null;
                        })
                      : null,
                ),
            ],
          ),
          if (variant != null && variant.volumeTiers.isNotEmpty) ...[
            const SizedBox(height: 8),
            for (final tier in variant.volumeTiers)
              Text(
                'Buy ${formatQuantity(tier.minimumQuantity)}+ ${variant.unitName}: ${formatPeso(tier.amountCentavos)} each',
                style: const TextStyle(fontSize: 13),
              ),
          ],
          SectionHeading('Quantity'),
          if (variant == null || variant.wholeUnits)
            QuantityStepper(
              quantity: _quantity,
              unitName: variant?.unitName ?? '',
              enabled: variant != null,
              onChanged: (value) => setState(() => _quantity = value),
            )
          else
            Text(
              'Sold in steps of ${variant.quantityStep} ${variant.unitName}. Adjust the exact quantity in the cart.',
            ),
          if (detail.pickupAvailable || detail.deliveryOffered) ...[
            SectionHeading('Fulfillment'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (detail.deliveryOffered)
                  ChoiceChip(
                    selected: _fulfillment == 'DELIVERY',
                    showCheckmark: true,
                    avatar: const Icon(LucideIcons.truck, size: 18),
                    label: Text(
                      detail.delivery == 'WITHIN_STATED_AREA'
                          ? 'Site Delivery'
                          : 'Site Delivery (outside stated area)',
                    ),
                    onSelected: (_) =>
                        setState(() => _fulfillment = 'DELIVERY'),
                  ),
                if (detail.pickupAvailable)
                  ChoiceChip(
                    selected: _fulfillment == 'PICKUP',
                    showCheckmark: true,
                    avatar: const Icon(LucideIcons.store, size: 18),
                    label: const Text('Self-Pickup'),
                    onSelected: (_) => setState(() => _fulfillment = 'PICKUP'),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              detail.fulfillmentNotice,
              style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
            ),
          ],
          SectionHeading('Store'),
          _vendor(detail),
          if (detail.attributes.isNotEmpty ||
              detail.manufacturer != null ||
              detail.countryOfManufacture != null) ...[
            SectionHeading('Specification'),
            if (detail.manufacturer != null)
              _SpecRow('Manufacturer', detail.manufacturer!),
            if (detail.countryOfManufacture != null)
              _SpecRow('Country of manufacture', detail.countryOfManufacture!),
            for (final entry in detail.attributes.entries)
              _SpecRow(_attributeLabel(entry.key), entry.value),
          ],
          if (detail.description != null) ...[
            SectionHeading('Description'),
            Text(detail.description!),
          ],
          SectionHeading('Compliance'),
          Text(detail.complianceNotice, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 12),
          Text(
            'Details current as of ${formatManilaTimestamp(detail.currentAsOf)}',
            style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
          ),
        ],
      ),
    );
  }

  Widget _vendor(ListingDetailView detail) => Semantics(
    button: true,
    label:
        '${detail.vendorName}, ${detail.vendorScore}, ${formatDistance(detail.distanceMeters)} away. Open Store Profile',
    excludeSemantics: true,
    child: InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => widget.navigation.openStoreProfile(context, detail.vendorId),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            const Icon(LucideIcons.store, color: BuyerTheme.action),
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
                    '${detail.vendorScore} · ${formatDistance(detail.distanceMeters)} · ${switch (detail.vendorOpenStatus) {
                      'OPEN' => 'Open now',
                      'CLOSED' => 'Closed now',
                      _ => 'Hours unavailable',
                    }}',
                    style: const TextStyle(fontSize: 13),
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
            const Icon(LucideIcons.chevronRight),
          ],
        ),
      ),
    ),
  );

  Widget _actions(ListingDetailView detail) {
    final variant = _variant;
    final canAdd =
        detail.purchasable && variant != null && variant.available && !_adding;
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
            IconButton.outlined(
              tooltip: _favorite
                  ? 'Remove Favorite Supplier'
                  : 'Save as Favorite Supplier',
              isSelected: _favorite,
              onPressed: _toggleFavorite,
              icon: Icon(_favorite ? LucideIcons.heartOff : LucideIcons.heart),
            ),
            const SizedBox(width: 8),
            IconButton.outlined(
              tooltip: 'Message Vendor (available in a later release)',
              onPressed: null,
              icon: const Icon(LucideIcons.messageCircle),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton.icon(
                onPressed: canAdd ? _addToCart : null,
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

class _SpecRow extends StatelessWidget {
  const _SpecRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Wrap(
      spacing: 12,
      children: [
        Text(label, style: const TextStyle(color: BuyerTheme.muted)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
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
    final height = landscape ? 160.0 : 220.0;
    if (widget.images.isEmpty) {
      return Container(
        height: height,
        color: BuyerTheme.canvas,
        alignment: Alignment.center,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.package, size: 40, color: BuyerTheme.muted),
            Text('No product photo'),
          ],
        ),
      );
    }
    return Column(
      children: [
        SizedBox(
          height: height,
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
          Text(
            'Photo ${_page + 1} of ${widget.images.length}',
            style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
          ),
      ],
    );
  }
}
