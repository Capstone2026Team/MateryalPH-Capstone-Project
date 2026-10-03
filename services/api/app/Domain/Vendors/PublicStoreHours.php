<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use Carbon\CarbonImmutable;
use Carbon\CarbonInterface;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;

/**
 * ONB-05 public operating schedule. Reads only the saved S5 schedule (a Vendor's unsaved Store Setup draft
 * lives in vendor_onboarding_drafts and never reaches here) in Asia/Manila, applies the unique dated override
 * for a date before the recurring weekly rule, and treats the exact closing minute as closed. All-Closed is a
 * valid schedule; an incomplete or legacy schedule is reported as UNAVAILABLE instead of inventing hours.
 *
 * The result is informational: it is not a claim of staff presence, stock or response time, and nothing in
 * discovery, ranking, order windows or deadlines reads it.
 */
final class PublicStoreHours
{
    public const TIME_ZONE = 'Asia/Manila';

    public const DAYS_SHOWN = 7;

    private const WEEKDAYS = [1 => 'Monday', 2 => 'Tuesday', 3 => 'Wednesday', 4 => 'Thursday', 5 => 'Friday', 6 => 'Saturday', 7 => 'Sunday'];

    public function __construct(private readonly StoreOperatingSchedule $schedule) {}

    /** @return array<string, mixed> */
    public function describe(string $profileId, ?CarbonInterface $at = null): array
    {
        return $this->describeMany([$profileId], $at)[$profileId];
    }

    /**
     * @param  list<string>  $profileIds
     * @return array<string, array<string, mixed>>
     */
    public function describeMany(array $profileIds, ?CarbonInterface $at = null): array
    {
        $now = CarbonImmutable::instance($at ?? Carbon::now())->setTimezone(self::TIME_ZONE);
        $today = $now->startOfDay();
        $weekly = $this->schedule->weeklyMany($profileIds);
        $overrides = [];
        if ($profileIds !== []) {
            // One extra day beyond the displayed week lets "next opening" look a full seven days ahead.
            foreach (DB::table('store_operation_date_overrides')->whereIn('store_profile_id', $profileIds)
                ->whereBetween('specific_date', [$today->toDateString(), $today->addDays(self::DAYS_SHOWN)->toDateString()])->get() as $override) {
                $overrides[(string) $override->store_profile_id][substr((string) $override->specific_date, 0, 10)] = $override;
            }
        }
        $result = [];
        foreach ($profileIds as $profileId) {
            $schedule = $weekly[$profileId] ?? [];
            if (! $this->schedule->valid($schedule)) {
                $result[$profileId] = $this->unavailable($now);

                continue;
            }
            $days = [];
            for ($offset = 0; $offset <= self::DAYS_SHOWN; $offset++) {
                $date = $today->addDays($offset);
                $days[] = $this->day($date, $schedule, $overrides[$profileId][$date->toDateString()] ?? null);
            }
            $result[$profileId] = [
                'status' => 'AVAILABLE',
                'time_zone' => self::TIME_ZONE,
                'as_of' => $now->toIso8601String(),
                'weekly' => $schedule,
                'week' => array_slice($days, 0, self::DAYS_SHOWN),
                'today' => $days[0],
                'open_now' => $this->openNow($now, $days),
                'all_closed' => collect($schedule)->every(static fn (array $day): bool => $day['status'] === 'CLOSED'),
            ];
        }

        return $result;
    }

    /**
     * @param  list<array{day_of_week: int, status: string, opens_at: ?string, closes_at: ?string}>  $schedule
     * @return array{date: string, day_of_week: int, weekday: string, status: string, opens_at: ?string, closes_at: ?string, source: string}
     */
    private function day(CarbonImmutable $date, array $schedule, ?object $override): array
    {
        $weekday = $date->isoWeekday();
        if ($override !== null) {
            return ['date' => $date->toDateString(), 'day_of_week' => $weekday, 'weekday' => self::WEEKDAYS[$weekday],
                'status' => $override->is_closed ? 'CLOSED' : 'OPEN',
                'opens_at' => $override->is_closed ? null : substr((string) $override->opens_at, 0, 5),
                'closes_at' => $override->is_closed ? null : substr((string) $override->closes_at, 0, 5),
                'source' => 'DATE_OVERRIDE'];
        }
        $rule = collect($schedule)->firstWhere('day_of_week', $weekday);

        return ['date' => $date->toDateString(), 'day_of_week' => $weekday, 'weekday' => self::WEEKDAYS[$weekday],
            'status' => $rule['status'], 'opens_at' => $rule['opens_at'], 'closes_at' => $rule['closes_at'], 'source' => 'WEEKLY'];
    }

    /**
     * Open from the opening minute up to, but not including, the closing minute.
     *
     * @param  list<array<string, mixed>>  $days
     * @return array{status: string, closes_at: ?string, next_opening: ?array{date: string, weekday: string, opens_at: string}, basis: string}
     */
    private function openNow(CarbonImmutable $now, array $days): array
    {
        $clock = $now->format('H:i:s');
        $today = $days[0];
        $open = $today['status'] === 'OPEN' && $clock >= $today['opens_at'].':00' && $clock < $today['closes_at'].':00';
        $next = null;
        if (! $open) {
            foreach ($days as $index => $day) {
                if ($day['status'] === 'OPEN' && ($index > 0 || $clock < $day['opens_at'].':00')) {
                    $next = ['date' => $day['date'], 'weekday' => $day['weekday'], 'opens_at' => (string) $day['opens_at']];

                    break;
                }
            }
        }

        return ['status' => $open ? 'OPEN' : 'CLOSED', 'closes_at' => $open ? $today['closes_at'] : null, 'next_opening' => $next, 'basis' => $today['source'] === 'DATE_OVERRIDE' ? 'DATE_OVERRIDE' : 'SAVED_SCHEDULE'];
    }

    /** @return array<string, mixed> */
    private function unavailable(CarbonImmutable $now): array
    {
        return ['status' => 'UNAVAILABLE', 'time_zone' => self::TIME_ZONE, 'as_of' => $now->toIso8601String(), 'weekly' => [], 'week' => [], 'today' => null,
            'open_now' => ['status' => 'UNAVAILABLE', 'closes_at' => null, 'next_opening' => null, 'basis' => 'SAVED_SCHEDULE'], 'all_closed' => false];
    }
}
