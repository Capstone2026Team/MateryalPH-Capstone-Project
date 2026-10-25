import 'project_supplier_view.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import '../orders/order_models.dart' show formatManilaDateTime;
import '../../design_system/components/specification_chips.dart';
import '../../design_system/components/product_summary_row.dart';
import 'projects_repository.dart';
import 'quotation_line_widgets.dart';
import 'project_selection_checkout_screen.dart';
import 'vendor_selection_screen.dart';
import 'vendor_selection_widgets.dart';
import 'work_package_material_widgets.dart';

const _missingReasons = {
  'UNLISTED_MATERIAL': 'Unlisted material — never matched automatically',
  'QUANTITY_NOT_FULFILLABLE': 'This Vendor cannot supply the full quantity',
};

/// One Vendor's system-compiled estimate for the Work Package, presented as a
/// quotation: what this Vendor supplies, what is missing (with draft
/// supplementary supplier selections), delivery and totals. A published Vendor
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
  final api.WorkPackageView package;
  final api.ProjectCandidate candidate;
  final api.ProjectCompiledEstimate? estimate;
  final ProjectSourcingLinks links;
  @override
  State<VendorQuotationScreen> createState() => _VendorQuotationScreenState();
}

class _VendorQuotationScreenState extends State<VendorQuotationScreen> {
  final keys = <String, String>{};
  final offers = <String, api.WorkPackageAlternativePage>{};
  final offerErrors = <String, String>{};
  final offerLoads = <String, int>{};
  String? error, adding;
  bool busy = false, pricing = false;

  /// The candidate as last priced by the server, with [selections] applied.
  late api.ProjectCandidate c = widget.candidate;
  late api.WorkPackageView package = widget.package;

  /// Specification choices: Work Package line id → option id.
  final selections = <String, String>{};
  List<ProjectData> get missing => projectRows(c.missingLines);
  bool get actionable =>
      !busy && !pricing && candidateActionable(package, widget.estimate, c);

  /// Lines where several specifications fit and none is chosen yet.
  List<ProjectData> get pendingChoices => [
    for (final l in projectRows(c.lines))
      if (l['selection_required'] == true) l,
  ];
  void _openProduct(String listingId, String? variantId) =>
      widget.links.openProduct?.call(context, listingId, variantId);
  Future<void> _chooseSpecification(ProjectData line) async {
    final option = await showSpecificationChoice(
      context,
      line: line,
      storeName: projectText(c.storeName),
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
      await _reprice();
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

  /// Re-prices a Vendor that offers both Delivery and Pickup for the method the
  /// Buyer picked; the choices already made stay applied.
  Future<void> _chooseMethod(String method) async {
    if (pricing || busy || method == projectText(c.fulfillmentMethod)) {
      return;
    }
    setState(() {
      pricing = true;
      error = null;
    });
    try {
      await _reprice(method: method);
    } on DiscoveryFailure catch (e) {
      // Keep the last server-priced method; the switch did not apply.
      if (mounted) setState(() => error = e.message);
    } finally {
      if (mounted) setState(() => pricing = false);
    }
  }

  /// Re-reads this Vendor's quotation from the server with the choices made so
  /// far. Totals, fulfillment, the missing items and the quantity each
  /// recommendation must cover all come back from that one response, so the
  /// card, the order summary and the offers cannot drift apart. [method] picks
  /// Delivery or Pickup for a Vendor offering both; otherwise the current one stays.
  Future<void> _reprice({String? method}) async {
    final priced = await widget.repository.selectionPreview(
      projectText(package.id),
      projectText(c.id),
      Map.of(selections),
      fulfillmentMethod:
          method ??
          (needsFulfillmentChoice(c) ? projectText(c.fulfillmentMethod) : null),
    );
    if (!mounted) return;
    setState(() => c = priced);
    for (final m in missing) {
      unawaited(_loadOffers(projectText(m['line_id'])));
    }
  }

  /// The method the Work Package was saved with; Both leaves the pick to the Buyer.
  String get packageMethod => projectText(
    projectObject(package.version?.content)['fulfillment_method'],
  );

  /// What this quotation covers, from the server: the Vendor's own supply plus
  /// the separate purchases tagged to its missing lines. Never recounted here.
  api.ProjectFulfillment get fulfillment => candidateFulfillment(c);

  /// Draft supplements and earlier linked purchases for this Vendor's gaps.
  List<api.ProjectSeparatePurchase> get separate =>
      fulfillment.separateItems.toList();
  int get separateTotal => projectInt(fulfillment.separateTotalCentavos);
  List<api.ProjectDraftVendorGroup> get supplierGroups =>
      c.draftGroups?.toList() ?? [];

  Future<void> _loadArrangement() async {
    try {
      await _reprice();
    } on DiscoveryFailure catch (e) {
      if (mounted) setState(() => error = e.message);
      for (final line in missing) {
        unawaited(_loadOffers(projectText(line['line_id'])));
      }
    } finally {
      if (mounted) setState(() => pricing = false);
    }
  }

  @override
  void initState() {
    super.initState();
    if (separate.isNotEmpty && c.draftGroups == null) {
      pricing = true;
      unawaited(_loadArrangement());
    } else {
      for (final m in missing) {
        unawaited(_loadOffers(projectText(m['line_id'])));
      }
    }
  }

  Future<void> _loadOffers(String lineId) async {
    final token = (offerLoads[lineId] ?? 0) + 1;
    offerLoads[lineId] = token;
    if (mounted) setState(() => offerErrors.remove(lineId));
    try {
      final result = await widget.repository.alternatives(
        projectText(package.id),
        lineId,
        excludeVendorId: projectText(c.vendorId),
        candidateId: projectText(c.id),
        selections: Map.of(selections),
        fulfillmentMethod: projectText(c.fulfillmentMethod),
      );
      if (mounted && offerLoads[lineId] == token) {
        setState(() => offers[lineId] = result);
      }
    } on DiscoveryFailure catch (e) {
      if (mounted && offerLoads[lineId] == token) {
        setState(() => offerErrors[lineId] = alternativesError(e));
      }
    }
  }

  Future<void> _add(
    api.WorkPackageAlternative offer,
    ProjectData line,
    api.WorkPackageAlternativePage page,
  ) async {
    if (adding != null || busy || pricing) return;
    final variant = projectText(offer.variantId);
    setState(() {
      adding = variant;
      error = null;
    });
    try {
      await widget.repository.saveDraftItem(
        packageId: projectText(package.id),
        candidateId: projectText(c.id),
        lineId: projectText(line['line_id']),
        offer: offer,
        lockVersion: projectInt(package.lockVersion),
        selections: Map.of(selections),
        fulfillmentMethod: projectText(c.fulfillmentMethod),
      );
      if (mounted) await _reprice();
    } on DiscoveryFailure catch (e) {
      if (mounted) setState(() => error = e.message);
    } finally {
      if (mounted) setState(() => adding = null);
    }
  }

  Future<void> _remove(api.ProjectSeparatePurchase item) async {
    if (adding != null || busy || pricing) return;
    setState(() {
      adding = projectText(item.variantId);
      error = null;
    });
    try {
      await widget.repository.removeDraftItem(
        packageId: projectText(package.id),
        candidateId: projectText(c.id),
        lineId: projectText(item.lineId),
        variantId: projectText(item.variantId),
        lockVersion: projectInt(package.lockVersion),
      );
      if (mounted) await _reprice();
    } on DiscoveryFailure catch (e) {
      if (mounted) setState(() => error = e.message);
    } finally {
      if (mounted) setState(() => adding = null);
    }
  }

  Future<void> _choose(bool select) async {
    if (busy) return;
    final pending = pendingChoices;
    if (pending.isNotEmpty) return _chooseSpecification(pending.first);
    if (select) {
      await Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => ProjectSelectionCheckoutScreen(
            repository: widget.repository,
            package: package,
            candidate: c,
            selections: Map.of(selections),
            links: widget.links,
          ),
        ),
      );
      if (mounted) await _reprice();
      return;
    }
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final result = await chooseCandidate(
        context,
        repository: widget.repository,
        package: package,
        candidate: c,
        select: select,
        keys: keys,
        selections: Map.of(selections),
      );
      if (result == null || !mounted) return;
      widget.links.openConversation(context, result);
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
        packageId: projectText(package.id),
        line: line,
        excludeVendorId: projectText(c.vendorId),
        candidateId: projectText(c.id),
        first: offers[lineId],
        remainingQuantity: () =>
            materialQuantity(fulfillmentLine(c, lineId)?.remainingQuantity),
        selections: Map.of(selections),
        fulfillmentMethod: projectText(c.fulfillmentMethod),
        onAdd: (offer, page) => _add(offer, line, page),
        actionError: () => error,
        selectedItems: () => [
          for (final item in separate)
            if (item.lineId == lineId && item.stage.name == 'DRAFT') item,
        ],
        onRemove: _remove,
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
    final estimateState = projectText(widget.estimate?.state);
    final quotation = projectText(c.currentQuotationState);
    final pending = pendingChoices;
    final store = projectText(c.storeName);
    final hasSeparate = separate.isNotEmpty;
    final total = hasSeparate
        ? c.procurementTotalCentavos
        : c.projectedTotalCentavos;
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
                            : 'Select this quotation',
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
            StatusBand(
              tone: BandTone.danger,
              title: error!,
              action: TextButton(
                onPressed: busy || pricing
                    ? null
                    : () {
                        setState(() {
                          pricing = true;
                          error = null;
                        });
                        unawaited(_loadArrangement());
                      },
                child: const Text('Retry'),
              ),
            ),
            const SizedBox(height: 12),
          ],
          _StoreHeader(
            candidate: c,
            onOpenStore: () =>
                widget.links.openStore(context, projectText(c.vendorId)),
          ),
          const SizedBox(height: 12),
          StatusBand(
            tone: estimateState == 'ACTIVE' && c.stale != true
                ? BandTone.info
                : BandTone.warning,
            title: 'System-compiled estimate · advisory',
            message: c.stale == true
                ? 'Prices, stock or delivery rates changed. Refresh the estimate before selecting.'
                : estimateState == 'ACTIVE'
                ? 'Valid until ${formatManilaDateTime(DateTime.parse(projectText(widget.estimate!.expiresAt)))}. Vendor confirmation follows your request.'
                : 'This estimate is no longer active. Refresh it from Vendor selection.',
          ),
          if (quotation != 'NO_INQUIRY') ...[
            const SizedBox(height: 8),
            StatusBand(
              tone: BandTone.info,
              title: 'Vendor quotation: ${projectStatus(quotation)}',
              message: 'Review the Vendor-issued terms in your conversation.',
              action: TextButton(
                onPressed: actionable ? () => _choose(false) : null,
                child: const Text('Open'),
              ),
            ),
          ],
          _Section(
            title: 'Order summary',
            subtitle: 'Supplied by $store',
            children: [
              _FulfillmentHeader(candidate: c),
              for (final l in projectRows(c.lines))
                if ((double.tryParse(projectText(l['matched_quantity'])) ?? 0) >
                        0 ||
                    l['selection_required'] == true)
                  QuotationSummaryLine(
                    line: l,
                    storeName: store,
                    busy: busy || pricing,
                    fulfillment: fulfillmentLine(c, projectText(l['line_id'])),
                    onChoose: () => _chooseSpecification(l),
                    onOpenProduct: openProduct,
                  ),
              const Divider(height: 24),
              _AmountRow(
                pending.isEmpty
                    ? 'Materials total'
                    : 'Materials total (lowest options)',
                projectMoney(c.materialsCentavos),
                strong: true,
              ),
              Text(
                'Includes VAT ${projectMoney(c.includedVatCentavos)}',
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
                  'Exact matches are selected automatically. Remove a selection to choose another supplier. Review all items in quotation checkout.',
              children: [
                for (final (i, m) in missing.indexed) ...[
                  if (i > 0) const Divider(height: 16),
                  _MissingItem(
                    line: m,
                    fulfillment: fulfillmentLine(c, projectText(m['line_id'])),
                    offers: offers[projectText(m['line_id'])],
                    error: offerErrors[projectText(m['line_id'])],
                    inCart: [
                      for (final s in separate)
                        if (s.lineId == m['line_id']) s,
                    ],
                    adding: adding,
                    onRemove: _remove,
                    onRetry: () => _loadOffers(projectText(m['line_id'])),
                    onAdd: (offer, page) => _add(offer, m, page),
                    onViewList: () => _viewList(m),
                    onOpenProduct: openProduct,
                  ),
                ],
              ],
            ),
          if (separate.any((item) => item.stage.name != 'DRAFT'))
            _Section(
              title: 'Earlier linked purchases',
              subtitle: 'Existing purchases linked to this Work Package.',
              children: [
                for (final line in separate.where(
                  (item) => item.stage.name != 'DRAFT',
                ))
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
              if (hasSeparate) ...[
                Text(
                  store,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              _ModeToggle(
                method: projectText(c.fulfillmentMethod),
                choices: needsFulfillmentChoice(c)
                    ? fulfillmentOptions(c)
                    : const [],
                onChanged: pricing || busy ? null : _chooseMethod,
              ),
              const SizedBox(height: 8),
              Text(
                needsFulfillmentChoice(c)
                    ? 'This Vendor offers both. Pick one; the totals update for it.'
                    : c.fulfillmentMethod == 'DELIVERY' &&
                          projectRows(c.lines).any(
                            (line) =>
                                projectObject(line['load'])['material_kind'] ==
                                'READY_MIXED_CONCRETE',
                          )
                    ? 'Ready-mixed concrete requires Site delivery by mixer truck. All items from this supplier use Site delivery.'
                    : packageMethod == 'BOTH'
                    ? 'Your Work Package accepts either. This Vendor offers ${fulfillmentLabel(c.fulfillmentMethod).toLowerCase()} only.'
                    : 'Set in the activated Work Package. Change it with a new Work Package version.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: BuyerTheme.muted,
                ),
              ),
              if (projectText(c.fulfillmentMethod) == 'DELIVERY') ...[
                const SizedBox(height: 16),
                ProjectDeliveryConfiguration(
                  candidate: ProjectSupplierView.candidate(c),
                ),
              ],
              if (supplierGroups.isNotEmpty) ...[
                const Divider(height: 28),
                Text(
                  'Separate items',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Fulfillment and delivery fees are shown per supplier. Ready-mixed concrete always uses Site delivery.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: BuyerTheme.muted,
                  ),
                ),
                const SizedBox(height: 12),
                for (final (index, group) in supplierGroups.indexed) ...[
                  if (index > 0) const Divider(height: 24),
                  ProjectSupplierFulfillment(
                    group: ProjectSupplierView.draft(group),
                    showStore: true,
                    showItems: true,
                  ),
                  if (group.fulfillmentMethod.name == 'DELIVERY')
                    ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: const EdgeInsets.only(bottom: 8),
                      title: Text(
                        'Delivery details',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      children: [
                        ProjectDeliveryConfiguration(
                          candidate: ProjectSupplierView.draft(group),
                        ),
                      ],
                    ),
                  for (final issue in group.issues)
                    Text(
                      projectText(issue),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                ],
              ],
            ],
          ),
          _Section(
            title: 'Total cost',
            children: [
              _AmountRow(
                hasSeparate ? 'Primary supplier materials' : 'Materials',
                projectMoney(c.materialsCentavos),
              ),
              if (hasSeparate)
                _AmountRow('Separate items', projectMoney(separateTotal)),
              _AmountRow(
                hasSeparate ? 'Primary supplier delivery' : 'Delivery fee',
                deliveryFee(c),
              ),
              if (hasSeparate)
                _AmountRow(
                  'Separate suppliers delivery',
                  c.separateDeliveryCentavos == null
                      ? 'Vendor review'
                      : projectMoney(c.separateDeliveryCentavos),
                ),
              const _AmountRow('Processing fee', 'Shown at payment'),
              const Divider(height: 24),
              Center(
                child: Column(
                  children: [
                    Text(
                      total == null
                          ? pricing
                                ? 'Updating total…'
                                : 'Cost review required'
                          : projectMoney(total),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      total == null
                          ? 'A complete total needs all delivery estimates'
                          : hasSeparate
                          ? 'Projected total · all suppliers'
                          : 'Projected total from this Vendor',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: BuyerTheme.muted,
                      ),
                    ),
                  ],
                ),
              ),
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
                          projectMoney(package.budgetCentavos),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  BudgetStatusChip(
                    hasSeparate
                        ? projectText(c.procurementBudgetLabel?.name)
                        : projectText(c.budgetLabel),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: FulfillmentScoreTile(
              factors: projectObject(c.fms),
              displayName: c.storeName,
            ),
          ),
          const ProjectProcurementRules(),
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
    final compact = title != 'Total cost' && title != 'Delivery mode';
    return Container(
      margin: EdgeInsets.only(top: compact ? 12 : 16),
      padding: EdgeInsets.all(compact ? 12 : 16),
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
  final api.ProjectCandidate candidate;
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
                      projectText(candidate.storeName),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${kilometres(candidate.distanceMeters)} · ${projectText(candidate.scoreLabel)} · ${fulfillmentLabel(candidate.fulfillmentMethod)}',
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

/// The quotation's item fulfillment, the same figure the Vendor card shows,
/// above the lines it counts.
class _FulfillmentHeader extends StatelessWidget {
  const _FulfillmentHeader({required this.candidate});
  final api.ProjectCandidate candidate;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final f = candidateFulfillment(candidate);
    final (text, color) = switch (f.status.name) {
      'COMPLETE' => ('Every material covered', BuyerTheme.successStrong),
      'NONE' => ('Nothing covered yet', BuyerTheme.actionPressed),
      _ => ('Partly covered', BuyerTheme.actionPressed),
    };
    return Semantics(
      container: true,
      label: 'Item fulfillment ${fulfillmentSummary(candidate)}, $text',
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'Item fulfillment '),
                    TextSpan(
                      text: fulfillmentSummary(candidate),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.end,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A separate Item-Based purchase in the cart, with the store that supplies it.
class _SeparateLine extends StatelessWidget {
  const _SeparateLine({
    required this.line,
    required this.onOpen,
    this.onRemove,
  });
  final api.ProjectSeparatePurchase line;
  final OpenProduct? onOpen;
  final VoidCallback? onRemove;
  @override
  Widget build(BuildContext context) =>
      ProjectSupplementRow(item: line, onOpen: onOpen, onRemove: onRemove);
}

/// Why a search for a missing line found nothing, from what the server left out.
String noAlternativeMessage(
  api.WorkPackageAlternativePage offers,
  ProjectData line,
) {
  final radius = projectSearchRadiusKm;
  final needed =
      '${materialQuantity(offers.neededQuantity)} ${projectText(line['unit_code'])}'
          .trim();
  final excluded = offers.excluded;
  final out = projectInt(excluded.outOfStock);
  final cannot = projectInt(excluded.cannotServeFulfillment);
  return [
    'No suitable product within $radius km for the $needed still needed.',
    if (out > 0) '$out listing${out == 1 ? ' is' : 's are'} out of stock.',
    if (cannot > 0)
      '$cannot listing${cannot == 1 ? '' : 's'} cannot serve this Work Package\'s delivery or pick-up.',
  ].join(' ');
}

class _MissingItem extends StatelessWidget {
  const _MissingItem({
    required this.line,
    required this.fulfillment,
    required this.offers,
    required this.error,
    required this.inCart,
    required this.adding,
    required this.onRetry,
    required this.onAdd,
    required this.onViewList,
    required this.onRemove,
    this.onOpenProduct,
  });
  final ProjectData line;

  /// The server's fulfillment row for this line: what is still to source.
  final api.ProjectFulfillmentLine? fulfillment;
  final api.WorkPackageAlternativePage? offers;
  final String? error;
  final List<api.ProjectSeparatePurchase> inCart;
  final String? adding;
  final VoidCallback onRetry, onViewList;
  final void Function(
    api.WorkPackageAlternative offer,
    api.WorkPackageAlternativePage page,
  )
  onAdd;
  final OpenProduct? onOpenProduct;
  final Future<void> Function(api.ProjectSeparatePurchase item) onRemove;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = (offers?.items.toList() ?? <api.WorkPackageAlternative>[]);
    final unlisted = offers?.status.name == 'UNLISTED';
    final covered = fulfillment?.status.name == 'FULFILLED';
    final remaining = fulfillment == null
        ? missingQuantity(line)
        : '${materialQuantity(fulfillment?.remainingQuantity)} ${projectText(line['unit_code'])}'
              .trim();
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
                  if (line['reason'] != 'NO_EXACT_ACTIVE_MATCH')
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
              covered ? 'Covered' : remaining,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: covered
                    ? BuyerTheme.successStrong
                    : BuyerTheme.actionPressed,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        for (final item in inCart)
          _SeparateLine(
            line: item,
            onOpen: onOpenProduct,
            onRemove: item.stage.name == 'DRAFT' && adding == null
                ? () => onRemove(item)
                : null,
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
        else if (offers!.status.name == 'COVERED')
          Text(
            'Covered by the current arrangement. Remove a draft item to change the supplier.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: BuyerTheme.successStrong,
            ),
          )
        else if (items.isEmpty)
          Text(
            noAlternativeMessage(offers!, line),
            style: theme.textTheme.bodySmall?.copyWith(color: BuyerTheme.muted),
          )
        else ...[
          Text(
            'Recommended from other stores within $projectSearchRadiusKm km',
            style: theme.textTheme.labelLarge?.copyWith(
              color: BuyerTheme.muted,
              fontWeight: FontWeight.w700,
            ),
          ),
          for (final offer in items.take(3))
            OfferRow(
              offer: offer.rebuild(
                (b) => b.alreadyAdded =
                    offer.alreadyAdded == true ||
                    inCart.any((item) => item.variantId == offer.variantId),
              ),
              onRemove: adding != null
                  ? null
                  : () {
                      final item = inCart
                          .where(
                            (item) =>
                                item.variantId == offer.variantId &&
                                item.stage.name == 'DRAFT',
                          )
                          .firstOrNull;
                      if (item != null) onRemove(item);
                    },
              quantity: materialQuantity(offers!.neededQuantity),
              adding: adding == offer.variantId,
              onAdd: adding == null ? () => onAdd(offer, offers!) : null,
              onOpen: onOpenProduct,
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onViewList,
              icon: const Icon(LucideIcons.list, size: 18),
              label: Text('View list (${projectInt(offers!.total)})'),
            ),
          ),
        ],
      ],
    );
  }
}

/// A recommended product with draft Add and Remove actions.
class OfferRow extends StatelessWidget {
  const OfferRow({
    super.key,
    required this.offer,
    required this.adding,
    required this.onAdd,
    this.onOpen,
    this.onRemove,
    this.quantity,
  });
  final String? quantity;
  final api.WorkPackageAlternative offer;
  final bool adding;
  final VoidCallback? onAdd, onRemove;
  final OpenProduct? onOpen;
  @override
  Widget build(BuildContext context) {
    final added = offer.alreadyAdded == true;
    final listing = offer.listingId as String?;
    final exact = offer.exactMatch == true;
    return ProductSummaryRow(
      name: [
        projectText(offer.displayName),
        projectText(offer.variantLabel),
      ].where((s) => s.isNotEmpty).join(' · '),
      imageUrl: offer.image?.url,
      specifications: specificationDetails(offer.specifications),
      details:
          '${projectText(offer.storeName)} · ${kilometres(offer.distanceMeters)} · ${projectText(offer.stockLabel)}'
          '${offer.fulfillmentMethods.length == 1 && offer.fulfillmentMethods.single.name == 'DELIVERY' ? '\nSite delivery only' : ''}',
      price: [
        '${projectMoney(offer.unitPriceCentavos)} / ${projectText(offer.unitCode)}',
        if (quantity != null) 'Needed $quantity ${projectText(offer.unitCode)}',
        '${projectMoney(offer.estimatedTotalCentavos)} estimate',
      ].join(' · '),
      status: exact
          ? (offer.availability.name == 'PARTIAL'
                ? 'Matches specifications · partial quantity'
                : 'Matches specifications')
          : 'Different specifications — does not close the requirement',
      statusIsSuccess: exact,
      onOpen: onOpen == null || listing == null
          ? null
          : () => onOpen!(listing, offer.variantId as String?),
      action: TextButton.icon(
        onPressed: adding
            ? null
            : added
            ? onRemove
            : onAdd,
        icon: Icon(added ? LucideIcons.minus : LucideIcons.plus, size: 16),
        label: Text(
          adding
              ? 'Updating…'
              : added
              ? (onRemove == null ? 'Already selected' : 'Remove')
              : 'Add',
        ),
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
    required this.candidateId,
    required this.first,
    required this.remainingQuantity,
    required this.selections,
    required this.fulfillmentMethod,
    required this.onAdd,
    required this.selectedItems,
    required this.actionError,
    required this.onRemove,
    this.onOpen,
  });
  final ProjectsRepository repository;
  final String packageId, excludeVendorId, candidateId, fulfillmentMethod;
  final Map<String, String> selections;
  final OpenProduct? onOpen;
  final ProjectData line;
  final api.WorkPackageAlternativePage? first;
  final String Function() remainingQuantity;
  final Future<void> Function(
    api.WorkPackageAlternative offer,
    api.WorkPackageAlternativePage page,
  )
  onAdd;
  final List<api.ProjectSeparatePurchase> Function() selectedItems;
  final String? Function() actionError;
  final Future<void> Function(api.ProjectSeparatePurchase item) onRemove;
  @override
  State<_OfferListSheet> createState() => _OfferListSheetState();
}

class _OfferListSheetState extends State<_OfferListSheet> {
  late api.WorkPackageAlternativePage? page = widget.first;
  late List<api.WorkPackageAlternative> items =
      widget.first?.items.toList() ?? [];
  bool loading = false;
  String? adding, error;
  Future<void> _more({bool reset = false}) async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final next = await widget.repository.alternatives(
        widget.packageId,
        projectText(widget.line['line_id']),
        page: reset ? 1 : projectInt(page?.page) + 1,
        excludeVendorId: widget.excludeVendorId,
        candidateId: widget.candidateId,
        selections: widget.selections,
        fulfillmentMethod: widget.fulfillmentMethod,
      );
      if (mounted) {
        setState(() {
          page = next;
          items = <String, api.WorkPackageAlternative>{
            for (final item in [if (!reset) ...items, ...next.items])
              projectText(item.variantId): item,
          }.values.toList();
        });
      }
    } on DiscoveryFailure catch (e) {
      if (mounted) setState(() => error = alternativesError(e));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _change(String variant, Future<void> Function() action) async {
    if (adding != null || loading) return;
    setState(() {
      adding = variant;
      error = null;
    });
    await action();
    if (!mounted) return;
    setState(() => error = widget.actionError());
    if (error == null) await _more(reset: true);
    if (mounted) setState(() => adding = null);
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
            'Still needed: ${widget.remainingQuantity()} ${projectText(widget.line['unit_code'])} · within $projectSearchRadiusKm km · draft selections for this Work Package',
            style: theme.textTheme.bodySmall?.copyWith(color: BuyerTheme.muted),
          ),
          for (final item in widget.selectedItems())
            ProjectSupplementRow(
              item: item,
              onOpen: widget.onOpen,
              onRemove: adding != null || loading
                  ? null
                  : () => _change(
                      projectText(item.variantId),
                      () => widget.onRemove(item),
                    ),
            ),
          for (final offer in items.where(
            (offer) => !widget.selectedItems().any(
              (item) => item.variantId == offer.variantId,
            ),
          ))
            OfferRow(
              offer: offer,
              quantity: materialQuantity(page?.neededQuantity),
              onOpen: widget.onOpen,
              adding: adding == offer.variantId,
              onAdd: adding != null || loading || page == null
                  ? null
                  : () => _change(
                      projectText(offer.variantId),
                      () => widget.onAdd(offer, page!),
                    ),
            ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(error!),
            ),
          if (page?.hasMore == true)
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

/// The fulfillment method as a two-way toggle. Read-only when the activated
/// package fixes it (owner decision 2026-10-12) or the Vendor offers one
/// method; selectable when [choices] lists both, for a Both package.
class _ModeToggle extends StatelessWidget {
  const _ModeToggle({
    required this.method,
    required this.choices,
    required this.onChanged,
  });
  final String method;
  final List<String> choices;
  final ValueChanged<String>? onChanged;
  bool get _selectable => choices.length > 1;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget option(String value, String label, IconData icon) {
      final on = value == method;
      final tile = Container(
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
              on && !_selectable ? LucideIcons.lock : icon,
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
      );
      if (!_selectable) return Expanded(child: tile);
      return Expanded(
        child: Semantics(
          button: true,
          selected: on,
          label: label,
          excludeSemantics: true,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: on || onChanged == null ? null : () => onChanged!(value),
            child: tile,
          ),
        ),
      );
    }

    final toggle = Container(
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
    );
    if (_selectable) return toggle;
    return Semantics(
      label:
          'Delivery mode ${method == 'DELIVERY' ? 'Site delivery' : 'Self pick-up'}, locked',
      excludeSemantics: true,
      child: toggle,
    );
  }
}

class ProjectDeliveryConfiguration extends StatelessWidget {
  const ProjectDeliveryConfiguration({super.key, required this.candidate});
  final ProjectSupplierView candidate;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final delivery = candidate.delivery;
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
          _AmountRow(
            'Delivery fee',
            candidate.method == 'PICKUP'
                ? 'Pick-up · ₱0.00'
                : candidate.deliveryCentavos == null
                ? 'Vendor review'
                : projectMoney(candidate.deliveryCentavos),
            strong: true,
          ),
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

class ProjectProcurementRules extends StatelessWidget {
  const ProjectProcurementRules({super.key, this.grouped = false});
  final bool grouped;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rules = [
      grouped
          ? 'One procurement arrangement is selected for this Work Package. Group members supply their assigned materials independently.'
          : 'One Project-Based Vendor is awarded each Work Package as a package deal.',
      grouped
          ? 'Each vendor confirms its own quotation, delivery and order. Selecting a group does not confirm orders or start payment.'
          : 'Missing items are bought through separate Item-Based orders and linked to the package; nothing is substituted silently.',
      'System estimates are advisory for 48 hours. Vendor quotations are separate and versioned.',
      'A purchase above the Work Package or Project budget needs a written override.',
    ];
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: vendorCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.shieldCheck,
                size: 18,
                color: BuyerTheme.muted,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Procurement rules',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < rules.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i < rules.length - 1 ? 4 : 0),
              child: Text(
                '• ${rules[i]}',
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
