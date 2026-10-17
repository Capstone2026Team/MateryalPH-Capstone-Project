import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import '../orders/order_models.dart' show formatManilaDateTime;
import '../../design_system/components/specification_chips.dart';
import 'projects_repository.dart';
import 'quotation_line_widgets.dart';
import 'vendor_selection_screen.dart';
import 'vendor_selection_widgets.dart';
import 'work_package_material_widgets.dart';

const _missingReasons = {
  'UNLISTED_MATERIAL': 'Unlisted material — never matched automatically',
  'NO_EXACT_ACTIVE_MATCH': 'This Vendor has no exact match',
  'QUANTITY_NOT_FULFILLABLE': 'This Vendor cannot supply the full quantity',
};

/// One Vendor's system-compiled estimate for the Work Package, presented as a
/// quotation: what this Vendor supplies, what is missing (with separate
/// Item-Based offers to buy instead), delivery and totals. A published Vendor
/// quotation stays separate and is reviewed in the conversation.
class VendorQuotationScreen extends StatefulWidget {
  const VendorQuotationScreen({
    super.key,
    required this.repository,
    required this.package,
    required this.candidate,
    required this.estimate,
    required this.links,
  });
  final ProjectsRepository repository;
  final ProjectData package, candidate;
  final ProjectData? estimate;
  final ProjectSourcingLinks links;

  @override
  State<VendorQuotationScreen> createState() => _VendorQuotationScreenState();
}

class _VendorQuotationScreenState extends State<VendorQuotationScreen> {
  final keys = <String, String>{};
  final offers = <String, ProjectData>{};
  final offerErrors = <String, String>{};
  Map<String, List<ProjectData>> tagged = {};
  String? error, adding;
  bool busy = false, pricing = false;

  /// The candidate as last priced by the server, with [selections] applied.
  late ProjectData c = widget.candidate;

  /// Specification choices: Work Package line id → option id.
  final selections = <String, String>{};
  List<ProjectData> get missing => projectRows(c['missing_lines']);
  bool get actionable =>
      !busy &&
      !pricing &&
      candidateActionable(widget.package, widget.estimate, c);

  /// Lines where several specifications fit and none is chosen yet.
  List<ProjectData> get pendingChoices => [
    for (final l in projectRows(c['lines']))
      if (l['selection_required'] == true) l,
  ];

  void _openProduct(String listingId, String? variantId) =>
      widget.links.openProduct?.call(context, listingId, variantId);

  Future<void> _chooseSpecification(ProjectData line) async {
    final option = await showSpecificationChoice(
      context,
      line: line,
      storeName: projectText(c['store_name']),
      onOpenProduct: widget.links.openProduct == null ? null : _openProduct,
    );
    final lineId = projectText(line['line_id']);
    if (option == null || !mounted || option == line['selected_option_id']) {
      return;
    }
    final previous = selections[lineId];
    setState(() {
      selections[lineId] = option;
      pricing = true;
      error = null;
    });
    try {
      final priced = await widget.repository.selectionPreview(
        projectText(widget.package['id']),
        projectText(c['id']),
        Map.of(selections),
      );
      if (!mounted) return;
      setState(() => c = priced);
      // A partial option can leave a new missing line that needs offers.
      for (final m in missing) {
        final id = projectText(m['line_id']);
        if (!offers.containsKey(id)) unawaited(_loadOffers(id));
      }
    } on DiscoveryFailure catch (e) {
      if (mounted) {
        setState(() {
          // Keep the last server-priced state; the choice did not apply.
          if (previous == null) {
            selections.remove(lineId);
          } else {
            selections[lineId] = previous;
          }
          error = e.message;
        });
      }
    } finally {
      if (mounted) setState(() => pricing = false);
    }
  }

  /// Cart lines bought for this Vendor's missing lines.
  List<ProjectData> get separate => [
    for (final m in missing) ...?tagged[projectText(m['line_id'])],
  ];
  int get separateTotal => separate.fold(
    0,
    (sum, line) => sum + projectInt(line['line_total_centavos']),
  );

  @override
  void initState() {
    super.initState();
    unawaited(_loadTagged());
    for (final m in missing) {
      unawaited(_loadOffers(projectText(m['line_id'])));
    }
  }

  Future<void> _loadTagged() async {
    try {
      final result = await widget.repository.taggedCartLines();
      if (mounted) setState(() => tagged = result);
    } on DiscoveryFailure {
      // The cart summary is supplementary; the estimate stays usable.
    }
  }

  Future<void> _loadOffers(String lineId) async {
    setState(() => offerErrors.remove(lineId));
    try {
      final result = await widget.repository.alternatives(
        projectText(widget.package['id']),
        lineId,
        excludeVendorId: projectText(c['vendor_id']),
      );
      if (mounted) setState(() => offers[lineId] = result);
    } on DiscoveryFailure catch (e) {
      if (mounted) setState(() => offerErrors[lineId] = e.message);
    }
  }

  Future<void> _add(
    ProjectData offer,
    ProjectData line,
    ProjectData page,
  ) async {
    if (adding != null) return;
    final variant = projectText(offer['variant_id']);
    setState(() => adding = variant);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await widget.repository.addMissingToCart(
        offer: offer,
        quantity: materialQuantity(line['quantity']),
        workPackageLineId: projectText(line['line_id']),
        locationId: page['location_id'] as String?,
        radiusKm: projectInt(page['radius_km']),
        idempotencyKey: keys.putIfAbsent('add:$variant', projectKey),
      );
      keys.remove('add:$variant');
      widget.links.onCartChanged?.call();
      await _loadTagged();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            '${projectText(offer['display_name'])} added to your cart as a separate purchase.',
          ),
          action: widget.links.openCart == null
              ? null
              : SnackBarAction(
                  label: 'View cart',
                  onPressed: () => widget.links.openCart!(context),
                ),
        ),
      );
    } on DiscoveryFailure catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => adding = null);
    }
  }

  Future<void> _choose(bool select) async {
    if (busy) return;
    final pending = pendingChoices;
    if (pending.isNotEmpty) return _chooseSpecification(pending.first);
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final result = await chooseCandidate(
        context,
        repository: widget.repository,
        package: widget.package,
        candidate: c,
        select: select,
        keys: keys,
        selections: Map.of(selections),
      );
      if (result == null || !mounted) return;
      if (select) {
        widget.links.openOrder(context, result);
      } else {
        widget.links.openConversation(context, result);
      }
    } on DiscoveryFailure catch (e) {
      if (mounted) setState(() => error = e.message);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _viewList(ProjectData line) async {
    final lineId = projectText(line['line_id']);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _OfferListSheet(
        repository: widget.repository,
        packageId: projectText(widget.package['id']),
        line: line,
        excludeVendorId: projectText(c['vendor_id']),
        first: offers[lineId],
        onAdd: (offer, page) => _add(offer, line, page),
        onOpen: widget.links.openProduct == null
            ? null
            : (listing, variant) {
                Navigator.pop(context);
                _openProduct(listing, variant);
              },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final estimateState = projectText(widget.estimate?['state']);
    final quotation = projectText(c['current_quotation_state']);
    final pending = pendingChoices;
    final store = projectText(c['store_name']);
    final openProduct = widget.links.openProduct == null ? null : _openProduct;
    return Scaffold(
      appBar: buyerAppBar(context, 'Quotation'),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (pending.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    pending.length == 1
                        ? 'Choose a specification for ${projectText(pending.first['name'])} to continue.'
                        : 'Choose specifications for ${pending.length} items to continue.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: BuyerTheme.actionPressed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              Row(
                children: [
                  IconButton.outlined(
                    tooltip: 'Message Vendor',
                    onPressed: actionable ? () => _choose(false) : null,
                    icon: const Icon(LucideIcons.messageCircle),
                    style: IconButton.styleFrom(
                      minimumSize: const Size(52, 52),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: actionable ? () => _choose(true) : null,
                      child: Text(
                        busy || pricing
                            ? 'Working…'
                            : pending.isNotEmpty
                            ? 'Choose specification'
                            : 'Select this Vendor',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          if (busy || pricing) const LinearProgressIndicator(),
          if (error != null) ...[
            StatusBand(tone: BandTone.danger, title: error!),
            const SizedBox(height: 12),
          ],
          _StoreHeader(
            candidate: c,
            onOpenStore: () =>
                widget.links.openStore(context, projectText(c['vendor_id'])),
          ),
          const SizedBox(height: 12),
          StatusBand(
            tone: estimateState == 'ACTIVE' && c['stale'] != true
                ? BandTone.info
                : BandTone.warning,
            title: 'System-compiled estimate · advisory',
            message: c['stale'] == true
                ? 'Prices, stock or delivery rates changed. Refresh the estimate before selecting.'
                : estimateState == 'ACTIVE'
                ? 'Valid until ${formatManilaDateTime(DateTime.parse(projectText(widget.estimate!['expires_at'])))}. The Vendor confirms the final package after you select.'
                : 'This estimate is no longer active. Refresh it from Vendor selection.',
          ),
          if (quotation != 'NO_INQUIRY') ...[
            const SizedBox(height: 8),
            StatusBand(
              tone: BandTone.info,
              title: 'Vendor quotation: ${projectStatus(quotation)}',
              message:
                  'A quotation from this Vendor is reviewed in your conversation and stays separate from this estimate.',
              action: TextButton(
                onPressed: actionable ? () => _choose(false) : null,
                child: const Text('Open'),
              ),
            ),
          ],
          _Section(
            title: 'Order summary',
            subtitle: openProduct == null
                ? 'Supplied by $store.'
                : 'Supplied by $store. Tap a product to see its full details.',
            children: [
              for (final l in projectRows(c['lines']))
                if ((double.tryParse(projectText(l['matched_quantity'])) ?? 0) >
                        0 ||
                    l['selection_required'] == true)
                  QuotationSummaryLine(
                    line: l,
                    storeName: store,
                    busy: busy || pricing,
                    onChoose: () => _chooseSpecification(l),
                    onOpenProduct: openProduct,
                  ),
              const Divider(height: 24),
              _AmountRow(
                pending.isEmpty
                    ? 'Materials total'
                    : 'Materials total (lowest options)',
                projectMoney(c['materials_centavos']),
                strong: true,
              ),
              Text(
                'Includes VAT ${projectMoney(c['included_vat_centavos'])}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: BuyerTheme.muted,
                ),
              ),
            ],
          ),
          if (missing.isNotEmpty)
            _Section(
              title: 'Missing items',
              subtitle:
                  'This Vendor cannot supply these. Buy them separately through an Item-Based order; it links to this Work Package.',
              children: [
                for (final (i, m) in missing.indexed) ...[
                  if (i > 0) const Divider(height: 28),
                  _MissingItem(
                    line: m,
                    offers: offers[projectText(m['line_id'])],
                    error: offerErrors[projectText(m['line_id'])],
                    inCart: tagged[projectText(m['line_id'])] ?? const [],
                    adding: adding,
                    onRetry: () => _loadOffers(projectText(m['line_id'])),
                    onAdd: (offer, page) => _add(offer, m, page),
                    onViewList: () => _viewList(m),
                    onOpenProduct: openProduct,
                  ),
                ],
              ],
            ),
          if (separate.isNotEmpty)
            _Section(
              title: 'Buying separately',
              subtitle:
                  'In your cart as separate Item-Based purchases, each from the store shown.',
              children: [
                for (final line in separate)
                  _SeparateLine(line: line, onOpen: openProduct),
                const Divider(height: 20),
                _AmountRow(
                  'Separate items',
                  projectMoney(separateTotal),
                  strong: true,
                ),
              ],
            ),
          _Section(
            title: 'Delivery mode',
            children: [
              _LockedModeToggle(method: projectText(c['fulfillment_method'])),
              const SizedBox(height: 8),
              Text(
                'Set in the activated Work Package. Change it with a new Work Package version.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: BuyerTheme.muted,
                ),
              ),
              if (projectText(c['fulfillment_method']) == 'DELIVERY') ...[
                const SizedBox(height: 16),
                _DeliveryConfiguration(candidate: c),
              ],
            ],
          ),
          _Section(
            title: 'Total cost',
            children: [
              _AmountRow('Materials', projectMoney(c['materials_centavos'])),
              _AmountRow('Delivery fee', deliveryFee(c)),
              const _AmountRow('Processing fee', 'Shown at payment'),
              const Divider(height: 24),
              Center(
                child: Column(
                  children: [
                    Text(
                      candidateTotal(c),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      c['projected_total_centavos'] == null
                          ? 'Materials only · delivery under Vendor review'
                          : 'Projected total from this Vendor',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: BuyerTheme.muted,
                      ),
                    ),
                  ],
                ),
              ),
              if (separateTotal > 0) ...[
                const SizedBox(height: 12),
                _AmountRow(
                  'Separate items in cart',
                  projectMoney(separateTotal),
                ),
                _AmountRow(
                  'Total incl. separate items',
                  projectMoney(
                    projectInt(
                          c['projected_total_centavos'] ??
                              c['materials_centavos'],
                        ) +
                        separateTotal,
                  ),
                  strong: true,
                ),
              ],
              const SizedBox(height: 12),
              // Budget and its status on one aligned row, like the amounts above.
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Work Package budget',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: BuyerTheme.muted,
                          ),
                        ),
                        Text(
                          projectMoney(widget.package['budget_centavos']),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  BudgetStatusChip(projectText(c['budget_label'])),
                ],
              ),
            ],
          ),
          _ScoreSection(fms: projectObject(c['fms'])),
          const _ProcurementRules(),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children, this.subtitle});
  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: vendorCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: BuyerTheme.muted,
              ),
            ),
          ],
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow(this.label, this.value, {this.strong = false});
  final String label, value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontWeight: strong ? FontWeight.w700 : FontWeight.w400,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: style)),
          const SizedBox(width: 12),
          Text(value, style: style),
        ],
      ),
    );
  }
}

class _StoreHeader extends StatelessWidget {
  const _StoreHeader({required this.candidate, required this.onOpenStore});
  final ProjectData candidate;
  final VoidCallback onOpenStore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: BuyerTheme.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpenStore,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: BuyerTheme.brandSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  LucideIcons.store,
                  color: BuyerTheme.actionPressed,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      projectText(candidate['store_name']),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${kilometres(candidate['distance_meters'])} · ${projectText(candidate['score_label'])} · ${fulfillmentLabel(candidate['fulfillment_method'])}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: BuyerTheme.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight, color: BuyerTheme.muted),
            ],
          ),
        ),
      ),
    );
  }
}

/// A separate Item-Based purchase in the cart, with the store that supplies it.
class _SeparateLine extends StatelessWidget {
  const _SeparateLine({required this.line, required this.onOpen});
  final ProjectData line;
  final OpenProduct? onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final listing = line['listing_id'] as String?;
    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  [
                    projectText(line['display_name']),
                    projectText(line['variant_label']),
                  ].where((s) => s.isNotEmpty).join(' · '),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${materialQuantity(line['quantity'])} ${projectText(line['unit_code'])} · Sold by ${projectText(line['store_name'])}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: BuyerTheme.muted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            line['line_total_centavos'] == null
                ? '—'
                : projectMoney(line['line_total_centavos']),
            style: theme.textTheme.bodyMedium,
          ),
          if (onOpen != null && listing != null)
            const Icon(LucideIcons.chevronRight, color: BuyerTheme.muted),
        ],
      ),
    );
    return onOpen == null || listing == null
        ? row
        : InkWell(
            onTap: () => onOpen!(listing, line['variant_id'] as String?),
            child: Semantics(
              button: true,
              hint: 'Opens product details',
              child: row,
            ),
          );
  }
}

class _MissingItem extends StatelessWidget {
  const _MissingItem({
    required this.line,
    required this.offers,
    required this.error,
    required this.inCart,
    required this.adding,
    required this.onRetry,
    required this.onAdd,
    required this.onViewList,
    this.onOpenProduct,
  });
  final ProjectData line;
  final ProjectData? offers;
  final String? error;
  final List<ProjectData> inCart;
  final String? adding;
  final VoidCallback onRetry, onViewList;
  final void Function(ProjectData offer, ProjectData page) onAdd;
  final OpenProduct? onOpenProduct;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = projectRows(offers?['items']);
    final unlisted = offers?['status'] == 'UNLISTED';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(
                LucideIcons.triangleAlert,
                size: 18,
                color: BuyerTheme.actionPressed,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    projectText(line['name']),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _missingReasons[line['reason']] ??
                        'Not supplied by this Vendor',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: BuyerTheme.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              missingQuantity(line),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: BuyerTheme.actionPressed,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        for (final cartLine in inCart)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Icon(
                  LucideIcons.shoppingCart,
                  size: 16,
                  color: BuyerTheme.successStrong,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'In your cart: ${materialQuantity(cartLine['quantity'])} ${projectText(cartLine['unit_code'])} · ${projectText(cartLine['display_name'])}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: BuyerTheme.successStrong,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 10),
        if (error != null)
          Row(
            children: [
              Expanded(child: Text(error!, style: theme.textTheme.bodySmall)),
              TextButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          )
        else if (offers == null)
          const LinearProgressIndicator()
        else if (unlisted)
          Text(
            'Unlisted materials have no comparable listings. Buy it from any store, then record a waiver on the Work Package.',
            style: theme.textTheme.bodySmall?.copyWith(color: BuyerTheme.muted),
          )
        else if (items.isEmpty)
          Text(
            'No similar Item-Based listings within ${projectInt(offers!['radius_km'])} km.',
            style: theme.textTheme.bodySmall?.copyWith(color: BuyerTheme.muted),
          )
        else ...[
          Text(
            'Recommended from other stores',
            style: theme.textTheme.labelLarge?.copyWith(
              color: BuyerTheme.muted,
              fontWeight: FontWeight.w700,
            ),
          ),
          for (final offer in items.take(3))
            OfferRow(
              offer: offer,
              adding: adding == offer['variant_id'],
              onAdd: adding == null ? () => onAdd(offer, offers!) : null,
              onOpen: onOpenProduct,
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onViewList,
              icon: const Icon(LucideIcons.list, size: 18),
              label: Text('View list (${projectInt(offers!['total'])})'),
            ),
          ),
        ],
      ],
    );
  }
}

/// A similar Item-Based offer with an Add action.
class OfferRow extends StatelessWidget {
  const OfferRow({
    super.key,
    required this.offer,
    required this.adding,
    required this.onAdd,
    this.onOpen,
  });
  final ProjectData offer;
  final bool adding;
  final VoidCallback? onAdd;

  /// Product Details for this offer; the details area becomes the link.
  final OpenProduct? onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final exact = offer['exact_match'] == true;
    final listing = offer['listing_id'] as String?;
    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          [
            projectText(offer['display_name']),
            projectText(offer['variant_label']),
          ].where((s) => s.isNotEmpty).join(' · '),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          [
            'Sold by ${projectText(offer['store_name'])}',
            kilometres(offer['distance_meters']),
            projectText(offer['stock_label']),
          ].where((s) => s.isNotEmpty).join(' · '),
          style: theme.textTheme.bodySmall?.copyWith(color: BuyerTheme.muted),
        ),
        if (specificationDetails(offer['specifications']).isNotEmpty) ...[
          const SizedBox(height: 4),
          SpecificationChips(
            details: specificationDetails(offer['specifications']),
          ),
        ],
      ],
    );
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.fromLTRB(4, 6, 8, 6),
      decoration: BoxDecoration(
        color: BuyerTheme.canvas,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (onOpen == null || listing == null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 0, 0),
                    child: details,
                  )
                else
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () =>
                        onOpen!(listing, offer['variant_id'] as String?),
                    child: Semantics(
                      button: true,
                      hint: 'Opens product details',
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
                        child: details,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 2, 0, 4),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              '${projectMoney(offer['unit_price_centavos'])} / ${projectText(offer['unit_code'])}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text: exact ? '  · Exact match' : '  · Similar',
                          style: TextStyle(
                            color: exact
                                ? BuyerTheme.successStrong
                                : BuyerTheme.muted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.tonal(
            style: FilledButton.styleFrom(minimumSize: const Size(72, 44)),
            onPressed: onAdd,
            child: adding
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Add'),
          ),
        ],
      ),
    );
  }
}

/// Every similar offer for one missing line, page by page.
class _OfferListSheet extends StatefulWidget {
  const _OfferListSheet({
    required this.repository,
    required this.packageId,
    required this.line,
    required this.excludeVendorId,
    required this.first,
    required this.onAdd,
    this.onOpen,
  });
  final ProjectsRepository repository;
  final String packageId, excludeVendorId;
  final OpenProduct? onOpen;
  final ProjectData line;
  final ProjectData? first;
  final Future<void> Function(ProjectData offer, ProjectData page) onAdd;

  @override
  State<_OfferListSheet> createState() => _OfferListSheetState();
}

class _OfferListSheetState extends State<_OfferListSheet> {
  late ProjectData? page = widget.first;
  late List<ProjectData> items = projectRows(widget.first?['items']);
  bool loading = false;
  String? adding, error;

  Future<void> _more() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final next = await widget.repository.alternatives(
        widget.packageId,
        projectText(widget.line['line_id']),
        page: projectInt(page?['page']) + 1,
        excludeVendorId: widget.excludeVendorId,
      );
      if (mounted) {
        setState(() {
          page = next;
          items = [...items, ...projectRows(next['items'])];
        });
      }
    } on DiscoveryFailure catch (e) {
      if (mounted) setState(() => error = e.message);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .7,
      maxChildSize: .92,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          Text(
            'Similar items for ${projectText(widget.line['name'])}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Needed: ${missingQuantity(widget.line)} · added as a separate Item-Based purchase',
            style: theme.textTheme.bodySmall?.copyWith(color: BuyerTheme.muted),
          ),
          for (final offer in items)
            OfferRow(
              offer: offer,
              onOpen: widget.onOpen,
              adding: adding == offer['variant_id'],
              onAdd: adding != null || page == null
                  ? null
                  : () async {
                      setState(() => adding = projectText(offer['variant_id']));
                      await widget.onAdd(offer, page!);
                      if (mounted) setState(() => adding = null);
                    },
            ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(error!),
            ),
          if (page?['has_more'] == true)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: OutlinedButton(
                onPressed: loading ? null : _more,
                child: Text(loading ? 'Loading…' : 'More listings'),
              ),
            ),
        ],
      ),
    );
  }
}

/// The package's fulfillment method, shown as a read-only two-way toggle
/// (owner decision 2026-10-12: it is locked in the activated package).
class _LockedModeToggle extends StatelessWidget {
  const _LockedModeToggle({required this.method});
  final String method;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget option(String value, String label, IconData icon) {
      final on = value == method;
      return Expanded(
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: on ? BuyerTheme.action : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                on ? LucideIcons.lock : icon,
                size: 16,
                color: on ? Colors.white : BuyerTheme.muted,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: on ? Colors.white : BuyerTheme.muted,
                    fontWeight: on ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Semantics(
      label:
          'Delivery mode ${method == 'DELIVERY' ? 'Site delivery' : 'Self pick-up'}, locked',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: BuyerTheme.canvas,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: BuyerTheme.border),
        ),
        child: Row(
          children: [
            option('DELIVERY', 'Site delivery', LucideIcons.truck),
            const SizedBox(width: 4),
            option('PICKUP', 'Self pick-up', LucideIcons.store),
          ],
        ),
      ),
    );
  }
}

class _DeliveryConfiguration extends StatelessWidget {
  const _DeliveryConfiguration({required this.candidate});
  final ProjectData candidate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final delivery = projectObject(candidate['delivery']);
    final options = projectRows(projectObject(delivery['estimate'])['options']);
    final route = projectObject(delivery['route']);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: BuyerTheme.brandSoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Delivery configuration',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: BuyerTheme.actionPressed,
            ),
          ),
          const SizedBox(height: 8),
          if (route['distance_meters'] != null)
            _AmountRow('Road distance', kilometres(route['distance_meters'])),
          if (options.isEmpty)
            for (final issue in projectRows(delivery['issues']))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  projectText(issue['message']),
                  style: theme.textTheme.bodySmall,
                ),
              ),
          for (final o in options) ...[
            const Divider(height: 16),
            Row(
              children: [
                const Icon(LucideIcons.truck, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    projectText(o['vehicle_name']),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            _AmountRow(
              'Vehicles · trips',
              '${projectInt(o['vehicles'])} · ${projectInt(o['trips'])}',
            ),
            if (o['base_fee_centavos'] != null)
              _AmountRow('Base fee', projectMoney(o['base_fee_centavos'])),
            if (o['per_km_centavos'] != null)
              _AmountRow('Rate per km', projectMoney(o['per_km_centavos'])),
            _AmountRow('Estimated fee', projectMoney(o['fee_centavos'])),
          ],
          const Divider(height: 20),
          _AmountRow('Delivery fee', deliveryFee(candidate), strong: true),
          const SizedBox(height: 4),
          Text(
            'Estimate only. The Vendor confirms vehicles, trips and the final fee before you pay.',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _ScoreSection extends StatelessWidget {
  const _ScoreSection({required this.fms});
  final ProjectData fms;

  @override
  Widget build(BuildContext context) {
    final components = projectObject(fms['components']);
    const labels = {
      'material_match': 'Material match',
      'budget_fit': 'Budget fit',
      'distance': 'Distance',
      'vps': 'Vendor performance',
    };
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: vendorCardDecoration(context),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: ExpansionTile(
          shape: const Border(),
          collapsedShape: const Border(),
          leading: const Icon(LucideIcons.gauge),
          title: const Text('Fulfillment Match Score'),
          subtitle: Text(
            fms['score'] == null
                ? 'Cost review'
                : '${_points(fms['score'])} / 100',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: BuyerTheme.actionPressed,
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          children: [
            for (final e in labels.entries)
              _ScoreComponentRow(e.value, components[e.key]),
          ],
        ),
      ),
    );
  }
}

/// A 0-100 score as at most two decimals, without trailing zeros: 58.03, 100.
String _points(Object? value) {
  final n = num.tryParse(projectText(value));
  if (n == null) return '—';
  return n.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
}

class _ScoreComponentRow extends StatelessWidget {
  const _ScoreComponentRow(this.label, this.value);
  final String label;
  final Object? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final n = num.tryParse(projectText(value));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
              const SizedBox(width: 12),
              Text(
                n == null ? '—' : '${_points(value)} / 100',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          if (n != null) ...[
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: (n / 100).clamp(0, 1).toDouble(),
                minHeight: 6,
                backgroundColor: BuyerTheme.border,
                color: BuyerTheme.actionPressed,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProcurementRules extends StatelessWidget {
  const _ProcurementRules();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const rules = [
      'One Project-Based Vendor is awarded each Work Package as a package deal.',
      'Missing items are bought through separate Item-Based orders and linked to the package; nothing is substituted silently.',
      'System estimates are advisory for 48 hours. Vendor quotations are separate and versioned.',
      'A purchase above the Work Package or Project budget needs a written override.',
    ];
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: vendorCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.shieldCheck,
                size: 18,
                color: BuyerTheme.muted,
              ),
              const SizedBox(width: 8),
              Text(
                'Procurement rules',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final rule in rules)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '• $rule',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: BuyerTheme.muted,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
