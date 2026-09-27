# materyalph_api_client.model.CatalogListingSummary

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**displayName** | **String** |  |
**vendorSku** | **String** |  |
**status** | [**ListingStatus**](ListingStatus.md) |  |
**complianceStatus** | [**ListingComplianceStatus**](ListingComplianceStatus.md) |  |
**regulated** | **bool** |  |
**categoryName** | **String** |  | [optional]
**materialName** | **String** |  | [optional]
**otherLabel** | **String** |  | [optional]
**lockVersion** | **int** |  |
**updatedAt** | **String** |  | [optional]
**variantCount** | **int** |  |
**minPriceCentavos** | **int** |  | [optional]
**maxPriceCentavos** | **int** |  | [optional]
**publicAvailability** | **String** | The only availability a Buyer would see. |
**primaryImageFileId** | **String** |  | [optional]
**primaryImageUrl** | **String** | Short-lived signed URL of the first ready product photo; expires within minutes. | [optional]
**unitCode** | **String** | Sale unit code when every active variant uses the same unit. | [optional]
**availableQuantity** | **String** | Vendor-only summed available-to-sell quantity when every active variant shares one unit and has a stock count. Never returned to Buyers. | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


