import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../features/trust/trust_models.dart';
import '../theme.dart';

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// "2026-10-04" → "Oct 4" (or "Oct 4, 2026" when [year] is true). Analytics dates are calendar days.
String analyticsDayLabel(String date, {bool year = false}) {
  final parts = date.split('-');
  if (parts.length != 3) return date;
  final month = int.tryParse(parts[1]) ?? 1;
  final day = int.tryParse(parts[2]) ?? 1;
  return '${_months[(month - 1).clamp(0, 11)]} $day${year ? ', ${parts[0]}' : ''}';
}

/// "1234.5" → "₱1,234.50"; null → "—".
String pesoDecimal(String? value) {
  final number = value == null ? null : double.tryParse(value);
  if (number == null) return '—';
  final fixed = number.toStringAsFixed(2);
  final whole = fixed.split('.').first;
  final grouped = whole.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  return '₱$grouped.${fixed.split('.').last}';
}

/// Direction as text plus an icon; a null percentage shows its reason instead of a number.
class TrendText extends StatelessWidget {
  const TrendText({super.key, required this.trend, this.compact = false});

  final AnalyticsTrendView trend;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final percent = trend.changePercent;
    if (percent == null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(LucideIcons.minus, size: 16, color: BuyerTheme.muted),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              trend.label ?? 'Insufficient Local Data',
              style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
            ),
          ),
        ],
      );
    }
    final direction = trend.direction ?? 'NO_MATERIAL_CHANGE';
    final icon = switch (direction) {
      'INCREASING' => LucideIcons.trendingUp,
      'DECREASING' => LucideIcons.trendingDown,
      _ => LucideIcons.minus,
    };
    final word = switch (direction) {
      'INCREASING' => 'Increasing',
      'DECREASING' => 'Decreasing',
      _ => 'No material change',
    };
    final sign = percent.startsWith('-') || percent == '0.00' ? '' : '+';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: BuyerTheme.ink),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                '$sign$percent% · $word',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        if (!compact && trend.startDate != null && trend.endDate != null)
          Text(
            '${analyticsDayLabel(trend.startDate!, year: true)} → ${analyticsDayLabel(trend.endDate!, year: true)}',
            style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
          ),
        if (trend.compositionChanged == true)
          Text(
            compact
                ? 'Sellers changed'
                : (trend.compositionNote ??
                      'Participating sellers changed between the dates.'),
            style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
          ),
      ],
    );
  }
}

/// Explicit null state: never an empty chart or a fabricated line.
class AnalyticsNullCard extends StatelessWidget {
  const AnalyticsNullCard({
    super.key,
    required this.title,
    required this.reason,
  });

  final String title;
  final String reason;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: '$title. $reason',
    excludeSemantics: true,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
              const Icon(LucideIcons.eyeOff, size: 18, color: BuyerTheme.muted),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            reason,
            style: const TextStyle(fontSize: 13, color: BuyerTheme.muted),
          ),
        ],
      ),
    ),
  );
}

/// MAT-06 graph + synchronized sortable table. Gaps break the line (hatched band); a triangle marks a
/// change in participating sellers; tapping the graph or a table row shows that day's exact values.
class PriceTrendPanel extends StatefulWidget {
  const PriceTrendPanel({
    super.key,
    required this.title,
    required this.unit,
    required this.points,
    required this.emptyReason,
  });

  final String title;
  final String unit;
  final List<AnalyticsPointView> points;
  final String emptyReason;

  @override
  State<PriceTrendPanel> createState() => _PriceTrendPanelState();
}

class _PriceTrendPanelState extends State<PriceTrendPanel> {
  String? _focused;
  bool _byValue = false;
  bool _ascending = false;

  @override
  Widget build(BuildContext context) {
    final points = widget.points;
    final valued = points.where((point) => point.hasValue).length;
    if (valued == 0) {
      return AnalyticsNullCard(
        title: 'No graph for this period',
        reason: widget.emptyReason,
      );
    }
    final focus = _focused == null
        ? null
        : points.where((point) => point.date == _focused).firstOrNull;
    final rows = [...points]
      ..sort((a, b) {
        final order = _byValue
            ? (double.tryParse(a.average ?? '') ?? double.infinity).compareTo(
                double.tryParse(b.average ?? '') ?? double.infinity,
              )
            : a.date.compareTo(b.date);
        return _ascending ? order : -order;
      });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label:
              '${widget.title}. $valued days with an average and ${points.length - valued} days without one, in pesos per ${widget.unit}. The table below lists every value.',
          image: true,
          excludeSemantics: true,
          child: LayoutBuilder(
            builder: (context, constraints) => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (details) {
                if (points.isEmpty) return;
                final usable = constraints.maxWidth - 56;
                final step = points.length == 1
                    ? usable
                    : usable / (points.length - 1);
                final index = ((details.localPosition.dx - 48) / step)
                    .round()
                    .clamp(0, points.length - 1);
                setState(() => _focused = points[index].date);
              },
              child: CustomPaint(
                size: Size(constraints.maxWidth, 200),
                painter: _TrendPainter(points: points, focused: _focused),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Semantics(
          liveRegion: true,
          child: Text(
            focus == null
                ? 'Tap the graph or a row to read exact values. Hatched bands are days without a value; ▲ marks a change in sellers.'
                : '${analyticsDayLabel(focus.date, year: true)} · ${focus.hasValue ? '${pesoDecimal(focus.average)} per ${widget.unit}${focus.vendorCount == null ? '' : ' · ${focus.vendorCount} seller${focus.vendorCount == 1 ? '' : 's'}'}' : (focus.label ?? 'No value for this date')}${focus.participantsChanged == true ? ' · Sellers changed' : ''}',
            style: TextStyle(
              fontSize: 13,
              color: focus == null ? BuyerTheme.muted : BuyerTheme.ink,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _SortButton(
              label: 'Date',
              active: !_byValue,
              ascending: _ascending,
              onPressed: () => setState(() {
                _ascending = !_byValue ? !_ascending : false;
                _byValue = false;
              }),
            ),
            const SizedBox(width: 8),
            _SortButton(
              label: 'Average',
              active: _byValue,
              ascending: _ascending,
              onPressed: () => setState(() {
                _ascending = _byValue ? !_ascending : true;
                _byValue = true;
              }),
            ),
          ],
        ),
        const Divider(height: 1),
        for (final point in rows)
          Semantics(
            button: true,
            selected: point.date == _focused,
            label:
                '${analyticsDayLabel(point.date, year: true)}, ${point.hasValue ? '${pesoDecimal(point.average)} per ${widget.unit}' : (point.label ?? 'no value')}${point.vendorCount == null || !point.hasValue ? '' : ', ${point.vendorCount} sellers'}${point.participantsChanged == true ? ', sellers changed' : ''}',
            excludeSemantics: true,
            child: InkWell(
              onTap: () => setState(() => _focused = point.date),
              child: Container(
                constraints: const BoxConstraints(minHeight: 44),
                color: point.date == _focused ? BuyerTheme.brandSoft : null,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        analyticsDayLabel(point.date, year: true),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        point.hasValue ? pesoDecimal(point.average) : '—',
                        style: const TextStyle(
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        [
                          if (point.hasValue && point.vendorCount != null)
                            '${point.vendorCount} seller${point.vendorCount == 1 ? '' : 's'}',
                          if (!point.hasValue || point.status == 'LIMITED_DATA')
                            point.label ?? '',
                          if (point.participantsChanged == true)
                            'Sellers changed',
                        ].where((text) => text.isNotEmpty).join(' · '),
                        style: const TextStyle(
                          fontSize: 12,
                          color: BuyerTheme.muted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _SortButton extends StatelessWidget {
  const _SortButton({
    required this.label,
    required this.active,
    required this.ascending,
    required this.onPressed,
  });

  final String label;
  final bool active;
  final bool ascending;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => TextButton.icon(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      minimumSize: const Size(44, 44),
      foregroundColor: BuyerTheme.ink,
    ),
    icon: Icon(
      active
          ? (ascending ? LucideIcons.arrowUp : LucideIcons.arrowDown)
          : LucideIcons.arrowUpDown,
      size: 16,
    ),
    label: Text(
      'Sort by $label',
      semanticsLabel:
          'Sort by $label${active ? (ascending ? ', ascending' : ', descending') : ''}',
    ),
  );
}

class _TrendPainter extends CustomPainter {
  _TrendPainter({required this.points, required this.focused});

  final List<AnalyticsPointView> points;
  final String? focused;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 48.0, right = 8.0, top = 8.0, bottom = 24.0;
    final values = points
        .map((point) => double.tryParse(point.average ?? ''))
        .toList();
    final numeric = values.whereType<double>().toList();
    if (numeric.isEmpty) return;
    var low = numeric.reduce(math.min), high = numeric.reduce(math.max);
    final pad = high == low ? math.max(1, high * 0.05) : (high - low) * 0.12;
    low = math.max(0, low - pad);
    high = high + pad;
    final width = size.width - left - right,
        height = size.height - top - bottom;
    double x(int index) =>
        left +
        (points.length == 1 ? width / 2 : index * width / (points.length - 1));
    double y(double value) => top + (1 - (value - low) / (high - low)) * height;
    final grid = Paint()
      ..color = BuyerTheme.border
      ..strokeWidth = 1;
    final textStyle = const TextStyle(
      fontFamily: 'Inter',
      fontSize: 10,
      color: BuyerTheme.muted,
    );
    for (final tick in [low, (low + high) / 2, high]) {
      canvas.drawLine(
        Offset(left, y(tick)),
        Offset(size.width - right, y(tick)),
        grid,
      );
      final painter = TextPainter(
        text: TextSpan(
          text: pesoDecimal(tick.toStringAsFixed(2)),
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, Offset(0, y(tick) - 6));
    }
    final hatch = Paint()
      ..color = BuyerTheme.border
      ..strokeWidth = 2;
    for (var index = 0; index < points.length; index++) {
      if (values[index] != null) continue;
      for (var offset = 0.0; offset < height; offset += 6) {
        canvas.drawLine(
          Offset(x(index) - 4, top + offset),
          Offset(x(index) + 4, top + offset + 6),
          hatch,
        );
      }
    }
    final line = Paint()
      ..color = BuyerTheme.action
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    Path? path;
    for (var index = 0; index < points.length; index++) {
      final value = values[index];
      if (value == null) {
        if (path != null) canvas.drawPath(path, line);
        path = null;
        continue;
      }
      path = path == null
          ? (Path()..moveTo(x(index), y(value)))
          : (path..lineTo(x(index), y(value)));
    }
    if (path != null) canvas.drawPath(path, line);
    final fill = Paint()..color = Colors.white;
    for (var index = 0; index < points.length; index++) {
      final value = values[index];
      if (value == null) continue;
      final center = Offset(x(index), y(value));
      final radius = points[index].date == focused ? 6.0 : 4.0;
      canvas.drawCircle(center, radius, fill);
      canvas.drawCircle(center, radius, line);
      if (points[index].participantsChanged == true) {
        final marker = Path()
          ..moveTo(center.dx, center.dy - 16)
          ..lineTo(center.dx + 5, center.dy - 8)
          ..lineTo(center.dx - 5, center.dy - 8)
          ..close();
        canvas.drawPath(marker, Paint()..color = BuyerTheme.ink);
      }
    }
    final labelEvery = math.max(1, (points.length / 4).ceil());
    for (var index = 0; index < points.length; index++) {
      // The last date is labelled only when it is not crowded against the previous label.
      final last =
          index == points.length - 1 &&
          (index % labelEvery == 0 || index % labelEvery > labelEvery / 2);
      if (index % labelEvery != 0 && !last) continue;
      final painter = TextPainter(
        text: TextSpan(
          text: analyticsDayLabel(points[index].date),
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(
        canvas,
        Offset(
          (x(index) - painter.width / 2).clamp(0, size.width - painter.width),
          size.height - 14,
        ),
      );
    }
    final focusIndex = points.indexWhere((point) => point.date == focused);
    if (focusIndex >= 0) {
      canvas.drawLine(
        Offset(x(focusIndex), top),
        Offset(x(focusIndex), top + height),
        Paint()
          ..color = BuyerTheme.muted
          ..strokeWidth = 1,
      );
    }
  }

  @override
  bool shouldRepaint(_TrendPainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.focused != focused;
}
