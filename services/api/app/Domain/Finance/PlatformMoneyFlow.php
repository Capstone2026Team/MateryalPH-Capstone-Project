<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use App\Domain\Analytics\Geo\GeoFactsBuilder;
use App\Support\PortalDateRange;
use Illuminate\Database\Query\Builder;
use Illuminate\Support\Facades\DB;

/**
 * Marketplace money for Admin Platform Finance, read live from the order, payment, cash and refund records. None of
 * it is platform money: Buyer online payments settle to each Vendor's own Xendit sub-account and cash is received by
 * the Vendor; only PLATFORM_FEE_PAYMENT captures reach the platform account (see CommissionService::collections).
 *
 *   gross merchandise value = commercial total of every order once confirmed (NRPC counted once, no Buyer fee)
 *   net merchandise value   = gross − cancelled order value − other confirmed refunds of commercial value
 *   Buyer payments received = verified online payments (Buyer processing fee included) + recorded COD and In-Store cash
 *   refunds to Buyers       = confirmed online refunds + confirmed cash reimbursements
 *
 * Every figure uses its own event date: confirmation, verified payment, cash record, refund confirmation. Late captures
 * are excluded together with their compensation refunds, since they never paid for an order. GMV keeps the Marketplace
 * Analytics definition (GeoFactsBuilder) but is never read from that rebuilt snapshot.
 */
final class PlatformMoneyFlow
{
    /** Figures charted per day or month beside commission activity. */
    public const TREND_FIGURES = ['gmv_centavos', 'buyer_payments_centavos', 'buyer_refunds_centavos'];

    private const CASH_REFUND_DATE = 'COALESCE(m.reimbursed_at, m.updated_at)';

    /**
     * One query per record family with its event-date column, its totals and its chart figures, so the cards and the
     * chart can never use different scopes or dates.
     *
     * @return list<array{query: \Closure(): Builder, column: string, sums: array<string, string>, trend: array<string, string>}>
     */
    public static function sources(): array
    {
        return [
            ['query' => static fn (): Builder => self::confirmedOrders(), 'column' => 'COALESCE(h.confirmed_at, o.accepted_at, o.created_at)',
                'sums' => ['gross_gmv' => 'o.commercial_total_centavos', 'confirmed_orders' => '1',
                    'cancelled_gmv' => "CASE WHEN o.order_state = 'CANCELLED' THEN o.commercial_total_centavos ELSE 0 END",
                    'refunded_gmv' => "CASE WHEN o.order_state = 'CANCELLED' THEN 0 ELSE LEAST(o.commercial_total_centavos, COALESCE(rf.refunded_centavos, 0) + COALESCE(rc.refunded_centavos, 0)) END"],
                'trend' => ['gmv_centavos' => 'o.commercial_total_centavos']],
            ['query' => static fn (): Builder => self::onlinePayments(), 'column' => 'p.paid_at',
                'sums' => ['online_payments' => 'p.total_centavos', 'buyer_processing_fees' => 'p.processing_fee_centavos', 'online_payment_count' => '1'],
                'trend' => ['buyer_payments_centavos' => 'p.total_centavos']],
            ['query' => static fn (): Builder => self::cashCollections(), 'column' => 'c.recorded_at',
                'sums' => ['in_store' => "CASE WHEN c.method = 'IN_STORE' THEN c.amount_centavos ELSE 0 END",
                    'cash_on_delivery' => "CASE WHEN c.method = 'IN_STORE' THEN 0 ELSE c.amount_centavos END", 'cash_record_count' => '1'],
                'trend' => ['buyer_payments_centavos' => 'c.amount_centavos']],
            ['query' => static fn (): Builder => self::onlineRefunds()->where('f.state', 'REFUNDED'), 'column' => 'f.completed_at',
                'sums' => ['cancellation_refunds' => "CASE WHEN f.trigger = 'CANCELLATION' THEN f.amount_centavos ELSE 0 END",
                    'dispute_refunds' => "CASE WHEN f.trigger = 'DISPUTE_CONCLUSION' THEN f.amount_centavos ELSE 0 END",
                    'other_refunds' => "CASE WHEN f.trigger IN ('CANCELLATION', 'DISPUTE_CONCLUSION') THEN 0 ELSE f.amount_centavos END"],
                'trend' => ['buyer_refunds_centavos' => 'f.amount_centavos']],
            ['query' => static fn (): Builder => DB::table('physical_reimbursements as m')->where('m.state', 'REIMBURSEMENT_CONFIRMED'), 'column' => self::CASH_REFUND_DATE,
                'sums' => ['cash_reimbursements' => 'm.amount_centavos'], 'trend' => ['buyer_refunds_centavos' => 'm.amount_centavos']],
        ];
    }

    /**
     * @param  array<string, mixed>  $filters
     * @return array<string, int>
     */
    public static function totals(array $filters): array
    {
        $totals = [];
        foreach (self::sources() as $source) {
            $totals += VendorFinanceService::sums(PortalDateRange::apply($source['query'](), DB::raw($source['column']), $filters), $source['sums']);
        }
        // Current obligations, not money moved: refunds still waiting for the provider or for the Vendor's cash.
        $pending = VendorFinanceService::sums(PortalDateRange::apply(self::onlineRefunds()->whereIn('f.state', ['REFUND_PENDING', 'REFUND_FAILED']), DB::raw('COALESCE(f.requested_at, f.created_at)'), $filters),
            ['pending_online_refunds' => 'f.amount_centavos', 'pending_online_refund_count' => '1']);
        $pendingCash = VendorFinanceService::sums(PortalDateRange::apply(DB::table('physical_reimbursements as m')->where('m.state', 'VENDOR_REIMBURSEMENT_PENDING'), 'm.created_at', $filters),
            ['pending_cash_reimbursements' => 'm.amount_centavos', 'pending_cash_reimbursement_count' => '1']);

        return $totals + $pending + $pendingCash;
    }

    /**
     * Buyer payments received per method over the same records and dates as the totals: each online channel by its
     * verified captures, then Cash on Delivery and In-Store cash. Largest first; methods without activity are left out.
     *
     * @param  array<string, mixed>  $filters
     * @return list<array{method: string, label: string, kind: string, payments: int, amount_centavos: int}>
     */
    public static function paymentMethods(array $filters): array
    {
        $names = DB::table('payment_channel_fee_versions')->orderBy('version')->pluck('display_name', 'channel_code');
        $online = PortalDateRange::apply(self::onlinePayments(), 'p.paid_at', $filters)->groupBy('p.channel_code')
            ->selectRaw('p.channel_code AS method, COUNT(*) AS payments, COALESCE(SUM(p.total_centavos), 0) AS amount')->get()
            ->map(static fn (object $row): array => ['method' => (string) ($row->method ?? 'UNSPECIFIED'), 'label' => (string) ($names[$row->method] ?? 'Other online channel'), 'kind' => 'ONLINE',
                'payments' => (int) $row->payments, 'amount_centavos' => (int) $row->amount]);
        $cash = PortalDateRange::apply(self::cashCollections(), 'c.recorded_at', $filters)->groupByRaw("CASE WHEN c.method = 'IN_STORE' THEN 'IN_STORE' ELSE 'CASH_ON_DELIVERY' END")
            ->selectRaw("CASE WHEN c.method = 'IN_STORE' THEN 'IN_STORE' ELSE 'CASH_ON_DELIVERY' END AS method, COUNT(*) AS payments, COALESCE(SUM(c.amount_centavos), 0) AS amount")->get()
            ->map(static fn (object $row): array => ['method' => (string) $row->method, 'label' => $row->method === 'IN_STORE' ? 'In-Store Payment' : 'Cash on Delivery', 'kind' => 'PHYSICAL',
                'payments' => (int) $row->payments, 'amount_centavos' => (int) $row->amount]);

        return $online->concat($cash)->filter(static fn (array $row): bool => $row['amount_centavos'] > 0)
            ->sortBy([['amount_centavos', 'desc'], ['label', 'asc']])->values()->all();
    }

    /**
     * First and last Asia/Manila day with marketplace activity inside the filters.
     *
     * @param  array<string, mixed>  $filters
     * @return array{0: ?string, 1: ?string}
     */
    public static function bounds(array $filters): array
    {
        $first = null;
        $last = null;
        foreach (self::sources() as $source) {
            $local = "(({$source['column']}) AT TIME ZONE 'Asia/Manila')::date";
            $row = PortalDateRange::apply($source['query'](), DB::raw($source['column']), $filters)->whereNotNull(DB::raw($source['column']))
                ->selectRaw("MIN({$local}) AS first_day, MAX({$local}) AS last_day")->first();
            if ($row?->first_day !== null) {
                $first = $first === null || (string) $row->first_day < $first ? (string) $row->first_day : $first;
                $last = $last === null || (string) $row->last_day > $last ? (string) $row->last_day : $last;
            }
        }

        return [$first, $last];
    }

    /**
     * @param  array<string, mixed>  $filters
     * @return array<string, array<string, int>> bucket start date => trend figure => centavos
     */
    public static function trendBuckets(array $filters, string $granularity): array
    {
        $buckets = [];
        foreach (self::sources() as $source) {
            foreach (VendorFinanceService::bucketSums(PortalDateRange::apply($source['query'](), DB::raw($source['column']), $filters), $source['column'], $source['trend'], $granularity) as $bucket => $sums) {
                foreach ($sums as $figure => $value) {
                    $buckets[$bucket][$figure] = ($buckets[$bucket][$figure] ?? 0) + $value;
                }
            }
        }

        return $buckets;
    }

    /** Orders that reached CONFIRMED, with their non-cancellation online refunds and dispute cash reimbursements. */
    private static function confirmedOrders(): Builder
    {
        $confirmed = DB::table('order_status_history')->where('state_family', 'ORDER')->where('to_state', 'CONFIRMED')->groupBy('order_id')->selectRaw('order_id, MIN(created_at) AS confirmed_at');
        $refunds = DB::table('refunds')->where('target_type', 'ORDER')->where('state', 'REFUNDED')->where('trigger', '<>', 'CANCELLATION')->whereNotNull('order_id')
            ->groupBy('order_id')->selectRaw('order_id, SUM(COALESCE(principal_centavos, amount_centavos)) AS refunded_centavos');
        $cash = DB::table('physical_reimbursements')->where('state', 'REIMBURSEMENT_CONFIRMED')->whereNotNull('dispute_decision_id')
            ->groupBy('order_id')->selectRaw('order_id, SUM(amount_centavos) AS refunded_centavos');

        return DB::table('orders as o')->leftJoinSub($confirmed, 'h', 'h.order_id', '=', 'o.id')->leftJoinSub($refunds, 'rf', 'rf.order_id', '=', 'o.id')->leftJoinSub($cash, 'rc', 'rc.order_id', '=', 'o.id')
            ->where(fn (Builder $q) => $q->whereNotNull('h.confirmed_at')->orWhereIn('o.order_state', GeoFactsBuilder::POST_CONFIRMATION));
    }

    /** Verified Buyer captures for orders (full, NRPC assurance and balance payments), never platform fee payments. */
    private static function onlinePayments(): Builder
    {
        return DB::table('payments as p')->where('p.purpose', '<>', 'PLATFORM_FEE_PAYMENT')->where('p.state', 'PAID')->where('p.late_capture', false);
    }

    private static function cashCollections(): Builder
    {
        return DB::table('physical_payment_records as c')->where('c.record_kind', 'COLLECTION');
    }

    /** Refund instructions against those captures; commission refunds (PLATFORM_FEE) and late-capture compensation are excluded. */
    private static function onlineRefunds(): Builder
    {
        return DB::table('refunds as f')->join('payments as p', 'p.id', '=', 'f.source_payment_id')->where('f.target_type', 'ORDER')
            ->where('p.purpose', '<>', 'PLATFORM_FEE_PAYMENT')->where('p.late_capture', false);
    }
}
