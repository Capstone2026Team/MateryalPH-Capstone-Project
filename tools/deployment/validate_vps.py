"""Repository-only infrastructure invariants. Live acceptance has separate evidence."""
from pathlib import Path
import yaml

ROOT = Path(__file__).resolve().parents[2]


def main():
    compose = yaml.safe_load((ROOT / 'compose.vps.yaml').read_text())
    services = compose['services']
    assert set(services) == {
        'postgres', 'redis', 'api', 'worker', 'scheduler', 'reverb', 'edge',
        'release', 'operator', 'backup', 'scanner', 'scanner-signatures',
    }
    assert [name for name, service in services.items() if service.get('ports')] == ['edge']
    assert compose['networks']['data']['internal'] is True
    assert compose['networks']['scanning']['internal'] is True
    assert services['scanner']['networks'] == ['scanning']
    assert services['scanner-signatures']['networks'] == ['egress']
    assert services['scanner']['volumes'] == ['scanner-signatures:/var/lib/clamav:ro']
    assert services['scanner-signatures']['volumes'] == ['scanner-signatures:/var/lib/clamav']
    for role in ['scanner', 'scanner-signatures']:
        assert 'env_file' not in services[role]
        assert services[role]['environment'] == {'TZ': 'UTC'}
    for role in ['api', 'worker', 'scheduler', 'release', 'operator']:
        runtime = services[role]
        assert runtime['environment']['RUN_QUEUE'] == 'false'
        assert runtime['environment']['RUN_SCHEDULER'] == 'false'
        assert runtime['environment']['APP_ENV'] == 'staging'
        assert runtime['environment']['XENDIT_MODE'] == 'TEST'
        assert runtime['environment']['LIVE_COMMERCE_ENABLED'] == 'false'
        assert 'build' not in runtime
    assert services['worker']['profiles'] == ['active']
    assert services['scheduler']['profiles'] == ['active']
    assert services['api']['volumes'] == ['runtime-state:/run/materyalph:ro']
    assert services['api']['environment']['SCANNER_DRIVER'] == 'clamd'
    assert services['api']['environment']['CLAMAV_ADDRESS'] == 'tcp://scanner:3310'
    assert services['api']['depends_on']['scanner']['condition'] == 'service_healthy'
    assert services['backup']['image'].startswith('restic/restic:')
    assert services['redis']['command'][2:4] == ['yes', '--maxmemory']
    for role in ['postgres', 'redis', 'api', 'worker', 'scheduler', 'reverb', 'edge', 'scanner', 'scanner-signatures']:
        assert services[role]['restart'] == 'unless-stopped'
        assert services[role]['logging']['options']['max-size'] == '10m'
    print('VPS private networking, independent roles, persistent services and staging guards passed.')


if __name__ == '__main__':
    main()
