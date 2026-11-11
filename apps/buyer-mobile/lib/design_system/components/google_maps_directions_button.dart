import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens directions to a public store location. Google Maps chooses the origin;
/// the app never sends the Buyer's saved location or requests device location.
class GoogleMapsDirectionsButton extends StatelessWidget {
  const GoogleMapsDirectionsButton({
    super.key,
    required this.destination,
    this.openLink,
  });

  final String destination;
  final Future<void> Function(Uri)? openLink;

  Future<void> _open(BuildContext context) async {
    final uri = Uri.https('www.google.com', '/maps/dir/', {
      'api': '1',
      'destination': destination,
      'travelmode': 'driving',
    });
    try {
      final open = openLink;
      if (open != null) {
        await open(uri);
        return;
      }
      if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return;
    } catch (_) {
      // Keep the current screen open and let the Buyer retry the button.
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Google Maps could not open. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: () => _open(context),
    style: OutlinedButton.styleFrom(minimumSize: const Size(0, 44)),
    icon: const Icon(LucideIcons.navigation, size: 20),
    label: const Text('Directions in Google Maps'),
  );
}
