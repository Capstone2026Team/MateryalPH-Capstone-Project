import 'package:flutter/material.dart';

import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/components/procurement_components.dart';
import '../../design_system/components/quotation_payment_choices.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import 'projects_repository.dart';
import 'quotation_line_widgets.dart';
import 'vendor_selection_screen.dart';
import 'vendor_selection_widgets.dart';

/// Checklist and final review share the same server-priced arrangement.
/// Only the final, supplier-specific request buttons create pending requests.
class ProjectSelectionCheckoutScreen extends StatefulWidget {
  const ProjectSelectionCheckoutScreen({
    super.key,
    required this.repository,
    required this.package,
    required this.candidate,
    required this.selections,
    required this.links,
  });
  final ProjectsRepository repository;
  final ProjectData package, candidate;
  final Map<String, String> selections;
  final ProjectSourcingLinks links;

  @override
  State<ProjectSelectionCheckoutScreen> createState() =>
      _ProjectSelectionCheckoutScreenState();
}

class _ProjectSelectionCheckoutScreenState
    extends State<ProjectSelectionCheckoutScreen> {
  late ProjectData package = widget.package, candidate = widget.candidate;
  final methods = <String, String>{},
      requestKeys = <String, String>{},
      requested = <String, String>{};
  final note = TextEditingController(), budgetReason = TextEditingController();
  bool loading = true,
      busy = false,
      checkout = false,
      acknowledged = false,
      previewReady = false;
  String? error, primaryOrder;

  String get primaryId => projectText(candidate['vendor_id']);
  List<ProjectData> get groups => projectRows(candidate['draft_groups']);

  List<String> _available(Object? rows) => [
    for (final row in projectRows(rows))
      if (row['available'] == true) projectText(row['method']),
  ];

  List<String> _issues(Object? value) =>
      value is List ? value.map(projectText).toList() : [];

  bool get canReview =>
      previewReady &&
      !loading &&
      !busy &&
      acknowledged &&
      (primaryOrder != null ||
          _available(
            candidate['payment_methods'],
          ).contains(methods[primaryId])) &&
      groups.every(
        (group) =>
            _issues(group['issues']).isEmpty &&
            _available(
              group['payment_methods'],
            ).contains(methods[projectText(group['vendor_id'])]),
      );

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void dispose() {
    note.dispose();
    budgetReason.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    if (mounted) {
      setState(() {
        loading = true;
        error = null;
        previewReady = false;
      });
    }
    try {
      final current = await widget.repository.package(
        projectText(package['id']),
      );
      final priced = await widget.repository.selectionPreview(
        projectText(package['id']),
        projectText(candidate['id']),
        widget.selections,
        fulfillmentMethod: projectText(candidate['fulfillment_method']),
      );
      if (!mounted) return;
      setState(() {
        package = current;
        candidate = priced;
        previewReady = true;
        primaryOrder = priced['primary_order_id'] as String? ?? primaryOrder;
        if (primaryOrder != null) {
          methods[primaryId] = projectText(priced['payment_method']);
          requested[primaryId] = primaryOrder!;
        }
        if (primaryOrder == null &&
            !_available(
              priced['payment_methods'],
            ).contains(methods[primaryId])) {
          methods.remove(primaryId);
        }
        for (final group in groups) {
          final id = projectText(group['vendor_id']);
          if (!_available(group['payment_methods']).contains(methods[id])) {
            methods.remove(id);
          }
        }
      });
    } on DiscoveryFailure catch (e) {
      if (mounted) setState(() => error = e.message);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _remove(ProjectData item) async {
    if (busy || loading) return;
    setState(() {
      busy = true;
      acknowledged = false;
    });
    try {
      await widget.repository.removeDraftItem(
        packageId: projectText(package['id']),
        candidateId: projectText(candidate['id']),
        lineId: projectText(item['line_id']),
        variantId: projectText(item['variant_id']),
        lockVersion: projectInt(package['lock_version']),
      );
      await _refresh();
    } on DiscoveryFailure catch (e) {
      if (mounted) setState(() => error = e.message);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _request({ProjectData? group}) async {
    if (loading || busy || !acknowledged) return;
    final id = group == null ? primaryId : projectText(group['vendor_id']);
    final method = methods[id];
    if (method == null) return;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final body = <String, Object?>{
        'lock_version': projectInt(package['lock_version']),
        'payment_method': method,
        if (budgetReason.text.trim().isNotEmpty)
          'budget_override_reason': budgetReason.text.trim(),
      };
      // A changed body gets a new key; a failed request retries its exact key.
      final action =
          '$id:$method:${package['lock_version']}:${note.text.trim()}:${budgetReason.text.trim()}:${group?['draft_fingerprint'] ?? ''}';
      final key = requestKeys.putIfAbsent(action, projectKey);
      final order = group == null
          ? await widget.repository.candidate(
              projectText(package['id']),
              {
                ...body,
                'candidate_id': candidate['id'],
                'selections': specificationSelections(widget.selections),
                'fulfillment_method': candidate['fulfillment_method'],
                if (note.text.trim().isNotEmpty) 'note': note.text.trim(),
              },
              key,
              select: true,
            )
          : await widget.repository.requestDraftSupplier(
              packageId: projectText(package['id']),
              candidateId: projectText(candidate['id']),
              vendorId: id,
              input: {...body, 'draft_fingerprint': group['draft_fingerprint']},
              key: key,
            );
      if (!mounted) return;
      setState(() {
        if (group == null) primaryOrder = order;
        requested[id] = order;
      });
      await _refresh();
    } on DiscoveryFailure catch (e) {
      if (mounted) setState(() => error = e.message);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Widget _payment(String vendor, Object? options) => QuotationPaymentChoices(
    fulfillmentMethod: projectText(candidate['fulfillment_method']),
    availableMethods: _available(options),
    value: methods[vendor],
    availableOnly: true,
    onChanged: (value) {
      if (busy || loading || requested.containsKey(vendor)) return;
      setState(() {
        if (value != null) methods[vendor] = value;
        acknowledged = false;
      });
    },
  );

  Widget _section(String title, List<Widget> children, {String? subtitle}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: BuyerTheme.muted),
              ),
            ...children,
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: buyerAppBar(
        context,
        checkout ? 'Quotation checkout' : 'Selection checklist',
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: primaryOrder != null && checkout
              ? FilledButton(
                  onPressed: busy
                      ? null
                      : () => widget.links.openOrder(context, primaryOrder!),
                  child: const Text('View primary request'),
                )
              : FilledButton(
                  onPressed: canReview
                      ? () {
                          if (!checkout) {
                            setState(() => checkout = true);
                          } else {
                            _request();
                          }
                        }
                      : null,
                  child: Text(
                    busy
                        ? 'Sending request…'
                        : checkout
                        ? 'Send request to primary Vendor'
                        : 'Continue to quotation checkout',
                  ),
                ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          if (loading || busy) const LinearProgressIndicator(),
          if (error != null) ...[
            StatusBand(
              tone: BandTone.danger,
              title: error!,
              action: TextButton(
                onPressed: busy ? null : _refresh,
                child: const Text('Refresh'),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Text(projectText(package['name']), style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          const Text(
            'System-compiled estimate · advisory',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(
            'Vendor-issued quotations are reviewed separately in your conversation. Requests below still need Vendor confirmation and your final approval.',
            style: theme.textTheme.bodySmall?.copyWith(color: BuyerTheme.muted),
          ),
          const SizedBox(height: 12),
          _section(
            projectText(candidate['store_name']),
            [
              for (final line in projectRows(candidate['lines']))
                if ((double.tryParse(projectText(line['matched_quantity'])) ??
                        0) >
                    0)
                  QuotationSummaryLine(
                    line: line,
                    storeName: projectText(candidate['store_name']),
                    busy: true,
                    onChoose: () {},
                    onOpenProduct: widget.links.openProduct == null
                        ? null
                        : (listing, variant) => widget.links.openProduct!(
                            context,
                            listing,
                            variant,
                          ),
                    fulfillment: fulfillmentLine(
                      candidate,
                      projectText(line['line_id']),
                    ),
                  ),
              Text(
                'Materials ${projectMoney(candidate['materials_centavos'])} · Delivery ${deliveryFee(candidate)}',
                style: theme.textTheme.bodyMedium,
              ),
              if (!checkout && primaryOrder == null)
                _payment(primaryId, candidate['payment_methods'])
              else
                Text('Payment: ${paymentLabel(methods[primaryId])}'),
              if (primaryOrder != null)
                Text(
                  'Request sent · awaiting Vendor confirmation',
                  style: TextStyle(color: BuyerTheme.successStrong),
                ),
            ],
            subtitle:
                'Primary Project-Based Vendor · ${fulfillmentLabel(candidate['fulfillment_method'])}',
          ),
          for (final group in groups) ...[
            const Divider(height: 16),
            _section(projectText(group['store_name']), [
              ProjectSupplierFulfillment(group: group),
              const SizedBox(height: 8),
              for (final item in projectRows(group['items']))
                ProjectSupplementRow(
                  item: item,
                  onOpen: widget.links.openProduct == null
                      ? null
                      : (listing, variant) => widget.links.openProduct!(
                          context,
                          listing,
                          variant,
                        ),
                  onRemove: busy || loading ? null : () => _remove(item),
                ),
              Text('Materials ${projectMoney(group['materials_centavos'])}'),
              if (!checkout)
                _payment(
                  projectText(group['vendor_id']),
                  group['payment_methods'],
                )
              else
                Text(
                  'Payment: ${paymentLabel(methods[projectText(group['vendor_id'])])}',
                ),
              for (final issue in _issues(group['issues']))
                Text(issue, style: TextStyle(color: theme.colorScheme.error)),
              if (checkout && primaryOrder != null)
                OutlinedButton(
                  onPressed:
                      busy ||
                          loading ||
                          !acknowledged ||
                          _issues(group['issues']).isNotEmpty ||
                          !_available(
                            group['payment_methods'],
                          ).contains(methods[projectText(group['vendor_id'])])
                      ? null
                      : () => _request(group: group),
                  child: const Text('Send request to this supplier'),
                ),
            ], subtitle: 'Supplementary supplier · linked to this Work Package'),
          ],
          for (final entry in requested.entries.where(
            (entry) => entry.key != primaryId,
          ))
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Supplementary request sent'),
              subtitle: const Text('Awaiting Vendor confirmation'),
              trailing: TextButton(
                onPressed: () => widget.links.openOrder(context, entry.value),
                child: const Text('View'),
              ),
            ),
          const Divider(height: 24),
          Text(
            'Fulfillment: ${fulfillmentSummary(candidate)}',
            style: theme.textTheme.titleSmall,
          ),
          for (final line in projectRows(
            candidateFulfillment(candidate)['lines'],
          ))
            if ((double.tryParse(projectText(line['remaining_quantity'])) ??
                    0) >
                0)
              Text(
                '${projectText(line['name'])}: ${projectText(line['remaining_quantity'])} ${projectText(line['unit_code'])} still to source',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: BuyerTheme.actionPressed,
                ),
              ),
          const SizedBox(height: 8),
          Text(
            'Delivery · all suppliers: ${candidate['procurement_delivery_centavos'] == null ? 'Vendor review' : projectMoney(candidate['procurement_delivery_centavos'])}',
            style: theme.textTheme.bodyMedium,
          ),
          Text(
            candidate['procurement_total_centavos'] == null
                ? 'Materials total: ${projectMoney(candidate['procurement_materials_centavos'])}'
                : 'Arrangement total (estimate): ${projectMoney(candidate['procurement_total_centavos'])}',
            style: theme.textTheme.titleSmall,
          ),
          const Text(
            'Delivery estimates are shown per supplier. Unconfirmed delivery and processing fees are finalized before payment.',
            style: TextStyle(color: BuyerTheme.muted),
          ),
          if (primaryOrder == null) ...[
            const SizedBox(height: 12),
            TextField(
              controller: note,
              maxLength: 2000,
              decoration: const InputDecoration(
                labelText: 'Optional note to primary Vendor',
                helperText: 'Informational; no response required',
              ),
            ),
          ],
          TextField(
            controller: budgetReason,
            maxLength: 2000,
            decoration: const InputDecoration(
              labelText: 'Budget override reason, if needed',
              helperText:
                  'Required when a request exceeds the Work Package or Project budget',
            ),
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: acknowledged,
            onChanged: busy || loading
                ? null
                : (value) => setState(() => acknowledged = value == true),
            title: const Text(
              'I reviewed the items, specifications, quantities and payment choices.',
            ),
            subtitle: Text(
              primaryOrder == null
                  ? 'The primary request assigns this Work Package and expires other active quotations. Other suppliers need their own request. No payment starts here.'
                  : 'Only the supplier whose request I send will receive it. No payment starts here.',
            ),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          if (checkout && (primaryOrder == null || groups.isNotEmpty))
            TextButton(
              onPressed: busy ? null : () => setState(() => checkout = false),
              child: const Text('Edit payment choices'),
            ),
        ],
      ),
    );
  }
}
