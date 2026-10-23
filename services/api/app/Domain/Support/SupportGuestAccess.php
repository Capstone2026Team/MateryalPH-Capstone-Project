<?php

declare(strict_types=1);

namespace App\Domain\Support;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Notifications\MailDeliveryPolicy;
use App\Domain\Notifications\MailProvider;
use App\Domain\Operations\OutboxPublisher;
use App\Mail\SupportAccessMail;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use SensitiveParameter;

final class SupportGuestAccess
{
    public function sendLink(object $ticket): void
    {
        if ($ticket->user_id !== null) {
            return;
        }
        $token = bin2hex(random_bytes(32));
        $id = (string) Str::uuid7();
        DB::table('support_guest_credentials')->insert(['id' => $id, 'ticket_id' => $ticket->id, 'purpose' => 'LINK',
            'token_hash' => SupportAccess::hash($token), 'expires_at' => now()->addDay(), 'created_at' => now()]);
        app(OutboxPublisher::class)->publish('SUPPORT_GUEST_EMAIL', 'SUPPORT_TICKET', (string) $ticket->id,
            ['credential_id' => $id, 'token' => $token]);
    }

    /** @return array{ticket_id: string, session: string} */
    public function exchange(#[SensitiveParameter] string $token): array
    {
        return DB::transaction(function () use ($token): array {
            $credential = DB::table('support_guest_credentials')->where('token_hash', SupportAccess::hash($token))->where('purpose', 'LINK')
                ->whereNull('consumed_at')->where('expires_at', '>', now())->lockForUpdate()->first();
            if ($credential === null || ! DB::table('support_tickets')->where('id', $credential->ticket_id)->whereNull('user_id')->exists()) {
                throw new AuthenticationException('SUPPORT_LINK_INVALID', 'This link has expired or was already used. Request a new support access email.', 422);
            }
            DB::table('support_guest_credentials')->where('id', $credential->id)->update(['consumed_at' => now()]);
            $session = bin2hex(random_bytes(32));
            DB::table('support_guest_credentials')->insert(['id' => (string) Str::uuid7(), 'ticket_id' => $credential->ticket_id,
                'purpose' => 'SESSION', 'token_hash' => SupportAccess::hash($session), 'expires_at' => now()->addMinutes(30), 'created_at' => now()]);

            return ['ticket_id' => $credential->ticket_id, 'session' => $session];
        });
    }

    public function deliver(string $credentialId, #[SensitiveParameter] string $token, string $requestedAt): void
    {
        $credential = DB::table('support_guest_credentials')->where('id', $credentialId)->where('purpose', 'LINK')
            ->where('token_hash', SupportAccess::hash($token))->whereNull('consumed_at')->where('expires_at', '>', now())->first();
        $ticket = $credential === null ? null : DB::table('support_tickets')->where('id', $credential->ticket_id)->whereNull('user_id')->first();
        if ($ticket === null || ! app(MailDeliveryPolicy::class)->allows($requestedAt)) {
            return;
        }
        $base = rtrim((string) config('app.vendor_frontend_url'), '/');
        $scheme = parse_url($base, PHP_URL_SCHEME);
        $host = parse_url($base, PHP_URL_HOST);
        $developmentLoopback = app()->environment(['local', 'development']) && $scheme === 'http'
            && in_array($host, ['localhost', '127.0.0.1', '[::1]'], true);
        if (! is_string($host) || $host === '' || ($scheme !== 'https' && ! $developmentLoopback)
            || parse_url($base, PHP_URL_USER) !== null || parse_url($base, PHP_URL_PASS) !== null) {
            throw new AuthenticationException('SUPPORT_EMAIL_CONFIGURATION', 'A secure Vendor frontend URL is required for support email delivery.', 503);
        }
        app(MailProvider::class)->send((string) $ticket->email, new SupportAccessMail((string) $ticket->ticket_number, $base.'/contact/access#token='.$token));
    }
}
