"""Exercise the Render Nginx/FPM configuration without application data or providers.

Build the production image first, then run:
    python scripts/deployment/test-render-runtime.py --image materyalph-api:staging-review
Only the uniquely named, network-isolated test container is removed afterward.
"""

import argparse
import json
from pathlib import Path
import shutil
import subprocess
import uuid


ROOT = Path(__file__).resolve().parents[2]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--image", default="materyalph-api:staging-review")
    args = parser.parse_args()
    docker = shutil.which("docker")
    if not docker:
        candidate = Path.home() / "AppData/Local/Programs/DockerDesktop/resources/bin/docker.exe"
        if candidate.is_file():
            docker = str(candidate)
    if not docker:
        raise RuntimeError("Docker Desktop CLI is required")

    name = "materyalph-runtime-check-" + uuid.uuid4().hex[:12]
    fixture = (ROOT / ".tmp/staging-deployment" / name).resolve()
    assert fixture.is_relative_to(ROOT / ".tmp/staging-deployment")
    fixture.mkdir(parents=True)
    public = fixture / "public"
    public.mkdir()
    (public / "index.php").write_text(
        "<?php\n"
        "$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);\n"
        "if ($path === '/upload') {\n"
        "    $result = [];\n"
        "    foreach ($_FILES as $file) { $result[] = $file['error'] . ':' . $file['size']; }\n"
        "    echo implode(',', $result);\n"
        "} elseif (preg_match('#^/slow/([12])$#', $path, $match)) {\n"
        "    touch('/tmp/runtime-start-' . $match[1]);\n"
        "    sleep(6);\n"
        "    echo 'slow-ok';\n"
        "} else { echo 'fast-ok'; }\n",
        encoding="utf-8",
    )
    (fixture / "portal-hosts.conf").write_text(
        "map $host $portal_host { default $host; }\n", encoding="utf-8"
    )
    (fixture / "check.php").write_text(
        r'''<?php
function request(string $path, string $method = 'GET'): array {
    $context = stream_context_create(['http' => [
        'method' => $method, 'timeout' => 12, 'ignore_errors' => true,
    ]]);
    $start = microtime(true);
    $body = @file_get_contents('http://127.0.0.1:10000'.$path, false, $context);
    preg_match('/ (\d{3}) /', $http_response_header[0] ?? '', $match);
    return [(int) ($match[1] ?? 0), $body, microtime(true) - $start];
}
function verify(bool $condition, string $message): void {
    if (!$condition) { throw new RuntimeException($message); }
}
function upload(array $sizes): array {
    $boundary = 'materyalph-runtime-fixture';
    $headers = [];
    foreach ($sizes as $index => $size) {
        $headers[] = '--'.$boundary."\r\nContent-Disposition: form-data; name=\"file$index\"; filename=\"fixture.bin\"\r\nContent-Type: application/octet-stream\r\n\r\n";
    }
    $end = '--'.$boundary."--\r\n";
    $length = array_sum(array_map('strlen', $headers)) + array_sum($sizes) + count($sizes) * 2 + strlen($end);
    $socket = fsockopen('127.0.0.1', 10000, $code, $message, 5);
    verify(is_resource($socket), 'upload fixture could not connect');
    stream_set_timeout($socket, 20);
    fwrite($socket, "POST /upload HTTP/1.1\r\nHost: localhost\r\nConnection: close\r\nContent-Type: multipart/form-data; boundary=$boundary\r\nContent-Length: $length\r\n\r\n");
    foreach ($sizes as $index => $size) {
        fwrite($socket, $headers[$index]);
        while ($size > 0) {
            $written = fwrite($socket, str_repeat('x', min(32768, $size)));
            verify(is_int($written) && $written > 0, 'upload body was rejected before completion');
            $size -= $written;
        }
        fwrite($socket, "\r\n");
    }
    fwrite($socket, $end);
    $response = stream_get_contents($socket);
    fclose($socket);
    [$responseHeaders, $body] = explode("\r\n\r\n", $response, 2);
    preg_match('/ (\d{3}) /', strtok($responseHeaders, "\r\n"), $match);
    // Nginx uses chunked transfer for this fixture; retain the file result independently of framing.
    return [(int) ($match[1] ?? 0), $body];
}
for ($attempt = 0; $attempt < 100; $attempt++) {
    if (request('/fast')[0] === 200) { break; }
    usleep(100000);
}
verify(request('/fast')[1] === 'fast-ok', 'ordinary PHP request failed');
verify(request('/api/v1/vendors/account/photo?signature=runtime-query-redaction-fixture')[0] === 200, 'rewritten diagnostic route failed');
[$uploadStatus, $uploadBody] = upload([25 * 1024 * 1024]);
verify($uploadStatus === 200 && str_contains($uploadBody, '0:26214400'), '25 MiB upload failed');
[$batchStatus, $batchBody] = upload([20 * 1024 * 1024, 20 * 1024 * 1024]);
verify($batchStatus === 200 && str_contains($batchBody, '0:20971520,0:20971520'), 'multipart request above 32 MiB failed');
[$tooLargeStatus, $tooLargeBody] = upload([25 * 1024 * 1024 + 1]);
verify($tooLargeStatus === 200 && str_contains($tooLargeBody, '1:0'), 'PHP did not reject the oversized file');
$socket = fsockopen('127.0.0.1', 10000, $code, $message, 5);
fwrite($socket, "POST /upload HTTP/1.1\r\nHost: localhost\r\nConnection: close\r\nContent-Length: 84934656\r\n\r\n");
$oversizedStatus = fgets($socket);
fclose($socket);
verify(str_contains($oversizedStatus, ' 413 '), 'Nginx did not reject a request above 80 MiB');
$children = [];
foreach ([1, 2] as $number) {
    $pid = pcntl_fork();
    verify($pid !== -1, 'fork failed');
    if ($pid === 0) {
        [$status, $body] = request('/slow/'.$number);
        exit($status === 200 && $body === 'slow-ok' ? 0 : 1);
    }
    $children[] = $pid;
}
$deadline = microtime(true) + 3;
do {
    clearstatcache();
    $busy = is_file('/tmp/runtime-start-1') && is_file('/tmp/runtime-start-2');
    if (!$busy) { usleep(50000); }
} while (!$busy && microtime(true) < $deadline);
verify($busy, 'two ordinary request workers did not start concurrently');
[$status, $body, $duration] = request('/up');
verify($status === 200 && $body === 'ok', 'FPM ping failed while ordinary workers were busy');
verify($duration < 1, 'FPM ping exceeded one second');
[$headStatus, $headBody] = request('/up', 'HEAD');
verify($headStatus === 200 && $headBody === '', 'HEAD health check failed');
foreach ($children as $pid) {
    pcntl_waitpid($pid, $result);
    verify(pcntl_wifexited($result) && pcntl_wexitstatus($result) === 0, 'slow request failed');
}
verify(posix_kill((int) file_get_contents('/tmp/test-fpm.pid'), SIGTERM), 'could not stop fixture FPM');
for ($attempt = 0; $attempt < 50; $attempt++) {
    [$downStatus] = request('/up');
    if ($downStatus === 502) { break; }
    usleep(100000);
}
verify($downStatus === 502, 'health check falsely succeeded after FPM stopped');
echo json_encode([
    'ordinary_request_passed' => true,
    'full_25_mib_upload_passed' => true,
    'multipart_above_32_mib_passed' => true,
    'php_file_limit_enforced' => true,
    'nginx_request_limit_enforced' => true,
    'concurrent_request_workers' => 2,
    'health_while_workers_busy_passed' => true,
    'health_latency_ms' => round($duration * 1000, 1),
    'head_health_passed' => true,
    'fpm_failure_detected' => true,
    'network_isolated' => true,
    'memory_limit_mib' => 512,
]).PHP_EOL;
''',
        encoding="utf-8",
    )

    def run(*arguments, check=True):
        return subprocess.run(
            [docker, *arguments], cwd=ROOT, capture_output=True, text=True, check=check
        )

    started = False
    try:
        run(
            "run", "-d", "--name", name, "--network", "none", "--memory", "512m",
            "--cpus", "0.5", "--entrypoint", "/bin/sh",
            "--mount", f"type=bind,src={ROOT / 'infrastructure/docker/render-nginx.conf'},dst=/check/nginx.conf,readonly",
            "--mount", f"type=bind,src={ROOT / 'infrastructure/docker/render-php-fpm.conf'},dst=/usr/local/etc/php-fpm.d/zz-render.conf,readonly",
            "--mount", f"type=bind,src={ROOT / 'infrastructure/docker/uploads.ini'},dst=/usr/local/etc/php/conf.d/uploads.ini,readonly",
            "--mount", f"type=bind,src={public},dst=/app/services/api/public,readonly",
            "--mount", f"type=bind,src={fixture},dst=/fixture,readonly",
            args.image, "-c",
            'mkdir -p /tmp/nginx; cp /fixture/portal-hosts.conf /tmp/nginx/portal-hosts.conf; '
            'php-fpm -F & echo $! > /tmp/test-fpm.pid; '
            'nginx -e /dev/null -c /check/nginx.conf -g "daemon off;" & wait',
        )
        started = True
        result = run("exec", name, "php", "/fixture/check.php", check=False)
        if result.returncode:
            # The fixture has no secrets, request data or provider access.
            logs = run("logs", "--tail", "30", name, check=False)
            raise RuntimeError(result.stdout + result.stderr + logs.stdout + logs.stderr)
        logs = run("logs", name, check=False)
        log_text = logs.stdout + logs.stderr
        assert "GET /api/v1/vendors/account/photo 200 " in log_text, "original route missing from access log"
        assert "runtime-query-redaction-fixture" not in log_text, "query leaked into access log"
        report = json.loads(result.stdout)
        report["original_route_logged"] = True
        report["query_string_redacted"] = True
        print(json.dumps(report))
    finally:
        if started:
            run("rm", "-f", name)


if __name__ == "__main__":
    main()
