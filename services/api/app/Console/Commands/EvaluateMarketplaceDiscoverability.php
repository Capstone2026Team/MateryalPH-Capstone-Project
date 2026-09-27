<?php

declare(strict_types=1);

namespace App\Console\Commands;

use App\Domain\Catalog\MarketplaceDiscoverability;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

/**
 * Stock confirmations age out with time, so discoverable stores are re-evaluated
 * on a schedule in addition to every catalog, compliance and activation change.
 */
final class EvaluateMarketplaceDiscoverability extends Command
{
    protected $signature = 'materyalph:discoverability-evaluate';

    protected $description = 'Re-evaluate Marketplace Discoverability for active stores.';

    public function handle(MarketplaceDiscoverability $discoverability): int
    {
        $changed = 0;
        DB::table('vendor_organizations')->where(fn ($query) => $query->where('store_activation_status', 'ACTIVE')->orWhere('marketplace_discoverability_status', 'DISCOVERABLE'))
            ->orderBy('id')->select(['id', 'marketplace_discoverability_status'])
            ->chunkById(200, function ($organizations) use ($discoverability, &$changed): void {
                foreach ($organizations as $organization) {
                    $changed += $discoverability->evaluate((string) $organization->id)['status'] !== $organization->marketplace_discoverability_status ? 1 : 0;
                }
            });
        $this->info('Updated Marketplace Discoverability for '.$changed.' store(s).');

        return self::SUCCESS;
    }
}
