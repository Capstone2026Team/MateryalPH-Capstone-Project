<?php

declare(strict_types=1);

namespace App\Infrastructure\Notifications;

use App\Domain\Notifications\MailDeliveryException;
use App\Domain\Notifications\MailDeliveryPolicy;
use Illuminate\Http\Client\PendingRequest;
use Illuminate\Http\Client\Response;
use Illuminate\Support\Facades\Http;
use Symfony\Component\Mailer\SentMessage;
use Symfony\Component\Mailer\Transport\AbstractTransport;
use Symfony\Component\Mime\Message;
use Symfony\Component\Mime\MessageConverter;
use Throwable;

/** Gmail send-only OAuth transport. Provider payloads and MIME never enter exception chains. */
final class GmailApiTransport extends AbstractTransport
{
    private const SCOPE = 'https://www.googleapis.com/auth/gmail.send';

    private ?string $accessToken = null;

    private int $expiresAt = 0;

    public static function assertConfigured(): void
    {
        foreach (['client_id', 'client_secret', 'refresh_token'] as $key) {
            $value = config('services.gmail_api.'.$key);
            if (! is_string($value) || trim($value) === '' || strpbrk($value, "\r\n") !== false) {
                throw new MailDeliveryException('MAIL_CONFIGURATION_INVALID');
            }
        }
        $sender = config('mail.from.address');
        $timeout = config('mail.mailers.gmail_api.timeout');
        if (! is_string($sender) || filter_var($sender, FILTER_VALIDATE_EMAIL) === false
            || ! is_int($timeout) || $timeout < 1 || $timeout > 30
            || config('mail.mailers.gmail_api.transport') !== 'gmail_api'
            || config('services.gmail_api.client_id') === config('services.google_oidc.client_id')
            || (new MailDeliveryPolicy)->activationTime() === null) {
            throw new MailDeliveryException('MAIL_CONFIGURATION_INVALID');
        }
    }

    public function __toString(): string
    {
        return 'gmail_api';
    }

    protected function doSend(SentMessage $message): void
    {
        try {
            self::assertConfigured();
            $original = $message->getOriginalMessage();
            if (! $original instanceof Message) {
                throw new MailDeliveryException('MAIL_CONFIGURATION_INVALID');
            }
            $email = MessageConverter::toEmail($original);
            $from = $email->getFrom();
            $sender = (string) config('mail.from.address');
            if (count($from) !== 1 || strcasecmp($from[0]->getAddress(), $sender) !== 0
                || strcasecmp($message->getEnvelope()->getSender()->getAddress(), $sender) !== 0) {
                throw new MailDeliveryException('MAIL_CONFIGURATION_INVALID');
            }
            $raw = rtrim(strtr(base64_encode($email->toString()), '+/', '-_'), '=');
            $response = $this->sendMessage($raw);
            // An explicit 401 rejected the send. Refresh once; never automatically replay an ambiguous timeout.
            if ($response->status() === 401) {
                $this->accessToken = null;
                $response = $this->sendMessage($raw);
            }
            if ($response->status() === 403 && in_array($response->json('error.errors.0.reason'), ['rateLimitExceeded', 'userRateLimitExceeded', 'dailyLimitExceeded'], true)) {
                throw new MailDeliveryException('MAIL_RATE_LIMITED');
            }
            if (in_array($response->status(), [401, 403], true)) {
                throw new MailDeliveryException($response->status() === 401 ? 'MAIL_AUTHENTICATION_FAILED' : 'MAIL_PROVIDER_REJECTED');
            }
            if ($response->status() === 429) {
                throw new MailDeliveryException('MAIL_RATE_LIMITED');
            }
            if (! $response->successful() || ! is_string($response->json('id')) || $response->json('id') === '') {
                throw new MailDeliveryException;
            }
        } catch (MailDeliveryException $failure) {
            throw $failure;
        } catch (Throwable) {
            throw new MailDeliveryException;
        }
    }

    private function sendMessage(#[\SensitiveParameter] string $raw): Response
    {
        return $this->request()->withToken($this->token())->post('https://gmail.googleapis.com/gmail/v1/users/me/messages/send', ['raw' => $raw]);
    }

    private function token(): string
    {
        if ($this->accessToken !== null && time() < $this->expiresAt) {
            return $this->accessToken;
        }
        $response = $this->request()->asForm()->post('https://oauth2.googleapis.com/token', [
            'grant_type' => 'refresh_token',
            'client_id' => config('services.gmail_api.client_id'),
            'client_secret' => config('services.gmail_api.client_secret'),
            'refresh_token' => config('services.gmail_api.refresh_token'),
        ]);
        if (in_array($response->status(), [400, 401, 403], true)) {
            throw new MailDeliveryException('MAIL_AUTHENTICATION_FAILED');
        }
        if ($response->status() === 429) {
            throw new MailDeliveryException('MAIL_RATE_LIMITED');
        }
        $token = $response->json('access_token');
        $expires = $response->json('expires_in');
        $scope = $response->json('scope');
        if (! $response->successful() || ! is_string($token) || $token === '' || strpbrk($token, "\r\n") !== false
            || ! is_int($expires) || $expires < 60 || $expires > 86400
            || strtolower((string) $response->json('token_type')) !== 'bearer'
            || ($scope !== null && $scope !== self::SCOPE)) {
            throw new MailDeliveryException;
        }
        $this->accessToken = $token;
        $this->expiresAt = time() + $expires - 30;

        return $token;
    }

    private function request(): PendingRequest
    {
        return Http::acceptJson()->connectTimeout(5)->timeout((int) config('mail.mailers.gmail_api.timeout'))
            ->withOptions(['allow_redirects' => false]);
    }
}
