# materyalph_api_client.model.ComplianceExtraction

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**source_** | **String** |  | [optional]
**provider** | **String** | Extraction provenance, such as TESSERACT, NONE or BROWSER_QR_DECODER. Null for manual entry. | [optional]
**status** | **String** |  |
**confidence** | **num** | Mean OCR word recognition confidence; never a probability of authenticity or approval. | [optional]
**suggestions** | **BuiltMap&lt;String, String&gt;** | Editable marking_type, certificate_number (the PS License No. or ICC sticker serial), icc_certificate_number, verification_reference, manufacturer_name, manufacturer_address, importer_name, importer_address, country_of_manufacture, brand and batch_number where read unambiguously. PNS standard numbers are never marking numbers. |
**registerListed** | **bool** | True when the suggested certificate_number exists in the active DTI-BPS register snapshot. Still a suggestion: the Vendor confirms it against the physical marking. | [optional]
**assistanceOnly** | **bool** | Always true. The Vendor must review and confirm values before a separate official-register comparison or Admin decision. | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


