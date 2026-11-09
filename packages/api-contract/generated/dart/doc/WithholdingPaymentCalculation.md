# materyalph_api_client.model.WithholdingPaymentCalculation

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**orderReference** | **String** |  |
**grossBasisCentavos** | **int** |  |
**rateBasisPoints** | **int** | Saved effective rate. 50 basis points means 0.5%; zero may reflect approved relief. |
**withheldCentavos** | **int** | Original tax amount rounded half-up per assessment; never recomputed after later refunds. |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


