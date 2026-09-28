# materyalph_api_client.model.DiscoverySearchRequest

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**locationId** | **String** |  | [optional]
**latitude** | **double** |  | [optional]
**longitude** | **double** |  | [optional]
**originSource** | **String** |  | [optional]
**radiusKm** | **int** | Must be one of 5, 10, 20, 30, 40 or 50; otherwise 422 RADIUS_UNSUPPORTED. | [optional]
**includeVerified** | **bool** |  | [optional]
**includeDirectory** | **bool** |  | [optional]
**favoritesOnly** | **bool** |  | [optional]
**supplierType** | **String** | WHOLESALER_DISTRIBUTOR, RETAIL_HARDWARE_STORE, SPECIALIZED_SUPPLIER or OTHER. Tier-specific filters hide Directory Suppliers. | [optional]
**categoryId** | **String** |  | [optional]
**page** | **int** |  | [optional]
**perPage** | **int** |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


