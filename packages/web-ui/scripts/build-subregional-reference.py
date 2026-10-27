"""Rebuild presentation-only PSGC outlines from a pinned public source; no runtime provider calls."""
import hashlib
import json
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
from urllib.request import urlopen

COMMIT = "5d4929bdd477946ef88748a85d21c194d5d1d3ea"
ROOT = Path(__file__).resolve().parents[1] / "src" / "geography"
TREE_URL = f"https://api.github.com/repos/faeldon/philippines-json-maps/git/trees/{COMMIT}?recursive=1"


def read_json(url):
    with urlopen(url, timeout=45) as response:
        return response.read()


def rounded(value):
    if isinstance(value, list):
        return [rounded(item) for item in value]
    return round(value, 4) if isinstance(value, float) else value


def download(entry):
    raw = read_json(f"https://raw.githubusercontent.com/faeldon/philippines-json-maps/{COMMIT}/{entry['path']}")
    assert hashlib.sha1(f"blob {len(raw)}\0".encode() + raw).hexdigest() == entry["sha"]
    return entry, json.loads(raw)


def main():
    tree = json.loads(read_json(TREE_URL))
    entries = [entry for entry in tree["tree"] if any(entry["path"].startswith(f"latest/geojson/{level}/medres/") for level in ("regions", "provdists")) and entry["path"].endswith(".json")]
    regions = {}
    manifest = []
    with ThreadPoolExecutor(max_workers=8) as pool:
        for entry, collection in pool.map(download, entries):
            manifest.append({"path": entry["path"], "blob": entry["sha"]})
            city = "/provdists/" in entry["path"]
            for feature in collection["features"]:
                props = feature["properties"]
                region = str(props["adm1_psgc"]).zfill(10)
                code = str(props["adm3_psgc" if city else "adm2_psgc"]).zfill(10)
                level = ("MUNICIPALITY" if props["geo_level"] == "Mun" else "CITY") if city else "DISTRICT" if props["geo_level"] == "Dist" else "PROVINCE"
                geometry = feature["geometry"]
                normalized = {"type": "Feature", "properties": {"code": code, "name": props["adm3_en" if city else "adm2_en"], "level": level, "regionCode": region, "provinceCode": str(props["adm2_psgc"]).zfill(10)}, "geometry": {"type": geometry["type"], "coordinates": rounded(geometry["coordinates"])}}
                regions.setdefault(region, {})[code] = normalized
    target = ROOT / "subregions"
    target.mkdir(exist_ok=True)
    for region, features in sorted(regions.items()):
        (target / f"{region}.json").write_text(json.dumps({"type": "FeatureCollection", "features": sorted(features.values(), key=lambda item: item["properties"]["code"])}, ensure_ascii=False, separators=(",", ":")), encoding="utf-8")
    (ROOT / "subregions-manifest.json").write_text(json.dumps({"commit": COMMIT, "sources": manifest}, indent=2) + "\n", encoding="utf-8")
    print(f"Built {len(regions)} region files with {sum(len(features) for features in regions.values())} province/city outlines.")


if __name__ == "__main__":
    main()
