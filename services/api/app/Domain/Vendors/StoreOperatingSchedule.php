<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use InvalidArgumentException;

final class StoreOperatingSchedule
{
    /** @return list<array{day_of_week: int, status: string, opens_at: ?string, closes_at: ?string}> */
    public function weekly(string $profileId): array
    {
        return $this->weeklyMany([$profileId])[$profileId] ?? [];
    }

    /**
     * The saved (never draft) weekly schedules of several profiles in one query.
     *
     * @param  list<string>  $profileIds
     * @return array<string, list<array{day_of_week: int, status: string, opens_at: ?string, closes_at: ?string}>>
     */
    public function weeklyMany(array $profileIds): array
    {
        if ($profileIds === []) {
            return [];
        }
        $schedules = [];
        foreach (DB::table('operating_hours')->whereIn('store_profile_id', $profileIds)->orderBy('store_profile_id')->orderBy('day_of_week')->get() as $row) {
            $schedules[(string) $row->store_profile_id][] = [
                'day_of_week' => (int) $row->day_of_week,
                'status' => $row->is_closed ? 'CLOSED' : 'OPEN',
                'opens_at' => $row->is_closed ? null : substr((string) $row->opens_at, 0, 5),
                'closes_at' => $row->is_closed ? null : substr((string) $row->closes_at, 0, 5),
            ];
        }

        return $schedules;
    }

    /** @param list<array<string, mixed>> $days */
    public function replaceWeekly(string $profileId, array $days): void
    {
        if (! $this->valid($days)) {
            throw new InvalidArgumentException('Every day needs an explicit valid operating state and same-day hours when open.');
        }
        $canonical = collect($days)->map(fn (array $day): array => ['day_of_week' => $day['day_of_week'], 'status' => $day['status'], 'opens_at' => $day['status'] === 'OPEN' ? $day['opens_at'] : null, 'closes_at' => $day['status'] === 'OPEN' ? $day['closes_at'] : null])->sortBy('day_of_week')->values()->all();
        if ($this->weekly($profileId) === $canonical) {
            return;
        }
        foreach ($days as $day) {
            DB::table('operating_hours')->updateOrInsert(
                ['store_profile_id' => $profileId, 'day_of_week' => $day['day_of_week']],
                ['id' => DB::table('operating_hours')->where('store_profile_id', $profileId)->where('day_of_week', $day['day_of_week'])->value('id') ?? (string) Str::uuid7(),
                    'is_closed' => $day['status'] === 'CLOSED',
                    'opens_at' => $day['status'] === 'OPEN' ? $day['opens_at'] : null,
                    'closes_at' => $day['status'] === 'OPEN' ? $day['closes_at'] : null,
                    'updated_at' => now(), 'created_at' => DB::table('operating_hours')->where('store_profile_id', $profileId)->where('day_of_week', $day['day_of_week'])->value('created_at') ?? now()],
            );
        }
    }

    /** @param list<mixed> $days */
    public function valid(array $days): bool
    {
        if (count($days) !== 7) {
            return false;
        }
        $seen = [];
        foreach ($days as $day) {
            if (! is_array($day)) {
                return false;
            }
            $number = $day['day_of_week'] ?? null;
            $status = $day['status'] ?? null;
            if (! is_int($number) || $number < 1 || $number > 7 || isset($seen[$number]) || ! in_array($status, ['OPEN', 'CLOSED'], true)) {
                return false;
            }
            $seen[$number] = true;
            $open = $day['opens_at'] ?? null;
            $close = $day['closes_at'] ?? null;
            if ($status === 'CLOSED') {
                if ($open !== null || $close !== null) {
                    return false;
                }
            } elseif (! $this->validTime($open) || ! $this->validTime($close) || $close <= $open) {
                return false;
            }
        }

        return true;
    }

    private function validTime(mixed $value): bool
    {
        return is_string($value) && preg_match('/^(?:[01][0-9]|2[0-3]):[0-5][0-9]$/D', $value) === 1;
    }
}
