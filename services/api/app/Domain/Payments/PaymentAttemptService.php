<?php

declare(strict_types=1);

namespace App\Domain\Payments;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Geography\BuyerProfiles;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderAccess;
use App\Domain\Orders\OrderExpiryService;
use Carbon\CarbonImmutable;
use Illuminate\Database\QueryException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Creates and reads payment attempts. Every attempt reuses the organization-bound, reconciled Phase 3D TEST
 * association: checkout never provisions an account, never accepts a pasted link or account ID and never changes
 * the association's API contract. Before each create the selected adapter revalidates environment, association,
 * purpose and the account's actual payment capability (TEST raw LIVE is TEST readiness only).
 *
 * Payment-attempt idempotency and reconciliation are a separate scope from account provisioning: the stored key
 * is namespaced `payment|…`, an uncertain payment never triggers account creation and an uncertain provisioning
 * attempt never blocks paying through an already-connected account. The provider call runs between two short
 * transactions with no lock held across it; an uncertain create stays UNCERTAIN until reconciled.
 */
final class PaymentAttemptService
{
    public function __construct(
        private readonly PaymentGateway $gateway,
        private readonly PaymentChannelCatalog $channels,
        private readonly PayableAmounts $payable,
        private readonly OrderAccess $orders,
        private readonly BuyerProfiles $profiles,
        private readonly CatalogAccess $keys,
        private readonly AuditRecorder $audit,
        private readonly PaymentPresenter $presenter,
    ) {}

    /** @return array<string, mixed> */
    public function buyerOptions(Request $request, string $orderId): array
    {
        $order = $this->orders->buyerOrder($request, $orderId);
        app(OrderExpiryService::class)->expireIfDue((string) $order->id);
        $order = $this->orders->buyerOrder($request, $orderId);
        $due = $this->payable->resolve($order);
        $latest = DB::table('payments')->where('order_id', $order->id)->orderByDesc('created_at')->orderByDesc('id')->first();
        $descriptor = $this->gateway->descriptor();

        return [
            'order_id' => (string) $order->id, 'order_reference' => (string) $order->reference, 'payment_due' => $due !== null,
            'purpose' => $due['purpose'] ?? null, 'principal_centavos' => $due['principal_centavos'] ?? null, 'breakdown' => $due['breakdown'] ?? null,
            'channels' => $due === null ? [] : $this->channels->options($due['principal_centavos']),
            'pay_by' => $due !== null && $due['purpose'] !== 'ORDER_BALANCE_PAYMENT' ? self::iso($order->payment_expires_at) : null,
            'environment' => 'TEST', 'evidence_origin' => $descriptor->evidenceOrigin, 'provider_ready' => $descriptor->configured,
            'latest_attempt' => $latest === null ? null : $this->presenter->attempt($latest, false),
            'notice' => 'TEST — no real charge. Your order is confirmed only after the payment provider verifies the payment; returning from the payment page alone does not confirm it.',
        ];
    }

    /**
     * @param  array{channel_code: string, expected_total_centavos: int}  $input
     * @return array{attempt: array<string, mixed>, replayed: bool}
     */
    public function createForOrder(Request $request, string $orderId, array $input): array
    {
        $buyerId = $this->profiles->idFor($request);
        $key = $this->keys->requireIdempotencyKey($request);
        $scopedKey = hash('sha256', 'payment|order|'.$buyerId.'|'.$key);
        if (($existing = $this->replay($request, $scopedKey, $orderId)) !== null) {
            return ['attempt' => $this->presenter->attempt($existing, true), 'replayed' => true];
        }
        $order = $this->orders->buyerOrder($request, $orderId);
        $due = $this->payable->resolve($order) ?? throw new AuthenticationException('PAYMENT_NOT_DUE', 'This order has no online payment due right now.', 409, ['order_state' => (string) $order->order_state]);
        $quote = $this->channels->select($input['channel_code'], $due['principal_centavos']);
        if ((int) $input['expected_total_centavos'] !== $quote['total_centavos']) {
            throw new AuthenticationException('PAYMENT_AMOUNT_CHANGED', 'The amount due changed. Review the updated total before paying.', 409, ['total_centavos' => $quote['total_centavos'], 'principal_centavos' => $due['principal_centavos'], 'fee_centavos' => $quote['fee_centavos']]);
        }
        $account = $this->vendorAccount((string) $order->vendor_organization_id);
        $this->revalidate($account);
        // One checkout session lives for a short while and never past the order deadline. When it fails or is
        // abandoned the order stays Pending Payment and the Buyer may open a new session for the same amount.
        $attemptEnds = CarbonImmutable::now()->addMinutes((int) config('payments.order_attempt_minutes', 45));
        $deadline = $due['purpose'] === 'ORDER_BALANCE_PAYMENT' ? null : CarbonImmutable::parse((string) $order->payment_expires_at);
        $expires = $deadline === null || $attemptEnds->lessThan($deadline) ? $attemptEnds : $deadline;
        $this->assertWindow($expires);
        $buyer = DB::table('users as u')->leftJoin('user_profiles as p', 'p.user_id', '=', 'u.id')->where('u.id', $request->user()->getKey())->first(['u.email', 'p.full_name']);
        $paymentId = $this->open($request, $scopedKey, $orderId, function () use ($order, $due, $quote, $account, $expires, $buyerId, $scopedKey, $request): array {
            $locked = DB::table('orders')->where('id', $order->id)->lockForUpdate()->first();
            $current = $this->payable->resolve($locked);
            if ($current === null || $current['purpose'] !== $due['purpose'] || $current['principal_centavos'] !== $due['principal_centavos']) {
                throw new AuthenticationException('PAYMENT_AMOUNT_CHANGED', 'The amount due changed. Review the updated total before paying.', 409);
            }
            // Re-check the deadline under the order lock: the expiry job takes the same lock, so a payment can never
            // be opened for an order the job is about to cancel.
            if ($due['purpose'] !== 'ORDER_BALANCE_PAYMENT' && ($locked->payment_expires_at === null || CarbonImmutable::parse((string) $locked->payment_expires_at)->lessThanOrEqualTo(CarbonImmutable::now()))) {
                throw new AuthenticationException('PAYMENT_WINDOW_EXPIRED', 'The payment deadline for this order has passed.', 409);
            }

            return $this->row($scopedKey, $request, [
                'order_id' => $order->id, 'vendor_organization_id' => $order->vendor_organization_id, 'buyer_profile_id' => $buyerId, 'financial_snapshot_id' => $due['financial_snapshot_id'],
                'purpose' => $due['purpose'], 'account_scope' => 'VENDOR_SUB_ACCOUNT', 'provider_account_id' => $account->provider_account_id, 'account_contract_version' => $account->provider_api_version,
                'principal_centavos' => $due['principal_centavos'], 'processing_fee_centavos' => $quote['fee_centavos'], 'total_centavos' => $quote['total_centavos'],
                'expires_at' => $expires, 'amount_breakdown' => $due['breakdown'] + ['principal_centavos' => $due['principal_centavos'], 'processing_fee_centavos' => $quote['fee_centavos']],
            ], $quote, 'order', (string) $order->id);
        });

        return ['attempt' => $this->presenter->attempt($this->send($paymentId, 'Order '.$order->reference.' — '.PaymentSettlement::label($due['purpose']).' (TEST)', $account->provider_account_id,
            ['reference_id' => 'buyer-'.substr(hash('sha256', $buyerId), 0, 24), 'given_names' => (string) ($buyer->full_name ?? 'MateryalPH Buyer'), 'email' => $buyer->email ?? null]), true), 'replayed' => false];
    }

    /**
     * Vendor Owner pays a positive issued statement to the platform TEST account under PLATFORM_FEE_PAYMENT. The
     * platform absorbs its own processing charge; there is no automatic debit, withdrawal, wallet or split. An open
     * attempt is reconciled first so a late success of an earlier attempt is ruled out before another charge.
     *
     * @param  array{channel_code: string, amount_centavos?: int|null}  $input
     * @return array{attempt: array<string, mixed>, replayed: bool}
     */
    public function createForStatement(Request $request, string $organizationId, string $statementId, array $input): array
    {
        $key = $this->keys->requireIdempotencyKey($request);
        $scopedKey = hash('sha256', 'payment|statement|'.$request->user()->getKey().'|'.$key);
        if (($existing = $this->replay($request, $scopedKey, $statementId)) !== null) {
            return ['attempt' => $this->presenter->attempt($existing, true), 'replayed' => true];
        }
        $statement = $this->statement($organizationId, $statementId);
        foreach (DB::table('payments')->where('fee_statement_id', $statementId)->whereIn('state', PaymentSettlement::OPEN_STATES)->pluck('id') as $openId) {
            app(PaymentReconciliationService::class)->reconcile((string) $openId, 'RECONCILIATION');
        }
        $statement = $this->statement($organizationId, $statementId);
        $outstanding = (int) $statement->outstanding_centavos;
        $amount = (int) ($input['amount_centavos'] ?? $outstanding);
        if (! in_array($statement->state, ['ISSUED', 'PARTIALLY_PAID'], true) || $outstanding <= 0) {
            throw new AuthenticationException('STATEMENT_NOT_PAYABLE', 'Only an issued statement with an outstanding amount can be paid.', 409, ['state' => (string) $statement->state]);
        }
        if ($amount < 1 || $amount > $outstanding) {
            throw new AuthenticationException('PAYMENT_AMOUNT_INVALID', 'Pay an amount above zero and no more than the outstanding balance.', 422, ['amount_centavos' => ['The outstanding balance is ₱'.number_format($outstanding / 100, 2).'.']]);
        }
        if (! $this->gateway->descriptor()->configured) {
            throw new AuthenticationException('PAYMENT_PROVIDER_UNAVAILABLE', 'Online payment is temporarily unavailable. Try again later.', 503);
        }
        $quote = $this->channels->select($input['channel_code'], $amount, 'PLATFORM');
        $expires = CarbonImmutable::now()->addMinutes((int) config('payments.platform_fee_attempt_minutes', 45));
        $owner = DB::table('users as u')->leftJoin('user_profiles as p', 'p.user_id', '=', 'u.id')->where('u.id', $request->user()->getKey())->first(['u.email', 'p.full_name']);
        $paymentId = $this->open($request, $scopedKey, $statementId, function () use ($statement, $amount, $quote, $expires, $scopedKey, $request, $organizationId): array {
            $locked = DB::table('fee_statements')->where('id', $statement->id)->lockForUpdate()->first();
            if ((int) $locked->outstanding_centavos < $amount || ! in_array($locked->state, ['ISSUED', 'PARTIALLY_PAID'], true)) {
                throw new AuthenticationException('STATEMENT_CHANGED', 'The statement changed. Refresh before paying.', 409);
            }

            return $this->row($scopedKey, $request, [
                'fee_statement_id' => $statement->id, 'vendor_organization_id' => $organizationId, 'purpose' => 'PLATFORM_FEE_PAYMENT', 'account_scope' => 'PLATFORM_ACCOUNT',
                'provider_account_id' => PaymentSettlement::platformAccount(), 'account_contract_version' => null, 'principal_centavos' => $amount, 'processing_fee_centavos' => 0,
                'total_centavos' => $amount, 'expires_at' => $expires, 'amount_breakdown' => ['statement_outstanding_centavos' => (int) $locked->outstanding_centavos, 'installment' => $amount < (int) $locked->outstanding_centavos ? 1 : 0, 'platform_absorbed_charge_centavos' => $quote['provider_charge_centavos']],
            ], $quote, 'statement', (string) $statement->id);
        });

        return ['attempt' => $this->presenter->attempt($this->send($paymentId, 'MateryalPH platform fee '.$statement->statement_reference.' (TEST)', PaymentSettlement::platformAccount(),
            ['reference_id' => 'vendor-'.substr(hash('sha256', $organizationId), 0, 24), 'given_names' => (string) ($owner->full_name ?? 'Vendor Owner'), 'email' => $owner->email ?? null]), true), 'replayed' => false];
    }

    /** @return array<string, mixed> */
    public function buyerAttempt(Request $request, string $paymentId): array
    {
        return $this->presenter->attempt($this->buyerPayment($request, $paymentId), true);
    }

    /**
     * Buyer asks for a fresh provider check; the result is still only what the provider authoritatively reports.
     *
     * @return array<string, mixed>
     */
    public function buyerRefresh(Request $request, string $paymentId): array
    {
        $payment = $this->buyerPayment($request, $paymentId);
        if (in_array($payment->state, PaymentSettlement::OPEN_STATES, true)) {
            app(PaymentReconciliationService::class)->reconcile((string) $payment->id, 'RECONCILIATION');
        }

        return $this->presenter->attempt(DB::table('payments')->where('id', $payment->id)->first(), true);
    }

    public function buyerPayment(Request $request, string $paymentId): object
    {
        $buyerId = $this->profiles->idFor($request);
        $payment = Str::isUuid($paymentId) ? DB::table('payments')->where('id', $paymentId)->where('buyer_profile_id', $buyerId)->first() : null;

        return $payment ?? throw new AuthenticationException('PAYMENT_NOT_FOUND', 'This payment is unavailable.', 404);
    }

    private function revalidate(object $account): void
    {
        $descriptor = $this->gateway->descriptor();
        if (! $descriptor->configured) {
            throw new AuthenticationException('PAYMENT_PROVIDER_UNAVAILABLE', 'Online payment is temporarily unavailable. Try again later.', 503);
        }
        if ($account->environment !== $descriptor->environment) {
            throw new AuthenticationException('PAYMENT_ENVIRONMENT_MISMATCH', 'This store\'s payment connection belongs to a different environment.', 409);
        }
        if ((string) $account->provider_api_version !== $descriptor->accountContractVersion) {
            // A contract change is an explicit migration decision, never an automatic fallback.
            throw new AuthenticationException('PAYMENT_CONTRACT_MISMATCH', 'This store\'s payment connection uses a different provider contract and needs reconciliation before payments.', 409);
        }
        try {
            $capability = $this->gateway->verifyAccount((string) $account->provider_account_id);
        } catch (PaymentProviderException) {
            throw new AuthenticationException('PAYMENT_PROVIDER_UNAVAILABLE', 'The payment provider could not confirm this store right now. Try again shortly.', 503);
        }
        if ($capability->providerAccountId !== $account->provider_account_id || $capability->environment !== 'TEST' || ! $capability->canAcceptPayments) {
            throw new AuthenticationException('VENDOR_PAYMENT_ACCOUNT_NOT_READY', 'This store cannot accept online payment right now. Choose another payment method or try later.', 409, ['reason' => $capability->reason]);
        }
    }

    private function vendorAccount(string $organizationId): object
    {
        $account = DB::table('vendor_payment_accounts')->where('vendor_organization_id', $organizationId)->first();
        if ($account === null || $account->provider_associated_at === null || empty($account->provider_account_id) || $account->connection_status !== 'CONNECTED_TEST') {
            throw new AuthenticationException('VENDOR_PAYMENT_ACCOUNT_NOT_READY', 'This store cannot accept online payment right now.', 409);
        }

        return $account;
    }

    private function assertWindow(CarbonImmutable $expires): void
    {
        $minimum = $this->gateway->descriptor()->minimumExpirySeconds;
        if ($expires->lessThanOrEqualTo(CarbonImmutable::now()->addSeconds(max(30, $minimum)))) {
            throw new AuthenticationException('PAYMENT_WINDOW_TOO_SHORT', 'Too little time remains in the payment window to open a new payment.', 409, ['expires_at' => $expires->toIso8601String()]);
        }
    }

    /**
     * Inserts the CREATING attempt in a short transaction. An already-open attempt for the same purpose blocks a
     * second charge; a matching PENDING attempt is returned for reuse instead of creating another session.
     *
     * @param  callable(): array{0: string, 1: bool}  $insert
     */
    private function open(Request $request, string $scopedKey, string $scopeId, callable $insert): string
    {
        try {
            [$paymentId, $reused] = DB::transaction(function () use ($insert): array {
                return $insert();
            });
        } catch (QueryException $exception) {
            $existing = DB::table('payments')->where('idempotency_key', $scopedKey)->value('id');
            if ($existing !== null) {
                return (string) $existing;
            }
            throw new AuthenticationException('PAYMENT_ATTEMPT_IN_PROGRESS', 'A payment for this item is already in progress. Check its status before trying again.', 409);
        }
        if ($reused) {
            throw new AuthenticationException('PAYMENT_ATTEMPT_IN_PROGRESS', 'A payment for this item is already in progress. Check its status before trying again.', 409, ['payment_id' => $paymentId]);
        }

        return $paymentId;
    }

    /**
     * @param  array<string, mixed>  $values
     * @param  array{version: object, fee_centavos: int, provider_charge_centavos: int, total_centavos: int, calculation: array<string, mixed>}  $quote
     * @return array{0: string, 1: bool}
     */
    private function row(string $scopedKey, Request $request, array $values, array $quote, string $scope, string $scopeId): array
    {
        $column = $scope === 'order' ? 'order_id' : 'fee_statement_id';
        $open = DB::table('payments')->where($column, $scopeId)->where('purpose', $values['purpose'])->whereIn('state', PaymentSettlement::OPEN_STATES)->first(['id']);
        if ($open !== null) {
            return [(string) $open->id, true];
        }
        $descriptor = $this->gateway->descriptor();
        $id = (string) Str::uuid7();
        $attempt = (int) DB::table('payments')->where($column, $scopeId)->where('purpose', $values['purpose'])->count() + 1;
        $breakdown = $values['amount_breakdown'];
        unset($values['amount_breakdown']);
        DB::table('payments')->insert($values + [
            'id' => $id, 'environment' => 'TEST', 'provider' => 'XENDIT', 'currency' => 'PHP', 'state' => 'CREATING', 'idempotency_key' => $scopedKey, 'attempt_number' => $attempt,
            'provider_api_version' => $descriptor->paymentApiVersion, 'gateway_mode' => $descriptor->mode, 'evidence_origin' => $descriptor->evidenceOrigin,
            'channel_code' => $quote['version']->channel_code, 'channel_fee_version_id' => $quote['version']->id, 'amount_breakdown' => json_encode($breakdown, JSON_THROW_ON_ERROR),
            'provider_charge_centavos' => $quote['provider_charge_centavos'], 'created_by_user_id' => $request->user()->getKey(), 'reconciliation_state' => 'PENDING',
            'lock_version' => 1, 'created_at' => now(), 'updated_at' => now(),
        ]);
        DB::table('processing_fee_snapshots')->insert(['id' => (string) Str::uuid7(), 'payment_id' => $id, 'channel' => $quote['version']->channel_code, 'quoted_centavos' => $quote['fee_centavos'],
            'calculation' => json_encode($quote['calculation'], JSON_THROW_ON_ERROR), 'policy_version' => $quote['version']->channel_code.'.v'.$quote['version']->version,
            'channel_fee_version_id' => $quote['version']->id, 'principal_centavos' => (int) $values['principal_centavos'], 'fee_bearer' => $values['purpose'] === 'PLATFORM_FEE_PAYMENT' ? 'PLATFORM' : 'BUYER',
            'created_at' => now(), 'updated_at' => now()]);
        $this->keys->claim($request, 'PAYMENT_CREATE', (string) $request->header('Idempotency-Key'), $scopeId, 201);
        $this->audit->account($request, 'PAYMENT_ATTEMPT_CREATED', 'PAYMENT', $id, after: ['purpose' => $values['purpose'], 'channel' => $quote['version']->channel_code,
            'principal_centavos' => (int) $values['principal_centavos'], 'fee_centavos' => $quote['fee_centavos'], 'total_centavos' => $quote['total_centavos'], 'evidence_origin' => $descriptor->evidenceOrigin]);

        return [$id, false];
    }

    /** @param array{reference_id: string, given_names: string, email: ?string} $customer */
    private function send(string $paymentId, string $description, ?string $forUserId, array $customer): object
    {
        $payment = DB::table('payments')->where('id', $paymentId)->first();
        if ($payment->state !== 'CREATING') {
            return $payment;
        }
        $version = DB::table('payment_channel_fee_versions')->where('id', $payment->channel_fee_version_id)->first();
        $returnBase = rtrim((string) config('app.url'), '/');
        $returnUrl = str_starts_with($returnBase, 'https://') ? $returnBase.'/api/v1/payments/return?attempt='.$paymentId : null;
        $correlation = (string) Str::uuid7();
        try {
            $result = $this->gateway->createSession(new SessionRequest($paymentId, (int) $payment->total_centavos, 'PHP', (string) $version->provider_channel_code,
                CarbonImmutable::parse((string) $payment->expires_at), $description, $forUserId, $customer, $returnUrl, $returnUrl));
        } catch (PaymentProviderException $exception) {
            DB::transaction(function () use ($payment, $exception, $correlation): void {
                $state = $exception->kind === PaymentProviderException::REJECTED ? 'FAILED' : 'UNCERTAIN';
                DB::table('payments')->where('id', $payment->id)->where('state', 'CREATING')->update(['state' => $state, 'failure_code' => $exception->safeCode,
                    'failed_at' => $state === 'FAILED' ? now() : null, 'reconciliation_state' => $state === 'FAILED' ? 'NOT_REQUIRED' : 'PENDING', 'updated_at' => now()]);
                $this->log((string) $payment->id, 'CREATE', $state === 'FAILED' ? 'REJECTED' : 'UNCERTAIN', $exception->httpStatus, $exception->providerRequestId, ['code' => $exception->safeCode], $correlation);
            });
            $fresh = DB::table('payments')->where('id', $paymentId)->first();
            if ($fresh->state === 'FAILED') {
                throw new AuthenticationException('PAYMENT_PROVIDER_REJECTED', 'The payment provider could not start this payment. Choose another channel or try again.', 422, ['payment_id' => $paymentId]);
            }

            return $fresh;
        }
        DB::transaction(function () use ($payment, $result, $correlation): void {
            DB::table('payments')->where('id', $payment->id)->where('state', 'CREATING')->update(['state' => 'PENDING', 'provider_session_id' => $result->sessionId,
                'provider_reference' => $result->sessionId, 'checkout_url_encrypted' => $result->checkoutUrl === null ? null : Crypt::encryptString($result->checkoutUrl),
                'provider_created_at' => now(), 'updated_at' => now()]);
            $this->log((string) $payment->id, 'CREATE', 'CREATED', 201, $result->providerRequestId, ['session_status' => $result->status], $correlation);
        });

        return DB::table('payments')->where('id', $paymentId)->first();
    }

    /** @param array<string, mixed> $safe */
    public function log(string $paymentId, string $operation, string $state, ?int $httpStatus, ?string $requestId, array $safe, string $correlationId): void
    {
        DB::table('payment_attempts')->insert(['id' => (string) Str::uuid7(), 'payment_id' => $paymentId, 'provider_event_id' => null, 'state' => $state, 'operation' => $operation,
            'http_status' => $httpStatus, 'provider_request_id' => $requestId, 'correlation_id' => mb_substr($correlationId, 0, 64), 'safe_payload' => json_encode($safe, JSON_THROW_ON_ERROR),
            'created_at' => now(), 'updated_at' => now()]);
    }

    private function replay(Request $request, string $scopedKey, string $scopeId): ?object
    {
        $existing = DB::table('payments')->where('idempotency_key', $scopedKey)->first();
        if ($existing === null) {
            return null;
        }
        if (! $this->keys->replayed($request, 'PAYMENT_CREATE', (string) $request->header('Idempotency-Key'), $scopeId)) {
            throw new AuthenticationException('IDEMPOTENCY_CONFLICT', 'Use a new request identifier for a different payment.', 409);
        }

        return $existing;
    }

    private function statement(string $organizationId, string $statementId): object
    {
        $statement = Str::isUuid($statementId) ? DB::table('fee_statements')->where('id', $statementId)->where('vendor_organization_id', $organizationId)->first() : null;

        return $statement ?? throw new AuthenticationException('STATEMENT_NOT_FOUND', 'This statement is unavailable.', 404);
    }

    private static function iso(mixed $value): ?string
    {
        return $value === null ? null : CarbonImmutable::parse((string) $value)->toIso8601String();
    }
}
