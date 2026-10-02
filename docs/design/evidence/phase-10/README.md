# Phase 10 visual evidence

Synthetic fixtures illustrate layout and interaction; they do not establish live provider readiness.

- Buyer Project list, archived Project/site/budget view and shared Project map sheet: 390 and 1024 logical pixels, captured by `projects_phase_ten_test.dart`. The map is explicitly labelled synthetic; the archived empty comparison tests read-only history and selected-site origin. Logical dimensions differ from PNG dimensions because Flutter's test device pixel ratio is retained.
- Vendor locked original / editable duplicate: 320, 375, 390, 768, 1024, 1280, 1440 and 1920 pixels, captured by `e2e/project-quotation.spec.ts` with reduced motion. The original/proposal are side by side at 1024px and above and stacked below; chat content scrolls inside its existing workspace.
- Existing Phase 6 goldens were visually reviewed after extracting the shared SupplierPreviewSheet. Original handle spacing, corner shape, elevation and shadow were retained; reviewed corner rasterization changes were refreshed.

Automated checks verify no horizontal browser overflow, accessible original/proposal regions, disabled Phase 15 PDF controls, Project-only map context, frozen origin, archived controls and exact budget text. See `docs/test-plans/phase-ten-projects.md` for full gates and remaining live checks.
