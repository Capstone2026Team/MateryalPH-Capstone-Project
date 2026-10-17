import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import '../map_discovery/discovery_repository.dart' show newIdempotencyKey;

/// Sends the request; returns the store conversation it was posted in.
typedef SiteInspectionSubmit =
    Future<String> Function({
      required String locationId,
      required DateTime preferredDate,
      required String key,
      String? notes,
    });

/// Free Site Inspection / Estimate for ready-mixed concrete (owner decision
/// 2026-10-16). For Buyers who do not yet know the volume: the store visits a
/// saved site and then sends a quotation for the measured volume in Messages.
/// Pops with the conversation id once the request is sent.
class SiteInspectionSheet extends StatefulWidget {
  const SiteInspectionSheet({
    super.key,
    required this.productName,
    required this.storeName,
    required this.locations,
    required this.submit,
    this.initialLocationId,
    this.today,
  });

  final String productName;
  final String storeName;
  final List<SavedLocationView> locations;
  final SiteInspectionSubmit submit;
  final String? initialLocationId;

  /// The Philippine date to start from; injectable for tests.
  final DateTime? today;

  /// The furthest preferred date the store accepts.
  static const maxDays = 60;

  @override
  State<SiteInspectionSheet> createState() => _SiteInspectionSheetState();
}

class _SiteInspectionSheetState extends State<SiteInspectionSheet> {
  late String? _locationId =
      widget.locations.any((item) => item.id == widget.initialLocationId)
      ? widget.initialLocationId
      : widget.locations.firstOrNull?.id;
  late final DateTime _today = widget.today ?? _manilaToday();
  late DateTime _date = _today.add(const Duration(days: 1));
  final _notes = TextEditingController();
  bool _busy = false;
  String? _error;

  /// One key per request attempt, reused for its retries.
  final String _key = newIdempotencyKey();

  static DateTime _manilaToday() {
    final now = DateTime.now().toUtc().add(const Duration(hours: 8));
    return DateTime(now.year, now.month, now.day);
  }

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: _today,
      lastDate: _today.add(const Duration(days: SiteInspectionSheet.maxDays)),
      helpText: 'Preferred inspection date',
    );
    if (picked != null && mounted) setState(() => _date = picked);
  }

  Future<void> _send() async {
    final location = _locationId;
    if (location == null) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final conversation = await widget.submit(
        locationId: location,
        preferredDate: _date,
        key: _key,
        notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      );
      if (mounted) Navigator.pop(context, conversation);
    } on DiscoveryFailure catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'The request was not sent. Please retry.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        8,
        16,
        16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: const Text(
                      'Request a free site inspection',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Close',
                  onPressed: _busy ? null : () => Navigator.pop(context),
                  icon: const Icon(LucideIcons.x),
                ),
              ],
            ),
            Text(
              '${widget.storeName} visits your site to estimate the concrete volume for ${widget.productName}, then sends you a quotation in Messages. The inspection is free and nothing is ordered until you accept the quotation.',
              style: const TextStyle(fontSize: 13, color: BuyerTheme.muted),
            ),
            const SizedBox(height: 16),
            if (widget.locations.isEmpty)
              const StatusBand(
                tone: BandTone.warning,
                title: 'Save your site first',
                message:
                    'Add the construction site as a saved location on the Map, then request the inspection.',
              )
            else
              DropdownButtonFormField<String>(
                initialValue: _locationId,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Site to inspect'),
                items: [
                  for (final location in widget.locations)
                    DropdownMenuItem(
                      value: location.id,
                      child: Text(
                        '${location.label} · ${location.formattedAddress}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: _busy
                    ? null
                    : (value) => setState(() => _locationId = value),
              ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                alignment: Alignment.centerLeft,
              ),
              onPressed: _busy ? null : _pickDate,
              icon: const Icon(LucideIcons.calendar, size: 18),
              label: Text(
                'Preferred date: ${MaterialLocalizations.of(context).formatMediumDate(_date)}',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notes,
              enabled: !_busy,
              maxLength: 1000,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Notes for the store (optional)',
                helperText:
                    'For example the slab size, gate access or the engineer’s required PSI.',
                helperMaxLines: 2,
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              StatusBand(tone: BandTone.warning, title: _error!),
            ],
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _busy || _locationId == null ? null : _send,
              child: _busy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Send request'),
            ),
          ],
        ),
      ),
    ),
  );
}
