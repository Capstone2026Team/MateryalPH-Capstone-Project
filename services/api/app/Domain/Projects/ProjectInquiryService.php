<?php

declare(strict_types=1);

namespace App\Domain\Projects;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Catalog\QuantityPolicy;
use App\Domain\Enforcement\BuyerCommerceRestriction;
use App\Domain\Finance\Money;
use App\Domain\Geography\BuyerProfiles;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Messaging\ConversationService;
use App\Domain\Messaging\FulfillmentThreadService;
use App\Domain\Messaging\QuotationService;
use App\Domain\Orders\OrderActor;
use App\Domain\Orders\OrderCommercial;
use App\Domain\Orders\OrderNotifier;
use App\Domain\Orders\OrderTransitionService;
use App\Domain\Payments\PaymentMethodPolicy;
use App\Domain\Settings\PlatformSettings;
use App\Domain\Vendors\VendorDeliveryEligibility;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class ProjectInquiryService
{
    public function __construct(private readonly ProjectService $projects, private readonly ProjectEstimateService $estimates, private readonly CatalogAccess $keys) {}

    /** @param array<string, mixed> $snapshot
     * @return array<string, mixed> */
    public static function duplicate(array $snapshot): array
    {
        $lines = [];
        foreach (self::aggregateLines($snapshot['lines']) as $l) {
            if ($l['variant_id'] === null || bccomp($l['matched_quantity'], '0', 4) <= 0) {
                continue;
            }
            if (isset($lines[$l['variant_id']])) {
                $lines[$l['variant_id']]['quantity'] = bcadd($lines[$l['variant_id']]['quantity'], $l['matched_quantity'], 4);
            } else {
                $lines[$l['variant_id']] = ['variant_id' => $l['variant_id'], 'quantity' => $l['matched_quantity'], 'unit_price_centavos' => $l['unit_price_centavos'], 'description' => $l['name'], 'specifications' => $l['specifications']];
            }
        }

        return ['lines' => array_values($lines), 'fulfillment_method' => $snapshot['fulfillment_method'], 'payment_method' => $snapshot['payment_method'], 'fulfillment_date' => null, 'deadline_hours' => (int) PlatformSettings::current()->field('quotations.deadline_limits', 'default_hours')];
    }

    /** @param array<string, mixed> $input
     * @return array<string, string> Work Package line id => specification option id */
    public static function selections(array $input): array
    {
        $map = [];
        foreach ($input['selections'] ?? [] as $selection) {
            $map[(string) $selection['line_id']] = (string) $selection['option_id'];
        }

        return $map;
    }

    /** The Buyer's choices applied before any lock (delivery is re-estimated through the route provider).
     * @param array<string, mixed> $input
     * @return array<string, mixed>|null */
    private function applied(Request $request, string $id, array $input): ?array
    {
        $selections = self::selections($input);

        return $selections === [] ? null : $this->estimates->withSelections($request, $id, $input['candidate_id'], $selections, $input['fulfillment_method'] ?? null);
    }

    /** Owner request 2026-10-16: a line with several matching specifications is never ordered on a guess.
     * @param array<string, mixed> $snapshot */
    private static function assertChosen(array $snapshot): void
    {
        $open = array_values(array_filter($snapshot['lines'], static fn (array $l): bool => $l['selection_required'] ?? false));
        if ($open !== []) {
            throw new AuthenticationException('SPECIFICATION_SELECTION_REQUIRED', 'Choose a specification for '.$open[0]['name'].(count($open) > 1 ? ' and '.(count($open) - 1).' more' : '').' before continuing.', 422,
                ['line_ids' => array_column($open, 'line_id')]);
        }
    }

    /** @param array<string, mixed> $input */
    public function inquire(Request $request, string $id, array $input): string
    {
        BuyerCommerceRestriction::assertAllowed(app(BuyerProfiles::class)->idFor($request));
        $key = $this->keys->requireIdempotencyKey($request);
        $applied = $this->applied($request, $id, $input);

        return DB::transaction(function () use ($request, $id, $input, $key, $applied): string {
            $w = $this->projects->package($request, $id, true);
            if ($this->keys->replayed($request, 'PROJECT_INQUIRE', $key, $id)) {
                $body = DB::table('idempotency_records')->where('actor_user_id', $request->user()->id)->where('endpoint', 'PROJECT_INQUIRE')->where('idempotency_key', $key)->value('response_body');

                return json_decode($body ?? '{}', true)['id'] ?? $key;
            }
            ProjectService::version($w, $input['lock_version']);
            $candidate = $this->estimates->candidate($request, $id, $input['candidate_id']);
            $this->unassigned($w);
            $existing = DB::table('conversations')->where('context_type', 'PROJECT_BASED')->where('context_id', $id)->where('vendor_organization_id', $candidate['snapshot']['vendor_id'])
                ->whereRaw("locked_reference->>'version_id' = ?", [$w->current_version_id])->value('id');
            if ($existing !== null) {
                $this->keys->claim($request, 'PROJECT_INQUIRE', $key, $id, 201);
                DB::table('idempotency_records')->where('actor_user_id', $request->user()->id)->where('endpoint', 'PROJECT_INQUIRE')->where('idempotency_key', $key)->update(['response_body' => json_encode(['id' => $existing], JSON_THROW_ON_ERROR)]);

                return $existing;
            }
            // A Vendor offering both Delivery and Pickup needs the Buyer's choice; the quotation is then one concrete method.
            $resolved = ProjectEstimateService::resolve($candidate['snapshot'], $input['fulfillment_method'] ?? null);
            $s = $applied ?? $resolved;
            if (isset($input['payment_method'])) {
                $s['payment_method'] = $input['payment_method'];
                app(PaymentMethodPolicy::class)->assertAllowed((string) $s['vendor_id'], (string) $s['fulfillment_method'], (string) $s['payment_method']);
            }
            self::assertChosen($s);
            $v = DB::table('work_package_versions')->where('id', $w->current_version_id)->first();
            $content = json_decode($v->content, true);
            $duplicate = self::duplicate($s);
            $reference = ['version_id' => $v->id, 'version' => (int) $v->version, 'content_hash' => $v->content_hash, 'work_package' => $content, 'system_estimate' => $s,
                'working_duplicate' => $duplicate, 'destination' => $s['destination'], 'lines' => $content['lines']];
            app(ConversationService::class)->createProject($request, $key, $candidate['snapshot']['vendor_id'], $id, $reference);
            DB::table('quotations')->insert(['id' => (string) Str::uuid7(), 'conversation_id' => $key, 'buyer_profile_id' => DB::table('projects')->where('id', $w->project_id)->value('buyer_profile_id'),
                'vendor_organization_id' => $candidate['snapshot']['vendor_id'], 'procurement_type' => 'PROJECT_BASED', 'work_package_id' => $id, 'state' => 'DRAFT',
                'draft' => json_encode($duplicate, JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
            DB::table('work_packages')->where('id', $id)->update(['status' => 'QUOTATION_INQUIRY', 'lock_version' => $w->lock_version + 1, 'updated_at' => now()]);
            $this->projects->record($request, 'PROJECT_VENDOR_INQUIRY_CREATED', $id);
            $this->keys->claim($request, 'PROJECT_INQUIRE', $key, $id, 201);

            return $key;
        });
    }

    /** @param array<string, mixed> $input */
    public function select(Request $request, string $id, array $input): string
    {
        BuyerCommerceRestriction::assertAllowed(app(BuyerProfiles::class)->idFor($request));
        $key = $this->keys->requireIdempotencyKey($request);
        $this->projects->package($request, $id);
        if ($this->keys->replayed($request, 'PROJECT_SELECT', $key, $id)) {
            return $key;
        }
        $applied = $this->applied($request, $id, $input);
        $package = $this->projects->package($request, $id);
        $snapshot = $applied ?? ProjectEstimateService::resolve($this->estimates->candidate($request, $id, $input['candidate_id'])['snapshot'], $input['fulfillment_method'] ?? null);
        app(ProjectProcurementDraft::class)->saveAutomatic($request, $package, $input['candidate_id'], $snapshot);

        return DB::transaction(function () use ($request, $id, $input, $key, $applied): string {
            $w = $this->projects->package($request, $id, true);
            if ($this->keys->replayed($request, 'PROJECT_SELECT', $key, $id)) {
                return $key;
            }
            ProjectService::version($w, $input['lock_version']);
            $this->unassigned($w);
            $candidate = $this->estimates->candidate($request, $id, $input['candidate_id']);
            $resolved = ProjectEstimateService::resolve($candidate['snapshot'], $input['fulfillment_method'] ?? null);
            $s = $applied ?? $resolved;
            if (! isset($input['payment_method'])) {
                throw new AuthenticationException('PAYMENT_METHOD_REQUIRED', 'Choose a payment method in the selection checklist.', 422);
            }
            $s['payment_method'] = $input['payment_method'];
            self::assertChosen($s);
            if (ProjectProcurementDraft::excessiveLines($w, $s) !== []) {
                throw new AuthenticationException('PROJECT_DRAFT_QUANTITY_REVIEW', 'Review supplementary quantities in quotation checkout before sending the primary request.', 409);
            }
            // Capability updates acquire the same organization lock; accepted history is never revalidated.
            DB::table('vendor_organizations')->where('id', $s['vendor_id'])->lockForUpdate()->first();
            if ($s['fulfillment_method'] === 'DELIVERY' && ! app(VendorDeliveryEligibility::class)->available((string) $s['vendor_id'])) {
                throw new AuthenticationException('FULFILLMENT_NOT_OFFERED', 'Vendor Delivery is currently unavailable for new orders. Refresh the Work Package candidates.', 422);
            }
            $this->estimates->assertFresh($s);
            if ($s['delivery']['status'] === 'BLOCKED') {
                throw new AuthenticationException('FULFILLMENT_REVIEW_REQUIRED', 'Resolve the delivery endpoint or coverage before selection.', 422);
            }
            app(PaymentMethodPolicy::class)->assertAllowed((string) $s['vendor_id'], (string) $s['fulfillment_method'], (string) $s['payment_method']);
            $order = $this->createRequest($request, $w, $s, $input, $key, $input['candidate_id']);
            $actor = OrderActor::buyer($request);
            app(ProjectBudget::class)->guard($request, $w, $s['projected_total_centavos'] ?? $s['materials_centavos'], $input, $key);
            $this->missing($w, $s['missing_lines']);
            app(QuotationService::class)->expireForPackage($id);
            DB::table('work_packages')->where('id', $id)->update(['status' => 'VENDOR_SELECTED', 'selected_vendor_organization_id' => $s['vendor_id'], 'lock_version' => $w->lock_version + 1, 'updated_at' => now()]);
            app(OrderNotifier::class)->vendor($order, 'Project package request '.$order->reference, 'Manually confirm availability, final amount, fulfillment date and delivery within 24 hours. The Buyer note is informational and needs no response.');
            $this->projects->record($request, 'PROJECT_VENDOR_SELECTED', $id);
            $this->keys->claim($request, 'PROJECT_SELECT', $key, $id, 201);

            return $key;
        });
    }

    /** One supplier's pending Project request. Caller owns the transaction, authorization and budget guard.
     * @param array<string, mixed> $s
     * @param array<string, mixed> $input */
    public function createRequest(Request $request, object $w, array $s, array $input, string $orderId, ?string $candidateId, ?string $arrangementId = null, ?string $memberId = null): object
    {
        $actor = OrderActor::buyer($request);
        $buyer = DB::table('projects')->where('id', $w->project_id)->value('buyer_profile_id');
        DB::table('orders')->insert(['id' => $orderId, 'reference' => 'ORD-'.now('Asia/Manila')->format('Y').'-'.Str::upper(Str::random(10)), 'buyer_profile_id' => $buyer,
            'vendor_organization_id' => $s['vendor_id'], 'work_package_id' => $w->id, 'work_package_version_id' => $w->current_version_id, 'compiled_estimate_vendor_id' => $candidateId, 'project_arrangement_id' => $arrangementId, 'project_arrangement_vendor_id' => $memberId,
            'procurement_type' => 'PROJECT_BASED', 'order_state' => 'AWAITING_VENDOR_CONFIRMATION', 'payment_state' => 'NOT_REQUIRED', 'fulfillment_method' => $s['fulfillment_method'], 'payment_method' => $s['payment_method'],
            'materials_centavos' => $s['materials_centavos'], 'delivery_centavos' => $s['fulfillment_method'] === 'PICKUP' ? 0 : null, 'commercial_total_centavos' => $s['materials_centavos'],
            'project_note' => $input['note'] ?? null, 'destination' => json_encode($s['destination'], JSON_THROW_ON_ERROR), 'submitted_at' => now(), 'vendor_response_due_at' => now()->addHours(PlatformSettings::current()->int('orders.vendor_response_hours')), 'created_at' => now(), 'updated_at' => now()]);
        if (! empty($s['destination']['access_instructions'])) {
            DB::table('orders')->where('id', $orderId)->update(['access_instructions_encrypted' => Crypt::encryptString($s['destination']['access_instructions'])]);
        }
        $allocations = [];
        foreach ($s['lines'] as $requirement) {
            foreach ($requirement['allocations'] ?? [$requirement] as $allocation) {
                if (($allocation['variant_id'] ?? null) !== null && bccomp($allocation['matched_quantity'], '0', 4) > 0) {
                    $allocations[$allocation['variant_id']][] = ['line_id' => $requirement['line_id'], 'quantity' => $allocation['matched_quantity']];
                }
            }
        }
        $lineNumber = 0;
        foreach (self::aggregateLines($s['lines']) as $l) {
            if ($l['variant_id'] === null || bccomp($l['matched_quantity'], '0', 4) <= 0) {
                continue;
            }
            $policy = QuantityPolicy::historical($l) ?? QuantityPolicy::forUnit((string) $l['unit_id']);
            $l += ['quantity_policy' => $policy->toArray(), 'unit_precision' => $policy->precision, 'quantity_step' => $policy->step()];
            DB::table('order_lines')->insert(['id' => (string) Str::uuid7(), 'order_id' => $orderId, 'line_number' => ++$lineNumber, 'listing_variant_id' => $l['variant_id'], 'vendor_listing_id' => $l['listing_id'],
                'work_package_line_id' => $allocations[$l['variant_id']][0]['line_id'] ?? null,
                'unit_id' => $l['unit_id'], 'quantity' => $l['matched_quantity'], 'unit_price_centavos' => $l['unit_price_centavos'], 'payable_centavos' => $l['amount_centavos'], 'included_vat_centavos' => $l['included_vat_centavos'],
                'tax_category' => $l['tax_category'], 'listing_price_version_id' => $l['source_price_version_id'], 'snapshot' => json_encode($l + ['display_name' => $l['name'], 'work_package_allocations' => $allocations[$l['variant_id']] ?? []], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
        }
        $order = DB::table('orders')->where('id', $orderId)->first();
        $commercial = app(OrderCommercial::class);
        $money = $commercial->compute($commercial->lines($orderId), [], 0, $order->delivery_centavos);
        $commercial->record($order, 'SUBMITTED', ['work_package_version_id' => $w->current_version_id, 'system_estimate' => $s, 'note' => $input['note'] ?? null,
            'note_response_required' => false, 'fulfillment_method' => $s['fulfillment_method'], 'payment_method' => $s['payment_method']], $money, $actor);

        app(OrderTransitionService::class)->opened($order, $actor);
        app(FulfillmentThreadService::class)->ensureForOrder($orderId);

        return $order;
    }

    private function unassigned(object $w): void
    {
        if ($w->selected_vendor_organization_id !== null || ! in_array($w->status, ['ACTIVE', 'QUOTATION_INQUIRY'], true)) {
            throw new AuthenticationException('WORK_PACKAGE_ALREADY_ASSIGNED', 'This Work Package already has a selected Vendor or is closed.', 409);
        }
    }

    /** A stock row occurs only once in a package order, even if several requirements use it.
     * @param list<array<string, mixed>> $lines
     * @return list<array<string, mixed>> */
    public static function aggregateLines(array $lines): array
    {
        $result = [];
        $flattened = [];
        foreach ($lines as $line) {
            if (isset($line['allocations'])) {
                foreach ($line['allocations'] as $allocation) {
                    $flattened[] = array_merge($line, $allocation);
                }
            } else {
                $flattened[] = $line;
            }
        }
        foreach ($flattened as $line) {
            unset($line['allocations']);
            if ($line['variant_id'] === null || bccomp($line['matched_quantity'], '0', 4) <= 0) {
                continue;
            }
            $id = $line['variant_id'];
            if (isset($result[$id])) {
                $result[$id]['matched_quantity'] = bcadd($result[$id]['matched_quantity'], $line['matched_quantity'], 4);
                $result[$id]['work_package_line_ids'][] = $line['line_id'];
                $result[$id]['amount_centavos'] = Money::lineAmount($result[$id]['matched_quantity'], $line['unit_price_centavos']);
                $result[$id]['included_vat_centavos'] = Money::includedVat($result[$id]['amount_centavos'], $line['tax_category']);
            } else {
                $result[$id] = $line + ['work_package_line_ids' => [$line['line_id']]];
            }
        }

        return array_values($result);
    }

    /** Reconcile the accepted proposal against the locked original without rewriting that original.
     * @param list<array<string, mixed>> $supplied
     * @param array{order_id: string, quantities: array<string, string>}|null $confirmation */
    public function acceptedMissing(object $w, array $supplied, ?array $confirmation = null): void
    {
        if ($w->current_version_id === null) {
            return;
        }
        $version = DB::table('work_package_versions')->where('id', $w->current_version_id)->first();
        $original = json_decode($version->content, true);
        $groupPurchases = $w->selected_arrangement_id === null ? null : PackageFulfillment::purchases($w, (string) DB::table('projects')->where('id', $w->project_id)->value('buyer_profile_id'), $confirmation);
        foreach ($original['lines'] as $required) {
            $needed = $required['quantity'];
            if ($groupPurchases !== null) {
                foreach ($groupPurchases[$required['id']] ?? [] as $purchase) {
                    if ($purchase['stage'] === 'ORDERED' && $purchase['satisfies_requirement']) {
                        $needed = bcsub($needed, bccomp($needed, $purchase['quantity'], 4) <= 0 ? $needed : $purchase['quantity'], 4);
                    }
                }
            }
            foreach ($groupPurchases === null ? array_keys($supplied) : [] as $index) {
                $line = &$supplied[$index];
                // An unlisted requirement is never machine-matched, even against another unlisted supply line.
                if (($required['material_id'] ?? null) === null || ($line['material_id'] ?? null) !== $required['material_id'] || $line['unit_id'] !== $required['unit_id']
                    || ($required['preferred_brand'] !== null && ($line['brand'] ?? null) !== $required['preferred_brand'])
                    || ! SpecificationMatch::satisfies($required['specifications'], $line['specifications'] ?? [])) {
                    continue;
                }
                $take = bccomp($needed, $line['quantity'], 4) <= 0 ? $needed : $line['quantity'];
                $needed = bcsub($needed, $take, 4);
                $line['quantity'] = bcsub($line['quantity'], $take, 4);
            }
            unset($line);
            if (bccomp($needed, '0', 4) > 0) {
                if ($groupPurchases !== null && DB::table('work_package_missing_lines')->where('work_package_version_id', $w->current_version_id)->where('work_package_line_id', $required['id'])->whereNotNull('waived_by_user_id')->exists()) {
                    continue;
                }
                DB::table('work_package_missing_lines')->updateOrInsert(['work_package_version_id' => $w->current_version_id, 'work_package_line_id' => $required['id']],
                    ['id' => DB::table('work_package_missing_lines')->where('work_package_line_id', $required['id'])->value('id') ?? (string) Str::uuid7(), 'quantity' => $needed, 'created_at' => now(), 'updated_at' => now()]);
            } else {
                DB::table('work_package_missing_lines')->where('work_package_version_id', $w->current_version_id)->where('work_package_line_id', $required['id'])->whereNull('linked_order_id')->whereNull('waived_by_user_id')->delete();
            }
        }
    }

    /** @param list<array<string, mixed>> $missing */
    public function missing(object $w, array $missing): void
    {
        foreach ($missing as $m) {
            DB::table('work_package_missing_lines')->insertOrIgnore(['id' => (string) Str::uuid7(), 'work_package_version_id' => $w->current_version_id,
                'work_package_line_id' => $m['line_id'], 'quantity' => $m['quantity'], 'created_at' => now(), 'updated_at' => now()]);
        }
    }
}
