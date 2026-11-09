# materyalph_api_client.model.CommissionPolicy

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**version** | **int** |  |
**commissionBasisPoints** | **int** | Integer basis points; 200 means 2.00%. |
**rateLabel** | **String** |  |
**effectiveFrom** | [**DateTime**](DateTime.md) |  |
**agreementVersionId** | **String** |  | [optional]
**reason** | **String** |  | [optional]
**status** | **String** |  |
**termsVersion** | **int** |  | [optional]
**termsContent** | **String** |  | [optional]
**vendorMessage** | **String** |  | [optional]
**noticeHours** | **int** |  | [optional]
**noticeOverrideReason** | **String** | Admin only. | [optional]
**publishedBy** | **String** | Admin audit identity; omitted in public and Vendor projections. | [optional]
**delivery** | [**CommissionEmailSummary**](CommissionEmailSummary.md) |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


