<?php

declare(strict_types=1);

namespace App\Domain\Fulfillment;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Inventory\InventoryLedgerWriter;
use App\Domain\Messaging\FulfillmentThreadService;
use App\Domain\Orders\OrderAccess;
use App\Domain\Orders\OrderActor;
use App\Domain\Orders\OrderNotifier;
use App\Domain\Orders\OrderStates;
use App\Domain\Orders\OrderTransitionService;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Throwable;

/**
 * Vendor fulfillment milestones through the shared order state machine:
 *
 *   CONFIRMED → PROCESSING → READY_FOR_PICKUP (Self-Pickup) | OUT_FOR_DELIVERY (Site Delivery) → PICKED_UP | DELIVERED
 *
 * Owner and Store Manager act on any order; Fulfillment Staff act only on orders currently assigned to them; other
 * roles never record milestones. Proof belongs to the milestone that requires it: Site Delivery needs a delivery
 * photo and receiver name (signature optional); Self-Pickup needs a confirmed handover with the Buyer or an
 * authorized receiver. Dispatch and trips must name a vehicle and trip of the accepted delivery snapshot; no request
 * here can change a price, fee, vehicle configuration or accepted commercial term. A repeated milestone is an
 * idempotent replay (same key) or a 409; an out-of-order milestone is a 409 and changes nothing. No milestone moves
 * while a cancellation request is open.
 */
final class FulfillmentService
{
    /** milestone => [required current order state, fulfillment method or null] */
    private const STEPS = [
        OrderStates::PROCESSING => [OrderStates::CONFIRMED, null],
        OrderStates::READY_FOR_PICKUP => [OrderStates::PROCESSING, 'PICKUP'],
        OrderStates::OUT_FOR_DELIVERY => [OrderStates::PROCESSING, 'DELIVERY'],
        OrderStates::PICKED_UP => [OrderStates::READY_FOR_PICKUP, 'PICKUP'],
        OrderStates::DELIVERED => [OrderStates::OUT_FOR_DELIVERY, 'DELIVERY'],
    ];

    public const VEHICLE_ISSUES = ['BREAKDOWN', 'CAPACITY_SHORTFALL', 'ACCESS_BLOCKED', 'DELAY', 'OTHER'];

    public function __construct(
        private readonly OrderAccess $access,
        private readonly CatalogAccess $keys,
        private readonly OrderTransitionService $transitions,
        private readonly FulfillmentRecords $records,
        private readonly FulfillmentThreadService $threads,
        private readonly InventoryLedgerWriter $ledger,
        private readonly OrderEvidenceFiles $files,
        private readonly OrderNotifier $notifier,
        private readonly AuditRecorder $audit,
    ) {}

    /** @return list<array{user_id: int, display_name: string, assigned: bool}> */
    public function assignees(Request $request, string $orderId): array
    {
        $scope = $this->access->vendorScope($request);
        $this->access->require($scope, OrderAccess::ASSIGN_FULFILLMENT, 'Only the Owner or Store Manager can assign Fulfillment Staff.');
        $order = $this->access->vendorOrder($scope, $orderId);
        $current = DB::table('order_fulfillment_assignments')->where('order_id', $order->id)->whereNull('ended_at')->value('user_id');

        return DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->leftJoin('user_profiles as p', 'p.user_id', '=', 'u.id')
            ->where('m.vendor_organization_id', $scope['organization_id'])->where('m.role', 'FULFILLMENT')->where('m.status', 'ACTIVE')->where('u.account_status', 'ACTIVE')
            ->orderBy('p.full_name')->orderBy('u.id')->get(['u.id', 'p.full_name'])
            ->map(static fn (object $row): array => ['user_id' => (int) $row->id, 'display_name' => (string) ($row->full_name ?: 'Fulfillment Staff'), 'assigned' => (int) $row->id === (int) $current])->values()->all();
    }

    public function assign(Request $request, string $orderId, int $userId, string $reason): void
    {
        $scope = $this->access->vendorScope($request);
        $this->access->require($scope, OrderAccess::ASSIGN_FULFILLMENT, 'Only the Owner or Store Manager can assign Fulfillment Staff.');
        $key = $this->keys->requireIdempotencyKey($request);
        DB::transaction(function () use ($request, $scope, $orderId, $userId, $reason, $key): void {
            if ($this->keys->replayed($request, 'FULFILLMENT_ASSIGN', $key, $orderId)) {
                return;
            }
            $order = $this->access->vendorOrder($scope, $orderId, true);
            $previous = $this->threads->assign($order, $request->user(), $userId, $reason);
            $actor = OrderActor::vendor($request, $scope['role']);
            $this->records->event($this->records->ensure($order), 'ASSIGNED', $actor, ['user_id' => $userId, 'previous_user_id' => $previous, 'reason' => mb_substr($reason, 0, 500)]);
            $this->keys->claim($request, 'FULFILLMENT_ASSIGN', $key, $orderId, 200);
            $this->audit->account($request, 'ORDER_FULFILLMENT_ASSIGNED', 'ORDER', $orderId, before: ['user_id' => $previous], after: ['user_id' => $userId, 'reason' => $reason]);
            $this->notifier->assignee($order, 'Order '.$order->reference.' assigned to you', 'You are assigned to prepare and fulfill this order using its accepted vehicles, trips and address. Open the order to record milestones and proof.');
        });
    }

    /**
     * @param  array{milestone: string, lock_version: int, vehicle_index?: int|null, trip_number?: int|null, receiver_name?: string|null, receiver_kind?: string|null, handover_confirmed?: bool|null, note?: string|null}  $input
     */
    public function record(Request $request, string $orderId, array $input, ?UploadedFile $photo, ?UploadedFile $signature): void
    {
        $scope = $this->access->vendorScope($request);
        $this->access->require($scope, OrderAccess::RECORD_FULFILLMENT, 'Only the Owner, Store Manager or assigned Fulfillment Staff can record fulfillment milestones.');
        $key = $this->keys->requireIdempotencyKey($request);
        $milestone = $input['milestone'];
        $this->access->vendorOrder($scope, $orderId);
        $this->validateProofInput($milestone, $input, $photo);
        $stored = [];
        try {
            $photoId = $photo === null ? null : ($stored[] = $this->files->store($photo, $orderId, OrderEvidenceFiles::PROOF, (int) $request->user()->getKey(), true));
            $signatureId = $signature === null ? null : ($stored[] = $this->files->store($signature, $orderId, OrderEvidenceFiles::PROOF, (int) $request->user()->getKey(), true));
            $applied = DB::transaction(fn (): bool => $this->apply($request, $scope, $orderId, $input, $key, $photoId, $signatureId));
        } catch (Throwable $exception) {
            $this->files->discard($stored);
            throw $exception;
        }
        if (! $applied) {
            $this->files->discard($stored);
        }
    }

    /**
     * @param  array{organization_id: string, role: string, permissions: list<string>}  $scope
     * @param  array<string, mixed>  $input
     */
    private function apply(Request $request, array $scope, string $orderId, array $input, string $key, ?string $photoId, ?string $signatureId): bool
    {
        if ($this->keys->replayed($request, 'FULFILLMENT_MILESTONE', $key, $orderId)) {
            return false;
        }
        $milestone = (string) $input['milestone'];
        $order = $this->access->vendorOrder($scope, $orderId, true);
        $fulfillment = $this->records->ensure($order);
        if (DB::table('fulfillment_milestones')->where('fulfillment_id', $fulfillment->id)->where('dedupe_key', 'MILESTONE:'.$milestone)->exists()) {
            throw new AuthenticationException('MILESTONE_ALREADY_RECORDED', 'This milestone was already recorded. Refresh to see the current fulfillment status.', 409, ['milestone' => $milestone]);
        }
        if ($order->order_state === OrderStates::CANCELLATION_REQUESTED) {
            throw new AuthenticationException('CANCELLATION_PENDING', 'The Buyer asked to cancel this order. Respond to the request first; milestones resume only if it is withdrawn.', 409);
        }
        [$from, $method] = self::STEPS[$milestone];
        if ($order->order_state !== $from || ($method !== null && $order->fulfillment_method !== $method)) {
            throw new AuthenticationException('ORDER_STATE_CONFLICT', 'This milestone is not the next step for this order. Refresh to see its current state.', 409, ['current_state' => $order->order_state, 'expected_state' => $from]);
        }
        if ((int) $input['lock_version'] !== (int) $order->lock_version) {
            throw new AuthenticationException('STALE_VERSION', 'This order changed since you opened it. Refresh and try again.', 409, ['lock_version' => (int) $order->lock_version]);
        }
        $actor = OrderActor::vendor($request, $scope['role']);
        $payload = array_filter(['note' => isset($input['note']) ? mb_substr(trim((string) $input['note']), 0, 500) : null], static fn (mixed $value): bool => $value !== null && $value !== '');
        $vehicle = null;
        if ($milestone === OrderStates::OUT_FOR_DELIVERY || ($milestone === OrderStates::DELIVERED && isset($input['vehicle_index']))) {
            $vehicle = $this->acceptedVehicle($order, $input);
            $payload['vehicle'] = $vehicle;
        }
        $eventId = (string) $this->records->event($fulfillment, $milestone, $actor, $payload, 'MILESTONE:'.$milestone);
        if ($milestone === OrderStates::OUT_FOR_DELIVERY && $vehicle !== null) {
            $this->records->event($fulfillment, 'TRIP_DISPATCHED', $actor, ['vehicle' => $vehicle], 'TRIP:'.$vehicle['vehicle_index'].':'.$vehicle['trip_number']);
        }
        if (in_array($milestone, OrderStates::AWAITING_RECEIPT, true)) {
            DB::table('fulfillment_proofs')->insert(['id' => (string) Str::uuid7(), 'fulfillment_id' => $fulfillment->id, 'order_id' => $order->id, 'milestone_id' => $eventId,
                'actor_user_id' => $actor->userId, 'event_type' => $milestone, 'photo_file_id' => $photoId, 'signature_file_id' => $signatureId,
                'receiver_name_encrypted' => Crypt::encryptString(trim((string) $input['receiver_name'])), 'receiver_kind' => $milestone === OrderStates::PICKED_UP ? (string) $input['receiver_kind'] : 'RECEIVER',
                'handover_confirmed' => $milestone === OrderStates::PICKED_UP, 'vehicle_reference' => $vehicle === null ? null : json_encode($vehicle, JSON_THROW_ON_ERROR),
                'payload' => json_encode($payload, JSON_THROW_ON_ERROR), 'occurred_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
            // Physical stock leaves only now: on-hand and reserved fall together; available-to-sell is unchanged.
            $this->ledger->fulfillOrder((string) $order->id, $actor->userId);
        }
        $order = $this->transitions->apply($order, [OrderStates::ORDER => $milestone, OrderStates::FULFILLMENT => $milestone], $actor, 'MILESTONE_'.$milestone, $payload['note'] ?? null);
        $columns = ['state' => $milestone];
        if (in_array($milestone, OrderStates::AWAITING_RECEIPT, true)) {
            $columns['auto_confirm_due_at'] = now()->addHours(FulfillmentRecords::RECEIPT_WINDOW_HOURS);
        }
        $this->records->update($fulfillment, $columns);
        if (in_array($milestone, OrderStates::HANDOVER_STAGE, true)) {
            // First valid handover-stage milestone enables the one fulfillment thread in this same transaction.
            $this->threads->ensureForMilestone((string) $order->id, $actor->userId);
        }
        $this->keys->claim($request, 'FULFILLMENT_MILESTONE', $key, $orderId, 200);
        $this->audit->account($request, 'ORDER_MILESTONE_RECORDED', 'ORDER', $orderId, after: ['milestone' => $milestone, 'proof' => $photoId !== null || $milestone === OrderStates::PICKED_UP]);
        $this->notify($order, $milestone);

        return true;
    }

    /** @param array<string, mixed> $input */
    private function validateProofInput(string $milestone, array $input, ?UploadedFile $photo): void
    {
        $errors = [];
        if ($milestone === OrderStates::DELIVERED) {
            if ($photo === null) {
                $errors['file'] = ['A delivery photo is required to record Delivered.'];
            }
            if (mb_strlen(trim((string) ($input['receiver_name'] ?? ''))) < 2) {
                $errors['receiver_name'] = ['Enter the name of the person who received the delivery.'];
            }
        }
        if ($milestone === OrderStates::PICKED_UP) {
            if (! (bool) ($input['handover_confirmed'] ?? false)) {
                $errors['handover_confirmed'] = ['Confirm the handover to record Picked up.'];
            }
            if (mb_strlen(trim((string) ($input['receiver_name'] ?? ''))) < 2) {
                $errors['receiver_name'] = ['Enter the name of the Buyer or authorized receiver.'];
            }
            if (! in_array($input['receiver_kind'] ?? null, ['BUYER', 'AUTHORIZED_RECEIVER'], true)) {
                $errors['receiver_kind'] = ['Choose whether the Buyer or an authorized receiver collected the order.'];
            }
        }
        if ($errors !== []) {
            throw new AuthenticationException('PROOF_REQUIRED', 'This milestone needs its fulfillment proof.', 422, $errors);
        }
    }

    /**
     * The dispatched vehicle and trip must come from the accepted delivery snapshot; staff cannot pick another
     * vehicle, add trips or change the fee.
     *
     * @param  array<string, mixed>  $input
     * @return array{vehicle_index: int, trip_number: int, name: ?string, total_vehicle_trips: int}
     */
    private function acceptedVehicle(object $order, array $input): array
    {
        $snapshot = DB::table('order_delivery_snapshots')->where('order_id', $order->id)->value('snapshot');
        $vehicles = json_decode((string) $snapshot, true)['vehicles'] ?? [];
        $index = isset($input['vehicle_index']) ? (int) $input['vehicle_index'] : -1;
        $trip = isset($input['trip_number']) ? (int) $input['trip_number'] : 1;
        $vehicle = $vehicles[$index] ?? null;
        if (! is_array($vehicle) || $trip < 1 || $trip > (int) ($vehicle['total_vehicle_trips'] ?? 0)) {
            throw new AuthenticationException('VEHICLE_NOT_IN_ACCEPTED_ARRANGEMENT', 'Choose a vehicle and trip from the accepted delivery arrangement. A different vehicle or extra trip needs an authorized revision approved by the Buyer.', 422,
                ['vehicle_index' => ['Use one of the accepted vehicles.'], 'trip_number' => ['Use a trip within the accepted trip count.']]);
        }

        return ['vehicle_index' => $index, 'trip_number' => $trip, 'name' => $vehicle['configuration']['name'] ?? null, 'total_vehicle_trips' => (int) $vehicle['total_vehicle_trips']];
    }

    /** @param array{vehicle_index: int, trip_number: int} $input */
    public function recordTrip(Request $request, string $orderId, array $input): void
    {
        $scope = $this->access->vendorScope($request);
        $this->access->require($scope, OrderAccess::RECORD_FULFILLMENT, 'Only the Owner, Store Manager or assigned Fulfillment Staff can record trips.');
        $key = $this->keys->requireIdempotencyKey($request);
        DB::transaction(function () use ($request, $scope, $orderId, $input, $key): void {
            if ($this->keys->replayed($request, 'FULFILLMENT_TRIP', $key, $orderId)) {
                return;
            }
            $order = $this->access->vendorOrder($scope, $orderId, true);
            if ($order->order_state !== OrderStates::OUT_FOR_DELIVERY) {
                throw new AuthenticationException('ORDER_STATE_CONFLICT', 'Additional trips are recorded while the order is out for delivery.', 409, ['current_state' => $order->order_state]);
            }
            $vehicle = $this->acceptedVehicle($order, $input);
            $event = $this->records->event($this->records->ensure($order), 'TRIP_DISPATCHED', OrderActor::vendor($request, $scope['role']), ['vehicle' => $vehicle], 'TRIP:'.$vehicle['vehicle_index'].':'.$vehicle['trip_number']);
            if ($event === null) {
                throw new AuthenticationException('TRIP_ALREADY_RECORDED', 'This trip was already recorded.', 409);
            }
            $this->keys->claim($request, 'FULFILLMENT_TRIP', $key, $orderId, 200);
            $this->notifier->buyer($order, 'Trip '.$vehicle['trip_number'].' dispatched for order '.$order->reference, 'Another accepted delivery trip left the store. There is no live tracking; the Vendor records delivery with proof.');
        });
    }

    /** @param array{category: string, description: string} $input */
    public function reportVehicleIssue(Request $request, string $orderId, array $input): void
    {
        $scope = $this->access->vendorScope($request);
        $this->access->require($scope, OrderAccess::RECORD_FULFILLMENT, 'Only the Owner, Store Manager or assigned Fulfillment Staff can report a vehicle issue.');
        $key = $this->keys->requireIdempotencyKey($request);
        DB::transaction(function () use ($request, $scope, $orderId, $input, $key): void {
            if ($this->keys->replayed($request, 'FULFILLMENT_VEHICLE_ISSUE', $key, $orderId)) {
                return;
            }
            $order = $this->access->vendorOrder($scope, $orderId, true);
            if (! in_array($order->order_state, [OrderStates::CONFIRMED, OrderStates::PROCESSING, OrderStates::READY_FOR_PICKUP, OrderStates::OUT_FOR_DELIVERY], true)) {
                throw new AuthenticationException('ORDER_STATE_CONFLICT', 'Vehicle issues are reported before delivery is recorded.', 409);
            }
            $this->records->event($this->records->ensure($order), 'VEHICLE_ISSUE_REPORTED', OrderActor::vendor($request, $scope['role']),
                ['category' => $input['category'], 'description' => mb_substr(trim($input['description']), 0, 1000)]);
            $this->keys->claim($request, 'FULFILLMENT_VEHICLE_ISSUE', $key, $orderId, 201);
            $this->audit->account($request, 'ORDER_VEHICLE_ISSUE_REPORTED', 'ORDER', $orderId, after: ['category' => $input['category']]);
            $this->notifier->vendor($order, 'Vehicle issue on order '.$order->reference, 'Fulfillment reported a vehicle issue ('.strtolower(str_replace('_', ' ', $input['category'])).'). The accepted vehicles, trips and fee are unchanged. '
                .'Any different arrangement needs an authorized revision approved by the Buyer, or a reasoned cancellation.', ['OWNER', 'STORE_MANAGER']);
        });
    }

    public function respondIssue(Request $request, string $orderId, string $issueId, string $response): void
    {
        $scope = $this->access->vendorScope($request);
        $this->access->require($scope, OrderAccess::RECORD_FULFILLMENT, 'Only the Owner, Store Manager or assigned Fulfillment Staff can respond to a reported problem.');
        $key = $this->keys->requireIdempotencyKey($request);
        DB::transaction(function () use ($request, $scope, $orderId, $issueId, $response, $key): void {
            if ($this->keys->replayed($request, 'FULFILLMENT_ISSUE_RESPONSE', $key, $orderId)) {
                return;
            }
            $order = $this->access->vendorOrder($scope, $orderId, true);
            $issue = DB::table('fulfillment_issues')->where('id', $issueId)->where('order_id', $order->id)->lockForUpdate()->first();
            if ($issue === null || $issue->state !== 'OPEN') {
                throw new AuthenticationException('ISSUE_NOT_OPEN', 'This problem report is not open.', 409);
            }
            DB::table('fulfillment_issues')->where('id', $issueId)->update(['vendor_response' => mb_substr(trim($response), 0, 2000), 'vendor_responded_by_user_id' => $request->user()->getKey(),
                'vendor_responded_role' => $scope['role'], 'vendor_responded_at' => now(), 'updated_at' => now()]);
            $this->records->event($this->records->ensure($order), 'ISSUE_RESPONDED', OrderActor::vendor($request, $scope['role']), ['issue_id' => $issueId]);
            $this->keys->claim($request, 'FULFILLMENT_ISSUE_RESPONSE', $key, $orderId, 200);
            $this->notifier->buyer($order, 'The Vendor responded to your problem report on order '.$order->reference, 'Open the order to read the response. Automatic receipt confirmation stays paused until you mark the problem resolved or confirm receipt.');
        });
    }

    private function notify(object $order, string $milestone): void
    {
        [$title, $buyer] = match ($milestone) {
            OrderStates::PROCESSING => ['is being prepared', 'The Vendor started preparing your order.'],
            OrderStates::READY_FOR_PICKUP => ['is ready for pickup', 'Your order is ready at the store. Bring your order reference; the Vendor records the handover. Fulfillment Messages are now open on the order.'],
            OrderStates::OUT_FOR_DELIVERY => ['is out for delivery', 'Your order left the store on the accepted vehicle. There is no live GPS tracking. Fulfillment Messages are now open on the order.'],
            OrderStates::DELIVERED => ['was delivered', 'The Vendor recorded delivery with proof. Review it, then confirm receipt or report a problem within 48 hours; after that receipt is confirmed automatically unless a problem is open.'],
            default => ['was picked up', 'The Vendor recorded the handover. Review it, then confirm receipt or report a problem within 48 hours; after that receipt is confirmed automatically unless a problem is open.'],
        };
        $this->notifier->buyer($order, 'Order '.$order->reference.' '.$title, $buyer);
        $this->notifier->vendor($order, 'Order '.$order->reference.' '.$title, 'Milestone recorded: '.strtolower(str_replace('_', ' ', $milestone)).'.', ['OWNER', 'STORE_MANAGER']);
    }
}
