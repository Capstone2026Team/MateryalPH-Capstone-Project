# Staging import encryption recovery

The staging database was copied from development. Its encrypted onboarding, representative, tax, order, payment and notification values therefore use the source encryption key. Staging has a separate `APP_KEY`. Authenticator records were repaired separately; repairing only those records does not make the rest of the imported database readable.

`IMPORTED_DATA_RECOVERY_ENABLED=true` enables an internal compatibility reader only in `staging` and `testing`. It has no effect in production. New encryption and Passport key derivation continue to use the staging key. The source key is never uploaded to Render or added to `APP_PREVIOUS_KEYS`.

An authorized local maintenance operation decrypts explicitly allowed stored columns with the local source key, validates the plaintext, re-encrypts it with the existing staging key, and inserts an `imported_encrypted_values` record. No original record is updated. This preserves immutable representative versions, verification history, commercial snapshots, recorded statuses and replay counters. Source ciphertexts are addressed by their SHA-256 fingerprint; the recovery ciphertext remains authenticated encryption under the staging key. No plaintext, source key or provider payload is placed in audit logs.

The reader first attempts ordinary Laravel decryption. On a MAC/decryption failure it performs one exact fingerprint lookup and one ordinary decryption of the recovered value. Unknown, modified and corrupt values fail closed. Recovery entries are append-only and have no client API. Existing endpoint authorization and private-file access controls remain authoritative.

Tax-profile recovery entries can also retain the original canonical TIN/taxpayer hash and its staging-key alias. New versions of an imported taxpayer retain the existing withholding identity rather than creating a new cumulative group after an environment-key change. Lookup aliases are themselves keyed hashes; no plaintext tax identifier is indexed. Commission, withholding rates, thresholds and sticky yearly treatment are unchanged.

The maintenance operation must use the verified staging workspace/database, an explicit column allowlist, one transaction, source row locks, an import-batch audit entry, and plaintext round-trip checks. Conflicting identity aliases or an unknown source key abort the batch. If temporary database access is needed, restrict it to the operator's single IP and restore the previous allowlist afterward.

Imported device tokens are intentionally excluded: devices register with the configured staging Firebase project again. Old jobs, messages, webhooks and payments are never replayed merely because their stored data became readable. Imported recovery codes and sessions require the existing fresh sign-in/regeneration flows.

The registry does not repair absent uploaded objects or provision third-party services. Render Free still requires externally hosted private storage, a supported mail transport and provider credentials. Scan-dependent uploads remain unavailable until a fail-closed scanner with sufficient resources is reachable; do not disable scanning to make the preview appear functional.
