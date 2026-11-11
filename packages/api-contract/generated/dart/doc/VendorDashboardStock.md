# materyalph_api_client.model.VendorDashboardStock

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**variants** | **int** |  |
**active** | **int** | Active variants belonging to ACTIVE listings, across all dates. Active plus inactive equals variants. |
**inactive** | **int** | Active variants on all other nonremoved listings, including drafts, inactive, hidden, rejected and pending listings. This is separate from stock availability. |
**inStock** | **int** |  |
**limitedStock** | **int** |  |
**outOfStock** | **int** |  |
**attention** | [**BuiltList&lt;VendorDashboardStockAttentionInner&gt;**](VendorDashboardStockAttentionInner.md) |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


