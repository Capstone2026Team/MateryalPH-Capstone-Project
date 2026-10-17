import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for AdminPlatformSettingsApi
void main() {
  final instance = MateryalphApiClient().getAdminPlatformSettingsApi();

  group(AdminPlatformSettingsApi, () {
    // platform_settings.view. Append-only versions with previous value, reason, actor role and correlation ID.
    //
    //Future<PlatformSettingHistoryEnvelope> listPlatformSettingHistory(String key) async
    test('test listPlatformSettingHistory', () async {
      // TODO
    });

    // platform_settings.view. Every approved non-secret default with its current version, validation rule and previous value, plus the fixed references that have no control.
    //
    //Future<PlatformSettingListEnvelope> listPlatformSettings() async
    test('test listPlatformSettings', () async {
      // TODO
    });

    // platform_settings.manage with recent re-authentication. Writes a new version; consuming rules apply it to new records only.
    //
    //Future<PlatformSettingEnvelope> updatePlatformSetting(String key, PlatformSettingUpdateRequest platformSettingUpdateRequest) async
    test('test updatePlatformSetting', () async {
      // TODO
    });

  });
}
