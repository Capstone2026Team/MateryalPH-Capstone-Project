# materyalph_api_client.model.VendorOnboardingSnapshotSetup

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**operatingSchedule** | [**BuiltList&lt;StoreOperatingDay&gt;**](StoreOperatingDay.md) |  | [optional]
**deliverySetup** | [**VendorDeliverySetup**](VendorDeliverySetup.md) |  | [optional]
**vacationMode** | **bool** | True while new procurement is paused. | [optional]
**vacationStatus** | **String** | SCHEDULED when a future start date is saved. ACTIVE with null dates is a legacy open-ended pause the Owner can turn off. | [optional]
**vacationStartsOn** | **String** | Asia/Manila calendar date. | [optional]
**vacationEndsOn** | **String** | Inclusive last Asia/Manila day. | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


