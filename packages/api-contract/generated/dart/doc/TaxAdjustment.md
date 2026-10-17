# materyalph_api_client.model.TaxAdjustment

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**kind** | **String** |  |
**state** | **String** |  |
**environment** | **String** |  |
**openedBy** | **String** |  |
**orderReference** | **String** |  | [optional]
**vendorName** | **String** |  | [optional]
**originalRecordType** | **String** |  |
**originalRecordId** | **String** |  |
**periodStart** | [**Date**](Date.md) |  |
**periodEnd** | [**Date**](Date.md) |  |
**amountCentavos** | **int** |  |
**beforeValues** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  |
**afterValues** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  |
**reason** | **String** |  |
**preparer** | **String** |  | [optional]
**reviewer** | **String** |  | [optional]
**reviewedAt** | [**DateTime**](DateTime.md) |  | [optional]
**postedAt** | [**DateTime**](DateTime.md) |  | [optional]
**createdAt** | [**DateTime**](DateTime.md) |  | [optional]
**allowedActions** | **BuiltList&lt;String&gt;** |  |
**separationNote** | **String** |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


