# @materyalph/api-client-ts@1.0.0-phase.5

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
*AccountsApi* | [**getAccountPhoto**](docs/AccountsApi.md#getaccountphoto) | **GET** /{webAccountPortal}/account/photo |
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
*AccountsApi* | [**updateVendorStaff**](docs/AccountsApi.md#updatevendorstaff) | **PATCH** /vendors/account/memberships/{membershipId} |
*AccountsApi* | [**uploadAccountPhoto**](docs/AccountsApi.md#uploadaccountphoto) | **POST** /{webAccountPortal}/account/photo |
*AdminProductComplianceApi* | [**activateComplianceRegister**](docs/AdminProductComplianceApi.md#activatecomplianceregister) | **POST** /admin/product-compliance/registers/{registerId}/activate |
*AdminProductComplianceApi* | [**createComparableGroup**](docs/AdminProductComplianceApi.md#createcomparablegroup) | **POST** /admin/taxonomy/comparable-groups |
*AdminProductComplianceApi* | [**decideProductCompliance**](docs/AdminProductComplianceApi.md#decideproductcompliance) | **POST** /admin/product-compliance/{submissionId}/decision |
*AdminProductComplianceApi* | [**getProductComplianceCase**](docs/AdminProductComplianceApi.md#getproductcompliancecase) | **GET** /admin/product-compliance/{submissionId} |
*AdminProductComplianceApi* | [**getProductComplianceFileUrl**](docs/AdminProductComplianceApi.md#getproductcompliancefileurl) | **GET** /admin/product-compliance/files/{fileId} |
*AdminProductComplianceApi* | [**importComplianceRegister**](docs/AdminProductComplianceApi.md#importcomplianceregister) | **POST** /admin/product-compliance/registers |
*AdminProductComplianceApi* | [**listComplianceRegisters**](docs/AdminProductComplianceApi.md#listcomplianceregisters) | **GET** /admin/product-compliance/registers |
*AdminProductComplianceApi* | [**listProductComplianceQueue**](docs/AdminProductComplianceApi.md#listproductcompliancequeue) | **GET** /admin/product-compliance |
*AdminVendorVerificationApi* | [**decideVendorVerificationRequirement**](docs/AdminVendorVerificationApi.md#decidevendorverificationrequirement) | **POST** /admin/vendor-verification/{organizationId}/requirements/{requirementKey}/decision |
*AdminVendorVerificationApi* | [**getAdminDashboard**](docs/AdminVendorVerificationApi.md#getadmindashboard) | **GET** /admin/dashboard |
*AdminVendorVerificationApi* | [**getAdminVendorEvidenceUrl**](docs/AdminVendorVerificationApi.md#getadminvendorevidenceurl) | **GET** /admin/vendor-verification/files/{fileId} |
*AdminVendorVerificationApi* | [**getVendorVerificationCase**](docs/AdminVendorVerificationApi.md#getvendorverificationcase) | **GET** /admin/vendor-verification/{organizationId} |
*AdminVendorVerificationApi* | [**listAdminDashboardAudit**](docs/AdminVendorVerificationApi.md#listadmindashboardaudit) | **GET** /admin/dashboard/audit |
*AdminVendorVerificationApi* | [**listVendorVerificationQueue**](docs/AdminVendorVerificationApi.md#listvendorverificationqueue) | **GET** /admin/vendor-verification |
*AdminVendorVerificationApi* | [**restoreVendorActivation**](docs/AdminVendorVerificationApi.md#restorevendoractivation) | **POST** /admin/vendor-verification/{organizationId}/restore |
*AdminVendorVerificationApi* | [**restrictVendorActivation**](docs/AdminVendorVerificationApi.md#restrictvendoractivation) | **POST** /admin/vendor-verification/{organizationId}/restrict |
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
*StoresApi* | [**getPublicStoreProfile**](docs/StoresApi.md#getpublicstoreprofile) | **GET** /stores/{storeId}/profile |
*StoresApi* | [**listPublicStores**](docs/StoresApi.md#listpublicstores) | **GET** /stores |
*SystemApi* | [**getApiHealth**](docs/SystemApi.md#getapihealth) | **GET** /health |
*VendorAutoAcceptApi* | [**configureAutoAcceptPolicy**](docs/VendorAutoAcceptApi.md#configureautoacceptpolicy) | **PUT** /vendor/auto-accept/policies/{variantId} |
*VendorAutoAcceptApi* | [**getAutoAcceptPolicy**](docs/VendorAutoAcceptApi.md#getautoacceptpolicy) | **GET** /vendor/auto-accept/policies/{variantId} |
*VendorAutoAcceptApi* | [**pauseAutoAcceptPolicy**](docs/VendorAutoAcceptApi.md#pauseautoacceptpolicy) | **POST** /vendor/auto-accept/policies/{variantId}/pause |
*VendorAutoAcceptApi* | [**resumeAutoAcceptPolicy**](docs/VendorAutoAcceptApi.md#resumeautoacceptpolicy) | **POST** /vendor/auto-accept/policies/{variantId}/resume |
*VendorAutoAcceptApi* | [**updateAutoAcceptAllotment**](docs/VendorAutoAcceptApi.md#updateautoacceptallotment) | **PATCH** /vendor/auto-accept/policies/{variantId}/allotment |
*VendorCatalogApi* | [**applyCatalogImport**](docs/VendorCatalogApi.md#applycatalogimport) | **POST** /vendor/catalog/imports/{jobId}/apply |
*VendorCatalogApi* | [**createVendorCatalogListing**](docs/VendorCatalogApi.md#createvendorcataloglisting) | **POST** /vendor/catalog/listings |
*VendorCatalogApi* | [**deactivateVendorCatalogListing**](docs/VendorCatalogApi.md#deactivatevendorcataloglisting) | **POST** /vendor/catalog/listings/{listingId}/deactivate |
*VendorCatalogApi* | [**deleteVendorCatalogListing**](docs/VendorCatalogApi.md#deletevendorcataloglisting) | **DELETE** /vendor/catalog/listings/{listingId} |
*VendorCatalogApi* | [**downloadCatalogFile**](docs/VendorCatalogApi.md#downloadcatalogfile) | **GET** /catalog-files/{fileId}/content |
*VendorCatalogApi* | [**getCatalogImport**](docs/VendorCatalogApi.md#getcatalogimport) | **GET** /vendor/catalog/imports/{jobId} |
*VendorCatalogApi* | [**getCatalogImportTemplate**](docs/VendorCatalogApi.md#getcatalogimporttemplate) | **GET** /vendor/catalog/imports/template |
*VendorCatalogApi* | [**getCatalogMaterial**](docs/VendorCatalogApi.md#getcatalogmaterial) | **GET** /vendor/catalog/materials/{materialId} |
*VendorCatalogApi* | [**getVendorCatalogFileUrl**](docs/VendorCatalogApi.md#getvendorcatalogfileurl) | **GET** /vendor/catalog/files/{fileId} |
*VendorCatalogApi* | [**getVendorCatalogListing**](docs/VendorCatalogApi.md#getvendorcataloglisting) | **GET** /vendor/catalog/listings/{listingId} |
*VendorCatalogApi* | [**getVendorCatalogTaxonomy**](docs/VendorCatalogApi.md#getvendorcatalogtaxonomy) | **GET** /vendor/catalog/taxonomy |
*VendorCatalogApi* | [**listVendorCatalogListings**](docs/VendorCatalogApi.md#listvendorcataloglistings) | **GET** /vendor/catalog/listings |
*VendorCatalogApi* | [**publishVendorCatalogListing**](docs/VendorCatalogApi.md#publishvendorcataloglisting) | **POST** /vendor/catalog/listings/{listingId}/publish |
*VendorCatalogApi* | [**removeVendorListingMedia**](docs/VendorCatalogApi.md#removevendorlistingmedia) | **DELETE** /vendor/catalog/listings/{listingId}/media/{mediaId} |
*VendorCatalogApi* | [**saveVendorCatalogVariants**](docs/VendorCatalogApi.md#savevendorcatalogvariants) | **PUT** /vendor/catalog/listings/{listingId}/variants |
*VendorCatalogApi* | [**searchCatalogMaterials**](docs/VendorCatalogApi.md#searchcatalogmaterials) | **GET** /vendor/catalog/materials/search |
*VendorCatalogApi* | [**submitListingCompliance**](docs/VendorCatalogApi.md#submitlistingcompliance) | **POST** /vendor/catalog/listings/{listingId}/compliance |
*VendorCatalogApi* | [**updateVendorCatalogListing**](docs/VendorCatalogApi.md#updatevendorcataloglisting) | **PATCH** /vendor/catalog/listings/{listingId} |
*VendorCatalogApi* | [**uploadCatalogImport**](docs/VendorCatalogApi.md#uploadcatalogimport) | **POST** /vendor/catalog/imports |
*VendorCatalogApi* | [**uploadListingComplianceEvidence**](docs/VendorCatalogApi.md#uploadlistingcomplianceevidence) | **POST** /vendor/catalog/listings/{listingId}/compliance/evidence |
*VendorCatalogApi* | [**uploadVendorListingMedia**](docs/VendorCatalogApi.md#uploadvendorlistingmedia) | **POST** /vendor/catalog/listings/{listingId}/media |
*VendorFleetApi* | [**downloadFleetVehicleImage**](docs/VendorFleetApi.md#downloadfleetvehicleimage) | **GET** /fleet-files/{fileId}/content |
*VendorFleetApi* | [**getFleetVehicleImageUrl**](docs/VendorFleetApi.md#getfleetvehicleimageurl) | **GET** /vendor/fleet/vehicle-images/{fileId} |
*VendorFleetApi* | [**listVendorFleetVehicles**](docs/VendorFleetApi.md#listvendorfleetvehicles) | **GET** /vendor/fleet/vehicles |
*VendorFleetApi* | [**saveVendorFleetVehicles**](docs/VendorFleetApi.md#savevendorfleetvehicles) | **PUT** /vendor/fleet/vehicles |
*VendorFleetApi* | [**uploadFleetVehicleImage**](docs/VendorFleetApi.md#uploadfleetvehicleimage) | **POST** /vendor/fleet/vehicle-images |
*VendorInventoryApi* | [**confirmVendorStock**](docs/VendorInventoryApi.md#confirmvendorstock) | **POST** /vendor/inventory/confirmations |
*VendorInventoryApi* | [**getVendorInventorySettings**](docs/VendorInventoryApi.md#getvendorinventorysettings) | **GET** /vendor/inventory/settings |
*VendorInventoryApi* | [**listVendorInventoryItems**](docs/VendorInventoryApi.md#listvendorinventoryitems) | **GET** /vendor/inventory/items |
*VendorInventoryApi* | [**listVendorInventoryMovements**](docs/VendorInventoryApi.md#listvendorinventorymovements) | **GET** /vendor/inventory/items/{variantId}/movements |
*VendorInventoryApi* | [**listVendorPriceHistory**](docs/VendorInventoryApi.md#listvendorpricehistory) | **GET** /vendor/inventory/items/{variantId}/prices |
*VendorInventoryApi* | [**saveVendorInventorySettings**](docs/VendorInventoryApi.md#savevendorinventorysettings) | **PUT** /vendor/inventory/settings |
*VendorInventoryApi* | [**updateVendorInventoryItem**](docs/VendorInventoryApi.md#updatevendorinventoryitem) | **PATCH** /vendor/inventory/items/{variantId} |
*VendorOnboardingApi* | [**acceptVendorCommission**](docs/VendorOnboardingApi.md#acceptvendorcommission) | **POST** /vendors/onboarding/verification/commission |
*VendorOnboardingApi* | [**activateVendorStore**](docs/VendorOnboardingApi.md#activatevendorstore) | **POST** /vendors/onboarding/activation |
*VendorOnboardingApi* | [**changeVendorStaffDisputes**](docs/VendorOnboardingApi.md#changevendorstaffdisputes) | **PATCH** /vendors/account/staff-disputes |
*VendorOnboardingApi* | [**completeVendorSetup**](docs/VendorOnboardingApi.md#completevendorsetup) | **POST** /vendors/onboarding/setup/complete |
*VendorOnboardingApi* | [**confirmVendorStoreEmailVerification**](docs/VendorOnboardingApi.md#confirmvendorstoreemailverification) | **POST** /vendors/onboarding/store-email/confirm |
*VendorOnboardingApi* | [**connectVendorPayment**](docs/VendorOnboardingApi.md#connectvendorpayment) | **POST** /vendors/onboarding/payment-connection |
*VendorOnboardingApi* | [**dismissVendorOnboardingWelcome**](docs/VendorOnboardingApi.md#dismissvendoronboardingwelcome) | **POST** /vendors/onboarding/welcome/dismiss |
*VendorOnboardingApi* | [**downloadVendorOnboardingFile**](docs/VendorOnboardingApi.md#downloadvendoronboardingfile) | **GET** /vendor-onboarding-files/{fileId}/content |
*VendorOnboardingApi* | [**getAuthoritativeVendorOnboarding**](docs/VendorOnboardingApi.md#getauthoritativevendoronboarding) | **GET** /vendor/onboarding |
*VendorOnboardingApi* | [**getVendorOnboarding**](docs/VendorOnboardingApi.md#getvendoronboarding) | **GET** /vendors/onboarding |
*VendorOnboardingApi* | [**getVendorPrivateFileUrl**](docs/VendorOnboardingApi.md#getvendorprivatefileurl) | **GET** /vendors/onboarding/files/{fileId} |
*VendorOnboardingApi* | [**inviteVendorTeamMember**](docs/VendorOnboardingApi.md#invitevendorteammember) | **POST** /vendors/account/invitations |
*VendorOnboardingApi* | [**listVendorTeamActivity**](docs/VendorOnboardingApi.md#listvendorteamactivity) | **GET** /vendors/account/activity |
*VendorOnboardingApi* | [**listVendorTeamInvitations**](docs/VendorOnboardingApi.md#listvendorteaminvitations) | **GET** /vendors/account/invitations |
*VendorOnboardingApi* | [**previewVendorRequirements**](docs/VendorOnboardingApi.md#previewvendorrequirements) | **GET** /vendors/onboarding/requirements |
*VendorOnboardingApi* | [**receiveXenditAccountVerificationWebhook**](docs/VendorOnboardingApi.md#receivexenditaccountverificationwebhook) | **POST** /webhooks/xendit/account-verification |
*VendorOnboardingApi* | [**reconcileVendorPaymentConnection**](docs/VendorOnboardingApi.md#reconcilevendorpaymentconnection) | **POST** /vendors/onboarding/payment-connection/reconcile |
*VendorOnboardingApi* | [**removePendingVendorDocument**](docs/VendorOnboardingApi.md#removependingvendordocument) | **DELETE** /vendors/onboarding/documents/pending/{requirementKey} |
*VendorOnboardingApi* | [**removeVendorStoreMedia**](docs/VendorOnboardingApi.md#removevendorstoremedia) | **DELETE** /vendors/onboarding/media/{mediaId} |
*VendorOnboardingApi* | [**requestVendorStoreEmailVerification**](docs/VendorOnboardingApi.md#requestvendorstoreemailverification) | **POST** /vendors/onboarding/store-email |
*VendorOnboardingApi* | [**resolveVendorAddress**](docs/VendorOnboardingApi.md#resolvevendoraddress) | **POST** /vendors/onboarding/address/resolve |
*VendorOnboardingApi* | [**resolveVendorAddressPin**](docs/VendorOnboardingApi.md#resolvevendoraddresspin) | **POST** /vendors/onboarding/address/pin |
*VendorOnboardingApi* | [**reverseGeocodeVendorAddress**](docs/VendorOnboardingApi.md#reversegeocodevendoraddress) | **POST** /vendors/onboarding/address/geocode |
*VendorOnboardingApi* | [**saveVendorSetupDraft**](docs/VendorOnboardingApi.md#savevendorsetupdraft) | **PATCH** /vendors/onboarding/setup |
*VendorOnboardingApi* | [**saveVendorVerificationDraft**](docs/VendorOnboardingApi.md#savevendorverificationdraft) | **PATCH** /vendors/onboarding/verification |
*VendorOnboardingApi* | [**searchVendorAddressAreas**](docs/VendorOnboardingApi.md#searchvendoraddressareas) | **GET** /vendors/onboarding/address/areas |
*VendorOnboardingApi* | [**submitVendorVerification**](docs/VendorOnboardingApi.md#submitvendorverification) | **POST** /vendors/onboarding/verification/submit |
*VendorOnboardingApi* | [**uploadVendorStoreMedia**](docs/VendorOnboardingApi.md#uploadvendorstoremedia) | **POST** /vendors/onboarding/media |
*VendorOnboardingApi* | [**uploadVendorVerificationDocument**](docs/VendorOnboardingApi.md#uploadvendorverificationdocument) | **POST** /vendors/onboarding/documents |


### Models

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
- [AdminDashboardAuditEnvelope](docs/AdminDashboardAuditEnvelope.md)
- [AdminDashboardEnvelope](docs/AdminDashboardEnvelope.md)
- [AdminDashboardSummary](docs/AdminDashboardSummary.md)
- [AdminInvitationRequest](docs/AdminInvitationRequest.md)
- [AdminVendorVerificationDecision](docs/AdminVendorVerificationDecision.md)
- [AdminVendorVerificationDetailEnvelope](docs/AdminVendorVerificationDetailEnvelope.md)
- [AdminVendorVerificationQueueEnvelope](docs/AdminVendorVerificationQueueEnvelope.md)
- [AdminVendorVerificationQueueItem](docs/AdminVendorVerificationQueueItem.md)
- [Agreement](docs/Agreement.md)
- [AgreementListEnvelope](docs/AgreementListEnvelope.md)
- [ApiError](docs/ApiError.md)
- [AuthEnvelope](docs/AuthEnvelope.md)
- [AuthEnvelopeAllOfData](docs/AuthEnvelopeAllOfData.md)
- [AutoAcceptAllotmentUpdate](docs/AutoAcceptAllotmentUpdate.md)
- [AutoAcceptPause](docs/AutoAcceptPause.md)
- [AutoAcceptPolicy](docs/AutoAcceptPolicy.md)
- [AutoAcceptPolicyConfigure](docs/AutoAcceptPolicyConfigure.md)
- [AutoAcceptPolicyDetail](docs/AutoAcceptPolicyDetail.md)
- [AutoAcceptPolicyDetailEnvelope](docs/AutoAcceptPolicyDetailEnvelope.md)
- [AutoAcceptPolicyDetailPermissions](docs/AutoAcceptPolicyDetailPermissions.md)
- [AutoAcceptPolicyDetailScope](docs/AutoAcceptPolicyDetailScope.md)
- [AutoAcceptPolicyDetailStock](docs/AutoAcceptPolicyDetailStock.md)
- [AutoAcceptPolicyVersion](docs/AutoAcceptPolicyVersion.md)
- [AutoAcceptResume](docs/AutoAcceptResume.md)
- [AutoAcceptStatus](docs/AutoAcceptStatus.md)
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
- [CatalogAttributeDefinition](docs/CatalogAttributeDefinition.md)
- [CatalogBlocker](docs/CatalogBlocker.md)
- [CatalogCompletion](docs/CatalogCompletion.md)
- [CatalogCompletionStep](docs/CatalogCompletionStep.md)
- [CatalogDeactivation](docs/CatalogDeactivation.md)
- [CatalogImportJob](docs/CatalogImportJob.md)
- [CatalogImportJobEnvelope](docs/CatalogImportJobEnvelope.md)
- [CatalogImportRowError](docs/CatalogImportRowError.md)
- [CatalogImportTemplate](docs/CatalogImportTemplate.md)
- [CatalogImportTemplateEnvelope](docs/CatalogImportTemplateEnvelope.md)
- [CatalogInventory](docs/CatalogInventory.md)
- [CatalogLimits](docs/CatalogLimits.md)
- [CatalogListing](docs/CatalogListing.md)
- [CatalogListingCreate](docs/CatalogListingCreate.md)
- [CatalogListingDeletedEnvelope](docs/CatalogListingDeletedEnvelope.md)
- [CatalogListingDeletedEnvelopeData](docs/CatalogListingDeletedEnvelopeData.md)
- [CatalogListingEnvelope](docs/CatalogListingEnvelope.md)
- [CatalogListingListMeta](docs/CatalogListingListMeta.md)
- [CatalogListingMaterial](docs/CatalogListingMaterial.md)
- [CatalogListingPermissions](docs/CatalogListingPermissions.md)
- [CatalogListingSummary](docs/CatalogListingSummary.md)
- [CatalogListingSummaryListEnvelope](docs/CatalogListingSummaryListEnvelope.md)
- [CatalogListingUpdate](docs/CatalogListingUpdate.md)
- [CatalogLockVersion](docs/CatalogLockVersion.md)
- [CatalogMaterial](docs/CatalogMaterial.md)
- [CatalogMaterialEnvelope](docs/CatalogMaterialEnvelope.md)
- [CatalogMaterialMatch](docs/CatalogMaterialMatch.md)
- [CatalogMaterialMatchListEnvelope](docs/CatalogMaterialMatchListEnvelope.md)
- [CatalogMedia](docs/CatalogMedia.md)
- [CatalogPrice](docs/CatalogPrice.md)
- [CatalogReference](docs/CatalogReference.md)
- [CatalogTaxonomy](docs/CatalogTaxonomy.md)
- [CatalogTaxonomyEnvelope](docs/CatalogTaxonomyEnvelope.md)
- [CatalogUnit](docs/CatalogUnit.md)
- [CatalogVariant](docs/CatalogVariant.md)
- [CatalogVariantInput](docs/CatalogVariantInput.md)
- [CatalogVariantsSave](docs/CatalogVariantsSave.md)
- [CatalogVolumeTier](docs/CatalogVolumeTier.md)
- [CatalogVolumeTierInput](docs/CatalogVolumeTierInput.md)
- [ComparableGroupCreate](docs/ComparableGroupCreate.md)
- [ComparableGroupEnvelope](docs/ComparableGroupEnvelope.md)
- [ComparableGroupEnvelopeData](docs/ComparableGroupEnvelopeData.md)
- [ComplianceEvidence](docs/ComplianceEvidence.md)
- [ComplianceEvidenceEnvelope](docs/ComplianceEvidenceEnvelope.md)
- [ComplianceExtraction](docs/ComplianceExtraction.md)
- [CompliancePath](docs/CompliancePath.md)
- [ComplianceReferenceResult](docs/ComplianceReferenceResult.md)
- [ComplianceRegister](docs/ComplianceRegister.md)
- [ComplianceRegisterEnvelope](docs/ComplianceRegisterEnvelope.md)
- [ComplianceRegisterListEnvelope](docs/ComplianceRegisterListEnvelope.md)
- [ComplianceReviewSummary](docs/ComplianceReviewSummary.md)
- [ComplianceSubmission](docs/ComplianceSubmission.md)
- [ComplianceSubmissionSummary](docs/ComplianceSubmissionSummary.md)
- [CsrfEnvelope](docs/CsrfEnvelope.md)
- [CsrfEnvelopeAllOfData](docs/CsrfEnvelopeAllOfData.md)
- [EmailRequest](docs/EmailRequest.md)
- [ErrorEnvelope](docs/ErrorEnvelope.md)
- [FeeAssessment](docs/FeeAssessment.md)
- [FinancialSnapshot](docs/FinancialSnapshot.md)
- [FleetVehicle](docs/FleetVehicle.md)
- [FleetVehicleEligibility](docs/FleetVehicleEligibility.md)
- [FleetVehicleImageEnvelope](docs/FleetVehicleImageEnvelope.md)
- [FleetVehicleImageEnvelopeData](docs/FleetVehicleImageEnvelopeData.md)
- [FleetVehicleInput](docs/FleetVehicleInput.md)
- [FleetVehicleListEnvelope](docs/FleetVehicleListEnvelope.md)
- [FleetVehicleListMeta](docs/FleetVehicleListMeta.md)
- [FleetVehicleListMetaDelivery](docs/FleetVehicleListMetaDelivery.md)
- [FleetVehicleListMetaLimits](docs/FleetVehicleListMetaLimits.md)
- [FleetVehicleListMetaPermissions](docs/FleetVehicleListMetaPermissions.md)
- [FleetVehiclesSave](docs/FleetVehiclesSave.md)
- [GenericDataEnvelope](docs/GenericDataEnvelope.md)
- [GoogleMobileExchangeRequest](docs/GoogleMobileExchangeRequest.md)
- [GoogleOidcStartRequest](docs/GoogleOidcStartRequest.md)
- [HealthEnvelope](docs/HealthEnvelope.md)
- [HealthEnvelopeAllOfData](docs/HealthEnvelopeAllOfData.md)
- [InventoryBalance](docs/InventoryBalance.md)
- [InventoryComparability](docs/InventoryComparability.md)
- [InventoryLedgerEnvelope](docs/InventoryLedgerEnvelope.md)
- [InventoryLedgerMeta](docs/InventoryLedgerMeta.md)
- [InventoryLedgerMetaPermissions](docs/InventoryLedgerMetaPermissions.md)
- [InventoryLedgerMetaStaleListings](docs/InventoryLedgerMetaStaleListings.md)
- [InventoryLedgerMetaSummary](docs/InventoryLedgerMetaSummary.md)
- [InventoryMovement](docs/InventoryMovement.md)
- [InventoryMovementListEnvelope](docs/InventoryMovementListEnvelope.md)
- [InventoryPrice](docs/InventoryPrice.md)
- [InventoryPriceChange](docs/InventoryPriceChange.md)
- [InventoryRow](docs/InventoryRow.md)
- [InventoryRowEnvelope](docs/InventoryRowEnvelope.md)
- [InventoryRowListEnvelope](docs/InventoryRowListEnvelope.md)
- [InventoryRowUpdate](docs/InventoryRowUpdate.md)
- [InventorySettings](docs/InventorySettings.md)
- [InventorySettingsEnvelope](docs/InventorySettingsEnvelope.md)
- [InventorySettingsUpdate](docs/InventorySettingsUpdate.md)
- [ListingComplianceStatus](docs/ListingComplianceStatus.md)
- [ListingStatus](docs/ListingStatus.md)
- [ListingStatusChange](docs/ListingStatusChange.md)
- [LoginRequest](docs/LoginRequest.md)
- [MarkingType](docs/MarkingType.md)
- [MaterialPriceObservation](docs/MaterialPriceObservation.md)
- [MfaCodeRequest](docs/MfaCodeRequest.md)
- [MfaEnrollmentEnvelope](docs/MfaEnrollmentEnvelope.md)
- [MfaEnrollmentEnvelopeAllOfData](docs/MfaEnrollmentEnvelopeAllOfData.md)
- [MfaRecoveryRequest](docs/MfaRecoveryRequest.md)
- [MfaStatusEnvelope](docs/MfaStatusEnvelope.md)
- [MfaStatusEnvelopeAllOfData](docs/MfaStatusEnvelopeAllOfData.md)
- [OnboardingDraftVersion](docs/OnboardingDraftVersion.md)
- [OnboardingRequirement](docs/OnboardingRequirement.md)
- [OnboardingStepCompletion](docs/OnboardingStepCompletion.md)
- [PageMeta](docs/PageMeta.md)
- [PasswordRecoveryRequest](docs/PasswordRecoveryRequest.md)
- [PasswordResetRequest](docs/PasswordResetRequest.md)
- [PriceHistoryEntry](docs/PriceHistoryEntry.md)
- [PriceHistoryEnvelope](docs/PriceHistoryEnvelope.md)
- [ProductComplianceCaseEnvelope](docs/ProductComplianceCaseEnvelope.md)
- [ProductComplianceCaseEnvelopeData](docs/ProductComplianceCaseEnvelopeData.md)
- [ProductComplianceDecision](docs/ProductComplianceDecision.md)
- [ProductComplianceQueueEnvelope](docs/ProductComplianceQueueEnvelope.md)
- [ProductComplianceQueueItem](docs/ProductComplianceQueueItem.md)
- [PsgcArea](docs/PsgcArea.md)
- [PsgcSearchEnvelope](docs/PsgcSearchEnvelope.md)
- [PsgcSearchEnvelopeData](docs/PsgcSearchEnvelopeData.md)
- [PublicStoreListEnvelope](docs/PublicStoreListEnvelope.md)
- [PublicStoreListEnvelopeMeta](docs/PublicStoreListEnvelopeMeta.md)
- [PublicStoreProfile](docs/PublicStoreProfile.md)
- [PublicStoreProfileEnvelope](docs/PublicStoreProfileEnvelope.md)
- [PublicStoreSummary](docs/PublicStoreSummary.md)
- [RegisterRequest](docs/RegisterRequest.md)
- [RegistrationEnvelope](docs/RegistrationEnvelope.md)
- [RegistrationEnvelopeAllOfData](docs/RegistrationEnvelopeAllOfData.md)
- [RegulatedMaterialRule](docs/RegulatedMaterialRule.md)
- [ResendBotChallengeRequest](docs/ResendBotChallengeRequest.md)
- [StaleListing](docs/StaleListing.md)
- [StockConfirmationItem](docs/StockConfirmationItem.md)
- [StockConfirmationRequest](docs/StockConfirmationRequest.md)
- [StockConfirmationSchedule](docs/StockConfirmationSchedule.md)
- [StockLabel](docs/StockLabel.md)
- [StoreActivationBlocker](docs/StoreActivationBlocker.md)
- [StoreActivationReadiness](docs/StoreActivationReadiness.md)
- [StoreOperatingDay](docs/StoreOperatingDay.md)
- [SuccessEnvelope](docs/SuccessEnvelope.md)
- [TaxCategory](docs/TaxCategory.md)
- [UserIdentity](docs/UserIdentity.md)
- [VendorActivationSnapshot](docs/VendorActivationSnapshot.md)
- [VendorAddressGeocode](docs/VendorAddressGeocode.md)
- [VendorAddressGeocodeEnvelope](docs/VendorAddressGeocodeEnvelope.md)
- [VendorAddressSelection](docs/VendorAddressSelection.md)
- [VendorBotProtectionEvidence](docs/VendorBotProtectionEvidence.md)
- [VendorCommissionAcceptance](docs/VendorCommissionAcceptance.md)
- [VendorDocument](docs/VendorDocument.md)
- [VendorDocumentEnvelope](docs/VendorDocumentEnvelope.md)
- [VendorFile](docs/VendorFile.md)
- [VendorFileEnvelope](docs/VendorFileEnvelope.md)
- [VendorInvitation](docs/VendorInvitation.md)
- [VendorInvitationAcceptance](docs/VendorInvitationAcceptance.md)
- [VendorInvitationEnvelope](docs/VendorInvitationEnvelope.md)
- [VendorInvitationRequest](docs/VendorInvitationRequest.md)
- [VendorMediaEnvelope](docs/VendorMediaEnvelope.md)
- [VendorOnboardingEnvelope](docs/VendorOnboardingEnvelope.md)
- [VendorOnboardingSection](docs/VendorOnboardingSection.md)
- [VendorOnboardingSnapshot](docs/VendorOnboardingSnapshot.md)
- [VendorOnboardingSnapshotSetup](docs/VendorOnboardingSnapshotSetup.md)
- [VendorOnboardingStep](docs/VendorOnboardingStep.md)
- [VendorPaymentOnboarding](docs/VendorPaymentOnboarding.md)
- [VendorPaymentOnboardingEnvelope](docs/VendorPaymentOnboardingEnvelope.md)
- [VendorPaymentReconciliationEnvelope](docs/VendorPaymentReconciliationEnvelope.md)
- [VendorRestriction](docs/VendorRestriction.md)
- [VendorRestrictionEnvelope](docs/VendorRestrictionEnvelope.md)
- [VendorSetupComplete](docs/VendorSetupComplete.md)
- [VendorSetupDraft](docs/VendorSetupDraft.md)
- [VendorSetupDraftDelivery](docs/VendorSetupDraftDelivery.md)
- [VendorSetupDraftVehiclesInner](docs/VendorSetupDraftVehiclesInner.md)
- [VendorStaffDisputeSetting](docs/VendorStaffDisputeSetting.md)
- [VendorStaffUpdate](docs/VendorStaffUpdate.md)
- [VendorStoreEmailConfirmation](docs/VendorStoreEmailConfirmation.md)
- [VendorStoreEmailEnvelope](docs/VendorStoreEmailEnvelope.md)
- [VendorTeamActivity](docs/VendorTeamActivity.md)
- [VendorTeamActivityEnvelope](docs/VendorTeamActivityEnvelope.md)
- [VendorTeamActivityEnvelopeMeta](docs/VendorTeamActivityEnvelopeMeta.md)
- [VendorTeamInvitationListEnvelope](docs/VendorTeamInvitationListEnvelope.md)
- [VendorTeamInvitationRecord](docs/VendorTeamInvitationRecord.md)
- [VendorVerificationDraft](docs/VendorVerificationDraft.md)
- [VendorVerificationDraftClassification](docs/VendorVerificationDraftClassification.md)
- [VendorVerificationDraftLegalIdentity](docs/VendorVerificationDraftLegalIdentity.md)
- [VendorVerificationDraftRepresentative](docs/VendorVerificationDraftRepresentative.md)
- [VendorVerificationDraftTaxProfile](docs/VendorVerificationDraftTaxProfile.md)
- [VendorVerificationSubmit](docs/VendorVerificationSubmit.md)
- [VendorWebhookEnvelope](docs/VendorWebhookEnvelope.md)
- [VerifyBotChallengeRequest](docs/VerifyBotChallengeRequest.md)
- [VerifyEmailRequest](docs/VerifyEmailRequest.md)
- [XenditAccountVerificationWebhook](docs/XenditAccountVerificationWebhook.md)
- [XenditAccountVerificationWebhookData](docs/XenditAccountVerificationWebhookData.md)
- [XenditAccountVerificationWebhookDataAccountInfo](docs/XenditAccountVerificationWebhookDataAccountInfo.md)

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

- API version: `1.0.0-phase.5`
- Package version: `1.0.0-phase.5`
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
