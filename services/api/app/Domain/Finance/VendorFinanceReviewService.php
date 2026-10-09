<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/**
 * The Vendor Owner's view of FIN-10 reviews that concern the store: commission statement approval and payment status
 * (including overdue debt), tax adjustments opened by refunds or corrections, tax evidence review state and open
 * platform finance reviews. Owner-only (finance.view); a Store Manager or other staff receive 403. Internal reviewer
 * notes, other Vendors and taxpayer identifiers are never included.
 */
final class VendorFinanceReviewService
{
    public function __construct(private readonly FinanceAccess $access) {}

    /** @return array<string, mixed> */
    public function reviews(Request $request): array
    {
        $scope = $this->access->owner($request);
        $organization = $scope['organization_id'];
        $today = CarbonImmutable::now('Asia/Manila')->toDateString();

        return [
            'label' => 'DEMO — No real funds or BIR filing',
            'statements' => DB::table('fee_statements')->where('vendor_organization_id', $organization)->whereIn('state', ['ISSUED', 'PARTIALLY_PAID', 'PAID'])->orderByDesc('period_start')->limit(12)
                ->get(['id', 'statement_reference', 'period_start', 'period_end', 'due_on', 'state', 'charges_centavos', 'credits_centavos', 'paid_centavos', 'outstanding_centavos', 'approved_at'])
                ->map(static fn (object $row): array => ['id' => (string) $row->id, 'reference' => $row->statement_reference, 'period_start' => (string) $row->period_start, 'period_end' => (string) $row->period_end,
                    'due_on' => (string) $row->due_on, 'state' => (string) $row->state, 'charges_centavos' => (int) $row->charges_centavos, 'credits_centavos' => (int) $row->credits_centavos,
                    'paid_centavos' => (int) $row->paid_centavos, 'outstanding_centavos' => (int) $row->outstanding_centavos, 'overdue' => (int) $row->outstanding_centavos > 0 && (string) $row->due_on < $today,
                    'approved' => $row->approved_at !== null])->all(),
            'tax_adjustments' => DB::table('tax_adjustments as t')->join('orders as o', 'o.id', '=', 't.order_id')->where('o.vendor_organization_id', $organization)->orderByDesc('t.created_at')->limit(25)
                ->get(['t.id', 't.kind', 't.state', 't.period_start', 't.period_end', 't.amount_centavos', 't.reviewed_at', 't.posted_at', 't.created_at', 'o.reference'])
                ->map(static fn (object $row): array => ['id' => (string) $row->id, 'kind' => (string) $row->kind, 'state' => (string) $row->state, 'order_reference' => (string) $row->reference,
                    'period_start' => (string) $row->period_start, 'period_end' => (string) $row->period_end, 'amount_centavos' => (int) $row->amount_centavos,
                    'reviewed' => $row->reviewed_at !== null, 'posted_at' => $row->posted_at === null ? null : CarbonImmutable::parse((string) $row->posted_at)->toIso8601String(),
                    'created_at' => CarbonImmutable::parse((string) $row->created_at)->toIso8601String()])->all(),
            'evidence' => DB::table('tax_evidence as e')->join('vendor_tax_profile_versions as tv', 'tv.id', '=', 'e.vendor_tax_profile_version_id')
                ->join('vendor_tax_profiles as p', 'p.id', '=', 'tv.vendor_tax_profile_id')->where('p.vendor_organization_id', $organization)->orderByDesc('e.created_at')->limit(25)
                ->get(['e.id', 'e.evidence_type', 'e.review_state', 'e.valid_from', 'e.valid_until', 'e.reviewed_at', 'tv.taxable_year'])
                ->map(static fn (object $row): array => ['id' => (string) $row->id, 'evidence_type' => (string) $row->evidence_type, 'review_state' => (string) $row->review_state,
                    'valid_from' => $row->valid_from, 'valid_until' => $row->valid_until, 'taxable_year' => $row->taxable_year === null ? null : (int) $row->taxable_year,
                    'reviewed_at' => $row->reviewed_at === null ? null : CarbonImmutable::parse((string) $row->reviewed_at)->toIso8601String()])->all(),
            'open_reviews' => DB::table('finance_review_items')->where('vendor_organization_id', $organization)->where('state', 'OPEN')->orderBy('created_at')->limit(25)->get(['id', 'kind', 'created_at'])
                ->map(static fn (object $row): array => ['id' => (string) $row->id, 'kind' => (string) $row->kind, 'label' => self::label((string) $row->kind),
                    'created_at' => CarbonImmutable::parse((string) $row->created_at)->toIso8601String()])->all(),
        ];
    }

    private static function label(string $kind): string
    {
        return match ($kind) {
            'RECONCILIATION_EXCEPTION' => 'A simulated settlement differs from the assessment and is being reconciled.',
            'OVERLAP_UNRESOLVED' => 'Your declared outside-platform total is under review; standard withholding applies meanwhile.',
            'THRESHOLD_ADJUSTMENT_REQUIRED' => 'A refund touched a remittance after the threshold was crossed; the status stays unchanged while finance reviews it.',
            'BASE_REVIEW_REQUIRED' => 'A remittance base needs finance review before it is posted.',
            'STATEMENT_OVERDUE' => 'A commission statement is overdue.',
            'FEE_CREDIT_PROPOSAL', 'PAID_FEE_CREDIT_PAYABLE' => 'A commission fee credit is being reviewed.',
            default => 'A platform finance review is in progress.',
        };
    }
}
