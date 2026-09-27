<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Vendors\StoreOperatingSchedule;
use PHPUnit\Framework\TestCase;

final class StoreOperatingScheduleTest extends TestCase
{
    public function test_all_seven_explicit_days_are_required_and_overnight_hours_are_rejected(): void
    {
        $schedule = array_map(fn (int $day): array => ['day_of_week' => $day, 'status' => $day === 7 ? 'CLOSED' : 'OPEN', 'opens_at' => $day === 7 ? null : '08:00', 'closes_at' => $day === 7 ? null : '17:00'], range(1, 7));
        $validator = new StoreOperatingSchedule;

        self::assertTrue($validator->valid($schedule));
        self::assertFalse($validator->valid(array_slice($schedule, 0, 6)));
        $duplicate = $schedule;
        $duplicate[1]['day_of_week'] = 1;
        self::assertFalse($validator->valid($duplicate));
        $malformed = $schedule;
        $malformed[1] = 'Tuesday';
        self::assertFalse($validator->valid($malformed));
        $schedule[0]['closes_at'] = '08:00';
        self::assertFalse($validator->valid($schedule));
        $schedule[0]['closes_at'] = '07:00';
        self::assertFalse($validator->valid($schedule));
        $schedule[0]['closes_at'] = '17:00';
        $schedule[6]['opens_at'] = '08:00';
        self::assertFalse($validator->valid($schedule));
    }
}
