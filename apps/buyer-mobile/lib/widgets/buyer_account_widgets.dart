import '../design_system/components/count_badge.dart';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';
import '../design_system/components/buyer_app_bar.dart';
import '../design_system/components/procurement_components.dart';
import '../design_system/theme.dart';
import '../features/notifications/buyer_notification_button.dart';

PreferredSizeWidget buyerAccountBar(BuildContext context, String title) =>
    buyerAppBar(context, title);

class BuyerMenuRow extends StatelessWidget {
  const BuyerMenuRow({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.destructive = false,
    this.badgeQuantity = '0',
    this.badgeMeaning = 'active record',
    this.status,
    this.statusPositive = false,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool destructive;
  final String badgeQuantity;
  final String badgeMeaning;

  /// A short state shown before the chevron, such as "On" or "Off".
  final String? status;
  final bool statusPositive;

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
        title: Semantics(
          label: positiveBadgeQuantity(badgeQuantity)
              ? '$label, $badgeQuantity $badgeMeaning'
              : status != null
              ? '$label, $status'
              : label,
          child: ExcludeSemantics(
            child: Text(
              label,
              style: TextStyle(
                color: destructive
                    ? Theme.of(context).colorScheme.error
                    : BuyerTheme.ink,
              ),
            ),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (positiveBadgeQuantity(badgeQuantity)) ...[
              CountBadge(quantity: badgeQuantity),
              const SizedBox(width: 8),
            ],
            if (status != null) ...[
              ExcludeSemantics(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusPositive
                        ? BuyerTheme.brandSoft
                        : BuyerTheme.canvas,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    status!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: statusPositive
                          ? BuyerTheme.action
                          : BuyerTheme.muted,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            const Icon(
              LucideIcons.chevronRight,
              size: 20,
              color: BuyerTheme.muted,
            ),
          ],
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
    this.photoBytes,
    this.onUploadPhoto,
    this.uploadingPhoto = false,
    this.photoUploadEnabled = true,
    this.onNotifications,
    this.onSearch,
  });
  final AccountProfile profile;
  final bool centered;
  final Uint8List? photoBytes;
  final VoidCallback? onUploadPhoto;
  final bool uploadingPhoto;
  final bool photoUploadEnabled;
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
          child: photoBytes == null
              ? Icon(
                  LucideIcons.user,
                  color: BuyerTheme.action,
                  size: centered ? 48 : 30,
                )
              : Image.memory(
                  photoBytes!,
                  semanticLabel: 'Your profile picture',
                  fit: BoxFit.cover,
                  errorBuilder: (_, error, stack) => Icon(
                    LucideIcons.user,
                    color: BuyerTheme.action,
                    size: centered ? 48 : 30,
                  ),
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
          children: [
            onUploadPhoto == null
                ? avatar
                : _EditableAvatar(
                    avatar: avatar,
                    size: avatarSize,
                    uploading: uploadingPhoto,
                    enabled: photoUploadEnabled && !uploadingPhoto,
                    onEdit: onUploadPhoto!,
                  ),
            const SizedBox(height: 20),
            information,
          ],
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
            BuyerNotificationButton(onPressed: onNotifications),
          ],
        ),
        const SizedBox(height: 16),
        information,
      ],
    );
  }
}

/// The profile photo with a ring and a pencil badge. Tapping the photo or the badge changes it;
/// while uploading, a progress ring replaces the badge action.
class _EditableAvatar extends StatelessWidget {
  const _EditableAvatar({
    required this.avatar,
    required this.size,
    required this.uploading,
    required this.enabled,
    required this.onEdit,
  });
  final Widget avatar;
  final double size;
  final bool uploading;
  final bool enabled;
  final VoidCallback onEdit;

  static const _hint = 'JPEG, PNG or WebP, up to 2 MB';

  @override
  Widget build(BuildContext context) {
    final ring = size + 12;
    return Semantics(
      container: true,
      button: true,
      enabled: enabled,
      label: uploading ? 'Uploading profile photo' : 'Change profile photo',
      hint: _hint,
      excludeSemantics: true,
      onTap: enabled ? onEdit : null,
      child: SizedBox(
        width: ring + 8,
        height: ring + 8,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              width: ring,
              height: ring,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: BuyerTheme.brandSoft, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                type: MaterialType.circle,
                clipBehavior: Clip.antiAlias,
                color: Colors.transparent,
                child: InkWell(
                  onTap: enabled ? onEdit : null,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      FittedBox(child: avatar),
                      if (uploading)
                        const ColoredBox(
                          color: Color(0x66000000),
                          child: Center(
                            child: SizedBox.square(
                              dimension: 32,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Tooltip(
                message: 'Change photo · $_hint',
                child: SizedBox.square(
                  // 44×44 touch target around a 36px visual badge.
                  dimension: 44,
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkResponse(
                      onTap: enabled ? onEdit : null,
                      radius: 24,
                      child: Center(
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: enabled
                                ? BuyerTheme.action
                                : BuyerTheme.muted,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: const Icon(
                            LucideIcons.pencil,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
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

class BuyerUnavailableScreen extends StatelessWidget {
  const BuyerUnavailableScreen({
    super.key,
    required this.title,
    this.artwork = StateArtwork.noResults,
  });
  final String title;
  final StateArtwork artwork;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: buyerAccountBar(context, title),
    body: SafeArea(child: BuyerUnavailableContent(artwork: artwork)),
  );
}

class BuyerUnavailableContent extends StatelessWidget {
  const BuyerUnavailableContent({
    super.key,
    this.artwork = StateArtwork.noResults,
  });
  final StateArtwork artwork;
  @override
  Widget build(BuildContext context) => StatePage(
    child: StateMessage(
      kind: StateKind.empty,
      artwork: artwork,
      title: 'Not yet implemented',
      message: 'This feature is not available yet.',
    ),
  );
}
