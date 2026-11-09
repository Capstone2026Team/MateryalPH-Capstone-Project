# materyalph_api_client.model.VendorReviewRow

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**buyerAvatarUrl** | **String** | Five-minute signed review-scoped Buyer photo URL, including for legacy reviews now shown with full identity. Null for store-authored Buyer ratings or missing photos. Fetch with the current Vendor session; never use a private storage URL. | [optional]
**id** | **String** |  | [optional]
**type** | **String** |  | [optional]
**ratings** | [**ReviewRatings**](ReviewRatings.md) |  | [optional]
**comment** | **String** |  | [optional]
**displayName** | **String** |  | [optional]
**verifiedPurchase** | **bool** |  | [optional]
**submittedAt** | [**DateTime**](DateTime.md) |  | [optional]
**edited** | **bool** |  | [optional]
**variantLabel** | **String** |  | [optional]
**product** | [**ReviewProduct**](ReviewProduct.md) | Purchased-product identity from the immutable order line snapshot; null for Store and Buyer ratings. | [optional]
**media** | [**BuiltList&lt;ReviewMediaLink&gt;**](ReviewMediaLink.md) |  | [optional]
**visibility** | **String** |  | [optional]
**orderId** | **String** |  | [optional]
**orderReference** | **String** |  | [optional]
**canReport** | **bool** |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


