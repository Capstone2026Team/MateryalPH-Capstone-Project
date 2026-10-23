"""Verify VPS least-privilege init and non-destructive PostgreSQL restore with synthetic data."""
from pathlib import Path
import json
import importlib.util
import secrets
import shutil
import subprocess
import tempfile
import time
import uuid

root = Path(__file__).resolve().parents[2]
docker = shutil.which('docker') or str(Path.home() / 'AppData/Local/Programs/DockerDesktop/resources/bin/docker.exe')
name = 'materyalph-vps-db-check-' + uuid.uuid4().hex[:12]
spec = importlib.util.spec_from_file_location('vps_host', Path(__file__).with_name('vps-host.py'))
host = importlib.util.module_from_spec(spec)
spec.loader.exec_module(host)


def run(*arguments, **kwargs):
    try:
        return subprocess.run([docker, *arguments], check=True, capture_output=True, **kwargs)
    except subprocess.CalledProcessError as error:
        detail = error.stderr.encode() if isinstance(error.stderr, str) else error.stderr
        (root / '.tmp/vps-database-fixture-error.log').write_bytes(detail or b'')
        raise


with tempfile.TemporaryDirectory(prefix='vps-database-', dir=root / '.tmp') as temporary:
    directory = Path(temporary)
    for role in ['owner', 'app']:
        path = directory / f'{role}-password'
        path.write_text(secrets.token_hex(32))
        path.chmod(0o600)
    started = False
    try:
        run('run', '-d', '--name', name, '--network', 'none', '--memory', '512m',
            '-e', 'POSTGRES_DB=materyalph_staging', '-e', 'POSTGRES_USER=materyalph_owner', '-e', 'POSTGRES_PASSWORD_FILE=/run/secrets/db_owner_password',
            '--mount', f'type=bind,src={directory / "owner-password"},dst=/run/secrets/db_owner_password,readonly',
            '--mount', f'type=bind,src={directory / "app-password"},dst=/run/secrets/db_app_password,readonly',
            '--mount', f'type=bind,src={directory},dst=/recovery,readonly',
            '--mount', f'type=bind,src={root / "infrastructure/vps/init-database.sh"},dst=/docker-entrypoint-initdb.d/20-materyalph.sh,readonly',
            '--mount', f'type=bind,src={root / "infrastructure/vps/postgres-entrypoint.sh"},dst=/opt/materyalph/postgres-entrypoint.sh,readonly',
            '--entrypoint', '/bin/sh', 'postgis/postgis:16-3.5', '/opt/materyalph/postgres-entrypoint.sh', 'postgres')
        started = True
        for attempt in range(60):
            ready = subprocess.run([docker, 'exec', name, 'pg_isready', '-U', 'materyalph_owner', '-d', 'materyalph_staging'], capture_output=True)
            # initdb temporarily accepts connections before the application role has been created.
            server = subprocess.run([docker, 'exec', name, 'cat', '/proc/1/comm'], capture_output=True, text=True)
            if ready.returncode == 0 and server.stdout.strip() == 'postgres':
                check = run('exec', name, 'psql', '-U', 'materyalph_owner', '-d', 'materyalph_staging', '-tAc', "SELECT count(*) FROM pg_roles WHERE rolname='materyalph_app'", text=True)
                if check.stdout.strip() == '1':
                    break
            time.sleep(0.5)
        else:
            raise RuntimeError('Synthetic PostgreSQL initialization failed.')
        run('exec', name, 'psql', '-U', 'materyalph_app', '-d', 'materyalph_staging', '-v', 'ON_ERROR_STOP=1', '-c', "CREATE TABLE synthetic_history (id integer PRIMARY KEY, note text NOT NULL); INSERT INTO synthetic_history VALUES (1, 'synthetic retained history');")
        archive = run('exec', name, 'pg_dump', '-U', 'materyalph_owner', '-d', 'materyalph_staging', '--format=custom', '--no-owner', '--no-acl', '--no-comments').stdout
        target = 'materyalph_restore_20261022000000'
        run('exec', name, 'createdb', '-U', 'materyalph_owner', '-O', 'materyalph_app', target)
        extensions = run('exec', name, 'psql', '-U', 'materyalph_owner', '-d', 'materyalph_staging', '-tAc', "SELECT json_agg(json_build_object('extname',extname)) FROM pg_extension", text=True).stdout
        run('exec', name, 'psql', '-U', 'materyalph_owner', '-d', target, '-v', 'ON_ERROR_STOP=1', '-c', host.extension_sql({'extensions': json.loads(extensions)}))
        toc = run('exec', '-i', name, 'pg_restore', '--list', input=archive).stdout.decode()
        (directory / 'restore.list').write_text(host.restore_toc(toc))
        run('exec', '-i', name, 'pg_restore', '-U', 'materyalph_owner', '--role=materyalph_app', '-d', target, '--use-list', '/recovery/restore.list', '--no-owner', '--no-acl', '--single-transaction', '--exit-on-error', input=archive)
        run('exec', name, 'psql', '-U', 'materyalph_owner', '-d', target, '-v', 'ON_ERROR_STOP=1', '-c', host.extension_grants(False))
        permission = run('exec', name, 'psql', '-U', 'materyalph_owner', '-d', target, '-tAc', "SELECT has_table_privilege('materyalph_app','public.spatial_ref_sys','INSERT')", text=True).stdout.strip()
        assert permission == 'f', 'Temporary extension import privilege was retained.'
        for database in ['materyalph_staging', target]:
            count = run('exec', name, 'psql', '-U', 'materyalph_app', '-d', database, '-tAc', 'SELECT count(*) FROM synthetic_history', text=True).stdout.strip()
            assert count == '1'
        print('Private PostgreSQL init, application-role restore, required extensions and preservation of source history passed.')
    finally:
        if started:
            subprocess.run([docker, 'rm', '-f', '-v', name], check=True, capture_output=True)
