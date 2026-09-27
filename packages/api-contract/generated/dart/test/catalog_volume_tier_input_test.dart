import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for CatalogVolumeTierInput
void main() {
  final instance = CatalogVolumeTierInputBuilder();
  // TODO add properties to the builder and call build()

  group(CatalogVolumeTierInput, () {
    // Greater than 1 and higher than the previous tier.
    // String minimumQuantity
    test('to test the property `minimumQuantity`', () async {
      // TODO
    });

    // VAT-inclusive unit price, lower than the ordinary price and the previous tier.
    // int priceCentavos
    test('to test the property `priceCentavos`', () async {
      // TODO
    });

  });
}
