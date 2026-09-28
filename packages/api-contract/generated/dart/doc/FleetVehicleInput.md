# materyalph_api_client.model.FleetVehicleInput

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | Omit for a new configuration. | [optional]
**lockVersion** | **int** | Required with id. | [optional]
**removed** | **bool** | True removes a saved configuration from future use; its versions and accepted snapshots are kept. | [optional]
**vehicleCategory** | **String** |  | [optional]
**vehicleType** | **String** |  | [optional]
**customTypeName** | **String** |  | [optional]
**name** | **String** |  | [optional]
**brand** | **String** |  | [optional]
**imageFileId** | **String** |  | [optional]
**numberAvailable** | **int** |  | [optional]
**capacityKg** | **num** | Payload in kilograms | [optional]
**cargoLengthM** | **num** |  | [optional]
**cargoWidthM** | **num** |  | [optional]
**cargoHeightM** | **num** |  | [optional]
**mixerCapacityM3** | **num** | Required for a Concrete Mixer Truck / Transit Mixer; cargo dimensions are then not applicable. | [optional]
**heavyClassification** | **String** |  | [optional]
**active** | **bool** |  | [optional]
**available** | **bool** |  | [optional]
**baseFeeCentavos** | **int** |  | [optional]
**perKmCentavos** | **int** |  | [optional]
**maximumDistanceKm** | **int** |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


