<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Domain\Authorization\RecentAuthentication;
use App\Domain\Disputes\DisputeRules;
use App\Domain\Orders\OrderQueries;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Buyer self-service account deletion (Buyer Workflow §Account; System Workflow §Privacy, Retention and Account Deletion).
 * The Buyer sees the retained-record exceptions first. Deletion is refused while an order, dispute or refund is still
 * open. Otherwise, in one transaction, the account is deactivated as DELETED (final, never restored by enforcement), every
 * session, push device and authenticator is revoked. The deletion reference is recorded in the existing audit trail.
 * Commercial and audit history is never deleted.
 */
final class DeleteBuyerAccount
{
    public const CONFIRMATION = 'DELETE';

    /** Shown before confirmation; these categories outlive the account for the stated purposes. */
    public const RETAINED_RECORDS = [
        ['category' => 'Orders, quotations and invoices', 'purpose' => 'Tax, accounting and Vendor records'],
        ['category' => 'Payments and refunds', 'purpose' => 'Financial reconciliation and fraud prevention'],
        ['category' => 'Disputes, reviews you posted and reports', 'purpose' => 'Marketplace safety and legal claims'],
        ['category' => 'Security and audit logs', 'purpose' => 'Account security and incident investigation'],
        ['category' => 'Agreement acceptances', 'purpose' => 'Proof of the Terms and Privacy Notice you accepted'],
    ];

    public function __construct(
        private readonly RecentAuthentication $recent,
        private readonly ManageAccount $accounts,
        private readonly TotpService $totp,
        private readonly AuditRecorder $audit,
    ) {}

    /** @return array{can_delete: bool, blockers: array{active_orders: int, active_disputes: int, pending_refunds: int}, retained_records: list<array{category: string, purpose: string}>, confirmation_phrase: string} */
    public function preview(Request $request): array
    {
        $blockers = $this->blockers($request->user());

        return [
            'can_delete' => array_sum($blockers) === 0,
            'blockers' => $blockers,
            'retained_records' => self::RETAINED_RECORDS,
            'confirmation_phrase' => self::CONFIRMATION,
        ];
    }

    /** @return array{reference: string, deleted_at: string, sign_in_required: true} */
    public function delete(Request $request): array
    {
        $this->recent->require($request);

        return DB::transaction(function () use ($request): array {
            $user = User::query()->whereKey($request->user()->getKey())->lockForUpdate()->firstOrFail();
            $this->recent->require($request);
            if ($user->account_type !== 'BUYER' || $user->account_status !== 'ACTIVE') {
                throw new AuthenticationException('ACCOUNT_DELETION_UNAVAILABLE', 'This account cannot be deleted here. Contact MateryalPH support.', 409);
            }
            $blockers = $this->blockers($user);
            if (array_sum($blockers) > 0) {
                throw new AuthenticationException('ACCOUNT_DELETION_BLOCKED', 'Finish or close your open orders, disputes and refunds before deleting your account.', 409, ['blockers' => $blockers]);
            }

            $deletedAt = now();
            $user->forceFill(['account_status' => 'DELETED', 'account_deleted_at' => $deletedAt, 'lock_version' => (int) $user->lock_version + 1])->save();
            $this->totp->revoke($user);
            DB::table('notification_devices')->where('user_id', $user->getKey())->whereNull('revoked_at')->update(['revoked_at' => $deletedAt, 'updated_at' => $deletedAt]);
            $this->accounts->revokeSessions($request, 'ALL');
            $reference = 'AD-'.$deletedAt->clone()->setTimezone('Asia/Manila')->format('Y').'-'.strtoupper((string) Str::uuid7());
            $this->audit->account($request, 'ACCOUNT_DELETED', 'USER', $user->public_id, ['account_status' => 'ACTIVE'], ['account_status' => 'DELETED', 'deletion_reference' => $reference]);
            $this->accounts->notice($user->email, $user->public_id, 'Your MateryalPH Buyer account was deleted and signed out everywhere. Reference '.$reference.'. Records we must keep by law are retained and minimized. Contact support if you did not request this.');

            return ['reference' => $reference, 'deleted_at' => $deletedAt->toIso8601String(), 'sign_in_required' => true];
        });
    }

    /** @return array{active_orders: int, active_disputes: int, pending_refunds: int} */
    private function blockers(User $user): array
    {
        $buyerProfileId = DB::table('buyer_profiles')->where('user_id', $user->getKey())->value('id');
        if ($buyerProfileId === null) {
            return ['active_orders' => 0, 'active_disputes' => 0, 'pending_refunds' => 0];
        }

        return [
            'active_orders' => DB::table('orders')->where('buyer_profile_id', $buyerProfileId)->whereNotIn('order_state', OrderQueries::VENDOR_GROUPS['CLOSED'])->count(),
            'active_disputes' => DB::table('dispute_cases')->where('buyer_profile_id', $buyerProfileId)->whereIn('status', DisputeRules::ACTIVE)->count(),
            'pending_refunds' => DB::table('refunds as r')->join('orders as o', 'o.id', '=', 'r.order_id')
                ->where('o.buyer_profile_id', $buyerProfileId)->where('r.state', 'REFUND_PENDING')->count(),
        ];
    }
}
