# Render staging audit — 2026-10-20

The owner requested deployment repairs while keeping every existing Render plan Free. This record separates verified code checks from live-provider and authenticated acceptance.

## Confirmed faults and repairs

- Admin bot assessment lacked `RECAPTCHA_GOOGLE_CLOUD_PROJECT_ID`. The existing Google API/site keys matched the portals. Both keys reached Google and rejected a synthetic invalid token after restoring the public project metadata. No credential was rotated or copied from development.
- The imported database contained unreadable encrypted values beyond the previously repaired authenticator records. The additive `2026_10_20_000000_create_imported_encrypted_values` migration supports staging-key recovery copies without updating original immutable records. Canonical taxpayer aliases preserve existing cumulative withholding groups. See [the recovery procedure](../security/staging-import-recovery.md).
- Portal reads timed out after 30 seconds while Free compute could still be waking. Both Render portal builds now configure a bounded 90-second read deadline. Cancellation remains effective and business mutations are never automatically replayed.
- The services were running different commits with automatic deployment disabled. The release procedure validates all four targets and deploys one explicit staging SHA, with API migrations before dependent services.
- Six Vendor order tests retained older UI/permission expectations. Their assertions now cover current controls and omit Customer Service discount authority. Buyer formatting and the motion-token generator were aligned with the formatting gate without changing application behavior.

## Live release and recovery

The API, Reverb, Vendor and Admin services are all live on repair commit `04c9c28a49cdda4f94b22a975c7967f5cbccf05e`. Existing Free plans and disabled automatic deployments were preserved.

| Service | Verified live deployment |
| --- | --- |
| API | `dep-dbbbuj8n74is73a1nqs0` |
| Reverb | `dep-dbbc01jbc2fs73akppl0` |
| Vendor | `dep-dbbc0ts9v7es73em4pf0` |
| Admin | `dep-dbbc0v0m7kps73ee8d7g` |

The migration was applied during guarded API startup. The maintenance transaction verified **120 source-encrypted values**, inserted **94 unique recovery entries**, reused 26 identical ciphertext entries, and modified **zero original source records**. A separate read-only check confirmed all 120 values are readable through staging-key recovery, all 39 authenticator records remain staging-readable, and no migrations remain pending. Four imported device tokens were excluded deliberately. The source key was never deployed. Temporary single-operator-IP database access was removed after each operation; external access is disabled again.

Live public HTTP checks passed for health, unauthenticated-session denial, SPA login routes, secure host-only CSRF cookies, preserved POST requests, missing-CSRF rejection and exact-origin credentialed CORS. Both deployed JavaScript bundles contain the configured cold-start deadline. These checks did not sign in or send email. Recent live errors still confirm inaccessible storage metadata and failed-closed upload scanning, consistent with the integration blockers below.

## Checks actually run

| Check | Result |
| --- | --- |
| Vendor lint, typecheck, full tests, production build | Passed; 609 tests |
| Admin lint, typecheck, full tests, production build | Passed; 138 tests |
| Recovery, Vendor onboarding, withholding and finance regression suites in a separate isolated PostgreSQL project | Passed; 161 tests, 2,101 assertions |
| PHPStan | Passed |
| Pint | Passed |
| Flutter analysis | Passed; no issues |
| Full Buyer Flutter tests | Failed; 468 passed, 66 failed, one skipped |
| Buyer Dart formatting | Passed; 251 files, no remaining changes |
| Design-token generation check | Passed |
| OpenAPI validation | Passed; eight existing unused-model recommendations |
| TypeScript client generation/build and Dart serializer generation | Passed; no generated API-client differences |
| Render schema, staging boundaries, secret references and workflow YAML | Passed |
| Changed/new-file secret scan and whitespace check | Passed |
| Full API regression suite | Failed; 643 tests, 12,630 assertions, 16 failures |

The full API run first exhausted its 128 MB test-runner memory limit, then completed at 512 MB. Its remaining failures concern older catalog-role, explicit-payment, support-throttle, geographic-fixture and Project comparison expectations. Buyer failures span navigation, procurement, quotation, layout and golden assertions; they have not all been diagnosed. These failures remain open; focused repair coverage does not make either full suite green. No production authorization, payment choice, privacy threshold or commercial rule was relaxed to satisfy an older assertion.

## Required services and acceptance still outstanding

**Follow-up:** the owner subsequently asked to use the existing local provider credentials. Maps, Cloudinary, Xendit TEST and native Firebase were configured and the API redeployed. A later owner-created private Backblaze staging bucket and scoped key passed signed S3 and Laravel adapter checks. Brevo SMTP authentication also passed with mandatory TLS; the owner-confirmed sender and mail settings were saved in Render with a fresh historical-mail cutoff. See [current provider setup and remaining steps](provider-setup.md) for deployment evidence. The paragraph below records what was absent at the initial audit; historical file-object migration, mailbox delivery acceptance, scanning and browser-push setup remain outstanding.

At the initial audit, no separate staging provider credential file was found, and the cloud API lacked backend maps, private object storage, Cloudinary, mail, Xendit TEST and Firebase configuration. The local storage endpoint belongs to development MinIO, and local Gmail SMTP cannot provide delivery from Free Render compute. Development credentials must not be silently reused in staging.

Configure the actual staging services through cloud secret fields or an ignored staging file: `GOOGLE_MAPS_SERVER_API_KEY`; private-storage `AWS_*` settings; `CLOUDINARY_*`; a mail transport supported by Free compute; `XENDIT_SECRET_KEY` with a TEST credential and the configured webhook verification secret; and `FIREBASE_PROJECT_ID`/`FIREBASE_SERVICE_ACCOUNT_JSON_BASE64`. Use the exact names in [the staging setup guide](render-staging.md) and API `.env.example`.

Private-file uploads remain fail-closed until a scanner with sufficient resources is reachable. The current 512 MB Free API cannot reliably run ClamAV. Free compute also sleeps, and its colocated worker/scheduler is unavailable while asleep. These constraints prevent a claim that every feature is working on the present topology. No paid service was enabled, no scan/authentication bypass was added, and failed jobs/provider events were not replayed.

Imported devices require fresh registration, and imported sessions/recovery-code hashes require the existing fresh-sign-in and regeneration flows. Restoring database decryption does not restore uploaded objects that were never copied to reachable private storage.

Live health/CSRF/CORS checks, authenticated Admin/Vendor journeys, private-file authorization, actual mail delivery, provider TEST callbacks, map APIs and native-device acceptance must be reported separately. Buyer remains a native Flutter app and is not hosted as a Render site.
