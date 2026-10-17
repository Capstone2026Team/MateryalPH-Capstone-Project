# materyalph_api_client.model.SiteInspection

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**status** | **String** |  |
**lockVersion** | **int** |  |
**listing** | [**SiteInspectionListing**](SiteInspectionListing.md) |  |
**variant** | [**SiteInspectionVariant**](SiteInspectionVariant.md) |  |
**site** | [**SiteInspectionSite**](SiteInspectionSite.md) |  |
**preferredDate** | [**Date**](Date.md) |  |
**buyerNotes** | **String** | Shown only to the Buyer and the store's sales roles. |
**scheduledFor** | [**DateTime**](DateTime.md) |  |
**vendorNote** | **String** |  |
**measuredVolumeM3** | **String** | Three-decimal cubic meters once COMPLETED. |
**requestedAt** | [**DateTime**](DateTime.md) |  |
**closedAt** | [**DateTime**](DateTime.md) |  |
**free** | **bool** | Always true; inspections are never charged. |
**actions** | [**SiteInspectionActions**](SiteInspectionActions.md) |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


