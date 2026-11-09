<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use Illuminate\Database\Query\Builder;
use Illuminate\Support\Facades\DB;

/** One sales scope for Vendor and Admin reports. Cash flows retain their own event dates. */
final class SalesReporting
{
    public const LISTING_ID = 'COALESCE(ol.vendor_listing_id, lv.vendor_listing_id)';

    public const POST_CONFIRMATION = ['CONFIRMED', 'PROCESSING', 'READY_FOR_PICKUP', 'OUT_FOR_DELIVERY', 'DELIVERED', 'PICKED_UP', 'COMPLETED', 'DISPUTED', 'CANCELLATION_REQUESTED'];

    public const CONFIRMED_AT = 'COALESCE(h.confirmed_at, o.accepted_at, o.created_at)';

    public const REFUNDS = 'LEAST(o.commercial_total_centavos, COALESCE(rf.refunded_centavos, 0) + COALESCE(rc.refunded_centavos, 0))';

    public const NET = "CASE WHEN o.order_state = 'CANCELLED' THEN 0 ELSE o.commercial_total_centavos - ".self::REFUNDS.' END';

    /** First confirmation, successful principal refunds and confirmed cash reimbursements, each joined once. */
    public static function orders(): Builder
    {
        $confirmed = DB::table('order_status_history')->where('state_family', 'ORDER')->where('to_state', 'CONFIRMED')
            ->groupBy('order_id')->selectRaw('order_id, MIN(created_at) AS confirmed_at');
        $refunds = DB::table('refunds as r')->join('payments as p', 'p.id', '=', 'r.source_payment_id')
            ->where('r.target_type', 'ORDER')->where('r.state', 'REFUNDED')->where('p.late_capture', false)
            ->where('p.purpose', '<>', 'PLATFORM_FEE_PAYMENT')->groupBy('r.order_id')
            ->selectRaw('r.order_id, SUM(COALESCE(r.principal_centavos, GREATEST(0, r.amount_centavos - r.processing_fee_centavos))) AS refunded_centavos');
        $cash = DB::table('physical_reimbursements')->where('state', 'REIMBURSEMENT_CONFIRMED')
            ->groupBy('order_id')->selectRaw('order_id, SUM(amount_centavos) AS refunded_centavos');

        return DB::table('orders as o')->leftJoinSub($confirmed, 'h', 'h.order_id', '=', 'o.id')
            ->leftJoinSub($refunds, 'rf', 'rf.order_id', '=', 'o.id')->leftJoinSub($cash, 'rc', 'rc.order_id', '=', 'o.id')
            ->where(fn (Builder $q) => $q->whereNotNull('h.confirmed_at')->orWhereIn('o.order_state', self::POST_CONFIRMATION));
    }

    /** The surviving sales and frozen components used by every Vendor product report. */
    public static function sales(string $organizationId): Builder
    {
        return self::orders()->join('financial_snapshots as s', 's.order_id', '=', 'o.id')
            ->joinSub(DB::table('financial_snapshots')->selectRaw('order_id, max(version) as version')->groupBy('order_id'), 'latest', fn ($join) => $join->on('latest.order_id', '=', 's.order_id')->on('latest.version', '=', 's.version'))
            ->where('o.vendor_organization_id', $organizationId)->whereRaw('('.self::NET.') > 0');
    }

    /** Material values after discounts, VAT included, before partial refunds. Delivery is separate. */
    public static function productLines(string $organizationId): Builder
    {
        return self::sales($organizationId)->join('financial_snapshot_lines as fl', 'fl.financial_snapshot_id', '=', 's.id')
            ->join('order_lines as ol', 'ol.id', '=', 'fl.order_line_id')->leftJoin('listing_variants as lv', 'lv.id', '=', 'ol.listing_variant_id')
            ->leftJoin('vendor_listings as vl', 'vl.id', '=', DB::raw(self::LISTING_ID))
            ->leftJoin('material_categories as c', 'c.id', '=', 'vl.material_category_id');
    }
}
