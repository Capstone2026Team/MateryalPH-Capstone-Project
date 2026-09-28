# materyalph_api_client.model.SupplierResult

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**resultId** | **String** |  |
**tier** | [**SupplierTier**](SupplierTier.md) |  |
**tierLabel** | **String** |  |
**rank** | **int** |  |
**name** | **String** | Canonical Public Store Name for Tier 2; Google display name for Tier 1. |
**marker** | [**MapPoint**](MapPoint.md) |  |
**distanceMeters** | **int** | Geodesic straight-line distance; never a route distance. |
**scoreLabel** | [**ScoreLabel**](ScoreLabel.md) |  |
**isFavorite** | **bool** |  |
**vendor** | [**VerifiedVendorSummary**](VerifiedVendorSummary.md) |  |
**directory** | [**DirectorySupplierSummary**](DirectorySupplierSummary.md) |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


