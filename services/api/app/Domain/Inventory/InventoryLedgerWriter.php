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
