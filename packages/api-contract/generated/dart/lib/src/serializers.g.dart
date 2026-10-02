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
      ..add(AddressComponents.serializer)
      ..add(AdminDashboardAuditEnvelope.serializer)
      ..add(AdminDashboardEnvelope.serializer)
      ..add(AdminDashboardSummary.serializer)
      ..add(AdminInvitationRequest.serializer)
      ..add(AdminInvitationRequestPrivacyAcceptedEnum.serializer)
      ..add(AdminInvitationRequestTermsAcceptedEnum.serializer)
      ..add(AdminPaymentListEnvelope.serializer)
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
      ..add(BotProofEnvelope.serializer)
      ..add(BotProofEnvelopeAllOfData.serializer)
      ..add(BotProofEnvelopeAllOfDataVerifiedEnum.serializer)
      ..add(BotStepUpErrorEnvelope.serializer)
      ..add(BotStepUpErrorEnvelopeAllOfErrors.serializer)
      ..add(BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails.serializer)
      ..add(BotStepUpErrorEnvelopeAllOfErrorsCodeEnum.serializer)
      ..add(BuyerIndustryClassification.serializer)
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
      ..add(BuyerMobileGoogleOidcStartRequest.serializer)
      ..add(BuyerMobileGoogleOidcStartRequestModeEnum.serializer)
      ..add(BuyerMobileLoginRequest.serializer)
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
      ..add(BuyerOriginRequest.serializer)
      ..add(BuyerOriginRequestOriginSourceEnum.serializer)
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
      ..add(ChatDecisionResult.serializer)
      ..add(ChatDecisionResultResponse.serializer)
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
      ..add(ChatPublish.serializer)
      ..add(ChatQuotation.serializer)
      ..add(ChatQuotationChange.serializer)
      ..add(ChatQuotationContent.serializer)
      ..add(ChatQuotationContentPriceSourceEnum.serializer)
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
      ..add(CheckoutChildOrder.serializer)
      ..add(CheckoutChildOrderConfirmationSourceEnum.serializer)
      ..add(CheckoutChildOrderFulfillmentMethodEnum.serializer)
      ..add(CheckoutChildOrderPaymentMethodEnum.serializer)
      ..add(CheckoutGroupPreview.serializer)
      ..add(CheckoutGroupPreviewFulfillmentMethodEnum.serializer)
      ..add(CheckoutGroupPreviewFulfillmentOptionsEnum.serializer)
      ..add(CheckoutGroupPreviewStatusEnum.serializer)
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
      ..add(ComparableGroupCreate.serializer)
      ..add(ComparableGroupEnvelope.serializer)
      ..add(ComparableGroupEnvelopeData.serializer)
      ..add(ComparableStatus.serializer)
      ..add(ComparableStatusStatusEnum.serializer)
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
      ..add(ConversationDetail.serializer)
      ..add(ConversationDetailResponse.serializer)
      ..add(ConversationPage.serializer)
      ..add(ConversationPageResponse.serializer)
      ..add(ConversationView.serializer)
      ..add(ConversationViewContextTypeEnum.serializer)
      ..add(ConversationViewPurposeEnum.serializer)
      ..add(CsrfEnvelope.serializer)
      ..add(CsrfEnvelopeAllOfData.serializer)
      ..add(DatasetLabel.serializer)
      ..add(DatasetLabelKindEnum.serializer)
      ..add(DeliveryAmount.serializer)
      ..add(DeliveryAmountStatusEnum.serializer)
      ..add(DeliveryConfirmation.serializer)
      ..add(DeliveryEstimate.serializer)
      ..add(DeliveryEstimateOption.serializer)
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
      ..add(DeliveryPreview.serializer)
      ..add(DeliveryPreviewEndpointEnum.serializer)
      ..add(DeliveryPreviewStatusEnum.serializer)
      ..add(DeliveryRoute.serializer)
      ..add(DeliveryRouteBasisEnum.serializer)
      ..add(DeliveryRouteSource_Enum.serializer)
      ..add(DeliveryVehicleSelection.serializer)
      ..add(DirectoryAvailability.serializer)
      ..add(DirectoryAvailabilityStatusEnum.serializer)
      ..add(DirectorySupplierDetail.serializer)
      ..add(DirectorySupplierDetailActionsEnum.serializer)
      ..add(DirectorySupplierDetailEnvelope.serializer)
      ..add(DirectorySupplierDetailTierEnum.serializer)
      ..add(DirectorySupplierDetailTierLabelEnum.serializer)
      ..add(DirectorySupplierPhoto.serializer)
      ..add(DirectorySupplierPhotoEnvelope.serializer)
      ..add(DirectorySupplierSummary.serializer)
      ..add(DirectorySupplierSummarySource_Enum.serializer)
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
      ..add(DiscoverySearchRequestOriginSourceEnum.serializer)
      ..add(EmailRequest.serializer)
      ..add(ErrorEnvelope.serializer)
      ..add(ExploreCategoryCount.serializer)
      ..add(ExploreCounts.serializer)
      ..add(ExploreLabels.serializer)
      ..add(ExploreSummary.serializer)
      ..add(ExploreSummaryCountScopeEnum.serializer)
      ..add(ExploreSummaryEnvelope.serializer)
      ..add(FavoriteSupplier.serializer)
      ..add(FavoriteSupplierListEnvelope.serializer)
      ..add(FavoriteSupplierState.serializer)
      ..add(FavoriteSupplierStateEnvelope.serializer)
      ..add(FeatureAvailability.serializer)
      ..add(FeatureAvailabilityStatusEnum.serializer)
      ..add(FeeAssessment.serializer)
      ..add(FeeAssessmentCommissionBasisPointsEnum.serializer)
      ..add(FeeCreditProposalRequest.serializer)
      ..add(FeeStatement.serializer)
      ..add(FeeStatementDetail.serializer)
      ..add(FeeStatementDetailEnvelope.serializer)
      ..add(FeeStatementEnvelope.serializer)
      ..add(FeeStatementListEnvelope.serializer)
      ..add(FeeStatementStateEnum.serializer)
      ..add(FinanceActionResultEnvelope.serializer)
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
      ..add(FleetVehicle.serializer)
      ..add(FleetVehicleEligibility.serializer)
      ..add(FleetVehicleEligibilityReasonsEnum.serializer)
      ..add(FleetVehicleHeavyClassificationEnum.serializer)
      ..add(FleetVehicleImageEnvelope.serializer)
      ..add(FleetVehicleImageEnvelopeData.serializer)
      ..add(FleetVehicleImageEnvelopeDataStatusEnum.serializer)
      ..add(FleetVehicleInput.serializer)
      ..add(FleetVehicleInputHeavyClassificationEnum.serializer)
      ..add(FleetVehicleInputVehicleCategoryEnum.serializer)
      ..add(FleetVehicleListEnvelope.serializer)
      ..add(FleetVehicleListMeta.serializer)
      ..add(FleetVehicleListMetaDelivery.serializer)
      ..add(FleetVehicleListMetaLimits.serializer)
      ..add(FleetVehicleListMetaPermissions.serializer)
      ..add(FleetVehicleListMetaScopeEnum.serializer)
      ..add(FleetVehicleVehicleCategoryEnum.serializer)
      ..add(FleetVehiclesSave.serializer)
      ..add(GenericDataEnvelope.serializer)
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
      ..add(MarkingType.serializer)
      ..add(MaterialCategoryOption.serializer)
      ..add(MaterialPriceObservation.serializer)
      ..add(MaterialPriceObservationEnvironmentEnum.serializer)
      ..add(MfaCodeRequest.serializer)
      ..add(MfaEnrollmentEnvelope.serializer)
      ..add(MfaEnrollmentEnvelopeAllOfData.serializer)
      ..add(MfaRecoveryRequest.serializer)
      ..add(MfaStatusEnvelope.serializer)
      ..add(MfaStatusEnvelopeAllOfData.serializer)
      ..add(MfaStatusEnvelopeAllOfDataMfaRequiredEnum.serializer)
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
      ..add(OrderBuyerRef.serializer)
      ..add(OrderChange.serializer)
      ..add(OrderChangeTypeEnum.serializer)
      ..add(OrderCheckoutRef.serializer)
      ..add(OrderCommercialVersion.serializer)
      ..add(OrderCommercialVersionKindEnum.serializer)
      ..add(OrderConfirmedDelivery.serializer)
      ..add(OrderConfirmedDeliveryBasisEnum.serializer)
      ..add(OrderConfirmedDeliveryEndpointEnum.serializer)
      ..add(OrderDeadline.serializer)
      ..add(OrderDeadlineKindEnum.serializer)
      ..add(OrderDeadlines.serializer)
      ..add(OrderDeadlinesTimezoneEnum.serializer)
      ..add(OrderDelivery.serializer)
      ..add(OrderDeliveryEstimate.serializer)
      ..add(OrderDeliveryStatusEnum.serializer)
      ..add(OrderDeliveryVehicle.serializer)
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
      ..add(OrderFirstLine.serializer)
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
      ..add(OrderReservation.serializer)
      ..add(OrderReservationStateEnum.serializer)
      ..add(OrderRevisionDecision.serializer)
      ..add(OrderState.serializer)
      ..add(OrderStateRow.serializer)
      ..add(OrderStateRowFamilyEnum.serializer)
      ..add(OrderSummary.serializer)
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
      ..add(PageMeta.serializer)
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
      ..add(PriceHistoryEntry.serializer)
      ..add(PriceHistoryEntryPriceKindEnum.serializer)
      ..add(PriceHistoryEnvelope.serializer)
      ..add(ProcessingFee.serializer)
      ..add(ProcessingFeeAmount.serializer)
      ..add(ProcessingFeeAmountStatusEnum.serializer)
      ..add(ProcessingFeeStatusEnum.serializer)
      ..add(ProductComplianceCaseEnvelope.serializer)
      ..add(ProductComplianceCaseEnvelopeData.serializer)
      ..add(ProductComplianceDecision.serializer)
      ..add(ProductComplianceDecisionDecisionEnum.serializer)
      ..add(ProductComplianceQueueEnvelope.serializer)
      ..add(ProductComplianceQueueItem.serializer)
      ..add(ProductRatingSummary.serializer)
      ..add(ProjectBudget.serializer)
      ..add(ProjectCandidate.serializer)
      ..add(ProjectCandidateRequest.serializer)
      ..add(ProjectCompile.serializer)
      ..add(ProjectCompileRadiusKmEnum.serializer)
      ..add(ProjectCompiledEstimate.serializer)
      ..add(ProjectCreate.serializer)
      ..add(ProjectEstimatePage.serializer)
      ..add(ProjectEstimatePageResponse.serializer)
      ..add(ProjectImportPreview.serializer)
      ..add(ProjectImportPreviewResponse.serializer)
      ..add(ProjectImportRequest.serializer)
      ..add(ProjectMaterialPage.serializer)
      ..add(ProjectMaterialPageResponse.serializer)
      ..add(ProjectMissingResolve.serializer)
      ..add(ProjectPage.serializer)
      ..add(ProjectPageResponse.serializer)
      ..add(ProjectPreferenceReset.serializer)
      ..add(ProjectPreferenceSave.serializer)
      ..add(ProjectPreferences.serializer)
      ..add(ProjectPreferencesResponse.serializer)
      ..add(ProjectRoute.serializer)
      ..add(ProjectRouteOriginEnum.serializer)
      ..add(ProjectRouteResponse.serializer)
      ..add(ProjectSite.serializer)
      ..add(ProjectSummary.serializer)
      ..add(ProjectSummaryStatusEnum.serializer)
      ..add(ProjectUpdate.serializer)
      ..add(ProjectUpdateStatusEnum.serializer)
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
      ..add(RankingPreferencesTotalPercentEnum.serializer)
      ..add(RankingPreferencesUpdate.serializer)
      ..add(RankingWeightSet.serializer)
      ..add(RegisterRequest.serializer)
      ..add(RegisterRequestPrivacyAcceptedEnum.serializer)
      ..add(RegisterRequestTermsAcceptedEnum.serializer)
      ..add(RegistrationEnvelope.serializer)
      ..add(RegistrationEnvelopeAllOfData.serializer)
      ..add(RegulatedMaterialRule.serializer)
      ..add(RegulatedMaterialRuleRequiredMarkingEnum.serializer)
      ..add(ResendBotChallengeRequest.serializer)
      ..add(ReviewResolveRequest.serializer)
      ..add(RouteEstimate.serializer)
      ..add(RouteEstimateDurationBasisEnum.serializer)
      ..add(RouteEstimateEnvelope.serializer)
      ..add(RouteEstimateRequest.serializer)
      ..add(RouteEstimateRequestOriginSourceEnum.serializer)
      ..add(ScoreLabel.serializer)
      ..add(ScoreLabelKindEnum.serializer)
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
      ..add(SupplierOpenStatus.serializer)
      ..add(SupplierOpenStatusBasisEnum.serializer)
      ..add(SupplierOpenStatusStatusEnum.serializer)
      ..add(SupplierResult.serializer)
      ..add(SupplierServiceability.serializer)
      ..add(SupplierServiceabilityBasisEnum.serializer)
      ..add(SupplierServiceabilityDeliveryEnum.serializer)
      ..add(SupplierTier.serializer)
      ..add(TaxCategory.serializer)
      ..add(ThresholdStatusEvent.serializer)
      ..add(ThresholdStatusEventActorTypeEnum.serializer)
      ..add(ThresholdStatusEventFromStatusEnum.serializer)
      ..add(ThresholdStatusEventToStatusEnum.serializer)
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
      ..add(VendorEarnings.serializer)
      ..add(VendorEarningsEnvelope.serializer)
      ..add(VendorFile.serializer)
      ..add(VendorFileEnvelope.serializer)
      ..add(VendorFinanceNotice.serializer)
      ..add(VendorFinanceOverview.serializer)
      ..add(VendorFinanceOverviewEnvelope.serializer)
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
      ..add(VendorOrderConfirmRequest.serializer)
      ..add(VendorOrderDeclineReason.serializer)
      ..add(VendorOrderDeclineRequest.serializer)
      ..add(VendorOrderPermissions.serializer)
      ..add(VendorOrderPrimaryAction.serializer)
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
      ..add(VerifiedVendorSummary.serializer)
      ..add(VerifyBotChallengeRequest.serializer)
      ..add(VerifyEmailRequest.serializer)
      ..add(VolumeTier.serializer)
      ..add(WithholdingAccumulatorDetail.serializer)
      ..add(WithholdingAccumulatorDetailEnvelope.serializer)
      ..add(WithholdingAccumulatorDetailStatusEnum.serializer)
      ..add(WithholdingAccumulatorListEnvelope.serializer)
      ..add(WithholdingAccumulatorView.serializer)
      ..add(WithholdingAccumulatorViewStatusEnum.serializer)
      ..add(WithholdingThresholdPanel.serializer)
      ..add(WithholdingThresholdPanelExternalOverlapStateEnum.serializer)
      ..add(WithholdingThresholdPanelStatusEnum.serializer)
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
      ..add(WorkPackageVersionPage.serializer)
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
          const FullType(
              BuiltList, const [const FullType(AutoAcceptPolicyVersion)]),
          () => ListBuilder<AutoAcceptPolicyVersion>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(AutoAcceptReason)]),
          () => ListBuilder<AutoAcceptReason>())
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
          const FullType(
              BuiltList, const [const FullType(DeliveryEstimateOption)]),
          () => ListBuilder<DeliveryEstimateOption>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(DeliveryPlanGroup)]),
          () => ListBuilder<DeliveryPlanGroup>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DeliveryPlanVehicle)]),
          () => ListBuilder<DeliveryPlanVehicle>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(DeliveryVehicleSelection)]),
          () => ListBuilder<DeliveryVehicleSelection>())
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
          const FullType(
              BuiltList, const [const FullType(MoneyBreakdownExcludesEnum)]),
          () => ListBuilder<MoneyBreakdownExcludesEnum>())
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
          const FullType(
              BuiltList, const [const FullType(OrderDeliveryVehicle)]),
          () => ListBuilder<OrderDeliveryVehicle>())
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
          const FullType(BuiltList, const [const FullType(ProjectCandidate)]),
          () => ListBuilder<ProjectCandidate>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ProjectSite)]),
          () => ListBuilder<ProjectSite>())
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
              BuiltList, const [const FullType(DeliveryPlanVehicle)]),
          () => ListBuilder<DeliveryPlanVehicle>())
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
          const FullType(
              BuiltList, const [const FullType(ThresholdStatusEvent)]),
          () => ListBuilder<ThresholdStatusEvent>())
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
          const FullType(BuiltList, const [const FullType(WorkPackageVersion)]),
          () => ListBuilder<WorkPackageVersion>())
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
