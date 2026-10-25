# Demo Vendor marketplace (capstone demonstration)

Twenty-two fictional, fully onboarded Tier 2 Vendors located across Metro Manila (Quezon City, Manila, Makati, Pasig,
Mandaluyong, San Juan, Marikina, Taguig, Pateros, Parañaque, Pasay, Las Piñas, Caloocan, Valenzuela, Muntinlupa, Malabon
and Navotas), each with Owner and staff accounts, profile photos, a store logo and banner, verified SAMPLE documents, a
Xendit TEST sub-account, delivery setup where offered, and published listings of real Philippine-market brands with
retail prices, variants, volume tiers, search tags and photos: 260 listings in total.

* Stores 1–10 (12 listings each) sell non-regulated goods (Boysen, Davies, Phelps Dodge, Royu, Firefly, Omni,
  Wassernison, Kitz, Makita, Bosch, Stanley, Yale, Bostik, Pioneer, Decolite, Acewell and more).
* **Sucat Cement, Steel & Ready-Mix Supply** (Muntinlupa, 10 listings): ready-mixed concrete at 2,500–4,000 psi
  delivered by a transit mixer (6 m³, ₱1,500 mobilization per truck), Holcim, Republic RapidSET, Fortune and Portland
  Plus cement, SteelAsia and Pag-asa rebar, Eagle G.I. pipe and SSI nails (PS Mark), and imported G.I. tie wire (ICC
  sticker).
* **Potrero Pipes, Tiles & Sanitary Center** (Malabon, 10 listings): Neltex Waterline, Powerguard and Saniguard, Atlanta
  HDPE pipe, Mariwasa 30×30/40×40 tile and HCG water closets and lavatory (PS Mark), plus LESSO drainage pipe and
  imported JBN 60×60 porcelain tile (ICC sticker).

* Stores 13–22 (12 listings each, added 2026-10-25): Avenida Hardware (Santa Cruz, Manila), Tondo Steel & Cement
  (Tondo, Manila), Dapitan Paint (Sampaloc, Manila), Greenhills Plumbing (San Juan), Taft Avenue Electrical (Pasay),
  Talon Builders (Las Piñas), Tangos Roofing (Navotas), Pateros Floor & Tile, Cubao Doors & Windows (Quezon City) and
  Kapitolyo Tools (Pasig). Most listings deliberately repeat an existing store's exact product (same brand, model, size
  and, for PS/ICC goods, the same register number) at the store's own price, so Materials Analytics shows multi-seller
  averages; their photo entries reuse that product's source. Four are new unbranded commodities (paint brush, garden
  hose, adobe stone, nylon rope) with openly licensed Wikimedia Commons photos. Staff phone numbers for stores 13+ use
  the 5xx block so they never reuse an earlier store's number.

## Materials Analytics coverage

Price comparison (MAT-03) only covers listings linked to a reference material that state every comparison key of their
category in the material's canonical unit. Migration `2026_10_25_000001_add_common_hardware_reference_materials` adds
unregulated hardware materials (enamel paint, sealants, anchors and screws, SPC flooring, hand tools, doors, windows,
polycarbonate roofing and more) with a "Size" key for categories that had none, and `vendors.json` links those products
with their size or fastener dimensions. DTI-regulated electrical goods, power tools, pumps, lumber and faucets stay
"Other" (Not Yet Comparable). The seeder finishes each run with `deriveForUnmapped()`, which creates the comparable
groups (equivalent to `php artisan analytics:derive-comparable-groups`).

## PS/ICC listings

Each regulated product in `vendors.json` has a `compliance` block naming a real PS License No. (for example `Q-0863`)
or an ICC sticker serial inside a listed range (for example `B479078310`), taken from the DTI-BPS registers in
`materials/List_of_PS_Licensee_MASTERLIST.csv` and `materials/List_of_ICC_Certificate_Holders.csv`. The seeder submits it
the way a Vendor does: Manual Entry with the product's packaging photo as the marking photo, then Review and Confirm in
automatic mode. The listing is verified only when the active register matches (rule `compliance.register-number.v2`);
the register record supplies the manufacturer or importer. Each regulated product also has a `maker` block (manufacturer
name, address and ISO country), which the listing needs before it can be published: names are the register's
licensee or, for imports, the foreign manufacturer the register names; addresses go no further than the plant's town or
the register's region. Imported products were chosen only from register rows that name their manufacturer. Nothing
writes an approval directly, and a number that stops
matching (for example after a register update) is reported as `COMPLIANCE_REGISTER_NOT_MATCHED` instead of being forced.

If no register snapshot of a kind is active, the seeder imports that CSV from `materials/` and activates it as the
first active Admin (set `DEMO_SEED_REGISTER_DIRECTORY` to use another folder). An existing active snapshot is never
replaced. The marking photos are product packaging photos, not photographs of a physical PS Mark or ICC sticker; no
marking image is drawn or fabricated.

| File | Purpose |
| --- | --- |
| `services/api/database/demo-assets/vendors.json` | Single source for the stores and products (prices in PHP) |
| `services/api/database/demo-assets/photo-sources.json` | Every photo's URL, source page, credit and license |
| `services/api/database/demo-assets/vendors/<slug>/` | Committed: logo, SAMPLE documents, AI-generated portraits (`owner.jpg`, `staff.jpg`, `fulfillment.jpg`) |
| `services/api/database/demo-assets/photos/` | **Git-ignored**: product, banner and vehicle photos (`vehicle.jpg`, `vehicle-mixer.jpg`) downloaded by the fetch script |
| `tools/demo-assets/fetch_demo_photos.py` | Downloads and normalizes the photos (`py tools/demo-assets/fetch_demo_photos.py`, needs Pillow) |
| `tools/demo-assets/generate_demo_vendor_assets.py` | Regenerates the logos and SAMPLE documents from `vendors.json` (`... [slug ...]` for selected stores) |
| `materials/List_of_*.csv` | DTI-BPS register copies the PS/ICC numbers come from; imported only when no snapshot is active |
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
* Xendit creates each TEST sub-account as REGISTERED and turns it LIVE a few minutes later. The seeder waits for that
  (up to `DEMO_SEED_XENDIT_LIVE_WAIT_SECONDS`, default 600) and then finishes those Stores in the same run; a Store
  still REGISTERED after the wait is reported INCOMPLETE and completes on the next run. Xendit accepts only letters,
  digits and spaces in the sub-account business name, so `&` is sent as "and" and other punctuation as a space; the
  Store Name itself is unchanged.
* Sign-in details (shared password, per-account authenticator secrets) are written to
  `services/api/storage/app/demo-vendor-credentials.json`, which is git-ignored. They are never printed.
* The seeder reads photos from `database/demo-assets/photos`; set `DEMO_SEED_PHOTO_DIRECTORY` to use another folder.
* Refuses to run in production.

## Photos and rights

* Branded product photos are manufacturer or retailer images (Phelps Dodge, DIY Hardware, KHM Megatools, Gigatools,
  CBK Hardware, Builders Home, La Europa, Manyu Stores, Holcim, Republic Cement, SteelAsia, Neltex, LESSO, HCG). They are used only for this academic demonstration, are never
  committed, and must be replaced with the store's own photos before any public or commercial use.
* Commodity photos (hollow blocks, sand, gravel, lumber, bamboo, doors, windows, glass, gutters, paint brushes, garden
  hose, adobe stone, rope), store banners and delivery vehicles are openly licensed Wikimedia Commons / Openverse images;
  `photo-sources.json` records each author and license for attribution. Five of the first twelve banners and every
  banner of stores 13–22 are composed from the store's own product photos; stores 13–22 reuse the vehicle photo of the
  store whose delivery setup they share.
* Owner and staff portraits are AI-generated faces (no real person). Store names, owners, staff, TINs, IDs and phone
  numbers are fictional; the verification documents are obviously labelled SAMPLE images.

## What it deliberately does not do

* No regulated material is listed without a real register number, and none is approved by writing a decision: stores
  1–10 use non-regulated materials or an "Other" classification, and the two PS/ICC stores go through the register
  lookup described above. Their sample product photos stand in for the marking photo a real Vendor would take.
