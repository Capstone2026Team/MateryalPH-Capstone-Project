# materyalph_api_client.model.OrderListMeta

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**group** | **String** |  |
**counts** | **BuiltMap&lt;String, int&gt;** |  |
**activeCounts** | **BuiltMap&lt;String, int&gt;** | Buyer lists include ITEM_BASED and PROJECT_BASED active order totals across all pages and status chips, regardless of procurement_type. Excludes COMPLETED, CANCELLED, DECLINED and EXPIRED; includes DISPUTED. Omitted on Vendor and Admin lists. | [optional]
**page** | **int** |  |
**perPage** | **int** |  |
**total** | **int** |  |
**hasMore** | **bool** |  |
**currentAsOf** | [**DateTime**](DateTime.md) |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


