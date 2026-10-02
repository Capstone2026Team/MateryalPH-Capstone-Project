import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/features/messaging/chat_delivery_dialog.dart';
import 'map_discovery_fakes.dart';
import 'messaging_layout_test.dart' show LayoutMessagingRepository;

class DeliveryRepository extends LayoutMessagingRepository {
  final declarations = <String>[];
  @override
  Future<void> updateDestination(
    String id,
    int version,
    String location,
    String restriction, {
    String? alternate,
    String? instructions,
  }) async {
    declarations.add('$id|$version|$location|$restriction');
  }
}

void main() {
  testWidgets(
    'delivery details require an explicit access answer and preserve conversation version',
    (tester) async {
      final repository = DeliveryRepository();
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => showChatDeliveryDialog(
                  context,
                  repository: repository,
                  conversationId: 'thread',
                  lockVersion: 7,
                  locations: [primaryLocation],
                ),
                child: const Text('Delivery details'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Delivery details'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Save delivery details'),
            )
            .onPressed,
        isNull,
      );
      await tester.tap(find.byType(DropdownButtonFormField<String>).last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('No restriction').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save delivery details'));
      await tester.pumpAndSettle();
      expect(repository.declarations, ['thread|7|loc-1|NO']);
      expect(find.byType(AlertDialog), findsNothing);
    },
  );
}
