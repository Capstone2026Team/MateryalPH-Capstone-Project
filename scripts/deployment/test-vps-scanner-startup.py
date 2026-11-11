"""Exercise scanner startup ordering with synthetic definitions and a probe process.

Uses the real Compose readiness command and dependency from compose.vps.yaml.
No definitions are downloaded, no malware engine is started, and no private inputs
or existing volumes are used. Only this run's Compose project and volume are removed.
"""
import argparse
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import time
import uuid


ROOT = Path(__file__).resolve().parents[2]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--image', required=True)
    args = parser.parse_args()
    docker = shutil.which('docker') or str(Path.home() / 'AppData/Local/Programs/DockerDesktop/resources/bin/docker.exe')
    project = 'materyalph-scanner-startup-' + uuid.uuid4().hex[:12]

    def run(*arguments, check=True, **kwargs):
        result = subprocess.run([docker, *arguments], capture_output=True, text=True, **kwargs)
        if check and result.returncode:
            raise RuntimeError(f'Docker {arguments[0]} failed: {result.stdout}{result.stderr}')
        return result

    with tempfile.TemporaryDirectory(prefix=project + '-', dir=ROOT / '.tmp') as temporary:
        directory = Path(temporary)
        private = directory / 'synthetic-input'
        private.write_text('SYNTHETIC_ONLY=true\n')
        environment = {
            **os.environ,
            'VPS_API_IMAGE': args.image, 'VPS_EDGE_IMAGE': args.image, 'VPS_DEPLOY_COMMIT': 'c' * 40,
            **{f'VPS_{role}_HOST': f'{role.lower()}.example.test' for role in ['API', 'VENDOR', 'ADMIN', 'REVERB']},
            **{name: private.as_posix() for name in [
                'VPS_API_ENV_FILE', 'VPS_REVERB_ENV_FILE', 'VPS_BACKUP_ENV_FILE',
                'VPS_DB_OWNER_PASSWORD_FILE', 'VPS_DB_APP_PASSWORD_FILE', 'VPS_BACKUP_PASSWORD_FILE',
            ]},
            'VPS_RECOVERY_DIRECTORY': directory.as_posix(),
        }
        parsed = json.loads(run('compose', '-f', str(ROOT / 'compose.vps.yaml'),
                                '--profile', 'active', '--profile', 'ops', 'config', '--format', 'json',
                                env=environment).stdout)
        services = {name: parsed['services'][name] for name in ['scanner', 'scanner-signatures']}
        assert services['scanner']['depends_on']['scanner-signatures']['condition'] == 'service_healthy', \
            'clamd must wait for the completed initial definition download'
        readiness = services['scanner-signatures']['healthcheck']['test']
        assert readiness[0] == 'CMD-SHELL'
        # Keep the production dependency and readiness predicate. Use fast polling
        # and a probe instead of external downloads and a real signature database.
        for name, service in services.items():
            service.pop('networks', None)
            service['network_mode'] = 'none'
            service['restart'] = 'no'
            service['command'] = ['php', '-r', f'echo "{name}-started\\n"; sleep(120);']
        services['scanner-signatures']['healthcheck'].update(
            interval='1s', timeout='1s', start_period='30s', retries=30)
        fixture = directory / 'compose.json'
        fixture.write_text(json.dumps({'services': services, 'volumes': {'scanner-signatures': {}}}))
        compose = ['compose', '-p', project, '-f', str(fixture)]
        launcher = None

        def ready():
            return run(*compose, 'exec', '-T', 'scanner-signatures', '/bin/sh', '-c', readiness[1], check=False).returncode == 0

        def seed(database, extension='cvd', contents='synthetic'):
            run(*compose, 'exec', '-T', 'scanner-signatures', 'php', '-r',
                'file_put_contents($argv[1], $argv[2]);', f'/var/lib/clamav/{database}.{extension}', contents)

        try:
            run(*compose, 'up', '-d', 'scanner-signatures')
            assert not ready(), 'An empty volume must not be ready'
            launcher = subprocess.Popen([docker, *compose, 'up', '-d', 'scanner'],
                                        stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
            deadline = time.monotonic() + 30
            while True:
                identity = run(*compose, 'ps', '--all', '-q', 'scanner').stdout.strip()
                if identity:
                    state = json.loads(run('inspect', '--format', '{{json .State}}', identity).stdout)
                    assert state['Status'] == 'created', 'Scanner started before definitions were ready'
                    break
                assert launcher.poll() is None, 'Compose did not wait for definition readiness'
                if time.monotonic() >= deadline:
                    raise RuntimeError('Compose did not create the waiting scanner')
                time.sleep(0.2)
            seed('daily')
            assert not ready(), 'A partial download must not be ready'
            seed('main')
            seed('bytecode', contents='')
            assert not ready(), 'An empty database must not be ready'
            assert launcher.poll() is None, 'Compose must still wait during a partial download'
            seed('bytecode')
            assert ready(), 'All three completed databases must be ready'
            stdout, stderr = launcher.communicate(timeout=30)
            assert launcher.returncode == 0, stdout + stderr
            state = json.loads(run('inspect', '--format', '{{json .State}}', identity).stdout)
            assert state['Running'] is True
            assert run('inspect', '--format', '{{.RestartCount}}', identity).stdout.strip() == '0'
            assert 'scanner-started' in run('logs', identity).stdout
            # FreshClam can replace compressed CVD files with incremental CLD files.
            run(*compose, 'exec', '-T', 'scanner-signatures', 'php', '-r',
                'foreach (["daily", "main", "bytecode"] as $name) {'
                ' rename("/var/lib/clamav/$name.cvd", "/var/lib/clamav/$name.cld"); }')
            assert ready(), 'Incrementally updated databases must also be ready'
            print('PASS: empty/partial/empty-file downloads block startup; completed CVD/CLD files '
                  'release the scanner with zero restarts; no providers or real definitions used.')
        finally:
            if launcher is not None and launcher.poll() is None:
                launcher.terminate()
                launcher.communicate(timeout=15)
            run(*compose, 'down', '--volumes', '--remove-orphans')


if __name__ == '__main__':
    main()
