<?php

declare(strict_types=1);

namespace App\Domain\Inventory;

use App\Domain\Identity\AuthenticationException;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * The single writer of inventory balances. Every change appends an immutable movement with the actor,
 * reason and before/after values, and every count is also a stock confirmation. Physical quantity never
 * falls below hard reservations; soft holds never reduce available_to_sell. Callers run inside a
 * transaction and have already locked the organization and listing (org → listing → inventory order).
 */
final class InventoryLedgerWriter
{
    public const REASONS = ['COUNT', 'RECEIVED', 'RETURNED', 'DAMAGED', 'LOST', 'CORRECTION'];

    private const MOVEMENT_TYPES = ['COUNT' => 'COUNT_ADJUSTMENT', 'RECEIVED' => 'RECEIVED', 'RETURNED' => 'RETURNED', 'DAMAGED' => 'DAMAGED', 'LOST' => 'LOST', 'CORRECTION' => 'CORRECTION'];

    public const QUANTITY_PATTERN = '/^\d{1,14}(\.\d{1,4})?$/';

    /** Records a physical count or adjustment. Returns the inventory item id. */
    public function recordCount(int $actorId, string $variantId, string $quantity, string $reasonCode, ?string $note, string $sourceType): string
    {
        $this->assertTransaction();
        if (preg_match(self::QUANTITY_PATTERN, $quantity) !== 1) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['quantity_on_hand' => ['Enter a counted quantity of zero or more, with up to four decimals.']]);
        }
        if (! in_array($reasonCode, self::REASONS, true)) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['reason_code' => ['Choose why the quantity changed.']]);
        }
        $quantity = StockAvailability::quantity($quantity);
        $item = DB::table('inventory_items')->where('listing_variant_id', $variantId)->lockForUpdate()->first();
        if ($item === null) {
            $itemId = (string) Str::uuid7();
            DB::table('inventory_items')->insert(['id' => $itemId, 'listing_variant_id' => $variantId, 'quantity_on_hand' => $quantity, 'confirmed_at' => now(), 'updated_by_user_id' => $actorId, 'created_at' => now(), 'updated_at' => now()]);
            $this->movement($itemId, 'INITIAL_COUNT', $quantity, '0.0000', $quantity, '0.0000', '0.0000', $actorId, $reasonCode, $note, $sourceType, $variantId);
            $this->confirmation($itemId, $actorId, $quantity, 'COUNT');

            return $itemId;
        }
        $itemId = (string) $item->id;
        $before = StockAvailability::quantity($item->quantity_on_hand);
        $reserved = StockAvailability::quantity($item->hard_reserved_quantity);
        if (bccomp($quantity, $reserved, 4) < 0) {
            throw new AuthenticationException('STOCK_BELOW_RESERVED', 'The counted quantity cannot be lower than stock already reserved for confirmed orders.', 422, ['quantity_on_hand' => ['Hard-reserved quantity is '.$reserved.'.']]);
        }
        $delta = bcsub($quantity, $before, 4);
        $direction = bccomp($delta, '0', 4);
        if (($reasonCode === 'RECEIVED' || $reasonCode === 'RETURNED') && $direction <= 0) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['quantity_on_hand' => ['Received or returned stock must increase the quantity on hand.']]);
        }
        if (($reasonCode === 'DAMAGED' || $reasonCode === 'LOST') && $direction >= 0) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['quantity_on_hand' => ['Damaged or lost stock must decrease the quantity on hand.']]);
        }
        DB::table('inventory_items')->where('id', $itemId)->update(['quantity_on_hand' => $quantity, 'confirmed_at' => now(), 'updated_by_user_id' => $actorId, 'lock_version' => DB::raw('lock_version + 1'), 'updated_at' => now()]);
        if ($direction !== 0) {
            $this->movement($itemId, self::MOVEMENT_TYPES[$reasonCode], $delta, $before, $quantity, $reserved, StockAvailability::quantity($item->soft_held_quantity), $actorId, $reasonCode, $note, $sourceType, $variantId);
        }
        $this->confirmation($itemId, $actorId, $quantity, 'COUNT');

        return $itemId;
    }

    /** Confirms an unchanged counted quantity. The caller verified the item's lock_version. */
    public function confirmUnchanged(int $actorId, object $item): void
    {
        $this->assertTransaction();
        DB::table('inventory_items')->where('id', $item->id)->update(['confirmed_at' => now(), 'updated_by_user_id' => $actorId, 'lock_version' => DB::raw('lock_version + 1'), 'updated_at' => now()]);
        $this->confirmation((string) $item->id, $actorId, StockAvailability::quantity($item->quantity_on_hand), 'CONFIRM_UNCHANGED');
    }

    /**
     * Hard-reserves an accepted quantity on an inventory row the caller locked through
     * InventoryLocks::lockForAcceptance and already validated. Physical quantity_on_hand is unchanged;
     * available_to_sell falls by the reserved quantity. Returns the updated row.
     */
    public function reserve(object $lockedItem, string $quantity, ?int $actorId, string $orderId, string $orderLineId, ?string $autoAcceptPolicyVersionId = null): object
    {
        $this->assertTransaction();
        $quantity = StockAvailability::quantity($quantity);
        $onHand = StockAvailability::quantity($lockedItem->quantity_on_hand);
        $reserved = StockAvailability::quantity($lockedItem->hard_reserved_quantity);
        if (bccomp($quantity, '0', 4) <= 0 || bccomp($quantity, StockAvailability::availableToSell($onHand, $reserved), 4) > 0) {
            throw new AuthenticationException('STOCK_INSUFFICIENT', 'Available stock changed. Nothing was reserved.', 409);
        }
        $after = bcadd($reserved, $quantity, 4);
        DB::table('inventory_items')->where('id', $lockedItem->id)->update(['hard_reserved_quantity' => $after, 'lock_version' => DB::raw('lock_version + 1'), 'updated_at' => now()]);
        $this->reservationMovement((string) $lockedItem->id, 'HARD_RESERVE', $quantity, $onHand, $reserved, $after, StockAvailability::quantity($lockedItem->soft_held_quantity), $actorId, 'ORDER_ACCEPTED', $orderId, $autoAcceptPolicyVersionId);
        DB::table('inventory_holds')->insert(['id' => (string) Str::uuid7(), 'inventory_item_id' => $lockedItem->id, 'hold_type' => 'HARD', 'quantity' => $quantity, 'state' => 'ACTIVE',
            'source_type' => 'ORDER', 'source_id' => $orderId, 'order_line_id' => $orderLineId, 'created_at' => now(), 'updated_at' => now()]);

        return DB::table('inventory_items')->where('id', $lockedItem->id)->first();
    }

    /**
     * Releases every active hard reservation of one order, locking the affected inventory rows in ascending id
     * order. Returns the released quantity per listing variant so the caller can restore auto-accept allotment.
     *
     * @return array<string, string>
     */
    public function releaseOrder(string $orderId, string $reasonCode, ?int $actorId): array
    {
        $this->assertTransaction();
        $holds = DB::table('inventory_holds')->where('source_type', 'ORDER')->where('source_id', $orderId)->where('hold_type', 'HARD')->where('state', 'ACTIVE')->orderBy('inventory_item_id')->get();
        if ($holds->isEmpty()) {
            return [];
        }
        $items = DB::table('inventory_items')->whereIn('id', $holds->pluck('inventory_item_id')->all())->orderBy('id')->lockForUpdate()->get()->keyBy('id');
        $released = [];
        foreach ($holds as $hold) {
            $item = $items->get($hold->inventory_item_id);
            $quantity = StockAvailability::quantity($hold->quantity);
            $reserved = StockAvailability::quantity($item->hard_reserved_quantity);
            $after = bcsub($reserved, $quantity, 4);
            if (bccomp($after, '0', 4) < 0) {
                throw new \LogicException('A reservation release cannot make the reserved quantity negative.');
            }
            DB::table('inventory_items')->where('id', $item->id)->update(['hard_reserved_quantity' => $after, 'lock_version' => DB::raw('lock_version + 1'), 'updated_at' => now()]);
            $this->reservationMovement((string) $item->id, 'HARD_RELEASE', bcmul($quantity, '-1', 4), StockAvailability::quantity($item->quantity_on_hand), $reserved, $after, StockAvailability::quantity($item->soft_held_quantity), $actorId, $reasonCode, $orderId, null);
            DB::table('inventory_holds')->where('id', $hold->id)->update(['state' => 'RELEASED', 'released_at' => now(), 'release_reason' => $reasonCode, 'updated_at' => now()]);
            $released[(string) $item->listing_variant_id] = $quantity;
        }

        return $released;
    }

    /**
     * Delivery or pickup: every active hard reservation of the order becomes a FULFILLED movement that lowers both
     * quantity_on_hand and hard_reserved_quantity by the reserved quantity, so available_to_sell is unchanged and a
     * reservation is never recorded as physical consumption twice. Rows lock in ascending id order. Idempotent: a
     * second call finds no active hold.
     *
     * @return array<string, string> fulfilled quantity per listing variant
     */
    public function fulfillOrder(string $orderId, ?int $actorId): array
    {
        $this->assertTransaction();
        $holds = DB::table('inventory_holds')->where('source_type', 'ORDER')->where('source_id', $orderId)->where('hold_type', 'HARD')->where('state', 'ACTIVE')->orderBy('inventory_item_id')->get();
        if ($holds->isEmpty()) {
            return [];
        }
        $items = DB::table('inventory_items')->whereIn('id', $holds->pluck('inventory_item_id')->all())->orderBy('id')->lockForUpdate()->get()->keyBy('id');
        $fulfilled = [];
        foreach ($holds as $hold) {
            $item = $items->get($hold->inventory_item_id);
            $quantity = StockAvailability::quantity($hold->quantity);
            $onHand = StockAvailability::quantity($item->quantity_on_hand);
            $reserved = StockAvailability::quantity($item->hard_reserved_quantity);
            $onHandAfter = bcsub($onHand, $quantity, 4);
            $reservedAfter = bcsub($reserved, $quantity, 4);
            if (bccomp($onHandAfter, '0', 4) < 0 || bccomp($reservedAfter, '0', 4) < 0) {
                throw new \LogicException('Fulfillment cannot make physical or reserved stock negative.');
            }
            DB::table('inventory_items')->where('id', $item->id)->update(['quantity_on_hand' => $onHandAfter, 'hard_reserved_quantity' => $reservedAfter, 'lock_version' => DB::raw('lock_version + 1'), 'updated_at' => now()]);
            DB::table('inventory_movements')->insert([
                'id' => (string) Str::uuid7(), 'inventory_item_id' => $item->id, 'movement_type' => 'FULFILLED', 'quantity' => bcmul($quantity, '-1', 4),
                'quantity_on_hand_before' => $onHand, 'quantity_on_hand_after' => $onHandAfter, 'hard_reserved_before' => $reserved, 'hard_reserved_after' => $reservedAfter,
                'soft_held_before' => StockAvailability::quantity($item->soft_held_quantity), 'soft_held_after' => StockAvailability::quantity($item->soft_held_quantity),
                'reason_code' => 'ORDER_FULFILLED', 'note' => null, 'actor_user_id' => $actorId, 'source_type' => 'ORDER', 'source_id' => $orderId, 'created_at' => now(), 'updated_at' => now(),
            ]);
            DB::table('inventory_holds')->where('id', $hold->id)->update(['state' => 'FULFILLED', 'released_at' => now(), 'updated_at' => now()]);
            $fulfilled[(string) $item->listing_variant_id] = $quantity;
        }

        return $fulfilled;
    }

    public function setReorderLevel(int $actorId, object $item, ?string $reorderLevel): void
    {
        $this->assertTransaction();
        if ($reorderLevel !== null && preg_match(self::QUANTITY_PATTERN, $reorderLevel) !== 1) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['reorder_level' => ['Enter a reorder level of zero or more, with up to four decimals, or leave it empty.']]);
        }
        DB::table('inventory_items')->where('id', $item->id)->update(['reorder_level' => $reorderLevel === null ? null : StockAvailability::quantity($reorderLevel), 'updated_by_user_id' => $actorId, 'lock_version' => DB::raw('lock_version + 1'), 'updated_at' => now()]);
    }

    private function movement(string $itemId, string $type, string $delta, string $before, string $after, string $reserved, string $softHeld, int $actorId, string $reasonCode, ?string $note, string $sourceType, string $sourceId): void
    {
        DB::table('inventory_movements')->insert([
            'id' => (string) Str::uuid7(), 'inventory_item_id' => $itemId, 'movement_type' => $type, 'quantity' => $delta,
            'quantity_on_hand_before' => $before, 'quantity_on_hand_after' => $after, 'hard_reserved_before' => $reserved, 'hard_reserved_after' => $reserved,
            'soft_held_before' => $softHeld, 'soft_held_after' => $softHeld, 'reason_code' => $reasonCode, 'note' => $note === null ? null : mb_substr(trim($note), 0, 500),
            'actor_user_id' => $actorId, 'source_type' => $sourceType, 'source_id' => $sourceId, 'created_at' => now(), 'updated_at' => now(),
        ]);
    }

    private function reservationMovement(string $itemId, string $type, string $delta, string $onHand, string $reservedBefore, string $reservedAfter, string $softHeld, ?int $actorId, string $reasonCode, string $orderId, ?string $policyVersionId): void
    {
        DB::table('inventory_movements')->insert([
            'id' => (string) Str::uuid7(), 'inventory_item_id' => $itemId, 'movement_type' => $type, 'quantity' => $delta,
            'quantity_on_hand_before' => $onHand, 'quantity_on_hand_after' => $onHand, 'hard_reserved_before' => $reservedBefore, 'hard_reserved_after' => $reservedAfter,
            'soft_held_before' => $softHeld, 'soft_held_after' => $softHeld, 'reason_code' => mb_substr($reasonCode, 0, 32), 'note' => null, 'auto_accept_policy_version_id' => $policyVersionId,
            'actor_user_id' => $actorId, 'source_type' => 'ORDER', 'source_id' => $orderId, 'created_at' => now(), 'updated_at' => now(),
        ]);
    }

    private function confirmation(string $itemId, int $actorId, string $quantity, string $source): void
    {
        DB::table('stock_confirmation_events')->insert(['id' => (string) Str::uuid7(), 'inventory_item_id' => $itemId, 'actor_user_id' => $actorId, 'confirmed_quantity' => $quantity, 'confirmed_at' => now(), 'source' => $source, 'created_at' => now(), 'updated_at' => now()]);
    }

    private function assertTransaction(): void
    {
        if (DB::transactionLevel() < 1) {
            throw new \LogicException('Inventory balances change only inside a database transaction.');
        }
    }
}
