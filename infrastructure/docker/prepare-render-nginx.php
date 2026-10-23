<?php

declare(strict_types=1);

// Static-site rewrites can replace Host. Preserve portal origins for absolute signed URLs,
// callback state and their verification, using the same exact Origin/Referer allowlist as the API.
$vendor = (string) getenv('FRONTEND_VENDOR_HOST');
$admin = (string) getenv('FRONTEND_ADMIN_HOST');
foreach ([$vendor, $admin] as $host) {
    if (! preg_match('/\A[a-z0-9][a-z0-9.-]*\z/i', $host)) {
        throw new RuntimeException('Set valid staging portal hostnames before starting the API.');
    }
}
$maps = 'map $http_origin $origin_host { default "";'."\n";
foreach ([$vendor, $admin] as $host) {
    $maps .= '"https://'.$host.'" "'.$host.'";'."\n";
}
$maps .= '} map $http_referer $referer_host { default $host;'."\n";
foreach ([$vendor, $admin] as $host) {
    $maps .= '~^https://'.preg_quote($host, '~').'(?:/|$) "'.$host.'";'."\n";
}
$maps .= <<<'NGINX'
}
map $origin_host $request_host { default $origin_host; "" $referer_host; }
map $request_uri $portal_host {
    default $request_host;
NGINX;
$maps .= "\n".'~^/api/v1/auth/google/callback(?:\?|$) "'.$vendor.'";'."\n}\n";
$directory = getenv('MATERYALPH_NGINX_DIRECTORY') ?: '/tmp/nginx';
if (file_put_contents($directory.'/portal-hosts.conf', $maps) === false) {
    throw new RuntimeException('Unable to prepare staging portal host configuration.');
}
$standby = getenv('DEPLOYMENT_STANDBY') ?: 'false';
if (! in_array($standby, ['true', 'false'], true)) {
    throw new RuntimeException('Invalid standby switch.');
}
// Static standby survives restarts; the VPS operator can also fence live HTTP
// before a consistent backup. /up remains a liveness probe in both cases.
$fence = ($standby === 'true' ? "return 503;\n" : '')."if (-f /run/materyalph/fenced) { return 503; }\n";
if (file_put_contents($directory.'/deployment-fence.conf', $fence) === false) {
    throw new RuntimeException('Unable to prepare deployment fence.');
}
