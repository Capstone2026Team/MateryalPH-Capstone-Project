<?php

declare(strict_types=1);

namespace App\Domain\Messaging;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Inventory\InventoryLedgerWriter;
use App\Domain\Inventory\InventoryLocks;
use App\Domain\Inventory\StockAvailability;
use App\Domain\Orders\OrderAcceptance;
use App\Domain\Orders\OrderActor;
use App\Domain\Orders\OrderCommercial;
use App\Domain\Orders\OrderEligibility;
use App\Domain\Orders\OrderTransitionService;
use App\Domain\Projects\ProjectBudget;
use App\Domain\Projects\ProjectInquiryService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/** Called under organization -> conversation -> quotation locks. All lines succeed together or none do. */
final class QuotationAcceptance
{
    /** @param array<string, mixed> $input */
    public function accept(Request $request, object $c, object $q, array $input): ?string
    {
        $v = DB::table('quotation_versions')->where('id', $q->current_version_id)->first();
        $content = json_decode($v->content, true);
        if (! hash_equals((string) $v->content_hash, (string) ($input['content_hash'] ?? ''))) {
            throw new AuthenticationException('QUOTATION_VERSION_CONFLICT', 'Review the current quotation before accepting.', 409);
        }
        $eligibility = app(OrderEligibility::class);
        $org = DB::table('vendor_organizations')->where('id', $q->vendor_organization_id)->first();
        if ($eligibility->storeBlockers($org) !== [] || ! $eligibility->onlinePaymentReady((string) $org->id)) {
            throw new AuthenticationException('STORE_NOT_ELIGIBLE', 'The store cannot accept this quotation right now.', 409);
        }
        if ($eligibility->lineBlockers((string) $org->id, array_column($content['lines'], 'tax_category', 'variant_id')) !== []) {
            throw new AuthenticationException('QUOTATION_REVALIDATION_REQUIRED', 'A product or tax classification changed. Ask the Vendor for a new version.', 409);
        }
        $currentTax = DB::table('vendor_tax_profiles')->where('vendor_organization_id', $org->id)->value('current_version_id');
        foreach ($content['lines'] as $line) {
            if ($line['source_tax_version_id'] !== $currentTax) {
                throw new AuthenticationException('QUOTATION_REVALIDATION_REQUIRED', 'The tax profile changed. Ask the Vendor for a new version.', 409);
            }
        }
        if ($content['fulfillment_date'] < now('Asia/Manila')->toDateString()) {
            throw new AuthenticationException('QUOTATION_REVALIDATION_REQUIRED', 'The fulfillment date passed. Ask the Vendor to revise it.', 409);
        }
        $nrpc = $content['nrpc'];
        $package = null;
        if ($q->work_package_id !== null) {
            $package = DB::table('work_packages')->where('id', $q->work_package_id)->first();
            if (! DB::table('store_profiles')->where('vendor_organization_id', $org->id)->where('bulk_capability', true)->exists()) {
                throw new AuthenticationException('PROJECT_VENDOR_INELIGIBLE', 'This Vendor is no longer eligible for a new Project award.', 409);
            }
        }
        if ($nrpc !== null && (! ($input['nrpc_acknowledged'] ?? false) || ($input['nrpc_terms_version_id'] ?? null) !== $nrpc['terms']['id'])) {
            throw new AuthenticationException('NRPC_ACCEPTANCE_REQUIRED', 'Review the NRPC amount, reason, affected lines and Terms, then acknowledge them.', 422);
        }
        $locked = app(InventoryLocks::class)->lockForAcceptance(array_column($content['lines'], 'variant_id'));
        foreach ($content['lines'] as $line) {
            $item = $locked['inventory'][$line['variant_id']] ?? null;
            if ($item === null || bccomp($line['quantity'], StockAvailability::availableToSell((string) $item->quantity_on_hand, (string) $item->hard_reserved_quantity), 4) > 0) {
                return null;
            }
        }
        $id = (string) Str::uuid7();
        $money = $content['commercial'];
        DB::table('orders')->insert(['id' => $id, 'reference' => 'ORD-'.now('Asia/Manila')->format('Y').'-'.Str::upper(Str::random(10)),
            'buyer_profile_id' => $q->buyer_profile_id, 'vendor_organization_id' => $q->vendor_organization_id, 'work_package_id' => $q->work_package_id,
            'quotation_version_id' => $v->id, 'work_package_version_id' => $package?->current_version_id,
            'procurement_type' => $q->procurement_type, 'order_state' => 'AWAITING_VENDOR_CONFIRMATION', 'payment_state' => 'NOT_REQUIRED',
            'fulfillment_method' => $content['fulfillment_method'], 'payment_method' => $content['payment_method'], 'commercial_total_centavos' => $money['commercial_total_centavos'],
            'materials_centavos' => $money['materials_payable_centavos'], 'vendor_discount_centavos' => $money['vendor_discount_centavos'], 'delivery_centavos' => $money['delivery_centavos'],
            'nrpc_centavos' => $money['nrpc_centavos'], 'confirmation_source' => 'MANUAL', 'expected_fulfillment_date' => $content['fulfillment_date'],
            'destination' => json_encode($content['destination'], JSON_THROW_ON_ERROR), 'submitted_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
        if ($package !== null) {
            app(ProjectBudget::class)->guard($request, $package, (int) $money['commercial_total_centavos'], $input, $id);
            app(ProjectInquiryService::class)->acceptedMissing($package, $content['lines']);
        }
        foreach ($content['lines'] as $index => $line) {
            $lineId = (string) Str::uuid7();
            $computed = array_values(array_filter($money['lines'], static fn (array $row): bool => $row['line_id'] === $line['variant_id']))[0];
            $snapshot = $line + ['display_name' => $line['description'], 'price_source' => 'PRIVATE_TRANSACTION', 'quotation_version_id' => $v->id];
            DB::table('order_lines')->insert(['id' => $lineId, 'order_id' => $id, 'line_number' => $index + 1, 'listing_variant_id' => $line['variant_id'],
                'vendor_listing_id' => $line['listing_id'], 'unit_id' => $line['unit_id'], 'quantity' => $line['quantity'], 'unit_price_centavos' => $line['unit_price_centavos'],
                'discount_centavos' => $computed['discount_centavos'], 'included_vat_centavos' => $computed['vat_centavos'], 'payable_centavos' => $computed['payable_centavos'],
                'tax_category' => $line['tax_category'], 'listing_price_version_id' => $line['source_price_version_id'], 'snapshot' => json_encode($snapshot, JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
            app(InventoryLedgerWriter::class)->reserve($locked['inventory'][$line['variant_id']], $line['quantity'], (int) $request->user()->id, $id, $lineId);

        }
        // Keep the exact published allocation: random order-line UUIDs must not change rounding tie breaks.
        $lineIds = DB::table('order_lines')->where('order_id', $id)->pluck('id', 'listing_variant_id')->all();
        $acceptedMoney = $money;
        foreach ($acceptedMoney['lines'] as &$line) {
            $line['line_id'] = $lineIds[$line['line_id']];
        }
        unset($line);
        $order = DB::table('orders')->where('id', $id)->first();
        $actor = OrderActor::buyer($request);
        app(OrderTransitionService::class)->opened($order, $actor);
        $snapshot = app(OrderCommercial::class)->record($order, 'VENDOR_CONFIRMED', $content + ['accepted_quotation_version_id' => $v->id, 'accepted_quotation_hash' => $v->content_hash], $acceptedMoney, $actor);
        $nrpcId = null;
        if ($nrpc !== null) {
            $nrpcId = (string) Str::uuid7();
            DB::table('nrpc_records')->insert(['id' => $nrpcId, 'order_id' => $id, 'actor_user_id' => $v->created_by_user_id, 'actor_role' => $v->actor_role,
                'state' => 'PROPOSED', 'reason' => $nrpc['reason'], 'amount_centavos' => $money['nrpc_centavos'], 'eligible_subtotal_centavos' => $money['nrpc_eligible_subtotal_centavos'],
                'agreement_version_id' => $nrpc['terms']['id'], 'order_snapshot_version' => $snapshot->version, 'payload' => json_encode(['quotation_version_id' => $v->id], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
            foreach ($acceptedMoney['lines'] as $line) {
                if ($line['nrpc_principal_centavos'] > 0) {
                    DB::table('nrpc_line_allocations')->insert(['id' => (string) Str::uuid7(), 'nrpc_record_id' => $nrpcId, 'order_line_id' => $line['line_id'],
                        'principal_centavos' => $line['nrpc_principal_centavos'], 'line_payable_centavos' => $line['payable_centavos'], 'vat_centavos' => $line['nrpc_vat_centavos'], 'created_at' => now()]);
                }
            }
            DB::table('nrpc_acceptances')->insert(['id' => (string) Str::uuid7(), 'order_id' => $id, 'nrpc_record_id' => $nrpcId, 'agreement_version_id' => $nrpc['terms']['id'],
                'actor_user_id' => $request->user()->id, 'state' => 'ACCEPTED', 'decision' => 'ACCEPTED', 'payload' => json_encode(['terms_content_hash' => $nrpc['terms']['content_hash'], 'quotation_version_id' => $v->id], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
        }
        if ($content['delivery'] !== null) {
            $delivery = $content['delivery'];
            DB::table('order_delivery_snapshots')->insert(['id' => (string) Str::uuid7(), 'order_id' => $id, 'vendor_organization_id' => $org->id, 'confirmed_by_user_id' => $v->created_by_user_id,
                'snapshot' => json_encode($delivery, JSON_THROW_ON_ERROR), 'final_charge_centavos' => $delivery['final_charge_centavos'], 'fulfillment_date' => $content['fulfillment_date'],
                'calculation_version' => $delivery['calculation_version'], 'basis' => $delivery['basis'], 'created_at' => now()]);
        }
        app(OrderAcceptance::class)->accept($order, $snapshot, $acceptedMoney, $nrpcId, $actor, 'QUOTATION_ACCEPTED');

        return $id;
    }
}
