#!/usr/bin/env bash
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
control="${1:?Pass the private deployment control file}"
compose=(docker compose --env-file "$control" -f "$root/compose.vps.yaml")
date -u +%FT%TZ
"${compose[@]}" --profile active ps --format 'table {{.Service}}\t{{.State}}\t{{.Health}}'
containers="$("${compose[@]}" --profile active ps -q)"
if [[ -n "$containers" ]]; then
    # Docker returns only container IDs here, never configuration or environment values.
    docker stats --no-stream --format '{{.Name}} CPU={{.CPUPerc}} RAM={{.MemUsage}}' $containers
fi
recovery="$(python3 "$root/scripts/deployment/vps-host.py" value "$control" VPS_RECOVERY_DIRECTORY)"
python3 - "$recovery/last-success" <<'PY'
from datetime import datetime, timezone
from pathlib import Path
import sys
path = Path(sys.argv[1])
if not path.is_file():
    print('OFFSITE BACKUP: missing'); sys.exit(1)
age = (datetime.now(timezone.utc) - datetime.fromisoformat(path.read_text().strip().replace('Z', '+00:00'))).total_seconds()
print(f'OFFSITE BACKUP age_hours={age / 3600:.1f}')
if not 0 <= age <= 86400:
    sys.exit(1)
PY
"${compose[@]}" run --rm --no-deps -T operator php /app/infrastructure/vps-transfer.php inspect /recovery
