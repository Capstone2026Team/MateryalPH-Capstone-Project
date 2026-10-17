import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import 'notification_inbox_controller.dart';
import 'buyer_push.dart';
import 'notifications_repository.dart';

/// Where the Buyer chooses which optional updates reach In-app, Email and Push.
/// Required notices (account safety, legal, transaction) stay on and are listed read-only.
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({
    super.key,
    required this.repository,
    this.enablePush,
  });
  final NotificationsRepository repository;
  final Future<void> Function()? enablePush;

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  List<api.NotificationPreference> _preferences = const [];
  bool _loading = true, _saving = false;
  String? _error, _message;
  Future<void> Function()? _retry;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  String _failure(Object failure) => switch (failure) {
    DiscoveryFailure() => failure.message,
    BuyerPushException() => failure.message,
    _ =>
      'This request could not be completed. Check your connection and retry.',
  };

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
    final textTheme = Theme.of(context).textTheme;
    return PopScope(
      canPop: !_saving,
      child: Scaffold(
        appBar: buyerAppBar(context, 'Notification settings'),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Text(
                'Choose where you receive optional updates. Required notices always reach you.',
                style: textTheme.bodyMedium?.copyWith(color: BuyerTheme.muted),
              ),
              const SizedBox(height: 16),
              if (_loading) const LinearProgressIndicator(),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Semantics(
                    liveRegion: true,
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.circleAlert,
                          size: 20,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _error!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _saving || _loading ? null : _retry,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              if (widget.enablePush != null) ...[
                _DeviceNotificationsRow(busy: _saving, onPressed: _enablePush),
                const SizedBox(height: 8),
              ],
              if (!_loading && optional.isNotEmpty) ...[
                _heading(context, 'Optional updates'),
                for (final preference in optional) _category(preference),
              ],
              if (!_loading && required.isNotEmpty) ...[
                _heading(context, 'Required notices'),
                _requiredNotices(context, required),
              ],
              if (_message != null || _saving)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Semantics(
                    liveRegion: true,
                    child: Row(
                      children: [
                        Icon(
                          _saving
                              ? LucideIcons.loader
                              : LucideIcons.circleCheck,
                          size: 18,
                          color: _saving
                              ? BuyerTheme.muted
                              : BuyerTheme.successStrong,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _saving ? 'Saving…' : _message!,
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heading(BuildContext context, String label) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: Semantics(
      header: true,
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: BuyerTheme.muted,
          fontWeight: FontWeight.w600,
          letterSpacing: .8,
        ),
      ),
    ),
  );

  Widget _category(api.NotificationPreference preference) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: BuyerTheme.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notificationCategoryLabel(preference.category),
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (preference.explanation.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      preference.explanation,
                      style: textTheme.bodySmall?.copyWith(
                        color: BuyerTheme.muted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            for (final channel in const ['inApp', 'email', 'push']) ...[
              const Divider(height: 1),
              _channel(preference, channel),
            ],
          ],
        ),
      ),
    );
  }

  Widget _requiredNotices(
    BuildContext context,
    List<api.NotificationPreference> required,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BuyerTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(
                  LucideIcons.lock,
                  size: 18,
                  color: BuyerTheme.muted,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Account safety, legal and transaction notices stay enabled across all available channels.',
                  style: textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final preference in required)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: BuyerTheme.canvas,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: BuyerTheme.border),
                  ),
                  child: Text(
                    notificationCategoryLabel(preference.category),
                    style: textTheme.bodySmall,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _channel(api.NotificationPreference preference, String channel) {
    final (label, icon, value) = switch (channel) {
      'inApp' => ('In-app', LucideIcons.smartphone, preference.inApp),
      'email' => ('Email', LucideIcons.mail, preference.email),
      _ => ('Push', LucideIcons.bellRing, preference.push),
    };
    return Semantics(
      container: true,
      label: '${notificationCategoryLabel(preference.category)}, $label',
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        secondary: Icon(icon, size: 20, color: BuyerTheme.muted),
        title: Text(label),
        value: value,
        activeThumbColor: Colors.white,
        activeTrackColor: BuyerTheme.action,
        onChanged: _saving
            ? null
            : (enabled) => _save(preference, channel, enabled),
      ),
    );
  }
}

class _DeviceNotificationsRow extends StatelessWidget {
  const _DeviceNotificationsRow({required this.busy, required this.onPressed});
  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: BuyerTheme.brandSoft,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Device notifications',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        const Text('Allow this phone to show push alerts for your updates.'),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: busy ? null : onPressed,
          icon: const Icon(LucideIcons.bellRing, size: 18),
          label: const Text('Enable device notifications'),
        ),
      ],
    ),
  );
}
