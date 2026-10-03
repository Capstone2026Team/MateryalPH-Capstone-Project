<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Payments\PaymentChannelCatalog;
use App\Domain\Payments\PaymentGateway;
use App\Domain\Payments\PaymentMethodPolicy;
use App\Domain\Payments\PaymentPresenter;
use Carbon\CarbonImmutable;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Symfony\Component\HttpFoundation\StreamedResponse;

/**
 * Vendor Owner finance surface: separate Xendit connection, Vendor Tax Profile summary, withholding arrangement,
 * FIN-04A threshold panel, Commission Terms, online channels, physical payments and refund capability sections,
 * plus the read-only Transaction History tabs, statements and Earnings (FIN-11). No wallet, stored balance or
 * escrow exists: figures are records and DEMO projections, never a balance MateryalPH holds. Every simulated
 * figure carries a DEMO label and no raw TIN, provider ID or private document is ever returned.
 */
final class VendorFinanceService
{
    public const TABS = ['PAYMENTS', 'PHYSICAL', 'REMITTANCES', 'STATEMENTS', 'REFUNDS', 'TAX_DOCUMENTS'];

    public const PER_PAGE = 20;

    public function __construct(
        private readonly FinanceAccess $access,
        private readonly TaxpayerContext $taxpayers,
        private readonly PaymentChannelCatalog $channels,
        private readonly PaymentGateway $gateway,
        private readonly PaymentMethodPolicy $methods,
        private readonly PaymentPresenter $presenter,
        private readonly AuditRecorder $audit,
    ) {}

    /** @return array<string, mixed> */
    public function overview(Request $request): array
    {
        $scope = $this->access->owner($request);
        $organizationId = $scope['organization_id'];
        $account = DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organizationId)->first();
        $descriptor = $this->gateway->descriptor();
        $connected = $account !== null && $account->connection_status === 'CONNECTED_TEST' && $account->provider_associated_at !== null && $account->environment === 'TEST';
        $taxpayer = null;
        try {
            $taxpayer = $this->taxpayers->forOrganization($organizationId, CarbonImmutable::now());
        } catch (AuthenticationException) {
        }
        $settings = $this->methods->settings($organizationId);
        $channels = array_map(static fn (array $option): array => array_intersect_key($option, array_flip(['code', 'display_name', 'kind', 'available', 'unavailable_reason', 'refund_supported', 'rate_label', 'fee_version'])),
            $this->channels->options(100000));
        $outstanding = DB::table('fee_statements')->where('vendor_organization_id', $organizationId)->whereIn('state', ['ISSUED', 'PARTIALLY_PAID'])->get(['outstanding_centavos', 'due_on']);

        return [
            'demo_label' => 'DEMO — simulated tax and settlement figures. Xendit TEST payments are not real charges; no tax was withheld or remitted and no BIR filing occurred.',
            'xendit_connection' => [
                'status' => $connected ? 'CONNECTED_TEST' : ($account?->provider_associated_at !== null ? 'PENDING' : 'NOT_CONNECTED'),
                'label' => $connected ? 'Connected — TEST' : ($account?->provider_associated_at !== null ? 'Connection pending reconciliation' : 'Not connected'),
                'environment' => 'TEST', 'raw_provider_status' => $account?->provider_status, 'account_contract' => $account?->provider_api_version,
                'payment_api' => $descriptor->paymentApiVersion, 'gateway_mode' => $descriptor->mode, 'provider_configured' => $descriptor->configured,
                'last_reconciled_at' => self::iso($account?->last_reconciled_at), 'production_capability' => false,
                'note' => 'The TEST sub-account was connected during Store Setup and is reused for every payment. A TEST status never proves live payment, KYC or tax readiness.',
            ],
            'tax_profile' => $taxpayer === null ? ['available' => false] : [
                'available' => true, 'tin_masked' => $taxpayer['tin_last4'] === null ? null : '•••-•••-'.substr((string) $taxpayer['tin_last4'], -3).' (masked)',
                'vat_category' => $taxpayer['vat_category'], 'entity_class' => $taxpayer['entity_class'], 'fiscal_year_start_month' => $taxpayer['fiscal_year_start_month'],
                'relief_claimed' => $taxpayer['relief_claimed'], 'declaration' => $this->declaration($organizationId),
            ],
            'withholding_arrangement' => [
                'scenario' => $taxpayer['scenario'] ?? 'DEMO_PLATFORM_WITHHOLDER',
                'label' => ($taxpayer['scenario'] ?? '') === 'DEMO_PROVIDER_WITHHOLDER' ? 'DEMO provider-withholder scenario (simulated)' : 'DEMO platform-withholder scenario (simulated)',
                'production_assignment' => 'UNCONFIRMED', 'production_assignment_label' => 'Production assignment unconfirmed',
                'rate_label' => '0.5% of qualifying gross remittance (RR No. 5-2025); never an extra Buyer charge',
            ],
            'threshold' => $taxpayer === null ? null : $this->threshold($taxpayer),
            'commission_terms' => $this->commissionTerms($organizationId, $scope['user_id']),
            'online_channels' => ['provider_ready' => $descriptor->configured && $connected, 'channels' => $channels,
                'fee_note' => 'Buyers see the Payment Processing Fee before paying; it is the configured DEMO channel rate with no markup.'],
            'physical_payments' => $settings + ['cod_note' => 'Cash on Delivery pairs with Site Delivery only.', 'in_store_note' => 'In-Store Payment pairs with Self-Pickup only.'],
            'refund_capability' => [
                'status' => $connected && $descriptor->configured ? 'AVAILABLE_TEST' : 'UNAVAILABLE',
                'refund_channels' => array_values(array_map(static fn (array $c): string => (string) $c['display_name'], array_filter($channels, static fn (array $c): bool => $c['available'] && $c['refund_supported']))),
                'note' => 'Refunds go to the original payment method. Cash collected directly is reimbursed and recorded separately, never through an unrelated online payment.',
            ],
            'statements' => ['outstanding_centavos' => (int) $outstanding->sum('outstanding_centavos'), 'next_due_on' => $outstanding->min('due_on')],
            'notices' => DB::table('notifications')->where('user_id', $scope['user_id'])->whereIn('category', [FinanceNotifier::MANDATORY, FinanceNotifier::ADVISORY])
                ->orderByDesc('created_at')->limit(10)->get(['id', 'category', 'title', 'body', 'created_at', 'read_at'])
                ->map(static fn (object $row): array => ['id' => (string) $row->id, 'mandatory' => $row->category === FinanceNotifier::MANDATORY, 'title' => (string) $row->title,
                    'body' => (string) $row->body, 'created_at' => self::iso($row->created_at), 'read' => $row->read_at !== null])->all(),
        ];
    }

    /**
     * Owner enables or disables Cash on Delivery and In-Store Payment for future orders only; accepted orders keep
     * their snapshot. Optimistic lock_version guards concurrent edits (0 = no saved settings yet).
     *
     * @param  array{lock_version: int, cod_enabled: bool, in_store_enabled: bool}  $input
     * @return array<string, mixed>
     */
    public function updatePhysicalPayments(Request $request, array $input): array
    {
        $scope = $this->access->owner($request, 'payments.configure');
        DB::transaction(function () use ($request, $scope, $input): void {
            DB::table('vendor_organizations')->where('id', $scope['organization_id'])->lockForUpdate()->first();
            $current = DB::table('vendor_payment_settings')->where('vendor_organization_id', $scope['organization_id'])->first();
            if ((int) ($current->lock_version ?? 0) !== (int) $input['lock_version']) {
                throw new AuthenticationException('VERSION_CONFLICT', 'These payment settings changed. Refresh and review them again.', 409, ['current_lock_version' => (int) ($current->lock_version ?? 0)]);
            }
            $values = ['cod_enabled' => (bool) $input['cod_enabled'], 'in_store_enabled' => (bool) $input['in_store_enabled'], 'updated_by_user_id' => $scope['user_id'], 'updated_at' => now()];
            if ($current === null) {
                DB::table('vendor_payment_settings')->insert($values + ['id' => (string) Str::uuid7(), 'vendor_organization_id' => $scope['organization_id'], 'lock_version' => 1, 'created_at' => now()]);
            } else {
                DB::table('vendor_payment_settings')->where('id', $current->id)->update($values + ['lock_version' => (int) $current->lock_version + 1]);
            }
            $this->audit->account($request, 'VENDOR_PHYSICAL_PAYMENT_SETTINGS_UPDATED', 'VENDOR_ORGANIZATION', $scope['organization_id'],
                before: ['cod_enabled' => (bool) ($current->cod_enabled ?? false), 'in_store_enabled' => (bool) ($current->in_store_enabled ?? false)], after: ['cod_enabled' => $values['cod_enabled'], 'in_store_enabled' => $values['in_store_enabled']]);
        });

        return $this->methods->settings($scope['organization_id']);
    }

    /**
     * @param  array<string, mixed>  $taxpayer
     * @return array<string, mixed>
     */
    private function threshold(array $taxpayer): array
    {
        $accumulator = DB::table('vendor_withholding_accumulators')->where('environment', 'TEST')->where('taxpayer_key', $taxpayer['taxpayer_key'])->where('taxable_year', $taxpayer['taxable_year'])->first();
        $threshold = (int) ($accumulator->threshold_centavos ?? WithholdingThresholdEngine::DEFAULT_THRESHOLD_CENTAVOS);
        $effective = (int) ($accumulator->g_effective_centavos ?? $taxpayer['external_declared_centavos']);
        $status = (string) ($accumulator->withholding_status ?? 'NOT_STARTED');
        $crossed = $accumulator?->crossed_at === null ? null : CarbonImmutable::parse((string) $accumulator->crossed_at);

        return [
            'demo' => true, 'taxable_year' => (int) $taxpayer['taxable_year'], 'year_start_at' => $taxpayer['year_start_at']->toIso8601String(), 'year_end_at' => $taxpayer['year_end_at']->toIso8601String(),
            'threshold_centavos' => $threshold, 'cumulative_gross_centavos' => $effective, 'remaining_allowance_centavos' => max(0, $threshold - $effective),
            'local_gross_centavos' => (int) ($accumulator->g_accumulated_centavos ?? 0), 'external_declared_centavos' => (int) ($accumulator->g_external_declared_centavos ?? $taxpayer['external_declared_centavos']),
            'external_overlap_centavos' => (int) ($accumulator->g_external_overlap_centavos ?? 0), 'external_overlap_state' => $accumulator->external_overlap_state ?? ($taxpayer['external_overlap_unresolved'] ? 'UNRESOLVED' : 'NONE'),
            'percent_of_threshold' => (int) min(100, intdiv($effective * 100, $threshold)), 'advisory' => $effective >= intdiv($threshold * 80, 100) && $crossed === null,
            'status' => $status, 'status_label' => self::statusLabel($status), 'status_icon' => self::statusIcon($status), 'reason_code' => $accumulator->status_reason_code ?? null,
            'crossed_at' => $crossed?->toIso8601String(), 'crossed_at_manila' => $crossed?->setTimezone('Asia/Manila')->format('F j, Y g:i A').($crossed === null ? '' : ' (Asia/Manila)'),
            'prior_year_total_centavos' => $accumulator?->prior_year_total_centavos === null ? null : (int) $accumulator->prior_year_total_centavos,
            'final_for_year_notice' => 'Crossing ₱500,000.00 is final for the taxable year: withholding then applies to the whole crossing remittance and every later remittance, and a refund or a newly uploaded declaration does not restore relief until the next taxable year.',
            'events' => $accumulator === null ? [] : DB::table('vendor_withholding_status_events')->where('accumulator_id', $accumulator->id)->orderByDesc('occurred_at')->limit(10)->get()
                ->map(static fn (object $event): array => ['from_status' => $event->from_status, 'to_status' => (string) $event->to_status, 'reason_code' => (string) $event->reason_code,
                    'g_before_centavos' => (int) $event->g_before_centavos, 'g_after_centavos' => (int) $event->g_after_centavos, 'actor_type' => (string) $event->actor_type, 'occurred_at' => self::iso($event->occurred_at)])->all(),
        ];
    }

    /** @return array<string, mixed> */
    private function declaration(string $organizationId): array
    {
        $evidence = DB::table('tax_evidence as e')->join('vendor_tax_profile_versions as v', 'v.id', '=', 'e.vendor_tax_profile_version_id')->join('vendor_tax_profiles as p', 'p.id', '=', 'v.vendor_tax_profile_id')
            ->where('p.vendor_organization_id', $organizationId)->where('e.evidence_type', 'TAX_RELIEF_DECLARATION')->orderByDesc('e.created_at')->first(['e.review_state', 'e.valid_from', 'e.valid_until', 'e.created_at', 'v.taxable_year']);

        return $evidence === null ? ['status' => 'NOT_SUBMITTED'] : ['status' => (string) $evidence->review_state, 'taxable_year' => $evidence->taxable_year === null ? null : (int) $evidence->taxable_year,
            'valid_from' => $evidence->valid_from, 'valid_until' => $evidence->valid_until, 'submitted_at' => self::iso($evidence->created_at),
            'note' => 'A declaration is a claim reviewed by MateryalPH; it is never automatic relief, and one recorded after a crossing does not change that taxable year.'];
    }

    /** @return array<string, mixed> */
    private function commissionTerms(string $organizationId, int $ownerId): array
    {
        $acceptance = DB::table('agreement_acceptances as a')->join('agreement_versions as v', 'v.id', '=', 'a.agreement_version_id')->join('agreement_documents as d', 'd.id', '=', 'v.agreement_document_id')
            ->where('d.code', 'VENDOR_COMMISSION_TEST')->where('a.vendor_organization_id', $organizationId)->orderByDesc('a.accepted_at')->first(['v.version', 'a.accepted_at', 'd.title']);

        return ['accepted' => $acceptance !== null, 'title' => $acceptance->title ?? 'Vendor Commission Terms — TEST/DEMO', 'version' => $acceptance === null ? null : (int) $acceptance->version,
            'accepted_at' => self::iso($acceptance?->accepted_at), 'rate_label' => '2% of completed, non-refunded materials value excluding VAT, billed monthly',
            'note' => 'Accepted once in Store Verification. MateryalPH never asks for this consent again here and never deducts commission from Buyer payments.'];
    }

    /**
     * @param  array{tab?: string, page?: int}  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function transactions(Request $request, array $filters): array
    {
        $organizationId = $this->access->owner($request)['organization_id'];
        $tab = $filters['tab'] ?? 'PAYMENTS';
        $page = max(1, min(1000, (int) ($filters['page'] ?? 1)));
        $query = $this->tabQuery($organizationId, $tab);
        $total = (clone $query)->count();
        $rows = $query->offset(($page - 1) * self::PER_PAGE)->limit(self::PER_PAGE)->get();

        return ['items' => $rows->map(fn (object $row): array => $this->row($tab, $row))->all(),
            'meta' => ['tab' => $tab, 'page' => $page, 'per_page' => self::PER_PAGE, 'total' => $total, 'has_more' => $page * self::PER_PAGE < $total, 'environment' => 'TEST', 'demo' => true]];
    }

    /** Owner-only CSV export of one tab; every download is audited and carries the internal-report notice. */
    public function export(Request $request, string $tab): StreamedResponse
    {
        $scope = $this->access->owner($request);
        if (! in_array($tab, self::TABS, true)) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Choose a Transaction History tab to export.', 422);
        }
        $rows = $this->tabQuery($scope['organization_id'], $tab)->limit(5000)->get()->map(fn (object $row): array => $this->row($tab, $row))->all();
        $this->audit->account($request, 'FINANCE_EXPORT_DOWNLOADED', 'VENDOR_ORGANIZATION', $scope['organization_id'], after: ['tab' => $tab, 'rows' => count($rows)]);

        return response()->streamDownload(static function () use ($rows): void {
            $out = fopen('php://output', 'wb');
            fputcsv($out, ['Internal Operational Report - Not a Tax Invoice. TEST/DEMO figures; no BIR filing.']);
            if ($rows !== []) {
                fputcsv($out, array_keys($rows[0]));
                foreach ($rows as $row) {
                    fputcsv($out, array_map(static fn (mixed $value): string => is_scalar($value) || $value === null ? (string) $value : json_encode($value, JSON_THROW_ON_ERROR), $row));
                }
            }
            fclose($out);
        }, 'materyalph-'.strtolower($tab).'-test.csv', ['Content-Type' => 'text/csv; charset=UTF-8', 'Cache-Control' => 'private, no-store']);
    }

    /** @return array<string, mixed> FIN-11 Owner Earnings: separate figures, never a balance. */
    public function earnings(Request $request): array
    {
        $organizationId = $this->access->owner($request)['organization_id'];
        $orders = DB::table('orders')->where('vendor_organization_id', $organizationId)->whereNotIn('order_state', ['DECLINED', 'EXPIRED', 'CANCELLED', 'AWAITING_VENDOR_CONFIRMATION', 'AWAITING_BUYER_APPROVAL', 'AWAITING_NRPC_ACCEPTANCE']);
        $snapshots = DB::table('financial_snapshots as s')->joinSub(DB::table('financial_snapshots')->selectRaw('order_id, max(version) as version')->groupBy('order_id'), 'latest', fn ($join) => $join->on('latest.order_id', '=', 's.order_id')->on('latest.version', '=', 's.version'))
            ->whereIn('s.order_id', (clone $orders)->select('id'));
        $payments = DB::table('payments')->where('vendor_organization_id', $organizationId)->where('purpose', '<>', 'PLATFORM_FEE_PAYMENT')->where('state', 'PAID')->where('late_capture', false);
        $assessments = DB::table('remittance_assessments')->whereIn('order_id', (clone $orders)->select('id'))->where('calculation_state', 'POSTED');
        $fees = DB::table('fee_assessments')->where('vendor_organization_id', $organizationId);

        return [
            'demo' => true, 'environment' => 'TEST', 'notice' => 'Internal Operational Report — Not a Tax Invoice. Cash receipts do not equal taxable income; this does not replace your books or BIR returns.',
            'commercial_sales_centavos' => (int) (clone $snapshots)->sum('s.buyer_total_centavos'), 'included_vat_centavos' => (int) (clone $snapshots)->sum('s.materials_vat_centavos'),
            'online_collections_centavos' => (int) (clone $payments)->sum('principal_centavos'), 'buyer_processing_fees_centavos' => (int) (clone $payments)->sum('processing_fee_centavos'),
            'physical_collections_centavos' => (int) DB::table('physical_payment_records')->whereIn('order_id', (clone $orders)->select('id'))->where('record_kind', 'COLLECTION')->sum('amount_centavos'),
            'provider_charges_centavos' => (int) (clone $assessments)->sum('provider_charge_centavos'), 'simulated_cwt_centavos' => (int) (clone $assessments)->sum('withheld_centavos'),
            'estimated_remittance_cash_centavos' => (int) (clone $assessments)->sum('expected_vendor_cash_centavos'),
            'earned_commission_centavos' => (int) (clone $fees)->where('state', 'EARNED')->sum('earned_centavos'), 'estimated_commission_centavos' => (int) (clone $fees)->where('state', 'ESTIMATED')->sum('earned_target_centavos'),
            'unpaid_statements_centavos' => (int) DB::table('fee_statements')->where('vendor_organization_id', $organizationId)->whereIn('state', ['ISSUED', 'PARTIALLY_PAID'])->sum('outstanding_centavos'),
        ];
    }

    /** @return array<string, mixed> */
    public function statement(Request $request, string $statementId): array
    {
        $organizationId = $this->access->owner($request)['organization_id'];
        $statement = DB::table('fee_statements')->where('id', $statementId)->where('vendor_organization_id', $organizationId)->whereNot('state', 'DRAFT')->first();
        if ($statement === null) {
            throw new AuthenticationException('STATEMENT_NOT_FOUND', 'This statement is unavailable.', 404);
        }

        return self::statementView($statement) + [
            'lines' => DB::table('fee_statement_lines as l')->leftJoin('fee_assessments as f', 'f.id', '=', 'l.fee_assessment_id')->leftJoin('orders as o', 'o.id', '=', 'f.order_id')
                ->where('l.fee_statement_id', $statementId)->orderBy('l.created_at')->get(['l.line_type', 'l.amount_centavos', 'l.description', 'o.reference', 'f.commission_basis_centavos'])
                ->map(static fn (object $line): array => ['type' => (string) $line->line_type, 'amount_centavos' => (int) $line->amount_centavos, 'description' => (string) $line->description,
                    'order_reference' => $line->reference, 'basis_centavos' => $line->commission_basis_centavos === null ? null : (int) $line->commission_basis_centavos])->all(),
            'payments' => DB::table('payments')->where('fee_statement_id', $statementId)->orderByDesc('created_at')->get()->map(fn (object $payment): array => $this->presenter->attempt($payment, true))->all(),
            'channels' => in_array($statement->state, ['ISSUED', 'PARTIALLY_PAID'], true) ? $this->channels->options(max(1, (int) $statement->outstanding_centavos), 'PLATFORM') : [],
        ];
    }

    /** @return array<string, mixed> */
    public static function statementView(object $statement): array
    {
        $overdue = in_array($statement->state, ['ISSUED', 'PARTIALLY_PAID'], true) && (int) $statement->outstanding_centavos > 0 && $statement->due_on < now('Asia/Manila')->toDateString();

        return ['id' => (string) $statement->id, 'reference' => (string) $statement->statement_reference, 'state' => (string) $statement->state, 'overdue' => $overdue,
            'period_start' => (string) $statement->period_start, 'period_end' => (string) $statement->period_end, 'issued_on' => (string) $statement->issued_on, 'due_on' => (string) $statement->due_on,
            'charges_centavos' => (int) $statement->charges_centavos, 'credits_centavos' => (int) $statement->credits_centavos, 'paid_centavos' => (int) $statement->paid_centavos,
            'outstanding_centavos' => (int) $statement->outstanding_centavos, 'disputed_held_centavos' => (int) $statement->disputed_held_centavos, 'lock_version' => (int) $statement->lock_version,
            'sample_notice' => 'SAMPLE statement — not an official invoice. TEST/DEMO billing.'];
    }

    private function tabQuery(string $organizationId, string $tab): Builder
    {
        return match ($tab) {
            'PAYMENTS' => DB::table('payments as p')->leftJoin('orders as o', 'o.id', '=', 'p.order_id')->where('p.vendor_organization_id', $organizationId)->where('p.purpose', '<>', 'PLATFORM_FEE_PAYMENT')
                ->orderByDesc('p.created_at')->select(['p.*', 'o.reference as order_reference']),
            'PHYSICAL' => DB::table('physical_payment_records as r')->join('orders as o', 'o.id', '=', 'r.order_id')->where('o.vendor_organization_id', $organizationId)->orderByDesc('r.recorded_at')
                ->select(['r.*', 'o.reference as order_reference']),
            'REMITTANCES' => DB::table('remittance_assessments as a')->join('orders as o', 'o.id', '=', 'a.order_id')->where('o.vendor_organization_id', $organizationId)->orderByDesc('a.created_at')
                ->select(['a.*', 'o.reference as order_reference']),
            'STATEMENTS' => DB::table('fee_statements')->where('vendor_organization_id', $organizationId)->whereNot('state', 'DRAFT')->orderByDesc('period_start'),
            'REFUNDS' => DB::table('refunds as f')->leftJoin('orders as o', 'o.id', '=', 'f.order_id')->where(fn ($q) => $q->where('o.vendor_organization_id', $organizationId)
                ->orWhereIn('f.fee_statement_id', DB::table('fee_statements')->where('vendor_organization_id', $organizationId)->select('id')))->orderByDesc('f.created_at')->select(['f.*', 'o.reference as order_reference']),
            'TAX_DOCUMENTS' => DB::table('tax_certificates')->where('vendor_organization_id', $organizationId)->orderByDesc('period_end'),
            default => throw new AuthenticationException('VALIDATION_FAILED', 'Unknown Transaction History tab.', 422),
        };
    }

    /** @return array<string, mixed> */
    private function row(string $tab, object $row): array
    {
        return match ($tab) {
            'PAYMENTS' => ['id' => (string) $row->id, 'reference' => (string) ($row->order_reference ?? ''), 'purpose' => (string) $row->purpose, 'status' => $this->presenter->attempt($row, false)['status'],
                'gross_centavos' => (int) $row->total_centavos, 'principal_centavos' => (int) $row->principal_centavos, 'buyer_processing_fee_centavos' => (int) $row->processing_fee_centavos,
                'channel' => $row->channel_code, 'environment' => (string) $row->environment, 'evidence_origin' => (string) $row->evidence_origin, 'at' => self::iso($row->paid_at ?? $row->created_at)],
            'PHYSICAL' => ['id' => (string) $row->id, 'reference' => (string) $row->order_reference, 'kind' => (string) $row->record_kind, 'method' => (string) $row->method,
                'amount_centavos' => (int) $row->amount_centavos, 'remaining_centavos' => (int) $row->remaining_obligation_centavos, 'state' => (string) $row->state,
                'evidence_origin' => $row->record_kind === 'ONLINE_BALANCE_CREDIT' ? 'VERIFIED_ONLINE_PAYMENT' : 'VENDOR_RECORD', 'buyer_acknowledged' => $row->buyer_acknowledged_at !== null, 'at' => self::iso($row->recorded_at)],
            'REMITTANCES' => ['id' => (string) $row->id, 'reference' => (string) $row->order_reference, 'collected_centavos' => (int) $row->collections_centavos, 'refunds_centavos' => (int) $row->refunds_centavos,
                'delivery_centavos' => (int) $row->delivery_centavos, 'vat_centavos' => (int) $row->vat_centavos, 'provider_charge_centavos' => (int) $row->provider_charge_centavos,
                'gross_basis_centavos' => (int) $row->gross_basis_centavos, 'withheld_centavos' => (int) $row->withheld_centavos, 'expected_cash_centavos' => $row->expected_vendor_cash_centavos === null ? null : (int) $row->expected_vendor_cash_centavos,
                'commission_deducted_centavos' => 0, 'threshold_status_before' => $row->threshold_status_before, 'threshold_status_after' => $row->threshold_status_after,
                'g_effective_after_centavos' => $row->g_effective_after_centavos === null ? null : (int) $row->g_effective_after_centavos, 'calculation_state' => (string) $row->calculation_state,
                'deduction_evidence_state' => (string) $row->deduction_evidence_state, 'reconciliation_state' => (string) $row->reconciliation_state, 'scenario' => $row->withholding_scenario,
                'evidence_origin' => 'SIMULATED', 'environment' => (string) $row->environment, 'at' => self::iso($row->created_at)],
            'STATEMENTS' => self::statementView($row),
            'REFUNDS' => ['id' => (string) $row->id, 'reference' => (string) ($row->order_reference ?? ''), 'trigger' => (string) $row->trigger, 'target_type' => (string) $row->target_type,
                'amount_centavos' => (int) $row->amount_centavos, 'state' => (string) $row->state, 'evidence_origin' => $row->evidence_origin, 'at' => self::iso($row->created_at)],
            default => ['id' => (string) $row->id, 'certificate_type' => (string) $row->certificate_type, 'issuer' => (string) $row->issuer, 'period_start' => (string) $row->period_start,
                'period_end' => (string) $row->period_end, 'tax_centavos' => (int) $row->tax_centavos, 'verification_state' => (string) $row->verification_state, 'origin' => (string) $row->document_origin],
        };
    }

    public static function statusLabel(string $status): string
    {
        return match ($status) {
            'RELIEF_ACTIVE' => 'Relief active — no withholding',
            'SUBJECT_STANDARD' => 'Subject to withholding — standard',
            'SUBJECT_THRESHOLD_BREACHED' => 'Subject to withholding — threshold crossed',
            'SUBJECT_PRIOR_YEAR' => 'Subject to withholding — prior year above threshold',
            'UNDER_REVIEW' => 'Under review — assessed at the standard rate',
            default => 'No remittance assessed yet this taxable year',
        };
    }

    public static function statusIcon(string $status): string
    {
        return match ($status) {
            'RELIEF_ACTIVE' => 'shield-check', 'SUBJECT_THRESHOLD_BREACHED' => 'alert-octagon', 'SUBJECT_PRIOR_YEAR' => 'history',
            'UNDER_REVIEW' => 'search', 'SUBJECT_STANDARD' => 'percent', default => 'circle-dashed',
        };
    }

    private static function iso(mixed $value): ?string
    {
        return $value === null ? null : CarbonImmutable::parse((string) $value)->toIso8601String();
    }
}
