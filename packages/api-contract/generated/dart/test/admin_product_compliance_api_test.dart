import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for AdminProductComplianceApi
void main() {
  final instance = MateryalphApiClient().getAdminProductComplianceApi();

  group(AdminProductComplianceApi, () {
    //Future<ComplianceRegisterEnvelope> activateComplianceRegister(String registerId) async
    test('test activateComplianceRegister', () async {
      // TODO
    });

    // MAT-03. Creates an approved comparable group version from an exact controlled key (material, brand, model, every controlled specification, canonical unit and conversion version) and maps exactly matching active variants.
    //
    //Future<ComparableGroupEnvelope> createComparableGroup(ComparableGroupCreate comparableGroupCreate) async
    test('test createComparableGroup', () async {
      // TODO
    });

    // Approve, Return for Correction or Reject the named submission version. A reason is required unless approving; a stale lock_version is rejected with STALE_REVIEW. The decision never changes Store Activation.
    //
    //Future<ProductComplianceCaseEnvelope> decideProductCompliance(String submissionId, String idempotencyKey, ProductComplianceDecision productComplianceDecision) async
    test('test decideProductCompliance', () async {
      // TODO
    });

    //Future<ProductComplianceCaseEnvelope> getProductComplianceCase(String submissionId) async
    test('test getProductComplianceCase', () async {
      // TODO
    });

    //Future<VendorFileEnvelope> getProductComplianceFileUrl(String fileId) async
    test('test getProductComplianceFileUrl', () async {
      // TODO
    });

    // Imports a CSV snapshot of the DTI-BPS PS licensee or ICC certificate register as an immutable DRAFT. It is used for matching only after activation.
    //
    //Future<ComplianceRegisterEnvelope> importComplianceRegister(String registerKind, String sourceReference, Date snapshotDate, MultipartFile file) async
    test('test importComplianceRegister', () async {
      // TODO
    });

    //Future<ComplianceRegisterListEnvelope> listComplianceRegisters({ int page }) async
    test('test listComplianceRegisters', () async {
      // TODO
    });

    //Future<ProductComplianceQueueEnvelope> listProductComplianceQueue({ String status, CompliancePath path, ComplianceReferenceResult referenceResult, String sort, int page }) async
    test('test listProductComplianceQueue', () async {
      // TODO
    });

  });
}
