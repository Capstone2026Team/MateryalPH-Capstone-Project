# materyalph_api_client.model.DisputeDetail

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**reference** | **String** |  |
**orderId** | **String** |  |
**orderReference** | **String** |  |
**status** | **String** |  |
**caseKind** | **String** |  |
**issueType** | **String** |  |
**requestedRemedy** | **String** |  |
**requestedAmountCentavos** | **int** |  | [optional]
**filedByParty** | **String** |  |
**responsibleParty** | **String** |  |
**nextDeadline** | [**DisputeDeadline**](DisputeDeadline.md) |  | [optional]
**refundState** | **String** |  |
**remedyState** | **String** |  |
**appealAvailable** | **bool** |  |
**vendorName** | **String** |  |
**buyerName** | **String** |  | [optional]
**assignedToAdmin** | **bool** |  |
**decisions** | [**BuiltList&lt;DisputeDecision&gt;**](DisputeDecision.md) |  |
**filedAt** | [**DateTime**](DateTime.md) |  | [optional]
**updatedAt** | [**DateTime**](DateTime.md) |  | [optional]
**description** | **String** |  | [optional]
**affectedLines** | [**BuiltList&lt;DisputeAffectedLine&gt;**](DisputeAffectedLine.md) |  |
**originalPaymentMethod** | [**DisputeOriginalPaymentMethod**](DisputeOriginalPaymentMethod.md) |  | [optional]
**preferredContactChannel** | **String** |  | [optional]
**order** | [**DisputeOrderRef**](DisputeOrderRef.md) |  |
**deadlines** | [**BuiltList&lt;DisputeDeadline&gt;**](DisputeDeadline.md) |  |
**serverTime** | [**DateTime**](DateTime.md) |  |
**timezone** | **String** |  |
**handler** | [**DisputeHandler**](DisputeHandler.md) |  |
**lockVersion** | **int** |  |
**timeline** | [**BuiltList&lt;DisputeTimelineEntry&gt;**](DisputeTimelineEntry.md) |  |
**proposals** | [**BuiltList&lt;DisputeProposal&gt;**](DisputeProposal.md) |  |
**clarifications** | [**BuiltList&lt;DisputeClarification&gt;**](DisputeClarification.md) |  |
**appeal** | [**DisputeAppeal**](DisputeAppeal.md) |  | [optional]
**remedies** | [**BuiltList&lt;DisputeRemedy&gt;**](DisputeRemedy.md) |  |
**refunds** | [**BuiltList&lt;RefundTimelineItem&gt;**](RefundTimelineItem.md) |  |
**reimbursements** | [**BuiltList&lt;ReimbursementTimelineItem&gt;**](ReimbursementTimelineItem.md) |  | [optional]
**availableActions** | **BuiltList&lt;String&gt;** |  |
**limitedView** | **bool** |  |
**permissions** | [**DisputeVendorPermissions**](DisputeVendorPermissions.md) |  | [optional]
**admin** | [**DisputeAdminContext**](DisputeAdminContext.md) |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


