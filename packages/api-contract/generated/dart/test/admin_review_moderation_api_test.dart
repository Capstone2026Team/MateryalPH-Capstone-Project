import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for AdminReviewModerationApi
void main() {
  final instance = MateryalphApiClient().getAdminReviewModerationApi();

  group(AdminReviewModerationApi, () {
    // reviews.moderate. Review, media, flags, verified-purchase reference, related dispute, immutable revisions and moderation history.
    //
    //Future<ModerationDetailEnvelope> getAdminReviewModeration(String reviewId) async
    test('test getAdminReviewModeration', () async {
      // TODO
    });

    // reviews.moderate. Photo behind a signed link.
    //
    //Future<Uint8List> getAdminReviewPhoto(String reviewId, String mediaId, int expires, String signature) async
    test('test getAdminReviewPhoto', () async {
      // TODO
    });

    // reviews.moderate (Super Admin, User Management Staff). The Product Review Moderation Queue.
    //
    //Future<ModerationQueueEnvelope> listAdminReviewModeration({ String state, int page }) async
    test('test listAdminReviewModeration', () async {
      // TODO
    });

    // reviews.moderate. Dismiss Flag, Request Correction, Hide Pending Review, Remove or Restore, each with a reason and audit record; original content is preserved.
    //
    //Future<ModerationDetailEnvelope> moderateAdminReview(String reviewId, String idempotencyKey, ReviewModerationRequest reviewModerationRequest) async
    test('test moderateAdminReview', () async {
      // TODO
    });

  });
}
