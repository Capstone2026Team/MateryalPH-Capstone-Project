<?php

declare(strict_types=1);

// Operator-only CLI. Artifacts contain private staging data: keep them in ignored .tmp.
use Illuminate\Contracts\Console\Kernel;
use Illuminate\Contracts\Encryption\DecryptException;
use Illuminate\Encryption\Encrypter;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

require dirname(__DIR__, 2).'/services/api/vendor/autoload.php';
$app = require dirname(__DIR__, 2).'/services/api/bootstrap/app.php';
$app->make(Kernel::class)->bootstrap();
umask(0077);

function checkedKey(string $key): string
{
    if ($key === '' || str_starts_with($key, '/') || str_contains($key, '\\')
        || preg_match('~(?:^|/)\.\.?(?:/|$)|[\x00-\x1f]~', $key)) {
        throw new RuntimeException('Unsafe object key.');
    }

    return $key;
}

function saveJson(string $path, mixed $data): void
{
    if (file_put_contents($path, json_encode($data, JSON_THROW_ON_ERROR | JSON_PRETTY_PRINT)."\n", LOCK_EX) === false) {
        throw new RuntimeException('Artifact write failed.');
    }
}

try {
    [$script, $mode, $directory] = array_pad($argv, 3, '');
    $base = realpath(dirname(__DIR__, 2).'/.tmp');
    $directory = realpath($directory);
    if ($base === false || $directory === false || ! str_starts_with($directory, $base.DIRECTORY_SEPARATOR)) {
        throw new RuntimeException('Use an existing ignored .tmp subdirectory.');
    }
    if ($mode === 'export') {
        if (! $app->environment(['local', 'development']) || is_file($directory.'/ready.json')) {
            throw new RuntimeException('Export requires a local source and a new batch directory.');
        }
        $keyFile = realpath($argv[3] ?? '');
        if ($keyFile === false || ! str_starts_with($keyFile, $base.DIRECTORY_SEPARATOR)) {
            throw new RuntimeException('Use a staging key in ignored .tmp.');
        }
        $stagingKey = trim((string) file_get_contents($keyFile));
        if (! str_starts_with($stagingKey, 'base64:')) {
            throw new RuntimeException('Use a separate generated staging key.');
        }
        $rawKey = base64_decode(substr($stagingKey, 7), true);
        if (! is_string($rawKey) || $stagingKey === config('app.key')) {
            throw new RuntimeException('Source and staging keys must differ.');
        }
        $target = new Encrypter($rawKey, config('app.cipher'));
        DB::beginTransaction();
        DB::statement('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ READ ONLY');
        $snapshot = DB::selectOne('SELECT pg_export_snapshot() AS id')->id;
        $batch = (string) Str::uuid7();
        $counts = [];
        foreach (DB::select("SELECT tablename FROM pg_tables WHERE schemaname = 'public' ORDER BY tablename") as $table) {
            if (! preg_match('/^[a-z_][a-z0-9_]*$/', $table->tablename)) {
                throw new RuntimeException('Unexpected table identifier.');
            }
            if ($table->tablename !== 'imported_encrypted_values') {
                $counts[$table->tablename] = DB::table($table->tablename)->count();
            }
        }
        $stream = fopen($directory.'/recovery.jsonl', 'x');
        if ($stream === false) {
            throw new RuntimeException('Recovery artifact already exists.');
        }
        $seen = [];
        $columns = DB::select("SELECT table_name, column_name FROM information_schema.columns WHERE table_schema = 'public' AND (column_name LIKE '%\_encrypted' OR column_name IN ('encrypted_secret', 'sealed_token')) ORDER BY table_name, column_name");
        foreach ($columns as $column) {
            $table = $column->table_name;
            $name = $column->column_name;
            if (! preg_match('/^[a-z_][a-z0-9_]*$/', $table) || ! preg_match('/^[a-z_][a-z0-9_]*$/', $name)) {
                throw new RuntimeException('Unexpected column identifier.');
            }
            foreach (DB::table($table)->whereNotNull($name)->orderBy('id')->cursor() as $row) {
                $ciphertext = $row->{$name};
                if ($ciphertext === '') {
                    continue;
                }
                $fingerprint = hash('sha256', $ciphertext);
                if (isset($seen[$fingerprint])) {
                    continue;
                }
                try {
                    $plaintext = Crypt::decryptString($ciphertext);
                } catch (DecryptException) {
                    // Source may already have recovered imported values. Never create fallback chains.
                    $replacement = DB::table('imported_encrypted_values')->where('source_ciphertext_sha256', $fingerprint)->value('staging_ciphertext');
                    $plaintext = Crypt::decryptString($replacement);
                }
                $identity = null;
                $canonical = null;
                if ($table === 'vendor_tax_profile_versions' && in_array($name, ['taxpayer_key_encrypted', 'tin_encrypted'], true)) {
                    $identityValue = $name === 'tin_encrypted' ? substr($plaintext, 0, 9) : $plaintext;
                    $identity = hash_hmac('sha256', $identityValue, $stagingKey);
                    $canonical = $row->{$name === 'tin_encrypted' ? 'tin_hash' : 'taxpayer_key_hash'};
                    if (! is_string($canonical) || ! preg_match('/^[a-f0-9]{64}$/', $canonical)) {
                        throw new RuntimeException('Taxpayer identity requires an explicit recovery review.');
                    }
                }
                if (! Str::isUuid((string) $row->id)) {
                    throw new RuntimeException('Unsupported encrypted record identifier.');
                }
                $entry = ['id' => (string) Str::uuid7(), 'source_ciphertext_sha256' => $fingerprint,
                    'staging_ciphertext' => $target->encryptString($plaintext), 'source_table' => $table,
                    'source_column' => $name, 'source_record_id' => $row->id, 'staging_identity_hash' => $identity,
                    'canonical_identity_hash' => $canonical, 'import_batch_id' => $batch, 'created_at' => now()->toIso8601String()];
                fwrite($stream, json_encode($entry, JSON_THROW_ON_ERROR)."\n");
                $seen[$fingerprint] = true;
            }
        }
        fclose($stream);
        mkdir($directory.'/objects', 0700);
        $references = [];
        foreach (DB::table('files')->orderBy('id')->cursor() as $file) {
            $metadata = json_decode($file->metadata ?? '{}', true, flags: JSON_THROW_ON_ERROR);
            if (($metadata['storage_provider'] ?? '') === 'CLOUDINARY') {
                continue; // Keep existing immutable Cloudinary references and account assets.
            }
            $references[] = ['disk' => $metadata['disk'] ?? config('materyalph.files.disk'), 'key' => $file->object_key,
                'sha256' => $file->checksum_sha256, 'bytes' => $file->byte_size, 'uses_default_disk' => ! isset($metadata['disk'])];
        }
        foreach (DB::table('users')->whereNotNull('profile_photo_key')->cursor() as $user) {
            $references[] = ['disk' => $user->profile_photo_disk, 'key' => $user->profile_photo_key];
        }
        foreach (DB::table('message_attachments')->whereNotNull('storage_key')->cursor() as $file) {
            $references[] = ['disk' => $file->disk, 'key' => $file->storage_key];
        }
        $files = [];
        $defaultReferences = [];
        foreach ($references as $reference) {
            $key = checkedKey($reference['key']);
            $disk = $reference['disk'];
            if (! in_array($disk, ['local', 'public', 's3'], true)) {
                throw new RuntimeException('Review an unsupported recorded storage disk.');
            }
            $index = $disk.':'.$key;
            if (($reference['uses_default_disk'] ?? false) && $disk !== 's3') {
                $defaultReferences[$index] = $key;
            }
            if (isset($files[$index])) {
                continue;
            }
            $source = Storage::disk($disk)->readStream($key);
            if (! is_resource($source)) {
                throw new RuntimeException('A referenced object is missing.');
            }
            $temp = $directory.'/objects/transfer';
            $destination = fopen($temp, 'wb');
            if ($destination === false || stream_copy_to_stream($source, $destination) === false) {
                throw new RuntimeException('Object copy failed.');
            }
            fclose($source);
            fclose($destination);
            $hash = hash_file('sha256', $temp);
            $bytes = filesize($temp);
            if ((isset($reference['sha256']) && ! hash_equals($reference['sha256'], $hash))
                || (isset($reference['bytes']) && (int) $reference['bytes'] !== $bytes)) {
                throw new RuntimeException('Source object checksum or size differs from its record.');
            }
            if (is_file($directory.'/objects/'.$hash)) {
                unlink($temp);
            } elseif (! rename($temp, $directory.'/objects/'.$hash)) {
                throw new RuntimeException('Object artifact move failed.');
            }
            $files[$index] = ['disk' => $disk, 'key' => $key, 'sha256' => $hash, 'bytes' => $bytes,
                'destination' => ($disk === 's3' ? '' : 'imports/'.$disk.'/').$key];
        }
        // Older records without a disk use the newly configured default s3 root.
        // Preserve their fallback as well as explicit local/public aliases.
        foreach ($defaultReferences as $index => $key) {
            $files['default:'.$key] = array_merge($files[$index], ['destination' => $key]);
        }
        saveJson($directory.'/files.json', array_values($files));
        saveJson($directory.'/counts.json', $counts);
        saveJson($directory.'/ready.json', ['snapshot' => $snapshot, 'batch' => $batch,
            'target_key_sha256' => hash('sha256', $stagingKey), 'source_database' => DB::connection()->getDatabaseName()]);
        // pg_dump must finish while this read-only exported snapshot remains open.
        $deadline = time() + 1800;
        while (! is_file($directory.'/release-snapshot') && time() < $deadline) {
            sleep(1);
        }
        if (! is_file($directory.'/release-snapshot')) {
            throw new RuntimeException('Snapshot export timed out.');
        }
        DB::rollBack();
    } elseif ($mode === 'recover') {
        if (! $app->environment('staging') || config('finance.live_commerce_enabled') || config('services.xendit.mode') !== 'TEST') {
            throw new RuntimeException('Recovery is staging-only.');
        }
        $ready = json_decode((string) file_get_contents($directory.'/ready.json'), true, flags: JSON_THROW_ON_ERROR);
        if (! hash_equals($ready['target_key_sha256'], hash('sha256', config('app.key')))) {
            throw new RuntimeException('The staging key does not match this batch.');
        }
        DB::transaction(function () use ($directory, $ready): void {
            if (DB::table('imported_encrypted_values')->exists()) {
                throw new RuntimeException('Recovery requires an empty recovery table.');
            }
            $counts = json_decode((string) file_get_contents($directory.'/counts.json'), true, flags: JSON_THROW_ON_ERROR);
            foreach ($counts as $table => $expected) {
                if (DB::table($table)->count() !== $expected) {
                    throw new RuntimeException('Restored record counts differ from the snapshot.');
                }
            }
            $source = fopen($directory.'/recovery.jsonl', 'rb');
            while (($line = fgets($source)) !== false) {
                $entry = json_decode($line, true, flags: JSON_THROW_ON_ERROR);
                Crypt::decryptString($entry['staging_ciphertext']);
                $original = DB::table($entry['source_table'])->where('id', $entry['source_record_id'])->value($entry['source_column']);
                if (! is_string($original) || ! hash_equals($entry['source_ciphertext_sha256'], hash('sha256', $original))) {
                    throw new RuntimeException('Recovery entry does not match a restored source record.');
                }
                DB::table('imported_encrypted_values')->insert($entry);
            }
            fclose($source);
            $now = now();
            DB::table('auth_sessions')->whereNull('revoked_at')->update(['revoked_at' => $now, 'revoke_reason' => 'STAGING_IMPORT', 'updated_at' => $now]);
            DB::table('oauth_access_tokens')->where('revoked', false)->update(['revoked' => true]);
            DB::table('oauth_refresh_tokens')->where('revoked', false)->update(['revoked' => true]);
            DB::table('trusted_devices')->whereNull('revoked_at')->update(['revoked_at' => $now, 'updated_at' => $now]);
            DB::table('email_otps')->whereNull('consumed_at')->whereNull('invalidated_at')->update(['invalidated_at' => $now, 'updated_at' => $now]);
            DB::table('recovery_codes')->whereNull('used_at')->update(['used_at' => $now, 'updated_at' => $now]);
            DB::table('audit_logs')->insert([
                'id' => (string) Str::uuid7(), 'actor_user_id' => null, 'actor_role' => null,
                'action' => 'STAGING_IMPORT_ACCESS_RESET', 'resource_type' => 'IMPORT_BATCH', 'resource_id' => $ready['batch'],
                'before' => '{}', 'after' => json_encode(['fresh_sign_in_required' => true, 'recovery_code_regeneration_required' => true], JSON_THROW_ON_ERROR),
                'reason' => 'Staging import with separate environment keys', 'correlation_id' => $ready['batch'],
                'succeeded' => true, 'created_at' => $now, 'updated_at' => $now,
            ]);
        });
    } elseif ($mode === 'copy-files') {
        if (! $app->environment(['local', 'development'])) {
            throw new RuntimeException('Copy files from the local export host only.');
        }
        $settings = realpath($argv[3] ?? '');
        if ($settings === false || ! str_starts_with($settings, $base.DIRECTORY_SEPARATOR)) {
            throw new RuntimeException('Keep destination storage credentials in ignored .tmp.');
        }
        $configuration = json_decode((string) file_get_contents($settings), true, flags: JSON_THROW_ON_ERROR);
        if (($configuration['driver'] ?? '') !== 's3' || ($configuration['bucket'] ?? '') === config('filesystems.disks.s3.bucket')
            || ($configuration['region'] ?? '') !== 'ap-southeast-1' || ! empty($configuration['endpoint'])) {
            throw new RuntimeException('Use a dedicated AWS staging bucket in Singapore.');
        }
        $configuration['throw'] = true;
        $disk = Storage::build($configuration);
        foreach (json_decode((string) file_get_contents($directory.'/files.json'), true, flags: JSON_THROW_ON_ERROR) as $file) {
            $key = checkedKey($file['destination']);
            $path = $directory.'/objects/'.$file['sha256'];
            if (! preg_match('/^[a-f0-9]{64}$/', $file['sha256']) || ! hash_equals($file['sha256'], hash_file('sha256', $path))) {
                throw new RuntimeException('Exported object checksum differs.');
            }
            if (! $disk->exists($key)) {
                $stream = fopen($path, 'rb');
                $disk->put($key, $stream, ['visibility' => 'private', 'ServerSideEncryption' => 'AES256']);
                fclose($stream);
            }
            $stream = $disk->readStream($key);
            $hash = hash_init('sha256');
            hash_update_stream($hash, $stream);
            fclose($stream);
            if (! hash_equals($file['sha256'], hash_final($hash))) {
                throw new RuntimeException('Destination object differs; no existing object was overwritten.');
            }
        }
    } else {
        throw new RuntimeException('Choose export, recover or copy-files.');
    }
    fwrite(STDOUT, "Staging transfer step completed.\n");
} catch (Throwable) {
    if (DB::transactionLevel() > 0) {
        DB::rollBack();
    }
    // DB/provider exceptions can contain values. Never print or chain them.
    fwrite(STDERR, "Staging transfer failed. Check prerequisites and the protected batch artifacts. No source records were changed.\n");
    exit(1);
}
