import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for VendorOnboardingApi
void main() {
  final instance = MateryalphApiClient().getVendorOnboardingApi();

  group(VendorOnboardingApi, () {
    // accept Vendor Commission Terms
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorCommissionTermsEnvelope> acceptVendorCommissionTerms(String organization, AcceptVendorCommission acceptVendorCommission) async
    test('test acceptVendorCommissionTerms', () async {
      // TODO
    });

    // activate Vendor Marketplace
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorReadinessEnvelope> activateVendorMarketplace(String organization, VendorVersionMutation vendorVersionMutation) async
    test('test activateVendorMarketplace', () async {
      // TODO
    });

    // change Vendor Team Member
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorMutationEnvelope> changeVendorTeamMember(String organization, String membership, ChangeVendorTeamMember changeVendorTeamMember) async
    test('test changeVendorTeamMember', () async {
      // TODO
    });

    // confirm Vendor Store Email Verification
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorBusinessEnvelope> confirmVendorStoreEmailVerification(String organization, VendorStoreEmailVerificationConfirmation vendorStoreEmailVerificationConfirmation) async
    test('test confirmVendorStoreEmailVerification', () async {
      // TODO
    });

    // connect Vendor Test
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorSetupEnvelope> connectVendorTest(String organization, ConnectVendorTest connectVendorTest) async
    test('test connectVendorTest', () async {
      // TODO
    });

    // download Admin Vendor Document
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<Uint8List> downloadAdminVendorDocument(String organization, String version, String expires, String signature, String viewer) async
    test('test downloadAdminVendorDocument', () async {
      // TODO
    });

    // download Vendor Document
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<Uint8List> downloadVendorDocument(String organization, String version, String expires, String signature, String viewer) async
    test('test downloadVendorDocument', () async {
      // TODO
    });

    // get Admin Vendor Business
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorBusinessEnvelope> getAdminVendorBusiness(String organization) async
    test('test getAdminVendorBusiness', () async {
      // TODO
    });

    // get Admin Vendor Readiness
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorReadinessEnvelope> getAdminVendorReadiness(String organization) async
    test('test getAdminVendorReadiness', () async {
      // TODO
    });

    // get Admin Vendor Tax Profile
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorTaxProfileEnvelope> getAdminVendorTaxProfile(String organization) async
    test('test getAdminVendorTaxProfile', () async {
      // TODO
    });

    // get Public Vendor Store Media
    //
    // Public delivery for an approved, unreplaced Store Profile image belonging to an active Vendor.
    //
    //Future<Uint8List> getPublicVendorStoreMedia(String organization, String media) async
    test('test getPublicVendorStoreMedia', () async {
      // TODO
    });

    // get Vendor Business
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorBusinessEnvelope> getVendorBusiness(String organization) async
    test('test getVendorBusiness', () async {
      // TODO
    });

    // get Vendor Commission Terms
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorCommissionTermsEnvelope> getVendorCommissionTerms(String organization) async
    test('test getVendorCommissionTerms', () async {
      // TODO
    });

    // get Vendor Readiness
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorReadinessEnvelope> getVendorReadiness(String organization) async
    test('test getVendorReadiness', () async {
      // TODO
    });

    // get Vendor Setup
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorSetupEnvelope> getVendorSetup(String organization) async
    test('test getVendorSetup', () async {
      // TODO
    });

    // get Vendor Tax Profile
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorTaxProfileEnvelope> getVendorTaxProfile(String organization) async
    test('test getVendorTaxProfile', () async {
      // TODO
    });

    // get Vendor Team
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorTeamEnvelope> getVendorTeam(String organization, { int page, int perPage }) async
    test('test getVendorTeam', () async {
      // TODO
    });

    // invite Vendor Team
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorMutationEnvelope> inviteVendorTeam(String organization, String idempotencyKey, InviteVendorTeam inviteVendorTeam) async
    test('test inviteVendorTeam', () async {
      // TODO
    });

    // issue Admin Vendor Document Link
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorDownloadLinkEnvelope> issueAdminVendorDocumentLink(String organization, String version) async
    test('test issueAdminVendorDocumentLink', () async {
      // TODO
    });

    // issue Vendor Document Link
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorDownloadLinkEnvelope> issueVendorDocumentLink(String organization, String version) async
    test('test issueVendorDocumentLink', () async {
      // TODO
    });

    // list Admin Vendor Documents
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorDocumentListEnvelope> listAdminVendorDocuments(String organization, { int page, int perPage }) async
    test('test listAdminVendorDocuments', () async {
      // TODO
    });

    // list Admin Vendor Store Media
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorStoreMediaListEnvelope> listAdminVendorStoreMedia(String organization) async
    test('test listAdminVendorStoreMedia', () async {
      // TODO
    });

    // list Vendor Documents
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorDocumentListEnvelope> listVendorDocuments(String organization, { int page, int perPage }) async
    test('test listVendorDocuments', () async {
      // TODO
    });

    // list Vendor Store Media
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorStoreMediaListEnvelope> listVendorStoreMedia(String organization) async
    test('test listVendorStoreMedia', () async {
      // TODO
    });

    // list Vendor Team Invitations
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorTeamInvitationListEnvelope> listVendorTeamInvitations(String organization, { int page, int perPage }) async
    test('test listVendorTeamInvitations', () async {
      // TODO
    });

    // list Vendor Verification Queue
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorVerificationRowListEnvelope> listVendorVerificationQueue({ int page, int perPage }) async
    test('test listVendorVerificationQueue', () async {
      // TODO
    });

    // preview Admin Vendor Store Media
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<Uint8List> previewAdminVendorStoreMedia(String organization, String media) async
    test('test previewAdminVendorStoreMedia', () async {
      // TODO
    });

    // preview Vendor Store Media
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<Uint8List> previewVendorStoreMedia(String organization, String media) async
    test('test previewVendorStoreMedia', () async {
      // TODO
    });

    // reconcile Vendor Test Connection
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorSetupEnvelope> reconcileVendorTestConnection(String organization, VendorVersionMutation vendorVersionMutation) async
    test('test reconcileVendorTestConnection', () async {
      // TODO
    });

    // remove Vendor Store Media
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorMutationEnvelope> removeVendorStoreMedia(String organization, String media, VendorVersionMutation vendorVersionMutation) async
    test('test removeVendorStoreMedia', () async {
      // TODO
    });

    // request Vendor Store Email Verification
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorBusinessEnvelope> requestVendorStoreEmailVerification(String organization, VendorStoreEmailVerificationRequest vendorStoreEmailVerificationRequest) async
    test('test requestVendorStoreEmailVerification', () async {
      // TODO
    });

    // review Vendor Business
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorReadinessEnvelope> reviewVendorBusiness(String organization, VendorBusinessReview vendorBusinessReview) async
    test('test reviewVendorBusiness', () async {
      // TODO
    });

    // review Vendor Document
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorReadinessEnvelope> reviewVendorDocument(String organization, String version, VendorDocumentReview vendorDocumentReview) async
    test('test reviewVendorDocument', () async {
      // TODO
    });

    // review Vendor Store Media
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorMutationEnvelope> reviewVendorStoreMedia(String organization, String media, VendorReview vendorReview) async
    test('test reviewVendorStoreMedia', () async {
      // TODO
    });

    // review Vendor Tax Profile
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorReadinessEnvelope> reviewVendorTaxProfile(String organization, String version, VendorReview vendorReview) async
    test('test reviewVendorTaxProfile', () async {
      // TODO
    });

    // revoke Vendor Team Invitation
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorMutationEnvelope> revokeVendorTeamInvitation(String organization, String invitation, VendorVersionMutation vendorVersionMutation) async
    test('test revokeVendorTeamInvitation', () async {
      // TODO
    });

    // save Vendor Business
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorBusinessEnvelope> saveVendorBusiness(String organization, SaveVendorBusiness saveVendorBusiness) async
    test('test saveVendorBusiness', () async {
      // TODO
    });

    // save Vendor Store
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorSetupEnvelope> saveVendorStore(String organization, SaveVendorStore saveVendorStore) async
    test('test saveVendorStore', () async {
      // TODO
    });

    // save Vendor Tax Profile
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorTaxProfileEnvelope> saveVendorTaxProfile(String organization, SaveVendorTax saveVendorTax) async
    test('test saveVendorTaxProfile', () async {
      // TODO
    });

    // upload Vendor Document
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorDocumentUploadEnvelope> uploadVendorDocument(String organization, int lockVersion, String documentType, MultipartFile file) async
    test('test uploadVendorDocument', () async {
      // TODO
    });

    // upload Vendor Store Media
    //
    // TEST onboarding. Passport session, current membership/role, resource ownership and applicable recent authentication are enforced. Later-phase dependencies do not authorize activation.
    //
    //Future<VendorMutationEnvelope> uploadVendorStoreMedia(String organization, int lockVersion, String kind, String altText, MultipartFile file) async
    test('test uploadVendorStoreMedia', () async {
      // TODO
    });

  });
}
