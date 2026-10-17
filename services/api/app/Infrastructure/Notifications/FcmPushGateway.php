<?php

declare(strict_types=1);

namespace App\Infrastructure\Notifications;

use App\Domain\Notifications\PushGateway;
use App\Domain\Notifications\PushNotification;
use Illuminate\Support\Facades\Http;
use RuntimeException;
use Throwable;

/** Backend-only HTTP v1 adapter. Neither provider bodies nor credentials enter exceptions or delivery logs. */
final class FcmPushGateway implements PushGateway
{
    public function send(#[\SensitiveParameter] string $token, PushNotification $notification, string $platform): string
    {
        try {
            $path = (string) config('notifications.firebase_credentials');
            $encoded = (string) config('notifications.firebase_credentials_base64');
            $json = $encoded !== '' ? base64_decode($encoded, true) : ($path !== '' && is_readable($path) ? file_get_contents($path) : false);
            if (! is_string($json)) {
                throw new RuntimeException('PUSH_NOT_CONFIGURED');
            }
            $credentials = json_decode($json, true, flags: JSON_THROW_ON_ERROR);
            $project = (string) config('notifications.firebase_project_id');
            if ($project === '' || ($credentials['project_id'] ?? null) !== $project) {
                throw new RuntimeException('PUSH_NOT_CONFIGURED');
            }
            $encode = static fn (string $text): string => rtrim(strtr(base64_encode($text), '+/', '-_'), '=');
            $unsigned = $encode(json_encode(['alg' => 'RS256', 'typ' => 'JWT'], JSON_THROW_ON_ERROR)).'.'.$encode(json_encode([
                'iss' => $credentials['client_email'], 'scope' => 'https://www.googleapis.com/auth/firebase.messaging',
                'aud' => 'https://oauth2.googleapis.com/token', 'iat' => time(), 'exp' => time() + 3600,
            ], JSON_THROW_ON_ERROR));
            if (! openssl_sign($unsigned, $signature, $credentials['private_key'], OPENSSL_ALGO_SHA256)) {
                throw new RuntimeException('PUSH_NOT_CONFIGURED');
            }
            $auth = Http::timeout(15)->asForm()->post('https://oauth2.googleapis.com/token', ['grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer', 'assertion' => $unsigned.'.'.$encode($signature)]);
            if (! $auth->successful() || ! is_string($auth->json('access_token'))) {
                throw new RuntimeException('PUSH_UNAVAILABLE');
            }
            // The domain supplies the authorized notice preview. Routes and private files remain behind REST.
            $message = ['token' => $token, 'notification' => ['title' => $notification->title, 'body' => $notification->body],
                'data' => ['notification_id' => $notification->id]];
            if ($platform === 'ANDROID') {
                $message['android'] = ['priority' => 'high', 'notification' => [
                    'channel_id' => 'materyalph_updates', 'icon' => 'ic_notification',
                    'sound' => 'default', 'tag' => $notification->id, 'visibility' => 'PRIVATE',
                ]];
            } elseif ($platform === 'IOS') {
                $message['apns'] = ['headers' => ['apns-priority' => '10'], 'payload' => ['aps' => ['sound' => 'default']]];
            }
            if ($platform === 'WEB') {
                // The registered worker opens its own origin; Vendor and Admin origins never mix.
                unset($message['notification']);
                $message['webpush'] = ['headers' => ['TTL' => '3600']];
            }
            $response = Http::timeout(15)->withToken($auth->json('access_token'))
                ->withBody(json_encode(['message' => $message], JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR), 'application/json')
                ->post('https://fcm.googleapis.com/v1/projects/'.rawurlencode($project).'/messages:send');
            if ($response->status() === 404 && str_contains($response->body(), 'UNREGISTERED')) {
                return 'REVOKED';
            }
            if (! $response->successful()) {
                throw new RuntimeException('PUSH_UNAVAILABLE');
            }

            return 'SENT';
        } catch (Throwable) {
            throw new RuntimeException('PUSH_UNAVAILABLE');
        }
    }
}
