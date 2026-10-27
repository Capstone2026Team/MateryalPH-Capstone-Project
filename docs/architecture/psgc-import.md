# PSGC master import (Phase 6)

MateryalPH stores Buyer locations as authoritative PostGIS points plus the **best resolved, versioned** Philippine Standard Geographic Code (PSGC) references. Coordinates always decide radius membership; PSGC codes only support administrative aggregation (for example, Admin geographic analytics in Phase 16).

This guide covers how the PSGC master gets into the database, how a version becomes active, and what happens when a name cannot be resolved.

## Data model

| Table | Purpose |
| --- | --- |
| `psgc_versions` | One row per imported master. `status` is `DRAFT`, `ACTIVE` or `RETIRED`; at most one version is `ACTIVE` (unique partial index). Records `source_kind`, `source_reference`, `effective_on`, `content_hash`, `area_count`, `level_counts` and `orphan_count`. |
| `psgc_areas` | Areas of one version: 10-digit `code`, `name`, `normalized_name`, `level` (`REGION`, `PROVINCE`, `CITY`, `MUNICIPALITY`, `SUB_MUNICIPALITY`, `SPECIAL_GEOGRAPHIC_AREA`, `BARANGAY`, `OTHER`) and `parent_id`. |
| `addresses` (Buyer rows) | `psgc_version_id`, `region_code`, `province_code`, `city_code`, `psgc_code` (barangay) and `psgc_resolution` (`RESOLVED`, `PARTIAL`, `UNRESOLVED`). |

Rules enforced by the database:

- Areas of an `ACTIVE` or `RETIRED` version are **immutable** (trigger `psgc_areas_immutable`). A saved address therefore always keeps the exact code and version it was resolved against.
- A version can leave `DRAFT` only when it has areas.
- A Buyer address must have a point inside the Philippine envelope; PSGC is best effort, so `UNRESOLVED` is a valid saved state.

## Sources

One importer (`App\Domain\Geography\PsgcImporter`) accepts two sources. Both create a **DRAFT** version; nothing changes for Buyers until an operator activates it.

### 1. Official PSA publication (recommended for production-like data)

1. Download the current PSGC publication datafile from the Philippine Statistics Authority (PSA) website.
2. Open the workbook and export the sheet that lists every geographic unit to **CSV (UTF-8)**.
3. Keep at least these columns. Header names are matched case-insensitively:
   - a code column: `10-digit PSGC`, `PSGC`, `PSGC Code` or `Code`
   - `Name`
   - `Geographic Level` (`Reg`, `Prov`, `City`, `Mun`, `SubMun`, `SGU`, `Bgy`)

   Excel often drops the leading zero from a 10-digit code; the importer restores 9-digit numeric codes to 10 digits and rejects any other malformed code.
4. Import it:

   ```bash
   cd services/api
   php artisan materyalph:psgc-import --source=psa-csv --file=/path/to/psgc-2025q2.csv \
     --label=2025Q2 --effective-on=2025-06-30 --reference="PSA PSGC 2nd Quarter 2025 publication"
   ```

Limits: 20 MB file, 60,000 rows, unique codes, at least one region. The whole import runs in one transaction.

### 2. psgc.cloud snapshot (quick start, no barangays)

```bash
php artisan materyalph:psgc-import --source=psgc-cloud --label=psgc-cloud-2026-09 \
  --effective-on=2026-09-28 --reference="psgc.cloud v2 snapshot 2026-09-28"
```

This snapshots the public psgc.cloud mirror of the PSA data: regions, provinces, and every city, municipality, sub-municipality and special geographic area. Barangays are **not** included. That is enough for the required region, province-or-independent-city, and city/municipality resolution; use the PSA CSV when barangay codes are needed. Vendor onboarding keeps using its existing live psgc.cloud lookup and is unaffected by this import.

## Review and activate

The import prints level counts and `orphan_count` (areas whose parent could not be derived). Parents are derived by zeroing trailing PSGC segments: barangay → city or sub-municipality, city/municipality → province or independent city, then region. Review the counts, then activate:

```bash
php artisan materyalph:psgc-activate 2025Q2
```

Activation locks all versions, marks the previous `ACTIVE` version `RETIRED` and the chosen version `ACTIVE` in one transaction. Re-importing identical content returns the existing version instead of creating a duplicate; reusing a label with different content is rejected.

The Admin verification region filter (`PhilippineRegionDirectory`) prefers the `ACTIVE` version and falls back to the latest effective non-retired version, so an unreviewed draft never replaces an active master.

## Resolution behaviour

`App\Domain\Geography\PsgcResolver` resolves against the `ACTIVE` version only:

| Result | Meaning | Stored codes |
| --- | --- | --- |
| `RESOLVED` | The city or municipality matched uniquely; region and province (or the independent city itself) are derived from the hierarchy. Barangay is added when it also matches uniquely. | region, province, city, optional barangay, version |
| `PARTIAL` | Only a province or region matched. | region, optional province, version |
| `UNRESOLVED` | No active version, or the names were missing or ambiguous. The point is still saved. | none |

Names are compared after normalization (accents removed; "City of", "City", "Municipality", "Barangay" and punctuation stripped). Duplicate city names are disambiguated by province, then by region aliases (for example "Metro Manila" → National Capital Region). Anything still ambiguous stays unresolved and is never guessed.

Codes chosen from the Buyer area picker (`GET /api/v1/buyers/geography/areas`) are validated against the active version, and a code from any other version is rejected.

## Remapping after a new version

Activating a new version does **not** rewrite existing addresses; historical facts keep their original code and version. Reporting that needs current boundaries must apply a documented remap from the stored version to the current one (Phase 16 scope).

## Verification

Covered by `tests/Feature/Api/PhaseSixBuyerDiscoveryTest.php`:

- CSV import with a byte-order mark and a leading-zero-dropped code
- sub-municipality parentage
- duplicate import detection
- explicit activation and retirement of the previous version
- immutability of active areas
- rejection of an invalid CSV
- unresolved resolution before any import
- ambiguous "Quezon" resolution by region alias

## Administrative boundaries for the Admin map (Phase 16)

The Admin geographic analytics map draws simplified PSGC boundaries with the Google Maps JavaScript data layer. Boundaries are reference geometry only: analytics facts store PSGC codes and never a Buyer or Vendor coordinate, and no point is sent to the browser.

### Import

```bash
docker compose exec api php artisan materyalph:psgc-boundaries-import \
  --file=storage/app/private/boundaries/psgc-municities.geojson \
  --reference="<publisher>, <dataset name>, <publication date>" \
  [--version=<PSGC version label>] [--code-property=<feature property with the 10-digit PSGC code>] [--replace]
```

- Input is a GeoJSON `FeatureCollection` of at most 150 MB whose features carry a 10-digit PSGC code. The code property is detected automatically (`psgc`, `psgc_code`, `adm1_psgc`…`adm4_psgc`, `code`, `PSGC`, `PSGC_CODE`) or named with `--code-property`.
- Features are matched by code to the areas of the ACTIVE PSGC version (or `--version`). Unmatched codes are listed in the result and in `psgc_boundary_imports`; they are never guessed by name.
- Geometry is repaired with `ST_MakeValid`, stored as a MultiPolygon in `psgc_boundaries.geom` (GiST-indexed, used for server-side point placement when an order address lacks a resolved code), and simplified per level for the browser in `simplified_geojson`.
- An existing boundary is replaced only with `--replace`. Every run records its source reference, file hash, matched, replaced and skipped counts.
- The importer reads only a local file; it never downloads from a provider. Use a source whose licence permits this use and record it in `--reference`.

### Fallbacks

- Areas without imported geometry appear in `missing_codes` of `GET /api/v1/admin/geo-analytics/boundaries`. The national view can fill regional outlines from the bundled, MIT-licensed 18-region reference geometry, matched only by exact PSGC code. Imported geometry takes precedence. Provenance is recorded in `packages/web-ui/src/geography/README.md`.
- Without `VITE_GOOGLE_MAPS_BROWSER_KEY` (a referrer-restricted browser key, never a server secret), or when the Maps script fails, an interactive SVG renders the available boundaries. Pinned, locally lazy-loaded province/city reference geometry can fill missing subregional outlines by exact code; imported geometry takes precedence. Other public province borders (or NCR city/municipality borders) remain noninteractive context within a selected region. Unknown areas remain reachable through the labelled area selector and synchronized sortable table; no boundary or point location is invented. Provenance, hashes, licence and attribution are documented in `packages/web-ui/src/geography/README.md`.
- Bundled geometry is presentation-only reference data. It never changes server attribution, active PSGC versions, suppression, or historical facts. Review its version when regional boundaries change. All names, values and drill-down eligibility still come from the authorized API.
- The Admin analytics overview explicitly selects the outline renderer: only Philippine geometry is displayed, without a Google/world basemap. On regional drill-down, the selected region's reference outline is fitted with any authorized child geometry, so missing child boundaries or an empty child list never removes the regional map. Shared basemap support remains available to other callers.

### Hierarchy used by the dashboard

Philippines → Region → Province, or an independent/highly urbanized city directly under its region → City or Municipality. Barangay-level figures are not published. Facts whose address has no resolvable PSGC code are reported as **unresolved geography** and counted only in the Philippines total.
