<?php

declare(strict_types=1);

namespace App\Domain\Procurement;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Catalog\VolumePricing;
use App\Domain\Finance\FinancialSnapshotService;
use App\Domain\Geography\BuyerProfiles;
use App\Domain\Geography\GeographyScopeResolver;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Inventory\StockAvailability;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * The Buyer's Item-Based cart. Placing or editing a line never creates an inventory hold or reservation and
 * never changes available_to_sell; it records the listing publication, price version, payable unit price and
 * public stock label the Buyer saw so later changes surface as line issues rather than silent updates.
 * Lines are grouped by Vendor; each group keeps its own fulfillment choice. The intended destination and any
 * heavy-vehicle alternate drop-off are stored separately and are never replaced by another saved location.
 */
final class CartService
{
    public const MAX_LINES = 100;

    public const QUANTITY_PATTERN = '/^\d{1,7}(\.\d{1,4})?$/';

    public const BLOCKING = 'BLOCKING';

    public const ACTION_REQUIRED = 'ACTION_REQUIRED';

    public const INFO = 'INFO';

    public function __construct(
        private readonly BuyerProfiles $profiles,
        private readonly GeographyScopeResolver $scopes,
        private readonly ScopedOfferQuery $offers,
        private readonly ListingPublicFacts $facts,
        private readonly CatalogAccess $idempotency,
    ) {}

    public static function quantityStep(int $unitPrecision): string
    {
        return $unitPrecision <= 0 ? '1' : '0.'.str_repeat('0', min(4, $unitPrecision) - 1).'1';
    }

    /** @return array<string, mixed> */
    public function view(Request $request): array
    {
        return $this->present($this->cart($this->profiles->idFor($request)));
    }

    /**
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function addItem(Request $request, array $input): array
    {
        $buyerId = $this->profiles->idFor($request);
        $key = $this->idempotency->requireIdempotencyKey($request);
        $cartId = DB::transaction(function () use ($request, $input, $buyerId, $key): string {
            $cart = $this->cart($buyerId, true);
            if ($this->idempotency->replayed($request, 'BUYER_CART_ADD', $key, $buyerId)) {
                return (string) $cart->id;
            }
            $scope = $this->scopes->forBuyer($buyerId, $input);
            $variantId = (string) $input['listing_variant_id'];
            $offer = $this->offerQuery($this->offers->within($scope))->where('v.id', $variantId)->first();
            if ($offer === null) {
                throw $this->offers->anywhere()->where('v.id', $variantId)->exists()
                    ? new AuthenticationException('OUTSIDE_SELECTED_RADIUS', 'This store is outside your selected radius. Change the radius or location to add it.', 422)
                    : new AuthenticationException('LISTING_UNAVAILABLE', 'This product is no longer available. Refresh to see current offers.', 409);
            }
            if ($offer->vacation_mode) {
                throw new AuthenticationException('STORE_ON_VACATION', 'This store has paused new procurement.', 409);
            }
            if ((string) $offer->price_version_id !== (string) $input['expected_price_version_id']) {
                throw new AuthenticationException('PRICE_CHANGED', 'The price changed since you opened this product. Review the current price and add again.', 409,
                    ['current_price_version_id' => (string) $offer->price_version_id, 'current_unit_price_centavos' => (int) $offer->amount_centavos]);
            }
            $quantity = $this->quantity($input['quantity'] ?? null, (int) $offer->unit_precision);
            $existing = DB::table('cart_items')->where('cart_id', $cart->id)->where('listing_variant_id', $variantId)->lockForUpdate()->first();
            $total = $existing === null || $existing->saved_for_later_at !== null ? $quantity : bcadd(StockAvailability::quantity($existing->quantity), $quantity, 4);
            $this->assertAvailable($total, (string) $offer->available);
            if ($existing === null && DB::table('cart_items')->where('cart_id', $cart->id)->count() >= self::MAX_LINES) {
                throw new AuthenticationException('CART_FULL', 'Your cart can hold up to '.self::MAX_LINES.' lines. Remove a line first.', 422);
            }
            $snapshot = $this->snapshot($offer) + ['quantity' => $total, 'saved_for_later_at' => null, 'updated_at' => now()];
            if ($existing === null) {
                DB::table('cart_items')->insert($snapshot + ['id' => (string) Str::uuid7(), 'cart_id' => $cart->id, 'listing_variant_id' => $variantId, 'lock_version' => 1, 'created_at' => now()]);
            } else {
                DB::table('cart_items')->where('id', $existing->id)->update($snapshot + ['lock_version' => (int) $existing->lock_version + 1]);
            }
            $this->ensureGroup((string) $cart->id, (string) $offer->organization_id, (string) $offer->fulfillment_method, $input['fulfillment_method'] ?? null);
            $this->touch($cart);
            $this->idempotency->claim($request, 'BUYER_CART_ADD', $key, $buyerId, 200);

            return (string) $cart->id;
        });

        return $this->present(DB::table('carts')->where('id', $cartId)->first());
    }

    /**
     * Quantity edits revalidate availability; accept_current_price replaces the stored snapshot with the
     * current price version only on the Buyer's explicit request.
     *
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function updateItem(Request $request, string $itemId, array $input): array
    {
        $buyerId = $this->profiles->idFor($request);
        DB::transaction(function () use ($buyerId, $itemId, $input): void {
            $cart = $this->lockedCart($buyerId, (int) $input['lock_version']);
            $item = Str::isUuid($itemId) ? DB::table('cart_items')->where('id', $itemId)->where('cart_id', $cart->id)->lockForUpdate()->first() : null;
            if ($item === null) {
                throw new AuthenticationException('CART_ITEM_NOT_FOUND', 'This cart line no longer exists.', 404);
            }
            $offer = $this->offerQuery($this->offers->anywhere())->where('v.id', $item->listing_variant_id)->first();
            $update = ['updated_at' => now(), 'lock_version' => (int) $item->lock_version + 1];
            if (array_key_exists('saved_for_later', $input)) {
                $update['saved_for_later_at'] = $input['saved_for_later'] ? ($item->saved_for_later_at ?? now()) : null;
            }
            if (isset($input['quantity'])) {
                if ($offer === null) {
                    throw new AuthenticationException('LISTING_UNAVAILABLE', 'This product is no longer available. Remove it or save it for later.', 409);
                }
                $update['quantity'] = $this->quantity($input['quantity'], (int) $offer->unit_precision);
                $this->assertAvailable($update['quantity'], (string) $offer->available);
            }
            if (($input['accept_current_price'] ?? false) === true) {
                if ($offer === null) {
                    throw new AuthenticationException('LISTING_UNAVAILABLE', 'This product is no longer available. Remove it or save it for later.', 409);
                }
                $update += $this->snapshot($offer);
            }
            DB::table('cart_items')->where('id', $item->id)->update($update);
            $this->touch($cart);
        });

        return $this->view($request);
    }

    /** @return array<string, mixed> */
    public function removeItem(Request $request, string $itemId, int $lockVersion): array
    {
        $buyerId = $this->profiles->idFor($request);
        DB::transaction(function () use ($buyerId, $itemId, $lockVersion): void {
            $cart = $this->lockedCart($buyerId, $lockVersion);
            $item = Str::isUuid($itemId) ? DB::table('cart_items')->where('id', $itemId)->where('cart_id', $cart->id)->first() : null;
            if ($item === null) {
                throw new AuthenticationException('CART_ITEM_NOT_FOUND', 'This cart line no longer exists.', 404);
            }
            $organizationId = DB::table('listing_variants as v')->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')->where('v.id', $item->listing_variant_id)->value('l.vendor_organization_id');
            DB::table('cart_items')->where('id', $item->id)->delete();
            $remaining = DB::table('cart_items as c')->join('listing_variants as v', 'v.id', '=', 'c.listing_variant_id')->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')
                ->where('c.cart_id', $cart->id)->where('l.vendor_organization_id', $organizationId)->exists();
            if (! $remaining) {
                DB::table('cart_vendor_groups')->where('cart_id', $cart->id)->where('vendor_organization_id', $organizationId)->delete();
            }
            $this->touch($cart);
        });

        return $this->view($request);
    }

    /**
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function setFulfillment(Request $request, string $vendorId, array $input): array
    {
        $buyerId = $this->profiles->idFor($request);
        DB::transaction(function () use ($buyerId, $vendorId, $input): void {
            $cart = $this->lockedCart($buyerId, (int) $input['lock_version']);
            $group = Str::isUuid($vendorId) ? DB::table('cart_vendor_groups')->where('cart_id', $cart->id)->where('vendor_organization_id', $vendorId)->first() : null;
            if ($group === null) {
                throw new AuthenticationException('CART_GROUP_NOT_FOUND', 'This Vendor is no longer in your cart.', 404);
            }
            $method = (string) $input['fulfillment_method'];
            $offered = self::fulfillmentOptions((string) DB::table('store_profiles')->where('vendor_organization_id', $vendorId)->value('fulfillment_method'));
            if (! in_array($method, $offered, true)) {
                throw new AuthenticationException('FULFILLMENT_NOT_OFFERED', $method === 'DELIVERY' ? 'This store does not offer Site Delivery.' : 'This store does not offer Self-Pickup.', 422);
            }
            DB::table('cart_vendor_groups')->where('id', $group->id)->update(['fulfillment_method' => $method, 'updated_at' => now()]);
            $this->touch($cart);
        });

        return $this->view($request);
    }

    /**
     * Heavy-vehicle restriction Yes requires a distinct saved alternate drop-off and access instructions;
     * the intended destination (delivery address or Project site) is kept as its own reference either way.
     *
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function setDestination(Request $request, array $input): array
    {
        $buyerId = $this->profiles->idFor($request);
        DB::transaction(function () use ($buyerId, $input): void {
            $cart = $this->lockedCart($buyerId, (int) $input['lock_version']);
            $intended = $input['intended_location_id'] ?? null;
            $answer = (string) ($input['heavy_vehicle_restriction'] ?? 'UNANSWERED');
            $alternate = $answer === 'YES' ? ($input['alternate_drop_off_location_id'] ?? null) : null;
            $instructions = isset($input['access_instructions']) ? trim((string) $input['access_instructions']) : '';
            $errors = [];
            if ($intended !== null && ! $this->ownsActiveLocation($buyerId, (string) $intended)) {
                $errors['intended_location_id'][] = 'Choose one of your saved locations.';
            }
            if ($answer !== 'UNANSWERED' && $intended === null) {
                $errors['intended_location_id'][] = 'Choose the intended delivery location or Project site first.';
            }
            if ($answer === 'YES') {
                if ($alternate === null) {
                    $errors['alternate_drop_off_location_id'][] = 'A heavy-vehicle restriction needs an alternative drop-off location.';
                } elseif ($alternate === $intended) {
                    $errors['alternate_drop_off_location_id'][] = 'The alternative drop-off must be a different location from the intended destination.';
                } elseif (! $this->ownsActiveLocation($buyerId, (string) $alternate)) {
                    $errors['alternate_drop_off_location_id'][] = 'Choose one of your saved locations.';
                }
                if (mb_strlen($instructions) < 5) {
                    $errors['access_instructions'][] = 'Describe access and unloading at the alternative drop-off.';
                }
            }
            if (mb_strlen($instructions) > 500) {
                $errors['access_instructions'][] = 'Use 500 characters or fewer.';
            }
            if ($errors !== []) {
                $code = isset($errors['alternate_drop_off_location_id']) ? 'ALTERNATE_DROP_OFF_REQUIRED' : 'VALIDATION_FAILED';

                throw new AuthenticationException($code, 'Review the delivery destination.', 422, $errors);
            }
            DB::table('carts')->where('id', $cart->id)->update([
                'intended_location_id' => $intended, 'heavy_vehicle_restriction' => $answer, 'alternate_drop_off_location_id' => $alternate,
                'access_instructions_encrypted' => $instructions === '' ? null : Crypt::encryptString($instructions),
            ]);
            $this->touch($cart);
        });

        return $this->view($request);
    }

    public function cart(string $buyerId, bool $lock = false): object
    {
        DB::table('carts')->insertOrIgnore(['id' => (string) Str::uuid7(), 'buyer_profile_id' => $buyerId, 'state' => 'ACTIVE', 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);
        $query = DB::table('carts')->where('buyer_profile_id', $buyerId)->where('state', 'ACTIVE');

        return ($lock ? $query->lockForUpdate() : $query)->first();
    }

    /**
     * Every cart line with its snapshot and current public state. A line whose offer stopped being eligible
     * keeps its descriptive data and is reported unavailable; it is never removed automatically.
     *
     * @return list<array<string, mixed>>
     */
    public function lines(string $cartId): array
    {
        $items = DB::table('cart_items as c')->join('listing_variants as v', 'v.id', '=', 'c.listing_variant_id')->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')
            ->join('units as u', 'u.id', '=', 'v.unit_id')->where('c.cart_id', $cartId)->orderBy('c.created_at')->orderBy('c.id')
            ->get(['c.*', 'v.label as variant_label', 'v.weight_kg', 'v.length_cm', 'v.width_cm', 'v.height_cm', 'l.id as listing_id', 'l.display_name', 'l.vendor_organization_id', 'l.publication_version as current_publication_version',
                'u.code as unit_code', 'u.name as unit_name', 'u.precision as unit_precision']);
        $variantIds = $items->pluck('listing_variant_id')->map(static fn (mixed $id): string => (string) $id)->all();
        $offers = $variantIds === [] ? collect() : $this->offerQuery($this->offers->anywhere())->whereIn('v.id', $variantIds)->get()->keyBy('variant_id');
        $tiers = $this->facts->volumeTiers($variantIds);
        $images = $this->facts->images($items->pluck('listing_id')->unique()->map(static fn (mixed $id): string => (string) $id)->values()->all());
        $lines = [];
        foreach ($items as $item) {
            $offer = $offers->get($item->listing_variant_id);
            $quantity = StockAvailability::quantity($item->quantity);
            $issues = [];
            $current = null;
            if ($offer === null) {
                $issues[] = ['code' => 'LISTING_UNAVAILABLE', 'severity' => self::BLOCKING, 'message' => 'No longer available to order. Remove it or save it for later.'];
            } else {
                $label = StockAvailability::label(StockAvailability::quantity($offer->available), $offer->reorder_level === null ? null : StockAvailability::quantity($offer->reorder_level));
                $tier = VolumePricing::applicableTier($tiers[(string) $item->listing_variant_id] ?? [], $quantity);
                $current = ['price_version_id' => (string) $offer->price_version_id, 'unit_price_centavos' => (int) $offer->amount_centavos, 'tax_category' => (string) $offer->tax_category,
                    'applied_unit_price_centavos' => $tier['amount_centavos'] ?? (int) $offer->amount_centavos, 'applied_price_version_id' => $tier['price_version_id'] ?? (string) $offer->price_version_id,
                    'volume_tier_applied' => $tier !== null, 'stock_label' => $label, 'vacation_mode' => (bool) $offer->vacation_mode];
                if ((string) $offer->price_version_id !== (string) $item->listing_price_version_id) {
                    $issues[] = ['code' => 'PRICE_CHANGED', 'severity' => self::ACTION_REQUIRED, 'message' => 'The price changed since you added this item. Review and accept the current price.'];
                }
                if (bccomp($quantity, StockAvailability::quantity($offer->available), 4) > 0) {
                    $issues[] = ['code' => 'QUANTITY_UNAVAILABLE', 'severity' => self::ACTION_REQUIRED, 'message' => 'The store cannot currently confirm this quantity. Lower the quantity.'];
                }
                if ($item->stock_label !== null && $item->stock_label !== $label) {
                    $issues[] = ['code' => 'AVAILABILITY_CHANGED', 'severity' => self::INFO, 'message' => $label === StockAvailability::LIMITED_STOCK ? 'Now Limited Stock.' : 'Now In Stock.'];
                }
                if ($item->listing_publication_version !== null && (int) $item->listing_publication_version !== (int) $item->current_publication_version) {
                    $issues[] = ['code' => 'LISTING_UPDATED', 'severity' => self::INFO, 'message' => 'The Vendor updated this listing. Review the details before checkout.'];
                }
            }
            $lines[] = [
                'id' => (string) $item->id, 'lock_version' => (int) $item->lock_version, 'listing_id' => (string) $item->listing_id, 'variant_id' => (string) $item->listing_variant_id,
                'vendor_id' => (string) $item->vendor_organization_id, 'display_name' => (string) $item->display_name, 'variant_label' => $item->variant_label,
                'image' => $images[(string) $item->listing_id][0] ?? null,
                'unit_code' => (string) $item->unit_code, 'unit_name' => (string) $item->unit_name, 'quantity' => $quantity, 'quantity_step' => self::quantityStep((int) $item->unit_precision),
                'saved_for_later' => $item->saved_for_later_at !== null,
                'snapshot' => ['price_version_id' => $item->listing_price_version_id === null ? null : (string) $item->listing_price_version_id, 'unit_price_centavos' => $item->unit_price_centavos === null ? null : (int) $item->unit_price_centavos,
                    'stock_label' => $item->stock_label, 'publication_version' => $item->listing_publication_version === null ? null : (int) $item->listing_publication_version,
                    'added_at' => Carbon::parse((string) $item->created_at)->toIso8601String()],
                'current' => $current,
                'line_total_centavos' => $current === null ? null : FinancialSnapshotService::lineAmountCentavos($quantity, $current['applied_unit_price_centavos']),
                'issues' => $issues,
                'status' => $this->worst($issues),
                'load' => ['weight_kg' => $item->weight_kg === null ? null : (string) $item->weight_kg, 'length_cm' => $item->length_cm === null ? null : (string) $item->length_cm,
                    'width_cm' => $item->width_cm === null ? null : (string) $item->width_cm, 'height_cm' => $item->height_cm === null ? null : (string) $item->height_cm],
            ];
        }

        return $lines;
    }

    /** @return list<string> DELIVERY and/or PICKUP */
    public static function fulfillmentOptions(string $storeMethod): array
    {
        return match ($storeMethod) {
            'BOTH' => ['DELIVERY', 'PICKUP'],
            'VENDOR_DELIVERY' => ['DELIVERY'],
            'SELF_PICKUP' => ['PICKUP'],
            default => [],
        };
    }

    /**
     * @param  list<array{severity: string}>  $issues
     */
    public function worst(array $issues): string
    {
        $severities = array_column($issues, 'severity');

        return in_array(self::BLOCKING, $severities, true) ? 'BLOCKED' : (in_array(self::ACTION_REQUIRED, $severities, true) ? 'ACTION_REQUIRED' : 'READY');
    }

    /** @return array<string, mixed> */
    public function destination(object $cart): array
    {
        $ids = [];
        foreach ([$cart->intended_location_id, $cart->alternate_drop_off_location_id] as $id) {
            if ($id !== null) {
                $ids[] = (string) $id;
            }
        }
        $locations = $ids === [] ? collect() : DB::table('buyer_locations as bl')->join('addresses as a', 'a.id', '=', 'bl.address_id')->whereIn('bl.id', $ids)
            ->where('bl.buyer_profile_id', $cart->buyer_profile_id)->get(['bl.id', 'bl.label', 'bl.location_kind', 'bl.archived_at', 'a.id as address_id', 'a.formatted_address', 'a.latitude', 'a.longitude'])->keyBy('id');
        $describe = static function (?string $id) use ($locations): ?array {
            $location = $id === null ? null : $locations->get($id);
            if ($location === null) {
                return null;
            }

            return ['location_id' => (string) $location->id, 'label' => $location->label, 'kind' => (string) $location->location_kind, 'formatted_address' => $location->formatted_address,
                'status' => $location->archived_at === null ? 'ACTIVE' : 'UNAVAILABLE'];
        };
        $restriction = (string) $cart->heavy_vehicle_restriction;
        $instructions = $cart->access_instructions_encrypted === null ? null : Crypt::decryptString((string) $cart->access_instructions_encrypted);

        return [
            'intended' => $describe($cart->intended_location_id),
            'heavy_vehicle_restriction' => $restriction,
            'alternate_drop_off' => $describe($cart->alternate_drop_off_location_id),
            'vehicle_endpoint' => $cart->intended_location_id === null ? null : ($restriction === 'YES' ? 'ALTERNATE_DROP_OFF' : 'INTENDED_LOCATION'),
            'access_instructions' => $instructions,
            'labels' => ['intended' => 'Intended destination / Project site', 'vehicle_endpoint' => 'Actual vehicle drop-off'],
            '_points' => [
                'intended' => ($row = $locations->get((string) $cart->intended_location_id)) === null ? null : ['latitude' => (float) $row->latitude, 'longitude' => (float) $row->longitude, 'address_id' => (string) $row->address_id, 'active' => $row->archived_at === null],
                'alternate' => ($alt = $locations->get((string) $cart->alternate_drop_off_location_id)) === null ? null : ['latitude' => (float) $alt->latitude, 'longitude' => (float) $alt->longitude, 'address_id' => (string) $alt->address_id, 'active' => $alt->archived_at === null],
            ],
        ];
    }

    /** @return array<string, mixed> */
    private function present(object $cart): array
    {
        // The load measurements feed the delivery advisory only; the cart view does not repeat them.
        $lines = array_map(static fn (array $line): array => array_diff_key($line, ['load' => true]), $this->lines((string) $cart->id));
        $active = array_values(array_filter($lines, static fn (array $line): bool => ! $line['saved_for_later']));
        $groups = DB::table('cart_vendor_groups')->where('cart_id', $cart->id)->get()->keyBy('vendor_organization_id');
        $vendorIds = array_values(array_unique(array_map(static fn (array $line): string => $line['vendor_id'], $active)));
        $stores = $vendorIds === [] ? collect() : DB::table('store_profiles')->whereIn('vendor_organization_id', $vendorIds)->get(['vendor_organization_id', 'public_store_name', 'fulfillment_method', 'vacation_mode'])->keyBy('vendor_organization_id');
        $destination = $this->destination($cart);
        unset($destination['_points']);
        $presented = [];
        foreach ($vendorIds as $vendorId) {
            $store = $stores->get($vendorId);
            $options = self::fulfillmentOptions((string) ($store->fulfillment_method ?? ''));
            $chosen = $groups->get($vendorId)?->fulfillment_method;
            $groupLines = array_values(array_filter($active, static fn (array $line): bool => $line['vendor_id'] === $vendorId));
            $presented[] = [
                'vendor' => ['id' => $vendorId, 'name' => (string) ($store->public_store_name ?? 'Store unavailable'), 'vacation_mode' => (bool) ($store->vacation_mode ?? false)],
                'fulfillment_method' => $chosen ?? (count($options) === 1 ? $options[0] : null),
                'fulfillment_options' => $options,
                'lines' => $groupLines,
                'materials_subtotal_centavos' => array_sum(array_map(static fn (array $line): int => (int) ($line['line_total_centavos'] ?? 0), array_filter($groupLines, static fn (array $line): bool => $line['current'] !== null))),
                'status' => $this->worst(array_merge(...array_map(static fn (array $line): array => $line['issues'], $groupLines))),
            ];
        }

        return [
            'id' => (string) $cart->id,
            'lock_version' => (int) $cart->lock_version,
            'current_as_of' => now()->toIso8601String(),
            'destination' => $destination,
            'groups' => $presented,
            'saved_for_later' => array_values(array_filter($lines, static fn (array $line): bool => $line['saved_for_later'])),
            'summary' => [
                'line_count' => count($active), 'vendor_count' => count($presented),
                'materials_subtotal_centavos' => array_sum(array_column($presented, 'materials_subtotal_centavos')),
                'notice' => 'Checkout creates a separate order request for each Vendor. Nothing is reserved until each Vendor confirms, and totals stay advisory until then.',
                'reserves_stock' => false,
            ],
        ];
    }

    private function offerQuery(Builder $offers): Builder
    {
        return $offers->join('units as u', 'u.id', '=', 'v.unit_id')
            ->select(['v.id as variant_id', 'l.id as listing_id', 'o.id as organization_id', 'l.publication_version', 'pv.id as price_version_id', 'pv.amount_centavos', 'pv.tax_category',
                'i.reorder_level', 'p.fulfillment_method', 'p.vacation_mode', 'u.precision as unit_precision'])
            ->selectRaw('i.quantity_on_hand - i.hard_reserved_quantity AS available');
    }

    /** @return array<string, mixed> */
    private function snapshot(object $offer): array
    {
        return [
            'listing_price_version_id' => (string) $offer->price_version_id, 'unit_price_centavos' => (int) $offer->amount_centavos, 'tax_category' => (string) $offer->tax_category,
            'listing_publication_version' => (int) $offer->publication_version,
            'stock_label' => StockAvailability::label(StockAvailability::quantity($offer->available), $offer->reorder_level === null ? null : StockAvailability::quantity($offer->reorder_level)),
        ];
    }

    private function quantity(mixed $value, int $unitPrecision): string
    {
        $text = is_int($value) ? (string) $value : (is_string($value) ? trim($value) : '');
        if (preg_match(self::QUANTITY_PATTERN, $text) !== 1 || bccomp($text, '0', 4) <= 0 || bccomp($text, '1000000', 4) > 0) {
            throw new AuthenticationException('QUANTITY_INVALID', 'Enter a quantity greater than zero.', 422, ['quantity' => ['Enter a quantity greater than zero and up to 1,000,000.']]);
        }
        $normalized = StockAvailability::quantity($text);
        if (bccomp($normalized, bcadd($normalized, '0', max(0, min(4, $unitPrecision))), 4) !== 0) {
            throw new AuthenticationException('QUANTITY_INVALID', $unitPrecision <= 0 ? 'This item is sold in whole units.' : 'Use at most '.$unitPrecision.' decimal places.', 422,
                ['quantity' => [$unitPrecision <= 0 ? 'Enter a whole number.' : 'Use at most '.$unitPrecision.' decimal places.']]);
        }

        return $normalized;
    }

    /** Never reveals the exact quantity; a request above available_to_sell is simply not confirmable now. */
    private function assertAvailable(string $quantity, string $available): void
    {
        if (bccomp($quantity, StockAvailability::quantity($available), 4) > 0) {
            throw new AuthenticationException('QUANTITY_UNAVAILABLE', 'The store cannot currently confirm this quantity. Try a smaller quantity.', 422, ['quantity' => ['Lower the quantity.']]);
        }
    }

    private function ensureGroup(string $cartId, string $organizationId, string $storeMethod, mixed $requested): void
    {
        $options = self::fulfillmentOptions($storeMethod);
        $group = DB::table('cart_vendor_groups')->where('cart_id', $cartId)->where('vendor_organization_id', $organizationId)->first();
        $method = is_string($requested) && in_array($requested, $options, true) ? $requested : null;
        if ($group === null) {
            DB::table('cart_vendor_groups')->insert(['id' => (string) Str::uuid7(), 'cart_id' => $cartId, 'vendor_organization_id' => $organizationId,
                'fulfillment_method' => $method ?? (count($options) === 1 ? $options[0] : null), 'created_at' => now(), 'updated_at' => now()]);
        } elseif ($method !== null && $group->fulfillment_method === null) {
            DB::table('cart_vendor_groups')->where('id', $group->id)->update(['fulfillment_method' => $method, 'updated_at' => now()]);
        }
    }

    private function lockedCart(string $buyerId, int $expectedVersion): object
    {
        $cart = $this->cart($buyerId, true);
        if ((int) $cart->lock_version !== $expectedVersion) {
            throw new AuthenticationException('CART_VERSION_CONFLICT', 'Your cart changed on another screen or device. Review the latest cart and try again.', 409, ['current_lock_version' => (int) $cart->lock_version]);
        }

        return $cart;
    }

    private function touch(object $cart): void
    {
        DB::table('carts')->where('id', $cart->id)->update(['lock_version' => (int) $cart->lock_version + 1, 'updated_at' => now()]);
    }

    private function ownsActiveLocation(string $buyerId, string $locationId): bool
    {
        return Str::isUuid($locationId) && DB::table('buyer_locations as bl')->join('addresses as a', 'a.id', '=', 'bl.address_id')
            ->where('bl.id', $locationId)->where('bl.buyer_profile_id', $buyerId)->whereNull('bl.archived_at')->whereNotNull('a.location')->exists();
    }
}
