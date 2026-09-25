# materyalph_api_client.model.VendorSetupDraftVehiclesInner

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | [optional]
**vehicleCategory** | **String** | Separate category and type. Categorized configurations require applicable cargo dimensions or mixer capacity and heavy classification. | [optional]
**vehicleType** | **String** |  | [optional]
**customTypeName** | **String** |  | [optional]
**brand** | **String** |  | [optional]
**mixerCapacityM3** | **num** |  | [optional]
**imageFileId** | **String** | Clean VEHICLE_IMAGE file owned by this Vendor. | [optional]
**active** | **bool** | Disabled configurations are retained for history and excluded from recommendations. | [optional]
**name** | **String** |  | [optional]
**capacityKg** | **num** |  | [optional]
**numberAvailable** | **int** |  | [optional]
**cargoLengthM** | **num** |  | [optional]
**cargoWidthM** | **num** |  | [optional]
**cargoHeightM** | **num** |  | [optional]
**heavyClassification** | **String** |  | [optional]
**baseFeeCentavos** | **int** |  | [optional]
**perKmCentavos** | **int** |  | [optional]
**maximumDistanceKm** | **int** | Omission retains the saved limit; new coverage defaults to the approved 50 km procurement limit. New vehicle rates inherit coverage. | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


