# materyalph_api_client.model.NotificationReadFilter

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**throughId** | **String** | Newest notification ID in the captured client inbox snapshot. Later arrivals remain unread. |
**category** | **String** | Exact notification category selected in the dynamic Type filter. Omit for All types. New categories are supported without a client enum change. | [optional]
**title** | **String** | Legacy exact display-title filter retained for older clients. New clients use category. When both filters are supplied, both must match. | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


