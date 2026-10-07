<?php

return [
    'push_driver' => env('NOTIFICATION_PUSH_DRIVER', 'fcm'),
    'firebase_credentials' => env('GOOGLE_APPLICATION_CREDENTIALS'),
    'firebase_credentials_base64' => env('FIREBASE_SERVICE_ACCOUNT_JSON_BASE64'),
    'firebase_project_id' => env('FIREBASE_PROJECT_ID'),
    'web_push_approved' => env('WEB_PUSH_APPROVED', false),
];
