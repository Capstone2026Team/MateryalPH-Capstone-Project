import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../design_system/theme.dart';
import 'projects_repository.dart';
import 'work_package_material_widgets.dart';

/// Catalog suggestions shown at once; the Buyer types more to narrow further.
const maxVisibleMatches = 3;

const _unlistedExplanation =
    'Unlisted materials are never matched automatically and show as missing lines in system estimates.';

/// Catalog suggestions as a dense single-choice list, with the typed name kept
/// as an unlisted material at the end. Close matches show their similarity and
/// ask the Buyer to confirm the product.
class MaterialSearchResults extends StatelessWidget {
  const MaterialSearchResults({
    super.key,
    required this.matches,
    required this.searching,
    required this.query,
    required this.selectedId,
    required this.unlisted,
    required this.onChoose,
  });
  final List<api.ProjectMaterial> matches;
  final bool searching, unlisted;
  final String query;
  final String? selectedId;
  final ValueChanged<api.ProjectMaterial?> onChoose;

  @override
  Widget build(BuildContext context) {
    if (searching && matches.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 8),
        child: LinearProgressIndicator(),
      );
    }
    if (query.isEmpty) return const SizedBox.shrink();
    final visible = matches.take(maxVisibleMatches).toList();
    // A revised line keeps its current choice visible even past the cap.
    final chosen = matches.where((m) => m.id == selectedId).firstOrNull;
    if (chosen != null && !visible.contains(chosen)) visible.add(chosen);
    return Container(
      margin: const EdgeInsets.only(top: 8),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BuyerTheme.border),
      ),
      child: Column(
        children: [
          for (final m in visible) ...[
            _MatchTile(
              selected: m.id == selectedId,
              title: projectText(m.name),
              meta: _MatchMeta(match: m),
              note: m.matchType.name == 'FUZZY'
                  ? 'Confirm it is the same product as “${projectText(m.matchedText)}”.'
                  : null,
              onTap: () => onChoose(m),
            ),
            const Divider(height: 1),
          ],
          _MatchTile(
            selected: unlisted,
            title: matches.isEmpty
                ? 'No match — use “$query”'
                : 'Not listed — use “$query”',
            trailing: const Icon(
              LucideIcons.info,
              size: 18,
              color: BuyerTheme.muted,
            ),
            note: unlisted ? _unlistedExplanation : null,
            noteLines: 2,
            semanticsHint: _unlistedExplanation,
            onTap: () => onChoose(null),
          ),
        ],
      ),
    );
  }
}

/// The chosen material collapsed to one row; [onChange] re-opens the list.
class SelectedMaterialRow extends StatelessWidget {
  const SelectedMaterialRow({
    super.key,
    required this.material,
    required this.name,
    required this.onChange,
  });

  /// The catalog choice, or null for an unlisted material named [name].
  final api.ProjectMaterial? material;
  final String name;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final m = material;
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.fromLTRB(10, 0, 4, 8),
      decoration: BoxDecoration(
        color: BuyerTheme.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BuyerTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.radio_button_checked,
                size: 20,
                color: BuyerTheme.action,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  m == null ? name : projectText(m.name),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: onChange,
                child: Text(
                  'Change',
                  semanticsLabel: 'Change material',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: BuyerTheme.action,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          // Meta uses the full width under the title, aligned with it.
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 30, end: 8),
            child: m == null ? const UnlistedBadge() : _MatchMeta(match: m),
          ),
        ],
      ),
    );
  }
}

/// One line: regulated badge, match kind and category, ellipsized together.
class _MatchMeta extends StatelessWidget {
  const _MatchMeta({required this.match});
  final api.ProjectMaterial match;

  @override
  Widget build(BuildContext context) {
    final category = projectText(match.categoryName);
    return LayoutBuilder(
      builder: (context, constraints) => Row(
        children: [
          if (match.regulated == true) ...[
            // Leaves room for the match chip on very narrow rows.
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.6),
              child: const RegulatedBadge(),
            ),
            const SizedBox(width: 6),
          ],
          switch (match.matchType.name) {
            'EXACT' => const _MatchChip(label: 'Exact name', exact: true),
            'ALIAS' => _MatchChip(
              label: 'Also called “${projectText(match.matchedText)}”',
              exact: true,
            ),
            _ => _MatchChip(
              label:
                  'Close match ${((match.similarity as num? ?? 0) * 100).round()}%',
              exact: false,
            ),
          },
          if (category.isNotEmpty) ...[
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                category,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: BuyerTheme.muted),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MatchTile extends StatelessWidget {
  const _MatchTile({
    required this.selected,
    required this.title,
    required this.onTap,
    this.meta,
    this.note,
    this.noteLines = 1,
    this.trailing,
    this.semanticsHint,
  });
  final bool selected;
  final String title;
  final Widget? meta;
  final String? note;
  final int noteLines;
  final Widget? trailing;
  final String? semanticsHint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      button: true,
      hint: semanticsHint,
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: selected ? BuyerTheme.success.withValues(alpha: 0.08) : null,
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.fromLTRB(10, 8, 12, 8),
          child: Row(
            children: [
              ExcludeSemantics(
                child: Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  size: 20,
                  color: selected ? BuyerTheme.action : BuyerTheme.muted,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (meta != null) ...[const SizedBox(height: 2), meta!],
                    if (note != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        note!,
                        maxLines: noteLines,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: BuyerTheme.muted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                ExcludeSemantics(child: trailing!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MatchChip extends StatelessWidget {
  const _MatchChip({required this.label, required this.exact});
  final String label;
  final bool exact;

  @override
  Widget build(BuildContext context) => Flexible(
    fit: FlexFit.loose,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: exact
            ? BuyerTheme.success.withValues(alpha: 0.12)
            : BuyerTheme.brandSoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: exact ? BuyerTheme.successStrong : BuyerTheme.actionPressed,
        ),
      ),
    ),
  );
}

/// DTI-BPS regulated products need a PS Mark or ICC sticker on the Vendor side.
class RegulatedBadge extends StatelessWidget {
  const RegulatedBadge({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: BuyerTheme.action.withValues(alpha: 0.5)),
      color: BuyerTheme.brandSoft,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          LucideIcons.shieldCheck,
          size: 12,
          color: BuyerTheme.actionPressed,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            'DTI-BPS regulated',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: BuyerTheme.actionPressed,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
}
