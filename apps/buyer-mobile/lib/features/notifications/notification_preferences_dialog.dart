import 'dart:async';
import 'package:flutter/material.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import '../../design_system/components/buyer_overlays.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import 'notification_inbox_controller.dart';
import 'notifications_repository.dart';

class NotificationPreferencesDialog extends StatefulWidget {
  const NotificationPreferencesDialog({
    super.key,
    required this.repository,
    this.enablePush,
  });
  final NotificationsRepository repository;
  final Future<void> Function()? enablePush;

  @override
  State<NotificationPreferencesDialog> createState() =>
      _NotificationPreferencesDialogState();
}

class _NotificationPreferencesDialogState
    extends State<NotificationPreferencesDialog> {
  List<api.NotificationPreference> _preferences = const [];
  bool _loading = true, _saving = false;
  String? _error, _message;
  Future<void> Function()? _retry;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  String _failure(Object failure) => failure is DiscoveryFailure
      ? failure.message
      : 'This request could not be completed. Check your connection and retry.';

  Future<void> _load() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final result = await widget.repository.preferences();
      if (mounted) setState(() => _preferences = result);
    } catch (failure) {
      if (mounted) {
        setState(() {
          _error = _failure(failure);
          _retry = _load;
          _clearDenied(failure);
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _clearDenied(Object failure) {
    if (failure is DiscoveryFailure &&
        (failure.kind == DiscoveryFailureKind.forbidden ||
            failure.kind == DiscoveryFailureKind.sessionExpired)) {
      _preferences = const [];
      widget.repository.inbox.setActive(false, clear: true);
    }
  }

  Future<void> _save(
    api.NotificationPreference preference,
    String channel,
    bool enabled,
  ) async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = _message = null;
    });
    try {
      await widget.repository.preference(preference, channel, enabled);
      final result = await widget.repository.preferences();
      if (mounted) {
        setState(() {
          _preferences = result;
          _message = 'Preferences saved.';
        });
      }
      unawaited(widget.repository.inbox.refresh());
    } catch (failure) {
      if (mounted) {
        setState(() {
          _error = _failure(failure);
          _retry = () => _save(preference, channel, enabled);
          _clearDenied(failure);
        });
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _enablePush() async {
    setState(() {
      _saving = true;
      _error = _message = null;
    });
    try {
      await widget.enablePush!();
      if (mounted) setState(() => _message = 'Device notifications enabled.');
    } catch (failure) {
      if (mounted) {
        setState(() {
          _error = _failure(failure);
          _retry = _enablePush;
        });
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final required = _preferences.where((p) => p.mandatory).toList();
    final optional = _preferences.where((p) => !p.mandatory).toList();
    return PopScope(
      canPop: !_saving,
      child: BuyerDialog(
        title: const Text('Notification preferences'),
        content: SizedBox(
          width: 480,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_loading) const LinearProgressIndicator(),
              if (_error != null)
                Semantics(
                  liveRegion: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      TextButton(
                        onPressed: _saving || _loading ? null : _retry,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              if (!_loading && optional.isNotEmpty) ...[
                const Text('Choose where you receive optional updates.'),
                const SizedBox(height: 12),
                for (final preference in optional) ...[
                  Text(
                    notificationCategoryLabel(preference.category),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final controls = [
                        for (final channel in const ['inApp', 'email', 'push'])
                          _channel(preference, channel),
                      ];
                      return constraints.maxWidth < 260 ||
                              MediaQuery.textScalerOf(context).scale(14) > 20
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: controls,
                            )
                          : Row(
                              children: controls
                                  .map((control) => Expanded(child: control))
                                  .toList(),
                            );
                    },
                  ),
                  const Divider(height: 24),
                ],
              ],
              if (!_loading && required.isNotEmpty) ...[
                Row(
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 18,
                      color: BuyerTheme.muted,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Required notices',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Account safety, legal and transaction notices stay enabled across all available channels.',
                ),
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: const EdgeInsets.only(bottom: 12),
                  title: const Text('View required types'),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        required
                            .map(
                              (preference) => notificationCategoryLabel(
                                preference.category,
                              ),
                            )
                            .join(', '),
                      ),
                    ),
                  ],
                ),
              ],
              if (widget.enablePush != null) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _saving ? null : _enablePush,
                  icon: const Icon(Icons.notifications_outlined, size: 18),
                  label: const Text('Enable device notifications'),
                ),
              ],
              if (_message != null || _saving)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Semantics(
                    liveRegion: true,
                    child: Text(_saving ? 'Saving…' : _message!),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saving ? null : () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Widget _channel(api.NotificationPreference preference, String channel) {
    final label = switch (channel) {
      'inApp' => 'In-app',
      'email' => 'Email',
      _ => 'Push',
    };
    final value = switch (channel) {
      'inApp' => preference.inApp,
      'email' => preference.email,
      _ => preference.push,
    };
    return Semantics(
      label: '${notificationCategoryLabel(preference.category)}, $label',
      child: InkWell(
        onTap: _saving ? null : () => _save(preference, channel, !value),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: value,
              onChanged: _saving
                  ? null
                  : (enabled) => _save(preference, channel, enabled!),
            ),
            Flexible(child: Text(label)),
          ],
        ),
      ),
    );
  }
}
