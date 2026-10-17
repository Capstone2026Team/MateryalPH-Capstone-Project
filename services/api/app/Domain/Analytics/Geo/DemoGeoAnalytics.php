<?php

declare(strict_types=1);

namespace App\Domain\Analytics\Geo;

use App\Domain\Identity\AuthenticationException;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * DEMO — Simulated Marketplace Data for the geographic dashboard. Writes only DEMO-environment fact rows (never orders,
 * users or TEST facts), so simulated figures can never mix with recorded TEST activity or any future live figures.
 * The generator is deterministic for a given seed. It spreads synthetic Buyers over real PSGC areas of the active
 * version, and deliberately leaves some areas with only a few Buyers so the small-cell suppression is visible.
 */
final class DemoGeoAnalytics
{
    public const ENVIRONMENT = 'DEMO';

    public function __construct(private readonly PsgcHierarchy $psgc) {}

    /** @return array{run_id: string, orders: int, buyers: int, vendors: int, areas: int} */
    public function seed(int $days = 90, int $seed = 16): array
    {
        if (app()->isProduction()) {
            throw new AuthenticationException('DEMO_DISABLED', 'DEMO data cannot be seeded in production.', 409);
        }
        $this->psgc->forget();
        $version = $this->psgc->requireVersion();
        mt_srand($seed);
        $localities = $this->localities();
        if ($localities === []) {
            throw new AuthenticationException('PSGC_VERSION_UNAVAILABLE', 'The active PSGC version has no cities or municipalities to seed.', 409);
        }
        $categories = DB::table('material_categories')->where('active', true)->orderBy('sort_order')->pluck('id')->all();
        $materials = DB::table('materials')->where('active', true)->orderBy('code')->limit(40)->get(['id', 'material_category_id', 'canonical_unit_id'])->all();
        $today = CarbonImmutable::now('Asia/Manila')->startOfDay();
        $start = $today->subDays($days - 1);

        return DB::transaction(function () use ($version, $localities, $categories, $materials, $today, $start, $days): array {
            DB::statement('SELECT pg_advisory_xact_lock(?)', [crc32('materyalph-geo-facts')]);
            DB::statement('DELETE FROM analytics_order_line_facts WHERE analytics_order_fact_id IN (SELECT id FROM analytics_order_facts WHERE environment = ?)', [self::ENVIRONMENT]);
            foreach (['analytics_order_facts', 'analytics_activity_facts', 'analytics_response_facts', 'analytics_presence_facts'] as $table) {
                DB::table($table)->where('environment', self::ENVIRONMENT)->delete();
            }
            DB::table('analytics_geo_runs')->where('environment', self::ENVIRONMENT)->where('state', 'PUBLISHED')->update(['state' => 'SUPERSEDED', 'updated_at' => now()]);
            $revision = (int) DB::table('analytics_geo_runs')->where('environment', self::ENVIRONMENT)->where('through_date', $today->toDateString())->max('revision') + 1;
            $runId = (string) Str::uuid7();
            DB::table('analytics_geo_runs')->insert(['id' => $runId, 'environment' => self::ENVIRONMENT, 'through_date' => $today->toDateString(), 'revision' => $revision, 'state' => 'RUNNING',
                'trigger' => 'DEMO_SEED', 'psgc_version_id' => $version->id, 'started_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
            // Buyers concentrate in a few hubs; the tail keeps a handful of small areas for suppression.
            $buyers = [];
            foreach ($localities as $index => $place) {
                $population = $index < 12 ? mt_rand(18, 60) : mt_rand(1, 6);
                for ($n = 0; $n < $population; $n++) {
                    $buyers[] = ['key' => GeoFactsBuilder::personKey('DEMO_BUYER', $index.':'.$n), 'place' => $place];
                }
            }
            $vendors = [];
            foreach ($localities as $index => $place) {
                for ($n = 0, $count = $index < 12 ? mt_rand(2, 8) : mt_rand(0, 2); $n < $count; $n++) {
                    $vendors[] = ['key' => GeoFactsBuilder::personKey('DEMO_VENDOR', $index.':'.$n), 'user' => GeoFactsBuilder::personKey('DEMO_VENDOR_USER', $index.':'.$n), 'place' => $place];
                }
            }
            $rows = ['orders' => [], 'lines' => [], 'activity' => [], 'responses' => [], 'presence' => []];
            $orders = 0;
            foreach ($buyers as $buyerIndex => $buyer) {
                $placements = mt_rand(0, 5);
                for ($n = 0; $n < $placements; $n++) {
                    $day = $start->addDays(mt_rand(0, $days - 1));
                    $gross = mt_rand(150_000, 12_000_000);
                    $state = $this->state();
                    $cancelled = $state === 'CANCELLED';
                    $refunded = ! $cancelled && mt_rand(1, 100) <= 4 ? intdiv($gross, mt_rand(3, 10)) : 0;
                    $due = $day->addDays(mt_rand(1, 6));
                    $completed = $state === 'COMPLETED' ? $due->addDays(mt_rand(-1, 2)) : null;
                    $factId = (string) Str::uuid7();
                    $method = mt_rand(0, 1) === 1 ? 'DELIVERY' : 'PICKUP';
                    $rows['orders'][] = ['id' => $factId, 'environment' => self::ENVIRONMENT, 'source_key' => 'demo-order:'.$buyerIndex.':'.$n, 'analytics_geo_run_id' => $runId,
                        'confirmed_on' => $day->toDateString(), 'buyer_key' => $buyer['key'], 'geo_basis' => $method === 'DELIVERY' ? 'DELIVERY_SITE' : 'PICKUP_STORE',
                        'psgc_version_id' => $version->id, 'region_code' => $buyer['place']['region_code'], 'area_code' => $buyer['place']['area_code'], 'locality_code' => $buyer['place']['locality_code'],
                        'geo_resolution' => 'RESOLVED', 'procurement_type' => mt_rand(1, 100) <= 22 ? 'PROJECT_BASED' : 'ITEM_BASED', 'fulfillment_method' => $method,
                        'payment_method' => $method === 'DELIVERY' ? (mt_rand(1, 100) <= 30 ? 'CASH_ON_DELIVERY' : 'ONLINE') : (mt_rand(1, 100) <= 25 ? 'IN_STORE' : 'ONLINE'),
                        'order_state' => $state, 'gross_value_centavos' => $gross, 'cancelled_value_centavos' => $cancelled ? $gross : 0, 'refunded_value_centavos' => $refunded,
                        'net_value_centavos' => $gross - ($cancelled ? $gross : 0) - $refunded, 'due_on' => $due->toDateString(), 'completed_on' => $completed?->min($today)->toDateString(),
                        'cancelled' => $cancelled, 'disputed' => mt_rand(1, 100) <= 3, 'created_at' => now()];
                    foreach (range(1, mt_rand(1, 3)) as $line) {
                        $material = $materials === [] ? null : $materials[mt_rand(0, count($materials) - 1)];
                        $quantity = (string) mt_rand(1, 400);
                        $rows['lines'][] = ['id' => (string) Str::uuid7(), 'analytics_order_fact_id' => $factId,
                            'material_category_id' => $material->material_category_id ?? ($categories === [] ? null : $categories[mt_rand(0, count($categories) - 1)]),
                            'material_id' => $material?->id, 'unit_id' => $material?->canonical_unit_id, 'quantity' => $quantity, 'normalized_quantity' => $material === null ? null : $quantity,
                            'value_centavos' => intdiv($gross, 3)];
                    }
                    $rows['activity'][] = $this->activity($runId, 'demo-act:'.$buyerIndex.':'.$n, $day, 'BUYER', $buyer['key'], 'ORDER_SUBMITTED', $buyer['place'], $version->id);
                    if ($completed !== null && $completed->lessThanOrEqualTo($today)) {
                        $rows['activity'][] = $this->activity($runId, 'demo-rcpt:'.$buyerIndex.':'.$n, $completed, 'BUYER', $buyer['key'], 'RECEIPT_CONFIRMED', $buyer['place'], $version->id);
                    }
                    $vendor = $vendors === [] ? null : $vendors[mt_rand(0, count($vendors) - 1)];
                    if ($vendor !== null) {
                        $available = $day->setTime(mt_rand(7, 19), mt_rand(0, 59))->setTimezone('UTC');
                        $answered = mt_rand(1, 100) <= 92;
                        $seconds = $answered ? (int) (mt_rand(4, 300) ** 1.6) : null;
                        $rows['responses'][] = ['id' => (string) Str::uuid7(), 'environment' => self::ENVIRONMENT, 'source_key' => 'demo-resp:'.$buyerIndex.':'.$n, 'analytics_geo_run_id' => $runId,
                            'available_on' => $day->toDateString(), 'request_kind' => ['INQUIRY', 'ORDER_REQUEST', 'PACKAGE_REQUEST', 'COUNTER_OFFER'][mt_rand(0, 3)], 'buyer_key' => $buyer['key'],
                            'psgc_version_id' => $version->id, 'region_code' => $vendor['place']['region_code'], 'area_code' => $vendor['place']['area_code'], 'locality_code' => $vendor['place']['locality_code'],
                            'geo_resolution' => 'RESOLVED', 'available_at' => $available, 'responded_at' => $seconds === null ? null : $available->addSeconds($seconds), 'response_seconds' => $seconds, 'created_at' => now()];
                        $rows['activity'][] = $this->activity($runId, 'demo-vact:'.$buyerIndex.':'.$n, $day, 'VENDOR', $vendor['user'], 'ORDER_DECIDED', $vendor['place'], $version->id);
                    }
                    $orders++;
                }
            }
            foreach ([$today, $today->subDays(30), $today->subDays(60)] as $snapshot) {
                foreach ($vendors as $vendor) {
                    $rows['presence'][] = $this->presence($runId, $snapshot, 'VENDOR', $vendor['key'], $vendor['place'], $version->id);
                }
                foreach ($buyers as $buyer) {
                    $rows['presence'][] = $this->presence($runId, $snapshot, 'BUYER', $buyer['key'], $buyer['place'], $version->id);
                }
            }
            foreach (['orders' => 'analytics_order_facts', 'lines' => 'analytics_order_line_facts', 'activity' => 'analytics_activity_facts', 'responses' => 'analytics_response_facts', 'presence' => 'analytics_presence_facts'] as $key => $table) {
                foreach (array_chunk($rows[$key], 500) as $chunk) {
                    DB::table($table)->insertOrIgnore($chunk);
                }
            }
            DB::table('analytics_geo_runs')->where('id', $runId)->update(['state' => 'PUBLISHED', 'published_at' => now(), 'updated_at' => now(),
                'counts' => json_encode(['orders' => $orders, 'buyers' => count($buyers), 'vendors' => count($vendors)], JSON_THROW_ON_ERROR)]);

            return ['run_id' => $runId, 'orders' => $orders, 'buyers' => count($buyers), 'vendors' => count($vendors), 'areas' => count($localities)];
        });
    }

    /** @return list<array{region_code: string, area_code: ?string, locality_code: ?string}> */
    private function localities(): array
    {
        $places = [];
        foreach ($this->psgc->children(null) as $region) {
            $second = $this->psgc->children($region['code']);
            foreach (array_slice($second, 0, 3) as $area) {
                $third = $this->psgc->children($area['code']);
                if ($third === []) {
                    $places[] = ['region_code' => $region['code'], 'area_code' => $area['code'], 'locality_code' => null];

                    continue;
                }
                foreach (array_slice($third, 0, 2) as $locality) {
                    $places[] = ['region_code' => $region['code'], 'area_code' => $area['code'], 'locality_code' => $locality['code']];
                }
            }
        }
        // Deterministic shuffle so the large hubs are spread across regions rather than the first codes only.
        usort($places, static fn (array $a, array $b): int => strcmp(md5(($a['locality_code'] ?? $a['area_code']).'demo'), md5(($b['locality_code'] ?? $b['area_code']).'demo')));

        return $places;
    }

    private function state(): string
    {
        $roll = mt_rand(1, 100);

        return match (true) {
            $roll <= 70 => 'COMPLETED',
            $roll <= 80 => 'CANCELLED',
            $roll <= 88 => 'PROCESSING',
            $roll <= 94 => 'CONFIRMED',
            default => 'DELIVERED',
        };
    }

    /**
     * @param  array{region_code: string, area_code: ?string, locality_code: ?string}  $place
     * @return array<string, mixed>
     */
    private function activity(string $runId, string $key, CarbonImmutable $day, string $audience, string $actor, string $kind, array $place, string $versionId): array
    {
        return ['id' => (string) Str::uuid7(), 'environment' => self::ENVIRONMENT, 'source_key' => $key, 'analytics_geo_run_id' => $runId, 'activity_on' => $day->toDateString(),
            'audience' => $audience, 'actor_key' => $actor, 'action_kind' => $kind, 'psgc_version_id' => $versionId, 'region_code' => $place['region_code'], 'area_code' => $place['area_code'],
            'locality_code' => $place['locality_code'], 'geo_resolution' => 'RESOLVED', 'created_at' => now()];
    }

    /**
     * @param  array{region_code: string, area_code: ?string, locality_code: ?string}  $place
     * @return array<string, mixed>
     */
    private function presence(string $runId, CarbonImmutable $day, string $audience, string $key, array $place, string $versionId): array
    {
        return ['id' => (string) Str::uuid7(), 'environment' => self::ENVIRONMENT, 'analytics_geo_run_id' => $runId, 'snapshot_on' => $day->toDateString(), 'audience' => $audience,
            'subject_key' => $key, 'psgc_version_id' => $versionId, 'region_code' => $place['region_code'], 'area_code' => $place['area_code'], 'locality_code' => $place['locality_code'],
            'geo_resolution' => 'RESOLVED', 'created_at' => now()];
    }
}
