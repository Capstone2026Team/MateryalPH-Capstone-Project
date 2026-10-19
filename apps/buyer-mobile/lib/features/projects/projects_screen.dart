import '../notifications/notification_scope.dart';
import '../reporting/document_export_dialog.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as export_api;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/buyer_overlays.dart';
import '../../design_system/components/work_package_attachment.dart';
import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/components/form_dialog.dart';
import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';
import 'project_editor.dart';
import 'project_ranking_preferences_screen.dart';
import '../map_discovery/discovery_models.dart';
import '../map_discovery/discovery_repository.dart';
import '../map_discovery/device_location.dart';
import '../map_discovery/select_location_screen.dart';
import '../map_discovery/supplier_map.dart';
import 'projects_repository.dart';
import 'vendor_selection_screen.dart';
import 'project_selection_checkout_screen.dart';
import 'project_arrangement_screen.dart';
import 'work_package_editor.dart';
import 'work_package_material_widgets.dart' show materialQuantity;
import 'work_package_overview_widgets.dart';

typedef ProjectOpen = void Function(BuildContext context, String id);

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({
    super.key,
    required this.repository,
    required this.discovery,
    required this.deviceLocation,
    required this.mapBuilder,
    required this.openConversation,
    required this.openOrder,
    required this.openStore,
    this.openCart,
    this.onCartChanged,
    this.openProduct,
    this.active = true,
    this.initialProjectId,
  });
  final bool active;
  final String? initialProjectId;
  final ProjectsRepository repository;
  final DiscoveryRepository discovery;
  final DeviceLocationService deviceLocation;
  final SupplierMapBuilder mapBuilder;
  final ProjectOpen openConversation, openOrder, openStore;

  /// Opens the Item-Based cart; missing materials are bought there.
  final void Function(BuildContext context)? openCart;

  /// Refreshes the shared cart after a separate purchase is added.
  final VoidCallback? onCartChanged;

  /// Product Details for a quoted or recommended listing variant.
  final void Function(
    BuildContext context,
    String listingId,
    String? variantId,
  )?
  openProduct;
  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  ProjectData? _page, _project, _package;
  String? _error;
  bool _busy = false;
  int _sequence = 0;
  int _projectSection = 0;
  final Map<String, String> _keys = {};
  Timer? _refresh;
  ProjectsRepository get repo => widget.repository;
  String get id => projectText(_package?['id']);
  int get lock => projectInt(_package?['lock_version']);
  ProjectData get content =>
      projectObject(projectObject(_package?['version'])['content']);
  @override
  void initState() {
    super.initState();
    unawaited(
      widget.initialProjectId == null
          ? _run(_reload)
          : _openProject(widget.initialProjectId!),
    );
    _refresh = Timer.periodic(const Duration(seconds: 45), (_) {
      if (mounted &&
          widget.active &&
          !_busy &&
          ModalRoute.of(context)?.isCurrent == true &&
          WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
        unawaited(_run(_reload));
      }
    });
  }

  @override
  void dispose() {
    _refresh?.cancel();
    _sequence++;
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } on DiscoveryFailure catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Unable to complete this request. Please retry.',
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _reload() async {
    final token = ++_sequence;
    final result = _package != null
        ? await repo.package(id)
        : _project != null
        ? await repo.project(projectText(_project!['id']))
        : await repo.list();
    if (!mounted || token != _sequence) return;
    setState(() {
      if (_package != null) {
        _package = result;
      } else if (_project != null) {
        _project = result;
      } else {
        _page = result;
      }
    });
  }

  String _key(String action) => _keys.putIfAbsent(action, projectKey);
  Future<void> _openProject(String id) => _run(() async {
    final token = ++_sequence;
    final p = await repo.project(id);
    if (mounted && token == _sequence) {
      setState(() {
        _project = p;
        _package = null;
        _projectSection = 0;
      });
    }
  });
  Future<void> _openPackage(String id) => _run(() async {
    final token = ++_sequence;
    final p = await repo.package(id);
    if (mounted && token == _sequence) {
      setState(() {
        _package = p;
        _keys.clear();
      });
    }
  });
  Future<void> _back() async {
    _sequence++;
    setState(() {
      if (_package != null) {
        _package = null;
      } else {
        _project = null;
      }
      _keys.clear();
    });
    await _run(_reload);
  }

  Future<DiscoveryOrigin?> _location() async {
    final locations = await widget.discovery.locations();
    if (!mounted) return null;
    return Navigator.of(context).push<DiscoveryOrigin>(
      MaterialPageRoute(
        builder: (_) => SelectLocationScreen(
          repository: widget.discovery,
          deviceLocation: widget.deviceLocation,
          savedLocations: locations,
          mapsAvailable: kMapsClientConfigured,
          requireSave: true,
        ),
      ),
    );
  }

  Future<void> _createProject({bool editing = false}) async {
    final result = await Navigator.of(context).push<ProjectData>(
      MaterialPageRoute(
        builder: (_) => ProjectEditor(
          repository: repo,
          chooseLocation: _location,
          project: editing ? _project : null,
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _project = result;
        _projectSection = 0;
      });
    }
  }

  Future<void> _editPackage() async {
    final result = await Navigator.of(context).push<ProjectData>(
      MaterialPageRoute(
        builder: (_) => WorkPackageEditor(
          repository: repo,
          project: _project!,
          package: _package,
          chooseLocation: _location,
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _package = result;
        _keys.clear();
      });
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

  Future<void> _reactivatePackage() async {
    if (!await _confirm(
          'Reactivate this Work Package?',
          'It returns to Active with its current requirements, and its budget counts against the Project again. Compare vendors again for fresh estimates.',
        ) ||
        !mounted) {
      return;
    }
    final action = 'reactivate-$lock';
    await _run(() async {
      _package = await repo.reactivate(id, lock, _key(action));
      _keys.remove(action);
    });
  }

  Future<void> _deletePackage() async {
    final name = projectText(_package?['name']);
    final plainDraft =
        _package?['status'] == 'DRAFT' &&
        projectObject(_package?['version'])['locked_at'] == null;
    final confirmed =
        await showBuyerFormDialog<bool>(
          context: context,
          builder: (context) => BuyerDialog(
            title: Text('Delete $name?'),
            content: Text(
              plainDraft
                  ? 'This Draft and its budget allocation are removed. You cannot undo this.'
                  : 'It leaves your Project and its budget returns to the unallocated Project budget. Active quotation requests close and current estimates are invalidated. Saved originals and quotation history stay on record. You cannot undo this.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Keep it'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed || !mounted) return;
    var deleted = false;
    await _run(() async {
      await repo.delete(id, lock);
      deleted = true;
      _package = null;
      await _reload();
    });
    if (deleted && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$name was deleted.')));
    }
  }

  /// Vendor selection: map, sortable results and quotations (opened from the
  /// package; the comparison no longer lives inside the package page).
  Future<void> _findVendors([ProjectData? initial]) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => VendorSelectionScreen(
          repository: repo,
          package: _package!,
          mapBuilder: widget.mapBuilder,
          initialEstimates: initial,
          links: ProjectSourcingLinks(
            openConversation: widget.openConversation,
            openOrder: widget.openOrder,
            openStore: widget.openStore,
            openCart: widget.openCart,
            onCartChanged: widget.onCartChanged,
            openProduct: widget.openProduct,
          ),
        ),
      ),
    );
    if (mounted && _package != null) await _run(_reload);
  }

  Future<void> _reviewProcurement() => _run(() async {
    if (_package!['selected_arrangement_id'] != null) {
      await Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => ProjectArrangementScreen(
            repository: repo,
            package: _package!,
            option: {'id': _package!['selected_arrangement_id'], 'version': 1},
            links: ProjectSourcingLinks(
              openConversation: widget.openConversation,
              openOrder: widget.openOrder,
              openStore: widget.openStore,
              openProduct: widget.openProduct,
            ),
          ),
        ),
      );
      if (mounted) await _reload();
      return;
    }
    final candidate = await repo.selectionPreview(
      id,
      projectText(_package!['procurement_candidate_id']),
      const {},
    );
    if (!mounted) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => ProjectSelectionCheckoutScreen(
          repository: repo,
          package: _package!,
          candidate: candidate,
          selections: {
            for (final e in projectObject(
              candidate['specification_selections'],
            ).entries)
              e.key: projectText(e.value),
          },
          links: ProjectSourcingLinks(
            openConversation: widget.openConversation,
            openOrder: widget.openOrder,
            openStore: widget.openStore,
            openProduct: widget.openProduct,
          ),
        ),
      ),
    );
    if (mounted) await _reload();
  });

  Future<void> _preferences() => Navigator.of(context).push<void>(
    MaterialPageRoute(
      builder: (_) => ProjectRankingPreferencesScreen(repository: repo),
    ),
  );

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: _project == null,
    onPopInvokedWithResult: (didPop, result) {
      if (!didPop && !_busy) unawaited(_back());
    },
    child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _project == null
          ? buyerTabAppBar(
              context,
              'Projects',
              actions: [_rankingPreferencesAction()],
            )
          : buyerAppBar(
              context,
              projectText(_package?['name'] ?? _project?['name'] ?? 'Projects'),
              // Inside a Project the back control steps up the Project hierarchy, not the route stack.
              onBack: _project == null
                  ? null
                  : () {
                      if (!_busy) _back();
                    },
              actions: [
                if (_project != null && NotificationScope.of(context) != null)
                  BuyerDocumentExportButton(
                    repository: NotificationScope.of(context)!,
                    resourceId: projectText(_project?['id']),
                    types: [
                      export_api.DocumentExportInputTypeEnum.PROJECT_SUMMARY,
                      export_api.DocumentExportInputTypeEnum.BUDGET_REPORT,
                    ],
                  ),
                _rankingPreferencesAction(),
              ],
            ),
      body: Column(
        children: [
          if (_busy) const LinearProgressIndicator(),
          if (_error != null && (_page != null || _project != null))
            MaterialBanner(
              content: Text(_error!),
              actions: [
                TextButton(
                  onPressed: _busy ? null : () => _run(_reload),
                  child: const Text('Retry'),
                ),
              ],
            ),
          Expanded(
            child: _package != null
                ? _packageBody()
                : _project != null
                ? _projectBody()
                : _index(),
          ),
        ],
      ),
    ),
  );
  Widget _rankingPreferencesAction() => BuyerHeaderIconButton(
    onPressed: _busy ? null : _preferences,
    icon: LucideIcons.slidersHorizontal,
    tooltip: 'Project Ranking Preferences',
  );

  Widget _index() => _page == null
      ? (_busy
            ? ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  SkeletonBox(height: 120),
                  SizedBox(height: 12),
                  SkeletonBox(height: 120),
                ],
              )
            : SingleChildScrollView(
                child: StateMessage(
                  kind: StateKind.error,
                  title: 'Projects could not load',
                  message: _error ?? 'Please retry.',
                  actionLabel: 'Retry',
                  onAction: () => _run(_reload),
                ),
              ))
      : ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Plan materials, compare Vendors and track your budget.',
              style: const TextStyle(color: BuyerTheme.muted),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.icon(
                onPressed: _busy ? null : _createProject,
                icon: const Icon(Icons.add),
                label: const Text('Create Project'),
              ),
            ),
            if (_page != null && projectRows(_page!['items']).isEmpty)
              const StateMessage(
                kind: StateKind.empty,
                title: 'No Projects yet',
                message:
                    'Your Projects will appear here. Start with a site, timeline and overall budget.',
              ),
            ...projectRows(_page?['items']).map(
              (p) => Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Card(
                  color: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: BuyerTheme.border),
                  ),
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: _busy
                        ? null
                        : () => _openProject(projectText(p['id'])),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.folder_outlined,
                                color: BuyerTheme.action,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  projectText(p['name']),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            projectStatus(p['status']),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: BuyerTheme.muted,
                            ),
                          ),
                          if (p['starts_on'] != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '${p['starts_on']} – ${p['ends_on']}',
                              ),
                            ),
                          const Divider(height: 24),
                          SpecificationRow(
                            'Budget',
                            projectMoney(p['budget_centavos']),
                          ),
                          SpecificationRow(
                            'Committed',
                            projectMoney(
                              projectObject(p['budget'])['committed_centavos'],
                            ),
                          ),
                          SpecificationRow(
                            'Remaining',
                            projectMoney(
                              projectObject(p['budget'])['remaining_centavos'],
                            ),
                          ),
                          if (projectObject(p['budget'])['warning'] == true)
                            const StatusBand(
                              tone: BandTone.warning,
                              title: 'Budget needs attention',
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (_page?['has_more'] == true)
              OutlinedButton(
                onPressed: _busy
                    ? null
                    : () => _run(() async {
                        final next = await repo.list(
                          page: projectInt(_page!['page']) + 1,
                        );
                        if (mounted) {
                          setState(
                            () => _page = {
                              ...next,
                              'items': [
                                ...projectRows(_page!['items']),
                                ...projectRows(next['items']),
                              ],
                            },
                          );
                        }
                      }),
                child: const Text('More Projects'),
              ),
          ],
        );
  Widget _projectBody() {
    final p = _project!, packages = projectObject(p['packages']);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SegmentedTabs(
                labels: const ['Overview', 'Work Packages', 'Sites'],
                selected: _projectSection,
                onChanged: (value) => setState(() => _projectSection = value),
              ),
            ),
            Expanded(
              child: ListView(
                key: ValueKey('project-section-$_projectSection'),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                children: [
                  if (_projectSection == 0) ...[
                    StatusBand(
                      tone: p['status'] == 'ACTIVE'
                          ? BandTone.info
                          : BandTone.warning,
                      title: projectStatus(p['status']),
                      message: p['status'] == 'ARCHIVED'
                          ? 'This Project is archived. Your planning and procurement history remains available.'
                          : p['status'] == 'COMPLETED'
                          ? 'This Project is complete. Your procurement history remains available.'
                          : 'Organize materials into Work Packages, compare Vendors and track your spending.',
                    ),
                    const SectionHeading('Budget overview'),
                    ProjectBudgetCard(
                      budget: projectObject(p['budget']),
                      action: NotificationScope.of(context) == null
                          ? null
                          : BuyerDocumentExportButton(
                              repository: NotificationScope.of(context)!,
                              resourceId: projectText(p['id']),
                              types: [
                                export_api
                                    .DocumentExportInputTypeEnum
                                    .BUDGET_REPORT,
                              ],
                            ),
                    ),
                    const SectionHeading('Schedule'),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: BuyerTheme.border),
                      ),
                      child: Column(
                        children: [
                          SpecificationRow(
                            'Start date',
                            projectText(p['starts_on']),
                          ),
                          SpecificationRow(
                            'End date',
                            projectText(p['ends_on']),
                          ),
                        ],
                      ),
                    ),
                    if (p['status'] != 'ARCHIVED') ...[
                      const SectionHeading('Manage Project'),
                      OutlinedButton.icon(
                        onPressed: _busy || p['status'] != 'ACTIVE'
                            ? null
                            : () => _createProject(editing: true),
                        icon: const Icon(LucideIcons.pencil, size: 18),
                        label: const Text('Edit planning / add site'),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _busy || p['status'] == 'ARCHIVED'
                                  ? null
                                  : () => _run(() async {
                                      _project = await repo
                                          .update(projectText(p['id']), {
                                            'lock_version': p['lock_version'],
                                            'status': 'ARCHIVED',
                                          }, _key('archive'));
                                    }),
                              icon: const Icon(LucideIcons.archive, size: 18),
                              label: const Text('Archive'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _busy || p['status'] != 'ACTIVE'
                                  ? null
                                  : () => _run(() async {
                                      _project = await repo
                                          .update(projectText(p['id']), {
                                            'lock_version': p['lock_version'],
                                            'status': 'COMPLETED',
                                          }, _key('complete'));
                                    }),
                              icon: const Icon(
                                LucideIcons.circleCheck,
                                size: 18,
                              ),
                              label: const Text('Complete'),
                            ),
                          ),
                        ],
                      ),
                      if (p['status'] == 'ACTIVE' &&
                          projectRows(packages['items']).isEmpty) ...[
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.error,
                          ),
                          onPressed: _busy
                              ? null
                              : () async {
                                  if (await _confirm(
                                    'Delete empty Project?',
                                    'This permanently removes this planning draft. Projects with procurement history are retained.',
                                  )) {
                                    await _run(() async {
                                      await repo.delete(
                                        projectText(p['id']),
                                        projectInt(p['lock_version']),
                                        project: true,
                                      );
                                      _project = null;
                                      await _reload();
                                    });
                                  }
                                },
                          icon: const Icon(LucideIcons.trash2, size: 18),
                          label: const Text('Delete'),
                        ),
                      ],
                    ],
                  ],
                  if (_projectSection == 1) ...[
                    AllocationSummary(budget: projectObject(p['budget'])),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _busy || p['status'] != 'ACTIVE'
                          ? null
                          : () => _editPackage(),
                      icon: const Icon(LucideIcons.plus),
                      label: const Text('New Work Package'),
                    ),
                    SectionHeading(
                      'Work Packages',
                      trailing: Text(
                        '${projectRows(packages['items']).length}${packages['has_more'] == true ? '+' : ''}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: BuyerTheme.muted,
                        ),
                      ),
                    ),
                    if (projectRows(packages['items']).isEmpty)
                      const WorkPackagesEmptyState(),
                    ...projectRows(packages['items']).map(
                      (w) => WorkPackageCard(
                        package: w,
                        onTap: () => _openPackage(projectText(w['id'])),
                      ),
                    ),
                    if (packages['has_more'] == true)
                      OutlinedButton(
                        onPressed: _busy
                            ? null
                            : () => _run(() async {
                                final next = await repo.project(
                                  projectText(p['id']),
                                  page: projectInt(packages['page']) + 1,
                                );
                                final more = projectObject(next['packages']);
                                if (mounted) {
                                  setState(
                                    () => _project = {
                                      ...next,
                                      'packages': {
                                        ...more,
                                        'items': [
                                          ...projectRows(packages['items']),
                                          ...projectRows(more['items']),
                                        ],
                                      },
                                    },
                                  );
                                }
                              }),
                        child: const Text('More Work Packages'),
                      ),
                  ],
                  if (_projectSection == 2) ...[
                    const SectionHeading('Project sites'),
                    const Text(
                      'Choose a saved site when creating a Work Package. Vendor discovery uses that site.',
                    ),
                    ...projectRows(p['sites']).map(
                      (site) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.location_on_outlined),
                              title: Text(projectText(site['name'])),
                              subtitle: Text(
                                projectText(
                                  projectObject(
                                    site['point'],
                                  )['formatted_address'],
                                ),
                              ),
                            ),
                            const Divider(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _packageBody() {
    final w = _package!,
        draft = w['status'] == 'DRAFT',
        projectActive = w['project_status'] == 'ACTIVE',
        editable = draft && projectActive,
        cancelled = w['status'] == 'CANCELLED',
        canDelete = w['can_delete'] == true,
        manage = projectActive && w['has_order'] != true,
        canEdit =
            manage &&
            [
              'DRAFT',
              'ACTIVE',
              'QUOTATION_INQUIRY',
              'CANCELLED',
            ].contains(w['status']);
    final missingMaterials =
        !cancelled &&
            !draft &&
            w['has_order'] == true &&
            w['selected_arrangement_id'] == null
        ? projectRows(w['missing_lines'])
        : <ProjectData>[];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [WorkPackageStatusChip(projectText(w['status']))],
        ),
        const SizedBox(height: 12),
        ProjectBudgetCard(budget: projectObject(w['budget'])),
        const SizedBox(height: 16),
        if (editable) ...[
          FilledButton.icon(
            onPressed: _busy
                ? null
                : () async {
                    if (await _confirm(
                      'Activate this Work Package?',
                      'Estimates and Vendor comparison start now. You can still edit this Work Package until an order exists.',
                    )) {
                      ProjectData? compiled;
                      await _run(() async {
                        _package = await repo.activate(
                          id,
                          lock,
                          _key('activate'),
                        );
                        _keys.remove('activate');
                        compiled = await repo.compile(id, lock);
                      });
                      if (compiled != null && mounted) {
                        await _findVendors(compiled);
                      }
                    }
                  },
            icon: const Icon(LucideIcons.scanSearch, size: 18),
            label: const Text('Activate and compare'),
          ),
          const SizedBox(height: 12),
        ],
        if (w['order_id'] != null && w['selected_arrangement_id'] == null) ...[
          FilledButton.icon(
            onPressed: () =>
                widget.openOrder(context, projectText(w['order_id'])),
            icon: const Icon(LucideIcons.receipt, size: 18),
            label: const Text('Open order'),
          ),
          const SizedBox(height: 12),
        ],
        if (w['selected_arrangement_id'] != null) ...[
          FilledButton.icon(
            onPressed: _busy ? null : _reviewProcurement,
            icon: const Icon(LucideIcons.clipboardList, size: 18),
            label: const Text('Review procurement arrangement'),
          ),
          const SizedBox(height: 12),
          for (final order in projectRows(w['vendor_orders']))
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(projectText(order['reference'])),
              subtitle: Text(projectStatus(order['order_state'])),
              trailing: const Icon(LucideIcons.chevronRight, size: 18),
              onTap: () => widget.openOrder(context, projectText(order['id'])),
            ),
        ],
        if (projectActive &&
            w['procurement_candidate_id'] != null &&
            w['selected_arrangement_id'] == null) ...[
          OutlinedButton.icon(
            onPressed: _busy ? null : _reviewProcurement,
            icon: const Icon(LucideIcons.clipboardList, size: 18),
            label: const Text('Review quotation checkout'),
          ),
          const SizedBox(height: 12),
        ],
        if (!draft && !cancelled && w['selected_arrangement_id'] == null) ...[
          FilledButton.icon(
            onPressed: _busy ? null : () => _findVendors(),
            icon: const Icon(LucideIcons.search, size: 18),
            label: const Text('Find vendors'),
          ),
          const SizedBox(height: 12),
        ],
        if (manage && cancelled) ...[
          FilledButton.icon(
            onPressed: _busy ? null : _reactivatePackage,
            icon: const Icon(LucideIcons.rotateCcw, size: 18),
            label: const Text('Reactivate'),
          ),
          const SizedBox(height: 12),
        ],
        // Delete stays available until an order, tagged purchase or selected Vendor exists; the server enforces the same rule.
        if (canEdit || canDelete)
          Row(
            children: [
              if (canEdit)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _busy ? null : _editPackage,
                    icon: const Icon(LucideIcons.pencil, size: 18),
                    label: const Text('Edit'),
                  ),
                ),
              if (canEdit && canDelete) const SizedBox(width: 12),
              if (canDelete)
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                    ),
                    onPressed: _busy ? null : _deletePackage,
                    icon: const Icon(LucideIcons.trash2, size: 18),
                    label: const Text('Delete'),
                  ),
                ),
            ],
          ),
        const SectionHeading('Requirements'),
        WorkPackageAttachment(
          original: content,
          title: 'Work Package details',
          showPaymentMethod: false,
        ),
        const SizedBox(height: 8),
        if (missingMaterials.isNotEmpty)
          const SectionHeading('Missing materials'),
        ...missingMaterials.map(
          (m) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: BuyerTheme.border),
            ),
            child: ListTile(
              leading: Icon(
                m['waived_by_user_id'] != null
                    ? LucideIcons.circleCheck
                    : LucideIcons.triangleAlert,
                color: m['waived_by_user_id'] != null
                    ? BuyerTheme.successStrong
                    : BuyerTheme.actionPressed,
              ),
              title: Text(
                'Missing: ${m['name']} · ${materialQuantity(m['quantity'])}',
              ),
              subtitle: Text(
                m['waived_by_user_id'] != null
                    ? 'Explicitly waived'
                    : m['linked_order_id'] != null
                    ? 'Linked order: ${m['linked_order_id']}'
                    : 'Link an Item-Based purchase or explicitly waive.',
              ),
              trailing:
                  projectActive &&
                      m['waived_by_user_id'] == null &&
                      (m['linked_order_id'] == null ||
                          [
                            'CANCELLED',
                            'DECLINED',
                            'EXPIRED',
                          ].contains(m['linked_order_state']))
                  ? TextButton(
                      onPressed: _busy ? null : () => _resolve(m),
                      child: const Text('Resolve'),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _resolve(ProjectData line) async {
    final reason = TextEditingController(),
        order = TextEditingController(),
        override = TextEditingController();
    final confirmed = await showBuyerFormDialog<bool>(
      context: context,
      builder: (context) => BuyerDialog(
        title: const Text('Resolve missing material'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: order,
              decoration: const InputDecoration(
                labelText: 'Accepted Item-Based order ID to link',
              ),
            ),
            TextField(
              controller: reason,
              decoration: const InputDecoration(
                labelText: 'Or written waiver reason',
              ),
            ),
            TextField(
              controller: override,
              decoration: const InputDecoration(
                labelText: 'Budget override reason, if required',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _run(() async {
        _package = await repo.resolve(id, projectText(line['id']), {
          'lock_version': lock,
          if (order.text.trim().isNotEmpty)
            'order_id': order.text.trim()
          else
            'reason': reason.text.trim(),
          if (override.text.trim().isNotEmpty)
            'budget_override_reason': override.text.trim(),
        });
      });
    }
    reason.dispose();
    order.dispose();
    override.dispose();
  }
}

class ProjectBudgetCard extends StatelessWidget {
  const ProjectBudgetCard({super.key, required this.budget, this.action});
  final ProjectData budget;

  /// Optional header action, such as the budget report export.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = projectInt(budget['budget_centavos']);
    final committed = projectInt(budget['committed_centavos']);
    final remaining = projectInt(budget['remaining_centavos']);
    final over = remaining < 0;
    final percent = projectText(budget['utilization_percent']);
    final buckets = [
      (
        'Pending incomplete orders',
        projectInt(budget['pending_centavos']),
        Color.lerp(BuyerTheme.action, Colors.white, 0.55)!,
      ),
      (
        'Actual completed / retained cost',
        projectInt(budget['actual_centavos']),
        BuyerTheme.action,
      ),
      (
        'Paid cancelled amount awaiting recovery',
        projectInt(budget['awaiting_recovery_centavos']),
        BuyerTheme.ink,
      ),
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BuyerTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  over ? 'Over budget by' : 'Remaining',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: BuyerTheme.muted,
                  ),
                ),
              ),
              ?action,
            ],
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              projectMoney(remaining.abs()),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: over ? theme.colorScheme.error : BuyerTheme.ink,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _BudgetBar(
            total: total > committed ? total : committed,
            segments: [for (final b in buckets) (b.$2, b.$3)],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${projectMoney(committed)} committed',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                'of ${projectMoney(total)}${percent.isEmpty ? '' : ' · ${percent.replaceFirst(RegExp(r'\.?0+$'), '')}%'}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: BuyerTheme.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: BuyerTheme.canvas,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                for (final b in buckets)
                  _BudgetLine(label: b.$1, centavos: b.$2, color: b.$3),
              ],
            ),
          ),
          if (budget['warning'] == true) ...[
            const SizedBox(height: 12),
            StatusBand(
              tone: BandTone.warning,
              title: '${budget['utilization_percent']}% utilized',
              message: 'Purchases above 100% require a written override.',
            ),
          ],
        ],
      ),
    );
  }
}

/// Stacked bar of committed buckets against the larger of budget and committed.
class _BudgetBar extends StatelessWidget {
  const _BudgetBar({required this.total, required this.segments});
  final int total;
  final List<(int, Color)> segments;

  @override
  Widget build(BuildContext context) {
    final used = segments.fold<int>(0, (sum, s) => sum + s.$1);
    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          height: 10,
          color: BuyerTheme.border,
          child: total <= 0 || used <= 0
              ? null
              : Row(
                  children: [
                    for (final s in segments)
                      if (s.$1 > 0)
                        Expanded(
                          flex: s.$1,
                          child: ColoredBox(color: s.$2),
                        ),
                    if (total > used) Spacer(flex: total - used),
                  ],
                ),
        ),
      ),
    );
  }
}

class _BudgetLine extends StatelessWidget {
  const _BudgetLine({
    required this.label,
    required this.centavos,
    required this.color,
  });
  final String label;
  final int centavos;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: BuyerTheme.muted),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          projectMoney(centavos),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}
