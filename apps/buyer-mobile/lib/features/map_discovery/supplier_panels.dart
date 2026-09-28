import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/discovery_controls.dart';
import '../../design_system/generated/color_tokens.dart';
import '../../design_system/theme.dart';
import '../../widgets/auth_content.dart';
import 'discovery_controller.dart';
import 'discovery_models.dart';
import 'map_geometry.dart';

enum SupplierListView { all, verified, directory, favorites }

/// The accessible peer of the map: the same suppliers in the same server order, selectable by
/// touch, keyboard or screen reader at any time.
class SupplierListPanel extends StatelessWidget {
  const SupplierListPanel({
    super.key,
    required this.controller,
    required this.view,
    required this.onViewChanged,
    required this.onExpand,
    required this.onChangeLocation,
    required this.onAdjustFilters,
    this.scrollController,
  });

  final DiscoveryController controller;
  final SupplierListView view;
  final ValueChanged<SupplierListView> onViewChanged;
  final VoidCallback onExpand;
  final VoidCallback onChangeLocation;
  final VoidCallback onAdjustFilters;
  final ScrollController? scrollController;

  List<SupplierResultView> get _visible => switch (view) {
    SupplierListView.all => controller.items,
    SupplierListView.verified =>
      controller.items.where((item) => item.isVerified).toList(),
    SupplierListView.directory =>
      controller.items.where((item) => !item.isVerified).toList(),
    SupplierListView.favorites =>
      controller.items.where((item) => item.isFavorite).toList(),
  };

  @override
  Widget build(BuildContext context) {
    final page = controller.page;
    final loading =
        controller.phase == DiscoveryPhase.loading ||
        controller.phase == DiscoveryPhase.initializing;
    final visible = _visible;
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          sliver: SliverList.list(
            children: [
              Semantics(
                header: true,
                child: Text(
                  'Suppliers near you',
                  style: Theme.of(context).textTheme.titleLarge,
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
                      : '${page.verifiedCount} Verified Vendor${page.verifiedCount == 1 ? '' : 's'} · ${page.directoryCount} Directory Supplier${page.directoryCount == 1 ? '' : 's'} within ${page.radiusKm} km · Updated ${_time(page.currentAsOf)}',
                  style: const TextStyle(color: BuyerTheme.muted),
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final option in SupplierListView.values)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          selected: view == option,
                          showCheckmark: true,
                          label: Text(switch (option) {
                            SupplierListView.all => 'All',
                            SupplierListView.verified => 'Verified Vendors',
                            SupplierListView.directory => 'Directory Suppliers',
                            SupplierListView.favorites => 'Favorite Suppliers',
                          }),
                          onSelected: (_) => onViewChanged(option),
                        ),
                      ),
                  ],
                ),
              ),
              if (controller.resultsStale) ...[
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
              if (page != null && _directoryNotice(page) != null) ...[
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
                const AuthNotice(
                  message:
                      '50 km is the platform maximum. Directory Suppliers beyond Verified Vendors are shown only as off-platform contact references.',
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
                onRetry: controller.search,
                onChangeLocation: onChangeLocation,
              ),
            ),
          )
        else if (visible.isEmpty && page != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _EmptyState(
                message: view == SupplierListView.favorites
                    ? 'None of your Favorite Suppliers are within ${controller.radiusKm} km with current offerings.'
                    : controller.filters.activeCount > 0
                    ? 'No suppliers match your filters within ${controller.radiusKm} km.'
                    : 'No suppliers were found within ${controller.radiusKm} km of this location.',
                actionLabel: controller.filters.activeCount > 0
                    ? 'Adjust filters'
                    : 'Change location',
                onAction: controller.filters.activeCount > 0
                    ? onAdjustFilters
                    : onChangeLocation,
              ),
            ),
          )
        else
          SliverList.separated(
            itemCount: visible.length,
            separatorBuilder: (_, _) =>
                const Divider(height: 1, indent: 16, endIndent: 16),
            itemBuilder: (context, index) => SupplierRow(
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
        if (page != null && page.directoryCount > 0)
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
      'Directory Suppliers are hidden because a Verified Vendor filter is active.',
    _ => null,
  };
}

String _time(DateTime? value) {
  if (value == null) return 'earlier';
  final local = value.toUtc().add(const Duration(hours: 8));
  final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
  return '$hour:${local.minute.toString().padLeft(2, '0')} ${local.hour < 12 ? 'AM' : 'PM'}';
}

class SupplierRow extends StatelessWidget {
  const SupplierRow({
    super.key,
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final SupplierResultView item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final open = item.openState;
    return Semantics(
      selected: selected,
      button: true,
      label:
          '${item.name}, ${item.isVerified ? 'Verified Vendor' : 'Directory Supplier'}, ${item.scoreText}, ${formatDistance(item.distanceMeters)} away${item.isFavorite ? ', Favorite Supplier' : ''}${selected ? ', selected' : ''}',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 72),
          decoration: BoxDecoration(
            color: selected ? BuyerTheme.brandSoft : null,
            border: Border(
              left: BorderSide(
                color: selected ? BuyerTheme.ink : Colors.transparent,
                width: 4,
              ),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SupplierAvatar(item: item),
              const SizedBox(width: 12),
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
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        TierBadge(tier: item.tier),
                        ScoreBadge(kind: item.scoreKind, text: item.scoreText),
                        if (item.isFavorite)
                          const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                LucideIcons.star,
                                size: 14,
                                color: BuyerTheme.ink,
                              ),
                              SizedBox(width: 2),
                              Text(
                                'Favorite Supplier',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      [
                        '${formatDistance(item.distanceMeters)} away',
                        if (open != null) _openText(open),
                        if (item.vacationMode) 'Vacation Mode',
                      ].join(' · '),
                      style: const TextStyle(
                        color: BuyerTheme.muted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
  const _SupplierAvatar({required this.item});
  final SupplierResultView item;

  @override
  Widget build(BuildContext context) {
    final fallback = Icon(
      item.isVerified ? LucideIcons.store : LucideIcons.building2,
      color: item.isVerified ? BuyerTheme.action : BuyerTheme.muted,
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 48,
        height: 48,
        color: BuyerTheme.canvas,
        alignment: Alignment.center,
        child: item.logoUrl == null
            ? fallback
            : Image.network(
                item.logoUrl!,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                semanticLabel: '${item.name} logo',
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

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(message),
      const SizedBox(height: 8),
      OutlinedButton(onPressed: onAction, child: Text(actionLabel)),
    ],
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

/// Preview for the selected supplier.
///
/// Tier 2: name with the Verified Vendor badge, Favorite bookmark, VPS or New Vendor, descriptive
/// open status, distance/ETA, categories, one explicit View Store action and a secondary Message.
///
/// Tier 1: information only. Name, `Directory Supplier`, distance/ETA, informational Call, Open
/// in Google Maps, Website and Share actions, and attributed Place Details split into Overview
/// and About. There is no Favorite, storefront, message, review tab, photo or VPS: Google
/// reviews and photos are not requested, and a Google rating is labelled `Google rating`.
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

enum _DirectorySection { overview, about }

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

  Widget _title(BuildContext context, SupplierResultView item) => Semantics(
    header: true,
    label:
        '${item.name}, ${item.isVerified ? 'Verified Vendor' : 'Directory Supplier'}',
    excludeSemantics: true,
    child: Text.rich(
      TextSpan(
        text: item.name,
        children: [
          if (item.isVerified)
            const WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: EdgeInsets.only(left: 6),
                child: Icon(
                  LucideIcons.badgeCheck,
                  size: 20,
                  color: BuyerTheme.action,
                ),
              ),
            ),
        ],
      ),
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
    ),
  );

  Widget _closeButton() => IconButton(
    tooltip: 'Close preview',
    onPressed: widget.onClose,
    icon: const Icon(LucideIcons.x),
  );

  List<Widget> _verified(BuildContext context, SupplierResultView item) => [
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: _title(context, item),
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
        _closeButton(),
      ],
    ),
    Wrap(
      spacing: 8,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ScoreBadge(
          kind: item.scoreKind,
          text: item.scoreKind == ScoreKind.newVendor
              ? 'New Vendor — Building Track Record'
              : item.scoreText,
        ),
        const TierBadge(tier: SupplierTier.verified),
      ],
    ),
    if (item.openState != null) ...[
      const SizedBox(height: 8),
      _OpenStatusLine(open: item.openState!),
    ],
    const SizedBox(height: 8),
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _RouteLine(controller: controller, item: item),
        ),
        if (item.delivery != null && item.delivery != 'NOT_OFFERED')
          const Padding(
            padding: EdgeInsets.only(left: 8),
            child: Icon(
              LucideIcons.truck,
              size: 20,
              color: BuyerTheme.action,
              semanticLabel: 'Offers Vendor Delivery',
            ),
          ),
      ],
    ),
    if (item.niches.isNotEmpty) ...[
      const SizedBox(height: 12),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final niche in item.niches) _CategoryChip(label: niche),
        ],
      ),
    ],
    const SizedBox(height: 16),
    Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () => widget.onViewStore(item),
            icon: const Icon(LucideIcons.store, size: 20),
            label: const Text('View Store'),
          ),
        ),
        const SizedBox(width: 12),
        IconButton.outlined(
          tooltip: 'Message this store',
          onPressed: () => widget.onMessage(item),
          style: IconButton.styleFrom(
            minimumSize: const Size(48, 48),
            foregroundColor: BuyerTheme.action,
            side: const BorderSide(color: BuyerTheme.border),
          ),
          icon: const Icon(LucideIcons.messageCircle),
        ),
      ],
    ),
    const Divider(height: 32),
    Text(_fulfillment(item)),
    if (item.address != null) ...[
      const SizedBox(height: 8),
      _DetailRow(icon: LucideIcons.mapPin, text: item.address!),
    ],
    if (item.vacationMode) ...[
      const SizedBox(height: 8),
      const AuthNotice(
        message: 'Vacation Mode: this store has paused new procurement.',
      ),
    ],
    if (item.openState != null) ...[
      const SizedBox(height: 8),
      Text(
        'Hours are informational${item.openState!.fromDateOverride ? ' (date-specific hours today)' : ''} and do not guarantee stock or staff availability.',
        style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
      ),
    ],
  ];

  String _fulfillment(SupplierResultView item) {
    final methods = <String>[
      if (item.pickupAvailable) 'Pickup',
      if (item.delivery != null && item.delivery != 'NOT_OFFERED')
        'Vendor Delivery',
    ];
    final delivery = switch (item.delivery) {
      'WITHIN_STATED_AREA' =>
        ' Delivery is advertised up to ${item.deliveryMaximumKm} km (straight-line estimate; confirmed at checkout).',
      'OUTSIDE_STATED_AREA' =>
        ' This location appears outside the stated ${item.deliveryMaximumKm} km delivery area (estimate).',
      _ => '',
    };
    return 'Fulfillment: ${methods.isEmpty ? 'Not stated' : methods.join(' and ')}.$delivery';
  }

  List<Widget> _directory(BuildContext context, SupplierResultView item) {
    final details = controller.directoryDetails;
    final type = _placeType(item.directoryType);
    final today = details == null ? null : _todayHours(details.openingHours);
    final phone = details?.actions.contains('CALL') == true
        ? details?.publicPhone
        : null;
    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _title(context, item),
            ),
          ),
          _closeButton(),
        ],
      ),
      Wrap(
        spacing: 8,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const TierBadge(tier: SupplierTier.directory),
          if (type != null)
            Text(type, style: const TextStyle(color: BuyerTheme.muted)),
        ],
      ),
      if (today != null) ...[
        const SizedBox(height: 8),
        _DetailRow(icon: LucideIcons.clock, text: today),
      ],
      const SizedBox(height: 8),
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
              IconButton.outlined(
                tooltip: 'Share',
                onPressed: () => widget.onShare(
                  [
                    details.name,
                    details.formattedAddress,
                    details.googleMapsUri,
                  ].whereType<String>().join('\n'),
                ),
                style: IconButton.styleFrom(
                  minimumSize: const Size(48, 48),
                  foregroundColor: BuyerTheme.action,
                  side: const BorderSide(color: BuyerTheme.border),
                ),
                icon: const Icon(LucideIcons.share2),
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
            ButtonSegment(value: _DirectorySection.about, label: Text('About')),
          ],
          selected: {_section},
          onSelectionChanged: (value) => setState(() => _section = value.first),
        ),
        const SizedBox(height: 16),
        const AuthNotice(
          message:
              'Directory Supplier from Google Maps. Informational only: it is not a MateryalPH Verified Vendor, and ordering, messaging, reviews and payments are not available. Details may be outdated.',
        ),
        const SizedBox(height: 12),
        if (_section == _DirectorySection.overview)
          ..._overview(details, item, phone != null)
        else
          ..._about(details),
        const SizedBox(height: 12),
        Text(
          '${details.attribution} Retrieved ${_time(details.fetchedAt)}.',
          style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
        ),
      ],
    ];
  }

  List<Widget> _overview(
    DirectoryDetailsView details,
    SupplierResultView item,
    bool callIsPrimary,
  ) => [
    if (details.formattedAddress != null)
      _DetailRow(icon: LucideIcons.mapPin, text: details.formattedAddress!),
    if (details.googleRatingValue != null) ...[
      const SizedBox(height: 12),
      GoogleRatingBadge(
        value: details.googleRatingValue!,
        count: details.googleRatingCount,
      ),
    ],
    const SizedBox(height: 12),
    Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (callIsPrimary && details.actions.contains('OPEN_IN_MAPS'))
          OutlinedButton.icon(
            onPressed: () => _openInMaps(details, item),
            icon: const Icon(LucideIcons.map, size: 18),
            label: const Text('Open in Google Maps'),
          ),
        if (details.actions.contains('WEBSITE') && details.websiteUri != null)
          OutlinedButton.icon(
            onPressed: () => widget.onOpenLink(Uri.parse(details.websiteUri!)),
            icon: const Icon(LucideIcons.globe, size: 18),
            label: const Text('Website'),
          ),
      ],
    ),
  ];

  List<Widget> _about(DirectoryDetailsView details) => [
    Semantics(
      header: true,
      child: const Text(
        'Opening hours',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    const SizedBox(height: 4),
    if (details.openingHours.isEmpty)
      const Text(
        'Google Maps did not return opening hours for this place.',
        style: TextStyle(color: BuyerTheme.muted),
      )
    else
      for (final line in details.openingHours)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text(line),
        ),
    if (details.publicPhone != null) ...[
      const SizedBox(height: 12),
      _DetailRow(icon: LucideIcons.phone, text: details.publicPhone!),
    ],
    if (details.websiteUri != null) ...[
      const SizedBox(height: 8),
      _DetailRow(
        icon: LucideIcons.globe,
        text: Uri.tryParse(details.websiteUri!)?.host ?? details.websiteUri!,
      ),
    ],
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

/// Today's line from Google's weekday descriptions (Monday first), in Asia/Manila.
String? _todayHours(List<String> weekdays) {
  if (weekdays.length != 7) return null;
  final today = DateTime.now().toUtc().add(const Duration(hours: 8)).weekday;
  final line = weekdays[today - 1];
  final colon = line.indexOf(':');
  return colon < 0 ? line : 'Today:${line.substring(colon + 1)}';
}

class _OpenStatusLine extends StatelessWidget {
  const _OpenStatusLine({required this.open});
  final SupplierOpenState open;

  @override
  Widget build(BuildContext context) {
    final (String status, Color dot) = switch (open.status) {
      'OPEN' => ('Open', BuyerTheme.success),
      'CLOSED' => ('Closed', const Color(MateryalColorTokens.statusError)),
      _ => ('Hours unavailable', BuyerTheme.muted),
    };
    final detail = switch (open.status) {
      'OPEN' when open.closesAt != null => 'Closes ${_clock(open.closesAt!)}',
      'CLOSED' when open.opensAt != null => 'Opens ${_clock(open.opensAt!)}',
      'CLOSED' => 'Closed today',
      _ => null,
    };
    return Semantics(
      label: [status, ?detail].join(', '),
      excludeSemantics: true,
      child: Row(
        children: [
          Icon(Icons.circle, size: 10, color: dot),
          const SizedBox(width: 6),
          Flexible(
            child: Text.rich(
              TextSpan(
                text: status,
                style: const TextStyle(fontWeight: FontWeight.w700),
                children: [
                  if (detail != null && detail != 'Closed today')
                    TextSpan(
                      text: ' · $detail',
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
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
  const _DetailRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Icon(icon, size: 18, color: BuyerTheme.muted),
      ),
      const SizedBox(width: 8),
      Expanded(child: Text(text)),
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
    final Widget content = switch (controller.routePhase) {
      RoutePhase.ready when route != null => Text(
        '${formatDistance(route.distanceMeters)} · ${formatDuration(route.durationSeconds)} drive · Estimated ${_time(route.computedAt)}${route.trafficAware ? ' with current traffic' : ''}',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      RoutePhase.failed => Row(
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
      _ => Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${formatDistance(item.distanceMeters)} straight-line · Calculating driving time…',
            ),
          ),
        ],
      ),
    };
    return Semantics(liveRegion: true, child: content);
  }
}
