"""Validate the staging topology locally; optionally validate against Railway's live schema."""
import argparse
import json
from pathlib import Path
from urllib.request import Request, urlopen

ROOT = Path(__file__).resolve().parents[2]
ROLES = ("api", "worker", "scheduler", "reverb", "postgres", "redis")


def validate(schema=None):
    for role in ROLES:
        path = ROOT / f"infrastructure/railway/{role}.json"
        config = json.loads(path.read_text())
        if schema is not None:
            from jsonschema import validate as validate_schema
            validate_schema(config, schema)
        deploy = config["deploy"]
        assert deploy["numReplicas"] == 1 and deploy["sleepApplication"] is False
        assert deploy["region"] == "asia-southeast1-eqsg3a"
        assert deploy["restartPolicyType"] == "ON_FAILURE"
        assert deploy["overlapSeconds"] == 0
        assert ("preDeployCommand" in deploy) == (role == "api")
        assert (ROOT / config["build"]["dockerfilePath"]).is_file()
        if role in ("postgres", "redis"):
            assert "requiredMountPath" in deploy and "healthcheckPath" not in deploy
        else:
            assert deploy["startCommand"] == f"/usr/local/bin/staging-start {role}"
    start = (ROOT / "infrastructure/docker/staging-start.sh").read_text()
    assert "STAGING_DATA_READY" in start and "STAGING_JOBS_ENABLED" in start
    assert "STAGING_RELEASE_APPROVED" in start
    supervisor = (ROOT / "infrastructure/docker/staging-supervisord.conf").read_text()
    assert "queue:work" not in supervisor and "schedule:" not in supervisor
    assert "freshclam" in supervisor
    redis = (ROOT / "infrastructure/docker/redis-start.sh").read_text()
    assert "noeviction" in redis and "appendonly yes" in redis and "requirepass" in redis
    buyer = json.loads((ROOT / "apps/buyer-mobile/config/staging.example.json").read_text())
    assert buyer["APP_ENV"] == "staging" and buyer["API_BASE_URL"].endswith("/api/v1")
    print("Six Railway roles, release guards, persistence and Buyer template validated.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--online", action="store_true")
    parser.add_argument("--schema", type=Path)
    args = parser.parse_args()
    schema = None
    if args.schema:
        schema = json.loads(args.schema.read_text())
    elif args.online:
        request = Request("https://railway.com/railway.schema.json", headers={"User-Agent": "Mozilla/5.0"})
        with urlopen(request, timeout=30) as response:
            schema = json.load(response)
    validate(schema)
