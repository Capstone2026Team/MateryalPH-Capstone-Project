<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\OutboxPublisher;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class IssueVendorInvitation
{
    public const ROLES = ['STORE_MANAGER', 'STORE_STAFF', 'CUSTOMER_SERVICE', 'INVENTORY', 'FULFILLMENT'];

    public function __construct(
        private readonly AccountAccess $access,
        private readonly AuditRecorder $audit,
        private readonly OutboxPublisher $outbox,
    ) {}

    /**
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function handle(Request $request, array $input): array
    {
        $scope = $this->access->resolve($request->user());
        if (! is_string($scope['organization_id'] ?? null) || ! in_array('staff.manage', $scope['permissions'], true)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'You cannot invite Vendor team accounts.', 403);
        }
        $role = strtoupper(trim((string) ($input['role'] ?? '')));
        if (! in_array($role, self::ROLES, true) || ($scope['role'] !== 'OWNER' && $role === 'STORE_MANAGER')) {
            throw new AuthenticationException('ROLE_UNAVAILABLE', 'This Vendor team role cannot be assigned by your account.', 422);
        }

        $email = mb_strtolower(trim((string) ($input['email'] ?? '')));
        $name = trim((string) ($input['invitee_name'] ?? ''));
        $mobile = isset($input['invitee_mobile']) ? trim((string) $input['invitee_mobile']) : null;
        $key = $request->header('Idempotency-Key');
        if (! is_string($key) || ! Str::isUuid($key)) {
            throw new AuthenticationException('IDEMPOTENCY_KEY_REQUIRED', 'A unique request identifier is required.', 422);
        }
        $organizationId = $scope['organization_id'];
        $requestHash = hash_hmac('sha256', implode('|', [$email, $name, $mobile ?? '', $role]), (string) config('app.key'));

        return DB::transaction(function () use ($request, $organizationId, $email, $name, $mobile, $role, $key, $requestHash): array {
            $previous = DB::table('idempotency_records')->where('actor_user_id', $request->user()->getKey())->where('endpoint', 'VENDOR_INVITATION')->where('idempotency_key', $key)->first();
            if ($previous !== null) {
                if (! hash_equals((string) $previous->request_hash, $requestHash) || ($previous->expires_at !== null && now()->greaterThanOrEqualTo($previous->expires_at))) {
                    throw new AuthenticationException('IDEMPOTENCY_CONFLICT', 'Use a new request identifier for a changed or expired invitation request.', 409);
                }

                return ['queued' => true, 'replayed' => true];
            }

            DB::table('idempotency_records')->insert([
                'id' => (string) Str::uuid7(), 'actor_user_id' => $request->user()->getKey(), 'endpoint' => 'VENDOR_INVITATION', 'idempotency_key' => $key,
                'request_hash' => $requestHash, 'response_status' => 202, 'expires_at' => now()->addDay(), 'created_at' => now(), 'updated_at' => now(),
            ]);

            $organization = DB::table('vendor_organizations')
                ->where('id', $organizationId)
                ->where('account_status', 'ACTIVE')
                ->where('store_setup_status', 'COMPLETED')
                ->first();
            if ($organization === null) {
                throw new AuthenticationException('TEAM_SETUP_REQUIRED', 'Complete and submit Store Setup before inviting team accounts.', 409);
            }
            if (DB::table('users')->whereRaw('LOWER(email) = ?', [$email])->where('account_type', '!=', 'VENDOR')->exists()) {
                throw new AuthenticationException('INVITATION_NOT_AVAILABLE', 'This team invitation cannot be issued.', 422);
            }
            if (DB::table('vendor_memberships')->where('vendor_organization_id', $organizationId)->whereIn('user_id', DB::table('users')->whereRaw('LOWER(email) = ?', [$email])->pluck('id'))->exists()) {
                throw new AuthenticationException('INVITATION_NOT_AVAILABLE', 'This person already belongs to the Vendor team.', 422);
            }

            DB::table('vendor_invitations')->where('vendor_organization_id', $organizationId)->where('normalized_email', $email)->whereNull('accepted_at')->update(['revoked_at' => now(), 'updated_at' => now()]);
            $token = bin2hex(random_bytes(32));
            $invitationId = (string) Str::uuid7();
            DB::table('vendor_invitations')->insert([
                'id' => $invitationId, 'vendor_organization_id' => $organizationId, 'invited_by_user_id' => $request->user()->getKey(), 'normalized_email' => $email,
                'role' => $role, 'can_manage_staff' => false, 'token_hash' => hash_hmac('sha256', $token, (string) config('app.key')), 'expires_at' => now()->addDay(),
                'invitee_name' => $name, 'invitee_mobile' => $mobile, 'created_at' => now(), 'updated_at' => now(),
            ]);
            $this->outbox->publish('VENDOR_INVITATION_REQUESTED', 'VENDOR_INVITATION', $invitationId, [
                'recipient' => $email, 'invitation_url' => rtrim((string) config('app.vendor_frontend_url'), '/').'/accept-invite?token='.urlencode($token),
            ]);
            $this->audit->account($request, 'VENDOR_INVITATION_CREATED', 'VENDOR_INVITATION', $invitationId, after: ['organization_id' => $organizationId, 'role' => $role, 'invitee_email' => 'REDACTED']);

            return ['queued' => true, 'invitation_id' => $invitationId, 'role' => $role, 'expires_at' => now()->addDay()->toIso8601String()];
        });
    }
}
