<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Client\ConnectionException;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;

final class XenditTestConnection implements TestConnectionProvider
{
    private const STATUSES = ['INVITED', 'REGISTERED', 'AWAITING_DOCS', 'PENDING_VERIFICATION', 'AWAITING_RESUBMISSION', 'LIVE', 'DECLINED', 'DORMANT', 'SUSPENDED', 'CLOSED'];

    public function validateConfiguration(): void
    {
        $secret = (string) config('vendor_providers.xendit.secret');
        if (config('vendor_providers.xendit.mode') !== 'test' || ! str_starts_with($secret, 'xnd_development_') || config('finance.live_commerce_enabled') || ! in_array(config('finance.mode'), ['TEST', 'DEMO'], true)) {
            throw new AuthenticationException('XENDIT_TEST_CONFIGURATION_REQUIRED', 'A backend Xendit TEST key with xenPlatform Account Write permission is required.', 503);
        }
    }

    public function connect(string $organization): array
    {
        $this->validateConfiguration();
        $org = DB::table('vendor_organizations')->where('id', $organization)->firstOrFail();
        if ($org->business_type !== 'CORPORATION') {
            throw new AuthenticationException('XENDIT_TEST_ENTITY_UNSUPPORTED', 'Xendit TEST currently supports Corporation only. Your recorded business type will not be changed.', 422);
        }
        $owner = DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->where('m.vendor_organization_id', $organization)->where('m.role', 'OWNER')->where('m.status', 'ACTIVE')->first(['u.email', 'u.email_verified_at']);
        if ($owner === null || $owner->email_verified_at === null || $org->onboarding_status !== 'APPROVED' || ! filled($org->legal_name)) {
            throw new AuthenticationException('XENDIT_IDENTITY_REQUIRED', 'Approved business information and a verified Owner email are required.', 422);
        }
        try {
            $response = Http::withBasicAuth((string) config('vendor_providers.xendit.secret'), '')->acceptJson()->connectTimeout(5)->timeout(20)->withOptions(['allow_redirects' => false])->post('https://api.xendit.co/v3/accounts', ['name' => $org->legal_name, 'email' => $owner->email, 'identity' => ['country_of_incorporation' => 'PH', 'entity_type' => $org->business_type], 'configuration' => ['users' => ['send_email_invite' => false], 'webhooks' => ['recipient' => 'MASTER_ACCOUNT']]]);
        } catch (ConnectionException) {
            throw new AuthenticationException('XENDIT_OUTCOME_UNKNOWN', 'The account-creation outcome is unknown. Provider reconciliation is required before another attempt.', 503);
        }
        if (! $response->successful()) {
            throw new AuthenticationException('XENDIT_ACCOUNT_CREATION_FAILED', 'Xendit did not confirm account creation. Review provider account health before retrying.', 503);
        }
        $id = $response->json('id');
        $status = $response->json('status');
        if (! is_string($id) || ! preg_match('/^[a-f0-9]{24}$/i', $id) || ! in_array($status, self::STATUSES, true) || $response->json('identity.country_of_incorporation') !== 'PH' || $response->json('identity.entity_type') !== 'CORPORATION') {
            throw new AuthenticationException('XENDIT_OUTCOME_UNKNOWN', 'The provider response could not be verified. Reconciliation is required before another attempt.', 503);
        }

        return ['status' => $status === 'LIVE' ? 'TEST_CONNECTED' : 'TEST_PENDING', 'provider_status' => $status, 'evidence_origin' => 'PROVIDER_TEST', 'provider_account_reference' => $id, 'capabilities' => ['simulated_onboarding' => false, 'live_payments' => false, 'provider_verified' => true]];
    }

    public function reconcile(string $organization): array
    {
        $this->validateConfiguration();
        $org = DB::table('vendor_organizations')->where('id', $organization)->firstOrFail();
        $owner = DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->where('m.vendor_organization_id', $organization)->where('m.role', 'OWNER')->where('m.status', 'ACTIVE')->first(['u.email']);
        if ($owner === null || ! filled($org->legal_name)) {
            throw new AuthenticationException('XENDIT_IDENTITY_REQUIRED', 'Approved business information and a verified Owner email are required.', 422);
        }

        try {
            $response = Http::withBasicAuth((string) config('vendor_providers.xendit.secret'), '')->acceptJson()->connectTimeout(5)->timeout(20)->withOptions(['allow_redirects' => false])->get('https://api.xendit.co/v2/accounts', ['email' => [$owner->email], 'public_profile.business_name' => $org->legal_name, 'limit' => 50]);
        } catch (ConnectionException) {
            throw new AuthenticationException('XENDIT_RECONCILIATION_UNAVAILABLE', 'Xendit account reconciliation is temporarily unavailable. No new account was created.', 503);
        }
        $accounts = $response->json('data');
        if (! $response->successful() || ! is_array($accounts) || $response->json('has_more') === true) {
            throw new AuthenticationException('XENDIT_RECONCILIATION_UNVERIFIED', 'Xendit did not provide a complete account result. No new account was created.', 503);
        }
        if ($accounts === []) {
            return ['outcome' => 'NOT_FOUND'];
        }
        if (count($accounts) !== 1) {
            throw new AuthenticationException('XENDIT_RECONCILIATION_AMBIGUOUS', 'More than one Xendit account matched this identity. No new account was created.', 409);
        }
        $account = $accounts[0];
        $id = $account['id'] ?? null;
        $status = $account['status'] ?? null;
        $email = $account['email'] ?? null;
        $name = $account['public_profile']['business_name'] ?? null;
        $country = $account['public_profile']['country'] ?? 'PH';
        if (! is_string($id) || ! preg_match('/^[a-f0-9]{24}$/i', $id) || ! in_array($status, self::STATUSES, true) || ! is_string($email) || strcasecmp($email, (string) $owner->email) !== 0 || $name !== $org->legal_name || $country !== 'PH') {
            throw new AuthenticationException('XENDIT_RECONCILIATION_UNVERIFIED', 'Xendit returned an account that did not match the approved Vendor identity. No new account was created.', 409);
        }

        return ['outcome' => 'FOUND', 'status' => $status === 'LIVE' ? 'TEST_CONNECTED' : 'TEST_PENDING', 'provider_status' => $status, 'provider_account_reference' => $id, 'capabilities' => ['simulated_onboarding' => false, 'live_payments' => false, 'provider_verified' => true]];
    }
}
