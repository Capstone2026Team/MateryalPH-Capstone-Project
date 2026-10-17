# Demo Vendor marketplace (capstone demonstration)

Ten fictional, fully onboarded Tier 2 Vendors located across Metro Manila (Quezon City, Makati, Pasig, Mandaluyong,
Marikina, Taguig, Parañaque, Caloocan and Valenzuela), each with Owner and staff accounts, profile photos, a store logo
and banner, verified SAMPLE documents, a Xendit TEST sub-account, delivery setup where offered, and 12 published
listings of real Philippine-market brands (Boysen, Davies, Phelps Dodge, Royu, Firefly, Omni, Wassernison, Kitz,
Makita, Bosch, Stanley, Yale, Bostik, Pioneer, Decolite, Acewell and more) with retail prices, variants, volume tiers,
search tags and up to five photos each: 120 listings in total.

| File | Purpose |
| --- | --- |
| `services/api/database/demo-assets/vendors.json` | Single source for the stores and products (prices in PHP) |
| `services/api/database/demo-assets/photo-sources.json` | Every photo's URL, source page, credit and license |
| `services/api/database/demo-assets/vendors/<slug>/` | Committed: logo, SAMPLE documents, AI-generated portraits (`owner.jpg`, `staff.jpg`, `fulfillment.jpg`) |
| `services/api/database/demo-assets/photos/` | **Git-ignored**: product, banner and vehicle photos downloaded by the fetch script |
| `tools/demo-assets/fetch_demo_photos.py` | Downloads and normalizes the photos (`py tools/demo-assets/fetch_demo_photos.py`, needs Pillow) |
| `tools/demo-assets/generate_demo_vendor_assets.py` | Regenerates the logos and SAMPLE documents from `vendors.json` |
| `services/api/app/Domain/Demo/DemoVendorMarketplace.php` | The seeder; reuses the real onboarding, fleet, catalog, activation and discoverability services |

## Run

1. Fetch the photos (once per machine; re-running skips files that exist, `--force` rebuilds them):

   ```bash
   py tools/demo-assets/fetch_demo_photos.py
   ```

2. Set `DEMO_SEED_EMAIL_BASE` in `services/api/.env` (see `.env.example`), then seed:

   ```bash
   docker compose exec api php artisan materyalph:demo-vendors-seed
   ```

* Re-running is safe: existing Vendors, listings and photos are reused and stock confirmations are refreshed.
  Run it again before a demo (or with `--refresh-only`) because stock confirmations older than the hide window make
  listings ineligible.
* `--only=bahay-toro-electrical` seeds one Vendor. `--payments=simulate` is for automated tests only.
* Sign-in details (shared password, per-account authenticator secrets) are written to
  `services/api/storage/app/demo-vendor-credentials.json`, which is git-ignored. They are never printed.
* The seeder reads photos from `database/demo-assets/photos`; set `DEMO_SEED_PHOTO_DIRECTORY` to use another folder.
* Refuses to run in production.

## Photos and rights

* Branded product photos are manufacturer or retailer images (Phelps Dodge, DIY Hardware, KHM Megatools, Gigatools,
  CBK Hardware, Builders Home, La Europa, Manyu Stores). They are used only for this academic demonstration, are never
  committed, and must be replaced with the store's own photos before any public or commercial use.
* Commodity photos (hollow blocks, sand, gravel, lumber, bamboo, doors, windows, glass, gutters), store banners and
  delivery vehicles are openly licensed Wikimedia Commons / Openverse images; `photo-sources.json` records each author
  and license for attribution. Five banners are composed from the store's own product photos.
* Owner and staff portraits are AI-generated faces (no real person). Store names, owners, staff, TINs, IDs and phone
  numbers are fictional; the verification documents are obviously labelled SAMPLE images.

## What it deliberately does not do

* No regulated materials (cement, rebar, nails, plywood, ceramic tile, uPVC/PE/PB pipe, GI pipe, sanitary ware, tie
  wire, etc.), because their listings need PS/ICC compliance evidence and none is fabricated. Listings use the
  non-regulated canonical materials or an "Other" classification.
