<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;

final class ReconcileXenditTestAccount
{
    public function __construct(private readonly OnboardingAccess $access, private readonly TestConnectionProvider $provider, private readonly ActivationReadiness $readiness, private readonly AuditRecorder $audit) {}

    /** @return array<string, mixed> */
    public function handle(Request $request, string $organization, int $version): array
    {
        $this->access->vendor($request, $organization, 'payments.configure', true);
        $attempt = DB::transaction(function () use ($request, $organization, $version): string {
            $org = DB::table('vendor_organizations')->where('id', $organization)->lockForUpdate()->firstOrFail();
            $this->access->version($org, $version);
            $account = DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organization)->lockForUpdate()->first();
            $recoverableConnectingAttempt = $account?->status === 'TEST_CONNECTING'
                && Carbon::parse($account->updated_at)->lte(now()->subMinute());
            if ($account === null || $account->environment !== 'TEST' || $account->provider !== 'XENDIT' || (! $recoverableConnectingAttempt && $account->status !== 'TEST_RECONCILE_REQUIRED') || $account->connection_attempt_id === null || $account->provider_account_reference !== null) {
                throw new AuthenticationException('XENDIT_RECONCILIATION_NOT_REQUIRED', 'This Vendor does not have an uncertain Xendit TEST creation attempt.', 409);
            }
            $this->audit->account($request, 'XENDIT_TEST_RECONCILIATION_STARTED', 'VENDOR_ORGANIZATION', $organization, after: ['attempt_id' => $account->connection_attempt_id, 'environment' => 'TEST']);

            return $account->connection_attempt_id;
        });

        try {
            $result = $this->provider->reconcile($organization);
        } catch (\Throwable $exception) {
            $this->audit->account($request, 'XENDIT_TEST_RECONCILIATION_BLOCKED', 'VENDOR_ORGANIZATION', $organization, after: ['attempt_id' => $attempt, 'outcome' => $exception instanceof AuthenticationException ? $exception->errorCode : 'UNAVAILABLE'], succeeded: false);
            throw $exception;
        }
        if (! in_array($result['outcome'], ['FOUND', 'NOT_FOUND'], true)) {
            $this->audit->account($request, 'XENDIT_TEST_RECONCILIATION_BLOCKED', 'VENDOR_ORGANIZATION', $organization, after: ['attempt_id' => $attempt, 'outcome' => 'UNVERIFIED'], succeeded: false);
            throw new AuthenticationException('XENDIT_RECONCILIATION_UNVERIFIED', 'Xendit reconciliation did not produce an authoritative result. No new account was created.', 503);
        }

        return DB::transaction(function () use ($request, $organization, $attempt, $result): array {
            $org = DB::table('vendor_organizations')->where('id', $organization)->lockForUpdate()->firstOrFail();
            $account = DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organization)->lockForUpdate()->firstOrFail();
            if ($account->connection_attempt_id !== $attempt || ! in_array($account->status, ['TEST_CONNECTING', 'TEST_RECONCILE_REQUIRED'], true) || $account->provider_account_reference !== null) {
                throw new AuthenticationException('VERSION_CONFLICT', 'The Xendit connection changed during reconciliation. Reload before continuing.', 409);
            }

            if ($result['outcome'] === 'FOUND') {
                DB::table('vendor_payment_accounts')->where('id', $account->id)->update(['status' => $result['status'], 'provider_status' => $result['provider_status'], 'provider_account_reference' => $result['provider_account_reference'], 'capabilities' => json_encode($result['capabilities'], JSON_THROW_ON_ERROR), 'connection_error' => null, 'checked_at' => now(), 'updated_at' => now()]);
                $action = 'XENDIT_TEST_RECONCILIATION_MATCHED';
            } elseif ($result['outcome'] === 'NOT_FOUND') {
                DB::table('vendor_payment_accounts')->where('id', $account->id)->update(['status' => 'TEST_RETRY_ALLOWED', 'provider_status' => null, 'connection_attempt_id' => null, 'connection_error' => null, 'checked_at' => now(), 'updated_at' => now()]);
                $action = 'XENDIT_TEST_RECONCILIATION_RETRY_ALLOWED';
            }
            DB::table('vendor_organizations')->where('id', $organization)->update(['lock_version' => $org->lock_version + 1, 'updated_at' => now()]);
            $this->audit->account($request, $action, 'VENDOR_ORGANIZATION', $organization, after: ['attempt_id' => $attempt, 'outcome' => $result['outcome'], 'environment' => 'TEST', 'provider_status' => $result['provider_status'] ?? null]);
            $this->readiness->reconcile($request, $organization);

            return app(VendorSetup::class)->read($request, $organization);
        });
    }
}
