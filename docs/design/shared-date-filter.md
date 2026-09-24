# Shared portal date filter

The existing Admin verification picker and dual-month calendar now live in `packages/web-ui/src/date-filter.tsx` and `range-calendar.tsx`. Both portals import `DateFilter` and `DateFilterRange` from `@materyalph/web-ui`; do not create portal-specific implementations.

`DateFilter` defaults to `ALL_DATES` and accepts a controlled `value`, `onChange`, and optional dialog `title`. Changes remain draft-only until Apply. Cancel/Escape discard draft changes on reopening. Existing inclusive Asia/Manila preset calculations and open-ended boundaries remain unchanged. Supported presets: All dates, Today, Yesterday, Last 7/30/60/90/365 days.

The UI uses shared Button/Field primitives, semantic orange selection tokens, visible focus outlines, calendar icon, unique dialog/field IDs, dual calendars, and viewport-constrained scrolling.

Scope confirmed by user: UI-only, preserve existing behavior. Admin verification is the only currently implemented date-filter consumer. Neither dashboard API accepts date ranges, so no misleading dashboard filter controls were added. The same exported component is ready for both dashboards when real date-filtered data is implemented. No API, migration, authorization, or workflow changes.

Validation: Admin 14 tests; Vendor 50 tests. Both typechecks, lint and production builds pass. Vendor retains its existing bundle-size warning. Browser visual QA was not performed in this change.
