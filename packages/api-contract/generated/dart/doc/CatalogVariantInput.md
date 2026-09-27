# materyalph_api_client.model.CatalogVariantInput

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | [optional]
**sku** | **String** |  |
**label** | **String** |  | [optional]
**unitId** | **String** |  |
**packQuantity** | **String** |  |
**priceCentavos** | **int** | Ordinary single-sale VAT-inclusive payable price in centavos. |
**taxCategory** | [**TaxCategory**](TaxCategory.md) |  |
**taxBasis** | **String** |  | [optional]
**weightKg** | **String** |  | [optional]
**lengthCm** | **String** |  | [optional]
**widthCm** | **String** |  | [optional]
**heightCm** | **String** |  | [optional]
**quantityOnHand** | **String** | Counted physical stock; recording it confirms stock now. | [optional]
**active** | **bool** |  | [optional]
**attributes** | **BuiltMap&lt;String, String&gt;** |  | [optional]
**volumeTiers** | [**BuiltList&lt;CatalogVolumeTierInput&gt;**](CatalogVolumeTierInput.md) | Replaces the variant volume tiers when present (an empty list removes them); omitted keeps the current tiers. | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


