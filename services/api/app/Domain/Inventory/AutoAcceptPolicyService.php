<?php

declare(strict_types=1);

namespace App\Domain\Inventory;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Catalog\ListingTaxPolicy;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Per-variant Item-Based auto-accept configuration. Disabled by default. Owner and Store Manager enable,
 * pause, resume and set the independent allotment, unit and amount safeguards; Inventory Staff may only set
 * the allotment; Store Staff and Customer Service view outcomes. Every change appends an immutable policy
 * version. An allotment reaching zero pauses immediately and notifies permitted users; replenishing stock or
 * restoring allotment never resumes it — only a deliberate, confirmed Owner/Manager resume does.
 */
final class AutoAcceptPolicyService
{
    public const STATUS_DISABLED = 'DISABLED';

    public const STATUS_ACTIVE = 'ACTIVE';

    public const STATUS_PAUSED = 'PAUSED';

    private const NOTIFY_ROLES = ['OWNER', 'STORE_MANAGER', 'INVENTORY'];

    private const MAX_CENTAVOS = 100000000000;

    public function __construct(
        private readonly InventoryAccess $access,
        private readonly InventoryLocks $locks,
        private readonly CatalogAccess $catalog,
        private readonly ListingTaxPolicy $tax,
        private readonly VendorInventoryNotifier $notifier,
        private readonly AuditRecorder $audit,
    ) {}

    /** @return array<string, mixed> */
    public static function present(?object $policy): array
    {
        if ($policy === null) {
            return ['status' => self::STATUS_DISABLED, 'enabled' => false, 'paused' => false, 'pause_reason' => null, 'paused_at' => null, 'allotment_quantity' => '0', 'remaining_allotment_quantity' => '0', 'max_unit_count' => null, 'max_order_amount_centavos' => null, 'current_version' => 0, 'lock_version' => 0, 'updated_at' => null];
        }
        $status = ! $policy->enabled ? self::STATUS_DISABLED : ($policy->paused ? self::STATUS_PAUSED : self::STATUS_ACTIVE);

        return [
            'status' => $status, 'enabled' => (bool) $policy->enabled, 'paused' => (bool) $policy->paused && (bool) $policy->enabled, 'pause_reason' => $policy->pause_reason, 'paused_at' => $policy->paused_at,
            'allotment_quantity' => self::integer($policy->allotment_quantity), 'remaining_allotment_quantity' => self::integer($policy->remaining_allotment_quantity),
            'max_unit_count' => $policy->max_unit_count === null ? null : StockAvailability::quantity($policy->max_unit_count),
            'max_order_amount_centavos' => $policy->max_order_amount_centavos === null ? null : (int) $policy->max_order_amount_centavos,
            'current_version' => (int) $policy->current_version, 'lock_version' => (int) $policy->lock_version, 'updated_at' => $policy->updated_at,
        ];
    }

    /** @return array<string, mixed> */
    public function show(Request $request, string $variantId): array
    {
        $organizationId = $this->access->organizationFor($request, [InventoryAccess::AUTO_ACCEPT_CONFIGURE, InventoryAccess::AUTO_ACCEPT_ALLOTMENT, InventoryAccess::AUTO_ACCEPT_VIEW]);

        return $this->detail($request, $organizationId, $variantId);
    }

    /**
     * @param  array{lock_version: int, enabled: bool, allotment_quantity: int|string, max_unit_count?: string|int|null, max_order_amount_centavos?: int|null}  $input
     * @return array<string, mixed>
     */
    public function configure(Request $request, string $variantId, array $input): array
    {
        $organizationId = $this->access->organizationFor($request, [InventoryAccess::AUTO_ACCEPT_CONFIGURE]);
        DB::transaction(function () use ($request, $organizationId, $variantId, $input): void {
            ['listing' => $listing, 'variant' => $variant] = $this->locks->variantForUpdate($organizationId, $variantId);
            $policy = $this->lockPolicy($variantId, (int) $input['lock_version']);
            $allotment = $this->allotment($input['allotment_quantity']);
            $unitCap = $this->unitCap($input['max_unit_count'] ?? null);
            $amountCap = $this->amountCap($input['max_order_amount_centavos'] ?? null);
            $enabled = (bool) $input['enabled'];
            if ($enabled) {
                $this->assertEligible($organizationId, $listing, $variant);
                if (bccomp($allotment, '0', 0) <= 0 && ! ($policy !== null && $policy->enabled)) {
                    throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['allotment_quantity' => ['Enter a whole-number allotment above zero to enable auto-accept.']]);
                }
            }
            $before = self::present($policy);
            $paused = $enabled && $policy !== null && $policy->enabled && $policy->paused;
            $reason = $paused ? $policy->pause_reason : null;
            $kind = $enabled ? 'CONFIGURED' : 'DISABLED';
            if ($enabled && ! $paused && bccomp($allotment, '0', 0) === 0) {
                // An active policy set to a zero allotment pauses exactly as an exhausted one does.
                [$paused, $reason, $kind] = [true, 'ALLOTMENT_EXHAUSTED', 'EXHAUSTED'];
            }
            $values = ['enabled' => $enabled, 'paused' => $paused, 'pause_reason' => $reason, 'paused_at' => $paused ? ($policy->paused_at ?? now()) : null, 'allotment_quantity' => $allotment, 'remaining_allotment_quantity' => $allotment, 'max_unit_count' => $unitCap, 'max_order_amount_centavos' => $amountCap];
            $saved = $this->write($request, $variantId, $policy, $values, $kind);
            $this->audit->account($request, 'AUTO_ACCEPT_POLICY_CONFIGURED', 'LISTING_VARIANT', $variantId, before: $before, after: self::present($saved));
            if ($kind === 'EXHAUSTED' && $before['status'] !== self::STATUS_PAUSED) {
                $this->notifyPaused($organizationId, (string) $listing->display_name, $variantId);
            }
        });

        return $this->detail($request, $organizationId, $variantId);
    }

    /**
     * Inventory Staff grant: sets the remaining allotment only. It never enables or resumes a policy.
     *
     * @param  array{lock_version: int, allotment_quantity: int|string}  $input
     * @return array<string, mixed>
     */
    public function updateAllotment(Request $request, string $variantId, array $input): array
    {
        $organizationId = $this->access->organizationFor($request, [InventoryAccess::AUTO_ACCEPT_CONFIGURE, InventoryAccess::AUTO_ACCEPT_ALLOTMENT]);
        DB::transaction(function () use ($request, $organizationId, $variantId, $input): void {
            ['listing' => $listing] = $this->locks->variantForUpdate($organizationId, $variantId);
            $policy = $this->lockPolicy($variantId, (int) $input['lock_version']);
            $allotment = $this->allotment($input['allotment_quantity']);
            $before = self::present($policy);
            $exhausts = $policy !== null && $policy->enabled && ! $policy->paused && bccomp($allotment, '0', 0) === 0;
            $values = ['allotment_quantity' => $allotment, 'remaining_allotment_quantity' => $allotment];
            if ($exhausts) {
                $values += ['paused' => true, 'pause_reason' => 'ALLOTMENT_EXHAUSTED', 'paused_at' => now()];
            }
            $saved = $this->write($request, $variantId, $policy, $values, $exhausts ? 'EXHAUSTED' : 'ALLOTMENT_UPDATED');
            $this->audit->account($request, 'AUTO_ACCEPT_ALLOTMENT_UPDATED', 'LISTING_VARIANT', $variantId, before: $before, after: self::present($saved));
            if ($exhausts) {
                $this->notifyPaused($organizationId, (string) $listing->display_name, $variantId);
            }
        });

        return $this->detail($request, $organizationId, $variantId);
    }

    /** @return array<string, mixed> */
    public function pause(Request $request, string $variantId, int $lockVersion): array
    {
        $organizationId = $this->access->organizationFor($request, [InventoryAccess::AUTO_ACCEPT_CONFIGURE]);
        DB::transaction(function () use ($request, $organizationId, $variantId, $lockVersion): void {
            $this->locks->variantForUpdate($organizationId, $variantId);
            $policy = $this->lockPolicy($variantId, $lockVersion);
            if ($policy === null || ! $policy->enabled || $policy->paused) {
                throw new AuthenticationException('AUTO_ACCEPT_NOT_ACTIVE', 'Only an active auto-accept policy can be paused.', 409);
            }
            $before = self::present($policy);
            $saved = $this->write($request, $variantId, $policy, ['paused' => true, 'pause_reason' => 'MANUAL', 'paused_at' => now()], 'PAUSED');
            $this->audit->account($request, 'AUTO_ACCEPT_POLICY_PAUSED', 'LISTING_VARIANT', $variantId, before: $before, after: self::present($saved));
        });

        return $this->detail($request, $organizationId, $variantId);
    }

    /**
     * Deliberate resume. The caller must name the exact remaining allotment it is restoring, so a policy
     * whose allotment changed after the confirmation dialog opened is not silently resumed.
     *
     * @return array<string, mixed>
     */
    public function resume(Request $request, string $variantId, int $lockVersion, string $confirmedAllotment): array
    {
        $organizationId = $this->access->organizationFor($request, [InventoryAccess::AUTO_ACCEPT_CONFIGURE]);
        $key = $this->catalog->requireIdempotencyKey($request);
        DB::transaction(function () use ($request, $organizationId, $variantId, $lockVersion, $confirmedAllotment, $key): void {
            ['listing' => $listing, 'variant' => $variant] = $this->locks->variantForUpdate($organizationId, $variantId);
            if ($this->catalog->replayed($request, 'AUTO_ACCEPT_RESUME', $key, $variantId)) {
                return;
            }
            $policy = $this->lockPolicy($variantId, $lockVersion);
            if ($policy === null || ! $policy->enabled || ! $policy->paused) {
                throw new AuthenticationException('AUTO_ACCEPT_NOT_PAUSED', 'Only a paused auto-accept policy can be resumed.', 409);
            }
            $remaining = self::integer($policy->remaining_allotment_quantity);
            if (bccomp($remaining, '0', 0) <= 0) {
                throw new AuthenticationException('AUTO_ACCEPT_ALLOTMENT_REQUIRED', 'Set a new allotment above zero before resuming auto-accept.', 422, ['allotment_quantity' => ['The remaining allotment is 0.']]);
            }
            if (preg_match('/^\d{1,14}$/', $confirmedAllotment) !== 1 || bccomp($confirmedAllotment, $remaining, 0) !== 0) {
                throw new AuthenticationException('AUTO_ACCEPT_ALLOTMENT_CHANGED', 'The remaining allotment changed. Review it and confirm again.', 409, ['remaining_allotment_quantity' => $remaining]);
            }
            $this->assertEligible($organizationId, $listing, $variant);
            $before = self::present($policy);
            $saved = $this->write($request, $variantId, $policy, ['paused' => false, 'pause_reason' => null, 'paused_at' => null], 'RESUMED');
            $this->catalog->claim($request, 'AUTO_ACCEPT_RESUME', $key, $variantId, 200);
            $this->audit->account($request, 'AUTO_ACCEPT_POLICY_RESUMED', 'LISTING_VARIANT', $variantId, before: $before, after: self::present($saved) + ['restored_allotment' => $remaining]);
        });

        return $this->detail($request, $organizationId, $variantId);
    }

    /**
     * Consumes allotment inside the later order-acceptance transaction, after InventoryLocks::lockForAcceptance
     * locked the policy row and AutoAcceptGate admitted the whole order. Pauses and notifies at zero.
     * Returns the policy version id the accepted order must record.
     */
    public function consume(object $lockedPolicy, string $quantity, string $organizationId, string $listingName): string
    {
        if (DB::transactionLevel() < 1) {
            throw new \LogicException('Auto-accept allotment is consumed only inside the acceptance transaction.');
        }
        $quantity = StockAvailability::quantity($quantity);
        $remaining = bcsub(self::integer($lockedPolicy->remaining_allotment_quantity), $quantity, 4);
        if (! $lockedPolicy->enabled || $lockedPolicy->paused || bccomp($remaining, '0', 4) < 0 || bccomp($quantity, bcadd($quantity, '0', 0), 4) !== 0) {
            throw new AuthenticationException('AUTO_ACCEPT_NOT_ELIGIBLE', 'The auto-accept policy no longer admits this order.', 409);
        }
        $exhausted = bccomp($remaining, '0', 4) === 0;
        $values = ['remaining_allotment_quantity' => bcadd($remaining, '0', 0)] + ($exhausted ? ['paused' => true, 'pause_reason' => 'ALLOTMENT_EXHAUSTED', 'paused_at' => now()] : []);
        $versionId = $this->append($lockedPolicy, $values, $exhausted ? 'EXHAUSTED' : 'ALLOTMENT_UPDATED', null);
        if ($exhausted) {
            $this->notifyPaused($organizationId, $listingName, (string) $lockedPolicy->listing_variant_id);
        }

        return $versionId;
    }

    /** Returns allotment released by payment expiry or cancellation. It never clears a pause. */
    public function restore(object $lockedPolicy, string $quantity): void
    {
        if (DB::transactionLevel() < 1 || bccomp(StockAvailability::quantity($quantity), bcadd($quantity, '0', 0), 4) !== 0) {
            throw new \LogicException('Allotment is restored in whole units inside the releasing transaction.');
        }
        $this->append($lockedPolicy, ['remaining_allotment_quantity' => bcadd(self::integer($lockedPolicy->remaining_allotment_quantity), bcadd($quantity, '0', 0), 0)], 'ALLOTMENT_UPDATED', null);
    }

    /** @return array<string, mixed> */
    private function detail(Request $request, string $organizationId, string $variantId): array
    {
        $row = DB::table('listing_variants as v')->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')->join('units as u', 'u.id', '=', 'v.unit_id')
            ->leftJoin('inventory_items as i', 'i.listing_variant_id', '=', 'v.id')->leftJoin('auto_accept_policies as a', 'a.listing_variant_id', '=', 'v.id')
            ->where('v.id', $variantId)->where('l.vendor_organization_id', $organizationId)->whereNull('l.removed_at')
            ->first(['v.id', 'v.sku', 'v.label', 'u.code as unit_code', 'l.id as listing_id', 'l.display_name', 'l.status as listing_status', 'i.quantity_on_hand', 'i.hard_reserved_quantity', DB::raw("(SELECT COALESCE(SUM(h.quantity), 0) FROM inventory_holds h WHERE h.inventory_item_id = i.id AND h.hold_type = 'SOFT' AND h.state = 'ACTIVE' AND (h.expires_at IS NULL OR h.expires_at > CURRENT_TIMESTAMP)) as soft_held_quantity"), 'a.id as policy_id']);
        if ($row === null) {
            throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The product variant is unavailable.', 404);
        }
        $policy = $row->policy_id === null ? null : DB::table('auto_accept_policies')->where('id', $row->policy_id)->first();
        $permissions = $this->access->scope($request)['permissions'];
        $available = $row->quantity_on_hand === null ? null : StockAvailability::availableToSell((string) $row->quantity_on_hand, (string) $row->hard_reserved_quantity);
        $editor = $policy?->updated_by_user_id === null ? null : DB::table('user_profiles')->where('user_id', $policy->updated_by_user_id)->value('full_name');

        return [
            'listing_variant_id' => $row->id, 'listing_id' => $row->listing_id, 'listing_name' => $row->display_name, 'listing_status' => $row->listing_status,
            'variant_label' => $row->label, 'sku' => $row->sku, 'unit_code' => $row->unit_code,
            'stock' => $row->quantity_on_hand === null ? null : ['quantity_on_hand' => StockAvailability::quantity($row->quantity_on_hand), 'hard_reserved_quantity' => StockAvailability::quantity($row->hard_reserved_quantity), 'soft_held_quantity' => StockAvailability::quantity($row->soft_held_quantity), 'available_to_sell' => $available],
            'policy' => self::present($policy) + ['last_editor' => $editor],
            'versions' => $policy === null ? [] : DB::table('auto_accept_policy_versions as pv')->leftJoin('user_profiles as up', 'up.user_id', '=', 'pv.created_by_user_id')
                ->where('pv.auto_accept_policy_id', $policy->id)->orderByDesc('pv.version')->limit(20)
                ->get(['pv.version', 'pv.change_kind', 'pv.enabled', 'pv.paused', 'pv.pause_reason', 'pv.allotment_quantity', 'pv.remaining_allotment_quantity', 'pv.max_unit_count', 'pv.max_order_amount_centavos', 'pv.automated', 'pv.created_at', 'up.full_name'])
                ->map(static fn (object $version): array => [
                    'version' => (int) $version->version, 'change_kind' => $version->change_kind, 'enabled' => (bool) $version->enabled, 'paused' => (bool) $version->paused, 'pause_reason' => $version->pause_reason,
                    'allotment_quantity' => self::integer($version->allotment_quantity), 'remaining_allotment_quantity' => self::integer($version->remaining_allotment_quantity),
                    'max_unit_count' => $version->max_unit_count === null ? null : StockAvailability::quantity($version->max_unit_count), 'max_order_amount_centavos' => $version->max_order_amount_centavos === null ? null : (int) $version->max_order_amount_centavos,
                    'created_at' => $version->created_at, 'automated' => (bool) $version->automated, 'actor' => $version->automated ? 'Automated policy' : ($version->full_name ?? 'Vendor user'),
                ])->all(),
            'scope' => ['item_based_only' => true, 'nrpc_excluded' => true, 'project_based_excluded' => true, 'rule_version' => AutoAcceptGate::RULE_VERSION],
            'permissions' => [
                'can_configure' => in_array(InventoryAccess::AUTO_ACCEPT_CONFIGURE, $permissions, true),
                'can_update_allotment' => in_array(InventoryAccess::AUTO_ACCEPT_CONFIGURE, $permissions, true) || in_array(InventoryAccess::AUTO_ACCEPT_ALLOTMENT, $permissions, true),
            ],
        ];
    }

    private function lockPolicy(string $variantId, int $lockVersion): ?object
    {
        $policy = DB::table('auto_accept_policies')->where('listing_variant_id', $variantId)->lockForUpdate()->first();
        if (($policy === null ? 0 : (int) $policy->lock_version) !== $lockVersion) {
            throw new AuthenticationException('STALE_VERSION', 'This auto-accept policy changed since you opened it. Review the current values and try again.', 409, ['current' => self::present($policy)]);
        }

        return $policy;
    }

    /** @param array<string, mixed> $values */
    private function write(Request $request, string $variantId, ?object $policy, array $values, string $kind): object
    {
        $actorId = (int) $request->user()->getKey();
        if ($policy === null) {
            $id = (string) Str::uuid7();
            DB::table('auto_accept_policies')->insert(['id' => $id, 'listing_variant_id' => $variantId, 'enabled' => false, 'paused' => false, 'current_version' => 0, 'lock_version' => 0, 'created_at' => now(), 'updated_at' => now()]);
            $policy = DB::table('auto_accept_policies')->where('id', $id)->lockForUpdate()->first();
        }
        $this->append($policy, $values, $kind, $actorId);

        return DB::table('auto_accept_policies')->where('id', $policy->id)->first();
    }

    /** @param array<string, mixed> $values */
    private function append(object $policy, array $values, string $kind, ?int $actorId): string
    {
        $version = (int) $policy->current_version + 1;
        $next = array_merge((array) $policy, $values);
        DB::table('auto_accept_policies')->where('id', $policy->id)->update($values + ['current_version' => $version, 'lock_version' => (int) $policy->lock_version + 1, 'updated_by_user_id' => $actorId, 'updated_at' => now()]);
        $versionId = (string) Str::uuid7();
        DB::table('auto_accept_policy_versions')->insert([
            'id' => $versionId, 'auto_accept_policy_id' => $policy->id, 'version' => $version, 'change_kind' => $kind,
            'enabled' => (bool) $next['enabled'], 'paused' => (bool) $next['paused'] && (bool) $next['enabled'], 'pause_reason' => $next['pause_reason'],
            'allotment_quantity' => $next['allotment_quantity'], 'remaining_allotment_quantity' => $next['remaining_allotment_quantity'],
            'max_unit_count' => $next['max_unit_count'], 'max_order_amount_centavos' => $next['max_order_amount_centavos'], 'automated' => $actorId === null,
            // Automated consumption has no human editor; the user who last configured the policy stays accountable for it.
            'created_by_user_id' => $actorId ?? $policy->updated_by_user_id ?? DB::table('auto_accept_policy_versions')->where('auto_accept_policy_id', $policy->id)->orderBy('version')->value('created_by_user_id'),
            'created_at' => now(), 'updated_at' => now(),
        ]);

        return $versionId;
    }

    /** Enabling or resuming requires an ACTIVE listing, an active variant and a validated price-tax classification. */
    private function assertEligible(string $organizationId, object $listing, object $variant): void
    {
        $reasons = [];
        if ($listing->status !== 'ACTIVE') {
            $reasons['listing'] = ['Auto-accept is available only for an Active listing.'];
        }
        if (! $variant->active) {
            $reasons['variant'] = ['This variant is inactive.'];
        }
        $price = DB::table('listing_price_versions')->where('listing_variant_id', $variant->id)->where('price_kind', 'ORDINARY')->whereNull('retired_at')->first(['tax_category']);
        if ($price === null || ! in_array($price->tax_category, $this->tax->allowedCategories($organizationId), true)) {
            $reasons['price'] = ['A current ordinary price with a permitted tax classification is required.'];
        }
        if ($reasons !== []) {
            throw new AuthenticationException('AUTO_ACCEPT_NOT_ELIGIBLE', 'This variant cannot use auto-accept yet.', 422, $reasons);
        }
    }

    private function notifyPaused(string $organizationId, string $listingName, string $variantId): void
    {
        $this->notifier->notify($organizationId, self::NOTIFY_ROLES, 'AUTO_ACCEPT', 'Auto-accept paused', 'Auto-accept for “'.Str::limit($listingName, 120).'” paused because its allotment reached zero. Review stock and resume it deliberately when ready.', 'LISTING_VARIANT', $variantId);
    }

    private function allotment(mixed $value): string
    {
        $value = is_int($value) ? (string) $value : (is_string($value) ? trim($value) : '');
        if (preg_match('/^\d{1,14}$/', $value) !== 1) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['allotment_quantity' => ['Enter a whole-number allotment of zero or more.']]);
        }

        return bcadd($value, '0', 0);
    }

    private function unitCap(mixed $value): ?string
    {
        if ($value === null || $value === '') {
            return null;
        }
        $value = is_int($value) ? (string) $value : (is_string($value) ? trim($value) : '');
        if (preg_match(InventoryLedgerWriter::QUANTITY_PATTERN, $value) !== 1 || bccomp($value, '0', 4) <= 0) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['max_unit_count' => ['Enter a maximum unit count above zero, or leave it empty for no unit cap.']]);
        }

        return StockAvailability::quantity($value);
    }

    private function amountCap(mixed $value): ?int
    {
        if ($value === null) {
            return null;
        }
        if (! is_int($value) || $value <= 0 || $value > self::MAX_CENTAVOS) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['max_order_amount_centavos' => ['Enter a maximum order amount above zero, or leave it empty for no amount cap.']]);
        }

        return $value;
    }

    private static function integer(mixed $value): string
    {
        return bcadd((string) $value, '0', 0);
    }
}
