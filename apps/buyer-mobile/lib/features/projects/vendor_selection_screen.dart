import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/components/buyer_overlays.dart';
import '../../design_system/components/form_dialog.dart';
import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import '../map_discovery/map_geometry.dart';
import '../map_discovery/supplier_map.dart';
import '../map_discovery/supplier_preview_sheet.dart';
import '../orders/order_models.dart' show formatManilaDateTime;
import 'projects_repository.dart';
import 'vendor_quotation_screen.dart';
import 'vendor_selection_widgets.dart';

/// Navigation the sourcing screens need from the app shell.
class ProjectSourcingLinks {
  const ProjectSourcingLinks({
    required this.openConversation,
    required this.openOrder,
    required this.openStore,
    this.openCart,
    this.onCartChanged,
    this.openProduct,
  });
  final void Function(BuildContext context, String id) openConversation,
      openOrder,
      openStore;
  final void Function(BuildContext context)? openCart;
  final VoidCallback? onCartChanged;

  /// Product Details for a listing, opened on the quoted variant.
  final void Function(
    BuildContext context,
    String listingId,
    String? variantId,
  )?
  openProduct;
}

/// Messages a Vendor (quotation inquiry) or selects it directly with an
/// optional Note. Returns the conversation or order id, or null when the Buyer
/// cancels. Idempotency keys live in [keys] so a retry reuses them.
Future<String?> chooseCandidate(
  BuildContext context, {
  required ProjectsRepository repository,
  required ProjectData package,
  required ProjectData candidate,
  required bool select,
  required Map<String, String> keys,
  Map<String, String> selections = const {},
}) async {
  String? note, reason;
  if (select) {
    final input = TextEditingController(), override = TextEditingController();
    final confirmed = await showBuyerFormDialog<bool>(
      context: context,
      builder: (context) => BuyerDialog(
        title: Text('Select ${candidate['store_name']}?'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Other active quotations expire. This Vendor manually confirms the package before your final approval.',
              ),
              const SizedBox(height: 12),
              TextField(
                controller: input,
                maxLength: 2000,
                decoration: const InputDecoration(
                  labelText: 'Optional informational Note',
                  helperText: 'No Vendor response required',
                ),
              ),
              TextField(
                controller: override,
                maxLength: 2000,
                decoration: const InputDecoration(
                  labelText: 'Budget override reason',
                  helperText:
                      'Required when the purchase exceeds either budget',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Select Vendor'),
          ),
        ],
      ),
    );
    note = input.text.trim();
    reason = override.text.trim();
    input.dispose();
    override.dispose();
    if (confirmed != true) return null;
  }
  // Different specification choices are a different request, never a retry.
  final action =
      '${select ? 'select' : 'inquire'}:${candidate['id']}:'
      '${(selections.entries.map((e) => '${e.key}=${e.value}').toList()..sort()).join(',')}';
  final result = await repository.candidate(
    projectText(package['id']),
    {
      'lock_version': projectInt(package['lock_version']),
      'candidate_id': candidate['id'],
      if (note?.isNotEmpty ?? false) 'note': note,
      if (reason?.isNotEmpty ?? false) 'budget_override_reason': reason,
      if (selections.isNotEmpty)
        'selections': specificationSelections(selections),
    },
    keys.putIfAbsent(action, projectKey),
    select: select,
  );
  keys.remove(action);
  return result;
}

/// Whether the saved comparison still allows messaging or selecting.
bool candidateActionable(
  ProjectData package,
  ProjectData? estimate,
  ProjectData c,
) =>
    package['project_status'] == 'ACTIVE' &&
    ['ACTIVE', 'QUOTATION_INQUIRY'].contains(package['status']) &&
    c['stale'] != true &&
    projectObject(estimate)['state'] == 'ACTIVE';

/// Map of eligible Project Vendors around the locked site with a sortable,
/// filterable list of system-compiled estimates.
class VendorSelectionScreen extends StatefulWidget {
  const VendorSelectionScreen({
    super.key,
    required this.repository,
    required this.package,
    required this.mapBuilder,
    required this.links,
    this.initialEstimates,
  });
  final ProjectsRepository repository;
  final ProjectData package;
  final SupplierMapBuilder mapBuilder;
  final ProjectSourcingLinks links;
  final ProjectData? initialEstimates;

  @override
  State<VendorSelectionScreen> createState() => _VendorSelectionScreenState();
}

class _VendorSelectionScreenState extends State<VendorSelectionScreen> {
  late ProjectData package = widget.package;
  ProjectData? page;
  String sort = 'BEST_MATCH';
  bool favorites = false, complete = false, withinBudget = false;
  bool busy = false, loading = false;
  String? error, selected, routeError;
  List<GeoPoint>? path;
  ProjectData? route;
  int sequence = 0, routeSequence = 0;
  final keys = <String, String>{};
  final cardKeys = <String, GlobalKey>{};

  ProjectsRepository get repo => widget.repository;
  String get id => projectText(package['id']);
  ProjectData get content =>
      projectObject(projectObject(package['version'])['content']);
  ProjectData? get estimate =>
      page?['estimate'] == null ? null : projectObject(page!['estimate']);
  List<ProjectData> get candidates => projectRows(page?['items']);
  int get radius => projectInt(
    projectObject(estimate?['context'])['radius_km'] ?? content['radius_km'],
  );
  bool get scannable =>
      package['project_status'] == 'ACTIVE' &&
      ['ACTIVE', 'QUOTATION_INQUIRY'].contains(package['status']);

  @override
  void initState() {
    super.initState();
    page = widget.initialEstimates;
    if (page == null) unawaited(_load());
  }

  @override
  void dispose() {
    sequence++;
    routeSequence++;
    super.dispose();
  }

  Future<void> _load({bool append = false}) async {
    final token = ++sequence;
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final next = await repo.estimates(
        id,
        page: append ? projectInt(page?['page']) + 1 : 1,
        sort: sort,
        favoritesOnly: favorites,
        completeOnly: complete,
        withinBudget: withinBudget,
      );
      if (!mounted || token != sequence) return;
      setState(() {
        page = append
            ? {
                ...next,
                'items': [...candidates, ...projectRows(next['items'])],
              }
            : next;
        loading = false;
      });
    } on DiscoveryFailure catch (e) {
      if (mounted && token == sequence) {
        setState(() {
          error = e.message;
          loading = false;
        });
      }
    }
  }

  Future<bool> _confirm(String title, String message) async =>
      await showBuyerFormDialog<bool>(
        context: context,
        builder: (context) => BuyerDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Continue'),
            ),
          ],
        ),
      ) ??
      false;

  Future<void> _run(Future<void> Function() action) async {
    if (busy) return;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await action();
    } on DiscoveryFailure catch (e) {
      if (mounted) setState(() => error = e.message);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _scan(int km) async {
    if (!await _confirm(
      'Find Vendors within $km km?',
      'Scan from the locked Project site. This replaces the comparison with a fresh 48-hour advisory estimate.',
    )) {
      return;
    }
    await _run(() async {
      await repo.compile(id, projectInt(package['lock_version']), km);
      package = await repo.package(id);
      selected = null;
      path = null;
      routeSequence++;
      await _load();
    });
  }

  Future<void> _select(String candidate) async {
    final token = ++routeSequence;
    final version = package['current_version_id'];
    setState(() {
      selected = candidate;
      path = null;
      route = null;
      routeError = null;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final target = cardKeys[candidate]?.currentContext;
      if (target != null) {
        unawaited(
          Scrollable.ensureVisible(
            target,
            duration: MediaQuery.disableAnimationsOf(context)
                ? Duration.zero
                : const Duration(milliseconds: 250),
            alignment: .1,
          ),
        );
      }
    });
    try {
      final result = await repo.route(id, candidate);
      if (mounted &&
          token == routeSequence &&
          result['version_id'] == version) {
        setState(() {
          route = result;
          path = decodePolyline(projectText(result['encoded_polyline']));
        });
      }
    } on DiscoveryFailure catch (e) {
      if (mounted && token == routeSequence) {
        setState(() => routeError = e.message);
      }
    }
  }

  Future<void> _choose(ProjectData c, bool select) async {
    // A specification still to choose is chosen on the quotation first.
    if (c['selection_required'] == true) return _openQuotation(c);
    return _chooseNow(c, select);
  }

  Future<void> _chooseNow(ProjectData c, bool select) => _run(() async {
    final result = await chooseCandidate(
      context,
      repository: repo,
      package: package,
      candidate: c,
      select: select,
      keys: keys,
    );
    if (result == null || !mounted) return;
    if (select) {
      widget.links.openOrder(context, result);
    } else {
      widget.links.openConversation(context, result);
    }
    package = await repo.package(id);
    await _load();
  });

  Future<void> _openQuotation(ProjectData c) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => VendorQuotationScreen(
          repository: repo,
          package: package,
          candidate: c,
          estimate: estimate,
          links: widget.links,
        ),
      ),
    );
    if (!mounted) return;
    package = await repo.package(id).catchError((_) => package);
    await _load();
  }

  void _filter({bool? favorites, bool? complete, bool? withinBudget}) {
    setState(() {
      this.favorites = favorites ?? this.favorites;
      this.complete = complete ?? this.complete;
      this.withinBudget = withinBudget ?? this.withinBudget;
    });
    unawaited(_load());
  }

  @override
  Widget build(BuildContext context) {
    final point = projectObject(projectObject(content['site'])['point']);
    final origin = GeoPoint(
      double.tryParse(projectText(point['latitude'])) ?? 0,
      double.tryParse(projectText(point['longitude'])) ?? 0,
    );
    return Scaffold(
      appBar: buyerAppBar(context, 'Vendor selection'),
      body: LayoutBuilder(
        builder: (context, size) {
          final wide = size.maxWidth >= 1024;
          final map = Stack(
            children: [
              Positioned.fill(
                child: widget.mapBuilder(
                  context,
                  SupplierMapProps(
                    items: [
                      for (final (i, c) in candidates.indexed)
                        SupplierResultView(
                          resultId: projectText(c['id']),
                          tier: SupplierTier.verified,
                          rank: i + 1,
                          name: projectText(c['store_name']),
                          point: GeoPoint(
                            (c['latitude'] as num).toDouble(),
                            (c['longitude'] as num).toDouble(),
                          ),
                          distanceMeters: projectInt(c['distance_meters']),
                          scoreKind: c['vps'] == null
                              ? ScoreKind.newVendor
                              : ScoreKind.vps,
                          scoreText: projectText(c['score_label']),
                        ),
                    ],
                    origin: origin,
                    radiusKm: radius,
                    selectedId: selected,
                    routePath: path,
                    onSelect: _select,
                    bottomInset: wide ? 0 : size.maxHeight * .42,
                    recenterToken: 0,
                    procurementContext: SupplierMapContext.projectBased,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 8,
                child: _RadiusChips(
                  radius: radius,
                  scanned: estimate != null,
                  enabled: scannable && !busy,
                  onChanged: _scan,
                ),
              ),
            ],
          );
          Widget list(ScrollController? controller) => ListView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: _results(context, point),
          );
          return wide
              ? Row(
                  children: [
                    Expanded(child: map),
                    SizedBox(width: 460, child: list(null)),
                  ],
                )
              : Stack(
                  children: [
                    Positioned.fill(child: map),
                    SupplierPreviewSheet(
                      builder: (context, controller) => list(controller),
                    ),
                  ],
                );
        },
      ),
    );
  }

  List<Widget> _results(BuildContext context, ProjectData point) {
    final theme = Theme.of(context);
    final state = projectText(estimate?['state']);
    final total = projectInt(page?['total']);
    final unfiltered = projectInt(page?['unfiltered_total'] ?? page?['total']);
    final suggested = page?['suggested_radius_km'];
    return [
      if (busy || loading) const LinearProgressIndicator(),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  projectText(
                    point['label'] ?? projectObject(content['site'])['name'],
                  ),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  projectText(package['name']),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: BuyerTheme.muted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: BuyerTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Allocated budget',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: BuyerTheme.muted,
                  ),
                ),
                Text(
                  projectMoney(package['budget_centavos']),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: BuyerTheme.canvas,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: BuyerTheme.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Vendor results: ',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: projectText(package['name'])),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              estimate == null
                  ? 'No scan yet. Choose a radius above to find Vendors.'
                  : 'Found $unfiltered Vendor${unfiltered == 1 ? '' : 's'} within $radius km'
                        '${total != unfiltered ? ' · $total match your filters' : ''}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: BuyerTheme.muted,
              ),
            ),
            if (estimate != null)
              Text(
                state == 'ACTIVE'
                    ? 'System-compiled estimate · expires ${formatManilaDateTime(DateTime.parse(projectText(estimate!['expires_at'])))}'
                    : 'This estimate is ${projectStatus(state).toLowerCase()}. Refresh it before selecting a Vendor.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: state == 'ACTIVE'
                      ? BuyerTheme.muted
                      : theme.colorScheme.error,
                ),
              ),
            if (scannable && estimate == null)
              TextButton.icon(
                onPressed: busy ? null : () => _scan(radius),
                icon: const Icon(LucideIcons.search, size: 18),
                label: Text('Find Vendors within $radius km'),
              ),
            if (scannable &&
                estimate != null &&
                (state != 'ACTIVE' ||
                    candidates.any((candidate) => candidate['stale'] == true)))
              TextButton.icon(
                onPressed: busy ? null : () => _scan(radius),
                icon: const Icon(LucideIcons.refreshCw, size: 18),
                label: const Text('Refresh estimate'),
              ),
          ],
        ),
      ),
      if (error != null) ...[
        const SizedBox(height: 12),
        StatusBand(
          tone: BandTone.danger,
          title: error!,
          action: TextButton(onPressed: _load, child: const Text('Retry')),
        ),
      ],
      const SizedBox(height: 8),
      VendorSortTabs(
        value: sort,
        onChanged: (value) {
          setState(() => sort = value);
          unawaited(_load());
        },
      ),
      const Divider(height: 1),
      const SizedBox(height: 8),
      VendorFilterChips(
        favorites: favorites,
        complete: complete,
        withinBudget: withinBudget,
        onChanged: _filter,
      ),
      const SizedBox(height: 12),
      if (estimate != null && candidates.isEmpty && !loading)
        _EmptyResults(
          filtered: total != unfiltered,
          suggestedRadius: scannable && suggested != null
              ? projectInt(suggested)
              : null,
          onWiden: (km) => _scan(km),
        ),
      for (final c in candidates)
        KeyedSubtree(
          key: cardKeys.putIfAbsent(projectText(c['id']), GlobalKey.new),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VendorResultCard(
                candidate: c,
                selected: selected == c['id'],
                onSelect: () => _select(projectText(c['id'])),
                onMessage: !busy && candidateActionable(package, estimate, c)
                    ? () => _choose(c, false)
                    : null,
                onViewQuotation: () => _openQuotation(c),
              ),
              if (selected == c['id'] && (route != null || routeError != null))
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    routeError ??
                        'Road route from the Project site: ${kilometres(route!['distance_meters'])} · about ${(projectInt(route!['duration_seconds']) / 60).ceil()} min',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: BuyerTheme.muted,
                    ),
                  ),
                ),
            ],
          ),
        ),
      if (page?['has_more'] == true)
        OutlinedButton(
          onPressed: loading ? null : () => _load(append: true),
          child: const Text('More Vendors'),
        ),
    ];
  }
}

class _RadiusChips extends StatelessWidget {
  const _RadiusChips({
    required this.radius,
    required this.scanned,
    required this.enabled,
    required this.onChanged,
  });
  final int radius;
  final bool scanned;
  final bool enabled;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Row(
      children: [
        for (final km in [5, 10, 20, 30, 40, 50])
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text('$km km'),
              selected: km == radius,
              showCheckmark: false,
              // The current radius stays enabled so it reads as selected; it
              // only scans again when no scan exists yet.
              onSelected: enabled
                  ? (_) {
                      if (km != radius || !scanned) onChanged(km);
                    }
                  : null,
            ),
          ),
      ],
    ),
  );
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({
    required this.filtered,
    required this.suggestedRadius,
    required this.onWiden,
  });
  final bool filtered;
  final int? suggestedRadius;
  final ValueChanged<int> onWiden;

  @override
  Widget build(BuildContext context) => StateMessage(
    kind: StateKind.empty,
    compact: true,
    title: filtered
        ? 'No Vendors match these filters'
        : 'No eligible Vendors yet',
    message: filtered
        ? 'Clear a filter to see every Vendor in this estimate.'
        : 'Fewer than three Vendors stock these materials nearby.',
    secondaryLabel: !filtered && suggestedRadius != null
        ? 'Search within $suggestedRadius km'
        : null,
    onSecondary: !filtered && suggestedRadius != null
        ? () => onWiden(suggestedRadius!)
        : null,
  );
}
