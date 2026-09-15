<?php

return [
    'disk' => 's3',
    'simulated_scan' => env('VENDOR_TEST_SIMULATED_SCAN', false),
    'simulated_connection' => env('VENDOR_TEST_SIMULATED_CONNECTION', false),
    'maximum_file_bytes' => 10 * 1024 * 1024,
    'download_minutes' => 5,
    // Operational reminder policy; this is not a statutory deadline.
    'expiry_reminder_days' => (int) env('VENDOR_EXPIRY_REMINDER_DAYS', 30),
];
