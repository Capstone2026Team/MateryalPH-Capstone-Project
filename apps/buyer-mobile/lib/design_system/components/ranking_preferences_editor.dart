import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'procurement_components.dart';
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
  Map<String, int>? _dragBasis;
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
      builder: (context) => AlertDialog(
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

  void _set(String key, int value) => setState(
    () => _draft = rebalanceRankingWeights(
      _dragBasis ?? _draft,
      key,
      value,
      defaults: _saved!.defaults,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final saved = _saved;
    final total = _draft.values.fold(0, (a, b) => a + b);
    final remaining = 100 - total;
    final allZero = total == 0;
    final valid = total == 100;
    final changed = saved != null && !mapEquals(_draft, saved.weights);
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      bottomNavigationBar: saved == null
          ? null
          : SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Semantics(
                      liveRegion: true,
                      child: Row(
                        children: [
                          Icon(
                            valid
                                ? LucideIcons.circleCheck
                                : LucideIcons.triangleAlert,
                            size: 18,
                            color: valid
                                ? BuyerTheme.success
                                : BuyerTheme.actionPressed,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              allZero
                                  ? 'Total 0%. At least one weight must be above zero.'
                                  : valid
                                  ? 'Total 100%'
                                  : remaining > 0
                                  ? 'Total $total% — add $remaining% to reach 100%'
                                  : 'Total $total% — remove ${-remaining}% to reach 100%',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: valid && changed && !_saving
                          ? () => _run(
                              () => widget.save(_draft, saved.version),
                              'Ranking preferences saved.',
                            )
                          : null,
                      child: const Text('Save preferences'),
                    ),
                    TextButton(
                      onPressed: (saved.personalized || changed) && !_saving
                          ? _reset
                          : null,
                      child: const Text('Reset to Default'),
                    ),
                  ],
                ),
              ),
            ),
      body: SafeArea(child: _body()),
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
        StatusBand(
          tone: saved.personalized ? BandTone.warning : BandTone.info,
          title: saved.personalized
              ? 'Personalized ranking is active'
              : 'Using the platform default weights',
          message: widget.description,
        ),
        if (_notice != null) ...[
          const SizedBox(height: 8),
          StatusBand(tone: BandTone.danger, title: _notice!),
        ],
        for (final (key, label, help) in widget.factors) ...[
          SectionHeading(
            label,
            trailing: Text(
              '${(_draft[key] ?? 0)}%',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          Text(help, style: const TextStyle(color: BuyerTheme.muted)),
          Row(
            children: [
              IconButton(
                tooltip: 'Decrease $label',
                onPressed: !_saving && (_draft[key] ?? 0) > 0
                    ? () => _set(key, (_draft[key] ?? 0) - 1)
                    : null,
                icon: const Icon(LucideIcons.minus),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 14,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 26,
                    ),
                  ),
                  child: Slider(
                    value: (_draft[key] ?? 0).toDouble(),
                    max: 100,
                    divisions: 100,
                    label: '${(_draft[key] ?? 0)}%',
                    semanticFormatterCallback: (value) =>
                        '$label ${value.round()} percent',
                    onChangeStart: (_) => _dragBasis = _draft,
                    onChangeEnd: (_) => _dragBasis = null,
                    onChanged: _saving
                        ? null
                        : (value) => _set(key, value.round()),
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Increase $label',
                onPressed: !_saving && (_draft[key] ?? 0) < 100
                    ? () => _set(key, (_draft[key] ?? 0) + 1)
                    : null,
                icon: const Icon(LucideIcons.plus),
              ),
            ],
          ),
          Text(
            'Platform default ${saved.defaults[key]}%',
            style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
          ),
        ],
      ],
    );
  }
}
