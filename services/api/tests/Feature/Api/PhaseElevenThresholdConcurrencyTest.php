<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\VendorFileScanner;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabaseState;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\Support\CreatesOrderFixtures;
use Tests\Support\CreatesPaymentFixtures;
use Tests\Support\CreatesWithholdingFixtures;
use Tests\Support\FakeAddressGeocoder;
use Tests\Support\FakePlacesProvider;
use Tests\Support\FakeRouteProvider;
use Tests\TestCase;

/**
 * FIN-04A fixture 8 against live PostgreSQL: two settlements for one taxpayer, each G = 100,000, from
 * g_effective = 49,950,000. The first holds the accumulator row lock inside an open transaction; the second must
 * wait for it, then sees the committed total. Totals 50,050,000 then 50,150,000, exactly one crossing event, no
 * lost update and no double assessment.
 */
final class PhaseElevenThresholdConcurrencyTest extends TestCase
{
    use CreatesDiscoveryFixtures;
    use CreatesOrderFixtures;
    use CreatesPaymentFixtures;
    use CreatesWithholdingFixtures;

    protected function setUp(): void
    {
        parent::setUp();
        // Both sessions must see committed fixtures, so this suite starts from and leaves a freshly migrated test database.
        $this->artisan('migrate:fresh', ['--force' => true])->assertSuccessful();
        $this->beforeApplicationDestroyed(function (): void {
            $this->artisan('migrate:fresh', ['--force' => true]);
            RefreshDatabaseState::$migrated = true;
        });
        $this->seed(SystemFoundationSeeder::class);
        config()->set('materyalph.files.disk', 'local');
        config()->set('services.cloudinary.cloud_name', '');
        Storage::fake('local');
        $this->mock(VendorFileScanner::class)->shouldReceive('assertClean')->andReturnNull();
        $this->withCredentials()->withUnencryptedCookie('mp_csrf', 'test-csrf')->withHeader('X-CSRF-Token', 'test-csrf');
        $this->app->instance(PlacesProvider::class, new FakePlacesProvider);
        $this->app->instance(RouteProvider::class, new FakeRouteProvider);
        $this->app->instance(AddressGeocoder::class, new FakeAddressGeocoder);
        $this->fakePayments();
    }

    public function test_fixture_8_two_concurrent_settlements_serialize_on_the_taxpayer_year_row(): void
    {
        [$store, , , $orderId] = $this->awaitingPayment('Race Threshold Hardware');
        $this->grantRelief($store->id);
        $accumulatorId = $this->seedAccumulator($store->id, 49950000, 'RELIEF_ACTIVE');
        // The responsibility assignment exists before the race, so the accumulator row is the only shared lock.
        $versionId = (string) DB::table('vendor_tax_profiles')->where('vendor_organization_id', $store->id)->value('current_version_id');
        DB::table('withholding_assignments')->insert(['id' => (string) Str::uuid7(), 'vendor_tax_profile_version_id' => $versionId, 'tax_rule_version_id' => DB::table('tax_rule_versions')->where('code', 'DEMO_PLATFORM_WITHHOLDER')->value('id'),
            'rate_basis_points' => 50, 'effective_from' => now()->subDay(), 'scenario' => 'DEMO_PLATFORM_WITHHOLDER', 'reason' => 'Fixture', 'created_at' => now(), 'updated_at' => now()]);

        $status = $this->race(
            fn () => $this->assessGroup($store->id, $orderId, 'RACE-A', 100000),
            function () use ($store, $orderId): int {
                $assessment = $this->assessGroup($store->id, $orderId, 'RACE-B', 100000);

                return (int) $assessment->g_effective_before_centavos === 50050000 && (int) $assessment->withheld_centavos === 500 ? 0 : 4;
            },
        );

        self::assertSame(0, $status, 'The waiting settlement must read the committed total, not the stale one.');
        $assessments = DB::table('remittance_assessments')->orderBy('g_effective_after_centavos')->get();
        self::assertCount(2, $assessments);
        self::assertSame([[49950000, 50050000, 500, 'SUBJECT_THRESHOLD_BREACHED'], [50050000, 50150000, 500, 'SUBJECT_THRESHOLD_BREACHED']], $assessments->map(static fn (object $row): array => [
            (int) $row->g_effective_before_centavos, (int) $row->g_effective_after_centavos, (int) $row->withheld_centavos, $row->threshold_status_after])->all());
        $accumulator = DB::table('vendor_withholding_accumulators')->where('id', $accumulatorId)->first();
        self::assertSame([50150000, 'SUBJECT_THRESHOLD_BREACHED', $assessments[0]->id], [(int) $accumulator->g_accumulated_centavos, $accumulator->withholding_status, $accumulator->crossing_assessment_id]);
        self::assertSame(1, DB::table('vendor_withholding_status_events')->where('accumulator_id', $accumulatorId)->where('to_status', 'SUBJECT_THRESHOLD_BREACHED')->count(), 'Exactly one crossing event.');

        // A third delivery of an already assessed group returns the stored result without touching the counter.
        self::assertSame($assessments[1]->id, $this->assessGroup($store->id, $orderId, 'RACE-B', 100000)->id);
        self::assertSame(50150000, (int) DB::table('vendor_withholding_accumulators')->where('id', $accumulatorId)->value('g_accumulated_centavos'));
    }

    /**
     * Runs $holder inside an open transaction (holding its row locks), lets $contender start in a second
     * session, proves it waits, then commits. Returns the contender's exit status.
     */
    private function race(callable $holder, callable $contender): int
    {
        $sockets = stream_socket_pair(STREAM_PF_UNIX, STREAM_SOCK_STREAM, STREAM_IPPROTO_IP);
        self::assertNotFalse($sockets);
        $pid = pcntl_fork();
        self::assertNotSame(-1, $pid);
        if ($pid === 0) {
            fclose($sockets[0]);
            DB::purge('pgsql');
            fwrite($sockets[1], 'R');
            stream_set_timeout($sockets[1], 20);
            if (fread($sockets[1], 1) !== 'S') {
                exit(3);
            }
            try {
                exit($contender());
            } catch (\Throwable) {
                exit(5);
            }
        }
        fclose($sockets[1]);
        stream_set_timeout($sockets[0], 20);
        $status = 0;
        try {
            self::assertSame('R', fread($sockets[0], 1));
            DB::purge('pgsql');
            DB::beginTransaction();
            $holder();
            fwrite($sockets[0], 'S');
            usleep(800000);
            self::assertSame(0, pcntl_waitpid($pid, $status, WNOHANG), 'The second settlement must wait on the accumulator row lock.');
            DB::commit();
            pcntl_waitpid($pid, $status);
        } finally {
            if (DB::transactionLevel() > 0) {
                DB::rollBack();
            }
            fclose($sockets[0]);
        }
        self::assertTrue(pcntl_wifexited($status));

        return pcntl_wexitstatus($status);
    }
}
