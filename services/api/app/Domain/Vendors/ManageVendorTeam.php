<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Agreements\AccountAgreements;
use App\Domain\Authorization\AccountAccess;
use App\Domain\Authorization\ManageMembership;
use App\Domain\Authorization\MembershipPolicy;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\TokenSessionService;
use App\Domain\Operations\OutboxPublisher;
use App\Models\AuthSession;
use App\Models\VendorMembership;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;

final class ManageVendorTeam
{
    public const STAFF_ROLES = ['STORE_STAFF', 'CUSTOMER_SERVICE', 'INVENTORY', 'FULFILLMENT'];

    public function __construct(private readonly OnboardingAccess $access, private readonly AccountAccess $accounts, private readonly AuditRecorder $audit, private readonly OutboxPublisher $outbox, private readonly ReviewVendorEvidence $notices) {}

    private function role(Request $request, string $organization, string $role, bool $delegation = false): void
    {
        $this->access->vendor($request, $organization, 'staff.manage', true);
        $scope = $this->accounts->resolve($request->user());
        if (! in_array($role, [...self::STAFF_ROLES, 'STORE_MANAGER'], true) || ($scope['role'] !== 'OWNER' && ($role === 'STORE_MANAGER' || $delegation)) || ($delegation && $role !== 'STORE_MANAGER')) {
            throw new AuthenticationException('ROLE_ASSIGNMENT_DENIED', 'This role or delegation cannot be assigned by your account.', 403);
        }
    }

    /** @return array<string, mixed> */
    public function read(Request $request, string $organization): array
    {
        $this->access->vendor($request, $organization, 'staff.manage');
        $members = DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->where('m.vendor_organization_id', $organization)->orderBy('m.id')->paginate($request->integer('per_page', 20), ['m.id', 'u.name', 'm.role', 'm.status', 'm.can_manage_staff', 'm.lock_version', 'm.created_at']);

        return ['members' => $members->items(), 'page' => $members->currentPage(), 'last_page' => $members->lastPage(), 'total' => $members->total()];
    }

    public function invite(Request $request, string $organization): void
    {
        $data = Validator::make($request->all(), ['full_name' => ['required', 'string', 'max:160'], 'email' => ['required', 'email:rfc', 'max:254'], 'telephone_e164' => ['nullable', 'regex:/^\+?[0-9 ()-]{7,20}$/'], 'role' => ['required', Rule::in([...self::STAFF_ROLES, 'STORE_MANAGER'])], 'can_manage_staff' => ['sometimes', 'boolean'], 'expires_at' => ['required', 'date', 'after:now', 'before:'.now()->addDays(30)->toIso8601String()]])->validate();
        $this->role($request, $organization, $data['role'], $data['can_manage_staff'] ?? false);
        $key = $request->header('Idempotency-Key');
        if (! is_string($key) || ! Str::isUuid($key)) {
            throw new AuthenticationException('IDEMPOTENCY_KEY_REQUIRED', 'A unique request identifier is required.', 422);
        }
        DB::transaction(function () use ($request, $organization, $data, $key): void {
            DB::table('vendor_organizations')->where('id', $organization)->lockForUpdate()->firstOrFail();
            $this->role($request, $organization, $data['role'], $data['can_manage_staff'] ?? false);
            $hash = hash_hmac('sha256', json_encode([$organization, $data], JSON_THROW_ON_ERROR), (string) config('app.key'));
            $prior = DB::table('idempotency_records')->where('actor_user_id', $request->user()->getKey())->where('endpoint', 'VENDOR_INVITATION')->where('idempotency_key', $key)->first();
            if ($prior !== null) {
                if (! hash_equals($prior->request_hash, $hash) || now()->greaterThanOrEqualTo($prior->expires_at)) {
                    throw new AuthenticationException('IDEMPOTENCY_CONFLICT', 'Use a new identifier for changed or expired requests.', 409);
                }

                return;
            }
            DB::table('idempotency_records')->insert(['id' => (string) Str::uuid7(), 'actor_user_id' => $request->user()->getKey(), 'endpoint' => 'VENDOR_INVITATION', 'idempotency_key' => $key, 'request_hash' => $hash, 'response_status' => 202, 'expires_at' => now()->addDay(), 'created_at' => now(), 'updated_at' => now()]);
            $id = (string) Str::uuid7();
            $token = bin2hex(random_bytes(32));
            $email = mb_strtolower(trim($data['email']));
            DB::table('vendor_invitations')->insert(['id' => $id, 'vendor_organization_id' => $organization, 'invited_by_user_id' => $request->user()->getKey(), 'normalized_email' => $email, 'full_name' => $data['full_name'], 'telephone_e164' => $data['telephone_e164'] ?? null, 'role' => $data['role'], 'can_manage_staff' => $data['can_manage_staff'] ?? false, 'token_hash' => hash_hmac('sha256', $token, (string) config('app.key')), 'expires_at' => $data['expires_at'], 'created_at' => now(), 'updated_at' => now()]);
            $this->outbox->publish('VENDOR_INVITATION_REQUESTED', 'VENDOR_INVITATION', $id, ['recipient' => $email, 'invitation_url' => rtrim((string) config('app.vendor_frontend_url'), '/').'/accept-invite?token='.urlencode($token)]);
            $this->audit->account($request, 'VENDOR_INVITATION_CREATED', 'VENDOR_INVITATION', $id, after: ['role' => $data['role'], 'can_manage_staff' => $data['can_manage_staff'] ?? false]);
            $this->notices->notice($organization, 'A team invitation was created. Review Team Accounts for the actor and assigned role.');
        });
    }

    public function revoke(Request $request, string $organization, string $invitation): void
    {
        $this->access->vendor($request, $organization, 'staff.manage', true);
        DB::transaction(function () use ($request, $organization, $invitation): void {
            $row = DB::table('vendor_invitations')->where('id', $invitation)->where('vendor_organization_id', $organization)->lockForUpdate()->first();
            if ($row === null) {
                throw new AuthenticationException('RESOURCE_NOT_FOUND', 'This invitation is unavailable.', 404);
            }
            $this->role($request, $organization, $row->role);
            $this->access->version($row, $request->integer('lock_version'));
            if ($row->accepted_at !== null) {
                throw new AuthenticationException('INVITATION_ACCEPTED', 'Manage the membership after acceptance.', 409);
            }
            DB::table('vendor_invitations')->where('id', $invitation)->update(['revoked_at' => now(), 'lock_version' => $row->lock_version + 1, 'updated_at' => now()]);
            $this->audit->account($request, 'VENDOR_INVITATION_REVOKED', 'VENDOR_INVITATION', $invitation);
            $this->notices->notice($organization, 'A team invitation was revoked. Review Team Accounts.');
        });
    }

    public function change(Request $request, string $organization, string $membership): void
    {
        $this->access->vendor($request, $organization, 'staff.manage', true);
        app(AccountAgreements::class)->requireCurrent($request);
        DB::transaction(function () use ($request, $organization, $membership): void {
            $target = VendorMembership::query()->whereKey($membership)->where('vendor_organization_id', $organization)->lockForUpdate()->first();
            if ($target === null) {
                throw new AuthenticationException('RESOURCE_NOT_FOUND', 'This membership is unavailable.', 404);
            }
            $this->access->version($target, $request->integer('lock_version'));
            if (! app(MembershipPolicy::class)->manage($request->user(), $target)) {
                throw new AuthenticationException('PERMISSION_DENIED', 'You cannot manage this membership.', 403);
            }
            if ($request->has('role')) {
                $role = $request->string('role')->toString();
                $this->role($request, $organization, $role);
                $before = ['role' => $target->role, 'can_manage_staff' => $target->can_manage_staff];
                $target->update(['role' => $role, 'can_manage_staff' => false]);
                DB::table('vendor_memberships')->where('id', $membership)->increment('lock_version');
                foreach (AuthSession::query()->where('user_id', $target->user_id)->whereNull('revoked_at')->orderBy('id')->lockForUpdate()->get() as $session) {
                    app(TokenSessionService::class)->revoke($session, 'MEMBERSHIP_CHANGED');
                }
                $this->audit->account($request, 'VENDOR_STAFF_ROLE_CHANGED', 'VENDOR_MEMBERSHIP', $membership, $before, ['role' => $role, 'can_manage_staff' => false]);
                $this->notices->notice($organization, 'A team fixed role changed. Review Team Accounts.');
            } elseif ($request->has('can_manage_staff')) {
                app(ManageMembership::class)->change($request, $membership, 'can_manage_staff', $request->boolean('can_manage_staff'));
            } else {
                app(ManageMembership::class)->change($request, $membership, 'status', $request->string('status')->toString());
            }
        });
    }
}
