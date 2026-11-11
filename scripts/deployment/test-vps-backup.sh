#!/usr/bin/env bash
# Run the real backup control flow with synthetic files and mocked external commands.
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
mkdir -p "$root/.tmp"
fixture="$(mktemp -d "$root/.tmp/vps-backup-test-XXXXXX")"
cleanup() {
    [[ "$fixture" = "$root"/.tmp/vps-backup-test-* && ! -L "$fixture" ]] || return 1
    rm -rf -- "$fixture"
}
trap cleanup EXIT
mkdir -p "$fixture/runtime/scripts/deployment" "$fixture/bin"
cp "$root/scripts/deployment/vpsctl.sh" "$fixture/runtime/scripts/deployment/vpsctl.sh"
printf 'SYNTHETIC_ONLY=true\n' > "$fixture/control"

cat > "$fixture/bin/python3" <<'SH'
#!/usr/bin/env bash
set -eu
case "$2" in
    value) [[ "$4" = VPS_RECOVERY_DIRECTORY ]]; printf '%s\n' "$TEST_BACKUP_STATE/recovery" ;;
    database) printf 'synthetic_database\n' ;;
    *) exit 99 ;;
esac
SH
cat > "$fixture/bin/flock" <<'SH'
#!/usr/bin/env bash
exit 0
SH
cat > "$fixture/bin/docker" <<'SH'
#!/usr/bin/env bash
set -eu
printf '%s ' "$@" >> "$TEST_BACKUP_STATE/commands"
printf '\n' >> "$TEST_BACKUP_STATE/commands"
if [[ "$1" = start ]]; then
    [[ "${TEST_FAIL_START:-}" != "$2" ]]
    exit
fi
[[ "$1" = compose ]] || exit 99
while [[ "$1" != ps && "$1" != run && "$1" != start && "$1" != stop && "$1" != exec ]]; do shift; done
case "$1" in
    ps)
        if [[ " $* " = *' --services '* ]]; then
            for service in $TEST_RUNNING_SERVICES; do printf '%s\n' "$service"; done
        else
            service="${!#}"
            if [[ " $TEST_RUNNING_SERVICES " = *" $service "* ]]; then printf 'id-%s-before\n' "$service"; fi
        fi
        ;;
    start)
        echo 'dependency failed to start: scanner-signatures has no healthcheck configured' >&2
        exit 1
        ;;
    stop) ;;
    exec) printf 'synthetic-database-dump\n' ;;
    run)
        case " $* " in
            *' operator test -f '*) [[ -f "$TEST_BACKUP_STATE/fenced" ]] ;;
            *' operator touch '*) touch "$TEST_BACKUP_STATE/fenced" ;;
            *' operator rm -f '*) rm -f -- "$TEST_BACKUP_STATE/fenced" ;;
            *' operator php '*' export '*) [[ "${TEST_FAIL_EXPORT:-false}" = false ]] ;;
            *' backup '*) ;;
            *) exit 99 ;;
        esac
        ;;
esac
SH
chmod +x "$fixture/bin/"*
export PATH="$fixture/bin:$PATH"

scenario() {
    local name="$1" running="$2" initially_fenced="$3" expected_status="$4" expected_starts="$5"
    export TEST_BACKUP_STATE="$fixture/$name" TEST_RUNNING_SERVICES="$running"
    mkdir -p "$TEST_BACKUP_STATE/recovery"
    [[ "$initially_fenced" = false ]] || touch "$TEST_BACKUP_STATE/fenced"
    local status=0
    bash "$fixture/runtime/scripts/deployment/vpsctl.sh" backup "$fixture/control" > "$TEST_BACKUP_STATE/output" 2>&1 || status=$?
    if [[ "$status" != "$expected_status" ]]; then
        cat "$TEST_BACKUP_STATE/output" >&2
        echo "FAIL: $name returned $status, expected $expected_status" >&2
        exit 1
    fi
    local actual_starts
    actual_starts="$(awk '$1 == "start" { print $2 }' "$TEST_BACKUP_STATE/commands" | paste -sd ' ' -)"
    [[ "$actual_starts" = "$expected_starts" ]] || { echo "FAIL: $name restarted '$actual_starts'" >&2; exit 1; }
    if [[ "$initially_fenced" = true ]]; then
        [[ -f "$TEST_BACKUP_STATE/fenced" ]]
    else
        [[ ! -f "$TEST_BACKUP_STATE/fenced" ]]
    fi
    if [[ "${TEST_FAIL_EXPORT:-false}" = true ]]; then
        [[ ! -f "$TEST_BACKUP_STATE/recovery/last-success" ]]
        compgen -G "$TEST_BACKUP_STATE/recovery/bundle-*" > /dev/null
    else
        [[ -f "$TEST_BACKUP_STATE/recovery/last-success" ]]
    fi
    local unexpected_starts
    unexpected_starts="$(awk '$1 == "compose" && / (start|up) / { print }' "$TEST_BACKUP_STATE/commands")"
    [[ -z "$unexpected_starts" ]] || { echo 'FAIL: backup reconciled Compose dependencies' >&2; exit 1; }
    echo "PASS: $name"
}

scenario legacy-healthcheck-upgrade 'api reverb worker scheduler' false 0 'id-api-before id-reverb-before id-worker-before id-scheduler-before'
scenario retain-fenced-state 'api reverb worker scheduler' true 0 'id-api-before id-reverb-before'
scenario leave-stopped-services-stopped 'reverb worker' false 0 'id-reverb-before id-worker-before'
export TEST_FAIL_EXPORT=true
scenario failed-export-restores-existing-containers 'api reverb worker scheduler' false 1 'id-api-before id-reverb-before id-worker-before id-scheduler-before'
unset TEST_FAIL_EXPORT
export TEST_FAIL_START=id-api-before
scenario failed-restart-blocks-release 'api reverb worker scheduler' false 1 'id-api-before id-reverb-before id-worker-before id-scheduler-before'
