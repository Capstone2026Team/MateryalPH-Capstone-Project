<?php

declare(strict_types=1);

use App\Domain\Notifications\NotificationPolicy;
use App\Domain\Notifications\NotificationService;
use App\Models\User;
use Illuminate\Contracts\Console\Kernel;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

// Read-only diagnostics: never output tokens, credentials, identities or notification content.
require __DIR__.'/../services/api/vendor/autoload.php';
$app = require __DIR__.'/../services/api/bootstrap/app.php';
$app->make(Kernel::class)->bootstrap();

$credentialsValid = false;
$projectMatches = false;
try {
    $encoded = (string) config('notifications.firebase_credentials_base64');
    $path = (string) config('notifications.firebase_credentials');
    $json = $encoded !== '' ? base64_decode($encoded, true) : ($path !== '' && is_readable($path) ? file_get_contents($path) : false);
    $credentials = is_string($json) ? json_decode($json, true, flags: JSON_THROW_ON_ERROR) : [];
    $credentialsValid = ($credentials['type'] ?? null) === 'service_account'
        && is_string($credentials['client_email'] ?? null)
        && openssl_pkey_get_private($credentials['private_key'] ?? '') !== false;
    $projectMatches = ($credentials['project_id'] ?? null) === config('notifications.firebase_project_id');
} catch (Throwable) {
    // Only safe readiness booleans leave this process.
}

$schemaReady = Schema::hasTable('notification_devices') && Schema::hasTable('notification_delivery_attempts');
$summary = [
    'push_driver_fcm' => config('notifications.push_driver') === 'fcm',
    'firebase_credentials_valid' => $credentialsValid,
    'firebase_project_matches' => $projectMatches,
    'configuration_cached' => $app->configurationIsCached(),
    'notification_schema_ready' => $schemaReady,
    'queue_redis' => config('queue.default') === 'redis',
];
if ($schemaReady) {
    $summary['buyer_notifications'] = DB::table('notifications')->join('users', 'users.id', '=', 'notifications.user_id')->where('users.account_type', 'BUYER')->count();
    $summary['active_buyer_devices'] = DB::table('notification_devices')->join('users', 'users.id', '=', 'notification_devices.user_id')->where('users.account_type', 'BUYER')->whereNull('notification_devices.revoked_at')->where('environment', app()->environment())->count();
    $summary['push_deliveries_by_state'] = DB::table('notification_deliveries')->where('channel', 'PUSH')->selectRaw('state, count(*) AS total')->groupBy('state')->pluck('total', 'state')->all();
    $summary['pending_notification_outbox'] = DB::table('outbox_events')->whereIn('event_type', ['NOTIFICATION_READY', 'NOTIFICATION_DELIVERY', 'NOTIFICATIONS_CHANGED'])->whereNull('processed_at')->count();
    $visible = $unread = 0;
    $policy = app(NotificationPolicy::class);
    foreach (DB::table('notifications')->join('users', 'users.id', '=', 'notifications.user_id')->where('users.account_type', 'BUYER')->select('notifications.*')->cursor() as $notice) {
        $user = User::query()->find($notice->user_id);
        if ($user instanceof User && $policy->allows($user, $notice) && NotificationService::enabled($notice, 'in_app')) {
            $visible++;
            $unread += $notice->read_at === null ? 1 : 0;
        }
    }
    $summary['buyer_authorized_visible_notifications'] = $visible;
    $summary['buyer_authorized_unread_notifications'] = $unread;
}
echo json_encode($summary, JSON_PRETTY_PRINT | JSON_THROW_ON_ERROR).PHP_EOL;
