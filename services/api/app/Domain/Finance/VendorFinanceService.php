<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Payments\PaymentChannelCatalog;
use App\Domain\Payments\PaymentGateway;
use App\Domain\Payments\PaymentMethodPolicy;
use App\Domain\Payments\PaymentPresenter;
use App\Domain\Payments\RefundService;
use App\Support\PortalDateRange;
use Carbon\CarbonImmutable;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Symfony\Component\HttpFoundation\StreamedResponse;

/**
 * Vendor Owner finance surface: separate Xendit connection, Vendor Tax Profile summary, withholding arrangement,
 * FIN-04A threshold panel, Commission Terms, online channels, physical payments and refund capability sections,
 * plus the read-only Transaction History tabs, statements and Earnings (FIN-11). No wallet, stored balance or
 * escrow exists: figures are records and DEMO projections, never a balance MateryalPH holds. Every simulated
 * figure carries a DEMO label. No provider ID or private document is ever returned, and the full TIN leaves only
 * through the audited Owner-only revealTin().
 */
final class VendorFinanceService
{
    public const TABS = ['PAYMENTS', 'PHYSICAL', 'REMITTANCES', 'STATEMENTS', 'REFUNDS', 'TAX_DOCUMENTS'];

    /** Payments status filter; each value matches exactly the badge the Payments row shows. */
    public const PAYMENT_STATUSES = ['PAID', 'PAID_PARTIALLY_REFUNDED', 'PAID_REFUND_PENDING', 'PAID_REFUNDED', 'PAID_REFUND_FAILED', 'PENDING', 'FAILED', 'EXPIRED', 'LATE_CAPTURE'];

    public const PER_PAGE = 20;

    /** Earnings figures charted over time; each is bucketed by the same date column its total is filtered on. */
    public const TREND_FIGURES = ['commercial_sales_centavos', 'online_collections_centavos', 'online_refunds_centavos', 'buyer_processing_fees_centavos', 'physical_collections_centavos',
        'provider_charges_centavos', 'simulated_cwt_centavos', 'estimated_remittance_cash_centavos', 'earned_commission_centavos'];

    /** Earnings periods longer than this are charted by calendar month instead of by day. */
    public const TREND_DAILY_MAX_DAYS = 92;

    /** Order states that are not a sale: never accepted, or ended without a sale. */
    private const UNCONFIRMED_OR_CLOSED_UNSOLD = ['DECLINED', 'EXPIRED', 'CANCELLED', 'AWAITING_VENDOR_CONFIRMATION', 'AWAITING_BUYER_APPROVAL', 'AWAITING_NRPC_ACCEPTANCE'];

    /** Products listed on Earnings, largest sales value first. */
    private const EARNINGS_PRODUCT_LIMIT = 50;

    private const TIMEZONE = 'Asia/Manila';

    /** SQL prefix of a remittance figure that is zero once its whole payment was confirmed refunded (see earningsSources). */
    private const KEPT_UNLESS_FULLY_REFUNDED = 'CASE WHEN pay.id IS NULL OR COALESCE(r.refunded_centavos, 0) < pay.total_centavos THEN ';

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
     * Owner-only, on-demand reveal of the store's own full TIN and branch code. Every other response carries only
     * the masked value; each reveal is audited without recording the number, and the caller must not cache it.
     *
     * @return array{tin: string}
     */
    public function revealTin(Request $request): array
    {
        $scope = $this->access->owner($request);
        $encrypted = DB::table('vendor_tax_profiles as p')->join('vendor_tax_profile_versions as v', 'v.id', '=', 'p.current_version_id')
            ->where('p.vendor_organization_id', $scope['organization_id'])->value('v.tin_encrypted');
        if (! is_string($encrypted) || $encrypted === '') {
            throw new AuthenticationException('TIN_NOT_RECORDED', 'No TIN is recorded for this store yet.', 404);
        }
        $digits = Crypt::decryptString($encrypted);
        $this->audit->account($request, 'VENDOR_TIN_REVEALED', 'VENDOR_ORGANIZATION', $scope['organization_id'], after: ['digits' => strlen($digits)]);

        return ['tin' => preg_match('/^[0-9]{12,14}$/D', $digits) === 1 ? substr($digits, 0, 3).'-'.substr($digits, 3, 3).'-'.substr($digits, 6, 3).'-'.substr($digits, 9) : $digits];
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
            'calculation_breakdown' => $this->thresholdCalculation($accumulator),
            'final_for_year_notice' => 'Crossing ₱500,000.00 is final for the taxable year: withholding then applies to the whole crossing remittance and every later remittance, and a refund or a newly uploaded declaration does not restore relief until the next taxable year.',
            'events' => $accumulator === null ? [] : DB::table('vendor_withholding_status_events')->where('accumulator_id', $accumulator->id)->orderByDesc('occurred_at')->limit(10)->get()
                ->map(static fn (object $event): array => ['from_status' => $event->from_status, 'to_status' => (string) $event->to_status, 'reason_code' => (string) $event->reason_code,
                    'g_before_centavos' => (int) $event->g_before_centavos, 'g_after_centavos' => (int) $event->g_after_centavos, 'actor_type' => (string) $event->actor_type, 'occurred_at' => self::iso($event->occurred_at)])->all(),
        ];
    }

    /**
     * Explain the stored taxpayer-year counter using its posted assessments, including other stores belonging
     * to that taxpayer. Voided assessments never contribute; post-assessment refunds must not rewrite this basis.
     * Historical counters without matching assessment components have no reconstructable breakdown.
     *
     * @return array<string, int>|null
     */
    private function thresholdCalculation(?object $accumulator): ?array
    {
        if ($accumulator === null) {
            return null;
        }
        $components = self::sums(DB::table('remittance_assessments')->where('accumulator_id', $accumulator->id)
            ->where('environment', 'TEST')->where('obligation_type', RemittanceAssessmentService::OBLIGATION)->where('calculation_state', 'POSTED'), [
                'collections_centavos' => 'collections_centavos', 'refunds_centavos' => 'refunds_centavos',
                'delivery_centavos' => 'delivery_centavos', 'material_vat_centavos' => 'vat_centavos',
                'provider_charges_centavos' => 'provider_charge_centavos', 'gross_basis_centavos' => 'gross_basis_centavos',
                'withheld_centavos' => 'withheld_centavos', 'assessed_cash_centavos' => 'expected_vendor_cash_centavos',
            ]);
        $gross = $components['collections_centavos'] - $components['refunds_centavos'] - $components['delivery_centavos'] - $components['material_vat_centavos'] - $components['provider_charges_centavos'];
        $cash = $components['collections_centavos'] - $components['refunds_centavos'] - $components['provider_charges_centavos'] - $components['withheld_centavos'];

        return $gross === (int) $accumulator->g_accumulated_centavos && $gross === $components['gross_basis_centavos'] && $cash === $components['assessed_cash_centavos']
            ? $components : null;
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
        $query = $this->tabQuery($organizationId, $tab, $filters);
        $total = (clone $query)->count();
        $rows = $query->offset(($page - 1) * self::PER_PAGE)->limit(self::PER_PAGE)->get();

        return ['items' => $rows->map(fn (object $row): array => $this->row($tab, $row))->all(),
            'meta' => ['tab' => $tab, 'page' => $page, 'per_page' => self::PER_PAGE, 'total' => $total, 'has_more' => $page * self::PER_PAGE < $total, 'environment' => 'TEST', 'demo' => true]];
    }

    /**
     * @param  array<string, mixed>  $filters
     *                                         Owner-only CSV export of one tab; every download is audited and carries the internal-report notice.
     */
    public function export(Request $request, string $tab, array $filters = []): StreamedResponse
    {
        $scope = $this->access->owner($request);
        if (! in_array($tab, self::TABS, true)) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Choose a Transaction History tab to export.', 422);
        }
        $rows = $this->tabQuery($scope['organization_id'], $tab, $filters)->limit(5000)->get()->map(fn (object $row): array => $this->row($tab, $row))->all();
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

    /**
     * @param  array<string, mixed>  $filters
     * @return array<string, mixed> FIN-11 Owner Earnings: separate figures, never a balance.
     */
    public function earnings(Request $request, array $filters = []): array
    {
        $organizationId = $this->access->owner($request)['organization_id'];
        $sources = $this->earningsSources($organizationId);
        $totals = [];
        foreach ($sources as $source) {
            $totals += self::sums(PortalDateRange::apply($source['query'](), DB::raw($source['column']), $filters), $source['sums']);
        }
        $statements = PortalDateRange::apply(DB::table('fee_statements')->where('vendor_organization_id', $organizationId)->whereIn('state', ['ISSUED', 'PARTIALLY_PAID']), 'issued_on', $filters, true);

        return [
            'demo' => true, 'environment' => 'TEST', 'notice' => 'Internal Operational Report — Not a Tax Invoice. Cash receipts do not equal taxable income; this does not replace your books or BIR returns.',
            'commercial_sales_centavos' => $totals['commercial_sales_centavos'], 'included_vat_centavos' => $totals['included_vat_centavos'],
            'online_collections_centavos' => $totals['online_collections_centavos'], 'buyer_processing_fees_centavos' => $totals['buyer_processing_fees_centavos'],
            'online_refunds_centavos' => $totals['online_refunds_centavos'],
            'physical_collections_centavos' => $totals['physical_collections_centavos'],
            'breakdown' => [
                'sales' => ['orders' => $totals['sales_order_count'], 'materials_before_discount_centavos' => $totals['sales_materials_gross_centavos'], 'vendor_discounts_centavos' => $totals['sales_vendor_discount_centavos'],
                    'materials_after_discount_centavos' => $totals['sales_materials_gross_centavos'] - $totals['sales_vendor_discount_centavos'], 'delivery_centavos' => $totals['sales_delivery_centavos']],
                'online' => ['payments' => $totals['online_payment_count'], 'principal_paid_centavos' => $totals['online_principal_paid_centavos'],
                    'refunded_principal_centavos' => $totals['online_principal_paid_centavos'] - $totals['online_collections_centavos']],
                'physical' => ['records' => $totals['physical_record_count'], 'cash_on_delivery_centavos' => $totals['physical_cod_centavos'], 'in_store_centavos' => $totals['physical_in_store_centavos']],
            ],
            'products' => $this->earningsProducts($organizationId, $filters),
            'provider_charges_centavos' => $totals['provider_charges_centavos'], 'simulated_cwt_centavos' => $totals['simulated_cwt_centavos'],
            'estimated_remittance_cash_centavos' => $totals['estimated_remittance_cash_centavos'],
            'remittance_collections_centavos' => $totals['remittance_collections_centavos'], 'remittance_refunds_centavos' => $totals['remittance_refunds_centavos'],
            'earned_commission_centavos' => $totals['earned_commission_centavos'], 'estimated_commission_centavos' => $totals['estimated_commission_centavos'],
            'unpaid_statements_centavos' => (int) $statements->sum('outstanding_centavos'),
            'trend' => $this->earningsTrend($organizationId, $sources, $filters),
        ];
    }

    /**
     * Every Earnings figure as one query, its date column and the sums it yields, so the totals, the chart buckets and
     * the previous-period comparison can never use different scopes or dates.
     *
     * @return list<array{query: \Closure(): Builder, column: string, sums: array<string, string>}>
     */
    private function earningsSources(string $organizationId): array
    {
        $orderIds = static fn (): Builder => DB::table('orders')->where('vendor_organization_id', $organizationId)->whereNotIn('order_state', self::UNCONFIRMED_OR_CLOSED_UNSOLD)->select('id');

        return [
            // The breakdown figures (materials, discounts, delivery, order count) share this scope, so they always add up to commercial sales.
            ['query' => fn (): Builder => $this->commercialSales($organizationId),
                'column' => 'o.accepted_at', 'sums' => ['commercial_sales_centavos' => 's.buyer_total_centavos', 'included_vat_centavos' => 's.materials_vat_centavos',
                    'sales_materials_gross_centavos' => 's.materials_gross_centavos', 'sales_vendor_discount_centavos' => 's.vendor_discount_centavos',
                    'sales_delivery_centavos' => 's.delivery_centavos', 'sales_order_count' => '1']],
            ['query' => fn (): Builder => DB::table('payments as p')->leftJoinSub($this->paymentRefunds($organizationId), 'r', 'r.source_payment_id', '=', 'p.id')
                ->where('p.vendor_organization_id', $organizationId)->where('p.purpose', '<>', 'PLATFORM_FEE_PAYMENT')->where('p.state', 'PAID')->where('p.late_capture', false),
                'column' => 'p.paid_at', 'sums' => ['online_collections_centavos' => 'GREATEST(0, p.principal_centavos - COALESCE(r.principal_refunded_centavos, 0))',
                    'online_refunds_centavos' => 'LEAST(p.total_centavos, COALESCE(r.refunded_centavos, 0))',
                    'buyer_processing_fees_centavos' => 'GREATEST(0, p.processing_fee_centavos - COALESCE(r.fees_refunded_centavos, 0))',
                    'online_principal_paid_centavos' => 'p.principal_centavos', 'online_payment_count' => '1']],
            ['query' => static fn (): Builder => DB::table('physical_payment_records')->whereIn('order_id', $orderIds())->where('record_kind', 'COLLECTION'),
                'column' => 'recorded_at', 'sums' => ['physical_collections_centavos' => 'amount_centavos',
                    'physical_in_store_centavos' => "CASE WHEN method = 'IN_STORE' THEN amount_centavos ELSE 0 END",
                    'physical_cod_centavos' => "CASE WHEN method = 'IN_STORE' THEN 0 ELSE amount_centavos END", 'physical_record_count' => '1']],
            // Keep fully refunded collections visible on both sides of the breakdown, including VOIDED assessments.
            // Their gross collection and refund cancel out; they still add no provider charge, CWT or net cash.
            ['query' => fn (): Builder => DB::table('remittance_assessments as a')->join('orders as o', 'o.id', '=', 'a.order_id')->leftJoin('payments as pay', 'pay.id', '=', 'a.payment_id')
                ->leftJoinSub($this->paymentRefunds($organizationId), 'r', 'r.source_payment_id', '=', 'a.payment_id')
                ->where('o.vendor_organization_id', $organizationId)->where(fn (Builder $q) => $q->where('a.calculation_state', 'POSTED')
                ->orWhere(fn (Builder $voided) => $voided->where('a.calculation_state', 'VOIDED')->where('pay.state', 'PAID')
                    ->whereRaw('COALESCE(r.refunded_centavos, 0) >= pay.total_centavos'))),
                'column' => 'a.created_at', 'sums' => ['provider_charges_centavos' => self::KEPT_UNLESS_FULLY_REFUNDED.'a.provider_charge_centavos ELSE 0 END',
                    'simulated_cwt_centavos' => self::KEPT_UNLESS_FULLY_REFUNDED.'a.withheld_centavos ELSE 0 END',
                    'remittance_collections_centavos' => 'a.collections_centavos',
                    'remittance_refunds_centavos' => 'LEAST(a.collections_centavos, GREATEST(a.refunds_centavos, COALESCE(r.refunded_centavos, 0)))',
                    'estimated_remittance_cash_centavos' => self::KEPT_UNLESS_FULLY_REFUNDED.'a.expected_vendor_cash_centavos - GREATEST(0, COALESCE(r.refunded_centavos, 0) - a.refunds_centavos) ELSE 0 END']],
            ['query' => static fn (): Builder => CommissionService::movements($organizationId),
                'column' => 'occurred_at', 'sums' => ['earned_commission_centavos' => 'amount_centavos']],
            ['query' => static fn (): Builder => DB::table('fee_assessments')->where('vendor_organization_id', $organizationId)->where('state', 'ESTIMATED'),
                'column' => 'created_at', 'sums' => ['estimated_commission_centavos' => 'earned_target_centavos']],
        ];
    }

    /**
     * Commercial sales scope: the latest financial snapshot of every order the store has accepted, leaving out declined,
     * expired, cancelled and unconfirmed orders and orders whose payment was fully refunded, so refunded money never
     * counts as sold. Product sales value uses the same rule; the Dashboard's Gross sales deliberately does not (it is before refunds).
     */
    private function commercialSales(string $organizationId): Builder
    {
        return DB::table('financial_snapshots as s')
            ->joinSub(DB::table('financial_snapshots')->selectRaw('order_id, max(version) as version')->groupBy('order_id'), 'latest', fn ($join) => $join->on('latest.order_id', '=', 's.order_id')->on('latest.version', '=', 's.version'))
            ->join('orders as o', 'o.id', '=', 's.order_id')->where('o.vendor_organization_id', $organizationId)->whereNotIn('o.order_state', self::UNCONFIRMED_OR_CLOSED_UNSOLD)->where('o.refund_state', '<>', 'REFUNDED');
    }

    /**
     * Sales value per product for the same orders and dates as commercial sales: each product's share of the latest
     * snapshot's line amounts (after vendor discount, VAT included). Delivery belongs to no product, so the products
     * plus delivery equal commercial sales. Largest first; a bounded list, never the whole catalog.
     *
     * @param  array<string, mixed>  $filters
     * @return array{items: list<array<string, mixed>>, total: int, truncated: bool}
     */
    private function earningsProducts(string $organizationId, array $filters): array
    {
        $listing = 'COALESCE(ol.vendor_listing_id, lv.vendor_listing_id)';
        $query = PortalDateRange::apply($this->commercialSales($organizationId), DB::raw('o.accepted_at'), $filters)
            ->join('financial_snapshot_lines as fl', 'fl.financial_snapshot_id', '=', 's.id')->join('order_lines as ol', 'ol.id', '=', 'fl.order_line_id')
            ->leftJoin('listing_variants as lv', 'lv.id', '=', 'ol.listing_variant_id')->leftJoin('vendor_listings as vl', 'vl.id', '=', DB::raw($listing))
            ->leftJoin('material_categories as c', 'c.id', '=', 'vl.material_category_id')->groupByRaw($listing);
        $total = (int) DB::query()->fromSub((clone $query)->selectRaw($listing.' AS listing_id'), 'products')->count();
        $rows = $query->selectRaw($listing.' AS listing_id, MAX(vl.display_name) AS name, MAX(c.name) AS category, MAX(vl.vendor_sku) AS sku, COUNT(DISTINCT o.id) AS orders,
            COALESCE(SUM(fl.ordinary_payable_centavos), 0) AS value_centavos, COALESCE(SUM(fl.vat_centavos), 0) AS vat_centavos')
            ->orderByRaw('COALESCE(SUM(fl.ordinary_payable_centavos), 0) DESC')->orderByRaw('MAX(vl.display_name)')->limit(self::EARNINGS_PRODUCT_LIMIT)->get();

        return ['total' => $total, 'truncated' => $total > self::EARNINGS_PRODUCT_LIMIT,
            'items' => $rows->map(static fn (object $row): array => ['listing_id' => $row->listing_id === null ? null : (string) $row->listing_id, 'name' => $row->name === null ? 'Unlisted material' : (string) $row->name,
                'category' => $row->category === null ? 'Uncategorized' : (string) $row->category, 'sku' => $row->sku === null ? null : (string) $row->sku, 'orders' => (int) $row->orders,
                'value_centavos' => (int) $row->value_centavos, 'vat_centavos' => (int) $row->vat_centavos])->all()];
    }

    /**
     * One aggregate per original payment prevents multiple refund instructions from duplicating a collection.
     * Only confirmed refunds reduce collections; pending and failed instructions remain separate statuses.
     * Older technical-compensation instructions have no split, so recover it from the original payment fee.
     */
    private function paymentRefunds(string $organizationId): Builder
    {
        return RefundService::paymentTotals($organizationId);
    }

    /**
     * The same figures bucketed by Asia/Manila day (by calendar month past 92 days) over the filtered period, which ends
     * today at the latest and starts at the store's first order when no start date is chosen, plus the totals of the
     * equal-length period just before it. Records only; no forecast, ratio or derived income figure.
     *
     * @param  list<array{query: \Closure(): Builder, column: string, sums: array<string, string>}>  $sources
     * @param  array<string, mixed>  $filters
     * @return array<string, mixed>
     */
    private function earningsTrend(string $organizationId, array $sources, array $filters): array
    {
        $today = CarbonImmutable::now(self::TIMEZONE)->startOfDay();
        $end = isset($filters['to']) ? CarbonImmutable::parse((string) $filters['to'], self::TIMEZONE)->startOfDay() : $today;
        $end = $end->greaterThan($today) ? $today : $end;
        $earliest = DB::table('orders')->where('vendor_organization_id', $organizationId)->min('created_at');
        $start = isset($filters['from']) ? CarbonImmutable::parse((string) $filters['from'], self::TIMEZONE)->startOfDay()
            : ($earliest === null ? $end : CarbonImmutable::parse((string) $earliest)->setTimezone(self::TIMEZONE)->startOfDay());
        $start = $start->greaterThan($end) && ! isset($filters['from']) ? $end : $start;
        $days = $start->greaterThan($end) ? 0 : (int) $start->diffInDays($end) + 1;
        $granularity = $days > self::TREND_DAILY_MAX_DAYS ? 'MONTH' : 'DAY';
        $trend = ['granularity' => $granularity, 'timezone' => self::TIMEZONE, 'from' => $start->toDateString(), 'to' => $end->toDateString(), 'days' => $days, 'points' => [], 'previous' => null];
        if ($days === 0) {
            return $trend;
        }

        $window = ['from' => $start->toDateString(), 'to' => $end->toDateString()];
        $byBucket = [];
        foreach ($sources as $source) {
            foreach (self::bucketSums(PortalDateRange::apply($source['query'](), DB::raw($source['column']), $window), $source['column'], $source['sums'], $granularity) as $bucket => $sums) {
                $byBucket[$bucket] = ($byBucket[$bucket] ?? []) + $sums;
            }
        }
        $zero = array_fill_keys(self::TREND_FIGURES, 0);
        $current = $zero;
        $monthly = $granularity === 'MONTH';
        for ($cursor = $monthly ? $start->startOfMonth() : $start; $cursor->lessThanOrEqualTo($end); $cursor = $monthly ? $cursor->addMonth() : $cursor->addDay()) {
            $point = array_intersect_key(($byBucket[$cursor->toDateString()] ?? []) + $zero, $zero);
            foreach (self::TREND_FIGURES as $figure) {
                $current[$figure] += $point[$figure];
            }
            $trend['points'][] = ['date' => $cursor->toDateString()] + $point;
        }

        $previousEnd = $start->subDay();
        $previousStart = $start->subDays($days);
        $previous = [];
        foreach ($sources as $source) {
            $previous += self::sums(PortalDateRange::apply($source['query'](), DB::raw($source['column']), ['from' => $previousStart->toDateString(), 'to' => $previousEnd->toDateString()]), $source['sums']);
        }
        $previous = array_intersect_key($previous, $zero);
        $trend['previous'] = ['from' => $previousStart->toDateString(), 'to' => $previousEnd->toDateString(), 'totals' => $previous,
            'change_percent' => array_combine(self::TREND_FIGURES, array_map(static fn (string $figure): ?float => $previous[$figure] === 0 ? null
                : round(($current[$figure] - $previous[$figure]) / abs($previous[$figure]) * 100, 1), self::TREND_FIGURES))];

        return $trend;
    }

    /**
     * @param  array<string, string>  $sums  figure => SQL expression
     * @return array<string, int>
     */
    private static function sums(Builder $query, array $sums): array
    {
        $row = $query->selectRaw(implode(', ', array_map(static fn (string $figure, string $expression): string => "COALESCE(SUM({$expression}), 0) AS {$figure}", array_keys($sums), $sums)))->first();

        return array_map(static fn (string $figure): int => (int) ($row->{$figure} ?? 0), array_combine(array_keys($sums), array_keys($sums)));
    }

    /**
     * @param  array<string, string>  $sums  figure => SQL expression
     * @return array<string, array<string, int>> bucket start date => figure => centavos
     */
    private static function bucketSums(Builder $query, string $column, array $sums, string $granularity): array
    {
        $local = "(({$column}) AT TIME ZONE '".self::TIMEZONE."')";
        $bucket = $granularity === 'MONTH' ? "date_trunc('month', {$local})::date" : "{$local}::date";
        $select = ["{$bucket} AS bucket", ...array_map(static fn (string $figure, string $expression): string => "COALESCE(SUM({$expression}), 0) AS {$figure}", array_keys($sums), $sums)];
        $out = [];
        foreach ($query->whereNotNull(DB::raw($column))->selectRaw(implode(', ', $select))->groupByRaw($bucket)->get() as $row) {
            $out[(string) $row->bucket] = array_map(static fn (string $figure): int => (int) $row->{$figure}, array_combine(array_keys($sums), array_keys($sums)));
        }

        return $out;
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

    /** @param array<string, mixed> $filters */
    private function tabQuery(string $organizationId, string $tab, array $filters = []): Builder
    {
        $query = match ($tab) {
            'PAYMENTS' => DB::table('payments as p')->leftJoin('orders as o', 'o.id', '=', 'p.order_id')->where('p.vendor_organization_id', $organizationId)->where('p.purpose', '<>', 'PLATFORM_FEE_PAYMENT')
                ->leftJoinSub($this->paymentRefunds($organizationId), 'r', 'r.source_payment_id', '=', 'p.id')
                ->orderByDesc('p.created_at')->select(['p.*', 'o.reference as order_reference', 'r.refunded_centavos', 'r.pending_count', 'r.failed_count']),
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
        [$column, $calendarDate] = match ($tab) {
            'PAYMENTS' => [DB::raw('COALESCE(p.paid_at, p.created_at)'), false],
            'PHYSICAL' => ['r.recorded_at', false],
            'REMITTANCES' => ['a.created_at', false],
            'STATEMENTS' => ['issued_on', true],
            'REFUNDS' => ['f.created_at', false],
            default => ['period_end', true],
        };

        if ($tab === 'PAYMENTS' && isset($filters['status'])) {
            $this->applyPaymentStatus($query, (string) $filters['status']);
        }

        return PortalDateRange::apply($query, $column, $filters, $calendarDate);
    }

    /**
     * Mirrors PaymentPresenter::attempt() and the refund_state derivation in row(), so a filtered list never disagrees
     * with the badge on the row. Refund outcomes are evaluated in the same order: refunded, pending, partial, failed.
     */
    private function applyPaymentStatus(Builder $query, string $status): void
    {
        $refunded = 'COALESCE(r.refunded_centavos, 0)';
        $pending = 'COALESCE(r.pending_count, 0)';
        $failed = 'COALESCE(r.failed_count, 0)';
        $paid = "p.state = 'PAID' AND NOT COALESCE(p.late_capture, false)";
        $condition = match ($status) {
            'PAID' => "$paid AND $refunded < p.total_centavos AND $pending = 0 AND $refunded = 0 AND $failed = 0",
            'PAID_REFUNDED' => "$paid AND $refunded >= p.total_centavos",
            'PAID_REFUND_PENDING' => "$paid AND $refunded < p.total_centavos AND $pending > 0",
            'PAID_PARTIALLY_REFUNDED' => "$paid AND $refunded < p.total_centavos AND $pending = 0 AND $refunded > 0",
            'PAID_REFUND_FAILED' => "$paid AND $refunded < p.total_centavos AND $pending = 0 AND $refunded = 0 AND $failed > 0",
            'LATE_CAPTURE' => "p.state = 'PAID' AND COALESCE(p.late_capture, false)",
            'FAILED' => "p.state = 'FAILED'",
            'EXPIRED' => "p.state IN ('EXPIRED', 'CANCELLED')",
            'PENDING' => "p.state NOT IN ('PAID', 'FAILED', 'EXPIRED', 'CANCELLED')",
            default => throw new AuthenticationException('VALIDATION_FAILED', 'Unknown payment status.', 422),
        };
        $query->whereRaw($condition);
    }

    /** @return array<string, mixed> */
    private function row(string $tab, object $row): array
    {
        return match ($tab) {
            'PAYMENTS' => ['id' => (string) $row->id, 'reference' => (string) ($row->order_reference ?? ''), 'purpose' => (string) $row->purpose, 'status' => $this->presenter->attempt($row, false)['status'],
                'refund_state' => match (true) {
                    (int) ($row->refunded_centavos ?? 0) >= (int) $row->total_centavos => 'REFUNDED',
                    (int) ($row->pending_count ?? 0) > 0 => 'REFUND_PENDING',
                    (int) ($row->refunded_centavos ?? 0) > 0 => 'PARTIALLY_REFUNDED',
                    (int) ($row->failed_count ?? 0) > 0 => 'REFUND_FAILED',
                    default => 'NOT_REQUESTED',
                },
                'refunded_centavos' => min((int) $row->total_centavos, (int) ($row->refunded_centavos ?? 0)),
                'net_collected_centavos' => $row->state === 'PAID' ? max(0, (int) $row->total_centavos - (int) ($row->refunded_centavos ?? 0)) : 0,
                'gross_centavos' => (int) $row->total_centavos, 'principal_centavos' => (int) $row->principal_centavos, 'buyer_processing_fee_centavos' => (int) $row->processing_fee_centavos,
                'channel' => $row->channel_code, 'environment' => (string) $row->environment, 'evidence_origin' => (string) $row->evidence_origin, 'at' => self::iso($row->paid_at ?? $row->created_at)],
            'PHYSICAL' => ['id' => (string) $row->id, 'reference' => (string) $row->order_reference, 'kind' => (string) $row->record_kind, 'method' => (string) $row->method,
                'amount_centavos' => (int) $row->amount_centavos, 'remaining_centavos' => (int) $row->remaining_obligation_centavos, 'state' => (string) $row->state,
                'evidence_origin' => $row->record_kind === 'ONLINE_BALANCE_CREDIT' ? 'VERIFIED_ONLINE_PAYMENT' : 'VENDOR_RECORD', 'buyer_acknowledged' => $row->buyer_acknowledged_at !== null, 'at' => self::iso($row->recorded_at)],
            'REMITTANCES' => ['id' => (string) $row->id, 'reference' => (string) $row->order_reference, 'collected_centavos' => (int) $row->collections_centavos, 'refunds_centavos' => (int) $row->refunds_centavos,
                'delivery_centavos' => (int) $row->delivery_centavos, 'vat_centavos' => (int) $row->vat_centavos, 'provider_charge_centavos' => (int) $row->provider_charge_centavos,
                'gross_basis_centavos' => (int) $row->gross_basis_centavos, 'withheld_centavos' => (int) $row->withheld_centavos, 'expected_cash_centavos' => $row->expected_vendor_cash_centavos === null ? null : (int) $row->expected_vendor_cash_centavos,
                'commission_deducted_centavos' => 0, 'threshold_status_before' => $row->threshold_status_before, 'threshold_status_after' => $row->threshold_status_after,
                'g_effective_after_centavos' => $row->g_effective_after_centavos === null ? null : (int) $row->g_effective_after_centavos, 'calculation_state' => (string) $row->calculation_state,                'deduction_evidence_state' => (string) $row->deduction_evidence_state, 'reconciliation_state' => (string) $row->reconciliation_state, 'scenario' => $row->withholding_scenario,
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
