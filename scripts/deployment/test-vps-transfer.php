<?php

declare(strict_types=1);

define('MATERYALPH_RECOVERY_LIBRARY', true);
require __DIR__.'/vps-transfer.php';

$directory = sys_get_temp_dir().'/materyalph-recovery-'.bin2hex(random_bytes(8));
mkdir($directory, 0700);
mkdir($directory.'/objects', 0700);
try {
    foreach (['../escape', '/absolute', 'a/../../escape', 'a\\escape', 's3:key'] as $key) {
        try {
            recoveryObjectKey($key);
            throw new LogicException('Unsafe object key accepted.');
        } catch (RuntimeException $error) {
            if ($error->getMessage() !== 'OBJECT_KEY_INVALID') {
                throw $error;
            }
        }
    }
    $raw = random_bytes(32);
    if (recoveryKey('base64:'.base64_encode($raw)) !== $raw) {
        throw new LogicException('Key normalization failed.');
    }
    file_put_contents($directory.'/database.dump', 'synthetic fixture archive');
    file_put_contents($directory.'/recovery.jsonl', '');
    $bytes = 'synthetic private object';
    $hash = hash('sha256', $bytes);
    file_put_contents($directory.'/objects/'.$hash, $bytes);
    $manifest = ['format' => 'materyalph-recovery-v1', 'postgres_major' => 16, 'target_key_sha256' => hash('sha256', $raw), 'database_bytes' => 1234,
        'table_counts' => ['synthetic' => 1], 'mail_delivery_not_before' => '2026-10-22T00:00:00Z', 'outbox_delivery_not_before' => '2026-10-22T00:00:00Z',
        'database_sha256' => hash_file('sha256', $directory.'/database.dump'), 'recovery_sha256' => hash_file('sha256', $directory.'/recovery.jsonl'),
        'objects' => [['disk' => 's3', 'key' => 'synthetic/private-object', 'sha256' => $hash, 'bytes' => strlen($bytes)]]];
    file_put_contents($directory.'/manifest.json', json_encode($manifest, JSON_THROW_ON_ERROR));
    recoveryVerify($directory);
    file_put_contents($directory.'/objects/'.$hash, 'tampered');
    try {
        recoveryVerify($directory);
        throw new LogicException('Tampered object accepted.');
    } catch (RuntimeException $error) {
        if ($error->getMessage() !== 'RECOVERY_OBJECT_CHECKSUM_FAILED') {
            throw $error;
        }
    }
    echo "Recovery traversal, key normalization, complete checksums and tamper rejection passed.\n";
} finally {
    foreach (glob($directory.'/objects/*') as $path) {
        unlink($path);
    }
    rmdir($directory.'/objects');
    foreach (glob($directory.'/*') as $path) {
        unlink($path);
    }
    rmdir($directory);
}
