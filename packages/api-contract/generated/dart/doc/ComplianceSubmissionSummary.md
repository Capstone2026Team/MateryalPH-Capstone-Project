# materyalph_api_client.model.ComplianceSubmissionSummary

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**version** | **int** |  |
**path** | [**CompliancePath**](CompliancePath.md) |  |
**status** | **String** |  |
**markingType** | **String** |  | [optional]
**markingNumber** | **String** | Vendor-confirmed PS licence number or ICC sticker serial. | [optional]
**registerRecord** | [**ComplianceRegisterRecord**](ComplianceRegisterRecord.md) | Immutable matched register details retained with this submission, including the registered product, brand, model, company and standard when present. | [optional]
**reviewMode** | **String** |  | [optional]
**submittedAt** | **String** |  | [optional]
**decidedAt** | **String** |  | [optional]
**latestReview** | [**ComplianceReviewSummary**](ComplianceReviewSummary.md) |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


