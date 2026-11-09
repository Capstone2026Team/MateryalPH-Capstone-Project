<?php

declare(strict_types=1);

return [
    'commission_min_notice_days' => max(0, (int) env('COMMISSION_MIN_NOTICE_DAYS', 30)),
    'commission_reminder_enabled' => filter_var(env('COMMISSION_REMINDER_ENABLED', false), FILTER_VALIDATE_BOOL),
    'commission_reminder_days' => max(1, (int) env('COMMISSION_REMINDER_DAYS', 3)),
    'mode' => env('FINANCE_MODE'),
    'withholding_scenario' => env('WITHHOLDING_SCENARIO'),
    'platform_tax_profile' => env('PLATFORM_TAX_PROFILE'),
    'live_commerce_enabled' => filter_var(env('LIVE_COMMERCE_ENABLED', false), FILTER_VALIDATE_BOOL),
    // Installed in Phase 14; the flag remains an operational kill switch for every analytics entry point.
    'materials_analytics_enabled' => in_array(env('MATERIALS_ANALYTICS_ENABLED'), [null, ''], true) || filter_var(env('MATERIALS_ANALYTICS_ENABLED'), FILTER_VALIDATE_BOOL),
    'demo_dataset' => [
        'id' => env('DEMO_DATASET_ID'),
        'label' => env('DEMO_DATASET_LABEL'),
        'as_of' => env('DEMO_DATASET_AS_OF'),
    ],
];
