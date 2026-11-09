# MateryalPH design context

## Direction

Use a light-first, industrial construction visual language: strong hierarchy, measured spacing, clear dividers, purposeful icons, and limited ornament. Avoid decorative gradients, glow effects, generic dashboard collages, nested-card-heavy layouts, bounce/elastic motion, gray text on colored surfaces, and unlabeled icon controls. The workflows and UI/UX implementation planner control behavior, terminology, states, accessibility, and provider policy.

## Brand foundation

- Typeface: Inter with controlled local/system fallbacks; do not fetch it at runtime from an unapproved third party.
- Central brand accent: `brand.orange.500` (`#F97316`).
- Filled action with white text: `action.primary` (`#C2410C`), pressed `action.primary.pressed` (`#9A3412`).
- Primary text: `text.strong`; supporting text: `text.secondary` on light surfaces only.
- Page surface: `surface.canvas`; primary surface: `surface.primary`; borders: `border.default`.
- Keyboard focus: `focus.ring`, independent of brand selection state.

The canonical machine-readable values are in `packages/design-tokens/tokens.json`. Feature code uses semantic utilities or component APIs, not unexplained raw colors.

## Type and spacing

Use the approved Display, H1, H2, H3, Body large, Body, Body strong, Label, and Caption styles. Sentence case is the default. The base spacing unit is 4 px with the approved 4–64 px scale. Routine mobile targets should be 44×44 px; never go below WCAG's 24×24 CSS-pixel minimum.

## Layout and interaction

- Prefer one clear surface with spacing, dividers, and section headings before adding another card.
- Present one dominant filled action per decision area.
- Vendor and Admin back/return controls use the shared `BackNavigation` treatment: dark 14 px semibold text, a 16 px left arrow, an 8 px gap, a 44 px minimum target, and visible keyboard focus. Keep destination labels and existing return context.
- Every surface handles relevant loading, empty, validation, unauthorized, offline/provider failure, retry, and success states.
- Status always has text or icon meaning in addition to color.
- Timers also show the exact date and time.
- Motion explains a state change, is cancelled when stale, and is removed or reduced under reduced-motion settings.

## Maps

Every map has a synchronized accessible list/table alternative. Tier 2 labels show store name plus VPS or New Vendor; Tier 1 labels show store name plus Directory. Never label a Google rating as VPS. A selected Tier 2 marker may reveal one decision route and preview with an explicit View Store action. Tier 1 opens attributed Place Details only. Never imply live GPS or animate a delivery vehicle.

## Loading and connection states

- Keep page headers, navigation, tabs, filters and entered form values mounted while the affected section loads. Show a bounded section loader for the first request, a compact indicator for an in-place update, and preserve a matching authorized snapshot when the existing resource flow supports it. Never show an empty result or a zero count before a response.
- Use the shared web `AsyncLoading` and Buyer `BuyerLoadingState` / `BuyerLoadingIndicator` / `BuyerLoadingProgress` components. Loading uses the primary action color, a 24px section indicator, a 14px supporting label and a static progress mark under reduced motion. Keep numeric progress determinate.
- Offline and failed-request states use a white bordered surface, a 24px cause-specific icon, a concise title, the specific safe error message and an explicit retry control. Keep empty-state artwork for empty results. Device offline, request timeout, provider failure and denied access remain distinct; a failed request must not establish that every service is offline.
- Connection notices leave the current view open. A retry uses the existing request and idempotency behavior; reconnection never submits a form or repeats a financial or commercial mutation automatically. Clear protected content when the existing session or authorization flow requires it.

## Review workflow

Review significant surfaces for hierarchy, accessible controls, error states, responsiveness, reduced motion, and semantic token consistency using component tests and browser inspection.
