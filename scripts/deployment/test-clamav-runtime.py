"""Check the resident scanner using existing real signatures, synthetic files and no network.

Pass --image ACCEPTED_API_IMAGE --signatures-volume EXISTING_CLAMAV_VOLUME.
The exact image is tested without source overrides. The signature volume is mounted
read-only. The per-request comparison runs afterward in a separate container. No app
environment, database, storage provider, credential or customer file is used. Only
this run's containers are removed.
"""
import argparse
import json
from pathlib import Path
import re
import shutil
import subprocess
import time
import uuid


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--image', required=True)
    parser.add_argument('--signatures-volume', required=True)
    args = parser.parse_args()
    if not re.fullmatch(r'[a-zA-Z0-9][a-zA-Z0-9_.-]+', args.signatures_volume):
        raise ValueError('Select an existing named signature volume.')
    docker = shutil.which('docker') or str(Path.home() / 'AppData/Local/Programs/DockerDesktop/resources/bin/docker.exe')
    name = 'materyalph-scanner-check-' + uuid.uuid4().hex[:12]

    def run(*arguments, check=True, **kwargs):
        result = subprocess.run([docker, *arguments], capture_output=True, text=True, **kwargs)
        if check and result.returncode:
            raise RuntimeError(f'Docker {arguments[0]} failed ({result.returncode}): {result.stdout}{result.stderr}')
        return result

    # Refuse a typo instead of silently creating an empty volume.
    run('volume', 'inspect', args.signatures_volume)
    options = ['--name', name, '--network', 'none', '--memory', '2048m', '--cpus', '1',
               '--security-opt', 'no-new-privileges:true', '--cap-drop', 'ALL', '--env', 'TZ=UTC',
               '--mount', f'type=volume,src={args.signatures_volume},dst=/var/lib/clamav,readonly']
    started = False
    try:
        run('run', '-d', *options, args.image, 'clamd', '--config-file=/app/infrastructure/clamd.conf')
        started = True
        for _ in range(90):
            health = run('exec', name, 'php', '/app/infrastructure/clamav-health.php', check=False)
            if health.returncode == 0:
                break
            if run('inspect', '--format', '{{.State.Running}}', name).stdout.strip() != 'true':
                logs = run('logs', '--tail', '15', name)
                raise RuntimeError('Scanner stopped: ' + logs.stdout + logs.stderr)
            time.sleep(1)
        else:
            raise RuntimeError('Scanner did not load a fresh signature database.')
        result = run('exec', '-i', name, 'php', input=r'''<?php
require '/app/services/api/vendor/autoload.php';
$scanner = new App\Infrastructure\Files\ClamAvDaemonFileMalwareScanner('tcp://127.0.0.1:3310');
$path = tempnam('/tmp', 'synthetic-scan-');
$timings = [];
try {
    foreach ([64, 2621440, 26214400] as $size) {
        $file = fopen($path, 'wb');
        while (ftell($file) < $size) { fwrite($file, str_repeat('A', min(65536, $size - ftell($file)))); }
        fclose($file);
        clearstatcache();
        $start = microtime(true);
        $scanner->assertClean($path);
        $timings[(string) $size] = round((microtime(true) - $start) * 1000, 1);
    }
    // The standard antivirus test string is assembled only inside this disposable container.
    file_put_contents($path, 'X5O!P%@AP[4\PZX54(P^)7CC)7}'.'$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*');
    try { $scanner->assertClean($path); throw new RuntimeException('Malware fixture was accepted.'); }
    catch (App\Domain\Files\FileScanRejected) {}
    echo json_encode(['clean_scan_ms_by_bytes' => $timings,
        'eicar_rejected' => true, 'fresh_loaded_signatures' => true, 'network_isolated' => true]), PHP_EOL;
} finally { unlink($path); }
''')
        report = json.loads(result.stdout)
    finally:
        if started:
            run('rm', '-f', name)

    # Compare per-request startup after stopping the resident engine. Loading both
    # databases together would double memory use inside the daemon's 2 GiB budget.
    try:
        baseline = run('run', '--rm', '-i', *options, args.image, 'php', input=r'''<?php
require '/app/services/api/vendor/autoload.php';
$path = tempnam('/tmp', 'synthetic-baseline-');
try {
    file_put_contents($path, 'Harmless synthetic scan benchmark.');
    $baseline = new Symfony\Component\Process\Process(['clamscan', '--no-summary', '--infected', '--fail-if-cvd-older-than=7', $path]);
    $baseline->setTimeout(60);
    $start = microtime(true);
    $baseline->mustRun();
    echo json_encode(round((microtime(true) - $start) * 1000, 1)), PHP_EOL;
} finally { unlink($path); }
''')
        report['per_request_clamscan_ms'] = json.loads(baseline.stdout)
        print(json.dumps(report))
    finally:
        run('rm', '-f', name, check=False)


if __name__ == '__main__':
    main()
