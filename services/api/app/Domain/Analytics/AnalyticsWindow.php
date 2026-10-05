<?php

declare(strict_types=1);

namespace App\Domain\Analytics;

use App\Domain\Identity\AuthenticationException;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;

/**
 * MAT-04 date window. Presets compare the end date with 7, 30 or 90 calendar days earlier (default 30); the default end
 * is the latest successfully published snapshot date. A custom window needs start before end, at most 365 days and no
 * future endpoint. Both endpoints are included; endpoints are exact dates, never the nearest available date.
 */
final readonly class AnalyticsWindow
{
    public const PRESETS = [7, 30, 90];

    public const MAX_DAYS = 365;

    public function __construct(
        public ?string $start,
        public ?string $end,
        public ?int $preset,
        public ?string $earliest,
        public ?string $latest,
    ) {}

    /**
     * @param  array<string, mixed>  $input
     * @param  array{environment: string, dataset_id: string}  $dataset
     */
    public static function resolve(array $input, array $dataset, ?CarbonImmutable $today = null): self
    {
        $today = ($today ?? CarbonImmutable::now())->setTimezone('Asia/Manila')->toDateString();
        $bounds = DB::table('analytics_published_runs')->where('kind', AnalyticsDataset::KIND)->where('environment', $dataset['environment'])->where('dataset_id', $dataset['dataset_id'])
            ->selectRaw('min(snapshot_date) AS earliest, max(snapshot_date) AS latest')->first();
        $earliest = $bounds?->earliest === null ? null : (string) $bounds->earliest;
        $latest = $bounds?->latest === null ? null : (string) $bounds->latest;
        $start = $input['start_date'] ?? null;
        $end = $input['end_date'] ?? null;
        if ($start !== null || $end !== null) {
            if ($start === null || $end === null) {
                throw self::invalid('Choose both a start date and an end date.');
            }
            if ($end > $today || $start > $today) {
                throw self::invalid('Dates cannot be in the future.');
            }
            if ($start >= $end) {
                throw self::invalid('The start date must be before the end date.');
            }
            if (CarbonImmutable::parse($start)->diffInDays(CarbonImmutable::parse($end)) > self::MAX_DAYS) {
                throw self::invalid('Choose a range of at most 365 days.');
            }

            return new self($start, $end, null, $earliest, $latest);
        }
        $preset = (int) ($input['preset_days'] ?? 30);
        if (! in_array($preset, self::PRESETS, true)) {
            throw self::invalid('Choose 7, 30 or 90 days, or a custom range.');
        }
        if ($latest === null) {
            return new self(null, null, $preset, null, null);
        }

        return new self(CarbonImmutable::parse($latest)->subDays($preset)->toDateString(), $latest, $preset, $earliest, $latest);
    }

    /** @return list<string> every date from start to end inclusive */
    public function dates(): array
    {
        if ($this->start === null || $this->end === null) {
            return [];
        }
        $dates = [];
        for ($day = CarbonImmutable::parse($this->start); $day->toDateString() <= $this->end; $day = $day->addDay()) {
            $dates[] = $day->toDateString();
        }

        return $dates;
    }

    /** @return array<string, mixed> */
    public function summary(): array
    {
        return ['preset_days' => $this->preset, 'start_date' => $this->start, 'end_date' => $this->end, 'earliest_available_date' => $this->earliest,
            'latest_available_date' => $this->latest, 'max_days' => self::MAX_DAYS, 'presets' => self::PRESETS];
    }

    public function cacheKey(): string
    {
        return ($this->start ?? '-').':'.($this->end ?? '-');
    }

    private static function invalid(string $message): AuthenticationException
    {
        return new AuthenticationException('ANALYTICS_DATE_RANGE_INVALID', $message, 422, ['max_days' => self::MAX_DAYS]);
    }
}
