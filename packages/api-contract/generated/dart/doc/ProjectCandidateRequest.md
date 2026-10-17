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

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


