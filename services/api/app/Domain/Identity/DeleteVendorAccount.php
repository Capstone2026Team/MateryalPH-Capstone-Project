<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Authorization\RecentAuthentication;
use App\Domain\Disputes\DisputeRules;
use App\Domain\Operations\OutboxPublisher;
use App\Domain\Orders\OrderQueries;
use App\Models\AuthSession;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

/** Owner self-service closure. Commercial, compliance, tax and audit evidence remain immutable. */
final class DeleteVendorAccount
{
    public const CONFIRMATION = 'DELETE';

    public const RETAINED_RECORDS = [
        ['category' => 'Orders, quotations and invoices', 'purpose' => 'Accounting, contractual obligations and legal claims'],
        ['category' => 'Payments, refunds, commission and tax records', 'purpose' => 'Financial reconciliation and tax requirements'],
        ['category' => 'Business verification, disputes, reviews and reports', 'purpose' => 'Compliance, marketplace safety and legal claims'],
        ['category' => 'Security, team activity and audit records', 'purpose' => 'Security investigation and historical attribution'],
        ['category' => 'Agreement acceptances', 'purpose' => 'Evidence of accepted agreements and privacy notices'],
    ];

    public function __construct(
        private readonly AccountAccess $access,
        private readonly RecentAuthentication $recent,
        private readonly TokenSessionService $sessions,
        private readonly TotpService $totp,
        private readonly AuditRecorder $audit,
        private readonly ManageAccount $accounts,
        private readonly OutboxPublisher $outbox,
    ) {}

    /** @return array<string, mixed> */
    public function preview(Request $request): array
    {
        $organizationId = $this->ownerOrganization($request);

        return DB::transaction(function () use ($organizationId): array {
            DB::table('vendor_organizations')->where('id', $organizationId)->lockForUpdate()->firstOrFail();
            $blockers = $this->blockers($organizationId);

            return ['can_delete' => array_sum($blockers) === 0, 'blockers' => $blockers,
                'retained_records' => self::RETAINED_RECORDS, 'confirmation_phrase' => self::CONFIRMATION];
        });
    }

    /** @return array{reference: string, deleted_at: string, sign_in_required: true} */
    public function delete(Request $request): array
    {
        $organizationId = $this->ownerOrganization($request);
        $this->recent->require($request);
        $key = $request->header('Idempotency-Key');
        if (! is_string($key) || ! Str::isUuid($key)) {
            throw new AuthenticationException('IDEMPOTENCY_KEY_REQUIRED', 'A unique request identifier is required.', 422);
        }

        return DB::transaction(function () use ($request, $organizationId, $key): array {
            // New procurement and staff changes take this same organization lock first.
            $organization = DB::table('vendor_organizations')->where('id', $organizationId)->lockForUpdate()->firstOrFail();
            $this->ownerOrganization($request);
            $this->recent->require($request);
            if ($organization->account_status !== 'ACTIVE') {
                throw new AuthenticationException('ACCOUNT_DELETION_UNAVAILABLE', 'This store cannot be deleted here. Contact support.', 409);
            }
            $blockers = $this->blockers($organizationId);
            if (array_sum($blockers) !== 0) {
                throw new AuthenticationException('ACCOUNT_DELETION_BLOCKED', 'Resolve your open orders, payments, refunds, disputes and financial obligations before deleting this account.', 409, ['blockers' => $blockers]);
            }

            $deletedAt = now();
            $memberships = DB::table('vendor_memberships')->where('vendor_organization_id', $organizationId)->whereNull('deleted_at')->orderBy('id')->lockForUpdate()->get();
            $userIds = $memberships->pluck('user_id')->all();
            $owner = User::query()->whereKey($request->user()->getKey())->lockForUpdate()->firstOrFail();
            $email = $owner->email;
            if ($owner->profile_photo_key !== null && $owner->profile_photo_disk !== null) {
                $this->outbox->publish('DELETED_ACCOUNT_PHOTO_CLEANUP', 'USER', $owner->public_id,
                    ['user_id' => (int) $owner->getKey(), 'disk' => $owner->profile_photo_disk, 'key' => $owner->profile_photo_key]);
            }
            $owner->forceFill(['account_status' => 'DELETED', 'account_deleted_at' => $deletedAt,
                'name' => 'Deleted Vendor', 'email' => 'deleted-vendor-'.$owner->public_id.'@deleted.invalid',
                'email_verified_at' => null, 'password' => Hash::make(Str::random(64)), 'remember_token' => null,
                'profile_photo_key' => null, 'profile_photo_disk' => null, 'lock_version' => (int) $owner->lock_version + 1])->save();
            DB::table('user_profiles')->where('user_id', $owner->getKey())->update(['full_name' => 'Deleted Vendor', 'mobile_e164' => null, 'updated_at' => $deletedAt]);
            DB::table('external_identities')->where('user_id', $owner->getKey())->delete();
            DB::table('email_otps')->where(fn ($q) => $q->where('user_id', $owner->getKey())->orWhere('normalized_email', $email))
                ->update(['normalized_email' => $owner->email, 'invalidated_at' => $deletedAt, 'updated_at' => $deletedAt]);
            DB::table('account_email_changes')->where('user_id', $owner->getKey())->whereNull('completed_at')
                ->update(['normalized_email' => $owner->email, 'invalidated_at' => $deletedAt, 'updated_at' => $deletedAt]);
            DB::table('password_reset_tokens')->where('email', $email)->delete();
            $this->totp->revoke($owner);

            // Close organization access; staff identities/history are not the Owner's personal data to erase.
            DB::table('vendor_memberships')->whereIn('id', $memberships->pluck('id'))->update(['status' => 'DEACTIVATED',
                'can_manage_staff' => false, 'deactivated_at' => $deletedAt, 'updated_at' => $deletedAt]);
            DB::table('vendor_memberships')->whereIn('id', $memberships->pluck('id'))->where('role', '!=', 'OWNER')->update(['deleted_at' => $deletedAt]);
            DB::table('vendor_invitations')->where('vendor_organization_id', $organizationId)->whereNull('accepted_at')->whereNull('revoked_at')
                ->update(['revoked_at' => $deletedAt, 'updated_at' => $deletedAt]);
            foreach (AuthSession::query()->whereIn('user_id', $userIds)->whereNull('revoked_at')->orderBy('id')->lockForUpdate()->get() as $session) {
                $this->sessions->revoke($session, 'VENDOR_ACCOUNT_DELETED');
            }
            DB::table('notification_devices')->whereIn('user_id', $userIds)->whereNull('revoked_at')->update(['revoked_at' => $deletedAt, 'updated_at' => $deletedAt]);
            DB::table('trusted_devices')->where('user_id', $owner->getKey())->whereNull('revoked_at')->update(['revoked_at' => $deletedAt, 'updated_at' => $deletedAt]);
            DB::table('vendor_organizations')->where('id', $organizationId)->update(['account_status' => 'DELETED',
                'account_deleted_at' => $deletedAt, 'store_activation_status' => 'NOT_READY', 'marketplace_status' => 'NOT_ACTIVE',
                'marketplace_discoverability_status' => 'NOT_DISCOVERABLE', 'store_email' => null, 'store_email_verified_at' => null,
                'store_phone' => null, 'lock_version' => (int) $organization->lock_version + 1, 'updated_at' => $deletedAt]);
            DB::table('store_profiles')->where('vendor_organization_id', $organizationId)->update(['description' => null,
                'public_email' => null, 'public_phone' => null, 'logo_file_id' => null, 'banner_file_id' => null, 'updated_at' => $deletedAt]);
            $reference = 'AD-'.$deletedAt->clone()->setTimezone('Asia/Manila')->format('Y').'-'.strtoupper((string) Str::uuid7());
            $this->audit->account($request, 'VENDOR_ACCOUNT_DELETED', 'VENDOR_ORGANIZATION', $organizationId,
                ['account_status' => 'ACTIVE'], ['account_status' => 'DELETED', 'deletion_reference' => $reference]);
            DB::table('idempotency_records')->insert(['id' => (string) Str::uuid7(), 'actor_user_id' => $owner->getKey(),
                'endpoint' => 'VENDOR_ACCOUNT_DELETION', 'idempotency_key' => $key,
                'request_hash' => hash_hmac('sha256', $organizationId.'|'.$request->getContent(), (string) config('app.key')),
                'response_status' => 200, 'expires_at' => now()->addDay(), 'created_at' => $deletedAt, 'updated_at' => $deletedAt]);
            $this->accounts->notice($email, $owner->public_id, 'Your MateryalPH Vendor account was deleted. The store is closed and all team sessions were revoked. Reference '.$reference.'. Required commercial, tax, compliance and audit records are retained under the applicable retention schedule. Contact support if you did not request this.');

            return ['reference' => $reference, 'deleted_at' => $deletedAt->toIso8601String(), 'sign_in_required' => true];
        }, 3);
    }

    private function ownerOrganization(Request $request): string
    {
        $scope = $this->access->resolve($request->user());
        if ($request->user()->account_type !== 'VENDOR' || $scope['role'] !== 'OWNER' || $scope['organization_id'] === null
            || ! in_array('organization.delete', $scope['permissions'], true)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'Only the Vendor Owner can delete the store account.', 403);
        }

        return $scope['organization_id'];
    }

    /** @return array<string, int> */
    private function blockers(string $organizationId): array
    {
        return [
            'active_orders' => DB::table('orders')->where('vendor_organization_id', $organizationId)->whereNotIn('order_state', OrderQueries::VENDOR_GROUPS['CLOSED'])->count(),
            'pending_payments' => DB::table('payments')->where('vendor_organization_id', $organizationId)->whereIn('state', ['CREATING', 'PENDING', 'UNCERTAIN'])->count(),
            'unresolved_disputes' => DB::table('dispute_cases')->where('vendor_organization_id', $organizationId)->whereIn('status', DisputeRules::ACTIVE)->count(),
            'pending_refunds' => DB::table('refunds as r')->leftJoin('orders as o', 'o.id', '=', 'r.order_id')
                ->leftJoin('fee_statements as s', 's.id', '=', 'r.fee_statement_id')
                ->where(fn ($q) => $q->where('o.vendor_organization_id', $organizationId)->orWhere('s.vendor_organization_id', $organizationId))
                ->whereIn('r.state', ['REFUND_PENDING', 'REFUND_FAILED'])->count()
                + DB::table('physical_reimbursements as r')->join('physical_payment_records as p', 'p.id', '=', 'r.physical_payment_record_id')
                    ->join('orders as o', 'o.id', '=', 'p.order_id')->where('o.vendor_organization_id', $organizationId)->where('r.state', '!=', 'REIMBURSEMENT_CONFIRMED')->count(),
            'uncollected_payments' => DB::query()->fromSub(DB::table('physical_payment_records as p')->join('orders as o', 'o.id', '=', 'p.order_id')
                ->where('o.vendor_organization_id', $organizationId)->groupBy('p.order_id')
                ->havingRaw("NOT BOOL_OR(p.record_kind = 'CANCELLATION_RELEASE') AND MIN(p.remaining_obligation_centavos) > 0")->select('p.order_id'), 'uncollected')->count(),
            'outstanding_statements' => DB::table('fee_statements')->where('vendor_organization_id', $organizationId)->whereIn('state', ['DRAFT', 'ISSUED', 'PARTIALLY_PAID'])->where('outstanding_centavos', '>', 0)->count(),
            'unbilled_commissions' => DB::table('fee_assessments')->where('vendor_organization_id', $organizationId)->where('state', 'EARNED')->whereNull('billed_at')->whereColumn('earned_centavos', '>', 'credited_centavos')->count(),
            'finance_reviews' => DB::table('finance_review_items')->where('vendor_organization_id', $organizationId)->where('state', 'OPEN')->count(),
        ];
    }
}
