"""Small Ubuntu operator checks; never execute environment-file contents or print secrets."""
import hashlib
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import re
import subprocess
import sys


def environment(path, raw=False):
    result = {}
    for line in Path(path).read_text(encoding="utf-8-sig").splitlines():
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        key, separator, value = line.partition("=")
        if not separator or not re.fullmatch(r"[A-Z][A-Z0-9_]*", key):
            raise ValueError("Use a flat deployment environment file.")
        # File inputs use one-line base64 values, not shell interpolation or multiline PEMs.
        if '\0' in value:
            raise ValueError('Malformed private input.')
        if raw:
            pass  # Match Compose env_file format: raw, including quotes and inline hashes.
        elif value.startswith(('"', "'")):
            if len(value) < 2 or value[-1] != value[0]:
                raise ValueError("Malformed private input.")
            value = value[1:-1]
        else:
            value = value.split(' #', 1)[0].rstrip()
        if key in result:
            raise ValueError("Duplicate deployment input name.")
        result[key] = value
    return result


def sha256(path):
    with open(path, "rb") as stream:
        return hashlib.file_digest(stream, "sha256").hexdigest()


def extension_sql(manifest):
    allowed = ['plpgsql', 'postgis', 'fuzzystrmatch', 'address_standardizer', 'address_standardizer_data_us', 'postgis_topology', 'postgis_tiger_geocoder', 'pg_trgm', 'pgcrypto']
    requested = {item['extname'] for item in manifest['extensions']}
    if not requested.issubset(allowed) or not {'postgis', 'pg_trgm', 'pgcrypto'}.issubset(requested):
        raise ValueError('Review source extensions before recovery.')
    return '\n'.join(f'CREATE EXTENSION IF NOT EXISTS {name};' for name in allowed if name in requested) + '\n' + extension_grants(True)


def extension_grants(grant):
    table = 'GRANT INSERT ON TABLE %I.%I TO materyalph_app' if grant else 'REVOKE INSERT ON TABLE %I.%I FROM materyalph_app'
    sequence = 'GRANT USAGE, UPDATE ON SEQUENCE %I.%I TO materyalph_app' if grant else 'REVOKE USAGE, UPDATE ON SEQUENCE %I.%I FROM materyalph_app'
    schema = 'GRANT USAGE, CREATE ON SCHEMA %I TO materyalph_app' if grant else 'REVOKE CREATE ON SCHEMA %I FROM materyalph_app'
    return f"""DO $restore$
DECLARE item record;
BEGIN
  FOR item IN SELECT nspname FROM pg_namespace WHERE nspname IN ('tiger','tiger_data','topology') LOOP
    EXECUTE format('{schema}', item.nspname);
  END LOOP;
  FOR item IN SELECT n.nspname,c.relname,c.relkind FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace
    JOIN pg_depend d ON d.classid='pg_class'::regclass AND d.objid=c.oid
    WHERE d.refclassid='pg_extension'::regclass AND d.deptype='e' AND c.relkind IN ('r','p','S') LOOP
    IF item.relkind='S' THEN EXECUTE format('{sequence}', item.nspname,item.relname);
    ELSE EXECUTE format('{table}', item.nspname,item.relname); END IF;
  END LOOP;
END;
$restore$;"""


def restore_toc(contents):
    # PostGIS extensions recreate these schemas. Their application/custom data is retained.
    pattern = r'^\d+; \d+ \d+ SCHEMA - (?:tiger|tiger_data|topology) '
    return '\n'.join(';' + line if re.match(pattern, line) else line for line in contents.splitlines()) + '\n'


def main():
    command, path, *arguments = sys.argv[1:]
    control = environment(path)
    if command == "value":
        key = arguments[0]
        if key not in {"VPS_RECOVERY_DIRECTORY", "VPS_API_ENV_FILE"}:
            raise ValueError("Only non-secret deployment paths may be queried.")
        print(control[key])
        return
    api = environment(control["VPS_API_ENV_FILE"], raw=True)
    if api.get("APP_ENV") != "staging" or api.get("LIVE_COMMERCE_ENABLED") != "false" or api.get("XENDIT_MODE") != "TEST":
        raise ValueError("Staging TEST guard failed.")
    database = api.get("DB_DATABASE", "")
    if not re.fullmatch(r"materyalph_(staging|restore_\d{14})", database):
        raise ValueError("Dedicated staging database required.")
    if command == "extension-sql":
        print(extension_sql(json.loads(Path(arguments[0]).read_text())))
    elif command == "revoke-extension-grants":
        print(extension_grants(False))
    elif command == "restore-toc":
        source, destination = map(Path, arguments)
        with destination.open('x') as stream:
            stream.write(restore_toc(source.read_text()))
    elif command == "database":
        print(database)
    elif command == "release":
        release = json.loads(Path(arguments[0]).read_text())
        if release.get("format") != "materyalph-vps-release-v1" or release.get("commit") != control["VPS_DEPLOY_COMMIT"] or release.get("required_check") != "success" or release.get('image_checks') != 'runtime-and-trivy-passed':
            raise ValueError("Exact accepted release evidence is required.")
        for role in ("api", "edge"):
            expected = release["images"][role]
            reference = control[f"VPS_{role.upper()}_IMAGE"]
            actual = subprocess.run(["docker", "image", "inspect", reference, "--format", "{{.Id}}"], capture_output=True, text=True, check=True).stdout.strip()
            if actual != expected or not re.fullmatch(r"sha256:[a-f0-9]{64}", expected):
                raise ValueError("Loaded image does not match the accepted release.")
    elif command == "backup-recent":
        last = Path(control["VPS_RECOVERY_DIRECTORY"], "last-success").read_text().strip()
        age = (datetime.now(timezone.utc) - datetime.fromisoformat(last.replace("Z", "+00:00"))).total_seconds()
        if not 0 <= age <= 900:
            raise ValueError("Take a verified offsite backup immediately before deployment.")
    elif command in {"activate", "rehearse"}:
        evidence = json.loads(Path(arguments[0]).read_text())
        expected = ["other_environment_fenced", "database_and_files_verified", "imported_side_effects_reviewed", "test_provider_ownership_verified", "authentication_and_private_media_passed", "native_apk_passed", "load_20_users_passed", "backup_restore_drill_passed"]
        if command == "rehearse":
            expected = expected[:4]
        if evidence.get("commit") != control["VPS_DEPLOY_COMMIT"] or not all(evidence.get(key) is True for key in expected):
            raise ValueError("Complete dated acceptance and single-primary recovery evidence before activation.")
        if not evidence.get("reviewed_at") or not evidence.get("reviewer"):
            raise ValueError("Record the operator and review time.")
    elif command == "select-database":
        name, manifest_path = arguments
        if not re.fullmatch(r"materyalph_restore_\d{14}", name):
            raise ValueError("Only a newly restored database can be selected.")
        manifest = json.loads(Path(manifest_path).read_text())
        if manifest["database_bytes"] >= 1_000_000_000:
            raise ValueError("Render Free recovery sizing gate failed; no history was trimmed.")
        original = Path(control["VPS_API_ENV_FILE"])
        text = original.read_text()
        updates = {"DB_DATABASE": name, "MAIL_DELIVERY_NOT_BEFORE": manifest["mail_delivery_not_before"], "OUTBOX_DELIVERY_NOT_BEFORE": manifest["outbox_delivery_not_before"]}
        for key, value in updates.items():
            if not isinstance(value, str) or "\n" in value or "\r" in value:
                raise ValueError("Recovery metadata is incomplete.")
            text, count = re.subn(rf"^{key}=.*$", lambda _: f"{key}={value}", text, flags=re.MULTILINE)
            if count != 1:
                raise ValueError("Configure each import boundary exactly once.")
        temporary = original.with_suffix(".pending")
        with open(temporary, "x", encoding="utf-8") as stream:
            os.chmod(temporary, 0o600)
            stream.write(text)
        os.replace(temporary, original)
    else:
        raise ValueError("Unsupported operator check.")


if __name__ == "__main__":
    try:
        main()
    except Exception:
        # Exceptions from subprocesses/providers can contain confidential parameters.
        print("VPS operator guard failed; inspect private configuration and acceptance evidence.", file=sys.stderr)
        sys.exit(1)
