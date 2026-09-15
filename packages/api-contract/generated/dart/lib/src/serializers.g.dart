// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (Serializers().toBuilder()
      ..add($SuccessEnvelope.serializer)
      ..add(AcceptVendorCommission.serializer)
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
      ..add(AdminInvitationRequest.serializer)
      ..add(AdminInvitationRequestPrivacyAcceptedEnum.serializer)
      ..add(AdminInvitationRequestTermsAcceptedEnum.serializer)
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
      ..add(ChangeVendorTeamMember.serializer)
      ..add(ChangeVendorTeamMemberRoleEnum.serializer)
      ..add(ChangeVendorTeamMemberStatusEnum.serializer)
      ..add(ConnectVendorTest.serializer)
      ..add(ConnectVendorTestWithholdingDemoScenarioEnum.serializer)
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
      ..add(InviteVendorTeam.serializer)
      ..add(InviteVendorTeamRoleEnum.serializer)
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
      ..add(SaveVendorBusiness.serializer)
      ..add(SaveVendorStore.serializer)
      ..add(SaveVendorStoreFulfillmentEnum.serializer)
      ..add(SaveVendorStoreRefundConfiguration.serializer)
      ..add(SaveVendorTax.serializer)
      ..add(UserIdentity.serializer)
      ..add(VendorBotProtectionEvidence.serializer)
      ..add(VendorBusiness.serializer)
      ..add(VendorBusinessAddress.serializer)
      ..add(VendorBusinessContact.serializer)
      ..add(VendorBusinessDraft.serializer)
      ..add(VendorBusinessDraftBusinessTypeEnum.serializer)
      ..add(VendorBusinessDraftClassificationEnum.serializer)
      ..add(VendorBusinessDraftNichesEnum.serializer)
      ..add(VendorBusinessEnvelope.serializer)
      ..add(VendorBusinessReview.serializer)
      ..add(VendorBusinessReviewDecisionEnum.serializer)
      ..add(VendorBusinessStatusEnum.serializer)
      ..add(VendorChecklistItem.serializer)
      ..add(VendorChecklistItemRequirementLevelEnum.serializer)
      ..add(VendorChecklistItemSectionEnum.serializer)
      ..add(VendorChecklistItemStatusEnum.serializer)
      ..add(VendorCommissionTerms.serializer)
      ..add(VendorCommissionTermsEnvelope.serializer)
      ..add(VendorConnection.serializer)
      ..add(VendorDocument.serializer)
      ..add(VendorDocumentListEnvelope.serializer)
      ..add(VendorDocumentReview.serializer)
      ..add(VendorDocumentReviewDecisionEnum.serializer)
      ..add(VendorDocumentUpload.serializer)
      ..add(VendorDocumentUploadEnvelope.serializer)
      ..add(VendorDownloadLink.serializer)
      ..add(VendorDownloadLinkEnvelope.serializer)
      ..add(VendorIndividualRegisteredName.serializer)
      ..add(VendorInvitationAcceptance.serializer)
      ..add(VendorMutationEnvelope.serializer)
      ..add(VendorOperatingDay.serializer)
      ..add(VendorReadiness.serializer)
      ..add(VendorReadinessActivationStatusEnum.serializer)
      ..add(VendorReadinessDiscoverabilityStatusEnum.serializer)
      ..add(VendorReadinessEnvelope.serializer)
      ..add(VendorReadinessEnvironmentEnum.serializer)
      ..add(VendorReadinessOnboardingStatusEnum.serializer)
      ..add(VendorReadinessStoreSetupStatusEnum.serializer)
      ..add(VendorReadinessStoreVerificationStatusEnum.serializer)
      ..add(VendorReview.serializer)
      ..add(VendorReviewDecisionEnum.serializer)
      ..add(VendorSetup.serializer)
      ..add(VendorSetupEnvelope.serializer)
      ..add(VendorStore.serializer)
      ..add(VendorStoreEmailVerification.serializer)
      ..add(VendorStoreEmailVerificationConfirmation.serializer)
      ..add(VendorStoreEmailVerificationRequest.serializer)
      ..add(VendorStoreMedia.serializer)
      ..add(VendorStoreMediaKindEnum.serializer)
      ..add(VendorStoreMediaListEnvelope.serializer)
      ..add(VendorTaxData.serializer)
      ..add(VendorTaxDataEntityClassEnum.serializer)
      ..add(VendorTaxDataVatCategoryEnum.serializer)
      ..add(VendorTaxProfile.serializer)
      ..add(VendorTaxProfileEnvelope.serializer)
      ..add(VendorTaxProfileEvidenceVersionsInner.serializer)
      ..add(VendorTaxProfileLegalEffectEnum.serializer)
      ..add(VendorTaxReviewHistory.serializer)
      ..add(VendorTaxReviewHistoryEnvironmentEnum.serializer)
      ..add(VendorTaxVersionHistory.serializer)
      ..add(VendorTaxVersionHistoryEnvironmentEnum.serializer)
      ..add(VendorTaxVersionHistoryEvidenceOriginEnum.serializer)
      ..add(VendorTeam.serializer)
      ..add(VendorTeamEnvelope.serializer)
      ..add(VendorTeamInvitation.serializer)
      ..add(VendorTeamInvitationListEnvelope.serializer)
      ..add(VendorTeamMember.serializer)
      ..add(VendorVehicle.serializer)
      ..add(VendorVehicleVehicleSubtypeEnum.serializer)
      ..add(VendorVehicleVehicleTypeEnum.serializer)
      ..add(VendorVerificationRow.serializer)
      ..add(VendorVerificationRowListEnvelope.serializer)
      ..add(VendorVerificationRowOnboardingStatusEnum.serializer)
      ..add(VendorVerificationRowStoreSetupStatusEnum.serializer)
      ..add(VendorVerificationRowStoreVerificationStatusEnum.serializer)
      ..add(VendorVersionMutation.serializer)
      ..add(VerifyBotChallengeRequest.serializer)
      ..add(VerifyEmailRequest.serializer)
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
              BuiltList, const [const FullType(VendorBusinessDraftNichesEnum)]),
          () => ListBuilder<VendorBusinessDraftNichesEnum>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(VendorBusinessContact)]),
          () => ListBuilder<VendorBusinessContact>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(VendorChecklistItem)]),
          () => ListBuilder<VendorChecklistItem>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(VendorDocument)]),
          () => ListBuilder<VendorDocument>())
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
          const FullType(BuiltList, const [const FullType(VendorOperatingDay)]),
          () => ListBuilder<VendorOperatingDay>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(VendorVehicle)]),
          () => ListBuilder<VendorVehicle>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(VendorStoreMedia)]),
          () => ListBuilder<VendorStoreMedia>())
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
          const FullType(BuiltList,
              const [const FullType(VendorTaxProfileEvidenceVersionsInner)]),
          () => ListBuilder<VendorTaxProfileEvidenceVersionsInner>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(VendorTaxVersionHistory)]),
          () => ListBuilder<VendorTaxVersionHistory>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(VendorTaxReviewHistory)]),
          () => ListBuilder<VendorTaxReviewHistory>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(VendorTeamInvitation)]),
          () => ListBuilder<VendorTeamInvitation>())
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
          const FullType(BuiltList, const [const FullType(VendorTeamMember)]),
          () => ListBuilder<VendorTeamMember>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(VendorVehicle)]),
          () => ListBuilder<VendorVehicle>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(VendorOperatingDay)]),
          () => ListBuilder<VendorOperatingDay>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(VendorVerificationRow)]),
          () => ListBuilder<VendorVerificationRow>())
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
          const FullType(BuiltList, const [const FullType(ApiError)]),
          () => ListBuilder<ApiError>())
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
          const FullType(BuiltList, const [const FullType(ApiError)]),
          () => ListBuilder<ApiError>())
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
          const FullType(BuiltList, const [const FullType(ApiError)]),
          () => ListBuilder<ApiError>())
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
          const FullType(BuiltList, const [const FullType(ApiError)]),
          () => ListBuilder<ApiError>())
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
