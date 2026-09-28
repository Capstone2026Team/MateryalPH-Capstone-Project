<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Inventory\InventoryLedgerService;
use App\Models\User;
use App\Models\VendorMembership;
use App\Models\VendorOrganization;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\DatabaseMigrations;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Tests\TestCase;

/**
 * Two real PostgreSQL sessions edit the same inventory row. The second editor waits for the row locks
 * and then receives a stale-version conflict instead of silently overwriting the committed count.
 */
final class InventoryConcurrencyTest extends TestCase
{
    use DatabaseMigrations;

    public function test_a_concurrent_manual_edit_waits_for_the_lock_and_then_conflicts_instead_of_overwriting(): void
    {
        $this->seed(SystemFoundationSeeder::class);
        $organization = VendorOrganization::query()->create(['legal_name' => 'Concurrent stock store', 'store_name' => 'Concurrent stock store']);
        DB::table('vendor_organizations')->where('id', $organization->id)->update(['account_status' => 'ACTIVE', 'store_activation_status' => 'ACTIVE']);
        $owner = User::factory()->create(['account_type' => 'VENDOR', 'account_status' => 'ACTIVE']);
        VendorMembership::query()->create(['vendor_organization_id' => $organization->getKey(), 'user_id' => $owner->getKey(), 'role' => 'OWNER', 'status' => 'ACTIVE', 'can_manage_staff' => false]);
        $productId = DB::table('products')->insertGetId(['name' => 'Concurrent product', 'public_id' => (string) Str::uuid7(), 'created_at' => now(), 'updated_at' => now()]);
        $listingId = (string) Str::uuid7();
        DB::table('vendor_listings')->insert(['id' => $listingId, 'vendor_organization_id' => $organization->id, 'product_id' => $productId, 'vendor_sku' => 'CONC-1', 'display_name' => 'Concurrent listing', 'status' => 'DRAFT', 'created_at' => now(), 'updated_at' => now()]);
        $variantId = (string) Str::uuid7();
        DB::table('listing_variants')->insert(['id' => $variantId, 'vendor_listing_id' => $listingId, 'sku' => 'CONC-1-V1', 'unit_id' => DB::table('units')->value('id'), 'created_at' => now(), 'updated_at' => now()]);
        $itemId = (string) Str::uuid7();
        DB::table('inventory_items')->insert(['id' => $itemId, 'listing_variant_id' => $variantId, 'quantity_on_hand' => '50', 'confirmed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);

        $sockets = stream_socket_pair(STREAM_PF_UNIX, STREAM_SOCK_STREAM, STREAM_IPPROTO_IP);
        self::assertNotFalse($sockets);
        $pid = pcntl_fork();
        self::assertNotSame(-1, $pid);
        if ($pid === 0) {
            fclose($sockets[0]);
            DB::purge('pgsql');
            fwrite($sockets[1], 'R');
            stream_set_timeout($sockets[1], 10);
            if (fread($sockets[1], 1) !== 'S') {
                exit(3);
            }
            $request = Request::create('/api/v1/vendor/inventory/items/'.$variantId, 'PATCH');
            $request->setUserResolver(fn () => $owner);
            $request->attributes->set('account_scope', ['organization_id' => $organization->id, 'role' => 'OWNER']);
            $request->attributes->set('correlation_id', (string) Str::uuid7());
            $reported = false;
            DB::listen(static function ($query) use ($sockets, &$reported): void {
                if (! $reported && str_contains($query->sql, 'vendor_memberships')) {
                    $reported = true;
                    fwrite($sockets[1], 'P');
                }
            });
            try {
                app(InventoryLedgerService::class)->adjust($request, $variantId, ['lock_version' => 1, 'quantity_on_hand' => '10', 'reason_code' => 'COUNT']);
                exit(2);
            } catch (AuthenticationException $exception) {
                exit($exception->errorCode === 'STALE_VERSION' && $exception->httpStatus === 409 ? 0 : 4);
            } catch (\Throwable) {
                exit(5);
            }
        }

        fclose($sockets[1]);
        stream_set_timeout($sockets[0], 10);
        $status = 0;
        try {
            self::assertSame('R', fread($sockets[0], 1), 'The child must release its inherited database connection.');
            DB::purge('pgsql');
            DB::beginTransaction();
            DB::table('vendor_organizations')->where('id', $organization->id)->lockForUpdate()->first();
            DB::table('inventory_items')->where('id', $itemId)->update(['quantity_on_hand' => '60', 'lock_version' => 2]);
            fwrite($sockets[0], 'S');
            self::assertSame('P', fread($sockets[0], 1), 'The child must resolve its authority before the first edit commits.');
            usleep(300000);
            self::assertSame(0, pcntl_waitpid($pid, $status, WNOHANG), 'The second editor must wait for the organization lock.');
            DB::commit();
            pcntl_waitpid($pid, $status);
            self::assertTrue(pcntl_wifexited($status));
            self::assertSame(0, pcntl_wexitstatus($status), 'The waiting editor must receive a stale-version conflict.');
        } finally {
            if (DB::transactionLevel() > 0) {
                DB::rollBack();
            }
            fclose($sockets[0]);
        }
        self::assertSame('60.0000', (string) DB::table('inventory_items')->where('id', $itemId)->value('quantity_on_hand'));
        self::assertSame(0, DB::table('inventory_movements')->where('inventory_item_id', $itemId)->count());
    }
}
