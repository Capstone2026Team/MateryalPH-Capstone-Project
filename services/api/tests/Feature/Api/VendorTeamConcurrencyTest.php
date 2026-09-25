<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Identity\AcceptVendorInvitation;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Vendors\IssueVendorInvitation;
use App\Models\User;
use App\Models\VendorMembership;
use App\Models\VendorOrganization;
use Illuminate\Foundation\Testing\DatabaseMigrations;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Tests\TestCase;

final class VendorTeamConcurrencyTest extends TestCase
{
    use DatabaseMigrations;

    public function test_invitation_cannot_be_issued_after_delegation_is_revoked_while_request_waits_for_organization_lock(): void
    {
        [$organization, $manager, $membership] = $this->managerFixture();
        $email = 'concurrent-staff@example.test';
        $request = Request::create('/api/v1/vendors/account/invitations', 'POST');
        $request->headers->set('Idempotency-Key', (string) Str::uuid7());
        $request->setUserResolver(fn () => $manager);

        $this->runAgainstRevocation($organization, $membership, 'vendor_memberships', static function () use ($request, $email): void {
            app(IssueVendorInvitation::class)->handle($request, ['email' => $email, 'invitee_name' => 'Concurrent Staff', 'role' => 'STORE_STAFF']);
        });

        self::assertSame(0, DB::table('vendor_invitations')->where('normalized_email', $email)->count());
        self::assertSame(0, DB::table('idempotency_records')->where('endpoint', 'VENDOR_INVITATION')->count());
        self::assertSame(0, DB::table('outbox_events')->where('event_type', 'VENDOR_INVITATION_REQUESTED')->count());
    }

    public function test_invitation_acceptance_cannot_create_employee_after_inviter_delegation_is_revoked(): void
    {
        [$organization, $manager, $membership] = $this->managerFixture();
        $email = 'concurrent-acceptance@example.test';
        $token = bin2hex(random_bytes(32));
        $invitationId = (string) Str::uuid7();
        DB::table('vendor_invitations')->insert([
            'id' => $invitationId, 'vendor_organization_id' => $organization->getKey(), 'invited_by_user_id' => $manager->getKey(),
            'normalized_email' => $email, 'role' => 'STORE_STAFF', 'can_manage_staff' => false,
            'token_hash' => hash_hmac('sha256', $token, (string) config('app.key')),
            'expires_at' => now()->addDay(), 'created_at' => now(), 'updated_at' => now(),
        ]);
        $request = Request::create('/api/v1/auth/vendor-invitations/accept', 'POST');

        $this->runAgainstRevocation($organization, $membership, 'vendor_invitations', static function () use ($request, $token, $email): void {
            app(AcceptVendorInvitation::class)->handle($request, $token, $email, 'Concurrent Employee', 'StrongPassword123');
        });

        self::assertFalse(User::query()->where('email', $email)->exists());
        self::assertNull(DB::table('vendor_invitations')->where('id', $invitationId)->value('accepted_at'));
        self::assertSame(0, DB::table('audit_logs')->where('action', 'VENDOR_INVITATION_ACCEPTED')->count());
    }

    /** @return array{VendorOrganization, User, VendorMembership} */
    private function managerFixture(): array
    {
        $organization = VendorOrganization::query()->create(['legal_name' => 'Concurrency test store', 'store_name' => 'Concurrency test store']);
        $manager = User::factory()->create(['account_type' => 'VENDOR', 'account_status' => 'ACTIVE']);
        $membership = VendorMembership::query()->create([
            'vendor_organization_id' => $organization->getKey(), 'user_id' => $manager->getKey(),
            'role' => 'STORE_MANAGER', 'can_manage_staff' => true, 'status' => 'ACTIVE',
        ]);

        return [$organization, $manager, $membership];
    }

    /** @param callable(): void $operation */
    private function runAgainstRevocation(VendorOrganization $organization, VendorMembership $membership, string $preflightTable, callable $operation): void
    {
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
            $reported = false;
            DB::listen(static function ($query) use ($sockets, $preflightTable, &$reported): void {
                if (! $reported && str_contains($query->sql, $preflightTable)) {
                    $reported = true;
                    fwrite($sockets[1], 'P');
                }
            });
            try {
                $operation();
                exit(2);
            } catch (AuthenticationException $exception) {
                exit($exception->httpStatus === 403 || $exception->errorCode === 'VENDOR_INVITATION_INVALID' ? 0 : 4);
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
            DB::table('vendor_organizations')->where('id', $organization->getKey())->lockForUpdate()->first();
            DB::table('vendor_memberships')->where('id', $membership->getKey())->update(['can_manage_staff' => false]);
            fwrite($sockets[0], 'S');
            self::assertSame('P', fread($sockets[0], 1), 'The child must finish its preflight read before delegation revocation commits.');
            usleep(200000);
            self::assertSame(0, pcntl_waitpid($pid, $status, WNOHANG), 'The child must wait for the organization lock.');
            DB::commit();
            pcntl_waitpid($pid, $status);
            self::assertTrue(pcntl_wifexited($status));
            self::assertSame(0, pcntl_wexitstatus($status), 'The stale invitation operation must be denied.');
        } finally {
            if (DB::transactionLevel() > 0) {
                DB::rollBack();
            }
            fclose($sockets[0]);
        }
    }
}
