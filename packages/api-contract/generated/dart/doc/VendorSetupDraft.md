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
**formState** | **String** | Encrypted JSON setup form progress. Unfinished vehicle entries are not operational configurations. Returned privately as setup.form_state. | [optional]
**vacationMode** | **bool** | Owner-only immediate pause of all new procurement. Existing work and messaging remain available. Does not alter weekly hours or activation. | [optional]
**publicStoreName** | **String** |  | [optional]
**description** | **String** |  | [optional]
**bulkCapability** | **bool** |  | [optional]
**fulfillmentMethod** | **String** |  | [optional]
**publicEmail** | **String** |  | [optional]
**publicPhone** | **String** |  | [optional]
**operatingSchedule** | [**BuiltList&lt;StoreOperatingDay&gt;**](StoreOperatingDay.md) | Complete replacement of the normal weekly schedule. All seven distinct weekdays are required. Closed days have null times; Open days need a same-day opening and later closing time. | [optional]
**delivery** | [**VendorSetupDraftDelivery**](VendorSetupDraftDelivery.md) |  | [optional]
**vehicles** | [**BuiltList&lt;VendorSetupDraftVehiclesInner&gt;**](VendorSetupDraftVehiclesInner.md) |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


