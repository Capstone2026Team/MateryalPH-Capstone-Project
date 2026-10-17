import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for ChatQuotationDiscount
void main() {
  final instance = ChatQuotationDiscountBuilder();
  // TODO add properties to the builder and call build()

  group(ChatQuotationDiscount, () {
    // Delivery discounts require Site Delivery.
    // String scope
    test('to test the property `scope`', () async {
      // TODO
    });

    // Percentage from 0 to 100, with up to two decimal places. Rounded half-up to centavos. Materials must retain a positive payable subtotal.
    // String percent
    test('to test the property `percent`', () async {
      // TODO
    });

  });
}
