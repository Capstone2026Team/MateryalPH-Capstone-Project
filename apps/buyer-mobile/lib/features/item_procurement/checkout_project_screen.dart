import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import 'package:flutter/material.dart';

import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/components/procurement_components.dart';
import '../map_discovery/discovery_models.dart';
import '../projects/projects_repository.dart';

@immutable
class CheckoutProjectLink {
  const CheckoutProjectLink({
    required this.projectName,
    required this.packageName,
    required this.packageId,
    required this.lockVersion,
  });
  final String projectName;
  final String packageName;
  final String packageId;
  final int lockVersion;
}

/// Selects existing owned records through the paginated Project API.
class CheckoutProjectScreen extends StatefulWidget {
  const CheckoutProjectScreen({
    super.key,
    required this.repository,
    this.selected,
  });
  final ProjectsRepository repository;
  final CheckoutProjectLink? selected;

  @override
  State<CheckoutProjectScreen> createState() => _CheckoutProjectScreenState();
}

typedef _Choice = ({
  String id,
  String name,
  int budgetCentavos,
  int lockVersion,
  api.ProjectSummary? project,
});

class _CheckoutProjectScreenState extends State<CheckoutProjectScreen> {
  final List<_Choice> _items = [];
  api.ProjectSummary? _project;
  bool _loading = true;
  bool _hasMore = false;
  int _page = 0;
  DiscoveryFailure? _failure;

  @override
  void initState() {
    super.initState();
    _load(reset: true);
  }

  Future<void> _load({bool reset = false}) async {
    setState(() {
      _loading = true;
      _failure = null;
      if (reset) {
        _items.clear();
        _page = 0;
      }
    });
    try {
      final page = reset ? 1 : _page + 1;
      final choices = <_Choice>[];
      final bool hasMore;
      if (_project == null) {
        final data = await widget.repository.list(page: page);
        hasMore = data.hasMore;
        choices.addAll(
          data.items
              .where((item) => item.status.name == 'ACTIVE')
              .map(
                (item) => (
                  id: item.id,
                  name: item.name,
                  budgetCentavos: item.budgetCentavos,
                  lockVersion: item.lockVersion,
                  project: item,
                ),
              ),
        );
      } else {
        final data = (await widget.repository.project(
          _project!.id,
          page: page,
        )).packages;
        hasMore = data.hasMore;
        choices.addAll(
          data.items
              .where(
                (item) =>
                    !['COMPLETED', 'CANCELLED'].contains(item.status.name) &&
                    item.currentVersionId != null,
              )
              .map(
                (item) => (
                  id: item.id,
                  name: item.name,
                  budgetCentavos: item.budgetCentavos,
                  lockVersion: item.lockVersion,
                  project: null,
                ),
              ),
        );
      }
      if (!mounted) return;
      setState(() {
        if (reset) _items.clear();
        _items.addAll(choices);
        _page = page;
        _hasMore = hasMore;
      });
    } on DiscoveryFailure catch (error) {
      if (mounted) setState(() => _failure = error);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: buyerAppBar(context, 'Project Procurement'),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const StatusBand(
            tone: BandTone.info,
            title: 'Link to your Project',
            message:
                'Choose a Project and Work Package to track this Item-Based purchase in its budget. Delivery stays as selected in checkout. Missing materials are resolved separately after acceptance.',
          ),
          if (widget.selected != null)
            TextButton(
              onPressed: () => Navigator.pop(context, const <String, Object?>{
                'remove': true,
              }),
              child: const Text('Remove Project link'),
            ),
          if (_project != null) ...[
            const SizedBox(height: 12),
            Text(
              projectText(_project!.name),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(
              onPressed: _loading
                  ? null
                  : () {
                      _project = null;
                      _load(reset: true);
                    },
              child: const Text('Choose another Project'),
            ),
          ],
          if (_failure != null)
            StateMessage(
              kind: _failure!.kind == DiscoveryFailureKind.offline
                  ? StateKind.offline
                  : StateKind.error,
              title: 'Projects could not load',
              message: _failure!.message,
              actionLabel: 'Retry',
              onAction: () => _load(reset: _page == 0),
            ),
          if (!_loading && _failure == null && _items.isEmpty)
            StateMessage(
              kind: StateKind.empty,
              title: _project == null
                  ? 'No active Projects'
                  : 'No open Work Packages',
              message:
                  'Create a Project and Work Package from Projects, then return to link this purchase.',
            ),
          for (final item in _items)
            ListTile(
              enabled: !_loading,
              contentPadding: EdgeInsets.zero,
              title: Text(projectText(item.name)),
              subtitle: Text(
                _project == null
                    ? 'Active Project'
                    : 'Work Package budget: ${projectMoney(item.budgetCentavos)}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                if (_project == null) {
                  _project = item.project;
                  _items.clear();
                  _page = 0;
                  _load(reset: true);
                } else {
                  Navigator.pop(
                    context,
                    CheckoutProjectLink(
                      projectName: projectText(_project!.name),
                      packageName: projectText(item.name),
                      packageId: projectText(item.id),
                      lockVersion: projectInt(item.lockVersion),
                    ),
                  );
                }
              },
            ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
          if (_hasMore && !_loading && _failure == null)
            OutlinedButton(onPressed: _load, child: const Text('Load more')),
        ],
      ),
    ),
  );
}
