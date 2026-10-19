import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'buyer_overlays.dart';
import 'buyer_app_bar.dart';
import 'procurement_components.dart';
import 'ranking_influence_dashboard.dart';
import 'ranking_priority_control.dart';
import '../ranking_weights.dart';
import '../theme.dart';
import '../../features/map_discovery/discovery_models.dart';

class RankingPreferenceSnapshot {
  const RankingPreferenceSnapshot({
    required this.weights,
    required this.defaults,
    required this.personalized,
    required this.version,
  });
  final Map<String, int> weights, defaults;
  final bool personalized;
  final int version;
}

/// One ranking editor for both procurement types; each adapter owns its factors and API.
class RankingPreferencesEditor extends StatefulWidget {
  const RankingPreferencesEditor({
    super.key,
    required this.title,
    required this.description,
    required this.resetMessage,
    required this.factors,
    required this.load,
    required this.save,
    required this.reset,
    this.onChanged,
  });
  final String title, description, resetMessage;
  final List<(String, String, String)> factors;
  final Future<RankingPreferenceSnapshot> Function() load;
  final Future<RankingPreferenceSnapshot> Function(Map<String, int>, int) save;
  final Future<RankingPreferenceSnapshot> Function(int) reset;
  final VoidCallback? onChanged;
  @override
  State<RankingPreferencesEditor> createState() =>
      _RankingPreferencesEditorState();
}

class _RankingPreferencesEditorState extends State<RankingPreferencesEditor> {
  RankingPreferenceSnapshot? _saved;
  Map<String, int> _draft = {};
  bool _loading = true;
  bool _saving = false;
  DiscoveryFailure? _failure;
  String? _notice;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _failure = null;
    });
    try {
      final preferences = await widget.load();
      if (!mounted) return;
      setState(() {
        _saved = preferences;
        _draft = preferences.weights;
        _loading = false;
      });
    } on DiscoveryFailure catch (error) {
      if (!mounted) return;
      setState(() {
        _failure = error;
        _loading = false;
      });
    }
  }

  Future<void> _run(
    Future<RankingPreferenceSnapshot> Function() action,
    String success,
  ) async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _notice = null;
    });
    try {
      final result = await action();
      if (!mounted) return;
      setState(() {
        _saved = result;
        _draft = result.weights;
      });
      widget.onChanged?.call();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(success)));
    } on DiscoveryFailure catch (error) {
      if (!mounted) return;
      setState(() => _notice = error.message);
      if (error.kind == DiscoveryFailureKind.conflict) await _load();
      if (mounted) setState(() => _notice = error.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _reset() async {
    final saved = _saved;
    if (saved == null || _saving) return;
    if (!saved.personalized) {
      setState(() => _draft = saved.defaults);
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => BuyerDialog(
        title: const Text('Reset to Default?'),
        content: Text(widget.resetMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep mine'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Reset to Default'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _run(
      () => widget.reset(saved.version),
      'Ranking reset to the platform defaults.',
    );
  }

  void _set(String key, int value) =>
      setState(() => _draft = updateRankingWeight(_draft, key, value));

  @override
  Widget build(BuildContext context) {
    final saved = _saved;
    final total = _draft.values.fold(0, (a, b) => a + b);
    final allZero = total == 0;
    final changed = saved != null && !mapEquals(_draft, saved.weights);
    return Scaffold(
      appBar: buyerAppBar(context, widget.title),
      bottomNavigationBar: saved == null
          ? null
          : _footer(saved, allZero, changed),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: _body(),
          ),
        ),
      ),
    );
  }

  Widget _footer(RankingPreferenceSnapshot saved, bool allZero, bool changed) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: BuyerTheme.border)),
        ),
        child: SafeArea(
          top: false,
          child: Align(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Semantics(
                      liveRegion: true,
                      child: Row(
                        children: [
                          Icon(
                            allZero
                                ? LucideIcons.triangleAlert
                                : LucideIcons.circleCheck,
                            size: 16,
                            color: allZero
                                ? BuyerTheme.actionPressed
                                : BuyerTheme.successStrong,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              allZero
                                  ? 'Enable at least one criterion by setting its weight above zero.'
                                  : _saving
                                  ? 'Saving preferences…'
                                  : changed
                                  ? 'Save to apply your changes'
                                  : 'Preferences are up to date',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: !allZero && changed && !_saving
                          ? () => _run(
                              () => widget.save(_draft, saved.version),
                              'Ranking preferences saved.',
                            )
                          : null,
                      child: const Text('Save preferences'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    if (_loading && _saved == null) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SkeletonBox(height: 60),
          SizedBox(height: 12),
          SkeletonBox(height: 60),
          SizedBox(height: 12),
          SkeletonBox(height: 60),
        ],
      );
    }
    final saved = _saved;
    if (saved == null) {
      return SingleChildScrollView(
        child: StateMessage(
          kind: _failure?.kind == DiscoveryFailureKind.offline
              ? StateKind.offline
              : StateKind.error,
          title: 'Ranking preferences could not load',
          message: _failure?.message ?? 'Please retry.',
          actionLabel: 'Retry',
          onAction: _load,
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        if (_notice != null) ...[
          StatusBand(tone: BandTone.danger, title: _notice!),
          const SizedBox(height: 12),
        ],
        RankingInfluenceDashboard(weights: _draft, factors: widget.factors),
        const SizedBox(height: 12),
        Text(
          saved.personalized
              ? 'Personalized ranking is active'
              : 'Using the platform default weights',
          style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  'Adjust priorities',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: 'Reset to Default',
              child: TextButton.icon(
                onPressed:
                    (saved.personalized || !mapEquals(_draft, saved.weights)) &&
                        !_saving
                    ? _reset
                    : null,
                icon: const Icon(LucideIcons.rotateCcw, size: 16),
                label: const Text('Reset'),
                style: TextButton.styleFrom(foregroundColor: BuyerTheme.muted),
              ),
            ),
          ],
        ),
        const Text(
          'Weights do not need to total 100%. Set a factor to 0 to turn it off.',
          style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
        ),
        const SizedBox(height: 12),
        for (final (key, label, help) in widget.factors) ...[
          RankingPriorityControl(
            key: ValueKey('ranking-priority-$key'),
            factorKey: key,
            label: label,
            description: help,
            value: _draft[key] ?? 0,
            onChanged: _saving ? null : (value) => _set(key, value),
          ),
          const SizedBox(height: 12),
        ],
        Text(
          widget.description,
          style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
        ),
      ],
    );
  }
}
