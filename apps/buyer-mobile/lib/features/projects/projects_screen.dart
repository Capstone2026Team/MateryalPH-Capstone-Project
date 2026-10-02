import 'dart:async';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../design_system/components/work_package_attachment.dart';
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
import '../map_discovery/supplier_preview_sheet.dart';
import '../map_discovery/map_geometry.dart';
import '../orders/order_models.dart' show formatManilaDateTime;
import 'projects_repository.dart';

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
    required this.openAnalysis,
    this.active = true,
  });
  final bool active;
  final ProjectsRepository repository;
  final DiscoveryRepository discovery;
  final DeviceLocationService deviceLocation;
  final SupplierMapBuilder mapBuilder;
  final ProjectOpen openConversation, openOrder, openStore;
  final void Function(BuildContext context, ProjectData site) openAnalysis;
  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  ProjectData? _page, _project, _package, _estimates;
  String? _error, _selected, _note;
  bool _busy = false, _map = false;
  int _sequence = 0, _routeSequence = 0;
  int _projectSection = 0;
  List<GeoPoint>? _path;
  ProjectData? _route;
  String? _routeError;
  final Map<String, String> _keys = {};
  final Map<String, GlobalKey> _candidateKeys = {};
  Timer? _refresh;
  ProjectsRepository get repo => widget.repository;
  String get id => projectText(_package?['id']);
  int get lock => projectInt(_package?['lock_version']);
  ProjectData get content =>
      projectObject(projectObject(_package?['version'])['content']);
  @override
  void initState() {
    super.initState();
    unawaited(_run(_reload));
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
    _routeSequence++;
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
    ProjectData? estimates;
    if (_package != null && result['status'] != 'DRAFT') {
      estimates = await repo.estimates(id);
    }
    if (!mounted || token != _sequence) return;
    setState(() {
      if (_package != null) {
        _package = result;
        _estimates = estimates;
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
    final e = p['status'] == 'DRAFT' ? null : await repo.estimates(id);
    if (mounted && token == _sequence) {
      setState(() {
        _package = p;
        _estimates = e;
        _selected = null;
        _path = null;
        _map = false;
        _keys.clear();
      });
    }
  });
  Future<void> _back() async {
    _sequence++;
    _routeSequence++;
    setState(() {
      if (_package != null) {
        _package = null;
        _estimates = null;
      } else {
        _project = null;
      }
      _selected = null;
      _path = null;
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

  Future<void> _editPackage({bool newVersion = false}) async {
    final result = await Navigator.of(context).push<ProjectData>(
      MaterialPageRoute(
        builder: (_) => WorkPackageEditor(
          repository: repo,
          project: _project!,
          package: _package,
          newVersion: newVersion,
          chooseLocation: _location,
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _package = result;
        _estimates = null;
        _keys.clear();
      });
    }
  }

  Future<void> _scan(int radius) async {
    if (!await _confirm(
      'Compile $radius km estimates?',
      'Scan from the locked Project site. This replaces the displayed comparison with a fresh 48-hour advisory snapshot.',
    )) {
      return;
    }
    await _run(() async {
      final e = await repo.compile(id, lock, radius);
      if (mounted) {
        setState(() {
          _estimates = e;
          _path = null;
          _selected = null;
          _routeSequence++;
        });
      }
    });
  }

  Future<bool> _confirm(String title, String message) async =>
      await showBuyerFormDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
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
  Future<void> _selectMarker(String candidate) async {
    final token = ++_routeSequence, version = _package?['current_version_id'];
    setState(() {
      _selected = candidate;
      _path = null;
      _route = null;
      _routeError = null;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedContext = _candidateKeys[candidate]?.currentContext;
      if (selectedContext != null) {
        unawaited(
          Scrollable.ensureVisible(
            selectedContext,
            duration: MediaQuery.disableAnimationsOf(context)
                ? Duration.zero
                : const Duration(milliseconds: 250),
            alignment: .1,
          ),
        );
      }
    });
    try {
      final result = await repo.route(id, candidate);
      if (mounted &&
          token == _routeSequence &&
          version == _package?['current_version_id'] &&
          result['version_id'] == version) {
        setState(() {
          _route = result;
          _path = decodePolyline(projectText(result['encoded_polyline']));
        });
      }
    } on DiscoveryFailure catch (e) {
      if (mounted && token == _routeSequence) {
        setState(() => _routeError = e.message);
      }
    }
  }

  Future<void> _candidate(ProjectData row, bool select) async {
    String? reason;
    if (select) {
      final input = TextEditingController(text: _note ?? ''),
          override = TextEditingController();
      final confirmed = await showBuyerFormDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Select ${row['store_name']}?'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Other active quotations expire. This Vendor manually confirms the package before your final approval.',
                ),
                TextField(
                  controller: input,
                  maxLength: 2000,
                  decoration: const InputDecoration(
                    labelText: 'Optional informational Note',
                    helperText: 'No Vendor response required',
                  ),
                ),
                TextField(
                  controller: override,
                  maxLength: 2000,
                  decoration: const InputDecoration(
                    labelText: 'Budget override reason',
                    helperText:
                        'Required when the purchase exceeds either budget',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Select Vendor'),
            ),
          ],
        ),
      );
      _note = input.text.trim();
      reason = override.text.trim();
      input.dispose();
      override.dispose();
      if (confirmed != true) return;
    }
    await _run(() async {
      final result = await repo.candidate(
        id,
        {
          'lock_version': lock,
          'candidate_id': row['id'],
          if (select && (_note?.isNotEmpty ?? false)) 'note': _note,
          if (reason?.isNotEmpty ?? false) 'budget_override_reason': reason,
        },
        _key('${select ? 'select' : 'inquire'}:${row['id']}'),
        select: select,
      );
      _keys.remove('${select ? 'select' : 'inquire'}:${row['id']}');
      await _reload();
      if (!mounted) return;
      if (select) {
        widget.openOrder(context, result);
      } else {
        widget.openConversation(context, result);
      }
    });
  }

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
      appBar: AppBar(
        leading: _project == null
            ? null
            : IconButton(
                onPressed: _busy ? null : _back,
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Back',
              ),
        title: Text(
          projectText(_package?['name'] ?? _project?['name'] ?? 'Projects'),
        ),
        actions: [
          IconButton(
            onPressed: _busy ? null : _preferences,
            icon: const Icon(Icons.tune),
            tooltip: 'Project Ranking Preferences',
          ),
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
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'Your Projects will appear here. Start with a site, timeline and overall budget.',
                ),
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
                    ProjectBudgetCard(budget: projectObject(p['budget'])),
                    const SectionHeading('Schedule'),
                    SpecificationRow('Start date', projectText(p['starts_on'])),
                    SpecificationRow('End date', projectText(p['ends_on'])),
                    if (p['status'] != 'ARCHIVED') ...[
                      const SectionHeading('Manage Project'),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          OutlinedButton(
                            onPressed: _busy || p['status'] != 'ACTIVE'
                                ? null
                                : () => _createProject(editing: true),
                            child: const Text('Edit planning / add site'),
                          ),
                          OutlinedButton(
                            onPressed: _busy || p['status'] == 'ARCHIVED'
                                ? null
                                : () => _run(() async {
                                    _project = await repo
                                        .update(projectText(p['id']), {
                                          'lock_version': p['lock_version'],
                                          'status': 'ARCHIVED',
                                        }, _key('archive'));
                                  }),
                            child: const Text('Archive'),
                          ),
                          OutlinedButton(
                            onPressed: _busy || p['status'] != 'ACTIVE'
                                ? null
                                : () => _run(() async {
                                    _project = await repo
                                        .update(projectText(p['id']), {
                                          'lock_version': p['lock_version'],
                                          'status': 'COMPLETED',
                                        }, _key('complete'));
                                  }),
                            child: const Text('Complete'),
                          ),
                          if (p['status'] == 'ACTIVE' &&
                              projectRows(packages['items']).isEmpty)
                            TextButton(
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
                              child: const Text('Delete empty Project'),
                            ),
                        ],
                      ),
                    ],
                  ],
                  if (_projectSection == 1) ...[
                    const SectionHeading('Work Packages'),
                    FilledButton.icon(
                      onPressed: _busy || p['status'] != 'ACTIVE'
                          ? null
                          : () => _editPackage(),
                      icon: const Icon(Icons.add),
                      label: const Text('New Work Package'),
                    ),
                    if (projectRows(packages['items']).isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'Add a Work Package to specify materials and compare eligible Vendors.',
                        ),
                      ),
                    ...projectRows(packages['items']).map(
                      (w) => Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(projectText(w['name'])),
                          subtitle: Text(
                            '${projectStatus(w['status'])} · ${projectMoney(w['budget_centavos'])}',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _openPackage(projectText(w['id'])),
                        ),
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
                            TextButton.icon(
                              onPressed: () =>
                                  widget.openAnalysis(context, site),
                              icon: const Icon(Icons.insights_outlined),
                              label: const Text('Market analysis'),
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
        unassigned = ['ACTIVE', 'QUOTATION_INQUIRY'].contains(w['status']);
    final candidates = projectRows(_estimates?['items']);
    final list = ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          '${projectStatus(w['status'])} · version ${projectObject(w['version'])['version']}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        ProjectBudgetCard(budget: projectObject(w['budget'])),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (editable)
              FilledButton(
                onPressed: _busy ? null : () => _editPackage(),
                child: const Text('Edit Draft'),
              ),
            if (editable &&
                projectRows(
                  projectObject(w['versions'])['items'],
                ).every((v) => v['locked_at'] == null))
              TextButton(
                onPressed: _busy
                    ? null
                    : () async {
                        if (await _confirm(
                          'Delete this Draft?',
                          'Only editable drafts without locked history can be deleted.',
                        )) {
                          await _run(() async {
                            await repo.delete(id, lock);
                            _package = null;
                            await _reload();
                          });
                        }
                      },
                child: const Text('Delete Draft'),
              ),
            if (editable)
              FilledButton(
                onPressed: _busy
                    ? null
                    : () async {
                        if (await _confirm(
                          'Activate this Work Package?',
                          'The material original becomes locked. Future corrections require an explicit new version.',
                        )) {
                          await _run(() async {
                            _package = await repo.activate(
                              id,
                              lock,
                              _key('activate'),
                            );
                            _keys.remove('activate');
                            _estimates = await repo.compile(
                              id,
                              lock,
                              projectInt(content['radius_km']),
                            );
                          });
                        }
                      },
                child: const Text('Activate and compare'),
              ),
            if (projectActive && (unassigned || w['status'] == 'CANCELLED'))
              OutlinedButton(
                onPressed: _busy ? null : () => _editPackage(newVersion: true),
                child: const Text('Create new version'),
              ),
            if (projectActive && unassigned)
              OutlinedButton(
                onPressed: _busy
                    ? null
                    : () async {
                        if (await _confirm(
                          'Cancel Work Package?',
                          'Locked originals and quotation history remain available.',
                        )) {
                          await _run(() async {
                            _package = await repo.close(id, lock);
                          });
                        }
                      },
                child: const Text('Cancel package'),
              ),
            if (w['order_id'] != null)
              FilledButton(
                onPressed: () =>
                    widget.openOrder(context, projectText(w['order_id'])),
                child: const Text('Open order'),
              ),
            if (!draft)
              OutlinedButton.icon(
                onPressed: () => setState(() => _map = !_map),
                icon: Icon(_map ? Icons.list : Icons.map_outlined),
                label: Text(_map ? 'Comparison list' : 'Project Vendor Map'),
              ),
            OutlinedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.picture_as_pdf_outlined),
              label: const Text('Export PDF (coming soon)'),
            ),
          ],
        ),
        WorkPackageAttachment(
          original: content,
          version: projectObject(w['version'])['version'],
          locked: projectObject(w['version'])['locked_at'] != null,
        ),
        ExpansionTile(
          title: const Text('Version history'),
          children: [
            ...projectRows(projectObject(w['versions'])['items']).map(
              (v) => ExpansionTile(
                title: Text(
                  'Version ${v['version']} · ${v['locked_at'] == null ? 'Draft' : 'Locked'}',
                ),
                subtitle: Text(
                  v['locked_at'] == null
                      ? 'Editable planning draft'
                      : 'Saved original requirements',
                ),
                children: [
                  WorkPackageAttachment(
                    original: projectObject(v['content']),
                    version: v['version'],
                    locked: v['locked_at'] != null,
                  ),
                ],
              ),
            ),
            if (projectObject(w['versions'])['has_more'] == true)
              TextButton(
                onPressed: () => _run(() async {
                  final next = await repo.package(
                    id,
                    page: projectInt(projectObject(w['versions'])['page']) + 1,
                  );
                  final more = projectObject(next['versions']);
                  if (mounted) {
                    setState(
                      () => _package = {
                        ...next,
                        'versions': {
                          ...more,
                          'items': [
                            ...projectRows(
                              projectObject(w['versions'])['items'],
                            ),
                            ...projectRows(more['items']),
                          ],
                        },
                      },
                    );
                  }
                }),
                child: const Text('Older versions'),
              ),
          ],
        ),
        ...projectRows(w['missing_lines']).map(
          (m) => ListTile(
            title: Text('Missing: ${m['name']} · ${m['quantity']}'),
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
        if (!draft) ...[
          const SizedBox(height: 20),
          Text(
            'Vendor comparison',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (_estimates?['estimate'] != null)
            Text(
              'Advisory system estimate · ${projectObject(_estimates!['estimate'])['state']} · expires ${formatManilaDateTime(DateTime.parse(projectText(projectObject(_estimates!['estimate'])['expires_at'])))}',
            ),
          if (_estimates?['estimate'] != null)
            Text(
              projectObject(
                        projectObject(
                          projectObject(_estimates!['estimate'])['context'],
                        )['preferences'],
                      )['personalized'] ==
                      true
                  ? 'Personalized Project FMS weights active · saved estimate basis'
                  : 'Platform default Project weights · saved estimate basis',
            ),
          if (projectActive && unassigned)
            Wrap(
              spacing: 8,
              children: [5, 10, 20, 30, 40, 50]
                  .map(
                    (radius) => ActionChip(
                      label: Text('$radius km'),
                      onPressed: _busy ? null : () => _scan(radius),
                    ),
                  )
                  .toList(),
            ),
          if (candidates.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'No matching Vendors in this comparison. Compile estimates within your chosen radius to find eligible Vendors.',
              ),
            ),
          ...candidates.map(_candidateCard),
          if (_estimates?['has_more'] == true)
            OutlinedButton(
              onPressed: _busy
                  ? null
                  : () => _run(() async {
                      final next = await repo.estimates(
                        id,
                        page: projectInt(_estimates!['page']) + 1,
                      );
                      if (mounted) {
                        setState(
                          () => _estimates = {
                            ...next,
                            'items': [
                              ...candidates,
                              ...projectRows(next['items']),
                            ],
                          },
                        );
                      }
                    }),
              child: const Text('More Vendors'),
            ),
        ],
      ],
    );
    if (!_map) return list;
    final point = projectObject(projectObject(content['site'])['point']);
    final origin = GeoPoint(
      double.parse(projectText(point['latitude'])),
      double.parse(projectText(point['longitude'])),
    );
    final markers = candidates.asMap().entries.map((e) {
      final c = e.value;
      return SupplierResultView(
        resultId: projectText(c['id']),
        tier: SupplierTier.verified,
        rank: e.key + 1,
        name: projectText(c['store_name']),
        point: GeoPoint(
          (c['latitude'] as num).toDouble(),
          (c['longitude'] as num).toDouble(),
        ),
        distanceMeters: projectInt(c['distance_meters']),
        scoreKind: c['vps'] == null ? ScoreKind.newVendor : ScoreKind.vps,
        scoreText: projectText(c['score_label']),
      );
    }).toList();
    return LayoutBuilder(
      builder: (context, size) {
        final wide = size.maxWidth >= 1024;
        final map = widget.mapBuilder(
          context,
          SupplierMapProps(
            items: markers,
            origin: origin,
            radiusKm: projectInt(
              projectObject(
                    projectObject(_estimates?['estimate'])['context'],
                  )['radius_km'] ??
                  content['radius_km'],
            ),
            selectedId: _selected,
            routePath: _path,
            onSelect: _selectMarker,
            bottomInset: wide ? 0 : size.maxHeight * .42,
            recenterToken: 0,
            procurementContext: SupplierMapContext.projectBased,
          ),
        );
        return wide
            ? Row(
                children: [
                  Expanded(child: map),
                  SizedBox(width: 440, child: list),
                ],
              )
            : Stack(
                children: [
                  Positioned.fill(child: map),
                  SupplierPreviewSheet(
                    builder: (context, controller) => ListView(
                      controller: controller,
                      padding: const EdgeInsets.all(16),
                      children: [
                        Text(
                          'Project site: ${point['label']}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          'Radius ${projectObject(projectObject(_estimates?["estimate"])["context"])["radius_km"] ?? content["radius_km"]} km · eligible Tier 2 Vendors',
                        ),
                        TextButton(
                          onPressed: () => setState(() => _map = false),
                          child: const Text('Open full comparison'),
                        ),
                        if (candidates.isEmpty)
                          const Text(
                            'This saved comparison has no eligible candidates. Open the full comparison for estimate status; an Active package can scan a wider radius.',
                          ),
                        ...candidates.map(_candidateCard),
                      ],
                    ),
                  ),
                ],
              );
      },
    );
  }

  Widget _candidateCard(ProjectData c) {
    final fms = projectObject(c['fms']),
        destination = projectObject(c['destination']);
    final available =
        !_busy &&
        _package?['project_status'] == 'ACTIVE' &&
        ['ACTIVE', 'QUOTATION_INQUIRY'].contains(_package?['status']) &&
        c['stale'] != true &&
        projectObject(_estimates?['estimate'])['state'] == 'ACTIVE';
    return Card(
      key: _candidateKeys.putIfAbsent(projectText(c['id']), GlobalKey.new),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: _selected == c['id']
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              projectText(c['store_name']),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '${c['score_label']} · FMS ${fms['score'] ?? 'Cost review required'}',
            ),
            Text(
              '${c['complete'] == true ? 'Complete match' : 'Partial match'} · ${c['fulfillment_percent']}% · ${projectText(c['budget_label']).replaceAll('_', ' ')}',
            ),
            Text(
              'Materials ${projectMoney(c['materials_centavos'])} (includes VAT ${projectMoney(c['included_vat_centavos'])})\nDelivery ${c['delivery_centavos'] == null ? 'manual review' : projectMoney(c['delivery_centavos'])}\nBuyer processing fee ${c['processing_fee_centavos'] == null ? 'pending payment channel' : projectMoney(c['processing_fee_centavos'])}\nProjected total ${c['projected_total_centavos'] == null ? 'pending delivery review' : projectMoney(c['projected_total_centavos'])}',
            ),
            Text(
              '${(projectInt(c['distance_meters']) / 1000).toStringAsFixed(2)} km · ${projectText(c['distance_basis']).replaceAll('_', ' ')} · ${c['fulfillment_method']}\nQuotation: ${projectText(c['current_quotation_state']).replaceAll('_', ' ')}',
            ),
            Text(
              'Project site: ${projectObject(destination['intended'])['formatted_address']}\nVehicle endpoint: ${destination['vehicle_endpoint'] == 'ALTERNATE_DROP_OFF' ? 'Alternative vehicle drop-off' : 'Project site'} · ${projectObject(destination[destination['vehicle_endpoint'] == 'ALTERNATE_DROP_OFF' ? 'alternate_drop_off' : 'intended'])['formatted_address']}\nDelivery rate uses the road route from the store to this vehicle endpoint.',
            ),
            ...projectRows(
              projectObject(
                projectObject(c['delivery'])['estimate'],
              )['options'],
            ).map(
              (option) => Text(
                '${option['vehicle_name']} · ${option['vehicles']} vehicle(s) · ${option['trips']} trip(s)\n${projectMoney(option['base_fee_centavos'])} base + ${projectMoney(option['per_km_centavos'])}/km, rounded half-up per trip; ${projectMoney(option['fee_per_trip_centavos'])}/trip · ${projectMoney(option['fee_centavos'])} estimate',
              ),
            ),
            if (c['stale'] == true)
              const Text(
                'Sources changed. Compile a fresh estimate before proceeding.',
              ),
            ...projectRows(c['missing_lines']).map(
              (m) => Text(
                'Missing ${m['name']}: ${m['quantity']} ${m['unit_code'] ?? ''}',
              ),
            ),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: const Text('Compare material lines and FMS'),
              children: [
                ...projectRows(c['lines']).map(
                  (l) => ListTile(
                    dense: true,
                    title: Text(projectText(l['name'])),
                    subtitle: Text(
                      '${l['matched_quantity']} / ${l['quantity']} ${l['unit_code']} · ${projectMoney(l['amount_centavos'])}',
                    ),
                  ),
                ),
                ...projectObject(fms['components']).entries.map(
                  (e) => Text('${e.key.replaceAll('_', ' ')}: ${e.value}'),
                ),
              ],
            ),
            if (_selected == c['id'] && _route != null)
              Text(
                'Route from Project site: ${(projectInt(_route!['distance_meters']) / 1000).toStringAsFixed(2)} km · ETA ${(projectInt(_route!['duration_seconds']) / 60).ceil()} min',
              ),
            if (_selected == c['id'] && _routeError != null) Text(_routeError!),
            Wrap(
              spacing: 8,
              children: [
                TextButton(
                  onPressed: () => _selectMarker(projectText(c['id'])),
                  child: const Text('Route / retry'),
                ),
                TextButton(
                  onPressed: () =>
                      widget.openStore(context, projectText(c['vendor_id'])),
                  child: const Text('View Store'),
                ),
                OutlinedButton(
                  onPressed: available ? () => _candidate(c, false) : null,
                  child: const Text('Message Vendor'),
                ),
                FilledButton(
                  onPressed: available ? () => _candidate(c, true) : null,
                  child: const Text('Select / Add Note'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _resolve(ProjectData line) async {
    final reason = TextEditingController(),
        order = TextEditingController(),
        override = TextEditingController();
    final confirmed = await showBuyerFormDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resolve missing material'),
        scrollable: true,
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
  const ProjectBudgetCard({super.key, required this.budget});
  final ProjectData budget;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: BuyerTheme.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Remaining ${projectMoney(budget['remaining_centavos'])}',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        SpecificationRow(
          'Overall budget',
          projectMoney(budget['budget_centavos']),
        ),
        SpecificationRow(
          'Committed',
          projectMoney(budget['committed_centavos']),
          strong: true,
        ),
        const Divider(height: 24),
        SpecificationRow(
          'Pending incomplete orders',
          projectMoney(budget['pending_centavos']),
        ),
        SpecificationRow(
          'Actual completed / retained cost',
          projectMoney(budget['actual_centavos']),
        ),
        SpecificationRow(
          'Paid cancelled amount awaiting recovery',
          projectMoney(budget['awaiting_recovery_centavos']),
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

class WorkPackageEditor extends StatefulWidget {
  const WorkPackageEditor({
    super.key,
    required this.repository,
    required this.project,
    required this.chooseLocation,
    this.package,
    this.newVersion = false,
  });
  final ProjectsRepository repository;
  final ProjectData project;
  final ProjectData? package;
  final bool newVersion;
  final Future<DiscoveryOrigin?> Function() chooseLocation;
  @override
  State<WorkPackageEditor> createState() => _WorkPackageEditorState();
}

class _WorkPackageEditorState extends State<WorkPackageEditor> {
  final name = TextEditingController(),
      budget = TextEditingController(),
      description = TextEditingController(),
      contact = TextEditingController(),
      instructions = TextEditingController(),
      search = TextEditingController();
  final lines = <ProjectData>[];
  List<ProjectData> suggestions = [];
  String? site, alternate, alternateLabel, error;
  String fulfillment = 'PICKUP', heavy = 'NO';
  int radius = 5, sequence = 0, section = 0;
  bool busy = false;
  final key = projectKey();
  Timer? debounce;
  @override
  void initState() {
    super.initState();
    final original = projectObject(
      projectObject(widget.package?['version'])['content'],
    );
    name.text = projectText(original['name']);
    budget.text = projectMoney(original['budget_centavos']).replaceAll('₱', '');
    description.text = projectText(original['description']);
    contact.text = projectText(original['site_contact']);
    instructions.text = projectText(original['access_instructions']);
    site =
        original['site_id'] as String? ??
        projectRows(widget.project['sites']).firstOrNull?['id'] as String?;
    fulfillment = projectText(original['fulfillment_method']).isEmpty
        ? 'PICKUP'
        : projectText(original['fulfillment_method']);
    radius = projectInt(original['radius_km']) == 0
        ? 5
        : projectInt(original['radius_km']);
    heavy =
        projectText(
          projectObject(original['destination'])['heavy_vehicle_restriction'],
        ).isEmpty
        ? 'NO'
        : projectText(
            projectObject(original['destination'])['heavy_vehicle_restriction'],
          );
    alternate =
        projectObject(
              projectObject(original['destination'])['alternate_drop_off'],
            )['location_id']
            as String?;
    lines.addAll(projectRows(original['lines']));
  }

  @override
  void dispose() {
    debounce?.cancel();
    sequence++;
    for (final c in [
      name,
      budget,
      description,
      contact,
      instructions,
      search,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _lookup(String query) async {
    final token = ++sequence;
    if (query.trim().length < 2) {
      setState(() => suggestions = []);
      return;
    }
    try {
      final result = await widget.repository.materials(query.trim());
      if (mounted && token == sequence) {
        setState(() => suggestions = projectRows(result['items']));
      }
    } on DiscoveryFailure catch (e) {
      if (mounted && token == sequence) setState(() => error = e.message);
    }
  }

  Future<void> _line(ProjectData material) async {
    final units = projectRows(material['compatible_units']);
    if (units.isEmpty) {
      setState(
        () => error = 'This material has no configured compatible units.',
      );
      return;
    }
    String? lineError;
    final quantity = TextEditingController(),
        brand = TextEditingController(),
        specs = TextEditingController();
    String? unit = units.first['id'] as String?;
    await showBuyerFormDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, update) => AlertDialog(
          title: Text(projectText(material['name'])),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (lineError != null)
                  StatusBand(tone: BandTone.danger, title: lineError!),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: unit,
                  decoration: const InputDecoration(
                    labelText: 'Normalized unit',
                  ),
                  items: units
                      .map(
                        (u) => DropdownMenuItem(
                          value: projectText(u['id']),
                          child: Text(projectText(u['code'])),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => update(() => unit = v),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: quantity,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Quantity'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: brand,
                  decoration: const InputDecoration(
                    labelText: 'Preferred brand (optional)',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: specs,
                  decoration: const InputDecoration(
                    labelText: 'Specifications · key=value, one per line',
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (!RegExp(
                      r'^\d{1,7}(\.\d{1,4})?$',
                    ).hasMatch(quantity.text.trim()) ||
                    (double.tryParse(quantity.text) ?? 0) <= 0 ||
                    (double.tryParse(quantity.text) ?? 0) > 1000000 ||
                    unit == null) {
                  update(
                    () => lineError =
                        'Use a quantity above zero, up to 1,000,000, with at most four decimal places.',
                  );
                  return;
                }
                if (lines.length >= 100) {
                  update(
                    () => lineError =
                        'A Work Package supports up to 100 materials.',
                  );
                  return;
                }
                final specifications = <String, String>{};
                for (final row in specs.text.split('\n')) {
                  final split = row.indexOf('=');
                  if (row.trim().isEmpty) continue;
                  if (split <= 0 || row.substring(split + 1).trim().isEmpty) {
                    update(
                      () =>
                          lineError = 'Enter each specification as name=value.',
                    );
                    return;
                  }
                  if (split > 0) {
                    specifications[row.substring(0, split).trim()] = row
                        .substring(split + 1)
                        .trim();
                  }
                }
                setState(() {
                  lines.add({
                    'material_id': material['id'],
                    'name': material['name'],
                    'unit_id': unit,
                    'unit_code': units.firstWhere(
                      (u) => u['id'] == unit,
                    )['code'],
                    'quantity': quantity.text.trim(),
                    'preferred_brand': brand.text.trim().isEmpty
                        ? null
                        : brand.text.trim(),
                    'specifications': specifications,
                  });
                  suggestions = [];
                  search.clear();
                });
                Navigator.pop(context);
              },
              child: const Text('Add material'),
            ),
          ],
        ),
      ),
    );
    quantity.dispose();
    brand.dispose();
    specs.dispose();
  }

  Future<void> _import() async {
    final csv = TextEditingController();
    String? failure;
    bool importing = false;
    await showBuyerFormDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, update) => AlertDialog(
          title: const Text('Import material CSV'),
          scrollable: true,
          content: SizedBox(
            width: 540,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SelectableText(
                  'material_code,name,unit_code,quantity,preferred_brand,specifications',
                ),
                TextButton.icon(
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Choose CSV file'),
                  onPressed: importing
                      ? null
                      : () async {
                          try {
                            final file = await FilePicker.pickFile(
                              type: FileType.custom,
                              allowedExtensions: ['csv'],
                            );
                            if (file == null || !context.mounted) return;
                            final bytes = await file.xFile.readAsBytes();
                            if (!context.mounted) return;
                            if (bytes.isEmpty || bytes.length > 100000) {
                              update(
                                () => failure =
                                    'Choose a UTF-8 CSV file up to 100 KB.',
                              );
                              return;
                            }
                            csv.text = utf8
                                .decode(bytes)
                                .replaceFirst(RegExp(r'^\uFEFF'), '');
                            update(() => failure = null);
                          } catch (_) {
                            if (context.mounted) {
                              update(
                                () => failure =
                                    'This file could not be read. Choose a UTF-8 CSV file or paste its contents.',
                              );
                            }
                          }
                        },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: csv,
                  minLines: 5,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    labelText: 'Paste CSV · maximum 100 rows',
                  ),
                ),
                if (failure != null) Text(failure!),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: importing
                  ? null
                  : () async {
                      update(() => importing = true);
                      try {
                        final preview = await widget.repository.importCsv(
                          csv.text,
                        );
                        if (!context.mounted || !mounted) return;
                        if (preview['valid'] != true) {
                          update(() {
                            failure = projectRows(
                              preview['validation_errors'],
                            ).map((e) => e.values.join(' · ')).join('\n');
                            importing = false;
                          });
                          return;
                        }
                        if (lines.length +
                                projectRows(preview['lines']).length >
                            100) {
                          update(() {
                            failure =
                                'A Work Package supports up to 100 materials.';
                            importing = false;
                          });
                          return;
                        }
                        setState(
                          () => lines.addAll(projectRows(preview['lines'])),
                        );
                        if (context.mounted) Navigator.pop(context);
                      } on DiscoveryFailure catch (e) {
                        if (!context.mounted) return;
                        update(() {
                          failure = e.message;
                          importing = false;
                        });
                      }
                    },
              child: const Text('Validate and add'),
            ),
          ],
        ),
      ),
    );
    csv.dispose();
  }

  Future<void> _save() async {
    if (busy) return;
    FocusManager.instance.primaryFocus?.unfocus();
    final amount = parseProjectMoney(budget.text);
    if (amount == null ||
        name.text.trim().isEmpty ||
        site == null ||
        lines.isEmpty) {
      setState(() {
        section = name.text.trim().isEmpty || amount == null || site == null
            ? 0
            : 1;
        error = 'Add a name, valid budget, Project site and material lines.';
      });
      return;
    }
    if (fulfillment == 'DELIVERY' &&
        (contact.text.trim().length < 3 ||
            instructions.text.trim().length < 5 ||
            (heavy == 'YES' && alternate == null))) {
      setState(() {
        section = 0;
        error =
            'Add a site contact, access instructions and any required alternative vehicle drop-off.';
      });
      return;
    }
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final result = await widget.repository.save(
        projectText(widget.project['id']),
        {
          'name': name.text.trim(),
          'description': description.text.trim(),
          'budget_centavos': amount,
          'site_id': site,
          'radius_km': radius,
          'fulfillment_method': fulfillment,
          'payment_method': 'ONLINE',
          'site_contact': contact.text.trim(),
          'access_instructions': instructions.text.trim(),
          'heavy_vehicle_restriction': fulfillment == 'PICKUP' ? 'NO' : heavy,
          if (fulfillment == 'DELIVERY' && heavy == 'YES')
            'alternate_drop_off_location_id': alternate,
          if (widget.package != null)
            'lock_version': widget.package!['lock_version'],
          'lines': lines
              .map(
                (l) => <String, Object?>{
                  for (final k in [
                    'material_id',
                    'name',
                    'unit_id',
                    'quantity',
                    'preferred_brand',
                    'specifications',
                  ])
                    k: l[k],
                },
              )
              .toList(),
        },
        key,
        id: widget.package?['id'] as String?,
        newVersion: widget.newVersion,
      );
      if (mounted) Navigator.pop(context, result);
    } on DiscoveryFailure catch (e) {
      if (mounted) setState(() => error = e.message);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !busy,
    child: Scaffold(
      appBar: AppBar(
        title: Text(
          widget.newVersion ? 'New Work Package version' : 'Work Package Draft',
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: FilledButton(
            onPressed: busy ? null : _save,
            child: Text(busy ? 'Saving…' : 'Save Draft'),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: SegmentedTabs(
                  labels: const ['Details', 'Materials'],
                  selected: section,
                  onChanged: (value) {
                    if (!busy) setState(() => section = value);
                  },
                ),
              ),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: StatusBand(tone: BandTone.danger, title: error!),
                ),
              Expanded(
                child: AbsorbPointer(
                  absorbing: busy,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (busy) const LinearProgressIndicator(),
                      if (section == 0) ...[
                        const SectionHeading('Package details'),
                        const SizedBox(height: 16),
                        TextField(
                          controller: name,
                          maxLength: 150,
                          decoration: const InputDecoration(
                            labelText: 'Work Package name',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: description,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: budget,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Work Package budget (₱)',
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: site,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Project site',
                          ),
                          items: projectRows(widget.project['sites'])
                              .map(
                                (s) => DropdownMenuItem(
                                  value: projectText(s['id']),
                                  child: Text(projectText(s['name'])),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => site = v),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<int>(
                          initialValue: radius,
                          decoration: const InputDecoration(
                            labelText: 'Confirmed search radius',
                          ),
                          items: [5, 10, 20, 30, 40, 50]
                              .map(
                                (r) => DropdownMenuItem(
                                  value: r,
                                  child: Text('$r km'),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => radius = v!),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: fulfillment,
                          decoration: const InputDecoration(
                            labelText: 'Fulfillment',
                          ),
                          items: ['PICKUP', 'DELIVERY']
                              .map(
                                (s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(
                                    s == 'PICKUP' ? 'Pickup' : 'Delivery',
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => fulfillment = v!),
                        ),
                        if (fulfillment == 'DELIVERY') ...[
                          const SizedBox(height: 16),
                          TextField(
                            controller: contact,
                            decoration: const InputDecoration(
                              labelText: 'Site contact',
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: instructions,
                            decoration: const InputDecoration(
                              labelText: 'Access instructions',
                            ),
                          ),
                          SwitchListTile(
                            title: const Text(
                              'Heavy vehicles restricted at Project site',
                            ),
                            subtitle: const Text(
                              'A separate vehicle drop-off preserves the intended Project site.',
                            ),
                            value: heavy == 'YES',
                            onChanged: (v) =>
                                setState(() => heavy = v ? 'YES' : 'NO'),
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
                                  }
                                } on DiscoveryFailure catch (e) {
                                  if (mounted) {
                                    setState(() => error = e.message);
                                  }
                                }
                              },
                              icon: const Icon(Icons.location_on_outlined),
                              label: Text(
                                alternateLabel ??
                                    'Choose alternative vehicle drop-off',
                              ),
                            ),
                        ],
                      ],
                      if (section == 1) ...[
                        const SectionHeading('Materials'),
                        const Text(
                          'Search and add required materials, or import a CSV. Review quantities before saving.',
                        ),
                        const SizedBox(height: 16),
                        const SizedBox(height: 16),
                        TextField(
                          controller: search,
                          decoration: const InputDecoration(
                            labelText: 'Search materials',
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: (v) {
                            debounce?.cancel();
                            sequence++;
                            debounce = Timer(
                              const Duration(milliseconds: 350),
                              () => _lookup(v),
                            );
                          },
                        ),
                        ...suggestions.map(
                          (m) => ListTile(
                            title: Text(projectText(m['name'])),
                            subtitle: Text(projectText(m['code'])),
                            onTap: () => _line(m),
                          ),
                        ),
                        ...lines.asMap().entries.map(
                          (e) => Card(
                            child: ListTile(
                              title: Text(projectText(e.value['name'])),
                              subtitle: Text(
                                '${e.value['quantity']} ${e.value['unit_code'] ?? ''} · ${e.value['preferred_brand'] ?? 'Any brand'}',
                              ),
                              trailing: IconButton(
                                onPressed: () =>
                                    setState(() => lines.removeAt(e.key)),
                                icon: const Icon(Icons.delete_outline),
                                tooltip: 'Remove material',
                              ),
                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: busy ? null : _import,
                          icon: const Icon(Icons.upload_file),
                          label: const Text('Import CSV'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
