<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

/**
 * Vacation Mode runs over an Owner-chosen window of Asia/Manila calendar days. `store_profiles.vacation_mode`
 * stays the single flag every procurement path reads; this class owns the window and flips the flag on time.
 */
final class VendorVacationSchedule
{
    public const ZONE = 'Asia/Manila';

    /**
     * Resolve the owner's request into the columns to store. Turning Vacation Mode off clears the window.
     *
     * @param  array<string, mixed>  $input
     * @return array{vacation_mode: bool, vacation_starts_at: ?string, vacation_ends_at: ?string}
     */
    public function resolve(array $input, ?object $existing): array
    {
        if (! (bool) $input['vacation_mode']) {
            return ['vacation_mode' => false, 'vacation_starts_at' => null, 'vacation_ends_at' => null];
        }
        $start = CarbonImmutable::createFromFormat('!Y-m-d', (string) $input['vacation_starts_on'], self::ZONE);
        $end = CarbonImmutable::createFromFormat('!Y-m-d', (string) $input['vacation_ends_on'], self::ZONE)->addDay();
        $unchangedStart = ($existing->vacation_starts_at ?? null) !== null && CarbonImmutable::parse((string) $existing->vacation_starts_at)->equalTo($start);
        if ($start->isBefore(CarbonImmutable::now(self::ZONE)->startOfDay()) && ! $unchangedStart) {
            throw ValidationException::withMessages(['vacation_starts_on' => 'The start date cannot be in the past.']);
        }

        return [
            'vacation_mode' => $start->lessThanOrEqualTo(CarbonImmutable::now()),
            'vacation_starts_at' => $start->toIso8601String(),
            'vacation_ends_at' => $end->toIso8601String(),
        ];
    }

    /** @return array{vacation_status: string, vacation_starts_on: ?string, vacation_ends_on: ?string} */
    public function snapshot(?object $profile): array
    {
        $starts = ($profile->vacation_starts_at ?? null) === null ? null : CarbonImmutable::parse((string) $profile->vacation_starts_at)->setTimezone(self::ZONE);
        $ends = ($profile->vacation_ends_at ?? null) === null ? null : CarbonImmutable::parse((string) $profile->vacation_ends_at)->setTimezone(self::ZONE)->subDay();

        return [
            'vacation_status' => ($profile->vacation_mode ?? false) ? 'ACTIVE' : ($starts === null ? 'OFF' : 'SCHEDULED'),
            'vacation_starts_on' => $starts?->toDateString(),
            'vacation_ends_on' => $ends?->toDateString(),
        ];
    }

    /** Start windows that have begun and end windows that have finished. Returns how many stores changed. */
    public function sweep(): int
    {
        $now = now();
        $due = DB::table('store_profiles')->whereNotNull('vacation_starts_at')
            ->where(fn ($query) => $query
                ->where(fn ($start) => $start->where('vacation_mode', false)->where('vacation_starts_at', '<=', $now)->where('vacation_ends_at', '>', $now))
                ->orWhere(fn ($end) => $end->where('vacation_ends_at', '<=', $now)))
            ->orderBy('vacation_starts_at')->limit(500)->pluck('vendor_organization_id');
        $changed = 0;
        foreach ($due as $organizationId) {
            $changed += DB::transaction(function () use ($organizationId): int {
                // Same lock order as profile updates and NewProcurementAvailability.
                DB::table('vendor_organizations')->where('id', $organizationId)->lockForUpdate()->first();
                $profile = DB::table('store_profiles')->where('vendor_organization_id', $organizationId)->lockForUpdate()->first();
                if ($profile === null || $profile->vacation_starts_at === null) {
                    return 0;
                }
                $now = CarbonImmutable::now();
                $ended = CarbonImmutable::parse((string) $profile->vacation_ends_at)->lessThanOrEqualTo($now);
                if ($ended) {
                    $update = ['vacation_mode' => false, 'vacation_starts_at' => null, 'vacation_ends_at' => null];
                    $action = 'VENDOR_VACATION_MODE_ENDED';
                } elseif (! $profile->vacation_mode && CarbonImmutable::parse((string) $profile->vacation_starts_at)->lessThanOrEqualTo($now)) {
                    $update = ['vacation_mode' => true];
                    $action = 'VENDOR_VACATION_MODE_STARTED';
                } else {
                    return 0;
                }
                DB::table('store_profiles')->where('id', $profile->id)->update($update + ['updated_at' => $now]);
                $window = $this->snapshot($profile);
                DB::table('audit_logs')->insert([
                    'id' => (string) Str::uuid7(), 'actor_user_id' => null, 'actor_role' => 'SYSTEM:materyalph:vendor-vacation-sweep', 'vendor_organization_id' => $organizationId,
                    'action' => $action, 'resource_type' => 'STORE_PROFILE', 'resource_id' => $profile->id,
                    'before' => json_encode(['vacation_mode' => (bool) $profile->vacation_mode] + $window, JSON_THROW_ON_ERROR),
                    'after' => json_encode(['vacation_mode' => (bool) $update['vacation_mode']], JSON_THROW_ON_ERROR),
                    'reason' => $ended ? 'The Vacation Mode end date passed.' : 'The Vacation Mode start date arrived.',
                    'correlation_id' => (string) Str::uuid7(), 'succeeded' => true, 'created_at' => $now, 'updated_at' => $now,
                ]);

                return 1;
            });
        }

        return $changed;
    }
}
