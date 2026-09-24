import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';
import '../design_system/theme.dart';

AppBar buyerAccountBar(BuildContext context, String title) => AppBar(
  title: Text(title),
  centerTitle: true,
  toolbarHeight:
      56 + (MediaQuery.textScalerOf(context).scale(20) - 20).clamp(0, 48),
  backgroundColor: Colors.white,
  leading: Navigator.canPop(context)
      ? IconButton(
          tooltip: 'Back',
          icon: const Icon(LucideIcons.arrowLeft, color: BuyerTheme.action),
          onPressed: () => Navigator.pop(context),
        )
      : null,
);

class BuyerMenuRow extends StatelessWidget {
  const BuyerMenuRow({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.destructive = false,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        minVerticalPadding: 14,
        leading: Icon(
          icon,
          size: 24,
          color: destructive
              ? Theme.of(context).colorScheme.error
              : BuyerTheme.muted,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: destructive
                ? Theme.of(context).colorScheme.error
                : BuyerTheme.ink,
          ),
        ),
        trailing: const Icon(
          LucideIcons.chevronRight,
          size: 20,
          color: BuyerTheme.muted,
        ),
        onTap: onTap,
      ),
      const Divider(height: 1),
    ],
  );
}

class BuyerSectionLabel extends StatelessWidget {
  const BuyerSectionLabel(this.label, {super.key});
  final String label;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(8, 28, 8, 12),
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
}

class BuyerIdentity extends StatelessWidget {
  const BuyerIdentity({
    super.key,
    required this.profile,
    this.centered = false,
    this.onEditPhoto,
    this.onNotifications,
    this.onSearch,
  });
  final AccountProfile profile;
  final bool centered;
  final VoidCallback? onEditPhoto;
  final VoidCallback? onNotifications;
  final VoidCallback? onSearch;

  @override
  Widget build(BuildContext context) {
    final avatarSize = centered ? 112.0 : 64.0;
    final avatar = Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: BuyerTheme.brandSoft,
          ),
          clipBehavior: Clip.antiAlias,
          child: profile.avatarUrl == null
              ? Icon(
                  LucideIcons.user,
                  color: BuyerTheme.action,
                  size: centered ? 48 : 30,
                )
              : Image.network(
                  profile.avatarUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, error, stack) => Icon(
                    LucideIcons.user,
                    color: BuyerTheme.action,
                    size: centered ? 48 : 30,
                  ),
                ),
        ),
        if (onEditPhoto != null)
          Positioned(
            right: -12,
            bottom: -8,
            child: IconButton.filled(
              tooltip: 'Edit profile picture',
              onPressed: onEditPhoto,
              icon: const Icon(LucideIcons.pencil, size: 20),
            ),
          ),
      ],
    );
    final information = Column(
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          profile.fullName,
          textAlign: centered ? TextAlign.center : TextAlign.start,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          profile.email,
          textAlign: centered ? TextAlign.center : TextAlign.start,
          style: const TextStyle(color: BuyerTheme.muted),
        ),
        const SizedBox(height: 4),
        Text(
          profile.mobileE164?.trim().isNotEmpty == true
              ? profile.mobileE164!
              : 'Phone number not added',
          style: TextStyle(color: BuyerTheme.muted, fontSize: 13),
        ),
      ],
    );
    if (centered) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [avatar, const SizedBox(height: 28), information],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            avatar,
            const Spacer(),
            IconButton(
              tooltip: 'Search',
              onPressed: onSearch,
              icon: const Icon(LucideIcons.search, color: BuyerTheme.ink),
            ),
            IconButton(
              tooltip: 'Notifications',
              onPressed: onNotifications,
              icon: const Icon(LucideIcons.bell, color: BuyerTheme.ink),
            ),
          ],
        ),
        const SizedBox(height: 16),
        information,
      ],
    );
  }
}

class BuyerUnavailableScreen extends StatelessWidget {
  const BuyerUnavailableScreen({
    super.key,
    required this.title,
    this.artwork = 'not-implemented',
  });
  final String title;
  final String artwork;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: buyerAccountBar(context, title),
    body: SafeArea(child: BuyerUnavailableContent(artwork: artwork)),
  );
}

class BuyerUnavailableContent extends StatelessWidget {
  const BuyerUnavailableContent({super.key, this.artwork = 'not-implemented'});
  final String artwork;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/states/$artwork.png',
                  width: 200,
                  height: 200,
                  excludeFromSemantics: true,
                ),
                const SizedBox(height: 24),
                Text(
                  'Not yet implemented',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                  'This feature is not available yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: BuyerTheme.muted),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
