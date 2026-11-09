import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import '../../design_system/components/archive_item_action.dart';
import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import '../orders/order_models.dart' show formatManilaDateTime;
import 'projects_repository.dart';

class ProjectArchivesScreen extends StatefulWidget {
  const ProjectArchivesScreen({
    super.key,
    required this.repository,
    this.onBack,
  });
  final ProjectsRepository repository;
  final VoidCallback? onBack;
  @override
  State<ProjectArchivesScreen> createState() => _ProjectArchivesScreenState();
}

class _ProjectArchivesScreenState extends State<ProjectArchivesScreen> {
  api.ProjectArchivePage? page;
  int tab = 0;
  bool busy = false;
  String? error;
  final keys = <String, String>{};
  String get type => tab == 0 ? 'PROJECT' : 'WORK_PACKAGE';

  @override
  void initState() {
    super.initState();
    _run(_load);
  }

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
    } catch (_) {
      if (mounted) {
        setState(
          () => error = 'Unable to update archived items. Please try again.',
        );
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _load({bool more = false}) async {
    final next = await widget.repository.archives(
      type: type,
      page: more ? page!.page + 1 : 1,
    );
    if (mounted) {
      setState(
        () => page = more
            ? next.rebuild(
                (b) => b.items.replace([...page!.items, ...next.items]),
              )
            : next,
      );
    }
  }

  Future<void> change(api.ProjectArchiveItem item, ArchiveAction action) async {
    if (busy ||
        !await confirmArchiveAction(context, name: item.name, action: action) ||
        !mounted) {
      return;
    }
    await _run(() async {
      final scope = '${item.id}:${item.lockVersion}:${action.name}';
      final key = keys.putIfAbsent(scope, projectKey);
      if (action == ArchiveAction.restore) {
        await widget.repository.restoreArchive(
          item.id,
          item.lockVersion,
          key,
          project: item.type.name == 'PROJECT',
        );
      } else {
        await widget.repository.deleteArchive(
          item.id,
          item.lockVersion,
          key,
          project: item.type.name == 'PROJECT',
        );
      }
      keys.remove(scope);
      await _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              action == ArchiveAction.restore
                  ? '${item.name} was restored.'
                  : '${item.name} was permanently deleted.',
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).colorScheme.surface,
    appBar: buyerAppBar(context, 'Archived Items', onBack: widget.onBack),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SegmentedTabs(
            labels: const ['Archived Projects', 'Archived Work Packages'],
            selected: tab,
            onChanged: (value) {
              if (busy || value == tab) return;
              setState(() {
                tab = value;
                page = null;
              });
              _run(_load);
            },
          ),
        ),
        if (busy) const BuyerLoadingProgress(),
        if (error != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: StateMessage(
              kind: StateKind.error,
              title: 'Archived items could not update',
              message: error!,
              actionLabel: 'Try again',
              onAction: busy ? null : () => _run(_load),
            ),
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _run(_load),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              children: [
                const Text(
                  'Archived items can be restored for 30 days. Required transaction and audit records are retained after permanent deletion.',
                  style: TextStyle(color: BuyerTheme.muted),
                ),
                if (page != null && page!.items.isEmpty)
                  const StateMessage(
                    kind: StateKind.empty,
                    title: 'No archived items',
                    message: 'Items you archive appear here for 30 days.',
                  ),
                for (final item in page?.items ?? <api.ProjectArchiveItem>[])
                  Card(
                    margin: const EdgeInsets.only(top: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (item.projectName != null) Text(item.projectName!),
                          const SizedBox(height: 8),
                          const StatusBand(
                            tone: BandTone.warning,
                            title: 'Archived',
                          ),
                          SpecificationRow(
                            'Original budget',
                            projectMoney(item.budgetCentavos),
                          ),
                          SpecificationRow(
                            'Date archived',
                            formatManilaDateTime(item.archivedAt),
                          ),
                          SpecificationRow(
                            'Scheduled deletion',
                            formatManilaDateTime(item.deleteAfter),
                          ),
                          Text(
                            '${item.remainingDays} days remaining before permanent deletion',
                          ),
                          if (item.parentArchived)
                            const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                'Restore the parent project before restoring this work package.',
                              ),
                            ),
                          if (!item.canRestore && !item.parentArchived)
                            const Text('The restoration period has ended.'),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              FilledButton.icon(
                                onPressed: busy || !item.canRestore
                                    ? null
                                    : () => change(item, ArchiveAction.restore),
                                icon: const Icon(
                                  LucideIcons.rotateCcw,
                                  size: 18,
                                ),
                                label: const Text('Restore'),
                              ),
                              OutlinedButton.icon(
                                onPressed: busy || !item.canDelete
                                    ? null
                                    : () => change(
                                        item,
                                        ArchiveAction.deletePermanently,
                                      ),
                                icon: const Icon(LucideIcons.trash2, size: 18),
                                label: const Text('Delete Permanently'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                if (page?.hasMore == true)
                  OutlinedButton(
                    onPressed: busy
                        ? null
                        : () => _run(() => _load(more: true)),
                    child: const Text('More archived items'),
                  ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
