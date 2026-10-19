import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../design_system/components/bottom_action_bar.dart';
import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/components/buyer_overlays.dart';
import '../../design_system/components/form_dialog.dart';
import '../../design_system/components/procurement_components.dart';
import '../../design_system/components/product_summary_row.dart';
import '../../design_system/components/specification_chips.dart';
import '../../design_system/components/quotation_payment_choices.dart';
import '../../design_system/components/ranking_indicator.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import 'projects_repository.dart';
import 'quotation_line_widgets.dart';
import 'vendor_quotation_screen.dart'
    show
        OfferRow,
        ProjectDeliveryConfiguration,
        ProjectProcurementRules,
        noAlternativeMessage;
import 'vendor_selection_screen.dart';
import 'vendor_selection_widgets.dart';
import 'work_package_material_widgets.dart';

/// One review surface, checklist and final checkout for equal Work Package suppliers.
class ProjectArrangementScreen extends StatefulWidget {
  const ProjectArrangementScreen({
    super.key,
    required this.repository,
    required this.package,
    required this.option,
    required this.links,
  });
  final ProjectsRepository repository;
  final ProjectData package, option;
  final ProjectSourcingLinks links;
  @override
  State<ProjectArrangementScreen> createState() =>
      _ProjectArrangementScreenState();
}

class _ProjectArrangementScreenState extends State<ProjectArrangementScreen> {
  ProjectData? arrangement;
  bool busy = false, loading = true, acknowledged = false;
  int stage = 0;
  String? error;
  final createKey = projectKey();
  String? submitKey;
  final payments = <String, String>{};
  final note = TextEditingController(), reason = TextEditingController();
  String get packageId => projectText(widget.package['id']);
  String get id => projectText(arrangement?['id']);
  List<ProjectData> get vendors => projectRows(arrangement?['vendors']);
  ProjectData get coverage => projectObject(arrangement?['coverage']);
  List<ProjectData> get requirements => projectRows(
    projectObject(projectObject(widget.package['version'])['content'])['lines'],
  );
  bool get hasPending => vendors.any((v) => v['requested'] != true);
  bool get allQuoted =>
      vendors.isNotEmpty &&
      vendors.every((v) => v['quotation_version_id'] != null);
  bool get allConfirmed =>
      vendors.isNotEmpty && vendors.every((v) => v['accepted'] == true);
  Iterable<String> available(ProjectData vendor) => projectRows(
    vendor['payment_methods'],
  ).where((m) => m['available'] == true).map((m) => projectText(m['method']));
  bool get ready =>
      arrangement != null &&
      !loading &&
      !busy &&
      vendors.isNotEmpty &&
      ((arrangement!['issues'] as List?) ?? const []).isEmpty &&
      arrangement!['stale'] != true;
  bool get paymentsReady => vendors.every(
    (v) =>
        v['requested'] == true ||
        available(v).contains(payments[projectText(v['vendor_id'])]),
  );

  @override
  void initState() {
    super.initState();
    unawaited(_refresh());
  }

  @override
  void dispose() {
    note.dispose();
    reason.dispose();
    super.dispose();
  }

  void _accept(ProjectData next) {
    arrangement = next;
    acknowledged = false;
    for (final v in projectRows(next['vendors'])) {
      final vendorId = projectText(v['vendor_id']);
      if (v['requested'] != true &&
          !available(v).contains(payments[vendorId])) {
        payments.remove(vendorId);
      }
    }
  }

  Future<void> _refresh() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final next = arrangement != null
          ? await widget.repository.arrangement(packageId, id)
          : projectInt(widget.option['version']) > 0
          ? await widget.repository.arrangement(
              packageId,
              projectText(widget.option['id']),
            )
          : await widget.repository.createArrangement(
              packageId,
              projectText(widget.option['source_candidate_id']),
              createKey,
              proposalToken: widget.option['proposal_token'] as String?,
            );
      if (mounted) setState(() => _accept(next));
    } on DiscoveryFailure catch (e) {
      if (mounted) setState(() => error = e.message);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<bool> _edit(ProjectData input) async {
    if (busy) return false;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final next = await widget.repository.editArrangement(packageId, id, {
        'version': arrangement!['version'],
        ...input,
      });
      if (mounted) {
        setState(() {
          _accept(next);
          stage = 0;
          submitKey = null;
        });
      }
      return true;
    } on DiscoveryFailure catch (e) {
      if (mounted) setState(() => error = e.message);
      return false;
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _remove(ProjectData item) async {
    await _edit({
      'line_id': item['line_id'],
      'item_id': item['draft_item_id'],
      'remove': true,
    });
  }

  Future<void> _change(ProjectData item) async {
    if (await _edit({
          'line_id': item['line_id'],
          'item_id': item['draft_item_id'],
          'remove': true,
        }) &&
        mounted) {
      final requirement = requirements.firstWhere(
        (r) => r['id'] == item['line_id'],
      );
      await _offers(requirement);
    }
  }

  Future<void> _offers(ProjectData requirement) async {
    final selected = await showBuyerBottomSheet<ProjectData>(
      context: context,
      builder: (context) => _ArrangementOffers(
        repository: widget.repository,
        packageId: packageId,
        arrangementId: id,
        requirement: requirement,
        links: widget.links,
      ),
    );
    if (selected == null || !mounted) return;
    final methods = (selected['fulfillment_methods'] as List?) ?? const [];
    final current = vendors.where(
      (v) => v['vendor_id'] == selected['vendor_id'],
    );
    final preferred = current.isNotEmpty
        ? projectText(current.first['fulfillment_method'])
        : projectText(
            projectObject(
              projectObject(widget.package['version'])['content'],
            )['fulfillment_method'],
          );
    await _edit({
      'line_id': requirement['id'],
      'variant_id': selected['variant_id'],
      'price_version_id': selected['price_version_id'],
      'method': methods.contains(preferred)
          ? preferred
          : methods.contains('DELIVERY')
          ? 'DELIVERY'
          : 'PICKUP',
    });
  }

  Future<void> _waive(ProjectData line) async {
    final text = TextEditingController();
    final form = GlobalKey<FormState>();
    final confirmed = await showBuyerFormDialog<bool>(
      context: context,
      builder: (context) => BuyerDialog(
        title: Text('Waive ${projectText(line['name'])}'),
        content: Form(
          key: form,
          child: TextFormField(
            controller: text,
            maxLines: 3,
            maxLength: 2000,
            decoration: const InputDecoration(
              labelText: 'Written reason',
              helperText:
                  'This records an explicit waiver of the uncovered quantity.',
              helperMaxLines: 3,
            ),
            validator: (value) => (value?.trim().length ?? 0) < 10
                ? 'Explain the waiver in at least 10 characters.'
                : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (form.currentState!.validate()) Navigator.pop(context, true);
            },
            child: const Text('Record waiver'),
          ),
        ],
      ),
    );
    final written = text.text.trim();
    text.dispose();
    if (confirmed != true || !mounted) return;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final current = await widget.repository.package(packageId);
      await widget.repository.resolve(packageId, projectText(line['line_id']), {
        'lock_version': current['lock_version'],
        'reason': written,
      });
      if (mounted) await _refresh();
    } on DiscoveryFailure catch (e) {
      if (mounted) setState(() => error = e.message);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _message(ProjectData vendor) async {
    if (vendor['order_id'] != null) {
      widget.links.openOrder(context, projectText(vendor['order_id']));
      return;
    }
    if (vendor['conversation_id'] != null) {
      widget.links.openConversation(
        context,
        projectText(vendor['conversation_id']),
      );
      return;
    }
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final next = await widget.repository.arrangementInquiry(
        packageId,
        id,
        projectText(vendor['vendor_id']),
        projectInt(arrangement!['version']),
      );
      if (!mounted) return;
      setState(() => _accept(next));
      final updated = vendors.firstWhere(
        (v) => v['vendor_id'] == vendor['vendor_id'],
      );
      widget.links.openConversation(
        context,
        projectText(updated['conversation_id']),
      );
    } on DiscoveryFailure catch (e) {
      if (mounted) setState(() => error = e.message);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _next() async {
    if (!ready) return;
    if (stage == 0) {
      setState(() {
        stage = 1;
        acknowledged = false;
      });
      return;
    }
    if (stage == 1) {
      if (paymentsReady && acknowledged) setState(() => stage = 2);
      return;
    }
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final next = await widget.repository.submitArrangement(packageId, id, {
        'version': arrangement!['version'],
        'fingerprint': arrangement!['fingerprint'],
        'acknowledged': acknowledged,
        'payments': [
          for (final vendor in vendors)
            if (vendor['requested'] != true)
              {
                'vendor_id': vendor['vendor_id'],
                'payment_method': payments[projectText(vendor['vendor_id'])],
              },
        ],
        if (note.text.trim().isNotEmpty) 'note': note.text.trim(),
        if (reason.text.trim().isNotEmpty)
          'budget_override_reason': reason.text.trim(),
      }, submitKey ??= projectKey());
      if (mounted) {
        setState(() {
          _accept(next);
          stage = 0;
          submitKey = null;
        });
      }
    } on DiscoveryFailure catch (e) {
      if (mounted) setState(() => error = e.message);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Widget _amount(String name, Object? amount, {bool strong = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            name,
            style: TextStyle(fontWeight: strong ? FontWeight.w700 : null),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            amount == null ? 'Vendor review' : projectMoney(amount),
            textAlign: TextAlign.end,
            style: TextStyle(fontWeight: strong ? FontWeight.w700 : null),
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = vendors.length;
    final group = count > 1;
    return PopScope(
      canPop: stage == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && mounted) setState(() => stage--);
      },
      child: Scaffold(
        appBar: buyerAppBar(
          context,
          stage == 0
              ? (group ? 'Quotation group' : 'Quotation')
              : stage == 1
              ? 'Selection checklist'
              : 'Quotation checkout',
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              if (loading || busy) const LinearProgressIndicator(),
              if (error != null)
                StatusBand(
                  tone: BandTone.danger,
                  title: error!,
                  action: TextButton(
                    onPressed: busy ? null : _refresh,
                    child: const Text('Refresh'),
                  ),
                ),
              if (arrangement != null) ...[
                Text(
                  projectText(widget.package['name']),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$count vendor${count == 1 ? '' : 's'} · ${projectInt(coverage['lines_fulfilled'])}/${projectInt(coverage['lines_total'])} materials covered',
                ),
                const SizedBox(height: 12),
                StatusBand(
                  tone: BandTone.info,
                  title: allConfirmed
                      ? 'Vendor-confirmed orders'
                      : allQuoted
                      ? 'Vendor quotations'
                      : 'System-compiled estimate',
                  message: allConfirmed
                      ? 'Review each vendor’s recorded order and fulfillment status below.'
                      : allQuoted
                      ? 'Review each vendor’s current quotation version. Acceptance and payment remain separate steps.'
                      : 'Estimates are advisory. Issued quotations are identified under each vendor. Review confirmations before approval and payment.',
                ),
                if (arrangement!['stale'] == true)
                  const StatusBand(
                    tone: BandTone.warning,
                    title: 'Estimate expired',
                    message:
                        'Return to Quotation options and refresh the estimate before continuing.',
                  ),
                if (arrangement!['submitted'] == true)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      'Group requests submitted. Review each vendor’s confirmation below.',
                      style: TextStyle(color: BuyerTheme.successStrong),
                    ),
                  ),
                for (final vendor in vendors) _vendor(vendor),
                if (projectInt(coverage['lines_remaining']) > 0 ||
                    projectInt(coverage['lines_waived']) > 0)
                  ArrangementPanel(
                    title: 'Material coverage',
                    children: [
                      for (final line in projectRows(coverage['lines']))
                        if ((double.tryParse(
                                  projectText(line['remaining_quantity']),
                                ) ??
                                0) >
                            0)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(projectText(line['name'])),
                            subtitle: Text(
                              '${materialQuantity(line['remaining_quantity'])} ${projectText(line['unit_code'])} still needed',
                            ),
                            trailing: TextButton(
                              onPressed: busy || loading
                                  ? null
                                  : () => _offers(
                                      requirements.firstWhere(
                                        (r) => r['id'] == line['line_id'],
                                      ),
                                    ),
                              child: const Text('Find supplier'),
                            ),
                          ),
                      if (stage == 0 &&
                          arrangement!['submitted'] == true &&
                          vendors.any((v) => v['order_id'] != null))
                        for (final line in projectRows(coverage['lines']))
                          if ((double.tryParse(
                                    projectText(line['remaining_quantity']),
                                  ) ??
                                  0) >
                              0)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: busy || loading
                                    ? null
                                    : () => _waive(line),
                                child: Text(
                                  'Waive ${projectText(line['name'])}',
                                ),
                              ),
                            ),
                      for (final line in projectRows(coverage['lines']))
                        if ((double.tryParse(
                                  projectText(line['waived_quantity']),
                                ) ??
                                0) >
                            0)
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(LucideIcons.clipboardCheck),
                            title: Text(projectText(line['name'])),
                            subtitle: Text(
                              '${materialQuantity(line['waived_quantity'])} ${projectText(line['unit_code'])} explicitly waived',
                            ),
                          ),
                    ],
                  ),
                ArrangementPanel(
                  title: 'Delivery mode',
                  children: [
                    for (final (index, vendor) in vendors.indexed) ...[
                      if (index > 0) const Divider(height: 24),
                      ProjectSupplierFulfillment(
                        group: vendor,
                        showStore: true,
                      ),
                      if (stage == 0 &&
                          vendor['requested'] != true &&
                          vendor['conversation_id'] == null &&
                          (((vendor['fulfillment_options'] as List?)?.length ??
                                      0) >
                                  1 ||
                              ProjectSupplierFulfillment.requiresMixerDelivery(
                                vendor,
                              )))
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final method
                                  in (vendor['fulfillment_options'] as List))
                                ChoiceChip(
                                  label: Text(fulfillmentLabel(method)),
                                  selected:
                                      vendor['fulfillment_method'] == method,
                                  onSelected:
                                      busy ||
                                          (vendor['fulfillment_options']
                                                      as List)
                                                  .length ==
                                              1
                                      ? null
                                      : (_) => _edit({
                                          'vendor_id': vendor['vendor_id'],
                                          'fulfillment_method': method,
                                        }),
                                ),
                              if (ProjectSupplierFulfillment.requiresMixerDelivery(
                                vendor,
                              ))
                                const Tooltip(
                                  message:
                                      'Self pick-up is unavailable while this supplier request includes ready-mixed concrete.',
                                  child: ChoiceChip(
                                    label: Text('Self pick-up'),
                                    selected: false,
                                    onSelected: null,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      if (vendor['fulfillment_method'] == 'DELIVERY')
                        ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          title: const Text('Delivery configuration'),
                          children: [
                            ProjectDeliveryConfiguration(candidate: vendor),
                          ],
                        ),
                    ],
                  ],
                ),
                ArrangementPanel(
                  title: 'Total cost',
                  children: [
                    _amount(
                      'Materials · all vendors',
                      arrangement!['materials_centavos'],
                    ),
                    _amount(
                      'Delivery fee · all vendors',
                      arrangement!['delivery_centavos'],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(child: Text('Processing fee')),
                          Text('Shown at payment'),
                        ],
                      ),
                    ),
                    const Divider(height: 28),
                    Center(
                      child: Text(
                        arrangement!['total_centavos'] == null
                            ? 'Cost review required'
                            : projectMoney(arrangement!['total_centavos']),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const Center(child: Text('Projected total · all vendors')),
                    const SizedBox(height: 16),
                    if (arrangement!['total_centavos'] != null)
                      _amount(
                        projectInt(arrangement!['total_centavos']) >
                                projectInt(widget.package['budget_centavos'])
                            ? 'Over budget by'
                            : 'Budget remaining',
                        (projectInt(widget.package['budget_centavos']) -
                                projectInt(arrangement!['total_centavos']))
                            .abs(),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Work Package budget\n${projectMoney(widget.package['budget_centavos'])}',
                          ),
                        ),
                        BudgetStatusChip(
                          projectText(arrangement!['budget_label']),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: FulfillmentScoreTile(
                    candidate: arrangement!,
                    position: projectInt(arrangement!['rank']),
                    arrangement: true,
                  ),
                ),
                for (final previous in projectRows(
                  arrangement!['previous_vendors'],
                ))
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Supplier request ${projectStatus(previous['order_state']).toLowerCase()}',
                    ),
                    subtitle: const Text(
                      'Other vendors are retained. Find a supplier for the uncovered quantities.',
                    ),
                    trailing: TextButton(
                      onPressed: () => previous['order_id'] != null
                          ? widget.links.openOrder(
                              context,
                              projectText(previous['order_id']),
                            )
                          : widget.links.openConversation(
                              context,
                              projectText(previous['conversation_id']),
                            ),
                      child: Text(
                        previous['order_id'] != null
                            ? 'View order'
                            : 'View quotation',
                      ),
                    ),
                  ),
                if (stage >= 1 && hasPending) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: note,
                    maxLines: 2,
                    maxLength: 2000,
                    decoration: const InputDecoration(
                      labelText: 'Note to vendors (optional)',
                      helperText:
                          'Informational only; no separate response required.',
                    ),
                  ),
                  if (arrangement!['budget_label'] == 'OVER_BUDGET')
                    TextField(
                      controller: reason,
                      minLines: 2,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Budget override reason',
                        helperText:
                            'Explain why you need to exceed the budget.',
                      ),
                    ),
                  if (stage == 1)
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: acknowledged,
                      onChanged: busy
                          ? null
                          : (v) => setState(() => acknowledged = v == true),
                      title: const Text(
                        'I reviewed the assigned materials, specifications, remaining quantities, delivery and vendor payment choices.',
                      ),
                      subtitle: const Text(
                        'Requests still need vendor confirmation and the existing buyer approval steps.',
                      ),
                    ),
                ],
                const ProjectProcurementRules(grouped: true),
              ],
            ],
          ),
        ),
        bottomNavigationBar: arrangement == null
            ? null
            : BottomActionBar(
                status:
                    '${projectInt(coverage['lines_fulfilled'])}/${projectInt(coverage['lines_total'])} covered',
                actionLabel: stage == 0
                    ? (hasPending
                          ? 'Select this quotation'
                          : 'Requests submitted')
                    : stage == 1
                    ? 'Review checkout'
                    : 'Submit group requests',
                onAction:
                    ready &&
                        hasPending &&
                        (stage == 0 || (paymentsReady && acknowledged))
                    ? _next
                    : null,
              ),
      ),
    );
  }

  Widget _vendor(ProjectData vendor) {
    final theme = Theme.of(context);
    final requested = vendor['requested'] == true;
    final editable =
        stage == 0 &&
        !requested &&
        vendor['conversation_id'] == null &&
        !busy &&
        !loading;
    return ArrangementPanel(
      title: projectText(vendor['store_name']),
      children: [
        Text(
          vendors.length == 1 &&
                  projectInt(coverage['lines_fulfilled']) ==
                      projectInt(coverage['lines_total'])
              ? 'Main vendor · complete package'
              : '${projectRows(vendor['items']).length} assigned material${projectRows(vendor['items']).length == 1 ? '' : 's'}',
          style: theme.textTheme.bodySmall,
        ),
        if (vendor['order_state'] != null)
          Text(
            'Order · ${projectStatus(vendor['order_state'])}',
            style: TextStyle(color: BuyerTheme.successStrong),
          ),
        if (vendor['quotation_state'] != null)
          Text(
            'Vendor quotation · ${projectStatus(vendor['quotation_state'])}${vendor['quotation_version'] == null ? '' : ' · v${vendor['quotation_version']}'}'
            '${vendor['quotation_total_centavos'] == null ? '' : ' · ${projectMoney(vendor['quotation_total_centavos'])}'}',
          ),
        for (final item in projectRows(vendor['items']))
          ProductSummaryRow(
            name: [
              projectText(item['display_name']),
              projectText(item['variant_label']),
            ].where((v) => v.isNotEmpty).join(' · '),
            imageUrl: projectObject(item['image'])['url'] as String?,
            specifications: specificationDetails(item['specifications']),
            details:
                '${materialQuantity(item['quantity'])} ${projectText(item['unit_code'])}',
            price:
                '${projectMoney(item['unit_price_centavos'])} each · ${projectMoney(item['line_total_centavos'])}',
            status: item['satisfies_requirement'] == true
                ? 'Matches specifications'
                : 'Different specifications · requirement remains open',
            statusIsSuccess: item['satisfies_requirement'] == true,
            onOpen: widget.links.openProduct == null
                ? null
                : () => widget.links.openProduct!(
                    context,
                    projectText(item['listing_id']),
                    item['variant_id'] as String?,
                  ),
            action: !editable
                ? null
                : Wrap(
                    spacing: 4,
                    children: [
                      TextButton(
                        onPressed: () => _change(item),
                        child: const Text('Change'),
                      ),
                      TextButton.icon(
                        onPressed: () => _remove(item),
                        icon: const Icon(LucideIcons.minus, size: 16),
                        label: const Text('Remove'),
                      ),
                    ],
                  ),
          ),
        for (final line in projectRows(vendor['choice_lines']))
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Choose ${projectText(line['name'])} specifications',
              ),
              items: [
                for (final option in projectRows(line['options']))
                  DropdownMenuItem(
                    value: projectText(option['option_id']),
                    child: Text(
                      '${projectText(option['variant_label'])} · ${projectMoney(option['unit_price_centavos'])}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: !editable
                  ? null
                  : (value) {
                      if (value != null) {
                        _edit({
                          'vendor_id': vendor['vendor_id'],
                          'line_id': line['line_id'],
                          'option_id': value,
                        });
                      }
                    },
            ),
          ),
        _amount('Materials', vendor['materials_centavos']),
        _amount('Delivery', vendor['delivery_centavos']),
        _amount(
          'Vendor total',
          vendor['projected_total_centavos'],
          strong: true,
        ),
        if (stage == 1 && !requested)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: QuotationPaymentChoices(
              fulfillmentMethod: projectText(vendor['fulfillment_method']),
              availableMethods: available(vendor),
              value: payments[projectText(vendor['vendor_id'])],
              availableOnly: true,
              onChanged: (value) => setState(() {
                if (value != null) {
                  payments[projectText(vendor['vendor_id'])] = value;
                }
              }),
            ),
          )
        else if (stage == 2 || requested && vendor['payment_method'] != null)
          Text(
            'Payment: ${paymentLabel(requested ? vendor['payment_method'] : payments[projectText(vendor['vendor_id'])])}',
          ),
        for (final issue in (vendor['issues'] as List?) ?? const [])
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              projectText(issue),
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        if (stage == 0)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: busy || loading ? null : () => _message(vendor),
              icon: const Icon(LucideIcons.messageCircle, size: 18),
              label: Text(
                vendor['order_id'] != null
                    ? 'Order & messages'
                    : vendor['quotation_state'] != null
                    ? 'Review vendor quotation'
                    : 'Message vendor',
              ),
            ),
          ),
      ],
    );
  }
}

class ArrangementPanel extends StatelessWidget {
  const ArrangementPanel({
    super.key,
    required this.title,
    required this.children,
  });
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 12),
    padding: const EdgeInsets.all(16),
    decoration: vendorCardDecoration(context),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    ),
  );
}

class ProjectArrangementCard extends StatelessWidget {
  const ProjectArrangementCard({
    super.key,
    required this.option,
    required this.selected,
    required this.onSelect,
    required this.onReview,
    required this.onVendor,
    this.rankingPosition,
  });
  final ProjectData option;
  final int? rankingPosition;
  final bool selected;
  final VoidCallback onSelect, onReview;
  final ValueChanged<String> onVendor;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vendors = projectRows(option['vendors']);
    final coverage = projectObject(option['coverage']);
    final complete =
        projectInt(coverage['lines_total']) > 0 &&
        projectInt(coverage['lines_fulfilled']) ==
            projectInt(coverage['lines_total']);
    final single = vendors.length == 1 && complete;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: vendorCardDecoration(context),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onSelect,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: selected
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: BuyerTheme.action, width: 2),
                  )
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (rankingPosition != null) ...[
                  RankingIndicator(
                    position: rankingPosition!,
                    recommendation: RankingRecommendation.bestMatch,
                    description:
                        'Based on material coverage, complete cost and your ranking preferences.',
                  ),
                  const SizedBox(height: 12),
                ],
                Row(
                  children: [
                    Icon(
                      single ? LucideIcons.store : LucideIcons.layers,
                      size: 18,
                      color: BuyerTheme.actionPressed,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        single ? 'Complete package' : 'Quotation group',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: BuyerTheme.actionPressed,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '${vendors.length} vendor${vendors.length == 1 ? '' : 's'}',
                        textAlign: TextAlign.right,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: BuyerTheme.muted,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (single) ...[
                  Text(
                    projectText(vendors.first['store_name']),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Main vendor', style: theme.textTheme.bodySmall),
                ] else ...[
                  for (final vendor in vendors)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              projectText(vendor['store_name']),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              '${projectRows(vendor['items']).map((i) => i['line_id']).toSet().length} material${projectRows(vendor['items']).map((i) => i['line_id']).toSet().length == 1 ? '' : 's'}',
                              textAlign: TextAlign.right,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: BuyerTheme.muted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      complete
                          ? LucideIcons.circleCheck
                          : LucideIcons.triangleAlert,
                      size: 18,
                      color: complete
                          ? BuyerTheme.successStrong
                          : BuyerTheme.actionPressed,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${projectInt(coverage['lines_fulfilled'])}/${projectInt(coverage['lines_total'])} materials covered',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: complete
                              ? BuyerTheme.successStrong
                              : BuyerTheme.actionPressed,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _CardAmount('Materials', option['materials_centavos']),
                _CardAmount(
                  'Delivery · all vendors',
                  option['delivery_centavos'],
                ),
                const SizedBox(height: 12),
                Text(
                  'Estimated total',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: BuyerTheme.muted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  option['total_centavos'] == null
                      ? 'Cost review required'
                      : projectMoney(option['total_centavos']),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  option['total_centavos'] == null
                      ? 'Materials or delivery estimates need review'
                      : complete
                      ? 'All materials and applicable delivery fees'
                      : 'Selected materials and delivery · incomplete coverage',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: BuyerTheme.muted,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: BudgetStatusChip(projectText(option['budget_label'])),
                ),
                if (projectInt(coverage['lines_remaining']) > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${projectInt(coverage['lines_remaining'])} material requirements still need a supplier.',
                    ),
                  ),
                if (((option['issues'] as List?) ?? const []).isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Review specifications or delivery details before submitting.',
                    ),
                  ),
                const Divider(height: 24),
                FulfillmentScoreTile(
                  candidate: option,
                  position: rankingPosition ?? 0,
                  arrangement: true,
                  outlined: false,
                ),
                ExpansionTile(
                  shape: const Border(),
                  collapsedShape: const Border(),
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: EdgeInsets.zero,
                  title: Text(
                    'Vendor details',
                    style: theme.textTheme.bodyMedium,
                  ),
                  subtitle: Text(
                    'Distance, rating and individual FMS',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: BuyerTheme.muted,
                    ),
                  ),
                  children: [
                    for (final vendor in vendors)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(projectText(vendor['store_name'])),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 4,
                            children: [
                              Text(kilometres(vendor['distance_meters'])),
                              Text(projectText(vendor['score_label'])),
                              Text(
                                fulfillmentLabel(vendor['fulfillment_method']),
                              ),
                              if (projectObject(vendor['fms'])['score'] != null)
                                Text(
                                  'Vendor FMS · ${projectObject(vendor['fms'])['score']}/100',
                                ),
                            ],
                          ),
                        ),
                        trailing: const Icon(LucideIcons.mapPin, size: 18),
                        onTap: () => onVendor(projectText(vendor['vendor_id'])),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      LucideIcons.info,
                      size: 16,
                      color: BuyerTheme.muted,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'System-compiled estimate',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: BuyerTheme.muted,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: onReview,
                  icon: const Icon(LucideIcons.arrowRight, size: 18),
                  iconAlignment: IconAlignment.end,
                  label: const Text('View quotation'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CardAmount extends StatelessWidget {
  const _CardAmount(this.label, this.amount);
  final String label;
  final Object? amount;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: BuyerTheme.muted),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              amount == null ? 'Vendor review' : projectMoney(amount),
              textAlign: TextAlign.right,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    ),
  );
}

class _ArrangementOffers extends StatefulWidget {
  const _ArrangementOffers({
    required this.repository,
    required this.packageId,
    required this.arrangementId,
    required this.requirement,
    required this.links,
  });
  final ProjectsRepository repository;
  final String packageId, arrangementId;
  final ProjectData requirement;
  final ProjectSourcingLinks links;
  @override
  State<_ArrangementOffers> createState() => _ArrangementOffersState();
}

class _ArrangementOffersState extends State<_ArrangementOffers> {
  ProjectData? page;
  String? error;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load({bool more = false}) async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final next = await widget.repository.alternatives(
        widget.packageId,
        projectText(widget.requirement['id']),
        arrangementId: widget.arrangementId,
        page: more ? projectInt(page?['page']) + 1 : 1,
      );
      if (mounted) {
        setState(
          () => page = more
              ? {
                  ...next,
                  'items': [
                    ...projectRows(page?['items']),
                    ...projectRows(next['items']),
                  ],
                }
              : next,
        );
      }
    } on DiscoveryFailure catch (e) {
      if (mounted) setState(() => error = e.message);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: MediaQuery.sizeOf(context).height * .75,
    child: ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Text(
          'Choose supplier · ${projectText(widget.requirement['name'])}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Text(
          'Project-Based suppliers within 50 km. Review specifications before adding. Manage requested vendors through their quotation or order.',
        ),
        if (loading) const LinearProgressIndicator(),
        if (error != null)
          StatusBand(
            tone: BandTone.danger,
            title: error!,
            action: TextButton(onPressed: _load, child: const Text('Retry')),
          ),
        if (page != null && projectRows(page!['items']).isEmpty && !loading)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(noAlternativeMessage(page!, widget.requirement)),
          ),
        for (final offer in projectRows(page?['items']))
          OfferRow(
            offer: offer,
            adding: loading,
            quantity: materialQuantity(page?['needed_quantity']),
            onAdd: offer['already_added'] == true
                ? null
                : () => Navigator.pop(context, offer),
            onOpen: widget.links.openProduct == null
                ? null
                : (listing, variant) =>
                      widget.links.openProduct!(context, listing, variant),
          ),
        if (page?['has_more'] == true)
          OutlinedButton(
            onPressed: loading ? null : () => _load(more: true),
            child: const Text('More products'),
          ),
      ],
    ),
  );
}
