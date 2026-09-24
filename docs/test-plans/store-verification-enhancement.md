# Store Verification enhancement implementation and verification

Implemented 21 September 2026 against [the supplied enhancement brief](../workflows/Store_Verification_Enhancement.md) and [the final system workflow](../workflows/MateryalPH_Final_System_Workflow.md). The user explicitly approved requiring an Admin Authority to Act decision for every organizational representative, using existing registration evidence or a separate authority document.

## Outcome and scope

Store Verification has four steps: Business Information; Registered Business Address; Supplier Type / Classification; Privacy, Review and Submit. Tax Information, BIR evidence, the optional Sworn Declaration and representative evidence are inside Business Information. Standalone onboarding, Finish Later, Store Setup and activation gates remain available.

Business types distinguish sole proprietorship, partnership, corporation, OPC and cooperative. Individual and corporate legal identities remain distinct from the public Store Name. The verified Store Email remains effective until its replacement passes email OTP. Store Phone has optional Owner prefill and no SMS OTP.

Core TIN accepts exactly nine numeric digits and remains encrypted and masked on reads. Branch Code accepts three or five numeric digits, including explicit Head Office zero codes. VAT remains declared until Admin verification. A BIR-received Sworn Declaration requires an explicit claim, taxable year and PDF evidence; upload does not grant relief or change the existing DEMO withholding rules.

The three supplier types use 27 canonical niches. Other Category uses a separate custom label. Equipment and vehicle rental classifications remain unsupported. Address lookup retains manual structured fields and ignores stale lookup responses.

## Changed implementation files

- Vendor: `PhaseThreeVendorPages.tsx`, `OnboardingFlow.tsx`, `onboarding-steps.ts`, `onboarding-api.ts`, `VendorNavigation.test.tsx` and `e2e/onboarding-steps.spec.ts`.
- Admin: `PhaseThreeAdminPages.tsx` adds representative details, evidence selection and explicit authority scopes to requirement review.
- API: `VendorOnboardingService.php`, `AdminVendorVerificationService.php`, the Vendor draft and Admin decision requests, `AppServiceProvider.php`, `config/services.php` and `.env.example`.
- New services: `VendorAuthorityService.php`, `VendorFileScanner.php`, `PublicStoreMediaStorage.php` and `CloudinaryPublicStoreMediaStorage.php`.
- Contract: `packages/api-contract/openapi.yaml`, its onboarding contract check, and regenerated TypeScript/Dart models and serializers.
- Migration: `2026_09_21_000000_enhance_store_verification.php`; adds representative versions, authority reviews and encrypted verification change history, plus representative references on tax versions and agreement acceptances. Existing records are retained. Applied successfully to the confirmed development environment, batch 3; also exercised from an empty isolated test database.

## API and authorization

Existing `/api/v1` endpoints are extended. Verification drafts accept representative details, numeric TIN/Branch Code, branch length, Head Office and declaration year. Document uploads accept representative identity front/back, authority evidence, individual ID back and optional certification. Admin decisions accept an evidence version and the supported `TAX_DECLARATIONS`, `COMMISSION_AGREEMENT` and `PAYMENT_CONFIGURATION` scopes.

Snapshots include the current Privacy Notice, masked representative information, current document versions and correction reasons. Private evidence is restricted to the owning Vendor's authorized accounts and authorized Admin reviewers, with authenticated short-lived URLs. Scanning fails closed. Only public Store media goes to Cloudinary; tax, identity and authority evidence stays on the configured private disk. The Cloudinary adapter uses the [official server upload API](https://cloudinary.com/documentation/upload_images).

Account membership does not establish legal authority. Under the existing account model, the Owner may prepare and submit organizational evidence before authority approval. Final attestations require the current Owner-linked representative and explicit Admin approval for the applicable scope. A representative who is not linked to the Owner does not gain a new signatory login through this enhancement.

Representative and authority records are immutable. Replacement evidence retains its previous versions; replacing the representative or relevant evidence reopens authority review. Stale Admin decisions with a prior step lock version are rejected. Legal, address and tax changes reopen related requirements; ordinary public Store Name changes preserve unrelated approvals. Notifications and audit events use the existing mechanisms.

## Automated results

| Check | Result |
| --- | --- |
| Full isolated Laravel suite | 126 passed; 1,469 assertions |
| Final onboarding API suite after supplier and review-dependency refinements | 32 passed; 302 assertions |
| Laravel Pint, whole API | Passed |
| PHPStan with `--memory-limit=512M --no-progress` | Passed; default 128 MB initially exhausted runner memory |
| Vendor lint, strict TypeScript, Vitest and production build | Passed; 63 tests in 9 files |
| Admin lint, strict TypeScript, Vitest and production build | Passed; 16 tests in 8 files |
| Playwright onboarding sections | 16 passed across 320, 375, 390, 768, 1024, 1280, 1440 and 1920 pixels |
| OpenAPI validation | Passed with three existing unused-schema recommendations |
| Vendor/Admin contract | 26 operations matched Laravel routes; private field and authority schema checks passed |
| Generated TypeScript client build | Passed |
| Dart serializer generation | Passed |
| Dart analyzer | Five existing generator warnings; four unused imports and one raw BuiltMap type, no new analyzer errors |
| Development and isolated test Compose configuration | Passed |
| Gitleaks working-tree diff and new Vendor/storage/migration source | No leaks found |
| Git whitespace check | Passed |

Browser tests use synthetic data and fake API responses. The initial run had an ambiguous Core TIN locator; the corrected run passed. A Windows preview teardown hang was resolved by rerunning against the already running previews. Visual evidence: [desktop](../design/evidence/store-verification-enhancement/business-desktop.png), [mobile](../design/evidence/store-verification-enhancement/business-mobile.png).

## Setup and limits

Existing keys were retained. Required names are `GOOGLE_MAPS_SERVER_API_KEY`, `VITE_GOOGLE_MAPS_BROWSER_KEY`, `CLOUDINARY_CLOUD_NAME`, `CLOUDINARY_API_KEY`, `CLOUDINARY_API_SECRET`, `FILESYSTEM_DISK`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_BUCKET`, `AWS_ENDPOINT` and `AWS_USE_PATH_STYLE_ENDPOINT`. Backend credentials never belong in Vite configuration. ClamAV and a current signature database are required by the existing scanner. A published current Privacy Notice is required before submission.

No live Cloudinary upload, Google geocode or private MinIO transfer was performed with user data; adapter behavior was tested with fakes. Provider configuration presence does not prove live connectivity. Existing private Store media remains usable; new public uploads use Cloudinary when configured. No deployment, push, merge or credential rotation was performed.

Suggested commit: `feat(onboarding): enhance store verification and combine business tax information`
