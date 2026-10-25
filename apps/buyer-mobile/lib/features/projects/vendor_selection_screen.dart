import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/components/buyer_overlays.dart';
import '../../design_system/components/discovery_controls.dart';
import '../../design_system/components/form_dialog.dart';
import '../../design_system/components/procurement_components.dart';
import '../../design_system/components/supplier_route_tile.dart';
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
  required api.WorkPackageView package,
  required api.ProjectCandidate candidate,
  required bool select,
  required Map<String, String> keys,
  Map<String, String> selections = const {},
}) async {
  // A Vendor offering both Delivery and Pickup needs the Buyer's pick; the
  // candidate shown is already priced for it.
  final method = needsFulfillmentChoice(candidate)
      ? projectText(candidate.fulfillmentMethod)
      : null;
  if (select) {
    throw StateError('Direct selection must pass through quotation checkout.');
  }
  // Different specification or method choices are a different request, never a retry.
  final action =
      '${select ? 'select' : 'inquire'}:${candidate.id}:${method ?? ''}:'
      '${(selections.entries.map((e) => '${e.key}=${e.value}').toList()..sort()).join(',')}';
  final result = await repository.candidate(
    projectText(package.id),
    {
      'lock_version': projectInt(package.lockVersion),
      'candidate_id': candidate.id,
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
  api.WorkPackageView package,
  api.ProjectCompiledEstimate? estimate,
  api.ProjectCandidate c,
) =>
    package.projectStatus.name == 'ACTIVE' &&
    ['ACTIVE', 'QUOTATION_INQUIRY'].contains(package.status) &&
    c.stale != true &&
    estimate?.state == 'ACTIVE';

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
  final api.WorkPackageView package;
  final SupplierMapBuilder mapBuilder;
  final ProjectSourcingLinks links;
  final api.ProjectEstimatePage? initialEstimates;

  @override
  State<VendorSelectionScreen> createState() => _VendorSelectionScreenState();
}

class _VendorSelectionScreenState extends State<VendorSelectionScreen> {
  late api.WorkPackageView package = widget.package;
  _ComparisonPage? page;
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
  String? error, selected, focusedVendor;
  final routes = <String, api.ProjectRoute>{};
  Map<String, List<GeoPoint>> routePaths = {};
  final routeErrors = <String, String>{};
  final routeLoading = <String>{};
  final sheet = DraggableScrollableController();
  double sheetSize = .42;
  Timer? _sheetSettle;

  /// The selected option's card, brought to the top of the list on selection.
  final _selectedCard = GlobalKey();
  int sequence = 0, routeSequence = 0;
  int recenterToken = 0;
  final keys = <String, String>{};

  ProjectsRepository get repo => widget.repository;
  String get id => projectText(package.id);
  ProjectData get content => projectObject(package.version?.content);
  api.ProjectCompiledEstimate? get estimate => page?.estimate;
  List<_ComparisonOption> get candidates => page?.items ?? [];
  _ComparisonOption? get selectedOption =>
      candidates.where((c) => c.id == selected).firstOrNull;
  bool get legacy =>
      package.selectedArrangementId == null &&
      package.procurementCandidateId != null;

  /// Always the fixed Project-Based radius, never a value read back from a
  /// package or estimate saved before the radius was fixed.
  int get radius => projectSearchRadiusKm;
  List<_MapVendor> get mapVendors {
    final byId = <String, _MapVendor>{};
    for (final option
        in selectedOption == null ? candidates : [selectedOption!]) {
      for (final vendor in option.vendors) {
        byId[vendor.vendorId] = vendor;
      }
    }
    return byId.values.toList();
  }

  Set<String> get highlightedVendors => {
    for (final option in candidates.where((c) => c.id == selected))
      for (final vendor in option.vendors) vendor.vendorId,
  };

  /// An estimate scanned at another radius is outdated and is replaced.
  bool get radiusOutdated =>
      estimate != null &&
      projectInt(projectObject(estimate!.context)['radius_km']) != radius;
  bool get scannable =>
      package.projectStatus.name == 'ACTIVE' &&
      ['ACTIVE', 'QUOTATION_INQUIRY'].contains(package.status);

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
    final state = projectText(estimate?.state);
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
    _sheetSettle?.cancel();
    sheet.dispose();
    wideScroll.dispose();
    super.dispose();
  }

  /// Rebuilding the screen (and re-padding the Google map) on every frame of
  /// a drag or snap made the sheet lag and the camera fight the Buyer. Apply
  /// the size once the sheet has stopped, as Map home does.
  bool _sheetMoved(DraggableScrollableNotification notification) {
    _sheetSettle?.cancel();
    final extent = notification.extent;
    _sheetSettle = Timer(const Duration(milliseconds: 120), () {
      if (mounted && (extent - sheetSize).abs() > 0.002) {
        setState(() => sheetSize = extent);
      }
    });
    return false;
  }

  void _resetSelection() {
    routeSequence++;
    selected = null;
    focusedVendor = null;
    routes.clear();
    routePaths = {};
    routeErrors.clear();
    routeLoading.clear();
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
      if (!append) {
        rankingsCurrent = false;
        _resetSelection();
      }
      error = null;
    });
    try {
      final next = legacy
          ? _ComparisonPage.fromVendors(
              await repo.estimates(
                id,
                page: append ? projectInt(page?.page) + 1 : 1,
                sort: sort,
                // Best Match is a fixed ranking: it has no direction to send.
                direction: vendorSortDescending.containsKey(sort)
                    ? vendorSortDirection(sortDescending)
                    : null,
                favoritesOnly: favorites,
                completeOnly: complete,
                withinBudget: withinBudget,
              ),
            )
          : _ComparisonPage.fromGroups(
              await repo.arrangementOptions(
                id,
                page: append ? projectInt(page?.page) + 1 : 1,
                sort: sort,
                direction: vendorSortDirection(sortDescending),
                favoritesOnly: favorites,
                completeOnly: complete,
                withinBudget: withinBudget,
              ),
            );
      if (!mounted || token != sequence) return;
      setState(() {
        page = append ? next.withItems([...candidates, ...next.items]) : next;
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
      await repo.compile(id, projectInt(package.lockVersion));
      package = await repo.package(id);
      await _load();
    });
  }

  Future<void> _select(String candidate, {String? vendorId}) async {
    if (loading || busy) return;
    final matching = candidates
        .where(
          (c) =>
              c.id == candidate ||
              c.vendors.any((v) => v.vendorId == candidate),
        )
        .toList();
    if (matching.isEmpty) return;
    final option = matching.firstWhere(
      (c) => c.id == selected,
      orElse: () => matching.first,
    );
    final members = option.vendors;
    if (members.isEmpty) return;
    final member = members.firstWhere(
      (v) =>
          v.vendorId ==
          (vendorId ?? (candidate == option.id ? focusedVendor : candidate)),
      orElse: () => members.first,
    );
    final changed = selected != option.id;
    final lowerSheet = changed && sheet.isAttached && sheet.size > .42;
    setState(() {
      if (changed) _resetSelection();
      selected = option.id;
      focusedVendor = member.vendorId;
      // The map frames the routes for the lowered sheet at once, instead of
      // fitting now and again when the sheet settles.
      if (lowerSheet) sheetSize = .42;
    });
    // Focusing another member of the same option only moves the map. A new
    // option keeps its card in place under the finger: the card glides to the
    // top of the list (its routes open inside it) while the sheet eases down
    // to reveal the map, as one motion instead of a jump to the list's top.
    if (changed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final reduced = MediaQuery.disableAnimationsOf(context);
        const duration = Duration(milliseconds: 320);
        const curve = Curves.easeOutCubic;
        final card = _selectedCard.currentContext;
        if (card != null) {
          unawaited(
            Scrollable.ensureVisible(
              card,
              duration: reduced ? Duration.zero : duration,
              curve: curve,
            ),
          );
        }
        if (lowerSheet && sheet.isAttached) {
          if (reduced) {
            sheet.jumpTo(.42);
          } else {
            unawaited(sheet.animateTo(.42, duration: duration, curve: curve));
          }
        }
      });
      // Each member gets an independent provider result and retry state.
      await Future.wait(members.map(_loadRoute));
    }
  }

  Future<void> _loadRoute(_MapVendor member) async {
    final vendorId = member.vendorId;
    if (routeLoading.contains(vendorId)) return;
    final token = routeSequence;
    final version = package.currentVersionId;
    setState(() {
      routeLoading.add(vendorId);
      routeErrors.remove(vendorId);
    });
    try {
      api.ProjectRoute result;
      try {
        result = await repo.route(id, member.candidateId);
      } on DiscoveryFailure catch (e) {
        // The road provider can time out when every member asks at once; a
        // transient 503 gets one quiet retry before the Buyer sees an error.
        if (e.code != 'ROUTE_UNAVAILABLE' ||
            !mounted ||
            token != routeSequence) {
          rethrow;
        }
        result = await repo.route(id, member.candidateId);
      }
      if (!mounted || token != routeSequence) return;
      final path = decodePolyline(result.encodedPolyline);
      if (result.versionId != version ||
          result.candidateId != member.candidateId ||
          projectText(result.origin) != 'PROJECT_SITE' ||
          path.length < 2 ||
          DateTime.tryParse(result.computedAt) == null ||
          result.distanceMeters < 0 ||
          result.durationSeconds < 0) {
        setState(() {
          routeErrors[vendorId] =
              'A current road route could not be confirmed. Retry or refresh the options.';
        });
      } else {
        setState(() {
          routes[vendorId] = result;
          routePaths = {...routePaths, vendorId: path};
        });
      }
    } on DiscoveryFailure catch (e) {
      if (mounted && token == routeSequence) {
        setState(() => routeErrors[vendorId] = e.message);
      }
    } finally {
      if (mounted && token == routeSequence) {
        setState(() => routeLoading.remove(vendorId));
      }
    }
  }

  /// Back to every option on the map, framed on the whole search area.
  void _hideRoutes() => setState(() {
    _resetSelection();
    recenterToken++;
  });

  Future<void> _choose(api.ProjectCandidate c, bool select) async {
    // A specification or a Delivery/Pickup method still to choose is chosen on
    // the quotation first, where each method shows its own total.
    if (select || c.selectionRequired == true || needsFulfillmentChoice(c)) {
      return _openQuotation(_ComparisonOption.vendor(c));
    }
    return _chooseNow(c, select);
  }

  Future<void> _chooseNow(api.ProjectCandidate c, bool select) =>
      _run(() async {
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

  Future<void> _openQuotation(_ComparisonOption c) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => c.group != null
            ? ProjectArrangementScreen(
                repository: repo,
                package: package,
                option: c.group!,
                links: widget.links,
              )
            : VendorQuotationScreen(
                repository: repo,
                package: package,
                candidate: c.vendor!,
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
                          resultId: projectText(vendor.vendorId),
                          tier: SupplierTier.verified,
                          rank: i + 1,
                          name: projectText(vendor.name),
                          point: GeoPoint(
                            (vendor.latitude as num).toDouble(),
                            (vendor.longitude as num).toDouble(),
                          ),
                          distanceMeters: projectInt(vendor.distanceMeters),
                          scoreKind: vendor.vps == null
                              ? ScoreKind.newVendor
                              : ScoreKind.vps,
                          scoreText: projectText(vendor.scoreLabel),
                        ),
                    ],
                    origin: origin,
                    radiusKm: radius,
                    selectedId: focusedVendor,
                    highlightedIds: highlightedVendors,
                    routePath: routePaths[focusedVendor],
                    routePaths: routePaths,
                    onSelect: _select,
                    bottomInset: wide ? 0 : size.maxHeight * sheetSize,
                    recenterToken: recenterToken,
                    procurementContext: SupplierMapContext.projectBased,
                  ),
                ),
              ),
              const Positioned(
                left: 12,
                top: 12,
                child: _RadiusBadge(radius: projectSearchRadiusKm),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: MapFloatingIconButton(
                  icon: LucideIcons.locateFixed,
                  label: 'Show the whole $projectSearchRadiusKm km area',
                  onPressed: () => setState(() => recenterToken++),
                ),
              ),
            ],
          );
          // Built lazily: a route or loading update rebuilds only the cards on
          // screen, not every option on the page.
          Widget list(ScrollController controller) {
            listScroll = controller;
            final options = candidates;
            final more = page?.hasMore == true;
            return ListView.builder(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: 1 + options.length + (more ? 1 : 0),
              itemBuilder: (context, i) {
                if (i == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _results(context, point),
                  );
                }
                if (i <= options.length) {
                  return _option(i - 1, options[i - 1]);
                }
                return OutlinedButton(
                  onPressed: loading ? null : () => _load(append: true),
                  child: const Text('More options'),
                );
              },
            );
          }

          return wide
              ? Row(
                  children: [
                    Expanded(child: map),
                    SizedBox(width: 460, child: list(wideScroll)),
                  ],
                )
              : NotificationListener<DraggableScrollableNotification>(
                  onNotification: _sheetMoved,
                  child: Stack(
                    children: [
                      Positioned.fill(child: RepaintBoundary(child: map)),
                      SupplierPreviewSheet(
                        controller: sheet,
                        builder: (context, controller) =>
                            RepaintBoundary(child: list(controller)),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }

  List<Widget> _results(BuildContext context, ProjectData point) {
    final theme = Theme.of(context);
    final state = projectText(estimate?.state);
    final total = projectInt(page?.total);
    final unfiltered = projectInt(page?.unfilteredTotal ?? page?.total);
    final muted = theme.textTheme.bodySmall?.copyWith(color: BuyerTheme.muted);
    final active = state == 'ACTIVE';
    final refresh =
        scannable &&
        estimate != null &&
        (!active || candidates.any((candidate) => candidate.stale == true));
    return [
      // Reserved height, so loading never shifts the list under the finger.
      SizedBox(
        height: 4,
        child: busy || loading ? const LinearProgressIndicator() : null,
      ),
      // Package and site on the left, its budget on the right.
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  projectText(package.name),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      LucideIcons.mapPin,
                      size: 14,
                      color: BuyerTheme.muted,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        projectText(
                          point['label'] ??
                              projectObject(content['site'])['name'],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: muted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Allocated budget',
                  textAlign: TextAlign.end,
                  style: muted,
                ),
                const SizedBox(height: 2),
                Text(
                  projectMoney(package.budgetCentavos),
                  textAlign: TextAlign.end,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      if (estimate == null) ...[
        Text(
          'No scan yet. Find Vendors within $radius km of the Project site.',
          style: muted,
        ),
        if (scannable) ...[
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: busy ? null : _scan,
            icon: const Icon(LucideIcons.search, size: 18),
            label: Text('Find Vendors within $radius km'),
          ),
        ],
      ] else
        // One strip for the estimate's validity and its refresh action.
        Container(
          padding: EdgeInsets.fromLTRB(12, 8, refresh ? 4 : 12, 8),
          decoration: BoxDecoration(
            color: active
                ? BuyerTheme.canvas
                : theme.colorScheme.error.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                active ? LucideIcons.clock : LucideIcons.triangleAlert,
                size: 16,
                color: active ? BuyerTheme.muted : theme.colorScheme.error,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  active
                      ? 'System-compiled estimate · expires ${formatManilaDateTime(DateTime.parse(projectText(estimate!.expiresAt)))}'
                      : 'This estimate is ${projectStatus(state).toLowerCase()}. Refresh it before selecting a Vendor.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: active ? BuyerTheme.muted : theme.colorScheme.error,
                  ),
                ),
              ),
              if (refresh)
                Semantics(
                  label: 'Refresh estimate',
                  excludeSemantics: true,
                  child: TextButton.icon(
                    onPressed: busy ? null : _scan,
                    icon: const Icon(LucideIcons.refreshCw, size: 16),
                    label: const Text('Refresh'),
                  ),
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
      if (estimate != null) ...[
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: VendorSortTabs(
                value: sort,
                descending: sortDescending,
                onChanged: _sort,
                grouped: !legacy,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              total != unfiltered
                  ? '$total of $unfiltered options'
                  : '$unfiltered option${unfiltered == 1 ? '' : 's'}',
              style: muted,
            ),
          ],
        ),
        const Divider(height: 1),
        const SizedBox(height: 8),
        VendorFilterChips(
          favorites: favorites,
          complete: complete,
          withinBudget: withinBudget,
          onChanged: _filter,
        ),
      ],
      const SizedBox(height: 12),
      if (estimate != null && candidates.isEmpty && !loading)
        _EmptyResults(filtered: total != unfiltered),
    ];
  }

  Widget _option(int index, _ComparisonOption c) => KeyedSubtree(
    key: ValueKey(c.id),
    child: Column(
      key: selected == c.id ? _selectedCard : null,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (c.group != null)
          ProjectArrangementCard(
            option: c.group!,
            rankingPosition:
                sort == 'BEST_MATCH' && rankingsCurrent && c.rank != null
                ? projectInt(c.rank)
                : null,
            selected: selected == c.id,
            onSelect: () => _select(projectText(c.id)),
            onVendor: (vendor) => _select(projectText(c.id), vendorId: vendor),
            onReview: () => _openQuotation(c),
            routes: selected == c.id ? _routeTiles(c) : null,
            onHideRoutes: _hideRoutes,
          )
        else ...[
          VendorResultCard(
            candidate: c.vendor!,
            rankingPosition:
                sort == 'BEST_MATCH' &&
                    (page?.sort ?? 'BEST_MATCH') == 'BEST_MATCH' &&
                    rankingsCurrent
                ? index + 1
                : null,
            selected: selected == c.id,
            onSelect: () => _select(projectText(c.id)),
            onMessage:
                !busy && candidateActionable(package, estimate, c.vendor!)
                ? () => _choose(c.vendor!, false)
                : null,
            onViewQuotation: () => _openQuotation(c),
          ),
          if (selected == c.id) ...[
            _routePanel(context, c),
            const SizedBox(height: 12),
          ],
        ],
      ],
    ),
  );

  /// Under a legacy single-Vendor card: its route with a way back to every
  /// option. Quotation groups show [_routeTiles] inside their card instead.
  Widget _routePanel(BuildContext context, _ComparisonOption option) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      OverflowBar(
        alignment: MainAxisAlignment.spaceBetween,
        overflowAlignment: OverflowBarAlignment.end,
        spacing: 12,
        overflowSpacing: 4,
        children: [
          Text(
            'Route from the Project site',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          TextButton(onPressed: _hideRoutes, child: const Text('Hide routes')),
        ],
      ),
      _routeTiles(option),
    ],
  );

  Widget _routeTiles(_ComparisonOption option) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (final member in option.vendors)
        SupplierRouteTile(
          key: ValueKey('vendor-route:${member.vendorId}'),
          dense: true,
          name: member.name,
          selected: member.vendorId == focusedVendor,
          loading: routeLoading.contains(member.vendorId),
          error: routeErrors[member.vendorId],
          distanceMeters: routes[member.vendorId]?.distanceMeters,
          durationSeconds: routes[member.vendorId]?.durationSeconds,
          computedAtLabel: routes[member.vendorId] == null
              ? null
              : formatManilaDateTime(
                  DateTime.parse(routes[member.vendorId]!.computedAt),
                ),
          onSelect: () => _select(option.id, vendorId: member.vendorId),
          onRetry: () => _loadRoute(member),
        ),
    ],
  );
}

/// The fixed Project-Based search radius, shown on the map as a read-only
/// label. There is nothing to choose: 50 km is the only radius.
class _RadiusBadge extends StatelessWidget {
  const _RadiusBadge({required this.radius});
  final int radius;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Search radius $radius kilometres, fixed',
    excludeSemantics: true,
    child: MapFloatingSurface(
      radius: 999,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.radar, size: 16, color: BuyerTheme.action),
            const SizedBox(width: 6),
            Text(
              'Within $radius km',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: BuyerTheme.ink,
              ),
            ),
          ],
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

final class _MapVendor {
  const _MapVendor({
    required this.vendorId,
    required this.candidateId,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.distanceMeters,
    this.vps,
    required this.scoreLabel,
  });
  factory _MapVendor.fromCandidate(api.ProjectCandidate c) => _MapVendor(
    vendorId: c.vendorId,
    candidateId: c.id,
    name: c.storeName,
    latitude: c.latitude.toDouble(),
    longitude: c.longitude.toDouble(),
    distanceMeters: c.distanceMeters,
    vps: c.vps,
    scoreLabel: c.scoreLabel,
  );
  factory _MapVendor.fromJson(ProjectData v) => _MapVendor(
    vendorId: projectText(v['vendor_id']),
    candidateId: projectText(v['candidate_id']),
    name: projectText(v['store_name']),
    latitude: (v['latitude'] as num).toDouble(),
    longitude: (v['longitude'] as num).toDouble(),
    distanceMeters: projectInt(v['distance_meters']),
    vps: v['vps'] as String?,
    scoreLabel: projectText(v['score_label']),
  );
  final String vendorId, candidateId, name, scoreLabel;
  final double latitude, longitude;
  final int distanceMeters;
  final String? vps;
}

final class _ComparisonOption {
  const _ComparisonOption.vendor(api.ProjectCandidate value)
    : vendor = value,
      group = null;
  const _ComparisonOption.group(api.ProjectArrangement value)
    : group = value,
      vendor = null;
  final api.ProjectCandidate? vendor;
  final api.ProjectArrangement? group;
  String get id => vendor?.id ?? group!.id;
  bool get stale => vendor?.stale ?? group!.stale;
  int? get rank => vendor?.rank ?? group?.rank;
  bool get selectionRequired => vendor?.selectionRequired ?? false;
  List<_MapVendor> get vendors => vendor != null
      ? [_MapVendor.fromCandidate(vendor!)]
      : projectRows(group!.vendors)
            .where((v) => v['latitude'] is num && v['longitude'] is num)
            .map(_MapVendor.fromJson)
            .toList();
}

final class _ComparisonPage {
  const _ComparisonPage({
    required this.items,
    required this.estimate,
    required this.page,
    required this.hasMore,
    required this.total,
    required this.unfilteredTotal,
    required this.sort,
  });
  factory _ComparisonPage.fromVendors(api.ProjectEstimatePage p) =>
      _ComparisonPage(
        items: p.items.map(_ComparisonOption.vendor).toList(),
        estimate: p.estimate,
        page: p.page,
        hasMore: p.hasMore,
        total: p.total,
        unfilteredTotal: p.unfilteredTotal ?? p.total,
        sort: p.sort ?? 'BEST_MATCH',
      );
  factory _ComparisonPage.fromGroups(api.ProjectArrangementPage p) =>
      _ComparisonPage(
        items: p.items.map(_ComparisonOption.group).toList(),
        estimate: p.estimate,
        page: p.page,
        hasMore: p.hasMore,
        total: p.total,
        unfilteredTotal: p.unfilteredTotal,
        sort: p.sort?.name ?? 'BEST_MATCH',
      );
  final List<_ComparisonOption> items;
  final api.ProjectCompiledEstimate? estimate;
  final int page, total, unfilteredTotal;
  final bool hasMore;
  final String sort;
  _ComparisonPage withItems(List<_ComparisonOption> items) => _ComparisonPage(
    items: items,
    estimate: estimate,
    page: page,
    hasMore: hasMore,
    total: total,
    unfilteredTotal: unfilteredTotal,
    sort: sort,
  );
}
