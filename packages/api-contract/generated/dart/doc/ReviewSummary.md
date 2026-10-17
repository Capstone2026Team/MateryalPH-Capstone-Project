# materyalph_api_client.model.ReviewSummary

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**count** | **int** |  |
**average** | **num** | Arithmetic mean of visible product star ratings, rounded half-up to two decimals; null when count is zero. |
**distribution** | [**BuiltList&lt;ReviewRatingBucket&gt;**](ReviewRatingBucket.md) | All five rating buckets ordered from five stars to one star, including zero counts. |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


