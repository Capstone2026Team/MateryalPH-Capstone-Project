"""Use disposable synthetic inputs to exercise the real Compose parser; never start services."""
import json
from pathlib import Path
import shutil
import subprocess
import tempfile

root = Path(__file__).resolve().parents[2]
docker = shutil.which('docker') or str(Path.home() / 'AppData/Local/Programs/DockerDesktop/resources/bin/docker.exe')
with tempfile.TemporaryDirectory(prefix='vps-compose-', dir=root / '.tmp') as temporary:
    directory = Path(temporary)
    environment = directory / 'fixture.env'
    private = directory / 'synthetic-input'
    private.write_text('SYNTHETIC_ONLY=true\nSYNTHETIC_SECRET=literal$UNDEFINED#suffix\n')
    values = {
        'VPS_API_IMAGE': 'sha256:' + 'a' * 64, 'VPS_EDGE_IMAGE': 'sha256:' + 'b' * 64,
        'VPS_DEPLOY_COMMIT': 'c' * 40,
        **{f'VPS_{role}_HOST': f'materyalph26-{host}.duckdns.org' for role, host in [('API', 'api'), ('VENDOR', 'vendor'), ('ADMIN', 'admin'), ('REVERB', 'ws')]},
        **{name: str(private).replace('\\', '/') for name in ['VPS_API_ENV_FILE', 'VPS_REVERB_ENV_FILE', 'VPS_BACKUP_ENV_FILE', 'VPS_DB_OWNER_PASSWORD_FILE', 'VPS_DB_APP_PASSWORD_FILE', 'VPS_BACKUP_PASSWORD_FILE']},
        'VPS_RECOVERY_DIRECTORY': str(directory).replace('\\', '/'),
    }
    environment.write_text(''.join(f'{key}={value}\n' for key, value in values.items()))
    command = [docker, 'compose', '--env-file', str(environment), '-f', str(root / 'compose.vps.yaml'), '--profile', 'active', '--profile', 'ops', 'config']
    subprocess.run(command + ['--quiet'], check=True)
    parsed = json.loads(subprocess.run(command + ['--format', 'json'], check=True, capture_output=True, text=True).stdout)
    assert not parsed['services']['postgres'].get('ports')
    assert not parsed['services']['redis'].get('ports')
    assert parsed['services']['api']['environment']['RUN_QUEUE'] == 'false'
    # `compose config` escapes dollars so its output can be re-used as Compose input.
    for role in ['api', 'reverb', 'backup']:
        actual = parsed['services'][role]['environment']['SYNTHETIC_SECRET']
        assert actual.replace('$$', '$') == 'literal$UNDEFINED#suffix', repr(actual)
    assert parsed['services']['worker']['command'][-1] == 'worker'
    assert parsed['services']['scheduler']['command'][-1] == 'scheduler-loop'
    print('Real VPS Compose parser passed with synthetic inputs; no services were started.')
