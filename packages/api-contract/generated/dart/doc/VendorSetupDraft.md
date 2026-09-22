# materyalph_api_client.model.VendorSetupDraft

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**draftLockVersion** | **int** | Version of this workstream draft; zero for its first save. Stale versions return 409. | [optional]
**organizationLockVersion** | **int** |  |
**publicStoreName** | **String** |  | [optional]
**description** | **String** |  | [optional]
**bulkCapability** | **bool** |  | [optional]
**fulfillmentMethod** | **String** |  | [optional]
**publicEmail** | **String** |  | [optional]
**publicPhone** | **String** |  | [optional]
**delivery** | [**VendorSetupDraftDelivery**](VendorSetupDraftDelivery.md) |  | [optional]
**vehicles** | [**BuiltList&lt;VendorSetupDraftVehiclesInner&gt;**](VendorSetupDraftVehiclesInner.md) |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


