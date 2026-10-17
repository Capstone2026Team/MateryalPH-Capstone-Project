# materyalph_api_client.model.EnforcementDetail

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**subjectType** | **String** |  |
**subjectId** | **String** |  |
**subjectName** | **String** |  |
**action** | **String** |  |
**actionLabel** | **String** |  |
**state** | **String** |  |
**source_** | **String** |  |
**caseId** | **String** |  | [optional]
**caseReference** | **String** |  | [optional]
**reason** | **String** |  |
**durationDays** | **int** |  | [optional]
**continuationPlan** | **String** |  | [optional]
**issuedRole** | **String** |  | [optional]
**appliedRole** | **String** |  | [optional]
**createdAt** | [**DateTime**](DateTime.md) |  |
**appliedAt** | [**DateTime**](DateTime.md) |  | [optional]
**expiresAt** | [**DateTime**](DateTime.md) |  | [optional]
**liftedAt** | [**DateTime**](DateTime.md) |  | [optional]
**liftReason** | **String** |  | [optional]
**lockVersion** | **int** |  |
**scope** | **String** |  |
**restorationCondition** | **String** |  | [optional]
**continuationNote** | **String** |  | [optional]
**priorSubjectState** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  | [optional]
**subjectReview** | [**SubjectReview**](SubjectReview.md) |  |
**events** | [**BuiltList&lt;EnforcementEvent&gt;**](EnforcementEvent.md) |  |
**allowedActions** | **BuiltList&lt;String&gt;** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


