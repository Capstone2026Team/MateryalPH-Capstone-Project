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
      ..add(AdminVendorVerificationDecisionAuthorityScopesEnum.serializer)
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
      ..add(CatalogAttributeDefinition.serializer)
      ..add(CatalogAttributeDefinitionValueTypeEnum.serializer)
      ..add(CatalogBlocker.serializer)
      ..add(CatalogCompletion.serializer)
      ..add(CatalogCompletionStep.serializer)
      ..add(CatalogCompletionStepLevelEnum.serializer)
      ..add(CatalogDeactivation.serializer)
      ..add(CatalogImportJob.serializer)
      ..add(CatalogImportJobEnvelope.serializer)
      ..add(CatalogImportJobStatusEnum.serializer)
      ..add(CatalogImportRowError.serializer)
      ..add(CatalogImportTemplate.serializer)
      ..add(CatalogImportTemplateEnvelope.serializer)
      ..add(CatalogInventory.serializer)
      ..add(CatalogLimits.serializer)
      ..add(CatalogListing.serializer)
      ..add(CatalogListingCreate.serializer)
      ..add(CatalogListingDeletedEnvelope.serializer)
      ..add(CatalogListingDeletedEnvelopeData.serializer)
      ..add(CatalogListingEnvelope.serializer)
      ..add(CatalogListingListMeta.serializer)
      ..add(CatalogListingListMetaScopeEnum.serializer)
      ..add(CatalogListingMaterial.serializer)
      ..add(CatalogListingMaterialMatchEnum.serializer)
      ..add(CatalogListingPermissions.serializer)
      ..add(CatalogListingSummary.serializer)
      ..add(CatalogListingSummaryListEnvelope.serializer)
      ..add(CatalogListingSummaryPublicAvailabilityEnum.serializer)
      ..add(CatalogListingUpdate.serializer)
      ..add(CatalogListingUpdateMaterialMatchEnum.serializer)
      ..add(CatalogLockVersion.serializer)
      ..add(CatalogMaterial.serializer)
      ..add(CatalogMaterialEnvelope.serializer)
      ..add(CatalogMaterialMatch.serializer)
      ..add(CatalogMaterialMatchListEnvelope.serializer)
      ..add(CatalogMaterialMatchMatchTypeEnum.serializer)
      ..add(CatalogMedia.serializer)
      ..add(CatalogMediaStatusEnum.serializer)
      ..add(CatalogPrice.serializer)
      ..add(CatalogReference.serializer)
      ..add(CatalogTaxonomy.serializer)
      ..add(CatalogTaxonomyEnvelope.serializer)
      ..add(CatalogUnit.serializer)
      ..add(CatalogVariant.serializer)
      ..add(CatalogVariantComparabilityEnum.serializer)
      ..add(CatalogVariantInput.serializer)
      ..add(CatalogVariantPublicAvailabilityEnum.serializer)
      ..add(CatalogVariantsSave.serializer)
      ..add(CatalogVolumeTier.serializer)
      ..add(CatalogVolumeTierInput.serializer)
      ..add(ComparableGroupCreate.serializer)
      ..add(ComparableGroupEnvelope.serializer)
      ..add(ComparableGroupEnvelopeData.serializer)
      ..add(ComplianceEvidence.serializer)
      ..add(ComplianceEvidenceEnvelope.serializer)
      ..add(ComplianceEvidenceEvidenceKindEnum.serializer)
      ..add(ComplianceExtraction.serializer)
      ..add(ComplianceExtractionSource_Enum.serializer)
      ..add(ComplianceExtractionStatusEnum.serializer)
      ..add(CompliancePath.serializer)
      ..add(ComplianceReferenceResult.serializer)
      ..add(ComplianceRegister.serializer)
      ..add(ComplianceRegisterEnvelope.serializer)
      ..add(ComplianceRegisterListEnvelope.serializer)
      ..add(ComplianceRegisterRegisterKindEnum.serializer)
      ..add(ComplianceRegisterStatusEnum.serializer)
      ..add(ComplianceReviewSummary.serializer)
      ..add(ComplianceReviewSummaryDecisionEnum.serializer)
      ..add(ComplianceReviewSummarySource_Enum.serializer)
      ..add(ComplianceSubmission.serializer)
      ..add(ComplianceSubmissionConfirmedEnum.serializer)
      ..add(ComplianceSubmissionSummary.serializer)
      ..add(ComplianceSubmissionSummaryStatusEnum.serializer)
      ..add(CsrfEnvelope.serializer)
      ..add(CsrfEnvelopeAllOfData.serializer)
      ..add(EmailRequest.serializer)
      ..add(ErrorEnvelope.serializer)
      ..add(FeeAssessment.serializer)
      ..add(FeeAssessmentCommissionBasisPointsEnum.serializer)
      ..add(FinancialSnapshot.serializer)
      ..add(FinancialSnapshotEnvironmentEnum.serializer)
      ..add(GenericDataEnvelope.serializer)
      ..add(GoogleMobileExchangeRequest.serializer)
      ..add(GoogleOidcStartRequest.serializer)
      ..add(GoogleOidcStartRequestModeEnum.serializer)
      ..add(GoogleOidcStartRequestPortalEnum.serializer)
      ..add(HealthEnvelope.serializer)
      ..add(HealthEnvelopeAllOfData.serializer)
      ..add(HealthEnvelopeAllOfDataServiceEnum.serializer)
      ..add(HealthEnvelopeAllOfDataStatusEnum.serializer)
      ..add(ListingComplianceStatus.serializer)
      ..add(ListingStatus.serializer)
      ..add(ListingStatusChange.serializer)
      ..add(LoginRequest.serializer)
      ..add(LoginRequestPortalEnum.serializer)
      ..add(MarkingType.serializer)
      ..add(MaterialPriceObservation.serializer)
      ..add(MaterialPriceObservationEnvironmentEnum.serializer)
      ..add(MfaCodeRequest.serializer)
      ..add(MfaEnrollmentEnvelope.serializer)
      ..add(MfaEnrollmentEnvelopeAllOfData.serializer)
      ..add(MfaRecoveryRequest.serializer)
      ..add(MfaStatusEnvelope.serializer)
      ..add(MfaStatusEnvelopeAllOfData.serializer)
      ..add(MfaStatusEnvelopeAllOfDataMfaRequiredEnum.serializer)
      ..add(OnboardingDraftVersion.serializer)
      ..add(OnboardingDraftVersionWorkstreamEnum.serializer)
      ..add(OnboardingRequirement.serializer)
      ..add(OnboardingRequirementLevelEnum.serializer)
      ..add(OnboardingRequirementStatusEnum.serializer)
      ..add(OnboardingRequirementWorkstreamEnum.serializer)
      ..add(OnboardingStepCompletion.serializer)
      ..add(OnboardingStepCompletionKeyEnum.serializer)
      ..add(OnboardingStepCompletionWorkstreamEnum.serializer)
      ..add(PasswordRecoveryRequest.serializer)
      ..add(PasswordRecoveryRequestPortalEnum.serializer)
      ..add(PasswordResetRequest.serializer)
      ..add(ProductComplianceCaseEnvelope.serializer)
      ..add(ProductComplianceCaseEnvelopeData.serializer)
      ..add(ProductComplianceDecision.serializer)
      ..add(ProductComplianceDecisionDecisionEnum.serializer)
      ..add(ProductComplianceQueueEnvelope.serializer)
      ..add(ProductComplianceQueueItem.serializer)
      ..add(PsgcArea.serializer)
      ..add(PsgcSearchEnvelope.serializer)
      ..add(PsgcSearchEnvelopeData.serializer)
      ..add(PublicStoreListEnvelope.serializer)
      ..add(PublicStoreListEnvelopeMeta.serializer)
      ..add(PublicStoreProfile.serializer)
      ..add(PublicStoreProfileEffectiveSourceEnum.serializer)
      ..add(PublicStoreProfileEnvelope.serializer)
      ..add(PublicStoreProfileTimeZoneEnum.serializer)
      ..add(PublicStoreSummary.serializer)
      ..add(RegisterRequest.serializer)
      ..add(RegisterRequestPrivacyAcceptedEnum.serializer)
      ..add(RegisterRequestTermsAcceptedEnum.serializer)
      ..add(RegistrationEnvelope.serializer)
      ..add(RegistrationEnvelopeAllOfData.serializer)
      ..add(RegulatedMaterialRule.serializer)
      ..add(RegulatedMaterialRuleRequiredMarkingEnum.serializer)
      ..add(ResendBotChallengeRequest.serializer)
      ..add(StoreActivationBlocker.serializer)
      ..add(StoreActivationReadiness.serializer)
      ..add(StoreActivationReadinessStatusEnum.serializer)
      ..add(StoreOperatingDay.serializer)
      ..add(StoreOperatingDayStatusEnum.serializer)
      ..add(TaxCategory.serializer)
      ..add(UserIdentity.serializer)
      ..add(VendorActivationSnapshot.serializer)
      ..add(VendorAddressGeocode.serializer)
      ..add(VendorAddressGeocodeEnvelope.serializer)
      ..add(VendorAddressSelection.serializer)
      ..add(VendorBotProtectionEvidence.serializer)
      ..add(VendorCommissionAcceptance.serializer)
      ..add(VendorCommissionAcceptanceAcceptedEnum.serializer)
      ..add(VendorDocument.serializer)
      ..add(VendorDocumentEnvelope.serializer)
      ..add(VendorDocumentScanStateEnum.serializer)
      ..add(VendorDocumentStatusEnum.serializer)
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
      ..add(VendorOnboardingSnapshotSetup.serializer)
      ..add(VendorOnboardingStep.serializer)
      ..add(VendorOnboardingStepLevelEnum.serializer)
      ..add(VendorOnboardingStepStatusEnum.serializer)
      ..add(VendorPaymentOnboarding.serializer)
      ..add(VendorPaymentOnboardingEnvelope.serializer)
      ..add(VendorPaymentOnboardingEnvironmentEnum.serializer)
      ..add(VendorPaymentOnboardingStatusEnum.serializer)
      ..add(VendorPaymentReconciliationEnvelope.serializer)
      ..add(VendorRestriction.serializer)
      ..add(VendorRestrictionEnvelope.serializer)
      ..add(VendorSetupComplete.serializer)
      ..add(VendorSetupDraft.serializer)
      ..add(VendorSetupDraftDelivery.serializer)
      ..add(VendorSetupDraftFulfillmentMethodEnum.serializer)
      ..add(VendorSetupDraftVehiclesInner.serializer)
      ..add(VendorSetupDraftVehiclesInnerVehicleCategoryEnum.serializer)
      ..add(VendorStaffDisputeSetting.serializer)
      ..add(VendorStaffUpdate.serializer)
      ..add(VendorStaffUpdateRoleEnum.serializer)
      ..add(VendorStoreEmailConfirmation.serializer)
      ..add(VendorStoreEmailEnvelope.serializer)
      ..add(VendorTeamActivity.serializer)
      ..add(VendorTeamActivityEnvelope.serializer)
      ..add(VendorTeamActivityEnvelopeMeta.serializer)
      ..add(VendorTeamInvitationListEnvelope.serializer)
      ..add(VendorTeamInvitationRecord.serializer)
      ..add(VendorTeamInvitationRecordStatusEnum.serializer)
      ..add(VendorVerificationDraft.serializer)
      ..add(VendorVerificationDraftBusinessTypeEnum.serializer)
      ..add(VendorVerificationDraftClassification.serializer)
      ..add(VendorVerificationDraftLegalIdentity.serializer)
      ..add(VendorVerificationDraftRepresentative.serializer)
      ..add(VendorVerificationDraftRepresentativeAuthorityDocumentTypeEnum
          .serializer)
      ..add(VendorVerificationDraftRepresentativeAuthorityEvidenceSourceEnum
          .serializer)
      ..add(VendorVerificationDraftRepresentativeAuthorityScopesEnum.serializer)
      ..add(VendorVerificationDraftRepresentativeIdTypeEnum.serializer)
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
      ..add(XenditAccountVerificationWebhookData.serializer)
      ..add(XenditAccountVerificationWebhookDataAccountInfo.serializer)
      ..add(XenditAccountVerificationWebhookEventEnum.serializer)
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
          const FullType(BuiltList, const [
            const FullType(AdminVendorVerificationDecisionAuthorityScopesEnum)
          ]),
          () =>
              ListBuilder<AdminVendorVerificationDecisionAuthorityScopesEnum>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(int)]),
          () => MapBuilder<String, int>())
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
          const FullType(
              BuiltList, const [const FullType(CatalogCompletionStep)]),
          () => ListBuilder<CatalogCompletionStep>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(CatalogImportRowError)]),
          () => ListBuilder<CatalogImportRowError>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(CatalogListingSummary)]),
          () => ListBuilder<CatalogListingSummary>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(CatalogMaterialMatch)]),
          () => ListBuilder<CatalogMaterialMatch>())
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
          const FullType(BuiltList, const [const FullType(CatalogReference)]),
          () => ListBuilder<CatalogReference>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(CatalogUnit)]),
          () => ListBuilder<CatalogUnit>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(CatalogReference)]),
          () => ListBuilder<CatalogReference>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(CatalogAttributeDefinition)]),
          () => ListBuilder<CatalogAttributeDefinition>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(TaxCategory)]),
          () => ListBuilder<TaxCategory>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(TaxCategory)]),
          () => ListBuilder<TaxCategory>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(CatalogVariantInput)]),
          () => ListBuilder<CatalogVariantInput>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ComplianceRegister)]),
          () => ListBuilder<ComplianceRegister>())
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
          const FullType(
              BuiltList, const [const FullType(OnboardingStepCompletion)]),
          () => ListBuilder<OnboardingStepCompletion>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(OnboardingRequirement)]),
          () => ListBuilder<OnboardingRequirement>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(OnboardingDraftVersion)]),
          () => ListBuilder<OnboardingDraftVersion>())
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
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ProductComplianceQueueItem)]),
          () => ListBuilder<ProductComplianceQueueItem>())
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
          const FullType(BuiltList, const [const FullType(PsgcArea)]),
          () => ListBuilder<PsgcArea>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(PublicStoreSummary)]),
          () => ListBuilder<PublicStoreSummary>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(StoreActivationBlocker)]),
          () => ListBuilder<StoreActivationBlocker>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(StoreOperatingDay)]),
          () => ListBuilder<StoreOperatingDay>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(StoreOperatingDay)]),
          () => ListBuilder<StoreOperatingDay>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(StoreOperatingDay)]),
          () => ListBuilder<StoreOperatingDay>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(VendorSetupDraftVehiclesInner)]),
          () => ListBuilder<VendorSetupDraftVehiclesInner>())
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
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => MapBuilder<String, String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => MapBuilder<String, String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(CatalogVariant)]),
          () => ListBuilder<CatalogVariant>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(CatalogMedia)]),
          () => ListBuilder<CatalogMedia>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ComplianceSubmissionSummary)]),
          () => ListBuilder<ComplianceSubmissionSummary>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ListingStatusChange)]),
          () => ListBuilder<ListingStatusChange>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(CatalogBlocker)]),
          () => ListBuilder<CatalogBlocker>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltSet, const [const FullType(String)]),
          () => SetBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(VendorTeamActivity)]),
          () => ListBuilder<VendorTeamActivity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(VendorTeamInvitationRecord)]),
          () => ListBuilder<VendorTeamInvitationRecord>())
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
            const FullType(BuiltList, const [const FullType(String)])
          ]),
          () => MapBuilder<String, BuiltList<String>>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => MapBuilder<String, String>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => MapBuilder<String, String>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => MapBuilder<String, String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(CatalogVolumeTier)]),
          () => ListBuilder<CatalogVolumeTier>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => MapBuilder<String, String>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(CatalogVolumeTierInput)]),
          () => ListBuilder<CatalogVolumeTierInput>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(int)]),
          () => MapBuilder<String, int>())
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
          () => ListBuilder<JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltSet, const [
            const FullType(
                VendorVerificationDraftRepresentativeAuthorityScopesEnum)
          ]),
          () => SetBuilder<
              VendorVerificationDraftRepresentativeAuthorityScopesEnum>()))
    .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
