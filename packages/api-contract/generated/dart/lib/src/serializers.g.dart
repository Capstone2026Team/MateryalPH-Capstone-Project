// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (Serializers().toBuilder()
      ..add($AdminAnalyticsRow.serializer)
      ..add($AuditEvent.serializer)
      ..add($BuyerAnalyticsProductRow.serializer)
      ..add($BuyerAnalyticsRow.serializer)
      ..add($EnforcementSummary.serializer)
      ..add($ProjectCandidateRequest.serializer)
      ..add($SubjectReview.serializer)
      ..add($SuccessEnvelope.serializer)
      ..add($VendorAnalyticsRow.serializer)
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
      ..add(ActivationBlocker.serializer)
      ..add(ActivationBlockerCategoryEnum.serializer)
      ..add(ActivationBlockerSource.serializer)
      ..add(ActivationRestrictions.serializer)
      ..add(ActivationRestrictionsCategoriesEnum.serializer)
      ..add(ActivationRestrictionsOverrideAvailableEnum.serializer)
      ..add(AddressComponents.serializer)
      ..add(AdminAnalyticsPoint.serializer)
      ..add(AdminAnalyticsPointStatusEnum.serializer)
      ..add(AdminCancellationRequestListEnvelope.serializer)
      ..add(AdminCancellationRequestRow.serializer)
      ..add(AdminDashboardActivityPoint.serializer)
      ..add(AdminDashboardAreaSegment.serializer)
      ..add(AdminDashboardAreas.serializer)
      ..add(AdminDashboardAreasPointsInner.serializer)
      ..add(AdminDashboardAreasRecruitmentInner.serializer)
      ..add(AdminDashboardAreasStateEnum.serializer)
      ..add(AdminDashboardAreasUnusualInner.serializer)
      ..add(AdminDashboardAuditEnvelope.serializer)
      ..add(AdminDashboardCategories.serializer)
      ..add(AdminDashboardCategoriesDemandInner.serializer)
      ..add(AdminDashboardEnvelope.serializer)
      ..add(AdminDashboardInsights.serializer)
      ..add(AdminDashboardInsightsAccess.serializer)
      ..add(AdminDashboardInsightsEnvelope.serializer)
      ..add(AdminDashboardMarketplace.serializer)
      ..add(AdminDashboardMarketplaceDisclosure.serializer)
      ..add(AdminDashboardMarketplaceDisclosureMethodEnum.serializer)
      ..add(AdminDashboardMarketplaceForecast.serializer)
      ..add(AdminDashboardMarketplacePeriod.serializer)
      ..add(AdminDashboardMarketplacePeriodGranularityEnum.serializer)
      ..add(AdminDashboardSeriesPoint.serializer)
      ..add(AdminDashboardSummary.serializer)
      ..add(AdminDashboardVendorHealth.serializer)
      ..add(AdminDashboardVendorHealthAttentionInner.serializer)
      ..add(AdminDashboardVendorHealthAttentionInnerClass_Enum.serializer)
      ..add(AdminDashboardVendorHealthClassesInner.serializer)
      ..add(AdminDashboardVendorHealthClassesInnerKeyEnum.serializer)
      ..add(AdminDashboardVendorHealthSegments.serializer)
      ..add(AdminDashboardVendorHealthSegmentsSegmentsInner.serializer)
      ..add(AdminDashboardVendorHealthSegmentsStateEnum.serializer)
      ..add(AdminDisputeAppealDecisionRequest.serializer)
      ..add(AdminDisputeAppealDecisionRequestMetricEventEnum.serializer)
      ..add(AdminDisputeAppealDecisionRequestOutcomeEnum.serializer)
      ..add(AdminDisputeAppealDecisionRequestResultEnum.serializer)
      ..add(AdminDisputeClarificationRequest.serializer)
      ..add(AdminDisputeClarificationRequestPartiesEnum.serializer)
      ..add(AdminDisputeDecisionRequest.serializer)
      ..add(AdminDisputeDecisionRequestMetricEventEnum.serializer)
      ..add(AdminDisputeDecisionRequestOutcomeEnum.serializer)
      ..add(AdminInvitationRequest.serializer)
      ..add(AdminInvitationRequestPrivacyAcceptedEnum.serializer)
      ..add(AdminInvitationRequestTermsAcceptedEnum.serializer)
      ..add(AdminMaterialsAnalyticsDetail.serializer)
      ..add(AdminMaterialsAnalyticsDetailAudienceEnum.serializer)
      ..add(AdminMaterialsAnalyticsDetailEnvelope.serializer)
      ..add(AdminMaterialsAnalyticsDetailGroup.serializer)
      ..add(AdminMaterialsAnalyticsDetailSourceKindEnum.serializer)
      ..add(AdminMaterialsAnalyticsList.serializer)
      ..add(AdminMaterialsAnalyticsListAudienceEnum.serializer)
      ..add(AdminMaterialsAnalyticsListEnvelope.serializer)
      ..add(AdminMaterialsAnalyticsListSourceKindEnum.serializer)
      ..add(AdminOrderActionResultEnvelope.serializer)
      ..add(AdminOrderOperationsSummary.serializer)
      ..add(AdminOrderOperationsSummaryEnvelope.serializer)
      ..add(AdminPaymentListEnvelope.serializer)
      ..add(AdminRefundListEnvelope.serializer)
      ..add(AdminRefundRow.serializer)
      ..add(AdminRefundRowDisplayStateEnum.serializer)
      ..add(AdminRefundRowStateEnum.serializer)
      ..add(AdminRefundRowTargetTypeEnum.serializer)
      ..add(AdminRefundRowTriggerEnum.serializer)
      ..add(AdminReimbursementDecision.serializer)
      ..add(AdminReimbursementListEnvelope.serializer)
      ..add(AdminReimbursementRow.serializer)
      ..add(AdminReimbursementRowStateEnum.serializer)
      ..add(AdminScoreDetail.serializer)
      ..add(AdminScoreDetailEnvelope.serializer)
      ..add(AdminScoreListEnvelope.serializer)
      ..add(AdminScoreRow.serializer)
      ..add(AdminVendorVerificationDecision.serializer)
      ..add(AdminVendorVerificationDecisionAuthorityScopesEnum.serializer)
      ..add(AdminVendorVerificationDecisionDecisionEnum.serializer)
      ..add(AdminVendorVerificationDecisionExpirationKindEnum.serializer)
      ..add(AdminVendorVerificationDecisionVerifiedVatCategoryEnum.serializer)
      ..add(AdminVendorVerificationDetail.serializer)
      ..add(AdminVendorVerificationDetailEnvelope.serializer)
      ..add(AdminVendorVerificationQueueEnvelope.serializer)
      ..add(AdminVendorVerificationQueueItem.serializer)
      ..add(Agreement.serializer)
      ..add(AgreementListEnvelope.serializer)
      ..add(AnalyticsCategoryRef.serializer)
      ..add(AnalyticsCorrectionEnvelope.serializer)
      ..add(AnalyticsCorrectionRequest.serializer)
      ..add(AnalyticsCorrectionResult.serializer)
      ..add(AnalyticsCurrentCounts.serializer)
      ..add(AnalyticsCurrentCountsStatusEnum.serializer)
      ..add(AnalyticsMaterialRef.serializer)
      ..add(AnalyticsPriceRange.serializer)
      ..add(AnalyticsRun.serializer)
      ..add(AnalyticsRunListEnvelope.serializer)
      ..add(AnalyticsRunStateEnum.serializer)
      ..add(AnalyticsSnapshotRef.serializer)
      ..add(AnalyticsSource.serializer)
      ..add(AnalyticsSourceListEnvelope.serializer)
      ..add(AnalyticsTrend.serializer)
      ..add(AnalyticsTrendDirectionEnum.serializer)
      ..add(AnalyticsTrendReasonEnum.serializer)
      ..add(AnalyticsUnit.serializer)
      ..add(AnalyticsWindow.serializer)
      ..add(ApiError.serializer)
      ..add(AuditActionListEnvelope.serializer)
      ..add(AuditEventDetail.serializer)
      ..add(AuditEventDetailEnvelope.serializer)
      ..add(AuditEventListEnvelope.serializer)
      ..add(AuditSearchMeta.serializer)
      ..add(AuthEnvelope.serializer)
      ..add(AuthEnvelopeAllOfData.serializer)
      ..add(AutoAcceptAllotmentUpdate.serializer)
      ..add(AutoAcceptOutcome.serializer)
      ..add(AutoAcceptOutcomeRoutedToEnum.serializer)
      ..add(AutoAcceptPause.serializer)
      ..add(AutoAcceptPolicy.serializer)
      ..add(AutoAcceptPolicyConfigure.serializer)
      ..add(AutoAcceptPolicyDetail.serializer)
      ..add(AutoAcceptPolicyDetailEnvelope.serializer)
      ..add(AutoAcceptPolicyDetailPermissions.serializer)
      ..add(AutoAcceptPolicyDetailScope.serializer)
      ..add(AutoAcceptPolicyDetailScopeItemBasedOnlyEnum.serializer)
      ..add(AutoAcceptPolicyDetailScopeNrpcExcludedEnum.serializer)
      ..add(AutoAcceptPolicyDetailScopeProjectBasedExcludedEnum.serializer)
      ..add(AutoAcceptPolicyDetailStock.serializer)
      ..add(AutoAcceptPolicyPauseReasonEnum.serializer)
      ..add(AutoAcceptPolicyVersion.serializer)
      ..add(AutoAcceptPolicyVersionChangeKindEnum.serializer)
      ..add(AutoAcceptReason.serializer)
      ..add(AutoAcceptResume.serializer)
      ..add(AutoAcceptStatus.serializer)
      ..add(BadgeMetric.serializer)
      ..add(BadgeMetricKeyEnum.serializer)
      ..add(BadgeState.serializer)
      ..add(BadgeStateCodeEnum.serializer)
      ..add(BadgeStateScopesInner.serializer)
      ..add(BadgeStateStatusEnum.serializer)
      ..add(BadgeSuppressionRequest.serializer)
      ..add(BadgeSuppressionRequestBadgeCodeEnum.serializer)
      ..add(BadgeSuppressionRequestReasonCodeEnum.serializer)
      ..add(BotProofEnvelope.serializer)
      ..add(BotProofEnvelopeAllOfData.serializer)
      ..add(BotProofEnvelopeAllOfDataVerifiedEnum.serializer)
      ..add(BotStepUpErrorEnvelope.serializer)
      ..add(BotStepUpErrorEnvelopeAllOfErrors.serializer)
      ..add(BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails.serializer)
      ..add(BotStepUpErrorEnvelopeAllOfErrorsCodeEnum.serializer)
      ..add(BudgetOverrideListEnvelope.serializer)
      ..add(BudgetOverrideRecord.serializer)
      ..add(BuyAgainAddedLine.serializer)
      ..add(BuyAgainEnvelope.serializer)
      ..add(BuyAgainResult.serializer)
      ..add(BuyAgainSkippedLine.serializer)
      ..add(BuyAgainSkippedLineReasonCodeEnum.serializer)
      ..add(BuyerAccountDeletionBlockers.serializer)
      ..add(BuyerAccountDeletionPreview.serializer)
      ..add(BuyerAccountDeletionPreviewEnvelope.serializer)
      ..add(BuyerAccountDeletionRequest.serializer)
      ..add(BuyerAccountDeletionRequestConfirmationEnum.serializer)
      ..add(BuyerAccountDeletionResult.serializer)
      ..add(BuyerAccountDeletionResultEnvelope.serializer)
      ..add(BuyerAccountRetainedRecord.serializer)
      ..add(BuyerAnalyticsCategorySummary.serializer)
      ..add(BuyerAnalyticsFeaturedVariant.serializer)
      ..add(BuyerAnalyticsPoint.serializer)
      ..add(BuyerAnalyticsPointStatusEnum.serializer)
      ..add(BuyerAnalyticsProductDetail.serializer)
      ..add(BuyerAnalyticsProductDetailAudienceEnum.serializer)
      ..add(BuyerAnalyticsProductDetailEnvelope.serializer)
      ..add(BuyerAnalyticsProductDetailProduct.serializer)
      ..add(BuyerAnalyticsProductDetailSourceKindEnum.serializer)
      ..add(BuyerAnalyticsProductList.serializer)
      ..add(BuyerAnalyticsProductListAudienceEnum.serializer)
      ..add(BuyerAnalyticsProductListEnvelope.serializer)
      ..add(BuyerAnalyticsProductListSourceKindEnum.serializer)
      ..add(BuyerAnalyticsProductVariant.serializer)
      ..add(BuyerAnalyticsProductVariantAvailabilityEnum.serializer)
      ..add(BuyerCancelRequest.serializer)
      ..add(BuyerCancelRequestReasonCodeEnum.serializer)
      ..add(BuyerCancellationPreview.serializer)
      ..add(BuyerCancellationPreviewEnvelope.serializer)
      ..add(BuyerIndustryClassification.serializer)
      ..add(BuyerInvoiceBillingDetails.serializer)
      ..add(BuyerLocation.serializer)
      ..add(BuyerLocationCreate.serializer)
      ..add(BuyerLocationEnvelope.serializer)
      ..add(BuyerLocationKind.serializer)
      ..add(BuyerLocationListEnvelope.serializer)
      ..add(BuyerLocationPreview.serializer)
      ..add(BuyerLocationPreviewEnvelope.serializer)
      ..add(BuyerLocationPreviewProviderStatusEnum.serializer)
      ..add(BuyerLocationPreviewSource_Enum.serializer)
      ..add(BuyerLocationRemoved.serializer)
      ..add(BuyerLocationRemovedEnvelope.serializer)
      ..add(BuyerLocationResolveRequest.serializer)
      ..add(BuyerLocationResolveRequestModeEnum.serializer)
      ..add(BuyerLocationUpdate.serializer)
      ..add(BuyerMaterialsAnalyticsDetail.serializer)
      ..add(BuyerMaterialsAnalyticsDetailAudienceEnum.serializer)
      ..add(BuyerMaterialsAnalyticsDetailEnvelope.serializer)
      ..add(BuyerMaterialsAnalyticsDetailGroup.serializer)
      ..add(BuyerMaterialsAnalyticsDetailSourceKindEnum.serializer)
      ..add(BuyerMaterialsAnalyticsList.serializer)
      ..add(BuyerMaterialsAnalyticsListAudienceEnum.serializer)
      ..add(BuyerMaterialsAnalyticsListEnvelope.serializer)
      ..add(BuyerMaterialsAnalyticsListSourceKindEnum.serializer)
      ..add(BuyerMaterialsAnalyticsRequest.serializer)
      ..add(BuyerMaterialsAnalyticsRequestOriginSourceEnum.serializer)
      ..add(BuyerMaterialsAnalyticsRequestPresetDaysEnum.serializer)
      ..add(BuyerMaterialsAnalyticsRequestRadiusKmEnum.serializer)
      ..add(BuyerMobileGoogleOidcStartRequest.serializer)
      ..add(BuyerMobileGoogleOidcStartRequestModeEnum.serializer)
      ..add(BuyerMobileLoginRequest.serializer)
      ..add(BuyerMobileMfaChallengeRequest.serializer)
      ..add(BuyerMobileMfaRecoveryRequest.serializer)
      ..add(BuyerMobilePasswordRecoveryRequest.serializer)
      ..add(BuyerMobileRefreshRequest.serializer)
      ..add(BuyerMobileRegisterRequest.serializer)
      ..add(BuyerMobileRegisterRequestPrivacyAcceptedEnum.serializer)
      ..add(BuyerMobileRegisterRequestTermsAcceptedEnum.serializer)
      ..add(BuyerOnboarding.serializer)
      ..add(BuyerOnboardingEnvelope.serializer)
      ..add(BuyerOnboardingStatusEnum.serializer)
      ..add(BuyerOnboardingUpdate.serializer)
      ..add(BuyerOnboardingUpdateActionEnum.serializer)
      ..add(BuyerOrderInvoices.serializer)
      ..add(BuyerOrderInvoicesEnvelope.serializer)
      ..add(BuyerOrderInvoicesStatusEnum.serializer)
      ..add(BuyerOrderReviews.serializer)
      ..add(BuyerOrderReviewsEnvelope.serializer)
      ..add(BuyerOrderReviewsPartyEnum.serializer)
      ..add(BuyerOrderReviewsRevealReasonEnum.serializer)
      ..add(BuyerOrderReviewsSpeedKindEnum.serializer)
      ..add(BuyerOrderReviewsStateEnum.serializer)
      ..add(BuyerOriginRequest.serializer)
      ..add(BuyerOriginRequestOriginSourceEnum.serializer)
      ..add(BuyerReviewEditRequest.serializer)
      ..add(BuyerReviewSubmitRequest.serializer)
      ..add(BuyerReviewSubmitRequestDisplayNameChoiceEnum.serializer)
      ..add(BuyerReviewSubmitRequestProductReviewsInner.serializer)
      ..add(BuyerReviewSubmitRequestVendorRating.serializer)
      ..add(BuyerTwoFactorConfirmation.serializer)
      ..add(BuyerTwoFactorDisable.serializer)
      ..add(BuyerTwoFactorEnrollment.serializer)
      ..add(BuyerTwoFactorEnrollmentEnvelope.serializer)
      ..add(CancellationDecisionView.serializer)
      ..add(CancellationDecisionViewCauseEnum.serializer)
      ..add(CancellationDecisionViewDecidedByEnum.serializer)
      ..add(CancellationPlan.serializer)
      ..add(CancellationPlanCauseEnum.serializer)
      ..add(CancellationPlanExcludesEnum.serializer)
      ..add(CancellationPlanPayment.serializer)
      ..add(CancellationRemedy.serializer)
      ..add(CancellationRemedyCodeEnum.serializer)
      ..add(Cart.serializer)
      ..add(CartDestination.serializer)
      ..add(CartDestinationHeavyVehicleRestrictionEnum.serializer)
      ..add(CartDestinationLabels.serializer)
      ..add(CartDestinationUpdate.serializer)
      ..add(CartDestinationUpdateHeavyVehicleRestrictionEnum.serializer)
      ..add(CartDestinationVehicleEndpointEnum.serializer)
      ..add(CartEnvelope.serializer)
      ..add(CartFulfillmentUpdate.serializer)
      ..add(CartFulfillmentUpdateFulfillmentMethodEnum.serializer)
      ..add(CartIssue.serializer)
      ..add(CartIssueSeverityEnum.serializer)
      ..add(CartItemCreate.serializer)
      ..add(CartItemCreateFulfillmentMethodEnum.serializer)
      ..add(CartItemCreateOriginSourceEnum.serializer)
      ..add(CartItemUpdate.serializer)
      ..add(CartLine.serializer)
      ..add(CartLineCurrent.serializer)
      ..add(CartLineCurrentStockLabelEnum.serializer)
      ..add(CartLineCurrentTaxCategoryEnum.serializer)
      ..add(CartLineSnapshot.serializer)
      ..add(CartLineStatusEnum.serializer)
      ..add(CartLocationRef.serializer)
      ..add(CartLocationRefStatusEnum.serializer)
      ..add(CartSummary.serializer)
      ..add(CartSummaryReservesStockEnum.serializer)
      ..add(CartVendorGroup.serializer)
      ..add(CartVendorGroupFulfillmentMethodEnum.serializer)
      ..add(CartVendorGroupFulfillmentOptionsEnum.serializer)
      ..add(CartVendorGroupStatusEnum.serializer)
      ..add(CartVendorRef.serializer)
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
      ..add(ChannelFeeVersion.serializer)
      ..add(ChannelFeeVersionListEnvelope.serializer)
      ..add(ChatAttachment.serializer)
      ..add(ChatAttachmentScanStateEnum.serializer)
      ..add(ChatChannelAuth.serializer)
      ..add(ChatChannelSignature.serializer)
      ..add(ChatCreate.serializer)
      ..add(ChatCreateContextTypeEnum.serializer)
      ..add(ChatDecision.serializer)
      ..add(ChatDecisionPaymentMethodEnum.serializer)
      ..add(ChatDecisionResult.serializer)
      ..add(ChatDecisionResultResponse.serializer)
      ..add(ChatDestinationUpdate.serializer)
      ..add(ChatDestinationUpdateHeavyVehicleRestrictionEnum.serializer)
      ..add(ChatDraftContent.serializer)
      ..add(ChatDraftContentFulfillmentMethodEnum.serializer)
      ..add(ChatDraftContentPaymentMethodEnum.serializer)
      ..add(ChatDraftLine.serializer)
      ..add(ChatDraftSave.serializer)
      ..add(ChatEmptyResponse.serializer)
      ..add(ChatHandler.serializer)
      ..add(ChatHandlersResponse.serializer)
      ..add(ChatId.serializer)
      ..add(ChatIdResponse.serializer)
      ..add(ChatIdentity.serializer)
      ..add(ChatMessage.serializer)
      ..add(ChatMessageKindEnum.serializer)
      ..add(ChatMessagePage.serializer)
      ..add(ChatProduct.serializer)
      ..add(ChatProductPage.serializer)
      ..add(ChatProductPageResponse.serializer)
      ..add(ChatPublish.serializer)
      ..add(ChatQuotation.serializer)
      ..add(ChatQuotationChange.serializer)
      ..add(ChatQuotationContent.serializer)
      ..add(ChatQuotationContentPriceSourceEnum.serializer)
      ..add(ChatQuotationDiscount.serializer)
      ..add(ChatQuotationDiscountAssessment.serializer)
      ..add(ChatQuotationDiscountAssessmentScopeEnum.serializer)
      ..add(ChatQuotationDiscountScopeEnum.serializer)
      ..add(ChatQuotationLine.serializer)
      ..add(ChatQuotationMoney.serializer)
      ..add(ChatQuotationPage.serializer)
      ..add(ChatQuotationPageResponse.serializer)
      ..add(ChatQuotationVersion.serializer)
      ..add(ChatRead.serializer)
      ..add(ChatRealtime.serializer)
      ..add(ChatRealtimeResponse.serializer)
      ..add(ChatSend.serializer)
      ..add(ChatStore.serializer)
      ..add(ChatTransfer.serializer)
      ..add(ChatTyping.serializer)
      ..add(CheckoutChildOrder.serializer)
      ..add(CheckoutChildOrderConfirmationSourceEnum.serializer)
      ..add(CheckoutChildOrderFulfillmentMethodEnum.serializer)
      ..add(CheckoutChildOrderPaymentMethodEnum.serializer)
      ..add(CheckoutGroupPreview.serializer)
      ..add(CheckoutGroupPreviewFulfillmentMethodEnum.serializer)
      ..add(CheckoutGroupPreviewFulfillmentOptionsEnum.serializer)
      ..add(CheckoutGroupPreviewStatusEnum.serializer)
      ..add(CheckoutInvoiceDetails.serializer)
      ..add(CheckoutPreview.serializer)
      ..add(CheckoutPreviewEnvelope.serializer)
      ..add(CheckoutPreviewRequest.serializer)
      ..add(CheckoutPreviewSummary.serializer)
      ..add(CheckoutPreviewSummaryCreatesOrdersEnum.serializer)
      ..add(CheckoutPreviewSummaryReservesStockEnum.serializer)
      ..add(CheckoutSubmission.serializer)
      ..add(CheckoutSubmissionDerivedStatusEnum.serializer)
      ..add(CheckoutSubmissionEnvelope.serializer)
      ..add(CheckoutSubmitRequest.serializer)
      ..add(CheckoutSubmitRequestPaymentMethodsEnum.serializer)
      ..add(CheckoutVendorRef.serializer)
      ..add(CommissionPolicies.serializer)
      ..add(CommissionPoliciesEnvelope.serializer)
      ..add(CommissionPolicy.serializer)
      ..add(CommissionPolicyEnvelope.serializer)
      ..add(CommissionPolicyPublishRequest.serializer)
      ..add(CommissionPolicyStatusEnum.serializer)
      ..add(CommissionTrendPoint.serializer)
      ..add(ComparableGroupCreate.serializer)
      ..add(ComparableGroupEnvelope.serializer)
      ..add(ComparableGroupEnvelopeData.serializer)
      ..add(ComparableSpecification.serializer)
      ..add(ComparableSpecificationAttributesInner.serializer)
      ..add(ComparableStatus.serializer)
      ..add(ComparableStatusStatusEnum.serializer)
      ..add(ComparableVariant.serializer)
      ..add(CompleteWebPasswordRecoveryRequest.serializer)
      ..add(ComplianceEvidence.serializer)
      ..add(ComplianceEvidenceEnvelope.serializer)
      ..add(ComplianceEvidenceEvidenceKindEnum.serializer)
      ..add(ComplianceExtraction.serializer)
      ..add(ComplianceExtractionSource_Enum.serializer)
      ..add(ComplianceExtractionStatusEnum.serializer)
      ..add(ComplianceLookup.serializer)
      ..add(ComplianceLookupEnvelope.serializer)
      ..add(ComplianceLookupReasonEnum.serializer)
      ..add(ComplianceLookupRegister.serializer)
      ..add(ComplianceLookupRequest.serializer)
      ..add(CompliancePath.serializer)
      ..add(ComplianceReferenceResult.serializer)
      ..add(ComplianceRegister.serializer)
      ..add(ComplianceRegisterEnvelope.serializer)
      ..add(ComplianceRegisterListEnvelope.serializer)
      ..add(ComplianceRegisterRecord.serializer)
      ..add(ComplianceRegisterRecordRegisterKindEnum.serializer)
      ..add(ComplianceRegisterRegisterKindEnum.serializer)
      ..add(ComplianceRegisterSourceChannelEnum.serializer)
      ..add(ComplianceRegisterStatusEnum.serializer)
      ..add(ComplianceReviewSummary.serializer)
      ..add(ComplianceReviewSummaryDecisionEnum.serializer)
      ..add(ComplianceReviewSummarySource_Enum.serializer)
      ..add(ComplianceSubmission.serializer)
      ..add(ComplianceSubmissionConfirmedEnum.serializer)
      ..add(ComplianceSubmissionReviewModeEnum.serializer)
      ..add(ComplianceSubmissionSummary.serializer)
      ..add(ComplianceSubmissionSummaryReviewModeEnum.serializer)
      ..add(ComplianceSubmissionSummaryStatusEnum.serializer)
      ..add(ConversationDetail.serializer)
      ..add(ConversationDetailResponse.serializer)
      ..add(ConversationPage.serializer)
      ..add(ConversationPageResponse.serializer)
      ..add(ConversationView.serializer)
      ..add(ConversationViewContextTypeEnum.serializer)
      ..add(ConversationViewPurposeEnum.serializer)
      ..add(CounterpartRating.serializer)
      ..add(CsrfEnvelope.serializer)
      ..add(CsrfEnvelopeAllOfData.serializer)
      ..add(DashboardAction.serializer)
      ..add(DashboardActionKeyEnum.serializer)
      ..add(DashboardActionSeverityEnum.serializer)
      ..add(DashboardAnomaly.serializer)
      ..add(DashboardClassification.serializer)
      ..add(DashboardClassificationBandsEnum.serializer)
      ..add(DashboardClassificationClass_Enum.serializer)
      ..add(DashboardCount.serializer)
      ..add(DashboardDelta.serializer)
      ..add(DashboardForecast.serializer)
      ..add(DashboardForecastDirectionEnum.serializer)
      ..add(DashboardForecastPoint.serializer)
      ..add(DashboardForecastStateEnum.serializer)
      ..add(DashboardRate.serializer)
      ..add(DashboardResponseTime.serializer)
      ..add(DashboardRule.serializer)
      ..add(DatasetLabel.serializer)
      ..add(DatasetLabelKindEnum.serializer)
      ..add(DeliveryAmount.serializer)
      ..add(DeliveryAmountStatusEnum.serializer)
      ..add(DeliveryAssignmentHistory.serializer)
      ..add(DeliveryConfirmation.serializer)
      ..add(DeliveryEstimate.serializer)
      ..add(DeliveryEstimateOption.serializer)
      ..add(DeliveryEstimateOptionMobilizationBasisEnum.serializer)
      ..add(DeliveryFailure.serializer)
      ..add(DeliveryNavigationRoute.serializer)
      ..add(DeliveryNavigationRouteEnvelope.serializer)
      ..add(DeliveryNavigationRoutePoint.serializer)
      ..add(DeliveryPlan.serializer)
      ..add(DeliveryPlanAdvisoryEnum.serializer)
      ..add(DeliveryPlanEndpoint.serializer)
      ..add(DeliveryPlanEndpointHeavyVehicleRestrictionEnum.serializer)
      ..add(DeliveryPlanEndpointKindEnum.serializer)
      ..add(DeliveryPlanEnvelope.serializer)
      ..add(DeliveryPlanFormula.serializer)
      ..add(DeliveryPlanGroup.serializer)
      ..add(DeliveryPlanGroupStatusEnum.serializer)
      ..add(DeliveryPlanRequest.serializer)
      ..add(DeliveryPlanRoute.serializer)
      ..add(DeliveryPlanRouteBasisEnum.serializer)
      ..add(DeliveryPlanStatusEnum.serializer)
      ..add(DeliveryPlanVehicle.serializer)
      ..add(DeliveryPlanVehicleMobilizationBasisEnum.serializer)
      ..add(DeliveryPreview.serializer)
      ..add(DeliveryPreviewEndpointEnum.serializer)
      ..add(DeliveryPreviewEnvelope.serializer)
      ..add(DeliveryPreviewStatusEnum.serializer)
      ..add(DeliveryRoute.serializer)
      ..add(DeliveryRouteBasisEnum.serializer)
      ..add(DeliveryRouteSource_Enum.serializer)
      ..add(DeliveryVehicleOption.serializer)
      ..add(DeliveryVehicleOptionsEnvelope.serializer)
      ..add(DeliveryVehicleSelection.serializer)
      ..add(DeliveryWorkspacePage.serializer)
      ..add(DeliveryWorkspacePageMeta.serializer)
      ..add(DirectoryAvailability.serializer)
      ..add(DirectoryAvailabilityStatusEnum.serializer)
      ..add(DirectoryBuyerEnvelope.serializer)
      ..add(DirectoryBuyerListEnvelope.serializer)
      ..add(DirectoryBuyerProfile.serializer)
      ..add(DirectoryBuyerProfileActivity.serializer)
      ..add(DirectoryBuyerProfileProfile.serializer)
      ..add(DirectoryBuyerProfileRatings.serializer)
      ..add(DirectoryBuyerProfileRatingsReceived.serializer)
      ..add(DirectoryBuyerProfileRatingsWritten.serializer)
      ..add(DirectoryBuyerProfileRecentOrdersInner.serializer)
      ..add(DirectoryBuyerProfileStatusEnum.serializer)
      ..add(DirectoryBuyerProfileSubjectTypeEnum.serializer)
      ..add(DirectoryBuyerRow.serializer)
      ..add(DirectoryBuyerRowBuyerTypeEnum.serializer)
      ..add(DirectoryBuyerRowStatusEnum.serializer)
      ..add(DirectoryListing.serializer)
      ..add(DirectoryListingListEnvelope.serializer)
      ..add(DirectoryListingStockEnum.serializer)
      ..add(DirectoryPageMeta.serializer)
      ..add(DirectoryPageMetaDirectionEnum.serializer)
      ..add(DirectoryPageMetaTypeEnum.serializer)
      ..add(DirectoryReview.serializer)
      ..add(DirectoryReviewListEnvelope.serializer)
      ..add(DirectoryReviewRatingsValue.serializer)
      ..add(DirectoryReviewTypeEnum.serializer)
      ..add(DirectorySanction.serializer)
      ..add(DirectorySanctionActionEnum.serializer)
      ..add(DirectorySanctionStateEnum.serializer)
      ..add(DirectorySupplierDetail.serializer)
      ..add(DirectorySupplierDetailActionsEnum.serializer)
      ..add(DirectorySupplierDetailEnvelope.serializer)
      ..add(DirectorySupplierDetailTierEnum.serializer)
      ..add(DirectorySupplierDetailTierLabelEnum.serializer)
      ..add(DirectorySupplierPhoto.serializer)
      ..add(DirectorySupplierPhotoEnvelope.serializer)
      ..add(DirectorySupplierSummary.serializer)
      ..add(DirectorySupplierSummarySource_Enum.serializer)
      ..add(DirectoryVendorEnvelope.serializer)
      ..add(DirectoryVendorListEnvelope.serializer)
      ..add(DirectoryVendorProfile.serializer)
      ..add(DirectoryVendorProfileActivity.serializer)
      ..add(DirectoryVendorProfileOwner.serializer)
      ..add(DirectoryVendorProfileRatings.serializer)
      ..add(DirectoryVendorProfileRatingsProduct.serializer)
      ..add(DirectoryVendorProfileRatingsStore.serializer)
      ..add(DirectoryVendorProfileStore.serializer)
      ..add(DirectoryVendorProfileSubjectTypeEnum.serializer)
      ..add(DirectoryVendorRow.serializer)
      ..add(DirectoryVendorRowStatusEnum.serializer)
      ..add(DirectoryVendorRowVerificationStatusEnum.serializer)
      ..add(DiscoveryCounts.serializer)
      ..add(DiscoveryPreferences.serializer)
      ..add(DiscoveryPreferencesEnvelope.serializer)
      ..add(DiscoveryScope.serializer)
      ..add(DiscoveryScopeAudienceEnum.serializer)
      ..add(DiscoveryScopeDistanceBasisEnum.serializer)
      ..add(DiscoveryScopeKindEnum.serializer)
      ..add(DiscoveryScopeOriginKindEnum.serializer)
      ..add(DiscoverySearchEnvelope.serializer)
      ..add(DiscoverySearchMeta.serializer)
      ..add(DiscoverySearchRequest.serializer)
      ..add(DiscoverySearchRequestDirectoryMaxDistanceKmEnum.serializer)
      ..add(DiscoverySearchRequestDirectoryMinRatingEnum.serializer)
      ..add(DiscoverySearchRequestOriginSourceEnum.serializer)
      ..add(DisputeAdminContext.serializer)
      ..add(DisputeAdminContextMetricEventsEnum.serializer)
      ..add(DisputeAdminContextOutcomesEnum.serializer)
      ..add(DisputeAdminContextSanctionsEnum.serializer)
      ..add(DisputeAdminParty.serializer)
      ..add(DisputeAffectedLine.serializer)
      ..add(DisputeAppeal.serializer)
      ..add(DisputeAppealAppellantPartyEnum.serializer)
      ..add(DisputeAppealGroundsEnum.serializer)
      ..add(DisputeAppealStateEnum.serializer)
      ..add(DisputeChannelAuthRequest.serializer)
      ..add(DisputeClarification.serializer)
      ..add(DisputeClarificationRequestedPartyEnum.serializer)
      ..add(DisputeClarificationStateEnum.serializer)
      ..add(DisputeDeadline.serializer)
      ..add(DisputeDeadlineKindEnum.serializer)
      ..add(DisputeDeadlineResponsiblePartyEnum.serializer)
      ..add(DisputeDecision.serializer)
      ..add(DisputeDecisionAppealResultEnum.serializer)
      ..add(DisputeDecisionKindEnum.serializer)
      ..add(DisputeDecisionOutcomeEnum.serializer)
      ..add(DisputeDetail.serializer)
      ..add(DisputeDetailAvailableActionsEnum.serializer)
      ..add(DisputeDetailCaseKindEnum.serializer)
      ..add(DisputeDetailEnvelope.serializer)
      ..add(DisputeDetailFiledByPartyEnum.serializer)
      ..add(DisputeDetailIssueTypeEnum.serializer)
      ..add(DisputeDetailPreferredContactChannelEnum.serializer)
      ..add(DisputeDetailRemedyStateEnum.serializer)
      ..add(DisputeDetailRequestedRemedyEnum.serializer)
      ..add(DisputeDetailResponsiblePartyEnum.serializer)
      ..add(DisputeDetailStatusEnum.serializer)
      ..add(DisputeEligibility.serializer)
      ..add(DisputeEligibilityCaseKindEnum.serializer)
      ..add(DisputeEligibilityEnvelope.serializer)
      ..add(DisputeEligibilityIssueTypesEnum.serializer)
      ..add(DisputeEligibilityMethod.serializer)
      ..add(DisputeEligibilityRequestedRemediesEnum.serializer)
      ..add(DisputeEscalateRequest.serializer)
      ..add(DisputeEvidence.serializer)
      ..add(DisputeEvidenceLabelEnum.serializer)
      ..add(DisputeExport.serializer)
      ..add(DisputeExportEnvelope.serializer)
      ..add(DisputeExportListEnvelope.serializer)
      ..add(DisputeExportRequest.serializer)
      ..add(DisputeExportRequestGroupEnum.serializer)
      ..add(DisputeExportStateEnum.serializer)
      ..add(DisputeFileLink.serializer)
      ..add(DisputeHandler.serializer)
      ..add(DisputeHandlerRef.serializer)
      ..add(DisputeListEnvelope.serializer)
      ..add(DisputeListMeta.serializer)
      ..add(DisputeMessageRequest.serializer)
      ..add(DisputeOrderRef.serializer)
      ..add(DisputeOriginalPaymentMethod.serializer)
      ..add(DisputeProposal.serializer)
      ..add(DisputeProposalAnswer.serializer)
      ..add(DisputeProposalAnswerDecisionEnum.serializer)
      ..add(DisputeProposalProposedByPartyEnum.serializer)
      ..add(DisputeProposalRemedyEnum.serializer)
      ..add(DisputeProposalRequest.serializer)
      ..add(DisputeProposalRequestRemedyEnum.serializer)
      ..add(DisputeProposalStateEnum.serializer)
      ..add(DisputeRealtime.serializer)
      ..add(DisputeRealtimeEnvelope.serializer)
      ..add(DisputeRefundable.serializer)
      ..add(DisputeRemedy.serializer)
      ..add(DisputeRemedyConfirmRequest.serializer)
      ..add(DisputeRemedyKindEnum.serializer)
      ..add(DisputeRemedyStateEnum.serializer)
      ..add(DisputeSanctionInput.serializer)
      ..add(DisputeSanctionInputActionEnum.serializer)
      ..add(DisputeSanctionInputSubjectEnum.serializer)
      ..add(DisputeSummary.serializer)
      ..add(DisputeSummaryCaseKindEnum.serializer)
      ..add(DisputeSummaryFiledByPartyEnum.serializer)
      ..add(DisputeSummaryIssueTypeEnum.serializer)
      ..add(DisputeSummaryRemedyStateEnum.serializer)
      ..add(DisputeSummaryRequestedRemedyEnum.serializer)
      ..add(DisputeSummaryResponsiblePartyEnum.serializer)
      ..add(DisputeSummaryStatusEnum.serializer)
      ..add(DisputeTimelineActor.serializer)
      ..add(DisputeTimelineActorPartyEnum.serializer)
      ..add(DisputeTimelineEntry.serializer)
      ..add(DisputeTimelineEntryTypeEnum.serializer)
      ..add(DisputeVendorPermissions.serializer)
      ..add(DocumentExport.serializer)
      ..add(DocumentExportInput.serializer)
      ..add(DocumentExportInputFormatEnum.serializer)
      ..add(DocumentExportInputTypeEnum.serializer)
      ..add(EmailRequest.serializer)
      ..add(EnforcementApplyRequest.serializer)
      ..add(EnforcementApplyRequestContinuationPlanEnum.serializer)
      ..add(EnforcementDetail.serializer)
      ..add(EnforcementDetailAllowedActionsEnum.serializer)
      ..add(EnforcementDetailEnvelope.serializer)
      ..add(EnforcementEvent.serializer)
      ..add(EnforcementEventEventEnum.serializer)
      ..add(EnforcementListEnvelope.serializer)
      ..add(EnforcementRecordRequest.serializer)
      ..add(EnforcementRecordRequestActionEnum.serializer)
      ..add(EnforcementRecordRequestContinuationPlanEnum.serializer)
      ..add(EnforcementRecordRequestSubjectTypeEnum.serializer)
      ..add(EnforcementSubjectEnvelope.serializer)
      ..add(EnforcementSubjectEnvelopeData.serializer)
      ..add(EnforcementSubjectMatch.serializer)
      ..add(EnforcementSubjectMatchListEnvelope.serializer)
      ..add(EnforcementSubjectMatchTypeEnum.serializer)
      ..add(EnforcementSummaryActionEnum.serializer)
      ..add(EnforcementSummaryContinuationPlanEnum.serializer)
      ..add(EnforcementSummarySource_Enum.serializer)
      ..add(EnforcementSummaryStateEnum.serializer)
      ..add(EnforcementSummarySubjectTypeEnum.serializer)
      ..add(ErrorEnvelope.serializer)
      ..add(ExploreCategoryCount.serializer)
      ..add(ExploreCounts.serializer)
      ..add(ExploreLabels.serializer)
      ..add(ExploreSummary.serializer)
      ..add(ExploreSummaryCountScopeEnum.serializer)
      ..add(ExploreSummaryEnvelope.serializer)
      ..add(ExportAccessRecord.serializer)
      ..add(FavoriteSupplier.serializer)
      ..add(FavoriteSupplierListEnvelope.serializer)
      ..add(FavoriteSupplierState.serializer)
      ..add(FavoriteSupplierStateEnvelope.serializer)
      ..add(FavoriteSupplierTierEnum.serializer)
      ..add(FeatureAvailability.serializer)
      ..add(FeatureAvailabilityStatusEnum.serializer)
      ..add(FeeAssessment.serializer)
      ..add(FeeCreditProposalRequest.serializer)
      ..add(FeeStatement.serializer)
      ..add(FeeStatementDetail.serializer)
      ..add(FeeStatementDetailEnvelope.serializer)
      ..add(FeeStatementEnvelope.serializer)
      ..add(FeeStatementListEnvelope.serializer)
      ..add(FeeStatementStateEnum.serializer)
      ..add(FinanceActionResultEnvelope.serializer)
      ..add(FinanceKpi.serializer)
      ..add(FinanceKpiEnvelope.serializer)
      ..add(FinanceKpis.serializer)
      ..add(FinanceKpisPeriod.serializer)
      ..add(FinanceKpisTrendGranularityEnum.serializer)
      ..add(FinancePaymentMethod.serializer)
      ..add(FinancePaymentMethodKindEnum.serializer)
      ..add(FinanceReviewItem.serializer)
      ..add(FinanceReviewItemListEnvelope.serializer)
      ..add(FinanceReviewItemStateEnum.serializer)
      ..add(FinanceTransactionListEnvelope.serializer)
      ..add(FinancialPreview.serializer)
      ..add(FinancialPreviewCurrencyEnum.serializer)
      ..add(FinancialPreviewExcludesEnum.serializer)
      ..add(FinancialPreviewLine.serializer)
      ..add(FinancialPreviewLineTaxCategoryEnum.serializer)
      ..add(FinancialPreviewStatusEnum.serializer)
      ..add(FinancialPreviewVatTreatmentEnum.serializer)
      ..add(FinancialSnapshot.serializer)
      ..add(FinancialSnapshotEnvironmentEnum.serializer)
      ..add(FixedSetting.serializer)
      ..add(FleetSummary.serializer)
      ..add(FleetVehicle.serializer)
      ..add(FleetVehicleEligibility.serializer)
      ..add(FleetVehicleEligibilityReasonsEnum.serializer)
      ..add(FleetVehicleHeavyClassificationEnum.serializer)
      ..add(FleetVehicleImageEnvelope.serializer)
      ..add(FleetVehicleImageEnvelopeData.serializer)
      ..add(FleetVehicleImageEnvelopeDataStatusEnum.serializer)
      ..add(FleetVehicleInput.serializer)
      ..add(FleetVehicleInputHeavyClassificationEnum.serializer)
      ..add(FleetVehicleInputMobilizationBasisEnum.serializer)
      ..add(FleetVehicleInputVehicleCategoryEnum.serializer)
      ..add(FleetVehicleListEnvelope.serializer)
      ..add(FleetVehicleListMeta.serializer)
      ..add(FleetVehicleListMetaDelivery.serializer)
      ..add(FleetVehicleListMetaLimits.serializer)
      ..add(FleetVehicleListMetaPermissions.serializer)
      ..add(FleetVehicleListMetaScopeEnum.serializer)
      ..add(FleetVehicleMobilizationBasisEnum.serializer)
      ..add(FleetVehicleVehicleCategoryEnum.serializer)
      ..add(FleetVehiclesSave.serializer)
      ..add(FulfillmentArrangement.serializer)
      ..add(FulfillmentArrangementVehicle.serializer)
      ..add(FulfillmentAssignee.serializer)
      ..add(FulfillmentAssigneeListEnvelope.serializer)
      ..add(FulfillmentAssignment.serializer)
      ..add(FulfillmentAssignmentRequest.serializer)
      ..add(FulfillmentAssignmentRoleEnum.serializer)
      ..add(FulfillmentConversationPage.serializer)
      ..add(FulfillmentConversationPageResponse.serializer)
      ..add(FulfillmentConversationSummary.serializer)
      ..add(FulfillmentConversationSummaryFulfillmentMethodEnum.serializer)
      ..add(FulfillmentConversationSummaryReadOnlyReasonEnum.serializer)
      ..add(FulfillmentIssue.serializer)
      ..add(FulfillmentIssueCategoryEnum.serializer)
      ..add(FulfillmentIssueResolutionEnum.serializer)
      ..add(FulfillmentIssueStateEnum.serializer)
      ..add(FulfillmentProof.serializer)
      ..add(FulfillmentProofMilestoneEnum.serializer)
      ..add(FulfillmentProofReceiverKindEnum.serializer)
      ..add(FulfillmentReceipt.serializer)
      ..add(FulfillmentReceiptConfirmationSourceEnum.serializer)
      ..add(FulfillmentStep.serializer)
      ..add(FulfillmentStepProofRequirementsEnum.serializer)
      ..add(FulfillmentStepStatusEnum.serializer)
      ..add(FulfillmentThreadRef.serializer)
      ..add(FulfillmentThreadRefReadOnlyReasonEnum.serializer)
      ..add(FulfillmentTrip.serializer)
      ..add(FulfillmentTripRequest.serializer)
      ..add(FulfillmentVehicleIssue.serializer)
      ..add(FulfillmentVehicleIssueCategoryEnum.serializer)
      ..add(GenericDataEnvelope.serializer)
      ..add(GeoActiveUsers.serializer)
      ..add(GeoActivityPoint.serializer)
      ..add(GeoBoundaryCollection.serializer)
      ..add(GeoBoundaryCollectionPsgcVersion.serializer)
      ..add(GeoBoundaryCollectionTypeEnum.serializer)
      ..add(GeoBoundaryEnvelope.serializer)
      ..add(GeoBreadcrumb.serializer)
      ..add(GeoCell.serializer)
      ..add(GeoChild.serializer)
      ..add(GeoChildRegisteredBuyers.serializer)
      ..add(GeoChildSuppressionReasonEnum.serializer)
      ..add(GeoDashboard.serializer)
      ..add(GeoDashboardEnvelope.serializer)
      ..add(GeoDashboardPeriod.serializer)
      ..add(GeoDashboardPeriodGranularityEnum.serializer)
      ..add(GeoDashboardUnresolved.serializer)
      ..add(GeoDataset.serializer)
      ..add(GeoDatasetEnvironmentEnum.serializer)
      ..add(GeoDemand.serializer)
      ..add(GeoDemandCell.serializer)
      ..add(GeoDemandCellValue.serializer)
      ..add(GeoDemandColumnsInner.serializer)
      ..add(GeoDemandDimensionEnum.serializer)
      ..add(GeoDemandEnvelope.serializer)
      ..add(GeoDemandMeasureEnum.serializer)
      ..add(GeoDemandRowsInner.serializer)
      ..add(GeoFilterApplicability.serializer)
      ..add(GeoKpis.serializer)
      ..add(GeoKpisActiveUsers.serializer)
      ..add(GeoRate.serializer)
      ..add(GeoResponseTime.serializer)
      ..add(GeoScope.serializer)
      ..add(GeoScopePsgcVersion.serializer)
      ..add(GeoTrendPoint.serializer)
      ..add(GetNavigationUpdates200Response.serializer)
      ..add(GetNotificationPreferences200Response.serializer)
      ..add(GetNotificationUnreadCount200Response.serializer)
      ..add(GetVendorNavigationUpdates200Response.serializer)
      ..add(GoogleContentAuthor.serializer)
      ..add(GoogleMobileExchangeRequest.serializer)
      ..add(GoogleOidcStartRequest.serializer)
      ..add(GoogleOidcStartRequestModeEnum.serializer)
      ..add(GoogleOidcStartRequestPortalEnum.serializer)
      ..add(GooglePlaceAttribute.serializer)
      ..add(GooglePlacePhoto.serializer)
      ..add(GooglePlaceReview.serializer)
      ..add(GoogleRating.serializer)
      ..add(GoogleRatingSource_Enum.serializer)
      ..add(HealthEnvelope.serializer)
      ..add(HealthEnvelopeAllOfData.serializer)
      ..add(HealthEnvelopeAllOfDataServiceEnum.serializer)
      ..add(HealthEnvelopeAllOfDataStatusEnum.serializer)
      ..add(IntegrationOverview.serializer)
      ..add(IntegrationOverviewEnvelope.serializer)
      ..add(IntegrationStatus.serializer)
      ..add(IntegrationStatusStatusEnum.serializer)
      ..add(InventoryBalance.serializer)
      ..add(InventoryComparability.serializer)
      ..add(InventoryComparabilityStatusEnum.serializer)
      ..add(InventoryLedgerEnvelope.serializer)
      ..add(InventoryLedgerMeta.serializer)
      ..add(InventoryLedgerMetaPermissions.serializer)
      ..add(InventoryLedgerMetaStaleListings.serializer)
      ..add(InventoryLedgerMetaSummary.serializer)
      ..add(InventoryLedgerMetaTimezoneEnum.serializer)
      ..add(InventoryMovement.serializer)
      ..add(InventoryMovementListEnvelope.serializer)
      ..add(InventoryMovementMovementTypeEnum.serializer)
      ..add(InventoryPrice.serializer)
      ..add(InventoryPriceChange.serializer)
      ..add(InventoryRow.serializer)
      ..add(InventoryRowEnvelope.serializer)
      ..add(InventoryRowListEnvelope.serializer)
      ..add(InventoryRowUpdate.serializer)
      ..add(InventoryRowUpdateReasonCodeEnum.serializer)
      ..add(InventorySettings.serializer)
      ..add(InventorySettingsEnvelope.serializer)
      ..add(InventorySettingsInAppRemindersEnum.serializer)
      ..add(InventorySettingsTimezoneEnum.serializer)
      ..add(InventorySettingsUpdate.serializer)
      ..add(InvestigationAckEnvelope.serializer)
      ..add(InvestigationReasonRequest.serializer)
      ..add(InvoiceBillingDetailsRequest.serializer)
      ..add(InvoiceExplanationRequest.serializer)
      ..add(InvoiceListMeta.serializer)
      ..add(InvoiceLogEnvelope.serializer)
      ..add(InvoiceLogRow.serializer)
      ..add(InvoiceOrderLine.serializer)
      ..add(InvoiceRecordView.serializer)
      ..add(InvoiceRecordViewDocumentOriginEnum.serializer)
      ..add(InvoiceRecordViewEInvoicingCoverageEnum.serializer)
      ..add(InvoiceRecordViewInvoiceTypeEnum.serializer)
      ..add(InvoiceRecordViewReconciliationStateEnum.serializer)
      ..add(InvoiceRecordViewVerificationStateEnum.serializer)
      ..add(InvoiceRequestAnswer.serializer)
      ..add(InvoiceRequestAnswerActionEnum.serializer)
      ..add(InvoiceRequestCreate.serializer)
      ..add(InvoiceRequestCreateKindEnum.serializer)
      ..add(InvoiceRequestView.serializer)
      ..add(InvoiceRequestViewKindEnum.serializer)
      ..add(InvoiceRequestViewStateEnum.serializer)
      ..add(ListDocumentExports200Response.serializer)
      ..add(ListNotificationFailures200Response.serializer)
      ..add(ListNotifications200Response.serializer)
      ..add(ListTaxPackages200Response.serializer)
      ..add(ListingAttributeLabel.serializer)
      ..add(ListingCategoryRef.serializer)
      ..add(ListingCompliance.serializer)
      ..add(ListingComplianceBadgeEnum.serializer)
      ..add(ListingComplianceStatus.serializer)
      ..add(ListingDetailFulfillment.serializer)
      ..add(ListingDetailFulfillmentBasisEnum.serializer)
      ..add(ListingDetailFulfillmentDeliveryEnum.serializer)
      ..add(ListingDetailVendor.serializer)
      ..add(ListingDetails.serializer)
      ..add(ListingDetailsEnvelope.serializer)
      ..add(ListingDetailsNotPurchasableReasonEnum.serializer)
      ..add(ListingFulfillmentSummary.serializer)
      ..add(ListingFulfillmentSummaryBasisEnum.serializer)
      ..add(ListingFulfillmentSummaryDeliveryEnum.serializer)
      ..add(ListingImage.serializer)
      ..add(ListingPrice.serializer)
      ..add(ListingPriceCurrencyEnum.serializer)
      ..add(ListingPriceTaxCategoryEnum.serializer)
      ..add(ListingSearchEnvelope.serializer)
      ..add(ListingSearchExpansion.serializer)
      ..add(ListingSearchMeta.serializer)
      ..add(ListingSearchQuery.serializer)
      ..add(ListingSearchRanking.serializer)
      ..add(ListingSearchRequest.serializer)
      ..add(ListingSearchRequestAvailabilityEnum.serializer)
      ..add(ListingSearchRequestComplianceEnum.serializer)
      ..add(ListingSearchRequestFulfillmentEnum.serializer)
      ..add(ListingSearchRequestOriginSourceEnum.serializer)
      ..add(ListingSearchResult.serializer)
      ..add(ListingSearchResultBadgesEnum.serializer)
      ..add(ListingSearchResultStockLabelEnum.serializer)
      ..add(ListingSearchSort.serializer)
      ..add(ListingStatus.serializer)
      ..add(ListingStatusChange.serializer)
      ..add(ListingVariantOffer.serializer)
      ..add(ListingVariantOfferStockLabelEnum.serializer)
      ..add(ListingVariantPrice.serializer)
      ..add(ListingVariantPriceCurrencyEnum.serializer)
      ..add(ListingVariantPriceTaxCategoryEnum.serializer)
      ..add(ListingVendorCard.serializer)
      ..add(LocationAutocompleteRequest.serializer)
      ..add(LocationSuggestion.serializer)
      ..add(LocationSuggestionEnvelope.serializer)
      ..add(LockVersionRequest.serializer)
      ..add(LoginRequest.serializer)
      ..add(LoginRequestPortalEnum.serializer)
      ..add(MapPoint.serializer)
      ..add(MarkNotificationsRead200Response.serializer)
      ..add(MarkingType.serializer)
      ..add(MaterialCategoryOption.serializer)
      ..add(MaterialOffer.serializer)
      ..add(MaterialOfferAvailabilityEnum.serializer)
      ..add(MaterialOfferListEnvelope.serializer)
      ..add(MaterialPriceObservation.serializer)
      ..add(MaterialPriceObservationEnvironmentEnum.serializer)
      ..add(MfaCodeRequest.serializer)
      ..add(MfaEnrollmentEnvelope.serializer)
      ..add(MfaEnrollmentEnvelopeAllOfData.serializer)
      ..add(MfaRecoveryRequest.serializer)
      ..add(MfaStatusEnvelope.serializer)
      ..add(MfaStatusEnvelopeAllOfData.serializer)
      ..add(MfaStatusEnvelopeAllOfDataMfaRequiredEnum.serializer)
      ..add(MixerVolumePlan.serializer)
      ..add(ModerationDetail.serializer)
      ..add(ModerationDetailAvailableActionsEnum.serializer)
      ..add(ModerationDetailEnvelope.serializer)
      ..add(ModerationDetailModerationStateEnum.serializer)
      ..add(ModerationDetailReviewerPartyEnum.serializer)
      ..add(ModerationDetailVisibilityEnum.serializer)
      ..add(ModerationQueueEnvelope.serializer)
      ..add(ModerationQueueRow.serializer)
      ..add(ModerationQueueRowModerationStateEnum.serializer)
      ..add(ModerationQueueRowTypeEnum.serializer)
      ..add(MoneyBreakdown.serializer)
      ..add(MoneyBreakdownCurrencyEnum.serializer)
      ..add(MoneyBreakdownExcludesEnum.serializer)
      ..add(MoneyBreakdownPaymentPurposeEnum.serializer)
      ..add(MoneyBreakdownStatusEnum.serializer)
      ..add(MoneyBreakdownVatTreatmentEnum.serializer)
      ..add(MoneyDelivery.serializer)
      ..add(MoneyDeliveryStatusEnum.serializer)
      ..add(MoneyNrpc.serializer)
      ..add(MoneyNrpcStatusEnum.serializer)
      ..add(MoneyNrpcWithinOrderValueEnum.serializer)
      ..add(MoneyRange.serializer)
      ..add(NavigationUpdates.serializer)
      ..add(NotificationAction.serializer)
      ..add(NotificationBulkReadAction.serializer)
      ..add(NotificationChannelAuthResponse.serializer)
      ..add(NotificationDeviceInput.serializer)
      ..add(NotificationDeviceInputPlatformEnum.serializer)
      ..add(NotificationDeviceResult.serializer)
      ..add(NotificationItem.serializer)
      ..add(NotificationPreference.serializer)
      ..add(NotificationPreferenceInput.serializer)
      ..add(NotificationReadFilter.serializer)
      ..add(NotificationTarget.serializer)
      ..add(NotificationUnreadCount.serializer)
      ..add(NrpcAcceptRequest.serializer)
      ..add(NrpcAcceptRequestAcknowledgedEnum.serializer)
      ..add(NrpcAffectedLine.serializer)
      ..add(NrpcFlag.serializer)
      ..add(NrpcFlagRequest.serializer)
      ..add(NrpcFlagReviewStateEnum.serializer)
      ..add(NrpcLineAllocation.serializer)
      ..add(NrpcProposal.serializer)
      ..add(NrpcRejectRequest.serializer)
      ..add(NrpcTermsRef.serializer)
      ..add(NrpcTermsVersion.serializer)
      ..add(OnboardingDraftVersion.serializer)
      ..add(OnboardingDraftVersionWorkstreamEnum.serializer)
      ..add(OnboardingRequirement.serializer)
      ..add(OnboardingRequirementLevelEnum.serializer)
      ..add(OnboardingRequirementStatusEnum.serializer)
      ..add(OnboardingRequirementWorkstreamEnum.serializer)
      ..add(OnboardingStepCompletion.serializer)
      ..add(OnboardingStepCompletionKeyEnum.serializer)
      ..add(OnboardingStepCompletionWorkstreamEnum.serializer)
      ..add(OperationFailure.serializer)
      ..add(OperationFailureKindEnum.serializer)
      ..add(OperationFailureListEnvelope.serializer)
      ..add(OperationRetryEnvelope.serializer)
      ..add(OperationRetryListEnvelope.serializer)
      ..add(OperationRetryRecord.serializer)
      ..add(OperationRetryRequest.serializer)
      ..add(OperationRetryRequestTargetTypeEnum.serializer)
      ..add(OperationRetryResult.serializer)
      ..add(OperationRetryResultOutcomeEnum.serializer)
      ..add(OperationsQueue.serializer)
      ..add(OrderBuyerRef.serializer)
      ..add(OrderCancellation.serializer)
      ..add(OrderCancellationModeEnum.serializer)
      ..add(OrderChange.serializer)
      ..add(OrderChangeTypeEnum.serializer)
      ..add(OrderCheckoutRef.serializer)
      ..add(OrderClosureReason.serializer)
      ..add(OrderCommercialVersion.serializer)
      ..add(OrderCommercialVersionKindEnum.serializer)
      ..add(OrderConfirmedDelivery.serializer)
      ..add(OrderConfirmedDeliveryBasisEnum.serializer)
      ..add(OrderConfirmedDeliveryEndpointEnum.serializer)
      ..add(OrderConversationRef.serializer)
      ..add(OrderDeadline.serializer)
      ..add(OrderDeadlineKindEnum.serializer)
      ..add(OrderDeadlines.serializer)
      ..add(OrderDeadlinesTimezoneEnum.serializer)
      ..add(OrderDelivery.serializer)
      ..add(OrderDeliveryEstimate.serializer)
      ..add(OrderDeliveryStatusEnum.serializer)
      ..add(OrderDeliveryVehicle.serializer)
      ..add(OrderDeliveryVehicleMobilizationBasisEnum.serializer)
      ..add(OrderDestination.serializer)
      ..add(OrderDestinationHeavyVehicleRestrictionEnum.serializer)
      ..add(OrderDestinationTypeEnum.serializer)
      ..add(OrderDestinationVehicleEndpointEnum.serializer)
      ..add(OrderDetail.serializer)
      ..add(OrderDetailAvailableActionsEnum.serializer)
      ..add(OrderDetailConfirmationSourceEnum.serializer)
      ..add(OrderDetailEnvelope.serializer)
      ..add(OrderDetailFulfillmentMethodEnum.serializer)
      ..add(OrderDetailPaymentMethodEnum.serializer)
      ..add(OrderDetailProcurementTypeEnum.serializer)
      ..add(OrderDisputeRef.serializer)
      ..add(OrderDisputeRefFiledByPartyEnum.serializer)
      ..add(OrderDisputeRefStatusEnum.serializer)
      ..add(OrderFirstLine.serializer)
      ..add(OrderFulfillment.serializer)
      ..add(OrderFulfillmentConversation.serializer)
      ..add(OrderFulfillmentConversationEnvelope.serializer)
      ..add(OrderFulfillmentMethodEnum.serializer)
      ..add(OrderFulfillmentNextActionEnum.serializer)
      ..add(OrderInvoiceRef.serializer)
      ..add(OrderInvoiceRefStatusEnum.serializer)
      ..add(OrderLine.serializer)
      ..add(OrderLineChangeEnum.serializer)
      ..add(OrderLineInventory.serializer)
      ..add(OrderLineQuantity.serializer)
      ..add(OrderListEnvelope.serializer)
      ..add(OrderListMeta.serializer)
      ..add(OrderNrpc.serializer)
      ..add(OrderNrpcStatusEnum.serializer)
      ..add(OrderPaymentAvailability.serializer)
      ..add(OrderPaymentAvailabilityEnvironmentEnum.serializer)
      ..add(OrderPaymentAvailabilityPurposeEnum.serializer)
      ..add(OrderPaymentState.serializer)
      ..add(OrderPoint.serializer)
      ..add(OrderRefundTimeline.serializer)
      ..add(OrderReservation.serializer)
      ..add(OrderReservationStateEnum.serializer)
      ..add(OrderRevisionDecision.serializer)
      ..add(OrderState.serializer)
      ..add(OrderStateRow.serializer)
      ..add(OrderStateRowFamilyEnum.serializer)
      ..add(OrderSummary.serializer)
      ..add(OrderSummaryCardActionsEnum.serializer)
      ..add(OrderSummaryConfirmationSourceEnum.serializer)
      ..add(OrderSummaryFulfillmentMethodEnum.serializer)
      ..add(OrderSummaryNextActionEnum.serializer)
      ..add(OrderSummaryPaymentMethodEnum.serializer)
      ..add(OrderSummaryProcurementTypeEnum.serializer)
      ..add(OrderTimelineEvent.serializer)
      ..add(OrderTimelineEventFamilyEnum.serializer)
      ..add(OrderTimelineEventSource_Enum.serializer)
      ..add(OrderVendorRef.serializer)
      ..add(OrderVolumeTier.serializer)
      ..add(OverlapResolveRequest.serializer)
      ..add(OwnReview.serializer)
      ..add(OwnReviewTypeEnum.serializer)
      ..add(OwnReviewVisibilityEnum.serializer)
      ..add(PageMeta.serializer)
      ..add(PasswordRecoveryEnvelope.serializer)
      ..add(PasswordRecoveryEnvelopeAllOfData.serializer)
      ..add(PasswordRecoveryRequest.serializer)
      ..add(PasswordRecoveryRequestPortalEnum.serializer)
      ..add(PasswordResetRequest.serializer)
      ..add(PaymentAttempt.serializer)
      ..add(PaymentAttemptEnvelope.serializer)
      ..add(PaymentAttemptEnvironmentEnum.serializer)
      ..add(PaymentAttemptEvidenceOriginEnum.serializer)
      ..add(PaymentAttemptFeeBearerEnum.serializer)
      ..add(PaymentAttemptPurposeEnum.serializer)
      ..add(PaymentAttemptStatusEnum.serializer)
      ..add(PaymentChannelOption.serializer)
      ..add(PaymentChannelOptionFeeBearerEnum.serializer)
      ..add(PaymentChannelOptionKindEnum.serializer)
      ..add(PaymentChannelOptionRateSourceEnum.serializer)
      ..add(PaymentCreateRequest.serializer)
      ..add(PaymentMethodEligibility.serializer)
      ..add(PaymentMethodEligibilityMethodEnum.serializer)
      ..add(PaymentOptions.serializer)
      ..add(PaymentOptionsEnvelope.serializer)
      ..add(PaymentOptionsEnvironmentEnum.serializer)
      ..add(PaymentOptionsEvidenceOriginEnum.serializer)
      ..add(PaymentOptionsPurposeEnum.serializer)
      ..add(PaymentWebhookAck.serializer)
      ..add(PaymentWebhookAckEnvelope.serializer)
      ..add(PaymentWebhookPayload.serializer)
      ..add(PhysicalHandoverCash.serializer)
      ..add(PhysicalHandoverCashMilestoneEnum.serializer)
      ..add(PhysicalPaymentRecord.serializer)
      ..add(PhysicalPaymentRecordKindEnum.serializer)
      ..add(PhysicalPaymentRecordSource_Enum.serializer)
      ..add(PhysicalPaymentRecordStateEnum.serializer)
      ..add(PhysicalPaymentSettings.serializer)
      ..add(PhysicalPaymentSettingsEnvelope.serializer)
      ..add(PhysicalPaymentSettingsUpdate.serializer)
      ..add(PhysicalPaymentSummary.serializer)
      ..add(PhysicalPaymentSummaryEnvelope.serializer)
      ..add(PickupConfirmation.serializer)
      ..add(PickupPreview.serializer)
      ..add(PlatformDocumentRef.serializer)
      ..add(PlatformDocumentRefKindEnum.serializer)
      ..add(PlatformDocumentRefLabelEnum.serializer)
      ..add(PlatformSetting.serializer)
      ..add(PlatformSettingEnvelope.serializer)
      ..add(PlatformSettingHistoryEnvelope.serializer)
      ..add(PlatformSettingListEnvelope.serializer)
      ..add(PlatformSettingListMeta.serializer)
      ..add(PlatformSettingUpdateRequest.serializer)
      ..add(PlatformSettingVersion.serializer)
      ..add(PlatformSettingVersionSource_Enum.serializer)
      ..add(PrepareTaxPackage201Response.serializer)
      ..add(PriceHistoryEntry.serializer)
      ..add(PriceHistoryEntryPriceKindEnum.serializer)
      ..add(PriceHistoryEnvelope.serializer)
      ..add(ProblemResolveRequest.serializer)
      ..add(ProblemResponseRequest.serializer)
      ..add(ProcessingFee.serializer)
      ..add(ProcessingFeeAmount.serializer)
      ..add(ProcessingFeeAmountStatusEnum.serializer)
      ..add(ProcessingFeeStatusEnum.serializer)
      ..add(ProductAnalyticsPeriod.serializer)
      ..add(ProductAnalyticsRow.serializer)
      ..add(ProductAnalyticsRowStockStatusEnum.serializer)
      ..add(ProductAnalyticsSegments.serializer)
      ..add(ProductAnalyticsSegmentsPointsInner.serializer)
      ..add(ProductAnalyticsSegmentsSegmentsInner.serializer)
      ..add(ProductAnalyticsSegmentsSegmentsInnerKindEnum.serializer)
      ..add(ProductAnalyticsSegmentsStateEnum.serializer)
      ..add(ProductAnalyticsSeriesPoint.serializer)
      ..add(ProductAnalyticsSuggestion.serializer)
      ..add(ProductAnalyticsSuggestionKindEnum.serializer)
      ..add(ProductAnalyticsSuggestionPriorityEnum.serializer)
      ..add(ProductAnalyticsTracking.serializer)
      ..add(ProductComplianceCaseEnvelope.serializer)
      ..add(ProductComplianceCaseEnvelopeData.serializer)
      ..add(ProductComplianceDecision.serializer)
      ..add(ProductComplianceDecisionDecisionEnum.serializer)
      ..add(ProductComplianceQueueEnvelope.serializer)
      ..add(ProductComplianceQueueItem.serializer)
      ..add(ProductComplianceQueueItemReviewModeEnum.serializer)
      ..add(ProductDeliveryPreviewRequest.serializer)
      ..add(ProductRatingSummary.serializer)
      ..add(ProjectArrangement.serializer)
      ..add(ProjectArrangementCreate.serializer)
      ..add(ProjectArrangementEdit.serializer)
      ..add(ProjectArrangementEditFulfillmentMethodEnum.serializer)
      ..add(ProjectArrangementEditMethodEnum.serializer)
      ..add(ProjectArrangementInquiry.serializer)
      ..add(ProjectArrangementPage.serializer)
      ..add(ProjectArrangementPageResponse.serializer)
      ..add(ProjectArrangementPageSortEnum.serializer)
      ..add(ProjectArrangementResponse.serializer)
      ..add(ProjectArrangementSubmit.serializer)
      ..add(ProjectArrangementSubmitPaymentsInner.serializer)
      ..add(ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum.serializer)
      ..add(ProjectBudget.serializer)
      ..add(ProjectCandidate.serializer)
      ..add(ProjectCandidateFulfillmentOptionsEnum.serializer)
      ..add(ProjectCandidateProcurementBudgetLabelEnum.serializer)
      ..add(ProjectCandidateRequestFulfillmentMethodEnum.serializer)
      ..add(ProjectCandidateRequestPaymentMethodEnum.serializer)
      ..add(ProjectCandidateResponse.serializer)
      ..add(ProjectCompile.serializer)
      ..add(ProjectCompileRadiusKmEnum.serializer)
      ..add(ProjectCompiledEstimate.serializer)
      ..add(ProjectCreate.serializer)
      ..add(ProjectDraftItemInput.serializer)
      ..add(ProjectDraftItemInputFulfillmentMethodEnum.serializer)
      ..add(ProjectDraftSupplierRequest.serializer)
      ..add(ProjectDraftSupplierRequestPaymentMethodEnum.serializer)
      ..add(ProjectDraftVendorGroup.serializer)
      ..add(ProjectDraftVendorGroupFulfillmentMethodEnum.serializer)
      ..add(ProjectDraftVendorGroupFulfillmentOptionsEnum.serializer)
      ..add(ProjectEstimatePage.serializer)
      ..add(ProjectEstimatePageResponse.serializer)
      ..add(ProjectFulfillment.serializer)
      ..add(ProjectFulfillmentLine.serializer)
      ..add(ProjectFulfillmentLineStatusEnum.serializer)
      ..add(ProjectFulfillmentStatusEnum.serializer)
      ..add(ProjectImportPreview.serializer)
      ..add(ProjectImportPreviewResponse.serializer)
      ..add(ProjectImportRequest.serializer)
      ..add(ProjectMaterial.serializer)
      ..add(ProjectMaterialAttribute.serializer)
      ..add(ProjectMaterialAttributeValueTypeEnum.serializer)
      ..add(ProjectMaterialMatchTypeEnum.serializer)
      ..add(ProjectMaterialPage.serializer)
      ..add(ProjectMaterialPageResponse.serializer)
      ..add(ProjectMaterialUnit.serializer)
      ..add(ProjectMissingResolve.serializer)
      ..add(ProjectPage.serializer)
      ..add(ProjectPageResponse.serializer)
      ..add(ProjectPaymentMethod.serializer)
      ..add(ProjectPaymentMethodMethodEnum.serializer)
      ..add(ProjectPreferenceReset.serializer)
      ..add(ProjectPreferenceSave.serializer)
      ..add(ProjectPreferences.serializer)
      ..add(ProjectPreferencesResponse.serializer)
      ..add(ProjectRoute.serializer)
      ..add(ProjectRouteOriginEnum.serializer)
      ..add(ProjectRouteResponse.serializer)
      ..add(ProjectSelectionPreview.serializer)
      ..add(ProjectSelectionPreviewFulfillmentMethodEnum.serializer)
      ..add(ProjectSeparatePurchase.serializer)
      ..add(ProjectSeparatePurchaseStageEnum.serializer)
      ..add(ProjectSite.serializer)
      ..add(ProjectSpecificationDetail.serializer)
      ..add(ProjectSpecificationSelection.serializer)
      ..add(ProjectSummary.serializer)
      ..add(ProjectSummaryStatusEnum.serializer)
      ..add(ProjectUpdate.serializer)
      ..add(ProjectUpdateStatusEnum.serializer)
      ..add(ProjectVendorSelectionRequest.serializer)
      ..add(ProjectVersionRequest.serializer)
      ..add(ProjectView.serializer)
      ..add(ProjectViewResponse.serializer)
      ..add(ProviderAttribution.serializer)
      ..add(ProviderAttributionProviderEnum.serializer)
      ..add(PsgcArea.serializer)
      ..add(PsgcAreaListEnvelope.serializer)
      ..add(PsgcAreaListMeta.serializer)
      ..add(PsgcAreaListMetaStatusEnum.serializer)
      ..add(PsgcAreaOption.serializer)
      ..add(PsgcAreaRef.serializer)
      ..add(PsgcResolution.serializer)
      ..add(PsgcResolutionResolutionEnum.serializer)
      ..add(PsgcSearchEnvelope.serializer)
      ..add(PsgcSearchEnvelopeData.serializer)
      ..add(PublicAddressSummary.serializer)
      ..add(PublicBadge.serializer)
      ..add(PublicBadgeCodeEnum.serializer)
      ..add(PublicReview.serializer)
      ..add(PublicReviewListEnvelope.serializer)
      ..add(PublicReviewTypeEnum.serializer)
      ..add(PublicScores.serializer)
      ..add(PublicStoreListEnvelope.serializer)
      ..add(PublicStoreListEnvelopeMeta.serializer)
      ..add(PublicStoreProfile.serializer)
      ..add(PublicStoreProfileEffectiveSourceEnum.serializer)
      ..add(PublicStoreProfileEnvelope.serializer)
      ..add(PublicStoreProfileHoursStatusEnum.serializer)
      ..add(PublicStoreProfileHoursUnavailableReasonEnum.serializer)
      ..add(PublicStoreProfileTimeZoneEnum.serializer)
      ..add(PublicStoreSummary.serializer)
      ..add(RadiusExpansion.serializer)
      ..add(RadiusKm.serializer)
      ..add(RankingComponent.serializer)
      ..add(RankingComponentKeyEnum.serializer)
      ..add(RankingExplanation.serializer)
      ..add(RankingPreferences.serializer)
      ..add(RankingPreferencesEnvelope.serializer)
      ..add(RankingPreferencesProcurementTypeEnum.serializer)
      ..add(RankingPreferencesUpdate.serializer)
      ..add(RankingWeightSet.serializer)
      ..add(ReadyMixedConcreteDetail.serializer)
      ..add(ReadyMixedConcreteDetailDeliveryVehicleEnum.serializer)
      ..add(ReadyMixedConcreteOpenInspection.serializer)
      ..add(ReadyMixedConcreteOpenInspectionStatusEnum.serializer)
      ..add(ReadyMixedConcreteSiteInspection.serializer)
      ..add(ReasonedVersionRequest.serializer)
      ..add(RecordTaxSimulation200Response.serializer)
      ..add(RefundTimelineItem.serializer)
      ..add(RefundTimelineItemDisplayStateEnum.serializer)
      ..add(RefundTimelineItemStateEnum.serializer)
      ..add(RefundTimelineItemTriggerEnum.serializer)
      ..add(RegisterNotificationDevice201Response.serializer)
      ..add(RegisterRequest.serializer)
      ..add(RegisterRequestPrivacyAcceptedEnum.serializer)
      ..add(RegisterRequestTermsAcceptedEnum.serializer)
      ..add(RegistrationEnvelope.serializer)
      ..add(RegistrationEnvelopeAllOfData.serializer)
      ..add(RegulatedMaterialRule.serializer)
      ..add(RegulatedMaterialRuleRequiredMarkingEnum.serializer)
      ..add(ReimbursementTimelineItem.serializer)
      ..add(ReimbursementTimelineItemStateEnum.serializer)
      ..add(RemittanceQueueEnvelope.serializer)
      ..add(RemittanceQueueRow.serializer)
      ..add(RequestDocumentExport202Response.serializer)
      ..add(ResendBotChallengeRequest.serializer)
      ..add(ResolveNotification200Response.serializer)
      ..add(ReviewDisplayOption.serializer)
      ..add(ReviewDisplayOptionChoiceEnum.serializer)
      ..add(ReviewFlagRequest.serializer)
      ..add(ReviewFlagRequestReasonCodeEnum.serializer)
      ..add(ReviewLine.serializer)
      ..add(ReviewListMeta.serializer)
      ..add(ReviewMediaLink.serializer)
      ..add(ReviewMediaLinkContentTypeEnum.serializer)
      ..add(ReviewModerationRequest.serializer)
      ..add(ReviewModerationRequestActionEnum.serializer)
      ..add(ReviewProduct.serializer)
      ..add(ReviewRatingBucket.serializer)
      ..add(ReviewRatings.serializer)
      ..add(ReviewRatingsSpeedKindEnum.serializer)
      ..add(ReviewReported.serializer)
      ..add(ReviewReportedEnvelope.serializer)
      ..add(ReviewResolveRequest.serializer)
      ..add(ReviewSummary.serializer)
      ..add(ReviewWindowRules.serializer)
      ..add(RevokeNotificationDevice200Response.serializer)
      ..add(RouteEstimate.serializer)
      ..add(RouteEstimateDurationBasisEnum.serializer)
      ..add(RouteEstimateEnvelope.serializer)
      ..add(RouteEstimateRequest.serializer)
      ..add(RouteEstimateRequestOriginSourceEnum.serializer)
      ..add(ScheduledTaskHealth.serializer)
      ..add(ScheduledTaskHealthStatusEnum.serializer)
      ..add(ScoreExclusionRequest.serializer)
      ..add(ScoreExclusionRequestReasonCodeEnum.serializer)
      ..add(ScoreHistoryPoint.serializer)
      ..add(ScoreLabel.serializer)
      ..add(ScoreLabelKindEnum.serializer)
      ..add(ScoreMetric.serializer)
      ..add(ScoreMetricKeyEnum.serializer)
      ..add(SiteInspection.serializer)
      ..add(SiteInspectionActions.serializer)
      ..add(SiteInspectionCreate.serializer)
      ..add(SiteInspectionCreateHeavyVehicleRestrictionEnum.serializer)
      ..add(SiteInspectionCreatedResponse.serializer)
      ..add(SiteInspectionCreatedResponseData.serializer)
      ..add(SiteInspectionDecision.serializer)
      ..add(SiteInspectionListResponse.serializer)
      ..add(SiteInspectionListResponseData.serializer)
      ..add(SiteInspectionListing.serializer)
      ..add(SiteInspectionSite.serializer)
      ..add(SiteInspectionStatusEnum.serializer)
      ..add(SiteInspectionVariant.serializer)
      ..add(SiteInspectionVersion.serializer)
      ..add(StaleListing.serializer)
      ..add(StatementApproveRequest.serializer)
      ..add(StatementPaymentRequest.serializer)
      ..add(StockConfirmationItem.serializer)
      ..add(StockConfirmationRequest.serializer)
      ..add(StockConfirmationSchedule.serializer)
      ..add(StockConfirmationScheduleStateEnum.serializer)
      ..add(StockLabel.serializer)
      ..add(StoreActivationBlocker.serializer)
      ..add(StoreActivationReadiness.serializer)
      ..add(StoreActivationReadinessStatusEnum.serializer)
      ..add(StoreHoursDay.serializer)
      ..add(StoreHoursDaySource_Enum.serializer)
      ..add(StoreHoursDayStatusEnum.serializer)
      ..add(StoreNextOpening.serializer)
      ..add(StoreOpenNow.serializer)
      ..add(StoreOpenNowBasisEnum.serializer)
      ..add(StoreOpenNowStatusEnum.serializer)
      ..add(StoreOperatingDay.serializer)
      ..add(StoreOperatingDayStatusEnum.serializer)
      ..add(StorePerformance.serializer)
      ..add(StorePerformanceEnvelope.serializer)
      ..add(SupplierOpenStatus.serializer)
      ..add(SupplierOpenStatusBasisEnum.serializer)
      ..add(SupplierOpenStatusStatusEnum.serializer)
      ..add(SupplierResult.serializer)
      ..add(SupplierServiceability.serializer)
      ..add(SupplierServiceabilityBasisEnum.serializer)
      ..add(SupplierServiceabilityDeliveryEnum.serializer)
      ..add(SupplierTier.serializer)
      ..add(SupportAccessEmail.serializer)
      ..add(SupportAccessExchange.serializer)
      ..add(SupportAccessResponse.serializer)
      ..add(SupportAccessResult.serializer)
      ..add(SupportAttachment.serializer)
      ..add(SupportCategory.serializer)
      ..add(SupportCommandResponse.serializer)
      ..add(SupportCommandResult.serializer)
      ..add(SupportEmailResponse.serializer)
      ..add(SupportEmailResult.serializer)
      ..add(SupportEntry.serializer)
      ..add(SupportEntryDetails.serializer)
      ..add(SupportEntryKindEnum.serializer)
      ..add(SupportEntryListResponse.serializer)
      ..add(SupportHandler.serializer)
      ..add(SupportHandlerListResponse.serializer)
      ..add(SupportPageMeta.serializer)
      ..add(SupportPortal.serializer)
      ..add(SupportReceipt.serializer)
      ..add(SupportReceiptResponse.serializer)
      ..add(SupportReferenceType.serializer)
      ..add(SupportReplyResponse.serializer)
      ..add(SupportStatus.serializer)
      ..add(SupportTicket.serializer)
      ..add(SupportTicketListResponse.serializer)
      ..add(SupportTicketResponse.serializer)
      ..add(SupportUpdate.serializer)
      ..add(SupportUserType.serializer)
      ..add(TaxAdjustment.serializer)
      ..add(TaxAdjustmentAllowedActionsEnum.serializer)
      ..add(TaxAdjustmentEnvelope.serializer)
      ..add(TaxAdjustmentListEnvelope.serializer)
      ..add(TaxAdjustmentOpenedByEnum.serializer)
      ..add(TaxAdjustmentPrepareRequest.serializer)
      ..add(TaxAdjustmentPrepareRequestCertificateImpactEnum.serializer)
      ..add(TaxAdjustmentReviewRequest.serializer)
      ..add(TaxAdjustmentReviewRequestDecisionEnum.serializer)
      ..add(TaxAdjustmentStateEnum.serializer)
      ..add(TaxCategory.serializer)
      ..add(TaxEvidenceQueueEnvelope.serializer)
      ..add(TaxEvidenceRow.serializer)
      ..add(TaxPackage.serializer)
      ..add(TaxPackageInput.serializer)
      ..add(TaxPackageInputFormEnum.serializer)
      ..add(TaxPackageInputWithholdingEntityEnum.serializer)
      ..add(TaxPackageReview.serializer)
      ..add(ThresholdStatusEvent.serializer)
      ..add(ThresholdStatusEventActorTypeEnum.serializer)
      ..add(ThresholdStatusEventFromStatusEnum.serializer)
      ..add(ThresholdStatusEventToStatusEnum.serializer)
      ..add(UserIdentity.serializer)
      ..add(VehicleIssueRequest.serializer)
      ..add(VehicleIssueRequestCategoryEnum.serializer)
      ..add(VendorActivationSnapshot.serializer)
      ..add(VendorAddressGeocode.serializer)
      ..add(VendorAddressGeocodeEnvelope.serializer)
      ..add(VendorAddressSelection.serializer)
      ..add(VendorAnalyticsPoint.serializer)
      ..add(VendorAnalyticsPointStatusEnum.serializer)
      ..add(VendorBotProtectionEvidence.serializer)
      ..add(VendorBuyerRatingRequest.serializer)
      ..add(VendorCancelRequest.serializer)
      ..add(VendorCancelRequestReasonCodeEnum.serializer)
      ..add(VendorCancellationPreview.serializer)
      ..add(VendorCancellationPreviewEnvelope.serializer)
      ..add(VendorCancellationRequestRef.serializer)
      ..add(VendorCommissionAcceptance.serializer)
      ..add(VendorCommissionAcceptanceAcceptedEnum.serializer)
      ..add(VendorCommissionAssessment.serializer)
      ..add(VendorCommissionAssessmentStateEnum.serializer)
      ..add(VendorCommissionMonitoring.serializer)
      ..add(VendorCommissionMonitoringEnvelope.serializer)
      ..add(VendorCommissionSummary.serializer)
      ..add(VendorCurrentCompetitors.serializer)
      ..add(VendorCurrentCompetitorsStatusEnum.serializer)
      ..add(VendorDashboardDisputes.serializer)
      ..add(VendorDashboardDisputesSeriesInner.serializer)
      ..add(VendorDashboardInsights.serializer)
      ..add(VendorDashboardInsightsAccess.serializer)
      ..add(VendorDashboardInsightsEnvelope.serializer)
      ..add(VendorDashboardInsightsPeriod.serializer)
      ..add(VendorDashboardInsightsTraffic.serializer)
      ..add(VendorDashboardInsightsTrafficStoreVisits.serializer)
      ..add(VendorDashboardOrders.serializer)
      ..add(VendorDashboardOrdersForecast.serializer)
      ..add(VendorDashboardOrdersFunnelInner.serializer)
      ..add(VendorDashboardOrdersFunnelInnerKeyEnum.serializer)
      ..add(VendorDashboardOrdersIncomingInner.serializer)
      ..add(VendorDashboardOrdersIncomingInnerFulfillmentMethodEnum.serializer)
      ..add(VendorDashboardOrdersIncomingInnerProcurementTypeEnum.serializer)
      ..add(VendorDashboardOrdersKpis.serializer)
      ..add(VendorDashboardOrdersKpisAverageOrderValueCentavos.serializer)
      ..add(VendorDashboardOrdersMix.serializer)
      ..add(VendorDashboardOrdersPipelineInner.serializer)
      ..add(VendorDashboardOrdersProducts.serializer)
      ..add(VendorDashboardOrdersProductsBasketRules.serializer)
      ..add(VendorDashboardOrdersProductsCategoriesInner.serializer)
      ..add(VendorDashboardOrdersProductsSegments.serializer)
      ..add(VendorDashboardOrdersProductsSegmentsPointsInner.serializer)
      ..add(VendorDashboardOrdersProductsSegmentsStateEnum.serializer)
      ..add(VendorDashboardOrdersUnusualDays.serializer)
      ..add(VendorDashboardOrdersUnusualDaysDaysInner.serializer)
      ..add(VendorDashboardOrdersUnusualDaysStateEnum.serializer)
      ..add(VendorDashboardPerformance.serializer)
      ..add(VendorDashboardProduct.serializer)
      ..add(VendorDashboardSegment.serializer)
      ..add(VendorDashboardSeriesPoint.serializer)
      ..add(VendorDashboardStock.serializer)
      ..add(VendorDashboardStockAttentionInner.serializer)
      ..add(VendorDashboardStockAttentionInnerStatusEnum.serializer)
      ..add(VendorDeliverySetup.serializer)
      ..add(VendorDeliverySetupFulfillmentMethodEnum.serializer)
      ..add(VendorDocument.serializer)
      ..add(VendorDocumentEnvelope.serializer)
      ..add(VendorDocumentScanStateEnum.serializer)
      ..add(VendorDocumentStatusEnum.serializer)
      ..add(VendorEarnings.serializer)
      ..add(VendorEarningsBreakdown.serializer)
      ..add(VendorEarningsBreakdownOnline.serializer)
      ..add(VendorEarningsBreakdownPhysical.serializer)
      ..add(VendorEarningsBreakdownSales.serializer)
      ..add(VendorEarningsEnvelope.serializer)
      ..add(VendorEarningsProduct.serializer)
      ..add(VendorEarningsProducts.serializer)
      ..add(VendorEarningsTrend.serializer)
      ..add(VendorEarningsTrendChange.serializer)
      ..add(VendorEarningsTrendComparison.serializer)
      ..add(VendorEarningsTrendFigures.serializer)
      ..add(VendorEarningsTrendGranularityEnum.serializer)
      ..add(VendorEarningsTrendPoint.serializer)
      ..add(VendorFile.serializer)
      ..add(VendorFileEnvelope.serializer)
      ..add(VendorFinanceNotice.serializer)
      ..add(VendorFinanceOverview.serializer)
      ..add(VendorFinanceOverviewEnvelope.serializer)
      ..add(VendorFinanceReviews.serializer)
      ..add(VendorFinanceReviewsEnvelope.serializer)
      ..add(VendorFinanceReviewsOpenReviewsInner.serializer)
      ..add(VendorInvitation.serializer)
      ..add(VendorInvitationAcceptance.serializer)
      ..add(VendorInvitationEnvelope.serializer)
      ..add(VendorInvitationRequest.serializer)
      ..add(VendorInvitationRequestRoleEnum.serializer)
      ..add(VendorInvoiceBillingDetails.serializer)
      ..add(VendorMaterialsAnalyticsDetail.serializer)
      ..add(VendorMaterialsAnalyticsDetailAudienceEnum.serializer)
      ..add(VendorMaterialsAnalyticsDetailEnvelope.serializer)
      ..add(VendorMaterialsAnalyticsDetailGroup.serializer)
      ..add(VendorMaterialsAnalyticsDetailSourceKindEnum.serializer)
      ..add(VendorMaterialsAnalyticsList.serializer)
      ..add(VendorMaterialsAnalyticsListAudienceEnum.serializer)
      ..add(VendorMaterialsAnalyticsListEnvelope.serializer)
      ..add(VendorMaterialsAnalyticsListSourceKindEnum.serializer)
      ..add(VendorMediaEnvelope.serializer)
      ..add(VendorNavigationUpdates.serializer)
      ..add(VendorOnboardingEnvelope.serializer)
      ..add(VendorOnboardingSection.serializer)
      ..add(VendorOnboardingSnapshot.serializer)
      ..add(VendorOnboardingSnapshotSetup.serializer)
      ..add(VendorOnboardingSnapshotSetupVacationStatusEnum.serializer)
      ..add(VendorOnboardingStep.serializer)
      ..add(VendorOnboardingStepLevelEnum.serializer)
      ..add(VendorOnboardingStepProgressStatusEnum.serializer)
      ..add(VendorOnboardingStepStatusEnum.serializer)
      ..add(VendorOrderConfirmRequest.serializer)
      ..add(VendorOrderDeclineReason.serializer)
      ..add(VendorOrderDeclineRequest.serializer)
      ..add(VendorOrderInvoices.serializer)
      ..add(VendorOrderInvoicesEnvelope.serializer)
      ..add(VendorOrderInvoicesInvoiceTypesEnum.serializer)
      ..add(VendorOrderInvoicesInvoicingMethodsEnum.serializer)
      ..add(VendorOrderInvoicesSourceSystemsEnum.serializer)
      ..add(VendorOrderInvoicesStatusEnum.serializer)
      ..add(VendorOrderPermissions.serializer)
      ..add(VendorOrderPrimaryAction.serializer)
      ..add(VendorOrderReviews.serializer)
      ..add(VendorOrderReviewsEnvelope.serializer)
      ..add(VendorOrderReviewsPartyEnum.serializer)
      ..add(VendorOrderReviewsRevealReasonEnum.serializer)
      ..add(VendorOrderReviewsStateEnum.serializer)
      ..add(VendorOwnOffer.serializer)
      ..add(VendorPaymentOnboarding.serializer)
      ..add(VendorPaymentOnboardingEnvelope.serializer)
      ..add(VendorPaymentOnboardingEnvironmentEnum.serializer)
      ..add(VendorPaymentOnboardingStatusEnum.serializer)
      ..add(VendorPaymentReconciliationEnvelope.serializer)
      ..add(VendorProductAnalytics.serializer)
      ..add(VendorProductAnalyticsAccess.serializer)
      ..add(VendorProductAnalyticsBasketRules.serializer)
      ..add(VendorProductAnalyticsCategoriesInner.serializer)
      ..add(VendorProductAnalyticsDetail.serializer)
      ..add(VendorProductAnalyticsDetailEnvelope.serializer)
      ..add(VendorProductAnalyticsDetailKpis.serializer)
      ..add(VendorProductAnalyticsDetailUnusualDays.serializer)
      ..add(VendorProductAnalyticsDetailUnusualDaysDaysInner.serializer)
      ..add(VendorProductAnalyticsDetailUnusualDaysStateEnum.serializer)
      ..add(VendorProductAnalyticsEnvelope.serializer)
      ..add(VendorProductAnalyticsForecast.serializer)
      ..add(VendorProductAnalyticsKpis.serializer)
      ..add(VendorProductAnalyticsKpisProductsViewed.serializer)
      ..add(VendorProductAnalyticsProducts.serializer)
      ..add(VendorProductAnalyticsProductsMeta.serializer)
      ..add(VendorProductAnalyticsProductsMetaSortEnum.serializer)
      ..add(VendorProductAnalyticsSummaries.serializer)
      ..add(VendorProductAnalyticsSummariesEnvelope.serializer)
      ..add(VendorProductAnalyticsSummariesItemsInner.serializer)
      ..add(VendorRestriction.serializer)
      ..add(VendorRestrictionEnvelope.serializer)
      ..add(VendorReviewEditRequest.serializer)
      ..add(VendorReviewEnvelope.serializer)
      ..add(VendorReviewListEnvelope.serializer)
      ..add(VendorReviewListMeta.serializer)
      ..add(VendorReviewRow.serializer)
      ..add(VendorReviewRowTypeEnum.serializer)
      ..add(VendorReviewRowVisibilityEnum.serializer)
      ..add(VendorSetupComplete.serializer)
      ..add(VendorSetupDraft.serializer)
      ..add(VendorSetupDraftDelivery.serializer)
      ..add(VendorSetupDraftFulfillmentMethodEnum.serializer)
      ..add(VendorSetupDraftVehiclesInner.serializer)
      ..add(VendorSetupDraftVehiclesInnerMobilizationBasisEnum.serializer)
      ..add(VendorSetupDraftVehiclesInnerVehicleCategoryEnum.serializer)
      ..add(VendorStaffDisputeSetting.serializer)
      ..add(VendorStaffUpdate.serializer)
      ..add(VendorStaffUpdateRoleEnum.serializer)
      ..add(VendorStoreEmailConfirmation.serializer)
      ..add(VendorStoreEmailEnvelope.serializer)
      ..add(VendorTeamActivity.serializer)
      ..add(VendorTeamActivityCategoryEnum.serializer)
      ..add(VendorTeamActivityEnvelope.serializer)
      ..add(VendorTeamActivityEnvelopeMeta.serializer)
      ..add(VendorTeamActivityEnvelopeMetaCategoriesInner.serializer)
      ..add(
          VendorTeamActivityEnvelopeMetaCategoriesInnerCategoryEnum.serializer)
      ..add(VendorTeamConfirmationPerformance.serializer)
      ..add(VendorTeamDeletion.serializer)
      ..add(VendorTeamDisputePerformance.serializer)
      ..add(VendorTeamFulfillmentPerformance.serializer)
      ..add(VendorTeamInventoryPerformance.serializer)
      ..add(VendorTeamInvitationListEnvelope.serializer)
      ..add(VendorTeamInvitationListEnvelopeMeta.serializer)
      ..add(VendorTeamInvitationRecord.serializer)
      ..add(VendorTeamInvitationRecordStatusEnum.serializer)
      ..add(VendorTeamPerformance.serializer)
      ..add(VendorTeamPerformanceActivity.serializer)
      ..add(VendorTeamPerformanceEnvelope.serializer)
      ..add(VendorTeamPerformanceRoleEnum.serializer)
      ..add(VendorTeamPerformanceTimezoneEnum.serializer)
      ..add(VendorTeamPerformanceTrend.serializer)
      ..add(VendorTeamPerformanceTrendGranularityEnum.serializer)
      ..add(VendorTeamPerformanceTrendMetricEnum.serializer)
      ..add(VendorTeamPerformanceTrendPointsInner.serializer)
      ..add(VendorTeamQuotationPerformance.serializer)
      ..add(VendorTeamReplyTime.serializer)
      ..add(VendorTeamSalesPerformance.serializer)
      ..add(VendorTinReveal.serializer)
      ..add(VendorTinRevealEnvelope.serializer)
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
      ..add(VendorWorkstreams.serializer)
      ..add(VendorWorkstreamsActivation.serializer)
      ..add(VendorWorkstreamsDiscoverability.serializer)
      ..add(VendorWorkstreamsProviderReadiness.serializer)
      ..add(VendorWorkstreamsVerification.serializer)
      ..add(VerifiedVendorSummary.serializer)
      ..add(VerifyBotChallengeRequest.serializer)
      ..add(VerifyEmailRequest.serializer)
      ..add(VerifyWebPasswordRecoveryRequest.serializer)
      ..add(VolumeTier.serializer)
      ..add(WebPasswordRecoveryEnvelope.serializer)
      ..add(WebPasswordRecoveryEnvelopeAllOfData.serializer)
      ..add(WebPasswordRecoveryPortal.serializer)
      ..add(WebResendBotChallengeRequest.serializer)
      ..add(WebResendBotChallengeRequestPortalEnum.serializer)
      ..add(WebVerifyBotChallengeRequest.serializer)
      ..add(WebVerifyBotChallengeRequestPortalEnum.serializer)
      ..add(WithholdingAccumulatorDetail.serializer)
      ..add(WithholdingAccumulatorDetailEnvelope.serializer)
      ..add(WithholdingAccumulatorDetailStatusEnum.serializer)
      ..add(WithholdingAccumulatorListEnvelope.serializer)
      ..add(WithholdingAccumulatorView.serializer)
      ..add(WithholdingAccumulatorViewStatusEnum.serializer)
      ..add(WithholdingThresholdCalculation.serializer)
      ..add(WithholdingThresholdPanel.serializer)
      ..add(WithholdingThresholdPanelExternalOverlapStateEnum.serializer)
      ..add(WithholdingThresholdPanelStatusEnum.serializer)
      ..add(WorkPackageAlternative.serializer)
      ..add(WorkPackageAlternativeAvailabilityEnum.serializer)
      ..add(WorkPackageAlternativeFulfillmentMethodsEnum.serializer)
      ..add(WorkPackageAlternativePage.serializer)
      ..add(WorkPackageAlternativePageExcluded.serializer)
      ..add(WorkPackageAlternativePageRadiusKmEnum.serializer)
      ..add(WorkPackageAlternativePageResponse.serializer)
      ..add(WorkPackageAlternativePageStatusEnum.serializer)
      ..add(WorkPackageBudgetEstimate.serializer)
      ..add(WorkPackageBudgetEstimateBasisEnum.serializer)
      ..add(WorkPackageBudgetEstimateDeliveryStatusEnum.serializer)
      ..add(WorkPackageBudgetEstimateFulfillmentMethodEnum.serializer)
      ..add(WorkPackageBudgetEstimateLine.serializer)
      ..add(WorkPackageBudgetEstimateLineInput.serializer)
      ..add(WorkPackageBudgetEstimateLineStatusEnum.serializer)
      ..add(WorkPackageBudgetEstimateRequest.serializer)
      ..add(WorkPackageBudgetEstimateRequestFulfillmentMethodEnum.serializer)
      ..add(WorkPackageBudgetEstimateRequestHeavyVehicleRestrictionEnum
          .serializer)
      ..add(WorkPackageBudgetEstimateRequestRadiusKmEnum.serializer)
      ..add(WorkPackageBudgetEstimateResponse.serializer)
      ..add(WorkPackageInput.serializer)
      ..add(WorkPackageInputFulfillmentMethodEnum.serializer)
      ..add(WorkPackageInputHeavyVehicleRestrictionEnum.serializer)
      ..add(WorkPackageInputPaymentMethodEnum.serializer)
      ..add(WorkPackageInputRadiusKmEnum.serializer)
      ..add(WorkPackageLineInput.serializer)
      ..add(WorkPackagePage.serializer)
      ..add(WorkPackageSummary.serializer)
      ..add(WorkPackageSummaryStatusEnum.serializer)
      ..add(WorkPackageVersion.serializer)
      ..add(WorkPackageView.serializer)
      ..add(WorkPackageViewProjectStatusEnum.serializer)
      ..add(WorkPackageViewResponse.serializer)
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
          const FullType(BuiltList, const [const FullType(ActivationBlocker)]),
          () => ListBuilder<ActivationBlocker>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(ActivationRestrictionsCategoriesEnum)]),
          () => ListBuilder<ActivationRestrictionsCategoriesEnum>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(AdminCancellationRequestRow)]),
          () => ListBuilder<AdminCancellationRequestRow>())
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
              const [const FullType(AdminDashboardCategoriesDemandInner)]),
          () => ListBuilder<AdminDashboardCategoriesDemandInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DashboardRule)]),
          () => ListBuilder<DashboardRule>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(AdminDashboardSeriesPoint)]),
          () => ListBuilder<AdminDashboardSeriesPoint>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(AdminDashboardActivityPoint)]),
          () => ListBuilder<AdminDashboardActivityPoint>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(AdminDashboardVendorHealthClassesInner)]),
          () => ListBuilder<AdminDashboardVendorHealthClassesInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(AdminDashboardVendorHealthAttentionInner)]),
          () => ListBuilder<AdminDashboardVendorHealthAttentionInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(AdminDisputeClarificationRequestPartiesEnum)
          ]),
          () => ListBuilder<AdminDisputeClarificationRequestPartiesEnum>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(AdminRefundRow)]),
          () => ListBuilder<AdminRefundRow>())
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
          const FullType(
              BuiltList, const [const FullType(AdminReimbursementRow)]),
          () => ListBuilder<AdminReimbursementRow>())
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
          const FullType(BuiltList, const [const FullType(AdminScoreRow)]),
          () => ListBuilder<AdminScoreRow>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ApiError)]),
          () => ListBuilder<ApiError>())
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
          const FullType(BuiltList, const [const FullType(AnalyticsRun)]),
          () => ListBuilder<AnalyticsRun>())
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
          const FullType(BuiltList, const [const FullType(AnalyticsSource)]),
          () => ListBuilder<AnalyticsSource>())
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
          const FullType(BuiltList, const [const FullType(AuditEvent)]),
          () => ListBuilder<AuditEvent>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ApiError)]),
          () => ListBuilder<ApiError>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(AutoAcceptPolicyVersion)]),
          () => ListBuilder<AutoAcceptPolicyVersion>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(AutoAcceptReason)]),
          () => ListBuilder<AutoAcceptReason>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(BadgeStateScopesInner)]),
          () => ListBuilder<BadgeStateScopesInner>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(BudgetOverrideRecord)]),
          () => ListBuilder<BudgetOverrideRecord>())
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
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(VendorFinanceReviewsOpenReviewsInner)]),
          () => ListBuilder<VendorFinanceReviewsOpenReviewsInner>())
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
          const FullType(BuiltList, const [const FullType(PaymentAttempt)]),
          () => ListBuilder<PaymentAttempt>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(PaymentChannelOption)]),
          () => ListBuilder<PaymentChannelOption>())
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
          const FullType(BuiltList, const [const FullType(ApiError)]),
          () => ListBuilder<ApiError>())
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
          const FullType(BuiltList, const [const FullType(ApiError)]),
          () => ListBuilder<ApiError>())
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
          const FullType(BuiltList, const [const FullType(ApiError)]),
          () => ListBuilder<ApiError>())
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
          const FullType(BuiltList, const [const FullType(BuyAgainAddedLine)]),
          () => ListBuilder<BuyAgainAddedLine>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(BuyAgainSkippedLine)]),
          () => ListBuilder<BuyAgainSkippedLine>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(BuyerAccountRetainedRecord)]),
          () => ListBuilder<BuyerAccountRetainedRecord>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(BuyerAnalyticsPoint)]),
          () => ListBuilder<BuyerAnalyticsPoint>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(BuyerLocation)]),
          () => ListBuilder<BuyerLocation>())
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
            const FullType(BuyerReviewSubmitRequestProductReviewsInner)
          ]),
          () => ListBuilder<BuyerReviewSubmitRequestProductReviewsInner>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(CancellationPlanPayment)]),
          () => ListBuilder<CancellationPlanPayment>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(CancellationPlanExcludesEnum)]),
          () => ListBuilder<CancellationPlanExcludesEnum>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(CartIssue)]),
          () => ListBuilder<CartIssue>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(CartIssue)]),
          () => ListBuilder<CartIssue>())
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
          const FullType(BuiltList, const [const FullType(CartVendorGroup)]),
          () => ListBuilder<CartVendorGroup>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(CartLine)]),
          () => ListBuilder<CartLine>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(CartVendorGroupFulfillmentOptionsEnum)]),
          () => ListBuilder<CartVendorGroupFulfillmentOptionsEnum>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(CartLine)]),
          () => ListBuilder<CartLine>())
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
          const FullType(BuiltList, const [const FullType(ChannelFeeVersion)]),
          () => ListBuilder<ChannelFeeVersion>())
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
          const FullType(BuiltList, const [const FullType(ChatAttachment)]),
          () => ListBuilder<ChatAttachment>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ChatDraftLine)]),
          () => ListBuilder<ChatDraftLine>())
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
          const FullType(BuiltList, const [const FullType(ChatHandler)]),
          () => ListBuilder<ChatHandler>())
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
          const FullType(BuiltList, const [const FullType(ChatMessage)]),
          () => ListBuilder<ChatMessage>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ChatProduct)]),
          () => ListBuilder<ChatProduct>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ChatQuotationLine)]),
          () => ListBuilder<ChatQuotationLine>())
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
              BuiltList, const [const FullType(ChatQuotationChange)]),
          () => ListBuilder<ChatQuotationChange>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ChatQuotationChange)]),
          () => ListBuilder<ChatQuotationChange>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ChatQuotationVersion)]),
          () => ListBuilder<ChatQuotationVersion>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(CheckoutChildOrder)]),
          () => ListBuilder<CheckoutChildOrder>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(CheckoutGroupPreview)]),
          () => ListBuilder<CheckoutGroupPreview>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(CheckoutGroupPreviewFulfillmentOptionsEnum)
          ]),
          () => ListBuilder<CheckoutGroupPreviewFulfillmentOptionsEnum>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(CartIssue)]),
          () => ListBuilder<CartIssue>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(CartLine)]),
          () => ListBuilder<CartLine>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(PaymentMethodEligibility)]),
          () => ListBuilder<PaymentMethodEligibility>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(CommissionPolicy)]),
          () => ListBuilder<CommissionPolicy>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(ComparableSpecificationAttributesInner)]),
          () => ListBuilder<ComparableSpecificationAttributesInner>())
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
          const FullType(BuiltList, const [const FullType(ConversationView)]),
          () => ListBuilder<ConversationView>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DashboardCount)]),
          () => ListBuilder<DashboardCount>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DashboardCount)]),
          () => ListBuilder<DashboardCount>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DashboardCount)]),
          () => ListBuilder<DashboardCount>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DashboardForecastPoint)]),
          () => ListBuilder<DashboardForecastPoint>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DashboardAnomaly)]),
          () => ListBuilder<DashboardAnomaly>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DashboardRule)]),
          () => ListBuilder<DashboardRule>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DashboardRule)]),
          () => ListBuilder<DashboardRule>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DeliveryEstimateOption)]),
          () => ListBuilder<DeliveryEstimateOption>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DeliveryEstimateOption)]),
          () => ListBuilder<DeliveryEstimateOption>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DeliveryEstimateOption)]),
          () => ListBuilder<DeliveryEstimateOption>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(OrderDeliveryVehicle)]),
          () => ListBuilder<OrderDeliveryVehicle>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DeliveryFailure)]),
          () => ListBuilder<DeliveryFailure>())
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
          const FullType(BuiltList, const [const FullType(DeliveryPlanGroup)]),
          () => ListBuilder<DeliveryPlanGroup>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DeliveryPlanVehicle)]),
          () => ListBuilder<DeliveryPlanVehicle>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DeliveryVehicleOption)]),
          () => ListBuilder<DeliveryVehicleOption>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DeliveryVehicleSelection)]),
          () => ListBuilder<DeliveryVehicleSelection>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(DirectoryBuyerProfileRecentOrdersInner)]),
          () => ListBuilder<DirectoryBuyerProfileRecentOrdersInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DirectorySanction)]),
          () => ListBuilder<DirectorySanction>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DirectoryBuyerRow)]),
          () => ListBuilder<DirectoryBuyerRow>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ApiError)]),
          () => ListBuilder<ApiError>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DirectoryListing)]),
          () => ListBuilder<DirectoryListing>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ApiError)]),
          () => ListBuilder<ApiError>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DirectoryReview)]),
          () => ListBuilder<DirectoryReview>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ApiError)]),
          () => ListBuilder<ApiError>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DirectorySanction)]),
          () => ListBuilder<DirectorySanction>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DirectoryVendorRow)]),
          () => ListBuilder<DirectoryVendorRow>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ApiError)]),
          () => ListBuilder<ApiError>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(DisputeAdminContextOutcomesEnum)]),
          () => ListBuilder<DisputeAdminContextOutcomesEnum>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(DisputeAdminContextSanctionsEnum)]),
          () => ListBuilder<DisputeAdminContextSanctionsEnum>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(DisputeAdminContextMetricEventsEnum)]),
          () => ListBuilder<DisputeAdminContextMetricEventsEnum>())
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
          const FullType(BuiltList, const [const FullType(DisputeDecision)]),
          () => ListBuilder<DisputeDecision>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DisputeAffectedLine)]),
          () => ListBuilder<DisputeAffectedLine>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DisputeDeadline)]),
          () => ListBuilder<DisputeDeadline>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DisputeTimelineEntry)]),
          () => ListBuilder<DisputeTimelineEntry>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DisputeProposal)]),
          () => ListBuilder<DisputeProposal>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DisputeClarification)]),
          () => ListBuilder<DisputeClarification>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DisputeRemedy)]),
          () => ListBuilder<DisputeRemedy>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(RefundTimelineItem)]),
          () => ListBuilder<RefundTimelineItem>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ReimbursementTimelineItem)]),
          () => ListBuilder<ReimbursementTimelineItem>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(DisputeDetailAvailableActionsEnum)]),
          () => ListBuilder<DisputeDetailAvailableActionsEnum>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(DisputeEligibilityIssueTypesEnum)]),
          () => ListBuilder<DisputeEligibilityIssueTypesEnum>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(DisputeEligibilityRequestedRemediesEnum)]),
          () => ListBuilder<DisputeEligibilityRequestedRemediesEnum>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DisputeAffectedLine)]),
          () => ListBuilder<DisputeAffectedLine>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DisputeExport)]),
          () => ListBuilder<DisputeExport>())
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
          const FullType(BuiltList, const [const FullType(DisputeSummary)]),
          () => ListBuilder<DisputeSummary>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ApiError)]),
          () => ListBuilder<ApiError>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DocumentExport)]),
          () => ListBuilder<DocumentExport>())
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
              const [const FullType(EnforcementDetailAllowedActionsEnum)]),
          () => ListBuilder<EnforcementDetailAllowedActionsEnum>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(EnforcementEvent)]),
          () => ListBuilder<EnforcementEvent>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(EnforcementSubjectMatch)]),
          () => ListBuilder<EnforcementSubjectMatch>())
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
          const FullType(BuiltList, const [const FullType(EnforcementSummary)]),
          () => ListBuilder<EnforcementSummary>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(EnforcementSummary)]),
          () => ListBuilder<EnforcementSummary>())
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
          const FullType(
              BuiltList, const [const FullType(ExploreCategoryCount)]),
          () => ListBuilder<ExploreCategoryCount>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(FavoriteSupplier)]),
          () => ListBuilder<FavoriteSupplier>())
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
          const FullType(BuiltList, const [const FullType(FinanceKpi)]),
          () => ListBuilder<FinanceKpi>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(FinanceKpi)]),
          () => ListBuilder<FinanceKpi>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(int)]),
          () => MapBuilder<String, int>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(FinancePaymentMethod)]),
          () => ListBuilder<FinancePaymentMethod>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(CommissionTrendPoint)]),
          () => ListBuilder<CommissionTrendPoint>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(FinanceReviewItem)]),
          () => ListBuilder<FinanceReviewItem>())
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
          const FullType(
              BuiltList, const [const FullType(FinancialPreviewLine)]),
          () => ListBuilder<FinancialPreviewLine>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(FinancialPreviewExcludesEnum)]),
          () => ListBuilder<FinancialPreviewExcludesEnum>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(FixedSetting)]),
          () => ListBuilder<FixedSetting>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(FleetVehicle)]),
          () => ListBuilder<FleetVehicle>())
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
              const [const FullType(FleetVehicleEligibilityReasonsEnum)]),
          () => ListBuilder<FleetVehicleEligibilityReasonsEnum>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(FleetVehicleInput)]),
          () => ListBuilder<FleetVehicleInput>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(FulfillmentArrangementVehicle)]),
          () => ListBuilder<FulfillmentArrangementVehicle>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(FulfillmentAssignee)]),
          () => ListBuilder<FulfillmentAssignee>())
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
              const [const FullType(FulfillmentConversationSummary)]),
          () => ListBuilder<FulfillmentConversationSummary>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(FulfillmentStep)]),
          () => ListBuilder<FulfillmentStep>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(FulfillmentTrip)]),
          () => ListBuilder<FulfillmentTrip>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(FulfillmentVehicleIssue)]),
          () => ListBuilder<FulfillmentVehicleIssue>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DeliveryAssignmentHistory)]),
          () => ListBuilder<DeliveryAssignmentHistory>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(FulfillmentStepProofRequirementsEnum)]),
          () => ListBuilder<FulfillmentStepProofRequirementsEnum>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(GeoBreadcrumb)]),
          () => ListBuilder<GeoBreadcrumb>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(GeoDemandCell)]),
          () => ListBuilder<GeoDemandCell>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(GeoDemandColumnsInner)]),
          () => ListBuilder<GeoDemandColumnsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(GeoDemandRowsInner)]),
          () => ListBuilder<GeoDemandRowsInner>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(GoogleContentAuthor)]),
          () => ListBuilder<GoogleContentAuthor>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(GooglePlacePhoto)]),
          () => ListBuilder<GooglePlacePhoto>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(GoogleContentAuthor)]),
          () => ListBuilder<GoogleContentAuthor>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(GooglePlacePhoto)]),
          () => ListBuilder<GooglePlacePhoto>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(GooglePlaceReview)]),
          () => ListBuilder<GooglePlaceReview>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(GooglePlaceAttribute)]),
          () => ListBuilder<GooglePlaceAttribute>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(GoogleContentAuthor)]),
          () => ListBuilder<GoogleContentAuthor>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(DirectorySupplierDetailActionsEnum)]),
          () => ListBuilder<DirectorySupplierDetailActionsEnum>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(InventoryMovement)]),
          () => ListBuilder<InventoryMovement>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(InventoryRow)]),
          () => ListBuilder<InventoryRow>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(InventoryRow)]),
          () => ListBuilder<InventoryRow>())
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
          const FullType(BuiltList, const [const FullType(InvoiceLogRow)]),
          () => ListBuilder<InvoiceLogRow>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ApiError)]),
          () => ListBuilder<ApiError>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(InvoiceRecordView)]),
          () => ListBuilder<InvoiceRecordView>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(InvoiceRequestView)]),
          () => ListBuilder<InvoiceRequestView>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(PlatformDocumentRef)]),
          () => ListBuilder<PlatformDocumentRef>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(InvoiceRecordView)]),
          () => ListBuilder<InvoiceRecordView>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(InvoiceRequestView)]),
          () => ListBuilder<InvoiceRequestView>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(PlatformDocumentRef)]),
          () => ListBuilder<PlatformDocumentRef>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(VendorOrderInvoicesInvoiceTypesEnum)]),
          () => ListBuilder<VendorOrderInvoicesInvoiceTypesEnum>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(VendorOrderInvoicesSourceSystemsEnum)]),
          () => ListBuilder<VendorOrderInvoicesSourceSystemsEnum>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(VendorOrderInvoicesInvoicingMethodsEnum)]),
          () => ListBuilder<VendorOrderInvoicesInvoicingMethodsEnum>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(InvoiceOrderLine)]),
          () => ListBuilder<InvoiceOrderLine>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ListingSearchResult)]),
          () => ListBuilder<ListingSearchResult>())
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
              BuiltList, const [const FullType(ListingSearchResultBadgesEnum)]),
          () => ListBuilder<ListingSearchResultBadgesEnum>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(LocationSuggestion)]),
          () => ListBuilder<LocationSuggestion>())
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
          const FullType(BuiltList, const [const FullType(MaterialOffer)]),
          () => ListBuilder<MaterialOffer>())
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
          const FullType(BuiltList, const [const FullType(ModerationQueueRow)]),
          () => ListBuilder<ModerationQueueRow>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ApiError)]),
          () => ListBuilder<ApiError>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(MoneyBreakdownExcludesEnum)]),
          () => ListBuilder<MoneyBreakdownExcludesEnum>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(NotificationItem)]),
          () => ListBuilder<NotificationItem>())
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
              BuiltList, const [const FullType(NotificationPreference)]),
          () => ListBuilder<NotificationPreference>())
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
          const FullType(BuiltList, const [const FullType(NrpcAffectedLine)]),
          () => ListBuilder<NrpcAffectedLine>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(NrpcLineAllocation)]),
          () => ListBuilder<NrpcLineAllocation>())
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
          const FullType(BuiltList, const [const FullType(OperationFailure)]),
          () => ListBuilder<OperationFailure>())
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
          const FullType(
              BuiltList, const [const FullType(OperationRetryRecord)]),
          () => ListBuilder<OperationRetryRecord>())
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
          const FullType(BuiltList, const [const FullType(OperationsQueue)]),
          () => ListBuilder<OperationsQueue>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(OrderDetail)]),
          () => ListBuilder<OrderDetail>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ApiError)]),
          () => ListBuilder<ApiError>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(OrderLineQuantity)]),
          () => ListBuilder<OrderLineQuantity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(OrderLineQuantity)]),
          () => ListBuilder<OrderLineQuantity>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(OrderStateRow)]),
          () => ListBuilder<OrderStateRow>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(OrderSummaryCardActionsEnum)]),
          () => ListBuilder<OrderSummaryCardActionsEnum>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(OrderSummary)]),
          () => ListBuilder<OrderSummary>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(OrderVolumeTier)]),
          () => ListBuilder<OrderVolumeTier>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(PaymentAttempt)]),
          () => ListBuilder<PaymentAttempt>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(PhysicalPaymentRecord)]),
          () => ListBuilder<PhysicalPaymentRecord>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(PlatformSetting)]),
          () => ListBuilder<PlatformSetting>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ApiError)]),
          () => ListBuilder<ApiError>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(PlatformSettingVersion)]),
          () => ListBuilder<PlatformSettingVersion>())
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
          const FullType(BuiltList, const [const FullType(PriceHistoryEntry)]),
          () => ListBuilder<PriceHistoryEntry>())
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
              BuiltList, const [const FullType(ProductAnalyticsRow)]),
          () => ListBuilder<ProductAnalyticsRow>())
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
          const FullType(BuiltList, const [const FullType(ProjectArrangement)]),
          () => ListBuilder<ProjectArrangement>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(ProjectArrangementSubmitPaymentsInner)]),
          () => ListBuilder<ProjectArrangementSubmitPaymentsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ProjectCandidate)]),
          () => ListBuilder<ProjectCandidate>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ProjectFulfillmentLine)]),
          () => ListBuilder<ProjectFulfillmentLine>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ProjectSeparatePurchase)]),
          () => ListBuilder<ProjectSeparatePurchase>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ProjectMaterial)]),
          () => ListBuilder<ProjectMaterial>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ProjectMaterialUnit)]),
          () => ListBuilder<ProjectMaterialUnit>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ProjectMaterialUnit)]),
          () => ListBuilder<ProjectMaterialUnit>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ProjectMaterialAttribute)]),
          () => ListBuilder<ProjectMaterialAttribute>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ProjectSeparatePurchase)]),
          () => ListBuilder<ProjectSeparatePurchase>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(ProjectDraftVendorGroupFulfillmentOptionsEnum)
          ]),
          () => ListBuilder<ProjectDraftVendorGroupFulfillmentOptionsEnum>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ProjectPaymentMethod)]),
          () => ListBuilder<ProjectPaymentMethod>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ProjectSite)]),
          () => ListBuilder<ProjectSite>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ProjectSpecificationDetail)]),
          () => ListBuilder<ProjectSpecificationDetail>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(WorkPackageAlternativeFulfillmentMethodsEnum)
          ]),
          () => ListBuilder<WorkPackageAlternativeFulfillmentMethodsEnum>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ProjectSpecificationSelection)]),
          () => ListBuilder<ProjectSpecificationSelection>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ProjectSpecificationSelection)]),
          () => ListBuilder<ProjectSpecificationSelection>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ProjectSpecificationSelection)]),
          () => ListBuilder<ProjectSpecificationSelection>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ProjectSpecificationSelection)]),
          () => ListBuilder<ProjectSpecificationSelection>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ProjectSummary)]),
          () => ListBuilder<ProjectSummary>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(PsgcArea)]),
          () => ListBuilder<PsgcArea>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(PsgcAreaOption)]),
          () => ListBuilder<PsgcAreaOption>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(PublicBadge)]),
          () => ListBuilder<PublicBadge>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(PublicBadge)]),
          () => ListBuilder<PublicBadge>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(PublicBadge)]),
          () => ListBuilder<PublicBadge>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(PublicReview)]),
          () => ListBuilder<PublicReview>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(PublicReview)]),
          () => ListBuilder<PublicReview>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ApiError)]),
          () => ListBuilder<ApiError>())
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
          const FullType(BuiltList, const [const FullType(RankingComponent)]),
          () => ListBuilder<RankingComponent>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(RefundTimelineItem)]),
          () => ListBuilder<RefundTimelineItem>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ReimbursementTimelineItem)]),
          () => ListBuilder<ReimbursementTimelineItem>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(RemittanceQueueRow)]),
          () => ListBuilder<RemittanceQueueRow>())
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
          const FullType(
              BuiltList, const [const FullType(ReviewDisplayOption)]),
          () => ListBuilder<ReviewDisplayOption>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ReviewLine)]),
          () => ListBuilder<ReviewLine>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ReviewMediaLink)]),
          () => ListBuilder<ReviewMediaLink>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ReviewMediaLink)]),
          () => ListBuilder<ReviewMediaLink>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ReviewMediaLink)]),
          () => ListBuilder<ReviewMediaLink>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ReviewRatingBucket)]),
          () => ListBuilder<ReviewRatingBucket>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ScoreMetric)]),
          () => ListBuilder<ScoreMetric>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(BadgeMetric)]),
          () => ListBuilder<BadgeMetric>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ScoreHistoryPoint)]),
          () => ListBuilder<ScoreHistoryPoint>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(BadgeState)]),
          () => ListBuilder<BadgeState>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ScoreMetric)]),
          () => ListBuilder<ScoreMetric>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(BadgeMetric)]),
          () => ListBuilder<BadgeMetric>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(BadgeState)]),
          () => ListBuilder<BadgeState>())
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
          const FullType(BuiltList, const [const FullType(ScoreHistoryPoint)]),
          () => ListBuilder<ScoreHistoryPoint>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ScoreMetric)]),
          () => ListBuilder<ScoreMetric>())
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
          const FullType(BuiltList, const [const FullType(BadgeMetric)]),
          () => ListBuilder<BadgeMetric>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ScoreHistoryPoint)]),
          () => ListBuilder<ScoreHistoryPoint>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(BadgeState)]),
          () => ListBuilder<BadgeState>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(SiteInspection)]),
          () => ListBuilder<SiteInspection>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(SiteInspection)]),
          () => ListBuilder<SiteInspection>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(StaleListing)]),
          () => ListBuilder<StaleListing>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(StockConfirmationItem)]),
          () => ListBuilder<StockConfirmationItem>())
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
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(StoreHoursDay)]),
          () => ListBuilder<StoreHoursDay>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(PublicBadge)]),
          () => ListBuilder<PublicBadge>())
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
              BuiltList, const [const FullType(AdminDashboardAreaSegment)]),
          () => ListBuilder<AdminDashboardAreaSegment>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(AdminDashboardAreasUnusualInner)]),
          () => ListBuilder<AdminDashboardAreasUnusualInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(AdminDashboardAreasRecruitmentInner)]),
          () => ListBuilder<AdminDashboardAreasRecruitmentInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(AdminDashboardAreasPointsInner)]),
          () => ListBuilder<AdminDashboardAreasPointsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(AdminDashboardVendorHealthSegmentsSegmentsInner)
          ]),
          () => ListBuilder<AdminDashboardVendorHealthSegmentsSegmentsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(CancellationRemedy)]),
          () => ListBuilder<CancellationRemedy>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DeliveryPlanVehicle)]),
          () => ListBuilder<DeliveryPlanVehicle>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DeliveryPlanVehicle)]),
          () => ListBuilder<DeliveryPlanVehicle>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DisputeSanctionInput)]),
          () => ListBuilder<DisputeSanctionInput>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DisputeSanctionInput)]),
          () => ListBuilder<DisputeSanctionInput>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(MaterialCategoryOption)]),
          () => ListBuilder<MaterialCategoryOption>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(BuyerIndustryClassification)]),
          () => ListBuilder<BuyerIndustryClassification>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(ProductAnalyticsSegmentsSegmentsInner)]),
          () => ListBuilder<ProductAnalyticsSegmentsSegmentsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(ProductAnalyticsSegmentsPointsInner)]),
          () => ListBuilder<ProductAnalyticsSegmentsPointsInner>())
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
          const FullType(
              BuiltList, const [const FullType(VendorDashboardSegment)]),
          () => ListBuilder<VendorDashboardSegment>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(VendorDashboardOrdersProductsSegmentsPointsInner)
          ]),
          () => ListBuilder<VendorDashboardOrdersProductsSegmentsPointsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(WorkPackageBudgetEstimateLine)]),
          () => ListBuilder<WorkPackageBudgetEstimateLine>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(DashboardClassificationBandsEnum)
          ]),
          () => MapBuilder<String, DashboardClassificationBandsEnum>())
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
          const FullType(BuiltList, const [const FullType(ApiError)]),
          () => ListBuilder<ApiError>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltSet, const [const FullType(String)]),
          () => SetBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(SupplierResult)]),
          () => ListBuilder<SupplierResult>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(SupportAttachment)]),
          () => ListBuilder<SupportAttachment>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(SupportEntry)]),
          () => ListBuilder<SupportEntry>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ApiError)]),
          () => ListBuilder<ApiError>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(SupportHandler)]),
          () => ListBuilder<SupportHandler>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ApiError)]),
          () => ListBuilder<ApiError>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(SupportTicket)]),
          () => ListBuilder<SupportTicket>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ApiError)]),
          () => ListBuilder<ApiError>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(TaxAdjustment)]),
          () => ListBuilder<TaxAdjustment>())
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
          const FullType(BuiltList, const [const FullType(TaxEvidenceRow)]),
          () => ListBuilder<TaxEvidenceRow>())
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
          const FullType(BuiltList, const [const FullType(TaxPackage)]),
          () => ListBuilder<TaxPackage>())
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
              BuiltList, const [const FullType(ThresholdStatusEvent)]),
          () => ListBuilder<ThresholdStatusEvent>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(VendorCommissionAssessment)]),
          () => ListBuilder<VendorCommissionAssessment>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(VendorDashboardDisputesSeriesInner)]),
          () => ListBuilder<VendorDashboardDisputesSeriesInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DashboardCount)]),
          () => ListBuilder<DashboardCount>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DashboardCount)]),
          () => ListBuilder<DashboardCount>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(VendorDashboardOrdersUnusualDaysDaysInner)
          ]),
          () => ListBuilder<VendorDashboardOrdersUnusualDaysDaysInner>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(VendorDashboardProduct)]),
          () => ListBuilder<VendorDashboardProduct>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(VendorDashboardOrdersProductsCategoriesInner)
          ]),
          () => ListBuilder<VendorDashboardOrdersProductsCategoriesInner>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(VendorDashboardSeriesPoint)]),
          () => ListBuilder<VendorDashboardSeriesPoint>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(VendorDashboardOrdersPipelineInner)]),
          () => ListBuilder<VendorDashboardOrdersPipelineInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(VendorDashboardOrdersIncomingInner)]),
          () => ListBuilder<VendorDashboardOrdersIncomingInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(VendorDashboardOrdersFunnelInner)]),
          () => ListBuilder<VendorDashboardOrdersFunnelInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(VendorDashboardStockAttentionInner)]),
          () => ListBuilder<VendorDashboardStockAttentionInner>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(VendorEarningsProduct)]),
          () => ListBuilder<VendorEarningsProduct>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(VendorEarningsTrendPoint)]),
          () => ListBuilder<VendorEarningsTrendPoint>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(VendorProductAnalyticsDetailUnusualDaysDaysInner)
          ]),
          () => ListBuilder<VendorProductAnalyticsDetailUnusualDaysDaysInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(VendorProductAnalyticsSummariesItemsInner)
          ]),
          () => ListBuilder<VendorProductAnalyticsSummariesItemsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(VendorReviewRow)]),
          () => ListBuilder<VendorReviewRow>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ApiError)]),
          () => ListBuilder<ApiError>())
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
          const FullType(BuiltList, const [
            const FullType(VendorTeamActivityEnvelopeMetaCategoriesInner)
          ]),
          () => ListBuilder<VendorTeamActivityEnvelopeMetaCategoriesInner>())
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
          const FullType(BuiltList,
              const [const FullType(VendorTeamPerformanceTrendPointsInner)]),
          () => ListBuilder<VendorTeamPerformanceTrendPointsInner>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(WithholdingAccumulatorView)]),
          () => ListBuilder<WithholdingAccumulatorView>())
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
              const [const FullType(WorkPackageBudgetEstimateLineInput)]),
          () => ListBuilder<WorkPackageBudgetEstimateLineInput>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(WorkPackageLineInput)]),
          () => ListBuilder<WorkPackageLineInput>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(WorkPackageLineInput)]),
          () => ListBuilder<WorkPackageLineInput>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(WorkPackageSummary)]),
          () => ListBuilder<WorkPackageSummary>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(int)]),
          () => ListBuilder<int>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(int)]),
          () => ListBuilder<int>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(int)]),
          () => ListBuilder<int>())
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
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => MapBuilder<String, String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DashboardAction)]),
          () => ListBuilder<DashboardAction>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => MapBuilder<String, String>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ProductAnalyticsSeriesPoint)]),
          () => ListBuilder<ProductAnalyticsSeriesPoint>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ProductAnalyticsRow)]),
          () => ListBuilder<ProductAnalyticsRow>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ProductAnalyticsRow)]),
          () => ListBuilder<ProductAnalyticsRow>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ProductAnalyticsRow)]),
          () => ListBuilder<ProductAnalyticsRow>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(VendorProductAnalyticsCategoriesInner)]),
          () => ListBuilder<VendorProductAnalyticsCategoriesInner>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ProductAnalyticsSuggestion)]),
          () => ListBuilder<ProductAnalyticsSuggestion>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => MapBuilder<String, String>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ProductAnalyticsSeriesPoint)]),
          () => ListBuilder<ProductAnalyticsSeriesPoint>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ProductAnalyticsSuggestion)]),
          () => ListBuilder<ProductAnalyticsSuggestion>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(int)]),
          () => MapBuilder<String, int>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(int)]),
          () => MapBuilder<String, int>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(int)]),
          () => MapBuilder<String, int>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(int)]),
          () => MapBuilder<String, int>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(int)]),
          () => MapBuilder<String, int>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(int)]),
          () => MapBuilder<String, int>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(int)]),
          () => MapBuilder<String, int>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(DirectoryReviewRatingsValue)
          ]),
          () => MapBuilder<String, DirectoryReviewRatingsValue?>())
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
          const FullType(BuiltList, const [const FullType(AdminAnalyticsRow)]),
          () => ListBuilder<AdminAnalyticsRow>())
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
          const FullType(BuiltList, const [
            const FullType(BuiltMap, const [
              const FullType(String),
              const FullType.nullable(JsonObject)
            ])
          ]),
          () => ListBuilder<BuiltMap<String, JsonObject?>>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => MapBuilder<String, String>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(ProjectCandidateFulfillmentOptionsEnum)]),
          () => ListBuilder<ProjectCandidateFulfillmentOptionsEnum>())
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
              BuiltList, const [const FullType(ProjectPaymentMethod)]),
          () => ListBuilder<ProjectPaymentMethod>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ProjectDraftVendorGroup)]),
          () => ListBuilder<ProjectDraftVendorGroup>())
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
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
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
              BuiltList, const [const FullType(BuyerAnalyticsCategorySummary)]),
          () => ListBuilder<BuyerAnalyticsCategorySummary>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(BuyerAnalyticsProductRow)]),
          () => ListBuilder<BuyerAnalyticsProductRow>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(BuyerAnalyticsProductVariant)]),
          () => ListBuilder<BuyerAnalyticsProductVariant>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(BuyerAnalyticsRow)]),
          () => ListBuilder<BuyerAnalyticsRow>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ComparableVariant)]),
          () => ListBuilder<ComparableVariant>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(AdminAnalyticsPoint)]),
          () => ListBuilder<AdminAnalyticsPoint>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ComparableVariant)]),
          () => ListBuilder<ComparableVariant>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(BuyerAnalyticsPoint)]),
          () => ListBuilder<BuyerAnalyticsPoint>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ComparableVariant)]),
          () => ListBuilder<ComparableVariant>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(VendorAnalyticsPoint)]),
          () => ListBuilder<VendorAnalyticsPoint>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DisputeEvidence)]),
          () => ListBuilder<DisputeEvidence>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(GeoFilterApplicability)]),
          () => ListBuilder<GeoFilterApplicability>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(GeoTrendPoint)]),
          () => ListBuilder<GeoTrendPoint>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(GeoActivityPoint)]),
          () => ListBuilder<GeoActivityPoint>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(GeoChild)]),
          () => ListBuilder<GeoChild>())
      ..addBuilderFactory(
          const FullType(
              BuiltMap, const [const FullType(String), const FullType(String)]),
          () => MapBuilder<String, String>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(IntegrationStatus)]),
          () => ListBuilder<IntegrationStatus>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ScheduledTaskHealth)]),
          () => ListBuilder<ScheduledTaskHealth>())
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
              BuiltList, const [const FullType(ListingAttributeLabel)]),
          () => ListBuilder<ListingAttributeLabel>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ListingImage)]),
          () => ListBuilder<ListingImage>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ListingVariantOffer)]),
          () => ListBuilder<ListingVariantOffer>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(OrderStateRow)]),
          () => ListBuilder<OrderStateRow>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(OrderChange)]),
          () => ListBuilder<OrderChange>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(OrderLine)]),
          () => ListBuilder<OrderLine>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(OrderTimelineEvent)]),
          () => ListBuilder<OrderTimelineEvent>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(OrderDetailAvailableActionsEnum)]),
          () => ListBuilder<OrderDetailAvailableActionsEnum>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(OrderReservation)]),
          () => ListBuilder<OrderReservation>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(VendorOrderDeclineReason)]),
          () => ListBuilder<VendorOrderDeclineReason>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(PaymentChannelOption)]),
          () => ListBuilder<PaymentChannelOption>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ProjectSpecificationDetail)]),
          () => ListBuilder<ProjectSpecificationDetail>())
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
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(VendorAnalyticsRow)]),
          () => ListBuilder<VendorAnalyticsRow>())
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
          const FullType(BuiltList, const [const FullType(VolumeTier)]),
          () => ListBuilder<VolumeTier>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(WorkPackageAlternative)]),
          () => ListBuilder<WorkPackageAlternative>())
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
          const FullType(BuiltList,
              const [const FullType(ModerationDetailAvailableActionsEnum)]),
          () => ListBuilder<ModerationDetailAvailableActionsEnum>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ReviewMediaLink)]),
          () => ListBuilder<ReviewMediaLink>())
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
          const FullType(BuiltList, const [const FullType(ExportAccessRecord)]),
          () => ListBuilder<ExportAccessRecord>())
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
          const FullType(BuiltList,
              const [const FullType(TaxAdjustmentAllowedActionsEnum)]),
          () => ListBuilder<TaxAdjustmentAllowedActionsEnum>())
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
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(VendorFinanceNotice)]),
          () => ListBuilder<VendorFinanceNotice>())
      ..addBuilderFactory(
          const FullType(BuiltSet, const [const FullType(String)]),
          () => SetBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltSet, const [const FullType(String)]),
          () => SetBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(CheckoutSubmitRequestPaymentMethodsEnum)
          ]),
          () => MapBuilder<String, CheckoutSubmitRequestPaymentMethodsEnum>())
      ..addBuilderFactory(
          const FullType(BuiltSet, const [
            const FullType(
                VendorVerificationDraftRepresentativeAuthorityScopesEnum)
          ]),
          () => SetBuilder<
              VendorVerificationDraftRepresentativeAuthorityScopesEnum>()))
    .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
