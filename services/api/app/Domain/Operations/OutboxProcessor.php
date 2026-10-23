<?php

declare(strict_types=1);

namespace App\Domain\Operations;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Authorization\VendorTeamActivityBroadcast;
use App\Domain\Catalog\EligibilityInvalidation;
use App\Domain\Catalog\EligibleOfferQuery;
use App\Domain\Disputes\DisputeAccess;
use App\Domain\Disputes\DisputeChannel;
use App\Domain\Disputes\DisputeExportService;
use App\Domain\Finance\RemittanceAssessmentService;
use App\Domain\Finance\WithholdingThresholdService;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\EmailOtpService;
use App\Domain\Messaging\ConversationBroadcast;
use App\Domain\Notifications\MailDeliveryPolicy;
use App\Domain\Notifications\MailProvider;
use App\Domain\Notifications\NavigationBroadcast;
use App\Domain\Notifications\NotificationBroadcast;
use App\Domain\Notifications\NotificationDelivery;
use App\Domain\Notifications\NotificationService;
use App\Domain\Payments\PaymentGateway;
use App\Domain\Payments\PaymentProviderException;
use App\Domain\Payments\PaymentReconciliationService;
use App\Domain\Payments\RefundService;
use App\Domain\Payments\XenditWebhookProcessor;
use App\Domain\Reporting\DocumentExportService;
use App\Domain\Support\SupportGuestAccess;
use App\Domain\Vendors\FleetBroadcast;
use App\Mail\AccountSecurityMail;
use App\Mail\AdminInvitationMail;
use App\Mail\EmailOtpMail;
use App\Mail\FinanceNoticeMail;
use App\Mail\OrderNoticeMail;
use App\Mail\ProductComplianceNoticeMail;
use App\Mail\VendorInventoryNoticeMail;
use App\Mail\VendorInvitationMail;
use App\Mail\VendorOnboardingNoticeMail;
use App\Models\User;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use RuntimeException;
use SensitiveParameter;
use Throwable;

final class OutboxProcessor
{
    public const MAX_ATTEMPTS = 5;

    public function process(string $eventId): void
    {
        Cache::lock('outbox-event:'.$eventId, 120)->block(5, function () use ($eventId): void {
            $event = ImportedOutboxBoundary::apply(DB::table('outbox_events'))->where('id', $eventId)->first();
            if ($event === null || $event->processed_at !== null || (int) $event->attempts >= self::MAX_ATTEMPTS) {
                return;
            }

            try {
                /** @var array{sealed_payload?: mixed} $envelope */
                $envelope = json_decode((string) $event->payload, true, flags: JSON_THROW_ON_ERROR);
                if (! is_string($envelope['sealed_payload'] ?? null)) {
                    throw new RuntimeException('The outbox event has no sealed payload.');
                }

                /** @var array<string, mixed> $payload */
                $payload = json_decode(Crypt::decryptString($envelope['sealed_payload']), true, flags: JSON_THROW_ON_ERROR);
                $invalidInvitation = in_array($event->event_type, ['VENDOR_INVITATION_REQUESTED', 'ADMIN_INVITATION_REQUESTED', 'ADMIN_BOOTSTRAP_INVITATION_REQUESTED'], true)
                    && ! $this->invitationCurrent($event, $payload);
                $invalidOtp = $event->event_type === 'AUTH_EMAIL_OTP_REQUESTED'
                    && ($event->aggregate_type !== 'EMAIL_OTP' || ! app(EmailOtpService::class)->canDeliver(
                        (string) $event->aggregate_id, $this->requiredString($payload, 'recipient'),
                        $this->requiredString($payload, 'purpose'), $this->requiredString($payload, 'code'),
                    ));
                if ($invalidInvitation || $invalidOtp) {
                    DB::table('outbox_events')->where('id', $eventId)->update(['processed_at' => now(), 'updated_at' => now()]);

                    return;
                }
                if (in_array($event->event_type, ['ORDER_STATE_CHANGED', 'ORDER_SUBMITTED', 'CONVERSATION_CHANGED', 'DISPUTE_CASE_CHANGED', 'CART_CHANGED', 'NAVIGATION_CHANGED'], true)) {
                    app(NavigationBroadcast::class)->deliver((string) $event->aggregate_type, (string) $event->aggregate_id,
                        is_string($payload['permission'] ?? null) ? $payload['permission'] : null);
                }
                if ($event->event_type === 'DISPUTE_CASE_CHANGED' && DB::table('enforcement_actions')->where('dispute_case_id', $event->aggregate_id)->where('state', 'REFERRED')->exists()) {
                    app(NavigationBroadcast::class)->deliver('ENFORCEMENT_QUEUE', (string) $event->aggregate_id, 'enforcement.view');
                }
                $this->deliver((string) $event->event_type, $payload, (string) $event->created_at);

                DB::table('outbox_events')
                    ->where('id', $eventId)
                    ->whereNull('processed_at')
                    ->update(['processed_at' => now(), 'updated_at' => now()]);
            } catch (Throwable $exception) {
                $attempt = (int) $event->attempts + 1;
                DB::table('outbox_events')
                    ->where('id', $eventId)
                    ->increment('attempts', 1, ['available_at' => now()->addSeconds([30, 120, 300, 900, 900][min(4, $attempt - 1)]), 'updated_at' => now()]);

                if ($attempt >= self::MAX_ATTEMPTS && $event->event_type === 'DOCUMENT_EXPORT_REQUESTED') {
                    DB::table('data_exports')->where('id', $event->aggregate_id)->where('state', 'QUEUED')->update(['state' => 'FAILED', 'failure_code' => 'GENERATION_FAILED', 'updated_at' => now()]);
                }

                if ($attempt >= self::MAX_ATTEMPTS && $event->event_type !== 'NAVIGATION_CHANGED') {
                    // A failed invalidation cannot recursively create further invalidation jobs.
                    app(OutboxPublisher::class)->publish('NAVIGATION_CHANGED', 'OUTBOX_EVENT', $eventId, ['permission' => 'integrations.view']);
                }

                throw $exception;
            }
        });
    }

    /** @param array<string, mixed> $payload */
    private function invitationCurrent(object $event, #[SensitiveParameter] array $payload): bool
    {
        $vendor = $event->event_type === 'VENDOR_INVITATION_REQUESTED';
        $invitation = DB::table($vendor ? 'vendor_invitations' : 'admin_invitations')->where('id', $event->aggregate_id)->first();
        if ($invitation === null || ($vendor && $invitation->deleted_at !== null) || $invitation->accepted_at !== null || $invitation->revoked_at !== null || now()->greaterThanOrEqualTo($invitation->expires_at)
            || ($payload['recipient'] ?? null) !== $invitation->normalized_email) {
            return false;
        }
        if ($vendor) {
            $actor = User::query()->find($invitation->invited_by_user_id);
            if (! $actor instanceof User) {
                return false;
            }
            try {
                $scope = app(AccountAccess::class)->resolve($actor);
            } catch (AuthenticationException) {
                return false;
            }

            return $scope['organization_id'] === $invitation->vendor_organization_id && in_array('staff.manage', $scope['permissions'], true)
                && ($invitation->role !== 'STORE_MANAGER' || $scope['role'] === 'OWNER');
        }

        if ($invitation->bootstrap) {
            return true;
        }
        $actor = User::query()->find($invitation->invited_by_user_id);
        if (! $actor instanceof User) {
            return false;
        }
        try {
            return $actor->account_type === 'ADMIN' && app(AccountAccess::class)->allows($actor, 'admin.invite');
        } catch (AuthenticationException) {
            return false;
        }
    }

    /**
     * Committed order and fee domain events. They are the durable integration record for later consumers
     * (realtime order milestones, push, finance statements); in this release they have no external side effect.
     */
    private const RECORDED_DOMAIN_EVENTS = ['ORDER_STATE_CHANGED', 'ORDER_SUBMITTED', 'ORDER_VENDOR_CONFIRMED', 'ORDER_AUTO_ACCEPT_EVALUATED', 'ORDER_ACCEPTED', 'NRPC_PROPOSED', 'NRPC_DECIDED', 'NRPC_FLAGGED',
        'FEE_ASSESSMENT_ESTIMATED', 'FEE_ASSESSMENT_EARNED', 'FEE_ASSESSMENT_CANCELLED', 'INVENTORY_RESERVATION_RELEASED', 'ORDER_COMPLETED', 'ORDER_CANCELLED',
        'PROJECT_CREATED', 'PROJECT_UPDATED', 'PROJECT_DELETED', 'WORK_PACKAGE_DRAFT_SAVED', 'WORK_PACKAGE_VERSION_CREATED', 'WORK_PACKAGE_UPDATED', 'WORK_PACKAGE_REACTIVATED', 'WORK_PACKAGE_ACTIVATED',
        'WORK_PACKAGE_CANCELLED', 'WORK_PACKAGE_DELETED', 'WORK_PACKAGE_MISSING_LINE_RESOLVED', 'PROJECT_ESTIMATE_COMPILED', 'PROJECT_VENDOR_INQUIRY_CREATED',
        'PROJECT_VENDOR_SELECTED', 'PROJECT_BUDGET_OVERRIDE_RECORDED', 'PROJECT_RANKING_PREFERENCES_UPDATED', 'WORK_PACKAGE_DRAFT_DELETED'];

    /** @param array<string, mixed> $payload */
    private function deliver(string $eventType, #[SensitiveParameter] array $payload, string $requestedAt): void
    {
        if ($eventType === 'SUPPORT_GUEST_EMAIL') {
            app(SupportGuestAccess::class)->deliver($this->requiredString($payload, 'credential_id'), $this->requiredString($payload, 'token'), $requestedAt);

            return;
        }
        if (in_array($eventType, ['CART_CHANGED', 'NAVIGATION_CHANGED'], true)) {
            return;
        }
        if ($eventType === VendorTeamActivityBroadcast::EVENT) {
            app(VendorTeamActivityBroadcast::class)->deliver($this->requiredString($payload, 'vendor_organization_id'), $this->requiredString($payload, 'actor_role'));

            return;
        }
        if ($eventType === 'NOTIFICATION_DELIVERY') {
            app(NotificationDelivery::class)->send($this->requiredString($payload, 'delivery_id'));

            return;
        }
        if ($eventType === 'DOCUMENT_EXPORT_REQUESTED') {
            app(DocumentExportService::class)->process($this->requiredString($payload, 'export_id'));

            return;
        }
        if ($eventType === 'NOTIFICATIONS_CHANGED') {
            app(NotificationBroadcast::class)->deliver($this->requiredInteger($payload, 'user_id'));

            return;
        }
        if (in_array($eventType, ['NOTIFICATION_READY', 'FINANCE_NOTICE', 'ORDER_NOTICE', 'DISPUTE_NOTICE', 'VENDOR_ONBOARDING_NOTICE', 'PRODUCT_COMPLIANCE_NOTICE', 'VENDOR_INVENTORY_NOTICE', 'ACCOUNT_SECURITY_NOTICE'], true) && is_string($payload['notification_id'] ?? null)) {
            app(NotificationService::class)->enqueue($payload['notification_id'], $eventType,
                $eventType === 'ACCOUNT_SECURITY_NOTICE' && is_string($payload['recipient'] ?? null) ? $payload['recipient'] : null);
            app(NotificationBroadcast::class)->created($payload['notification_id']);

            return;
        }
        if ($eventType === 'VENDOR_FLEET_CHANGED' || ($eventType === 'ORDER_STATE_CHANGED' && str_contains((string) ($payload['changes'] ?? ''), 'OUT_FOR_DELIVERY'))) {
            app(FleetBroadcast::class)->deliver($this->requiredString($payload, 'vendor_organization_id'));

            return;
        }
        if ($eventType === 'CONVERSATION_CHANGED') {
            app(ConversationBroadcast::class)->deliver($this->requiredString($payload, 'conversation_id'));

            return;
        }
        if ($this->deliverDisputeEvent($eventType, $payload, $requestedAt)) {
            return;
        }
        if ($eventType === EligibilityInvalidation::EVENT) {
            EligibleOfferQuery::invalidate();

            return;
        }
        if (in_array($eventType, self::RECORDED_DOMAIN_EVENTS, true)) {
            return;
        }
        if ($this->deliverPaymentEvent($eventType, $payload)) {
            return;
        }
        $recipient = $payload['recipient'] ?? null;
        if (! is_string($recipient)) {
            throw new RuntimeException('The outbox email recipient is invalid.');
        }

        $mail = match ($eventType) {
            'VENDOR_INVITATION_REQUESTED' => new VendorInvitationMail(
                $this->requiredString($payload, 'invitation_url'),
            ),
            'ACCOUNT_SECURITY_NOTICE' => new AccountSecurityMail(
                $this->requiredString($payload, 'message'),
            ),
            'AUTH_EMAIL_OTP_REQUESTED' => new EmailOtpMail(
                $this->requiredString($payload, 'code'),
                $this->requiredString($payload, 'purpose'),
                $this->requiredInteger($payload, 'ttl_minutes'),
            ),
            'ADMIN_BOOTSTRAP_INVITATION_REQUESTED', 'ADMIN_INVITATION_REQUESTED' => new AdminInvitationMail(
                $this->requiredString($payload, 'invitation_url'),
            ),
            'VENDOR_ONBOARDING_NOTICE' => new VendorOnboardingNoticeMail(
                $this->requiredString($payload, 'message'),
            ),
            'PRODUCT_COMPLIANCE_NOTICE' => new ProductComplianceNoticeMail(
                $this->requiredString($payload, 'message'),
            ),
            'VENDOR_INVENTORY_NOTICE' => new VendorInventoryNoticeMail(
                $this->requiredString($payload, 'subject'),
                $this->requiredString($payload, 'message'),
            ),
            'ORDER_NOTICE' => new OrderNoticeMail(
                $this->requiredString($payload, 'subject'),
                $this->requiredString($payload, 'message'),
            ),
            'FINANCE_NOTICE' => new FinanceNoticeMail(
                $this->requiredString($payload, 'subject'),
                $this->requiredString($payload, 'message'),
            ),
            default => throw new RuntimeException('Unsupported outbox event type.'),
        };
        if (app(MailDeliveryPolicy::class)->allows($requestedAt)) {
            app(MailProvider::class)->send($recipient, $mail);
        }
    }

    /**
     * Phase 11 post-commit work: webhook processing, merchant-remittance assessment after a verified capture,
     * technical-compensation refunds and best-effort provider session cancellation. None of it runs under a lock
     * held by the transaction that published it.
     *
     * @param  array<string, mixed>  $payload
     */
    private function deliverPaymentEvent(string $eventType, array $payload): bool
    {
        switch ($eventType) {
            case 'XENDIT_WEBHOOK_RECEIVED':
                // A failed provider read leaves the inbox row RECEIVED; scheduled reconciliation retries it.
                app(XenditWebhookProcessor::class)->process($this->requiredString($payload, 'webhook_event_id'));

                return true;
            case 'PAYMENT_CAPTURED':
                $paymentId = $this->requiredString($payload, 'payment_id');
                if (($payload['purpose'] ?? null) !== 'PLATFORM_FEE_PAYMENT') {
                    try {
                        app(RemittanceAssessmentService::class)->assessCollection($paymentId, is_string($payload['correlation_id'] ?? null) ? $payload['correlation_id'] : null);
                    } catch (AuthenticationException $exception) {
                        $payment = DB::table('payments')->where('id', $paymentId)->first(['vendor_organization_id']);
                        app(WithholdingThresholdService::class)->reviewItem('TEST', $payment?->vendor_organization_id, 'BASE_REVIEW_REQUIRED', $paymentId, $exception->errorCode,
                            'The verified collection could not be assessed automatically: '.$exception->getMessage(), [], [], 'PAYMENT');
                    }
                }

                return true;
            case 'PAYMENT_REFUND_REQUESTED':
                // Initiation only; REFUNDED waits for a verified provider event or reconciliation.
                app(RefundService::class)->send($this->requiredString($payload, 'refund_id'), (string) ($payload['correlation_id'] ?? ''));

                return true;
            case 'PAYMENT_SESSION_CANCEL_REQUESTED':
                $payment = DB::table('payments')->where('id', $this->requiredString($payload, 'payment_id'))->first();
                if ($payment !== null && $payment->provider_session_id !== null) {
                    try {
                        app(PaymentGateway::class)->cancelSession((string) $payment->provider_session_id, PaymentReconciliationService::forUserId($payment));
                    } catch (PaymentProviderException) {
                        // The provider expiry equals the attempt expiry; a later capture is compensated.
                    }
                }

                return true;
            case 'PAYMENT_ATTEMPT_CREATED': case 'WITHHOLDING_ACCUMULATOR_POSTED': case 'FEE_STATEMENT_DRAFTED': case 'FEE_STATEMENT_ISSUED': case 'FEE_CREDIT_APPROVED':
                return true;
            default:
                return false;
        }
    }

    /**
     * Phase 13 post-commit work. A dispute notice is re-authorized at delivery: staff who lost case access after it
     * was queued (for example when the Owner switched staff dispute handling off) never receive it.
     *
     * @param  array<string, mixed>  $payload
     */
    private function deliverDisputeEvent(string $eventType, #[SensitiveParameter] array $payload, string $requestedAt): bool
    {
        switch ($eventType) {
            case 'DISPUTE_CASE_CHANGED':
                app(DisputeChannel::class)->deliver($this->requiredString($payload, 'dispute_case_id'));

                return true;
            case 'DISPUTE_NOTICE':
                $user = User::query()->find($payload['user_id'] ?? null);
                $case = DB::table('dispute_cases')->where('id', $this->requiredString($payload, 'dispute_case_id'))->first();
                if ($user instanceof User && $case !== null && $user->account_status === 'ACTIVE' && $user->email !== ''
                    && app(DisputeAccess::class)->userCanAccessCase($user, $case)
                    && app(MailDeliveryPolicy::class)->allows($requestedAt)) {
                    app(MailProvider::class)->send($user->email, new OrderNoticeMail($this->requiredString($payload, 'subject'), $this->requiredString($payload, 'message')));
                }

                return true;
            case 'DISPUTE_EXPORT_REQUESTED':
                app(DisputeExportService::class)->process($this->requiredString($payload, 'export_id'));

                return true;
            default:
                return false;
        }
    }

    /** @param array<string, mixed> $payload */
    private function requiredString(#[SensitiveParameter] array $payload, string $key): string
    {
        if (! is_string($payload[$key] ?? null)) {
            throw new RuntimeException('The outbox payload is invalid.');
        }

        return $payload[$key];
    }

    /** @param array<string, mixed> $payload */
    private function requiredInteger(#[SensitiveParameter] array $payload, string $key): int
    {
        if (! is_int($payload[$key] ?? null)) {
            throw new RuntimeException('The outbox payload is invalid.');
        }

        return $payload[$key];
    }
}
