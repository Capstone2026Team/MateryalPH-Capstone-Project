<?php

declare(strict_types=1);

namespace App\Domain\Operations;

use App\Domain\Enforcement\EnforcementService;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;

/**
 * Role-specific work queues for the Admin operations home. A queue appears only when the Admin holds its permission
 * (evaluated on the server), so a count never reveals work outside the role's scope. Each entry links to its filtered
 * queue and reports the oldest pending item's age so ageing work is visible without opening the queue.
 */
final class OperationsQueueService
{
    /**
     * @param  list<string>  $permissions
     * @return list<array<string, mixed>>
     */
    public function queues(array $permissions, int $userId): array
    {
        $has = static fn (string $permission): bool => in_array($permission, $permissions, true);
        $queues = [];
        $add = static function (string $key, string $label, string $group, int $count, mixed $oldest, string $href, string $description) use (&$queues): void {
            $queues[] = ['key' => $key, 'label' => $label, 'group' => $group, 'count' => $count, 'href' => $href, 'description' => $description,
                'oldest_at' => $oldest === null ? null : CarbonImmutable::parse((string) $oldest)->toIso8601String()];
        };
        if ($has('vendor_verification.review')) {
            $pending = DB::table('vendor_organizations')->whereIn('store_verification_status', ['SUBMITTED', 'PENDING_VERIFICATION']);
            $oldest = DB::table('vendor_onboarding_requirements as r')->join('vendor_organizations as o', 'o.id', '=', 'r.vendor_organization_id')->where('r.is_current', true)
                ->where('r.status', 'PENDING_VERIFICATION')->min('r.submitted_at');
            $add('vendor_verification', 'Vendor documents and verification', 'Vendor Management', (clone $pending)->count(), $oldest, '/vendor-verification?status=PENDING_VERIFICATION',
                'Submitted Store Verification cases with requirements awaiting a decision.');
            $add('vendor_activation', 'Activation readiness', 'Vendor Management', DB::table('vendor_organizations')->where('store_verification_status', 'APPROVED')
                ->whereNotIn('store_activation_status', ['ACTIVE'])->count(), null, '/vendor-verification?status=APPROVED&activation=NOT_ACTIVE', 'Approved stores not yet active; open each case for its exact blockers.');
            $add('document_expiry', 'Documents expiring in 30 days', 'Vendor Management', DB::table('business_document_reviews')->where('decision', 'APPROVED')->where('expiration_kind', 'DATE')
                ->whereBetween('verified_expiration_date', [now()->toDateString(), now()->addDays(30)->toDateString()])->count(), null, '/vendor-verification?expiry=30', 'Admin-verified expiration dates within 30 days.');
        }
        if ($has('product_compliance.review')) {
            $add('product_compliance', 'Product compliance reviews', 'Compliance and quality', DB::table('compliance_submissions')->where('status', 'PENDING_ADMIN_REVIEW')->count(),
                DB::table('compliance_submissions')->where('status', 'PENDING_ADMIN_REVIEW')->min('created_at'), '/product-compliance', 'PS/ICC submissions awaiting an Admin decision.');
        }
        if ($has('disputes.view')) {
            $review = DB::table('dispute_cases')->whereIn('status', ['ESCALATED_ADMIN_REVIEW', 'AWAITING_CLARIFICATION']);
            $add('disputes', 'Disputes under Admin review', 'Disputes and appeals', (clone $review)->count(), (clone $review)->min('escalated_at'), '/disputes?status=ESCALATED_ADMIN_REVIEW', 'Escalated cases and cases awaiting clarification.');
            $add('appeals', 'Open appeals', 'Disputes and appeals', DB::table('dispute_cases')->where('status', 'APPEAL_OPEN')->count(), null, '/disputes?status=APPEAL_OPEN', 'One appeal per case, decided by a different reviewer.');
            $add('remedies', 'Remedies in progress', 'Disputes and appeals', DB::table('dispute_remedies')->whereIn('state', ['PENDING', 'FAILED'])->count(),
                DB::table('dispute_remedies')->whereIn('state', ['PENDING', 'FAILED'])->min('created_at'), '/disputes?status=DECIDED', 'Replacement, refund and reimbursement remedies not yet terminal.');
        }
        if ($has('enforcement.view')) {
            $counts = EnforcementService::counts();
            $add('enforcement', 'Referred sanctions', 'Account enforcement', $counts['referred'], DB::table('enforcement_actions')->where('state', 'REFERRED')->min('created_at'), '/enforcement?state=REFERRED',
                'Restrictions, suspensions and bans recommended by a case decision or recorded for review.');
            $add('active_sanctions', 'Active restrictions and suspensions', 'Account enforcement', $counts['applied'], null, '/enforcement?state=APPLIED', 'Applied sanctions with their continuation plans.');
        }
        if ($has('reviews.moderate')) {
            $add('review_moderation', 'Flagged reviews', 'Compliance and quality', DB::table('review_flags')->where('state', 'OPEN')->count(), DB::table('review_flags')->where('state', 'OPEN')->min('created_at'),
                '/reviews', 'Review reports awaiting moderation.');
        }
        if ($has('invoices.view')) {
            $add('invoices', 'Overdue invoice requests', 'Finance', DB::table('invoice_requests')->whereIn('state', ['REQUESTED', 'RETURNED_FOR_CORRECTION'])->where('service_target_at', '<', now())->count(),
                DB::table('invoice_requests')->whereIn('state', ['REQUESTED', 'RETURNED_FOR_CORRECTION'])->where('service_target_at', '<', now())->min('created_at'), '/invoices', 'Buyer invoice requests past the service target.');
        }
        if ($has('privacy.manage') || $has('privacy.handle')) {
            $open = DB::table('privacy_requests')->whereNotIn('state', ['COMPLETED', 'REJECTED', 'WITHDRAWN'])->when(! $has('privacy.manage'), fn ($q) => $q->where('handler_user_id', $userId));
            $add('privacy', $has('privacy.manage') ? 'Open privacy requests' : 'Privacy requests assigned to you', 'Platform', (clone $open)->count(), (clone $open)->min('received_at'), '/privacy', 'Verified data-subject requests being handled.');
        }
        if ($has('orders.operations.view')) {
            $failed = DB::table('refunds')->where('state', 'REFUND_FAILED');
            $add('refund_failures', 'Failed refunds', 'Payments and refunds', (clone $failed)->count(), (clone $failed)->min('updated_at'), '/order-operations', 'Refunds needing a funded retry; never a duplicate request.');
            $add('refunds_pending', 'Refunds pending over 24 hours', 'Payments and refunds', DB::table('refunds')->where('state', 'REFUND_PENDING')->where('created_at', '<', now()->subDay())->count(), null,
                '/order-operations', 'Pending until a verified provider event or reconciliation.');
            $add('reimbursements', 'Cash reimbursements awaiting evidence', 'Payments and refunds', DB::table('physical_reimbursements')->where('state', 'VENDOR_REIMBURSEMENT_PENDING')->count(), null,
                '/order-operations', 'Physical reimbursements tracked separately from online refunds.');
        }
        if ($has('finance.view')) {
            $add('finance_reviews', 'Finance work items', 'Finance', DB::table('finance_review_items')->where('state', 'OPEN')->count(), DB::table('finance_review_items')->where('state', 'OPEN')->min('created_at'),
                '/finance', 'Reconciliation exceptions, threshold reviews, overlaps and fee proposals (DEMO — simulation).');
        }
        if ($has('integrations.view')) {
            $counts = JobHealthService::counts();
            $add('jobs', 'Failed jobs and dead letters', 'Platform', $counts['failed_jobs'] + $counts['dead_letters'], null, '/integrations', 'Allowlisted idempotent work can be retried with a reason.');
        }

        return $queues;
    }
}
