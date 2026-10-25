import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../design_system/compact_density.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import 'material_search_results.dart';
import 'projects_repository.dart';
import 'work_package_material_widgets.dart';

/// Catalog code of Ready-Mixed Concrete, whose quantity is the Order Volume (m³).
const readyMixedCode = 'READY_MIXED_CONCRETE';

/// Generic details for an unlisted material, which has no category attributes.
const unlistedDetails = [
  ('size', 'Size'),
  ('weight', 'Weight'),
  ('length', 'Length'),
  ('width', 'Width'),
];

/// Opens the Add/Edit Material form as a tall bottom sheet. Resolves to the
/// submitted Work Package line, or null when the Buyer cancels or dismisses.
Future<ProjectData?> showMaterialEditSheet(
  BuildContext context, {
  required ProjectsRepository repository,
  ProjectData? initial,
}) => showModalBottomSheet<ProjectData>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (sheetContext) => CompactScope(
    child: Padding(
      // Keeps the pinned footer above the keyboard.
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 1,
        builder: (context, scroll) => MaterialEditSheet(
          repository: repository,
          initial: initial,
          scrollController: scroll,
          onSubmit: (line) => Navigator.pop(sheetContext, line),
          onCancel: () => Navigator.pop(sheetContext),
        ),
      ),
    ),
  ),
);

/// The Buyer types a name, chooses an exact or close catalog match, or keeps
/// the name as an unlisted material; unit and technical details then follow
/// the choice. Header and Save/Cancel footer stay pinned; only the body
/// scrolls. Submits one Work Package line.
class MaterialEditSheet extends StatefulWidget {
  const MaterialEditSheet({
    super.key,
    required this.repository,
    required this.onSubmit,
    required this.onCancel,
    this.initial,
    this.scrollController,
  });
  final ProjectsRepository repository;
  final ValueChanged<ProjectData> onSubmit;
  final VoidCallback onCancel;

  /// A line being revised; null when adding.
  final ProjectData? initial;

  /// Drives the sheet's drag-to-resize from the body list.
  final ScrollController? scrollController;

  @override
  State<MaterialEditSheet> createState() => _MaterialEditSheetState();
}

class _MaterialEditSheetState extends State<MaterialEditSheet> {
  final name = TextEditingController(),
      description = TextEditingController(),
      color = TextEditingController(),
      quantity = TextEditingController(),
      brand = TextEditingController();
  final details = <String, TextEditingController>{};
  List<api.ProjectMaterial> matches = [];
  List<api.ProjectMaterialUnit> units = [];
  api.ProjectMaterial? material;
  bool unlisted = false, searching = false;

  /// Result list re-opened from the collapsed choice with "Change".
  bool browsing = false;
  bool detailsOpen = false, showDescription = false;
  String lookedUp = '';
  String? unit, error;
  int sequence = 0;
  Timer? debounce;

  bool get editing => widget.initial != null;
  bool get chosen => material != null || unlisted;

  /// Ready-mixed concrete is ordered by volume, not by a count of pieces.
  bool get readyMixed => !unlisted && material?.code == readyMixedCode;

  List<api.ProjectMaterialUnit> get unitChoices =>
      unlisted ? units : material?.compatibleUnits.toList() ?? [];

  /// Detail codes that apply to the current choice.
  Iterable<String> get detailCodes => unlisted
      ? unlistedDetails.map((d) => d.$1)
      : (material?.attributes.toList() ?? <api.ProjectMaterialAttribute>[]).map(
          (a) => projectText(a.code),
        );

  /// Stated technical details, shown as "N set" while the section is closed.
  int get detailsSet => [
    for (final code in detailCodes) details[code],
    color,
    brand,
    description,
  ].where((c) => (c?.text ?? '').trim().isNotEmpty).length;

  @override
  void initState() {
    super.initState();
    final line = widget.initial;
    if (line == null) return;
    name.text = projectText(line['name']);
    description.text = projectText(line['description']);
    color.text = projectText(line['color']);
    quantity.text = materialQuantity(line['quantity']);
    brand.text = projectText(line['preferred_brand']);
    unit = line['unit_id'] as String?;
    unlisted = line['material_id'] == null;
    for (final e in projectObject(line['specifications']).entries) {
      details[e.key] = TextEditingController(text: '${e.value}');
    }
    showDescription = description.text.isNotEmpty;
    detailsOpen =
        projectObject(line['specifications']).isNotEmpty ||
        color.text.isNotEmpty ||
        brand.text.isNotEmpty ||
        description.text.isNotEmpty;
    // Reload the catalog choice (or the unit list) so the line can be revised.
    _lookup(name.text, keep: true);
  }

  @override
  void dispose() {
    debounce?.cancel();
    sequence++;
    for (final c in [
      name,
      description,
      color,
      quantity,
      brand,
      ...details.values,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _detail(String code) =>
      details.putIfAbsent(code, TextEditingController.new);

  Future<void> _lookup(String query, {bool keep = false}) async {
    final token = ++sequence;
    if (query.trim().length < 2) {
      setState(() {
        matches = [];
        searching = false;
        lookedUp = '';
      });
      return;
    }
    setState(() => searching = true);
    try {
      final result = await widget.repository.materials(query.trim());
      if (!mounted || token != sequence) return;
      setState(() {
        matches = result.items.toList();
        units = result.units.toList();
        lookedUp = query.trim();
        searching = false;
        if (keep && !unlisted) {
          material = matches
              .where((m) => m.id == widget.initial?['material_id'])
              .firstOrNull;
        }
      });
    } on DiscoveryFailure catch (e) {
      if (mounted && token == sequence) {
        setState(() {
          error = e.message;
          searching = false;
        });
      }
    }
  }

  void _typed(String value) {
    debounce?.cancel();
    sequence++;
    setState(() {
      // A different name is a different choice.
      material = null;
      unlisted = false;
      unit = null;
      browsing = false;
    });
    debounce = Timer(const Duration(milliseconds: 350), () => _lookup(value));
  }

  void _choose(api.ProjectMaterial? m) => setState(() {
    material = m;
    unlisted = m == null;
    browsing = false;
    final choices = unitChoices;
    unit = choices.length == 1 ? projectText(choices.first.id) : null;
    error = null;
    detailsOpen = detailsSet > 0;
  });

  void _change() {
    setState(() => browsing = true);
    if (lookedUp != name.text.trim()) unawaited(_lookup(name.text));
  }

  void _fail(String message) {
    setState(() => error = message);
    final scroll = widget.scrollController;
    if (scroll != null && scroll.hasClients) {
      unawaited(
        scroll.animateTo(
          0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        ),
      );
    }
  }

  void _submit() {
    final typedName = name.text.trim();
    final choice = unitChoices.where((u) => u.id == unit).firstOrNull;
    final precision = projectInt(choice?.precision);
    final qty = quantity.text.trim();
    final decimals = qty.contains('.') ? qty.split('.').last.length : 0;
    final failure = !chosen || typedName.length < 2
        ? 'Type a material name, then choose a match or keep it as an unlisted material.'
        : choice == null
        ? 'Choose a unit.'
        : !RegExp(r'^\d{1,7}(\.\d{1,4})?$').hasMatch(qty) ||
              (double.tryParse(qty) ?? 0) <= 0 ||
              (double.tryParse(qty) ?? 0) > 1000000
        ? readyMixed
              ? 'Use an order volume above zero, up to 1,000,000 m³.'
              : 'Use a quantity above zero, up to 1,000,000.'
        : decimals > precision
        ? precision == 0
              ? 'This unit is counted in whole numbers.'
              : 'This unit allows up to $precision decimal places.'
        : _invalidDetail();
    if (failure != null) {
      _fail(failure);
      return;
    }
    final specifications = <String, String>{};
    for (final code in detailCodes) {
      final value = (details[code]?.text ?? '').trim();
      if (value.isNotEmpty) specifications[code] = value;
    }
    String? optional(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();
    widget.onSubmit({
      'material_id': unlisted ? null : material!.id,
      'material_kind': unlisted ? 'UNLISTED' : 'CATALOG',
      'name': unlisted ? typedName : projectText(material!.name),
      'category_name': unlisted ? null : material!.categoryName,
      'regulated': unlisted ? false : material!.regulated == true,
      'unit_id': unit,
      'unit_code': choice!.code,
      'quantity': qty,
      'preferred_brand': optional(brand),
      'description': optional(description),
      'color': optional(color),
      'specifications': specifications,
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          _SheetHeader(
            title: editing ? 'Edit Material' : 'Add Material',
            onClose: widget.onCancel,
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              controller: widget.scrollController,
              padding: const EdgeInsets.fromLTRB(
                CompactDensity.sheetPadding,
                CompactDensity.gapLarge,
                CompactDensity.sheetPadding,
                CompactDensity.gapLarge,
              ),
              children: [
                if (error != null) ...[
                  Text(
                    error!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: CompactDensity.gap),
                ],
                TextField(
                  controller: name,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: 'Material name',
                    helperText: chosen
                        ? null
                        : 'At least two characters. Matches update as you type.',
                    suffixIcon: const Icon(
                      LucideIcons.search,
                      size: CompactDensity.icon,
                    ),
                  ),
                  onChanged: _typed,
                ),
                if (chosen && !browsing)
                  SelectedMaterialRow(
                    material: material,
                    name: name.text.trim(),
                    onChange: _change,
                  )
                else
                  MaterialSearchResults(
                    matches: matches,
                    searching: searching,
                    query: lookedUp,
                    selectedId: material?.id,
                    unlisted: unlisted,
                    onChoose: _choose,
                  ),
                if (chosen) ...[
                  const SizedBox(height: CompactDensity.gapLarge),
                  _quantityAndUnit(theme),
                  const SizedBox(height: CompactDensity.gap),
                  _technicalDetails(),
                ],
              ],
            ),
          ),
          _SheetFooter(
            saveLabel: editing ? 'Save changes' : 'Add Item',
            onSave: _submit,
            onCancel: widget.onCancel,
          ),
        ],
      ),
    );
  }

  Widget _quantityAndUnit(ThemeData theme) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: quantity,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              decoration: InputDecoration(
                labelText: readyMixed ? 'Order volume (m³)' : 'Quantity',
              ),
            ),
          ),
          const SizedBox(width: CompactDensity.gap),
          Expanded(
            child: DropdownButtonFormField<String>(
              key: ValueKey('unit-${material?.id}-$unlisted'),
              initialValue: unitChoices.any((u) => u.id == unit) ? unit : null,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Unit'),
              // The closed field shows the code; the menu shows full names.
              selectedItemBuilder: (context) => [
                for (final u in unitChoices)
                  Text(
                    projectText(u.code),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
              items: [
                for (final u in unitChoices)
                  DropdownMenuItem(
                    value: projectText(u.id),
                    child: Text(
                      '${projectText(u.name)} (${projectText(u.code)})',
                    ),
                  ),
              ],
              onChanged: (v) => setState(() => unit = v),
            ),
          ),
        ],
      ),
      const SizedBox(height: 4),
      Text(
        unlisted
            ? 'Any normalized unit, e.g. bag, meter, sheet, cu.m.'
            : readyMixed
            ? 'Cubic meters of concrete to deliver to your site.'
            : 'Units this material is sold in.',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(color: BuyerTheme.muted),
      ),
    ],
  );

  Widget _technicalDetails() => TechnicalDetailsSection(
    // Re-keyed per choice so a newly chosen material re-applies auto-expand.
    key: ValueKey('details-${material?.id}-$unlisted'),
    helper: unlisted
        ? 'Describe the size and dimensions so Vendors can quote it.'
        : 'Only details you state are required of a Vendor match. Details you leave open let you choose between the products a Vendor offers. "Listed" values are what products are sold with now.',
    setCount: detailsSet,
    expanded: detailsOpen,
    onExpansionChanged: (open) => setState(() => detailsOpen = open),
    emptyNote:
        !unlisted &&
            (material?.attributes.toList() ?? <api.ProjectMaterialAttribute>[])
                .isEmpty
        ? 'This material has no technical details to state.'
        : null,
    cells: [
      ..._detailFields(),
      (
        label: 'Color (optional)',
        field: TextField(
          controller: color,
          maxLength: 60,
          buildCounter: nearLimitCounter,
          decoration: const InputDecoration(labelText: 'Color (optional)'),
        ),
      ),
    ],
    footer: [
      TextField(
        controller: brand,
        maxLength: 100,
        buildCounter: nearLimitCounter,
        decoration: const InputDecoration(
          labelText: 'Brand requirement (optional)',
        ),
      ),
      if (showDescription)
        TextField(
          controller: description,
          maxLength: 500,
          buildCounter: nearLimitCounter,
          minLines: 2,
          maxLines: 2,
          autofocus: description.text.isEmpty,
          decoration: const InputDecoration(
            labelText: 'Description (optional)',
          ),
        )
      else
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            onPressed: () => setState(() => showDescription = true),
            icon: const Icon(LucideIcons.plus, size: 18),
            label: const Text('Add description'),
          ),
        ),
    ],
  );

  String _attributeLabel(api.ProjectMaterialAttribute a) {
    final unitCode = projectText(a.unitCode);
    return unitCode.isEmpty
        ? projectText(a.label)
        : '${projectText(a.label)} ($unitCode)';
  }

  List<TechnicalDetailCell> _detailFields() {
    if (unlisted) {
      return [
        for (final (code, label) in unlistedDetails)
          (
            label: label,
            field: TextField(
              controller: _detail(code),
              maxLength: 200,
              buildCounter: noCounter,
              decoration: InputDecoration(labelText: label),
            ),
          ),
      ];
    }
    final fields = <TechnicalDetailCell>[];
    for (final a
        in (material?.attributes.toList() ??
            <api.ProjectMaterialAttribute>[])) {
      final code = projectText(a.code);
      final label = _attributeLabel(a);
      final allowed = a.allowedValues?.map(projectText).toList();
      final listed = [for (final v in a.offeredValues ?? []) '$v'];
      final current = _detail(code).text;
      final Widget input = a.valueType.name == 'ENUM' && allowed != null
          ? DropdownButtonFormField<String>(
              // Re-keyed so tapping a listed value shows it.
              key: ValueKey('detail-$code-$current'),
              initialValue: allowed.contains(current) ? current : null,
              isExpanded: true,
              decoration: InputDecoration(labelText: label),
              items: [
                const DropdownMenuItem<String>(child: Text('Any')),
                for (final v in allowed)
                  DropdownMenuItem(value: v, child: Text(v)),
              ],
              onChanged: (v) => setState(() => _detail(code).text = v ?? ''),
            )
          : TextField(
              controller: _detail(code),
              maxLength: 200,
              buildCounter: noCounter,
              keyboardType: a.valueType.name == 'NUMBER'
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : TextInputType.text,
              inputFormatters: a.valueType.name == 'NUMBER'
                  ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
                  : null,
              decoration: InputDecoration(labelText: label),
              onChanged: (_) => setState(() {}),
            );
      fields.add((
        label: label,
        field: listed.isEmpty
            ? input
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListedValues(
                    label: label,
                    values: listed,
                    selected: current,
                    onSelect: (v) => setState(
                      () => _detail(code).text = current == v ? '' : v,
                    ),
                  ),
                  input,
                ],
              ),
      ));
    }
    return fields;
  }

  /// A stated number must be one the matching can compare.
  String? _invalidDetail() {
    if (unlisted) return null;
    for (final a
        in (material?.attributes.toList() ??
            <api.ProjectMaterialAttribute>[])) {
      final value = (details[projectText(a.code)]?.text ?? '').trim();
      if (value.isEmpty || a.valueType.name != 'NUMBER') continue;
      if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value) ||
          (double.tryParse(value) ?? 0) <= 0) {
        return '${projectText(a.label)} must be a number above zero, without units.';
      }
    }
    return null;
  }
}

/// Values the material's current products are sold with, shown above their
/// field as tappable chips that wrap onto further lines; tapping the chosen
/// one again clears it.
class ListedValues extends StatelessWidget {
  const ListedValues({
    super.key,
    required this.label,
    required this.values,
    required this.selected,
    required this.onSelect,
  });
  final String label, selected;
  final List<String> values;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      // The field's floating label rises above its box; keep chips clear of it.
      padding: const EdgeInsets.only(bottom: 14),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Icon(LucideIcons.tag, size: 14, color: BuyerTheme.muted),
          Text(
            'Listed',
            style: theme.textTheme.labelMedium?.copyWith(
              color: BuyerTheme.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
          for (final v in values)
            ChoiceChip(
              label: Text(v),
              selected: v == selected,
              showCheckmark: false,
              visualDensity: VisualDensity.compact,
              labelStyle: theme.textTheme.labelLarge?.copyWith(
                color: v == selected
                    ? BuyerTheme.actionPressed
                    : theme.colorScheme.onSurface,
                fontWeight: v == selected ? FontWeight.w700 : FontWeight.w500,
              ),
              backgroundColor: theme.colorScheme.surface,
              selectedColor: BuyerTheme.brandSoft,
              side: BorderSide(
                color: v == selected
                    ? BuyerTheme.actionPressed
                    : BuyerTheme.border,
              ),
              shape: const StadiumBorder(),
              tooltip: '$label $v',
              onSelected: (_) => onSelect(v),
            ),
        ],
      ),
    );
  }
}

/// One technical-detail field and the label it shows, so the section can keep
/// that label readable.
typedef TechnicalDetailCell = ({String label, Widget field});

/// Collapsible "Technical details" with a "N set" badge while closed. Fields
/// sit two per row when both labels fit at half width; a longer label gets a
/// full row so it is never cut off. [footer] rows span the full width.
class TechnicalDetailsSection extends StatelessWidget {
  const TechnicalDetailsSection({
    super.key,
    required this.helper,
    required this.setCount,
    required this.expanded,
    required this.onExpansionChanged,
    required this.cells,
    required this.footer,
    this.emptyNote,
  });
  final String helper;
  final int setCount;

  /// Current open state; also the initial state for a newly keyed section.
  final bool expanded;
  final ValueChanged<bool> onExpansionChanged;
  final List<TechnicalDetailCell> cells;
  final List<Widget> footer;
  final String? emptyNote;

  /// Narrower than this (per column, at the current text scale) and the
  /// fields stack in one column so their labels stay readable.
  static const _minColumnWidth = 140.0;

  /// Field chrome beside the label: content padding and a dropdown arrow.
  static const _fieldChrome = 12.0 * 2 + 32;

  /// Rows of one or two cells: a cell whose label does not fit at half width
  /// takes the whole row.
  List<List<TechnicalDetailCell>> _rows(
    BuildContext context,
    double width,
    int columns,
  ) {
    final style = Theme.of(context).textTheme.bodyLarge;
    final scaler = MediaQuery.textScalerOf(context);
    final half = (width - CompactDensity.gap) / 2 - _fieldChrome;
    bool fits(String label) {
      final painter = TextPainter(
        text: TextSpan(text: label, style: style),
        textDirection: Directionality.of(context),
        textScaler: scaler,
        maxLines: 1,
      )..layout();
      final fitsHalf = painter.width <= half;
      painter.dispose();
      return fitsHalf;
    }

    final rows = <List<TechnicalDetailCell>>[];
    for (var i = 0; i < cells.length; i++) {
      final pairable =
          columns == 2 &&
          i + 1 < cells.length &&
          fits(cells[i].label) &&
          fits(cells[i + 1].label);
      rows.add(pairable ? [cells[i], cells[++i]] : [cells[i]]);
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: CompactDensity.gapLarge),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BuyerTheme.border),
      ),
      child: ExpansionTile(
        initiallyExpanded: expanded,
        onExpansionChanged: onExpansionChanged,
        minTileHeight: CompactDensity.target + 4,
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        title: Row(
          children: [
            Flexible(
              child: Text(
                'Technical details',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Tooltip(
              message: helper,
              triggerMode: TooltipTriggerMode.tap,
              showDuration: const Duration(seconds: 4),
              child: const SizedBox.square(
                dimension: CompactDensity.target,
                child: Icon(
                  LucideIcons.info,
                  size: 18,
                  color: BuyerTheme.muted,
                ),
              ),
            ),
            if (!expanded && setCount > 0) _SetBadge(count: setCount),
          ],
        ),
        children: [
          if (emptyNote != null)
            Padding(
              padding: const EdgeInsets.only(bottom: CompactDensity.gap),
              child: Text(
                emptyNote!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: BuyerTheme.muted,
                ),
              ),
            ),
          LayoutBuilder(
            builder: (context, constraints) {
              final scale = MediaQuery.textScalerOf(context).scale(1);
              final columns =
                  constraints.maxWidth / scale >=
                      _minColumnWidth * 2 + CompactDensity.gap
                  ? 2
                  : 1;
              return Padding(
                // Room above the first row for its floating label, which the
                // expansion clip would otherwise cut off.
                padding: const EdgeInsets.only(top: CompactDensity.gap),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final row in _rows(
                      context,
                      constraints.maxWidth,
                      columns,
                    ))
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: CompactDensity.gap,
                        ),
                        child: row.length == 1
                            ? row.first.field
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: row.first.field),
                                  const SizedBox(width: CompactDensity.gap),
                                  Expanded(child: row.last.field),
                                ],
                              ),
                      ),
                  ],
                ),
              );
            },
          ),
          for (final row in footer)
            Padding(
              padding: const EdgeInsets.only(bottom: CompactDensity.gap),
              child: row,
            ),
        ],
      ),
    );
  }
}

class _SetBadge extends StatelessWidget {
  const _SetBadge({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: BuyerTheme.brandSoft,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      '$count set',
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: BuyerTheme.actionPressed,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.title, required this.onClose});
  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(CompactDensity.sheetPadding, 4, 4, 0),
    child: Column(
      children: [
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: BuyerTheme.border,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontSize: 18),
                ),
              ),
            ),
            IconButton(
              tooltip: 'Close',
              onPressed: onClose,
              icon: const Icon(LucideIcons.x),
            ),
          ],
        ),
      ],
    ),
  );
}

class _SheetFooter extends StatelessWidget {
  const _SheetFooter({
    required this.saveLabel,
    required this.onSave,
    required this.onCancel,
  });
  final String saveLabel;
  final VoidCallback onSave, onCancel;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: BuyerTheme.border)),
    ),
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          CompactDensity.sheetPadding,
          CompactDensity.gap,
          CompactDensity.sheetPadding,
          CompactDensity.gap,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: FilledButton(onPressed: onSave, child: Text(saveLabel)),
            ),
            const SizedBox(width: CompactDensity.gapLarge),
            Expanded(
              flex: 2,
              child: OutlinedButton(
                onPressed: onCancel,
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
