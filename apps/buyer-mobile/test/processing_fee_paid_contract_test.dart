import 'package:built_value/serializer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

void main() {
  test('a paid order keeps its verified Payment Processing Fee readable', () {
    final serializers = MateryalphApiClient(
      basePathOverride: 'http://localhost/api/v1',
    ).serializers;
    final fee =
        serializers.deserialize(
              {'status': 'PAID', 'amount_centavos': 755},
              specifiedType: const FullType(ProcessingFee),
            )!
            as ProcessingFee;
    expect(fee.status, ProcessingFeeStatusEnum.PAID);
    expect(fee.amountCentavos, 755);
  });
}
