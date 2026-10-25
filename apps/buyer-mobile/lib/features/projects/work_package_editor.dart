import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../design_system/compact_density.dart';
import '../../design_system/components/bottom_action_bar.dart';
import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/components/peso_amount_field.dart';
import '../../design_system/components/procurement_components.dart';
import '../../design_system/components/setting_switch_row.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import 'material_edit_sheet.dart';
import 'projects_repository.dart';
import 'work_package_estimate_widgets.dart';
import 'work_package_material_widgets.dart';

/// Line fields the Work Package contract accepts.
const _lineKeys = [
  'material_id',
  'name',
  'unit_id',
  'quantity',
  'preferred_brand',
  'specifications',
  'description',
  'color',
];

/// Fulfillment choices in menu order. Both means the Buyer is open to either:
/// the scan lists Vendors offering delivery, pickup or both.
const _fulfillmentLabels = {
  'DELIVERY': 'Delivery',
  'PICKUP': 'Pickup',
  'BOTH': 'Both',
};

/// Vertical gap between the site card's fields: two steps of the 8 dp grid.
const _fieldGap = 16.0;

/// One page: name and materials, site and fulfillment, then the budget with
/// an optional advisory estimate. Finalize saves the Draft; activation stays
/// a separate action on the package screen (owner decision 2026-10-12).
class WorkPackageEditor extends StatefulWidget {
  const WorkPackageEditor({
    super.key,
    required this.repository,
    required this.project,
    required this.chooseLocation,
    this.package,
  });
  final ProjectsRepository repository;
  final api.ProjectView project;
  final api.WorkPackageView? package;
  final Future<DiscoveryOrigin?> Function() chooseLocation;
  @override
  State<WorkPackageEditor> createState() => _WorkPackageEditorState();
}

class _WorkPackageEditorState extends State<WorkPackageEditor> {
  final name = TextEditingController(),
      budget = TextEditingController(),
      description = TextEditingController(),
      contact = TextEditingController(),
      instructions = TextEditingController();
  final scroll = ScrollController();
  final lines = <ProjectData>[];
  String? site, alternate, alternateLabel, error;
  String fulfillment = 'PICKUP', heavy = 'NO';
  bool busy = false;
  final key = projectKey();

  /// Collapsed-by-default sections; each opens in place on tap.
  bool showDescription = false, siteOpen = false;

  /// The Buyer edited Site contact, so the profile number never overwrites it.
  bool contactTouched = false;

  bool estimateOn = false, estimating = false;
  api.WorkPackageBudgetEstimate? estimate;
  String? estimateError;
  int estimateSequence = 0;
  Timer? estimateDebounce;

  /// Project budget still unallocated, as the server reports it. Every
  /// non-cancelled package counts, so this package's own saved budget is
  /// returned to the pool while it is being edited.
  int get reserveCentavos {
    final status = projectText(widget.package?.status);
    final own = widget.package != null && status != 'CANCELLED'
        ? projectInt(widget.package!.budgetCentavos)
        : 0;
    return projectInt(widget.project.budget.unallocatedCentavos) + own;
  }

  bool get estimateReady => site != null && lines.isNotEmpty;

  @override
  void initState() {
    super.initState();
    final original = projectObject(widget.package?.version?.content);
    name.text = projectText(original['name']);
    budget.text = original['budget_centavos'] == null
        ? ''
        : pesoFieldText(projectInt(original['budget_centavos']));
    description.text = projectText(original['description']);
    contact.text = projectText(original['site_contact']);
    instructions.text = projectText(original['access_instructions']);
    site =
        original['site_id'] as String? ?? widget.project.sites.firstOrNull?.id;
    fulfillment = projectText(original['fulfillment_method']).isEmpty
        ? 'PICKUP'
        : projectText(original['fulfillment_method']);
    final destination = projectObject(original['destination']);
    heavy = projectText(destination['heavy_vehicle_restriction']).isEmpty
        ? 'NO'
        : projectText(destination['heavy_vehicle_restriction']);
    alternate =
        projectObject(destination['alternate_drop_off'])['location_id']
            as String?;
    lines.addAll(projectRows(original['lines']));
    showDescription = description.text.isNotEmpty;
    if (contact.text.isEmpty) unawaited(_prefillContact());
  }

  /// Offers the Buyer's profile number as the Site contact. Supplementary: a
  /// failed lookup or a profile without a number leaves the field empty.
  Future<void> _prefillContact() async {
    try {
      final phone = await widget.repository.profilePhone();
      if (phone != null && mounted && !contactTouched && contact.text.isEmpty) {
        contact.text = phone;
      }
    } on Object {
      // The Buyer can still type a contact.
    }
  }

  @override
  void dispose() {
    estimateDebounce?.cancel();
    estimateSequence++;
    for (final c in [name, budget, description, contact, instructions]) {
      c.dispose();
    }
    scroll.dispose();
    super.dispose();
  }

  /// Adds a line (null [index]) or revises one in the Edit Material sheet.
  Future<void> _editLine([int? index]) async {
    final line = await showMaterialEditSheet(
      context,
      repository: widget.repository,
      initial: index == null ? null : lines[index],
    );
    if (line == null || !mounted) return;
    setState(() {
      if (index == null) {
        lines.add(line);
      } else {
        lines[index] = line;
      }
      error = null;
    });
    _scheduleEstimate();
  }

  void _removeLine(int index) {
    setState(() => lines.removeAt(index));
    _scheduleEstimate();
  }

  /// Recomputes the advisory estimate after a material, site or
  /// fulfillment change; stale responses are ignored.
  void _scheduleEstimate() {
    estimateDebounce?.cancel();
    estimateSequence++;
    if (!estimateOn || !estimateReady) return;
    if (mounted) setState(() => estimating = true);
    estimateDebounce = Timer(
      const Duration(milliseconds: 400),
      _refreshEstimate,
    );
  }

  Future<void> _refreshEstimate() async {
    if (!estimateOn || !estimateReady) return;
    final token = ++estimateSequence;
    setState(() {
      estimating = true;
      estimateError = null;
    });
    try {
      final result = await widget.repository.estimateBudget(
        projectText(widget.project.id),
        {
          'site_id': site,
          'radius_km': projectSearchRadiusKm,
          'fulfillment_method': fulfillment,
          'heavy_vehicle_restriction': fulfillment == 'PICKUP' ? 'NO' : heavy,
          if (fulfillment != 'PICKUP' && heavy == 'YES' && alternate != null)
            'alternate_drop_off_location_id': alternate,
          'lines': [
            for (final l in lines)
              {
                'material_id': l['material_id'],
                'unit_id': l['unit_id'],
                'quantity': materialQuantity(l['quantity']),
                'preferred_brand': l['preferred_brand'],
                'specifications': projectObject(l['specifications']),
              },
          ],
        },
      );
      if (mounted && token == estimateSequence) {
        setState(() {
          estimate = result;
          estimating = false;
        });
      }
    } on DiscoveryFailure catch (e) {
      if (mounted && token == estimateSequence) {
        setState(() {
          estimateError = e.message;
          estimating = false;
        });
      }
    }
  }

  void _toggleEstimate(bool on) {
    setState(() {
      estimateOn = on;
      if (!on) {
        estimateDebounce?.cancel();
        estimateSequence++;
        estimating = false;
      }
    });
    if (on) unawaited(_refreshEstimate());
  }

  void _fail(String message) {
    setState(() => error = message);
    if (scroll.hasClients) {
      unawaited(
        scroll.animateTo(
          0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        ),
      );
    }
  }

  Future<void> _save() async {
    if (busy) return;
    FocusManager.instance.primaryFocus?.unfocus();
    final amount = parseProjectMoney(budget.text);
    if (name.text.trim().isEmpty) {
      return _fail('Name the Work Package.');
    }
    if (lines.isEmpty) {
      return _fail('Add at least one material.');
    }
    if (site == null) {
      setState(() => siteOpen = true);
      return _fail('Choose a Project site.');
    }
    if (amount == null) {
      return _fail('Enter a valid budget.');
    }
    if (amount > reserveCentavos) {
      return _fail(
        'This budget is more than the ${projectMoney(reserveCentavos)} still available from the Project budget.',
      );
    }
    // Both is open to delivery, so it needs the same delivery details.
    if (fulfillment != 'PICKUP' &&
        (contact.text.trim().length < 3 ||
            instructions.text.trim().length < 5 ||
            (heavy == 'YES' && alternate == null))) {
      setState(() => siteOpen = true);
      return _fail(
        'Add a site contact, access instructions and any required alternative vehicle drop-off.',
      );
    }
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final result = await widget.repository.save(
        projectText(widget.project.id),
        {
          'name': name.text.trim(),
          'description': description.text.trim(),
          'budget_centavos': amount,
          'site_id': site,
          'radius_km': projectSearchRadiusKm,
          'fulfillment_method': fulfillment,
          'site_contact': contact.text.trim(),
          'access_instructions': instructions.text.trim(),
          'heavy_vehicle_restriction': fulfillment == 'PICKUP' ? 'NO' : heavy,
          if (fulfillment != 'PICKUP' && heavy == 'YES')
            'alternate_drop_off_location_id': alternate,
          if (widget.package != null)
            'lock_version': widget.package!.lockVersion,
          'lines': [
            for (final l in lines)
              <String, Object?>{for (final k in _lineKeys) k: l[k]},
          ],
        },
        key,
        id: widget.package?.id,
      );
      if (mounted) Navigator.pop(context, result);
    } on DiscoveryFailure catch (e) {
      if (mounted) _fail(e.message);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !busy,
    child: CompactScope(child: Builder(builder: _page)),
  );

  Widget _page(BuildContext context) => Scaffold(
    appBar: buyerAppBar(
      context,
      widget.package == null ? 'Work package' : 'Edit Work Package',
    ),
    // A Scaffold bottom bar: the body ends above it, so nothing is hidden.
    bottomNavigationBar: BottomActionBar(
      status: lines.length == 1 ? '1 item' : '${lines.length} items',
      actionLabel: busy
          ? 'Saving…'
          : widget.package == null || widget.package!.status == 'DRAFT'
          ? 'Finalize'
          : 'Save changes',
      onAction: busy ? null : _save,
    ),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: AbsorbPointer(
          absorbing: busy,
          child: ListView(
            controller: scroll,
            padding: const EdgeInsets.fromLTRB(
              CompactDensity.gapLarge,
              CompactDensity.gap,
              CompactDensity.gapLarge,
              CompactDensity.gapLarge,
            ),
            children: [
              if (busy) const LinearProgressIndicator(),
              if (error != null) ...[
                StatusBand(tone: BandTone.danger, title: error!),
                const SizedBox(height: CompactDensity.gap),
              ],
              _materialsCard(context),
              const SizedBox(height: CompactDensity.gapLarge),
              _siteCard(context),
              const SizedBox(height: CompactDensity.gapLarge),
              _budgetCard(context),
              if (estimateOn) ...[
                const SizedBox(height: CompactDensity.gapLarge),
                ValueListenableBuilder(
                  valueListenable: budget,
                  builder: (context, value, _) => WorkPackageEstimateSection(
                    lines: lines,
                    estimate: estimate,
                    loading: estimating,
                    error: estimateError,
                    budgetCentavos: parseProjectMoney(value.text),
                    ready: estimateReady,
                    onRetry: _refreshEstimate,
                    onUseAsBudget: (total) =>
                        budget.text = pesoFieldText(total),
                  ),
                ),
              ],
              const SizedBox(height: CompactDensity.gap),
              Text(
                'Finalize saves this Work Package as a Draft. Activate it from the package screen when you are ready for Vendor scanning.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: BuyerTheme.muted),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _materialsCard(BuildContext context) {
    final theme = Theme.of(context);
    const compactButton = EdgeInsets.symmetric(horizontal: 8);
    // The field's own label names the card; a separate heading repeated it.
    return _EditorCard(
      children: [
        TextField(
          controller: name,
          maxLength: 150,
          buildCounter: nearLimitCounter,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: 'Work Package name',
            hintText: 'e.g. CONCRETE & MASONRY WORKS',
          ),
        ),
        if (showDescription) ...[
          const SizedBox(height: CompactDensity.gap),
          TextField(
            controller: description,
            maxLines: 2,
            minLines: 1,
            maxLength: 2000,
            buildCounter: nearLimitCounter,
            autofocus: description.text.isEmpty,
            decoration: const InputDecoration(
              labelText: 'Package description (optional)',
            ),
          ),
        ] else
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              style: TextButton.styleFrom(padding: compactButton),
              onPressed: () => setState(() => showDescription = true),
              icon: const Icon(LucideIcons.plus, size: 18),
              label: const Text('Add description (optional)'),
            ),
          ),
        const Divider(height: CompactDensity.gapLarge),
        if (lines.isEmpty)
          const MaterialsEmptyState()
        else
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: BuyerTheme.border),
            ),
            child: Column(
              children: [
                for (final (i, line) in lines.indexed) ...[
                  if (i > 0) const Divider(height: 1),
                  CompactItemTile(
                    index: i,
                    line: line,
                    onEdit: () => _editLine(i),
                    onRemove: () => _removeLine(i),
                  ),
                ],
              ],
            ),
          ),
        const SizedBox(height: 4),
        // Add Item and the material count share one row.
        Row(
          children: [
            Expanded(
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  style: TextButton.styleFrom(padding: compactButton),
                  onPressed: lines.length >= 100 ? null : _editLine,
                  icon: const Icon(LucideIcons.plus, size: 18),
                  label: const Text('Add Item'),
                ),
              ),
            ),
            Text(
              '${lines.length}/100',
              semanticsLabel: '${lines.length} of 100 materials',
              style: theme.textTheme.bodySmall?.copyWith(
                color: BuyerTheme.muted,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String get _siteSummary {
    final name = widget.project.sites
        .toList()
        .where((s) => s.id == site)
        .map((s) => projectText(s.name));
    return [
      _fulfillmentLabels[fulfillment] ?? 'Pickup',
      name.firstOrNull ?? 'Choose a Project site',
    ].join(' · ');
  }

  /// Collapsed to a "Delivery · site" summary; expands in place on tap and
  /// opens itself when Finalize finds a site or delivery problem.
  Widget _siteCard(BuildContext context) {
    final theme = Theme.of(context);
    return _EditorCard(
      children: [
        Semantics(
          button: true,
          expanded: siteOpen,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => siteOpen = !siteOpen),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: CompactDensity.target,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Site and fulfillment',
                          style: theme.textTheme.titleMedium,
                        ),
                        // Expanded, the fields below show the same facts.
                        if (!siteOpen)
                          Text(
                            _siteSummary,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: BuyerTheme.muted,
                            ),
                          ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: siteOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      LucideIcons.chevronDown,
                      size: CompactDensity.icon,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.topCenter,
          child: siteOpen
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: CompactDensity.gapLarge),
                    ..._siteFields(context),
                  ],
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }

  /// Fulfillment, Project site, Site contact, Access
  /// instructions, then the heavy-vehicle switch for Delivery or Both. Each
  /// field is separated by [_fieldGap] on the 8 dp grid.
  List<Widget> _siteFields(BuildContext context) => [
    DropdownButtonFormField<String>(
      initialValue: fulfillment,
      isExpanded: true,
      decoration: const InputDecoration(labelText: 'Fulfillment'),
      items: [
        for (final e in _fulfillmentLabels.entries)
          DropdownMenuItem(value: e.key, child: Text(e.value)),
      ],
      onChanged: (v) {
        setState(() {
          fulfillment = v!;
          // The switch is hidden for Pickup, so it goes back to off.
          if (fulfillment == 'PICKUP') {
            heavy = 'NO';
            alternate = alternateLabel = null;
          }
        });
        _scheduleEstimate();
      },
    ),
    const SizedBox(height: _fieldGap),
    // A long address wraps to two lines, then ends in an ellipsis. A dense
    // dropdown pins the selected text to one clipped line, so it is not dense.
    DropdownButtonFormField<String>(
      initialValue: site,
      isExpanded: true,
      isDense: false,
      itemHeight: null,
      decoration: const InputDecoration(labelText: 'Project site'),
      selectedItemBuilder: (context) => [
        for (final s in widget.project.sites.toList())
          _SiteName(projectText(s.name)),
      ],
      items: [
        for (final s in widget.project.sites.toList())
          DropdownMenuItem(
            value: projectText(s.id),
            child: _SiteName(projectText(s.name)),
          ),
      ],
      onChanged: (v) {
        setState(() => site = v);
        _scheduleEstimate();
      },
    ),
    const SizedBox(height: _fieldGap),
    TextField(
      controller: contact,
      keyboardType: TextInputType.phone,
      onChanged: (_) => contactTouched = true,
      decoration: const InputDecoration(labelText: 'Site contact'),
    ),
    const SizedBox(height: _fieldGap),
    TextField(
      controller: instructions,
      decoration: const InputDecoration(labelText: 'Access instructions'),
    ),
    if (fulfillment != 'PICKUP') ...[
      const SizedBox(height: _fieldGap),
      SettingSwitchRow(
        label: 'Heavy vehicles restricted',
        helper: "You'll set a separate drop-off point for trucks.",
        value: heavy == 'YES',
        onChanged: (v) {
          setState(() => heavy = v ? 'YES' : 'NO');
          _scheduleEstimate();
        },
      ),
      if (heavy == 'YES')
        OutlinedButton.icon(
          onPressed: () async {
            try {
              final point = await widget.chooseLocation();
              if (point != null && mounted) {
                setState(() {
                  alternate = point.locationId;
                  alternateLabel = point.label;
                });
                _scheduleEstimate();
              }
            } on DiscoveryFailure catch (e) {
              if (mounted) _fail(e.message);
            }
          },
          icon: const Icon(Icons.location_on_outlined),
          label: Text(alternateLabel ?? 'Choose alternative vehicle drop-off'),
        ),
    ],
  ];

  Widget _budgetCard(BuildContext context) => _EditorCard(
    title: 'Budget Summary',
    children: [
      PesoAmountField(controller: budget, label: 'Budget'),
      ProjectReserveHint(
        controller: budget,
        reserveCentavos: reserveCentavos,
        projectCentavos: projectInt(widget.project.budgetCentavos),
      ),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        title: const Text('Enable budget estimation'),
        subtitle: Text(
          'Average prices from nearby Vendors for your listed materials.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: BuyerTheme.muted),
        ),
        value: estimateOn,
        onChanged: _toggleEstimate,
      ),
    ],
  );
}

/// A Project site name that wraps to two lines before it is cut with an
/// ellipsis, so an address never ends mid-text.
class _SiteName extends StatelessWidget {
  const _SiteName(this.name);
  final String name;

  @override
  Widget build(BuildContext context) =>
      Text(name, maxLines: 2, overflow: TextOverflow.ellipsis);
}

class _EditorCard extends StatelessWidget {
  const _EditorCard({required this.children, this.title});
  final String? title;
  final List<Widget> children;

  @override
  // Material, not a decorated Container, so switch tiles keep visible ink.
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(CompactDensity.cardRadius),
      side: const BorderSide(color: BuyerTheme.border),
    ),
    child: Padding(
      padding: const EdgeInsets.all(CompactDensity.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            Text(title!, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: CompactDensity.gap),
          ],
          ...children,
        ],
      ),
    ),
  );
}
