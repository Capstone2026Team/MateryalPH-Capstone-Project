# Vendor review details and product feedback

## Scope

`/reviews` uses a shared, keyboard-operable review row. Selecting it opens `/reviews/:reviewId`; Report remains a separate action. Review details show the purchased product/variant snapshot, privacy-safe Buyer display name, submission time in Asia/Manila, all relevant rating criteria, full comment, and available private photos/videos. Store-submitted Buyer ratings identify the submitting store rather than mislabeling it as the Buyer.

`/performance/products/:listingId` includes all-time published Product Quality ratings, five-star distribution, total count and paginated reviews across that listing's variants. The analytics chart period does not filter reviews. The API calculates the summary over the complete visible scope before pagination.

## API and authorization

- `GET /api/v1/vendor/reviews/{reviewId}` requires current `reviews.view` and organization ownership. Unpublished, moderated, dispute-withheld or investigation-excluded received reviews return 404.
- `GET /api/v1/vendor/reviews?type=PRODUCT&listing_id={listingId}` requires an owned listing, including archived history. Other review types reject `listing_id`.
- Review media uses the existing signed, authenticated content route. Every request rechecks authorization, visibility and clean scan state. Preview transport allowlists the API origin, exact review content route and supported MIME types.
- Revoked sessions clear loaded object URLs. Videos load on explicit selection, have native controls and offer a download fallback for unsupported codecs. Refresh attachments fetches the current authorized review and new signed links.
- Existing report permission, moderation, blind reveal and review windows remain authoritative. No new mutation, migration, audit event or notification is introduced.

## Automated checks

- `services/api/tests/Feature/Api/PhaseFourteenReviewsScoresTest.php`: scoped details, immutable purchased-product snapshot, media visibility and revoked permissions, cross-store denial, pre-pagination summary, date filtering, publication/dispute/investigation exclusions.
- `apps/vendor-web/src/pages/VendorReviewPages.test.tsx`: navigation/back context, product filtering and server pagination, role denial and retry.
- `apps/vendor-web/src/lib/review-media.test.tsx`: URL/MIME allowlist, credentialed transport, explicit video load, preview cleanup, retry and refresh behavior.
- `packages/api-contract/scripts/check-trust-contract.mjs` and `check-vendor-review.dart`: route/schema parity and generated client decoding/serialization.

## Manual acceptance

1. At narrow and wide viewports, open Product reviews and select a review using the pointer and keyboard. Check product, Buyer, stars, timestamp, edited/verified labels and full comment.
2. Open photo attachments full size. Select Load video, play/pause/seek, and check download fallback where the browser cannot decode the file. Confirm missing/expired media provides retry and refresh.
3. Return to Ratings & Reviews and verify the tab, dates and page are retained. Confirm Report opens an accessible modal and preserves existing moderation behavior.
4. Open the same product's analytics. Confirm the all-time count/average/distribution include all variants and all pages; change the chart period and confirm the review scope stays all time. Another product must have its own summary and list.
5. Check zero reviews, no comment, no attachments, permission denial, revoked access and network failure. Confirm private contacts and hidden reviews never appear.

Browser/device acceptance is manual; automated component checks do not establish visual or codec compatibility.
