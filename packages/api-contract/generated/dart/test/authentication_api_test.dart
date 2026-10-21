import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for AuthenticationApi
void main() {
  final instance = MateryalphApiClient().getAuthenticationApi();

  group(AuthenticationApi, () {
    // Invitation-only Admin registration. Validates the invitation, recipient when supplied, and current inviter authority before bot verification or email delivery. When bot protection is enabled, requires the server-selected admin_invitation_accept checkbox action and configured hostname, or an accessible email proof bound to the invited email, portal, and action. Acceptance rechecks invitation availability after the provider call. No account or membership is created and no invitation consumed when bot validation fails. Authenticator enrollment remains required before staff access.
    //
    //Future<RegistrationEnvelope> acceptAdminInvitation(AdminInvitationRequest adminInvitationRequest) async
    test('test acceptAdminInvitation', () async {
      // TODO
    });

    // Completes a Buyer sign-in (password or Google) when the Buyer enrolled an authenticator. The challenge_token comes from the login or Google exchange body, is opaque, single-use, expires with challenge_expires_in and is bound to the MOBILE transport. Five wrong codes end the challenge. Codes cannot be replayed.
    //
    //Future<AuthEnvelope> completeBuyerMobileMfaChallenge(BuyerMobileMfaChallengeRequest buyerMobileMfaChallengeRequest) async
    test('test completeBuyerMobileMfaChallenge', () async {
      // TODO
    });

    // Browser requests accepting text/html receive a safe branded error page on callback failure. JSON requests retain the canonical error envelope. No callback parameters are reflected into the HTML page.
    //
    //Future completeGoogleOidc(String state, String code) async
    test('test completeGoogleOidc', () async {
      // TODO
    });

    //Future<AuthEnvelope> completeMfaChallenge(MfaCodeRequest mfaCodeRequest) async
    test('test completeMfaChallenge', () async {
      // TODO
    });

    //Future<AuthEnvelope> confirmMfaEnrollment(MfaCodeRequest mfaCodeRequest) async
    test('test confirmMfaEnrollment', () async {
      // TODO
    });

    //Future<AuthEnvelope> exchangeBuyerMobileGoogleCode(GoogleMobileExchangeRequest googleMobileExchangeRequest) async
    test('test exchangeBuyerMobileGoogleCode', () async {
      // TODO
    });

    //Future<AuthEnvelope> getBuyerMobileSession() async
    test('test getBuyerMobileSession', () async {
      // TODO
    });

    //Future<MfaStatusEnvelope> getMfaChallengeStatus() async
    test('test getMfaChallengeStatus', () async {
      // TODO
    });

    //Future<AuthEnvelope> getSession() async
    test('test getSession', () async {
      // TODO
    });

    //Future<CsrfEnvelope> issueWebCsrfToken() async
    test('test issueWebCsrfToken', () async {
      // TODO
    });

    // Vendor and Admin browser login requires an Enterprise checkbox assessment when bot protection is enabled, or an accessible single-use email security proof. The server selects vendor_login or admin_login and validates the configured hostname. Admin MFA remains mandatory after bot validation.
    //
    //Future<AuthEnvelope> login(LoginRequest loginRequest) async
    test('test login', () async {
      // TODO
    });

    //Future<AuthEnvelope> loginBuyerMobile(BuyerMobileLoginRequest buyerMobileLoginRequest) async
    test('test loginBuyerMobile', () async {
      // TODO
    });

    //Future<SuccessEnvelope> logout() async
    test('test logout', () async {
      // TODO
    });

    //Future<SuccessEnvelope> logoutBuyerMobile() async
    test('test logoutBuyerMobile', () async {
      // TODO
    });

    // Completes the Buyer challenge with a single-use recovery code when the authenticator is unavailable. All other sessions are revoked and a replacement set of recovery codes is returned once.
    //
    //Future<AuthEnvelope> recoverBuyerMobileMfaChallenge(BuyerMobileMfaRecoveryRequest buyerMobileMfaRecoveryRequest) async
    test('test recoverBuyerMobileMfaChallenge', () async {
      // TODO
    });

    //Future<AuthEnvelope> recoverMfaChallenge(MfaRecoveryRequest mfaRecoveryRequest) async
    test('test recoverMfaChallenge', () async {
      // TODO
    });

    //Future<AuthEnvelope> refreshBuyerMobileSession(BuyerMobileRefreshRequest buyerMobileRefreshRequest) async
    test('test refreshBuyerMobileSession', () async {
      // TODO
    });

    //Future<AuthEnvelope> refreshSession() async
    test('test refreshSession', () async {
      // TODO
    });

    //Future<RegistrationEnvelope> registerAccount(RegisterRequest registerRequest) async
    test('test registerAccount', () async {
      // TODO
    });

    // Creates a new Buyer account requiring email verification and current agreement acceptance. An email held by a DELETED Buyer may be reused; that account's login email is pseudonymized, external sign-in links removed and old email codes invalidated in the same transaction. The deleted account and its history remain separate. Other existing accounts retain ACCOUNT_ALREADY_EXISTS protection.
    //
    //Future<RegistrationEnvelope> registerBuyerMobile(BuyerMobileRegisterRequest buyerMobileRegisterRequest) async
    test('test registerBuyerMobile', () async {
      // TODO
    });

    //Future<SuccessEnvelope> requestBuyerMobilePasswordRecovery(BuyerMobilePasswordRecoveryRequest buyerMobilePasswordRecoveryRequest) async
    test('test requestBuyerMobilePasswordRecovery', () async {
      // TODO
    });

    //Future<SuccessEnvelope> requestPasswordRecovery(PasswordRecoveryRequest passwordRecoveryRequest) async
    test('test requestPasswordRecovery', () async {
      // TODO
    });

    //Future<SuccessEnvelope> resendBuyerMobileBotChallenge(String challengeId, ResendBotChallengeRequest resendBotChallengeRequest) async
    test('test resendBuyerMobileBotChallenge', () async {
      // TODO
    });

    //Future<SuccessEnvelope> resendBuyerMobileEmailVerification(EmailRequest emailRequest) async
    test('test resendBuyerMobileEmailVerification', () async {
      // TODO
    });

    // Issues a new code for a pending Vendor account or an active Vendor account whose Owner email is still unverified. The response does not reveal whether an eligible account exists.
    //
    //Future<SuccessEnvelope> resendEmailVerification(EmailRequest emailRequest) async
    test('test resendEmailVerification', () async {
      // TODO
    });

    //Future<SuccessEnvelope> resendWebBotChallenge(String challengeId, WebResendBotChallengeRequest webResendBotChallengeRequest) async
    test('test resendWebBotChallenge', () async {
      // TODO
    });

    //Future<SuccessEnvelope> resetBuyerMobilePassword(PasswordResetRequest passwordResetRequest) async
    test('test resetBuyerMobilePassword', () async {
      // TODO
    });

    //Future<SuccessEnvelope> resetPassword(PasswordResetRequest passwordResetRequest) async
    test('test resetPassword', () async {
      // TODO
    });

    // Starts Buyer Google authentication. SIGN_UP may create a fresh Buyer account using a previously deleted Buyer's Google identity or email, with current agreement acceptance. The deleted account's login identifiers are released transactionally and its history is retained. SIGN_IN never restores or replaces a deleted account.
    //
    //Future<SuccessEnvelope> startBuyerMobileGoogleOidc(BuyerMobileGoogleOidcStartRequest buyerMobileGoogleOidcStartRequest) async
    test('test startBuyerMobileGoogleOidc', () async {
      // TODO
    });

    //Future<SuccessEnvelope> startGoogleOidc(GoogleOidcStartRequest googleOidcStartRequest) async
    test('test startGoogleOidc', () async {
      // TODO
    });

    //Future<MfaEnrollmentEnvelope> startMfaEnrollment() async
    test('test startMfaEnrollment', () async {
      // TODO
    });

    //Future<BotProofEnvelope> verifyBuyerMobileBotChallenge(String challengeId, VerifyBotChallengeRequest verifyBotChallengeRequest) async
    test('test verifyBuyerMobileBotChallenge', () async {
      // TODO
    });

    //Future<SuccessEnvelope> verifyBuyerMobileEmail(VerifyEmailRequest verifyEmailRequest) async
    test('test verifyBuyerMobileEmail', () async {
      // TODO
    });

    //Future<SuccessEnvelope> verifyEmail(VerifyEmailRequest verifyEmailRequest) async
    test('test verifyEmail', () async {
      // TODO
    });

    //Future<BotProofEnvelope> verifyWebBotChallenge(String challengeId, WebVerifyBotChallengeRequest webVerifyBotChallengeRequest) async
    test('test verifyWebBotChallenge', () async {
      // TODO
    });

  });
}
