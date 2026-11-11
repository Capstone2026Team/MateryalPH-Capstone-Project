<?php

declare(strict_types=1);

// A bounded protocol fixture. It never opens user files or reaches a real provider.
$options = json_decode($argv[1], true, flags: JSON_THROW_ON_ERROR);
$server = stream_socket_server('tcp://127.0.0.1:0');
if ($server === false) {
    exit(1);
}
echo stream_socket_get_name($server, false), PHP_EOL;
flush();

function readBytes($socket, int $length): string
{
    $bytes = '';
    while (strlen($bytes) < $length) {
        $chunk = fread($socket, $length - strlen($bytes));
        if ($chunk === false || $chunk === '') {
            throw new RuntimeException('Incomplete fixture request.');
        }
        $bytes .= $chunk;
    }

    return $bytes;
}

try {
    for ($request = 0; $request < ($options['connections'] ?? 2); $request++) {
        $socket = stream_socket_accept($server, 5);
        if ($socket === false) {
            exit(2);
        }
        stream_set_timeout($socket, 3);
        $command = '';
        while (! str_ends_with($command, "\0") && strlen($command) < 32) {
            $command .= readBytes($socket, 1);
        }
        if ($command === "zVERSION\0") {
            $version = $options['version'] ?? 'ClamAV 1.4.6/28000/'.gmdate('D M j H:i:s Y');
            fwrite($socket, $version.($options['unterminated_version'] ?? false ? '' : "\0"));
        } elseif ($command === "zINSTREAM\0") {
            $hash = hash_init('sha256');
            $size = 0;
            while (true) {
                $length = unpack('Nlength', readBytes($socket, 4))['length'];
                if ($length === 0) {
                    break;
                }
                if ($length > 65536 || $size + $length > 25 * 1024 * 1024) {
                    exit(3);
                }
                hash_update($hash, readBytes($socket, $length));
                $size += $length;
            }
            if (($options['sha256'] ?? null) !== hash_final($hash) || $size !== ($options['size'] ?? null)) {
                exit(4);
            }
            if (isset($options['delay_ms'])) {
                usleep($options['delay_ms'] * 1000);
            }
            if (isset($options['mutate_path'])) {
                file_put_contents($options['mutate_path'], 'Changed during scan.');
            }
            @fwrite($socket, ($options['reply'] ?? 'stream: OK').($options['unterminated_reply'] ?? false ? '' : "\0"));
        } else {
            exit(5);
        }
        fclose($socket);
    }
} finally {
    fclose($server);
}
