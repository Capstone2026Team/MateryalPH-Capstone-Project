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
**favoritesOnly** | **bool** | Limits both tiers to the Buyer's Favorite Suppliers. Unlike supplier_type and category_id, it does not hide Directory Suppliers. | [optional]
**directoryMinRating** | **double** | Inclusive minimum Google rating, Directory Suppliers only. Send a JSON number; a value of 3.0 keeps ratings from 3.0 through 5.0 and excludes lower-rated and unrated places. Verified Vendors and VPS are unchanged. | [optional]
**directoryMaxDistanceKm** | **int** | Directory Suppliers only. Must not exceed the effective selected radius. | [optional]
**supplierType** | **String** | WHOLESALER_DISTRIBUTOR, RETAIL_HARDWARE_STORE, SPECIALIZED_SUPPLIER or OTHER. Tier-specific filters hide Directory Suppliers. | [optional]
**categoryId** | **String** |  | [optional]
**page** | **int** |  | [optional]
**perPage** | **int** |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


