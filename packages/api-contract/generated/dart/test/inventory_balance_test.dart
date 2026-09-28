import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for InventoryBalance
void main() {
  final instance = InventoryBalanceBuilder();
  // TODO add properties to the builder and call build()

  group(InventoryBalance, () {
    // Physical stock (four decimals). Reduced only by fulfillment or a recorded adjustment.
    // String quantityOnHand
    test('to test the property `quantityOnHand`', () async {
      // TODO
    });

    // String hardReservedQuantity
    test('to test the property `hardReservedQuantity`', () async {
      // TODO
    });

    // Planning-only quotation holds; never reduce available_to_sell.
    // String softHeldQuantity
    test('to test the property `softHeldQuantity`', () async {
      // TODO
    });

    // quantity_on_hand minus hard_reserved_quantity.
    // String availableToSell
    test('to test the property `availableToSell`', () async {
      // TODO
    });

    // String reorderLevel
    test('to test the property `reorderLevel`', () async {
      // TODO
    });

    // DateTime confirmedAt
    test('to test the property `confirmedAt`', () async {
      // TODO
    });

    // String updatedAt
    test('to test the property `updatedAt`', () async {
      // TODO
    });

  });
}
