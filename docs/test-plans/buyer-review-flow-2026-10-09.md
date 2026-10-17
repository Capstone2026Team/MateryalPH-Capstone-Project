# Buyer receipt and product-review flow

## Behavior

After a successful Confirm Receipt response reports `COMPLETED`, Order Details opens Review automatically. Back returns to the completed order. Revision approval, payment and failed receipt requests do not open ratings. Reviewing remains optional.

Review displays the purchased order items, individual Product Quality ratings, and a separate Vendor rating for Service Quality and Delivery Speed or Processing Speed. The submission preview shows actual ratings, comments, public identity and selected attachments. Comments retain the workflow's 1,000-character limit; Information Accuracy from the old prototype is not a rating criterion.

Each Product Review supports three attachments combined: JPG/PNG photos up to 10 MB each and MP4/MOV videos up to 100 MB each. Buyers can choose from their gallery, take a photo or record a video, preview and remove selections, and retry pending uploads after ratings have already saved. Every file has its own stable retry key. Existing attachments can be viewed and retired while editing is permitted. Android picker recovery associates a recovered file with the original order/line when Review is reopened.

The API validates detected MIME, extension and size, decodes photos using the existing validator, probes video structure/streams with a bounded FFmpeg process restricted to local files, and scans all media fail-closed before private storage. Review ownership, correction eligibility, blind reveal, active-dispute withholding and moderation still control access. Every add/remove appends a revision and audit record; retired commercial evidence is retained. Replayed uploads no longer create orphan files. Public product reviews display their authorized media through the same Buyer repository.

## Changed files

- Buyer navigation: `apps/buyer-mobile/lib/features/orders/order_details_screen.dart`.
- Review form, data and published media: `lib/features/trust/{order_reviews_screen,reviews_repository,trust_models,listing_reviews_section,review_media_section}.dart` under Buyer mobile.
- Shared Flutter controls: `lib/design_system/components/{star_rating,media_attachment_field}.dart`.
- Flutter dependencies/native metadata: Buyer `pubspec.yaml`, `pubspec.lock`, iOS `Runner/Info.plist`, and Flutter-generated desktop plugin registrants.
- Buyer transport checks/fakes: `test/reviews_repository_test.dart` and `test/trust_fakes.dart`.
- API: `services/api/app/Domain/Reviews/{ReviewMediaFiles,ReviewRules,ReviewService,ReviewPresenter,ReviewQueries}.php` and `app/Http/Controllers/Api/ReviewController.php`.
- API acceptance: `services/api/tests/Feature/Api/PhaseFourteenReviewsScoresTest.php` and the tiny synthetic blue-video fixture `tests/Fixtures/review-video.mp4`.
- Contract: `packages/api-contract/openapi.yaml`, `scripts/{generate-clients,check-trust-contract}.mjs`, regenerated TypeScript/Dart clients, and generated Dart serializers.
- Runtime: `infrastructure/docker/{api.Dockerfile,uploads.ini}`. FFmpeg is included; PHP permits 100 MB per file and 305 MB per multipart request. Endpoint-specific validation remains enforced.
- All four workflow documents record the revised review navigation/media behavior or audience handling.

No migrations or credential/key names were added. The existing Phase 14 review migration is confirmed Ran (batch 30). The local development API was rebuilt with `docker compose up -d --no-deps --build api`; its database setup dependency was excluded. It is healthy, contains `/usr/bin/ffprobe`, and reports the new PHP upload limits. No deployment, commit, Git command or development data mutation was performed.

## Verification

| Check | Result |
| --- | --- |
| Final `flutter analyze` | Passed; no issues |
| `flutter test test/reviews_repository_test.dart test/order_detail_contract_test.dart` | 5 passed; repository/contract tests only |
| Isolated API review + fulfillment suites | 18 passed; 780 assertions |
| Pint on affected PHP files and review acceptance test | Passed |
| Full API PHPStan (`--memory-limit=512M --no-progress`) | Passed; no errors |
| OpenAPI validation | Passed; three existing unused-model recommendations |
| Trust, fulfillment and orders contract scripts | Passed; 38 trust/analytics operations and 26 fulfillment operations checked |
| TypeScript/Dart regeneration and Dart build_runner | Passed |
| Generated TypeScript build | Passed |
| Admin typecheck | Passed |
| Vendor typecheck | Blocked by unrelated `PhaseThreeVendorPages.tsx:1122` TS6133: unused `StoreVehiclesEditor` |
| Compose configuration | Passed |
| Focused Gitleaks stdin scan of affected source/contract/runtime files | No leaks found; 1.37 MB scanned |
| Android debug APK (`flutter build apk --debug --dart-define-from-file=config/development.json`) | Passed; `build/app/outputs/flutter-apk/app-debug.apk` |
| Device, UI/E2E, iOS and live scanner/provider acceptance | Not run |

The first scanner-failure test used a replacement mock after the controller had already retained the original dependency. The corrected test overrides the original mock's default expectation; the final isolated suites passed. A parallel Flutter invocation had an asset-directory conflict; the subsequent repository/contract run passed. The APK build retains existing Gradle 8.14.0, AGP 8.11.1 and Kotlin 2.2.20 future-support warnings; no toolchain versions were changed. Git-based checks were excluded under the standing no-Git instruction.

## Manual phone checks

Restart the Buyer app with the README command so its new native plugins are installed:

```powershell
cd apps/buyer-mobile
flutter run -d 110013341G000422 --dart-define-from-file=config/development.json
```

1. Confirm receipt on an eligible Delivered or Picked Up order; Review should open only after the successful server response.
2. Check the purchased-item summary and choose the product and Vendor criteria. Self-Pickup uses Processing Speed.
3. Choose/capture a photo and video, preview them, and remove a selection. Deny permission and check the recoverable message.
4. Submit after reviewing the actual content. Interrupt an attachment upload and retry it; ratings and attachments must not duplicate.
5. Reopen the completed order to view/edit its review within the permitted window. Retire an attachment and confirm it disappears from current presentation.
6. Check blind reveal, a related active dispute and moderation withholding with authorized test accounts. Published review media should remain unavailable while withheld.

Implementation references: Flutter's [image_picker documentation](https://pub.dev/packages/image_picker), [video_player documentation](https://pub.dev/packages/video_player), and [FFprobe documentation](https://ffmpeg.org/ffprobe.html).

Suggested commit: `fix(buyer): open reviews after receipt and support captured review media`.
