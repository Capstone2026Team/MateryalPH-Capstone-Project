<?php

declare(strict_types=1);

namespace App\Infrastructure\Payments;

use App\Domain\Vendors\XenditAccountVerificationGateway;
use App\Domain\Vendors\XenditProviderUnavailable;
use Illuminate\Support\Facades\Http;

final class ConfiguredXenditAccountVerificationGateway implements XenditAccountVerificationGateway
{
    public function reconcile(string $providerAccountId): array
    {
        $key = config('services.xendit.secret_key');
        if (! is_string($key) || trim($key) === '' || config('services.xendit.mode') !== 'TEST') {
            throw new XenditProviderUnavailable('The TEST provider adapter is not configured.');
        }

        $baseUrl = rtrim((string) config('services.xendit.base_url', 'https://api.xendit.co'), '/');
        $response = Http::withToken($key)
            ->acceptJson()
            ->timeout((int) config('services.xendit.timeout_seconds', 5))
            ->get($baseUrl.'/account_verification', ['for-user-id' => $providerAccountId]);

        if ($response->failed()) {
            throw new XenditProviderUnavailable('The TEST provider could not reconcile the account.');
        }

        $payload = $response->json();
        if (! is_array($payload)) {
            throw new XenditProviderUnavailable('The TEST provider response was invalid.');
        }

        $status = $payload['status'] ?? $payload['verification_status'] ?? null;
        if (! is_string($status) || trim($status) === '') {
            throw new XenditProviderUnavailable('The TEST provider response did not include a verification status.');
        }

        return [
            'provider_account_id' => $providerAccountId,
            'status' => strtoupper($status),
            'capabilities' => is_array($payload['capabilities'] ?? null) ? $payload['capabilities'] : [],
        ];
    }
}
