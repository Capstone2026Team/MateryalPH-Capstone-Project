"""Exercise only newly created, network-isolated containers and synthetic data.

Build the three staging images with :railway-review tags first. This does not
connect to development, Railway, Vercel, email, or external object storage.
"""
import base64
import hashlib
import json
import os
from pathlib import Path
import secrets
import shutil
import subprocess
import time
import uuid

ROOT = Path(__file__).resolve().parents[2]

FIXTURE = r'''<?php
require '/app/services/api/vendor/autoload.php';
$app = require '/app/services/api/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
if ($argv[1] === 'seed') {
    $user = App\Models\User::query()->create(['name'=>'Synthetic import', 'email'=>'import@example.test',
        'password'=>Illuminate\Support\Facades\Hash::make(Str::random(40)), 'account_type'=>'BUYER', 'account_status'=>'ACTIVE']);
    DB::table('totp_factors')->insert(['id'=>(string)Str::uuid7(), 'user_id'=>$user->id,
        'encrypted_secret'=>Crypt::encryptString('SYNTHETIC-TOTP'), 'confirmed_at'=>now(), 'created_at'=>now(), 'updated_at'=>now()]);
    DB::table('recovery_codes')->insert(['id'=>(string)Str::uuid7(), 'user_id'=>$user->id,
        'code_hash'=>hash('sha256', 'synthetic-code'), 'created_at'=>now(), 'updated_at'=>now()]);
    Storage::disk('local')->put('private/synthetic.txt', 'Synthetic private file');
    DB::table('files')->insert(['id'=>(string)Str::uuid7(), 'owner_type'=>'USER', 'owner_id'=>$user->public_id,
        'purpose'=>'TEST_IMPORT', 'visibility'=>'PRIVATE', 'content_type'=>'text/plain', 'byte_size'=>22,
        'checksum_sha256'=>hash('sha256','Synthetic private file'), 'scan_state'=>'CLEAN', 'object_key'=>'private/synthetic.txt',
        'retention_class'=>'COMMERCIAL_HISTORY', 'metadata'=>'{}', 'created_at'=>now(), 'updated_at'=>now()]);
} elseif ($argv[1] === 'source-unchanged') {
    if (Crypt::decryptString(DB::table('totp_factors')->value('encrypted_secret')) !== 'SYNTHETIC-TOTP'
        || DB::table('recovery_codes')->whereNull('used_at')->count() !== 1
        || DB::table('imported_encrypted_values')->exists() || DB::table('audit_logs')->exists()) exit(1);
} else {
    if (Crypt::decryptString(DB::table('totp_factors')->value('encrypted_secret')) !== 'SYNTHETIC-TOTP'
        || DB::table('totp_factors')->whereNotNull('confirmed_at')->count() !== 1
        || DB::table('recovery_codes')->whereNull('used_at')->exists()
        || DB::table('audit_logs')->where('action','STAGING_IMPORT_ACCESS_RESET')->count() !== 1
        || config('filesystems.disks.local.driver') !== 's3'
        || config('filesystems.disks.local.root') !== 'imports/local'
        || config('filesystems.disks.public.visibility') !== 'private') exit(1);
    echo "Recovery and access reset verified.\n";
}
'''


def main():
    docker = shutil.which('docker')
    if not docker:
        candidate = Path.home() / 'AppData/Local/Programs/DockerDesktop/resources/bin/docker.exe'
        if candidate.is_file():
            docker = str(candidate)
    if not docker:
        raise RuntimeError('Docker Desktop is required.')
    tag = 'materyalph-staging-test-' + uuid.uuid4().hex[:10]
    directory = (ROOT / '.tmp' / tag).resolve()
    assert directory.is_relative_to(ROOT / '.tmp')
    directory.mkdir(parents=True)
    source_mount = directory / 'source'
    target_mount = directory / 'target'
    source_mount.mkdir()
    target_mount.mkdir()
    batch = source_mount / 'batch'
    batch.mkdir()
    (source_mount / 'fixture.php').write_text(FIXTURE)
    (target_mount / 'fixture.php').write_text(FIXTURE)
    target_key = 'base64:' + base64.b64encode(secrets.token_bytes(32)).decode()
    (source_mount / 'key.txt').write_text(target_key)
    names = {role: tag + '-' + role for role in ('source', 'target', 'redis', 'export')}
    owner_password = secrets.token_urlsafe(32)
    app_password = secrets.token_urlsafe(32)
    redis_password = secrets.token_urlsafe(32)
    pg_env = directory / 'postgres.env'
    pg_env.write_text(f'POSTGRES_USER=staging_owner\nPOSTGRES_DB=materyalph_staging\nPOSTGRES_PASSWORD={owner_password}\nSTAGING_DB_PASSWORD={app_password}\n')
    redis_env = directory / 'redis.env'
    redis_env.write_text(f'REDIS_PASSWORD={redis_password}\n')
    for role in ('source', 'target'):
        key = target_key if role == 'target' else 'base64:' + base64.b64encode(secrets.token_bytes(32)).decode()
        (directory / f'{role}.env').write_text(f'APP_ENV={"staging" if role == "target" else "development"}\nAPP_DEBUG=false\nAPP_KEY={key}\nDB_CONNECTION=pgsql\nDB_HOST={names[role]}\nDB_PORT=5432\nDB_DATABASE=materyalph_staging\nDB_USERNAME=materyalph_app\nDB_PASSWORD={app_password}\nDB_SSLMODE=require\nCACHE_STORE=array\nSESSION_DRIVER=array\nQUEUE_CONNECTION=sync\nMAIL_MAILER=array\nXENDIT_MODE=TEST\nLIVE_COMMERCE_ENABLED=false\nIMPORTED_DATA_RECOVERY_ENABLED=true\n')
    for file in directory.glob('*.env'):
        os.chmod(file, 0o600)
    with (directory / 'target.env').open('a') as settings:
        settings.write('STAGING_LEGACY_FILES_ON_S3=true\nFILESYSTEM_DISK=s3\nVENDOR_PRIVATE_DISK=s3\n')

    def run(arguments, *, data=None, check=True):
        result = subprocess.run([docker, *arguments], input=data, capture_output=True, timeout=180)
        if check and result.returncode:
            (directory / 'private-failure.log').write_bytes(result.stdout + result.stderr)
            raise RuntimeError('Isolated staging runtime check failed; inspect its ignored private log.')
        return result

    def api(role, arguments, **kwargs):
        return run(['run', '--rm', '--network', tag, '--env-file', str(directory / f'{role}.env'),
                    '--mount', f'type=bind,source={directory / role},target=/app/.tmp',
                    '--entrypoint', 'php', 'materyalph-api:railway-review', *arguments], **kwargs)

    exporter = None
    try:
        run(['network', 'create', '--internal', tag])
        for role in ('source', 'target'):
            run(['run', '-d', '--name', names[role], '--network', tag, '--env-file', str(pg_env),
                 '-e', f'POSTGRES_TLS_HOST={names[role]}', 'materyalph-postgres:railway-review'])
            deadline = time.monotonic() + 90
            while time.monotonic() < deadline:
                if run(['exec', names[role], 'pg_isready', '-h', '127.0.0.1', '-U', 'materyalph_app', '-d', 'materyalph_staging'], check=False).returncode == 0:
                    break
                time.sleep(0.5)
            else:
                raise RuntimeError('Isolated PostgreSQL did not become ready.')
            result = run(['exec', names[role], 'psql', '-U', 'staging_owner', '-d', 'materyalph_staging', '-Atc',
                          "SELECT rolsuper FROM pg_roles WHERE rolname='materyalph_app'; SHOW ssl;"])
            if result.stdout.decode().strip().splitlines() != ['f', 'on']:
                raise RuntimeError('Application database role or TLS configuration is unsafe.')
        api('source', ['artisan', 'migrate', '--force', '--no-interaction'])
        api('source', ['/app/.tmp/fixture.php', 'seed'])
        export_arguments = [docker, 'run', '--rm', '--name', names['export'], '--network', tag,
            '--env-file', str(directory / 'source.env'), '--mount', f'type=bind,source={source_mount},target=/app/.tmp',
            '--entrypoint', 'php', 'materyalph-api:railway-review', '/app/scripts/deployment/staging-transfer.php',
            'export', '/app/.tmp/batch', '/app/.tmp/key.txt']
        # Supply only this test's synthetic local disk to the snapshot exporter.
        source_storage = directory / 'storage'
        source_storage.mkdir(exist_ok=True)
        # Mount a synthetic disk at the production disk root for the exporter.
        (source_storage / 'private').mkdir()
        (source_storage / 'private/synthetic.txt').write_text('Synthetic private file')
        export_arguments[2:2] = ['--mount', f'type=bind,source={source_storage},target=/app/services/api/storage/app']
        log = open(directory / 'export-private.log', 'wb')
        exporter = subprocess.Popen(export_arguments, stdout=log, stderr=log)
        deadline = time.monotonic() + 90
        while not (batch / 'ready.json').is_file() and time.monotonic() < deadline and exporter.poll() is None:
            time.sleep(0.2)
        if not (batch / 'ready.json').is_file():
            raise RuntimeError('Snapshot exporter did not produce a ready manifest.')
        ready = json.loads((batch / 'ready.json').read_text())
        archive = run(['exec', names['source'], 'pg_dump', '-U', 'staging_owner', '-d', 'materyalph_staging',
                       '--format=custom', '--no-owner', '--no-privileges', '--exclude-table-data=public.imported_encrypted_values',
                       '--snapshot=' + ready['snapshot']]).stdout
        (batch / 'release-snapshot').touch()
        if exporter.wait(timeout=30):
            raise RuntimeError('Snapshot exporter failed.')
        log.close()
        files = json.loads((batch / 'files.json').read_text())
        if {file['destination'] for file in files} != {'imports/local/private/synthetic.txt', 'private/synthetic.txt'}:
            raise RuntimeError('Legacy disk aliases and default-disk fallback differ.')
        if any(hashlib.sha256((batch / 'objects' / file['sha256']).read_bytes()).hexdigest() != file['sha256'] for file in files):
            raise RuntimeError('Exported object checksum differs.')
        run(['exec', '-i', names['target'], 'pg_restore', '-U', 'materyalph_app', '-d', 'materyalph_staging',
             '--single-transaction', '--exit-on-error', '--no-owner', '--no-privileges', '--no-comments'], data=archive)
        target_batch = target_mount / 'batch'
        target_batch.mkdir()
        for filename in ('ready.json', 'counts.json', 'recovery.jsonl'):
            shutil.copy2(batch / filename, target_batch / filename)
        api('target', ['/app/scripts/deployment/staging-transfer.php', 'recover', '/app/.tmp/batch'])
        api('target', ['/app/.tmp/fixture.php', 'verify'])
        api('source', ['/app/.tmp/fixture.php', 'source-unchanged'])
        if api('target', ['/app/scripts/deployment/staging-transfer.php', 'recover', '/app/.tmp/batch'], check=False).returncode == 0:
            raise RuntimeError('Duplicate recovery unexpectedly succeeded.')
        run(['run', '-d', '--name', names['redis'], '--network', tag, '--env-file', str(redis_env), 'materyalph-redis:railway-review'])
        time.sleep(1)
        settings = run(['exec', names['redis'], 'sh', '-c', 'export REDISCLI_AUTH="$REDIS_PASSWORD"; redis-cli --raw CONFIG GET appendonly maxmemory-policy']).stdout.decode()
        if 'noeviction' not in settings or 'yes' not in settings:
            raise RuntimeError('Redis persistence/eviction configuration differs.')
        print(json.dumps({'postgres_tls': True, 'application_is_not_superuser': True, 'consistent_snapshot_restore': True,
            'encrypted_mfa_recovery': True, 'access_reset_audited': True, 'legacy_file_checksums': True,
            'duplicate_recovery_rejected': True, 'redis_aof_noeviction': True, 'development_data_untouched': True}))
    finally:
        if exporter is not None and exporter.poll() is None:
            (batch / 'release-snapshot').touch()
        for name in names.values():
            run(['rm', '-f', '-v', name], check=False)
        run(['network', 'rm', tag], check=False)


if __name__ == '__main__':
    main()
