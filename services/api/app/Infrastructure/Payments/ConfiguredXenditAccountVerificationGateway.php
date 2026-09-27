<?php

declare(strict_types=1);

namespace App\Infrastructure\Payments;

use App\Domain\Vendors\XenditAccountVerificationGateway;
use App\Domain\Vendors\XenditProviderUnavailable;
use Illuminate\Http\Client\ConnectionException;
use Illuminate\Support\Facades\Http;

final class ConfiguredXenditAccountVerificationGateway implements XenditAccountVerificationGateway
{
    public function initiate(string $email, string $businessName): array
    {
        $key = config('services.xendit.secret_key');
        if (! is_string($key) || ! str_starts_with($key, 'xnd_development_') || config('services.xendit.mode') !== 'TEST') {
            throw new XenditProviderUnavailable('The TEST provider adapter is not configured.', creationRejected: true);
        }
        $baseUrl = rtrim((string) config('services.xendit.base_url', 'https://api.xendit.co'), '/');
        if ($baseUrl !== 'https://api.xendit.co') {
            throw new XenditProviderUnavailable('The Xendit API origin is not supported.', creationRejected: true);
        }
        try {
            // Never retry a create automatically: the API does not document a
            // create idempotency key and a lost response may hide a created account.
            $response = Http::withBasicAuth($key, '')->acceptJson()->withoutRedirecting()
                ->connectTimeout((int) config('services.xendit.timeout_seconds', 5))
                ->timeout((int) config('services.xendit.timeout_seconds', 5))
                ->post($baseUrl.'/v2/accounts', [
                    'email' => $email,
                    'type' => 'OWNED',
                    'public_profile' => ['business_name' => $businessName],
                ]);
        } catch (ConnectionException) {
            throw new XenditProviderUnavailable('The TEST provider could not be reached.');
        }
        if (! $response->successful()) {
            // Only an explicit rejection releases the local creation reservation.
            $code = $response->json('error_code');
            $safeCode = is_string($code) && in_array($code, ['API_VALIDATION_ERROR', 'INVALID_CONFIGURATION', 'TYPE_AND_CONFIGURATION_CONFLICT', 'MAXIMUM_ACCOUNT_REACHED', 'INVALID_CREDENTIALS', 'DISALLOWED_OPERATION', 'BUSINESS_NOT_FOUND_ERROR'], true) ? $code : 'UNRECOGNIZED_PROVIDER_ERROR';
            $requestId = $response->header('Request-Id');
            $safeRequestId = preg_match('/^[A-Za-z0-9._:-]{1,128}$/', $requestId) ? $requestId : null;
            throw new XenditProviderUnavailable('The TEST provider rejected or could not confirm creation.', creationRejected: in_array($response->status(), [400, 401, 403, 404, 409, 422, 429], true), providerHttpStatus: $response->status(), providerErrorCode: $safeCode, providerRequestId: $safeRequestId);
        }
        $payload = $response->json();
        if (! is_array($payload) || ! is_string($payload['id'] ?? null)
            || ! preg_match('/^[A-Za-z0-9_-]{3,128}$/', $payload['id'])
            || ! in_array($payload['status'] ?? null, ['REGISTERED', 'LIVE'], true)
            || ($payload['type'] ?? null) !== 'OWNED'
            || data_get($payload, 'public_profile.business_name') !== $businessName
            || ($payload['email'] ?? null) !== $email
            || (isset($payload['country']) && $payload['country'] !== 'PH')) {
            throw new XenditProviderUnavailable('The TEST provider response was invalid.');
        }
        $created = $payload['created'] ?? null;
        if ($created !== null && (! is_string($created) || strlen($created) > 64 || strtotime($created) === false)) {
            throw new XenditProviderUnavailable('The TEST provider timestamp was invalid.');
        }

        return ['provider_account_id' => $payload['id'], 'status' => $payload['status'], 'provider_created_at' => $created];
    }

    public function reconcile(string $providerAccountId): array
    {
        $key = config('services.xendit.secret_key');
        if (! is_string($key) || ! str_starts_with($key, 'xnd_development_') || config('services.xendit.mode') !== 'TEST'
            || ! preg_match('/^[A-Za-z0-9_-]{3,128}$/', $providerAccountId)) {
            throw new XenditProviderUnavailable('The TEST provider adapter is not configured.');
        }
        $baseUrl = rtrim((string) config('services.xendit.base_url', 'https://api.xendit.co'), '/');
        if ($baseUrl !== 'https://api.xendit.co') {
            throw new XenditProviderUnavailable('The Xendit API origin is not supported.');
        }
        try {
            $response = Http::withBasicAuth($key, '')->acceptJson()->withoutRedirecting()
                ->connectTimeout((int) config('services.xendit.timeout_seconds', 5))
                ->timeout((int) config('services.xendit.timeout_seconds', 5))
                ->get($baseUrl.'/v2/accounts/'.$providerAccountId);
        } catch (ConnectionException) {
            throw new XenditProviderUnavailable('The TEST provider could not be reached.');
        }
        $payload = $response->json();
        if (! $response->successful() || ! is_array($payload)
            || ($payload['id'] ?? null) !== $providerAccountId
            || ! in_array($payload['type'] ?? null, ['OWNED', 'MANAGED'], true)
            || ! in_array($payload['status'] ?? null, ['INVITED', 'REGISTERED', 'AWAITING_DOCS', 'PENDING_VERIFICATION', 'LIVE', 'SUSPENDED'], true)) {
            throw new XenditProviderUnavailable('The TEST provider account could not be verified.');
        }

        return ['provider_account_id' => $providerAccountId, 'status' => $payload['status'], 'capabilities' => []];
    }
}
