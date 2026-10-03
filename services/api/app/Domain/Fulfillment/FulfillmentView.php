<?php

declare(strict_types=1);

namespace App\Domain\Fulfillment;

use App\Domain\Messaging\FulfillmentThreadService;
use App\Domain\Orders\OrderStates;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;

/**
 * Server-derived fulfillment workspace for Buyer and Vendor order details. Step completion comes only from recorded
 * milestones; proof is attached to the milestone that required it; the accepted vehicle/trip/fee and
 * intended/alternate address come from the accepted delivery snapshot, never from current vehicle settings. There is
 * no live GPS or vehicle position anywhere in this view.
 */
final class FulfillmentView
{
    public const TRACKING_NOTICE = 'There is no live GPS tracking. Status changes when the Vendor records each milestone.';

    /** @return array<string, mixed> */
    public function present(object $order, bool $forVendor, string $filePrefix): array
    {
        $fulfillment = DB::table('fulfillments')->where('order_id', $order->id)->first();
        $events = $fulfillment === null ? collect() : DB::table('fulfillment_milestones')->where('fulfillment_id', $fulfillment->id)->orderBy('occurred_at')->orderBy('id')->get();
        $byType = $events->whereNotNull('dedupe_key')->keyBy('event_type');
        $delivery = $order->fulfillment_method === 'DELIVERY';
        $handover = $delivery ? OrderStates::OUT_FOR_DELIVERY : OrderStates::READY_FOR_PICKUP;
        $done = $delivery ? OrderStates::DELIVERED : OrderStates::PICKED_UP;
        $proofRow = DB::table('fulfillment_proofs')->where('order_id', $order->id)->first();
        $proof = $proofRow === null ? null : [
            'milestone' => (string) $proofRow->event_type, 'recorded_at' => self::iso($proofRow->occurred_at),
            'receiver_name' => $proofRow->receiver_name_encrypted === null ? null : Crypt::decryptString((string) $proofRow->receiver_name_encrypted),
            'receiver_kind' => $proofRow->receiver_kind === 'RECEIVER' ? null : $proofRow->receiver_kind, 'handover_confirmed' => (bool) $proofRow->handover_confirmed,
            'photo_path' => $proofRow->photo_file_id === null ? null : $filePrefix.$proofRow->photo_file_id, 'signature_path' => $proofRow->signature_file_id === null ? null : $filePrefix.$proofRow->signature_file_id,
            'vehicle' => json_decode((string) ($proofRow->vehicle_reference ?? 'null'), true),
        ];
        $accepted = $order->accepted_at !== null && ! in_array($order->order_state, [...OrderStates::PENDING_ACCEPTANCE, OrderStates::AWAITING_PAYMENT], true);
        $cancelled = $order->order_state === OrderStates::CANCELLED || in_array($order->order_state, OrderStates::CLOSED_BEFORE_FULFILLMENT, true);
        $steps = [];
        $definitions = [[OrderStates::CONFIRMED, 'Confirmed', false], [OrderStates::PROCESSING, 'Preparing', false], [$handover, $delivery ? 'Out for delivery' : 'Ready for pickup', false],
            [$done, $delivery ? 'Delivered' : 'Picked up', true], [OrderStates::COMPLETED, 'Receipt confirmed', false]];
        foreach ($definitions as $position => [$key, $label, $proofRequired]) {
            // The first step is the verified-payment confirmation from the order history, not a fulfillment event.
            $event = $position === 0 ? null : $byType->get($key);
            $at = $position === 0 ? $this->confirmedAt((string) $order->id) : ($event === null ? null : self::iso($event->occurred_at));
            $steps[] = ['key' => $key, 'label' => $label, 'status' => $at !== null && ($position > 0 || $accepted || $cancelled) ? 'COMPLETE' : 'UPCOMING', 'at' => $at,
                'actor_role' => $event?->actor_role, 'proof_required' => $proofRequired, 'proof' => $key === $done ? $proof : null,
                'proof_requirements' => $proofRequired ? ($delivery ? ['DELIVERY_PHOTO', 'RECEIVER_NAME', 'SIGNATURE_OPTIONAL'] : ['HANDOVER_CONFIRMATION', 'RECEIVER_NAME', 'RECEIVER_TYPE']) : []];
        }
        if (! $cancelled) {
            foreach ($steps as $index => $step) {
                if ($step['status'] === 'UPCOMING') {
                    $steps[$index]['status'] = 'CURRENT';
                    break;
                }
            }
        }
        $issue = DB::table('fulfillment_issues')->where('order_id', $order->id)->orderByDesc('created_at')->first();
        $assigned = DB::table('order_fulfillment_assignments as a')->leftJoin('user_profiles as p', 'p.user_id', '=', 'a.user_id')->where('a.order_id', $order->id)->whereNull('a.ended_at')
            ->first(['a.user_id', 'a.created_at', 'p.full_name']);
        $thread = DB::table('conversations')->where('order_id', $order->id)->where('purpose', 'FULFILLMENT')->first();
        $writability = $thread === null ? null : FulfillmentThreadService::writability($thread);

        return [
            'method' => (string) $order->fulfillment_method, 'state' => (string) $order->fulfillment_state, 'expected_date' => $order->expected_fulfillment_date === null ? null : (string) $order->expected_fulfillment_date,
            'late' => $fulfillment?->late_flagged_at !== null && ! in_array($order->order_state, [...OrderStates::AWAITING_RECEIPT, OrderStates::COMPLETED], true),
            'steps' => $steps, 'proof' => $proof, 'tracking_notice' => self::TRACKING_NOTICE,
            'trips' => $events->where('event_type', 'TRIP_DISPATCHED')->map(static fn (object $row): array => (json_decode((string) $row->payload, true)['vehicle'] ?? []) + ['dispatched_at' => self::iso($row->occurred_at)])->values()->all(),
            'accepted_arrangement' => $this->arrangement($order),
            'receipt' => [
                'due_at' => self::iso($fulfillment?->auto_confirm_due_at), 'paused' => $fulfillment?->auto_confirm_paused_at !== null,
                'remaining_seconds' => $fulfillment?->auto_confirm_remaining_seconds === null ? null : (int) $fulfillment->auto_confirm_remaining_seconds,
                'confirmed_at' => self::iso($fulfillment?->receipt_confirmed_at), 'confirmation_source' => $fulfillment?->receipt_confirmation_source,
                'window_hours' => FulfillmentRecords::RECEIPT_WINDOW_HOURS,
            ],
            'issue' => $issue === null ? null : [
                'id' => (string) $issue->id, 'category' => (string) $issue->category, 'description' => (string) $issue->description, 'state' => (string) $issue->state,
                'reported_at' => self::iso($issue->created_at), 'vendor_response' => $issue->vendor_response, 'vendor_responded_at' => self::iso($issue->vendor_responded_at),
                'resolution' => $issue->resolution, 'resolved_at' => self::iso($issue->resolved_at),
                'photo_paths' => array_map(static fn (string $id): string => $filePrefix.$id, json_decode((string) $issue->evidence_file_ids, true) ?: []),
            ],
            'assignment' => $assigned === null ? null : ['display_name' => (string) ($assigned->full_name ?: 'Fulfillment Staff'), 'role' => 'FULFILLMENT', 'assigned_at' => self::iso($assigned->created_at),
                'user_id' => $forVendor ? (int) $assigned->user_id : null],
            'vehicle_issues' => $forVendor ? $events->where('event_type', 'VEHICLE_ISSUE_REPORTED')->map(static fn (object $row): array => (json_decode((string) $row->payload, true) ?: [])
                + ['reported_at' => self::iso($row->occurred_at), 'actor_role' => $row->actor_role])->values()->all() : [],
            'thread' => ['available' => $thread !== null, 'conversation_id' => $thread?->id, 'read_only' => (bool) ($writability['read_only'] ?? false),
                'read_only_reason' => $writability['reason'] ?? null,
                'notice' => $thread === null ? 'Fulfillment Messages open when the order is ready for pickup or out for delivery.' : null],
            'next_action' => $forVendor ? self::vendorNext($order) : (in_array($order->order_state, OrderStates::AWAITING_RECEIPT, true) ? 'CONFIRM_RECEIPT' : 'NONE'),
        ];
    }

    /** @return array<string, mixed>|null the accepted commitment the fulfillment must follow */
    private function arrangement(object $order): ?array
    {
        $row = DB::table('order_delivery_snapshots')->where('order_id', $order->id)->first();
        if ($row === null) {
            return null;
        }
        $snapshot = json_decode((string) $row->snapshot, true) ?: [];

        return [
            'vehicles' => array_map(static fn (array $vehicle, int $index): array => ['vehicle_index' => $index, 'name' => $vehicle['configuration']['name'] ?? null,
                'vehicle_type' => $vehicle['configuration']['vehicle_type'] ?? null, 'number_of_vehicles' => (int) ($vehicle['number_of_vehicles'] ?? 0),
                'total_vehicle_trips' => (int) ($vehicle['total_vehicle_trips'] ?? 0)], $snapshot['vehicles'] ?? [], array_keys($snapshot['vehicles'] ?? [])),
            'final_fee_centavos' => (int) $row->final_charge_centavos, 'endpoint' => ($snapshot['endpoint'] ?? null) === 'ALTERNATIVE_DROP_OFF' ? 'ALTERNATE_DROP_OFF' : ($snapshot['endpoint'] ?? null),
            'fulfillment_date' => $snapshot['fulfillment_date'] ?? null, 'arrangement' => $snapshot['arrangement'] ?? null,
            'notice' => 'Accepted when the order was confirmed. Later vehicle, rate or store-hour changes never change this arrangement or its fee.',
        ];
    }

    private function confirmedAt(string $orderId): ?string
    {
        $at = DB::table('order_status_history')->where('order_id', $orderId)->where('state_family', OrderStates::ORDER)->where('to_state', OrderStates::CONFIRMED)->orderBy('created_at')->value('created_at');

        return self::iso($at);
    }

    public static function vendorNext(object $order): string
    {
        return match ($order->order_state) {
            OrderStates::CONFIRMED => 'START_PREPARATION',
            OrderStates::PROCESSING => $order->fulfillment_method === 'DELIVERY' ? 'DISPATCH' : 'MARK_READY',
            OrderStates::READY_FOR_PICKUP => 'RECORD_PICKUP',
            OrderStates::OUT_FOR_DELIVERY => 'RECORD_DELIVERY',
            OrderStates::DELIVERED, OrderStates::PICKED_UP => 'AWAIT_RECEIPT',
            OrderStates::CANCELLATION_REQUESTED => 'RESPOND_TO_CANCELLATION',
            default => 'NONE',
        };
    }

    private static function iso(mixed $value): ?string
    {
        return $value === null ? null : CarbonImmutable::parse((string) $value)->toIso8601String();
    }
}
