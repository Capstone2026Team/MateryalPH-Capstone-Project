import 'package:flutter/material.dart';

import '../design_system/theme.dart';
import '../widgets/brand_lockup.dart';
import '../widgets/auth_content.dart';
import '../auth/auth_repository.dart';
import 'buyer_profile_screen.dart';
import 'buyer_store_browse_screen.dart';
import '../widgets/buyer_account_widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class BuyerHomeScreen extends StatefulWidget {
  const BuyerHomeScreen({
    super.key,
    required this.onSignOut,
    this.repository,
    this.onSessionEnded,
  });

  final Future<void> Function() onSignOut;
  final AuthRepository? repository;
  final VoidCallback? onSessionEnded;

  @override
  State<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen> {
  bool _signingOut = false;
  String? _error;
  int _destination = 0;
  Future<void> _signOut() async {
    setState(() {
      _signingOut = true;
      _error = null;
    });
    try {
      await widget.onSignOut();
    } catch (_) {
      if (mounted) {
        setState(
          () => _error =
              'Sign-out could not finish. Check your connection and try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _signingOut = false);
    }
  }

  void _sessionEnded() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    widget.onSessionEnded?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (_destination == 4 && widget.repository != null) {
      return Scaffold(
        body: BuyerProfileScreen(
          repository: widget.repository!,
          onSignedOut: _sessionEnded,
          onSignOut: widget.onSignOut,
        ),
        bottomNavigationBar: _navigation(),
      );
    }
    if (_destination == 1) {
      return Scaffold(appBar: AppBar(title: const Text('Explore stores')), body: const BuyerStoreBrowseScreen(), bottomNavigationBar: _navigation());
    }
    if (_destination > 0) {
      const titles = ['Map', 'Explore', 'Projects', 'Message', 'Profile'];
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text(titles[_destination]), centerTitle: true),
        body: SafeArea(
          child: BuyerUnavailableContent(
            artwork: _destination == 3 ? 'inbox' : 'not-implemented',
          ),
        ),
        bottomNavigationBar: _navigation(),
      );
    }
    return Scaffold(
      bottomNavigationBar: _navigation(),
      appBar: AppBar(
        title: const BrandLockup(compact: true),
        actions: [
          IconButton(
            onPressed: _signingOut ? null : _signOut,
            tooltip: 'Sign out',
            icon: const Icon(LucideIcons.logOut),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          children: [
            Text(
              'Your Buyer workspace',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 24),
            if (_error != null) ...[
              AuthNotice(message: _error!, isError: true),
              const SizedBox(height: 16),
            ],
            if (_signingOut) const AuthNotice(message: 'Signing out securely…'),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    LucideIcons.shieldCheck,
                    color: BuyerTheme.action,
                    size: 36,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Buyer account connected',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You are securely signed in. Supplier discovery and project tools are not available in this workspace yet.',
                    style: TextStyle(color: BuyerTheme.muted, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navigation() {
    const items = [
      (LucideIcons.compass, 'Map'),
      (LucideIcons.layoutGrid, 'Explore'),
      (LucideIcons.clipboardList, 'Projects'),
      (LucideIcons.messageCircle, 'Message'),
      (LucideIcons.user, 'Profile'),
    ];
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: BuyerTheme.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var index = 0; index < items.length; index++)
              Expanded(
                child: Semantics(
                  selected: index == _destination,
                  onTap: () => setState(() => _destination = index),
                  button: true,
                  label: items[index].$2,
                  child: ExcludeSemantics(
                    child: InkWell(
                      onTap: () => setState(() => _destination = index),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 76),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 3,
                              width: 28,
                              color: index == _destination
                                  ? BuyerTheme.action
                                  : Colors.transparent,
                            ),
                            const SizedBox(height: 12),
                            Icon(
                              items[index].$1,
                              size: 24,
                              color: index == _destination
                                  ? BuyerTheme.action
                                  : BuyerTheme.muted,
                            ),
                            const SizedBox(height: 6),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(2, 0, 2, 10),
                              child: Text(
                                items[index].$2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: index == _destination
                                      ? BuyerTheme.action
                                      : BuyerTheme.muted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
