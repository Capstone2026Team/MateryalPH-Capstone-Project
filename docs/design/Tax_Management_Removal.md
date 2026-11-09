# Tax Management removed from the Admin capstone

Owner decision: 9 November 2026.

The Admin sidebar no longer includes Tax Management. Withholding, tax-filing preparation/details and taxpayer-limit screens are removed. Old `/tax-management`, tax-report and taxpayer-limit links redirect to Platform Finance; they do not load a hidden copy of the removed page. Former tax query views also fall back to Finance overview.

Commission-credit approval remains in Commission management through the shared review drawer, using the existing independent-review API. Platform Finance, Vendor finance, withholding calculations, tax evidence, reconciliation automation, filing packages, immutable records and audit history are retained. No records, permissions, migrations or API contracts are changed by this removal.

The [prior redesign](Tax_Management_Redesign.md) is withdrawn and retained only as design history.

Suggested commit: `refactor(admin): remove tax management from capstone UI`

Validation for removal: Admin lint, typecheck and build passed; 53 focused finance, commission and App tests passed. Chromium checks passed at 1440px and 375px for eight former tax URLs, absent navigation, no removed tax API requests and no page overflow. The scoped diff check and source secret scan passed. No new setup or key names are required.

Changed surfaces: Admin routes/navigation; the Finance page; commission-credit review entry and drawer; removed tax register/filing UI and their obsolete tests; shared tax-only CSS import; corresponding workflow/design notes. Backend services, OpenAPI, generated clients and databases were not changed by this removal. The full Admin suite was not rerun for removal; the earlier unrelated UserDirectoryMedia assertions remain unresolved in the withdrawn redesign validation record.
