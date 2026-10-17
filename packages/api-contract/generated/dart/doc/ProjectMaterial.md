# materyalph_api_client.model.ProjectMaterial

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**code** | **String** |  |
**name** | **String** |  |
**categoryId** | **String** |  |
**categoryName** | **String** |  |
**regulated** | **bool** |  |
**matchType** | **String** |  |
**matchedText** | **String** |  |
**similarity** | **num** | 1 for exact or alias matches; pg_trgm similarity for close matches. |
**compatibleUnits** | [**BuiltList&lt;ProjectMaterialUnit&gt;**](ProjectMaterialUnit.md) |  |
**attributes** | [**BuiltList&lt;ProjectMaterialAttribute&gt;**](ProjectMaterialAttribute.md) | Category technical details the Buyer may state, keyed by code. |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


