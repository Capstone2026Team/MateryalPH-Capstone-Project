# materyalph_api_client.model.ComplianceRegister

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**registerKind** | **String** |  |
**sourceReference** | **String** |  |
**snapshotDate** | [**Date**](Date.md) |  |
**status** | **String** |  |
**sourceChannel** | **String** |  | [optional]
**stale** | **bool** | An ACTIVE snapshot older than the configured age (45 days); the government lists are updated monthly. | [optional]
**rowCount** | **int** |  |
**rejectedRowCount** | **int** |  |
**serialRangeCount** | **int** |  | [optional]
**activatedAt** | **String** |  | [optional]
**supersededAt** | **String** |  | [optional]
**createdAt** | **String** |  | [optional]
**columnMapping** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  | [optional]
**rejectedRows** | [**BuiltList&lt;BuiltMap&lt;String, JsonObject&gt;&gt;**](BuiltMap.md) |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


