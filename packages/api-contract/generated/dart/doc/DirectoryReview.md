# materyalph_api_client.model.DirectoryReview

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**type** | **String** |  |
**ratings** | [**BuiltMap&lt;String, DirectoryReviewRatingsValue&gt;**](DirectoryReviewRatingsValue.md) | Criterion scores by name; their keys depend on the review type. |
**comment** | **String** | Withheld for a hidden or removed review unless the caller holds reviews.moderate. |
**authorName** | **String** |  |
**orderReference** | **String** |  |
**storeName** | **String** |  |
**productName** | **String** |  |
**moderationState** | **String** |  |
**visibility** | **String** |  |
**submittedAt** | [**DateTime**](DateTime.md) |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


