#!/usr/bin/env bash
# Operator-controlled Ubuntu VPS operations. Never source private environment files as shell code.
set -euo pipefail
umask 077
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)"
command="${1:-}"
control="${2:-}"
[[ -f "$control" && ! -L "$control" ]] || { echo 'Pass an ordinary private deployment control file.' >&2; exit 1; }
control="$(realpath -- "$control")"
cd "$root"
compose=(docker compose --env-file "$control" -f "$root/compose.vps.yaml")
value() { python3 "$root/scripts/deployment/vps-host.py" value "$control" "$1"; }
recovery="$(value VPS_RECOVERY_DIRECTORY)"
[[ "$recovery" = /* && ! -L "$recovery" ]] || { echo 'Recovery directory must be absolute and cannot be a symlink.' >&2; exit 1; }
mkdir -p -- "$recovery"
chmod 700 -- "$recovery"
exec 9>"$recovery/.operator.lock"
flock -n 9 || { echo 'Another release/recovery operation is running.' >&2; exit 1; }
operator() { "${compose[@]}" run --rm --no-deps -T operator "$@"; }
fence() {
    operator touch /run/materyalph/fenced
    "${compose[@]}" --profile active stop worker scheduler
}
fenced() { operator test -f /run/materyalph/fenced; }
case "$command" in
  initialize)
    # Explicit operator action; initializing restic is intentionally not automatic in nightly backups.
    "${compose[@]}" up -d postgres redis
    operator touch /run/materyalph/fenced
    "${compose[@]}" run --rm -T backup init --quiet
    ;;
  deploy)
    release="${3:?Pass the accepted release.json path}"
    python3 "$root/scripts/deployment/vps-host.py" release "$control" "$release"
    python3 "$root/scripts/deployment/vps-host.py" backup-recent "$control"
    "${compose[@]}" config --quiet
    "${compose[@]}" up -d postgres redis
    fence
    "${compose[@]}" run --rm -T release
    "${compose[@]}" up -d --force-recreate api reverb edge
    echo 'Release is running fenced. Run smoke tests and approve activation separately.'
    ;;
  fence)
    fence
    ;;
  activate)
    evidence="${3:?Pass the completed acceptance/recovery-review JSON path}"
    python3 "$root/scripts/deployment/vps-host.py" activate "$control" "$evidence"
    "${compose[@]}" --profile active up -d worker scheduler
    operator rm -f /run/materyalph/fenced
    echo 'Primary activated; verify public routing and providers immediately.'
    ;;
  rehearse)
    evidence="${3:?Pass the import/provider review JSON path}"
    python3 "$root/scripts/deployment/vps-host.py" rehearse "$control" "$evidence"
    "${compose[@]}" --profile active up -d worker scheduler
    operator rm -f /run/materyalph/fenced
    echo 'Controlled staging rehearsal opened. Finish acceptance/load/recovery tests, then record activation.'
    ;;
  inspect)
    operator php /app/infrastructure/vps-transfer.php inspect /recovery
    ;;
  backup)
    bundle="$(mktemp -d "$recovery/bundle-XXXXXXXX")"
    relative="/recovery/$(basename -- "$bundle")"
    was_fenced=false
    fenced && was_fenced=true
    running="$("${compose[@]}" --profile active ps --status running --services)"
    cleanup() {
      result=$?
      trap - EXIT
      for service in api reverb; do
        if [[ $'\n'"$running"$'\n' = *$'\n'"$service"$'\n'* ]]; then "${compose[@]}" start "$service" || result=1; fi
      done
      if [[ "$was_fenced" = false ]]; then
        for service in worker scheduler; do
          if [[ $'\n'"$running"$'\n' = *$'\n'"$service"$'\n'* ]]; then "${compose[@]}" --profile active start "$service" || result=1; fi
        done
        operator rm -f /run/materyalph/fenced || result=1
      fi
      # Only our verified mktemp child is removed; failed bundles stay private for diagnosis.
      if [[ "$result" = 0 && "$bundle" = "$recovery"/bundle-* && ! -L "$bundle" ]]; then rm -rf -- "$bundle"; fi
      exit "$result"
    }
    trap cleanup EXIT
    fence
    # Drain/stop HTTP and WebSockets so no in-flight transaction can race the dump/files snapshot.
    "${compose[@]}" stop api reverb
    database="$(python3 "$root/scripts/deployment/vps-host.py" database "$control")"
    "${compose[@]}" exec -T postgres sh -c 'exec pg_dump -U "$POSTGRES_USER" -d "$1" --format=custom --no-owner --no-acl --no-comments' sh "$database" > "$bundle/database.dump"
    operator php /app/infrastructure/vps-transfer.php export "$relative"
    "${compose[@]}" run --rm -T backup backup --quiet --host materyalph-primary --tag materyalph-vps "$relative"
    "${compose[@]}" run --rm -T backup check --quiet --read-data-subset=1/7
    "${compose[@]}" run --rm -T backup forget --quiet --host materyalph-primary --tag materyalph-vps --group-by host,tags --keep-daily 7 --keep-weekly 4 --prune
    "${compose[@]}" run --rm -T backup check --quiet
    date -u +%FT%TZ > "$recovery/last-success"
    echo 'Encrypted offsite database/object recovery set verified.'
    ;;
  fetch)
    snapshot="${3:?Pass an explicit restic snapshot ID}"
    [[ "$snapshot" =~ ^[a-f0-9]{8,64}$ ]] || { echo 'Use an explicit snapshot ID.' >&2; exit 1; }
    name="restored-$(date -u +%Y%m%d%H%M%S)"
    [[ ! -e "$recovery/$name" ]] || exit 1
    "${compose[@]}" run --rm -T backup restore "$snapshot" --target "/recovery/$name" --quiet
    echo "Recovery files restored under $recovery/$name; verify the single selected manifest before restore-new."
    ;;
  restore-new)
    bundle="${3:?Pass the recovery directory containing manifest.json}"
    name="${4:?Pass a new name: materyalph_restore_YYYYMMDDHHMMSS}"
    [[ "$name" =~ ^materyalph_restore_[0-9]{14}$ ]] || exit 1
    [[ "$(realpath -- "$bundle")" = "$recovery"/* && ! -L "$bundle" ]] || exit 1
    bundle="$(realpath -- "$bundle")"
    relative="/recovery/${bundle#"$recovery"/}"
    operator php /app/infrastructure/vps-transfer.php verify "$relative"
    fence
    "${compose[@]}" exec -T postgres createdb -U materyalph_owner -O materyalph_app "$name"
    python3 "$root/scripts/deployment/vps-host.py" extension-sql "$control" "$bundle/manifest.json" | "${compose[@]}" exec -T postgres psql -U materyalph_owner -d "$name" -v ON_ERROR_STOP=1 > /dev/null
    "${compose[@]}" exec -T postgres pg_restore --list < "$bundle/database.dump" > "$bundle/$name-source.list"
    python3 "$root/scripts/deployment/vps-host.py" restore-toc "$control" "$bundle/$name-source.list" "$bundle/$name-restore.list"
    # No --clean, drop, reset, or overwrite: failure retains both the source DB and new target.
    restore_result=0
    "${compose[@]}" exec -T postgres pg_restore -U materyalph_owner --role=materyalph_app -d "$name" --use-list "$relative/$name-restore.list" --no-owner --no-acl --single-transaction --exit-on-error < "$bundle/database.dump" 2> "$recovery/restore-private.log" || restore_result=$?
    python3 "$root/scripts/deployment/vps-host.py" revoke-extension-grants "$control" | "${compose[@]}" exec -T postgres psql -U materyalph_owner -d "$name" -v ON_ERROR_STOP=1 > /dev/null
    [[ "$restore_result" = 0 ]] || { echo 'Restore failed; the original database remains selected. Inspect the protected restore log.' >&2; exit 1; }
    "${compose[@]}" run --rm --no-deps -T -e "DB_DATABASE=$name" operator php /app/infrastructure/vps-transfer.php restore "$relative"
    python3 "$root/scripts/deployment/vps-host.py" select-database "$control" "$name" "$bundle/manifest.json"
    echo 'New database and private objects verified and selected. Review integrations, deploy the matching release fenced, then perform acceptance before activation.'
    ;;
  *) echo 'Commands: initialize, deploy RELEASE_JSON, fence, rehearse REVIEW_JSON, activate ACCEPTANCE_JSON, inspect, backup, fetch SNAPSHOT_ID, restore-new BUNDLE NEW_DB_NAME' >&2; exit 1 ;;
esac
