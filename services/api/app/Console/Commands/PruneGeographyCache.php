<?php

declare(strict_types=1);

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

/**
 * Keeps Google-derived caches bounded: deletes expired search cells, Place Details, routes and unclaimed
 * Directory Supplier records, then trims each cache to its configured maximum record count, oldest first.
 */
final class PruneGeographyCache extends Command
{
    protected $signature = 'materyalph:geography-cache-prune';

    protected $description = 'Delete expired or excess Google Places and Routes cache records.';

    public function handle(): int
    {
        $expired = DB::table('place_cache_entries')->where('expires_at', '<=', now())->delete()
            + DB::table('route_cache_entries')->where('expires_at', '<=', now())->delete()
            + DB::table('directory_suppliers')->whereNull('claimed_vendor_organization_id')->where(fn ($query) => $query->whereNull('expires_at')->orWhere('expires_at', '<=', now()))->delete();
        $excess = $this->trim('place_cache_entries', (int) config('services.google_maps.places.max_cache_records', 20000))
            + $this->trim('route_cache_entries', (int) config('services.google_maps.routes.max_cache_records', 20000))
            + $this->trim('directory_suppliers', (int) config('services.google_maps.places.max_cache_records', 20000), unclaimedOnly: true);
        $this->info('Removed '.$expired.' expired and '.$excess.' excess geography cache record(s).');

        return self::SUCCESS;
    }

    private function trim(string $table, int $maximum, bool $unclaimedOnly = false): int
    {
        $query = DB::table($table)->when($unclaimedOnly, fn ($builder) => $builder->whereNull('claimed_vendor_organization_id'));
        $count = (clone $query)->count();
        if ($maximum < 1 || $count <= $maximum) {
            return 0;
        }

        return DB::table($table)->whereIn('id', (clone $query)->orderBy('updated_at')->orderBy('id')->limit($count - $maximum)->pluck('id'))->delete();
    }
}
