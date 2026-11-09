import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../features/trust/trust_models.dart' show StoreBadgeView;
import '../theme.dart';
export '../../core/vendor_score_display.dart';

class VendorRatingValue extends StatelessWidget {
  const VendorRatingValue({super.key, required this.score, this.style});

  final String score;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Vendor Performance Score $score out of 5',
    excludeSemantics: true,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star_rounded,
          size: 17,
          color: style?.color ?? BuyerTheme.action,
        ),
        const SizedBox(width: 3),
        Text(
          score,
          style: style ?? const TextStyle(fontWeight: FontWeight.w700),
        ),
      ],
    ),
  );
}

/// Public awards only. Callers pass the server's active, unsuppressed badges.
class VendorBadges extends StatelessWidget {
  const VendorBadges({super.key, required this.badges, this.compact = false});

  final List<StoreBadgeView> badges;
  final bool compact;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      for (final badge in badges)
        if (compact)
          Tooltip(
            message:
                '${badge.name}${badge.scopeLabel == null ? '' : ' · ${badge.scopeLabel}'}\n${badge.description}',
            child: Semantics(
              label:
                  'Earned badge: ${badge.name}${badge.scopeLabel == null ? '' : ', ${badge.scopeLabel}'}. ${badge.description}',
              excludeSemantics: true,
              child: Container(
                padding: const EdgeInsets.fromLTRB(5, 3, 9, 3),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(color: BuyerTheme.border),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    VendorBadgeEmblem(code: badge.code, size: 27),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        badge.scopeLabel == null
                            ? badge.name
                            : '${badge.name} · ${badge.scopeLabel}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          Semantics(
            label:
                'Earned badge: ${badge.name}${badge.scopeLabel == null ? '' : ', ${badge.scopeLabel}'}. ${badge.description}',
            excludeSemantics: true,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border.all(color: BuyerTheme.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VendorBadgeEmblem(code: badge.code),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          badge.scopeLabel == null
                              ? badge.name
                              : '${badge.name} · ${badge.scopeLabel}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(
                              LucideIcons.circleCheck,
                              size: 12,
                              color: BuyerTheme.successStrong,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Earned',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: BuyerTheme.successStrong,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          badge.description,
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.4,
                            color: BuyerTheme.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    ],
  );
}

/// Scalable medal artwork shared by Store Profile and Vendor selection.
class VendorBadgeEmblem extends StatelessWidget {
  const VendorBadgeEmblem({super.key, required this.code, this.size = 44});

  final String code;
  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox(
      width: size,
      height: size * 76 / 64,
      child: CustomPaint(
        painter: const _MedalPainter(),
        child: Align(
          alignment: const Alignment(0, -0.22),
          child: Icon(
            switch (code) {
              'FAST_RESPONDER' => LucideIcons.messageCircle,
              'HIGHLY_RATED' => LucideIcons.star,
              'HIGH_QUALITY_MATERIALS' => LucideIcons.badgeCheck,
              'MOST_ORDERED' => LucideIcons.trendingUp,
              'ON_TIME' => LucideIcons.timer,
              'TRUSTED_SUPPLIER' => LucideIcons.shieldCheck,
              _ => LucideIcons.award,
            },
            size: size * 0.38,
            color: BuyerTheme.actionPressed,
          ),
        ),
      ),
    ),
  );
}

class _MedalPainter extends CustomPainter {
  const _MedalPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 64, size.height / 76);
    final ribbon = Path()
      ..moveTo(18, 46)
      ..lineTo(15, 71)
      ..lineTo(32, 62)
      ..lineTo(49, 71)
      ..lineTo(46, 46)
      ..close();
    canvas.drawPath(ribbon, Paint()..color = BuyerTheme.brandSoft);
    final outline = Paint()
      ..color = BuyerTheme.action
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(ribbon, outline);
    final seal = Path()..moveTo(32, 3);
    for (final point in const [
      Offset(40, 8),
      Offset(49, 9),
      Offset(53, 17),
      Offset(59, 24),
      Offset(57, 34),
      Offset(58, 43),
      Offset(50, 49),
      Offset(44, 57),
      Offset(32, 56),
      Offset(22, 57),
      Offset(15, 49),
      Offset(7, 43),
      Offset(8, 34),
      Offset(6, 24),
      Offset(12, 17),
      Offset(16, 9),
      Offset(25, 8),
    ]) {
      seal.lineTo(point.dx, point.dy);
    }
    seal.close();
    canvas.drawPath(seal, Paint()..color = BuyerTheme.brandSoft);
    canvas.drawPath(seal, outline);
    canvas.drawCircle(const Offset(32, 30), 18, Paint()..color = Colors.white);
    canvas.drawCircle(
      const Offset(32, 30),
      18,
      outline..color = BuyerTheme.action.withValues(alpha: 0.35),
    );
  }

  @override
  bool shouldRepaint(_MedalPainter oldDelegate) => false;
}
