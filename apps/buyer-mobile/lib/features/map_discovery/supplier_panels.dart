import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollCacheExtent;
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/discovery_controls.dart';
import '../../design_system/components/procurement_components.dart';
import '../../design_system/generated/color_tokens.dart';
import '../../design_system/theme.dart';
import '../../widgets/auth_content.dart';
import 'discovery_controller.dart';
import 'discovery_models.dart';
import 'directory_photo_loader.dart';
import 'map_geometry.dart';
import 'google_place_content.dart';
import 'supplier_browsing.dart';

// Preserve the original import surface while keeping a single canonical enum definition.
export 'supplier_browsing.dart' show SupplierListView;

/// The accessible peer of the map's eligible set, with local supplier tabs, name search and sort.
/// Every row shares the map's selection and route behavior.
class SupplierListPanel extends StatelessWidget {
  const SupplierListPanel({
    super.key,
    required this.controller,
    required this.view,
    required this.sort,
    required this.searchController,
    required this.onQueryChanged,
    required this.onSortChanged,
    required this.onViewChanged,
    required this.onExpand,
    required this.onChangeLocation,
    required this.onAdjustFilters,
    this.scrollController,
    this.onSearchFocused,
  });

  final DiscoveryController controller;
  final SupplierListView view;
  final SupplierListSort sort;
  final TextEditingController searchController;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<SupplierListSort> onSortChanged;
  final VoidCallback? onSearchFocused;
  final ValueChanged<SupplierListView> onViewChanged;
  final VoidCallback onExpand;
  final VoidCallback onChangeLocation;
  final VoidCallback onAdjustFilters;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final page = controller.page;
    final availableViews = availableSupplierViews(controller.filters);
    final view = availableViews.contains(this.view)
        ? this.view
        : availableViews.first;
    final showDirectory = availableViews.contains(SupplierListView.directory);
    final loading =
        controller.phase == DiscoveryPhase.loading ||
        controller.phase == DiscoveryPhase.initializing;
    final visible = browseSuppliers(
      controller.items,
      view: view,
      sort: sort,
      query: searchController.text,
    );
    final summary = [
      if (availableViews.contains(SupplierListView.verified))
        '${page?.verifiedCount ?? 0} Verified',
      if (showDirectory) '${page?.directoryCount ?? 0} Directory',
      '${page?.radiusKm ?? controller.radiusKm} km',
    ].join(' · ');
    return CustomScrollView(
      controller: scrollController,
      scrollCacheExtent: const ScrollCacheExtent.pixels(
        0,
      ), // Do not fetch Google photos for offscreen rows.
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          sliver: SliverList.list(
            children: [
              Semantics(
                header: true,
                child: Text(
                  'Suppliers near you',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Semantics(
                liveRegion: true,
                child: Text(
                  loading
                      ? 'Finding suppliers within ${controller.radiusKm} km…'
                      : page == null
                      ? 'Choose a location to see suppliers.'
                      : '$summary\nUpdated ${_time(page.currentAsOf)}',
                  style: const TextStyle(
                    color: BuyerTheme.muted,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SupplierListControls(
                searchController: searchController,
                view: view,
                availableViews: availableViews,
                sort: sort,
                resultCount: page == null ? null : visible.length,
                onQueryChanged: onQueryChanged,
                onViewChanged: onViewChanged,
                onSortChanged: onSortChanged,
                onSearchFocused: onSearchFocused,
              ),
              if (controller.showingSavedResults) ...[
                const SizedBox(height: 12),
                const AuthNotice(
                  message:
                      'Showing saved suppliers while checking for updates…',
                ),
              ] else if (controller.resultsStale) ...[
                const SizedBox(height: 12),
                AuthNotice(
                  message:
                      '${controller.failure?.message ?? 'Results could not be refreshed.'} Showing suppliers from ${_time(page?.currentAsOf)}; driving times are hidden until you refresh.',
                  isError: true,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: controller.refresh,
                    child: const Text('Retry'),
                  ),
                ),
              ],
              if (showDirectory &&
                  page != null &&
                  _directoryNotice(page) != null) ...[
                const SizedBox(height: 12),
                AuthNotice(message: _directoryNotice(page)!),
              ],
              if (page != null &&
                  page.suggestedRadiusKm != null &&
                  !loading) ...[
                const SizedBox(height: 12),
                _ExpansionPrompt(page: page, onExpand: onExpand),
              ],
              if (page != null &&
                  page.atMaximum &&
                  page.eligibleVerifiedCount < 3 &&
                  !loading) ...[
                const SizedBox(height: 12),
                AuthNotice(
                  message: showDirectory
                      ? '50 km is the platform maximum. Directory Suppliers beyond Verified Vendors are shown only as off-platform contact references.'
                      : '50 km is the platform maximum.',
                ),
              ],
            ],
          ),
        ),
        if (loading && controller.items.isEmpty)
          SliverList.builder(
            itemCount: 4,
            itemBuilder: (_, _) => const _SkeletonRow(),
          )
        else if (controller.phase == DiscoveryPhase.failed)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _FailureState(
                failure: controller.failure,
                onRetry: controller.origin == null
                    ? controller.initialize
                    : controller.search,
                onChangeLocation: onChangeLocation,
              ),
            ),
          )
        else if (visible.isEmpty && page != null)
          SliverToBoxAdapter(
            child: StateMessage(
              kind: StateKind.empty,
              compact: true,
              artwork: view == SupplierListView.favorites
                  ? StateArtwork.favorites
                  : StateArtwork.noResults,
              title: searchController.text.trim().isNotEmpty
                  ? 'No matching stores'
                  : view == SupplierListView.favorites
                  ? 'No Favorite Suppliers nearby'
                  : 'No suppliers found',
              message: searchController.text.trim().isNotEmpty
                  ? 'Try another store name or switch supplier type.'
                  : view == SupplierListView.favorites
                  ? 'None of your Favorite Suppliers are within ${controller.radiusKm} km right now.'
                  : controller.filters.activeCount > 0
                  ? 'No suppliers match your filters within ${controller.radiusKm} km.'
                  : 'No suppliers were found within ${controller.radiusKm} km of this location.',
              secondaryLabel: searchController.text.trim().isNotEmpty
                  ? 'Clear search'
                  : controller.filters.activeCount > 0
                  ? 'Adjust filters'
                  : 'Change location',
              onSecondary: searchController.text.trim().isNotEmpty
                  ? () {
                      searchController.clear();
                      onQueryChanged('');
                    }
                  : controller.filters.activeCount > 0
                  ? onAdjustFilters
                  : onChangeLocation,
            ),
          )
        else
          SliverList.separated(
            itemCount: visible.length,
            separatorBuilder: (_, _) =>
                const Divider(height: 1, indent: 16, endIndent: 16),
            itemBuilder: (context, index) => SupplierRow(
              key: ValueKey(visible[index].resultId),
              photoLoader: controller.directoryPhotos,
              onToggleFavorite: () => controller.toggleFavorite(visible[index]),
              item: visible[index],
              selected: visible[index].resultId == controller.selectedId,
              onTap: () => controller.select(visible[index].resultId),
            ),
          ),
        if (page?.hasMore ?? false)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: OutlinedButton(
                onPressed: controller.loadingMore ? null : controller.loadMore,
                child: Text(
                  controller.loadingMore
                      ? 'Loading more…'
                      : 'Load more suppliers (${controller.items.length} of ${page!.total})',
                ),
              ),
            ),
          ),
        if (showDirectory && page != null && page.directoryCount > 0)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Text(
                'Directory Suppliers: ${page.directoryAttribution}',
                style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
              ),
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  String? _directoryNotice(
    DiscoveryResultPage page,
  ) => switch (page.directoryStatus) {
    'UNAVAILABLE' =>
      'Directory Suppliers from Google Maps are temporarily unavailable. Verified Vendors are still shown.',
    'NOT_CONFIGURED' =>
      'Directory Suppliers are not available right now. Verified Vendors are still shown.',
    'CACHED' =>
      'Directory Suppliers are shown from saved information as of ${_time(page.directoryAsOf)}.',
    'FILTERED_OUT' =>
      'Directory Suppliers are hidden because a supplier type or material category filter is active.',
    _ => null,
  };
}

String _time(DateTime? value) {
  if (value == null) return 'earlier';
  final local = value.toUtc().add(const Duration(hours: 8));
  final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
  return '$hour:${local.minute.toString().padLeft(2, '0')} ${local.hour < 12 ? 'AM' : 'PM'}';
}

class SupplierRow extends StatefulWidget {
  const SupplierRow({
    super.key,
    required this.item,
    required this.selected,
    required this.onTap,
    this.photoLoader,
    this.onToggleFavorite,
  });

  final SupplierResultView item;
  final bool selected;
  final VoidCallback onTap;

  /// Save / remove Favorite Supplier (either tier). Null hides the bookmark.
  final VoidCallback? onToggleFavorite;

  final DirectoryPhotoLoader? photoLoader;

  @override
  State<SupplierRow> createState() => _SupplierRowState();
}

class _SupplierRowState extends State<SupplierRow> {
  DirectoryPhotoView? _media;
  Timer? _debounce;
  int _sequence = 0;

  @override
  void initState() {
    super.initState();
    _schedulePhoto();
  }

  @override
  void didUpdateWidget(covariant SupplierRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.resultId != widget.item.resultId ||
        oldWidget.photoLoader != widget.photoLoader) {
      _media = null;
      _schedulePhoto();
    }
  }

  void _schedulePhoto() {
    _debounce?.cancel();
    final sequence = ++_sequence;
    if (widget.item.isVerified || widget.photoLoader == null) return;
    // Seen recently: paint it on the first frame, with no request and no wait.
    final seen = widget.photoLoader!.cached(widget.item.resultId);
    if (seen != null) {
      _media = seen;
      return;
    }
    // Let a fast fling pass before making a paid provider request.
    _debounce = Timer(const Duration(milliseconds: 250), () async {
      final result = await widget.photoLoader!.load(
        widget.item.resultId,
        () => mounted && sequence == _sequence,
      );
      if (mounted && sequence == _sequence) setState(() => _media = result);
    });
  }

  @override
  void dispose() {
    _sequence++;
    _debounce?.cancel();
    // The decoded thumbnail is deliberately left in Flutter's bounded in-memory image cache (never
    // on disk), so scrolling back or reopening the list paints it again with no download.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final selected = widget.selected;
    final open = item.openState;
    final favorite = widget.onToggleFavorite;
    // Isolated repaint layer: a drag or fling repaints rows independently of the map and sheet.
    return RepaintBoundary(
      child: Semantics(
        selected: selected,
        button: true,
        container: true,
        child: InkWell(
          onTap: widget.onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 84),
            decoration: BoxDecoration(
              color: selected ? BuyerTheme.brandSoft : null,
              border: Border(
                left: BorderSide(
                  color: selected ? BuyerTheme.action : Colors.transparent,
                  width: 4,
                ),
              ),
            ),
            padding: EdgeInsets.fromLTRB(12, 12, favorite == null ? 16 : 4, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SupplierAvatar(item: item, photo: _media?.photo),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          TierBadge(tier: item.tier),
                          // A Directory Supplier has no score, so its "Directory" chip only repeats the tier.
                          if (item.scoreKind != ScoreKind.directory)
                            ScoreBadge(
                              kind: item.scoreKind,
                              text: item.scoreText,
                            ),
                        ],
                      ),
                      if (!item.isVerified && item.googleRating != null) ...[
                        const SizedBox(height: 4),
                        Semantics(
                          label:
                              'Google rating ${item.googleRating!} out of 5${item.googleRatingCount == null ? '' : ', ${item.googleRatingCount} ratings'}',
                          excludeSemantics: true,
                          child: Row(
                            children: [
                              const Icon(
                                LucideIcons.star,
                                size: 14,
                                color: BuyerTheme.action,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Google rating ${item.googleRating!}${item.googleRatingCount == null ? '' : ' (${item.googleRatingCount})'}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            LucideIcons.navigation,
                            size: 13,
                            color: BuyerTheme.muted,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              [
                                '${formatDistance(item.distanceMeters)} away',
                                if (open != null) _openText(open),
                                if (item.vacationMode) 'Vacation Mode',
                              ].join(' · '),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: BuyerTheme.muted,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (favorite != null)
                  IconButton(
                    tooltip: item.isFavorite
                        ? 'Remove ${item.name} from Favorite Suppliers'
                        : 'Save ${item.name} as a Favorite Supplier',
                    onPressed: favorite,
                    icon: Icon(
                      item.isFavorite ? Icons.bookmark : Icons.bookmark_border,
                      color: BuyerTheme.action,
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.only(left: 8, top: 2),
                    child: Icon(
                      LucideIcons.chevronRight,
                      size: 18,
                      color: BuyerTheme.muted,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Decode size of the 56 dp row thumbnail at 3x density.
const _thumbnailPixels = 168;

String _openText(SupplierOpenState open) => switch (open.status) {
  'OPEN' =>
    'Open now${open.closesAt == null ? '' : ' · Closes ${_clock(open.closesAt!)}'}',
  'CLOSED' => open.opensAt == null ? 'Closed today' : 'Closed now',
  _ => 'Hours unavailable',
};

String _clock(String value) {
  final parts = value.split(':');
  final hour = int.tryParse(parts.first) ?? 0;
  return '${hour % 12 == 0 ? 12 : hour % 12}:${parts.length > 1 ? parts[1] : '00'} ${hour < 12 ? 'AM' : 'PM'}';
}

class _SupplierAvatar extends StatelessWidget {
  const _SupplierAvatar({required this.item, this.photo});
  final SupplierResultView item;
  final PlacePhotoView? photo;

  @override
  Widget build(BuildContext context) {
    final uri = item.isVerified ? item.logoUrl : photo?.uri;
    final fallback = Icon(
      item.isVerified ? LucideIcons.store : LucideIcons.building2,
      color: item.isVerified ? BuyerTheme.action : BuyerTheme.muted,
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 56,
        height: 56,
        color: BuyerTheme.canvas,
        alignment: Alignment.center,
        child: uri == null
            ? fallback
            : item.isVerified
            // A store logo is our own public media at a stable URL: kept on disk so it shows
            // instantly on every later open. Google photos below are never written to disk.
            ? Semantics(
                image: true,
                label: '${item.name} store logo',
                child: CachedNetworkImage(
                  imageUrl: uri,
                  cacheKey: 'store-logo|$uri',
                  width: 56,
                  height: 56,
                  memCacheWidth: _thumbnailPixels,
                  memCacheHeight: _thumbnailPixels,
                  fit: BoxFit.contain,
                  fadeInDuration: Duration.zero,
                  fadeOutDuration: Duration.zero,
                  placeholder: (_, _) => fallback,
                  errorWidget: (_, _, _) => fallback,
                ),
              )
            : Image.network(
                uri,
                width: 56,
                height: 56,
                // Decode at thumbnail size; a full-resolution photo per row is what made scrolling stutter.
                cacheWidth: _thumbnailPixels,
                cacheHeight: _thumbnailPixels,
                filterQuality: FilterQuality.low,
                fit: item.isVerified ? BoxFit.contain : BoxFit.cover,
                semanticLabel:
                    '${item.name} ${item.isVerified ? 'store logo' : 'Google Maps business photo'}',
                errorBuilder: (_, _, _) => fallback,
              ),
      ),
    );
  }
}

class _ExpansionPrompt extends StatelessWidget {
  const _ExpansionPrompt({required this.page, required this.onExpand});
  final DiscoveryResultPage page;
  final VoidCallback onExpand;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: BuyerTheme.border),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          page.eligibleVerifiedCount == 0
              ? 'No Verified Vendors within ${page.radiusKm} km.'
              : 'Fewer than three Verified Vendors within ${page.radiusKm} km.',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onExpand,
          icon: const Icon(LucideIcons.expand, size: 18),
          label: Text('Search within ${page.suggestedRadiusKm} km'),
        ),
      ],
    ),
  );
}

class _FailureState extends StatelessWidget {
  const _FailureState({
    required this.failure,
    required this.onRetry,
    required this.onChangeLocation,
  });
  final DiscoveryFailure? failure;
  final Future<void> Function() onRetry;
  final VoidCallback onChangeLocation;

  @override
  Widget build(BuildContext context) {
    final offline = failure?.kind == DiscoveryFailureKind.offline;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthNotice(
          message: offline
              ? 'You are offline. Suppliers will load when your connection returns.'
              : failure?.message ?? 'Suppliers could not be loaded.',
          isError: true,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
            OutlinedButton(
              onPressed: onChangeLocation,
              child: const Text('Change location'),
            ),
          ],
        ),
      ],
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow();

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: BuyerTheme.border,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 14, width: 180, color: BuyerTheme.border),
                const SizedBox(height: 8),
                Container(height: 12, width: 120, color: BuyerTheme.border),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// Preview for the selected supplier. Both tiers share one structure: a header (image, name, tier
/// and score badges, Favorite, Close), status lines (hours, route), one filled primary action with
/// a secondary icon action, then labelled detail groups.
///
/// Tier 2: VPS or New Vendor, descriptive open status, distance/ETA, View Storefront and Message,
/// categories, and a Store details card with fulfillment, delivery area and address.
///
/// Tier 1: information only. `Directory Supplier`, place type and attributed `Google rating`,
/// informational Call, Open in Google Maps, Website and Share actions, and Place Details split into
/// Overview, Reviews and About. A Directory Supplier can be saved as a Favorite Supplier; it has
/// no storefront, message, order, MateryalPH review or VPS.
class SupplierPreview extends StatefulWidget {
  const SupplierPreview({
    super.key,
    required this.controller,
    required this.onViewStore,
    required this.onMessage,
    required this.onClose,
    required this.onOpenLink,
    required this.onShare,
  });

  final DiscoveryController controller;
  final ValueChanged<SupplierResultView> onViewStore;
  final ValueChanged<SupplierResultView> onMessage;
  final VoidCallback onClose;
  final Future<void> Function(Uri uri) onOpenLink;
  final ValueChanged<String> onShare;

  @override
  State<SupplierPreview> createState() => _SupplierPreviewState();
}

enum _DirectorySection { overview, reviews, about }

class _SupplierPreviewState extends State<SupplierPreview> {
  _DirectorySection _section = _DirectorySection.overview;

  DiscoveryController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    final item = controller.selected;
    if (item == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: item.isVerified
            ? _verified(context, item)
            : _directory(context, item),
      ),
    );
  }

  Widget _header(
    BuildContext context,
    SupplierResultView item, {
    required List<Widget> badges,
    PlacePhotoView? photo,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _SupplierAvatar(item: item, photo: photo),
          const SizedBox(width: 12),
          Expanded(
            child: Semantics(
              header: true,
              label:
                  '${item.name}, ${item.isVerified ? 'Verified Vendor' : 'Directory Supplier'}${item.isFavorite ? ', Favorite Supplier' : ''}',
              excludeSemantics: true,
              child: Text(
                item.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: item.isFavorite
                ? 'Remove from Favorite Suppliers'
                : 'Save as Favorite Supplier',
            onPressed: () => controller.toggleFavorite(item),
            icon: Icon(
              item.isFavorite ? Icons.bookmark : Icons.bookmark_border,
              color: BuyerTheme.action,
            ),
          ),
          IconButton(
            tooltip: 'Close preview',
            onPressed: widget.onClose,
            icon: const Icon(LucideIcons.x),
          ),
        ],
      ),
      const SizedBox(height: 12),
      // Full width so long trust labels (e.g. New Vendor — Building Track Record) never truncate.
      Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: badges,
      ),
    ],
  );

  Widget _secondaryIconAction({
    required String tooltip,
    required IconData icon,
    required VoidCallback onPressed,
  }) => IconButton.outlined(
    tooltip: tooltip,
    onPressed: onPressed,
    style: IconButton.styleFrom(
      minimumSize: const Size(48, 48),
      foregroundColor: BuyerTheme.action,
      side: const BorderSide(color: BuyerTheme.border),
    ),
    icon: Icon(icon),
  );

  List<Widget> _verified(BuildContext context, SupplierResultView item) {
    final delivers = item.delivery != null && item.delivery != 'NOT_OFFERED';
    return [
      _header(
        context,
        item,
        badges: [
          const TierBadge(tier: SupplierTier.verified),
          ScoreBadge(
            kind: item.scoreKind,
            text: item.scoreKind == ScoreKind.newVendor
                ? 'New Vendor — Building Track Record'
                : item.scoreText,
          ),
        ],
      ),
      const SizedBox(height: 16),
      if (item.openState != null) ...[
        _OpenStatusLine.vendor(item.openState!),
        const SizedBox(height: 10),
      ],
      _RouteLine(controller: controller, item: item),
      if (item.vacationMode) ...[
        const SizedBox(height: 12),
        const AuthNotice(
          message: 'Vacation Mode: this store has paused new procurement.',
        ),
      ],
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: FilledButton.icon(
              onPressed: () => widget.onViewStore(item),
              icon: const Icon(LucideIcons.store, size: 20),
              label: const Text('View Storefront'),
            ),
          ),
          const SizedBox(width: 12),
          _secondaryIconAction(
            tooltip: 'Message this store',
            icon: LucideIcons.messageCircle,
            onPressed: () => widget.onMessage(item),
          ),
        ],
      ),
      if (item.niches.isNotEmpty) ...[
        const SizedBox(height: 20),
        const _SectionLabel('Categories'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final niche in item.niches) _CategoryChip(label: niche),
          ],
        ),
      ],
      const SizedBox(height: 20),
      const _SectionLabel('Store details'),
      const SizedBox(height: 8),
      _DetailsCard(
        children: [
          _DetailRow(
            icon: delivers ? LucideIcons.truck : LucideIcons.package,
            label: 'Fulfillment',
            text: _fulfillmentMethods(item),
            note: _deliveryNote(item),
          ),
          if (item.address != null)
            _DetailRow(
              icon: LucideIcons.mapPin,
              label: 'Address',
              text: item.address!,
            ),
        ],
      ),
      if (item.openState != null) ...[
        const SizedBox(height: 12),
        _Footnote(
          'Hours are informational${item.openState!.fromDateOverride ? ' (date-specific hours today)' : ''} and do not guarantee stock or staff availability.',
        ),
      ],
    ];
  }

  String _fulfillmentMethods(SupplierResultView item) {
    final methods = <String>[
      if (item.pickupAvailable) 'Pickup',
      if (item.delivery != null && item.delivery != 'NOT_OFFERED')
        'Vendor Delivery',
    ];
    return methods.isEmpty ? 'Not stated' : methods.join(' and ');
  }

  String? _deliveryNote(SupplierResultView item) => switch (item.delivery) {
    'WITHIN_STATED_AREA' =>
      'Delivery is advertised up to ${item.deliveryMaximumKm} km (straight-line estimate; confirmed at checkout).',
    'OUTSIDE_STATED_AREA' =>
      'This location appears outside the stated ${item.deliveryMaximumKm} km delivery area (estimate).',
    _ => null,
  };

  List<Widget> _directory(BuildContext context, SupplierResultView item) {
    final details = controller.directoryDetails;
    final type = _placeType(item.directoryType);
    final ratingValue = details?.googleRatingValue ?? item.googleRating;
    final ratingCount = details?.googleRatingValue != null
        ? details?.googleRatingCount
        : item.googleRatingCount;
    final phone = details?.actions.contains('CALL') == true
        ? details?.publicPhone
        : null;
    final status = details == null ? null : _directoryStatus(details);
    return [
      _header(
        context,
        item,
        photo: controller.directoryPhotos.cached(item.resultId)?.photo,
        badges: [
          const TierBadge(tier: SupplierTier.directory),
          if (type != null)
            Text(
              type,
              style: const TextStyle(fontSize: 13, color: BuyerTheme.muted),
            ),
          if (ratingValue != null)
            GoogleRatingBadge(value: ratingValue, count: ratingCount),
        ],
      ),
      const SizedBox(height: 16),
      if (status != null) ...[status, const SizedBox(height: 10)],
      _RouteLine(controller: controller, item: item),
      const SizedBox(height: 16),
      if (controller.directoryLoading)
        Semantics(
          label: 'Loading place details',
          child: const LinearProgressIndicator(),
        )
      else if (controller.directoryFailure != null) ...[
        Text(controller.directoryFailure!.message),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: controller.retryDirectoryDetails,
            child: const Text('Retry details'),
          ),
        ),
      ] else if (details != null) ...[
        Row(
          children: [
            Expanded(
              child: phone != null
                  ? FilledButton.icon(
                      onPressed: () => widget.onOpenLink(
                        Uri(
                          scheme: 'tel',
                          path: phone.replaceAll(RegExp(r'[^0-9+]'), ''),
                        ),
                      ),
                      icon: const Icon(LucideIcons.phone, size: 20),
                      label: const Text('Call'),
                    )
                  : FilledButton.icon(
                      onPressed: () => _openInMaps(details, item),
                      icon: const Icon(LucideIcons.map, size: 20),
                      label: const Text('Open in Google Maps'),
                    ),
            ),
            if (details.actions.contains('SHARE')) ...[
              const SizedBox(width: 12),
              _secondaryIconAction(
                tooltip: 'Share',
                icon: LucideIcons.share2,
                onPressed: () => widget.onShare(
                  [
                    details.name,
                    details.formattedAddress,
                    details.googleMapsUri,
                  ].whereType<String>().join('\n'),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        SegmentedButton<_DirectorySection>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(
              value: _DirectorySection.overview,
              label: Text('Overview'),
            ),
            ButtonSegment(
              value: _DirectorySection.reviews,
              label: Text('Reviews'),
            ),
            ButtonSegment(value: _DirectorySection.about, label: Text('About')),
          ],
          selected: {_section},
          onSelectionChanged: (value) => setState(() => _section = value.first),
        ),
        const SizedBox(height: 16),
        if (_section == _DirectorySection.overview)
          ..._overview(details, item, phone != null)
        else if (_section == _DirectorySection.reviews)
          GooglePlaceReviews(
            reviews: details.reviews,
            onOpenLink: widget.onOpenLink,
          )
        else
          ..._about(details),
        const Divider(height: 32),
        for (final author in details.providerAttributions)
          GooglePlaceAuthor(author: author, onOpenLink: widget.onOpenLink),
        const _Footnote(
          'Information from Google Maps may not reflect current real-world conditions.',
        ),
        const SizedBox(height: 4),
        _Footnote(
          '${details.attribution} Retrieved ${_time(details.fetchedAt)}.',
        ),
      ],
    ];
  }

  /// Open/closed from Google when known, otherwise today's listed hours.
  Widget? _directoryStatus(DirectoryDetailsView details) {
    final today = _todayHours(details.openingHours);
    final open = details.openNow;
    if (open == null) {
      return today == null
          ? null
          : _InfoLine(
              leading: const Icon(
                LucideIcons.clock,
                size: 18,
                color: BuyerTheme.muted,
              ),
              child: Text(today),
            );
    }
    return _OpenStatusLine(
      status: open ? 'Open' : 'Closed',
      color: open
          ? BuyerTheme.success
          : const Color(MateryalColorTokens.statusError),
      detail: open
          ? details.nextCloseTime == null
                ? null
                : 'Closes ${_time(details.nextCloseTime)}'
          : today,
    );
  }

  List<Widget> _overview(
    DirectoryDetailsView details,
    SupplierResultView item,
    bool callIsPrimary,
  ) {
    // Sized to their labels so they sit side by side and wrap only on narrow screens.
    final linkStyle = OutlinedButton.styleFrom(minimumSize: const Size(0, 44));
    final links = [
      if (callIsPrimary && details.actions.contains('OPEN_IN_MAPS'))
        OutlinedButton.icon(
          style: linkStyle,
          onPressed: () => _openInMaps(details, item),
          icon: const Icon(LucideIcons.map, size: 18),
          label: const Text('Open in Google Maps'),
        ),
      if (details.actions.contains('WEBSITE') && details.websiteUri != null)
        OutlinedButton.icon(
          style: linkStyle,
          onPressed: () => widget.onOpenLink(Uri.parse(details.websiteUri!)),
          icon: const Icon(LucideIcons.globe, size: 18),
          label: const Text('Website'),
        ),
    ];
    return [
      GooglePlacePhotos(photos: details.photos, onOpenLink: widget.onOpenLink),
      if (details.openingHours.isNotEmpty) ...[
        const SizedBox(height: 16),
        const _SectionLabel('Opening hours'),
        const SizedBox(height: 8),
        _DetailsCard(children: [_HoursTable(lines: details.openingHours)]),
      ],
      if (details.publicPhone != null || details.formattedAddress != null) ...[
        const SizedBox(height: 16),
        const _SectionLabel('Contact'),
        const SizedBox(height: 8),
        _DetailsCard(
          children: [
            if (details.publicPhone != null)
              _DetailRow(
                icon: LucideIcons.phone,
                label: 'Phone',
                text: details.publicPhone!,
              ),
            if (details.formattedAddress != null)
              _DetailRow(
                icon: LucideIcons.mapPin,
                label: 'Address',
                text: details.formattedAddress!,
              ),
          ],
        ),
      ],
      if (links.isNotEmpty) ...[
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: links),
      ],
    ];
  }

  List<Widget> _about(DirectoryDetailsView details) => [
    if (details.attributes.isEmpty)
      const Text(
        'Google Maps has not provided additional business attributes.',
        style: TextStyle(color: BuyerTheme.muted),
      )
    else
      _DetailsCard(
        children: [
          for (final attribute in details.attributes)
            _DetailRow(
              icon: attribute.available ? LucideIcons.check : LucideIcons.x,
              text: '${attribute.label}: ${attribute.available ? 'Yes' : 'No'}',
            ),
        ],
      ),
  ];

  void _openInMaps(DirectoryDetailsView details, SupplierResultView item) =>
      widget.onOpenLink(
        details.googleMapsUri != null
            ? Uri.parse(details.googleMapsUri!)
            : Uri.https('www.google.com', '/maps/search/', {
                'api': '1',
                'query': '${item.point.latitude},${item.point.longitude}',
              }),
      );
}

/// `hardware_store` → `Hardware store`.
String? _placeType(String? type) {
  if (type == null || type.isEmpty) return null;
  final words = type.replaceAll('_', ' ');
  return '${words[0].toUpperCase()}${words.substring(1)}';
}

const _weekdays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

/// Today's weekday name in Asia/Manila.
String _manilaWeekday() =>
    _weekdays[DateTime.now().toUtc().add(const Duration(hours: 8)).weekday - 1];

/// Match the provider's English weekday label; Google does not guarantee Monday-first ordering.
String? _todayHours(List<String> weekdays) {
  final today = _manilaWeekday();
  for (final line in weekdays) {
    if (line.startsWith('$today:')) {
      return 'Today:${line.substring(line.indexOf(':') + 1)}';
    }
  }
  return null;
}

/// Google weekday descriptions as an aligned day/hours table with today emphasized.
class _HoursTable extends StatelessWidget {
  const _HoursTable({required this.lines});
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final today = _manilaWeekday();
    return Column(
      children: [
        for (final line in lines)
          Builder(
            builder: (context) {
              final split = line.indexOf(':');
              final day = split < 0 ? line : line.substring(0, split);
              final hours = split < 0 ? '' : line.substring(split + 1).trim();
              final isToday = day == today;
              final style = TextStyle(
                fontSize: 14,
                height: 1.35,
                fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                color: isToday ? BuyerTheme.ink : BuyerTheme.muted,
              );
              return Semantics(
                label: '${isToday ? 'Today, ' : ''}$day: $hours',
                excludeSemantics: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: Text(day, style: style)),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 3,
                        child: Text(
                          hours,
                          textAlign: TextAlign.end,
                          style: style,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

/// A status or route line: a 20 dp leading glyph column so every line's text aligns.
class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.leading, required this.child});
  final Widget leading;
  final Widget child;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(width: 20, height: 22, child: Center(child: leading)),
      const SizedBox(width: 10),
      Expanded(child: child),
    ],
  );
}

class _OpenStatusLine extends StatelessWidget {
  const _OpenStatusLine({
    required this.status,
    required this.color,
    this.detail,
  });

  /// Vendor-saved hours. Descriptive only; never filters or ranks.
  factory _OpenStatusLine.vendor(SupplierOpenState open) {
    final (String status, Color color) = switch (open.status) {
      'OPEN' => ('Open', BuyerTheme.success),
      'CLOSED' when open.opensAt == null => (
        'Closed today',
        const Color(MateryalColorTokens.statusError),
      ),
      'CLOSED' => ('Closed', const Color(MateryalColorTokens.statusError)),
      _ => ('Hours unavailable', BuyerTheme.muted),
    };
    final detail = switch (open.status) {
      'OPEN' when open.closesAt != null => 'Closes ${_clock(open.closesAt!)}',
      'CLOSED' when open.opensAt != null => 'Opens ${_clock(open.opensAt!)}',
      _ => null,
    };
    return _OpenStatusLine(status: status, color: color, detail: detail);
  }

  final String status;
  final Color color;
  final String? detail;

  @override
  Widget build(BuildContext context) => Semantics(
    label: [status, ?detail].join(', '),
    excludeSemantics: true,
    child: _InfoLine(
      leading: Icon(Icons.circle, size: 10, color: color),
      child: Text.rich(
        TextSpan(
          text: status,
          style: const TextStyle(fontWeight: FontWeight.w700),
          children: [
            if (detail != null)
              TextSpan(
                text: ' · $detail',
                style: const TextStyle(fontWeight: FontWeight.w400),
              ),
          ],
        ),
      ),
    ),
  );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: BuyerTheme.muted,
        letterSpacing: 0.2,
      ),
    ),
  );
}

class _Footnote extends StatelessWidget {
  const _Footnote(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(fontSize: 12, height: 1.4, color: BuyerTheme.muted),
  );
}

/// A flat bordered group of detail rows separated by hairlines.
class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      border: Border.all(color: BuyerTheme.border),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < children.length; index++) ...[
            if (index > 0) const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: children[index],
            ),
          ],
        ],
      ),
    ),
  );
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: BuyerTheme.canvas,
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: BuyerTheme.border),
    ),
    child: Text(
      label,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    ),
  );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.text,
    this.label,
    this.note,
  });
  final IconData icon;
  final String text;
  final String? label;
  final String? note;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Icon(icon, size: 18, color: BuyerTheme.muted),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null) ...[
              Text(
                label!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: BuyerTheme.muted,
                ),
              ),
              const SizedBox(height: 2),
            ],
            Text(text, style: const TextStyle(height: 1.35)),
            if (note != null) ...[
              const SizedBox(height: 4),
              Text(
                note!,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: BuyerTheme.muted,
                ),
              ),
            ],
          ],
        ),
      ),
    ],
  );
}

class _RouteLine extends StatelessWidget {
  const _RouteLine({required this.controller, required this.item});
  final DiscoveryController controller;
  final SupplierResultView item;

  @override
  Widget build(BuildContext context) {
    final route = controller.route;
    const car = Icon(LucideIcons.car, size: 18, color: BuyerTheme.muted);
    final Widget content = switch (controller.routePhase) {
      RoutePhase.ready when route != null => _InfoLine(
        leading: car,
        child: Text(
          '${formatDistance(route.distanceMeters)} · ${formatDuration(route.durationSeconds)} drive · Estimated ${_time(route.computedAt)}${route.trafficAware ? ' with current traffic' : ''}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      RoutePhase.failed => _InfoLine(
        leading: car,
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Driving time unavailable · ${formatDistance((controller.routeFailure?.details['straight_line_meters'] as int?) ?? item.distanceMeters)} straight-line',
              ),
            ),
            TextButton(
              onPressed: controller.retryRoute,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      _ => _InfoLine(
        leading: const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        child: Text(
          '${formatDistance(item.distanceMeters)} straight-line · Calculating driving time…',
        ),
      ),
    };
    return Semantics(liveRegion: true, child: content);
  }
}
