# materyalph_api_client.model.WorkPackageAlternative

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**listingId** | **String** |  |
**variantId** | **String** |  |
**priceVersionId** | **String** |  |
**displayName** | **String** |  |
**variantLabel** | **String** |  | [optional]
**brand** | **String** |  | [optional]
**vendorId** | **String** |  |
**storeName** | **String** |  | [optional]
**image** | **String** |  | [optional]
**unitPriceCentavos** | **int** |  |
**unitCode** | **String** |  |
**unitPrecision** | **int** |  |
**distanceMeters** | **int** |  |
**stockLabel** | **String** | Availability label only; exact inventory is never returned. |
**specifications** | [**BuiltList&lt;ProjectSpecificationDetail&gt;**](ProjectSpecificationDetail.md) | Listing and variant details as the category names them. | [optional]
**exactMatch** | **bool** | Brand (when set) and every stated specification match the Work Package line. |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


