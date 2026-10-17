import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

import '../../design_system/theme.dart';
import '../item_procurement/procurement_models.dart' show formatQuantity;

/// The latest free site inspection in a store conversation (owner decision
/// 2026-10-16). The store schedules the visit, then quotes the measured volume
/// in this conversation; the Buyer may cancel while it is still open.
class SiteInspectionCard extends StatelessWidget {
  const SiteInspectionCard({
    super.key,
    required this.inspection,
    required this.busy,
    required this.onCancel,
  });

  final api.SiteInspection inspection;
  final bool busy;
  final VoidCallback onCancel;

  static const _status = {
    'REQUESTED': 'Requested · waiting for the store',
    'SCHEDULED': 'Scheduled',
    'COMPLETED': 'Inspected',
    'DECLINED': 'Declined by the store',
    'CANCELLED': 'Cancelled',
  };

  @override
  Widget build(BuildContext context) {
    final status = inspection.status.name;
    final localizations = MaterialLocalizations.of(context);
    final scheduled = inspection.scheduledFor?.toUtc().add(
      const Duration(hours: 8),
    );
    final preferred = inspection.preferredDate.toDateTime();
    final site = inspection.site.label ?? inspection.site.formattedAddress;
    final volume = inspection.measuredVolumeM3;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: BuyerTheme.canvas,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BuyerTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.ruler, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Semantics(
                  header: true,
                  child: const Text(
                    'Free site inspection',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Text(
                _status[status] ?? status,
                style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            [
              inspection.listing.displayName,
              ?inspection.variant?.label,
            ].join(' · '),
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          if (site != null)
            Text('Site: $site', style: const TextStyle(fontSize: 13)),
          Text(
            scheduled != null
                ? 'Visit: ${localizations.formatMediumDate(scheduled)}, ${localizations.formatTimeOfDay(TimeOfDay.fromDateTime(scheduled))} (Philippine time)'
                : 'Preferred date: ${localizations.formatMediumDate(preferred)}',
            style: const TextStyle(fontSize: 13),
          ),
          if (volume != null)
            Text(
              'Measured volume: ${formatQuantity(volume)} m³. The store will send a quotation for it here.',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          if (inspection.vendorNote != null)
            Text(
              'Store: ${inspection.vendorNote}',
              style: const TextStyle(fontSize: 13, color: BuyerTheme.muted),
            ),
          if (inspection.actions.cancel)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: busy ? null : onCancel,
                child: const Text('Cancel request'),
              ),
            ),
        ],
      ),
    );
  }
}
