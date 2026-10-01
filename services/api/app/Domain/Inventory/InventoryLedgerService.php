<?php

declare(strict_types=1);

namespace App\Domain\Inventory;

use App\Domain\Catalog\ComparableMappingService;
use App\Domain\Catalog\ListingTransitions;
use App\Domain\Catalog\MarketplaceDiscoverability;
use App\Domain\Catalog\PriceVersionService;
use App\Domain\Catalog\VolumePricing;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Vendor-only inventory ledger: exact balances, reorder levels, counts and adjustments, stock
 * confirmations, append-only movement history and quick ordinary-price versions. Manual edits use
 * lock_version optimistic concurrency and return the current row on conflict instead of overwriting it.
 * Buyers never receive these quantities; they only see StockAvailability labels.
 */
final class InventoryLedgerService
{
    public const PAGE_SIZE = 25;

    public const MAX_CONFIRMATIONS = 100;

    public function __construct(
        private readonly InventoryAccess $access,
        private readonly InventoryLocks $locks,
        private readonly InventoryLedgerWriter $writer,
        private readonly PriceVersionService $prices,
        private readonly ListingTransitions $transitions,
        private readonly MarketplaceDiscoverability $discoverability,
        private readonly StockConfirmationService $confirmations,
        private readonly AuditRecorder $audit,
    ) {}

    /**
     * @param  array<string, mixed>  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function ledger(Request $request, array $filters): array
    {
        $scope = $this->access->scope($request);
        if (! in_array(InventoryAccess::VIEW, $scope['permissions'], true)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'This action is not available to your role.', 403);
        }
        $organizationId = $scope['organization_id'];
        $base = function () use ($organizationId, $filters): Builder {
            $query = DB::table('listing_variants as v')->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')
                ->leftJoin('inventory_items as i', 'i.listing_variant_id', '=', 'v.id')
                ->where('l.vendor_organization_id', $organizationId)->whereNull('l.removed_at')->where('v.active', true);
            if (! empty($filters['q'])) {
                $term = '%'.addcslashes(mb_strtolower((string) $filters['q']), '%_\\').'%';
                $query->where(fn (Builder $search) => $search->whereRaw('lower(l.display_name) LIKE ?', [$term])->orWhereRaw('lower(l.vendor_sku) LIKE ?', [$term])->orWhereRaw('lower(v.sku) LIKE ?', [$term]));
            }
            if (! empty($filters['listing_id'])) {
                $query->where('l.id', $filters['listing_id']);
            }

            return $query;
        };
        $staleBefore = now()->subDays(StockConfirmationPolicy::HIDE_AFTER_DAYS);
        $dueBefore = now()->subDays(StockConfirmationPolicy::FIRST_REMINDER_DAYS);
        $summary = $base()->selectRaw(
            'COUNT(*) AS variants,
             COUNT(*) FILTER (WHERE i.id IS NULL OR i.quantity_on_hand - i.hard_reserved_quantity <= 0) AS out_of_stock,
             COUNT(*) FILTER (WHERE i.quantity_on_hand - i.hard_reserved_quantity > 0 AND i.reorder_level IS NOT NULL AND i.quantity_on_hand - i.hard_reserved_quantity <= i.reorder_level) AS limited_stock,
             COUNT(*) FILTER (WHERE i.confirmed_at IS NOT NULL AND i.confirmed_at <= ? AND i.confirmed_at > ?) AS confirmation_due,
             COUNT(*) FILTER (WHERE i.confirmed_at IS NULL OR i.confirmed_at <= ?) AS stale', [$dueBefore, $staleBefore, $staleBefore])->first();
        $query = $base();
        match ($filters['stock'] ?? null) {
            StockAvailability::OUT_OF_STOCK => $query->where(fn (Builder $out) => $out->whereNull('i.id')->orWhereRaw('i.quantity_on_hand - i.hard_reserved_quantity <= 0')),
            StockAvailability::LIMITED_STOCK => $query->whereRaw('i.quantity_on_hand - i.hard_reserved_quantity > 0')->whereNotNull('i.reorder_level')->whereRaw('i.quantity_on_hand - i.hard_reserved_quantity <= i.reorder_level'),
            StockAvailability::IN_STOCK => $query->whereRaw('i.quantity_on_hand - i.hard_reserved_quantity > 0')->where(fn (Builder $in) => $in->whereNull('i.reorder_level')->orWhereRaw('i.quantity_on_hand - i.hard_reserved_quantity > i.reorder_level')),
            default => null,
        };
        match ($filters['confirmation'] ?? null) {
            'DUE' => $query->whereNotNull('i.confirmed_at')->where('i.confirmed_at', '<=', $dueBefore)->where('i.confirmed_at', '>', $staleBefore),
            'STALE' => $query->where(fn (Builder $stale) => $stale->whereNull('i.confirmed_at')->orWhere('i.confirmed_at', '<=', $staleBefore)),
            default => null,
        };
        $page = $query->orderBy('l.display_name')->orderBy('l.id')->orderBy('v.sort_order')->orderBy('v.id')->paginate(self::PAGE_SIZE, ['v.id'], 'page', (int) ($filters['page'] ?? 1));
        $rows = $this->rows(array_map(static fn (object $row): string => (string) $row->id, $page->items()));

        return ['items' => $rows, 'meta' => [
            'current_page' => $page->currentPage(), 'last_page' => $page->lastPage(), 'total' => $page->total(), 'page_size' => self::PAGE_SIZE,
            'summary' => ['variants' => (int) $summary->variants, 'out_of_stock' => (int) $summary->out_of_stock, 'limited_stock' => (int) $summary->limited_stock, 'confirmation_due' => (int) $summary->confirmation_due, 'stale' => (int) $summary->stale],
            'stale_listings' => $this->staleListings($organizationId),
            'label_rule_version' => StockAvailability::RULE_VERSION, 'timezone' => StockConfirmationPolicy::TIMEZONE,
            'permissions' => $this->permissions($scope['permissions']),
        ]];
    }

    /**
     * Inline row edit: count/adjustment with a reason, reorder level and an optional quick ordinary-price
     * change. One transaction; a stale lock_version or price version returns 409 with the current row.
     *
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function adjust(Request $request, string $variantId, array $input): array
    {
        $hasQuantity = array_key_exists('quantity_on_hand', $input) && $input['quantity_on_hand'] !== null;
        $hasReorder = array_key_exists('reorder_level', $input);
        $hasPrice = isset($input['price']) && is_array($input['price']);
        $required = [];
        if ($hasQuantity || $hasReorder) {
            $required[] = InventoryAccess::MANAGE;
        }
        if ($hasPrice) {
            $required[] = InventoryAccess::PRICE;
        }
        if ($required === []) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Change the count, reorder level or price before saving.', 422, ['quantity_on_hand' => ['Nothing to save.']]);
        }
        $organizationId = $this->access->organizationFor($request, [InventoryAccess::MANAGE, InventoryAccess::PRICE]);
        foreach ($required as $permission) {
            if (! $this->access->allows($request, $permission)) {
                throw new AuthenticationException('PERMISSION_DENIED', 'This action is not available to your role.', 403);
            }
        }
        $actorId = (int) $request->user()->getKey();
        DB::transaction(function () use ($request, $organizationId, $variantId, $input, $hasQuantity, $hasReorder, $hasPrice, $actorId): void {
            ['listing' => $listing] = $this->locks->variantForUpdate($organizationId, $variantId);
            $item = DB::table('inventory_items')->where('listing_variant_id', $variantId)->lockForUpdate()->first();
            if (($item === null ? 0 : (int) $item->lock_version) !== (int) $input['lock_version']) {
                throw new AuthenticationException('STALE_VERSION', 'Someone else changed this row. Review the current values before saving again.', 409, ['current' => $this->rows([$variantId])[0] ?? null]);
            }
            $before = $this->rows([$variantId])[0] ?? [];
            if ($hasQuantity) {
                $this->writer->recordCount($actorId, $variantId, (string) $input['quantity_on_hand'], (string) ($input['reason_code'] ?? 'COUNT'), isset($input['note']) ? (string) $input['note'] : null, 'INVENTORY_LEDGER');
            }
            if ($hasReorder) {
                $item = DB::table('inventory_items')->where('listing_variant_id', $variantId)->lockForUpdate()->first();
                if ($item === null) {
                    throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['reorder_level' => ['Record a stock count before setting a reorder level.']]);
                }
                $this->writer->setReorderLevel($actorId, $item, $input['reorder_level'] === null ? null : (string) $input['reorder_level']);
            }
            $priceChanged = $hasPrice && $this->changePrice($actorId, $variantId, $input['price']);
            if ($priceChanged) {
                $this->transitions->republish($listing, $actorId, 'PRICE_VERSION_CHANGED');
            }
            $this->confirmations->restoreIfConfirmed(DB::table('vendor_listings')->where('id', $listing->id)->first(), $actorId, 'VENDOR');
            $this->audit->account($request, 'INVENTORY_ROW_UPDATED', 'LISTING_VARIANT', $variantId, before: self::auditView($before), after: self::auditView($this->rows([$variantId])[0] ?? []), reason: isset($input['reason_code']) ? (string) $input['reason_code'] : null);
            $this->discoverability->evaluate($organizationId, $actorId, 'VENDOR');
        });

        return $this->rows([$variantId])[0];
    }

    /**
     * Confirms unchanged counts. All rows succeed or none do; any stale version returns every conflict.
     *
     * @param  list<array{listing_variant_id: string, lock_version: int}>  $items
     * @return list<array<string, mixed>>
     */
    public function confirm(Request $request, array $items): array
    {
        $organizationId = $this->access->organizationFor($request, [InventoryAccess::MANAGE]);
        $actorId = (int) $request->user()->getKey();
        $variantIds = array_values(array_unique(array_map(static fn (array $item): string => (string) $item['listing_variant_id'], $items)));
        DB::transaction(function () use ($request, $organizationId, $items, $variantIds, $actorId): void {
            DB::table('vendor_organizations')->where('id', $organizationId)->lockForUpdate()->first(['id']);
            $owned = DB::table('listing_variants as v')->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')
                ->whereIn('v.id', $variantIds)->where('l.vendor_organization_id', $organizationId)->whereNull('l.removed_at')->where('v.active', true)
                ->pluck('l.id as listing_id', 'v.id as variant_id');
            if ($owned->count() !== count($variantIds)) {
                throw new AuthenticationException('RESOURCE_NOT_FOUND', 'One or more product variants are unavailable.', 404);
            }
            $listingIds = $owned->values()->unique()->sort()->values()->all();
            DB::table('vendor_listings')->whereIn('id', $listingIds)->orderBy('id')->lockForUpdate()->get(['id']);
            $locked = DB::table('inventory_items')->whereIn('listing_variant_id', $variantIds)->orderBy('id')->lockForUpdate()->get()->keyBy('listing_variant_id');
            $conflicts = [];
            foreach ($items as $item) {
                $row = $locked[$item['listing_variant_id']] ?? null;
                if ($row === null) {
                    $conflicts[$item['listing_variant_id']] = ['Record a stock count before confirming it.'];
                } elseif ((int) $row->lock_version !== (int) $item['lock_version']) {
                    $conflicts[$item['listing_variant_id']] = ['This row changed. Review the current count and confirm again.'];
                }
            }
            if ($conflicts !== []) {
                throw new AuthenticationException('STALE_VERSION', 'Some rows changed since you opened them. Nothing was confirmed.', 409, ['conflicts' => $conflicts, 'current' => $this->rows($variantIds)]);
            }
            foreach ($locked as $row) {
                $this->writer->confirmUnchanged($actorId, $row);
            }
            foreach ($listingIds as $listingId) {
                $this->confirmations->restoreIfConfirmed(DB::table('vendor_listings')->where('id', $listingId)->first(), $actorId, 'VENDOR');
            }
            $this->audit->account($request, 'INVENTORY_STOCK_CONFIRMED', 'VENDOR_ORGANIZATION', $organizationId, after: ['listing_variant_ids' => $variantIds]);
            $this->discoverability->evaluate($organizationId, $actorId, 'VENDOR');
        });

        return $this->rows($variantIds);
    }

    /** @return array{items: list<array<string, mixed>>, meta: array<string, mixed>} */
    public function movements(Request $request, string $variantId, int $page): array
    {
        $organizationId = $this->access->organizationFor($request, [InventoryAccess::VIEW]);
        $this->assertOwned($organizationId, $variantId);
        $result = DB::table('inventory_movements as m')->join('inventory_items as i', 'i.id', '=', 'm.inventory_item_id')
            ->leftJoin('user_profiles as up', 'up.user_id', '=', 'm.actor_user_id')->where('i.listing_variant_id', $variantId)
            ->orderByDesc('m.created_at')->orderByDesc('m.id')
            ->paginate(self::PAGE_SIZE, ['m.id', 'm.movement_type', 'm.quantity', 'm.quantity_on_hand_before', 'm.quantity_on_hand_after', 'm.hard_reserved_after', 'm.soft_held_after', 'm.reason_code', 'm.note', 'm.source_type', 'm.actor_user_id', 'm.auto_accept_policy_version_id', 'm.created_at', 'up.full_name'], 'page', $page);

        return ['items' => array_map(static fn (object $row): array => [
            'id' => $row->id, 'movement_type' => $row->movement_type, 'quantity_delta' => StockAvailability::quantity($row->quantity),
            'quantity_on_hand_before' => $row->quantity_on_hand_before === null ? null : StockAvailability::quantity($row->quantity_on_hand_before),
            'quantity_on_hand_after' => StockAvailability::quantity($row->quantity_on_hand_after),
            'hard_reserved_after' => $row->hard_reserved_after === null ? null : StockAvailability::quantity($row->hard_reserved_after),
            'reason_code' => $row->reason_code, 'note' => $row->note, 'source_type' => $row->source_type,
            'actor' => $row->actor_user_id === null ? ($row->auto_accept_policy_version_id === null ? 'System' : 'Auto-accept policy') : ($row->full_name ?? 'Vendor user'),
            'recorded_at' => $row->created_at,
        ], $result->items()), 'meta' => ['current_page' => $result->currentPage(), 'last_page' => $result->lastPage(), 'total' => $result->total()]];
    }

    /** @return list<array<string, mixed>> */
    public function priceHistory(Request $request, string $variantId): array
    {
        $organizationId = $this->access->organizationFor($request, [InventoryAccess::VIEW]);
        $this->assertOwned($organizationId, $variantId);

        return $this->prices->history($variantId);
    }

    /** @return array<string, mixed> */
    public function settings(Request $request): array
    {
        $scope = $this->access->scope($request);
        if (! in_array(InventoryAccess::VIEW, $scope['permissions'], true)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'This action is not available to your role.', 403);
        }

        return $this->presentSettings($scope['organization_id'], $scope['permissions']);
    }

    /**
     * @param  array{lock_version: int, reminder_local_time: string, email_reminders: bool, auto_accept_ready_lead_days?: int|null}  $input
     * @return array<string, mixed>
     */
    public function saveSettings(Request $request, array $input): array
    {
        $organizationId = $this->access->organizationFor($request, [InventoryAccess::SETTINGS]);
        DB::transaction(function () use ($request, $organizationId, $input): void {
            DB::table('vendor_organizations')->where('id', $organizationId)->lockForUpdate()->first(['id']);
            $current = DB::table('vendor_inventory_settings')->where('vendor_organization_id', $organizationId)->lockForUpdate()->first();
            if (($current === null ? 0 : (int) $current->lock_version) !== (int) $input['lock_version']) {
                throw new AuthenticationException('STALE_VERSION', 'These settings changed since you opened them. Review them and save again.', 409, ['current' => $this->presentSettings($organizationId, [])]);
            }
            $values = ['reminder_local_time' => $input['reminder_local_time'], 'email_reminders' => (bool) $input['email_reminders'], 'updated_by_user_id' => $request->user()->getKey(), 'updated_at' => now()];
            if (array_key_exists('auto_accept_ready_lead_days', $input)) {
                // Ready-for-pickup date recorded by an auto-accepted Self-Pickup order (approved by the project owner on 2026-09-29).
                $values['auto_accept_ready_lead_days'] = $input['auto_accept_ready_lead_days'] === null ? null : (int) $input['auto_accept_ready_lead_days'];
            }
            if ($current === null) {
                DB::table('vendor_inventory_settings')->insert($values + ['id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'lock_version' => 1, 'created_at' => now()]);
            } else {
                DB::table('vendor_inventory_settings')->where('id', $current->id)->update($values + ['lock_version' => (int) $current->lock_version + 1]);
            }
            $this->audit->account($request, 'INVENTORY_REMINDER_SETTINGS_UPDATED', 'VENDOR_ORGANIZATION', $organizationId, after: ['reminder_local_time' => $input['reminder_local_time'], 'email_reminders' => (bool) $input['email_reminders'],
                'auto_accept_ready_lead_days' => $values['auto_accept_ready_lead_days'] ?? ($current?->auto_accept_ready_lead_days)]);
        });

        return $this->presentSettings($organizationId, $this->access->scope($request)['permissions']);
    }

    /**
     * Vendor-only ledger rows for the given variants, in the given order.
     *
     * @param  list<string>  $variantIds
     * @return list<array<string, mixed>>
     */
    public function rows(array $variantIds): array
    {
        if ($variantIds === []) {
            return [];
        }
        $rows = DB::table('listing_variants as v')->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')->join('units as u', 'u.id', '=', 'v.unit_id')
            ->leftJoin('inventory_items as i', 'i.listing_variant_id', '=', 'v.id')
            ->leftJoin('listing_price_versions as pv', fn ($join) => $join->on('pv.listing_variant_id', '=', 'v.id')->where('pv.price_kind', 'ORDINARY')->whereNull('pv.retired_at'))
            ->whereIn('v.id', $variantIds)
            ->get(['v.id', 'v.sku', 'v.label', 'u.code as unit_code', 'l.id as listing_id', 'l.display_name', 'l.status as listing_status',
                'i.id as item_id', 'i.quantity_on_hand', 'i.hard_reserved_quantity', DB::raw("(SELECT COALESCE(SUM(h.quantity), 0) FROM inventory_holds h WHERE h.inventory_item_id = i.id AND h.hold_type = 'SOFT' AND h.state = 'ACTIVE' AND (h.expires_at IS NULL OR h.expires_at > CURRENT_TIMESTAMP)) as soft_held_quantity"), 'i.reorder_level', 'i.confirmed_at', 'i.lock_version', 'i.updated_at',
                'pv.id as price_id', 'pv.version as price_version', 'pv.amount_centavos', 'pv.tax_category', 'pv.effective_at'])->keyBy('id');
        $policies = DB::table('auto_accept_policies')->whereIn('listing_variant_id', $variantIds)->get()->keyBy('listing_variant_id');
        $comparable = DB::table('listing_comparable_assignments')->whereIn('listing_variant_id', $variantIds)->whereNull('effective_until')->where('mapping_state', 'APPROVED')->pluck('material_comparable_group_version_id', 'listing_variant_id');
        $anchors = [];
        $result = [];
        foreach ($variantIds as $variantId) {
            $row = $rows[$variantId] ?? null;
            if ($row === null) {
                continue;
            }
            $anchors[$row->listing_id] ??= StockConfirmationPolicy::listingAnchor((string) $row->listing_id);
            $available = $row->item_id === null ? null : StockAvailability::availableToSell((string) $row->quantity_on_hand, (string) $row->hard_reserved_quantity);
            $reorder = $row->reorder_level === null ? null : StockAvailability::quantity($row->reorder_level);
            $result[] = [
                'listing_variant_id' => $row->id, 'listing_id' => $row->listing_id, 'listing_name' => $row->display_name, 'listing_status' => $row->listing_status,
                'variant_label' => $row->label, 'sku' => $row->sku, 'unit_code' => $row->unit_code, 'lock_version' => $row->item_id === null ? 0 : (int) $row->lock_version,
                'inventory' => $row->item_id === null ? null : [
                    'quantity_on_hand' => StockAvailability::quantity($row->quantity_on_hand), 'hard_reserved_quantity' => StockAvailability::quantity($row->hard_reserved_quantity),
                    'soft_held_quantity' => StockAvailability::quantity($row->soft_held_quantity), 'available_to_sell' => $available, 'reorder_level' => $reorder,
                    'confirmed_at' => $row->confirmed_at, 'updated_at' => $row->updated_at,
                ],
                'public_label' => StockAvailability::label($available, $reorder),
                'stock_confirmation' => StockConfirmationPolicy::schedule($row->confirmed_at),
                'listing_confirmation' => StockConfirmationPolicy::schedule($anchors[$row->listing_id]),
                'price' => $row->price_id === null ? null : ['price_version_id' => $row->price_id, 'version' => (int) $row->price_version, 'amount_centavos' => (int) $row->amount_centavos, 'tax_category' => $row->tax_category, 'effective_at' => $row->effective_at],
                'comparability' => isset($comparable[$variantId]) ? ['status' => 'COMPARABLE', 'group_version_id' => $comparable[$variantId], 'rule_version' => ComparableMappingService::MAPPING_RULE] : ['status' => 'NOT_YET_COMPARABLE', 'group_version_id' => null, 'rule_version' => ComparableMappingService::MAPPING_RULE],
                'auto_accept' => AutoAcceptPolicyService::present($policies[$variantId] ?? null),
            ];
        }

        return $result;
    }

    /** @param array<string, mixed> $price */
    private function changePrice(int $actorId, string $variantId, array $price): bool
    {
        $current = DB::table('listing_price_versions')->where('listing_variant_id', $variantId)->where('price_kind', 'ORDINARY')->whereNull('retired_at')->lockForUpdate()->first();
        if ($current === null) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['price.amount_centavos' => ['Set the first price and tax classification in the product editor.']]);
        }
        if (($price['expected_price_version_id'] ?? null) !== $current->id) {
            throw new AuthenticationException('PRICE_VERSION_CONFLICT', 'The price changed since you opened this row. Review the current price before saving again.', 409, ['current' => $this->rows([$variantId])[0] ?? null]);
        }
        $amount = $price['amount_centavos'] ?? null;
        if (! is_int($amount) || $amount <= 0) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['price.amount_centavos' => ['Enter a price greater than zero.']]);
        }
        $tierErrors = VolumePricing::errors($this->prices->currentTierRows($variantId), $amount);
        if ($tierErrors !== []) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['price.amount_centavos' => ['This price is not above every volume tier price. Update the tiers in the product editor first.']]);
        }

        return $this->prices->saveOrdinary($actorId, $variantId, $amount, (string) $current->tax_category, $current->tax_basis);
    }

    /** @return array{count: int, items: list<array<string, mixed>>} */
    private function staleListings(string $organizationId): array
    {
        $due = now()->subDays(StockConfirmationPolicy::FIRST_REMINDER_DAYS);
        $query = DB::table('vendor_listings as l')->join('listing_variants as v', 'v.vendor_listing_id', '=', 'l.id')->leftJoin('inventory_items as i', 'i.listing_variant_id', '=', 'v.id')
            ->where('l.vendor_organization_id', $organizationId)->whereNull('l.removed_at')->where('v.active', true)
            ->whereIn('l.status', ['ACTIVE', 'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED'])->groupBy('l.id', 'l.display_name', 'l.status')
            ->havingRaw('MIN(i.confirmed_at) <= ? OR COUNT(i.confirmed_at) < COUNT(*)', [$due]);
        $count = DB::query()->fromSub((clone $query)->selectRaw('l.id'), 'due')->count();
        $items = $query->orderByRaw('MIN(i.confirmed_at) ASC NULLS FIRST')->orderBy('l.id')->limit(5)->selectRaw('l.id, l.display_name, l.status, MIN(i.confirmed_at) AS anchor, COUNT(*) AS variants, COUNT(i.confirmed_at) AS confirmed')->get();

        return ['count' => $count, 'items' => $items->map(static fn (object $row): array => [
            'listing_id' => $row->id, 'listing_name' => $row->display_name, 'listing_status' => $row->status,
            'confirmation' => StockConfirmationPolicy::schedule((int) $row->variants === (int) $row->confirmed ? (string) $row->anchor : null),
        ])->all()];
    }

    /**
     * @param  list<string>  $permissions
     * @return array<string, bool>
     */
    private function permissions(array $permissions): array
    {
        return [
            'can_adjust' => in_array(InventoryAccess::MANAGE, $permissions, true), 'can_change_price' => in_array(InventoryAccess::PRICE, $permissions, true),
            'can_configure_auto_accept' => in_array(InventoryAccess::AUTO_ACCEPT_CONFIGURE, $permissions, true),
            'can_update_allotment' => in_array(InventoryAccess::AUTO_ACCEPT_CONFIGURE, $permissions, true) || in_array(InventoryAccess::AUTO_ACCEPT_ALLOTMENT, $permissions, true),
            'can_view_auto_accept' => array_intersect([InventoryAccess::AUTO_ACCEPT_CONFIGURE, InventoryAccess::AUTO_ACCEPT_ALLOTMENT, InventoryAccess::AUTO_ACCEPT_VIEW], $permissions) !== [],
            'can_edit_settings' => in_array(InventoryAccess::SETTINGS, $permissions, true),
        ];
    }

    /**
     * @param  list<string>  $permissions
     * @return array<string, mixed>
     */
    private function presentSettings(string $organizationId, array $permissions): array
    {
        $settings = DB::table('vendor_inventory_settings')->where('vendor_organization_id', $organizationId)->first();

        return [
            'reminder_local_time' => $settings === null ? '08:00' : substr((string) $settings->reminder_local_time, 0, 5),
            'email_reminders' => $settings === null ? true : (bool) $settings->email_reminders,
            'in_app_reminders' => true, 'timezone' => StockConfirmationPolicy::TIMEZONE,
            'reminder_days' => [StockConfirmationPolicy::FIRST_REMINDER_DAYS, StockConfirmationPolicy::FINAL_REMINDER_DAYS], 'hide_after_days' => StockConfirmationPolicy::HIDE_AFTER_DAYS,
            'auto_accept_ready_lead_days' => $settings?->auto_accept_ready_lead_days === null ? null : (int) $settings->auto_accept_ready_lead_days,
            'lock_version' => $settings === null ? 0 : (int) $settings->lock_version,
            'can_edit' => in_array(InventoryAccess::SETTINGS, $permissions, true),
        ];
    }

    private function assertOwned(string $organizationId, string $variantId): void
    {
        $exists = DB::table('listing_variants as v')->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')
            ->where('v.id', $variantId)->where('l.vendor_organization_id', $organizationId)->whereNull('l.removed_at')->exists();
        if (! $exists) {
            throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The product variant is unavailable.', 404);
        }
    }

    /**
     * @param  array<string, mixed>  $row
     * @return array<string, mixed>
     */
    private static function auditView(array $row): array
    {
        return ['inventory' => $row['inventory'] ?? null, 'price' => $row['price'] ?? null];
    }
}
