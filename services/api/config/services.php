<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Third Party Services
    |--------------------------------------------------------------------------
    |
    | This file is for storing the credentials for third party services such
    | as Mailgun, Postmark, AWS and more. This file provides the de facto
    | location for this type of information, allowing packages to have
    | a conventional file to locate the various service credentials.
    |
    */

    'postmark' => [
        'token' => env('POSTMARK_TOKEN'),
    ],

    'ses' => [
        'key' => env('AWS_ACCESS_KEY_ID'),
        'secret' => env('AWS_SECRET_ACCESS_KEY'),
        'region' => env('AWS_DEFAULT_REGION', 'us-east-1'),
    ],

    'slack' => [
        'notifications' => [
            'bot_user_oauth_token' => env('SLACK_BOT_USER_OAUTH_TOKEN'),
            'channel' => env('SLACK_BOT_USER_DEFAULT_CHANNEL'),
        ],
    ],

    'google_oidc' => [
        'client_id' => env('GOOGLE_OIDC_CLIENT_ID'),
        'client_secret' => env('GOOGLE_OIDC_CLIENT_SECRET'),
        'redirect_uri' => env('GOOGLE_OIDC_REDIRECT_URI'),
        'authorization_endpoint' => 'https://accounts.google.com/o/oauth2/v2/auth',
        'token_endpoint' => 'https://oauth2.googleapis.com/token',
        'jwks_uri' => 'https://www.googleapis.com/oauth2/v3/certs',
    ],

    'recaptcha' => [
        'project_id' => env('RECAPTCHA_GOOGLE_CLOUD_PROJECT_ID'),
        'api_key' => env('RECAPTCHA_ENTERPRISE_API_KEY'),
        'timeout_seconds' => (int) env('RECAPTCHA_TIMEOUT_SECONDS', 5),
    ],

    'cloudinary' => [
        'cloud_name' => env('CLOUDINARY_CLOUD_NAME'),
        'api_key' => env('CLOUDINARY_API_KEY'),
        'api_secret' => env('CLOUDINARY_API_SECRET'),
        'asset_folder' => env('CLOUDINARY_ASSET_FOLDER', 'marketplace'),
    ],

    // Backend-only restricted key (Geocoding, Places API (New), Routes API). Android, iOS and browser keys are
    // separate client-restricted keys configured in each client's untracked native/build configuration.
    'google_maps' => [
        'server_api_key' => env('GOOGLE_MAPS_SERVER_API_KEY'),
        'timeout_seconds' => (int) env('GOOGLE_MAPS_TIMEOUT_SECONDS', 5),
        'places' => [
            'enabled' => (bool) env('GOOGLE_PLACES_ENABLED', true),
            'included_types' => array_values(array_filter(array_map('trim', explode(',', (string) env('GOOGLE_PLACES_INCLUDED_TYPES', 'hardware_store,home_improvement_store'))))),
            // Operational refresh target for permitted cached content; the database caps it at 30 days and a
            // shorter contractual limit in the current Google Maps Platform terms always prevails.
            'cache_ttl_hours' => (int) env('GOOGLE_PLACES_CACHE_TTL_HOURS', 168),
            'max_search_cells' => (int) env('GOOGLE_PLACES_MAX_SEARCH_CELLS', 121),
            'max_calls_per_day' => (int) env('GOOGLE_PLACES_MAX_CALLS_PER_DAY', 2000),
            'max_cache_records' => (int) env('GOOGLE_PLACES_MAX_CACHE_RECORDS', 20000),
        ],
        'routes' => [
            'routing_preference' => env('GOOGLE_ROUTES_ROUTING_PREFERENCE', 'TRAFFIC_AWARE'),
            'cache_ttl_minutes' => (int) env('GOOGLE_ROUTES_CACHE_TTL_MINUTES', 10),
            'max_calls_per_day' => (int) env('GOOGLE_ROUTES_MAX_CALLS_PER_DAY', 2000),
            'max_cache_records' => (int) env('GOOGLE_ROUTES_MAX_CACHE_RECORDS', 20000),
        ],
    ],

    'xendit' => [
        'mode' => strtoupper((string) env('XENDIT_MODE', 'TEST')),
        'secret_key' => env('XENDIT_SECRET_KEY'),
        'webhook_token' => env('XENDIT_WEBHOOK_VERIFICATION_TOKEN'),
        'base_url' => env('XENDIT_API_BASE_URL', 'https://api.xendit.co'),
        'timeout_seconds' => (int) env('XENDIT_TIMEOUT_SECONDS', 5),
        // Empty means platform-fee payments are collected by the master account itself (no for-user-id).
        'platform_account_id' => env('XENDIT_PLATFORM_ACCOUNT_ID'),
    ],

];
