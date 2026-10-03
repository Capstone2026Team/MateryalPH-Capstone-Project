import 'package:flutter/material.dart';
import '../../design_system/components/ranking_preferences_editor.dart';
import 'projects_repository.dart';

class ProjectRankingPreferencesScreen extends StatelessWidget {
  const ProjectRankingPreferencesScreen({
    super.key,
    required this.repository,
    this.onChanged,
  });
  final ProjectsRepository repository;
  final VoidCallback? onChanged;
  RankingPreferenceSnapshot _snapshot(ProjectData p) =>
      RankingPreferenceSnapshot(
        weights: projectObject(
          p['weights'],
        ).map((key, value) => MapEntry(key, projectInt(value))),
        defaults: projectObject(
          p['default_weights'],
        ).map((key, value) => MapEntry(key, projectInt(value))),
        personalized: p['personalized'] == true,
        version: projectInt(p['version']),
      );
  @override
  Widget build(BuildContext context) => RankingPreferencesEditor(
    title: 'Project ranking',
    description:
        'Set how Vendors rank for your Work Packages. Adjusting a weight keeps the total at 100%. Changes apply to new estimates; Item-Based preferences stay separate.',
    resetMessage:
        'Project Vendor ranking will use the current platform weights again. Item-Based preferences stay unchanged.',
    factors: const [
      (
        'material_match',
        'Material match',
        'Vendors that can fulfill more of your required materials score higher.',
      ),
      (
        'budget_fit',
        'Budget fit',
        'Offers within your Work Package budget score higher.',
      ),
      (
        'distance',
        'Distance',
        'Closer Vendors score higher within your confirmed radius.',
      ),
      (
        'vps',
        'Vendor Performance (VPS)',
        'Earned Vendor score; new Vendors use a neutral value.',
      ),
    ],
    load: () async => _snapshot(await repository.preferences()),
    save: (weights, version) async => _snapshot(
      await repository.savePreferences({
        'version': version,
        'weights': weights,
      }),
    ),
    reset: (version) async => _snapshot(
      await repository.savePreferences({'version': version}, reset: true),
    ),
    onChanged: onChanged,
  );
}
