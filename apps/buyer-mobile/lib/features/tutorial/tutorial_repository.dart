import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import '../../core/api_guard.dart';

abstract interface class TutorialRepository {
  Future<Map<String, String>> load();
  Future<void> acknowledge(String key, bool completed);
}

final class ApiTutorialRepository implements TutorialRepository {
  ApiTutorialRepository(
    api.MateryalphApiClient client,
    Future<void> Function() expired,
  ) : _api = client.getTutorialsApi(),
      _guard = ApiGuard(expired);
  final api.TutorialsApi _api;
  final ApiGuard _guard;

  @override
  Future<Map<String, String>> load() => _guard.call(() async {
    final response = await _api.getTutorialProgress(tutorialPortal: 'buyers');
    final data = _guard.required(response.data).data;
    return {for (final row in data) row.tutorialKey: row.status.name};
  });

  @override
  Future<void> acknowledge(String key, bool completed) => _guard.call(() async {
    await _api.acknowledgeTutorial(
      tutorialPortal: 'buyers',
      tutorialKey: key,
      tutorialAcknowledgment: api.TutorialAcknowledgment(
        (b) => b.status = completed
            ? api.TutorialAcknowledgmentStatusEnum.COMPLETED
            : api.TutorialAcknowledgmentStatusEnum.SKIPPED,
      ),
    );
  });
}
