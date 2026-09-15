import 'package:materyalph_api_client/materyalph_api_client.dart';
import 'package:test/test.dart';

void main() {
  test('incomplete tax profiles deserialize nullable evidence and review fields', () {
    final profile = standardSerializers.deserializeWith(VendorTaxProfile.serializer, {
      'review_reason': null,
      'lock_version': 1,
      'evidence_versions': <Object>[],
      'profile_id': null,
      'version_id': null,
      'version': null,
      'status': 'INCOMPLETE',
      'environment': 'TEST',
      'evidence_origin': 'SAMPLE_DEMO',
      'data': <String, Object>{},
      'owner_attested_at': null,
      'withholding_treatment': 'STANDARD_UNLESS_SEPARATE_RELIEF_VALIDATED',
      'history': <Object>[],
      'legal_effect': 'TEST_DEMO_ONLY_NOT_REGULATORY_APPROVAL',
    });
    expect(profile?.profileId, isNull);
    expect(profile?.reviewReason, isNull);
    expect(profile?.status, 'INCOMPLETE');
  });

  test('initial setup accepts missing store and provider state', () {
    final setup = standardSerializers.deserializeWith(VendorSetup.serializer, {
      'lock_version': 1,
      'store': null,
      'hours': <Object>[],
      'payment': null,
      'bulk_order_capable': false,
      'delivery_vehicles': <Object>[],
      'withholding_demo_scenario': null,
      'production_withholding_assignment': 'UNCONFIRMED',
      'environment': 'TEST',
    });
    expect(setup?.store, isNull);
    expect(setup?.payment, isNull);
    expect(setup?.environment, 'TEST');
  });
}
