import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../design_system/components/procurement_components.dart';
import '../../design_system/generated/color_tokens.dart';
import '../../design_system/theme.dart';
import 'projects_repository.dart';

const _info = Color(MateryalColorTokens.statusInfo);

/// Work Package lifecycle status as a coloured pill.
class WorkPackageStatusChip extends StatelessWidget {
  const WorkPackageStatusChip(this.status, {super.key});
  final String status;

  @override
  Widget build(BuildContext context) {
    final error = Theme.of(context).colorScheme.error;
    final (Color fg, IconData icon) = switch (status) {
      'DRAFT' => (BuyerTheme.muted, LucideIcons.pencilLine),
      'ACTIVE' || 'QUOTATION_INQUIRY' => (_info, LucideIcons.search),
      'COMPLETED' => (BuyerTheme.successStrong, LucideIcons.circleCheck),
      'CANCELLED' => (error, LucideIcons.circleX),
      _ => (BuyerTheme.actionPressed, LucideIcons.truck),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: fg.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 4),
          Text(
            projectStatus(status),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: fg,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// A Work Package in the Project list.
class WorkPackageCard extends StatelessWidget {
  const WorkPackageCard({
    super.key,
    required this.package,
    required this.onTap,
  });
  final ProjectData package;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: BuyerTheme.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: BuyerTheme.brandSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    LucideIcons.layers,
                    size: 20,
                    color: BuyerTheme.actionPressed,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        projectText(package['name']),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          WorkPackageStatusChip(projectText(package['status'])),
                          Text(
                            projectMoney(package['budget_centavos']),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(LucideIcons.chevronRight, color: BuyerTheme.muted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// How much of the Project budget is allocated to Work Packages (owner
/// decision 2026-10-12: every non-cancelled package, Drafts included).
class AllocationSummary extends StatelessWidget {
  const AllocationSummary({super.key, required this.budget});
  final ProjectData budget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = projectInt(budget['budget_centavos']);
    final allocated = projectInt(budget['allocated_centavos']);
    final available = projectInt(budget['unallocated_centavos']);
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
          Text(
            'Available for new Work Packages',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: BuyerTheme.muted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            projectMoney(available),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ExcludeSemantics(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: total <= 0 ? 0 : (allocated / total).clamp(0, 1),
                minHeight: 8,
                color: BuyerTheme.action,
                backgroundColor: BuyerTheme.border,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${projectMoney(allocated)} allocated of ${projectMoney(total)}',
            style: theme.textTheme.bodySmall?.copyWith(color: BuyerTheme.muted),
          ),
        ],
      ),
    );
  }
}

class WorkPackagesEmptyState extends StatelessWidget {
  const WorkPackagesEmptyState({super.key});

  @override
  Widget build(BuildContext context) => const StateMessage(
    kind: StateKind.empty,
    compact: true,
    title: 'No Work Packages yet',
    message:
        'Add a Work Package to list materials and compare eligible Vendors.',
  );
}
