import 'project_supplier_view.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
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
  final api.WorkPackageView package;
  final api.ProjectCandidate candidate;
  final Map<String, String> selections;
  final ProjectSourcingLinks links;

  @override
  State<ProjectSelectionCheckoutScreen> createState() =>
      _ProjectSelectionCheckoutScreenState();
}

class _ProjectSelectionCheckoutScreenState
    extends State<ProjectSelectionCheckoutScreen> {
  late api.WorkPackageView package = widget.package;
  late api.ProjectCandidate candidate = widget.candidate;
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

  String get primaryId => projectText(candidate.vendorId);
  List<api.ProjectDraftVendorGroup> get groups =>
      candidate.draftGroups?.toList() ?? [];

  List<String> _available(Iterable<api.ProjectPaymentMethod>? rows) => [
    for (final row in rows ?? <api.ProjectPaymentMethod>[])
      if (row.available) projectText(row.method),
  ];
  List<String> _issues(Iterable<String>? value) => value?.toList() ?? [];

  bool get canReview =>
      previewReady &&
      !loading &&
      !busy &&
      acknowledged &&
      (primaryOrder != null ||
          _available(candidate.paymentMethods).contains(methods[primaryId])) &&
      groups.every(
        (group) =>
            _issues(group.issues).isEmpty &&
            _available(
              group.paymentMethods,
            ).contains(methods[projectText(group.vendorId)]),
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
      final current = await widget.repository.package(projectText(package.id));
      final priced = await widget.repository.selectionPreview(
        projectText(package.id),
        projectText(candidate.id),
        widget.selections,
        fulfillmentMethod: projectText(candidate.fulfillmentMethod),
      );
      if (!mounted) return;
      setState(() {
        package = current;
        candidate = priced;
        previewReady = true;
        primaryOrder = priced.primaryOrderId ?? primaryOrder;
        if (primaryOrder != null) {
          methods[primaryId] = projectText(priced.paymentMethod);
          requested[primaryId] = primaryOrder!;
        }
        if (primaryOrder == null &&
            !_available(priced.paymentMethods).contains(methods[primaryId])) {
          methods.remove(primaryId);
        }
        for (final group in groups) {
          final id = projectText(group.vendorId);
          if (!_available(group.paymentMethods).contains(methods[id])) {
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

  Future<void> _remove(api.ProjectSeparatePurchase item) async {
    if (busy || loading) return;
    setState(() {
      busy = true;
      acknowledged = false;
    });
    try {
      await widget.repository.removeDraftItem(
        packageId: projectText(package.id),
        candidateId: projectText(candidate.id),
        lineId: projectText(item.lineId),
        variantId: projectText(item.variantId),
        lockVersion: projectInt(package.lockVersion),
      );
      await _refresh();
    } on DiscoveryFailure catch (e) {
      if (mounted) setState(() => error = e.message);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _request({api.ProjectDraftVendorGroup? group}) async {
    if (loading || busy || !acknowledged) return;
    final id = group == null ? primaryId : projectText(group.vendorId);
    final method = methods[id];
    if (method == null) return;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final body = <String, Object?>{
        'lock_version': projectInt(package.lockVersion),
        'payment_method': method,
        if (budgetReason.text.trim().isNotEmpty)
          'budget_override_reason': budgetReason.text.trim(),
      };
      // A changed body gets a new key; a failed request retries its exact key.
      final action =
          '$id:$method:${package.lockVersion}:${note.text.trim()}:${budgetReason.text.trim()}:${group?.draftFingerprint ?? ''}';
      final key = requestKeys.putIfAbsent(action, projectKey);
      final order = group == null
          ? await widget.repository.candidate(
              projectText(package.id),
              {
                ...body,
                'candidate_id': candidate.id,
                'selections': specificationSelections(widget.selections),
                'fulfillment_method': candidate.fulfillmentMethod,
                if (note.text.trim().isNotEmpty) 'note': note.text.trim(),
              },
              key,
              select: true,
            )
          : await widget.repository.requestDraftSupplier(
              packageId: projectText(package.id),
              candidateId: projectText(candidate.id),
              vendorId: id,
              input: {...body, 'draft_fingerprint': group.draftFingerprint},
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

  Widget _payment(String vendor, Iterable<api.ProjectPaymentMethod>? options) =>
      QuotationPaymentChoices(
        fulfillmentMethod: projectText(candidate.fulfillmentMethod),
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
          Text(projectText(package.name), style: theme.textTheme.titleLarge),
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
            projectText(candidate.storeName),
            [
              for (final line in projectRows(candidate.lines))
                if ((double.tryParse(projectText(line['matched_quantity'])) ??
                        0) >
                    0)
                  QuotationSummaryLine(
                    line: line,
                    storeName: projectText(candidate.storeName),
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
                'Materials ${projectMoney(candidate.materialsCentavos)} · Delivery ${deliveryFee(candidate)}',
                style: theme.textTheme.bodyMedium,
              ),
              if (!checkout && primaryOrder == null)
                _payment(primaryId, candidate.paymentMethods)
              else
                Text('Payment: ${paymentLabel(methods[primaryId])}'),
              if (primaryOrder != null)
                Text(
                  'Request sent · awaiting Vendor confirmation',
                  style: TextStyle(color: BuyerTheme.successStrong),
                ),
            ],
            subtitle:
                'Primary Project-Based Vendor · ${fulfillmentLabel(candidate.fulfillmentMethod)}',
          ),
          for (final group in groups) ...[
            const Divider(height: 16),
            _section(projectText(group.storeName), [
              ProjectSupplierFulfillment(
                group: ProjectSupplierView.draft(group),
              ),
              const SizedBox(height: 8),
              for (final item in group.items.toList())
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
              Text('Materials ${projectMoney(group.materialsCentavos)}'),
              if (!checkout)
                _payment(projectText(group.vendorId), group.paymentMethods)
              else
                Text(
                  'Payment: ${paymentLabel(methods[projectText(group.vendorId)])}',
                ),
              for (final issue in _issues(group.issues))
                Text(issue, style: TextStyle(color: theme.colorScheme.error)),
              if (checkout && primaryOrder != null)
                OutlinedButton(
                  onPressed:
                      busy ||
                          loading ||
                          !acknowledged ||
                          _issues(group.issues).isNotEmpty ||
                          !_available(
                            group.paymentMethods,
                          ).contains(methods[projectText(group.vendorId)])
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
          for (final remainingLine in candidate.fulfillment.lines)
            if ((double.tryParse(
                      projectText(remainingLine.remainingQuantity),
                    ) ??
                    0) >
                0)
              Text(
                '${projectText(remainingLine.name)}: ${projectText(remainingLine.remainingQuantity)} ${projectText(remainingLine.unitCode)} still to source',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: BuyerTheme.actionPressed,
                ),
              ),
          const SizedBox(height: 8),
          Text(
            'Delivery · all suppliers: ${candidate.procurementDeliveryCentavos == null ? 'Vendor review' : projectMoney(candidate.procurementDeliveryCentavos)}',
            style: theme.textTheme.bodyMedium,
          ),
          Text(
            candidate.procurementTotalCentavos == null
                ? 'Materials total: ${projectMoney(candidate.procurementMaterialsCentavos)}'
                : 'Arrangement total (estimate): ${projectMoney(candidate.procurementTotalCentavos)}',
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
