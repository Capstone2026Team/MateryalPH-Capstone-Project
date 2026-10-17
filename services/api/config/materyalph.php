<?php

declare(strict_types=1);

return [
    'business_timezone' => env('BUSINESS_TIMEZONE', 'Asia/Manila'),
    'agreements' => [
        'content_path' => resource_path('agreements'),
        'privacy_contact' => env('PRIVACY_CONTACT_EMAIL', 'privacy@example.test'),
    ],
    'auth' => [
        'otp_ttl_minutes' => (int) env('EMAIL_OTP_TTL_MINUTES', 10),
        'otp_max_attempts' => (int) env('EMAIL_OTP_MAX_ATTEMPTS', 5),
        'otp_resend_seconds' => (int) env('EMAIL_OTP_RESEND_SECONDS', 60),
        'access_token_minutes' => (int) env('PASSPORT_ACCESS_TOKEN_MINUTES', 15),
        'refresh_token_days' => (int) env('PASSPORT_REFRESH_TOKEN_DAYS', 14),
        'mfa_challenge_ttl_minutes' => (int) env('MFA_CHALLENGE_TTL_MINUTES', 5),
        'mfa_challenge_max_attempts' => (int) env('MFA_CHALLENGE_MAX_ATTEMPTS', 5),
        'cookie_secure' => filter_var(env('COOKIE_SECURE', true), FILTER_VALIDATE_BOOL),
        'cookie_same_site' => env('COOKIE_SAME_SITE', 'lax'),
        'cookie_domain' => env('SESSION_DOMAIN'),
    ],
    'bot_protection' => [
        'enabled' => filter_var(env('RECAPTCHA_ENABLED', false), FILTER_VALIDATE_BOOL),
        'step_up_ttl_minutes' => (int) env('BOT_STEP_UP_TTL_MINUTES', 5),
        'site_keys' => [
            'WEB' => env('RECAPTCHA_VENDOR_WEB_SITE_KEY'),
            'ADMIN_WEB' => env('RECAPTCHA_ADMIN_WEB_SITE_KEY') ?: env('RECAPTCHA_VENDOR_WEB_SITE_KEY'),
        ],
        'allowed_identities' => [
            'WEB' => array_values(array_filter(array_map('trim', explode(',', (string) env('RECAPTCHA_VENDOR_WEB_ALLOWED_HOSTNAMES', 'localhost,127.0.0.1'))))),
            'ADMIN_WEB' => array_values(array_filter(array_map('trim', explode(',', (string) (env('RECAPTCHA_ADMIN_WEB_ALLOWED_HOSTNAMES') ?: env('RECAPTCHA_VENDOR_WEB_ALLOWED_HOSTNAMES', 'localhost,127.0.0.1')))))),
        ],
    ],
    'files' => [
        'disk' => env('VENDOR_PRIVATE_DISK', 'local'),
        'max_document_kb' => (int) env('VENDOR_DOCUMENT_MAX_KB', 10240),
        'max_media_kb' => (int) env('VENDOR_MEDIA_MAX_KB', 20480),
    ],
    'catalog' => [
        'max_listing_image_kb' => (int) env('CATALOG_LISTING_IMAGE_MAX_KB', 5120),
        'max_compliance_evidence_kb' => (int) env('CATALOG_COMPLIANCE_EVIDENCE_MAX_KB', 10240),
        'max_import_kb' => (int) env('CATALOG_IMPORT_MAX_KB', 2048),
    ],
    'demo' => [
        // Capstone demo Vendors (materyalph:demo-vendors-seed). Plus-addressed mailbox base, e.g. name@example.com -> name+matdemo01@example.com.
        'email_base' => env('DEMO_SEED_EMAIL_BASE', ''),
        'password' => env('DEMO_SEED_PASSWORD', ''),
        // Fetched (git-ignored) demo photos; empty means database/demo-assets/photos.
        'photo_directory' => env('DEMO_SEED_PHOTO_DIRECTORY', ''),
    ],
    'compliance_ocr' => [
        'driver' => env('COMPLIANCE_OCR_DRIVER', 'tesseract'),
        'binary' => env('COMPLIANCE_OCR_BINARY', 'tesseract'),
        'timeout_seconds' => (int) env('COMPLIANCE_OCR_TIMEOUT_SECONDS', 15),
    ],
    // DTI-BPS PS licensee and ICC certificate holder registers. The official sheets disable download,
    // so no feed is configured by default; set a URL only for a source the platform is authorized to read.
    'compliance_registers' => [
        'feeds' => [
            'PS_LICENSE' => env('COMPLIANCE_REGISTER_PS_FEED_URL', ''),
            'ICC_CERTIFICATE' => env('COMPLIANCE_REGISTER_ICC_FEED_URL', ''),
        ],
        'allowed_hosts' => env('COMPLIANCE_REGISTER_FEED_HOSTS', ''),
        'auto_activate' => (bool) env('COMPLIANCE_REGISTER_FEED_AUTO_ACTIVATE', false),
        'max_bytes' => 31_457_280,
        // The lists are updated monthly; a snapshot older than this is flagged as stale to Admins.
        'stale_after_days' => 45,
    ],
];
