<?php

declare(strict_types=1);

namespace App\Infrastructure\Notifications;

use App\Domain\Notifications\MailDeliveryException;
use App\Domain\Notifications\MailDeliveryPolicy;
use App\Domain\Notifications\MailProvider;
use Illuminate\Mail\Mailable;
use Illuminate\Support\Facades\Mail;
use SensitiveParameter;
use Symfony\Component\Mailer\Exception\TransportExceptionInterface;
use Throwable;

final class LaravelMailProvider implements MailProvider
{
    public function send(#[SensitiveParameter] string $recipient, #[SensitiveParameter] Mailable $mail): void
    {
        $this->assertConfigured();

        try {
            Mail::to($recipient)->send($mail);
        } catch (Throwable $failure) {
            // Do not chain SMTP exceptions: their messages/debug transcripts can contain secrets.
            $code = $failure instanceof TransportExceptionInterface
                && str_contains($failure->getMessage(), 'Failed to authenticate on SMTP server')
                ? 'MAIL_AUTHENTICATION_FAILED' : 'MAIL_TRANSPORT_UNAVAILABLE';

            throw new MailDeliveryException($code);
        }
    }

    private function assertConfigured(): void
    {
        if (app()->environment('testing') && config('mail.default') === 'array') {
            return;
        }
        /** @var array<string, mixed> $smtp */
        $smtp = config('mail.mailers.smtp', []);
        if (config('mail.default') !== 'smtp' || ($smtp['transport'] ?? null) !== 'smtp'
            || ! empty($smtp['url']) || ! in_array($smtp['scheme'] ?? null, ['smtp', 'smtps'], true)
            || ($smtp['verify_peer'] ?? null) !== true || (int) ($smtp['timeout'] ?? 0) <= 0) {
            throw new MailDeliveryException('MAIL_CONFIGURATION_INVALID');
        }
        if (strtolower(trim((string) ($smtp['host'] ?? ''))) !== 'smtp.gmail.com') {
            return;
        }
        $username = trim((string) ($smtp['username'] ?? ''));
        if ($smtp['scheme'] !== 'smtp' || (int) ($smtp['port'] ?? 0) !== 587
            || ($smtp['auto_tls'] ?? null) !== true || ($smtp['require_tls'] ?? null) !== true
            || $username === '' || trim((string) ($smtp['password'] ?? '')) === ''
            || strcasecmp($username, (string) config('mail.from.address')) !== 0
            || app(MailDeliveryPolicy::class)->activationTime() === null) {
            throw new MailDeliveryException('MAIL_CONFIGURATION_INVALID');
        }
    }
}
