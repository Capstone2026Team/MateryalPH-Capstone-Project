# Philippine regional reference geometry

`philippines-regions.json` contains the 18 regional polygon features from
[faeldon/philippines-json-maps](https://github.com/faeldon/philippines-json-maps),
`latest/geojson/country/lowres/country.0.001.json`.
Upstream blob: `2a6dfc78e026953729724449fb79b5b1c8eb4ea2` (retrieved 2026-10-27).
The accompanying MIT license is retained in `LICENSE`.

Feature properties were normalized: numeric `adm1_psgc` becomes a zero-padded
10-digit `code`, `adm1_en` becomes `name`, and `level` is `REGION`. Geometry is
retained with coordinates rounded to four decimal places to reduce transfer size;
no rings are removed or reordered. No analytics values, user locations or provider
credentials are bundled.

These simplified reference outlines support the national map when imported
geometry or the Google Maps script is unavailable. Server-provided boundaries take
precedence by exact PSGC code; the authorized API remains the only source of
displayed values, names, suppression and navigation. Unknown codes are never
matched by name.

`subregions/*.json` adds 1,730 public province, district, city and municipality
outlines grouped into 18 lazy-loaded regional files. They come from the same
source's `latest/geojson/{regions,provdists}/medres/` directories, pinned to commit
`5d4929bdd477946ef88748a85d21c194d5d1d3ea` (PSGC 3Q 2026; retrieved 2026-10-27).
`subregions-manifest.json` records all 106 upstream paths and blob hashes.
Rebuild with `python packages/web-ui/scripts/build-subregional-reference.py`.
The script verifies Git blob hashes, normalizes numeric codes to 10 digits and
rounds coordinates to four decimal places without removing or reordering rings.
The files load locally only when their region is selected; no runtime external
map/data request is required.

Imported geometry takes precedence by exact code. Matching authorized areas use
only API-supplied names, values, suppression and selection behavior. Other province
borders (or NCR's 17 localities) provide unshaded, noninteractive reference context
inside the selected region. Province views retain their city/municipality borders.
Districts never replace the API's province/independent-city hierarchy. Codes absent
from the pinned reference remain accessible through the API-driven selector/table.

Attribution: underlying boundaries are from NAMRIA and PSA through
[OCHA COD-AB](https://data.humdata.org/dataset/cod-ab-phl), licensed
[CC BY-IGO](https://creativecommons.org/licenses/by/3.0/igo/).
The source repository's scripts and maps carry the retained MIT license.
The map displays attribution and links to the source/licence.

The reference dataset is not used for point attribution, official boundary
decisions or analytics calculations. Review and replace the pinned geometry when
the active PSGC regional boundaries change; retain provenance and the license.
