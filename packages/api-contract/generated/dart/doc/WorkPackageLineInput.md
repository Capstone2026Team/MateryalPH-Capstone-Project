# materyalph_api_client.model.WorkPackageLineInput

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**materialId** | **String** | Canonical catalog material; omitted or null for an unlisted material the Buyer names. Unlisted lines accept any normalized unit and are always missing lines. | [optional]
**name** | **String** |  |
**description** | **String** |  | [optional]
**color** | **String** |  | [optional]
**unitId** | **String** |  |
**quantity** | **String** | Positive quantity within the selected normalized unit precision; maximum 1,000,000. |
**specifications** | **BuiltMap&lt;String, String&gt;** |  |
**preferredBrand** | **String** |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


