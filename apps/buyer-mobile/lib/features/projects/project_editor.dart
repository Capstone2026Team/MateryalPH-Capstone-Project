import 'package:flutter/material.dart';
import '../../design_system/components/procurement_components.dart';
import '../map_discovery/discovery_models.dart';
import 'projects_repository.dart';

/// Planning fields own their controllers for the entire route lifetime.
class ProjectEditor extends StatefulWidget {
  const ProjectEditor({
    super.key,
    required this.repository,
    required this.chooseLocation,
    this.project,
  });
  final ProjectsRepository repository;
  final Future<DiscoveryOrigin?> Function() chooseLocation;
  final ProjectData? project;
  @override
  State<ProjectEditor> createState() => _ProjectEditorState();
}

class _ProjectEditorState extends State<ProjectEditor> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController(), _budget = TextEditingController();
  final _start = TextEditingController(), _end = TextEditingController();
  String? _location, _locationLabel, _error;
  bool _busy = false;
  final _key = projectKey();
  bool get _editing => widget.project != null;
  @override
  void initState() {
    super.initState();
    final p = widget.project;
    if (p == null) return;
    _name.text = projectText(p['name']);
    _budget.text = projectMoney(p['budget_centavos']).replaceAll('₱', '');
    _start.text = projectText(p['starts_on']);
    _end.text = projectText(p['ends_on']);
    final site = projectRows(p['sites']).firstOrNull;
    _location = projectObject(site?['point'])['location_id'] as String?;
    _locationLabel = site?['name'] as String?;
  }

  @override
  void dispose() {
    for (final c in [_name, _budget, _start, _end]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _date(TextEditingController field) async {
    final value = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate:
          DateTime.tryParse(field.text) ??
          DateTime.tryParse(_start.text) ??
          DateTime.now(),
    );
    if (value != null && mounted) {
      setState(() => field.text = value.toIso8601String().substring(0, 10));
    }
  }

  Future<void> _choose() async {
    try {
      final site = await widget.chooseLocation();
      if (site != null && mounted) {
        setState(() {
          _location = site.locationId;
          _locationLabel = site.label;
          _error = null;
        });
      }
    } on DiscoveryFailure catch (error) {
      if (mounted) setState(() => _error = error.message);
    }
  }

  Future<void> _save() async {
    if (_busy || !_form.currentState!.validate()) return;
    if (!_editing && _location == null) {
      setState(() => _error = 'Choose a saved Project site.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final input = <String, Object?>{
        'name': _name.text.trim(),
        'budget_centavos': parseProjectMoney(_budget.text),
        'starts_on': _start.text,
        'ends_on': _end.text,
        if (_location != null) 'location_id': _location,
      };
      final result = _editing
          ? await widget.repository.update(projectText(widget.project!['id']), {
              ...input,
              'lock_version': widget.project!['lock_version'],
            }, _key)
          : await widget.repository.create(input, _key);
      if (mounted) Navigator.of(context).pop(result);
    } on DiscoveryFailure catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_busy,
    child: Scaffold(
      appBar: AppBar(
        title: Text(_editing ? 'Edit Project planning' : 'Create Project'),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: FilledButton(
            onPressed: _busy ? null : _save,
            child: Text(
              _busy
                  ? 'Saving…'
                  : _editing
                  ? 'Save planning'
                  : 'Create Project',
            ),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Form(
            key: _form,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_error != null)
                  StatusBand(tone: BandTone.danger, title: _error!),
                const SectionHeading('Project details'),
                const Text(
                  'Set your overall budget and schedule. Add material requirements in Work Packages after saving.',
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _name,
                  enabled: !_busy,
                  maxLength: 150,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(labelText: 'Project name'),
                  validator: (v) => (v?.trim().isEmpty ?? true)
                      ? 'Enter a Project name.'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _budget,
                  enabled: !_busy,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Overall budget (₱)',
                    helperText: 'Your budget for all Work Packages.',
                  ),
                  validator: (v) => parseProjectMoney(v ?? '') == null
                      ? 'Enter a valid amount with up to two decimal places.'
                      : null,
                ),
                const SectionHeading('Schedule'),
                for (final field in [
                  (_start, 'Start date'),
                  (_end, 'End date'),
                ]) ...[
                  TextFormField(
                    controller: field.$1,
                    readOnly: true,
                    enabled: !_busy,
                    decoration: InputDecoration(
                      labelText: field.$2,
                      suffixIcon: const Icon(Icons.calendar_today_outlined),
                    ),
                    onTap: () => _date(field.$1),
                    validator: (v) => (v?.isEmpty ?? true)
                        ? 'Choose ${field.$2.toLowerCase()}.'
                        : field.$1 == _end &&
                              _start.text.isNotEmpty &&
                              _end.text.compareTo(_start.text) < 0
                        ? 'End date must be on or after the start date.'
                        : null,
                  ),
                  const SizedBox(height: 16),
                ],
                const SectionHeading('Project site'),
                const Text(
                  'Vendor discovery starts from the saved site selected for each Work Package.',
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _busy ? null : _choose,
                  icon: const Icon(Icons.location_on_outlined),
                  label: Text(_locationLabel ?? 'Choose Project site'),
                ),
                if (_editing)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Choosing another site adds it to this Project. Existing Work Package sites stay attached to their saved versions.',
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
