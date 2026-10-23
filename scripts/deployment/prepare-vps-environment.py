"""Prepare ignored Hostinger configuration from existing Render staging secrets without logging values.

Reads Render only. Does not deploy, alter providers or copy development credentials.
Run with access to the protected Render CLI configuration and PyYAML installed.
"""
import base64
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import re
import secrets
import subprocess
import sys
import urllib.parse
import urllib.request
import yaml

ROOT = Path(__file__).resolve().parents[2]
OWNER = 'tea-db8ouuc9v7es73dc3u7g'
STAGING_SERVICE = 'srv-dbb2uafbtjjs7395h1r0'
GROUP = 'evg-dbb2t6mq1p3s73dkv8v0'


def read_example(path):
    values = {}
    for line in path.read_text().splitlines():
        if line and not line.startswith('#') and '=' in line:
            key, value = line.split('=', 1)
            values[key] = value.split(' #', 1)[0]
    return values


def save(path, text):
    with path.open('x', encoding='utf-8', newline='\n') as stream:
        os.chmod(path, 0o600)
        stream.write(text)


def save_environment(path, values):
    if any(not re.fullmatch(r'[A-Z][A-Z0-9_]*', key) or any(character in value for character in ['\n', '\r', '\0']) for key, value in values.items()):
        raise ValueError('Only flat environment values are supported; use existing base64 fields for structured secrets.')
    save(path, ''.join(f'{key}={value}\n' for key, value in values.items()))


def private_directory(path):
    path.mkdir(parents=True, mode=0o700)
    if os.name == 'nt':
        identity = subprocess.run(
            ['powershell.exe', '-NoProfile', '-NonInteractive', '-Command',
             '[System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value'],
            check=True, capture_output=True, text=True,
        ).stdout.strip()
        if not re.fullmatch(r'S-1-5-\d+(?:-\d+)+', identity):
            raise ValueError('The private draft needs a verified local operator identity.')
        # Remove inherited access before writing any secret. Use SIDs across Windows locales.
        subprocess.run(
            ['icacls.exe', str(path), '/inheritance:r', '/grant:r',
             f'*{identity}:(OI)(CI)F', '*S-1-5-18:(OI)(CI)F'],
            check=True, capture_output=True,
        )


def main():
    destination = Path(sys.argv[1]).resolve()
    if destination.exists() or not destination.is_relative_to(ROOT / '.tmp'):
        raise ValueError('Use a NEW private directory under .tmp.')
    settings = yaml.safe_load((Path.home() / '.render/cli.yaml').read_text())
    token = settings['api']['key']
    class NoRedirect(urllib.request.HTTPRedirectHandler):
        def redirect_request(self, *args, **kwargs):
            return None
    opener = urllib.request.build_opener(NoRedirect)

    def get(path):
        request = urllib.request.Request('https://api.render.com/v1' + path, headers={'Authorization': 'Bearer ' + token, 'Accept': 'application/json', 'User-Agent': 'MateryalPH-VPS-config'})
        with opener.open(request, timeout=30) as response:
            return json.load(response)

    service = get('/services/' + STAGING_SERVICE)
    service = service.get('service', service)
    if service.get('ownerId') != OWNER or service.get('name') != 'materyalph-staging-api':
        raise ValueError('Confirmed staging service ownership is required.')
    group = get('/env-groups/' + GROUP)
    group = group.get('envGroup', group)
    inherited = {item.get('envVar', item)['key']: item.get('envVar', item)['value'] for item in group['envVars']}
    cursor = None
    for page in range(10):
        query = '?limit=100' + ('&cursor=' + urllib.parse.quote(cursor, safe='') if cursor else '')
        entries = get('/services/' + STAGING_SERVICE + '/env-vars' + query)
        for entry in entries:
            variable = entry.get('envVar', entry)
            inherited[variable['key']] = variable['value']
        if len(entries) < 100:
            break
        cursor = entries[-1].get('cursor')
        if not cursor:
            raise ValueError('Incomplete staging configuration pagination.')
    else:
        raise ValueError('Unexpected staging configuration pagination.')
    if inherited.get('APP_ENV') != 'staging' or inherited.get('XENDIT_MODE') != 'TEST' or inherited.get('LIVE_COMMERCE_ENABLED') != 'false':
        raise ValueError('Staging TEST isolation guard failed.')
    values = read_example(ROOT / 'infrastructure/vps/api/.env.example')
    keep_local = {'APP_URL', 'DB_HOST', 'DB_PORT', 'DB_DATABASE', 'DB_USERNAME', 'DB_PASSWORD', 'DB_SSLMODE', 'REDIS_URL', 'TRUSTED_PROXIES', 'FRONTEND_VENDOR_HOST', 'FRONTEND_ADMIN_HOST',
                  'FRONTEND_VENDOR_URL', 'FRONTEND_ADMIN_URL', 'CORS_ALLOWED_ORIGINS', 'RECAPTCHA_VENDOR_WEB_ALLOWED_HOSTNAMES', 'RECAPTCHA_ADMIN_WEB_ALLOWED_HOSTNAMES', 'GOOGLE_OIDC_REDIRECT_URI',
                  'BROADCAST_CONNECTION', 'REVERB_HOST', 'REVERB_PORT', 'REVERB_SCHEME', 'REVERB_PUBLIC_HOST', 'REVERB_PUBLIC_PORT', 'REVERB_PUBLIC_SCHEME', 'MAIL_DELIVERY_NOT_BEFORE', 'OUTBOX_DELIVERY_NOT_BEFORE'}
    copied = []
    for key in values:
        if key not in keep_local and inherited.get(key):
            values[key] = inherited[key]
            copied.append(key)
    key = values['APP_KEY']
    if not key.startswith('base64:'):
        key = 'base64:' + key
    if len(base64.b64decode(key[7:], validate=True)) != 32:
        raise ValueError('The existing staging encryption identity is incomplete.')
    values['APP_KEY'] = key
    values['DB_PASSWORD'] = secrets.token_hex(32)
    for name, expected in {'APP_ENV': 'staging', 'APP_DEBUG': 'false', 'XENDIT_MODE': 'TEST', 'LIVE_COMMERCE_ENABLED': 'false', 'FINANCE_MODE': 'TEST',
                           'FILESYSTEM_DISK': 's3', 'VENDOR_PRIVATE_DISK': 's3', 'STAGING_LEGACY_FILES_ON_S3': 'true', 'IMPORTED_DATA_RECOVERY_ENABLED': 'true', 'MAIL_REQUIRE_TLS': 'true',
                           'COOKIE_SECURE': 'true', 'SESSION_DOMAIN': '', 'SCANNER_DRIVER': 'bouncer'}.items():
        values[name] = expected
    private_directory(destination)
    save_environment(destination / 'api.env', values)
    save(destination / 'db-app-password', values['DB_PASSWORD'] + '\n')
    save(destination / 'db-owner-password', secrets.token_hex(32) + '\n')
    save(destination / 'backup-password', secrets.token_hex(32) + '\n')
    save(destination / 'staging-app-key', key + '\n')
    reverb = read_example(ROOT / 'infrastructure/vps/reverb/.env.example')
    for name in ['APP_ENV', 'APP_DEBUG', 'APP_KEY', 'REVERB_APP_ID', 'REVERB_APP_KEY', 'REVERB_APP_SECRET']:
        reverb[name] = values[name]
    save_environment(destination / 'reverb.env', reverb)
    missing = [name for name, value in values.items() if not value and name not in {'SESSION_DOMAIN', 'MAIL_DELIVERY_NOT_BEFORE', 'OUTBOX_DELIVERY_NOT_BEFORE'}]
    report = {'prepared_at': datetime.now(timezone.utc).isoformat(), 'source': 'existing Render staging only', 'copied_names': copied, 'missing_names': missing,
              'pending': ['fresh-import mail/outbox boundaries', 'separate scoped offsite backup repository', 'exact accepted CI commit/images', 'provider hostname allowlists']}
    save(destination / 'readiness.json', json.dumps(report, indent=2) + '\n')
    print(json.dumps({'configuration_prepared': True, 'copied_setting_count': len(copied), 'missing_names': missing, 'secret_values_displayed': False, 'render_modified': False}))


if __name__ == '__main__':
    try:
        main()
    except Exception:
        print('Staging configuration preparation refused or failed; no credentials or provider response values were logged.', file=sys.stderr)
        sys.exit(1)
