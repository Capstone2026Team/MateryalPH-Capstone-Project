<?php

declare(strict_types=1);

namespace App\Domain\Geography;

use Illuminate\Support\Facades\Cache;

/**
 * Platform-wide daily call budgets for billable maps providers, independent of per-Buyer rate limits. When
 * a budget is spent, callers degrade exactly as for a provider outage instead of incurring more charges.
 */
final class ProviderBudget
{
    public function consume(string $provider, int $calls = 1): void
    {
        $limit = (int) config('services.google_maps.'.strtolower($provider).'.max_calls_per_day', 0);
        if ($limit <= 0) {
            throw new GeographyProviderUnavailable('QUOTA');
        }
        $key = 'maps-budget:'.strtolower($provider).':'.now('Asia/Manila')->toDateString();
        Cache::add($key, 0, now()->addDays(2));
        if ((int) Cache::increment($key, $calls) > $limit) {
            throw new GeographyProviderUnavailable('QUOTA');
        }
    }
}
