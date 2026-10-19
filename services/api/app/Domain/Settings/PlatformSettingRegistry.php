<?php

declare(strict_types=1);

namespace App\Domain\Settings;

use App\Domain\Geography\RadiusPolicy;
use App\Domain\Procurement\RankingWeights;
use App\Domain\Projects\FulfillmentMatchScore;

/**
 * The approved non-secret Platform Settings (Admin Workflow §12). Each entry has a default, a human-readable
 * validation rule and a validator; the domain rule that consumes it reads the effective version for new records
 * only. Secrets, the LIVE commerce gate, VPS weights, the radius allowlist and any NRPC cap are deliberately absent:
 * they appear only as fixed, non-editable references.
 */
final class PlatformSettingRegistry
{
    /** Upper bounds that a setting may lower but never raise; they match the transport and storage limits in code. */
    public const UPLOAD_CEILINGS_KB = ['vendor_document' => 10240, 'store_media' => 20480, 'listing_image' => 5120, 'compliance_evidence' => 10240,
        'case_evidence' => 10240, 'review_photo' => 10240, 'review_video' => 102400];

    public const UPLOAD_LABELS = ['vendor_document' => 'Vendor verification document', 'store_media' => 'Store and vehicle media', 'listing_image' => 'Listing image',
        'compliance_evidence' => 'PS/ICC compliance evidence', 'case_evidence' => 'Dispute, invoice and fulfillment evidence', 'review_photo' => 'Review photo', 'review_video' => 'Review video'];

    /** @return array<string, array{group: string, label: string, description: string, rule: string, default: mixed, applies_to: string}> */
    public static function definitions(): array
    {
        return [
            'ranking.srs.default_weights' => ['group' => 'Ranking', 'label' => 'Item-Based SRS default weights', 'default' => RankingWeights::APPROVED_DEFAULT,
                'description' => 'Distance, price, VPS, stock and product rating weights used when a Buyer has no personal Item-Based preference.',
                'rule' => 'Whole percentages 0–100 for all five components; the total must be exactly 100%. Buyer personal preferences are never overwritten.',
                'applies_to' => 'New Item-Based searches for Buyers without personal weights.'],
            'ranking.fms.default_weights' => ['group' => 'Ranking', 'label' => 'Project-Based FMS default weights', 'default' => FulfillmentMatchScore::DEFAULTS,
                'description' => 'Material match, budget fit, distance and VPS weights used when a Buyer has no personal Project-Based preference.',
                'rule' => 'Whole percentages 0–100 for all four components; the total must be exactly 100%. Buyer personal preferences are never overwritten.',
                'applies_to' => 'New Project-Based comparisons for Buyers without personal weights.'],
            'discovery.buyer_default_radius_km' => ['group' => 'Discovery radius', 'label' => 'Buyer default discovery radius', 'default' => RadiusPolicy::BUYER_DEFAULT_KM,
                'description' => 'Radius used when a Buyer has not chosen one.', 'rule' => 'One of the approved radius values: 5, 10, 20, 30, 40 or 50 km.',
                'applies_to' => 'Buyer discovery requests without a saved radius.'],
            'discovery.vendor_default_radius_km' => ['group' => 'Discovery radius', 'label' => 'Vendor Materials Analytics default radius', 'default' => RadiusPolicy::VENDOR_DEFAULT_KM,
                'description' => 'Radius used for Vendor competitor aggregates when none is selected.', 'rule' => 'One of the approved radius values: 5, 10, 20, 30, 40 or 50 km.',
                'applies_to' => 'Vendor Materials Analytics requests without a radius.'],
            'discovery.radius_expansion_threshold' => ['group' => 'Discovery radius', 'label' => 'Radius expansion offer threshold', 'default' => RadiusPolicy::EXPANSION_THRESHOLD,
                'description' => 'Below this many eligible Tier 2 Vendors the Buyer is offered (never forced to) the next radius.', 'rule' => 'Whole number from 1 to 20.',
                'applies_to' => 'New Buyer discovery results.'],
            'orders.vendor_response_hours' => ['group' => 'Orders and payments', 'label' => 'Vendor-response window', 'default' => 24,
                'description' => 'Time a Vendor has to confirm, revise or decline a new order request or Work Package inquiry.', 'rule' => 'Whole hours from 1 to 72.',
                'applies_to' => 'Order requests submitted after the change; existing deadlines keep their stored instant.'],
            'orders.pending_payment_window_hours' => ['group' => 'Orders and payments', 'label' => 'Pending Payment window', 'default' => 24,
                'description' => 'Time an accepted online order may wait in Awaiting Payment before it expires.', 'rule' => 'Whole hours from 1 to 72, longer than every payment reminder offset.',
                'applies_to' => 'Orders entering Awaiting Payment after the change.'],
            'reminders.payment_hours_before' => ['group' => 'Reminders', 'label' => 'Payment reminder offsets', 'default' => [12, 1],
                'description' => 'Hours before the Pending Payment deadline when the Buyer is reminded.', 'rule' => 'One to three distinct whole hours, each at least 1 and shorter than the Pending Payment window.',
                'applies_to' => 'Reminder sweeps after the change.'],
            'quotations.deadline_limits' => ['group' => 'Quotations', 'label' => 'Quotation deadline limits', 'default' => ['min_hours' => 1, 'max_hours' => 72, 'default_hours' => 24],
                'description' => 'Allowed and default Buyer response window a Vendor may set on a published quotation.', 'rule' => 'Whole hours 1–168 with minimum ≤ default ≤ maximum.',
                'applies_to' => 'Quotation versions published after the change; published versions keep their deadline.'],
            'reminders.quotation_before_minutes' => ['group' => 'Reminders', 'label' => 'Quotation reminder offsets', 'default' => ['long_deadline_from_hours' => 8, 'long_minutes' => 240, 'short_minutes' => 30],
                'description' => 'Minutes before a quotation deadline when the Buyer is reminded; long deadlines use the longer offset.',
                'rule' => 'Long deadlines start at 1–168 hours; offsets are 5–1440 minutes, the short offset is below the long offset and shorter than the minimum deadline, and the long offset is shorter than the long-deadline threshold.',
                'applies_to' => 'Reminder sweeps after the change.'],
            'reminders.receipt_hours_before' => ['group' => 'Reminders', 'label' => 'Receipt auto-confirmation reminders', 'default' => ['first_hours' => 24, 'second_hours' => 2],
                'description' => 'Hours before the 48-hour receipt auto-confirmation when the Buyer is reminded.', 'rule' => 'Two whole hours with 47 ≥ first > second ≥ 1.',
                'applies_to' => 'Reminder sweeps after the change.'],
            'disputes.deadlines' => ['group' => 'Disputes', 'label' => 'Dispute deadlines',
                'default' => ['response_hours' => 48, 'mutual_resolution_hours' => 72, 'clarification_hours' => 24, 'appeal_business_days' => 5, 'post_completion_filing_days' => 7],
                'description' => 'Response, mutual-resolution and clarification windows, the appeal window and the post-completion filing window. All use Asia/Manila.',
                'rule' => 'Response 1–168 hours, mutual resolution 1–336 hours, clarification 1–168 hours, appeal 1–20 business days, post-completion filing 1–30 days.',
                'applies_to' => 'Cases and steps opened after the change; running deadlines keep their stored instant. Non-waivable legal rights are unaffected.'],
            'reviews.windows' => ['group' => 'Ratings', 'label' => 'Rating windows', 'default' => ['rating_window_days' => 14, 'edit_hours' => 24, 'correction_days' => 7],
                'description' => 'Rating window after completion, the one-time edit window after submission and the moderation correction window.',
                'rule' => 'Rating window 1–60 days, edit window 1–168 hours, correction window 1–30 days.',
                'applies_to' => 'Rating windows and corrections opened after the change.'],
            'badges.thresholds' => ['group' => 'Badges', 'label' => 'Badge thresholds', 'default' => [
                'fast_responder' => ['min_crr_percent' => '85.00', 'min_inquiries' => 10],
                'on_time' => ['min_frr_percent' => '95.00', 'min_fulfilled_orders' => 10],
                'highly_rated' => ['min_vcs' => '4.50', 'min_vendor_ratings' => 10],
                'high_quality_materials' => ['min_mqs' => '4.60', 'min_product_ratings' => 10],
                'trusted_supplier' => ['min_vcs' => '4.50', 'min_ohs' => '4.50', 'min_completed_orders' => 25, 'min_active_days' => 90],
            ], 'description' => 'Criteria the daily badge evaluation applies. Admins cannot award a badge or set a score; Most Ordered and Best Price keep their fixed rules.',
                'rule' => 'Percentages 0.00–100.00 and scores 1.00–5.00 with two decimals; sample counts 1–1000; Trusted Supplier active days 1–3650.',
                'applies_to' => 'The next daily badge evaluation.'],
            'projects.budget_warning_percent' => ['group' => 'Projects', 'label' => 'Budget warning threshold', 'default' => 90,
                'description' => 'Committed spend at or above this share of a Project or Work Package budget triggers the Buyer warning.', 'rule' => 'Whole percentage from 50 to 100.',
                'applies_to' => 'Budget evaluations after the change.'],
            'invoices.request_service_target_business_days' => ['group' => 'Invoices', 'label' => 'Invoice-request service target', 'default' => 3,
                'description' => 'Business days a Vendor has to upload a requested invoice copy. It never extends the legal invoicing deadline.', 'rule' => 'Whole business days from 1 to 10.',
                'applies_to' => 'Invoice requests opened after the change.'],
            'analytics.disclosure_min_persons' => ['group' => 'Analytics disclosure', 'label' => 'Small-cell disclosure threshold', 'default' => 5,
                'description' => 'Person-derived geographic cells built from fewer distinct Buyers or users are suppressed and rolled up into the parent area. Public storefront Vendor counts are not suppressed.',
                'rule' => 'Whole number of distinct persons from 1 to 50. 1 shows every value; raise it before real Buyer data is shared beyond Admin staff.',
                'applies_to' => 'Every geographic analytics response and export after the change.'],
            'uploads.limits_kb' => ['group' => 'Uploads', 'label' => 'Upload size limits', 'default' => ['vendor_document' => 10240, 'store_media' => 20480, 'listing_image' => 5120,
                'compliance_evidence' => 10240, 'case_evidence' => 10240, 'review_photo' => 10240, 'review_video' => 102400],
                'description' => 'Maximum file size in KB per upload purpose. Content validation and malware scanning still apply.',
                'rule' => 'Whole KB from 512 up to the approved ceiling for each purpose; a setting can lower a limit but never raise it above its ceiling.',
                'applies_to' => 'Uploads after the change.'],
            'features.flags' => ['group' => 'Feature flags', 'label' => 'Feature flags', 'default' => ['materials_analytics' => true, 'geo_analytics' => true],
                'description' => 'Operational switches for approved, non-LIVE features. Turning one off returns an unavailable state; it never bypasses authorization.',
                'rule' => 'true or false for Materials Analytics and Philippine geographic analytics. LIVE commerce is not a feature flag.',
                'applies_to' => 'Requests after the change.'],
        ];
    }

    /**
     * Fixed references shown beside the editable settings so the absence of a control is explicit.
     *
     * @return list<array{key: string, label: string, value: mixed, reason: string}>
     */
    public static function fixed(): array
    {
        return [
            ['key' => 'discovery.radius_allowlist', 'label' => 'Discovery radius values', 'value' => RadiusPolicy::ALLOWED_KM, 'reason' => 'Fixed by MAT-01 and a database constraint; a release is needed to change it.'],
            ['key' => 'ranking.vps_weights', 'label' => 'VPS weights', 'value' => ['vcs' => 50, 'ohs' => 50], 'reason' => 'VPS is fixed at 50% VCS and 50% OHS.'],
            ['key' => 'orders.nrpc_cap', 'label' => 'NRPC platform cap', 'value' => null, 'reason' => 'There is no platform-wide numeric NRPC cap; oversight uses disclosure, evidence, flags, disputes and enforcement.'],
            ['key' => 'finance.live_commerce', 'label' => 'LIVE commerce', 'value' => false, 'reason' => 'LIVE commerce stays disabled for the capstone; no Admin control can enable it.'],
            ['key' => 'finance.statutory_rates', 'label' => 'Withholding rate', 'value' => ['withholding_percent' => '0.50'], 'reason' => 'Statutory rules require a cited effective legal basis and independent approval. Commercial commission rates are managed in Finance.'],
        ];
    }

    public static function exists(string $key): bool
    {
        return isset(self::definitions()[$key]);
    }

    public static function defaultValue(string $key): mixed
    {
        return self::definitions()[$key]['default'];
    }

    /**
     * @param  array<string, mixed>  $current  effective values of every setting, for cross-setting rules
     * @return array<string, list<string>>
     */
    public static function errors(string $key, mixed $value, array $current): array
    {
        $errors = [];
        $add = static function (string $field, string $message) use (&$errors): void {
            $errors['value'.($field === '' ? '' : '.'.$field)][] = $message;
        };
        $check = static function (bool $ok, string $field, string $message) use ($add): void {
            if (! $ok) {
                $add($field, $message);
            }
        };
        $int = static fn (mixed $v, int $min, int $max): bool => is_int($v) && $v >= $min && $v <= $max;
        $object = static fn (mixed $v, array $keys): bool => is_array($v) && ! array_is_list($v) && array_keys($v) === array_values(array_intersect(array_keys($v), $keys)) && count($v) === count($keys);
        switch ($key) {
            case 'ranking.srs.default_weights':
                if (! is_array($value) || array_is_list($value)) {
                    $add('', 'Provide the five Item-Based weights.');
                    break;
                }
                foreach (RankingWeights::errors($value) as $field => $messages) {
                    foreach ($messages as $message) {
                        $add(str_replace('weights.', '', $field === 'weights' ? '' : $field), $message);
                    }
                }
                if ($errors === [] && array_sum($value) !== 100) {
                    $add('', sprintf('Weights must total 100%%. They currently total %d%%.', array_sum($value)));
                }
                break;
            case 'ranking.fms.default_weights':
                if (! is_array($value) || array_is_list($value) || array_diff(array_keys($value), array_keys(FulfillmentMatchScore::DEFAULTS)) !== [] || count($value) !== 4) {
                    $add('', 'Provide exactly the four Project-Based weights.');
                    break;
                }
                foreach ($value as $component => $weight) {
                    if (! $int($weight, 0, 100)) {
                        $add((string) $component, 'Enter a whole percentage from 0 to 100.');
                    }
                }
                if ($errors === [] && array_sum($value) !== 100) {
                    $add('', sprintf('Weights must total 100%%. They currently total %d%%.', array_sum($value)));
                }
                break;
            case 'discovery.buyer_default_radius_km':
            case 'discovery.vendor_default_radius_km':
                if (! is_int($value) || ! in_array($value, RadiusPolicy::ALLOWED_KM, true)) {
                    $add('', 'Choose 5, 10, 20, 30, 40 or 50 km.');
                }
                break;
            case 'discovery.radius_expansion_threshold':
                $check($int($value, 1, 20), '', 'Enter a whole number from 1 to 20.');
                break;
            case 'orders.vendor_response_hours':
                $check($int($value, 1, 72), '', 'Enter whole hours from 1 to 72.');
                break;
            case 'orders.pending_payment_window_hours':
                if (! $int($value, 1, 72)) {
                    $add('', 'Enter whole hours from 1 to 72.');
                } elseif (max([0, ...(array) ($current['reminders.payment_hours_before'] ?? [])]) >= $value) {
                    $add('', 'The window must be longer than every payment reminder offset. Shorten the reminders first.');
                }
                break;
            case 'reminders.payment_hours_before':
                if (! is_array($value) || ! array_is_list($value) || $value === [] || count($value) > 3) {
                    $add('', 'Provide one to three reminder offsets.');
                    break;
                }
                foreach ($value as $index => $hours) {
                    if (! $int($hours, 1, 71) || $hours >= (int) ($current['orders.pending_payment_window_hours'] ?? 24)) {
                        $add((string) $index, 'Each offset is a whole hour of at least 1, shorter than the Pending Payment window.');
                    }
                }
                if (count(array_unique($value)) !== count($value)) {
                    $add('', 'Offsets must be distinct.');
                }
                break;
            case 'quotations.deadline_limits':
                if (! $object($value, ['min_hours', 'max_hours', 'default_hours'])) {
                    $add('', 'Provide the minimum, maximum and default hours.');
                    break;
                }
                foreach ($value as $field => $hours) {
                    $check($int($hours, 1, 168), (string) $field, 'Enter whole hours from 1 to 168.');
                }
                if ($errors === [] && ! ($value['min_hours'] <= $value['default_hours'] && $value['default_hours'] <= $value['max_hours'])) {
                    $add('', 'The default must lie between the minimum and the maximum.');
                }
                $reminder = $current['reminders.quotation_before_minutes'] ?? null;
                if ($errors === [] && is_array($reminder) && (int) $reminder['short_minutes'] >= $value['min_hours'] * 60) {
                    $add('min_hours', 'The minimum deadline must be longer than the short quotation reminder offset.');
                }
                break;
            case 'reminders.quotation_before_minutes':
                if (! $object($value, ['long_deadline_from_hours', 'long_minutes', 'short_minutes'])) {
                    $add('', 'Provide the long-deadline threshold and both offsets.');
                    break;
                }
                $check($int($value['long_deadline_from_hours'], 1, 168), 'long_deadline_from_hours', 'Enter whole hours from 1 to 168.');
                $check($int($value['long_minutes'], 5, 1440), 'long_minutes', 'Enter whole minutes from 5 to 1440.');
                $check($int($value['short_minutes'], 5, 1440), 'short_minutes', 'Enter whole minutes from 5 to 1440.');
                if ($errors === []) {
                    if ($value['short_minutes'] >= $value['long_minutes']) {
                        $add('short_minutes', 'The short offset must be below the long offset.');
                    }
                    if ($value['long_minutes'] >= $value['long_deadline_from_hours'] * 60) {
                        $add('long_minutes', 'The long offset must be shorter than the long-deadline threshold.');
                    }
                    $limits = $current['quotations.deadline_limits'] ?? null;
                    if (is_array($limits) && $value['short_minutes'] >= (int) $limits['min_hours'] * 60) {
                        $add('short_minutes', 'The short offset must be shorter than the minimum quotation deadline.');
                    }
                }
                break;
            case 'reminders.receipt_hours_before':
                if (! $object($value, ['first_hours', 'second_hours'])) {
                    $add('', 'Provide the first and second reminder hours.');
                    break;
                }
                $check($int($value['first_hours'], 2, 47), 'first_hours', 'Enter whole hours from 2 to 47.');
                $check($int($value['second_hours'], 1, 46), 'second_hours', 'Enter whole hours from 1 to 46.');
                if ($errors === [] && $value['second_hours'] >= $value['first_hours']) {
                    $add('second_hours', 'The second reminder must be closer to the deadline than the first.');
                }
                break;
            case 'disputes.deadlines':
                if (! $object($value, ['response_hours', 'mutual_resolution_hours', 'clarification_hours', 'appeal_business_days', 'post_completion_filing_days'])) {
                    $add('', 'Provide all five dispute deadlines.');
                    break;
                }
                $check($int($value['response_hours'], 1, 168), 'response_hours', 'Enter whole hours from 1 to 168.');
                $check($int($value['mutual_resolution_hours'], 1, 336), 'mutual_resolution_hours', 'Enter whole hours from 1 to 336.');
                $check($int($value['clarification_hours'], 1, 168), 'clarification_hours', 'Enter whole hours from 1 to 168.');
                $check($int($value['appeal_business_days'], 1, 20), 'appeal_business_days', 'Enter whole business days from 1 to 20.');
                $check($int($value['post_completion_filing_days'], 1, 30), 'post_completion_filing_days', 'Enter whole days from 1 to 30.');
                break;
            case 'reviews.windows':
                if (! $object($value, ['rating_window_days', 'edit_hours', 'correction_days'])) {
                    $add('', 'Provide the rating, edit and correction windows.');
                    break;
                }
                $check($int($value['rating_window_days'], 1, 60), 'rating_window_days', 'Enter whole days from 1 to 60.');
                $check($int($value['edit_hours'], 1, 168), 'edit_hours', 'Enter whole hours from 1 to 168.');
                $check($int($value['correction_days'], 1, 30), 'correction_days', 'Enter whole days from 1 to 30.');
                break;
            case 'badges.thresholds':
                $shape = ['fast_responder' => ['min_crr_percent' => 'percent', 'min_inquiries' => 'count'], 'on_time' => ['min_frr_percent' => 'percent', 'min_fulfilled_orders' => 'count'],
                    'highly_rated' => ['min_vcs' => 'score', 'min_vendor_ratings' => 'count'], 'high_quality_materials' => ['min_mqs' => 'score', 'min_product_ratings' => 'count'],
                    'trusted_supplier' => ['min_vcs' => 'score', 'min_ohs' => 'score', 'min_completed_orders' => 'count', 'min_active_days' => 'days']];
                if (! $object($value, array_keys($shape))) {
                    $add('', 'Provide thresholds for all five evaluated badges.');
                    break;
                }
                foreach ($shape as $badge => $fields) {
                    if (! $object($value[$badge], array_keys($fields))) {
                        $add($badge, 'Provide every threshold for this badge.');

                        continue;
                    }
                    foreach ($fields as $field => $kind) {
                        $v = $value[$badge][$field];
                        $ok = match ($kind) {
                            'percent' => is_string($v) && preg_match('/^\d{1,3}\.\d{2}$/', $v) === 1 && bccomp($v, '100.00', 2) <= 0,
                            'score' => is_string($v) && preg_match('/^\d\.\d{2}$/', $v) === 1 && bccomp($v, '1.00', 2) >= 0 && bccomp($v, '5.00', 2) <= 0,
                            'count' => $int($v, 1, 1000),
                            default => $int($v, 1, 3650),
                        };
                        $check($ok, $badge.'.'.$field, match ($kind) {
                            'percent' => 'Enter a percentage from 0.00 to 100.00 with two decimals.',
                            'score' => 'Enter a score from 1.00 to 5.00 with two decimals.',
                            'count' => 'Enter a whole sample count from 1 to 1000.',
                            default => 'Enter whole days from 1 to 3650.',
                        });
                    }
                }
                break;
            case 'projects.budget_warning_percent':
                $check($int($value, 50, 100), '', 'Enter a whole percentage from 50 to 100.');
                break;
            case 'invoices.request_service_target_business_days':
                $check($int($value, 1, 10), '', 'Enter whole business days from 1 to 10.');
                break;
            case 'analytics.disclosure_min_persons':
                $check($int($value, 1, 50), '', 'Enter a whole number of persons from 1 to 50.');
                break;
            case 'uploads.limits_kb':
                if (! $object($value, array_keys(self::UPLOAD_CEILINGS_KB))) {
                    $add('', 'Provide a limit for every upload purpose.');
                    break;
                }
                foreach (self::UPLOAD_CEILINGS_KB as $purpose => $ceiling) {
                    $check($int($value[$purpose], 512, $ceiling), $purpose, sprintf('Enter whole KB from 512 to the approved ceiling of %d KB.', $ceiling));
                }
                break;
            case 'features.flags':
                if (! $object($value, ['materials_analytics', 'geo_analytics']) || ! is_bool($value['materials_analytics']) || ! is_bool($value['geo_analytics'])) {
                    $add('', 'Provide true or false for each approved feature.');
                }
                break;
            default:
                $add('', 'This setting is not an approved Platform Setting.');
        }

        return $errors;
    }
}
