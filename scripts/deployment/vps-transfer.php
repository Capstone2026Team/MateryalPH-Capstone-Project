<?php

declare(strict_types=1);

use Illuminate\Contracts\Console\Kernel;
use Illuminate\Encryption\Encrypter;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

/** Deployment-only recovery helper. No controller or client can invoke it. */
function recoveryKey(string $key): string
{
    $key = trim($key);
    if (preg_match('/\A[A-Za-z0-9+\/]{43}=\z/', $key)) {
        $key = 'base64:'.$key;
    }
    $raw = str_starts_with($key, 'base64:') ? base64_decode(substr($key, 7), true) : $key;
    if (! is_string($raw) || strlen($raw) !== 32) {
        throw new RuntimeException('RECOVERY_KEY_INVALID');
    }

    return $raw;
}

function recoveryObjectKey(string $key): void
{
    if ($key === '' || str_contains($key, '\\') || str_contains($key, "\0") || str_starts_with($key, '/') || str_contains($key, ':') || preg_match('#(?:^|/)\.\.(?:/|$)#', $key)) {
        throw new RuntimeException('OBJECT_KEY_INVALID');
    }
}

/** @return array<string, mixed> */
function recoveryVerify(string $directory): array
{
    $manifest = json_decode((string) file_get_contents($directory.'/manifest.json'), true, flags: JSON_THROW_ON_ERROR);
    if (is_link($directory.'/manifest.json') || ($manifest['format'] ?? '') !== 'materyalph-recovery-v1' || ($manifest['postgres_major'] ?? 0) !== 16
        || ! preg_match('/\A[a-f0-9]{64}\z/', $manifest['target_key_sha256'] ?? '') || ! is_int($manifest['database_bytes'] ?? null)
        || ! is_array($manifest['table_counts'] ?? null) || ! is_array($manifest['objects'] ?? null) || is_link($directory.'/objects')) {
        throw new RuntimeException('MANIFEST_FORMAT_INVALID');
    }
    foreach (['mail_delivery_not_before', 'outbox_delivery_not_before'] as $boundary) {
        if (! is_string($manifest[$boundary] ?? null) || ! preg_match('/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?Z\z/', $manifest[$boundary])) {
            throw new RuntimeException('MANIFEST_BOUNDARY_INVALID');
        }
    }
    foreach ($manifest['table_counts'] as $table => $count) {
        if (! preg_match('/\A[a-z][a-z0-9_]*\z/', $table) || ! is_int($count) || $count < 0) {
            throw new RuntimeException('MANIFEST_COUNTS_INVALID');
        }
    }
    foreach (['database.dump' => $manifest['database_sha256'] ?? '', 'recovery.jsonl' => $manifest['recovery_sha256'] ?? ''] as $name => $hash) {
        if (! preg_match('/\A[a-f0-9]{64}\z/', $hash) || is_link($directory.'/'.$name) || ! hash_equals($hash, (string) hash_file('sha256', $directory.'/'.$name))) {
            throw new RuntimeException('RECOVERY_CHECKSUM_FAILED');
        }
    }
    foreach ($manifest['objects'] as $object) {
        recoveryObjectKey($object['key']);
        if (! in_array($object['disk'], ['s3', 'local', 'public'], true) || ! preg_match('/\A[a-f0-9]{64}\z/', $object['sha256'])) {
            throw new RuntimeException('MANIFEST_OBJECT_INVALID');
        }
        $path = $directory.'/objects/'.$object['sha256'];
        if (is_link($path) || ! hash_equals($object['sha256'], (string) hash_file('sha256', $path)) || filesize($path) !== $object['bytes']) {
            throw new RuntimeException('RECOVERY_OBJECT_CHECKSUM_FAILED');
        }
    }

    return $manifest;
}

/** @return array<string, int> */
function recoveryCounts(): array
{
    $counts = [];
    foreach (DB::select("SELECT tablename FROM pg_tables WHERE schemaname='public' ORDER BY tablename") as $table) {
        if (! preg_match('/\A[a-z][a-z0-9_]*\z/', $table->tablename)) {
            throw new RuntimeException('TABLE_IDENTIFIER_INVALID');
        }
        $counts[$table->tablename] = DB::table($table->tablename)->count();
    }

    return $counts;
}

/** @return array<string, list<string>> */
function recoveryColumns(): array
{
    return [
        'totp_factors' => ['encrypted_secret'],
        'account_factor_replacements' => ['encrypted_secret'],
        'buyer_locations' => ['site_instructions_encrypted'],
        'carts' => ['access_instructions_encrypted'],
        'orders' => ['access_instructions_encrypted'],
        'payments' => ['checkout_url_encrypted'],
        'webhook_events' => ['payload_encrypted'],
        'fulfillment_proofs' => ['receiver_name_encrypted'],
        'notification_deliveries' => ['sealed_recipient'],
        'vendor_onboarding_drafts' => ['payload_encrypted'],
        'vendor_payment_accounts' => ['invitation_url_encrypted'],
        'vendor_organizations' => ['identity_id_number_encrypted'],
        'vendor_representative_versions' => ['details_encrypted'],
        'vendor_tax_profile_versions' => ['taxpayer_key_encrypted', 'tin_encrypted'],
        'vendor_verification_change_history' => ['snapshot_encrypted'],
        'vendor_verification_changes' => ['snapshot_encrypted'],
        'order_invoice_details' => ['tin_encrypted'],
        'site_inspection_requests' => ['buyer_notes_encrypted'],
    ];
}

/** Creates target-key recovery ciphertext locally; the development key never leaves this process. */
function recoveryPrepareEncryption(string $directory, Encrypter $target, string $targetTextKey): void
{
    if (DB::table('imported_encrypted_values')->exists()) {
        throw new RuntimeException('SOURCE_RECOVERY_REGISTRY_REQUIRES_REVIEW');
    }
    $allowed = recoveryColumns();
    foreach (DB::select("SELECT table_name,column_name FROM information_schema.columns WHERE table_schema='public' AND (column_name LIKE '%\_encrypted' ESCAPE '\' OR column_name IN ('encrypted_secret','sealed_recipient'))") as $column) {
        if (! in_array($column->column_name, $allowed[$column->table_name] ?? [], true)) {
            throw new RuntimeException('UNREVIEWED_ENCRYPTED_COLUMN');
        }
    }
    $stream = fopen($directory.'/recovery.jsonl', 'xb');
    if ($stream === false) {
        throw new RuntimeException('RECOVERY_OUTPUT_UNAVAILABLE');
    }
    $batch = (string) Str::uuid7();
    $sourceKey = (string) config('app.key');
    try {
        foreach ($allowed as $table => $columns) {
            foreach ($columns as $column) {
                if (! Schema::hasColumn($table, $column)) {
                    continue;
                }
                foreach (DB::table($table)->whereNotNull($column)->orderBy('id')->cursor() as $row) {
                    if ($row->{$column} === '') {
                        continue;
                    }
                    $plain = app('encrypter')->decryptString($row->{$column});
                    $replacement = $target->encryptString($plain);
                    if (! hash_equals($plain, $target->decryptString($replacement))) {
                        throw new RuntimeException('RECOVERY_ROUNDTRIP_FAILED');
                    }
                    $identityColumn = $table === 'vendor_tax_profile_versions' ? match ($column) {
                        'taxpayer_key_encrypted' => 'taxpayer_key_hash', 'tin_encrypted' => 'tin_hash', default => null,
                    } : null;
                    $canonicalHash = $identityColumn === null ? null : $row->{$identityColumn};
                    $stagingHash = null;
                    if ($canonicalHash !== null) {
                        $identity = $column === 'tin_encrypted' ? substr((string) preg_replace('/\D/', '', $plain), 0, 9) : $plain;
                        if (! hash_equals($canonicalHash, hash_hmac('sha256', $identity, $sourceKey))) {
                            throw new RuntimeException('SOURCE_IDENTITY_HASH_MISMATCH');
                        }
                        $stagingHash = hash_hmac('sha256', $identity, $targetTextKey);
                    }
                    fwrite($stream, json_encode([
                        'id' => (string) Str::uuid7(), 'source_ciphertext_sha256' => hash('sha256', $row->{$column}),
                        'staging_ciphertext' => $replacement, 'source_table' => $table, 'source_column' => $column,
                        'source_record_id' => (string) $row->id, 'staging_identity_hash' => $stagingHash,
                        'canonical_identity_hash' => $canonicalHash, 'import_batch_id' => $batch, 'created_at' => now()->toISOString(),
                    ], JSON_THROW_ON_ERROR)."\n");
                }
            }
        }
    } finally {
        fclose($stream);
    }
}

function recoveryExportObjects(string $directory): array
{
    $objects = [];
    $external = [];
    $add = function (string $disk, string $key, ?string $expectedHash = null) use (&$objects, $directory): void {
        recoveryObjectKey($key);
        if (! in_array($disk, ['s3', 'local', 'public'], true)) {
            throw new RuntimeException('UNREVIEWED_STORAGE_DISK');
        }
        $identity = $disk.':'.$key;
        if (isset($objects[$identity])) {
            return;
        }
        $input = Storage::disk($disk)->readStream($key);
        if (! is_resource($input)) {
            throw new RuntimeException('REFERENCED_OBJECT_MISSING');
        }
        $temporary = tempnam($directory.'/objects', 'object-');
        $output = fopen($temporary, 'wb');
        try {
            stream_copy_to_stream($input, $output);
        } finally {
            fclose($input);
            fclose($output);
        }
        $hash = (string) hash_file('sha256', $temporary);
        if ($expectedHash !== null && ! hash_equals($expectedHash, $hash)) {
            throw new RuntimeException('SOURCE_OBJECT_CHECKSUM_MISMATCH');
        }
        $bytes = filesize($temporary);
        if (is_file($directory.'/objects/'.$hash)) {
            unlink($temporary);
        } elseif (! rename($temporary, $directory.'/objects/'.$hash)) {
            throw new RuntimeException('OBJECT_ARCHIVE_FAILED');
        }
        $objects[$identity] = ['disk' => $disk, 'key' => $key, 'sha256' => $hash, 'bytes' => $bytes];
    };
    foreach (DB::table('files')->orderBy('id')->cursor() as $file) {
        $metadata = json_decode($file->metadata ?? '{}', true, flags: JSON_THROW_ON_ERROR) ?? [];
        if (($metadata['storage_provider'] ?? '') === 'CLOUDINARY') {
            $external[] = ['provider' => 'CLOUDINARY', 'object_key' => $file->object_key, 'url' => $metadata['public_url'] ?? null];
        } else {
            $add($metadata['disk'] ?? config('materyalph.files.disk', 'local'), $file->object_key, $file->checksum_sha256);
        }
    }
    foreach (DB::table('users')->whereNotNull('profile_photo_key')->orderBy('id')->cursor() as $user) {
        $add($user->profile_photo_disk ?? 'local', $user->profile_photo_key);
    }
    foreach (DB::table('message_attachments')->orderBy('id')->cursor() as $attachment) {
        $add($attachment->disk, $attachment->storage_key);
    }

    return [array_values($objects), $external];
}

function recoveryRestore(string $directory, array $manifest): void
{
    if (! app()->environment('staging') || config('finance.live_commerce_enabled') || config('services.xendit.mode') !== 'TEST'
        || ! hash_equals($manifest['target_key_sha256'], hash('sha256', recoveryKey(config('app.key'))))) {
        throw new RuntimeException('STAGING_RECOVERY_GUARD_FAILED');
    }
    $installed = [];
    foreach (DB::select('SELECT extname,extversion FROM pg_extension') as $extension) {
        $installed[$extension->extname] = $extension->extversion;
    }
    foreach ($manifest['extensions'] ?? [] as $extension) {
        if (! isset($installed[$extension['extname']]) || version_compare($installed[$extension['extname']], $extension['extversion'], '<')) {
            throw new RuntimeException('RESTORED_EXTENSION_VERSION_MISMATCH');
        }
    }
    foreach (['postgis', 'pg_trgm', 'pgcrypto'] as $extension) {
        if (! isset($installed[$extension])) {
            throw new RuntimeException('RESTORED_EXTENSION_MISSING');
        }
    }
    $counts = recoveryCounts();
    if (array_keys($counts) !== array_keys($manifest['table_counts'])) {
        throw new RuntimeException('RESTORED_DATABASE_TABLE_SET_MISMATCH');
    }
    foreach ($manifest['table_counts'] as $table => $count) {
        if (($counts[$table] ?? -1) !== $count) {
            throw new RuntimeException('RESTORED_DATABASE_COUNT_MISMATCH');
        }
    }
    foreach (['local', 'public', 's3'] as $disk) {
        if (config('filesystems.disks.'.$disk.'.driver') !== 's3') {
            throw new RuntimeException('RECOVERY_STORAGE_MUST_REMAIN_PRIVATE_S3');
        }
    }
    foreach ($manifest['objects'] as $object) {
        $disk = Storage::disk($object['disk']);
        if ($disk->exists($object['key'])) {
            $stream = $disk->readStream($object['key']);
            $hash = hash_init('sha256');
            hash_update_stream($hash, $stream);
            fclose($stream);
            if (! hash_equals($object['sha256'], hash_final($hash))) {
                throw new RuntimeException('DESTINATION_OBJECT_COLLISION');
            }
            continue;
        }
        $stream = fopen($directory.'/objects/'.$object['sha256'], 'rb');
        try {
            if (! $disk->put($object['key'], $stream, ['visibility' => 'private', 'ServerSideEncryption' => 'AES256'])) {
                throw new RuntimeException('RECOVERY_OBJECT_WRITE_FAILED');
            }
        } finally {
            fclose($stream);
        }
        $stream = $disk->readStream($object['key']);
        $hash = hash_init('sha256');
        hash_update_stream($hash, $stream);
        fclose($stream);
        if (! hash_equals($object['sha256'], hash_final($hash))) {
            throw new RuntimeException('RECOVERY_OBJECT_READBACK_FAILED');
        }
    }
    DB::transaction(function () use ($directory): void {
        $stream = fopen($directory.'/recovery.jsonl', 'rb');
        $added = 0;
        try {
            while (($line = fgets($stream)) !== false) {
                $entry = json_decode($line, true, flags: JSON_THROW_ON_ERROR);
                $expected = ['id', 'source_ciphertext_sha256', 'staging_ciphertext', 'source_table', 'source_column', 'source_record_id', 'staging_identity_hash', 'canonical_identity_hash', 'import_batch_id', 'created_at'];
                if (array_diff(array_keys($entry), $expected) || array_diff($expected, array_keys($entry))
                    || ! in_array($entry['source_column'], recoveryColumns()[$entry['source_table']] ?? [], true)
                    || ! Str::isUuid($entry['id']) || ! Str::isUuid($entry['source_record_id']) || ! Str::isUuid($entry['import_batch_id'])) {
                    throw new RuntimeException('RECOVERY_ENTRY_INVALID');
                }
                $source = DB::table($entry['source_table'])->where('id', $entry['source_record_id'])->value($entry['source_column']);
                if (! is_string($source) || ! hash_equals($entry['source_ciphertext_sha256'], hash('sha256', $source))) {
                    throw new RuntimeException('RECOVERY_SOURCE_FINGERPRINT_MISMATCH');
                }
                app('encrypter')->decryptString($entry['staging_ciphertext']);
                $added += (int) DB::table('imported_encrypted_values')->insertOrIgnore($entry);
            }
        } finally {
            fclose($stream);
        }
        if ($added > 0) {
            $id = (string) Str::uuid7();
            DB::table('audit_logs')->insert(['id' => $id, 'actor_role' => 'SYSTEM', 'action' => 'IMPORTED_ENCRYPTION_RECOVERED', 'resource_type' => 'IMPORT_BATCH', 'resource_id' => $id, 'after' => json_encode(['recovery_records_added' => $added], JSON_THROW_ON_ERROR), 'reason' => 'Authorized staging import; original history and source keys preserved locally.', 'correlation_id' => (string) Str::uuid7(), 'succeeded' => true, 'created_at' => now(), 'updated_at' => now()]);
        }
    });
    // Existing registries remain append-only even after mutable source rows change or expire.
    foreach (DB::table('imported_encrypted_values')->orderBy('id')->cursor() as $entry) {
        app('encrypter')->decryptString($entry->staging_ciphertext);
    }
    foreach (recoveryColumns() as $table => $columns) {
        foreach ($columns as $column) {
            if (! Schema::hasColumn($table, $column)) {
                continue;
            }
            foreach (DB::table($table)->whereNotNull($column)->orderBy('id')->cursor() as $row) {
                if ($row->{$column} !== '') {
                    app('encrypter')->decryptString($row->{$column});
                }
            }
        }
    }
}

if (! defined('MATERYALPH_RECOVERY_LIBRARY')) {
    try {
        [$script, $command, $directory] = array_pad($argv, 3, null);
        if (! in_array($command, ['export', 'export-source', 'verify', 'restore', 'inspect'], true) || ! is_string($directory) || ! is_dir($directory) || is_link($directory)) {
            throw new RuntimeException('USAGE_EXPORT_VERIFY_RESTORE_PRIVATE_DIRECTORY');
        }
        if ($command === 'verify') {
            recoveryVerify($directory);
        } else {
            $root = is_file('/app/services/api/bootstrap/app.php') ? '/app/services/api' : dirname(__DIR__, 2).'/services/api';
            require $root.'/vendor/autoload.php';
            $app = require $root.'/bootstrap/app.php';
            $app->make(Kernel::class)->bootstrap();
            if (! in_array($app->environment(), ['development', 'staging'], true) || DB::getDriverName() !== 'pgsql'
                || (int) DB::selectOne('SHOW server_version_num')->server_version_num < 160000
                || (int) DB::selectOne('SHOW server_version_num')->server_version_num >= 170000
                || config('finance.live_commerce_enabled') || config('services.xendit.mode') !== 'TEST') {
                throw new RuntimeException('RECOVERY_ENVIRONMENT_GUARD_FAILED');
            }
            if ($command === 'inspect') {
                $pending = App\Domain\Operations\ImportedOutboxBoundary::apply(DB::table('outbox_events'))->whereNull('processed_at')->where('available_at', '<=', now());
                $oldest = (clone $pending)->min('created_at');
                echo json_encode(['database_bytes' => (int) DB::selectOne('SELECT pg_database_size(current_database()) AS bytes')->bytes,
                    'eligible_pending_outbox' => (clone $pending)->count(), 'oldest_eligible_outbox_at' => $oldest,
                    'default_queue_length' => Illuminate\Support\Facades\Redis::connection((string) config('queue.connections.redis.connection', 'default'))->llen('queues:default'),
                    'scheduler_last_finished_at' => DB::table('scheduled_task_runs')->max('finished_at'), 'migrations' => DB::table('migrations')->count()], JSON_THROW_ON_ERROR)."\n";
                exit(0);
            }
            if ($command === 'restore') {
                recoveryRestore($directory, recoveryVerify($directory));
            } else {
                if (! is_file($directory.'/database.dump') || is_file($directory.'/manifest.json')) {
                    throw new RuntimeException('EXPORT_REQUIRES_FRESH_DATABASE_ARCHIVE');
                }
                mkdir($directory.'/objects', 0700);
                $targetText = (string) config('app.key');
                if ($command === 'export-source') {
                    if (! $app->environment('development') || empty($argv[3])) {
                        throw new RuntimeException('SOURCE_KEY_MUST_STAY_ON_DEVELOPMENT_MACHINE');
                    }
                    $targetText = 'base64:'.base64_encode(recoveryKey((string) file_get_contents($argv[3])));
                    if (hash_equals(recoveryKey($targetText), recoveryKey(config('app.key')))) {
                        throw new RuntimeException('ENVIRONMENT_KEYS_MUST_BE_SEPARATE');
                    }
                    recoveryPrepareEncryption($directory, new Encrypter(recoveryKey($targetText), 'AES-256-CBC'), $targetText);
                } else {
                    if (! $app->environment('staging')) {
                        throw new RuntimeException('USE_EXPORT_SOURCE_FOR_DEVELOPMENT');
                    }
                    file_put_contents($directory.'/recovery.jsonl', '');
                }
                [$objects, $external] = recoveryExportObjects($directory);
                $manifest = ['format' => 'materyalph-recovery-v1', 'postgres_major' => 16, 'created_at' => now()->toISOString(), 'source_environment' => $app->environment(), 'commit' => getenv('VPS_DEPLOY_COMMIT') ?: null,
                    'target_key_sha256' => hash('sha256', recoveryKey($targetText)), 'database_bytes' => (int) DB::selectOne('SELECT pg_database_size(current_database()) AS bytes')->bytes,
                    'outbox_delivery_not_before' => $command === 'export-source' ? now()->toISOString() : config('mail.outbox_delivery_not_before'),
                    'mail_delivery_not_before' => $command === 'export-source' ? now()->toISOString() : config('mail.delivery_not_before'),
                    'extensions' => DB::select('SELECT extname,extversion FROM pg_extension ORDER BY extname'),
                    'table_counts' => recoveryCounts(), 'objects' => $objects, 'external_media' => $external,
                    'database_sha256' => hash_file('sha256', $directory.'/database.dump'), 'recovery_sha256' => hash_file('sha256', $directory.'/recovery.jsonl')];
                file_put_contents($directory.'/manifest.json', json_encode($manifest, JSON_THROW_ON_ERROR | JSON_PRETTY_PRINT));
                recoveryVerify($directory);
            }
        }
        echo json_encode(['operation' => $command, 'verified' => true, 'source_keys_exported' => false], JSON_THROW_ON_ERROR)."\n";
    } catch (Throwable $error) {
        $code = preg_match('/\A[A-Z][A-Z0-9_]+\z/', $error->getMessage()) ? $error->getMessage() : 'RECOVERY_OPERATION_FAILED';
        fwrite(STDERR, $code."\n");
        exit(1);
    }
}
