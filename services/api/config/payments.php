<?php

declare(strict_types=1);

/*
 * Non-secret payment runtime settings. Provider credentials stay in config/services.php (backend env only).
 * PAYMENT_GATEWAY selects the adapter: `xendit` uses Xendit TEST Payment Sessions; `fake` uses the
 * deterministic simulator whose evidence is always labeled SIMULATED and can never become XENDIT_TEST.
 */
return [
    'gateway' => env('PAYMENT_GATEWAY', 'xendit'),
    'environment' => 'TEST',
    // Payment Sessions accept an expiry no sooner than ten minutes ahead.
    'provider_minimum_expiry_seconds' => 600,
    // Platform-fee payment attempts expire after 45 minutes (FIN-03).
    'platform_fee_attempt_minutes' => 45,
    // After the Vendor confirms an online order the Buyer has this long to pay (Pending Payment). Changed from 45
    // minutes to 24 hours by the project owner; orders already waiting keep the deadline they were given.
    'order_window_hours' => max(1, (int) env('ORDER_PAYMENT_WINDOW_HOURS', 24)),
    // One provider checkout session lives this long (never past the order deadline). An abandoned or failed
    // session simply ends; the order stays Pending Payment and the Buyer can start a new one.
    'order_attempt_minutes' => 45,
    // Reminders sent to the Buyer this many hours before the deadline, once each.
    'order_reminder_hours' => [12, 1],
    // Reconcile a pending attempt with the provider when no verified event has arrived after this long.
    'reconcile_after_seconds' => 120,
    // An uncertain create is only treated as abandoned after the provider expiry plus this grace period.
    'uncertain_grace_minutes' => 15,
    'webhook_max_bytes' => 65536,
];
