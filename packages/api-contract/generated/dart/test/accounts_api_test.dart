import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for AccountsApi
void main() {
  final instance = MateryalphApiClient().getAccountsApi();

  group(AccountsApi, () {
    // Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.
    //
    //Future<AccountMutationResultEnvelope> acceptAccountAgreements(String accountPortal, AccountAgreementAcceptance accountAgreementAcceptance) async
    test('test acceptAccountAgreements', () async {
      // TODO
    });

    //Future<AccountMutationResultEnvelope> acceptVendorStaffInvitation(VendorInvitationAcceptance vendorInvitationAcceptance) async
    test('test acceptVendorStaffInvitation', () async {
      // TODO
    });

    // Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.
    //
    //Future<AccountMutationResultEnvelope> changeAccountAdministrator(String accountPortal, String publicId, AccountAdminChange accountAdminChange) async
    test('test changeAccountAdministrator', () async {
      // TODO
    });

    // Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.
    //
    //Future<AccountMutationResultEnvelope> changeAccountDelegation(String accountPortal, String membershipId, AccountDelegation accountDelegation) async
    test('test changeAccountDelegation', () async {
      // TODO
    });

    // Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.
    //
    //Future<AccountMutationResultEnvelope> changeAccountMembershipStatus(String accountPortal, String membershipId, AccountMembershipStatus accountMembershipStatus) async
    test('test changeAccountMembershipStatus', () async {
      // TODO
    });

    // Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.
    //
    //Future<AccountMutationResultEnvelope> changeAccountPassword(String accountPortal, AccountPasswordChange accountPasswordChange) async
    test('test changeAccountPassword', () async {
      // TODO
    });

    // Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.
    //
    //Future<AccountMutationResultEnvelope> confirmAccountEmailChange(String accountPortal, AccountCodeConfirmation accountCodeConfirmation) async
    test('test confirmAccountEmailChange', () async {
      // TODO
    });

    // Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.
    //
    //Future<AccountRecoveryCodesEnvelope> confirmAccountFactorReplacement(String accountPortal, AccountCodeConfirmation accountCodeConfirmation) async
    test('test confirmAccountFactorReplacement', () async {
      // TODO
    });

    // Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.
    //
    //Future<AccountProfileEnvelope> getAccountProfile(String accountPortal) async
    test('test getAccountProfile', () async {
      // TODO
    });

    // Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.
    //
    //Future<AccountSecurityEnvelope> getAccountSecurity(String accountPortal) async
    test('test getAccountSecurity', () async {
      // TODO
    });

    // Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.
    //
    //Future<AccountMutationResultEnvelope> inviteAccountAdmin(String accountPortal, String idempotencyKey, AccountAdminInvitation accountAdminInvitation) async
    test('test inviteAccountAdmin', () async {
      // TODO
    });

    // Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.
    //
    //Future<AccountRoleListEnvelope> listAccountAdminRoles(String accountPortal) async
    test('test listAccountAdminRoles', () async {
      // TODO
    });

    // Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.
    //
    //Future<AccountAdministratorListEnvelope> listAccountAdministrators(String accountPortal, { int page }) async
    test('test listAccountAdministrators', () async {
      // TODO
    });

    // Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.
    //
    //Future<AccountAgreementListEnvelope> listAccountAgreements(String accountPortal) async
    test('test listAccountAgreements', () async {
      // TODO
    });

    // Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.
    //
    //Future<AccountMembershipListEnvelope> listAccountMemberships(String accountPortal, { int page }) async
    test('test listAccountMemberships', () async {
      // TODO
    });

    // Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.
    //
    //Future<AccountSessionListEnvelope> listAccountSessions(String accountPortal, { int page }) async
    test('test listAccountSessions', () async {
      // TODO
    });

    // Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.
    //
    //Future<AccountMutationResultEnvelope> reauthenticateAccount(String accountPortal, AccountReauthentication accountReauthentication) async
    test('test reauthenticateAccount', () async {
      // TODO
    });

    // Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.
    //
    //Future<AccountRecoveryCodesEnvelope> replaceAccountRecoveryCodes(String accountPortal) async
    test('test replaceAccountRecoveryCodes', () async {
      // TODO
    });

    // Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.
    //
    //Future<AccountMutationResultEnvelope> revokeAccountSession(String accountPortal, String sessionId) async
    test('test revokeAccountSession', () async {
      // TODO
    });

    // Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.
    //
    //Future<AccountMutationResultEnvelope> revokeAccountSessions(String accountPortal, AccountSessionRevocation accountSessionRevocation) async
    test('test revokeAccountSessions', () async {
      // TODO
    });

    // Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.
    //
    //Future<AccountMutationResultEnvelope> sendAccountReauthenticationEmail(String accountPortal) async
    test('test sendAccountReauthenticationEmail', () async {
      // TODO
    });

    // Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.
    //
    //Future<AccountPendingChangeEnvelope> startAccountEmailChange(String accountPortal, AccountEmailChange accountEmailChange) async
    test('test startAccountEmailChange', () async {
      // TODO
    });

    // Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.
    //
    //Future<AccountFactorEnrollmentEnvelope> startAccountFactorReplacement(String accountPortal) async
    test('test startAccountFactorReplacement', () async {
      // TODO
    });

    // Server enforces the route audience, active account and membership, resource ownership, Passport scope and session transport. buyers uses MOBILE bearer; vendors/admin use WEB cookies and CSRF on mutations. Privileged security changes require session-bound recent authentication. No client header can select or bypass transport security.
    //
    //Future<AccountProfileEnvelope> updateAccountProfile(String accountPortal, AccountProfileUpdate accountProfileUpdate) async
    test('test updateAccountProfile', () async {
      // TODO
    });

  });
}
