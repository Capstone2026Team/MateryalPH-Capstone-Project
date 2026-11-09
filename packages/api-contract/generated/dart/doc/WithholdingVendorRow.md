# materyalph_api_client.model.WithholdingVendorRow

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**vendorId** | **String** |  |
**vendorName** | **String** |  |
**withholdingEntity** | **String** |  |
**assessmentCount** | **int** |  |
**withheldCentavos** | **int** |  |
**reviewRequired** | **int** |  |
**calculation** | [**WithholdingCalculation**](WithholdingCalculation.md) |  |
**filingIssues** | **BuiltSet&lt;String&gt;** | Specific source conditions behind review_required. These do not prevent reading the calculation; existing filing-package safeguards remain enforced separately. |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


