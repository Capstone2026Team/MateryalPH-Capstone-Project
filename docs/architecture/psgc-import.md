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
