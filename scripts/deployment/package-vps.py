"""Build an exact CI-approved commit off the VPS. Never deploy, push, or copy secrets."""
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tarfile
import tempfile
import urllib.request


def run(arguments, **kwargs):
    return subprocess.run(arguments, check=True, **kwargs)


def digest(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def main():
    repository, commit, output = sys.argv[1:]
    if not re.fullmatch(r'[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+', repository) or not re.fullmatch(r'[a-f0-9]{40}', commit):
        raise ValueError('Pass OWNER/REPO, an exact commit, and a new output directory.')
    destination = Path(output).resolve()
    if destination.exists():
        raise ValueError('Use a new output directory.')
    headers = {'Accept': 'application/vnd.github+json', 'User-Agent': 'MateryalPH-release'}
    if os.environ.get('GITHUB_TOKEN'):
        headers['Authorization'] = 'Bearer ' + os.environ['GITHUB_TOKEN']
    request = urllib.request.Request(f'https://api.github.com/repos/{repository}/actions/runs?head_sha={commit}&event=workflow_dispatch&per_page=100', headers=headers)
    with urllib.request.urlopen(request, timeout=30) as response:
        runs = json.load(response)['workflow_runs']
    accepted = next((item for item in runs if item['head_sha'] == commit and item['head_branch'] == 'staging' and item['path'] == '.github/workflows/ci.yml' and item['status'] == 'completed' and item['conclusion'] == 'success'), None)
    if accepted is None:
        raise ValueError('Run the full quality-gates workflow manually on the exact staging commit first.')
    for key in ['VENDOR_RECAPTCHA_SITE_KEY', 'ADMIN_RECAPTCHA_SITE_KEY', 'GOOGLE_MAPS_BROWSER_KEY']:
        if not os.environ.get(key):
            raise ValueError('Set the three public portal build inputs in the build environment.')
    destination.mkdir(parents=True, mode=0o700)
    root = Path(__file__).resolve().parents[2]
    with tempfile.TemporaryDirectory(prefix='materyalph-release-') as temporary:
        temporary = Path(temporary)
        archive = temporary / 'source.tar'
        run(['git', '-C', str(root), 'archive', '--format=tar', '--output', str(archive), commit])
        source = temporary / 'source'
        source.mkdir()
        with tarfile.open(archive) as stream:
            stream.extractall(source, filter='data')
        images = {}
        for role, dockerfile in [('api', 'api.render.Dockerfile'), ('edge', 'portals.vps.Dockerfile')]:
            image = f'materyalph-{role}:{commit}'
            command = ['docker', 'build', '--pull', '--platform=linux/amd64', '-f', str(source / 'infrastructure/docker' / dockerfile), '-t', image]
            if role == 'edge':
                for key in ['VENDOR_RECAPTCHA_SITE_KEY', 'ADMIN_RECAPTCHA_SITE_KEY', 'GOOGLE_MAPS_BROWSER_KEY']:
                    command += ['--build-arg', key]
            run(command + [str(source)])
            images[role] = run(['docker', 'image', 'inspect', image, '--format', '{{.Id}}'], capture_output=True, text=True).stdout.strip()
        # Base tags can move after CI. Verify these exact rebuilt images before delivery.
        for mode in [[], ['--vps']]:
            run([sys.executable, str(source / 'scripts/deployment/test-render-runtime.py'), '--image', images['api'], *mode])
        run(['docker', 'run', '--rm', '--network', 'none', '-e', 'API_HOST=api.example.test', '-e', 'VENDOR_HOST=vendor.example.test', '-e', 'ADMIN_HOST=admin.example.test', '-e', 'REVERB_HOST=ws.example.test', images['edge'], 'caddy', 'adapt', '--config', '/etc/caddy/Caddyfile', '--validate'], capture_output=True)
        for role, image in images.items():
            run(['trivy', 'image', '--exit-code', '1', '--severity', 'HIGH,CRITICAL', '--no-progress', image])
            run(['docker', 'save', '--output', str(destination / f'{role}.tar'), image])
        # Only the explicitly enumerated runtime files travel to the VPS.
        runtime = destination / 'runtime'
        runtime.mkdir()
        for item in ['compose.vps.yaml', 'infrastructure/vps/init-database.sh', 'infrastructure/vps/postgres-entrypoint.sh', 'scripts/deployment/vpsctl.sh', 'scripts/deployment/vps-host.py']:
            target = runtime / item
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(source / item, target)
        for name in ['vpsctl.sh', '../../infrastructure/vps/init-database.sh']:
            (runtime / 'scripts/deployment' / name).chmod(0o700)
        with tarfile.open(destination / 'runtime.tar', 'w') as stream:
            stream.add(runtime, arcname='runtime')
        record = {'format': 'materyalph-vps-release-v1', 'commit': commit, 'required_check': 'success', 'image_checks': 'runtime-and-trivy-passed', 'ci_run_url': accepted['html_url'], 'images': images,
                  'archives': {name: digest(destination / name) for name in ['api.tar', 'edge.tar', 'runtime.tar']}}
        (destination / 'release.json').write_text(json.dumps(record, indent=2) + '\n')
    print('Accepted release built. Verify archive checksums, load both images and install the runtime on the VPS; no deployment occurred.')


if __name__ == '__main__':
    try:
        main()
    except Exception:
        print('Release packaging failed. Check accepted CI evidence, public build inputs and local Docker; no credential values were logged.', file=sys.stderr)
        sys.exit(1)
