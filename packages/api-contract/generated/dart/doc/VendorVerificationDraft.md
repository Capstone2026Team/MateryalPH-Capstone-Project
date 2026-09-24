# materyalph_api_client.model.VendorVerificationDraft

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**formState** | **String** | Encrypted unvalidated form progress as a JSON object of field names to string arrays. Saving progress does not submit or update review records. Sensitive identity numbers are omitted on read and merged server-side on final validation. | [optional]
**draftLockVersion** | **int** | Workstream draft version; zero on first save. Send together with the required organization guard. Omission retains legacy behavior without draft-level comparison. A stale draft returns 409 STALE_VERSION; a stale organization returns 409 RESOURCE_VERSION_CONFLICT. | [optional]
**lockVersion** | **int** |  |
**businessType** | **String** |  | [optional]
**registeredName** | **String** |  | [optional]
**legalBusinessName** | **String** |  | [optional]
**storeName** | **String** |  | [optional]
**dateEstablished** | [**Date**](Date.md) |  | [optional]
**storeEmail** | **String** |  | [optional]
**storePhone** | **String** |  | [optional]
**classification** | [**VendorVerificationDraftClassification**](VendorVerificationDraftClassification.md) |  | [optional]
**address** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) | New or changed addresses require province_code, city_code, psgc_code, street (2–200 characters), four-digit postal_code and canonical display names. source MANUAL is sufficient without geocoding or a token and stores null coordinates. Otherwise resolution_token from resolveVendorAddress is required. Client latitude and longitude are prohibited. Omit address to retain an existing record. | [optional]
**representative** | [**VendorVerificationDraftRepresentative**](VendorVerificationDraftRepresentative.md) |  | [optional]
**legalIdentity** | [**VendorVerificationDraftLegalIdentity**](VendorVerificationDraftLegalIdentity.md) |  | [optional]
**taxProfile** | [**VendorVerificationDraftTaxProfile**](VendorVerificationDraftTaxProfile.md) |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


