import 'package:flutter/material.dart';
import '../map_discovery/discovery_models.dart';
import 'messaging_repository.dart';

Future<void> showChatDeliveryDialog(
  BuildContext context, {
  required MessagingRepository repository,
  required String conversationId,
  required int lockVersion,
  required List<SavedLocationView> locations,
  String? initialLocation,
}) async {
  String? location = locations.any((item) => item.id == initialLocation)
      ? initialLocation
      : locations.firstOrNull?.id;
  String? alternate;
  String? restriction;
  var instructions = '';
  var busy = false;
  String? error;
  await showDialog<void>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, update) => AlertDialog(
        title: const Text('Delivery details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Choose your delivery location and declare heavy vehicle access before the Vendor publishes a delivery quotation.',
              ),
              if (locations.isEmpty)
                const Text('Add a saved location from the map first.'),
              DropdownButtonFormField<String>(
                initialValue: location,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Delivery location',
                ),
                items: locations
                    .map(
                      (item) => DropdownMenuItem(
                        value: item.id,
                        child: Text(
                          item.label,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: busy
                    ? null
                    : (value) => update(() {
                        location = value;
                        alternate = null;
                      }),
              ),
              DropdownButtonFormField<String>(
                initialValue: restriction,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Are heavy vehicles restricted?',
                ),
                items: const [
                  DropdownMenuItem(value: 'NO', child: Text('No restriction')),
                  DropdownMenuItem(
                    value: 'YES',
                    child: Text('Heavy vehicles restricted'),
                  ),
                ],
                onChanged: busy
                    ? null
                    : (value) => update(() => restriction = value),
              ),
              if (restriction == 'YES') ...[
                DropdownButtonFormField<String>(
                  key: ValueKey(location),
                  initialValue: alternate,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Alternative vehicle drop-off',
                  ),
                  items: locations
                      .where((item) => item.id != location)
                      .map(
                        (item) => DropdownMenuItem(
                          value: item.id,
                          child: Text(
                            item.label,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: busy
                      ? null
                      : (value) => update(() => alternate = value),
                ),
                TextField(
                  maxLength: 500,
                  readOnly: busy,
                  decoration: const InputDecoration(
                    labelText: 'Access and unloading instructions',
                  ),
                  onChanged: (value) => update(() => instructions = value),
                ),
              ],
              if (error != null)
                Text(
                  error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: busy ? null : () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed:
                busy ||
                    location == null ||
                    restriction == null ||
                    (restriction == 'YES' &&
                        (alternate == null || instructions.trim().length < 5))
                ? null
                : () async {
                    update(() {
                      busy = true;
                      error = null;
                    });
                    try {
                      await repository.updateDestination(
                        conversationId,
                        lockVersion,
                        location!,
                        restriction!,
                        alternate: restriction == 'YES' ? alternate : null,
                        instructions: restriction == 'YES'
                            ? instructions.trim()
                            : null,
                      );
                      if (context.mounted) Navigator.pop(context);
                    } catch (failure) {
                      if (context.mounted) {
                        update(() {
                          busy = false;
                          error = failure is DiscoveryFailure
                              ? failure.message
                              : 'Unable to save delivery details. Retry after reviewing the current quotation.';
                        });
                      }
                    }
                  },
            child: Text(busy ? 'Saving…' : 'Save delivery details'),
          ),
        ],
      ),
    ),
  );
}
