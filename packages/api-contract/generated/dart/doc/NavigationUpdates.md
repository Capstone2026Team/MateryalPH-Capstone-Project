# materyalph_api_client.model.NavigationUpdates

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**sections** | **BuiltMap&lt;String, int&gt;** | Authorized navigation paths mapped to unread messages/notices, active records or pending actions. Team headcounts are retained only in the legacy Vendor summary and are not displayed as attention badges. |
**cartQuantity** | **String** | Buyer only. Exact sum of active selected line quantities, excluding saved-for-later; never a line or unread count. | [optional]
**cartVersion** | **int** | Buyer only. Current active cart lock_version, zero when no cart exists. | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


