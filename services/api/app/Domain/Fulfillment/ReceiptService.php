<?php

declare(strict_types=1);

namespace App\Domain\Fulfillment;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Finance\FeeAssessmentService;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Messaging\FulfillmentThreadService;
use App\Domain\Operations\OutboxPublisher;
use App\Domain\Orders\OrderAccess;
use App\Domain\Orders\OrderActor;
use App\Domain\Orders\OrderNotifier;
use App\Domain\Orders\OrderStates;
use App\Domain\Orders\OrderTransitionService;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Throwable;

/**
 * Buyer receipt after DELIVERED or PICKED_UP. The Buyer confirms receipt or reports a problem; otherwise receipt is
 * confirmed automatically 48 hours after the milestone, with reminders 24 hours and 2 hours before (approved by
 * the project owner on 2026-10-02). An open problem report pauses the window and resolving it resumes the remaining
 * time; an active dispute also pauses it. Reporting a problem never opens a dispute or a refund.
 *
 * Completion moves the order to COMPLETED through the shared state machine and, in the same transaction, earns the
 * FIN-03 commission exactly once (a replay finds it EARNED), makes the fulfillment thread read-only and ends the
 * Fulfillment Staff assignment.
 */
final class ReceiptService
{
    public const ISSUE_CATEGORIES = ['NOT_RECEIVED', 'INCOMPLETE', 'DAMAGED', 'WRONG_ITEM', 'LATE', 'ACCESS_PROBLEM', 'OTHER'];

    /** Dispute states that do not pause auto-confirmation. */
    private const INACTIVE_DISPUTE = ['NONE', 'RESOLVED', 'CLOSED_INCONCLUSIVE'];

    public function __construct(
        private readonly OrderAccess $access,
        private readonly CatalogAccess $keys,
        private readonly OrderTransitionService $transitions,
        private readonly FulfillmentRecords $records,
        private readonly FulfillmentThreadService $threads,
        private readonly FeeAssessmentService $fees,
        private readonly OrderEvidenceFiles $files,
        private readonly OrderNotifier $notifier,
        private readonly OutboxPublisher $outbox,
        private readonly AuditRecorder $audit,
    ) {}

    public function confirm(Request $request, string $orderId): void
    {
        $key = $this->keys->requireIdempotencyKey($request);
        DB::transaction(function () use ($request, $orderId, $key): void {
            if ($this->keys->replayed($request, 'ORDER_RECEIPT_CONFIRM', $key, $orderId)) {
                return;
            }
            $order = $this->access->buyerOrder($request, $orderId, true);
            if (! in_array($order->order_state, OrderStates::AWAITING_RECEIPT, true)) {
                throw new AuthenticationException('ORDER_STATE_CONFLICT', 'Receipt can be confirmed after the Vendor records delivery or pickup.', 409, ['current_state' => $order->order_state]);
            }
            $actor = OrderActor::buyer($request);
            $fulfillment = $this->records->ensure($order);
            $open = DB::table('fulfillment_issues')->where('order_id', $order->id)->where('state', 'OPEN')->lockForUpdate()->first();
            if ($open !== null) {
                DB::table('fulfillment_issues')->where('id', $open->id)->update(['state' => 'RESOLVED', 'resolution' => 'RECEIPT_CONFIRMED', 'resolved_at' => now(), 'updated_at' => now()]);
                $this->records->event($fulfillment, 'ISSUE_RESOLVED', $actor, ['issue_id' => (string) $open->id, 'resolution' => 'RECEIPT_CONFIRMED']);
            }
            $this->complete($order, $fulfillment, $actor, 'BUYER');
            $this->keys->claim($request, 'ORDER_RECEIPT_CONFIRM', $key, $orderId, 200);
            $this->audit->account($request, 'ORDER_RECEIPT_CONFIRMED', 'ORDER', $orderId);
        });
    }

    /**
     * @param  array{category: string, description: string}  $input
     * @param  list<UploadedFile>  $photos
     */
    public function report(Request $request, string $orderId, array $input, array $photos): string
    {
        $key = $this->keys->requireIdempotencyKey($request);
        $preview = $this->access->buyerOrder($request, $orderId);
        $stored = [];
        try {
            foreach ($photos as $photo) {
                $stored[] = $this->files->store($photo, (string) $preview->id, OrderEvidenceFiles::ISSUE, (int) $request->user()->getKey(), true);
            }
            $issueId = DB::transaction(function () use ($request, $orderId, $input, $key, $stored): string {
                if ($this->keys->replayed($request, 'ORDER_PROBLEM_REPORT', $key, $orderId)) {
                    return (string) DB::table('fulfillment_issues')->where('order_id', $orderId)->orderByDesc('created_at')->value('id');
                }
                $order = $this->access->buyerOrder($request, $orderId, true);
                if (! in_array($order->order_state, [...OrderStates::HANDOVER_STAGE, ...OrderStates::AWAITING_RECEIPT], true)) {
                    throw new AuthenticationException('PROBLEM_REPORT_NOT_AVAILABLE', 'Report a Problem is available from Ready for Pickup or Out for Delivery until receipt is confirmed. After completion, use the return or dispute process.', 409);
                }
                if (DB::table('fulfillment_issues')->where('order_id', $order->id)->where('state', 'OPEN')->exists()) {
                    throw new AuthenticationException('PROBLEM_ALREADY_OPEN', 'You already have an open problem report on this order. Add details in Fulfillment Messages or resolve it first.', 409);
                }
                $actor = OrderActor::buyer($request);
                $fulfillment = $this->records->ensure($order);
                $id = (string) Str::uuid7();
                DB::table('fulfillment_issues')->insert(['id' => $id, 'order_id' => $order->id, 'fulfillment_id' => $fulfillment->id, 'reported_by_user_id' => $request->user()->getKey(),
                    'category' => $input['category'], 'description' => mb_substr(trim($input['description']), 0, 2000), 'evidence_file_ids' => json_encode($stored, JSON_THROW_ON_ERROR),
                    'order_state_at_report' => $order->order_state, 'state' => 'OPEN', 'created_at' => now(), 'updated_at' => now()]);
                $this->records->event($fulfillment, 'ISSUE_REPORTED', $actor, ['issue_id' => $id, 'category' => $input['category']]);
                if (in_array($order->order_state, OrderStates::AWAITING_RECEIPT, true) && $fulfillment->auto_confirm_due_at !== null) {
                    $remaining = max(0, (int) CarbonImmutable::now()->diffInSeconds(CarbonImmutable::parse((string) $fulfillment->auto_confirm_due_at), false));
                    $this->records->update($fulfillment, ['auto_confirm_due_at' => null, 'auto_confirm_paused_at' => now(), 'auto_confirm_remaining_seconds' => $remaining]);
                    $this->records->event($fulfillment, 'AUTO_CONFIRM_PAUSED', $actor, ['issue_id' => $id, 'remaining_seconds' => $remaining]);
                }
                $this->keys->claim($request, 'ORDER_PROBLEM_REPORT', $key, $orderId, 201);
                $this->audit->account($request, 'ORDER_PROBLEM_REPORTED', 'ORDER', $orderId, after: ['issue_id' => $id, 'category' => $input['category']]);
                $message = 'The Buyer reported a problem ('.strtolower(str_replace('_', ' ', $input['category'])).'). Respond on the order; automatic receipt confirmation is paused while it is open.';
                $this->notifier->vendor($order, 'Problem reported on order '.$order->reference, $message, ['OWNER', 'STORE_MANAGER']);
                $this->notifier->assignee($order, 'Problem reported on order '.$order->reference, $message);

                return $id;
            });
        } catch (Throwable $exception) {
            $this->files->discard($stored);
            throw $exception;
        }

        return (string) $issueId;
    }

    public function resolve(Request $request, string $orderId, string $issueId, ?string $note): void
    {
        $key = $this->keys->requireIdempotencyKey($request);
        DB::transaction(function () use ($request, $orderId, $issueId, $note, $key): void {
            if ($this->keys->replayed($request, 'ORDER_PROBLEM_RESOLVE', $key, $orderId)) {
                return;
            }
            $order = $this->access->buyerOrder($request, $orderId, true);
            $issue = DB::table('fulfillment_issues')->where('id', Str::isUuid($issueId) ? $issueId : '00000000-0000-0000-0000-000000000000')->where('order_id', $order->id)->lockForUpdate()->first();
            if ($issue === null || $issue->state !== 'OPEN') {
                throw new AuthenticationException('ISSUE_NOT_OPEN', 'This problem report is not open.', 409);
            }
            $actor = OrderActor::buyer($request);
            $fulfillment = $this->records->ensure($order);
            DB::table('fulfillment_issues')->where('id', $issue->id)->update(['state' => 'RESOLVED', 'resolution' => 'BUYER_RESOLVED', 'resolution_note' => $note === null ? null : mb_substr(trim($note), 0, 1000),
                'resolved_at' => now(), 'updated_at' => now()]);
            $this->records->event($fulfillment, 'ISSUE_RESOLVED', $actor, ['issue_id' => (string) $issue->id, 'resolution' => 'BUYER_RESOLVED']);
            if ($fulfillment->auto_confirm_paused_at !== null) {
                $this->records->update($fulfillment, ['auto_confirm_due_at' => now()->addSeconds((int) $fulfillment->auto_confirm_remaining_seconds), 'auto_confirm_paused_at' => null, 'auto_confirm_remaining_seconds' => null]);
                $this->records->event($fulfillment, 'AUTO_CONFIRM_RESUMED', $actor, ['issue_id' => (string) $issue->id, 'remaining_seconds' => (int) $fulfillment->auto_confirm_remaining_seconds]);
            }
            $this->keys->claim($request, 'ORDER_PROBLEM_RESOLVE', $key, $orderId, 200);
            $this->notifier->vendor($order, 'Problem resolved on order '.$order->reference, 'The Buyer marked the reported problem as resolved.', ['OWNER', 'STORE_MANAGER']);
        });
    }

    /** Completes a locked order awaiting receipt. Idempotent at the state machine and the fee contract. */
    private function complete(object $order, object $fulfillment, OrderActor $actor, string $source): object
    {
        $order = $this->transitions->apply($order, [OrderStates::ORDER => OrderStates::COMPLETED], $actor, $source === 'BUYER' ? 'BUYER_CONFIRMED_RECEIPT' : 'AUTO_CONFIRMED_RECEIPT');
        $this->records->update($fulfillment, ['state' => OrderStates::COMPLETED, 'completed_at' => now(), 'receipt_confirmed_at' => now(), 'receipt_confirmation_source' => $source,
            'auto_confirm_due_at' => null, 'auto_confirm_paused_at' => null, 'auto_confirm_remaining_seconds' => null]);
        $this->records->event($fulfillment, 'COMPLETED', $actor, ['source' => $source], 'MILESTONE:COMPLETED');
        // FIN-03: EARNED only at COMPLETED, once per order and policy version; a replay returns the earned amount.
        if (DB::table('fee_assessments')->where('order_id', $order->id)->exists()) {
            $this->fees->earnOnCompletion((string) $order->id, $actor->correlationId);
        }
        $this->threads->close($order, $actor->userId, OrderStates::COMPLETED);
        $this->outbox->publish('ORDER_COMPLETED', 'ORDER', (string) $order->id, ['order_id' => (string) $order->id, 'source' => $source]);
        $this->notifier->buyer($order, 'Order '.$order->reference.' completed', $source === 'BUYER'
            ? 'Thank you for confirming receipt. For a wrong, defective or incomplete item you can still use the return or dispute process within its deadline.'
            : 'Receipt was confirmed automatically 48 hours after delivery or pickup. For a wrong, defective or incomplete item you can still use the return or dispute process within its deadline.');
        $this->notifier->vendor($order, 'Order '.$order->reference.' completed', $source === 'BUYER' ? 'The Buyer confirmed receipt.' : 'Receipt was confirmed automatically after 48 hours.', ['OWNER', 'STORE_MANAGER']);

        return $order;
    }

    /** @return array<string, int> */
    public function sweep(int $limit = 200): array
    {
        $counts = ['completed' => 0, 'reminders' => 0, 'late' => 0];
        $now = CarbonImmutable::now();
        $due = DB::table('fulfillments as f')->join('orders as o', 'o.id', '=', 'f.order_id')->whereIn('o.order_state', OrderStates::AWAITING_RECEIPT)
            ->whereNotNull('f.auto_confirm_due_at')->where('f.auto_confirm_due_at', '<=', $now)->whereNull('f.auto_confirm_paused_at')
            ->whereIn('o.dispute_state', self::INACTIVE_DISPUTE)->orderBy('f.auto_confirm_due_at')->limit($limit)->pluck('o.id');
        foreach ($due as $orderId) {
            try {
                $counts['completed'] += $this->autoConfirm((string) $orderId) ? 1 : 0;
            } catch (Throwable $exception) {
                report($exception);
            }
        }
        foreach (['reminder_24h_sent_at' => 24, 'reminder_2h_sent_at' => 2] as $column => $hours) {
            $rows = DB::table('fulfillments as f')->join('orders as o', 'o.id', '=', 'f.order_id')->whereIn('o.order_state', OrderStates::AWAITING_RECEIPT)
                ->whereNotNull('f.auto_confirm_due_at')->whereNull('f.'.$column)->where('f.auto_confirm_due_at', '>', $now)->where('f.auto_confirm_due_at', '<=', $now->addHours($hours))
                ->limit($limit)->get(['o.id']);
            foreach ($rows as $row) {
                $counts['reminders'] += $this->remind((string) $row->id, $column, $hours) ? 1 : 0;
            }
        }
        $today = $now->setTimezone('Asia/Manila')->toDateString();
        $late = DB::table('orders as o')->leftJoin('fulfillments as f', 'f.order_id', '=', 'o.id')->whereNull('f.late_flagged_at')->whereNotNull('o.expected_fulfillment_date')
            ->where('o.expected_fulfillment_date', '<', $today)->where(fn ($q) => $q->whereIn('o.order_state', [OrderStates::CONFIRMED, OrderStates::PROCESSING])
            ->orWhere(fn ($delivery) => $delivery->where('o.order_state', OrderStates::OUT_FOR_DELIVERY)))->limit($limit)->pluck('o.id');
        foreach ($late as $orderId) {
            $counts['late'] += $this->flagLate((string) $orderId) ? 1 : 0;
        }

        return $counts;
    }

    private function autoConfirm(string $orderId): bool
    {
        return DB::transaction(function () use ($orderId): bool {
            $order = DB::table('orders')->where('id', $orderId)->lockForUpdate()->first();
            $fulfillment = $order === null ? null : DB::table('fulfillments')->where('order_id', $orderId)->lockForUpdate()->first();
            if ($fulfillment === null || ! in_array($order->order_state, OrderStates::AWAITING_RECEIPT, true) || $fulfillment->auto_confirm_due_at === null
                || CarbonImmutable::parse((string) $fulfillment->auto_confirm_due_at)->isFuture() || $fulfillment->auto_confirm_paused_at !== null
                || ! in_array($order->dispute_state, self::INACTIVE_DISPUTE, true) || DB::table('fulfillment_issues')->where('order_id', $orderId)->where('state', 'OPEN')->exists()) {
                return false;
            }
            $this->complete($order, $fulfillment, OrderActor::system(), 'AUTO_CONFIRMATION');

            return true;
        });
    }

    private function remind(string $orderId, string $column, int $hours): bool
    {
        return DB::transaction(function () use ($orderId, $column, $hours): bool {
            $order = DB::table('orders')->where('id', $orderId)->lockForUpdate()->first();
            $fulfillment = DB::table('fulfillments')->where('order_id', $orderId)->lockForUpdate()->first();
            if ($fulfillment === null || $fulfillment->{$column} !== null || $fulfillment->auto_confirm_due_at === null || ! in_array($order->order_state, OrderStates::AWAITING_RECEIPT, true)) {
                return false;
            }
            $this->records->update($fulfillment, [$column => now()]);
            $this->records->event($fulfillment, 'RECEIPT_REMINDER', OrderActor::system(), ['hours_before' => $hours], 'REMINDER:'.$hours.':'.CarbonImmutable::parse((string) $fulfillment->auto_confirm_due_at)->timestamp);
            $at = CarbonImmutable::parse((string) $fulfillment->auto_confirm_due_at)->setTimezone('Asia/Manila')->format('M j, Y g:i A');
            $this->notifier->buyer($order, 'Confirm receipt of order '.$order->reference, 'Please confirm receipt or report a problem. Receipt will be confirmed automatically on '.$at.' (Asia/Manila) unless a problem is open.');

            return true;
        });
    }

    private function flagLate(string $orderId): bool
    {
        return DB::transaction(function () use ($orderId): bool {
            $order = DB::table('orders')->where('id', $orderId)->lockForUpdate()->first();
            if ($order === null || ! in_array($order->order_state, [OrderStates::CONFIRMED, OrderStates::PROCESSING, OrderStates::OUT_FOR_DELIVERY], true)) {
                return false;
            }
            $fulfillment = $this->records->ensure($order);
            if ($fulfillment->late_flagged_at !== null) {
                return false;
            }
            $this->records->update($fulfillment, ['late_flagged_at' => now()]);
            $this->records->event($fulfillment, 'LATE_FLAGGED', OrderActor::system(), ['expected_fulfillment_date' => (string) $order->expected_fulfillment_date], 'LATE');
            // A missed date is a late milestone and notice only; it never cancels a paid order automatically.
            $this->notifier->buyer($order, 'Order '.$order->reference.' is running late', 'The expected '.($order->fulfillment_method === 'DELIVERY' ? 'delivery' : 'ready-for-pickup')
                .' date has passed. The Vendor was notified. You can message them, or request cancellation while the order is still being prepared.');
            $this->notifier->vendor($order, 'Order '.$order->reference.' is past its expected date', 'The accepted fulfillment date has passed. Update the Buyer through the order and record the next milestone.', ['OWNER', 'STORE_MANAGER']);
            $this->notifier->assignee($order, 'Order '.$order->reference.' is past its expected date', 'The accepted fulfillment date has passed.');

            return true;
        });
    }
}
