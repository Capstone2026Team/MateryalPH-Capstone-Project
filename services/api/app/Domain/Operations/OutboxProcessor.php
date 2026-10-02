<?php

declare(strict_types=1);

namespace App\Domain\Operations;

use App\Domain\Catalog\EligibilityInvalidation;
use App\Domain\Catalog\EligibleOfferQuery;
use App\Domain\Messaging\ConversationBroadcast;
use App\Mail\AccountSecurityMail;
use App\Mail\AdminInvitationMail;
use App\Mail\EmailOtpMail;
use App\Mail\OrderNoticeMail;
use App\Mail\ProductComplianceNoticeMail;
use App\Mail\VendorInventoryNoticeMail;
use App\Mail\VendorInvitationMail;
use App\Mail\VendorOnboardingNoticeMail;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Mail;
use RuntimeException;
use Throwable;

final class OutboxProcessor
{
    public const MAX_ATTEMPTS = 5;

    public function process(string $eventId): void
    {
        Cache::lock('outbox-event:'.$eventId, 120)->block(5, function () use ($eventId): void {
            $event = DB::table('outbox_events')->where('id', $eventId)->first();
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
                $this->deliver((string) $event->event_type, $payload);

                DB::table('outbox_events')
                    ->where('id', $eventId)
                    ->whereNull('processed_at')
                    ->update(['processed_at' => now(), 'updated_at' => now()]);
            } catch (Throwable $exception) {
                DB::table('outbox_events')
                    ->where('id', $eventId)
                    ->increment('attempts', 1, ['updated_at' => now()]);

                throw $exception;
            }
        });
    }

    /**
     * Committed order and fee domain events. They are the durable integration record for later consumers
     * (realtime order milestones, push, finance statements); in this release they have no external side effect.
     */
    private const RECORDED_DOMAIN_EVENTS = ['ORDER_STATE_CHANGED', 'ORDER_SUBMITTED', 'ORDER_VENDOR_CONFIRMED', 'ORDER_AUTO_ACCEPT_EVALUATED', 'ORDER_ACCEPTED', 'NRPC_PROPOSED', 'NRPC_DECIDED', 'NRPC_FLAGGED',
        'FEE_ASSESSMENT_ESTIMATED', 'FEE_ASSESSMENT_EARNED', 'FEE_ASSESSMENT_CANCELLED', 'INVENTORY_RESERVATION_RELEASED',
        'PROJECT_CREATED', 'PROJECT_UPDATED', 'PROJECT_DELETED', 'WORK_PACKAGE_DRAFT_SAVED', 'WORK_PACKAGE_VERSION_CREATED', 'WORK_PACKAGE_ACTIVATED',
        'WORK_PACKAGE_CANCELLED', 'WORK_PACKAGE_DELETED', 'WORK_PACKAGE_MISSING_LINE_RESOLVED', 'PROJECT_ESTIMATE_COMPILED', 'PROJECT_VENDOR_INQUIRY_CREATED',
        'PROJECT_VENDOR_SELECTED', 'PROJECT_BUDGET_OVERRIDE_RECORDED', 'PROJECT_RANKING_PREFERENCES_UPDATED', 'WORK_PACKAGE_DRAFT_DELETED'];

    /** @param array<string, mixed> $payload */
    private function deliver(string $eventType, array $payload): void
    {
        if ($eventType === 'CONVERSATION_CHANGED') {
            app(ConversationBroadcast::class)->deliver($this->requiredString($payload, 'conversation_id'));

            return;
        }
        if ($eventType === EligibilityInvalidation::EVENT) {
            EligibleOfferQuery::invalidate();

            return;
        }
        if (in_array($eventType, self::RECORDED_DOMAIN_EVENTS, true)) {
            return;
        }
        $recipient = $payload['recipient'] ?? null;
        if (! is_string($recipient)) {
            throw new RuntimeException('The outbox email recipient is invalid.');
        }

        match ($eventType) {
            'VENDOR_INVITATION_REQUESTED' => Mail::to($recipient)->send(new VendorInvitationMail(
                $this->requiredString($payload, 'invitation_url'),
            )),
            'ACCOUNT_SECURITY_NOTICE' => Mail::to($recipient)->send(new AccountSecurityMail(
                $this->requiredString($payload, 'message'),
            )),
            'AUTH_EMAIL_OTP_REQUESTED' => Mail::to($recipient)->send(new EmailOtpMail(
                $this->requiredString($payload, 'code'),
                $this->requiredString($payload, 'purpose'),
                $this->requiredInteger($payload, 'ttl_minutes'),
            )),
            'ADMIN_BOOTSTRAP_INVITATION_REQUESTED', 'ADMIN_INVITATION_REQUESTED' => Mail::to($recipient)->send(new AdminInvitationMail(
                $this->requiredString($payload, 'invitation_url'),
            )),
            'VENDOR_ONBOARDING_NOTICE' => Mail::to($recipient)->send(new VendorOnboardingNoticeMail(
                $this->requiredString($payload, 'message'),
            )),
            'PRODUCT_COMPLIANCE_NOTICE' => Mail::to($recipient)->send(new ProductComplianceNoticeMail(
                $this->requiredString($payload, 'message'),
            )),
            'VENDOR_INVENTORY_NOTICE' => Mail::to($recipient)->send(new VendorInventoryNoticeMail(
                $this->requiredString($payload, 'subject'),
                $this->requiredString($payload, 'message'),
            )),
            'ORDER_NOTICE' => Mail::to($recipient)->send(new OrderNoticeMail(
                $this->requiredString($payload, 'subject'),
                $this->requiredString($payload, 'message'),
            )),
            default => throw new RuntimeException('Unsupported outbox event type.'),
        };
    }

    /** @param array<string, mixed> $payload */
    private function requiredString(array $payload, string $key): string
    {
        if (! is_string($payload[$key] ?? null)) {
            throw new RuntimeException('The outbox payload is invalid.');
        }

        return $payload[$key];
    }

    /** @param array<string, mixed> $payload */
    private function requiredInteger(array $payload, string $key): int
    {
        if (! is_int($payload[$key] ?? null)) {
            throw new RuntimeException('The outbox payload is invalid.');
        }

        return $payload[$key];
    }
}
