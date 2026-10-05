<?php

declare(strict_types=1);

namespace App\Domain\Scores;

use App\Domain\Reviews\ReviewRules;
use Carbon\CarbonImmutable;
use Illuminate\Database\Query\Builder;
use Illuminate\Support\Facades\DB;

/**
 * Computes one Vendor's score components for a window ending at an exact instant (exclusive). Inputs are only
 * visible verified-purchase reviews and metric events of orders that are not Admin-excluded, so cancelled-only,
 * fraudulent, duplicate and test activity cannot move a score. Product ratings (MQS) and Vendor ratings (VCS) stay
 * separate inputs. Store hours are not an input to any component.
 */
final class ScoreCalculator
{
    /** @return array<string, mixed> */
    public function ratings(string $organizationId, CarbonImmutable $end): array
    {
        $start = $end->subDays(ScoreRules::RATING_WINDOW_DAYS);
        $vendor = $this->reviews($organizationId, ReviewRules::VENDOR, $start, $end)
            ->selectRaw('count(*) AS total, coalesce(sum(r.service_quality), 0) AS service, coalesce(sum(r.speed_rating), 0) AS speed')->first();
        $product = $this->reviews($organizationId, ReviewRules::PRODUCT, $start, $end)->selectRaw('count(*) AS total, coalesce(sum(r.rating), 0) AS quality')->first();
        $vendorCount = (int) $vendor->total;
        $productCount = (int) $product->total;
        $mqs = ScoreRules::average((int) $product->quality, $productCount);
        $mqsEligible = $productCount >= ScoreRules::MIN_PRODUCT_RATINGS;
        $service = ScoreRules::average((int) $vendor->service, $vendorCount);
        $speed = ScoreRules::average((int) $vendor->speed, $vendorCount);
        $vcsEligible = $vendorCount >= ScoreRules::MIN_VENDOR_RATINGS && $mqsEligible;

        return [
            'vendor_ratings' => $vendorCount, 'product_ratings' => $productCount,
            'service_quality' => $service, 'speed' => $speed,
            'mqs' => $mqsEligible && $mqs !== null ? ScoreRules::round(ScoreRules::clamp($mqs, 8)) : null,
            'mqs_raw' => $mqs,
            'vcs' => $vcsEligible && $service !== null && $speed !== null && $mqs !== null ? ScoreRules::round(ScoreRules::vcs($service, $speed, $mqs)) : null,
            'vcs_raw' => $service !== null && $speed !== null && $mqs !== null ? ScoreRules::vcs($service, $speed, $mqs) : null,
        ];
    }

    /** @return array<string, mixed> */
    public function operations(string $organizationId, CarbonImmutable $end): array
    {
        $start = $end->subDays(ScoreRules::OHS_WINDOW_DAYS);
        $orders = $this->distinctOrders($organizationId, 'ORDER_CONFIRMED', $start, $end);
        $nfr = $this->distinctOrders($organizationId, 'VENDOR_NON_FULFILLMENT', $start, $end);
        $odr = $this->distinctOrders($organizationId, 'ORDER_DEFECT', $start, $end);
        $returns = $this->distinctOrders($organizationId, 'VALIDATED_DEFECT_RETURN', $start, $end);
        $fulfilled = $this->distinctOrders($organizationId, 'ORDER_FULFILLED', $start, $end);
        $dispatch = $this->events($organizationId, 'FULFILLMENT_DISPATCHED', $start, $end)->selectRaw('count(*) AS total, coalesce(sum(e.value), 0) AS late')->first();
        $violations = (clone $this->events($organizationId, 'MISREPRESENTED_LISTING', $end->subDays(ScoreRules::LVD_WINDOW_DAYS), $end))->count();
        $rates = [
            'NFR' => ScoreRules::percent($nfr, $orders),
            'LSR' => ScoreRules::percent((int) $dispatch->late, (int) $dispatch->total),
            'RR' => ScoreRules::percent($returns, $fulfilled),
            'ODR' => ScoreRules::percent($odr, $orders),
        ];
        $penalties = array_map(static fn (string $metric): string => ScoreRules::penalty($metric, $rates[$metric]), array_combine(array_keys($rates), array_keys($rates)));
        $penalties['LVD'] = ScoreRules::lvdPenalty($violations);
        /** @var array{NFR: string, LSR: string, RR: string, ODR: string, LVD: string} $penalties */
        $eligible = $orders >= ScoreRules::MIN_OHS_ORDERS;

        return [
            'eligible_orders' => $orders, 'fulfilled_orders' => $fulfilled, 'dispatched_orders' => (int) $dispatch->total, 'listing_violations' => $violations,
            'numerators' => ['NFR' => $nfr, 'LSR' => (int) $dispatch->late, 'RR' => $returns, 'ODR' => $odr],
            'rates' => $rates, 'penalties' => $penalties,
            'ohs' => $eligible ? ScoreRules::ohs($penalties) : null,
        ];
    }

    /** @return array<string, mixed> */
    public function badgeMetrics(string $organizationId, CarbonImmutable $end): array
    {
        $inquiries = $this->events($organizationId, 'INQUIRY', $end->subDays(ScoreRules::CRR_WINDOW_DAYS), $end)->selectRaw('count(*) AS total, coalesce(sum(e.value), 0) AS answered')->first();
        $fulfilled = $this->events($organizationId, 'ORDER_FULFILLED', $end->subDays(ScoreRules::FRR_WINDOW_DAYS), $end)->selectRaw('count(*) AS total, coalesce(sum(e.value), 0) AS on_time')->first();
        $completed90 = $this->distinctOrders($organizationId, 'ORDER_COMPLETED', $end->subDays(90), $end);
        $completedAll = (int) $this->events($organizationId, 'ORDER_COMPLETED', CarbonImmutable::create(2000), $end)->distinct()->count('e.order_id');

        return [
            'inquiries' => (int) $inquiries->total, 'inquiries_answered' => (int) $inquiries->answered,
            'crr' => (int) $inquiries->total > 0 ? ScoreRules::percent((int) $inquiries->answered, (int) $inquiries->total) : null,
            'fulfilled_orders' => (int) $fulfilled->total, 'on_time_orders' => (int) $fulfilled->on_time,
            'frr' => (int) $fulfilled->total > 0 ? ScoreRules::percent((int) $fulfilled->on_time, (int) $fulfilled->total) : null,
            'completed_orders_90_days' => $completed90, 'completed_orders_total' => $completedAll,
        ];
    }

    private function reviews(string $organizationId, string $type, CarbonImmutable $start, CarbonImmutable $end): Builder
    {
        return ReviewRules::constrainVisible(DB::table('reviews as r')->where('r.vendor_organization_id', $organizationId)->where('r.review_type', $type)
            ->where('r.submitted_at', '>=', $start)->where('r.submitted_at', '<', $end));
    }

    private function events(string $organizationId, string $metric, CarbonImmutable $start, CarbonImmutable $end): Builder
    {
        return DB::table('metric_events as e')->where('e.vendor_organization_id', $organizationId)->where('e.metric', $metric)->where('e.occurred_at', '>=', $start)->where('e.occurred_at', '<', $end)
            ->where(fn (Builder $q) => $q->whereNull('e.order_id')->orWhereNotExists(fn (Builder $x) => $x->selectRaw('1')->from('score_exclusions as x')->whereColumn('x.order_id', 'e.order_id')->whereNull('x.revoked_at')));
    }

    private function distinctOrders(string $organizationId, string $metric, CarbonImmutable $start, CarbonImmutable $end): int
    {
        return (int) $this->events($organizationId, $metric, $start, $end)->whereNotNull('e.order_id')->distinct()->count('e.order_id');
    }
}
