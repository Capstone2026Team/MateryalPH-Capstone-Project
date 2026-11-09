<?php

declare(strict_types=1);

namespace App\Domain\Reviews;

use App\Domain\Scores\ScoreRules;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;

/** One CCS query for the Buyer's Profile and authorized Admin directories. */
final class BuyerRatingSummary
{
    /**
     * @param  list<string>  $profileIds
     * @return array<string, array<string, mixed>>
     */
    public function forProfiles(array $profileIds): array
    {
        if ($profileIds === []) {
            return [];
        }
        $end = CarbonImmutable::now();
        $totals = ReviewRules::constrainVisible(DB::table('reviews as r')->join('orders as o', 'o.id', '=', 'r.order_id')
            ->whereIn('r.buyer_profile_id', $profileIds)->where('r.review_type', ReviewRules::BUYER)->where('o.order_state', 'COMPLETED'))
            ->whereBetween('r.submitted_at', [$end->subDays(ScoreRules::RATING_WINDOW_DAYS), $end])
            ->groupBy('r.buyer_profile_id')->selectRaw('r.buyer_profile_id, count(*) AS total, sum(r.inquiry_seriousness) AS inquiry, sum(r.communication_quality) AS communication, sum(r.payment_reliability) AS payment')
            ->get()->keyBy('buyer_profile_id');
        $result = [];
        foreach ($profileIds as $profileId) {
            $row = $totals[$profileId] ?? null;
            $count = (int) ($row->total ?? 0);
            $published = $count >= ScoreRules::MIN_BUYER_RATINGS;
            $average = static fn (int $sum, int $divisor): ?float => $published ? (float) ScoreRules::round(ScoreRules::average($sum, $divisor) ?? '0') : null;
            $result[$profileId] = [
                'score' => $average((int) ($row->inquiry ?? 0) + (int) ($row->communication ?? 0) + (int) ($row->payment ?? 0), $count * 3),
                'count' => $count, 'minimum_count' => ScoreRules::MIN_BUYER_RATINGS, 'window_days' => ScoreRules::RATING_WINDOW_DAYS,
                'inquiry_seriousness' => $average((int) ($row->inquiry ?? 0), $count),
                'communication_quality' => $average((int) ($row->communication ?? 0), $count),
                'payment_reliability' => $average((int) ($row->payment ?? 0), $count),
            ];
        }

        return $result;
    }
}
