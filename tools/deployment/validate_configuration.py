"""Validate Render's current schema plus MateryalPH's staging deployment boundaries."""

import json
import pathlib
import sys
import urllib.request

import jsonschema
import yaml

ROOT = pathlib.Path(__file__).resolve().parents[2]


def main():
    blueprint = yaml.safe_load((ROOT / "render.yaml").read_text(encoding="utf-8"))
    if len(sys.argv) > 1:
        schema = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8-sig"))
    else:
        with urllib.request.urlopen("https://render.com/schema/render.yaml.json", timeout=30) as response:
            schema = json.load(response)
    try:
        jsonschema.validate(blueprint, schema)
    except jsonschema.ValidationError as error:
        # Schema exceptions otherwise dump the entire document and schema into CI logs.
        def summarize(issue):
            if issue.context:
                return "\n".join(summarize(child) for child in issue.context[:8])
            return f"{'/'.join(map(str, issue.absolute_path))}: {issue.message}"
        raise SystemExit(summarize(error)) from None
    projects = blueprint["projects"]
    assert len(projects) == 1 and len(projects[0]["environments"]) == 1
    staging = projects[0]["environments"][0]
    assert staging["name"] == "staging"
    services = staging["services"]
    assert {service["type"] for service in services} == {"web", "keyvalue"}
    assert len(services) == 5 and len({service["name"] for service in services}) == 5
    for service in services:
        assert service["name"].startswith("materyalph-staging-")
        if service.get("runtime") != "static":
            assert service["region"] == "singapore"
            assert service["plan"] == "free", "The user authorized Free plans only."
            assert "disk" not in service and "preDeployCommand" not in service
        if service["type"] != "keyvalue":
            assert service["branch"] == "staging" and service["autoDeployTrigger"] == "off"
        if service.get("runtime") == "static":
            assert not service.get("rootDir"), "Portals require shared packages outside the app directory."
            assert {"type": "rewrite", "source": "/*", "destination": "/index.html"} in service["routes"]
    database = staging["databases"][0]
    assert database["postgresMajorVersion"] == "16" and database["region"] == "singapore"
    assert database["ipAllowList"] == []
    assert database["plan"] == "free" and "diskSizeGB" not in database
    api = next(service for service in services if service["name"].endswith("-api"))
    assert api["healthCheckPath"] == "/up"
    secrets = {"APP_KEY", "REVERB_APP_SECRET", "PASSPORT_PRIVATE_KEY_BASE64", "AWS_SECRET_ACCESS_KEY", "MAIL_PASSWORD", "XENDIT_SECRET_KEY", "XENDIT_WEBHOOK_VERIFICATION_TOKEN", "GOOGLE_OIDC_CLIENT_SECRET", "RECAPTCHA_ENTERPRISE_API_KEY", "CLOUDINARY_API_SECRET", "FIREBASE_SERVICE_ACCOUNT_JSON_BASE64"}
    for owner in [*services, *staging["envVarGroups"]]:
        for variable in owner.get("envVars", []):
            if variable.get("key") in secrets:
                assert "value" not in variable, f"Secret literal: {variable['key']}"
            if owner in staging["envVarGroups"]:
                assert "sync" not in variable, "Render ignores sync:false inside environment groups."
    for workflow in (ROOT / ".github/workflows").glob("*.yml"):
        yaml.safe_load(workflow.read_text(encoding="utf-8"))
    print("Render schema, staging boundaries, secret references and workflow YAML passed.")


if __name__ == "__main__":
    main()
