# materyalph_api_client.model.ProjectCandidateRequest

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**lockVersion** | **int** |  |
**candidateId** | **String** |  |
**note** | **String** |  | [optional]
**budgetOverrideReason** | **String** |  | [optional]
**selections** | [**BuiltList&lt;ProjectSpecificationSelection&gt;**](ProjectSpecificationSelection.md) | The Buyer's specification choice for each line whose `selection_required` is true. Selection and inquiry are rejected with SPECIFICATION_SELECTION_REQUIRED until every such line has one. | [optional]
**fulfillmentMethod** | **String** | The Buyer's method for a Vendor whose candidate lists more than one `fulfillment_options` entry (Both packages). Required then, or the request is rejected with FULFILLMENT_CHOICE_REQUIRED; a method the Vendor does not offer is rejected with FULFILLMENT_NOT_OFFERED. | [optional]
**paymentMethod** | **String** | Required for direct selection; explicitly chosen in the checklist and revalidated against current Vendor and fulfillment rules. Inquiry may omit it. | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


