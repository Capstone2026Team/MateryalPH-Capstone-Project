# Xendit TEST sub-account connection

The Vendor Owner requests a platform-controlled TEST Owned sub-account for simulated payments. Xendit requires an email field in `POST /v2/accounts`; MateryalPH uses the verified Store Email when available, otherwise the authenticated Owner email. No Vendor invitation, Xendit login, or partner registration link is used in TEST. The Vendor's actual MateryalPH Business Type is unchanged. LIVE Managed merchant onboarding remains a separate future workflow.

## Provider flow

The authenticated, CSRF-protected and throttled `POST /api/v1/vendors/onboarding/payment-connection` requires an `Idempotency-Key`, Owner permission and current PAYMENT_CONFIGURATION authority. The backend calls `POST https://api.xendit.co/v2/accounts` with the server-only TEST key, `type=OWNED`, the trusted store name and the selected account email. Browser-supplied account IDs and URLs are rejected.

The backend validates a successful response's account ID, Owned type, email, store name and status. It saves the association as PENDING, then performs a separate `GET /v2/accounts/{id}`. Only an authoritative `LIVE` GET result marks `CONNECTED_TEST` and completes the setup requirement. The Owner can choose **Check account status** if it remains pending. An existing confirmed association is reused. The card shows a TEST indicator and optional masked account suffix, never the full ID or credential.

## Recovery and audit

The organization row is locked while reserving `onboarding_requested_at`; no lock spans the provider call. Concurrent requests cannot create duplicate accounts. Explicit HTTP 400/401/403/404/409/422/429 rejection releases the reservation and offers **Try again**. A 409 may indicate an email conflict; the UI does not claim a specific cause without provider evidence. A timeout, server error, or invalid successful response retains the reservation because creation may have succeeded. Another create is blocked until that attempt is investigated. An account is never marked connected from a browser ID, webhook log screenshot, or unconfirmed create response.

Creation attempts, failures, account association and status changes are audited without provider payloads, email addresses or credentials. Only an allowlisted provider error code, HTTP status and validated request ID can be included in failure audit metadata. Missing TEST credentials, LIVE mode/keys and alternate API origins fail closed. `XENDIT_PUBLIC_KEY` is not used for this operation.

The existing webhook endpoint supports legacy Managed account events but TEST completion uses the authoritative GET. Xendit states that Account Updated webhooks and sub-account login or activation are unavailable in TEST. Existing associated Managed accounts can still be reconciled; new TEST accounts are Owned. Webhook log entries alone do not establish an account association.

## Configuration and limits

Server-only settings: `XENDIT_MODE=TEST`, `XENDIT_SECRET_KEY`, `XENDIT_API_BASE_URL=https://api.xendit.co` and `XENDIT_TIMEOUT_SECONDS`. `XENDIT_WEBHOOK_VERIFICATION_TOKEN` is optional for this TEST flow. No secret values are changed. The associated ID can later be used by backend TEST transactions through Xendit's `for-user-id` mechanism. Orders, Messages and Fulfillment assignment behavior is unchanged.

**DEMO — No real funds or BIR filing.** A TEST connection does not establish production KYC, BIR registration, statutory withholding compliance or government approval. It does not activate LIVE merchant payments.

## Provider evidence reviewed 25 September 2026

- [v2 account creation and Owned response](https://docs.xendit.co/apidocs/create-account)
- [v2 account retrieval](https://docs.xendit.co/apidocs/get-account)
- [TEST feature availability](https://docs.xendit.co/docs/testing-xenplatform-features)
- [Unique Managed invitation link is copied from the dashboard](https://help.xendit.co/hc/en-us/articles/4408655256589-How-Do-I-Create-A-Sub-Account-on-XenPlatform)

Previous live attempts to create a v3 TEST account returned HTTP 403 `DISALLOWED_OPERATION`; v2 Managed attempts returned HTTP 403 and 409. The two `account.updated` user IDs visible in the supplied Xendit screenshots each returned HTTP 404 through `GET /v2/accounts/{id}` using the configured TEST key. Neither webhook screenshot proved this Vendor had an associated TEST account. After the Owned path was implemented, the current Vendor page showed a saved `CONNECTED_TEST/LIVE` account; a fresh read-only GET for that exact backend-associated ID returned `LIVE/OWNED`. No additional account was created during that verification. TEST payment transactions and LIVE merchant onboarding remain unverified.
