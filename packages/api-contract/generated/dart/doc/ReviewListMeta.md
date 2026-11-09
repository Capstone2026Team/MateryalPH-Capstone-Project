# materyalph_api_client.model.ReviewListMeta

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**counts** | **BuiltMap&lt;String, int&gt;** | Admin moderation only. Full totals by moderation state, including ALL and NEEDS_ACTION, after submission date filters but before state selection and pagination. NEEDS_ACTION counts each review once using the queue's existing open-report or flagged/hidden criteria. | [optional]
**page** | **int** |  | [optional]
**perPage** | **int** |  | [optional]
**total** | **int** |  | [optional]
**type** | **String** |  | [optional]
**summary** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  | [optional]
**scores** | [**PublicScores**](PublicScores.md) |  | [optional]
**correlationId** | **String** |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


