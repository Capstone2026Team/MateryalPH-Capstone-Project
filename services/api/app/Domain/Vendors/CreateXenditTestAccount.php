<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class CreateXenditTestAccount
{
    public function __construct(private readonly OnboardingAccess $access, private readonly TestConnectionProvider $provider, private readonly ActivationReadiness $readiness, private readonly AuditRecorder $audit) {}

    public function handle(Request $request, string $organization, int $version, string $scenario): void
    {
        $this->access->vendor($request, $organization, 'payments.configure', true);
        if ($this->provider instanceof XenditTestConnection) {
            $this->provider->validateConfiguration();
        }
        // Commit intent BEFORE the external call. A crash or timeout cannot silently retry creation.
        $attempt = DB::transaction(function () use ($request, $organization, $version, $scenario): ?string {
            $org = DB::table('vendor_organizations')->where('id', $organization)->lockForUpdate()->firstOrFail();
            $this->access->vendor($request, $organization, 'payments.configure', true);
            $account = DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organization)->first();
            if ($account !== null && $account->environment !== 'TEST') {
                throw new AuthenticationException('ENVIRONMENT_CONFLICT', 'TEST cannot replace another environment connection.', 409);
            }
            if ($account?->provider_account_reference !== null) {
                return null;
            }
            if ($account?->connection_attempt_id !== null) {
                throw new AuthenticationException('XENDIT_RECONCILIATION_REQUIRED', 'An account-creation attempt already exists. Reconcile its provider outcome before retrying.', 409);
            }
            $this->access->version($org, $version);
            if ($org->business_type !== 'CORPORATION') {
                throw new AuthenticationException('XENDIT_TEST_ENTITY_UNSUPPORTED', 'Xendit TEST currently supports Corporation only. Your business type will not be changed.', 422);
            }
            if ($org->onboarding_status !== 'APPROVED' || $request->user()->email_verified_at === null) {
                throw new AuthenticationException('XENDIT_IDENTITY_REQUIRED', 'Approved business information and verified Owner email are required.', 422);
            }
            $attempt = (string) Str::uuid7();
            DB::table('vendor_payment_accounts')->updateOrInsert(['vendor_organization_id' => $organization], ['id' => $account->id ?? (string) Str::uuid7(), 'provider' => 'XENDIT', 'environment' => 'TEST', 'status' => 'TEST_CONNECTING', 'evidence_origin' => 'PROVIDER_TEST', 'connection_attempt_id' => $attempt, 'connection_error' => null, 'created_at' => $account->created_at ?? now(), 'updated_at' => now()]);
            DB::table('vendor_organizations')->where('id', $organization)->update(['withholding_demo_scenario' => $scenario, 'lock_version' => $org->lock_version + 1, 'updated_at' => now()]);
            $this->audit->account($request, 'XENDIT_TEST_ACCOUNT_CREATION_STARTED', 'VENDOR_ORGANIZATION', $organization, after: ['attempt_id' => $attempt, 'environment' => 'TEST']);

            return $attempt;
        });
        if ($attempt === null) {
            return;
        }
        try {
            $result = $this->provider->connect($organization);
        } catch (\Throwable) {
            DB::table('vendor_payment_accounts')->where('connection_attempt_id', $attempt)->update(['status' => 'TEST_RECONCILE_REQUIRED', 'connection_error' => 'PROVIDER_OUTCOME_UNCONFIRMED', 'checked_at' => now(), 'updated_at' => now()]);
            $this->audit->account($request, 'XENDIT_TEST_ACCOUNT_CREATION_UNCONFIRMED', 'VENDOR_ORGANIZATION', $organization, after: ['attempt_id' => $attempt]);
            throw new AuthenticationException('XENDIT_RECONCILIATION_REQUIRED', 'Xendit account creation was not confirmed. Reconcile the provider outcome before another attempt.', 503);
        }
        try {
            DB::transaction(function () use ($request, $organization, $attempt, $result): void {
                DB::table('vendor_organizations')->where('id', $organization)->lockForUpdate()->firstOrFail();
                $account = DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organization)->lockForUpdate()->firstOrFail();
                if ($account->connection_attempt_id !== $attempt || $account->status !== 'TEST_CONNECTING' || $account->provider_account_reference !== null) {
                    throw new AuthenticationException('VERSION_CONFLICT', 'The Xendit TEST connection changed while account creation was in progress. Reconcile before continuing.', 409);
                }
                DB::table('vendor_payment_accounts')->where('id', $account->id)->update(['status' => $result['status'], 'provider_status' => $result['provider_status'] ?? null, 'provider_account_reference' => $result['provider_account_reference'], 'evidence_origin' => $result['evidence_origin'], 'capabilities' => json_encode($result['capabilities'], JSON_THROW_ON_ERROR), 'connection_error' => null, 'checked_at' => now(), 'updated_at' => now()]);
                $this->audit->account($request, 'XENDIT_TEST_ACCOUNT_CONNECTED', 'VENDOR_ORGANIZATION', $organization, after: ['attempt_id' => $attempt, 'status' => $result['status'], 'environment' => 'TEST']);
                $this->readiness->reconcile($request, $organization);
            });
        } catch (\Throwable) {
            DB::table('vendor_payment_accounts')->where('connection_attempt_id', $attempt)->whereNull('provider_account_reference')->update(['status' => 'TEST_RECONCILE_REQUIRED', 'connection_error' => 'PROVIDER_CREATED_DATABASE_UNCONFIRMED', 'checked_at' => now(), 'updated_at' => now()]);
            $this->audit->account($request, 'XENDIT_TEST_ACCOUNT_PERSISTENCE_UNCONFIRMED', 'VENDOR_ORGANIZATION', $organization, after: ['attempt_id' => $attempt, 'environment' => 'TEST'], succeeded: false);
            throw new AuthenticationException('XENDIT_RECONCILIATION_REQUIRED', 'Xendit confirmed account creation, but local persistence was not confirmed. Reconcile before continuing.', 503);
        }
    }
}
