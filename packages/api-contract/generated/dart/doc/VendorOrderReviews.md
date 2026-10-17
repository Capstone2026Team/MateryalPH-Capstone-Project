# materyalph_api_client.model.VendorOrderReviews

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**orderId** | **String** |  |
**orderReference** | **String** |  |
**state** | **String** |  |
**completedAt** | [**DateTime**](DateTime.md) |  | [optional]
**closesAt** | [**DateTime**](DateTime.md) |  | [optional]
**closesAtLabel** | **String** |  | [optional]
**revealed** | **bool** |  |
**revealedAt** | [**DateTime**](DateTime.md) |  | [optional]
**revealReason** | **String** |  | [optional]
**withheldForDispute** | **bool** |  |
**rules** | [**ReviewWindowRules**](ReviewWindowRules.md) |  |
**party** | **String** |  |
**buyerRating** | [**OwnReview**](OwnReview.md) |  | [optional]
**canSubmitBuyerRating** | **bool** |  |
**received** | [**BuiltList&lt;PublicReview&gt;**](PublicReview.md) |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


