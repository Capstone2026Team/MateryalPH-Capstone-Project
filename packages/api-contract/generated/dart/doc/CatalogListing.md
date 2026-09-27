# materyalph_api_client.model.CatalogListing

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**status** | [**ListingStatus**](ListingStatus.md) |  |
**lockVersion** | **int** |  |
**displayName** | **String** |  |
**vendorSku** | **String** |  |
**description** | **String** |  | [optional]
**material** | [**CatalogListingMaterial**](CatalogListingMaterial.md) |  | [optional]
**materialMatch** | **String** |  |
**materialCategoryId** | **String** |  | [optional]
**otherLabel** | **String** | Listing-only text; never a shared taxonomy entry. | [optional]
**tagIds** | **BuiltList&lt;String&gt;** |  |
**technicalAttributes** | **BuiltMap&lt;String, String&gt;** |  |
**brand** | **String** |  | [optional]
**model** | **String** |  | [optional]
**manufacturer** | **String** |  | [optional]
**manufacturerAddress** | **String** |  | [optional]
**countryOfManufacture** | **String** |  | [optional]
**regulated** | **bool** |  |
**complianceStatus** | [**ListingComplianceStatus**](ListingComplianceStatus.md) |  |
**regulatedRule** | [**RegulatedMaterialRule**](RegulatedMaterialRule.md) |  | [optional]
**publicationVersion** | **int** |  |
**publishedAt** | **String** |  | [optional]
**publicationRequestedAt** | **String** |  | [optional]
**variants** | [**BuiltList&lt;CatalogVariant&gt;**](CatalogVariant.md) |  |
**media** | [**BuiltList&lt;CatalogMedia&gt;**](CatalogMedia.md) |  |
**complianceSubmissions** | [**BuiltList&lt;ComplianceSubmissionSummary&gt;**](ComplianceSubmissionSummary.md) |  |
**statusHistory** | [**BuiltList&lt;ListingStatusChange&gt;**](ListingStatusChange.md) |  |
**completion** | [**CatalogCompletion**](CatalogCompletion.md) |  |
**blockers** | [**BuiltList&lt;CatalogBlocker&gt;**](CatalogBlocker.md) |  |
**permissions** | [**CatalogListingPermissions**](CatalogListingPermissions.md) |  |
**uploadedMediaId** | **String** |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


