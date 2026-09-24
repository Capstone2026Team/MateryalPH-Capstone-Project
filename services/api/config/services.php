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
    ],

    'google_maps' => [
        'server_api_key' => env('GOOGLE_MAPS_SERVER_API_KEY'),
        'timeout_seconds' => (int) env('GOOGLE_MAPS_TIMEOUT_SECONDS', 5),
    ],

    'xendit' => [
        'mode' => env('XENDIT_MODE', 'TEST'),
        'secret_key' => env('XENDIT_SECRET_KEY'),
        'webhook_token' => env('XENDIT_WEBHOOK_VERIFICATION_TOKEN'),
        'base_url' => env('XENDIT_API_BASE_URL', 'https://api.xendit.co'),
        'timeout_seconds' => (int) env('XENDIT_TIMEOUT_SECONDS', 5),
    ],

];
