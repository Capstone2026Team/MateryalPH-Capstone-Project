# materyalph_api_client.model.VendorSetupDraft

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**draftLockVersion** | **int** | Workstream draft version; zero on first save. Send together with the required organization guard. Omission retains legacy behavior without draft-level comparison. A stale draft returns 409 STALE_VERSION; a stale organization returns 409 RESOURCE_VERSION_CONFLICT. | [optional]
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


