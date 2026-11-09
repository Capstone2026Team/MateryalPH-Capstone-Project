<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\AdminAccess;
use App\Domain\Operations\OutboxPublisher;
use Carbon\CarbonImmutable;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\Str;

/** Business-event identity is Vendor scoped. Channel transport, attempts and backoff use the shared outbox. */
final class CommissionEmails
{
    public function eligible(): Builder
    {
        return DB::table('vendor_organizations')->where(fn (Builder $query) => $query->where('account_status', 'ACTIVE')->orWhereExists(fn (Builder $bills) => $bills->selectRaw('1')->from('fee_statements')->whereColumn('fee_statements.vendor_organization_id', 'vendor_organizations.id')->whereIn('state', ['ISSUED', 'PARTIALLY_PAID'])->where('outstanding_centavos', '>', 0)));
    }

    public function policy(string $policyId, int $oldBasisPoints, string $type): void
    {
        $policy = CommissionPolicyService::policies()->where('id', $policyId)->first();
        $title = ($type === 'RATE_CANCELLED' ? 'Cancelled commission change: ' : ($type === 'RATE_CORRECTED' ? 'Corrected commission change: ' : 'Commission rate update: '))
            .CommissionPolicyService::percent($oldBasisPoints).' → '.CommissionPolicyService::percent((int) $policy->commission_basis_points)
            .' effective '.CarbonImmutable::parse($policy->effective_from)->setTimezone('Asia/Manila')->format('M j, Y');
        $this->eligible()->select('id')->orderBy('id')->chunkById(100, function ($vendors) use ($policyId, $oldBasisPoints, $type, $title): void {
            foreach ($vendors as $vendor) {
                $this->record('POLICY', $policyId, (string) $vendor->id, $type, $title, 'Review the updated Commission Terms. Existing transactions keep their saved rate.', 'COMMISSION_POLICY', $oldBasisPoints);
            }
        });
    }

    public function statement(string $statementId): void
    {
        $statement = DB::table('fee_statements')->where('id', $statementId)->first();
        $this->record('STATEMENT', $statementId, (string) $statement->vendor_organization_id, 'STATEMENT_ISSUED',
            'Commission statement '.$statement->statement_reference.' issued',
            'Your commission statement for '.CarbonImmutable::parse($statement->period_start)->format('F Y').' is ready. '
            .((int) $statement->balance_centavos === 0 ? 'No payment needed.' : 'P'.WithholdingThresholdService::pesos((int) $statement->balance_centavos).' due '.$statement->due_on.'.')
            .' TEST/DEMO — no automatic debit, real funds or BIR filing.', PlatformFeeInvoiceService::TEMPLATE);
    }

    private function record(string $subjectType, string $subjectId, string $vendorId, string $type, string $title, string $body, string $template, ?int $oldRate = null): void
    {
        if (DB::transactionLevel() < 1) {
            throw new \LogicException('Commission notices require the business transaction.');
        }
        $eventId = (string) Str::uuid7();
        $key = $subjectId.':'.$vendorId.':'.$type;
        if (DB::table('commission_email_events')->insertOrIgnore(['id' => $eventId, 'event_key' => $key, 'subject_type' => $subjectType, 'subject_id' => $subjectId,
            'vendor_organization_id' => $vendorId, 'notification_type' => $type, 'old_basis_points' => $oldRate, 'created_at' => now()]) === 0) {
            return;
        }
        // Financial notices go to one verified Owner account, never a staff or unverified public store address.
        $owner = DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->where('m.vendor_organization_id', $vendorId)
            ->where('m.role', 'OWNER')->where('m.status', 'ACTIVE')->whereNull('m.deleted_at')->where('u.account_status', 'ACTIVE')->whereNotNull('u.email_verified_at')
            ->whereNotNull('u.email')->orderBy('u.id')->first(['u.id']);
        if ($owner === null) {
            return; // Visible BLOCKED delivery; there is no eligible verified destination to send to.
        }
        $noticeId = (string) Str::uuid7();
        DB::table('notifications')->insert(['id' => $noticeId, 'user_id' => $owner->id, 'category' => FinanceNotifier::MANDATORY,
            'title' => mb_substr($title, 0, 255), 'body' => $body, 'resource_type' => $subjectType === 'POLICY' ? 'VENDOR_ORGANIZATION' : 'FEE_STATEMENT',
            'resource_id' => $subjectType === 'POLICY' ? $vendorId : $subjectId, 'vendor_organization_id' => $vendorId,
            'event_key' => hash('sha256', $key), 'created_at' => now(), 'updated_at' => now()]);
        DB::table('commission_email_events')->where('id', $eventId)->update(['notification_id' => $noticeId]);
        app(OutboxPublisher::class)->publish($template, 'VENDOR_ORGANIZATION', $vendorId, ['notification_id' => $noticeId]);
    }

    /** @return array<string, int> */
    public function summary(string $subjectType, string $subjectId): array
    {
        $row = DB::table('commission_email_events as e')->leftJoin('notification_deliveries as d', fn ($join) => $join->on('d.notification_id', '=', 'e.notification_id')->where('d.channel', 'EMAIL'))
            ->where('e.subject_type', $subjectType)->where('e.subject_id', $subjectId)
            ->selectRaw("COUNT(*) AS total, COUNT(*) FILTER (WHERE d.state = 'SENT') AS sent, COUNT(*) FILTER (WHERE d.state = 'FAILED') AS failed,
                COUNT(*) FILTER (WHERE d.state IN ('QUEUED', 'RETRY') OR (d.id IS NULL AND e.notification_id IS NOT NULL)) AS queued,
                COUNT(*) FILTER (WHERE d.state IN ('REVOKED', 'SKIPPED') OR e.notification_id IS NULL) AS blocked")->first();

        return array_map('intval', (array) $row);
    }

    /** @return list<array<string, mixed>> */
    public function activity(string $subjectType, string $subjectId): array
    {
        return DB::table('commission_email_events as e')->leftJoin('notification_deliveries as d', fn ($join) => $join->on('d.notification_id', '=', 'e.notification_id')->where('d.channel', 'EMAIL'))
            ->where('e.subject_type', $subjectType)->where('e.subject_id', $subjectId)->orderBy('e.created_at')->get(['e.id', 'e.notification_type', 'e.notification_id', 'e.created_at', 'd.state', 'd.attempt_count', 'd.delivered_at', 'd.failure_code'])
            ->map(fn (object $row): array => ['id' => $row->id, 'type' => $row->notification_type, 'state' => $row->state ?? ($row->notification_id === null ? 'BLOCKED' : 'QUEUED'),
                'attempts' => (int) $row->attempt_count, 'sent_at' => $row->delivered_at === null ? null : CarbonImmutable::parse($row->delivered_at)->toIso8601String(),
                'last_error' => $row->failure_code ?? ($row->notification_id === null ? 'VERIFIED_OWNER_EMAIL_REQUIRED' : null), 'created_at' => CarbonImmutable::parse($row->created_at)->toIso8601String()])->all();
    }

    /** @return array<string, mixed> */
    public function resend(Request $request, string $eventId): array
    {
        $event = DB::table('commission_email_events')->where('id', $eventId)->first();
        if ($event === null) {
            throw new AuthenticationException('COMMISSION_EMAIL_NOT_FOUND', 'This email activity is unavailable.', 404);
        }
        app(AdminAccess::class)->require($request, 'finance.view', $event->subject_type === 'POLICY' ? 'platform_settings.manage' : 'finance.approve_statements');

        return app(AdminAccess::class)->idempotent($request, 'COMMISSION_EMAIL_RESEND:'.$eventId, function () use ($request, $event): array {
            $delivery = DB::table('notification_deliveries')->where('notification_id', $event->notification_id)->where('channel', 'EMAIL')->lockForUpdate()->first();
            if ($delivery === null || ! in_array($delivery->state, ['SENT', 'FAILED'], true)) {
                throw new AuthenticationException('COMMISSION_EMAIL_NOT_RESENDABLE', 'Only a sent or failed email can be resent. Queued emails retry automatically.', 409);
            }
            $key = 'commission-email-resend:'.$event->id;
            if (RateLimiter::tooManyAttempts($key, 1)) {
                throw new AuthenticationException('COMMISSION_EMAIL_RATE_LIMITED', 'Wait one minute before resending this email again.', 429);
            }
            RateLimiter::hit($key, 60);
            DB::table('notification_deliveries')->where('id', $delivery->id)->update(['state' => 'QUEUED', 'retry_after_attempt' => (int) $delivery->attempt_count, 'failure_code' => null, 'available_at' => now(), 'updated_at' => now()]);
            app(OutboxPublisher::class)->publish('NOTIFICATION_DELIVERY', 'NOTIFICATION_DELIVERY', (string) $delivery->id, ['delivery_id' => (string) $delivery->id]);
            app(AuditRecorder::class)->account($request, 'COMMISSION_EMAIL_RESENT', 'COMMISSION_EMAIL_EVENT', (string) $event->id, after: ['previous_state' => $delivery->state, 'previous_attempts' => (int) $delivery->attempt_count]);

            return ['queued' => true];
        })['result'];
    }

    /** @return array<string, mixed> */
    public function resendFailed(Request $request, string $policyId): array
    {
        app(AdminAccess::class)->require($request, 'finance.view', 'platform_settings.manage');

        return app(AdminAccess::class)->idempotent($request, 'COMMISSION_EMAIL_RESEND_FAILED:'.$policyId, function () use ($request, $policyId): array {
            $queued = 0;
            foreach ($this->activity('POLICY', $policyId) as $event) {
                if ($event['state'] === 'FAILED') {
                    $this->resend($request, $event['id']);
                    $queued++;
                }
            }

            return ['queued' => $queued];
        })['result'];
    }

    public function reminders(): void
    {
        if (! config('finance.commission_reminder_enabled')) {
            return;
        }
        $next = CommissionPolicyService::next();
        if ($next !== null && CarbonImmutable::parse($next->effective_from)->lessThanOrEqualTo(CarbonImmutable::now()->addDays((int) config('finance.commission_reminder_days', 3)))) {
            DB::transaction(fn () => $this->policy((string) $next->id, (int) CommissionPolicyService::current()->commission_basis_points, 'RATE_REMINDER'));
        }
    }
}
