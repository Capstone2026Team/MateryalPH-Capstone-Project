<?php

declare(strict_types=1);

namespace App\Domain\Orders;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\OutboxPublisher;
use App\Domain\Projects\ProjectBudget;
use App\Domain\Projects\ProjectService;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Buyer decisions on the latest Vendor commercial version. Approval applies only to the exact version shown;
 * a stale version is a conflict. An NRPC is accepted only with its record id and the NRPC Terms version that
 * was displayed; rejection of a revision or NRPC cancels the request and releases the reservation. A flag that
 * an NRPC is disproportionate is a separate review record and never accepts, rejects or changes anything.
 */
final class BuyerOrderDecisionService
{
    public function __construct(
        private readonly OrderAccess $access,
        private readonly OrderCommercial $commercial,
        private readonly OrderTransitionService $transitions,
        private readonly OrderAcceptance $acceptance,
        private readonly OrderRelease $release,
        private readonly OrderNotifier $notifier,
        private readonly NrpcTerms $terms,
        private readonly OutboxPublisher $outbox,
        private readonly AuditRecorder $audit,
        private readonly CatalogAccess $idempotency,
    ) {}

    /** @param array{snapshot_version: int} $input */
    public function approveRevision(Request $request, string $orderId, array $input): void
    {
        $this->decide($request, $orderId, 'ORDER_BUYER_APPROVE', function (object $order, OrderActor $actor) use ($input, $request): void {
            $this->assertAwaiting($order, OrderStates::AWAITING_BUYER_APPROVAL, (int) $input['snapshot_version']);
            $snapshot = $this->commercial->version((string) $order->id, (int) $order->current_snapshot_version);
            $nrpc = $this->nrpcFor($order);
            if ($nrpc !== null) {
                $order = $this->transitions->apply($order, [OrderStates::ORDER => OrderStates::AWAITING_NRPC_ACCEPTANCE], $actor, 'BUYER_APPROVED_REVISION', null, [], (int) $snapshot->version);
            } else {
                $order = $this->acceptance->accept($order, $snapshot, OrderCommercial::content($snapshot)['commercial'], null, $actor, 'BUYER_APPROVED_REVISION');
            }
            $this->notifier->vendor($order, 'Buyer approved order '.$order->reference, 'The Buyer approved your confirmed version.'.($nrpc !== null ? ' The NRPC still needs the Buyer\'s acceptance.' : ''));
            $this->audit->account($request, 'ORDER_REVISION_APPROVED', 'ORDER', (string) $order->id, after: ['snapshot_version' => (int) $snapshot->version]);
        });
    }

    /** @param array{snapshot_version: int, reason?: ?string} $input */
    public function rejectRevision(Request $request, string $orderId, array $input): void
    {
        $this->decide($request, $orderId, 'ORDER_BUYER_REJECT', function (object $order, OrderActor $actor) use ($input, $request): void {
            $this->assertAwaiting($order, OrderStates::AWAITING_BUYER_APPROVAL, (int) $input['snapshot_version']);
            $this->cancel($order, $actor, 'BUYER_REJECTED_REVISION', $input['reason'] ?? null);
            $this->audit->account($request, 'ORDER_REVISION_REJECTED', 'ORDER', (string) $order->id, reason: $input['reason'] ?? null);
        });
    }

    /** @param array{snapshot_version: int, nrpc_id: string, terms_version_id: string, acknowledged: bool} $input */
    public function acceptNrpc(Request $request, string $orderId, array $input): void
    {
        $this->decide($request, $orderId, 'ORDER_NRPC_ACCEPT', function (object $order, OrderActor $actor) use ($input, $request): void {
            $this->assertAwaiting($order, OrderStates::AWAITING_NRPC_ACCEPTANCE, (int) $input['snapshot_version']);
            $nrpc = $this->nrpcFor($order);
            if ($nrpc === null || (string) $nrpc->id !== $input['nrpc_id']) {
                throw new AuthenticationException('NRPC_CHANGED', 'This NRPC is no longer the current proposal. Review the latest one.', 409);
            }
            $terms = $this->terms->version((string) $nrpc->agreement_version_id);
            if ($terms === null || $terms['id'] !== $input['terms_version_id'] || $terms['content'] === null) {
                throw new AuthenticationException('NRPC_TERMS_CHANGED', 'Review the NRPC Terms version shown with this proposal before accepting.', 409);
            }
            if ($input['acknowledged'] !== true) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['acknowledged' => ['Confirm that you reviewed the amount, reason, affected lines and Terms.']]);
            }
            DB::table('nrpc_acceptances')->insert(['id' => (string) Str::uuid7(), 'order_id' => $order->id, 'nrpc_record_id' => $nrpc->id, 'agreement_version_id' => $terms['id'], 'decision' => 'ACCEPTED',
                'actor_user_id' => $actor->userId, 'state' => 'ACCEPTED', 'payload' => json_encode(['amount_centavos' => (int) $nrpc->amount_centavos, 'terms_version' => $terms['version'],
                    'terms_content_hash' => $terms['content_hash'], 'snapshot_version' => (int) $order->current_snapshot_version], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
            $snapshot = $this->commercial->version((string) $order->id, (int) $order->current_snapshot_version);
            $order = $this->acceptance->accept($order, $snapshot, OrderCommercial::content($snapshot)['commercial'], (string) $nrpc->id, $actor, 'BUYER_ACCEPTED_NRPC');
            $this->outbox->publish('NRPC_DECIDED', 'ORDER', (string) $order->id, ['order_id' => (string) $order->id, 'nrpc_record_id' => (string) $nrpc->id, 'decision' => 'ACCEPTED']);
            $this->notifier->vendor($order, 'Buyer accepted the NRPC for '.$order->reference, 'The Buyer accepted the Non-Recoverable Preparation Cost and its Terms.');
            $this->audit->account($request, 'NRPC_ACCEPTED', 'NRPC_RECORD', (string) $nrpc->id, after: ['terms_version' => $terms['version'], 'amount_centavos' => (int) $nrpc->amount_centavos]);
        });
    }

    /** @param array{snapshot_version: int, nrpc_id: string, reason?: ?string} $input */
    public function rejectNrpc(Request $request, string $orderId, array $input): void
    {
        $this->decide($request, $orderId, 'ORDER_NRPC_REJECT', function (object $order, OrderActor $actor) use ($input, $request): void {
            $this->assertAwaiting($order, OrderStates::AWAITING_NRPC_ACCEPTANCE, (int) $input['snapshot_version']);
            $nrpc = $this->nrpcFor($order);
            if ($nrpc === null || (string) $nrpc->id !== $input['nrpc_id']) {
                throw new AuthenticationException('NRPC_CHANGED', 'This NRPC is no longer the current proposal. Review the latest one.', 409);
            }
            DB::table('nrpc_acceptances')->insert(['id' => (string) Str::uuid7(), 'order_id' => $order->id, 'nrpc_record_id' => $nrpc->id, 'decision' => 'REJECTED', 'actor_user_id' => $actor->userId,
                'state' => 'REJECTED', 'reason' => $input['reason'] ?? null, 'created_at' => now(), 'updated_at' => now()]);
            $this->cancel($order, $actor, 'BUYER_REJECTED_NRPC', $input['reason'] ?? null);
            $this->outbox->publish('NRPC_DECIDED', 'ORDER', (string) $order->id, ['order_id' => (string) $order->id, 'nrpc_record_id' => (string) $nrpc->id, 'decision' => 'REJECTED']);
            $this->audit->account($request, 'NRPC_REJECTED', 'NRPC_RECORD', (string) $nrpc->id, reason: $input['reason'] ?? null);
        });
    }

    /** @param array{nrpc_id: string, reason: string} $input */
    public function flagNrpc(Request $request, string $orderId, array $input): void
    {
        $this->decide($request, $orderId, 'ORDER_NRPC_FLAG', function (object $order, OrderActor $actor) use ($input, $request): void {
            $nrpc = DB::table('nrpc_records')->where('order_id', $order->id)->where('id', Str::isUuid($input['nrpc_id']) ? $input['nrpc_id'] : '00000000-0000-0000-0000-000000000000')->first();
            if ($nrpc === null || in_array($order->order_state, [OrderStates::DECLINED, OrderStates::EXPIRED, OrderStates::CANCELLED, OrderStates::COMPLETED], true)) {
                throw new AuthenticationException('NRPC_FLAG_UNAVAILABLE', 'This NRPC can no longer be flagged here. Use the dispute process for a completed order.', 409);
            }
            if (DB::table('nrpc_acceptances')->where('nrpc_record_id', $nrpc->id)->where('decision', 'FLAGGED')->exists()) {
                throw new AuthenticationException('NRPC_ALREADY_FLAGGED', 'You already flagged this NRPC. It is waiting for review.', 409);
            }
            $reason = trim($input['reason']);
            DB::table('nrpc_acceptances')->insert(['id' => (string) Str::uuid7(), 'order_id' => $order->id, 'nrpc_record_id' => $nrpc->id, 'decision' => 'FLAGGED', 'review_state' => 'PENDING_ADMIN_REVIEW',
                'actor_user_id' => $actor->userId, 'state' => 'FLAGGED', 'reason' => $reason, 'created_at' => now(), 'updated_at' => now()]);
            $this->outbox->publish('NRPC_FLAGGED', 'ORDER', (string) $order->id, ['order_id' => (string) $order->id, 'nrpc_record_id' => (string) $nrpc->id]);
            $this->audit->account($request, 'NRPC_FLAGGED', 'NRPC_RECORD', (string) $nrpc->id, reason: $reason);
        });
    }

    /** The NRPC proposed with the order's current commercial version, if any. */
    public function nrpcFor(object $order): ?object
    {
        return DB::table('nrpc_records')->where('order_id', $order->id)->where('order_snapshot_version', (int) $order->current_snapshot_version)->first();
    }

    private function decide(Request $request, string $orderId, string $endpoint, callable $apply): void
    {
        $key = $this->idempotency->requireIdempotencyKey($request);
        $actor = OrderActor::buyer($request);
        DB::transaction(function () use ($request, $orderId, $endpoint, $apply, $key, $actor): void {
            $preview = $this->access->buyerOrder($request, $orderId);
            if ($preview->work_package_id !== null) {
                $package = app(ProjectService::class)->package($request, $preview->work_package_id, true);
            }
            $order = $this->access->buyerOrder($request, $orderId, true);
            if ($this->idempotency->replayed($request, $endpoint, $key, $orderId)) {
                return;
            }
            if (isset($package) && in_array($endpoint, ['ORDER_BUYER_APPROVE', 'ORDER_NRPC_ACCEPT'], true)) {
                app(ProjectBudget::class)->guard($request, $package, (int) $order->commercial_total_centavos, $request->all(), $orderId);
            }
            $apply($order, $actor);
            $this->idempotency->claim($request, $endpoint, $key, $orderId, 200);
        });
    }

    private function assertAwaiting(object $order, string $state, int $snapshotVersion): void
    {
        if ($order->order_state !== $state) {
            throw new AuthenticationException('ORDER_STATE_CONFLICT', 'This order changed and the action is no longer available. Refresh to see its current state.', 409, ['current_state' => $order->order_state]);
        }
        if ((int) $order->current_snapshot_version !== $snapshotVersion) {
            throw new AuthenticationException('STALE_VERSION', 'The Vendor changed this order. Review the latest version before deciding.', 409, ['current_snapshot_version' => (int) $order->current_snapshot_version]);
        }
        if ($order->buyer_response_due_at !== null && CarbonImmutable::parse((string) $order->buyer_response_due_at)->lessThanOrEqualTo(now())) {
            throw new AuthenticationException('RESPONSE_WINDOW_CLOSED', 'The response window for this order has ended and its reservation is being released.', 409);
        }
    }

    private function cancel(object $order, OrderActor $actor, string $reasonCode, ?string $reason): void
    {
        $this->release->release($order, OrderStates::CANCELLED, $reasonCode, $actor);
        $order = $this->transitions->apply($order, [OrderStates::ORDER => OrderStates::CANCELLED], $actor, $reasonCode, $reason, ['buyer_response_due_at' => null]);
        $this->notifier->vendor($order, 'Order '.$order->reference.' was not accepted', 'The Buyer did not accept your confirmed version. The reserved stock was released.');
    }
}
