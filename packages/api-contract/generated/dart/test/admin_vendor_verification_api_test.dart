import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for AdminVendorVerificationApi
void main() {
  final instance = MateryalphApiClient().getAdminVendorVerificationApi();

  group(AdminVendorVerificationApi, () {
    //Future<AdminVendorVerificationDetailEnvelope> decideVendorVerificationRequirement(String organizationId, String requirementKey, String idempotencyKey, AdminVendorVerificationDecision adminVendorVerificationDecision) async
    test('test decideVendorVerificationRequirement', () async {
      // TODO
    });

    //Future<AdminDashboardEnvelope> getAdminDashboard() async
    test('test getAdminDashboard', () async {
      // TODO
    });

    //Future<VendorFileEnvelope> getAdminVendorEvidenceUrl(String fileId) async
    test('test getAdminVendorEvidenceUrl', () async {
      // TODO
    });

    //Future<AdminVendorVerificationDetailEnvelope> getVendorVerificationCase(String organizationId) async
    test('test getVendorVerificationCase', () async {
      // TODO
    });

    //Future<AdminDashboardAuditEnvelope> listAdminDashboardAudit({ int page }) async
    test('test listAdminDashboardAudit', () async {
      // TODO
    });

    //Future<AdminVendorVerificationQueueEnvelope> listVendorVerificationQueue({ String status, String businessType, String regionCode, Date submittedFrom, Date submittedTo, String sort, int page }) async
    test('test listVendorVerificationQueue', () async {
      // TODO
    });

    //Future<VendorRestrictionEnvelope> restoreVendorActivation(String organizationId, String idempotencyKey, VendorRestriction vendorRestriction) async
    test('test restoreVendorActivation', () async {
      // TODO
    });

    //Future<VendorRestrictionEnvelope> restrictVendorActivation(String organizationId, String idempotencyKey, VendorRestriction vendorRestriction) async
    test('test restrictVendorActivation', () async {
      // TODO
    });

  });
}
