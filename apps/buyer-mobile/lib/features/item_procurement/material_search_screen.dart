import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import 'explore_controller.dart';
import 'procurement_models.dart';

/// Search history belongs to the signed-in controller lifetime and is cleared on
/// sign-out. Suggestions never mutate the current catalog or add history entries.
class MaterialSearchScreen extends StatefulWidget {
  const MaterialSearchScreen({
    super.key,
    required this.controller,
    this.onSetLocation,
    this.filters,
  });
  final ExploreController controller;
  final VoidCallback? onSetLocation;
  final ListingFilters? filters;

  @override
  State<MaterialSearchScreen> createState() => _MaterialSearchScreenState();
}

class _MaterialSearchScreenState extends State<MaterialSearchScreen> {
  late final _query = TextEditingController(text: widget.controller.query);
  Timer? _debounce;
  int _sequence = 0;
  List<String> _suggestions = const [];
  String? _failure;
  bool _loading = false;
  late String _scope = _scopeKey;
  String get _scopeKey =>
      '${widget.controller.origin?.identity}|${widget.controller.radiusKm}';

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_changedScope);
    if (_query.text.isNotEmpty) _changed(_query.text);
  }

  void _changedScope() {
    if (_scope == _scopeKey) return;
    _scope = _scopeKey;
    _changed(_query.text);
  }

  void _changed(String value) {
    _debounce?.cancel();
    final sequence = ++_sequence;
    setState(() {
      _suggestions = const [];
      _failure = null;
      _loading = value.trim().isNotEmpty && widget.controller.origin != null;
    });
    if (!_loading) return;
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      try {
        final items = await widget.controller.suggestions(
          value,
          withinFilters: widget.filters,
        );
        if (mounted && sequence == _sequence) {
          setState(() {
            _suggestions = items;
            _loading = false;
          });
        }
      } on DiscoveryFailure catch (error) {
        if (mounted && sequence == _sequence) {
          setState(() {
            _failure = error.message;
            _loading = false;
          });
        }
      }
    });
  }

  void _submit(String value) {
    if (value.trim().isEmpty) return;
    Navigator.of(context).pop(value.trim());
  }

  @override
  void dispose() {
    widget.controller.removeListener(_changedScope);
    _debounce?.cancel();
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
            child: Row(
              children: [
                RoundIconButton(
                  icon: LucideIcons.arrowLeft,
                  tooltip: 'Back',
                  filled: true,
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
                Expanded(
                  child: PillSearchField(
                    controller: _query,
                    autofocus: true,
                    onChanged: _changed,
                    onSubmitted: _submit,
                    onSearch: () => _submit(_query.text),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _body()),
        ],
      ),
    ),
  );

  Widget _body() {
    final radius = widget.controller.radiusKm;
    if (_query.text.trim().isEmpty) {
      final recent = widget.controller.recentSearches;
      if (recent.isEmpty) {
        return const _Centered(
          child: StateMessage(
            kind: StateKind.empty,
            artwork: 'assets/states/location.png',
            title: 'Search any materials',
            message:
                'Type a material, brand or store. Results come from Verified Vendors within your selected radius.',
          ),
        );
      }
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Recent searches',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: BuyerTheme.muted,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  widget.controller.clearRecentSearches();
                  setState(() {});
                },
                style: TextButton.styleFrom(
                  foregroundColor: BuyerTheme.muted,
                  textStyle: const TextStyle(fontFamily: 'Inter', fontSize: 13),
                ),
                child: const Text('Clear'),
              ),
            ],
          ),
          for (final term in recent)
            _TermRow(term: term, icon: LucideIcons.history, onTap: _submit),
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              'Searches from your current session.',
              style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
            ),
          ),
        ],
      );
    }
    if (widget.controller.origin == null) {
      return _Centered(
        child: StateMessage(
          kind: StateKind.needsLocation,
          artwork: 'assets/states/location.png',
          title: 'Choose a location first',
          message:
              'Pick a saved location or a map pin to search nearby Verified Vendors. GPS is not required.',
          actionLabel: 'Set location',
          onAction: widget.onSetLocation,
        ),
      );
    }
    if (_loading) {
      return const Align(
        alignment: Alignment.topCenter,
        child: LinearProgressIndicator(),
      );
    }
    if (_failure != null) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          StatusBand(
            tone: BandTone.warning,
            title: 'Suggestions could not load',
            message: _failure,
            action: TextButton(
              onPressed: () => _changed(_query.text),
              child: const Text('Retry'),
            ),
          ),
        ],
      );
    }
    if (_suggestions.isEmpty) {
      return _Centered(
        child: StateMessage(
          kind: StateKind.empty,
          artwork: 'assets/states/location.png',
          title: 'Search not found',
          message:
              'No matching materials within $radius km using the current filters. Search anyway to change the filters or radius.',
          actionLabel: 'Search for “${_query.text.trim()}”',
          onAction: () => _submit(_query.text),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        for (final term in _suggestions) _TermRow(term: term, onTap: _submit),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => _submit(_query.text),
            icon: const Icon(LucideIcons.search, size: 18),
            label: Text('Search for “${_query.text.trim()}”'),
          ),
        ),
      ],
    );
  }
}

class _TermRow extends StatelessWidget {
  const _TermRow({required this.term, required this.onTap, this.icon});

  final String term;
  final ValueChanged<String> onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => onTap(term),
    child: Container(
      constraints: const BoxConstraints(minHeight: 48),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: BuyerTheme.border)),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: BuyerTheme.muted),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              term,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    ),
  );
}

class _Centered extends StatelessWidget {
  const _Centered({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: Center(child: child),
      ),
    ),
  );
}
