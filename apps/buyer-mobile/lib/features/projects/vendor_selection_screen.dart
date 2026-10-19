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
import 'project_arrangement_screen.dart';
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

/// Opens a quotation inquiry. Direct selection belongs to the checklist and
/// quotation checkout. Idempotency keys live in [keys] so a retry reuses them.
Future<String?> chooseCandidate(
  BuildContext context, {
  required ProjectsRepository repository,
  required ProjectData package,
  required ProjectData candidate,
  required bool select,
  required Map<String, String> keys,
  Map<String, String> selections = const {},
}) async {
  // A Vendor offering both Delivery and Pickup needs the Buyer's pick; the
  // candidate shown is already priced for it.
  final method = needsFulfillmentChoice(candidate)
      ? projectText(candidate['fulfillment_method'])
      : null;
  if (select) {
    throw StateError('Direct selection must pass through quotation checkout.');
  }
  // Different specification or method choices are a different request, never a retry.
  final action =
      '${select ? 'select' : 'inquire'}:${candidate['id']}:${method ?? ''}:'
      '${(selections.entries.map((e) => '${e.key}=${e.value}').toList()..sort()).join(',')}';
  final result = await repository.candidate(
    projectText(package['id']),
    {
      'lock_version': projectInt(package['lock_version']),
      'candidate_id': candidate['id'],
      if (selections.isNotEmpty)
        'selections': specificationSelections(selections),
      'fulfillment_method': ?method,
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

  /// Direction of the selected ordering; unused by Best Match. A radius change
  /// rescans but keeps both.
  bool sortDescending = false;

  /// The results list's controller, so a re-sort can return to the top.
  ScrollController? listScroll;
  final wideScroll = ScrollController();
  bool favorites = false, complete = false, withinBudget = false;
  bool busy = false, loading = false;
  // Appending preserves positions; replacing criteria must first load their order.
  bool rankingsCurrent = true;
  String? error, selected, routeError, focusedVendor;
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
  bool get legacy =>
      package['selected_arrangement_id'] == null &&
      package['procurement_candidate_id'] != null;

  /// Always the fixed Project-Based radius, never a value read back from a
  /// package or estimate saved before the radius was fixed.
  int get radius => projectSearchRadiusKm;
  List<ProjectData> get mapVendors {
    final byId = <String, ProjectData>{};
    for (final candidate in candidates) {
      for (final vendor
          in candidate.containsKey('vendors')
              ? projectRows(candidate['vendors'])
              : [candidate]) {
        if (vendor['latitude'] is num && vendor['longitude'] is num) {
          byId[projectText(vendor['vendor_id'])] = vendor;
        }
      }
    }
    return byId.values.toList();
  }

  Set<String> get highlightedVendors => {
    for (final option in candidates.where((c) => c['id'] == selected))
      for (final vendor in projectRows(option['vendors']))
        projectText(vendor['vendor_id']),
  };

  /// An estimate scanned at another radius is outdated and is replaced.
  bool get radiusOutdated =>
      estimate != null &&
      projectInt(projectObject(estimate!['context'])['radius_km']) != radius;
  bool get scannable =>
      package['project_status'] == 'ACTIVE' &&
      ['ACTIVE', 'QUOTATION_INQUIRY'].contains(package['status']);

  @override
  void initState() {
    super.initState();
    page = null;
    unawaited(_open());
  }

  /// Opening Find vendors scans at once: the saved radius when no estimate
  /// exists yet or the saved one expired. An active estimate is shown as-is.
  Future<void> _open() async {
    if (page == null) await _load();
    if (!mounted || !scannable) return;
    final state = projectText(estimate?['state']);
    if (estimate == null ||
        radiusOutdated ||
        (state != 'ACTIVE' && error == null)) {
      await _scan(confirm: false);
    }
  }

  @override
  void dispose() {
    sequence++;
    routeSequence++;
    wideScroll.dispose();
    super.dispose();
  }

  /// Applies a tab tap: the new ordering and direction, re-sorted by the
  /// server, with the list back at the top.
  void _sort(String code, bool descending) {
    setState(() {
      sort = code;
      sortDescending = descending;
    });
    final scroll = listScroll;
    if (scroll != null && scroll.hasClients) scroll.jumpTo(0);
    unawaited(_load());
  }

  Future<void> _load({bool append = false}) async {
    final token = ++sequence;
    setState(() {
      loading = true;
      if (!append) rankingsCurrent = false;
      error = null;
    });
    try {
      final next = legacy
          ? await repo.estimates(
              id,
              page: append ? projectInt(page?['page']) + 1 : 1,
              sort: sort,
              direction: vendorSortDirection(sortDescending),
              favoritesOnly: favorites,
              completeOnly: complete,
              withinBudget: withinBudget,
            )
          : await repo.arrangementOptions(
              id,
              page: append ? projectInt(page?['page']) + 1 : 1,
              sort: sort,
              direction: vendorSortDirection(sortDescending),
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
        rankingsCurrent = true;
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

  Future<void> _scan({bool confirm = true}) async {
    if (confirm &&
        !await _confirm(
          'Find Vendors within $radius km?',
          'Scan from the locked Project site. This replaces the comparison with a fresh 48-hour advisory estimate.',
        )) {
      return;
    }
    await _run(() async {
      await repo.compile(id, projectInt(package['lock_version']));
      package = await repo.package(id);
      selected = null;
      path = null;
      routeSequence++;
      await _load();
    });
  }

  Future<void> _select(String candidate, {String? vendorId}) async {
    final matching = candidates
        .where(
          (c) =>
              c['id'] == candidate ||
              projectRows(c['vendors']).any((v) => v['vendor_id'] == candidate),
        )
        .toList();
    if (matching.isEmpty) return;
    final option = matching.firstWhere(
      (c) => c['id'] == selected,
      orElse: () => matching.first,
    );
    final members = projectRows(option['vendors']);
    final member = members.isEmpty
        ? option
        : members.firstWhere(
            (v) => v['vendor_id'] == (vendorId ?? candidate),
            orElse: () => members.first,
          );
    final routeCandidate = projectText(member['candidate_id'] ?? option['id']);
    candidate = projectText(option['id']);
    final token = ++routeSequence;
    final version = package['current_version_id'];
    setState(() {
      selected = candidate;
      focusedVendor = projectText(member['vendor_id'] ?? member['id']);
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
      final result = await repo.route(id, routeCandidate);
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
    // A specification or a Delivery/Pickup method still to choose is chosen on
    // the quotation first, where each method shows its own total.
    if (select ||
        c['selection_required'] == true ||
        needsFulfillmentChoice(c)) {
      return _openQuotation(c);
    }
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
        builder: (_) => c.containsKey('vendors')
            ? ProjectArrangementScreen(
                repository: repo,
                package: package,
                option: c,
                links: widget.links,
              )
            : VendorQuotationScreen(
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
      appBar: buyerAppBar(context, 'Quotation options'),
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
                      for (final (i, vendor) in mapVendors.indexed)
                        SupplierResultView(
                          resultId: projectText(vendor['vendor_id']),
                          tier: SupplierTier.verified,
                          rank: i + 1,
                          name: projectText(vendor['store_name']),
                          point: GeoPoint(
                            (vendor['latitude'] as num).toDouble(),
                            (vendor['longitude'] as num).toDouble(),
                          ),
                          distanceMeters: projectInt(vendor['distance_meters']),
                          scoreKind: vendor['vps'] == null
                              ? ScoreKind.newVendor
                              : ScoreKind.vps,
                          scoreText: projectText(vendor['score_label']),
                        ),
                    ],
                    origin: origin,
                    radiusKm: radius,
                    selectedId: focusedVendor,
                    highlightedIds: highlightedVendors,
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
                child: const _RadiusBadge(radius: projectSearchRadiusKm),
              ),
            ],
          );
          Widget list(ScrollController controller) {
            listScroll = controller;

            return ListView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: _results(context, point),
            );
          }

          return wide
              ? Row(
                  children: [
                    Expanded(child: map),
                    SizedBox(width: 460, child: list(wideScroll)),
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
                    text: 'Quotation options: ',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: projectText(package['name'])),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              estimate == null
                  ? 'No scan yet. Find Vendors within $radius km of the Project site.'
                  : '$unfiltered procurement option${unfiltered == 1 ? '' : 's'} · suppliers within $radius km'
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
                onPressed: busy ? null : _scan,
                icon: const Icon(LucideIcons.search, size: 18),
                label: Text('Find Vendors within $radius km'),
              ),
            if (scannable &&
                estimate != null &&
                (state != 'ACTIVE' ||
                    candidates.any((candidate) => candidate['stale'] == true)))
              TextButton.icon(
                onPressed: busy ? null : _scan,
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
        descending: sortDescending,
        onChanged: _sort,
        grouped: !legacy,
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
        _EmptyResults(filtered: total != unfiltered),
      for (final (index, c) in candidates.indexed)
        KeyedSubtree(
          key: cardKeys.putIfAbsent(projectText(c['id']), GlobalKey.new),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (c.containsKey('vendors'))
                ProjectArrangementCard(
                  option: c,
                  rankingPosition:
                      sort == 'BEST_MATCH' &&
                          rankingsCurrent &&
                          c['rank'] != null
                      ? projectInt(c['rank'])
                      : null,
                  selected: selected == c['id'],
                  onSelect: () => _select(projectText(c['id'])),
                  onVendor: (vendor) =>
                      _select(projectText(c['id']), vendorId: vendor),
                  onReview: () => _openQuotation(c),
                )
              else
                VendorResultCard(
                  candidate: c,
                  rankingPosition:
                      sort == 'BEST_MATCH' &&
                          (page?['sort'] ?? 'BEST_MATCH') == 'BEST_MATCH' &&
                          rankingsCurrent
                      ? index + 1
                      : null,
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
          child: const Text('More options'),
        ),
    ];
  }
}

/// The fixed Project-Based search radius, shown on the map as one selected,
/// non-interactive chip. There is nothing to choose: 50 km is the only radius.
class _RadiusBadge extends StatelessWidget {
  const _RadiusBadge({required this.radius});
  final int radius;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Semantics(
        label: 'Search radius $radius kilometres, fixed',
        excludeSemantics: true,
        child: ChoiceChip(
          avatar: const Icon(LucideIcons.mapPin, size: 16),
          label: Text('$radius km'),
          selected: true,
          showCheckmark: false,
          onSelected: null,
        ),
      ),
    ),
  );
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.filtered});
  final bool filtered;

  @override
  Widget build(BuildContext context) => StateMessage(
    kind: StateKind.empty,
    compact: true,
    title: filtered
        ? 'No Vendors match these filters'
        : 'No eligible Vendors within $projectSearchRadiusKm km',
    message: filtered
        ? 'Clear a filter to see every Vendor in this estimate.'
        : 'No open Vendor within $projectSearchRadiusKm km of the Project site stocks these materials for this fulfillment method.',
  );
}
