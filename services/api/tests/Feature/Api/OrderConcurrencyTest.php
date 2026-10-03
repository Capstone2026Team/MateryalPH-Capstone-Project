<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\AutoAcceptService;
use App\Domain\Orders\OrderConfirmationService;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\VendorFileScanner;
use App\Models\User;
use Carbon\CarbonImmutable;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabaseState;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Tests\Support\CreatesDiscoveryFixtures;
use Tests\Support\CreatesOrderFixtures;
use Tests\Support\FakeAddressGeocoder;
use Tests\Support\FakePlacesProvider;
use Tests\Support\FakeRouteProvider;
use Tests\TestCase;

/**
 * Two real PostgreSQL sessions race for the same organization, inventory and policy rows. The first acceptance
 * holds its locks inside an open transaction; the second waits, then revalidates against the committed state:
 * no overselling, no partial reservation, a committed restriction wins, and one allotment admits one order.
 */
final class OrderConcurrencyTest extends TestCase
{
    use CreatesDiscoveryFixtures;
    use CreatesOrderFixtures;

    protected function setUp(): void
    {
        parent::setUp();
        // Both sessions must see committed fixtures, so this suite cannot wrap a test in a transaction. It starts
        // from, and leaves behind, a freshly migrated isolated test database; a full down-migration rollback is
        // not used because an earlier onboarding migration cannot roll back populated activation history.
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
    }

    public function test_two_concurrent_confirmations_never_oversell_and_the_loser_reserves_nothing(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Race Hardware', [['price' => 1000, 'qty' => '10']]);
        [, $first] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '6']]);
        [, $second] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '6']]);
        $variant = $this->variantIds($listing)[0];

        $status = $this->race(
            fn () => app(OrderConfirmationService::class)->confirm($this->vendorRequest($owner, $store->id, 'OWNER'), $first, $this->pickupBody($first)),
            function () use ($owner, $store, $second): int {
                try {
                    app(OrderConfirmationService::class)->confirm($this->vendorRequest($owner, $store->id, 'OWNER'), $second, $this->pickupBody($second));

                    return 2;
                } catch (AuthenticationException $exception) {
                    return $exception->errorCode === 'STOCK_INSUFFICIENT' ? 0 : 4;
                }
            },
        );

        self::assertSame(0, $status, 'The waiting confirmation must revalidate and see the committed reservation.');
        self::assertSame('6.0000', $this->reserved($variant));
        self::assertSame(1, $this->activeHolds($first));
        self::assertSame(0, $this->activeHolds($second));
        self::assertSame('AWAITING_VENDOR_CONFIRMATION', DB::table('orders')->where('id', $second)->value('order_state'));
    }

    public function test_a_restriction_committed_while_confirmation_waits_blocks_it_without_a_partial_change(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Hold Hardware');
        [, $orderId] = $this->pickupOrder($store, $listing);

        $status = $this->race(
            fn () => DB::table('vendor_organizations')->where('id', $store->id)->update(['activation_hold_code' => 'ADMIN_HOLD', 'activation_hold_reason' => 'Concurrent review']),
            function () use ($owner, $store, $orderId): int {
                try {
                    app(OrderConfirmationService::class)->confirm($this->vendorRequest($owner, $store->id, 'OWNER'), $orderId, $this->pickupBody($orderId));

                    return 2;
                } catch (AuthenticationException $exception) {
                    return $exception->errorCode === 'STORE_NOT_ELIGIBLE' ? 0 : 4;
                }
            },
            lockOrganization: $store->id,
        );

        self::assertSame(0, $status);
        self::assertSame(0, DB::table('inventory_holds')->count());
        self::assertSame(0, DB::table('order_snapshots')->where('order_id', $orderId)->where('version', '>', 1)->count());
    }

    public function test_one_remaining_allotment_admits_one_concurrent_auto_accept_and_routes_the_other_to_manual_review(): void
    {
        [$store, $owner, $listing] = $this->pickupStore('Allot Hardware', [['price' => 1000, 'qty' => '20']]);
        $variant = $this->variantIds($listing)[0];
        [, $first] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '4']]);
        [, $second] = $this->pickupOrder($store, $listing, [['variant' => 0, 'quantity' => '4']]);
        $this->enableAutoAccept($owner, $store->id, $variant, '4');

        $status = $this->race(
            fn () => app(AutoAcceptService::class)->attempt($first),
            fn (): int => app(AutoAcceptService::class)->attempt($second)['accepted'] ? 2 : 0,
        );

        self::assertSame(0, $status, 'The second order must go to manual review, not partially accept.');
        self::assertSame('AWAITING_PAYMENT', DB::table('orders')->where('id', $first)->value('order_state'));
        self::assertSame('AWAITING_VENDOR_CONFIRMATION', DB::table('orders')->where('id', $second)->value('order_state'));
        self::assertSame('4.0000', $this->reserved($variant));
        $policy = DB::table('auto_accept_policies')->where('listing_variant_id', $variant)->first();
        self::assertSame(['0', true], [bcadd((string) $policy->remaining_allotment_quantity, '0', 0), (bool) $policy->paused]);
    }

    /**
     * Runs $holder inside an open transaction (holding its row locks), lets $contender start in a second
     * session, proves it waits, then commits. Returns the contender's exit status.
     */
    private function race(callable $holder, callable $contender, ?string $lockOrganization = null): int
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
            if ($lockOrganization !== null) {
                DB::table('vendor_organizations')->where('id', $lockOrganization)->lockForUpdate()->first();
            }
            $holder();
            fwrite($sockets[0], 'S');
            usleep(600000);
            self::assertSame(0, pcntl_waitpid($pid, $status, WNOHANG), 'The contender must wait for the committed rows.');
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

    private function vendorRequest(User $user, string $organizationId, string $role): Request
    {
        $request = Request::create('/api/v1/vendor/orders/confirm', 'POST', server: ['CONTENT_TYPE' => 'application/json', 'HTTP_IDEMPOTENCY_KEY' => (string) Str::uuid7()], content: '{}');
        $request->setUserResolver(fn () => $user);
        $request->attributes->set('account_scope', ['organization_id' => $organizationId, 'role' => $role]);
        $request->attributes->set('correlation_id', (string) Str::uuid7());

        return $request;
    }

    /** @return array<string, mixed> */
    private function pickupBody(string $orderId): array
    {
        $order = DB::table('orders')->where('id', $orderId)->first();

        return ['lock_version' => (int) $order->lock_version, 'pickup' => ['ready_date' => CarbonImmutable::now('Asia/Manila')->addDay()->toDateString()],
            'lines' => DB::table('order_lines')->where('order_id', $orderId)->orderBy('line_number')->get()->map(static fn (object $line): array => ['order_line_id' => (string) $line->id, 'confirmed_quantity' => (string) $line->quantity])->all()];
    }
}
