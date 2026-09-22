import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for VendorOnboardingApi
void main() {
  final instance = MateryalphApiClient().getVendorOnboardingApi();

  group(VendorOnboardingApi, () {
    //Future<VendorOnboardingEnvelope> activateVendorStore(String idempotencyKey) async
    test('test activateVendorStore', () async {
      // TODO
    });

    //Future<VendorOnboardingEnvelope> captureVendorPaymentConnection(String idempotencyKey, VendorPaymentConnection vendorPaymentConnection) async
    test('test captureVendorPaymentConnection', () async {
      // TODO
    });

    //Future<VendorOnboardingEnvelope> completeVendorSetup(String idempotencyKey, VendorSetupComplete vendorSetupComplete) async
    test('test completeVendorSetup', () async {
      // TODO
    });

    //Future<VendorOnboardingEnvelope> confirmVendorStoreEmailVerification(VendorStoreEmailConfirmation vendorStoreEmailConfirmation) async
    test('test confirmVendorStoreEmailVerification', () async {
      // TODO
    });

    // Persists the Owner welcome completion across refreshes and sessions. Clients continue to Store Verification after success.
    //
    //Future<VendorOnboardingEnvelope> dismissVendorOnboardingWelcome() async
    test('test dismissVendorOnboardingWelcome', () async {
      // TODO
    });

    //Future<Uint8List> downloadVendorOnboardingFile(String fileId) async
    test('test downloadVendorOnboardingFile', () async {
      // TODO
    });

    //Future<VendorOnboardingEnvelope> getAuthoritativeVendorOnboarding() async
    test('test getAuthoritativeVendorOnboarding', () async {
      // TODO
    });

    //Future<VendorOnboardingEnvelope> getVendorOnboarding() async
    test('test getVendorOnboarding', () async {
      // TODO
    });

    // Returns a five-minute signed URL for clean private verification evidence or ready Store Profile media owned by the current Vendor organization. Download rechecks authentication, permissions, ownership and scan state.
    //
    //Future<VendorFileEnvelope> getVendorPrivateFileUrl(String fileId) async
    test('test getVendorPrivateFileUrl', () async {
      // TODO
    });

    //Future<VendorInvitationEnvelope> inviteVendorTeamMember(String idempotencyKey, VendorInvitationRequest vendorInvitationRequest) async
    test('test inviteVendorTeamMember', () async {
      // TODO
    });

    //Future<VendorWebhookEnvelope> receiveXenditAccountVerificationWebhook(String xCallbackToken, XenditAccountVerificationWebhook xenditAccountVerificationWebhook) async
    test('test receiveXenditAccountVerificationWebhook', () async {
      // TODO
    });

    //Future<VendorPaymentReconciliationEnvelope> reconcileVendorPaymentConnection() async
    test('test reconcileVendorPaymentConnection', () async {
      // TODO
    });

    //Future<VendorStoreEmailEnvelope> requestVendorStoreEmailVerification(EmailRequest emailRequest) async
    test('test requestVendorStoreEmailVerification', () async {
      // TODO
    });

    //Future<VendorAddressGeocodeEnvelope> reverseGeocodeVendorAddress(VendorAddressGeocode vendorAddressGeocode) async
    test('test reverseGeocodeVendorAddress', () async {
      // TODO
    });

    // Saves version-checked setup progress. Public-name, description and public-contact-only edits preserve completed setup and activation; operational changes reopen setup requirements. Every successful save advances the organization lock version.
    //
    //Future<VendorOnboardingEnvelope> saveVendorSetupDraft(VendorSetupDraft vendorSetupDraft) async
    test('test saveVendorSetupDraft', () async {
      // TODO
    });

    //Future<VendorOnboardingEnvelope> saveVendorVerificationDraft(VendorVerificationDraft vendorVerificationDraft) async
    test('test saveVendorVerificationDraft', () async {
      // TODO
    });

    //Future<VendorOnboardingEnvelope> submitVendorVerification(String idempotencyKey, VendorVerificationSubmit vendorVerificationSubmit) async
    test('test submitVendorVerification', () async {
      // TODO
    });

    //Future<VendorMediaEnvelope> uploadVendorStoreMedia(String kind, MultipartFile file, { String altText }) async
    test('test uploadVendorStoreMedia', () async {
      // TODO
    });

    //Future<VendorDocumentEnvelope> uploadVendorVerificationDocument(String requirementKey, MultipartFile file, { BuiltMap<String, String> metadata }) async
    test('test uploadVendorVerificationDocument', () async {
      // TODO
    });

  });
}
