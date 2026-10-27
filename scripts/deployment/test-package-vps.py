"""Exercise release packaging with synthetic source and mocked external commands."""
import importlib.util
import io
import json
import os
from pathlib import Path
import subprocess
import sys
import tarfile
import tempfile
import unittest
from unittest.mock import patch


spec = importlib.util.spec_from_file_location('package_vps', Path(__file__).with_name('package-vps.py'))
package = importlib.util.module_from_spec(spec)
spec.loader.exec_module(package)

RUNTIME_FILES = [
    'compose.vps.yaml', 'infrastructure/vps/init-database.sh',
    'infrastructure/vps/postgres-entrypoint.sh', 'scripts/deployment/vpsctl.sh',
    'scripts/deployment/vps-host.py',
]


class ReleasePackagingTest(unittest.TestCase):
    def exercise(self, directory, reject_edge=False):
        destination = Path(directory) / 'release'
        commands = []
        commit = 'a' * 40

        def run(arguments, **kwargs):
            commands.append(arguments)
            if arguments[0] == 'git':
                with tarfile.open(arguments[arguments.index('--output') + 1], 'w') as archive:
                    for name in RUNTIME_FILES:
                        info = tarfile.TarInfo(name)
                        data = b'synthetic fixture\n'
                        info.size = len(data)
                        archive.addfile(info, io.BytesIO(data))
            elif arguments[:3] == ['docker', 'image', 'inspect']:
                role = 'b' if 'api' in arguments[3] else 'c'
                return subprocess.CompletedProcess(arguments, 0, stdout='sha256:' + role * 64)
            elif arguments[0] == 'trivy' and reject_edge and arguments[-1] == 'sha256:' + 'c' * 64:
                raise subprocess.CalledProcessError(1, arguments)
            elif arguments[:2] == ['docker', 'save']:
                Path(arguments[3]).write_bytes(b'synthetic image archive')
            return subprocess.CompletedProcess(arguments, 0)

        accepted = {'head_sha': commit, 'head_branch': 'staging', 'path': '.github/workflows/ci.yml',
                    'status': 'completed', 'conclusion': 'success',
                    'html_url': 'https://github.com/example/repository/actions/runs/1'}
        environment = {key: 'public-ci-only' for key in [
            'VENDOR_RECAPTCHA_SITE_KEY', 'ADMIN_RECAPTCHA_SITE_KEY', 'GOOGLE_MAPS_BROWSER_KEY',
        ]}
        with patch.object(sys, 'argv', ['package-vps.py', 'example/repository', commit, str(destination)]), \
                patch.dict(os.environ, environment), patch.object(package, 'fetch_runs', return_value=[accepted]), \
                patch.object(package, 'run', side_effect=run):
            if reject_edge:
                with self.assertRaises(subprocess.CalledProcessError):
                    package.main()
            else:
                package.main()
        return destination, commands

    def test_release_refreshes_edge_runtime_and_checks_exact_images(self):
        with tempfile.TemporaryDirectory() as directory:
            destination, commands = self.exercise(directory)
            builds = [command for command in commands if command[:2] == ['docker', 'build']]
            self.assertEqual(len(builds), 2)
            self.assertNotIn('--no-cache-filter', builds[0])
            self.assertEqual(builds[1][builds[1].index('--no-cache-filter') + 1], 'edge-runtime')
            record = json.loads((destination / 'release.json').read_text())
            scans = [command for command in commands if command[0] == 'trivy']
            self.assertEqual([command[-1] for command in scans], list(record['images'].values()))
            for command in scans:
                self.assertEqual(command[command.index('--exit-code') + 1], '1')
                self.assertEqual(command[command.index('--severity') + 1], 'HIGH,CRITICAL')
            for name, checksum in record['archives'].items():
                self.assertEqual(package.digest(destination / name), checksum)

    def test_edge_security_failure_cannot_produce_an_accepted_release(self):
        with tempfile.TemporaryDirectory() as directory:
            destination, commands = self.exercise(directory, reject_edge=True)
            self.assertFalse((destination / 'release.json').exists())
            self.assertFalse((destination / 'edge.tar').exists())
            self.assertEqual(len([command for command in commands if command[0] == 'trivy']), 2)


if __name__ == '__main__':
    unittest.main()
