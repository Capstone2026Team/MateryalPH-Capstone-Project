# materyalph_api_client.model.VendorInvoicePreset

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**invoiceType** | **String** |  |
**issuerName** | **String** | Must equal the registered business name. |
**sourceSystem** | **String** |  |
**invoicingMethod** | **String** |  |
**lockVersion** | **int** | Current lock version; zero creates a new draft or preset. |
**dateMode** | **String** | New copies start with today in Asia/Manila. Each invoice date remains editable; numbers and amounts are never preset. |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


