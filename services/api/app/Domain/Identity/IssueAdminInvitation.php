<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Domain\Agreements\AccountAgreements;
use App\Domain\Authorization\AccountAccess;
use App\Domain\Authorization\RecentAuthentication;
use App\Domain\Operations\OutboxPublisher;
use App\Models\AdminInvitation;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class IssueAdminInvitation
{
    public const ROLES = ['ADMIN_VENDOR_VERIFICATION', 'ADMIN_PRODUCT_COMPLIANCE', 'ADMIN_ORDER_DISPUTE', 'ADMIN_USER_MANAGEMENT', 'ADMIN_SUPPORT'];

    public function __construct(private readonly AccountAccess $access, private readonly RecentAuthentication $recent, private readonly AuditRecorder $audit, private readonly OutboxPublisher $outbox, private readonly AccountAgreements $agreements) {}

    public function handle(Request $request, string $email, string $roleId): void
    {
        if (! $this->access->allows($request->user(), 'admin.invite') || $this->access->resolve($request->user())['role'] !== 'ADMIN_SUPERADMIN') {
            throw new AuthenticationException('PERMISSION_DENIED', 'You cannot invite Admin accounts.', 403);
        }
        $this->recent->require($request);
        $this->agreements->requireCurrent($request);
        $key = $request->header('Idempotency-Key');
        if (! is_string($key) || ! Str::isUuid($key)) {
            throw new AuthenticationException('IDEMPOTENCY_KEY_REQUIRED', 'A unique request identifier is required.', 422);
        }
        DB::transaction(function () use ($request, $email, $roleId, $key): void {
            DB::table('users')->where('id', $request->user()->getKey())->lockForUpdate()->first();
            $this->recent->require($request);
            $role = DB::table('platform_roles')->where('id', $roleId)->where('platform', 'ADMIN')->whereIn('code', self::ROLES)->first();
            if ($role === null) {
                throw new AuthenticationException('ROLE_UNAVAILABLE', 'This role cannot be assigned.', 422);
            }
            $email = mb_strtolower(trim($email));
            $requestHash = hash_hmac('sha256', $email.'|'.$roleId, (string) config('app.key'));
            $previous = DB::table('idempotency_records')->where('actor_user_id', $request->user()->getKey())->where('endpoint', 'ADMIN_INVITATION')->where('idempotency_key', $key)->first();
            if ($previous !== null) {
                if (! hash_equals($previous->request_hash, $requestHash) || now()->greaterThanOrEqualTo($previous->expires_at)) {
                    throw new AuthenticationException('IDEMPOTENCY_CONFLICT', 'Use a new request identifier for a changed or expired invitation request.', 409);
                }

                return;
            }
            DB::table('idempotency_records')->insert(['id' => (string) Str::uuid7(), 'actor_user_id' => $request->user()->getKey(), 'endpoint' => 'ADMIN_INVITATION', 'idempotency_key' => $key, 'request_hash' => $requestHash, 'response_status' => 202, 'expires_at' => now()->addDay(), 'created_at' => now(), 'updated_at' => now()]);
            if (DB::table('users')->whereRaw('LOWER(email) = ?', [$email])->exists()) {
                return;
            }
            DB::table('admin_invitations')->where('normalized_email', $email)->whereNull('accepted_at')->update(['revoked_at' => now()]);
            $token = bin2hex(random_bytes(32));
            $invitation = AdminInvitation::query()->create([
                'normalized_email' => $email, 'platform_role_id' => $roleId, 'invited_by_user_id' => $request->user()->getKey(),
                'token_hash' => hash_hmac('sha256', $token, (string) config('app.key')), 'expires_at' => now()->addDay(), 'bootstrap' => false,
            ]);
            $this->outbox->publish('ADMIN_INVITATION_REQUESTED', 'ADMIN_INVITATION', (string) $invitation->getKey(), [
                'recipient' => $email, 'invitation_url' => rtrim((string) config('app.admin_frontend_url'), '/').'/accept-invite?token='.urlencode($token),
            ]);
            $this->audit->account($request, 'ADMIN_INVITATION_CREATED', 'ADMIN_INVITATION', (string) $invitation->getKey(), after: ['role' => $role->code]);
        });
    }
}
