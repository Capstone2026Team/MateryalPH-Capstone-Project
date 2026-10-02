<?php

declare(strict_types=1);

// Read-only readiness summary. Never output users, message content, env values or credentials.
require __DIR__.'/../services/api/vendor/autoload.php';
$app = require __DIR__.'/../services/api/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();
$db = Illuminate\Support\Facades\DB::class;
$duplicates = $db::selectOne("SELECT count(*) AS groups, coalesce(sum(n - 1), 0) AS legacy_threads FROM (SELECT count(*) AS n FROM conversations WHERE purpose = 'SALES' AND context_type = 'ITEM_BASED' GROUP BY buyer_profile_id, vendor_organization_id HAVING count(*) > 1) duplicates");
echo json_encode([
    'duplicate_groups' => (int) $duplicates->groups,
    'legacy_threads_to_link' => (int) $duplicates->legacy_threads,
    'reverb_enabled' => config('broadcasting.default') === 'reverb',
    'reverb_key_configured' => (bool) config('broadcasting.connections.reverb.key'),
    'reverb_secret_configured' => (bool) config('broadcasting.connections.reverb.secret'),
    'reverb_host_configured' => (bool) config('broadcasting.connections.reverb.options.host'),
    'reverb_configuration_cached' => $app->configurationIsCached(),
    'reverb_credentials_match_file' => hash_equals((string) config('broadcasting.connections.reverb.secret'), (string) (Dotenv\Dotenv::parse(file_get_contents(__DIR__.'/../services/api/.env'))['REVERB_APP_SECRET'] ?? '')),
    'migration_applied' => $db::table('migrations')->where('migration', '2026_10_06_000000_improve_store_conversations')->exists(),
], JSON_PRETTY_PRINT | JSON_THROW_ON_ERROR).PHP_EOL;
