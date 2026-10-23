"""Fresh, read-only local export after the operator has quiesced development writers."""
import json
from pathlib import Path
import subprocess
import sys


def main():
    target_key, output = map(lambda value: Path(value).resolve(), sys.argv[1:])
    root = Path(__file__).resolve().parents[2]
    if not target_key.is_file() or target_key.is_symlink() or output.exists() or not output.is_relative_to(root / '.tmp'):
        raise ValueError('Use a protected staging-key input and a NEW directory under .tmp.')
    docker = 'docker'
    import shutil
    if not shutil.which(docker):
        docker = str(Path.home() / 'AppData/Local/Programs/DockerDesktop/resources/bin/docker.exe')
    compose = [docker, 'compose', '-f', str(root / 'compose.yaml')]
    running = subprocess.run(compose + ['--profile', 'realtime', 'ps', '--status', 'running', '--services'], capture_output=True, text=True, check=True).stdout.splitlines()
    if set(running) & {'api', 'api-setup', 'horizon', 'scheduler', 'reverb'}:
        raise ValueError('Quiesce source writers first. This exporter never stops or modifies the local source.')
    if not {'postgres', 'minio'}.issubset(running):
        raise ValueError('Source PostgreSQL and private object storage must remain available.')
    output.mkdir(parents=True, mode=0o700)
    with (output / 'database.dump').open('xb') as stream:
        subprocess.run(compose + ['exec', '-T', 'postgres', 'sh', '-c', 'exec pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB" --format=custom --no-owner --no-acl --no-comments'], stdout=stream, stderr=subprocess.DEVNULL, check=True)
    subprocess.run(compose + ['run', '--rm', '--no-deps', '-T', '-v', f'{output}:/export', '-v', f'{target_key}:/run/target-key:ro', 'api', 'php', '/workspace/scripts/deployment/vps-transfer.php', 'export-source', '/export', '/run/target-key'], cwd=root, check=True)
    manifest = json.loads((output / 'manifest.json').read_text())
    print(json.dumps({'export_verified': True, 'database_bytes': manifest['database_bytes'], 'objects': len(manifest['objects']), 'source_keys_exported': False}))


if __name__ == '__main__':
    try:
        main()
    except Exception:
        print('Source export refused or failed. Check quiescence, Docker and the private input path; the source was not changed.', file=sys.stderr)
        sys.exit(1)
