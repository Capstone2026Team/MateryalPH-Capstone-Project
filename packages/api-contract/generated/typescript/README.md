# @materyalph/api-client-ts@1.0.0-phase.3

A TypeScript SDK client for the localhost API.

## Usage

First, install the SDK from npm.

```bash
npm install @materyalph/api-client-ts --save
```

Next, try it out.


```ts
import {
  Configuration,
  AccountsApi,
} from '@materyalph/api-client-ts';
import type { AcceptAccountAgreementsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AccountsApi(config);

  const body = {
    // 'buyers' | 'vendors' | 'admin'
    accountPortal: accountPortal_example,
    // AccountAgreementAcceptance
    accountAgreementAcceptance: ...,
  } satisfies AcceptAccountAgreementsRequest;

  try {
    const data = await api.acceptAccountAgreements(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```


## Documentation

### API Endpoints

All URIs are relative to */api/v1*

| Class | Method | HTTP request | Description
| ----- | ------ | ------------ | -------------
*AccountsApi* | [**acceptAccountAgreements**](docs/AccountsApi.md#acceptaccountagreements) | **POST** /{accountPortal}/account/agreements |
*AccountsApi* | [**acceptVendorStaffInvitation**](docs/AccountsApi.md#acceptvendorstaffinvitation) | **POST** /auth/vendor-invitations/accept |
*AccountsApi* | [**changeAccountAdministrator**](docs/AccountsApi.md#changeaccountadministrator) | **PATCH** /{accountPortal}/account/administrators/{publicId} |
*AccountsApi* | [**changeAccountDelegation**](docs/AccountsApi.md#changeaccountdelegation) | **PATCH** /{accountPortal}/account/memberships/{membershipId}/delegation |
*AccountsApi* | [**changeAccountMembershipStatus**](docs/AccountsApi.md#changeaccountmembershipstatus) | **PATCH** /{accountPortal}/account/memberships/{membershipId}/status |
*AccountsApi* | [**changeAccountPassword**](docs/AccountsApi.md#changeaccountpassword) | **POST** /{accountPortal}/account/password |
*AccountsApi* | [**confirmAccountEmailChange**](docs/AccountsApi.md#confirmaccountemailchange) | **POST** /{accountPortal}/account/email/confirm |
*AccountsApi* | [**confirmAccountFactorReplacement**](docs/AccountsApi.md#confirmaccountfactorreplacement) | **POST** /{accountPortal}/account/factor/confirm |
*AccountsApi* | [**getAccountProfile**](docs/AccountsApi.md#getaccountprofile) | **GET** /{accountPortal}/account/profile |
*AccountsApi* | [**getAccountSecurity**](docs/AccountsApi.md#getaccountsecurity) | **GET** /{accountPortal}/account/security |
*AccountsApi* | [**inviteAccountAdmin**](docs/AccountsApi.md#inviteaccountadmin) | **POST** /{accountPortal}/account/invitations |
*AccountsApi* | [**listAccountAdminRoles**](docs/AccountsApi.md#listaccountadminroles) | **GET** /{accountPortal}/account/roles |
*AccountsApi* | [**listAccountAdministrators**](docs/AccountsApi.md#listaccountadministrators) | **GET** /{accountPortal}/account/administrators |
*AccountsApi* | [**listAccountAgreements**](docs/AccountsApi.md#listaccountagreements) | **GET** /{accountPortal}/account/agreements |
*AccountsApi* | [**listAccountMemberships**](docs/AccountsApi.md#listaccountmemberships) | **GET** /{accountPortal}/account/memberships |
*AccountsApi* | [**listAccountSessions**](docs/AccountsApi.md#listaccountsessions) | **GET** /{accountPortal}/account/sessions |
*AccountsApi* | [**reauthenticateAccount**](docs/AccountsApi.md#reauthenticateaccount) | **POST** /{accountPortal}/account/reauthentication |
*AccountsApi* | [**replaceAccountRecoveryCodes**](docs/AccountsApi.md#replaceaccountrecoverycodes) | **POST** /{accountPortal}/account/recovery-codes |
*AccountsApi* | [**revokeAccountSession**](docs/AccountsApi.md#revokeaccountsession) | **DELETE** /{accountPortal}/account/sessions/{sessionId} |
*AccountsApi* | [**revokeAccountSessions**](docs/AccountsApi.md#revokeaccountsessions) | **POST** /{accountPortal}/account/sessions/revoke |
*AccountsApi* | [**sendAccountReauthenticationEmail**](docs/AccountsApi.md#sendaccountreauthenticationemail) | **POST** /{accountPortal}/account/reauthentication/email |
*AccountsApi* | [**startAccountEmailChange**](docs/AccountsApi.md#startaccountemailchange) | **POST** /{accountPortal}/account/email |
*AccountsApi* | [**startAccountFactorReplacement**](docs/AccountsApi.md#startaccountfactorreplacement) | **POST** /{accountPortal}/account/factor |
*AccountsApi* | [**updateAccountProfile**](docs/AccountsApi.md#updateaccountprofile) | **PATCH** /{accountPortal}/account/profile |
*AgreementsApi* | [**listCurrentAgreements**](docs/AgreementsApi.md#listcurrentagreements) | **GET** /agreements/current |
*AuthenticationApi* | [**acceptAdminInvitation**](docs/AuthenticationApi.md#acceptadmininvitation) | **POST** /auth/admin-invitations/accept |
*AuthenticationApi* | [**completeGoogleOidc**](docs/AuthenticationApi.md#completegoogleoidc) | **GET** /auth/google/callback |
*AuthenticationApi* | [**completeMfaChallenge**](docs/AuthenticationApi.md#completemfachallenge) | **POST** /auth/mfa/challenge |
*AuthenticationApi* | [**confirmMfaEnrollment**](docs/AuthenticationApi.md#confirmmfaenrollment) | **POST** /auth/mfa/enrollment/confirm |
*AuthenticationApi* | [**exchangeBuyerMobileGoogleCode**](docs/AuthenticationApi.md#exchangebuyermobilegooglecode) | **POST** /mobile/auth/google/exchange |
*AuthenticationApi* | [**getBuyerMobileSession**](docs/AuthenticationApi.md#getbuyermobilesession) | **GET** /mobile/auth/session |
*AuthenticationApi* | [**getMfaChallengeStatus**](docs/AuthenticationApi.md#getmfachallengestatus) | **GET** /auth/mfa/status |
*AuthenticationApi* | [**getSession**](docs/AuthenticationApi.md#getsession) | **GET** /auth/session |
*AuthenticationApi* | [**issueWebCsrfToken**](docs/AuthenticationApi.md#issuewebcsrftoken) | **GET** /auth/csrf |
*AuthenticationApi* | [**login**](docs/AuthenticationApi.md#loginoperation) | **POST** /auth/login |
*AuthenticationApi* | [**loginBuyerMobile**](docs/AuthenticationApi.md#loginbuyermobile) | **POST** /mobile/auth/login |
*AuthenticationApi* | [**logout**](docs/AuthenticationApi.md#logout) | **POST** /auth/logout |
*AuthenticationApi* | [**logoutBuyerMobile**](docs/AuthenticationApi.md#logoutbuyermobile) | **POST** /mobile/auth/logout |
*AuthenticationApi* | [**recoverMfaChallenge**](docs/AuthenticationApi.md#recovermfachallenge) | **POST** /auth/mfa/recovery |
*AuthenticationApi* | [**refreshBuyerMobileSession**](docs/AuthenticationApi.md#refreshbuyermobilesession) | **POST** /mobile/auth/refresh |
*AuthenticationApi* | [**refreshSession**](docs/AuthenticationApi.md#refreshsession) | **POST** /auth/refresh |
*AuthenticationApi* | [**registerAccount**](docs/AuthenticationApi.md#registeraccount) | **POST** /auth/register |
*AuthenticationApi* | [**registerBuyerMobile**](docs/AuthenticationApi.md#registerbuyermobile) | **POST** /mobile/auth/register |
*AuthenticationApi* | [**requestBuyerMobilePasswordRecovery**](docs/AuthenticationApi.md#requestbuyermobilepasswordrecovery) | **POST** /mobile/auth/password/forgot |
*AuthenticationApi* | [**requestPasswordRecovery**](docs/AuthenticationApi.md#requestpasswordrecovery) | **POST** /auth/password/forgot |
*AuthenticationApi* | [**resendBotChallenge**](docs/AuthenticationApi.md#resendbotchallengeoperation) | **POST** /auth/bot-challenges/{challenge_id}/resend |
*AuthenticationApi* | [**resendBuyerMobileBotChallenge**](docs/AuthenticationApi.md#resendbuyermobilebotchallenge) | **POST** /mobile/auth/bot-challenges/{challenge_id}/resend |
*AuthenticationApi* | [**resendBuyerMobileEmailVerification**](docs/AuthenticationApi.md#resendbuyermobileemailverification) | **POST** /mobile/auth/verify-email/resend |
*AuthenticationApi* | [**resendEmailVerification**](docs/AuthenticationApi.md#resendemailverification) | **POST** /auth/verify-email/resend |
*AuthenticationApi* | [**resetBuyerMobilePassword**](docs/AuthenticationApi.md#resetbuyermobilepassword) | **POST** /mobile/auth/password/reset |
*AuthenticationApi* | [**resetPassword**](docs/AuthenticationApi.md#resetpassword) | **POST** /auth/password/reset |
*AuthenticationApi* | [**startBuyerMobileGoogleOidc**](docs/AuthenticationApi.md#startbuyermobilegoogleoidc) | **POST** /mobile/auth/google/start |
*AuthenticationApi* | [**startGoogleOidc**](docs/AuthenticationApi.md#startgoogleoidc) | **POST** /auth/google/start |
*AuthenticationApi* | [**startMfaEnrollment**](docs/AuthenticationApi.md#startmfaenrollment) | **POST** /auth/mfa/enrollment |
*AuthenticationApi* | [**verifyBotChallenge**](docs/AuthenticationApi.md#verifybotchallengeoperation) | **POST** /auth/bot-challenges/{challenge_id}/verify |
*AuthenticationApi* | [**verifyBuyerMobileBotChallenge**](docs/AuthenticationApi.md#verifybuyermobilebotchallenge) | **POST** /mobile/auth/bot-challenges/{challenge_id}/verify |
*AuthenticationApi* | [**verifyBuyerMobileEmail**](docs/AuthenticationApi.md#verifybuyermobileemail) | **POST** /mobile/auth/verify-email |
*AuthenticationApi* | [**verifyEmail**](docs/AuthenticationApi.md#verifyemailoperation) | **POST** /auth/verify-email |
*SystemApi* | [**getApiHealth**](docs/SystemApi.md#getapihealth) | **GET** /health |
*VendorOnboardingApi* | [**acceptVendorCommissionTerms**](docs/VendorOnboardingApi.md#acceptvendorcommissionterms) | **POST** /vendors/{organization}/commission-terms/acceptance | accept Vendor Commission Terms
*VendorOnboardingApi* | [**activateVendorMarketplace**](docs/VendorOnboardingApi.md#activatevendormarketplace) | **POST** /vendors/{organization}/activation | activate Vendor Marketplace
*VendorOnboardingApi* | [**changeVendorTeamMember**](docs/VendorOnboardingApi.md#changevendorteammember) | **PATCH** /vendors/{organization}/team/memberships/{membership} | change Vendor Team Member
*VendorOnboardingApi* | [**confirmVendorStoreEmailVerification**](docs/VendorOnboardingApi.md#confirmvendorstoreemailverification) | **POST** /vendors/{organization}/business/store-email/verification/confirm | confirm Vendor Store Email Verification
*VendorOnboardingApi* | [**connectVendorTest**](docs/VendorOnboardingApi.md#connectvendortest) | **POST** /vendors/{organization}/payment-connection | connect Vendor Test
*VendorOnboardingApi* | [**downloadAdminVendorDocument**](docs/VendorOnboardingApi.md#downloadadminvendordocument) | **GET** /admin/vendor-verification/{organization}/documents/{version}/download | download Admin Vendor Document
*VendorOnboardingApi* | [**downloadVendorDocument**](docs/VendorOnboardingApi.md#downloadvendordocument) | **GET** /vendors/{organization}/documents/{version}/download | download Vendor Document
*VendorOnboardingApi* | [**getAdminVendorBusiness**](docs/VendorOnboardingApi.md#getadminvendorbusiness) | **GET** /admin/vendor-verification/{organization}/business | get Admin Vendor Business
*VendorOnboardingApi* | [**getAdminVendorReadiness**](docs/VendorOnboardingApi.md#getadminvendorreadiness) | **GET** /admin/vendor-verification/{organization}/onboarding | get Admin Vendor Readiness
*VendorOnboardingApi* | [**getAdminVendorTaxProfile**](docs/VendorOnboardingApi.md#getadminvendortaxprofile) | **GET** /admin/vendor-verification/{organization}/tax-profile | get Admin Vendor Tax Profile
*VendorOnboardingApi* | [**getPublicVendorStoreMedia**](docs/VendorOnboardingApi.md#getpublicvendorstoremedia) | **GET** /public/vendors/{organization}/store-media/{media} | get Public Vendor Store Media
*VendorOnboardingApi* | [**getVendorBusiness**](docs/VendorOnboardingApi.md#getvendorbusiness) | **GET** /vendors/{organization}/business | get Vendor Business
*VendorOnboardingApi* | [**getVendorCommissionTerms**](docs/VendorOnboardingApi.md#getvendorcommissionterms) | **GET** /vendors/{organization}/commission-terms | get Vendor Commission Terms
*VendorOnboardingApi* | [**getVendorReadiness**](docs/VendorOnboardingApi.md#getvendorreadiness) | **GET** /vendors/{organization}/onboarding | get Vendor Readiness
*VendorOnboardingApi* | [**getVendorSetup**](docs/VendorOnboardingApi.md#getvendorsetup) | **GET** /vendors/{organization}/setup | get Vendor Setup
*VendorOnboardingApi* | [**getVendorTaxProfile**](docs/VendorOnboardingApi.md#getvendortaxprofile) | **GET** /vendors/{organization}/tax-profile | get Vendor Tax Profile
*VendorOnboardingApi* | [**getVendorTeam**](docs/VendorOnboardingApi.md#getvendorteam) | **GET** /vendors/{organization}/team | get Vendor Team
*VendorOnboardingApi* | [**inviteVendorTeam**](docs/VendorOnboardingApi.md#invitevendorteam) | **POST** /vendors/{organization}/team/invitations | invite Vendor Team
*VendorOnboardingApi* | [**issueAdminVendorDocumentLink**](docs/VendorOnboardingApi.md#issueadminvendordocumentlink) | **POST** /admin/vendor-verification/{organization}/documents/{version}/download-link | issue Admin Vendor Document Link
*VendorOnboardingApi* | [**issueVendorDocumentLink**](docs/VendorOnboardingApi.md#issuevendordocumentlink) | **POST** /vendors/{organization}/documents/{version}/download-link | issue Vendor Document Link
*VendorOnboardingApi* | [**listAdminVendorDocuments**](docs/VendorOnboardingApi.md#listadminvendordocuments) | **GET** /admin/vendor-verification/{organization}/documents | list Admin Vendor Documents
*VendorOnboardingApi* | [**listAdminVendorStoreMedia**](docs/VendorOnboardingApi.md#listadminvendorstoremedia) | **GET** /admin/vendor-verification/{organization}/store-media | list Admin Vendor Store Media
*VendorOnboardingApi* | [**listVendorDocuments**](docs/VendorOnboardingApi.md#listvendordocuments) | **GET** /vendors/{organization}/documents | list Vendor Documents
*VendorOnboardingApi* | [**listVendorStoreMedia**](docs/VendorOnboardingApi.md#listvendorstoremedia) | **GET** /vendors/{organization}/store-media | list Vendor Store Media
*VendorOnboardingApi* | [**listVendorTeamInvitations**](docs/VendorOnboardingApi.md#listvendorteaminvitations) | **GET** /vendors/{organization}/team/invitations | list Vendor Team Invitations
*VendorOnboardingApi* | [**listVendorVerificationQueue**](docs/VendorOnboardingApi.md#listvendorverificationqueue) | **GET** /admin/vendor-verification | list Vendor Verification Queue
*VendorOnboardingApi* | [**previewAdminVendorStoreMedia**](docs/VendorOnboardingApi.md#previewadminvendorstoremedia) | **GET** /admin/vendor-verification/{organization}/store-media/{media} | preview Admin Vendor Store Media
*VendorOnboardingApi* | [**previewVendorStoreMedia**](docs/VendorOnboardingApi.md#previewvendorstoremedia) | **GET** /vendors/{organization}/store-media/{media} | preview Vendor Store Media
*VendorOnboardingApi* | [**reconcileVendorTestConnection**](docs/VendorOnboardingApi.md#reconcilevendortestconnection) | **POST** /vendors/{organization}/payment-connection/reconciliation | reconcile Vendor Test Connection
*VendorOnboardingApi* | [**removeVendorStoreMedia**](docs/VendorOnboardingApi.md#removevendorstoremedia) | **POST** /vendors/{organization}/store-media/{media}/remove | remove Vendor Store Media
*VendorOnboardingApi* | [**requestVendorStoreEmailVerification**](docs/VendorOnboardingApi.md#requestvendorstoreemailverification) | **POST** /vendors/{organization}/business/store-email/verification | request Vendor Store Email Verification
*VendorOnboardingApi* | [**reviewVendorBusiness**](docs/VendorOnboardingApi.md#reviewvendorbusiness) | **POST** /admin/vendor-verification/{organization}/business/reviews | review Vendor Business
*VendorOnboardingApi* | [**reviewVendorDocument**](docs/VendorOnboardingApi.md#reviewvendordocument) | **POST** /admin/vendor-verification/{organization}/documents/{version}/reviews | review Vendor Document
*VendorOnboardingApi* | [**reviewVendorStoreMedia**](docs/VendorOnboardingApi.md#reviewvendorstoremedia) | **POST** /admin/vendor-verification/{organization}/store-media/{media}/reviews | review Vendor Store Media
*VendorOnboardingApi* | [**reviewVendorTaxProfile**](docs/VendorOnboardingApi.md#reviewvendortaxprofile) | **POST** /admin/vendor-verification/{organization}/tax-profile/versions/{version}/reviews | review Vendor Tax Profile
*VendorOnboardingApi* | [**revokeVendorTeamInvitation**](docs/VendorOnboardingApi.md#revokevendorteaminvitation) | **POST** /vendors/{organization}/team/invitations/{invitation}/revoke | revoke Vendor Team Invitation
*VendorOnboardingApi* | [**saveVendorBusiness**](docs/VendorOnboardingApi.md#savevendorbusiness) | **PUT** /vendors/{organization}/business | save Vendor Business
*VendorOnboardingApi* | [**saveVendorStore**](docs/VendorOnboardingApi.md#savevendorstore) | **PUT** /vendors/{organization}/store-profile | save Vendor Store
*VendorOnboardingApi* | [**saveVendorTaxProfile**](docs/VendorOnboardingApi.md#savevendortaxprofile) | **POST** /vendors/{organization}/tax-profile/versions | save Vendor Tax Profile
*VendorOnboardingApi* | [**uploadVendorDocument**](docs/VendorOnboardingApi.md#uploadvendordocument) | **POST** /vendors/{organization}/documents | upload Vendor Document
*VendorOnboardingApi* | [**uploadVendorStoreMedia**](docs/VendorOnboardingApi.md#uploadvendorstoremedia) | **POST** /vendors/{organization}/store-media | upload Vendor Store Media


### Models

- [AcceptVendorCommission](docs/AcceptVendorCommission.md)
- [AccountAdminChange](docs/AccountAdminChange.md)
- [AccountAdminInvitation](docs/AccountAdminInvitation.md)
- [AccountAdministrator](docs/AccountAdministrator.md)
- [AccountAdministratorListEnvelope](docs/AccountAdministratorListEnvelope.md)
- [AccountAgreement](docs/AccountAgreement.md)
- [AccountAgreementAcceptance](docs/AccountAgreementAcceptance.md)
- [AccountAgreementListEnvelope](docs/AccountAgreementListEnvelope.md)
- [AccountCodeConfirmation](docs/AccountCodeConfirmation.md)
- [AccountDelegation](docs/AccountDelegation.md)
- [AccountEmailChange](docs/AccountEmailChange.md)
- [AccountFactorEnrollment](docs/AccountFactorEnrollment.md)
- [AccountFactorEnrollmentEnvelope](docs/AccountFactorEnrollmentEnvelope.md)
- [AccountMembership](docs/AccountMembership.md)
- [AccountMembershipListEnvelope](docs/AccountMembershipListEnvelope.md)
- [AccountMembershipStatus](docs/AccountMembershipStatus.md)
- [AccountMutationResult](docs/AccountMutationResult.md)
- [AccountMutationResultEnvelope](docs/AccountMutationResultEnvelope.md)
- [AccountPasswordChange](docs/AccountPasswordChange.md)
- [AccountPendingChange](docs/AccountPendingChange.md)
- [AccountPendingChangeEnvelope](docs/AccountPendingChangeEnvelope.md)
- [AccountProfile](docs/AccountProfile.md)
- [AccountProfileEnvelope](docs/AccountProfileEnvelope.md)
- [AccountProfileUpdate](docs/AccountProfileUpdate.md)
- [AccountReauthentication](docs/AccountReauthentication.md)
- [AccountRecoveryCodes](docs/AccountRecoveryCodes.md)
- [AccountRecoveryCodesEnvelope](docs/AccountRecoveryCodesEnvelope.md)
- [AccountRole](docs/AccountRole.md)
- [AccountRoleListEnvelope](docs/AccountRoleListEnvelope.md)
- [AccountSecurity](docs/AccountSecurity.md)
- [AccountSecurityEnvelope](docs/AccountSecurityEnvelope.md)
- [AccountSession](docs/AccountSession.md)
- [AccountSessionListEnvelope](docs/AccountSessionListEnvelope.md)
- [AccountSessionRevocation](docs/AccountSessionRevocation.md)
- [AccountType](docs/AccountType.md)
- [AdminInvitationRequest](docs/AdminInvitationRequest.md)
- [Agreement](docs/Agreement.md)
- [AgreementListEnvelope](docs/AgreementListEnvelope.md)
- [ApiError](docs/ApiError.md)
- [AuthEnvelope](docs/AuthEnvelope.md)
- [AuthEnvelopeAllOfData](docs/AuthEnvelopeAllOfData.md)
- [BotProofEnvelope](docs/BotProofEnvelope.md)
- [BotProofEnvelopeAllOfData](docs/BotProofEnvelopeAllOfData.md)
- [BotStepUpErrorEnvelope](docs/BotStepUpErrorEnvelope.md)
- [BotStepUpErrorEnvelopeAllOfErrors](docs/BotStepUpErrorEnvelopeAllOfErrors.md)
- [BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails](docs/BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails.md)
- [BuyerMobileGoogleOidcStartRequest](docs/BuyerMobileGoogleOidcStartRequest.md)
- [BuyerMobileLoginRequest](docs/BuyerMobileLoginRequest.md)
- [BuyerMobilePasswordRecoveryRequest](docs/BuyerMobilePasswordRecoveryRequest.md)
- [BuyerMobileRefreshRequest](docs/BuyerMobileRefreshRequest.md)
- [BuyerMobileRegisterRequest](docs/BuyerMobileRegisterRequest.md)
- [ChangeVendorTeamMember](docs/ChangeVendorTeamMember.md)
- [ConnectVendorTest](docs/ConnectVendorTest.md)
- [CsrfEnvelope](docs/CsrfEnvelope.md)
- [CsrfEnvelopeAllOfData](docs/CsrfEnvelopeAllOfData.md)
- [EmailRequest](docs/EmailRequest.md)
- [ErrorEnvelope](docs/ErrorEnvelope.md)
- [FeeAssessment](docs/FeeAssessment.md)
- [FinancialSnapshot](docs/FinancialSnapshot.md)
- [GoogleMobileExchangeRequest](docs/GoogleMobileExchangeRequest.md)
- [GoogleOidcStartRequest](docs/GoogleOidcStartRequest.md)
- [HealthEnvelope](docs/HealthEnvelope.md)
- [HealthEnvelopeAllOfData](docs/HealthEnvelopeAllOfData.md)
- [InviteVendorTeam](docs/InviteVendorTeam.md)
- [LoginRequest](docs/LoginRequest.md)
- [MaterialPriceObservation](docs/MaterialPriceObservation.md)
- [MfaCodeRequest](docs/MfaCodeRequest.md)
- [MfaEnrollmentEnvelope](docs/MfaEnrollmentEnvelope.md)
- [MfaEnrollmentEnvelopeAllOfData](docs/MfaEnrollmentEnvelopeAllOfData.md)
- [MfaRecoveryRequest](docs/MfaRecoveryRequest.md)
- [MfaStatusEnvelope](docs/MfaStatusEnvelope.md)
- [MfaStatusEnvelopeAllOfData](docs/MfaStatusEnvelopeAllOfData.md)
- [PasswordRecoveryRequest](docs/PasswordRecoveryRequest.md)
- [PasswordResetRequest](docs/PasswordResetRequest.md)
- [RegisterRequest](docs/RegisterRequest.md)
- [RegistrationEnvelope](docs/RegistrationEnvelope.md)
- [RegistrationEnvelopeAllOfData](docs/RegistrationEnvelopeAllOfData.md)
- [ResendBotChallengeRequest](docs/ResendBotChallengeRequest.md)
- [SaveVendorBusiness](docs/SaveVendorBusiness.md)
- [SaveVendorStore](docs/SaveVendorStore.md)
- [SaveVendorStoreRefundConfiguration](docs/SaveVendorStoreRefundConfiguration.md)
- [SaveVendorTax](docs/SaveVendorTax.md)
- [SuccessEnvelope](docs/SuccessEnvelope.md)
- [UserIdentity](docs/UserIdentity.md)
- [VendorBotProtectionEvidence](docs/VendorBotProtectionEvidence.md)
- [VendorBusiness](docs/VendorBusiness.md)
- [VendorBusinessAddress](docs/VendorBusinessAddress.md)
- [VendorBusinessContact](docs/VendorBusinessContact.md)
- [VendorBusinessDraft](docs/VendorBusinessDraft.md)
- [VendorBusinessEnvelope](docs/VendorBusinessEnvelope.md)
- [VendorBusinessReview](docs/VendorBusinessReview.md)
- [VendorChecklistItem](docs/VendorChecklistItem.md)
- [VendorCommissionTerms](docs/VendorCommissionTerms.md)
- [VendorCommissionTermsEnvelope](docs/VendorCommissionTermsEnvelope.md)
- [VendorConnection](docs/VendorConnection.md)
- [VendorDocument](docs/VendorDocument.md)
- [VendorDocumentListEnvelope](docs/VendorDocumentListEnvelope.md)
- [VendorDocumentReview](docs/VendorDocumentReview.md)
- [VendorDocumentUpload](docs/VendorDocumentUpload.md)
- [VendorDocumentUploadEnvelope](docs/VendorDocumentUploadEnvelope.md)
- [VendorDownloadLink](docs/VendorDownloadLink.md)
- [VendorDownloadLinkEnvelope](docs/VendorDownloadLinkEnvelope.md)
- [VendorIndividualRegisteredName](docs/VendorIndividualRegisteredName.md)
- [VendorInvitationAcceptance](docs/VendorInvitationAcceptance.md)
- [VendorMutationEnvelope](docs/VendorMutationEnvelope.md)
- [VendorOperatingDay](docs/VendorOperatingDay.md)
- [VendorReadiness](docs/VendorReadiness.md)
- [VendorReadinessEnvelope](docs/VendorReadinessEnvelope.md)
- [VendorReview](docs/VendorReview.md)
- [VendorSetup](docs/VendorSetup.md)
- [VendorSetupEnvelope](docs/VendorSetupEnvelope.md)
- [VendorStore](docs/VendorStore.md)
- [VendorStoreEmailVerification](docs/VendorStoreEmailVerification.md)
- [VendorStoreEmailVerificationConfirmation](docs/VendorStoreEmailVerificationConfirmation.md)
- [VendorStoreEmailVerificationRequest](docs/VendorStoreEmailVerificationRequest.md)
- [VendorStoreMedia](docs/VendorStoreMedia.md)
- [VendorStoreMediaListEnvelope](docs/VendorStoreMediaListEnvelope.md)
- [VendorTaxData](docs/VendorTaxData.md)
- [VendorTaxProfile](docs/VendorTaxProfile.md)
- [VendorTaxProfileEnvelope](docs/VendorTaxProfileEnvelope.md)
- [VendorTaxProfileEvidenceVersionsInner](docs/VendorTaxProfileEvidenceVersionsInner.md)
- [VendorTaxReviewHistory](docs/VendorTaxReviewHistory.md)
- [VendorTaxVersionHistory](docs/VendorTaxVersionHistory.md)
- [VendorTeam](docs/VendorTeam.md)
- [VendorTeamEnvelope](docs/VendorTeamEnvelope.md)
- [VendorTeamInvitation](docs/VendorTeamInvitation.md)
- [VendorTeamInvitationListEnvelope](docs/VendorTeamInvitationListEnvelope.md)
- [VendorTeamMember](docs/VendorTeamMember.md)
- [VendorVehicle](docs/VendorVehicle.md)
- [VendorVerificationRow](docs/VendorVerificationRow.md)
- [VendorVerificationRowListEnvelope](docs/VendorVerificationRowListEnvelope.md)
- [VendorVersionMutation](docs/VendorVersionMutation.md)
- [VerifyBotChallengeRequest](docs/VerifyBotChallengeRequest.md)
- [VerifyEmailRequest](docs/VerifyEmailRequest.md)

### Authorization


Authentication schemes defined for the API:
<a id="passportBearer"></a>
#### passportBearer


- **Type**: HTTP Bearer Token authentication (JWT)
<a id="accessCookie"></a>
#### accessCookie


- **Type**: API key
- **API key parameter name**: `mp_access`
- **Location**:
<a id="mfaChallengeCookie"></a>
#### mfaChallengeCookie


- **Type**: API key
- **API key parameter name**: `mp_mfa_challenge`
- **Location**:
<a id="botProofCookie"></a>
#### botProofCookie


- **Type**: API key
- **API key parameter name**: `mp_bot_proof`
- **Location**:
<a id="webCsrf"></a>
#### webCsrf


- **Type**: API key
- **API key parameter name**: `X-CSRF-Token`
- **Location**: HTTP header

## About

This TypeScript SDK client supports the [Fetch API](https://fetch.spec.whatwg.org/)
and is automatically generated by the
[OpenAPI Generator](https://openapi-generator.tech) project:

- API version: `1.0.0-phase.3`
- Package version: `1.0.0-phase.3`
- Generator version: `7.25.0`
- Build package: `org.openapitools.codegen.languages.TypeScriptFetchClientCodegen`

The generated npm module supports the following:

- Environments
  * Node.js
  * Webpack
  * Browserify
- Language levels
  * ES5 - you must have a Promises/A+ library installed
  * ES6
- Module systems
  * CommonJS
  * ES6 module system


## Development

### Building

To build the TypeScript source code, you need to have Node.js and npm installed.
After cloning the repository, navigate to the project directory and run:

```bash
npm install
npm run build
```

### Publishing

Once you've built the package, you can publish it to npm:

```bash
npm publish
```

## License

[]()
