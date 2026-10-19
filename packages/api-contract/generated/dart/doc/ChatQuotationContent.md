# materyalph_api_client.model.ChatQuotationContent

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**discount** | [**ChatQuotationDiscountAssessment**](ChatQuotationDiscountAssessment.md) |  | [optional]
**lines** | [**BuiltList&lt;ChatQuotationLine&gt;**](ChatQuotationLine.md) |  |
**commercial** | [**ChatQuotationMoney**](ChatQuotationMoney.md) |  |
**fulfillmentMethod** | **String** |  |
**paymentMethod** | **String** | Historical Vendor preference only. New quotations omit it; the Buyer chooses at acceptance. | [optional]
**fulfillmentDate** | **String** |  |
**delivery** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  | [optional]
**nrpc** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  | [optional]
**changes** | [**BuiltList&lt;ChatQuotationChange&gt;**](ChatQuotationChange.md) |  |
**originalChanges** | [**BuiltList&lt;ChatQuotationChange&gt;**](ChatQuotationChange.md) |  |
**priceSource** | **String** |  |
**processingFeeStatus** | **String** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


