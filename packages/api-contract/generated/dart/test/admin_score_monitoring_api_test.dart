import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for AdminScoreMonitoringApi
void main() {
  final instance = MateryalphApiClient().getAdminScoreMonitoringApi();

  group(AdminScoreMonitoringApi, () {
    // scores.investigate. Reversibly exclude one order (fraud, duplicate, test, invalid source) from later snapshots.
    //
    //Future<AdminScoreDetailEnvelope> excludeAdminScoreSource(String vendorId, String idempotencyKey, ScoreExclusionRequest scoreExclusionRequest) async
    test('test excludeAdminScoreSource', () async {
      // TODO
    });

    // scores.view. Components, sample sizes, windows, badge history, suppressions, exclusions and paginated source events.
    //
    //Future<AdminScoreDetailEnvelope> getAdminScore(String vendorId, { String metric, int page }) async
    test('test getAdminScore', () async {
      // TODO
    });

    // scores.investigate. Lift a suppression with a reason.
    //
    //Future<InvestigationAckEnvelope> liftAdminBadgeSuppression(String suppressionId, String idempotencyKey, InvestigationReasonRequest investigationReasonRequest) async
    test('test liftAdminBadgeSuppression', () async {
      // TODO
    });

    // scores.view (Super Admin, User Management Staff, Order and Dispute Staff).
    //
    //Future<AdminScoreListEnvelope> listAdminScores({ String q, int page }) async
    test('test listAdminScores', () async {
      // TODO
    });

    // scores.investigate. Reverse an exclusion with a reason.
    //
    //Future<InvestigationAckEnvelope> revokeAdminScoreExclusion(String exclusionId, String idempotencyKey, InvestigationReasonRequest investigationReasonRequest) async
    test('test revokeAdminScoreExclusion', () async {
      // TODO
    });

    // scores.investigate. Suppress a badge's display for a documented fraud or compliance case. Admins can never award a badge.
    //
    //Future<AdminScoreDetailEnvelope> suppressAdminBadge(String vendorId, String idempotencyKey, BadgeSuppressionRequest badgeSuppressionRequest) async
    test('test suppressAdminBadge', () async {
      // TODO
    });

  });
}
