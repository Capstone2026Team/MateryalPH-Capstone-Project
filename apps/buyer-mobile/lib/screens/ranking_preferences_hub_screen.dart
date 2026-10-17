import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../design_system/components/buyer_app_bar.dart';
import '../design_system/theme.dart';

/// Profile entry for ranking: Item-Based and Project-Based keep separate records, so each
/// opens its own editor. A null callback means that editor is not available in this session.
class RankingPreferencesHubScreen extends StatelessWidget {
  const RankingPreferencesHubScreen({
    super.key,
    this.onOpenItemBased,
    this.onOpenProjectBased,
  });
  final VoidCallback? onOpenItemBased;
  final VoidCallback? onOpenProjectBased;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: buyerAppBar(context, 'Ranking preferences'),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Text(
            'Choose how MateryalPH orders results. Item-Based and Project-Based ranking are saved separately.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: BuyerTheme.muted),
          ),
          const SizedBox(height: 16),
          Material(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: BuyerTheme.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                _RankingRow(
                  icon: LucideIcons.package,
                  title: 'Item-Based ranking',
                  description:
                      'Distance, price, Vendor Performance, stock and product rating for product search results.',
                  onTap: onOpenItemBased,
                ),
                const Divider(height: 1),
                _RankingRow(
                  icon: LucideIcons.clipboardList,
                  title: 'Project-Based ranking',
                  description:
                      'Material match, budget fit, distance and Vendor Performance for your Work Packages.',
                  onTap: onOpenProjectBased,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _RankingRow extends StatelessWidget {
  const _RankingRow({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: BuyerTheme.brandSoft,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: BuyerTheme.action),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    onTap == null ? 'Not available right now.' : description,
                    style: textTheme.bodyMedium?.copyWith(
                      color: BuyerTheme.muted,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 4, top: 10),
              child: Icon(
                LucideIcons.chevronRight,
                size: 20,
                color: BuyerTheme.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
