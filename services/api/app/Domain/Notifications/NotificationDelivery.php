<?php

declare(strict_types=1);

namespace App\Domain\Notifications;

use App\Mail\AccountSecurityMail;
use App\Mail\FinanceNoticeMail;
use App\Mail\OrderNoticeMail;
use App\Mail\ProductComplianceNoticeMail;
use App\Mail\VendorInventoryNoticeMail;
use App\Mail\VendorOnboardingNoticeMail;
use App\Models\User;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use RuntimeException;
use Throwable;

final class NotificationDelivery
{
    public function send(string $id): void
    {
        Cache::lock('notification-delivery:'.$id, 90)->block(5, function () use ($id): void {
            $delivery = DB::table('notification_deliveries')->where('id', $id)->first();
            if ($delivery === null || ! in_array($delivery->state, ['QUEUED', 'RETRY'], true) || (int) $delivery->attempt_count >= 5) {
                return;
            }
            $notice = DB::table('notifications')->where('id', $delivery->notification_id)->first();
            $user = $notice === null ? null : User::query()->find($notice->user_id);
            $state = 'REVOKED';
            $failure = null;
            $attempt = (int) $delivery->attempt_count + 1;
            try {
                if ($user instanceof User && app(NotificationPolicy::class)->allows($user, $notice)) {
                    if (($notice->category === 'MESSAGES' && $notice->read_at !== null) || ! NotificationService::enabled($notice, $delivery->channel)) {
                        $state = 'SKIPPED';
                    } elseif ($delivery->channel === 'EMAIL' && ! app(MailDeliveryPolicy::class)->allows((string) $notice->created_at)) {
                        $state = 'SKIPPED';
                    } elseif ($delivery->channel === 'EMAIL') {
                        $recipient = $delivery->sealed_recipient === null ? $user->email : Crypt::decryptString($delivery->sealed_recipient);
                        $mail = match ($delivery->template) {
                            'FINANCE_NOTICE' => new FinanceNoticeMail($notice->title, $notice->body),
                            'VENDOR_ONBOARDING_NOTICE' => new VendorOnboardingNoticeMail($notice->body),
                            'ACCOUNT_SECURITY_NOTICE' => new AccountSecurityMail($notice->body),
                            'PRODUCT_COMPLIANCE_NOTICE' => new ProductComplianceNoticeMail($notice->body),
                            'VENDOR_INVENTORY_NOTICE' => new VendorInventoryNoticeMail($notice->title, $notice->body),
                            default => new OrderNoticeMail($notice->title, $notice->body),
                        };
                        if (in_array($user->account_type, ['VENDOR', 'ADMIN'], true)) {
                            $base = (string) config($user->account_type === 'VENDOR' ? 'app.vendor_frontend_url' : 'app.admin_frontend_url');
                            $mail->with('noticeUrl', rtrim($base, '/').'/notifications?notice='.rawurlencode($notice->id));
                        }
                        app(MailProvider::class)->send($recipient, $mail);
                        $state = 'SENT';
                    } else {
                        $device = DB::table('notification_devices')->where('id', $delivery->device_id)->where('user_id', $user->getKey())->whereNull('revoked_at')->where('environment', app()->environment())->first();
                        if ($device !== null && ($device->platform !== 'WEB' || config('notifications.web_push_approved'))) {
                            $sessionActive = $device->session_id === null || DB::table('auth_sessions')->where('id', $device->session_id)->whereNull('revoked_at')->where('expires_at', '>', now())->exists();
                            if ($sessionActive) {
                                $state = app(PushGateway::class)->send(Crypt::decryptString($device->sealed_token),
                                    new PushNotification($notice->id, $notice->title, $notice->body), $device->platform);
                            }
                            if ($state === 'REVOKED') {
                                DB::table('notification_devices')->where('id', $device->id)->update(['revoked_at' => now(), 'updated_at' => now()]);
                            }
                        }
                    }
                }
            } catch (Throwable) {
                $state = $attempt >= 5 ? 'FAILED' : 'RETRY';
                $failure = 'CHANNEL_UNAVAILABLE';
            }
            DB::transaction(function () use ($id, $attempt, $state, $failure): void {
                DB::table('notification_delivery_attempts')->insert(['id' => (string) Str::uuid7(), 'notification_delivery_id' => $id, 'attempt' => $attempt,
                    'outcome' => $state, 'failure_code' => $failure, 'attempted_at' => now()]);
                DB::table('notification_deliveries')->where('id', $id)->update(['state' => $state, 'attempt_count' => $attempt, 'failure_code' => $failure,
                    'delivered_at' => $state === 'SENT' ? now() : null, 'available_at' => now()->addSeconds([30, 120, 300, 900, 900][$attempt - 1]), 'updated_at' => now()]);
            });
            if ($failure !== null) {
                throw new RuntimeException('Notification delivery failed. See the operational delivery record.');
            }
        });
    }
}
