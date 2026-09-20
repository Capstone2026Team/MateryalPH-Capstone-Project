// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (Serializers().toBuilder()
      ..add($SuccessEnvelope.serializer)
      ..add(AccountAdminChange.serializer)
      ..add(AccountAdminChangeStatusEnum.serializer)
      ..add(AccountAdminInvitation.serializer)
      ..add(AccountAdministrator.serializer)
      ..add(AccountAdministratorListEnvelope.serializer)
      ..add(AccountAgreement.serializer)
      ..add(AccountAgreementAcceptance.serializer)
      ..add(AccountAgreementListEnvelope.serializer)
      ..add(AccountCodeConfirmation.serializer)
      ..add(AccountDelegation.serializer)
      ..add(AccountEmailChange.serializer)
      ..add(AccountFactorEnrollment.serializer)
      ..add(AccountFactorEnrollmentEnvelope.serializer)
      ..add(AccountMembership.serializer)
      ..add(AccountMembershipListEnvelope.serializer)
      ..add(AccountMembershipStatus.serializer)
      ..add(AccountMembershipStatusStatusEnum.serializer)
      ..add(AccountMutationResult.serializer)
      ..add(AccountMutationResultEnvelope.serializer)
      ..add(AccountPasswordChange.serializer)
      ..add(AccountPendingChange.serializer)
      ..add(AccountPendingChangeEnvelope.serializer)
      ..add(AccountProfile.serializer)
      ..add(AccountProfileEnvelope.serializer)
      ..add(AccountProfileUpdate.serializer)
      ..add(AccountProfileUpdateBuyerTypeEnum.serializer)
      ..add(AccountReauthentication.serializer)
      ..add(AccountRecoveryCodes.serializer)
      ..add(AccountRecoveryCodesEnvelope.serializer)
      ..add(AccountRole.serializer)
      ..add(AccountRoleListEnvelope.serializer)
      ..add(AccountSecurity.serializer)
      ..add(AccountSecurityEnvelope.serializer)
      ..add(AccountSession.serializer)
      ..add(AccountSessionListEnvelope.serializer)
      ..add(AccountSessionRevocation.serializer)
      ..add(AccountSessionRevocationScopeEnum.serializer)
      ..add(AccountType.serializer)
      ..add(AdminDashboardAuditEnvelope.serializer)
      ..add(AdminDashboardEnvelope.serializer)
      ..add(AdminDashboardSummary.serializer)
      ..add(AdminInvitationRequest.serializer)
      ..add(AdminInvitationRequestPrivacyAcceptedEnum.serializer)
      ..add(AdminInvitationRequestTermsAcceptedEnum.serializer)
      ..add(AdminVendorVerificationDecision.serializer)
      ..add(AdminVendorVerificationDecisionDecisionEnum.serializer)
      ..add(AdminVendorVerificationDecisionExpirationKindEnum.serializer)
      ..add(AdminVendorVerificationDecisionVerifiedVatCategoryEnum.serializer)
      ..add(AdminVendorVerificationDetailEnvelope.serializer)
      ..add(AdminVendorVerificationQueueEnvelope.serializer)
      ..add(AdminVendorVerificationQueueItem.serializer)
      ..add(Agreement.serializer)
      ..add(AgreementListEnvelope.serializer)
      ..add(ApiError.serializer)
      ..add(AuthEnvelope.serializer)
      ..add(AuthEnvelopeAllOfData.serializer)
      ..add(BotProofEnvelope.serializer)
      ..add(BotProofEnvelopeAllOfData.serializer)
      ..add(BotProofEnvelopeAllOfDataVerifiedEnum.serializer)
      ..add(BotStepUpErrorEnvelope.serializer)
      ..add(BotStepUpErrorEnvelopeAllOfErrors.serializer)
      ..add(BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails.serializer)
      ..add(BotStepUpErrorEnvelopeAllOfErrorsCodeEnum.serializer)
      ..add(BuyerMobileGoogleOidcStartRequest.serializer)
      ..add(BuyerMobileGoogleOidcStartRequestModeEnum.serializer)
      ..add(BuyerMobileLoginRequest.serializer)
      ..add(BuyerMobilePasswordRecoveryRequest.serializer)
      ..add(BuyerMobileRefreshRequest.serializer)
      ..add(BuyerMobileRegisterRequest.serializer)
      ..add(BuyerMobileRegisterRequestPrivacyAcceptedEnum.serializer)
      ..add(BuyerMobileRegisterRequestTermsAcceptedEnum.serializer)
      ..add(CsrfEnvelope.serializer)
      ..add(CsrfEnvelopeAllOfData.serializer)
      ..add(EmailRequest.serializer)
      ..add(ErrorEnvelope.serializer)
      ..add(FeeAssessment.serializer)
      ..add(FeeAssessmentCommissionBasisPointsEnum.serializer)
      ..add(FinancialSnapshot.serializer)
      ..add(FinancialSnapshotEnvironmentEnum.serializer)
      ..add(GoogleMobileExchangeRequest.serializer)
      ..add(GoogleOidcStartRequest.serializer)
      ..add(GoogleOidcStartRequestModeEnum.serializer)
      ..add(GoogleOidcStartRequestPortalEnum.serializer)
      ..add(HealthEnvelope.serializer)
      ..add(HealthEnvelopeAllOfData.serializer)
      ..add(HealthEnvelopeAllOfDataServiceEnum.serializer)
      ..add(HealthEnvelopeAllOfDataStatusEnum.serializer)
      ..add(LoginRequest.serializer)
      ..add(LoginRequestPortalEnum.serializer)
      ..add(MaterialPriceObservation.serializer)
      ..add(MaterialPriceObservationEnvironmentEnum.serializer)
      ..add(MfaCodeRequest.serializer)
      ..add(MfaEnrollmentEnvelope.serializer)
      ..add(MfaEnrollmentEnvelopeAllOfData.serializer)
      ..add(MfaRecoveryRequest.serializer)
      ..add(MfaStatusEnvelope.serializer)
      ..add(MfaStatusEnvelopeAllOfData.serializer)
      ..add(MfaStatusEnvelopeAllOfDataMfaRequiredEnum.serializer)
      ..add(PasswordRecoveryRequest.serializer)
      ..add(PasswordRecoveryRequestPortalEnum.serializer)
      ..add(PasswordResetRequest.serializer)
      ..add(RegisterRequest.serializer)
      ..add(RegisterRequestPrivacyAcceptedEnum.serializer)
      ..add(RegisterRequestTermsAcceptedEnum.serializer)
      ..add(RegistrationEnvelope.serializer)
      ..add(RegistrationEnvelopeAllOfData.serializer)
      ..add(ResendBotChallengeRequest.serializer)
      ..add(UserIdentity.serializer)
      ..add(VendorAddressGeocode.serializer)
      ..add(VendorAddressGeocodeEnvelope.serializer)
      ..add(VendorBotProtectionEvidence.serializer)
      ..add(VendorDocument.serializer)
      ..add(VendorDocumentEnvelope.serializer)
      ..add(VendorDocumentScanStateEnum.serializer)
      ..add(VendorFile.serializer)
      ..add(VendorFileEnvelope.serializer)
      ..add(VendorInvitation.serializer)
      ..add(VendorInvitationAcceptance.serializer)
      ..add(VendorInvitationEnvelope.serializer)
      ..add(VendorInvitationRequest.serializer)
      ..add(VendorInvitationRequestRoleEnum.serializer)
      ..add(VendorMediaEnvelope.serializer)
      ..add(VendorOnboardingEnvelope.serializer)
      ..add(VendorOnboardingSection.serializer)
      ..add(VendorOnboardingSnapshot.serializer)
      ..add(VendorOnboardingStep.serializer)
      ..add(VendorOnboardingStepLevelEnum.serializer)
      ..add(VendorOnboardingStepStatusEnum.serializer)
      ..add(VendorPaymentConnection.serializer)
      ..add(VendorPaymentReconciliationEnvelope.serializer)
      ..add(VendorRestriction.serializer)
      ..add(VendorRestrictionEnvelope.serializer)
      ..add(VendorSetupComplete.serializer)
      ..add(VendorSetupCompleteCommissionTermsAcceptedEnum.serializer)
      ..add(VendorSetupDraft.serializer)
      ..add(VendorSetupDraftDelivery.serializer)
      ..add(VendorSetupDraftFulfillmentMethodEnum.serializer)
      ..add(VendorSetupDraftVehiclesInner.serializer)
      ..add(VendorStoreEmailConfirmation.serializer)
      ..add(VendorStoreEmailEnvelope.serializer)
      ..add(VendorVerificationDraft.serializer)
      ..add(VendorVerificationDraftBusinessTypeEnum.serializer)
      ..add(VendorVerificationDraftLegalIdentity.serializer)
      ..add(VendorVerificationDraftTaxProfile.serializer)
      ..add(VendorVerificationDraftTaxProfileEntityClassEnum.serializer)
      ..add(VendorVerificationDraftTaxProfileVatCategoryEnum.serializer)
      ..add(VendorVerificationDraftTaxProfileWithholdingScenarioEnum.serializer)
      ..add(VendorVerificationSubmit.serializer)
      ..add(VendorVerificationSubmitPrivacyAcknowledgedEnum.serializer)
      ..add(VendorWebhookEnvelope.serializer)
      ..add(VerifyBotChallengeRequest.serializer)
      ..add(VerifyEmailRequest.serializer)
      ..add(XenditAccountVerificationWebhook.serializer)
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(AccountAdministrator)]),
          () => ListBuilder<AccountAdministrator>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(AccountAgreement)]),
          () => ListBuilder<AccountAgreement>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(AccountMembership)]),
          () => ListBuilder<AccountMembership>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(AccountRole)]),
          () => ListBuilder<AccountRole>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(AccountSession)]),
          () => ListBuilder<AccountSession>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(AdminVendorVerificationQueueItem)]),
          () => ListBuilder<AdminVendorVerificationQueueItem>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Agreement)]),
          () => ListBuilder<Agreement>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(VendorSetupDraftVehiclesInner)]),
          () => ListBuilder<VendorSetupDraftVehiclesInner>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ApiError)]),
          () => ListBuilder<ApiError>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(BotStepUpErrorEnvelopeAllOfErrors)]),
          () => ListBuilder<BotStepUpErrorEnvelopeAllOfErrors>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(VendorOnboardingStep)]),
          () => ListBuilder<VendorOnboardingStep>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(VendorOnboardingSection)
          ]),
          () => MapBuilder<String, VendorOnboardingSection>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType.nullable(JsonObject)]),
          () => ListBuilder<JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType.nullable(JsonObject)]),
          () => ListBuilder<JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType.nullable(JsonObject)]),
          () => ListBuilder<JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType.nullable(JsonObject)]),
          () => ListBuilder<JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType.nullable(JsonObject)]),
          () => ListBuilder<JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType.nullable(JsonObject)]),
          () => ListBuilder<JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType.nullable(JsonObject)]),
          () => ListBuilder<JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType.nullable(JsonObject)]),
          () => ListBuilder<JsonObject?>()))
    .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
