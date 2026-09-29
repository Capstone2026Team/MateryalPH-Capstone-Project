import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import 'procurement_models.dart';
import 'procurement_repository.dart';

/// Item-Based ranking preferences. The five SRS weights are whole percentages that must total
/// exactly 100 (never all zero); the total and the remaining amount update live. Saving stores a
/// separate Buyer override; Reset to Default removes it so platform defaults apply again.
class RankingPreferencesScreen extends StatefulWidget {
  const RankingPreferencesScreen({super.key, required this.repository});

  final ProcurementRepository repository;

  @override
  State<RankingPreferencesScreen> createState() =>
      _RankingPreferencesScreenState();
}

class _RankingPreferencesScreenState extends State<RankingPreferencesScreen> {
  static const _components = [
    ('distance', 'Distance', 'Closer stores score higher within your radius.'),
    ('price', 'Price', 'Lower price than comparable offers scores higher.'),
    (
      'vps',
      'Vendor Performance (VPS)',
      'Earned Vendor score; new Vendors use a neutral value.',
    ),
    ('stock', 'Stock', 'In Stock scores higher than Limited Stock.'),
    (
      'product_rating',
      'Product Rating',
      'Verified product ratings; unrated products use a neutral value.',
    ),
  ];

  RankingPreferencesView? _saved;
  RankingWeights _draft = RankingWeights.approvedDefault;
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
      final preferences = await widget.repository.preferences();
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
    Future<RankingPreferencesView> Function() action,
    String success,
  ) async {
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
    if (saved == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Default?'),
        content: const Text(
          'Best Deal will use the current platform weights again. Your personal weights are removed.',
        ),
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
      () => widget.repository.resetPreferences(version: saved.version),
      'Ranking reset to the platform defaults.',
    );
  }

  void _set(String key, int value) =>
      setState(() => _draft = _draft.withValue(key, value.clamp(0, 100)));

  @override
  Widget build(BuildContext context) {
    final saved = _saved;
    final total = _draft.total;
    final remaining = 100 - total;
    final allZero = total == 0;
    final valid = _draft.valid;
    final changed = saved != null && _draft != saved.weights;
    return Scaffold(
      appBar: AppBar(title: const Text('Ranking preferences')),
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
                              () => widget.repository.savePreferences(
                                _draft,
                                version: saved.version,
                              ),
                              'Ranking preferences saved.',
                            )
                          : null,
                      child: const Text('Save preferences'),
                    ),
                    TextButton(
                      onPressed: saved.personalized && !_saving ? _reset : null,
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
      return StateMessage(
        kind: _failure?.kind == DiscoveryFailureKind.offline
            ? StateKind.offline
            : StateKind.error,
        title: 'Ranking preferences could not load',
        message: _failure?.message ?? 'Please retry.',
        actionLabel: 'Retry',
        onAction: _load,
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
          message:
              'Best Deal combines these five scores as a weighted sum. Favorites never change it; use Favorites First to see them first.',
        ),
        if (_notice != null) ...[
          const SizedBox(height: 8),
          StatusBand(tone: BandTone.danger, title: _notice!),
        ],
        for (final (key, label, help) in _components) ...[
          SectionHeading(
            label,
            trailing: Text(
              '${_draft.valueOf(key)}%',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          Text(help, style: const TextStyle(color: BuyerTheme.muted)),
          Row(
            children: [
              IconButton(
                tooltip: 'Decrease $label',
                onPressed: _draft.valueOf(key) > 0
                    ? () => _set(key, _draft.valueOf(key) - 1)
                    : null,
                icon: const Icon(LucideIcons.minus),
              ),
              Expanded(
                child: Slider(
                  value: _draft.valueOf(key).toDouble(),
                  max: 100,
                  divisions: 100,
                  label: '${_draft.valueOf(key)}%',
                  semanticFormatterCallback: (value) =>
                      '$label ${value.round()} percent',
                  onChanged: (value) => _set(key, value.round()),
                ),
              ),
              IconButton(
                tooltip: 'Increase $label',
                onPressed: _draft.valueOf(key) < 100
                    ? () => _set(key, _draft.valueOf(key) + 1)
                    : null,
                icon: const Icon(LucideIcons.plus),
              ),
            ],
          ),
          Text(
            'Platform default ${saved.defaults.valueOf(key)}%',
            style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
          ),
        ],
      ],
    );
  }
}
