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
**from** | [**Date**](Date.md) | Inclusive Asia/Manila notification created_at lower boundary. Omit for an open boundary. | [optional]
**to** | [**Date**](Date.md) | Inclusive Asia/Manila notification created_at upper boundary. Must be on or after from when both are provided. | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


