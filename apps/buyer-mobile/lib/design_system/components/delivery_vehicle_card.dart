import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../features/orders/order_models.dart';
import '../theme.dart';

String _measurement(String value) => value.contains('.')
    ? value.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '')
    : value;

/// Display-only vehicle details. Status describes the order arrangement, never live fleet availability.
class BuyerDeliveryVehicleCard extends StatelessWidget {
  const BuyerDeliveryVehicleCard({
    super.key,
    required this.vehicle,
    required this.status,
    this.photo,
  });

  final ConfirmedVehicleView vehicle;
  final String status;
  final Widget? photo;

  @override
  Widget build(BuildContext context) {
    final details = [
      if (vehicle.vehicleType != null)
        vehicle.vehicleType!.replaceAll('_', ' ').toLowerCase(),
      if (vehicle.brand != null) vehicle.brand!,
      if (vehicle.capacityKg != null)
        '${_measurement(vehicle.capacityKg!)} kg payload',
      if (vehicle.mixerCapacityM3 != null)
        '${_measurement(vehicle.mixerCapacityM3!)} m³ mixer',
      if (vehicle.cargoDimensions != null && vehicle.mixerCapacityM3 == null)
        '${vehicle.cargoDimensions!.split(' × ').map(_measurement).join(' × ')} m cargo',
      if (vehicle.heavyClassification == 'HEAVY') 'Heavy vehicle',
      if (vehicle.heavyClassification == 'NOT_HEAVY') 'Not a heavy vehicle',
    ];
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: BuyerTheme.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 88,
              height: 76,
              child:
                  photo ??
                  const ColoredBox(
                    color: BuyerTheme.canvas,
                    child: Icon(LucideIcons.truck, color: BuyerTheme.muted),
                  ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                if (details.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      details.join(' · '),
                      style: const TextStyle(
                        fontSize: 12,
                        color: BuyerTheme.muted,
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  '${vehicle.vehicles} vehicle${vehicle.vehicles == 1 ? '' : 's'} · ${vehicle.trips} trip${vehicle.trips == 1 ? '' : 's'}',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (vehicle.imageFileId == null)
                  const Text(
                    'Vehicle photo not recorded',
                    style: TextStyle(fontSize: 11, color: BuyerTheme.muted),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
